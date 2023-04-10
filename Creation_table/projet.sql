drop table if exists En_cours cascade;
drop table if exists Termines cascade;
drop table if exists Adresse cascade;
drop table if exists Loisir cascade;
drop table if exists Preference cascade;
drop table if exists Album cascade;
drop table if exists Photo cascade;
drop table if exists Premium cascade;
drop table if exists Facture cascade;
drop table if exists Femme cascade;
drop table if exists Homme cascade;
drop table if exists texto cascade;
drop table if exists conv cascade;
drop table if exists parrainage cascade;
drop table if exists compte cascade;
drop table if exists rdv cascade;
drop table if exists profil cascade;
drop table if exists signalement cascade;




create table compte (
  C_id serial primary key,
  compte_mail text not null);

create table profil (
	pid serial primary key,
	compte_mail text not null,
  nom text not null,
  prenom text not null,
  age integer not null);

create table signalement (
  pid_signalé integer not null,
  pid_signaleur integer not null,
  date_s date 
);
 
create table rdv (
  pid1 integer not null,
  pid2 integer not null,
  lieuRDV text not null,
  dateRDV date,
  primary key (pid1,pid2,lieuRDV,dateRDV)
  );
  
create table parrainage (
  pid_Parrain integer not null,
  pid_Parrainé integer not null,
  parrainage_date date not null,
  primary key (pid_Parrain,pid_Parrainé)
  );


create table En_cours (
  id_ad serial primary key)
  INHERITS (rdv);
  
create table Termines (
  fin date)
  INHERITS (rdv);
  
create table Adresse (
  adr_id serial primary key,
  pays text,
  ville text,
  codepostal int,
  rue text,
  num int
  );


create table Loisir (
  pid int primary key,
  L1 text,
  L2 text,
  L3 text
  );

create table Preference (
  pid int primary key,
  P1 text,
  P2 text,
  P3 text
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
  ;

create table Facture (
  date_fac date
 );

create table Femme (
  f_id serial primary key
 )INHERITS (profil);

create table Homme (
  h_id serial primary key
 )INHERITS (profil);

create table conv (
  id_conv serial primary key,
  pid1 integer not null,
  pid2 integer not null
 );

create table texto (
  id_texto serial primary key,
  id_conv integer not null,
  sms text,
  date_sms date,
  heure int
 );
