-- 1. Quels sont les médecins présents dans le cabinet médical ?
SELECT * FROM Medecin;

-- 2. Combien de patients sont enregistrés dans la base de données ?
SELECT COUNT(*) AS NombreDePatients FROM Patient;

-- 3. Quels patients sont suivis par le médecin avec l'ID 1 ?
SELECT DISTINCT Patient.*
FROM Patient
JOIN Consultation ON Patient.PatientID = Consultation.PatientID
WHERE Consultation.MedecinID = 1;

-- 4. Quelles sont les consultations effectuées par le médecin avec l'ID 2 ?
SELECT * 
FROM Consultation
WHERE MedecinID = 2;

-- 5. Quels sont les patients qui n'ont pas encore de prescription ?
SELECT Patient.*
FROM Patient
LEFT JOIN Prescription ON Patient.PatientID = Prescription.PatientID
WHERE Prescription.PatientID IS NULL;

-- 6. Quel est le nombre total de prescriptions effectuées dans le cabinet médical ?
SELECT COUNT(*) AS Nombre
