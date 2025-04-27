#4/21/2025
# Niyati and Natta
# Ran a few queries and made a schema diagram from the diasure data

CREATE TABLE diasure_data (
    ID VARCHAR(10) PRIMARY KEY,
    `Fasting Glucose (mg/dL)` INT,
    `OGTT 2hr (mg/dL)` INT,
    `HbA1c (%)` FLOAT,
    `Random Glucose (mg/dL)` INT,
    Symptoms VARCHAR(10),
    Diagnosis VARCHAR(50),
    Gender VARCHAR(20),
    State VARCHAR(50),
    `Systolic BP (mmHg)` INT,
    `Diastolic BP (mmHg)` INT,
    BMI FLOAT,
    Age INT,
    `Exercise Level` VARCHAR(20),
    `Access to Healthy Food` VARCHAR(20),
    Pregnant VARCHAR(5),
    `Age at Onset` INT,
    `Family History` VARCHAR(5),
    `Frequent Urination` VARCHAR(5),
    `Very Thirsty` VARCHAR(5),
    `Weight Loss` VARCHAR(5),
    `Feeling Exhausted` VARCHAR(5)
);
# people where diagnosed with likely diabetes from survey
SELECT * FROM diasure_data;
SELECT Diagnosis, COUNT(*) AS total
FROM diasure_data
GROUP BY Diagnosis;
# The average HbA1c per gender
SELECT Gender, AVG(`HbA1c (%)`) AS average_HbA1c
FROM diasure_data
GROUP BY Gender;

#Average fasting glucose by exercise level
SELECT `Exercise Level`, AVG(`Fasting Glucose (mg/dL)`) AS avg_fasting_glucose
FROM diasure_data
GROUP BY `Exercise Level`;

#Distribution of patients by states
SELECT State, COUNT(*) AS number_of_patients
FROM diasure_data
GROUP BY State
ORDER BY number_of_patients DESC;

#patients with high random glucose
SELECT ID, `Random Glucose (mg/dL)`, State
FROM diasure_data
WHERE `Random Glucose (mg/dL)` > 200;

# Patients with multiple key symptoms
SELECT ID, Gender, State
FROM diasure_data
WHERE `Frequent Urination` = 'Yes'
  AND `Very Thirsty` = 'Yes'
  AND `Weight Loss` = 'Yes'
  AND `Feeling Exhausted` = 'Yes';


#Basic Patient Info
CREATE TABLE patients (
    patient_id VARCHAR(10) PRIMARY KEY,
    gender VARCHAR(20),
    state VARCHAR(50),
    age INT,
    pregnant VARCHAR(5),
    family_history VARCHAR(5),
    age_at_onset INT
);
# Blood Test results
CREATE TABLE tests (
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id VARCHAR(10),
    test_date DATE,
    fasting_glucose INT,
    ogtt_2hr INT,
    random_glucose INT,
    hba1c FLOAT,
    systolic_bp INT,
    diastolic_bp INT,
    bmi FLOAT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);
#symptoms reported per patient
CREATE TABLE symptoms (
    symptom_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id VARCHAR(10),
    frequent_urination VARCHAR(5),
    very_thirsty VARCHAR(5),
    weight_loss VARCHAR(5),
    feeling_exhausted VARCHAR(5),
    general_symptom_report VARCHAR(10),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);
#behaviourial and Lifestyle indicators
CREATE TABLE lifestyle (
    patient_id VARCHAR(10) PRIMARY KEY,
    exercise_level VARCHAR(20),
    access_to_healthy_food VARCHAR(20),
    diagnosis VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

select * from lifestyle;






