-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT  company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT*
FROM layoffs_staging2;

SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY  company
ORDER BY 2 DESC;

SELECT `date` AS MONTH, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY MONTH
ORDER BY 1 ASC;

/*WITH Rolling_Total AS
(
SELECT `date` AS MONTH, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY MONTH
ORDER BY 1 ASC
)*/

SELECT substring(`date`, 1,7), total_laid_off AS total_off,
 SUM(total_laid_off) OVER( ORDER BY `date`) AS rolling_total
FROM layoffs_staging2;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY  company
ORDER BY 2 DESC;

SELECT company, substring(`date`, 1,7) AS MONTH , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY  company, MONTH
ORDER BY 3 DESC;

WITH Company_Year (Company, Month, Total_laid_off) AS
(
SELECT company, substring(`date`, 1,7) AS MONTH , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY  company, MONTH
), Company_Year_Rank AS
(SELECT *, dense_rank() over (partition by Month ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE Month IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;

WITH Industry_Year (Industry, Month, Total_laid_off) AS
(
SELECT Industry, substring(`date`, 1,7) AS MONTH , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY  Industry, MONTH
), Industry_Year_Rank AS
(SELECT *, dense_rank() over (partition by Month ORDER BY total_laid_off DESC) AS Ranking
FROM Industry_Year
WHERE Month IS NOT NULL
)
SELECT *
FROM Industry_Year_Rank
WHERE Ranking <= 5
;

WITH Country_Year (Country, Month, Total_laid_off) AS
(
SELECT Country, substring(`date`, 1,7) AS MONTH , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY  Country, MONTH
), Country_Year_Rank AS
(SELECT *, dense_rank() over (partition by Month ORDER BY total_laid_off DESC) AS Ranking
FROM Country_Year
WHERE Month IS NOT NULL
)
SELECT *
FROM Country_Year_Rank
WHERE Ranking <= 5
;