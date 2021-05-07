USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PCekProsesPID]    Script Date: 04/22/2021 11:02:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER        PROCEDURE [dbo].[PCekProsesPID]
(
    @NoPID  varchar(50)
)
AS
 if exists( select * from PIDScan where PID=@NoPID)
 begin
	 if exists( select * from PIDStock where PID=@NoPID)
		begin
			 if exists( select * from PIDSNEsto where PID=@NoPID)
				 begin
					select 'SUKSES'
				 end
			 else
			select 'Harap Upload Hasil Scanner, Report Stock per PID, Report SN ESTO Edele Esto/Site, Telah Berhasil Diinput. Silahkan Cek Report untuk Memastikan Data berhasil Diupload'
		end
     else
	select 'Harap Upload Hasil Scanner, Report Stock per PID, Report SN ESTO Edele Esto/Site, Telah Berhasil Diinput. Silahkan Cek Report untuk Memastikan Data berhasil Diupload'
 end
 else
  select 'Harap Upload Hasil Scanner, Report Stock per PID, Report SN ESTO Edele Esto/Site, Telah Berhasil Diinput. Silahkan Cek Report untuk Memastikan Data berhasil Diupload'

GO

