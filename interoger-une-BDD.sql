use sakila;
#1. Afficher tout les emprunt ayant été réalisé en 2006. Le mois doit être écrit en toute lettre et le résultat doit s’afficher dans une seul colonne
select rental_date from rental
join inventory on inventory.inventory_id=rental.inventory_id and year(rental_date)=2006
join film on film.film_id=inventory.film_id ;

#2.Afficher la colonne qui donne la durée de location des films en jour.
select datediff(return_date,rental_date) from rental;

#3.Afficher les emprunts réalisés avant 1h du matin en 2005. Afficher la date dans un format lisible
select title, rental_date from rental
join inventory on rental.inventory_id=inventory.inventory_id and time(rental_date) between '00:00' and '00:59:59' and year(rental_date)='2005'
join film on inventory.film_id=film.film_id;

#4. Afficher les emprunts réalisé entre le mois d’avril et le moi de mai. La liste doit être trié du plus ancien au plus récent.
select title, rental_date from rental 
join inventory on inventory.inventory_id=rental.inventory_id and month(rental_date) between 4 and 5
join film on film.film_id=inventory.film_id
order by rental_date;

#5.Lister les films dont le nom ne commence pas par le "LE" 
select title from film where title not like 'LE%';

#6.Lister les films ayant la mention « PG-13 » ou « NC-17 ». Ajouter une colonne qui affichera « oui » si « NC-17 » et « non » Sinon
select title, rating,
if (rating='NC-17','Oui', 'Non') as Confirmation
from film where rating in ('PG-13','NC-17');

#7.Fournir la liste des catégories qui commencent par un ‘A’ ou un ‘C’. (Utiliser LEFT)
select name from category where name like  'A%' or name like 'C%' ;

#8.Lister les trois premiers caractères des noms des catégorie
select substr(name,1,3) from category;

#9.Lister les premiers acteurs en remplaçant dans leur prenom les E par des A.
select last_name,replace(first_name,'E','A') from actor;

#**************LES JOINTURES*******************
#1. Lister les 10 premiers films ainsi que leur langues
select title, name from film 
join language on language.language_id=film.language_id
limit 10;

#2. Afficher les film dans les quel à joué « JENNIFER DAVIS » sortie en 2006
select title from actor
join film_actor on film_actor.actor_id=actor.actor_id and  first_name='JENNIFER' and last_name='DAVIS'
join film on film.film_id=film_actor.film_id;

#3.Afficher le noms des clients ayant emprunté « ALABAMA DEVIL »
select first_name, last_name from inventory
join film on film.film_id=inventory.film_id and film.title='ALABAMA DEVIL'
join rental on rental.inventory_id =inventory.inventory_id
join customer on customer.customer_id=rental.customer_id;

#4.Afficher les films louer par des personne habitant à « Woodridge ».  
select title from customer
join address on address.address_id=customer.address_id 
join city on city.city_id=address.city_id and  city='Woodridge'
join rental on rental.customer_id=customer.customer_id
join inventory on inventory.inventory_id=rental.inventory_id
join film on film.film_id=inventory.film_id;


# A Vérifier avec Valério : Vérifié s’il y a des films qui n’ont jamais été emprunté
select distinct title from rental 
join inventory on rental.inventory_id=inventory.inventory_id 
left join film on film.film_id=inventory.film_id 
where  film.film_id is null;

#5. Quel sont les 10 films dont la durée d’emprunt à été la plus courte 
select title, timediff(return_date,rental_date) from rental 
join inventory on inventory.inventory_id =rental.inventory_id and return_date is not null and rental_date is not null
join film on film.film_id=inventory.inventory_id
order by timediff(return_date,rental_date)
limit 10;


#6. Lister les films de la catégorie « Action » ordonnés par ordre alphabétique
select title , name from category 
join film_category on film_category.category_id = category.category_id and name= 'Action'
join film on film.film_id=film_category.film_id
order by title;


#7. Quel sont les films dont la duré d’emprunt à été inférieur à 2 jour ?
select distinct title from rental 
join inventory on inventory.inventory_id=rental.inventory_id and  timediff(return_date,rental_date) < '48:00:00'
join film on film.film_id=inventory.film_id
 