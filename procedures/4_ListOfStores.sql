-- 4. получить список всех магазинов
create or replace procedure ListOfStores 
is
type ti is table of stores.name_of_store%type;
i ti;
begin 
  select stores.name_of_store bulk collect into i 
  from stores;
  for k in 1..i.count loop
      dbms_output.put_line(k || ' ' || i(k));
  end loop;
end;
/

begin  
  ListOfStores;
end;
/
