/************************
Laboratorio 3
************************/
-- 1. Cuáles son las distanncias categopriuas de rating que existen en los datos?
select distinct rating from film;

-- 2. ¿Cuál es la lista de películas que tienen las letras “Air” y son de habla inglesa?
select f.title
from film f
inner join language l
    on f.language_id = l.language_id
where
    f.title LIKE '%AIR%'
    and l.name = 'English'
;    
-- 3. Muestre el customer_id, first_name, last_name, email, inventory_id, store_id del cliente llamado “John” donde el id de inventario sea 3604 o 1592.
select 
    c.customer_id
    , c.first_name
    , c.last_name
    , c.email
    , r.inventory_id
    , c.store_id
    --, c.store_id as store_id_from_cust_table
from customer c
inner join rental r
    on c.customer_id = r.customer_id
where c.first_name = 'JOHN'
    and inventory_id in (3604, 1592)
;
-- 4. ¿Cuántos clientes hay por país? Ordénelos de forma descendente.
select
    co.country
    , count(distinct customer_id) as customer_count
from customer c
inner join address a
    on c.address_id = a.address_id
inner join city as ct
    on ct.city_id = a.city_id 
inner join country co
    on co.country_id = ct.country_id
group by 1
order by 2 desc
;

-- 5. Realice una lista única del primer nombre (first_name) de las tablas de actors, staff y customer.
select first_name from actor
union  
select first_name from staff
union
select first_name from customer
;
-- 6. ¿Cuál es la cantidad de alquileres realizados en 2005-05-28?
select 
    count(*) as count_rent
from
    rental
where
rental_date between '2005-05-28 00:00:00' and '2005-05-28 23:59:59'
;

-- 7. ¿Cuántos alquileres se realizaron en la mañana (antes de las 11am), tarde (12am –5pm) y noche (6pm a medianoche)?

select
    case
        when cast(strftime('%H', rental_date) as number) between 0 and 11 then 'Morning'
        when cast(strftime('%H', rental_date) as number) between 12 and 17 then 'After Noon'
        when cast(strftime('%H', rental_date) as number) between 18 and 23 then 'Evening'
    end as time_of_day,
    count(*) as record_count
from
    rental
group by 1
order by 1    
;
