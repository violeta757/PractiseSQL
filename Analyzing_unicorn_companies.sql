You have been given access to their unicorns database, which contains the following tables:

Table1: dates
Column		Description
company_id	A unique ID for the company.
date_joined	The date that the company became a unicorn.
year_founded	The year that the company was founded.


Table2: funding
Column			Description
company_id		A unique ID for the company.
valuation		Company value in US dollars.
funding			The amount of funding raised in US dollars.
select_investors	A list of key investors in the company.


Table3: industries
Column		Description
company_id	A unique ID for the company.
industry	The industry that the company operates in.


Table4: companies
Column		Description
company_id	A unique ID for the company.
company		The name of the company.
city		The city where the company is headquartered.
country		The country where the company is headquartered.
continent	The continent where the company is headquartered.


The output
Your query should return a table in the following format:

industry	year	num_unicorns	average_valuation_billions
industry1	2021	---	---
industry2	2020	---	---
industry3	2019	---	---
industry1	2021	---	---
industry2	2020	---	---
industry3	2019	---	---
industry1	2021	---	---
industry2	2020	---	---
industry3	2019	---	---
Where industry1, industry2, and industry3 are the three top-performing industries.


CODE:

WITH top_industries AS (
	SELECT i.industry, count(i.*)
	FROM industries as i
		INNER JOIN dates as d
		ON i.company_id=d.company_id
		WHERE EXTRACT(year FROM d.date_joined) IN (2019, 2020, 2021)
		GROUP BY industry
		ORDER BY count DESC
		LIMIT 3),

 yearly_rankings AS (
	SELECT count(i.*) AS num_unicorns, i.industry, EXTRACT(year FROM d.date_joined) AS year, AVG(f.valuation) as avg_valuation
	FROM industries as i 
	INNER JOIN dates as d
	ON i.company_id = d.company_id
		INNER JOIN funding as f
		ON i.company_id = f.company_id
		GROUP BY industry, year)

SELECT industry, year, num_unicorns, ROUND(AVG(avg_valuation / 1000000000), 2) AS average_valuation_billions
FROM yearly_rankings
	WHERE year IN ('2019', '2020', '2021')
	AND industry IN (SELECT industry FROM top_industries)
		GROUP BY industry, num_unicorns, year
		ORDER BY year DESC, num_unicorns DESC;