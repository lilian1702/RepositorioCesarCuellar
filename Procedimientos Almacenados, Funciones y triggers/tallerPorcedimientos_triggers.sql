
DELIMITER //

create procedure día_de_la_semana (in dia int, out nombre_dia varchar(30))
begin
IF dia=1 then set nombre_dia="lunes";
elseif dia=2 then set nombre_dia="martes";
elseif dia=3 then set nombre_dia="miercoles";
elseif dia=4 then set nombre_dia="jueves";
elseif dia=5 then set nombre_dia="viernes";
elseif dia=6 then set nombre_dia="sabado";
elseif dia=7 then set nombre_dia="domingo";
else set nombre_dia="dato invalido";
end if;
end //

DELIMITER ;
call día_de_la_semana (3, @resultado);
select @resultado;

use jardineria;

DELIMITER //
CREATE PROCEDURE calcular_valores_pago (IN forma_pago VARCHAR(60))
BEGIN
SELECT MAX(total) AS max_pago,
MIN(total) as min_pago,
avg(total) as promedio_pago,
sum(total) as suma_pagos,
count(*) as num_pagos
from pago p where p.forma_pago= forma_pago;
END //

DELIMITER ;
call calcular_valores_pago ("PayPal");

#punto 3

create database procedimientos;
use procedimientos; 

create table pares(
numero int unsigned
);

create table impares(
numero int unsigned
);

DELIMITER //

create procedure calcular_pares_impares (in tope int unsigned)
begin
declare i int default 1;
	delete from pares;
	delete from impares;
		while i <= tope do
		if i %2=0 then 
			insert into pares (numero) values (i);
		else 
			insert into impares (numero) values (i);
		end if; 
		set i= i+1;
	end while;
end //

DELIMITER ;

call calcular_pares_impares (10);
use procedimientos; 

select * from pares;
select * from impares;


#4

DELIMITER //
create function obtener_mes (mes int) returns varchar (25) deterministic
begin
return case
when mes = 1 then "enero"
when mes = 2 then "febrero"
when mes = 3 then "marzo"
when mes = 4 then "abril"
when mes = 5 then "mayo"
when mes = 6 then "junio"
when mes = 7 then "julio"
when mes = 8 then "agosto"
when mes = 9 then "septiembre"
when mes = 10 then "octubre"
when mes = 11 then "noviembre"
when mes = 12 then "diciembre"
else "el dato no es valido"
end;
end //
DELIMITER ;
select obtener_mes (5); 

#5

use jardineria; 

DELIMITER //
create function obtener_total_pagos_mes_año (mes int, anio int) returns decimal (10,2) deterministic
begin
declare total_pagos decimal (10,2);
select sum(total) into total_pagos
from pago where month(fecha_pago)= mes and year(fecha_pago)= anio;
return total_pagos;
end //
DELIMITER ;

select obtener_total_pagos_mes_año (10, 2007 );

select  * from pago; 

#6

DELIMITER //
drop function if exists cantidad_total_de_productos_vendidos //
create function cantidad_total_de_productos_vendidos (codigo_producto varchar(15)) returns int deterministic
begin
 declare total int;
 select sum(cantidad) into total from detalle_pedido dp
 where dp.codigo_producto = codigo_producto;
 return total;
end //
DELIMITER ;

select cantidad_total_de_productos_vendidos ("OR-241");

select * from detalle_pedido; 
use jardineria; 

create table notificaciones (
id int unsigned auto_increment primary key,
fecha_hora datetime not null,
total numeric(10,2) not null,
codigo_cliente int not null
);

DELIMITER //
create trigger trigger_notificar_pago
after insert on pago
for each row
begin
insert into notificaciones (fecha_hora, total, codigo_cliente) 
values (new.fecha_pago, new.total, new.codigo_cliente);
end //
DELIMITER ;
select * from cliente;
insert into pago (fecha_pago, total, codigo_cliente, forma_pago, id_transaccion) values (now(),3500.00, 10, "PayPal","1234");

select * from notificaciones; 


#8
drop database test;
create database test; 
use test;

create table alumnos(
id int unsigned primary key auto_increment,
nombre varchar(50) not null,
apellido1 varchar(50) not null,
apellido2 varchar(50) not null,
email varchar (255) 
);
alter table alumnos modify column id int unsigned auto_increment primary key;
alter table alumnos modify column email varchar(255) null;alumnos
DELIMITER //
create procedure crear_email (in nombre varchar(50), in apellido1 varchar(50), in apellido2 varchar(50), in dominio varchar(50), out email varchar(255))
begin
set email = lower(concat(left(nombre,1),left(apellido1,3), left(apellido2,3),"@",dominio));
end//
DELIMITER ;


DELIMITER //
create trigger trigger_crear_email_before_insert 
before insert on alumnos
for each row
begin
if new.email is null then 
call crear_email(new.nombre, new.apellido1, new.apellido2, "default.com",@new_email);
set new.email=@new_email;
end if;
end //
DELIMITER ;

insert into alumnos(nombre, apellido1, apellido2,email) values("lilian", "anacona", "narvaez", null);
select * from alumnos;

