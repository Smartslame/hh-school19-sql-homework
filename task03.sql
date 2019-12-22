SELECT area_id,
		AVG(
			CASE 
				WHEN compensation_gross = true 
					THEN compensation_from * 0.87
				ELSE compensation_from
			END
		) as avg_from,
		AVG(
			CASE 
				WHEN compensation_gross = true 
					THEN compensation_to * 0.87
				ELSE compensation_to
			END
		) as avg_to,
		AVG(
			CASE 
				WHEN compensation_gross = true 
					THEN (compensation_from + compensation_to) / 2 * 0.87
				ELSE (compensation_from + compensation_to) / 2
			END
		) as avg_mid
FROM (
		SELECT vacancy.area_id, 
				compensation_gross,
				compensation_from,
				compensation_to 
		FROM vacancy INNER JOIN vacancy_body on vacancy.vacancy_body_id = vacancy_body.vacancy_body_id
		WHERE disabled = false and visible = true
	) as active_vacancies
GROUP BY area_id
