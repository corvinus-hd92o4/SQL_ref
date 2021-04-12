create or replace procedure MB18_BODMIH_HMH3MV(
tulaj in varchar2,
tabla in varchar2)
is
t_tulaj varchar2(250) := lower(tulaj);  --a kis es nagybetuk kezelesere vonatkozo kisbetuve alakitas
t_tabla varchar2(250) := lower(tulaj);
letezike int :=0; --igaz vagy hamis, tala letezesere vonatkozo int
nincsilyentabla exception; -- kivetel kezeles, ha a beirt tablanev nem letezik
ccursor myCursor (t_tulaj in varchar2, t_tabla in varchar2)
is
select TABLE_NAME,  -- ezeket szeretnenk visszakapni, az oszlopneveket tudjuk elore
COLUMN_NAME,
DATA_TYPE
from all_tab_columns
where OWNER = t_tulaj
and TABLE_NAME = t_tabla
and(DATA_TYPE  = 'NUMBER' or DATA_TYPE = 'varchar2')
order by COLUMN_ID; -- feladat kikötése
sorok myCursor%rowtype; -- a cursor fejlécének tipusainak atvetele
minimum NUMBER;
atlag NUMBER;
maximum NUMBER;
szoras NUMBER;
nemnull_arany int;
kulonbozo_ertekek  NUMBER;
begin
select count(*)
into letezike
from all_tables
where OWNER = t_tulaj and  TABLE_NAME = t_tulaj;
if (letezike = 0)
then
raise nincsilyentabla;
end if;
for sorok in myCursor (t_tulaj,t_tabla)
loop
dbms_output.put(lower(lpad(sorok.COLUMN_NAME)));
execute immediate 'select 100*count('  -- ezzel az eljárással nem kell külön meghivni a CURSOR-t 
						|| sorok.COLUMN_NAME || ')/count(*) from'
						|| t_tulaj || '.'
						|| t_tabla || into nemnull_arany;
dbms_output.put( ' notnull' 
						|| rpad((to_char(nemnull_arany, '999')
						|| '%'), 15));
if(
sorok.DATA_TYPE = 'NUMBER')
then
execute immediate 'select min('
						|| sorok.COLUMN_NAME || '),
						avg('||sorok.COLUMN_NAME ||'),
						max('|| sorok.COLUMN_NAME ||'),
						stddev('|| sorok.COLUMN_NAME||'),
                from  ' || t_tulaj || '.' || t_tabla|| ''
into  -- az értékek a deklaralt valtozokba tevese
						minimum,
						atlag,
						maximum,
						szoras;
dbms_output.put_line ('min' || to_char(minimum, '9.99EEEE') ||','
					  'avg:' || to_char(atlag, '9.99EEEE')|| ','
					  'max:' || to_char(maximum, '9.99EEEE')|| ','
					  'sd:'  || to_char(atlag, '9.99EEEE'));
end if;
if (
sorok.DATA_TYPE = 'VARCHAR2')
then
execute immediate 'select count(distinct ' 
					||sorok.COLUMN_NAME || ') from ' 
					|| t_tulaj || '.'
					|| t_tabla|| ''
into kulonbozo_ertekek;
dbms_output.put_line('unq:'
					|| to_char(kulonbozo_ertekek, '9.99EEEE'));
end if;
end loop;
exception
when nincsilyentabla then dbms_output.put_line('No such table : ' 
																|| t_tulaj || '.' || t_tabla);
end;
