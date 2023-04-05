drop table if exists En_cours;
drop table if exists Termines;
drop table if exists Adresse;
drop table if exists Loisir;
drop table if exists Preference;
drop table if exists Album;
drop table if exists Photo;
drop table if exists Premium;
drop table if exists Classique;
drop table if exists Fracture;
drop table if exists Femme;
drop table if exists Homme;
drop table if exists conv;
drop table if exists texto;
drop table if exists rdv;
drop table if exists profil;
drop table if exists compte;



create table compte (
  C_id serial primary key,
  compte_mail text not null);

create table profil (
	pid serial primary key,
	compte_mail text not null,
  nom text not null,
  prenom text not null,
  age integer not null);
 
--Plus pratique sans cette table ooft
-- create table prendre_RDV (
-- );

--Tout dans rdv directement
create table rdv (
  pid1 integer not null,
  pid2 integer not null,
  lieuRDV text not null,
  dateRDV date,
  primary key (pid1,lieuRDV,dateRDV)
  --foreign key (pid) references profil(pid)
  );
  
create table En_cours (
  id_ad serial primary key)
  INHERITS (rdv);
  
create table Termines (
  fin date primary key)
  INHERITS (rdv);
  
create table Adresse (
  adr_id serial primary key,
  pays text,
  ville text,
  codepostal int,
  rue text,
  num int
  );


--3 types de loisir par profil
create table Loisir (
  L1 text,
  L2 text,
  L3 text
  );

create table Preference (
  P1 text,
  P2 text
  );
  
create table Album (
  album_id serial primary key,
  pid int not null,
  album_date date NOT null
  );

create table Photo (
  ph_id serial primary key,
  album_id int not null,
  share_date date NOT null
  );

create table Premium (
  ppid serial primary key,
  fin_abonnement date NOT null,
  foreign KEY (ppid) REFERENCES profil(pid)
  )
  INHERITS (profil);

create table Classique (
  pcid serial primary key,
  fin_abonnement date NOT null,
  foreign KEY (pcid) REFERENCES profil(pid)
  )
  INHERITS (profil);

create table Fracture (
  date_fac date
 );

create table Femme (
  f_id serial primary key
 )INHERITS (profil);

create table Homme (
  h_id serial primary key
 )INHERITS (profil);

create table conv (
  pid1 integer not null,
  pid2 integer not null,
  primary key (pid1,pid2)
 );

create table texto (
  sms text,
  date_sms date,
  heure int
 );




    