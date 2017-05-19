/*1.	Show all data of the clerks who have been hired after the year 1997.*/
SELECT * 
FROM sqltest.employees
where TO_DAYS('1997-1-1')-TO_DAYS(hire_date)<0 and job_id = 'ST_CLERK';

/*2.	Show the last name,  job, salary, and commission of those employees who earn commission. Sort the data by the salary in descending order.*/
select last_name,job_id,salary,commission_pct
from sqltest.employees
where commission_pct is not null
order by salary desc;

/*3.	Show the employees that have no commission with a 10% raise in their salary (round off thesalaries).*/
select 'The salary of ' || last_name || ' after a 10% raise  is ' || salary as 'NEW SALARY'
FROM sqltest.employees
where commission_pct is null;

/*4.	Show the last names of all employees together with the number of years and the number ofcompleted months that they have been employed.*/
select last_name,DATE_FORMAT(from_days(TO_DAYS('2002-5-17')-TO_DAYS(hire_date)),'%y') as 'year',DATE_FORMAT(from_days(TO_DAYS('2002-5-17')-TO_DAYS(hire_date)),'%m') as 'month'
FROM sqltest.employees;

/*5.	Show those employees that have a name starting with J, K, L, or M.*/
select last_name
FROM sqltest.employees
where last_name like 'J%' or last_name like 'K%' or last_name like 'L%' OR last_name like 'M%';

/*6.没做完	Show all employees, and indicate with “Yes” or “No” whether they receive a commission*/
SELECT last_name, salary,
       decode(commission_pct, NULL, 'No', 'Yes') commission
FROM   employees;

/*7*/
select department_name,location_id,last_name,job_id,salary
from employees,departments
where employees.department_id = departments.department_id and location_id = 1800;

/*8*/
select count(last_name)
from employees
where last_name like '%n';

/*9*/
select departments.department_id,department_name,location_id,count(employees.employee_id)
from employees
right outer join departments
on( employees.department_id = departments.department_id)
group by department_id;

/*10*/
select distinct job_id
from employees,departments
where employees.department_id = departments.department_id and employees.department_id=10 or employees.department_id=20;

/*11*/
select distinct job_id,count(employees.employee_id) as 'frequence'
from employees,departments
where employees.department_id = departments.department_id and 
employees.department_id in(
select department_id
from departments
where department_name = 'Administration' or department_name = 'Executive'
)
group by job_id
order by frequence desc;

/*12*/
select last_name,hire_date
from employees
where day(hire_date)<16;

/*13*/
select last_name,salary,round(salary/1000) as 'thousands'
from employees;

/*14* */
SELECT e.last_name, m.last_name manager, m.salary,
       j.grade_level
FROM   employees e, employees m, job_grades j
WHERE  e.manager_id = m.employee_id
AND    m.salary BETWEEN j.lowest_sal AND j.highest_sal
AND    m.salary > 15000;

/*15 */
BREAK ON department_id - 
        ON department_name ON employees ON avg_sal SKIP 1

SELECT  d.department_id, d.department_name,
        count(e1.employee_id) employees,
        NVL(TO_CHAR(AVG(e1.salary), '99999.99'),
        'No average' ) avg_sal,
        e2.last_name, e2.salary, e2.job_id
FROM    departments d, employees e1, employees e2
WHERE   d.department_id = e1.department_id(+)
AND     d.department_id = e2.department_id(+)
GROUP BY d.department_id, d.department_name,
         e2.last_name,   e2.salary, e2.job_id
ORDER BY d.department_id, employees
/*16 */
SELECT department_id, MIN(salary)
FROM   employees
GROUP BY department_id
HAVING AVG(salary) = (SELECT MAX(AVG(salary))
                      FROM   employees
                      GROUP BY department_id)
;

/*17*/
select department_id,department_name,manager_id,location_id
from departments
where department_name != 'Sales';

/*18*/
select departments.department_id,department_name,count(*)
from employees
right outer join departments
on( employees.department_id = departments.department_id)
group by department_id
having count(*) <3;

SELECT d.department_id, d.department_name, COUNT(*)
FROM   departments d, employees e
WHERE  d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                   FROM   employees
                   GROUP BY department_id);
                   
                   SELECT d.department_id, d.department_name, COUNT(*)
