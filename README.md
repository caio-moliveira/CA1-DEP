# CA1 - Data Exploration and Preparation
 









## SUBJECT: DATA EXPLORATION & PREPARATION



### LECTURER:  Dr. Muhammad Iqbal






#### Caio Machado de Oliveira
#### ID: 2020351



























 
## INTRODUCTION

In this assignment, I explored a Crime dataset covering incidents reported across Ireland from 2003 to 2022. To tailor the dataset to our needs, I merged two Kaggle datasets (https://www.kaggle.com/datasets/zazaucd/recorded-crime-in-ireland) and (https://www.kaggle.com/datasets/sameerkulkarni91/crime-in-ireland) — one being a transposed version of the other. Using Excel, I performed merging and joining operations, resulting in a dataset with 157,000 rows and 11 columns.
The dataset presented a challenge as it primarily consisted of two numerical variables: "Year" and "Value," representing the number of crimes committed. All analyses were based on these numerical values, providing valuable insights into the safety landscape of different areas and illustrating how crime has changed in Ireland since 2003.
This exploration not only facilitated the application of skills learned in class but also offered powerful insights into the dataset, showcasing the evolving nature of crime in Ireland.








### QUESTIONS

#### Question A
Identify which variables are categorical, discrete and continuous in the chosen data set and show using some visualization or plot. Explore whether there are missing values for any of the variables.
 

![image](https://github.com/caio-moliveira/CA1-DEP/assets/150807759/b6b066a4-bdbd-4371-94e2-8751679ed329)





#### Question B
Calculate the statistical parameters (mean, median, minimum, maximum, and standard deviation) for each of the numerical variables.

As was mentioned before, the dataset chosen contain ‘Id’, ‘Year’, ‘OffenceCode’ and ‘Value’ as numerical variables. Only the variable ‘Value’ it is possible to be used to perform any analyse. I decided apply the calculation of statistical parameters by ‘Year’ to show a more insightful view of the dataset.
 


![image](https://github.com/caio-moliveira/CA1-DEP/assets/150807759/3d218bd0-e23a-4954-ba60-a60e2e92f2be)




#### Question C 
Apply Min-Max Normalization, Z-score Standardization and Robust scalar on the numerical data variables.

Min-Max Normalization

![image](https://github.com/caio-moliveira/CA1-DEP/assets/150807759/f8ea480e-1384-45f7-8a58-618669149704)

 
Z-Score Standarization
 

![image](https://github.com/caio-moliveira/CA1-DEP/assets/150807759/019e68cb-4b19-404b-aea2-d55b6564e269)



#### Question D
Line, Scatter and Heatmaps can be used to show the correlation between the features of the dataset.

A correlation heatmap is a plot displaying the correlation coefficients between variables in a data frame. It helps explore the relationships between variables, identify potential patterns, and find outliers. 

Using heatmap it is possible to see the correlation between the Quarters along the Years. It shows clearly that the number of crime has dropped considerably after 2010. 

![image](https://github.com/caio-moliveira/CA1-DEP/assets/150807759/9f3ff49b-95c6-4b45-9a22-e70fdc378cf1)


 
Plotting two variables on a graph and tracking how changes in one correlate to changes in the other over time is how correlation is shown using a line plot. When attempting to see correlations, trends, and patterns between two continuous data, line graphs are very helpful.

Using lines now, it proves that the heatmap correlation before was right about how crimes have dropped. 

![image](https://github.com/caio-moliveira/CA1-DEP/assets/150807759/99a3d8be-9ef8-4656-8705-19773ae93520)

 

#### Question E 
Graphics and descriptive understanding should be provided along with Data Exploratory analysis (EDA). Identify subgroups of features that can explore some interesting facts.

Using the material given in class and implementing skills gained doing some courses and researches I decided to explore the analytical side of the dataset using different libraries and approaches.  

![image](https://github.com/caio-moliveira/CA1-DEP/assets/150807759/22e5be2f-f1b3-4f16-a622-9863c0815b99)

 
The analyse above is to show the total amount of crime per county in Ireland. Using colour to quick identify from which region each county is. This show that the crimes in Dublin Metropolitan Region are the highest in the country.

![image](https://github.com/caio-moliveira/CA1-DEP/assets/150807759/52c136de-53fc-42f3-95e3-d71e3abb3aa3)

 
A simple but insightful viewing of how crimes in general have dropped since 2008, which was the year with most crimes committed.

![image](https://github.com/caio-moliveira/CA1-DEP/assets/150807759/c82a5d00-844b-42cb-b1fb-705fb44d82b3)

 
Using the variable “Quarter”, where Q1 = January until March; Q2 = April until June; Q3 = July until September; Q4 = October until Dezember. it is possible to group the amount of crime committer on each quarter of the year. When comparing each County in Ireland, it shows the most violent quarters of they year, which it is massive during Summer (Q3). The fun fact is that, during Winter the crimes are lower than the other part of the year, maybe is the spirit of Christmas.

The next two plots were made upon a library called ‘highcharter’.

Highcharter is a R wrapper for Highcharts javascript library and its modules. Highcharts is very flexible and customizable javascript charting library and it has a great and powerful API.

A interesting variable in this dataset is the type of crimes committed (Offence). Exploring the most 3 committed crimes in each county and following the same approach in the next plot by Region.

![image](https://github.com/caio-moliveira/CA1-DEP/assets/150807759/d6c4d1de-9d5b-4a91-ad1e-945d7a2796f7)

![image](https://github.com/caio-moliveira/CA1-DEP/assets/150807759/fc6fcc5d-7d06-4472-97ce-0f4916a46054)



 
 




















#### Question F
Apply dummy encoding to categorical variables (at least one variable used from the data set) and discuss the benefits of dummy encoding to understand the categorical data.

Dummy encoding generates individual columns for each unique value in a categorical column, using the value itself as the column name. By default, it assigns the first value in the column as the regression constant for training. 

The predicted score will be the average of this element when all other values are zero.
 

![image](https://github.com/caio-moliveira/CA1-DEP/assets/150807759/5ade4304-ef05-4bfa-af33-6fd70fc6105e)













#### Question G
Apply PCA with your chosen number of components. Write up a short profile of the first few components extracted based on your understanding.

![image](https://github.com/caio-moliveira/CA1-DEP/assets/150807759/ad7d39e9-2480-4b2a-ad6f-4a7646bf1e36)

 
A statistical method called principal component analysis (PCA) it is used to decrease a dataset's dimensionality while preserving the majority of its original variability. This is achieved by converting the data into a new coordinate system in such a way that the first coordinate (also known as the first principle component) has the largest variation, the second coordinate has the second greatest variance, and so on.

Frequently, there is too much information in the input data, much of which may be eliminated without changing the essential information. When creating new variables that are linear combinations of the original variables, PCA is frequently used.

The standard deviation, variance percentage, and cumulative proportion of these components are used to interpret them. The most important patterns in the data are usually represented by PC1, which is followed by PC2 and so on. How much of the overall variation can be explained by a mixture of the components that have been discovered may be determined using the cumulative percentage.

 In certain instances, it is important to consider that the later principal components may have insignificant variability and provide minimal contribution to the overall comprehension of the data. In this particular scenario, for instance, PC12 and PC13 exhibit drastically small standard deviations and proportion of variance, indicating that they might not contain valuable information and could be disregarded in subsequent analysis.  









#### Question H
What is the purpose of dimensionality reduction? Explore the situations where you can gain the benefit of dimensionality reduction for data analysis.

In question G, It was explored using the most famous method used for dimensions reductions: Principal components Analysis (aka PCA). 

Reducing dimensions is commonly regarded as a practical approach to decrease the number of characteristics in a vast dataset while retaining its importance or variability. If your measurement system is not balanced, Principal Components can help make the inputs given to the model more rationalized. The immediate advantage is a decrease in the computational resources and time required for modeling. There are few principles:

1)	The more features the dataset has, the more complex the model will be… leading to higher computation time, power, and storage needed. 
2)	By trying to embrace the whole complexity of the dataset, the model will be more likely to overfit on the training examples. 
3)	It will be harder to get representatives samples, well-distributed within the whole “universe” of possibilities as the number of features increases.

PCA brings prevention from creating models that doesn’t match physical constraints. To illustrate, let's suppose that the moisture content of an item and the temperature of the heating process have an inverse relationship. The two original characteristics will be arranged and contrasted in a similar direction, ensuring that when learning from this reduced dimension, your model will not deduce a scenario where both original features simultaneously increase or decrease.











## REFERENCES
- Analysis, D. (2023). Principal Component Analysis (PCA) in R. [online] Medium. Available at: https://medium.com/@data03/principal-component-analysis-pca-in-r-f380dd95af5d [Accessed 3 Dec. 2023].

- Analysis, D. (2023). How to create a correlation heatmap in R [Update 2023]. [online] Medium. Available at: https://medium.com/@data03/how-to-create-a-correlation-heatmap-in-r-update-2023-3e6f1b3c7b9 [Accessed 3 Dec. 2023].
- Bescond, P.-L. (2021). Principal Components Analysis (PCA), Fundamentals, Benefits & Insights for Industry. [online] Medium. Available at: https://medium.com/towards-data-science/principal-components-analysis-pca-fundamentals-benefits-insights-for-industry-2f03ad18c4d7 [Accessed 3 Dec. 2023].
- Datacadamia - Data and Co. (2013). Statistics - Dummy (Coding|Variable) - One-hot-encoding (OHE). [online] Available at: https://datacadamia.com/data_mining/dummy [Accessed 3 Dec. 2023].
- Goraya, Z. (2023). Data Analysis. [online] Data Analysis. Available at: https://www.data03.online/2023/09/how-to-create-a-correlation-heatmap-in-r.html [Accessed 3 Dec. 2023].
- Highcharts Blog | Highcharts. (n.d.). Highcharts for R users. [online] Available at: https://www.highcharts.com/blog/tutorials/highcharts-for-r-users/ [Accessed 3 Dec. 2023].
- jkunst.com. (n.d.). A Wrapper for the Highcharts Library. [online] Available at: https://jkunst.com/highcharter/ [Accessed 3 Dec. 2023].
- Mahadik, M. (2020). Exploring Highcharts in R. [online] Medium. Available at: https://medium.com/towards-data-science/exploring-highcharts-in-r-f754143efda7 [Accessed 3 Dec. 2023].
- Sharma, M. (2019). Representing Categorical data in Machine Learning. [online] Medium. Available at: https://medium.com/@mathanrajsharma/representing-categorical-data-in-machine-learning-6518c223c615 [Accessed 3 Dec. 2023].
- Yang, S. (2021). Dimension reduction using PCA in R. [online] Medium. Available at: https://medium.com/@syang76/dimension-reduction-using-pca-in-r-c5fdaa7bd81d [Accessed 3 Dec. 2023].






















