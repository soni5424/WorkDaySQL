use hartono
declare @NameArticle varchar(50)
set @NameArticle = 'MyPOSUser'

if (exists(select * from sys.tables where is_replicated = 1 and name=@NameArticle)) 
begin
	Declare @T Table (
		articleid varchar(100) NULL, 
		articlename varchar(100) NULL, 
		baseobject varchar(100) NULL,
		destinationobject varchar(100) NULL,
		synchronizationobject varchar(100) NULL,
		type varchar(100) NULL,
		status varchar(100) NULL,
		filter varchar(100) NULL,
		description varchar(100) NULL,
		insert_command varchar(100) NULL,
		update_command varchar(100) NULL,
		delete_command varchar(100) NULL,
		creationscriptpath varchar(100) NULL,
		verticalpartition varchar(100) NULL,
		pre_creation_cmd varchar(100) NULL,
		filter_clause varchar(100) NULL,
		schema_option varchar(100) NULL,
		dest_owner varchar(100) NULL,
		source_owner varchar(100) NULL,
		unqua_source_object varchar(100) NULL,
		sync_object_owner varchar(100) NULL,
		unqualified_sync_object varchar(100) NULL,
		filter_owner varchar(100) NULL,
		unqua_filter varchar(100) NULL,
		auto_identity_range varchar(100) NULL,
		publisher_identity_range varchar(100) NULL,
		identity_range varchar(100) NULL,
		threshold varchar(100) NULL,
		identityrangemanagementoption varchar(100) NULL,
		fire_triggers_on_snapshot varchar(100) NULL);

	DECLARE @ReplicationName as varchar(100);
	DECLARE @ReplicationCursor as CURSOR;
	SET @ReplicationCursor = CURSOR FOR
	SELECT name from syspublications
 
	OPEN @ReplicationCursor;
	FETCH NEXT FROM @ReplicationCursor INTO @ReplicationName;
 
	WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN TRY
			Insert @T EXEC sp_helparticle @ReplicationName, @NameArticle
			if (exists (Select * from @T))
				Select @ReplicationName As NamaReplicationYgDicari, @NameArticle AS NamaTableYgDicari from @T
		END TRY
		BEGIN CATCH
			-- Handle the error here
		END CATCH
		FETCH NEXT FROM @ReplicationCursor INTO @ReplicationName;
	END
 
	CLOSE @ReplicationCursor;
	DEALLOCATE @ReplicationCursor;	

end
else
	select 'Table '+@NameArticle+' Tidak ada Replication'