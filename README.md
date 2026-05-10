# 1. Project title
- Determinants of Child Mortality in Uganda

# 2. Research question
- What factors determines under-five child mortality in Uganda?

# 3. Research objective
- The analyses investigates the socioeconomic, demographic, and environmental determinants of child mortality in Uganda.

# 4. Data source
- Uganda 2022 Demographic and Health Survey (DHS). I requested and downloaded the Kid's Recode (KR) version from Uganda Bureau of Statistics. Then, I extracted the key variables (using R), cleaned, and constructed variables (using Stata).
  
## Key variables 
- Maternal education, household wealth, birth interval, maternal age, total number of children born, water sources, place of residence, region

# 5. Methodology
I applied the following:
- Survey-weighted descriptive statistics and bivariate analysis
- Graphical data visualization
- Survey-weighted multivariate logistic regression
The analyses were conducted in R and Stata

# 6. Key finding
- Higher fertility (total number of children ever born) among Ugandan women is associated with increased odds of under-five child mortality 

# 7. Repository contents
- `data_extractionKR.qmd` # R data extraction script
- `data_cleaning.do` # Stata data cleaning dofile
- `data_cleaning.log` # Stata data cleaning logfile
- `descriptive_analysis.qmd` - R descriptive data analysis script
- `multivariate_analysis.do` - Stata multivariate logistic regression script

# 8. Data availability
The dataset used is constructed from the 2022 Uganda DHS. I can avail the data upon request. However, to access the original data, request it from the Uganda Bureau of Statistics, link: https://microdata.ubos.org:7070/index.php/catalog/81 
