USE [Notebooks]

USE [Notebooks]
GO

DECLARE @RC int

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[seedProductionData] 
GO



DECLARE @RC int
DECLARE @ProductionId bigint

-- TODO: Set parameter values here.
SET @ProductionId = 1

EXECUTE @RC = [dbo].[getProductionData] @ProductionId

SELECT @RC AS [getProductionData]

USE [Notebooks]
GO
/**********************************************/
DECLARE @RC int
DECLARE @ProductionId bigint
DECLARE @WSId char(19)

-- TODO: Set parameter values here.
SET @WSId = 'TESTWS'

EXECUTE @RC = [dbo].[setProductionOrder] 9, @WSId
EXECUTE @RC = [dbo].[setProductionOrder] 8, @WSId
EXECUTE @RC = [dbo].[setProductionOrder] 7, @WSId
EXECUTE @RC = [dbo].[setProductionOrder] 6, @WSId
EXECUTE @RC = [dbo].[setProductionOrder] 5, @WSId

/**********************************************/

USE [Notebooks]
GO

DECLARE @RC int
DECLARE @ProductionId bigint
DECLARE @StartTime datetime2(7)
DECLARE @WorkCell varchar(20)
DECLARE @NumEmpl int

-- TODO: Set parameter values here.
SET @StartTime = DATEADD(MINUTE, -205, GETDATE())
EXECUTE @RC = [dbo].[startProductionData] 
   8
  ,@StartTime
  ,'HDW WORKSTATION 5'
  ,1
EXECUTE @RC = [dbo].[startProductionData] 
   1
  ,@StartTime
  ,'HDW WORKSTATION 5'
  ,1
EXECUTE @RC = [dbo].[startProductionData] 
   9
  ,@StartTime
  ,'HDW WORKSTATION 5'
  ,1
EXECUTE @RC = [dbo].[startProductionData] 
   5
  ,@StartTime
  ,'HDW WORKSTATION 5'
  ,1
GO


