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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		David Scott Blackburn
-- Create date: 12/28/18
-- Description:	Coverts an entered Prodction Id to an Id that is used by the system.
--              The Id used by the system is the REMAINDER of dividing the ID by 9.
-- =============================================
CREATE FUNCTION dbo.convertId
(	
	-- Add the parameters for the function here
	@RawProductionId int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar int

	-- Add the T-SQL statements to compute the return value here
	SET @ResultVar = @RawProductionId % 9
	IF @ResultVar = 0
		SET @ResultVar = 9

	-- Return the result of the function
	RETURN @ResultVar

END
GO

