USE Olympics
GO

SELECT TOP 10 '[Events]' AS TableName, * FROM [Olympics].dbo.[Events]
SELECT TOP 10 '[Countries]' AS TableName, * FROM [Olympics].dbo.[Countries]
SELECT TOP 10 '[Competitors]' AS TableName, * FROM [Olympics].dbo.[Competitors]
SELECT TOP 10 '[Disciplines]' AS TableName, * FROM [Olympics].dbo.[Disciplines]
SELECT TOP 10 '[EventsHistory]' AS TableName, * FROM [Olympics].dbo.[EventsHistory]
SELECT TOP 10 '[CountriesHistory]' AS TableName, * FROM [Olympics].dbo.[CountriesHistory]
SELECT TOP 10 '[CompetitorsHistory]' AS TableName, * FROM [Olympics].dbo.[CompetitorsHistory]
SELECT TOP 10 '[DisciplinesHistory]' AS TableName, * FROM [Olympics].[dbo].[CountriesHistory]

	



