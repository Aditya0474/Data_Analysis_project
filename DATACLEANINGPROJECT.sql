USE data_cleaning;

-- 1.REMOVE Duplicates
-- 2.Standarized the data
-- 3.NULL values or blank values
-- 4.REmove any columns

SELECT * FROM layoffs;

create table layoffs1
like layoffs;

insert layoffs1
SELECT * FROM layoffs;

SELECT * FROM layoffs1;

WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions
           ) AS row_num
    FROM layoffs1
)
SELECT * FROM cte
WHERE row_num > 1;

SELECT * FROM layoffs1
WHERE company = 'Casper';

WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions
           ) AS row_num
    FROM layoffs1
)
DELETE FROM cte
WHERE row_num > 1;

insert into layoffs2
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions
           ) AS row_num
    FROM layoffs1

SELECT * FROM layoffs2
WHERE row_num >1;

DELETE FROM layoffs2
WHERE row_num >1;

-- standarizing data

select company, (TRIM(company))
from layoffs2;

update layoffs2
set company = TRIM(company);

select *
from layoffs2
where industry LIKE 'Crypto%';

UPDATE layoffs2 
SET industry = 'Crypto'
where industry LIKE 'Crypto%';

select distinct country,TRIM(TRAILING '.' FROM country)
from layoffs2
order by 1;

UPDATE layoffs2 
SET country= TRIM(TRAILING '.' FROM country)
where country LIKE 'United States%';

select `date`
from layoffs2;

UPDATE layoffs2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

ALTER TABLE layoffs2
MODIFY COLUMN `date` DATE;

SELECT * FROM layoffs2;

-- remove NULL or BLANK

SELECT * FROM layoffs2
where company = 'Airbnb';

SELECT t1.industry,t2.industry 
FROM layoffs2 t1
JOIN layoffs2 t2
   on t1.company = t2.company
   AND  t1.location = t2.location
WHERE (t1.industry IS NULL or  t1.industry='')
and t2.industry IS NOT NULL;

UPDATE layoffs2
SET industry = null
WHERE industry='';


UPDATE layoffs2 t1
JOIN layoffs2 t2
on t1.company = t2.company
set t1.industry = t2.industry
WHERE t1.industry IS NULL 
and t2.industry IS NOT NULL;

-- remove colummns and rows

SELECT * FROM layoffs2
where total_laid_off IS NULL
and percentage_laid_off IS NULL;

DELETE FROM layoffs2
where total_laid_off IS NULL
and percentage_laid_off IS NULL;

ALTER TABLE layoffs2
DROP COLUMN row_num;

SELECT * FROM layoffs2;


