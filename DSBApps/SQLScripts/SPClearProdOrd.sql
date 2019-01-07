SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[clearProductionData]    Script Date: 12/28/2018 8:32:18 AM ******/
IF OBJECT_ID ( 'clearProductionData', 'P' ) IS NOT NULL  
	DROP PROCEDURE [dbo].[clearProductionData]
GO

-- =============================================
-- Author:		David Scott Blackburn
-- Create date: 12/27/18
-- Description:	Releases a workstation's hold on a production order
-- =============================================
CREATE PROCEDURE [dbo].[clearProductionData] 
	-- Add the parameters for the stored procedure here
	@ProductionId bigInt,
	@WSId char(19)
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

		BEGIN TRANSACTION
		SET @convertedId = dbo.convertId(@ProductionId)

		SET @RetStatus = ISNULL((SELECT [statusId] FROM [dbo].[ProductionOrder] WHERE [id] = @convertedId), 5)
		IF @RetStatus = 2 
			SET @RetStatus = ISNULL((SELECT 1 FROM [dbo].[ProductionOrder] WHERE [id] = @convertedId  AND [workstationId] = @WSId), 2)
		--
		SET @RetMessage = CASE @RetStatus
							WHEN 1 THEN 'OK'
							WHEN 2 THEN 'Held'
							WHEN 3 THEN 'Started'
							WHEN 4 THEN 'Completed'
							WHEN 5 THEN 'Invalid'
							WHEN 0 THEN 'Unset'
							ELSE 'ERROR'
						  END

		-- Return Data
		UPDATE [dbo].ProductionOrder
		   SET [statusId] = 1
		       , [workstationId] = ''
		   where [id] = @convertedId AND 
		          [statusId] = 2 AND [workstationId] = @WSId
		COMMIT

		SELECT @RetStatus AS ReturnCode,
				  @RetMessage AS ReturnMessage


    END TRY

    BEGIN CATCH
		SELECT @@ERROR AS ReturnCode,
				ERROR_MESSAGE() AS ReturnMessage
				,@ProductionId

		ROLLBACK
    END CATCH
END
GO
