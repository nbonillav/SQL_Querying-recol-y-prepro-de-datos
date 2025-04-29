/********************************
Proyecto 1
Estudiante: Natalia Bonilla V.
********************************/

/*
1. Muestre todas las películas disponibles que son catalogadas con rating de ‘PG’ o ‘PG-13’,
además que su duración de renta se encuentra entre 5 a 6, y su tamaño (largo) es mayor a 180.
*/

select title, description, rating, rental_duration, length from film
where rental_duration in (5, 6)
and length > 180
and rating in ('PG', 'PG-13')
;

/*
2. Muestre un listado de todos los clientes con su Nombre, Apellido y correo electrónico, que rentaron videos pero deben
cumplir con: El Apellido es ‘Simpson’, el inventory_id es 2580 o bien, 596, y la tienda donde se rentó es la 1.
*/

select
    c.first_name
    , c.last_name
    , c.email
    , r.inventory_id
    , c.store_id  
     
 from customer c
 inner join rental r
    on c.customer_id = r.customer_id
    
 where inventory_id in (2580, 596)
 and c.last_name LIKE '%SIMPSON%'
 ;
 
-- 3. Muestre un listado de todas las películas en habla ‘English’ y cuyo título de la película contenga ‘Egg’ en algún lado.
select 
    l.name  
    , f.title
    , f.description   
from film f
inner join language l
    on f.language_id = l.language_id
    
where l.name = 'English'
and f.title LIKE '%EGG%'
;

-- 4. Muestre las películas cuyo actor tiene como nombre ‘Penelope’ , la película tiene como tasa de renta 0.99 y un tamaño(length) de 175.
Select
    f.title,
    a.first_name,
    a.last_name,
    f.rental_rate,
    f. length
     from film f
inner join film_actor fa
    on f.film_id = fa.film_id
inner join actor a
    on a.actor_id = fa.actor_id
where a.first_name LIKE '%PENELOPE%'
    and f.rental_rate in (0.99)
    and f.length in (175)
;

/*
5. Muestre un listado de todos los países en donde se tiene presencia la empresa de Alquiler de Videos.
En el mismo listado debe aparecer la cantidad de clientes en dicho país, y las ventas totales realizadas hasta el momento.
*/
Select
    c.country
    , count(distinct cs.customer_id) as customer_count -- revisar si cs.customer_id debe llevar distinct (conteo unico)
    , sum(p.amount) as sum_amount

from country c
inner join city ct
    on c.country_id = ct.country_id
inner join address a
    on ct.city_id = a.city_id
inner join customer cs
    on a.address_id = cs.address_id
inner join payment p
    on cs.customer_id = p.customer_id
group by 1
order by 3 desc
;

/*
6. Muestre la cantidad de películas que se encuentran en la categoría de “Action”, “Comedy” o “Family”. Imprima ACCION,
COMEDIA o FAMILIAR y la cantidad de películas.
*/
select
    cat.name
    , count(cat.name) as film_count
 from category cat
inner join film_category fcat
    on cat.category_id = fcat.category_id
where cat.name LIKE '%Action%' 
    or cat.name LIKE '%Comedy%'
    or cat.name LIKE '%Family%'
group by cat.name
;

/*
7. Muestre cuantas clientes tiene por primer nombre ‘Grace’, además cuantas actrices tiene como primer nombre ‘Susan’ y
cuantos empleados (staff) tienen como primer nombre ‘Mike’. Todo tiene que aparecer en una sola sentencia.
*/
select
    a.first_name
    , count(a.first_name) as count
    , 'Susan, la actriz' as text
from actor a
where a.first_name like '%Susan%'
union  
select
    s.first_name
    , count(s.first_name) as count
    , 'Mike, el staff' as text
from staff s
where s.first_name like '%Mike%'
union
select
    c.first_name
    , count(c.first_name) as count
    , 'Grace, la cliente' as text
from customer c
where c.first_name like '%Grace%'
;

/*
8. Muestre un listado de todas las películas que han sido alquiladas entre las fechas 25 de mayo del 2005 al 26 de mayo del 2005.
De este listado, mostrar el número de boleta de alquiler, la fecha de alquiler, el nombre y apellido de la persona empleada que
lo alquiló, el titulo y la descripción de la película.
*/
-- film > Inventory > Rental> Staff
select
    r.rental_id
    , r.rental_date
    , s.first_name
    , s.last_name
--    , f.film_id
    , f.title
    , f.description
from film f
inner join inventory i
    on i.film_id = f.film_id
inner join rental r
    on r.inventory_id = i.inventory_id
inner join staff s
    on s.staff_id = r.staff_id
where r.rental_date between '2005-05-25 00:00:00' and '2005-05-26 23:59:59'
order by r.rental_date;
;

-- 9. Muestre todas las películas en donde posee características especiales como escenas borradas o Detrás de las escenas.
select title, description, special_features from film
;

-- 10. Muestre todas los clientes que compraron en la tienda 1, y muestre el Nombre, Apellido del cliente, y la última fecha en que alquiló algo en esa tienda.
select 
    cs.first_name
    , cs.last_name
    , max(r.rental_date) as last_rental_date
from rental r
inner join customer cs
    on cs.customer_id = r.customer_id
inner join inventory i 
    on r.inventory_id = i.inventory_id
where i.store_id = 1
group by cs.customer_id, cs.first_name, cs.last_name
order by last_rental_date desc
;
