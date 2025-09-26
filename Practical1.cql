create keyspace keyspace1 with replication = {'class':'SimpleStrategy', 'replication_factor':3};

use keyspace1;

create table dept(dept_id int PRIMARY KEY, dept_name text, dept_loc text);
create table emp(emp_id int PRIMARY KEY, emp_name text, dept_id int, email text, phone text);


insert into dept(dept_id, dept_name, dept_loc) values(1001, 'Accounts', 'Mumbai');
insert into dept(dept_id, dept_name, dept_loc) values(1002, 'Marketing', 'Delhi');
insert into dept(dept_id, dept_name, dept_loc) values(1003, 'HR', 'Chennai');


insert into emp(emp_id, emp_name, dept_id, email, phone) values(1001, 'ABCD', 1001, 'abcd@company.com', '1122334455');
insert into emp(emp_id, emp_name, dept_id, email, phone) values(1002, 'DEFG', 1001, 'defg@company.com', '2233445566');
insert into emp(emp_id, emp_name, dept_id, email, phone) values(1003, 'GHIJ', 1002, 'ghij@company.com', '3344556677');
insert into emp(emp_id, emp_name, dept_id, email, phone) values(1004, 'JKLM', 1002, 'jklm@company.com', '4455667788');
insert into emp(emp_id, emp_name, dept_id, email, phone) values(1005, 'MNOP', 1003, 'mnop@company.com', '5566778899');
insert into emp(emp_id, emp_name, dept_id, email, phone) values(1006, 'MNOP', 1003, 'mnop@company.com', '5566778844');

select * from dept;
select * from emp;

update dept set dept_name='Human Resource' where dept_id=1003;
select * from dept;

delete from emp where emp_id=1006;
select * from emp;
