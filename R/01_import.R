# R/01_import.R
#Libraries
library(tidyverse)
library(here)

churn_raw <- read.csv(here('data', 'churn_raw.csv'))

dim(churn_raw)
names(churn_raw)

sapply(churn_raw, class)
colSums(is.na(churn_raw))
sapply(churn_raw, n_distinct)

churn_raw %>% filter(is.na(TotalCharges))
