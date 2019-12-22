SELECT res.resume_id, specs AS specs_cur, spec_vac AS most_popular_vac_spec
FROM (
		resume 
		INNER JOIN
			(
				SELECT resume_body_id, array_agg(specialization_id) AS specs
				FROM resume_body_specialization
				GROUP BY resume_body_id
			) AS body 
		ON 
		resume.resume_body_id = body.resume_body_id
	) AS res
	
	LEFT JOIN
	 (
		--- решил специализации добавлять в массив, так как есть специализации с одинаковым максимальным количеством откликов 
		SELECT resume_id, ARRAY_AGG(DISTINCT spec) AS spec_vac
		FROM (
				SELECT resume_id, spec, spec_count, MAX(spec_count) OVER (PARTITION BY resume_id) AS spec_count_max
				FROM (
					SELECT resume_id, specialization_id AS spec, COUNT(specialization_id) OVER ( PARTITION BY resume_id, specialization_id) AS spec_count
					FROM (
							responses 
							INNER JOIN 
							vacancy_body 
							ON 
							vacancy_body.vacancy_body_id = (
															SELECT vacancy_body_id
												   			FROM vacancy
												   			WHERE vacancy.vacancy_id = responses.vacancy_id
							)
					) AS res 
					RIGHT OUTER JOIN 
					vacancy_body_specialization
					ON 
					vacancy_body_specialization.vacancy_body_id = res.vacancy_body_id) AS t
			) AS tmp
		WHERE spec_count = spec_count_max
		GROUP BY resume_id
	) AS vac on res.resume_id = vac.resume_id
ORDER BY res.resume_id
