USE [Notebooks]
GO



DELETE FROM [dbo].[PauseDetail]
DELETE FROM [dbo].[ProductionOrder]
GO
DELETE FROM [dbo].[Product]
GO
DELETE FROM [dbo].[WorkCell]

DELETE FROM [dbo].[WorkArea]

GO
DELETE FROM [dbo].[ProductionStatus]
GO


INSERT INTO [dbo].[ProductionStatus]
           ([id]
           ,[Status])
VALUES	(0, 'unset'),
		(1, 'Ready'),
		(2, 'Set'),
		(3, 'Started'),
		(4, 'Completed'),
		(5, 'Error')
GO

SELECT [id]
      ,[Status]
  FROM [dbo].[ProductionStatus]
GO

/****************************************/



INSERT INTO [dbo].[WorkArea]
           ([name])
     VALUES
		( '52 Pack'),
		( 'HDW'),
		( 'Complex'),
		( 'Shipping')
GO

SELECT [id]
      ,[name]
  FROM [dbo].[WorkArea]
GO

/****************************************/


INSERT INTO [dbo].[WorkCell]
           ([name]
           ,[workAreaId])
     VALUES
		('HDW WORKSTATION 1', (SELECT id FROM [dbo].[WorkArea] W WHERE W.[name] = 'HDW')),
		('HDW WORKSTATION 2', (SELECT id FROM [dbo].[WorkArea] W WHERE W.[name] = 'HDW')),
		('HDW WORKSTATION 3', (SELECT id FROM [dbo].[WorkArea] W WHERE W.[name] = 'HDW')),
		('HDW WORKSTATION 4', (SELECT id FROM [dbo].[WorkArea] W WHERE w.[name] = 'HDW')),
		('HDW WORKSTATION 5', (SELECT id FROM [dbo].[WorkArea] W WHERE W.[name] = 'HDW')),
		('52 PACK AREA 1', (SELECT id FROM [dbo].[WorkArea] W WHERE W.[name] = '52 Pack')),
		('52 PACK AREA 2', (SELECT id FROM [dbo].[WorkArea] W WHERE W.[name] = '52 Pack')),
		('52 PACK AREA 3', (SELECT id FROM [dbo].[WorkArea] W WHERE W.[name] = '52 Pack')),
		('COMPLEX WORKAREA A', (SELECT id FROM [dbo].[WorkArea] W WHERE W.[name] = 'Complex')),
		('COMPLEX WORKAREA B', (SELECT id FROM [dbo].[WorkArea] W WHERE W.[name] = 'Complex')),
		('COMPLEX WORKAREA C', (SELECT id FROM [dbo].[WorkArea] W WHERE W.[name] = 'Complex')),
		('RECIEVE AREA 1', (SELECT id FROM [dbo].[WorkArea] W WHERE W.[name] = 'Shipping')),
		('RECIEVE AREA 2', (SELECT id FROM [dbo].[WorkArea] W WHERE W.[name] = 'Shipping')),
		('RECIEVE AREA 3', (SELECT id FROM [dbo].[WorkArea] W WHERE W.[name] = 'Shipping')),
		('RECIEVE AREA 4', (SELECT id FROM [dbo].[WorkArea] W WHERE W.[name] = 'Shipping'))

SELECT [id]
      ,[name]
      ,[workAreaId]
  FROM [dbo].[WorkCell]
GO

/*************************************************************************************/



INSERT INTO [dbo].[Product] ( [number], [description], [stadardAsyTime] )
VALUES
		('Lorem', 'Lorem ipsum dolor sit amet', 6*60*1000),
		('Mauris', 'Mauris pellentesque pulvinar', 6*60*1000),
		('Dignissim', 'Dignissim diam quis enim lobortis', 6*60*1000),
		('Est', 'Est pellentesque elit ullamcorper dignissim.', 6*60*1000),
		('LEO', 'Congue quisque egestas', 6*60*1000),
		('ET', 'Sagittis id consectetur purus', 6*60*1000),
		('NULLAM', 'Vulputate sapien nec sagittis aliquam ', 6*60*1000),
		('IN', 'Leo a diam sollicitudin tempor id eu nisl', 6*60*1000),
		('QUAM', 'Et ligula ullamcorper malesuada proin', 6*60*1000),
		('QUIS', 'Tristique senectus et netus et. Pulvinar ', 6*60*1000),
		('DUIS', 'Nullam vehicula ipsum a arcu cursus vitae.', 6*60*1000),
		('A-ONE', 'Hendrerit dolor magna eget est lorem ipsum', 6*60*1000),
		('B-TWO', 'Quam quisque id diam vel quam elementum pulvinar ', 6*60*1000),
		('C-THREE-PO', 'Magna sit amet purus gravida quis blandit turpis ', 6*60*1000),
		('D-FOUR', 'scelerisque fermentum dui faucibus in ornare quam', 6*60*1000),
		('E-FIVE', 'Quis enim lobortis ', 6*60*1000),
		('606-SIX-SECHS', 'Turpis egestas maecenas pharetra convallis posuere morbi leo urna', 6*60*1000),
		('7-SIEBEN-SEVEN', 'Consectetur adipiscing elit ut aliquam', 6*60*1000),
		('AUCHT-8-EIGHT', 'Duis ultricies lacus sed turpis tincidunt id', 6*60*1000),
		('NINE-9-NUEN', 'Aliquet sagittis id consectetur purus', 6*60*1000),
		('ZHEN-10-TEN', 'A iaculis at erat pellentesque', 6*60*1000),
		('11-Aliquet', 'A diam maecenas sed enim. Lacinia at quis risus sed', 6*60*1000),
		('Lacinia', 'Est sit amet facilisis magna etiam', 6*60*1000),
		('Praesent', 'Praesent tristique magna sit amet purus.', 6*60*1000)

