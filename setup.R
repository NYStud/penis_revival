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
penis <- loldata::penis %>%
  mutate(growth_length  = length_erect / length_flaccid,
         growth_circumf = circumf_erect / circumf_flaccid,
         growth_volume  = volume_erect / volume_flaccid)

# Long format
penis_long <-
  penis %>%
  select(-circumf_erect_in, -length_erect_in) %>%
  {

  d1 <- gather(., state, length,  length_flaccid, length_erect) %>%
          mutate(state = ifelse(grepl(x = state, pattern = "erect"), "Erect", "Flaccid"),
                 state = factor(state, levels = c("Flaccid", "Erect"), ordered = T)) %>%
          select(-circumf_flaccid, -circumf_erect,
                 -volume_flaccid, -volume_erect)
  d2 <- gather(., state, volume,  volume_flaccid, volume_erect) %>%
          mutate(state = ifelse(grepl(x = state, pattern = "erect"), "Erect", "Flaccid"),
                 state = factor(state, levels = c("Flaccid", "Erect"), ordered = T)) %>%
         select(-length_flaccid, -length_erect,
                -circumf_flaccid, -circumf_erect)
  d3 <- gather(., state, circumf, circumf_flaccid, circumf_erect) %>%
          mutate(state = ifelse(grepl(x = state, pattern = "erect"), "Erect", "Flaccid"),
                 state = factor(state, levels = c("Flaccid", "Erect"), ordered = T)) %>%
          select(-length_flaccid, -length_erect,
                 -volume_flaccid, -volume_erect)

  full_join(d1,
            full_join(d2, d3,
                      by = c("Country", "Region", "Method", "N", "Source", "state")),
            by = c("Country", "Region", "Method", "N", "Source", "state"))
  }

## knitr options
knitr::opts_chunk$set(echo = T, warning = F, message = F, fig.align = "center",
                      fig.path = "assets/plots/")
## ggplot theme
theme_set(theme_readthedown(bg = "#FFFFFF") + theme(plot.caption = element_text(hjust = 0)))

## Plotting helpers
plot_caption <- "http://public.tadaa-data.de/penis_revival"

label_in <- function(x) {paste0(x, "\"")}
label_cm <- function(x) {paste0(x, "cm")}
