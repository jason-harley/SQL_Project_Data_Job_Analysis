ALTER TABLE job_applied
ADD contact VARCHAR(50); -- adds new column

UPDATE job_applied
SET contact = 'Elich Bachman'
WHERE job_id = 1;

UPDATE job_applied
SET contact = 'Dinesh Chugtai'
WHERE job_id = 2;

UPDATE job_applied
SET contact = 'Bertram Gilfoyle'
WHERE job_id = 3;

UPDATE job_applied
SET contact = 'Jian Yang'
WHERE job_id = 4;

UPDATE job_applied
SET contact = 'Big Head'
WHERE job_id = 5;

ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name; -- rename column

ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT; -- change data type

ALTER TABLE job_applied
DROP COLUMN contact_name -- deletes column BE CAREFUL

SELECT *
FROM job_applied
