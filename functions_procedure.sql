use windowsdb;
#FUNCTION
delimiter $$
create function get_annual_salary(monthly_salary decimal(10,2))
returns decimal(10,2)
begin
	return monthly_salary*12;
end
$$

delimiter ;

select name, salary,get_annual_salary(Salary) from employee; 

#PROCEDURE
delimiter $$
create procedure give_hike_by_country(
in countryName varchar(50),
in hike_per decimal(10,2))
begin 
update employee set Salary = Salary+(Salary*hike_per/100)
where Country = countryName;

end 
$$

delimiter ;

call give_hike_by_country('India',10);

select * from employee where country='India';

#procedure for output
delimiter && 
create procedure display_high_sal(
OUT highestSal int)
begin
select max(sal) into highestSal from employee;
end &&

delimiter ;

call display_high_sal(@Salary);
select @Salary as maxsal;
select * from employee;


delimiter &&
create procedure addition(
in a int,
in b int,
out sum int)
begin
select a+b into sum;
end &&

delimiter ;

call addition(5,3,@addi);

select @addi;


#Cursor
DELIMITER $$

CREATE PROCEDURE give_bonus_to_low_earners()
BEGIN
    -- Declare variables to store current row data
    DECLARE done INT DEFAULT FALSE;
    DECLARE emp_id INT;
    DECLARE emp_name VARCHAR(100);
    DECLARE emp_salary DECIMAL(10,2);

    -- Declare cursor for employees earning < 5000
    DECLARE emp_cursor CURSOR FOR
        SELECT id, name, salary FROM employee WHERE salary < 5000;

    -- Handler to set 'done' to true when no more rows
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open cursor
    OPEN emp_cursor;

    -- Start loop
    read_loop: LOOP
        -- Fetch data into variables
        FETCH emp_cursor INTO emp_id, emp_name, emp_salary;

        -- Exit loop if no more rows
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Update the salary for the fetched employee
        UPDATE employee
        SET salary = emp_salary + 500
        WHERE id = emp_id;

    END LOOP;

    -- Close cursor
    CLOSE emp_cursor;
END $$

DELIMITER ;
####call it 
CALL give_bonus_to_low_earners();
select * from employee;



