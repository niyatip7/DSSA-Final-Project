#4/21/2025
# Niyati and Natta

#create a database 
CREATE DATABASE IF NOT EXISTS diabetess;
USE diabetess;

CREATE TABLE IF NOT EXISTS diasure_data (
    patient_id VARCHAR(10) PRIMARY KEY,
    gender VARCHAR(20),
    state VARCHAR(50),
    age INT);
  

CREATE TABLE IF NOT EXISTS patients (
    patient_id VARCHAR(10) PRIMARY KEY,
    gender VARCHAR(20),
    state VARCHAR(50),
    age INT,
    pregnant VARCHAR(5),
    family_history VARCHAR(5),
    age_at_onset INT,
	FOREIGN KEY (patient_id) REFERENCES diasure_data(patient_id));

# Blood Test results
CREATE TABLE IF NOT EXISTS tests (
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id VARCHAR(10),
    fasting_glucose INT,
    ogtt_2hr INT,
    random_glucose INT,
    hba1c FLOAT,
    systolic_bp INT,
    diastolic_bp INT,
    bmi FLOAT,
    FOREIGN KEY (patient_id) REFERENCES diasure_data(patient_id));
    
#symptoms reported per patient
CREATE TABLE IF NOT EXISTS symptoms (
    symptom_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id VARCHAR(10),
    frequent_urination VARCHAR(5),
    very_thirsty VARCHAR(5),
    weight_loss VARCHAR(5),
    feeling_exhausted VARCHAR(5),
    general_symptom_report VARCHAR(10),
    FOREIGN KEY (patient_id) REFERENCES diasure_data(patient_id));
    
#Lifestyle indicators table 
CREATE TABLE IF NOT EXISTS lifestyle (
	lifestyle_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id VARCHAR(10),
    exercise_level VARCHAR(20),
    access_to_healthy_food VARCHAR(20),
    diagnosis VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES diasure_data(patient_id));



#Average fasting glucose by exercise level
SELECT l.exercise_level, 
    AVG(t.fasting_glucose) AS avg_fasting_glucose
FROM lifestyle l
JOIN tests t ON l.patient_id = t.patient_id
GROUP BY l.exercise_level;


#Distribution of patients by states
SELECT p.state, 
    COUNT(p.patient_id) AS total_patients
FROM patients p
GROUP BY p.state
ORDER BY total_patients DESC; -- Optional: Orders the states by the number of patients, descending
 

#patients with high sugar tests
SELECT 
    t.patient_id,
    t.random_glucose,
    t.fasting_glucose,
    t.ogtt_2hr
FROM tests t
WHERE 
    t.random_glucose >= 200
    AND t.fasting_glucose >= 126
    AND t.ogtt_2hr > 200;


# Patients with multiple key symptoms
SELECT 
    s.patient_id,
    s.frequent_urination,
    s.very_thirsty,
    s.weight_loss,
    s.feeling_exhausted
FROM 
    symptoms s
WHERE 
    s.frequent_urination = 'Yes'
    AND s.very_thirsty = 'Yes'
    AND s.weight_loss = 'Yes'
    AND s.feeling_exhausted = 'Yes';










