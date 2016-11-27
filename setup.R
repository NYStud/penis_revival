#### Setup ####
library(ggplot2)
library(dplyr)
library(tidyr)
library(tadaatoolbox)

## Get data
# devtools::install_github("tadaadata/loldata")
penis <- loldata::penis

## knitr options
knitr::opts_chunk$set(echo = F, warning = F, message = F, fig.align = "center",
                      fig.path = "plots/")
