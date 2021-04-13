SELECT l.ID, l.NAME, l.research_area , count(s.ID) num_of_subjects
FROM mb18___db.LECTURER l left outer JOIN mb18___db.SUBJECT s
ON l.ID = s.LECTURER
WHERE lower(l.RESEARCH_AREA) NOT LIKE '%neurobiology%'
GROUP BY l.ID, l.NAME, l.research_area
ORDER BY num_of_subjects DESC;

SELECT dcu_id
FROM dcdb.dc_usage;
DESCRIBE dcdb.components;

SELECT t0.dcc_id,
  t0.nr_atc_codes,
  COUNT(t1.tar_id) nr_targets
FROM
  (SELECT t0.dcc_id,
    COUNT(t1.ATC_ID) nr_atc_codes
  FROM dcdb.components t0
  LEFT OUTER JOIN DCDB.DCC_TO_ATC t1
  ON t1.dcc_id = t0.dcc_id
  GROUP BY t0.dcc_id
  ) t0
LEFT OUTER JOIN DCDB.DCC_TO_TARGETS t1
ON t0.dcc_id = t1.dcc_id
GROUP BY t0.dcc_id,
  t0.nr_atc_codes ;
  
  SELECT t0.dcc_id,
  t0.nr_atc_codes,
  COUNT(t1.tar_id) nr_targets
FROM
  (SELECT t0.dcc_id,
    COUNT(t1.ATC_ID) nr_atc_codes
  FROM dcdb.components t0
  LEFT OUTER JOIN DCDB.DCC_TO_ATC t1
  ON t1.dcc_id = t0.dcc_id
  GROUP BY t0.dcc_id
  ) t0
LEFT OUTER JOIN DCDB.DCC_TO_TARGETS t1
ON t0.dcc_id = t1.dcc_id
GROUP BY t0.dcc_id,
  t0.nr_atc_codes ;
  
  create table verseny(
tantargy varchar2(255),
pontszam number,
versenyzo varchar2(255));

insert into verseny values('matematika',100,'Kiss Anna');
insert into verseny values('matematika',98,'Kiss Péter');
insert into verseny values('matematika',94,'Kovács Béla');
insert into verseny values('matematika',76,'Szabó Lilla');
insert into verseny values('matematika',65,'Pásztor Júlia');
insert into verseny values('matematika',88,'Nagy Anna');
insert into verseny values('matematika',45,'Juhász Antal');
insert into verseny values('matematika',63,'Fazekas András');
insert into verseny values('matematika',34,'Kiss Éva');


insert into verseny values('irodalom',34,'Kiss Ádám');
insert into verseny values('irodalom',56,'Szabó Ádám');
insert into verseny values('irodalom',76,'Molnár Ágoston');
insert into verseny values('irodalom',100,'Nagy Máté');
insert into verseny values('irodalom',99,'Farkas Botond');
insert into verseny values('irodalom',99,'Lovas Lilla');
insert into verseny values('irodalom',98,'Juhász Júlia');
insert into verseny values('irodalom',45,'Nagy Éva');

insert into verseny values('biológia',32,'Kiss Márton');
insert into verseny values('biológia',89,'Kedves Anna');
insert into verseny values('biológia',100,'Vass Orsolya');
insert into verseny values('biológia',100,'Pintér Ákos');
insert into verseny values('biológia',23,'Horváth Dániel');
insert into verseny values('biológia',55,'Péterfy Janka');
insert into verseny values('biológia',67,'Szabó Ádám');

select * from verseny;

select tantargy, versenyzo, pontszam, avg(pontszam) over(partition by tantargy) atlagpont
from verseny;

select tantargy, avg(pontszam) over(order by avg(pontszam) ) atlagpont
from verseny;

select tantargy, avg(pontszam) atlagpont
from verseny
group by TANTARGY;

select tantargy, versenyzo, pontszam, 
pontszam -(AVG(pontszam) OVER(PARTITION BY tantargy)) atlagponttol_elteres
FROM verseny;

select * from (
select tantargy, versenyzo, pontszam,
rank() over(partition by tantargy order by pontszam desc) rangsor,
dense_rank() over(partition by tantargy order by pontszam desc) lol
from verseny)
where rangsor < 4;

SELECT * FROM(
SELECT tantargy, versenyzo, pontszam,
RANK() OVER(PARTITION BY tantargy ORDER BY pontszam DESC) rangsor,
DENSE_RANK() OVER(PARTITION BY tantargy ORDER BY pontszam DESC)suru_rangsor
FROM verseny)
WHERE rangsor<4

SELECT
t0.DCC_ID, t0.generic_name,
LISTAGG(t2.codes, '; ') WITHIN GROUP (ORDER BY t2.CODES desc)
FROM dcdb.components t0
LEFT OUTER JOIN DCDB.DCC_TO_ATC t1
ON t1.dcc_id= t0.dcc_id
LEFT OUTER JOIN DCDB.ATC_CODES t2
ON t2.atc_id = t1.atc_id
GROUP BY t0.dcc_id, t0.generic_name;

