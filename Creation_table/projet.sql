drop table if exists En_cours;
drop table if exists Termines;
drop table if exists Adresse;
drop table if exists Loisir;
drop table if exists Preference;
drop table if exists Album;
drop table if exists Photo;
drop table if exists Premium;
drop table if exists Classique;
drop table if exists Facture;
drop table if exists Femme;
drop table if exists Homme;
drop table if exists texto;
drop table if exists conv;
drop table if exists parrainage;
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
 

create table rdv (
  pid1 integer not null,
  pid2 integer not null,
  lieuRDV text not null,
  dateRDV date,
  primary key (pid1,lieuRDV,dateRDV)
  );
  
create table parrainage (
  pid_Parrain integer not null,
  pid_Parrainé integer not null,
  parrainage_date date NOT null,
  primary key (pid_Parrain,pid_Parrainé)
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

create table Classique (
  pcid serial primary key,
  fin_abonnement date NOT null,
  foreign KEY (pcid) REFERENCES profil(pid)
  );

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
  