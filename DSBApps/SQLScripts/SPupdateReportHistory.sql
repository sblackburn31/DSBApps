SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[updateReportHistory]    Script Date: 12/28/2018 8:32:18 AM ******/
IF OBJECT_ID ( 'updateReportHistory', 'P' ) IS NOT NULL  
	DROP PROCEDURE [dbo].[updateReportHistory]
GO

-- =============================================
-- Author:		David Scott Blackburn
-- Create date: 3/23/2019
-- Description:	Updates the ReportHistory table, if it is needed
-- =============================================
CREATE PROCEDURE [dbo].[updateReportHistory] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ReportDate AS DATETIME2;
	DECLARE @ToDate AS DATETIME2;
	DECLARE @FromDate AS DATETIME2;

	DECLARE @IsEmpty AS Bit;
	DECLARE @RecordExists AS Bit;

	SET @ReportDate = GETDATE();
	SET @ToDate = DATEADD(day,-1,@ReportDate) 
	SET @FromDate = DATEADD(year, -20, GETDATE());
	
	SELECT @IsEmpty = CASE WHEN EXISTS(SELECT 1 FROM [dbo].[ReportHistory]) THEN 0 ELSE 1 END;
	SELECT @RecordExists = 	CASE WHEN EXISTS(SELECT 10 
								FROM [dbo].[ReportHistory] 
								WHERE CONVERT(Date, GETDATE()) = CONVERT(Date, COALESCE( [DateRun], DATEADD(year, -20, GETDATE()) ) ) ) THEN 1 ELSE 0 END;

	IF NOT (@RecordExists = 1)
	BEGIN
		IF NOT (@IsEmpty = 1)
			SET @FromDate = ( SELECT TOP 1 DATEADD(DAY, 1, [ToDate]) FROM [dbo].[ReportHistory] ORDER BY [DateRun]);
		INSERT INTO [dbo].[ReportHistory]
				   ([DateRun]
				   ,[FromDate]
				   ,[ToDate])
			 VALUES
				   (@ReportDate
				   ,@FromDate
				   ,@ToDate )
	END

END
GO