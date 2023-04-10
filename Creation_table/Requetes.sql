--Requêtes
DROP TRIGGER check_age_trigger ON profil;
DROP TRIGGER add_timestamp_trigger ON texto;
DROP TRIGGER check_rdv_termines_trigger ON En_cours;
DROP TRIGGER create_facture_trigger ON Premium;
DROP TRIGGER update_age_trigger ON profil;


DROP FUNCTION check_age();
DROP FUNCTION add_timestamp();
DROP FUNCTION check_rdv_termines();
DROP FUNCTION create_facture();
DROP FUNCTION update_age();


DROP VIEW rdv_a_venir;
DROP VIEW total_rdv_par_utilisateur;



-- Trouver les utilisateurs qui ont des loisirs similaires à l'utilisateur ayant pid = 1
SELECT p.nom, p.prenom
FROM profil p
WHERE EXISTS (
    SELECT 1
    FROM Loisir l1
    WHERE l1.pid = p.pid AND (
        l1.L1 IN (SELECT L1 FROM Loisir WHERE pid = 1)
        OR l1.L2 IN (SELECT L1 FROM Loisir WHERE pid = 1)
        OR l1.L3 IN (SELECT L1 FROM Loisir WHERE pid = 1)
    )
);

-- Nom, prenom, age des personnes ayant un age supérieur que celui moyen
SELECT nom, prenom, age 
FROM profil 
WHERE age > (SELECT AVG(age) FROM profil);



--
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

-- profils Premium qui ont des préférences similaires à pid =3
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
    WHERE pref2.pid = 3
    AND pref.P1 = pref2.P1 OR pref.P2 = pref2.P2 OR pref.P3 = pref2.P3
  )
);


--Partie de Paul
-- INNER JOIN: Liste des utilisateurs avec leurs adresses :
SELECT p.pid, p.nom, p.prenom, a.pays, a.ville, a.rue, a.codepostal, a.num
FROM profil p
JOIN Adresse a ON p.pid = a.adr_id;


--LEFT JOIN: Liste des utilisateurs et leurs loisirs, même s'ils n'ont pas de loisirs enregistrés :
SELECT p.pid, p.nom, p.prenom, l.L1, l.L2, l.L3
FROM profil p
LEFT JOIN Loisir l ON p.pid = l.pid;


--RIGHT JOIN: Liste des rendez-vous en cours avec les informations des deux utilisateurs, y compris ceux qui n'ont pas de rendez-vous en cours :
SELECT e.id_ad, p1.pid AS pid1, p1.nom AS nom1, p1.prenom AS prenom1, p2.pid AS pid2, p2.nom AS nom2, p2.prenom AS prenom2, e.lieuRDV, e.dateRDV
FROM profil p1
JOIN En_cours e ON p1.pid = e.pid1
RIGHT JOIN profil p2 ON e.pid2 = p2.pid;


--INNER et LEFT: Liste des utilisateurs, leurs albums, et les photos partagées, même s'ils n'ont pas d'albums ou de photos :
SELECT p.pid, p.nom, p.prenom, a.album_id, a.album_date, ph.ph_id, ph.share_date
FROM profil p
LEFT JOIN Album a ON p.pid = a.pid
LEFT JOIN Photo ph ON a.album_id = ph.album_id;


--FULL OUTER JOIN: Montrer tous les profils et leurs adresses correspondantes
SELECT p.pid, p.nom, p.prenom, a.adr_id, a.pays, a.ville, a.rue, a.codepostal, a.num
FROM profil p
FULL OUTER JOIN Adresse a ON p.pid = a.adr_id;


--UNION :Liste de tous les rendez-vous (terminés et en cours)
SELECT pid1, pid2, lieuRDV, dateRDV
FROM En_cours
UNION ALL
SELECT pid1, pid2, lieuRDV, dateRDV
FROM Termines
ORDER BY dateRDV;

--Vue : liste des rendez-vous à venir par utilisateur
 
CREATE VIEW rdv_a_venir AS
SELECT p1.nom AS nom1, p1.prenom AS prenom1, p2.nom AS nom2, p2.prenom AS prenom2, rdv.lieuRDV, rdv.dateRDV
FROM rdv
JOIN profil p1 ON rdv.pid1 = p1.pid
JOIN profil p2 ON rdv.pid2 = p2.pid
WHERE rdv.dateRDV >= CURRENT_DATE;

--Test de vue : Rendez-vous de tous les John
SELECT * FROM rdv_a_venir
WHERE prenom1 = 'John' OR prenom2 = 'John';


--Vue : nombre total de rendez-vous par utilisateur

CREATE VIEW total_rdv_par_utilisateur AS
SELECT pid, COUNT(*) AS total_rdv
FROM (
    SELECT pid1 AS pid FROM rdv
    UNION ALL
    SELECT pid2 AS pid FROM rdv
) AS rdv_union
GROUP BY pid;

--Test de vue : Personnes ayant plusieurs rendez-vous
SELECT * FROM total_rdv_par_utilisateur
WHERE total_rdv > 1;


--vérifier l'âge avant d'insérer ou de mettre à jour un profil

CREATE OR REPLACE FUNCTION check_age() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.age < 18 THEN
    RAISE EXCEPTION 'L''âge doit être supérieur ou égal à 18';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_age_trigger
  BEFORE INSERT OR UPDATE ON profil
  FOR EACH ROW
  EXECUTE FUNCTION check_age();

--ajouter un timestamp lors de l'insertion d'un message dans la table texto
 
CREATE OR REPLACE FUNCTION add_timestamp() RETURNS TRIGGER AS $$
BEGIN
  NEW.heure = EXTRACT(HOUR FROM CURRENT_TIME);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER add_timestamp_trigger
  BEFORE INSERT ON texto
  FOR EACH ROW
  EXECUTE FUNCTION add_timestamp();
  
--marquer les rendez-vous comme terminés
 
CREATE OR REPLACE FUNCTION check_rdv_termines() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.dateRDV < CURRENT_DATE THEN
    INSERT INTO Termines (pid1, pid2, lieuRDV, dateRDV, fin) VALUES (NEW.pid1, NEW.pid2, NEW.lieuRDV, NEW.dateRDV, CURRENT_DATE);
    DELETE FROM En_cours WHERE id_ad = NEW.id_ad;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_rdv_termines_trigger
  AFTER INSERT OR UPDATE ON En_cours
  FOR EACH ROW
  EXECUTE FUNCTION check_rdv_termines();
  
--Ajouter une nouvelle ligne dans la table Facture lorsqu'un profil Premium est créé:

CREATE OR REPLACE FUNCTION create_facture()
  RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO Facture (date_fac) VALUES (NEW.fin_abonnement);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER create_facture_trigger
  AFTER INSERT ON Premium
  FOR EACH ROW
  EXECUTE FUNCTION create_facture();
  
-- mettre à jour le age d'un profil après une modification
CREATE OR REPLACE FUNCTION update_age()
  RETURNS TRIGGER AS $$
BEGIN
  NEW.age = EXTRACT(YEAR FROM age(NEW.date_naissance));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

ALTER TABLE profil ADD COLUMN date_naissance DATE;

CREATE TRIGGER update_age_trigger
  BEFORE INSERT OR UPDATE OF date_naissance ON profil
  FOR EACH ROW
  EXECUTE FUNCTION update_age();
