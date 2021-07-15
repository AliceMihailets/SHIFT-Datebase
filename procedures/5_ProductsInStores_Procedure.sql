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
