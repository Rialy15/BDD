--Requêtes

-- récupère tous les profils qui ont au moins un loisir en commun 
-- avec le profil dont le nom commence par "Doe". 
-- La sous-requête trouve tous les profils qui ont un loisir en commun 
-- avec le profil "Doe", puis la requête principale récupère 
-- les noms et prénoms correspondants.

SELECT p.nom, p.prenom
FROM profil p
WHERE p.pid IN (
  SELECT l1.pid
  FROM Loisir l1
  WHERE EXISTS (
    SELECT 1
    FROM Loisir l2
    WHERE l2.pid = [profil ID pour "Doe%"]
    AND l1.L1 = l2.L1 OR l1.L2 = l2.L2 OR l1.L3 = l2.L3
  )
)

SELECT nom, prenom, age 
FROM profil 
WHERE age > (SELECT AVG(age) FROM profil);

---
-- Cette requête retourne les noms et prénoms de deux profils ayant eu un rendez-vous dans un lieu donné (qui a été terminé) au cours de l'année 2022 et qui ont un lien de parrainage (le premier profil est le filleul du parrain du deuxième profil).

-- Les deux sous-requêtes sont :

-- SELECT lieurdv FROM Termines WHERE fin BETWEEN '2022-01-01' AND '2022-12-31' : qui retourne tous les lieux de rendez-vous qui ont été terminés au cours de l'année 2022.
-- SELECT pid_Parrainé FROM parrainage WHERE pid_Parrain = (SELECT pid_Parrain FROM parrainage WHERE pid_Parrainé = r.pid1) : qui retourne l'identifiant du profil parrainé ayant le même parrain que le profil pid1 de la table rdv. Cette sous-requête est utilisée dans la clause WHERE pour filtrer les rendez-vous en fonction des liens de parrainage.

SELECT 
    p1.prenom AS prenom1, p1.nom AS nom1, p2.prenom AS prenom2, p2.nom AS nom2
FROM 
    rdv r 
    JOIN profil p1 ON r.pid1 = p1.pid
    JOIN profil p2 ON r.pid2 = p2.pid
WHERE 
    r.lieurdv IN (
        SELECT lieurdv FROM Termines
        WHERE fin BETWEEN '2022-01-01' AND '2022-12-31'
    )
    AND 
    r.pid1 IN (
        SELECT pid_Parrainé FROM parrainage 
        WHERE pid_Parrain = (
            SELECT pid_Parrain FROM parrainage 
            WHERE pid_Parrainé = r.pid1
        )
    );

-- Cette requête utilise deux sous-requêtes imbriquées dans une clause WHERE. La première sous-requête sélectionne tous les utilisateurs ayant un compte premium en utilisant la table Premium et la jointure sur la table profil. La seconde sous-requête sélectionne tous les utilisateurs ayant des préférences en commun avec un utilisateur spécifié en comparant les colonnes P1, P2 et P3 de la table Preference 
-- avec celles de l'utilisateur spécifié. La requête globale renvoie les noms des utilisateurs qui répondent aux deux critères.
SELECT p.nom
FROM profil p
WHERE EXISTS (
  SELECT *
  FROM Premium pr
  WHERE p.pid = pr.ppid
) AND EXISTS (
  SELECT *
  FROM Preference pref
  WHERE pref.pid = p.pid
  AND EXISTS (
    SELECT *
    FROM Preference pref2
    WHERE pref2.pid = <utilisateur_specifié>
    AND pref.P1 = pref2.P1 OR pref.P2 = pref2.P2 OR pref.P3 = pref2.P3
  )
);


---Partie de Paul


SELECT compte.compte_mail, profil.nom, profil.prenom, profil.age
FROM compte
INNER JOIN profil ON compte.C_id = profil.C_id;

SELECT compte.compte_mail, prendre_RDV.lieuRDV, prendre_RDV.dateRDV
FROM compte
LEFT JOIN prendre_RDV ON compte.C_id = prendre_RDV.C_id;

SELECT prendre_RDV.pid, RDV.lieuRDV, RDV.dateRDV
FROM prendre_RDV
RIGHT JOIN RDV ON prendre_RDV.pid = RDV.pid;

SELECT compte.compte_mail, prendre_RDV.lieuRDV, RDV.dateRDV
FROM compte
FULL OUTER JOIN prendre_RDV ON compte.C_id = prendre_RDV.C_id
FULL OUTER JOIN RDV ON prendre_RDV.pid = RDV.pid;

SELECT a.adr_id, a.rue, b.adr_id, b.rue
FROM Adresse a
INNER JOIN Adresse b ON a.adr_id <> b.adr_id
WHERE a.rue = b.rue;


CREATE VIEW vue_persistante AS
SELECT compte.compte_mail, profil.nom, profil.prenom, profil.age
FROM compte
INNER JOIN profil ON compte.C_id = profil.C_id;

CREATE OR REPLACE TEMP VIEW vue_temporaire AS
SELECT compte.compte_mail, prendre_RDV.lieuRDV, RDV.dateRDV
FROM compte
FULL OUTER JOIN prendre_RDV ON compte.C_id = prendre_RDV.C_id
FULL OUTER JOIN RDV ON prendre_RDV.pid = RDV.pid;


SELECT compte_mail, COUNT(nom) AS nb_profil
FROM vue_persistante
GROUP BY compte_mail;

SELECT compte_mail, lieuRDV, dateRDV
FROM vue_temporaire
WHERE lieuRDV IS NOT NULL;

SELECT compte_mail, 'compte' AS type
FROM compte
UNION
SELECT compte_mail, 'profil' AS type
FROM profil;
