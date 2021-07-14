--домашка №3. 
--1. большой красивый (нет) пакет
create or replace package ActionsWithProducts is 

--добавление товара на склад
procedure AddProductToStorage (
  pts_quantity         productsonstorages.quantity%type,
  pts_id_prod          productsonstorages.id_product%type,
  pts_id_storage       productsonstorages.id_storage%type
);

--доваление товара со склада в магазин
procedure AddProductToStore (
  pis_price            productsinstores.price%type,
  pis_quantity         productsinstores.quantity%type,
  pis_id_store         productsinstores.id_store%type,
  pis_id_prod          productsinstores.id_product%type,
  pis_id_sale          productsinstores.id_sale%type         default null
);

--перемещение товара с одного склада на другой  
procedure TransferProductToNewStorage (
  pts_prod_id number,
  pts_storage_id number
);

end ActionsWithProducts; --конец спецификации на пакет

/

create or replace package body ActionsWithProducts is
procedure AddProductToStorage (
  pts_quantity         productsonstorages.quantity%type,
  pts_id_prod          productsonstorages.id_product%type,
  pts_id_storage       productsonstorages.id_storage%type
) is
  begin 
    insert into productsonstorages (id_product_on_storage,
                                    quantity,
                                    id_product,
                                    id_storage)
                                    
                                    values 
                                    (sq_ai_table.nextval,
                                    pts_quantity,  
                                    pts_id_prod,  
                                    pts_id_storage);
     commit;
     dbms_output.put_line('product added successfully!');
  exception
    when others then dbms_output.put_line('smth wrong((');
  end AddProductToStorage;
  
procedure AddProductToStore (
  pis_price            productsinstores.price%type,
  pis_quantity         productsinstores.quantity%type,
  pis_id_store         productsinstores.id_store%type,
  pis_id_prod          productsinstores.id_product%type,
  pis_id_sale          productsinstores.id_sale%type         default null
) is
  begin
    insert into productsinstores(id_product_in_store,
                                 price,
                                 quantity,
                                 id_store,
                                 id_product,
                                 id_sale)
                                 values
                                 (sq_ai_table.nextval,
                                  pis_price,   
                                  pis_quantity,
                                  pis_id_store,
                                  pis_id_prod, 
                                  pis_id_sale); 
    commit;                              
    dbms_output.put_line('product added successfully!');
  exception
    when others then dbms_output.put_line('smth wrong((');
  end AddProductToStore;

procedure TransferProductToNewStorage (
  pts_prod_id              number,
  pts_storage_id           number
  ) is
   
  v_prod productsonstorages%rowtype;
  v_errors varchar2(1000);
  v_exc exception;
  v_exist pls_integer;
  
  begin
     
    begin
      select * into v_prod from productsonstorages pis where pis.id_product_on_storage = pts_prod_id;
    exception
      when no_data_found then v_errors := substr(v_errors || 'emp not found ', 1, 1000);
    end;
    
    select count(1) into v_exist from storages s where s.id_storage = pts_storage_id;
      
    if v_exist = 0 then v_errors := substr(v_errors || ' storage not found', 1, 1000);
    end if;
      
    if v_errors is null then 
      if v_prod.id_storage = pts_storage_id then raise v_exc;
      else 
        update productsonstorages set id_storage = pts_storage_id where id_product_on_storage = pts_prod_id;
        dbms_output.put_line('all right!');
        commit;
      end if;
    else dbms_output.put_line(v_errors); 
    end if;
    
  exception
    when v_exc then  dbms_output.put_line('storage is equal');
  end TransferProductToNewStorage;
  
end ActionsWithProducts; --end of body

/

begin
  ActionsWithProducts.AddProductToStorage(pts_quantity   => 451,
                                          pts_id_prod    => 1,
                                          pts_id_storage => 1);
end;

/

begin
  ActionsWithProducts.TransferProductToNewStorage(pts_prod_id => 142, 
                                                  pts_storage_id => 3);
end;

/

begin
  ActionsWithProducts.AddProductToStore(pis_price    => 330,
                                        pis_quantity => 41,
                                        pis_id_store => 1,
                                        pis_id_prod  => 1,
                                        pis_id_sale  => 1);
end;
                                        
/

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

--3. добавить скидку + получить все скидки за определенный период 
--добавление
create or replace procedure AddSale (
  s_size              sales.size_of_sales%type,
  s_prod              sales.id_product_in_store%type,
  s_start_date        sales.start_date_of_sale%type,
  s_end_date          sales.end_date_of_sale%type          default null
)
is

begin 
  insert into sales(id_sale,
                    size_of_sales,
                    id_product_in_store,
                    start_date_of_sale,
                    end_date_of_sale)
               values (sq_ai_table.nextval,
                       s_size,      
                       s_prod,      
                       s_start_date,
                       s_end_date);
  commit;
  dbms_output.put_line('sale added!');  
  exception
    when others then dbms_output.put_line('smth wrong((');
end;                
/

begin 
  AddSale(s_size       => '25',
          s_prod       => 5,
          s_start_date => TO_DATE('14072021','DDMMYYYY'),
          s_end_date   => TO_DATE('14082021','DDMMYYYY'));
end;
/

--получение
create or replace procedure GetSales (start_date sales.start_date_of_sale%type, end_date sales.end_date_of_sale%type)
is 
  type rec is record (name_store stores.name_of_store%type, name_product products.name_of_product%type,
  sale_size sales.size_of_sales%type, start_date sales.start_date_of_sale%type, end_date sales.end_date_of_sale%type);
  type rec_table is table of rec;
  i rec;
  arr rec_table; 
begin
  select s.name_of_store, p.name_of_product, sa.size_of_sales, 
  sa.start_date_of_sale, sa.end_date_of_sale bulk collect into arr
  from stores s 
  join productsinstores pis on s.id_store = pis.id_store
  join products p on pis.id_product_in_store = p.id_product
  join sales sa on sa.id_product_in_store = pis.id_product_in_store
  where sa.start_date_of_sale >= start_date
  and sa.end_date_of_sale <= end_date;
  dbms_output.put_line('SALES FROM ' || start_date || ' TO ' || end_date);
     for k in 1..arr.count loop
         dbms_output.put_line(arr(k).name_store || CHR(9) || arr(k).name_product || CHR(9) || arr(k).sale_size || '%'
         || CHR(9) || arr(k).start_date || CHR(9) || arr(k).end_date);
     end loop;
end;

/
declare 
my_start_date sales.start_date_of_sale%type := TO_DATE('10102020','DDMMYYYY');
my_end_date sales.end_date_of_sale%type := TO_DATE('10102022','DDMMYYYY');
begin
  GetSales (my_start_date, my_end_date);
end;
/

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

--5. получить список товаров магазинов сети (по имени магазина)
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
