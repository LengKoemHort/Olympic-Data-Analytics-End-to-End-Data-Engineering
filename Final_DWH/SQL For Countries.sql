USE Olympics
GO

CREATE TABLE [dbo].[Countries](
    [id] [varchar](10) NULL,
    [name] [varchar](200) NULL,
    [continent] [varchar](10) NULL,
    [flag_url] [varchar](500) NULL,
    [gold_medals] [int] NULL,
    [silver_medals] [int] NULL,
    [bronze_medals] [int] NULL,
    [total_medals] [int] NULL,
    [rank] [decimal](18,2) NULL,
    [rank_total_medals] [decimal](18,2) NULL,
    [DatacollectionDate] [datetimeoffset](7) NULL
)
ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vm_Countries]
AS
/*
=========================================
CREATE BY:	SQLDevDBA
CREATED DATE: 08/04/2024
DESCRIPTION:	Selects data from table
=========================================
*/
SELECT [id],
       [name],
       [continent],
       [flag_url],
       [gold_medals],
       [silver_medals],
       [bronze_medals],
       [total_medals],
       [rank],
       [rank_total_medals],
       [DataCollectionDate],
       CASE 
           WHEN CAST(total_medals AS DECIMAL(18,2)) > 0
           THEN CAST(CAST(gold_medals AS DECIMAL(18,2)) / CAST(total_medals AS DECIMAL(18,2)) AS DECIMAL(18,2))
           ELSE 0 
       END AS Gold_Medals_Pct
FROM [Olympics].[dbo].[Countries]
GO

/******Object: Table [db0].[CountriesHistory]*****/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CountriesHistory]
(
    [id] [varchar](18) NULL,
    [name] [varchar](208) NULL,
    [continent] [varchar](18) NULL,
    [flag_url] [varchar](508) NULL,
    [gold_medals] [int] NULL,
    [silver_medals] [int] NULL,
    [bronze_medals] [int] NULL,
    [total_medals] [int] NULL,
    [rank] [decimal](18, 2) NULL,
    [rank_total_medals] [decimal](18, 2) NULL,
    [DataCollectionDate] [datetimeoffset](7) NULL
) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_CountriesHistory]
AS
/*
CREATED BY:
SQLDevDBA
CREATED DATE:
08/04/2024
DESCRIPTION:
Selects data from table
*/
SELECT [id],
       [name],
       [continent],
       [flag_url],
       [gold_medals],
       [silver_medals],
       [bronze_medals],
       [total_medals],
       [rank],
       [rank_total_medals],
       [DataCollectionDate]
FROM [Olympics].[dbo].[CountriesHistory]
GO

SET QUOTED_IDENTIFIER ON
GO
/***
CREATED BY:
CREATE DATE: 08/04/2024
***/
SELECT [id],
       [name],
       [continent],
       [flag_url],
       [gold_medals],
       [silver_medals],
       [bronze_medals],
       [total_medals],
       [rank],
       [rank_total_medals],
       [DataCollectionDate]
FROM [Olympics].[dbo].[CountriesHistory]