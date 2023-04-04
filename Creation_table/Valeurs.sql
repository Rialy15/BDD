INSERT INTO compte (compte_mail) VALUES
('compte1@mail.com'),
('compte2@mail.com'),
('compte3@mail.com');

INSERT INTO profil (compte_mail, nom, prenom, age) VALUES
('compte1@mail.com', 'Doe', 'John', 30),
('compte2@mail.com', 'Smith', 'Jane', 25),
('compte3@mail.com', 'Johnson', 'Michael', 40);

INSERT INTO RDV (pid1, pid2, lieuRDV, dateRDV) VALUES
(1, 2, 'Café de la Place', '2023-04-05'),
(2, 3, 'Bar du Coin', '2023-04-06'),
(3, 1, 'Restaurant Le Gourmet', '2023-04-07');

INSERT INTO Adresse (pays, ville, codepostal, rue, num) VALUES
('France', 'Paris', 75001, 'Rue de Rivoli', 10),
('Belgique', 'Bruxelles', 1000, 'Avenue Louise', 20),
('Canada', 'Montréal', 'H2L 2E7', 'Rue Sainte-Catherine', 30);

INSERT INTO Loisir (L1, L2, L3) VALUES
('Cinéma', 'Théâtre', 'Musique'),
('Sport', 'Voyages', 'Lecture'),
('Arts', 'Jeux vidéo', 'Cuisine');

INSERT INTO Album (pid, album_date) VALUES
(1, '2023-04-01'),
(2, '2023-04-02'),
(3, '2023-04-03');

INSERT INTO Photo (album_id, share_date) VALUES
(1, '2023-04-01'),
(2, '2023-04-02'),
(3, '2023-04-03');

INSERT INTO Premium (c_id, fin_abonnement) VALUES
(1, '2024-04-01'),
(2, '2024-04-02'),
(3, '2024-04-03');

INSERT INTO Classique (c_id, fin_abonnement) VALUES
(1, '2023-04-01'),
(2, '2023-04-02'),
(3, '2023-04-03');

INSERT INTO Fracture (date_fac) VALUES
('2023-04-01'),
('2023-04-02'),
('2023-04-03');

INSERT INTO Femme (compte_mail, nom, prenom, age) VALUES
('compte1@mail.com', 'Dupont', 'Marie', 28),
('compte2@mail.com', 'Garcia', 'Sophie', 32),
('compte3@mail.com', 'Leroy', 'Nathalie', 35);

INSERT INTO Homme (compte_mail, nom, prenom, age) VALUES
('homme1@mail.com', 'Martin', 'Jean', 35),
('homme2@mail.com', 'Durand', 'Pierre', 28),
('homme3@mail.com', 'Lefebvre', 'Nicolas', 42);

INSERT INTO conv (pid1, pid2) VALUES
(1, 2),
(2, 3),
(3, 1);

INSERT INTO texto (sms, date_sms, heure) VALUES
('Salut ça va ?', '2023-04-01', 10),
('Oui et toi ?', '2023-04-01', 11),
('Très bien merci', '2023-04-01', 12);
