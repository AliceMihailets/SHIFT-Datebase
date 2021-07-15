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