SELECT
tantargy,
LISTAGG(versenyzo, '; ') WITHIN GROUP (ORDER BY pontszam desc)
FROM verseny
Group by TANTARGY;

create table allinfo(
ID varchar2(255),
name varchar2(255),
salary number,
dept_name varchar2(255),
building varchar2(255),
budget number
);

insert into allinfo values('22222','Einstein',95000,'Physics','Watson',70000);
insert into allinfo values('12121','Wu',90000,'Finance','Painter',120000);
insert into allinfo values('32343','El Said',60000,'History','Painter',50000);
insert into allinfo values('45565','Katz',75000,'Comp. Sci.','Taylor',100000);
insert into allinfo values('98345','Kim',80000,'Elec. Eng','Taylor',85000);
insert into allinfo values('76766','Crick',72000,'Biology','Watson',90000);
insert into allinfo values('10101','Srinivasan',65000,'Comp. Sci.','Taylor',100000);
insert into allinfo values('58583','Califieri',62000,'History','Painter',50000);
insert into allinfo values('83821','Brandt',92000,'Comp. Sci.','Taylor',100000);
insert into allinfo values('15151','Mozart',40000,'Music','Packard',80000);
insert into allinfo values('33456','Gold',87000,'Physics','Watson',70000);
insert into allinfo values('76543','Singh',80000,'Finance','Painter',120000);


select * from MB18___DB.REGIONS;
select * from mb18___db.employees;

select department_id, count(employee_id) "dolgozok_szama"
from mb18___db.employees
group by department_id
having count(employee_id)>=6;

select count(employee_id),manager_id, avg(salary) "atlagkereset"
from mb18___db.employees
group by MANAGER_ID
having count(employee_id)>7;

select manager_id, avg(salary)
  from MB18___DB.EMPLOYEES
  group by manager_id
  having count(salary)>7;
  
select t0.region_id, t0.region_name, count(t1.country_id)"orszagok_szama", count(t2.location_id) "helyek_szama"
from mb18___db.countries t1
left outer join mb18___db.regions t0
on t0.region_id=t1.region_id
left outer join mb18___db.locations t2
on t1.country_id=t2.country_id
group by t0.region_id, t0.region_name;

select c.country_id, l.location_id
from MB18___DB.COUNTRIES c
left outer join MB18___DB.locations l
on c.country_id=l.country_id;

select country_id, 
count(location_id) helyek_szama
from (select c.country_id, l.location_id
from MB18___DB.COUNTRIES c
left outer join MB18___DB.locations l
on c.country_id=l.country_id)
group by country_id;


select c.country_id, l.location_id
from MB18___DB.COUNTRIES c
left outer join MB18___DB.locations l
on c.country_id=l.country_id;

select country_id, 
count(location_id) helyek_szama
from (select c.country_id, l.location_id
from MB18___DB.COUNTRIES c
left outer join MB18___DB.locations l
on c.country_id=l.country_id)
group by country_id;

 
select r.region_id, r.region_name,c.country_name
from MB18___DB.regions r
left outer join ;

select mb18___db.countries.country_id, count(mb18___db.locations.location_id) "Helyek száma"
from mb18___db.countries
left outer join mb18___db.locations
on mb18___db.countries.country_id=mb18___db.locations.country_id 
group by mb18___db.countries.country_id
order by country_id asc;

select mb18___db.countries.country_id, mb18___db.locations.location_id
from mb18___db.countries
left outer join mb18___db.locations
on mb18___db.countries.country_id=mb18___db.locations.country_id
order by country_id asc;

select t0.country_id, nvl(t1.location_id,0)
from  mb18___db.countries t0
full outer join  mb18___db.locations t1
on t0.country_id=t1.country_id;

select t0.country_id, nvl(count(t1.location_id),0)
from  mb18___db.countries t0
full outer join  mb18___db.locations t1
on t0.country_id=t1.country_id
group by t0.country_id
order by t0.country_id asc;

select t0.department_id,t0.department_name,t1.hire_date, t1.employee_id
from  mb18___db.departments t0
full outer join  mb18___db.employees t1
on t0.department_id=t1.department_id
order by t0.department_id asc;

select t0.department_id, t0.department_name, t1.hire_date;


select department_id, department_name, hire_date,
nvl(count(employee_id) over (partition by department_id order by hire_date),0) munkatarsak_szama,
nvl(hire_date-lag(hire_date) over(partition by department_id order by hire_date),0) eltelt_ido
from
(select d.department_id, d.department_name, e.hire_date, e.employee_id
from MB18___DB.departments d
left outer join MB18___DB.employees e
on d.department_id=e.department_id);

select employee_id, first_name, last_name
from MB18___DB.employees
where ((select min(salary) min_salary
from MB18___DB.employees
where lower(last_name) like '%cambrault%')*1.05)<salary and salary<(select max(salary) max_salary
from MB18___DB.employees
where lower(last_name) not like '%cambrault%' and hire_date>to_date('1995.01.01','yyyy.mm.dd'))