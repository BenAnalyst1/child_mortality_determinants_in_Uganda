# 1. Project title
Determinants of Child Mortality: Evdence from the 2022 Uganda Demographic and Health Survey (DHS)

# 2. Research question
Does child, maternal, and socioeconomic factors predict child survival in Uganda?

# 4. Data source
I obtained a sample size of 1434 children from the Kid's Record file of the 2022 Uganda Demographic and Health Survey (DHS). The data was requested from and provided by the Uganda Bureau of Statistics. After obtaining the dataset, I extracted the key child, maternal, and household characteristics to analyse. These variables included: Maternal education, household wealth, birth interval, maternal age, total number of children born, water sources, place of residence, and region, among others.

## Outcome variable
- Child survival status, that is, whether a child died or not before the age of five

## Explanatory variables
- Maternal education
- Household wealth
- birth interval
- maternal age
- total number of children born
- water sources
- place of residence
- region

# 5. Methodology
First, I utilised descriptive data analysis to understand the overall nature of child mortality in Uganda. In this phase, I produced descriptive tables and figures to present the data. Secondly, I conducted a bivariate analysis to understand the relationship between child mortality and the explanatory variables. Finally, I conducted a multivariate logistic regression to examine the key determinants of child mortality, taking into account other factors. The analysis accounted for the DHS sampling design through clustering, stratification, and probability weights. Results are reported as adjusted odds ratio with 95% confidence intervals, and statistical significance was assessed at the 5% level.

The analysis was done using R and Stata. R was particularly used for data extraction, descriptive analysis, and graphical analysis. Stata on the other hand was used for data cleaning, variable construction, and survey-weighted logistic analysis.

# 6. Key finding
- The child mortality rate was 49 deaths per 1,000 live births, with more deaths experienced by poor rural chiildren than urban dwellers.

- The main determinants of mortality were total number of children and birth interval. Giving birth to an additional child increased the odds of child mortality by 24%. This effect was statistically significant at the 5% level. Likewise, a child born after a birth interval of above 48 months had a 20% lower odds of mortality compared to one born before a birth interval of 24 months. This effect was marginally significant at the 5% level.

- The finding suggests that family size and birth spacing matters a lot more than maternal education, age, location, and income levels. Thus, if Uganda is to meet the 2030 target of fewer than 25 deaths per 1,000 live births, she has to strengthen policies and interventions that encourages optimal birth spacing, smaller family size, and maternal access to family planning and healthcare, especially in rural areas.

# 7. Repository contents
- `data_extractionKR.qmd` # R data extraction script
- `data_cleaning.do` # Stata data cleaning dofile
- `data_cleaning.log` # Stata data cleaning logfile
- `descriptive_analysis.qmd` - R descriptive data analysis script
- `multivariate_analysis.do` - Stata multivariate logistic regression script
- `Report_data_analysis_and_interpretation.pdf`

# 8. Data availability
For access to the cleaned data, write to me via the email adress, bensonbinya@gmail.com

In addition, the Uganda's DHS data is available upon request, either from the Uganda Bureau of Statistics or the DHS program. This link, https://microdata.ubos.org:7070/index.php/catalog/81, takes you directly to the said data source.
