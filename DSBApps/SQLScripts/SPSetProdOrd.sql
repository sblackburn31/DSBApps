use [dsbburndev]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[setProductionOrder]    Script Date: 12/28/2018 8:32:18 AM ******/
IF OBJECT_ID ( 'setProductionOrder', 'P' ) IS NOT NULL  
	DROP PROCEDURE [dbo].[setProductionOrder]
GO

-- =============================================
-- Author:		David Scott Blackburn
-- Create date: 12/27/18
-- Description:	Sets the status code to held and returns info about the production order
-- =============================================
CREATE PROCEDURE [dbo].[setProductionOrder] 
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
		DECLARE @StatusText	VARCHAR(10)
		DECLARE @ProductNumber VARCHAR(20)
		DECLARE @Description VARCHAR(50)
		DECLARE @StadardAsyTime int

		BEGIN TRANSACTION

		SET @ProductNumber = ''
		SET @Description = ''


		SET @convertedId = dbo.convertId(@ProductionId)

		SET @RetStatus = ISNULL((SELECT [statusId] FROM [dbo].[ProductionOrder] WHERE [id] = @convertedId), 5)
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
		SET @StatusText = CASE @RetStatus
							WHEN 1 THEN 'Ready'
							WHEN 2 THEN 'Set'
							WHEN 3 THEN 'Started'
							WHEN 4 THEN 'Completed'
						    WHEN 0 THEN 'Unset'
							ELSE 'ERROR'
						  END
		-- Return Data
		UPDATE [dbo].ProductionOrder
		   SET [statusId] = 2
		       , [workstationId] = @WSId
		   where [id] = @convertedId AND 
		          [statusId] = 1 -- Ready Status
		COMMIT

		IF @RetStatus > 1
			SELECT @RetStatus AS ReturnCode
				  ,@RetMessage AS ReturnMessage
				  ,@ProductionId	AS ProductionId
				  ,@StatusText AS Status
				  ,@RetStatus  AS StatusId
				  ,@ProductNumber AS ProductNumber
				  ,@Description AS Description
				  ,0 AS Quantity
				  ,0 AS StadardAsyTime
		ELSE
			SELECT @RetStatus AS ReturnCode
				  ,@RetMessage AS ReturnMessage
				  ,[productionId]	AS ProductionId
				  ,[status] AS Status
				  ,[statusId]  AS StatusId
				  ,[productNumber] AS ProductNumber
				  ,[description] AS Description
				  ,[quantity] AS Quantity
				  ,[stadardAsyTime] AS StadardAsyTime
			  FROM [dbo].[vProdOrdInfo]
			  WHERE [productionId] = @convertedId
    END TRY

    BEGIN CATCH
		SELECT @@ERROR AS ReturnCode,
				ERROR_MESSAGE() AS ReturnMessage
				,@ProductionId	AS ProductionId
				,'Error' AS Status
				,6       AS StatusId
				,@ProductNumber    AS ProductNumber
				,@Description    AS Description
				,0       AS Quantity
		ROLLBACK
    END CATCH
END
GO
