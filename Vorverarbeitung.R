# Datenvorvergarbeitung ALLBUS 2021


# Libraries laden
library(dplyr)
library(tibble)
library(haven)
library(readr)
library(labelled)
library(naniar)


# Daten einlesen und NAs korrigieren 
daten <- read_dta("Datensatz/Allbus_2021.dta")


# Name und Beschreibungen von Variablen extrahieren
variablen <- daten %>% 
  look_for() %>% 
  select(pos, variable, label, value_labels)

# inkl. antwortoptionen
variablen_optionen <- daten %>% 
  look_for() %>% 
  lookfor_to_long_format() %>% 
  select(pos, variable, label, value_labels)

# Liste speichern
write_excel_csv2(variablen, file = "Datensatz/ALLBUS_2021_variablen.csv")
write_excel_csv2(variablen_optionen, file = "Datensatz/ALLBUS_2021_variablen_optionen.csv")


# Subsamples erstellen 

# Wenige Fälle, wenige Variablen
sample_klein <- daten %>% 
  select(age, sex, educ, lm01) %>% 
  slice_sample(n = 20) %>% 
  rename(alter = age,
         geschlecht = sex,
         bildung = educ,
         fernsehkonsum = lm01) %>% 
  replace_with_na_all(condition = ~.x < 0) %>% 
  mutate(geschlecht = as_factor(geschlecht),
         bildung = as_factor(bildung),
         fernsehkonsum = round(fernsehkonsum)) %>% 
  remove_labels() %>%
  remove_attributes("format.stata")

# Mehr Fälle, wenige Variablen
sample_mittel <- daten %>% 
  select(age, sex, educ, lm01, cf03, pv01) %>% 
  slice_sample(n = 200) %>% 
  rename(alter = age,
         geschlecht = sex,
         fernsehkonsum = lm01,
         kriminalitaet = cf03,
         wahlabsicht_partei = pv01) %>% 
  replace_with_na_all(condition = ~.x < 0) %>% 
  mutate(across(c(geschlecht, kriminalitaet, wahlabsicht_partei), as_factor),
         fernsehkonsum = round(fernsehkonsum)) %>% 
  remove_labels() %>%
  remove_attributes("format.stata")

# Mehr Fälle, viele Variablen
sample_gross <- daten %>% 
  select(age, sex, lm01, pa02a, pa01, pv01, ps03, cf03, lm35:lm39, st01:pt20) %>% 
  slice_sample(n = 500) %>% 
  rename(alter = age,
         geschlecht = sex,
         fernsehkonsum = lm01,
         politisches_interesse = pa02a,
         links_rechts_einordnung = pa01, 
         wahlabsicht_partei = pv01,
         zufriedenheit_demokratie = ps03,
         entwicklung_kriminalitaet = cf03,
         social_media_nachrichtenquelle = lm35,
         glaubwuerdigkeit_oer_tv = lm36,
         glaubwuerdigkeit_privat_tv = lm37,
         glaubwuerdigkeit_zeitungen = lm38,
         glaubwuerdigkeit_social_media = lm39,
         vertrauen_mitmenschen = st01,
         vertrauen_gesundheitswesen = pt01,
         vertrauen_bundesverfassungsgericht = pt02,
         vertrauen_bundestag = pt03,
         vertrauen_stadt_gemeindeverwaltung = pt04,
         vertrauen_katholische_kirche = pt06,
         vertrauen_evangelische_kirche = pt07,
         vertrauen_justiz = pt08,
         vertrauen_fernsehen = pt09,
         vertrauen_zeitungswesen = pt10,
         vertrauen_hochschulen = pt11,
         vertrauen_bundesregierung = pt12,
         vertrauen_polizei = pt14,
         vertrauen_parteien = pt15,
         vertrauen_eu_kommission = pt19,
         vertrauen_eu_parlament = pt20) %>% 
  replace_with_na_all(condition = ~.x < 0) %>% 
  mutate(across(c(geschlecht, politisches_interesse, wahlabsicht_partei, zufriedenheit_demokratie, 
                  entwicklung_kriminalitaet, glaubwuerdigkeit_oer_tv, glaubwuerdigkeit_privat_tv, 
                  glaubwuerdigkeit_zeitungen, glaubwuerdigkeit_social_media), as_factor),
         fernsehkonsum = round(fernsehkonsum),
         social_media_nachrichtenquelle = round(social_media_nachrichtenquelle)) %>% 
  remove_labels() %>%
  remove_attributes("format.stata")


# Samples speichern
write_rds(sample_klein, file = "Datensatz/ALLBUS_sample_klein.rds")
write_excel_csv2(sample_klein, file = "Datensatz/ALLBUS_sample_klein.csv")
write_rds(sample_mittel, file = "Datensatz/ALLBUS_sample_mittel.rds")
write_rds(sample_gross, file = "Datensatz/ALLBUS_sample_gross.rds")


