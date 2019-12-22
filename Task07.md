Самым долгим запросом оказался запрос из 5 задачи.

Делаем EXPLAIN ANALYZE и смотрим что получилось:

https://explain.depesz.com/s/Qrg3

Запрос выполняется 52 секунды, это очень долго. Смотрим в чем дело:

Seq Scan занимает почти все время работы запроса:

	Seq Scan on responses (cost=0.00..1,637.00 rows=2 width=8) (actual time=1.466..5.252 rows=4 loops=10,000)
	Filter: ((vacancy_id = vacancy.vacancy_id) AND (date_part('day'::text, (creation_time - vacancy.creation_time)) <= '7'::double precision))
	Rows Removed by Filter: 49996


Будем ускорять!

Добавим индекс по таблице responses от vacancy_id и creation_time, так как оба используются в Seq Scan.

Итого: 

CREATE INDEX responses_idx_1 ON responses(vacancy_id) INCLUDE(creation_time);

Смотрим, что получилось:

https://explain.depesz.com/s/QvuA

Seq Scan превратился в Index Only Scan и похудел до 30 ms, а это в 1733 раза меньше! 

	Index Only Scan using responses_idx_1 on responses (cost=0.41..4.54 rows=2 width=8) (actual time=0.002..0.003 rows=4 loops=10,000)
	Index Cond: (vacancy_id = vacancy.vacancy_id)
	Filter: (date_part('day'::text, (creation_time - vacancy.creation_time)) <= '7'::double precision)
	Rows Removed by Filter: 1
	Heap Fetches: 0

Вывод: наш индекс используется по-максимуму и очень сильно сокращает время выполнения запроса.