CREATE TABLE Medecin (
    MedecinID INT PRIMARY KEY,
    Nom NVARCHAR(50) NOT NULL,
    Prenom NVARCHAR(50) NOT NULL,
    Specialite NVARCHAR(50),
    Adresse NVARCHAR(100)
);

-- Table Patient
CREATE TABLE Patient (
    PatientID INT PRIMARY KEY,
    Nom NVARCHAR(50) NOT NULL,
    Prenom NVARCHAR(50) NOT NULL,
    DateNaissance DATE,
    Adresse NVARCHAR(100)
);

-- Table Consultation
CREATE TABLE Consultation (
    ConsultationID INT PRIMARY KEY,
    DateConsultation DATE NOT NULL,
    Description NVARCHAR(255),
    MedecinID INT,
    PatientID INT,
    FOREIGN KEY (MedecinID) REFERENCES Medecin(MedecinID),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);

-- Table Prescription
CREATE TABLE Prescription (
    PrescriptionID INT PRIMARY KEY,
    DatePrescription DATE NOT NULL,
    MedecinID INT,
    PatientID INT,
    FOREIGN KEY (MedecinID) REFERENCES Medecin(MedecinID),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);

-- Table Medicament
CREATE TABLE Medicament (
    MedicamentID INT PRIMARY KEY,
    NomMedicament NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Forme NVARCHAR(50),
    DosageStandard NVARCHAR(50)
);

-- Table PrescriptionMedicament
CREATE TABLE PrescriptionMedicament (
    PrescriptionMedicamentID INT PRIMARY KEY,
    PrescriptionID INT,
    MedicamentID INT,
    DosagePrescrit NVARCHAR(50),
    Frequence NVARCHAR(50),
    Duree NVARCHAR(50),
    FOREIGN KEY (PrescriptionID) REFERENCES Prescription(PrescriptionID),
    FOREIGN KEY (MedicamentID) REFERENCES Medicament(MedicamentID)
);