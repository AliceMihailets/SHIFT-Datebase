--2. добавление и перемещение сотрудника в должности 
create or replace package ForEmployyes as 
procedure CreateNewEmp (
  p_last_name          employees.last_name%type,
  p_first_name         employees.first_name%type,
  p_middle_name        employees.middle_name%type   default null,
  p_phone              employees.phone%type         default null,
  p_address            employees.address%type       default null,
  p_email              employees.email%type         default null,
  p_store              number,
  p_position           number);
  
procedure TransferEmpPosition (
  p_id_emp number,
  p_id_pos number
  );
end ForEmployyes; --спец

/

create or replace package body ForEmployyes as
procedure CreateNewEmp (
  p_last_name          employees.last_name%type,
  p_first_name         employees.first_name%type,
  p_middle_name        employees.middle_name%type   default null,
  p_phone              employees.phone%type         default null,
  p_address            employees.address%type       default null,
  p_email              employees.email%type         default null,
  p_store              number,
  p_position           number) as
  begin 
    insert into employees (id_employee,
                           last_name,
                           first_name,
                           middle_name,
                           phone,
                           address,
                           email,
                           id_store,
                           id_position)
                   values (sq_ai_table.nextval,
                           p_last_name,
                           p_first_name,
                           p_middle_name,
                           p_phone,
                           p_address,
                           p_email,
                           p_store,
                           p_position);
  commit;
  dbms_output.put_line('cool!');
  exception
    when others then dbms_output.put_line('smth wrong((');
  end; --CreateNewEmp

procedure TransferEmpPosition (
  p_id_emp number,
  p_id_pos number
  ) as
  v_emp employees%rowtype;
  v_errors varchar2(1000);
  v_exc exception;
  v_exist pls_integer;
  begin 
    begin
      select * into v_emp from employees e where e.id_employee = p_id_emp;
    exception
      when no_data_found then v_errors := substr(v_errors || 'emp not found ', 1, 1000);
    end; --select id_emp
      select count(1) into v_exist from position p where p.id_position = p_id_pos;
      if v_exist = 0 then v_errors := substr(v_errors || ' position not found', 1, 1000);
      end if;
    if v_errors is null then 
      if v_emp.id_position = p_id_pos then raise v_exc;
      else 
        update employees set id_position = p_id_pos where id_employee = p_id_emp;
        dbms_output.put_line('ok!');
        commit;
       end if;
    else dbms_output.put_line(v_errors); 
    end if;
  exception
    when v_exc then  dbms_output.put_line('position is equal');
  end; --TransferEmpPosition
  
end ForEmployyes; --end of body

/

begin
  ForEmployyes.CreateNewEmp(p_last_name   => 'dfsdf',
                            p_first_name  => 'dfsdf',
                            p_middle_name => 'dfsdf',
                            p_phone       => null,
                            p_address     => 'dfsdf',
                            p_email       => null,
                            p_store       => 1,
                            p_position    => 3);
end;

/

begin 
  ForEmployyes.TransferEmpPosition(p_id_emp => 1, p_id_pos => 20);
end;
/
