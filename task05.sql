SELECT name
FROM vacancy INNER JOIN vacancy_body on vacancy.vacancy_body_id = vacancy_body.vacancy_body_id
WHERE  (SELECT COUNT(creation_time)
		FROM responses
		WHERE responses.vacancy_id = vacancy.vacancy_id and 
				EXTRACT(DAY FROM (responses.creation_time - vacancy.creation_time)) <= 7
	   ) < 5 
ORDER BY name