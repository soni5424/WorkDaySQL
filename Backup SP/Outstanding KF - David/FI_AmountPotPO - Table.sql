USE [Hartono]
GO

/****** Object:  Table [dbo].[FI_AmountPotPO]    Script Date: 11/05/2020 13.44.14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FI_AmountPotPO](
	[PONo] [varchar](10) NOT NULL,
	[Assignment] [varchar](18) NOT NULL,
	[DocAmount] [decimal](18, 0) NULL,
 CONSTRAINT [PK_FI_AmountPotPO] PRIMARY KEY CLUSTERED 
(
	[PONo] ASC,
	[Assignment] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

