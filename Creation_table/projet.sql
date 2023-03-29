drop table if exists compte;
drop table if exists profil;


create table compte (
	C_id serial primary key,
	compte_mail text not null);

create table profil (
	C_id serial primary key,
	compte_mail text not null);
 
create table prendre_RDV (
 
);

create table RDV (
  rdv_id serial primary key,
  date date not null);
  
create table En_cours (
  id_ad serial primary key);
  
create table Termines (
  fin date primary key);
  
create table Adresse (
  ad_id serial primary key,
  pays text,
  ville text,
  rue text,
  num int
  );
  
create table Preference (
  );

create table Loisir (
  );
  
create table Album (
album_id serial primary key,
c_id int not null,
album_date date NOT null
  );

create table Photo (
p_id serial primary key,
album_id int not null,
share_date date NOT null
  );

create table Premium (
c_id serial primary key,
fin_abonnement date NOT null
  );

create table Fracture (
date date
 );

create table Femme (
  f_id serial primary key
 );
create table Homme (
  h_id serial primary key
 );

create table conversation (
  h_id serial primary key
 );




    