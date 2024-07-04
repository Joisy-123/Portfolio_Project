
-- Data Cleaning

SELECT *
FROM layoffs;

/* 1. Remove Duplicates
   2. Standardize the Data.
   3. Null Values or Blank values
   4. Remove any column */
   
   CREATE TABLE layoffs_staging
   LIKE layoffs;
   
   SELECT *
   FROM layoffs_staging;
   
   INSERT layoffs_staging
   SELECT *
   FROM layoffs;
   
    SELECT *
   FROM layoffs_staging
   WHERE company = 'Airbnb';
   
   WITH duplicate_cte AS
   (
   SELECT *,
   ROW_NUMBER() OVER(
   PARTITION BY  company, industry, total_laid_off, percentage_laid_off, `date`, stage, 
   country, funds_raised_millions) AS row_num
   FROM layoffs_staging
   )
   DELETE
   FROM duplicate_cte
   WHERE row_num >1;
   
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

INSERT INTO layoffs_staging2
SELECT *,
   ROW_NUMBER() OVER(
   PARTITION BY  company, industry, total_laid_off, percentage_laid_off, `date`, stage, 
   country, funds_raised_millions) AS row_num
   FROM layoffs_staging;

DELETE
   FROM layoffs_staging2
   WHERE row_num >1;
   
  SELECT *
  FROM layoffs_staging2;
  
  -- Standardizing data
  
  SELECT DISTINCT TRIM(company)
  FROM layoffs_staging2;
  
  SELECT company, TRIM(company)
  FROM layoffs_staging2;
   
   UPDATE layoffs_staging2
   SET company = TRIM(company);
   
   SELECT DISTINCT industry
  FROM layoffs_staging2
  ORDER BY 1;
  
  SELECT DISTINCT country
  FROM layoffs_staging2
  ORDER BY 1;
  
  SELECT *
  FROM layoffs_staging2
  WHERE country LIKE 'Unitd States%'
  ORDER BY 1;
  
  SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
  FROM layoffs_staging2
  ORDER BY 1;
  
  UPDATE layoffs_staging2
  SET country = TRIM(TRAILING '.' FROM country)
  WHERE country LIKE 'United States%';
  
  SELECT *
  FROM layoffs_staging2;
   
SELECT `date`
FROM layoffs_staging2;

SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE( `date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT*
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = ' '; 

SELECT *
FROM layoffs_staging2
WHERE company = 'AirBnB';

INSERT INTO layoffs_staging2 (industry)
VALUES ('Travel');


DELETE
FROM layoffs_staging2
WHERE industry = 'trave'
AND company IS NULL;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE company = 'Zalando';

SELECT DISTINCT *
FROM layoffs_staging2;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


