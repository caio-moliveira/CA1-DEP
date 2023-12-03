install.packages(c("tidyverse", "ggplot2","dplyr","readr","robustbase","highcharter","reshape2","fastDummies","scales"))

library(readr)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(robustbase)
library(tidyr)
library(highcharter)
library(fastDummies)
library(scales)
library(reshape2)



# Read file
ireland_crime <- read.csv("crime_ireland.csv")
# Filter out rows with 'Value'= 0
ireland_crime2 <- ireland_crime[!(ireland_crime$Value == 0), ]
# Reset row names in ireland_crime2 to start from 1.
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

# Calculate summary statistics for 'Value' grouped by 'Year' in ireland_crime2.
distance_summary_by_year <- ireland_crime2 %>% 
  group_by(Year) %>%
  summarize(
    min = min(Value, na.rm = TRUE),           # Minimum value
    q1 = quantile(Value, 0.25, na.rm = TRUE), # First quartile
    median = quantile(Value, 0.5, na.rm = TRUE), # Median
    q3 = quantile(Value, 0.75, na.rm = TRUE), # Third quartile
    max = max(Value, na.rm = TRUE),           # Maximum value
    mean = mean(Value, na.rm = TRUE),         # Mean
    sd = sd(Value, na.rm = TRUE),             # Standard deviation
    missing = sum(is.na(Value))               # Count of missing values
  )

# Display the resulting summary dataframe using the View() function.
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

ireland_crime2 %>%
  select(Value) %>%
  mutate(Value_z = scale(Value)) %>%
  summary()

#QUESTION D



# Group by 'Year' and 'Region', then calculate the sum of 'Value' for each group.
group_data <- ireland_crime2 %>%
  group_by(Year, Region) %>%
  summarise(Total_Crimes = sum(Value, na.rm = TRUE))


# Create the line plot using group_data dataset.
ggplot(group_data, aes(x = Year, y = Total_Crimes, group = Region, color = Region)) +
  geom_line() +
  geom_point() +
  labs(title = "Ireland Total Crimes Per Region Over Years",
       x = "Year",
       y = "Total Crimes",
       color = "Region") +
  theme_minimal() +
  theme(legend.position = "right")


# Group by 'Year' and 'Quarter', then calculate the sum of 'Value' for each group.
quarter_crimes <- ireland_crime2 %>%
  group_by(Year, Quarter) %>%
  summarise(Total_Crimes = sum(Value, na.rm = TRUE))


# Create the scatter plot using quarter_crimes dataset.
ggplot(quarter_crimes, aes(x = Quarter, y = Year, fill = Total_Crimes)) +
  geom_tile() +
  scale_fill_gradient(low = "lightblue", high = "darkred") +
  labs(title = "Ireland Total Crimes Over Quarters and Years",
       x = "Quarter",
       y = "Year",
       fill = "Total Crimes") +
  theme_minimal() +
  theme(legend.position = "right")


#QUESTION E

# Group by 'Region' and 'County', then calculate the sum of 'Value' for each group.
# Arrange the results in descending order.
county_crimes <- ireland_crime2 %>%
  group_by(Region, County) %>%
  summarise(Total_Crimes = sum(Value, na.rm = TRUE)) %>%
  arrange(desc(Total_Crimes))


#Create a grouped bar plot using ggplot for the county_crimes dataset.
ggplot(county_crimes, aes(x = Total_Crimes, y = reorder(County, Total_Crimes), fill = Region)) +
  geom_col() +
  labs(title = "Total Crimes in Ireland by County",
       x = "Total Crimes",
       y = "County",
       fill = "Region") +
  scale_x_continuous(labels = scales::comma) +
  theme_minimal() +
  theme(legend.position = "top",
        axis.text.y = element_text(hjust = 0),
        axis.title.x = element_text(margin = margin(b = 10)),
        plot.title = element_text(hjust = 0.5))