GO
SELECT * FROM [dbo].[Product]
GO


/*************************************************************************************/


INSERT INTO [dbo].[ProductionOrder] ( [id], [statusId], [productId], [quantity], [standardAsyTime])
VALUES (8, 4, (SELECT P.id FROM [dbo].[Product] P WHERE P.[number] = 'QUAM' ), 20, 20*6*60*1000),
       (7, 3, (SELECT P.id FROM [dbo].[Product] P WHERE P.[number] = 'LEO' ), 2, 2*6*60*1000),
       (6, 2, (SELECT P.id FROM [dbo].[Product] P WHERE P.[number] = 'NULLAM' ), 200, 200*6*60*1000),
       (5, 1, (SELECT P.id FROM [dbo].[Product] P WHERE P.[number] = '606-SIX-SECHS' ), 20, 20*6*60*1000),
       (4, 1, (SELECT P.id FROM [dbo].[Product] P WHERE P.[number] = 'C-THREE-PO' ), 2, 2*6*60*1000),
       (3, 1, (SELECT P.id FROM [dbo].[Product] P WHERE P.[number] = 'C-THREE-PO' ), 100, 100*6*60*1000),
       (2, 1, (SELECT P.id FROM [dbo].[Product] P WHERE P.[number] = 'AUCHT-8-EIGHT' ), 1, 6*60*1000),
       (1, 1, (SELECT P.id FROM [dbo].[Product] P WHERE P.[number] = '7-SIEBEN-SEVEN' ), 25, 25*6*60*1000)
GO

USE [Notebooks]
GO

UPDATE [dbo].[ProductionOrder]
   SET [workstationId] = 'COMPLETED SAMPLE'
      ,[workCellId] = (SELECT w.id FROM [dbo].[WorkCell] w WHERE w.name = 'HDW WORKSTATION 2' )
      ,[numberEmployees] = 1
      ,[startTime] = GETDATE()
      ,[endTime] = GETDATE()
 WHERE [id] = 8

 UPDATE [dbo].[ProductionOrder]
   SET [startTime] = DATEADD(MINUTE, -205, GETDATE())
      ,[endTime] = DATEADD(MINUTE, -30, GETDATE())
	  ,[duration] = DATEDIFF(MS,  DATEADD(MINUTE, -205, GETDATE()) , DATEADD(MINUTE, -70, GETDATE()))
 WHERE [id] = 8

 UPDATE [dbo].[ProductionOrder]
   SET [workstationId] = 'STARTED SAMPLE'
      ,[workCellId] = (SELECT w.id FROM [dbo].[WorkCell] w WHERE w.name = '52 PACK AREA 2' )
      ,[numberEmployees] = 2
      ,[startTime] = DATEADD(MINUTE, -90, GETDATE())
 WHERE [id] = 7


UPDATE [dbo].[ProductionOrder]
   SET [workstationId] = 'HELD SAMPLE'
 WHERE [id] = 6

GO

SELECT * FROM [dbo].[ProductionOrder]
GO


INSERT INTO [dbo].[PauseDetail]
           ([productionId]
           ,[reason]
           ,[startTime]
           ,[endTime]
           ,[duration])
     VALUES
           (8
           ,'BREAK'
           ,DATEADD(MINUTE, -150, GETDATE())
           ,DATEADD(MINUTE, -140, GETDATE())
           , DATEDIFF(MS,  DATEADD(MINUTE, -150, GETDATE()) , DATEADD(MINUTE, -140, GETDATE())))
          ,(8
           ,'INVENTORY'
           ,DATEADD(MINUTE, -100, GETDATE())
           ,DATEADD(MINUTE, -70, GETDATE())
           , DATEDIFF(MS,  DATEADD(MINUTE, -100, GETDATE()) , DATEADD(MINUTE, -70, GETDATE())))
GO

SELECT * FROM [dbo].[PauseDetail]
GO
