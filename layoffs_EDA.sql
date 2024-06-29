-- Exploratory data analysis

SELECT * 
FROM layoffs_staging2;

/* mostly exploring important parts of data,
 like the total_laid_offs and percentage_laid_offs */
 
 SELECT MAX(total_laid_off), MAX(percentage_laid_off)
 FROM layoffs_staging2;
 
# show companies that had a 100% layoffs with quantity in descending order 
 SELECT *
 FROM layoffs_staging2
 WHERE percentage_laid_off = 1
 ORDER BY total_laid_off DESC;
 
 #company with total layoffs they mave done
SELECT company,  SUM(total_laid_off) sum_layoffs
FROM layoffs_staging2
GROUP BY company
ORDER BY sum_layoffs DESC;

#industry with total layoffs
SELECT industry,  SUM(total_laid_off) sum_layoffs
FROM layoffs_staging2
GROUP BY industry
ORDER BY sum_layoffs DESC;

# first layoff and last layoff in data 
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

#country with total layoffs industry wise
SELECT company, industry,  SUM(total_laid_off) sum_layoffs, country
FROM layoffs_staging2
GROUP BY company, industry, country
ORDER BY sum_layoffs DESC;


#country with total layoffs industry wise
SELECT country,  SUM(total_laid_off) sum_layoffs
FROM layoffs_staging2
GROUP BY country
ORDER BY sum_layoffs DESC; 

#yearwise with total layoffs from country
SELECT YEAR(`date`),SUM(total_laid_off) sum_layoffs
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC; 

#yearwise with total layoffs from country
SELECT YEAR(`date`), country, SUM(total_laid_off) sum_layoffs
FROM layoffs_staging2
GROUP BY YEAR(`date`), country
ORDER BY 1 DESC; 

SELECT * 
FROM layoffs_staging2;

# progression of layoffs, rolling total year-month wise

/* SELECT MONTH(`date`) AS yearmonth, SUM(total_laid_off) as totaloffs
FROM layoffs_staging2 
WHERE MONTH(`date`) IS NOT NULL
GROUP BY yearmonth
ORDER BY 1; 
by above aproach we will only be getting by month combined 
of all years*/ 

SELECT substring(`date`, 1, 7) AS yearmonth, SUM(total_laid_off) as totaloffs
FROM layoffs_staging2 
WHERE substring(`date`, 1, 7) IS NOT NULL
GROUP BY yearmonth
ORDER BY 1;
#now making in rolling sum we have to use cte or temp table or subquery

WITH rolling_table AS
(
SELECT substring(`date`, 1, 7) AS yearmonth, SUM(total_laid_off) as totaloffs
FROM layoffs_staging2 
WHERE substring(`date`, 1, 7) IS NOT NULL
GROUP BY yearmonth
ORDER BY 1
)

SELECT yearmonth, totaloffs, SUM(totaloffs)
OVER(ORDER BY yearmonth) AS Rolling_sum
FROM rolling_table;

# rank companies basd on year wise layoffs, IMPORTANT CONCEPT
/*which company laid off most employees in which year and 
show top 5 companies per year*/

SELECT company, YEAR(`date`) as years, SUM(total_laid_off) AS lay_offs
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_laidoff (COMPANY, YEARS, LAY_OFFs) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC
), COMPANY_YEAR_RANK AS 
(
SELECT *, 
dense_rank() OVER(PARTITION BY years ORDER BY LAY_OFFs DESC ) AS RANKING
FROM Company_laidoff
WHERE years IS NOT NULL
)
SELECT *
FROM COMPANY_YEAR_RANK
WHERE RANKING <=5;
 /* for this complex query we will
 1) try to write logic for selecting company, YEAR(`date`) as years, SUM(total_laid_off)
 2) try cte, temp table or subquery
 3) write logic for ranking, dense_rank() OVER(PARTITION BY years ORDER BY LAY_OFFs DESC ) AS RANKING
 4) making another cte for final data showing WHERE RANKING <=5;*/