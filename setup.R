#### Setup ####
library(ggplot2)
library(dplyr)
library(tidyr)
library(broom)
library(magrittr)
library(DT)
library(plotly)
library(tadaatoolbox)

## Get data
# devtools::install_github("tadaadata/loldata")
penis <- loldata::penis

