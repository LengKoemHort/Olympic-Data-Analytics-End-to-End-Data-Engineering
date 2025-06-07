USE [Olympics]
GO

CREATE TABLE [dbo].[Competitors](
[event_id] [int] NULL,
[event_discipline_name] [varchar] (100) NULL,
[country_name] [varchar] (100) NULL,
[country_flag_url] [varchar](500) NULL,
[competitor_name] [varchar] (200) NULL,
[position][varchar] (10) NULL,
[result_position] [varchar] (10) NULL,
[result_winnerLoserTie] [varchar](10) NULL,
[result_mark] [varchar] (10) NULL,
[DataCollectionDate] [datetimeoffset] (7) NULL
) ON [PRIMARY]
GO

CREATE VIEW [dbo].[vw_Competitors]
as 
/*
=========================================
CREATE BY:	SQLDevDBA
CREATED DATE: 08/04/2024
DESSCRIPTION:	Selects data from table
=========================================
*/
SELECT [event_id]
		,[event_discipline_name]
		,[country_name]
		,[country_flag_url]
		,[competitor_name]
		,[position]
		,[result_position]
		,[result_winnerLoserTie]
		,[result_mark]
		,[DataCollectionDate]
	FROM [Olympics].[dbo].[Competitors]
GO


CREATE TABLE [dbo].[CompetitorsHistory] (
	[event_id] [int] NULL,
	[event_discipline_name] [varchar] (100) NULL,
	[country_name] [varchar] (100) NULL,
	[country_flag_url] [varchar](500) NULL,
	[competitor_name] [varchar] (200) NULL,
	[position] [varchar] (10) NULL,
	[result_position] [varchar] (10) NULL,
	[result_winnerLoserTie] [varchar](10) NULL,
	[result_mark] [varchar] (10) NULL,
	[DataCollectionDate] [datetimeoffset] (7) NULL
) ON [PRIMARY]
GO

/**** Object: View [dbo].[vm_CompetitorsHistory] ****/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vm_CompetitorsHistory]
AS
/*
=========================================
CREATE BY:	SQLDevDBA
CREATED DATE: 08/04/2024
DESSCRIPTION:	Selects data from table
=========================================
*/
SELECT [event_id]
		,[event_discipline_name]
		,[country_name]
		,[country_flag_url]
		,[competitor_name]
		,[position]
		,[result_position]
		,[result_winnerLoserTie]
		,[result_mark]
		,[DataCollectionDate]
	FROM [Olympics].[dbo].[CompetitorsHistory]
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
    [rank] [INT,2) NULL,
    [rank_total_medals] [INT,2) NULL,
    [DatacollectionDate] [datetimeoffset](7) NULL
)
ON [PRIMARY] 
GO

/**** Object: View [dbo].[vm_Countries] ****/
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
           WHEN CAST(total_medals AS INT,2)) > 0
           THEN CAST(CAST(gold_medals AS INT,2)) / CAST(total_medals AS INT,2)) AS INT,2))
           ELSE 0 
       END AS Gold_Medals_Pct
FROM [Olympics].[dbo].[Countries]
GO

/**** Object: View [dbo].[vm_CountriesHistory] ****/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vm_CountriesHistory]
AS
/*
=========================================
CREATE BY:	SQLDevDBA
CREATED DATE: 08/04/2024
DESCRIPTION:	Selects data from table
=========================================
*/
SELECT [event_id]
      ,[event_discipline_name]
      ,[country_name]
      ,[country_flag_url]
      ,[gold_medals]
      ,[silver_medals]
      ,[bronze_medals]
      ,[total_medals]
      ,[rank]
      ,[rank_total_medals]
      ,[DataCollectionDate]
FROM [Olympics].[dbo].[CountriesHistory]
GO


CREATE TABLE [dbo].[Disciplines]
(
    [id] [varchar](10) NULL,
    [name] [varchar](200) NULL,
    [pictogram_url] [varchar](1000) NULL,
    [pictogram_url_dark] [varchar](1000) NULL,
    [DataCollectionDate] [datetimeoffset](7) NULL
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Disciplines]
AS
/*
CREATED BY: SQLDevDBA
CREATED DATE: 08/04/2024
DESCRIPTION: Selects data from table
*/
SELECT [id],
       [name],
       [pictogram_url],
       [pictogram_url_dark],
       [DataCollectionDate]
FROM [Olympics].[dbo].[Disciplines]
GO


CREATE TABLE [dbo].[DisciplinesHistory] (
    [id] [varchar](10) NULL,
    [name] [varchar](200) NULL,
    [pictogram_url] [varchar](1000) NULL,
    [pictogram_url_dark] [varchar](1000) NULL,
    [event_id] [int] NULL,
    [event_name] [varchar](200) NULL,
    [DataCollectionDate] [datetimeoffset](7) NULL
) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_DisciplinesHistory]
AS
/*
CREATED BY: SQLDevDBA
CREATED DATE: 08/04/2024
DESCRIPTION: Selects data from table
*/
SELECT [id],
       [name],
       [pictogram_url],
       [pictogram_url_dark],
       [event_id],
       [event_name],
       [DataCollectionDate]
