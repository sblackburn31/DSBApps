SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[pauseStart]    Script Date: 12/28/2018 8:32:18 AM ******/
IF OBJECT_ID ( 'pauseStart', 'P' ) IS NOT NULL  
	DROP PROCEDURE [dbo].[pauseStart]
GO

-- =============================================
-- Author:		David Scott Blackburn
-- Create date: 12/29/18
-- Description:	Inserts a new pause record and sets start pause data
-- =============================================
CREATE PROCEDURE [dbo].[pauseStart] 
	-- Add the parameters for the stored procedure here
	@ProductionId bigInt,
	@StartTime datetime2,
	@Reason varchar(15),
	@WorkstationId char(19)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    BEGIN TRY
		DECLARE @convertedId bigInt

		DECLARE @ReturnCode int
		DECLARE @ReturnMsg VARCHAR(255)

		SET @ReturnCode = 1
		SET @ReturnMsg = ''

		BEGIN TRANSACTION

		IF ISNULL(@ProductionId, 0) > 0
			BEGIN
				SET @convertedId = dbo.convertId(@ProductionId)

				INSERT INTO [dbo].[PauseDetail] ([productionId], [reason], [startTime]) VALUES (@convertedId, @Reason, @StartTime)

			END
		ELSE
			BEGIN
				INSERT INTO [dbo].[PauseUnassigned] ([workstationId], [reason], [startTime]) 
				                             VALUES (@WorkstationId, @Reason, @StartTime)
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
