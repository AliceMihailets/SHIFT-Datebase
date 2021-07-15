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