FROM [Olympics].[dbo].[DisciplinesHistory]
GO

CREATE TABLE [dbo].[Events] (
    [id] [int] NULL,
    [day] [date] NULL,
    [discipline_name] [varchar](200) NULL,
    [discipline_pictogram] [varchar](500) NULL,
    [name] [varchar](200) NULL,
    [venue_name] [varchar](200) NULL,
    [event_name] [varchar](500) NULL,
    [detailed_event_name] [varchar](500) NULL,
    [start_date] [datetimeoffset](7) NULL,
    [end_date] [datetimeoffset](7) NULL,
    [status] [varchar](50) NULL,
    [is_medal_event] [int] NULL,
    [is_live] [int] NULL,
    [gender_code] [varchar](10) NULL,
    [DataCollectionDate] [datetimeoffset](7) NULL
) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vm_Events]
AS
/*
CREATED BY: SQLDevDBA
CREATED DATE: 08/04/2024
DESCRIPTION: Selects data from table
*/
SELECT [id],
       [day],
       [discipline_name],
       [discipline_pictogram],
       [name],
       [venue_name],
       [event_name],
       [detailed_event_name],
       [start_date],
       [end_date],
       [status],
       [is_medal_event],
       [is_live],
       [gender_code],
       [DataCollectionDate]
FROM [Olympics].[dbo].[Events]
GO

CREATE TABLE [dbo].[EventsHistory] (
    [id] [int] NULL,
    [day] [date] NULL,
    [discipline_name] [varchar](200) NULL,
    [discipline_pictogram] [varchar](500) NULL,
    [name] [varchar](200) NULL,
    [venue_name] [varchar](200) NULL,
    [event_name] [varchar](500) NULL,
    [detailed_event_name] [varchar](500) NULL,
    [start_date] [datetimeoffset](7) NULL,
    [end_date] [datetimeoffset](7) NULL,
    [status] [varchar](50) NULL,
    [is_medal_event] [int] NULL,
    [is_live] [int] NULL,
    [gender_code] [varchar](10) NULL,
    [DataCollectionDate] [datetimeoffset](7) NULL
) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vm_EventsHistory]
AS
/*
CREATED BY: SQLDevDBA
CREATED DATE: 08/04/2024
DESCRIPTION: Selects data from table
*/
SELECT [id],
       [day],
       [discipline_name],
       [discipline_pictogram],
       [name],
       [venue_name],
       [event_name],
       [detailed_event_name],
       [start_date],
       [end_date],
       [status],
       [is_medal_event],
       [is_live],
       [gender_code],
       [DataCollectionDate]
FROM [Olympics].[dbo].[EventsHistory]
GO

/***** Object: StoreProcedure [dbo].[usp_TruncateAllTables] *****/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON 
GO
CREATE PROCEDURE [dbo].[usp_TruncateAllTables]
AS
/*
CREATED BY: SQLDevDBA
CREATED DATE: 08/03/2024
DESCRIPTION: Truncates All Tables
*/
BEGIN
    TRUNCATE TABLE [Olympics].[dbo].[Countries];
    TRUNCATE TABLE [Olympics].[dbo].[CountriesHistory];

    TRUNCATE TABLE [Olympics].[dbo].[Disciplines];
    TRUNCATE TABLE [Olympics].[dbo].[DisciplinesHistory];

    TRUNCATE TABLE [Olympics].[dbo].[Competitors];
    TRUNCATE TABLE [Olympics].[dbo].[CompetitorsHistory];

    TRUNCATE TABLE [Olympics].[dbo].[Events];
    TRUNCATE TABLE [Olympics].[dbo].[EventsHistory];
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_TruncateCompetitors]
AS
/*
CREATED DATE: 08/03/2024
DESCRIPTION: Truncates Competitors Table
*/
BEGIN
    TRUNCATE TABLE [Olympics].[dbo].[Competitors];
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TruncateCountries]
AS
/*
CREATED BY: SQLDevDBA
CREATED DATE: 08/03/2024
DESCRIPTION: Truncates Countries Table
*/
BEGIN
    TRUNCATE TABLE [Olympics].[dbo].[Countries];
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TruncateDisciplines]
AS
/*
CREATED BY: SQLDevDBA
CREATED DATE: 08/03/2024
DESCRIPTION: Truncates Disciplines Table
*/
BEGIN
    TRUNCATE TABLE [Olympics].[dbo].[Disciplines];
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TruncateEvents]
AS
/*
CREATED BY: SQLDevDBA
CREATED DATE: 08/03/2024
DESCRIPTION: Truncates Events Table
*/
BEGIN
    TRUNCATE TABLE [Olympics].[dbo].[Events];
END
GO

