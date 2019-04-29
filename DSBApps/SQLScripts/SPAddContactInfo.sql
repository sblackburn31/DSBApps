
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[addContactInfo]    Script Date: 3/17/2019 ******/
IF OBJECT_ID ( 'addContactInfo', 'P' ) IS NOT NULL  
	DROP PROCEDURE [dbo].[addContactInfo]
GO

-- =============================================
-- Author:		David Blackburn	
-- Create date: 3/17/2019
-- Description:	Adds Contact Information usage to the ContactInfo table
-- =============================================
CREATE PROCEDURE dbo.addContactInfo 
	-- Add the parameters for the stored procedure here
CREATE PROCEDURE dbo.addContactInfo 
	-- Add the parameters for the stored procedure here
	@Pname  nvarchar(50),
	@Pemail nvarchar(50),
	@Pcomment nvarchar(256),
	@PvisitorType nvarchar(20),
	@Pwho nvarchar(30),
	@Prating bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

INSERT INTO [dbo].[Contact]
           ([Name]
           ,[Email]
           ,[VisitorType]
           ,[Comment]
           ,[Who]
           ,[Rating]
           ,[Actual]
           ,[Created])
     VALUES
           (@Pname
           ,@Pemail
           ,@PvisitorType
           ,@Pcomment
           ,@Pwho
           ,@Prating
           ,1
		   ,GETDATE())

END
GO