FROM   departments d, employees e
WHERE  d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(*) = (SELECT MIN(COUNT(*))
                   FROM   employees
                   GROUP BY department_id);
/*19*/
select y.employee_id,y.last_name,y.department_id,avg(y.salary)
from employees y
right outer join employees x
on(x.employee_id = x.employee_id)
where y.department_id is not null
group by y.department_id,y.last_name,y.department_id
order by y.employee_id;



/*20.	Show all employees who were hired on the day of the week on which the highest number of employees were hired.
*/
SELECT last_name,TO_CHAR(hire_date,'day')
FROM employees
where TO_CHAR(hire_date,'day') = (SELECT TO_CHAR(hire_date,'day')
      from employees
      group by TO_CHAR(hire_date,'day')
      having count(TO_CHAR(hire_date,'day')) = (select MAX(count(TO_CHAR(hire_date,'day'))) 
      from employees
      group by TO_CHAR(hire_date,'day')
      ));
/*21.	Create an anniversary overview based on the hire date of the employees. Sort the anniversaries in ascending order.
*/
SELECT last_name,TO_CHAR(hire_date,'MM-dd') as "BIRTHDAY"
FROM employees
order by TO_CHAR(hire_date,'MM-dd') asc;
/*22. Find the job that was filled in the first half of 1990 and the same job that was filled during the 		same period in 1991.*/
SELECT x.job_id
FROM employees x,employees y
where TO_CHAR(x.hire_date,'yyyy') = '1990' AND
TO_CHAR(x.hire_date,'MM')>=1 AND TO_CHAR(x.hire_date,'MM')<=6 AND
TO_CHAR(y.hire_date,'yyyy') = '1991' AND x.job_id = y.job_id ;
/*23. Write a compound query to produce a list of employees showing raise percentages, employee 		IDs, and old salary and new salary increase. Employees in departments 10, 50, and 110 are 		given a 5% raise, employees in department 60 are given a 10% raise, employees in 		departments 20 and 80 are given a  15% raise, and employees in department 90 are not given 		a raise.	
*/
SELECT '05% raise' raise, employee_id, salary, 
salary *.05 new_salary
FROM   employees
WHERE  department_id IN (10,50, 110)
UNION
SELECT '10% raise', employee_id, salary, salary * .10
FROM   employees
WHERE  department_id = 60
UNION
SELECT '15% raise', employee_id, salary, salary * .15 
FROM   employees
WHERE  department_id IN (20, 80)
UNION
SELECT 'no raise', employee_id, salary, salary
FROM   employees
WHERE  department_id = 90;

/*24.Alter the session to set the NLS_DATE_FORMAT to  DD-MON-YYYY HH24:MI:SS.
*/
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS';

/*25.*/
SELECT TZ_OFFSET ('Australia/Sydney') from dual; 

SELECT TZ_OFFSET ('Chile/EasterIsland') from dual;

ALTER SESSION SET TIME_ZONE = '+10:00';

SELECT SYSDATE,CURRENT_DATE, CURRENT_TIMESTAMP, LOCALTIMESTAMP
FROM DUAL; 

ALTER SESSION SET TIME_ZONE = '-06:00';

SELECT SYSDATE, CURRENT_DATE, CURRENT_TIMESTAMP, LOCALTIMESTAMP
FROM DUAL;

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';
/*26. 	Write a query to display the last names, month of the date of join, and hire date of those                 employees who have joined in the month of January, irrespective of the year of join.
*/
SELECT last_name,TO_CHAR(hire_date,'MM'),TO_CHAR(hire_date,'dd-MM-yyyy')
FROM employees
where TO_CHAR(hire_date,'MM') = '01'
/*27.*/
COLUMN city FORMAT A25 Heading CITY
COLUMN department_name FORMAT A15 Heading DNAME
COLUMN job_id  FORMAT A10 Heading JOB
COLUMN SUM(salary)  FORMAT $99,99,999.00 Heading SUM(SALARY)

SELECT   l.city,d.department_name, e.job_id, SUM(e.salary)
FROM     locations l,employees e,departments d
WHERE    d.location_id = l.location_id
AND      e.department_id = d.department_id
AND      e.department_id > 80
GROUP    BY CUBE( l.city,d.department_name, e.job_id);

