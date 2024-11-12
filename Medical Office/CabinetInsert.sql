-- Insert sample data into Medecin table
INSERT INTO Medecin (MedecinID, Nom, Prenom, Specialite, Adresse) VALUES 
(1, 'Dupont', 'Jean', 'Cardiologue', '123 Rue de la Santé, Paris'),
(2, 'Lemoine', 'Marie', 'Pédiatre', '45 Avenue des Enfants, Lyon'),
(3, 'Moreau', 'Pierre', 'Généraliste', '78 Rue des Champs, Marseille');

-- Insert sample data into Patient table
INSERT INTO Patient (PatientID, Nom, Prenom, DateNaissance, Adresse) VALUES 
(1, 'Martin', 'Alice', '1990-05-10', '5 Rue de Paris, Bordeaux'),
(2, 'Bernard', 'Louis', '1985-03-15', '10 Avenue de la République, Lille'),
(3, 'Dubois', 'Claire', '2000-07-22', '15 Rue des Fleurs, Nice');

-- Insert sample data into Consultation table
INSERT INTO Consultation (ConsultationID, DateConsultation, Description, MedecinID, PatientID) VALUES 
(1, '2024-10-01', 'Consultation annuelle', 1, 1),
(2, '2024-10-02', 'Consultation pédiatrique', 2, 3),
(3, '2024-10-03', 'Suivi général', 3, 2);

-- Insert sample data into Prescription table
INSERT INTO Prescription (PrescriptionID, DatePrescription, MedecinID, PatientID) VALUES 
(1, '2024-10-01', 1, 1),
(2, '2024-10-02', 2, 3),
(3, '2024-10-04', 3, 2);

-- Insert sample data into Medicament table
INSERT INTO Medicament (MedicamentID, NomMedicament, Description, Forme, DosageStandard) VALUES 
(1, 'Paracétamol', 'Antalgique et antipyrétique', 'Comprimé', '500 mg'),
(2, 'Ibuprofène', 'Anti-inflammatoire', 'Comprimé', '200 mg'),
(3, 'Amoxicilline', 'Antibiotique', 'Gélule', '500 mg'),
(4, 'Cétirizine', 'Antihistaminique', 'Comprimé', '10 mg');

-- Insert sample data into PrescriptionMedicament table
INSERT INTO PrescriptionMedicament (PrescriptionMedicamentID, PrescriptionID, MedicamentID, DosagePrescrit, Frequence, Duree) VALUES 
(1, 1, 1, '500 mg', '2 fois par jour', '5 jours'),
(2, 1, 2, '200 mg', '3 fois par jour', '7 jours'),
(3, 2, 3, '500 mg', '1 fois par jour', '10 jours'),
(4, 3, 4, '10 mg', '1 fois par jour', '5 jours');
