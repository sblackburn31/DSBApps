SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[getReportHistory]    Script Date: 12/28/2018 8:32:18 AM ******/
IF OBJECT_ID ( 'getReportHistory', 'P' ) IS NOT NULL  
	DROP PROCEDURE [dbo].[getReportHistory]
GO

-- =============================================
-- Author:		David Scott Blackburn
-- Create date: 3/23/2019
-- Description:	Updates and retrieves the latest report history record.
-- =============================================
CREATE PROCEDURE [dbo].[getReportHistory] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @RC int

	EXECUTE @RC = [dbo].[updateReportHistory]

	SELECT TOP 1 [FromDate], [ToDate] 
	FROM [dbo].[ReportHistory]
	ORDER BY [DateRun] DESC
END
GO