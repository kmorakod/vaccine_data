##Assignment #1 for module SOCS0100 

#Setting up my directory 
setwd("~/Desktop/wd_vaccine")

#Setting up my packages

if (!require("pacman")) {
  install.packages("pacman")
}
library(pacman)
pacman::p_load(
  tidyverse, #including dplyr for processing and purrr for functions
  kableExtra, #creating tables
  flextable, #creating tables
  glue, #to combine strings and objects
  ggplot2) #dataviz

options(scipen = 999) #managing scientific notation in data

#Setting up for reproducibility

if (!require("groundhog")) { 
  install.packages("groundhog")
  library(groundhog)
}

pkgs <- c("tidyverse", "kableExtra", "flextable", "glue", "ggplot2")
groundhog.library(pkgs, "2024-10-30") #Freezing date to when I started the project

#Importing my data.csv file

who17_vaccine <- read.csv("VCDB_WHO17.csv", header = TRUE) #so R acknowledges the original column names as variable labels

#creating a statistical summary of data excluding "Year", a continuous variable
who17_vaccine %>%
  select(-"Year") %>%
  summary() 

#Pivoting longer to summarise # of observations per Variable
longer_data <- who17_vaccine %>% 
  pivot_longer(
    cols = c(-Entity, -Year), #applied to integer vectors excluding "Year", not applied to chr "Entity"
    names_to = "Variable",
    values_to = "Count",
  )

#Creating a table to inspect # of missing values per variable
missing_data <- longer_data %>%
  group_by(Variable) %>%
  summarize (
    Missing_Values = sum(is.na(Count)), #counting # of NAs per column
    Remaining_Values = sum(!is.na(Count)), #counting # of remaining values to work with
    .groups = 'drop'
    ) %>% 
  filter(Missing_Values > 0) #only when # of NAs > 0

#Data Processing and Functional Programming

#Creating a function to rename and clean variable labels
rename_variables <- function(who17_vaccine) {
  colnames(who17_vaccine) <- colnames(who17_vaccine) %>%
    str_replace_all("\\.","_") %>%                        #replacing spaces w/underscores for compatability
    str_replace_all("\\(\\)", "") %>%                     #removing brackets
    str_replace_all("WHO.2017.", "") %>%                  #removing "WHO 2017"
    str_replace_all("..MCV|..Pol3|..HepB3", "") %>%       #removing duplicate abbreviat'ns
    str_replace_all("immunization.coverage.among.1.year.olds", "immunized_1yos") %>%
    str_replace_all("deaths.due.to.tuberculosis.", "TB_deaths_") %>% 
    str_replace_all("per.100.000.population", "_per_100k") %>%
    str_replace_all("..excluding.HIV..", "_wo_HIV") %>%
    str_replace_all("Estimated", "est") %>%
    str_replace_all("Number.of.|Number.|number.of", "") #dropping Number of to become "confirmed cases.."
    
  return(who17_vaccine)
}

#Applying the function to my dataset
renamed_data <- rename_variables(who17_vaccine)

#Cleaning up country variables

regions_toremove <- c(
  "Africa", "Americas", "Dominica",
  "Eastern Mediterranean", "Europe",
  "South-East Asia", "Western Pacific", "World"
)

country_cleaning <- function(who17_vaccine) {
  who17_vaccine %>%
    filter(!Entity %in% regions_toremove) %>%
    mutate(Entity = str_remove(Entity, "(country)"))
}

cleaned_data <- country_cleaning(renamed_data)




  
  


  