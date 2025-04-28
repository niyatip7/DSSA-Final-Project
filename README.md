## About the Project

This is project was completed by Margvinatta S. and Niyati P. as part of a final project for Data Gathering and Warehouse Class for Stockton University's Data Science and Strategic Analytics Masters program. The goal of the project is to apply the learning objectives and concepts completed in the course to build a comprehensive database system for a fictional company. 


### Company Info

*Name*: Diasure 

*Mission* - Diasure's mission is to prevent diabetes misdiagnosis through data accuracy. 

*Vision* - Empower individuals with accessible, and reliable tools to correctly identify their type of diabetes, prevent misdiagnosis, and receive the right care.

### Data Collection

At Diasure, data is collected through hospital records, insurance companies, laboratories, and clinics and collectively added to a cloud-based warehouse. Everything from patient demographics, family history, lab results, blood sugar levels, BMI, insulin, ketones, diet, lifestyle, diabetes symptoms(urination frequency, thirst, exhaustion, and weight loss), Diastolic and Systolic blood pressure is collected through the sources. Data quality checks happen before and after extraction to ensure the data is cleaned and organized appropriately. Mainly the ETL integration approach is followed. For duplicates, if patient data is the same for all columns the duplicate is deleted as well as if there is missing data. Accuracy checks happen to remove repeated/duplicate data and missing values. Ensure format consistency across columns, change columns names to comply with SQL workbench. Since a lot of personal data is collected so HIPPA is strictly enforced, and only authorized users have access. The warehouse is also encrypted. Below is an overview of the database including a few sources, staging, storage, and presentations. 
![image](https://github.com/user-attachments/assets/f001f824-5d87-428a-a2f6-d24463bcb9b0)


### Database Design

The schema file for the data is atttached as a separate file in the repository. There is another image with tables explaining all the columns with names, a short description and column type. 
There are a total of 5 main tables titled symptoms, diabetes data, patients, lifestyle, and tests. The patients table, symptoms, and tests tables are connected to the diabetes table through patient id, symptom id, and test id respectively. The lifestyle table is connected to the patients table through patients id.  

### Database Storage

All data is stored on a cloud-based warehouse because data needs to be access by multiple people at the same time for research and progress. To manage the data SQL workbench, RStudio, and Shiny app is used. For recovery, data is refreshed and uploaded daily and can be easily recalled based on the day if needed. 

### Database Access and Analysis

Several queries were run in SQL workbench. Below is an example of the query. For all visualizations, RStudio and Shiny app is used to create user-friendly surfaces for all to learn about various demographic and disease information. Refer to the picture below for a visual based on the query.

Query- ![Screenshot 2025-04-28 024319](https://github.com/user-attachments/assets/59d535fa-7964-4fe5-9ed5-0c3716799de5)


Visual- ![image](https://github.com/user-attachments/assets/446ebeba-c27b-42ba-8878-d152d0f674e5)


### Conclusion 
Diasure is a fully funded company because diabetes affects millions of people not just in the US but worldwide. A misdiagnosis hinders proper treatment and can be detrimental to health and quality of life for the individual. Being the 8th leading cause of death in the US, there is not information about misdiagnosis and prevention of a misdiagnosis. At Diasure we aim to bridge the gap in missing data and help individuals improve their well being by ensuring a proper and accurate diagnosis. 

Several files have been uploaded in the repository. A powerpoint presentation, RStudio code, word document with visuals, cleaned data CSV file, database schema, and SQL script.  

