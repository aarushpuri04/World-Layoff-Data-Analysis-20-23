### Problem Statement
The objective of this project is to clean and analyze a dataset containing information about company layoffs. The dataset includes details such as company name, location, industry, number of employees laid off, percentage of workforce laid off, date of layoff, company stage, country, and funds raised. The goal is to remove duplicates, standardize the data, handle missing values, and then perform exploratory data analysis (EDA) to gain insights into layoff trends across different companies, industries, and countries.

### Approach
#### Data Cleaning
1. **Removing Duplicates:**
   - Created a staging table and used a common table expression (CTE) to identify and remove duplicate records based on specific columns.

2. **Standardizing Data:**
   - Trimmed whitespace from the `company` column.
   - Unified similar industry names (e.g., merging "Crypto" and "Crypto Currency" into "Crypto").
   - Corrected country names with formatting issues (e.g., "United States." to "United States").
   - Reformatted the `date` column to the correct date type.

3. **Handling Missing Values:**
   - Identified rows with missing `total_laid_off` and `percentage_laid_off` values and removed those records.
   - Populated missing `industry` values by matching companies and locations from other records.

4. **Column Management:**
   - Removed unnecessary columns (e.g., `row_num`).

#### Exploratory Data Analysis (EDA)
1. **Descriptive Statistics:**
   - Calculated maximum values for `total_laid_off` and `percentage_laid_off`.
   - Identified companies with 100% layoffs and listed them in descending order of total layoffs.

2. **Aggregated Insights:**
   - Summarized total layoffs by company and industry.
   - Determined the first and last layoff dates in the dataset.
   - Analyzed layoffs by country and industry.

3. **Time-Series Analysis:**
   - Analyzed layoffs by year and year-country combinations.
   - Calculated a rolling total of layoffs on a year-month basis.

4. **Ranking Analysis:**
   - Ranked companies based on the number of layoffs each year and highlighted the top 5 companies for each year.

### Conclusion
The data cleaning process successfully removed duplicates, standardized the data, and addressed missing values. The exploratory data analysis revealed important trends, such as:

- Companies with the highest layoffs.
- Industries most affected by layoffs.
- The temporal distribution of layoffs, including a rolling total to observe trends over time.
- Yearly rankings of companies based on layoffs, providing insights into the most impacted organizations annually.

This analysis provides valuable insights into layoff patterns, which can be used by stakeholders to understand the impact of economic downturns and make informed decisions for future planning.

### Code and Data
The SQL code for data cleaning and exploratory data analysis is included in the repository. The cleaned dataset and the results of the analysis can be accessed and further analyzed as needed.
