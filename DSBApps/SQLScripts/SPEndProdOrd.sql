USE  [davidBBurn22_Notebooks]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[endProductionTimer]    Script Date: 12/28/2018 8:32:18 AM ******/
IF OBJECT_ID ( 'endProductionTimer', 'P' ) IS NOT NULL  
	DROP PROCEDURE [dbo].[endProductionTimer]
GO

-- =============================================
-- Author:		David Scott Blackburn
-- Create date: 12/27/18
-- Description:	Stops the production timer
-- =============================================
CREATE PROCEDURE [dbo].[endProductionTimer] 
	-- Add the parameters for the stored procedure here
	@ProductionId bigInt,
	@EndTime datetime2,
	@WorkCell varchar(20),
	@NumEmpl int
AS
BEGIN
	
	SET NOCOUNT ON;
    BEGIN TRY
		DECLARE @convertedId bigInt
		DECLARE @totalDuration int
		DECLARE @StartTime datetime2
		DECLARE @timePaused int
		DECLARE @RetMessage VARCHAR(255)
		DECLARE @RetStatus int

		BEGIN TRANSACTION
		SET @convertedId = dbo.convertId(@ProductionId)

		SET @RetStatus = ISNULL((SELECT [statusId] FROM [dbo].[ProductionOrder] WHERE [id] = @convertedId), 5)
		--
		SET @RetMessage = CASE @RetStatus
							WHEN 3 THEN 'OK'
							ELSE 'ERROR'
						  END

		IF @RetStatus = 3
			BEGIN
				SET @totalDuration = ISNULL( (SELECT SUM([duration]) FROM [dbo].[PauseDetail] WHERE [productionId] = @convertedId), 0 )
				SET @StartTime = (SELECT [startTime] FROM [dbo].[ProductionOrder] WHERE [id] = @convertedId)
				SET @timePaused = ISNULL((SELECT SUM([duration]) FROM [dbo].[PauseDetail] WHERE [productionId] = @convertedId), 0)
				SET @totalDuration = DATEDIFF(MS, @StartTime, @EndTime) - @timePaused
				-- Return Data
				UPDATE [dbo].ProductionOrder
				   SET [statusId] = 4
					   , [workCellId] = ( SELECT [id] FROM [dbo].[WorkCell] WHERE [name] = @WorkCell)
					   , [numberEmployees] = @NumEmpl
					   , [endTime] = @EndTime
					   , [duration] = @totalDuration
				   WHERE [id] = @convertedId 
						  
				COMMIT
				SET @RetStatus = 1
			END
		ELSE
			IF @RetStatus = 1
				SET @RetStatus = 6

		SELECT @RetStatus AS ReturnCode,
				  @RetMessage AS ReturnMessage


    END TRY

    BEGIN CATCH
		SELECT @@ERROR AS ReturnCode,
				ERROR_MESSAGE() AS ReturnMessage


		ROLLBACK
    END CATCH
END
GO
