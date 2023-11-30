install.packages(c("tidyverse", "ggplot2","dplyr","readr","robustbase","reshape2","gapminder"))
install.packages("fmsb")


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
library(csodata)
library(highcharter)
library(plotly)
library(fmsb)


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
  geom_point() +
  labs(title = "Total Crimes Per Region Over Years",
       x = "Year",
       y = "Total Crimes",
       color = "Region") +
  theme_minimal() +
  theme(legend.position = "right")


# Create the scatter plot
quarter_crimes <- ireland_crime2 %>%
  group_by(Year, Quarter) %>%
  summarise(Total_Crimes = sum(Value, na.rm = TRUE))

# Create the scatter plot
ggplot(quarter_crimes, aes(x = Quarter, y = Year, fill = Total_Crimes)) +
  geom_tile() +
  scale_fill_gradient(low = "lightblue", high = "darkred") +
  labs(title = "Total Crimes Over Quarters and Years",
       x = "Quarter",
       y = "Year",
       fill = "Total Crimes") +
  theme_minimal() +
  theme(legend.position = "right")



#QUESTION E

#CRIMES PER COUNTIES AND REGION
county_crimes <- ireland_crime2 %>%
  group_by(CountyCode, County) %>%
  summarise(Total_Crimes = sum(Value, na.rm = TRUE)) %>%
  arrange(desc(Total_Crimes))

highchart() %>%
  hc_chart(type = "column") %>%
  hc_title(text = "Total Crimes by County") %>%
  hc_xAxis(categories = county_crimes$County) %>%
  hc_yAxis(title = list(text = "Total Crimes")) %>%
  hc_add_series(
    name = "Total Crimes",
    data = county_crimes$Total_Crimes,
    colorByPoint = TRUE,  # Color bars by point
    colors = viridisLite::viridis(length(unique(ireland_crime2$Region)))  # Use a color palette
  ) %>%
  hc_tooltip(pointFormat = "Total Crimes: {point.y}") %>%
  hc_plotOptions(column = list(stacking = "normal")) %>%
  hc_legend(title = list(text = "Region"), enabled = TRUE)




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


top_crimes_per_county <- ireland_crime2 %>%
  group_by(Region, Offence) %>%
  summarise(Total_Value = sum(Value, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(Region, desc(Total_Value)) %>%
  group_by(Region) %>%
  top_n(3, wt = Total_Value)

column_chart <- top_crimes_per_county %>%
  hchart("column", hcaes(x = Offence, y = Total_Value, group = Region)) %>%
  hc_title(text = "Top Crimes Per County - Column Chart") %>%
  hc_legend(layout = "vertical", align = "right", verticalAlign = "middle")

column_chart


quarter_with_max_crimes <- ireland_crime %>%
  group_by(County, Quarter) %>%
  summarise(Total_Crimes = sum(Value, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(County, desc(Total_Crimes)) %>%
  group_by(County) %>%
  slice(which.max(Total_Crimes))

ggplot(quarter_with_max_crimes, aes(x = reorder(County, Total_Crimes), y = Total_Crimes, fill = Quarter, text = paste("Crimes: ", Total_Crimes))) +
geom_col(position = "dodge", color = "black", size = 0.2) +
scale_fill_brewer(palette = "Set3") +
labs(title = "Quarter with Maximum Crimes in Each County",
     x = "County",
     y = "Total Crimes",
     fill = "Quarter") +
theme_minimal() +
theme(legend.position = "top",
      axis.text.x = element_text(angle = 45, hjust = 1),
      axis.title.y = element_text(margin = margin(r = 10)),
      plot.title = element_text(hjust = 0.5))

# Convert ggplot to plotly and display tooltip
ggplotly(tooltip = "text")

grouped_data_year <- ireland_crime2 %>%
  group_by(Year) %>%
  summarise(Total_Crimes = sum(Value))%>%
  arrange(desc(Total_Crimes))


#QUESTION F 

dummy_encoded_df <- cbind(ireland_crime2, model.matrix(~ Region + Offence - 1, data = ireland_crime2))

# View the dummy-encoded data
print(dummy_encoded_df)