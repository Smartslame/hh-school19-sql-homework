DROP TRIGGER IF EXISTS save_old_resume on resume;
DROP FUNCTION IF EXISTS resume_cache();
DROP FUNCTION IF EXISTS see_history(id int);

CREATE FUNCTION resume_cache() RETURNS trigger AS $resume_cache$
	DECLARE my_row JSON;
    BEGIN
	
		my_row := row_to_json(OLD);
		
		INSERT INTO resume_cache(resume_id, last_change_time, cache)
		SELECT
			OLD.resume_id AS resume_id,
			now() - (random() * 24 * 3600 * 10 ) * '1 second'::interval  as last_change_time,
			my_row AS cache;
		RETURN NEW;
    END;
$resume_cache$ LANGUAGE plpgsql;

CREATE TRIGGER save_old_resume
    BEFORE UPDATE OR DELETE ON resume
	FOR EACH ROW EXECUTE PROCEDURE resume_cache();


UPDATE resume
	SET title = 'test' || i
	FROM generate_series(1, 10) AS g(i)
	WHERE resume.resume_id = i
;

UPDATE resume
	SET title = 'testtest' || i
	FROM generate_series(1, 10) AS g(i)
	WHERE resume.resume_id = i
;

UPDATE resume
	SET title = 'testtesttest' || i
	FROM generate_series(1, 10) AS g(i)
	WHERE resume.resume_id = i
;


CREATE FUNCTION see_history(id int)  RETURNS TABLE(resume_id int, last_change_time timestamp, old_title varchar, new_title varchar)
    AS $$ 
	SELECT resume_id, last_change_time, cache->>'title' as old_title, 
		LEAD(cache->>'title',1) OVER (ORDER BY last_change_time) as new_title
	FROM resume_cache
	WHERE resume_id = $1
	ORDER BY last_change_time
	$$
    LANGUAGE SQL;
	
SELECT * from see_history(2);


