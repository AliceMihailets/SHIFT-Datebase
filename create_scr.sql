--creating tables
/*
CREATE TABLE Sales (
  id_sale INTEGER NOT NULL,
  type_of_sales VARCHAR2(30) NOT NULL,
  size_of_sales INTEGER NOT NULL,
  id_product_in_store INTEGER NOT NULL,
  PRIMARY KEY (id_sale)
);

CREATE TABLE ProductsInStores (
  id_product_in_store INTEGER NOT NULL,
  price NUMBER(10,2) NOT NULL,
  quantity INTEGER NOT NULL,
  id_store INTEGER NOT NULL,
  id_product INTEGER NOT NULL,
  id_sale INTEGER NOT NULL,
  PRIMARY KEY (id_product_in_store)
);

CREATE TABLE Orders (
  id_order INTEGER NOT NULL,
  date_of_order DATE NOT NULL,
  id_store INTEGER NOT NULL,
  id_seller INTEGER NOT NULL,
  PRIMARY KEY (id_order)
);

CREATE TABLE ProductsForOrder (
  id_product_for_order INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  cost_of_product NUMBER(10,2) NOT NULL,
  id_order INTEGER NOT NULL,
  id_product INTEGER NOT NULL,
  PRIMARY KEY (id_product_for_order)
);

CREATE TABLE Cities (
  id_city INTEGER NOT NULL,
  name_of_city VARCHAR2(30) NOT NULL,
  PRIMARY KEY (id_city)
);

CREATE TABLE TypesOfShops (
  id_type INTEGER NOT NULL,
  name VARCHAR2(50) NOT NULL,
  PRIMARY KEY (id_type)
);

CREATE TABLE Stores (
  id_store INTEGER NOT NULL,
  name_of_store VARCHAR2(100) NOT NULL,
  address VARCHAR2(250) NOT NULL,
  phone VARCHAR2(20),
  id_city INTEGER NOT NULL,
  id_type INTEGER NOT NULL,
  PRIMARY KEY (id_store)
);

CREATE TABLE Storage (
  id_storage INTEGER NOT NULL,
  address VARCHAR2(250) NOT NULL,
  phone VARCHAR2(20),
  id_store INTEGER NOT NULL,
  PRIMARY KEY (id_storage)
);

CREATE TABLE Position (
  id_position INTEGER NOT NULL,
  name_of_position VARCHAR2(30) NOT NULL,
  salary NUMBER(10,2) NOT NULL,
  PRIMARY KEY (id_position)
);

CREATE TABLE Employees (
  id_employee INTEGER NOT NULL,
  last_name VARCHAR2(30) NOT NULL,
  first_name VARCHAR2(30) NOT NULL,
  middle_name VARCHAR2(30),
  phone VARCHAR2(20),
  address VARCHAR2(250),
  email VARCHAR2 (50),
  id_store INTEGER NOT NULL,
  id_position INTEGER NOT NULL,
  PRIMARY KEY (id_employee)
);

CREATE TABLE Products (
  id_product INTEGER NOT NULL,
  name_of_product VARCHAR2(100) NOT NULL,
  units VARCHAR2(20) NOT NULL,
  cost NUMBER(10,2) NOT NULL,
  id_category INTEGER NOT NULL,
  id_provider INTEGER NOT NULL,
  PRIMARY KEY (id_product)
);

CREATE TABLE ProductsOnStorages (
  id_product_on_storage INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  id_product INTEGER NOT NULL,
  id_storage INTEGER NOT NULL,
  PRIMARY KEY (id_product_on_storage)
);

CREATE TABLE Providers (
  id_provider INTEGER NOT NULL,
  name_of_provider VARCHAR2(50) NOT NULL,
  address VARCHAR2(250) NOT NULL,
  phone VARCHAR2(20),
  id_city INTEGER NOT NULL,
  PRIMARY KEY (id_provider)
);

CREATE TABLE Categories (
  id_category INTEGER NOT NULL,
  name_of_category VARCHAR2(30) NOT NULL,
  PRIMARY KEY (id_category)
);
 
*/


--FK

ALTER TABLE ProductsInStores
  ADD (CONSTRAINT pis_sal_fk
    FOREIGN KEY (id_sale)
    REFERENCES Sales (id_sale),
    CONSTRAINT pis_store_fk
    FOREIGN KEY (id_store)
    REFERENCES Stores (id_store),
    CONSTRAINT pis_prod_fk
    FOREIGN KEY (id_product)
    REFERENCES Products (id_product)
);

ALTER TABLE Orders
  ADD (CONSTRAINT ord_store_fk
    FOREIGN KEY (id_store)
    REFERENCES Stores (id_store),
    CONSTRAINT ord_emp_fk
    FOREIGN KEY (id_seller)
    REFERENCES Employees (id_employee)
);

ALTER TABLE ProductsForOrder
  ADD (CONSTRAINT pfo_ord_fk
    FOREIGN KEY (id_order)
    REFERENCES Orders (id_order),
    CONSTRAINT pfo_prod_fk
    FOREIGN KEY (id_product)
    REFERENCES Products (id_product)
);

ALTER TABLE Stores
  ADD (CONSTRAINT store_city_fk
    FOREIGN KEY (id_city)
    REFERENCES Cities (id_city),
    CONSTRAINT store_type_fk
    FOREIGN KEY (id_type)
    REFERENCES TypesOfShops (id_type)
);

ALTER TABLE Storage
  ADD (CONSTRAINT storage_store_fk
    FOREIGN KEY (id_store)
    REFERENCES Stores (id_store)
);

ALTER TABLE Employees
  ADD (CONSTRAINT emp_store_fk
    FOREIGN KEY (id_store)
    REFERENCES Stores (id_store),
    CONSTRAINT emp_pos_fk
    FOREIGN KEY (id_position)
    REFERENCES Position (id_position)
);

ALTER TABLE Products
  ADD (CONSTRAINT prod_prov_fk
    FOREIGN KEY (id_provider)
    REFERENCES Providers (id_provider),
    CONSTRAINT prod_cat_fk
    FOREIGN KEY (id_category)
    REFERENCES Categories (id_category)
);


ALTER TABLE ProductsOnStorages
  ADD (CONSTRAINT pos_prod_fk
    FOREIGN KEY (id_product)
    REFERENCES Products (id_product),
    CONSTRAINT pos_storage_fk
    FOREIGN KEY (id_storage)
    REFERENCES Storage (id_storage)
);

ALTER TABLE Providers
  ADD (CONSTRAINT prov_city_fk
    FOREIGN KEY (id_city)
    REFERENCES Cities (id_city)
);
