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
