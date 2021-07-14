-- 4. получить список всех магазинов (работает)
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

/*
но у меня была идея передавать в качестве параметра имя таблицы и столбца, которые я хочу вывести
(просто я где-то увидела такую штуку и захотела попробовать)
и вот оно уже не работает. ниже будет еще функция с этой фичей и несколько способов ее вызвать. но ни один не сработал
*/

create or replace function ListOfStoresAnotherOne (column_name varchar2)
return varchar2
is
var_out varchar2(1000);
begin 
  execute immediate 'select ' || column_name || ' from stores'  
  into var_out;
  return var_out;
end;
/

declare 
my_column varchar2(100) := 'NAME_OF_STORE';
begin  
  ListOfStoresAnotherOne (my_column);
end;
/

select ListOfStoresAnotherOne('NAME_OF_STORE') from dual;
/

declare 
my_column varchar2(1000) := '';
begin
  my_column := ListOfStoresAnotherOne ('NAME_OF_STORE');
end;
/

--5. получить список товаров магазинов сети (по имени магазина)
/*работает. пыталась переделать под айди магазина в качестве входных данных для процедуры, 
но подозреваю, что не работает, потому что у меня тип данных у айди в таблице - integer, а в интернете я находила только number  
*/
CREATE OR REPLACE PROCEDURE ProductsInStores_Procedure (name_store stores.name_of_store%type)
IS
type ti is table of stores.name_of_store%type;
i ti;
BEGIN
select p.name_of_product bulk collect into i
                  from stores s 
                  join productsinstores pis on s.id_store = pis.id_store
                  join products p on pis.id_product = p.id_product
                  where s.name_of_store = name_store;
                  for k in 1..i.count loop
                      dbms_output.put_line(k || ' ' || i(k));
                  end loop;
END;

/
declare 
name_store stores.name_of_store%type := 'Yarche'; 
begin
  ProductsInStores_Procedure (name_store);
end;
/


--6. получить список товаров на складе и их количество для конкретного магазина
--работает, но аналогично с прошлым не могу сменить аргумент на айди
CREATE OR REPLACE PROCEDURE QuamtityProducts (name_store stores.name_of_store%type)
IS
type rec is record 
(prod products.name_of_product%type, quantity productsonstorages.quantity%type, address storages.address%type);
type rec_table is table of rec;
i rec; --переменная типа rec
arr rec_table := new rec_table(); --массив 
BEGIN
  select products.name_of_product, productsonstorages.quantity, storages.address bulk collect into arr
  from stores  
  join storages on stores.id_store = storages.id_storage
  join productsonstorages on stores.id_store = productsonstorages.id_storage
  join products on productsonstorages.id_product = products.id_product
  where stores.name_of_store = name_store
  order by quantity;
  dbms_output.put_line('CHOOSEN STORE' || ' - ' || upper (name_store));
     for k in 1..arr.count loop
         dbms_output.put_line(arr(k).prod || CHR(9) || arr(k).quantity || CHR(9) || arr(k).address);
     end loop;
                  
END;

/
declare 
name_store stores.name_of_store%type := 'Yarche'; 
begin
  QuamtityProducts (name_store);
end;
/






















--5. получить список товаров магазинов сети (по айди магазина)

CREATE OR REPLACE PROCEDURE ProductsInStoresUsingID (name_store integer)
IS
type ti is table of integer;
i ti;
BEGIN
select p.name_of_product bulk collect into i
                  from stores s 
                  join productsinstores pis on s.id_store = pis.id_store
                  join products p on pis.id_product = p.id_product
                  --where s.id_store = 1;
                  where s.id_store = name_store;
                  for k in 1..i.count loop
                      dbms_output.put_line(k || ' ' || i(k));
                  end loop;
END;

/
declare 
name_store integer := 1; 
begin
  ProductsInStoresUsingID (name_store);
end;
/





