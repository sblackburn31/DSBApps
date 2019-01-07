SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[pauseEnd]    Script Date: 12/28/2018 8:32:18 AM ******/
IF OBJECT_ID ( 'pauseEnd', 'P' ) IS NOT NULL  
	DROP PROCEDURE [dbo].[pauseEnd]
GO

-- =============================================
-- Author:		David Scott Blackburn
-- Create date: 12/29/18
-- Description:	Sets the end pause time and calculates the duration for the pause record
-- =============================================
CREATE PROCEDURE [dbo].[pauseEnd] 
	-- Add the parameters for the stored procedure here
	@ProductionId bigInt,
	@EndTime datetime2,
	@WorkstationId char(19)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    BEGIN TRY
		DECLARE @convertedId bigInt
		DECLARE @idToChange bigInt
		DECLARE @ReturnCode int
		DECLARE @ReturnMsg VARCHAR(255)

		SET @ReturnCode = 1
		SET @ReturnMsg = ''

		BEGIN TRANSACTION

		IF ISNULL(@ProductionId, 0) > 0
			BEGIN
				SET @convertedId = dbo.convertId(@ProductionId)
				SET @idToChange  = (SELECT MAX([id]) FROM [dbo].[PauseDetail] WHERE [productionId] = @convertedId) 
				UPDATE [dbo].[PauseDetail]
				   SET [endTime] = @EndTime
					  ,[duration] = DATEDIFF(MS, [startTime], @EndTime )
				 WHERE [id] = @idToChange
			END
		ELSE
			BEGIN
				SET @idToChange  = (SELECT MAX([id]) FROM [dbo].[PauseUnassigned] WHERE [workstationId] = @WorkstationId) 
				UPDATE [dbo].[PauseUnassigned]
				   SET [endTime] = @EndTime
					  ,[duration] = DATEDIFF(MS, [startTime], @EndTime )
				 WHERE [id] = @idToChange
			END

		COMMIT
		SELECT @ReturnCode AS ReturnCode,
				@ReturnMsg AS ReturnMessage
    END TRY

    BEGIN CATCH
		SELECT @@ERROR AS ReturnCode,
				ERROR_MESSAGE() AS ReturnMessage

		ROLLBACK
    END CATCH
END
GO
