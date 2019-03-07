
GO
SET DATEFORMAT MDY
DECLARE @RC int
DECLARE @place nvarchar(20)
DECLARE @whoTS nvarchar(30)
DECLARE @whenTS nvarchar(30)
	SET DATEFORMAT MDY

-- TODO: Set parameter values here.
SET @place = 'TEST'
SET @whoTS = '2019-10-13 10:26:42.123'
SET @whenTS = '3/3/2019 2:02:45 PM'

    -- Insert statements for procedure here
		DECLARE @ConvWhoTS DATETIME2(7)
		DECLARE @ConvWhenTS DATETIME2(7)
		SET @ConvWhoTS = CONVERT( datetime2, @whoTS)
		SET @ConvWhenTS = CONVERT( datetime2, @whenTS)

SELECT @place,@whoTS,@whenTS

SELECT * FROM [dbo].[Tracking]
EXECUTE @RC = [dbo].[addTrackingInfo] 
   @place
  ,@whoTS
  ,@whenTS


SELECT * FROM [dbo].[Tracking]
GO

