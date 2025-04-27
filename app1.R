# Shiny App
# Niyati and Natta
# 4/21/25


# Load libraries
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(tidyverse)
library(usmap)
library(ggplot2)
library(readr)
library(broom)


install.packages("rsconnect")
rsconnect::setAccountInfo(name='niyatip',
                          token='E4CF50E49CE3EA01AE5941380332D435',
                          secret='yhrD+edbqBuP0tetgK3OQxbOkv3ZtRNFIWtaHWcR')


# Load and preprocess data
Diabetes_with_Type <- read_csv("Dataset_Diabetes(Sheet1).csv")

#create a new to column to calculate the likeliness of person having diabetes 
#based on glucose based test results 
Diabetes_with_Type <- Diabetes_with_Type %>%
    mutate(likely_diabetes = case_when(
      `Fasting Glucose (mg/dL)` >= 126 ~ TRUE,
      `OGTT 2hr (mg/dL)` >= 200 ~ TRUE,
      `HbA1c (%)` >= 6.5 ~ TRUE,
      `Random Glucose (mg/dL)` >= 200 ~ TRUE,
      TRUE ~ FALSE))
  # create a new columm to group ages into categories
  Diabetes_with_Type <- Diabetes_with_Type %>%
    mutate(age_group = case_when(
      Age < 20 ~ "Under 20",
      Age < 40 ~ "20–39",
      Age < 60 ~ "40–59",
      TRUE ~ "60+"))
  
  #code for shiny app user interface 
  # Define UI
  ui <- fluidPage(
    titlePanel("Diabetes Insights Dashboard"),         #main title
    tabsetPanel(
      tabPanel("US Heatmap", plotOutput("heatmap")),   #first tab title 
      tabPanel("Top States",                           # second tab title    
               sidebarLayout(
                 sidebarPanel(
                   #create an input area to select all or specific states 
                   selectInput("state_filter", "Select State:",
                               choices = c("All", sort(unique(Diabetes_with_Type$State))),
                               selected = "All")),
                 #graph results based pon chosen dropdown option 
                 mainPanel(plotOutput("topStates")))),   
      tabPanel("Age Risk",                            # third tab title 
               sidebarLayout(
                 sidebarPanel(
                   #create an option to select a certian age group or display all 
                   selectInput("age_filter", "Select Age Group:", 
                               choices = c("All", sort(unique(Diabetes_with_Type$age_group))),
                               selected = "All")),
                 #graph results based pon chosen dropdown option
                 mainPanel(plotOutput("agePlot")))),
      tabPanel("Family History", plotOutput("familyPlot"))))  #forth tab title 
  
  
  
  # Define Server (what the shiny app will do)
  server <- function(input, output) {
    # State Summary for Heatmap
    #summarize how many paitents and how many likely diabetes cases per state 
    state_summary <- Diabetes_with_Type %>%
      group_by(State) %>%
      summarise(
        total_patients = n(),
        likely_diabetes_cases = sum(likely_diabetes, na.rm = TRUE),
        diabetes_percent = (likely_diabetes_cases / total_patients) * 100,
        .groups = "drop"
      ) %>%
      rename(state = State)
    #heatmap plot 
    output$heatmap <- renderPlot({
      plot_usmap(data = state_summary, values = "diabetes_percent", color = "black") +
        #add a color gradient 
        scale_fill_continuous(low = "grey71", high = "steelblue2", name = "Likely Diabetes %") +
        #add a title 
        labs(title = "Likely Diabetes Prevalence by State") +
        theme(legend.position = "right")
    })
    #top states bar plot 
    output$topStates <- renderPlot({
      filtered_summary <- state_summary
      #if a state is selected display one if not then display all 
      if (input$state_filter != "All") {
        filtered_summary <- filtered_summary %>% filter(state == input$state_filter)
      } else {
        filtered_summary <- filtered_summary %>% arrange(desc(diabetes_percent)) %>% slice(1:10)}
      
      #
      ggplot(filtered_summary, aes(x = reorder(state, diabetes_percent), y = diabetes_percent, fill = diabetes_percent)) +
        geom_col() +
        #make it a vertical graph
        coord_flip() +  
        #add colors 
        scale_fill_gradient(low = "skyblue", high = "steelblue2", name = "Prevalence (%)") +
        #add a title and state names 
        labs(title = ifelse(input$state_filter == "All", 
                            "Top 10 States with Highest Likely Diabetes Prevalence", 
                            paste("Diabetes Prevalence in", input$state_filter)),
             x = "State", y = "Prevalence (%)") +
        theme_minimal() +
        theme(legend.position = "right",
              #remove tick marks 
              axis.ticks = element_blank(),
              #remove vertical background lines 
              panel.grid.major = element_blank(),
              #remove background grid  
              panel.grid.minor = element_blank())})
    
    
    #age group risk bar plot 
    output$agePlot <- renderPlot({
      selected_age <- input$age_filter
      #create a table to summarize diabetes likelihood by age group 
      age_summary <- Diabetes_with_Type %>%
        group_by(age_group) %>%
        summarise(
          total = n(),
          likely_cases = sum(likely_diabetes, na.rm = TRUE),
          percent_diabetes = (likely_cases / total) * 100,
          .groups = "drop")
      #filter if a specific age group is selected 
      if (selected_age != "All") {
        age_summary <- age_summary %>% filter(age_group == selected_age)}
      
      #plot details 
      ggplot(age_summary, aes(x = age_group, y = percent_diabetes, fill = percent_diabetes)) +
        geom_col() +
        #add color gradient 
        scale_fill_gradient(low = "steelblue2", high = "skyblue", name = "Prevalence (%)") + 
        #add a title and axes titles
        labs(title = "Likely Diabetes by Age Group", x = "Age Group", y = "Prevalence (%)") +
        theme_minimal() + theme(
          axis.ticks = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())})
    
    #family history bar plot 
    output$familyPlot <- renderPlot({
      #summarize diabetes likelihood based on family history 
      family_history_summary <- Diabetes_with_Type %>%
        filter(!is.na(`Family History`)) %>%
        group_by(`Family History`) %>%
        summarise(
          total = n(),
          likely_cases = sum(likely_diabetes, na.rm = TRUE),
          percent_diabetes = (likely_cases / total) * 100,
          .groups = "drop")
      
      #plot details 
      ggplot(family_history_summary, aes(x = `Family History`, y = percent_diabetes, fill = percent_diabetes)) +
        geom_col() +
        #color gradient 
        scale_fill_gradient(low = "steelblue2", high = "skyblue", name = "Prevalence (%)") + 
        #add titles 
        labs(title = "Impact of Family History on Diabetes Risk",
             x = "Family History", y = "Prevalence (%)") +
        theme_minimal() +
        theme(axis.ticks = element_blank(),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank())})}
    
  
  # Run App
  shinyApp(ui = ui, server = server)
  