-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
IF OBJECT_ID (N'dbo.obfuscateEmail', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.obfuscateEmail;  
GO  
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION dbo.obfuscateEmail
(
	-- Add the parameters for the function here
	@EmailVal nvarchar(50)
)
RETURNS nvarchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @pos int;
	DECLARE @rval nvarchar(50);
	SET @pos = CHARINDEX('@', @EmailVal, 1);
	IF (@pos = 0)   
	BEGIN
        SET @pos = LEN(@EmailVal);
		SET @rval = STUFF(@EmailVal, 1, @pos, REPLICATE('x', @pos));
	END
	ELSE
	BEGIN
		SET @rval = STUFF(@EmailVal, 1, @pos - 1, REPLICATE('x', @pos - 1));
	END
	-- Return the result of the function
	RETURN @rval

END
GO

