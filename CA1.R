install.packages(c("tidyverse", "ggplot2","dplyr","readr","robustbase","reshape2","gapminder"))
install.packages("leaflet")

library(readr)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(robustbase)
library(reshape2)
library(gapminder)
library(sf)
library(tmap)
library(leaflet)


ireland_crime <- read.csv("crime_ireland.csv")


ireland_crime2 <- ireland_crime[!(ireland_crime$Value == 0), ]
rownames(ireland_crime2) <- NULL


# QUESTION A 
# Function to identify variable types and create a plot
identify_variable_types <- function(data) {
  variable_types <- sapply(data, function(x) {
    if (is.factor(x) || is.character(x)) {
      "Categorical"
    } else if (is.numeric(x)) {
      if (length(unique(x)) > 20) {
        "Continuous"
      } else {
        "Discrete"
      }
    } else {
      "Other"
    }
  })
  
  data_long <- gather(data.frame(variable = names(variable_types), type = variable_types), key = "variable", value = "type")
  
  ggplot(data_long, aes(x = variable, fill = type)) +
    geom_bar(stat = "count", position = "dodge") +
    labs(title = "Variable Types",
         x = "Columns Names",
         y = " ",
         fill = "Variable Type") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

# Apply the function to the dataset
identify_variable_types(ireland_crime2)

# QUESTION B
distance_summary_by_year <- ireland_crime2 %>% 
  group_by(Year) %>%
  summarize(
    min = min(Value, na.rm = TRUE),
    q1 = quantile(Value, 0.25, na.rm = TRUE),
    median = quantile(Value, 0.5, na.rm = TRUE),
    q3 = quantile(Value, 0.75, na.rm = TRUE),
    max = max(Value, na.rm = TRUE),
    mean = mean(Value, na.rm = TRUE),
    sd = sd(Value, na.rm = TRUE),
    missing = sum(is.na(Value))
  )

View(distance_summary_by_year)


#QUESTION C

#Z_Score
ireland_crime2 %>%
  select(Value) %>%
  mutate(Value_z = (Value - mean(Value)) / sd(Value)) %>%
  summary()

#MIN-MAX
ireland_crime2 %>%
  select(Value) %>%
  mutate(Value_minMax =
           ((Value - min(Value))
            / (max(Value) - min(Value))) * (1 - 0) + 0) %>% 
  summary()

#Robust Scale



#QUESTION D








group_data <- ireland_crime2 %>%
  group_by(Year, Region) %>%
  summarise(Total_Crimes = sum(Value, na.rm = TRUE))

# Create the line plot
ggplot(group_data, aes(x = Year, y = Total_Crimes, group = Region, color = Region)) +
  geom_line() +
  labs(title = "Total Crimes Per Region Over Years",
       x = "Year",
       y = "Total Crimes",
       color = "Region") +
  theme_minimal() +
  theme(legend.position = "right") 


# Create the scatter plot
scatter_plot_custom <- ireland_crime2 %>%
  group_by(Quarter, Year) %>%
  summarise(Total_Crimes = sum(Value, na.rm = TRUE))

# Create the scatter plot
ggplot(ireland_crime2, aes(x = Year, y = Value, color = Quarter)) +
  geom_jitter(width = 0.2, height= 0, alpha=0.7) +
  labs(title = "Scatterplot of Total Crimes Per Region Over Years",
       x = "Year",
       y = "Crimes",
       color = "Quarter") +
  theme_minimal() +
  theme(legend.position = "right")  # Adjust legend position if needed

#QUESTION E

county_crimes <- ireland_crime2 %>%
  group_by(CountyCode, County) %>%
  summarise(Total_Crimes = sum(Value, na.rm = TRUE)) %>%
  arrange(desc(Total_Crimes))


ggplot(county_crimes, aes(x = County, y = Total_Crimes, fill = CountyCode)) +
  geom_bar(stat = "summary", fun = "mean", position = "dodge") +
  labs(title = "Average Numeric Variable by Category",
       x = "Categorical Variable",
       y = "Average Numeric Variable")+
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


region_colors <- c("DUBLIN METROPOLITAN REGION" = "red", 
                   "EASTERN REGION" = "blue", 
                   "NORTHERN REGION" = "green",
                   "SOUTH EASTERN REGION" = "orange", 
                   "WESTERN REGION" = "purple",
                   "SOUTHERN REGION" = "yellow")

ggplot(ireland_crime2, aes(Year, Value, size = Value, colour = Region)) +
  geom_point(alpha = 0.2, show.legend = FALSE) +
  scale_colour_manual(values = region_colors) +
  scale_size(range = c(2, 5)) +
  facet_wrap(~Region) +
  labs(title = 'Year: 2003-2022', x = 'Year', y = 'Crimes')



region_sum <- ireland_crime2 %>%
  group_by(Region) %>%
  summarize(Value = sum(Value, na.rm = TRUE))


# Assuming you have a dataset named 'crime_data'
# You can replace this with your actual dataset

# Example dataset
crime_data <- data.frame(
  Region = c("East", "South", "West", "Midwest", "Southwest"),
  County = c("Dublin", "Cork", "Galway", "Limerick", "Kerry"),
  Year = rep(2003:2022, each = 5),
  Quarter = rep(rep(1:4, each = 5), times = 20),
  Value = sample(50:200, 100, replace = TRUE) * 10
)



grouped_data_year <- ireland_crime2 %>%
  group_by(Year) %>%
  summarise(Total_Crimes = sum(Value))%>%
  arrange(desc(Total_Crimes))


