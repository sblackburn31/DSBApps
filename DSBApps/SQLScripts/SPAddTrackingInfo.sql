
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[getProductionData]    Script Date: 12/28/2018 8:32:18 AM ******/
IF OBJECT_ID ( 'addTrackingInfo', 'P' ) IS NOT NULL  
	DROP PROCEDURE [dbo].[addTrackingInfo]
GO

-- =============================================
-- Author:		David Blackburn	
-- Create date: 2/28/2019
-- Description:	Adds application tracking usage to the Tracking table
-- =============================================
CREATE PROCEDURE addTrackingInfo 
	-- Add the parameters for the stored procedure here
	@place  NVARCHAR(20),
	@who  NVARCHAR(30),
	@when NVARCHAR(30)  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET DATEFORMAT MDY
    -- Insert statements for procedure here
		DECLARE @ConvWhenTS DATETIME2(7)
		SET @ConvWhenTS = CONVERT( datetime2, @when)
		
		INSERT INTO [dbo].[Tracking]
				   ([place]
				   ,[who]
				   ,[whenTS])
			 VALUES
				   (@place
				   ,@who
				   ,@ConvWhenTS)
END
GO