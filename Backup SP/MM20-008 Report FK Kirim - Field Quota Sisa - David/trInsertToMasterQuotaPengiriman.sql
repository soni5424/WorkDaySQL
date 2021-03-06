USE [Hartono]
GO
/****** Object:  Trigger [dbo].[trInsertToMasterQuotaPengiriman]    Script Date: 24/08/2020 08.42.14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author               : Soni Gunawan
-- Modified Date        : 23.9.15
-- Description          : Pengurangan Quota, sudah tidak menggunakan SO, tetapi menggunakan KubikasiBarang
--                        Inserted, berarti Data sudah masuk ke Tabel TrxFaktur
--
-- Modified Date        : 12.1.16
-- Description          : Update Log Quota

-- Modified Date        : 11.4.16
-- Description          : Trigger di ganti yang 
--						  asal statuspenyerahan menjadi grouppengiriman

-- Author				: Ferry Hartono
-- Modified Date        : 17.3.20
-- Description          : Tambah filter group pengiriman '10'

-- =============================================

ALTER TRIGGER [dbo].[trInsertToMasterQuotaPengiriman]
   ON  [dbo].[TrxFaktur]
      FOR INSERT
AS 
BEGIN
      DECLARE @NoFaktur                   varchar(18),
                  @GroupPengiriman        varchar(50),
                  @tglPengiriman          datetime,
                  @tempTanggal            datetime,
                  @KodeStore              varchar(4),
                  @NoSo                   varchar(50)

      SELECT 
            @NoFaktur=a.Nofaktur,
            @GroupPengiriman=a.GroupPengiriman,
            @tglPengiriman=a.TglPengiriman,
            @NoSo=a.NoSO
      FROM 
            Inserted a
      WHERE
            a.isperlengkapan=0 
            AND a.grouppengiriman='01' or a.grouppengiriman='10'
            AND tglPengiriman IS NOT NULL

      PRINT '-------- INIT TRIGGER QUOTA PENGIRIMAN --------'
      PRINT @NoFaktur
      PRINT @GroupPengiriman
      PRINT @tglPengiriman
      PRINT @NoSo

      declare @countNoSO      int

      SELECT @countNoSo=count(*) FROM TrxFaktur WHERE NoSO=@NoSo
      PRINT @countNoSo

      SELECT @KodeStore=KodeStoreDEPO FROM TrxSOKirim WHERE NoSO=@NoSO
      print @KodeStore

            IF (@KodeStore IS NOT NULL AND @CountNoSO=1 ) --untuk test ditutup, jgn lupa di kembalikan
            BEGIN
                        DECLARE @Quota    decimal(18,2)
                        SET @Quota = 0

                        SELECT top 1
                              @Quota=isnull(Quota,0)
                        FROM
                              SetupQuotaKirimStore
                        WHERE
                              KodeStore=@KodeStore 
                              AND KodeSession=@GroupPengiriman
                        order by tanggal desc
                        print @Quota

                        DECLARE @KubikasiBarang       decimal(18,2)
                        SELECT @KubikasiBarang=isnull(KubikasiBarang,0) from TrxSOKirim where NoSO=@NoSO
                        print @KubikasiBarang
                        
                        SELECT @tempTanggal=dbo.getonlydate(@tglPengiriman)
                        print @tempTanggal

                        IF (EXISTS(SELECT * FROM MasterQuotaPengirimanStore WHERE KodeStore=@KodeStore AND KodeSession=@GroupPengiriman AND  @tempTanggal= dbo.getonlydate(tanggal)))
                        BEGIN
                              DECLARE @QuotaPengirimanAwal  decimal(18,2),
                                          @QuotaSisaAwal                decimal(18,2)

                              SELECT 
                                    @QuotaPengirimanAwal=isnull(QuotaPengiriman,0),
                                    @QuotaSisaAwal=isnull(QuotaSisa,0)
                              FROM 
                                    MasterQuotaPengirimanStore
                              WHERE
                                    KodeStore=@KodeStore AND
                                    KodeSession=@GroupPengiriman AND
                                    CONVERT(VARCHAR(10), tanggal, 101)=@tempTanggal

                              print '-------- UPDATE QUOTA --------'
                              UPDATE MasterQuotaPengirimanStore 
                              SET QuotaPengiriman=@QuotaPengirimanAwal+(CAST (@KubikasiBarang AS FLOAT)), 
                                    QuotaSisa=@QuotaSisaAwal-(CAST (@KubikasiBarang AS FLOAT))
                              WHERE 
                                    KodeStore=@KodeStore AND 
                                    KodeSession=@GroupPengiriman AND 
                                    @TempTanggal=CONVERT(VARCHAR(10), tanggal, 101)

                              print '-------- UPDATE LOG --------'
                              INSERT INTO [Hartono].[dbo].[LogQuota]
                                 ([KodeStore]
                                 ,[KodeSessionJenis]
                                 ,[Tanggal]
                                 ,[Quota]
                                 ,[QuotaPakai]
                                 ,[QuotaSisa]
                                 ,[TanggalSimpan]
                                 ,[NoFaktur]
                                 ,[Keterangan])
                               VALUES (
                                    @KodeStore,
                                    @GroupPengiriman,
                                    @tglPengiriman,
                                    isnull(@QuotaSisaAwal,0),
                                    (CAST (isnull(@KubikasiBarang,0) AS FLOAT)),
                                    isnull(@QuotaSisaAwal,0)-(CAST (@KubikasiBarang AS FLOAT)),
                                    getdate(),
                                    @NoFaktur,
                                    'UPDATE Pengiriman')
                              
                        END
                        ELSE
                        begin
                              print '-------- INSERT --------'
                              INSERT INTO MasterQuotaPengirimanStore 
                              VALUES (
                                    @KodeStore, 
                                    @GroupPengiriman, 
                                    @tglPengiriman, 
                                    isnull(@Quota,0), 
                                    (CAST (isnull(@KubikasiBarang,0) AS FLOAT)), 
                                    isnull(@Quota,0)-(CAST (@KubikasiBarang AS FLOAT)))

                              print '-------- SAVE LOG --------'
                              INSERT INTO [Hartono].[dbo].[LogQuota]
                                 ([KodeStore]
                                 ,[KodeSessionJenis]
                                 ,[Tanggal]
                                 ,[Quota]
                                 ,[QuotaPakai]
                                 ,[QuotaSisa]
                                 ,[TanggalSimpan]
                                 ,[NoFaktur]
                                 ,[Keterangan])
                               VALUES (
                                    @KodeStore,
                                    @GroupPengiriman,
                                    @tglPengiriman,
                                    isnull(@Quota,0),
                                    (CAST (isnull(@KubikasiBarang,0) AS FLOAT)),
                                    isnull(@Quota,0)-(CAST (@KubikasiBarang AS FLOAT)),
                                    getdate(),
                                    @NoFaktur,
                                    'INSERT Pengiriman')
                        end

            END
      print '-------- END TRIGGER QUOTA PENGIRIMAN --------'
END

