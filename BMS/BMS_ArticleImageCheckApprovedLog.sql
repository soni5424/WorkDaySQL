USE [Hartono]
GO

/****** Object:  Table [dbo].[BMS_ArticleImageCheckApprovedLog]    Script Date: 04/05/2021 10:43:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[BMS_ArticleImageCheckApprovedLog](
	[TrxID] [varchar](17) NOT NULL,
	[Article] [varchar](22) NOT NULL,
	[Status] [int] NULL,
	[StatusNote] [varchar](250) NULL,
	[StatusDate] [datetime] NOT NULL,
	[UserStatus] [varchar](20) NULL,
 CONSTRAINT [PK_BMS_ArticleImageCheckApprovedLog] PRIMARY KEY CLUSTERED 
(
	[TrxID] ASC,
	[Article] ASC,
	[StatusDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

