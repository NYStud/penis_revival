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

penis_long <-
  penis %>%
  select(-circumf_erect_in, -length_erect_in) %>%
  gather(state_l, length,  length_flaccid, length_erect) %>%
  gather(state_v, volume,  volume_flaccid, volume_erect) %>%
  gather(state_c, circumf, circumf_flaccid, circumf_erect) %>%
  gather(state_rel, state, starts_with("state_")) %>%
  mutate(state = ifelse(grepl(x = state, pattern = "erect"), "Erect", "Flaccid"),
         state = factor(state, levels = c("Flaccid", "Erect"), ordered = T)) %>%
  select(-state_rel)
