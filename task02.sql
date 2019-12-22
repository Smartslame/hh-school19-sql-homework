INSERT INTO vacancy_body(
    company_name, name, text, area_id, address_id, work_experience, 
    compensation_from, compensation_to, test_solution_required,
    work_schedule_type, employment_type, compensation_gross
)
SELECT 
    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 67)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 140 + i % 10)::integer)) AS company_name,

    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 67)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 210 + i % 10)::integer)) AS name,

    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 67)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 200 + i % 10)::integer)) AS text,

    (random() * 1000)::int AS area_id,
    (random() * 50000)::int AS address_id,
    random() * 5::int AS work_experience,
    100000 - (random() * 75000)::int AS compensation_from,
	101000 + (random() * 150000)::int AS compensation_to,
    (random() > 0.5) AS test_solution_required,
    random() * 4::int AS work_schedule_type,
    random() * 4::int AS employment_type,
    (random() > 0.5) AS compensation_gross
FROM generate_series(1, 10000) AS g(i);




INSERT INTO vacancy (creation_time, expire_time, employer_id, disabled, visible, area_id, vacancy_body_id)
SELECT
    -- random in +- 5 years from current time
    now()-(random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS creation_time,
    now() + (random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS expire_time,
    (random() * 1000000 + 1)::int AS employer_id,
    (random() > 0.5) AS disabled,
    (random() > 0.5) AS visible,
    (random() * 1000 + 1)::int AS area_id,
	i::integer as vacancy_body_id
FROM generate_series(1, 10000) AS g(i);


INSERT INTO vacancy_body_specialization(vacancy_body_id, specialization_id)
SELECT
	(i % 10000 + 1) as vacancy_body_id,
	(random() * 100 + 1)::integer as specialization_id
FROM generate_series(1, 50000) AS g(i);






INSERT INTO resume_body (desired_position, desired_salary, native_language_id, employment_type, work_schedule_type, has_car, work_permission_area_id)
SELECT 
    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 67)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 100 + i % 10)::integer)) AS desired_position,

    50000 + (random() * 150000)::int AS desired_salary,

    random() * 50::integer as native_language_id,

    random() * 4::int AS work_schedule_type,
    
    random() * 4::int AS employment_type,

    (random() > 0.7) AS has_car,

    (random() * 1000 + 1)::int AS work_permission_area_id
	
FROM generate_series(1, 100000) AS g(i);

INSERT INTO education_info(education_type, education_place, education_faculty, education_specialization, graduation_year)
SELECT 
	random() * 7::int AS education_type,
	(SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 67)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 100 + i % 10)::integer)) AS education_place,
	(SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 67)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 100 + i % 10)::integer)) AS education_faculty,
	(SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 67)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 100 + i % 10)::integer)) AS education_specialization,
	2016 + random() * 7::int AS graduation_year
FROM generate_series(1, 100000) AS g(i);

INSERT INTO resume_body_specialization(resume_body_id, specialization_id)
SELECT
	(i % 100000) + 1 as resume_body_id,
	(random() * 100 + 1)::integer as specialization_id
FROM generate_series(1, 500000) AS g(i);

INSERT INTO resume_body_foreign_language(resume_body_id, foreign_language_id)
SELECT
	(random() * 100000 + 1)::integer as resume_body_id,
	(random() * 100 + 1)::integer as foreign_language_id
FROM generate_series(1, 30000) AS g(i);

INSERT INTO resume_body_education_info(resume_body_id, education_info_id)
SELECT
	i as resume_body_id,
	(random() * 100000 + 1)::integer as education_info_id
FROM generate_series(1, 100000) AS g(i);

INSERT INTO resume(title, first_name, last_name, creation_time, phone_number, area_id, birth_date, gender, citizenship_area_id, has_work_exprience, resume_body_id)
SELECT
	(SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 67)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 100 + i % 10)::integer)) AS title,
	(SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 67)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 100 + i % 10)::integer)) AS first_name,
	
	(SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 67)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 100 + i % 10)::integer)) AS last_name,
	
	now()-(random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS creation_time,
	
	(SELECT '+79' || (SELECT string_agg(
        substr(
            '0123456789', 
            (random() * 9)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 9))) AS phone_number,
	
	(random() * 1000 + 1)::int AS area_id,
	
	now()-(random() * 365 * 24 * 3600 * 40) * '1 second'::interval AS birth_date,
	
	(CASE
		WHEN (random() > 0.5) THEN 'm'::gen
		ELSE 'f'::gen
	END) as gender,
	
	(random() * 1000 + 1)::int AS citizenship_area_id,
	
	(random() > 0.5) as has_work_exprience,
	
	i as resume_body_id

FROM generate_series(1, 100000) AS g(i);

INSERT INTO responses(resume_id, vacancy_id, creation_time)
SELECT
	(random() * 100000 + 1)::integer as resume_id,
	(random() * 10000 + 1)::integer as vacancy_id,
	now() as creation_time
FROM generate_series(1, 50000) AS g(i);

UPDATE responses
	SET creation_time = vacancy.creation_time + (random() * 24 * 3600 * 10 ) * '1 second'::interval
	FROM vacancy
	WHERE responses.vacancy_id = vacancy.vacancy_id
;
