SELECT resume_month, vacancy_month
FROM (
	(
		SELECT month as resume_month
		FROM (
				SELECT EXTRACT(MONTH FROM creation_time) AS month, COUNT(resume_id) as count
				FROM resume
				GROUP BY EXTRACT(MONTH FROM creation_time) 
		) as tmp
		WHERE count = (
				SELECT MAX(count)
				FROM (
						SELECT EXTRACT(MONTH FROM creation_time) AS month, COUNT(resume_id) as count
						FROM resume
						GROUP BY EXTRACT(MONTH FROM creation_time) 
					) as tmp 
		)
	) as res cross join (
		SELECT month as vacancy_month
		FROM (
				SELECT EXTRACT(MONTH FROM creation_time) AS month, COUNT(vacancy_id) as count
				FROM vacancy
				GROUP BY EXTRACT(MONTH FROM creation_time) ) as tmp
		WHERE count = (
				SELECT MAX(count)
				FROM (
						SELECT EXTRACT(MONTH FROM creation_time) AS month, COUNT(vacancy_id) as count
						FROM vacancy
						GROUP BY EXTRACT(MONTH FROM creation_time) 
					) as tmp 
		) 
	)	as vac
) as res_vac