/*28*/
SELECT department_id, job_id, manager_id,max(salary),min(salary)
FROM   employees
GROUP BY GROUPING SETS
((department_id,job_id), (job_id,manager_id));

/*29. Write a query to display the top three earners in the EMPLOYEES table. Display their last 	names and salaries.
*/
SELECT last_name,salary
FROM (SELECT last_name,salary from employees)
where rownum <= 3
order by rownum asc;
/*30. Write a query to display the employee ID and last names of the employees who work in the 	state of California. 
*/
select e.employee_id,e.last_name
from employees e inner join departments d
on e.department_id = d.department_id
inner join locations l on d.location_id = l.location_id and
l.state_province = 'California'
order by employee_id asc;

/*31.*/
DELETE FROM job_history JH
WHERE employee_id =
	(SELECT employee_id 
	 FROM employees E
	 WHERE JH.employee_id = E.employee_id
         AND START_DATE = (SELECT MIN(start_date)  
	          FROM job_history JH
	 	  WHERE JH.employee_id = E.employee_id)
	 AND 3 >  (SELECT COUNT(*)  
	          FROM job_history JH
	 	  WHERE JH.employee_id = E.employee_id
		  GROUP BY EMPLOYEE_ID
		  HAVING COUNT(*) >= 2));
/*32.*/
ROLLBACK;
/*33.*/
WITH 
MAX_SAL_CALC AS (
  SELECT job_title, MAX(salary) AS job_total
  FROM employees, jobs
  WHERE employees.job_id = jobs.job_id
  GROUP BY job_title)
SELECT job_title, job_total
FROM MAX_SAL_CALC
WHERE job_total > (
                    SELECT MAX(job_total) * 1/2
                    FROM MAX_SAL_CALC)
ORDER BY job_total DESC;
/*34.*/
SELECT employee_id,last_name,hire_date,salary
FROM employees
WHERE manager_id = (SELECT employee_id
      FROM employees
      WHERE last_name='De Haan');
/*同一个经理手下应该是同一个部门*/
SELECT employee_id,last_name,hire_date,salary
FROM employees
where department_id = (select department_id
      from employees
      where manager_id = 102);
      
SELECT employee_id,last_name,hire_date,salary
from employees
where LEVEL = 2
start with employee_id = (SELECT employee_id
      FROM employees
      WHERE last_name='De Haan')
connect by prior employee_id = manager_id;

SELECT employee_id,last_name,hire_date,salary
from employees
where LEVEL > 1
start with employee_id = 102
connect by prior employee_id = manager_id;
/*35.*/
SELECT employee_id,manager_id,LEVEL,last_name
from employees
where LEVEL > 2
start with employee_id = 102
connect by prior employee_id = manager_id;
/*36.*/
SELECT employee_id,manager_id,LEVEL,last_name
from employees
where LEVEL >= 1
start with employee_id in (select employee_id from employees)
connect by prior employee_id = manager_id;

/*37.*/
INSERT ALL
WHEN SAL < 5000 THEN
INTO  special_sal VALUES (EMPID, SAL)
ELSE
INTO sal_history VALUES(EMPID,HIREDATE,SAL)
INTO mgr_history VALUES(EMPID,MGR,SAL)   
SELECT employee_id EMPID, hire_date HIREDATE,
       salary SAL, manager_id MGR
FROM employees
WHERE employee_id >=200;	

/*38.*/
SELECT * FROM special_sal;
SELECT * FROM sal_history;
SELECT * FROM mgr_history;


/*39.*/
CREATE TABLE LOCATIONS_NAMED_INDEX
 (location_id NUMBER(4)
         PRIMARY KEY USING INDEX
        (CREATE INDEX locations_pk_idx ON
         LOCATIONS_NAMED_INDEX(location_id)),
location_name VARCHAR2(20));

/*40.*/
SELECT INDEX_NAME, TABLE_NAME
FROM USER_INDEXES
WHERE TABLE_NAME = 'LOCATIONS_NAMED_INDEX';    


/*41.*/

SET HEADING OFF ECHO OFF FEEDBACK OFF 
SET PAGESIZE 0

   

     SELECT   'DROP ' || object_type || ' ' || object_name || ';'
     FROM     user_objects
     ORDER BY object_type
     /



     SET HEADING ON ECHO ON FEEDBACK ON 
     SET PAGESIZE 24     