install.packages(c("tidyverse", "ggplot2","dplyr","readr"))

library(readr)
library(tidyverse)
library(ggplot2)
library(dplyr)



ireland_crime <- read.csv("crime_ireland.csv") 


missing_count <- colSums(is.na(ireland_crime))

ireland_crime2 <- ireland_crime[!(ireland_crime$Value == 0), ]
rownames(ireland_crime2) <- NULL


grouped_data_county <- ireland_crime2 %>%
  group_by(County) %>%
  summarise(Total_Crimes = sum(Value))%>%
  arrange(desc(Total_Crimes))


grouped_data_year <- ireland_crime2 %>%
  group_by(Year) %>%
  summarise(Total_Crimes = sum(Value))%>%
  arrange(desc(Total_Crimes))