# Group 'County' and 'Offence', then calculate the sum of 'Value' for each group.
# Arrange the results by 'County' and 'Total_Value' in descending order.
# Retain the top 3 offences for each county.
top_crimes_per_county <- ireland_crime2 %>%
  group_by(County, Offence) %>%
  summarise(Total_Value = sum(Value, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(County, desc(Total_Value)) %>%
  group_by(County) %>%
  top_n(3, wt = Total_Value)

#Create a highchart column chart using the top_crimes_per_county dataset.
column_chart <- top_crimes_per_county %>%
  hchart("column", hcaes(x = Offence, y = Total_Value, group = County)) %>%
  hc_title(text = "Top 3 Crimes Per County in Ireland (2003-2022)") %>%
  hc_legend(layout = "vertical", align = "right", verticalAlign = "middle")

column_chart


# Group 'Region' and 'Offence', then calculate the sum of 'Value' for each group.
# Arrange the results by 'Region' and 'Total_Value' in descending order.
# Retain the top 3 offences for each Region.
top_crimes_per_region <- ireland_crime2 %>%
  group_by(Region, Offence) %>%
  summarise(Total_Value = sum(Value, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(Region, desc(Total_Value)) %>%
  group_by(Region) %>%
  top_n(3, wt = Total_Value)

#Create a highchart column chart using the top_crimes_per_region dataset.
column_chart2 <- top_crimes_per_region %>%
  hchart("column", hcaes(x = Offence, y = Total_Value, group = Region)) %>%
  hc_title(text = "Top 3 Crimes Per County in Ireland (2003-2022)") %>%
  hc_legend(layout = "vertical", align = "right", verticalAlign = "middle")

column_chart2


# Group by 'County' and 'Quarter', then calculate the sum of 'Value' for each group.
# Arrange the results by 'County' and 'Total_Crimes' in descending order.
# Retain the row with the maximum total crimes for each county.
quarter_with_max_crimes <- ireland_crime %>%
  group_by(County, Quarter) %>%
  summarise(Total_Crimes = sum(Value, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(County, desc(Total_Crimes)) %>%
  group_by(County) %>%
  slice(which.max(Total_Crimes))

# Create a grouped bar plot using ggplot for the quarter_with_max_crimes dataset.
ggplot(quarter_with_max_crimes, aes(x = County, y = Total_Crimes, fill = Quarter, text = paste("Crimes: ", Total_Crimes))) +
  geom_bar(stat = "identity", position = "stack", color = "black", linewidth = 0.2) +
  scale_fill_brewer(palette = "Set3") +
  labs(title = "Most Violent Quarters of Each County in Ireland (2003-2022)",
       x = "County",
       y = "Total Crimes",
       fill = "Quarter") +
  theme_minimal() +
  theme(legend.position = "top",
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title.y = element_text(margin = margin(r = 10)),
        plot.title = element_text(hjust = 0.5))




# Group by 'Year', then calculate the sum of 'Value' for each year.
# Arrange the results in descending order.
grouped_data_year <- ireland_crime2 %>%
  group_by(Year) %>%
  summarise(Total_Crimes = sum(Value)) %>%
  arrange(desc(Total_Crimes))

# Create a line plot using ggplot for the grouped_data_year dataset.
ggplot(grouped_data_year, aes(x = Year, y = Total_Crimes, group = 1)) +
  geom_line(color = "blue") +
  geom_point(color = "red") +
  labs(title = "Total Crimes per Year",
       x = "Year",
       y = "Total Crimes") +
  scale_y_continuous(labels = comma) +
  theme_minimal()




#QUESTION F 

# Create dummy variables for 'Region' and 'Quarter'.
ireland_crime3 <- dummy_cols(ireland_crime2, select_columns = c('Region', 'Quarter'),
                             remove_selected_columns = TRUE)

# Calculate the correlation matrix for numeric columns.
correlation_matrix <- cor(ireland_crime3[, sapply(ireland_crime3, is.numeric)])

# Create a heatmap using ggplot for the correlation_matrix.
ggplot(data = melt(correlation_matrix), aes(x = Var1, y = Var2, fill = value)) +
  
  geom_tile() +
  scale_fill_gradient2(
    low = "blue", high = "red", mid = "white", midpoint = 0, limit = c(-1,1),
    space = "Lab", name = "Correlation"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#QUESTION G 

# Extract numerical and categorical data from ireland_crime3.
numerical_data <- ireland_crime3[, sapply(ireland_crime3, is.numeric)]
categorical_data <- ireland_crime3[, sapply(ireland_crime3, is.factor)]

# Perform Principal Component Analysis (PCA) on the numerical data.
pca_result <- prcomp(numerical_data[, c(2:14)], scale. = TRUE, center = TRUE)


# Extract loadings
loadings <- pca_result$rotation

# Summary of PCA result
summary(pca_result)

