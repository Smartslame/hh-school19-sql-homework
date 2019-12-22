DROP TABLE IF EXISTS vacancy;
DROP TABLE IF EXISTS vacancy_body;
DROP TABLE IF EXISTS vacancy_body_specialization;

DROP TABLE IF EXISTS resume;
DROP TABLE IF EXISTS education_info;
DROP TABLE IF EXISTS resume_body_specialization;
DROP TABLE IF EXISTS resume_body_foreign_language;
DROP TABLE IF EXISTS resume_body_education_info;
DROP TABLE IF EXISTS resume_body;

DROP TABLE IF EXISTS responses;

DROP TABLE IF EXISTS resume_cache;

DROP TYPE IF EXISTS gen;

CREATE TABLE vacancy_body (
    vacancy_body_id serial PRIMARY KEY,
    company_name varchar(150) DEFAULT ''::varchar NOT NULL,
    name varchar(220) DEFAULT ''::varchar NOT NULL,
    text text,
    area_id integer,
    address_id integer,
    work_experience integer DEFAULT 0 NOT NULL,
    compensation_from bigint DEFAULT 0,
    compensation_to bigint DEFAULT 0,
    test_solution_required boolean DEFAULT false NOT NULL,
    work_schedule_type integer DEFAULT 0 NOT NULL,
    employment_type integer DEFAULT 0 NOT NULL,
    compensation_gross boolean DEFAULT FALSE NOT NULL,
    driver_license_types varchar(5)[],
    CONSTRAINT vacancy_body_work_employment_type_validate CHECK ((employment_type = ANY (ARRAY[0, 1, 2, 3, 4]))),
    CONSTRAINT vacancy_body_work_schedule_type_validate CHECK ((work_schedule_type = ANY (ARRAY[0, 1, 2, 3, 4])))
);

CREATE TABLE vacancy (
    vacancy_id serial PRIMARY KEY,
    creation_time timestamp NOT NULL,
    expire_time timestamp NOT NULL,
    employer_id integer DEFAULT 0 NOT NULL,    
    disabled boolean DEFAULT false NOT NULL,
    visible boolean DEFAULT true NOT NULL,
    vacancy_body_id integer REFERENCES vacancy_body(vacancy_body_id),
    area_id integer
);

CREATE TABLE vacancy_body_specialization (
	vacancy_body_specialization serial PRIMARY KEY,
    vacancy_body_id integer DEFAULT 0 NOT NULL,
    specialization_id integer DEFAULT 0 NOT NULL
);

CREATE TABLE resume_body (
	resume_body_id serial PRIMARY KEY,
	desired_position varchar(220),
	desired_salary bigint,
	native_language_id integer NOT NULL,
	employment_type integer DEFAULT 0 NOT NULL,
	work_schedule_type integer DEFAULT 0 NOT NULL,
	driver_license_types varchar(5)[],
	has_car boolean,
	work_permission_area_id integer,
	relocation_requiered integer,
	relocation_area_id integer,

	CONSTRAINT resume_body_work_employment_type_validate CHECK ((employment_type = ANY (ARRAY[0, 1, 2, 3, 4]))),
	CONSTRAINT resume_body_work_schedule_type_validate CHECK ((work_schedule_type = ANY (ARRAY[0, 1, 2, 3, 4]))),
	CONSTRAINT resume_body_relocation_requiered_validate CHECK ((relocation_requiered = ANY (ARRAY[0, 1, 2])))
);

CREATE TABLE education_info (
    education_info_id serial PRIMARY KEY,
    education_type integer,
	education_place varchar(220) NOT NULL,
	education_faculty varchar(220),
	education_specialization varchar(220),
	graduation_year integer NOT NULL,
	
	CONSTRAINT education_info_education_type_validate CHECK ((education_type = ANY (ARRAY[0, 1, 2, 3, 4, 5, 6, 7])))

);

CREATE TABLE resume_body_specialization (
	resume_body_specialization_id serial PRIMARY KEY,
    resume_body_id integer DEFAULT 0 NOT NULL,
    specialization_id integer DEFAULT 0 NOT NULL
);

CREATE TABLE resume_body_foreign_language (
	resume_body_foreign_language_id serial PRIMARY KEY,
    resume_body_id integer DEFAULT 0 NOT NULL,
    foreign_language_id integer DEFAULT 0 NOT NULL
);

CREATE TABLE resume_body_education_info (
	resume_body_education_info_id serial PRIMARY KEY,
    resume_body_id integer DEFAULT 0 NOT NULL,
    education_info_id integer DEFAULT 0 NOT NULL
);

CREATE TYPE gen AS ENUM ('f', 'm');

CREATE TABLE resume (
	resume_id serial PRIMARY KEY,
	title varchar(220),
	first_name varchar(220),
	last_name varchar(220),
	creation_time timestamp NOT NULL,
	phone_number varchar(20) NOT NULL,
	area_id integer,
	birth_date timestamp,
	gender gen NOT NULL,
	citizenship_area_id integer NOT NULL,
	has_work_exprience boolean NOT NULL,
	resume_body_id integer REFERENCES resume_body(resume_body_id)
);

CREATE TABLE responses (
	responses_id serial PRIMARY KEY,
	resume_id integer NOT NULL,
	vacancy_id integer NOT NULL,
	creation_time timestamp NOT NULL
);

CREATE TABLE resume_cache (
	resume_id integer NOT NULL,
	last_change_time timestamp NOT NULL,
	cache JSON NOT NULL
)





