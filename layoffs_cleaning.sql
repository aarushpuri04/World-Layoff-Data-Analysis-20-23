-- 1) Data cleaning 

Select * from layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT * from layoffs;

SELECT * FROM layoffs_staging;

-- 1) Removing Duplicates
# creating a cte for using query during runtime only

WITH cte_dup AS 
( 
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * FROM cte_dup
WHERE row_num > 1; # selecting data where row_num > 1 as they are duplicates

#checking what to remove
SELECT * FROM layoffs_staging
where company = 'Casper';

#we will be creating a new table and deleting from it the duplicates

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * FROM layoffs_staging2
WHERE row_num>1;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT * FROM layoffs_staging2
WHERE row_num = 1;

-- 2) Standardize the Data

# removing spaces
SELECT * FROM layoffs_staging2;

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

#organising sector or industry wise

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

#as crypto and crypto currency is same so update it

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

#scan all the columns on by one and fix issues
SELECT Distinct country
FROM layoffs_staging2
ORDER BY 1
;

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

/* or UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' from country)
WHERE country LIKE 'United States%'; */

#formatting coulmn type accordingly
SELECT `date` from layoffs_staging2;
SELECT `date`, str_to_date(`date`, '%m/%d/%Y')from layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2 #never do alter on raw table
MODIFY COLUMN `date` DATE;

-- 3) null blank values

SELECT DISTINCT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

# try to populate

/*
SELECT DISTINCT  *
FROM layoffs_staging2
WHERE company IS NULL 
OR company = ' ';

SELECT DISTINCT  *
FROM layoffs_staging2
WHERE location IS NULL 
OR location = '';
*/

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = ''; #bally's did only 1 layoff

#finding if we can populate industry based on company
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';  

/* as airbnb has industry now we will find all others of the same type,
location and other firlds can be not null 
but for now let just conside same location ones are in same industry */
#checking the table with join on itself

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL; #did multiple layoffs and industry was missing

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

# updateing industry or populating it

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2;

/* we can't populate any other firld as we don't have relevant data.
We could have populated total laidoff if we had total employee before layoff data.
total_laid_off = total*percentage_laid_off */

# if you don't think you need some data you can delete it 

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE (total_laid_off IS NULL OR total_laid_off = '') 
AND (percentage_laid_off IS NULL OR percentage_laid_off = '');

#as we are seeing total layoffs not funds_raised etc so we can delete them 

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

-- 4) remove any column

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;

/* AND OUR DATA IS CLEANED AND READY FOR EDA */


