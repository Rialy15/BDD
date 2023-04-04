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
