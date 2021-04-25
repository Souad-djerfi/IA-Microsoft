use sakila;
select * from staff;
select * from store;
#1- Afficher les 10 locations les plus longues (nom/prenom client, film, video club, durée)
select customer.first_name, customer.last_name, title, staff.first_name,staff.last_name,datediff(return_date,rental_date) from film
join inventory on inventory.film_id=film.film_id
join rental on rental.inventory_id=inventory.inventory_id and rental_date is not null and return_date is not null
join customer on customer.customer_id=rental.customer_id
join staff on staff.staff_id=rental.staff_id
order by datediff(return_date,rental_date) desc
limit 10;

#2- Afficher les 10 meilleurs clients actifs par montant dépensé (nom/prénom client, montant dépensé)
select first_name, last_name, amount from payment
join customer on customer.customer_id=payment.customer_id
join rental on rental.rental_id=payment.rental_id
order by amount desc
limit 10;

#3- Afficher la durée moyenne de location par film triée de manière descendante
select title, avg(datediff(return_date,rental_date)) as moy from rental
join inventory on inventory.inventory_id=rental.inventory_id
join film on film.film_id=inventory.film_id
group by title
order by moy desc;

#4. - Afficher tous les films n'ayant jamais été empruntés
select distinct title from film 
where film_id 
not in 
(select distinct film.film_id from film 
join inventory on inventory.film_id=film.film_id
join rental on rental.inventory_id=inventory.inventory_id
);
#5.- Afficher le nombre d'employés (staff) par video club
select staff.staff_id,count(staff_id) as nbre_employés from staff
join store on store.store_id = staff.store_id
group by staff.staff_id;

#6- Afficher les 10 villes avec le plus de video clubs
select city , count(store_id) from store 
join address on address.address_id=store.address_id
join city on city.city_id=address.city_id
group by city
order by count(store_id) desc
limit 10;

#7.- Afficher le film le plus long dans lequel joue Johnny Lollobrigida
select title, length from actor
join film_actor on film_actor.actor_id=actor.actor_id and first_name='Johnny' and last_name='Lollobrigida'
join film on film.film_id=film_actor.film_id
order by length desc
limit 1;

#8.- Afficher le temps moyen de location du film 'Academy dinosaur'
select avg(datediff(return_date,rental_date)) from rental
join inventory on inventory.inventory_id=rental.inventory_id
join film on film.film_id=inventory.film_id and title ='Academy dinosaur';

#9- Afficher les films avec plus de deux exemplaires en inventaire (store id, titre du film, nombre d'exemplaires)
select store.store_id, title, count(inventory.film_id) as nbre_exemplaire from store
join inventory on inventory.store_id=store.store_id
join film on film.film_id=inventory.film_id
group by title
having nbre_exemplaire >2;

#10- Lister les films contenant 'din' dans le titre
select title from film where title like 'din%';

#11- Lister les 5 films les plus empruntés
select title, count(rental.rental_id) as nbre_emprunt from film
join inventory on inventory.film_id=film.film_id
join rental on rental.inventory_id=inventory.inventory_id
group by title
order by nbre_emprunt desc
limit 5;

#12- Lister les films sortis en 2003, 2005 et 2006
select title from film where release_year in (2003,2005,2006);

select * from rental where return_date is null;
#13- Afficher les films ayant été empruntés mais n'ayant pas encore été restitués, triés par date 
select title, rental_date,return_date from rental
join inventory on inventory.inventory_id=rental.inventory_id and return_date is null
join film on film.film_id=inventory.film_id
order by rental_date
limit 10;

#14- Afficher les films d'action durant plus de 2h
select title, length from category
join film_category on film_category.category_id=category.category_id and name='Action'
join film on film.film_id=film_category.film_id and length>120;

#15- Afficher tous les utilisateurs ayant emprunté des films avec la mention NC-17
select  distinct last_name,first_name, title, rating from film
join inventory on inventory.film_id=film.film_id and rating='NC-17'
join rental on rental.inventory_id=inventory.inventory_id
join customer on customer.customer_id=rental.customer_id;

select * from film;
#16- Afficher les films d'animation dont la langue originale est l'anglais // y a que ds null dans la colonne!
select title, category.name, language.name from category
join film_category on film_category.category_id=category.category_id and category.name='Animation'
join film on film.film_id=film_category.film_id
join language on language.language_id=film.language_id and language.name='English';

#17- Afficher les films dans lesquels une actrice nommée Jennifer a joué (bonus: en même temps qu'un acteur nommé Johnny)
select title from actor 
join film_actor on film_actor.actor_id=actor.actor_id and first_name='Jennifer' 
join film on film.film_id=film_actor.film_id;

#18- Quelles sont les 3 catégories les plus empruntées?
select title, count(rental_id), category.name  from film
join film_category on film_category.film_id=film.film_id
join category on category.category_id=film_category.category_id
join inventory on inventory.film_id=film.film_id
join rental on rental.inventory_id=inventory.inventory_id
group by category.name
order by count(rental_id) desc;

#19- Quelles sont les 10 villes où on a fait le plus de locations?
select city, count(rental_id) from rental
join inventory on inventory.inventory_id=rental.inventory_id
join store on store.store_id=inventory.store_id
join address on address.address_id=store.address_id
join city on city.city_id=address.city_id
group by city
order by count(rental_id) desc;


#20- Lister les acteurs ayant joué dans au moins 1 film
select first_name, last_name from actor
where actor.actor_id in (
					select distinct actor.actor_id from actor 
                    join film_actor on film_actor.actor_id=actor.actor_id)


