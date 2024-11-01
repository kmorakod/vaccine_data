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

#Data Processing and Functional Programming (25 points)

#Importing my data.csv file

who17_vaccine <- read.csv("VCDB_WHO17.csv", header = TRUE) #so R acknowledges the original column names as variable labels

