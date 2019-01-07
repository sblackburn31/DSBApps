SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[getProductionData]    Script Date: 12/28/2018 8:32:18 AM ******/
IF OBJECT_ID ( 'setProductionData', 'P' ) IS NOT NULL  
	DROP PROCEDURE [dbo].[getProductionData]
GO

-- =============================================
-- Author:		David Scott Blackburn
-- Create date: 12/27/18
-- Description:	Returns a Production Order based on the passed in Id passed in.
-- =============================================
CREATE PROCEDURE [dbo].[getProductionData] 
	-- Add the parameters for the stored procedure here
	@ProductionId bigInt
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @convertedId bigInt
	SET @convertedId = [dbo].[convertId](@ProductionId)

    -- Insert statements for procedure here
	SELECT [productionId]
		  ,[status]
		  ,[statusId]
		  ,[productNumber]
		  ,[description]
		  ,[quantity]
		  ,[workstationId]
		  ,[workCell]
		  ,[numberEmployees]
		  ,[startTime]
		  ,[endTime]
		  ,[duration]
	  FROM [dbo].[vProdOrdInfo]
	  WHERE [productionId] = @convertedId

END
GO
