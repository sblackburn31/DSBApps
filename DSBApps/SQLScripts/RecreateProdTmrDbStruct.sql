USE [dsbburndev]
GO

/**** Drop related tables ****/
DROP TABLE [dbo].[PauseUnassigned]
DROP TABLE [dbo].[PauseDetail];
DROP TABLE [dbo].[ProductionOrder];
DROP TABLE [dbo].[ProductionStatus];
DROP TABLE [dbo].[Product];
DROP TABLE [dbo].[WorkCell];
DROP TABLE [dbo].[WorkArea];
DROP TABLE [dbo].[Contact];
DROP TABLE [dbo].[Tracking];
DROP TABLE [dbo].[ReportHistory]
GO

/****** Object:  Table [dbo].[WorkCell]    Script Date: 12/26/2018 10:43:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkCell](
	[id] [int]  IDENTITY(1,1) NOT NULL,
	[name] [varchar](20) NOT NULL,
	[workAreaId] [int] NOT NULL,
 CONSTRAINT [PK_WorkCell] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_WorkCell] UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 12/26/2018 10:43:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[id] [int]  IDENTITY(1,1) NOT NULL,
	[number] [varchar](20) NOT NULL,
	[description] [varchar](100) NOT NULL,
	[stadardAsyTime] int NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Product] UNIQUE NONCLUSTERED 
(
	[number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductionStatus]    Script Date: 12/26/2018 10:43:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductionStatus](
	[id] [int] NOT NULL,
	[Status] [varchar](10) NOT NULL,
 CONSTRAINT [PK_ProductinStatus] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductionOrder]    Script Date: 12/26/2018 10:43:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductionOrder](
	[id] [bigint]  NOT NULL,
	[statusId] [int] NOT NULL,
	[productId] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[standardAsyTime] int NOT NULL,
	[workstationId] [char](19) NULL,
	[workCellId] [int] NULL,
	[numberEmployees] [int] NULL,
	[startTime] [datetime2](7) NULL,
	[endTime] [datetime2](7) NULL,
	[duration] int NULL,
 CONSTRAINT [PK_ProductionOrder] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PauseDetail]    Script Date: 12/26/2018 10:43:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PauseDetail](
	[id] [bigint]  IDENTITY(1,1) NOT NULL,
	[productionId] [bigint] NOT NULL,
	[reason] [varchar](15) NOT NULL,
	[startTime] [datetime2](7) NOT NULL,
	[endTime] [datetime2](7) NULL,
	[duration] int NULL,
 CONSTRAINT [PK_PauseDetail] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkArea]    Script Date: 12/26/2018 10:43:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkArea](
	[id] [int]  IDENTITY(1,1)  NOT NULL,
	[name] [varchar](20) NOT NULL,
 CONSTRAINT [PK_WorkArea] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_WorkArea] UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Object:  Table [dbo].[PauseUnassigned]    Script Date: 12/29/2018 9:57:30 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PauseUnassigned](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[workstationId] [char](19) NOT NULL,
	[reason] [varchar](15) NOT NULL,
	[startTime] [datetime2](7) NOT NULL,
	[endTime] [datetime2](7) NULL,
	[duration] [int] NULL,
 CONSTRAINT [PK_PauseUnassigned] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Tracking] (
    [place]  NVARCHAR (20) NOT NULL,
    [who]    NVARCHAR (30) NOT NULL,
    [whenTS] DATETIME2 (7) NOT NULL
);
GO

/****** Object:  Table [dbo].[ContactInfo]    Script Date: 3/17/2019 11:35:34 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Contact](
	[ContactId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[VisitorType] [nvarchar](30) NULL,
	[Comment] [nvarchar](254) NULL,
	[Who] [nvarchar](50) NULL,
	[Rating] [smallint] NULL,
	[Actual] [bit] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Contact] PRIMARY KEY CLUSTERED 
(
	[ContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ReportHistory]    Script Date: 3/23/2019 2:36:10 PM ******/

CREATE TABLE [dbo].[ReportHistory](
	[DateRun] [datetime2](7) NOT NULL,
	[FromDate] [datetime2](7) NOT NULL,
	[ToDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ReportHistory] PRIMARY KEY CLUSTERED 
(
	[DateRun] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PauseDetail]  WITH CHECK ADD  CONSTRAINT [FK_PauseDetail_ProductionOrder] FOREIGN KEY([productionId])
REFERENCES [dbo].[ProductionOrder] ([id])
GO
ALTER TABLE [dbo].[PauseDetail] CHECK CONSTRAINT [FK_PauseDetail_ProductionOrder]
GO
ALTER TABLE [dbo].[ProductionOrder]  WITH CHECK ADD  CONSTRAINT [FK_ProductionOrder_Product] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
ALTER TABLE [dbo].[ProductionOrder] CHECK CONSTRAINT [FK_ProductionOrder_Product]
GO
ALTER TABLE [dbo].[ProductionOrder]  WITH CHECK ADD  CONSTRAINT [FK_ProductionOrder_ProductinStatus] FOREIGN KEY([statusId])
REFERENCES [dbo].[ProductionStatus] ([id])
GO
ALTER TABLE [dbo].[ProductionOrder] CHECK CONSTRAINT [FK_ProductionOrder_ProductinStatus]
GO
ALTER TABLE [dbo].[ProductionOrder]  WITH CHECK ADD  CONSTRAINT [FK_ProductionOrder_WorkCell] FOREIGN KEY([workCellId])
REFERENCES [dbo].[WorkCell] ([id])
GO
ALTER TABLE [dbo].[ProductionOrder] CHECK CONSTRAINT [FK_ProductionOrder_WorkCell]
GO
ALTER TABLE [dbo].[WorkCell]  WITH CHECK ADD  CONSTRAINT [FK_WorkCell_WorkArea] FOREIGN KEY([workAreaId])
REFERENCES [dbo].[WorkArea] ([id])
GO
ALTER TABLE [dbo].[WorkCell] CHECK CONSTRAINT [FK_WorkCell_WorkArea]
GO



/****** Object:  View [dbo].[ProdOrdInfo]    Script Date: 12/27/2018 11:02:58 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ( '[dbo].[vProdOrdInfo]', 'V' ) IS NOT NULL 
	DROP VIEW [dbo].[vProdOrdInfo];
GO

CREATE VIEW [dbo].[vProdOrdInfo]
AS
SELECT        dbo.ProductionOrder.id AS productionId, 
                         dbo.ProductionStatus.Status AS status, 
						 dbo.ProductionOrder.[statusId],
						 dbo.Product.number AS productNumber, 
						 dbo.Product.description,
						 dbo.Product.[stadardAsyTime],
						 dbo.ProductionOrder.quantity, 
						 dbo.ProductionOrder.workstationId, 
                         dbo.WorkCell.name AS workCell, dbo.ProductionOrder.numberEmployees, dbo.ProductionOrder.startTime, dbo.ProductionOrder.endTime,
						 dbo.ProductionOrder.duration
FROM            dbo.ProductionOrder INNER JOIN
                         dbo.ProductionStatus ON dbo.ProductionOrder.statusId = dbo.ProductionStatus.id INNER JOIN
                         dbo.Product ON dbo.ProductionOrder.productId = dbo.Product.id LEFT OUTER JOIN
                         dbo.WorkCell ON dbo.ProductionOrder.workCellId = dbo.WorkCell.id
GO

