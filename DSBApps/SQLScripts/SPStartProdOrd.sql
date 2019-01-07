use [davidBBurn22_Notebooks]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[startProductionTimer]    Script Date: 12/28/2018 8:32:18 AM ******/
IF OBJECT_ID ( 'startProductionTimer', 'P' ) IS NOT NULL  
	DROP PROCEDURE [dbo].[startProductionTimer]
GO

-- =============================================
-- Author:		David Scott Blackburn
-- Create date: 12/27/18
-- Description:	Sets Start Timer information
-- =============================================
CREATE PROCEDURE [dbo].[startProductionTimer] 
	-- Add the parameters for the stored procedure here
	@ProductionId bigInt,
	@StartTime datetime2,
	@WorkCell varchar(20),
	@NumEmpl int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    BEGIN TRY
		DECLARE @convertedId bigInt
		DECLARE @RetCode int
		DECLARE @RetMessage VARCHAR(255)
		DECLARE @RetStatus int

		
		SET @convertedId = dbo.convertId(@ProductionId)

		SET @RetStatus = ISNULL((SELECT [statusId] FROM [dbo].[ProductionOrder] WHERE [id] = @convertedId), 5)
		--
		SET @RetMessage = CASE @RetStatus
							WHEN 2 THEN 'OK'
							ELSE 'ERROR'
						  END

		IF @RetStatus = 2
			BEGIN
			    BEGIN TRANSACTION
				-- Return Data
				UPDATE [dbo].ProductionOrder
				   SET [statusId] = 3
					   , [workCellId] = ( SELECT [id] FROM [dbo].[WorkCell] WHERE [name] = @WorkCell)
					   , [numberEmployees] = @NumEmpl
					   , [startTime] = @StartTime
				   where [id] = @convertedId 
						  
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
