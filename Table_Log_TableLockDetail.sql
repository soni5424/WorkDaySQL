USE [Hartono]
GO

/****** Object:  Table [dbo].[Log_TableLockDetail]    Script Date: 09/21/2020 16:32:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Log_TableLockDetail](
	[resource_type] [varchar](100) NULL,
	[requested_object_name] [varchar](100) NULL,
	[request_mode] [varchar](10) NULL,
	[request_status] [varchar](50) NULL,
	[TEXT] [varchar](max) NULL,
	[spid] [varchar](10) NULL,
	[blocked] [varchar](10) NULL,
	[status] [varchar](50) NULL,
	[loginame] [varchar](20) NULL,
	[created_at] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

