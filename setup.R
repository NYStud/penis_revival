#### Setup ####
library(ggplot2)
library(dplyr)
library(tidyr)
library(broom)
library(magrittr)
library(DT)
library(plotly)
library(tadaatoolbox)
library(highcharter)
library(viridisLite)

## Get data
# devtools::install_github("tadaadata/loldata")
penis <- loldata::penis %>%
  select(-circumf_erect_in, -length_erect_in) %>%
  mutate(growth_length  = length_erect / length_flaccid,
         growth_circumf = circumf_erect / circumf_flaccid,
         growth_volume  = volume_erect / volume_flaccid)

# rename Countries
penis$Country <- recode(penis$Country,
                        "Hong Kong"       = "Hong Kong SAR, China",
                        "Korea, South"    = "Korea, Rep.",
                        "Luxemburg"       = "Luxembourg",
                        "Macedonia"       = "Macedonia, FYR",
                        "Myanmar (Burma)" = "Myanmar",
                        "Nigerian"        = "Nigeria",
                        "Phillippines"    = "Philippines",
                        "Russia"          = "Russian Federation",
                        "Siria"           = "Syria",
                        "Slovakia"        = "Slovak Republic",
                        "Sri lanka"       = "Sri Lanka",
                        "UAE"             = "United Arab Emirates",
                        "United States of America" = "United States",
                        "Venezuela"       = "Venezuela, RB",
                        "Yemen"           = "Yemen, Rep.")

# Long format
penis_long <- loldata::penis %>%
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

# ISO3 Codes for countries
data("GNI2014", package = "treemap")

no.avail <- penis %>% filter(!(Country %in% GNI2014$country)) %>% select(Country)
avail    <- GNI2014 %>% filter(country %in% penis$Country) %>% select(country, iso3)

no.avail <- no.avail %>%
  mutate(iso3 = recode(Country,
                       "Angola"        = "AGO",
                       "Bahrein"       = "BHR",
                       "Cape Verde"    = "CPV",
                       "Central African Rep." = "CAF",
                       "Cuba"          = "CUB",
                       "DR Congo"      = "COD",
                       "Egypt"         = "EGY",
                       "Eritrea"       = "ERI",
                       "Estonia"       = "EST",
                       "Gambia"        = "GMB",
                       "Greenland"     = "GRL",
                       "Iran"          = "IRN",
                       "Korea, North"  = "PRK",
                       "Laos"          = "LAO",
                       "New Caledonia" = "NCL",
                       "Palestine"     = "PSE",
                       "Syria"         = "SYR",
                       "Taiwan"        = "TWN"))

names(avail) <- names(no.avail)
all <- rbind(avail, no.avail) %>% arrange(Country)

map <- penis %>%
  mutate(iso3 = all$iso3) %>%
  filter(!(Country %in% c("Buzzfeed Motion Pictures", "Congo-Brazzaville",
                         "Hawaii", "Scotland", "Tibet")))

rm(all, avail, no.avail, GNI2014)

## knitr options
knitr::opts_chunk$set(echo = T, warning = F, message = F, fig.align = "center",
                      fig.path = "assets/plots/")
## ggplot theme
theme_set(theme_readthedown(bg = "#FFFFFF") + theme(plot.caption = element_text(hjust = 0)))

## Plotting helpers
plot_caption <- "https://public.tadaa-data.de/penis_revival"

label_in <- function(x) {paste0(x, "\"")}
label_cm <- function(x) {paste0(x, "cm")}
