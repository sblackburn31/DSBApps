DECLARE @ProductionId bigint
DECLARE @StartTime datetime2(7)
DECLARE @EndTime datetime2(7)
DECLARE @WSID char(19)


SET @ProductionId = 3
SET @StartTime =  DATEADD(MINUTE, -100, GETDATE())
SET @EndTime =  DATEADD(MINUTE, -90, GETDATE())


USE [Notebooks]
GO

DECLARE @RC int
DECLARE @ProductionId bigint
DECLARE @EndTime datetime2(7)
DECLARE @WorkCell varchar(20)
DECLARE @NumEmpl int

-- TODO: Set parameter values here.
SET @ProductionId = 3
SET @EndTime = DATEADD(MINUTE, -30, GETDATE())
SET @WorkCell = 'HDW WORKSTATION 5'
SET @NumEmpl = 9

EXECUTE @RC = [dbo].[endProductionTimer] 
   @ProductionId
  ,@EndTime
  ,@WorkCell
  ,@NumEmpl

  SELECT * FROM [dbo].[ProductionOrder]

