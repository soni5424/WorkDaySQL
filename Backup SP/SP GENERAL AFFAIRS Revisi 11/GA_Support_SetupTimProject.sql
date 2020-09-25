USE [Hartono]
GO

/****** Object:  Table [dbo].[GA_Support_SetupTimProject]    Script Date: 15/06/2020 8:30:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GA_Support_SetupTimProject](
	[EmployeeID] [varchar](20) NOT NULL,
	[NamaUser] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

