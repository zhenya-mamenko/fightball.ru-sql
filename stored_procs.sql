USE [fightball.pro]
GO

/****** Object:  StoredProcedure [dbo].[sp_awards_insert]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_awards_insert] (
  @award_id int OUTPUT,
  @tour_id int,
  @user_id int,
  @award_type tinyint, /* 0 - кубок, 1 - орден, 2 - медаль */
  @award_subtype tinyint,
  @award_description varchar(100),
  @date_achieve smalldatetime
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    if @award_id is null select @award_id = isnull(max([award_id]), 0)+1 from awards
    insert
      into
        awards
      (
        [award_id],
        [tour_id],
        [user_id],
        [award_type],
        [award_subtype],
        [award_description],
        [date_achieve],
        [date_lost]
      ) 
      values
      (
        @award_id,
        @tour_id,
        @user_id,
        @award_type,
        @award_subtype,
        @award_description,
        @date_achieve,
        null
      )

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [insert into awards]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end

GO

/****** Object:  StoredProcedure [dbo].[sp_awards_update]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_awards_update] (
  @award_id int,
  @tour_id int = null,
  @user_id int = null,
  @award_type tinyint = null, /* 0 - кубок, 1 - орден, 2 - медаль */
  @award_subtype tinyint = null,
  @award_description varchar(100) = null,
  @date_achieve smalldatetime = null,
  @date_lost smalldatetime = null
)
AS
begin
  SET NOCOUNT ON

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    update
        awards
      set
        [tour_id] = case when @tour_id is null then [tour_id] else @tour_id end,       
        [user_id] = case when @user_id is null then [user_id] else @user_id end,       
        [award_type] = case when @award_type is null then [award_type] else @award_type end,       
        [award_subtype] = case when @award_subtype is null then [award_subtype] else @award_subtype end,       
        [award_description] = case when @award_description is null then [award_description] else @award_description end,       
        [date_achieve] = case when @date_achieve is null then [date_achieve] else @date_achieve end,       
        [date_lost] = case when @date_lost is null then [date_lost] else @date_lost end
      where
        ([award_id] = @award_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [update awards]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end

end

GO

/****** Object:  StoredProcedure [dbo].[sp_check_users_license]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_check_users_license] 
AS
begin
  SET NOCOUNT ON
  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    update
        users
      set
        [license_type] = 0
      where
        ([license_expired] < getdate())

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [update users]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end

end

GO

/****** Object:  StoredProcedure [dbo].[sp_config_values_insert]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_config_values_insert] (
  @user_id int,
  @config varchar(50),
  @value varchar(100)
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    insert
      into
        config_values
      (
        [user_id],
        [config],
        [value]
      ) 
      values
      (
        @user_id,
        @config,
        @value
      )

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [insert into config_values]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end

GO

/****** Object:  StoredProcedure [dbo].[sp_config_values_set]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_config_values_set] (
  @user_id int,
  @config varchar(50),
  @value varchar(100)
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  if exists(select * from config_values where [user_id] = @user_id and [config] = @config)
  begin
    exec sp_config_values_update @user_id, @config, @value
  end
  else
  begin
    exec sp_config_values_insert @user_id, @config, @value
  end

end

GO

/****** Object:  StoredProcedure [dbo].[sp_config_values_update]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_config_values_update] (
  @user_id int,
  @config varchar(50),
  @value varchar(100) = null
)
AS
begin
  SET NOCOUNT ON

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    update
        config_values
      set
        [value] = case when @value is null then [value] else @value end
      where
        ([user_id] = @user_id) and ([config] = @config)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [update config_values]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end

end

GO

/****** Object:  StoredProcedure [dbo].[sp_copy_user]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_copy_user] (
  @user_id int OUTPUT,
  @current_user_id int 
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
      if @user_id is null select @user_id = isnull(max([user_id]), 0)+1 from users
      insert
        into
          users
        (
          [user_id],
          [uid],
          [club_id],
          [user_rating],
          [user_exp],
          [user_rank],
          [license_type],
          [license_expired]
        ) 
        select
          @user_id,  
          [uid],
          [club_id],
          1200,
          0,
          0,
          [license_type],
          [license_expired]
        from users where [user_id] = @current_user_id
    
    update
      users
    set
      is_deleted = 1, is_rated = 0 where [user_id] = @current_user_id
      
    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [insert into users]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end


GO

/****** Object:  StoredProcedure [dbo].[sp_create_pairs]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_create_pairs] (
  @tour_id int
)
AS
begin
  set nocount on
  
  begin tran
  
  create table #tmp ([user_id] int, club_id	smallint, rating int, rival_id int, rating_min int, rating_max int, 
    challenge_club_id	smallint, challenge_user_id	int, cnt int, mask int, license_type tinyint)
  create clustered index tmp_cl on #tmp (license_type desc, rating desc, [user_id])
  create unique index tmp_id on #tmp ([user_id])
  
  insert into #tmp
    select u.user_id, u.club_id, u.user_rating as rating, r.rival_id, rating_min, rating_max, r.club_id as challenge_club_id, challenge_user_id,
      (select count(*) from stakes s where s.user_id = u.user_id and s.match_id in (select match_id from matches where tour_id = @tour_id )) as cnt,
      dbo.fn_get_stakes_mask(@tour_id, u.user_id) as mask, u.license_type
    from users u
      left outer join rivals r on r.user_id = u.user_id and r.tour_id = @tour_id 
    where u.is_deleted = 0
    order by license_type desc, rating desc, u.[user_id]

  delete from #tmp where cnt <> 12

  declare @user_id int, @rival_id int, @rating int, @rating_min int, @rating_max int, @club_id smallint, 
    @challenge_club_id smallint, @challenge_user_id int, @mask int, @license_type tinyint
    
  declare c cursor fast_forward read_only for
    select user_id, rival_id, challenge_user_id
      from #tmp t
      where (challenge_user_id is not null) and 
        exists(select * from #tmp where user_id = t.challenge_user_id and (rival_id is null or rival_id = t.user_id) and 
        dbo.fn_get_stakes_diff(mask ^ t.mask) <> 0)
      order by license_type desc, rating desc, [user_id] 
  open c
  fetch next from c into @user_id, @rival_id, @challenge_user_id
  while @@fetch_status = 0
  begin
    if (@rival_id is null)
    begin
      set @rival_id = @challenge_user_id
      update #tmp set rival_id = @rival_id where user_id = @user_id
      update #tmp set rival_id = @user_id where user_id = @rival_id
    end
    fetch next from c into @user_id, @rival_id, @challenge_user_id
  end
  close c
  deallocate c
    
  declare c cursor fast_forward for
    select user_id, club_id, rating, rival_id, rating_min, rating_max, challenge_club_id, challenge_user_id, mask
      from #tmp order by license_type desc, rating desc, [user_id] 
  open c
  fetch next from c into @user_id, @club_id, @rating, @rival_id, @rating_min, @rating_max, @challenge_club_id, @challenge_user_id, @mask
  while @@fetch_status = 0
  begin
    select @rival_id = rival_id from #tmp where [user_id] = @user_id    
    if (@rival_id is null)
    begin
      if (@rating_min is null) set @rating_min = 0
      if (@rating_max is null) set @rating_max = 1000000

      if (@challenge_club_id is not null)
      begin
        if exists(select * from #tmp where rival_id is null and club_id = @challenge_club_id and user_id <> @user_id and dbo.fn_get_stakes_diff(@mask ^ dbo.fn_get_stakes_mask(@tour_id, user_id)) <> 0)
        begin
          set @rival_id = (select top 1 user_id from #tmp where rival_id is null and club_id = @challenge_club_id and user_id <> @user_id 
            order by (
              (case when isnull(challenge_club_id, 0) = @club_id then 1 when isnull(challenge_club_id, 0) <> 0 then -1 else 0 end) +
              (case when isnull(rating, 0) >= @rating_min then 1 else -1 end) + (case when isnull(@rating, 0) >= isnull(rating_min, 0) then 1 else -1 end) +
              (case when rating is not null and rating < @rating_min then -1 else 0 end) + (case when @rating is not null and rating_min is not null and @rating < rating_min then -1 else 0 end) +
              (case when isnull(rating, 1000000) <= @rating_max then 1 else -1 end) + (case when isnull(@rating, 1000000) <= isnull(rating_max, 1000000) then 1 else -1 end) +
              (case when rating is not null and rating > @rating_max then -1 else 0 end) + (case when @rating is not null and rating_max is not null and @rating > rating_max then -1 else 0 end) +
              dbo.fn_get_stakes_diff(@mask ^ mask)*0.1
              ) desc, 
              rating desc)
        end
      end
      
      if (@rival_id is null)
      begin
        set @rival_id = (select top 1 user_id from #tmp where rival_id is null and user_id <> @user_id and dbo.fn_get_stakes_diff(@mask ^ dbo.fn_get_stakes_mask(@tour_id, user_id)) <> 0
          order by (
            (case when isnull(challenge_club_id, 0) = @club_id then 1 when isnull(challenge_club_id, 0) <> 0 then -1 else 0 end) +
            (case when isnull(rating, 0) >= @rating_min then 2 else 0 end) + (case when isnull(rating, 0) >= 0.9*@rating_min then 1 else -1 end) +
            (case when isnull(@rating, 0) >= isnull(rating_min, 0) then 2 else 0 end) + (case when isnull(@rating, 0) >= 0.9*isnull(rating_min, 0) then 1 else -1 end) +
            (case when rating is not null and rating < @rating_min then -1 else 0 end) + (case when @rating is not null and rating_min is not null and @rating < rating_min then -1 else 0 end) +
            (case when isnull(rating, 1000000) <= @rating_max then 2 else 0 end) + (case when isnull(rating, 1000000) <= 1.1*@rating_max then 1 else -1 end) +
            (case when isnull(@rating, 1000000) <= isnull(rating_max, 1000000) then 2 else 0 end) + (case when isnull(@rating, 1000000) <= 1.1*isnull(rating_max, 1000000) then 1 else -1 end) +
            (case when rating is not null and rating > @rating_max then -1 else 0 end) + (case when @rating is not null and rating_max is not null and @rating > rating_max then -1 else 0 end) +
            dbo.fn_get_stakes_diff(@mask ^ mask)*0.1
            ) desc, 
            rating desc)
      end
      if (@rival_id is not null)
      begin
        update #tmp set rival_id = @rival_id where user_id = @user_id
        update #tmp set rival_id = @user_id where user_id = @rival_id
      end  
    end
    fetch next from c into @user_id, @club_id, @rating, @rival_id, @rating_min, @rating_max, @challenge_club_id, @challenge_user_id, @mask
  end

  close c
  deallocate c


  declare @robot_id int
  select @robot_id = isnull(min(robot_id), 0)-1 from robots

  declare c cursor fast_forward read_only for
    select user_id, rating
      from #tmp where rival_id is null
  open c
  fetch next from c into @user_id, @rating
  while @@fetch_status = 0
  begin
    insert into robots values (@robot_id, @rating)
    update #tmp set rival_id = @robot_id where user_id = @user_id
    fetch next from c into @user_id, @rating
    set @robot_id = @robot_id - 1
  end
  close c
  deallocate c

  declare c cursor fast_forward read_only for
    select user_id, rival_id from #tmp
  open c
  fetch next from c into @user_id, @rival_id
  while @@fetch_status = 0
  begin
    exec sp_rivals_set_rival @tour_id, @user_id, @rival_id
    fetch next from c into @user_id, @rival_id
  end
  close c
  deallocate c

  drop table #tmp

  commit tran

end

GO

/****** Object:  StoredProcedure [dbo].[sp_dont_show_result]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_dont_show_result] (
  @uid bigint
  )
AS
begin
  SET NOCOUNT ON
  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    update
        users
      set
        [is_show_result] = 0
      where
        ([uid] = @uid)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [update users]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end

end


GO

/****** Object:  StoredProcedure [dbo].[sp_get_matches]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_get_matches] (
  @tour_id int
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  create table #tmp (num tinyint, primary key (num))
  declare @i int
  set @i = 0
  while (@i < 12)
  begin
    set @i = @i + 1
    insert into #tmp values (@i)
  end
  select t.num as order_num, isnull(m.match_id, 0) as match_id, isnull(m.club1_name + ' &mdash; ' + m.club2_name, '') as description
    from #tmp t
    left outer join vw_matches m on t.num = m.order_num and m.tour_id = @tour_id
  drop table #tmp
end

GO

/****** Object:  StoredProcedure [dbo].[sp_get_pivot_table]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_get_pivot_table] (
  @tour_id int
)
as
begin
  set nocount on
  select u.user_id, 0 as pair, u.uid, r.rating-r.rating_delta as old_rating, r.rating, r.chup_count, r.rival_chup, r.win, r.lose, r.psp, 
  ri.rival_id, '------------' as stakes, 
  (case when u.license_type = 0 then 'Любитель' when u.license_type = 1 then 'Про' when u.license_type = 2 then 'Премиум' end) + ', до '+u.license_expired_text as license_type, 
  c.club_name
  into #tmp
  from tours_results r
  inner join rivals ri on ri.user_id=r.user_id and ri.tour_id = r.tour_id
  inner join vw_users u on u.user_id=r.user_id
  inner join clubs c on u.club_id=c.club_id
  where r.tour_id = @tour_id and r.stakes_count <> 0

  declare @pair int, @u int, @r int, @p int, @s varchar(12)
  set @pair = 1

  declare c cursor fast_forward read_only for
    select user_id, rival_id, pair from #tmp
  open c
  fetch next from c into @u, @r, @p
  while @@fetch_status = 0
  begin
    if (@p = 0)
    begin
      update #tmp set pair = @pair where user_id in (@u, @r)
      set @pair += 1
    end
    set @s = ''
    select @s += convert(varchar(1), s.stakes) 
      from stakes s 
        inner join matches m on s.match_id=m.match_id and m.tour_id=@tour_id
      where s.user_id = @u
      order by m.order_num
    update #tmp set stakes = @s where user_id = @u
    fetch next from c into @u, @r, @p
  end
  close c
  deallocate c  

  select * from #tmp order by pair, win desc, chup_count desc, rival_chup

  drop table #tmp
end
GO

/****** Object:  StoredProcedure [dbo].[sp_get_psp]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_get_psp] (
  @tour_id int,
  @user_id int
)
AS
begin
  set nocount on

  declare @psp1 float, @psp2 float, @stakes1 tinyint, @stakes2 tinyint, @user_id2 int
  set @psp1 = 0
  set @psp2 = 0
  set @stakes1 = 0
  set @stakes2 = 0
  
  select @user_id2 = rival_id from rivals where tour_id = @tour_id and [user_id] = @user_id
      
  declare @ms0 numeric(4, 1), @ms1 numeric(4, 1), @ms2 numeric(4, 1), @s1 tinyint, @s2 tinyint

  declare m cursor fast_forward read_only for
    select isnull(s.stakes, 99), isnull(s2.stakes, isnull(s3.stakes, 99)) as stakes2, m.stakes0, m.stakes1, m.stakes2
      from vw_matches m
      left outer join stakes s on s.match_id = m.match_id and s.[user_id] = @user_id
      left outer join stakes s2 on s2.match_id = m.match_id and s2.[user_id] = @user_id2
      left outer join robot_stakes s3 on s3.match_id = m.match_id and s3.[robot_id] = @user_id2
      where tour_id = @tour_id    
  open m
  fetch next from m into @s1, @s2, @ms0, @ms1, @ms2
  while (@@fetch_status = 0)
  begin

    if (@s1 <> 99)
      set @stakes1 = @stakes1 + 1
    if (@s2 <> 99)
      set @stakes2 = @stakes2 + 1

    set @psp1 = @psp1 + (case when @s1 = 0 then @ms0 when @s1 = 1 then @ms1 when @s1 = 2 then @ms2 else 0 end)
    set @psp2 = @psp2 + (case when @s2 = 0 then @ms0 when @s2 = 1 then @ms1 when @s2 = 2 then @ms2 else 0 end)
    fetch next from m into @s1, @s2, @ms0, @ms1, @ms2
  end
  
  close m
  deallocate m
    
  if (@stakes1 <> 0)
  begin
    set @psp1 = round(@psp1/@stakes1, 1)
  end
  else
  begin
    set @psp1 = 0
  end
    
  if (@stakes2 <> 0)
  begin
    set @psp2 = round(@psp2/@stakes2, 1)
  end
  else
  begin
    set @psp2 = 0
  end

  select @psp1 as psp1, @psp2 as psp2
  
end
GO

/****** Object:  StoredProcedure [dbo].[sp_get_tour_table]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_get_tour_table] (
  @tour_id int
)
as
begin
  set nocount on
  select u.user_id, 0 as pair, u.uid, u.user_rating as rating, [dbo].[fn_get_user_psp](@tour_id, u.user_id) as psp, 
  ri.rival_id, '------------' as stakes, u.license_type, c.club_name
  into #tmp
  from rivals ri
  inner join users u on u.user_id=ri.user_id
  inner join clubs c on u.club_id=c.club_id
  where ri.tour_id = @tour_id and ri.rival_id is not null

  declare @pair int, @u int, @r int, @p int, @s varchar(12)
  set @pair = 1

  declare c cursor fast_forward read_only for
    select user_id, rival_id, pair from #tmp
  open c
  fetch next from c into @u, @r, @p
  while @@fetch_status = 0
  begin
    if (@p = 0)
    begin
      update #tmp set pair = @pair where user_id in (@u, @r)
      set @pair += 1
    end
    set @s = ''
    select @s += convert(varchar(1), s.stakes) 
      from stakes s 
        inner join matches m on s.match_id=m.match_id and m.tour_id=@tour_id
      where s.user_id = @u
      order by m.order_num
    update #tmp set stakes = @s where user_id = @u
    fetch next from c into @u, @r, @p
  end
  close c
  deallocate c  

  select * from #tmp order by pair, user_id

  drop table #tmp
end
GO

/****** Object:  StoredProcedure [dbo].[sp_get_tours_stat_users]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_get_tours_stat_users] (@from smallint)
as
begin
  set nocount on
  declare @tour_id smallint, @pagesize smallint, @i smallint, @s varchar(1000)
  set @pagesize = 20
    
  create table ##result ([user_id] int, [uid] bigint,
    t1 char(1), t2 char(1), t3 char(1), t4 char(1), t5 char(1), t6 char(1), t7 char(1), 
    t8 char(1), t9 char(1), t10 char(1), t11 char(1), t12 char(1), t13 char(1), t14 char(1), 
    t15 char(1), t16 char(1), t17 char(1), t18 char(1), t19 char(1), t20 char(1), 
    primary key ([user_id]))
  alter table ##result add constraint [DF_result_t1]  default (('-')) FOR [t1]
  alter table ##result add constraint [DF_result_t2]  default (('-')) FOR [t2]
  alter table ##result add constraint [DF_result_t3]  default (('-')) FOR [t3]
  alter table ##result add constraint [DF_result_t4]  default (('-')) FOR [t4]
  alter table ##result add constraint [DF_result_t5]  default (('-')) FOR [t5]
  alter table ##result add constraint [DF_result_t6]  default (('-')) FOR [t6]
  alter table ##result add constraint [DF_result_t7]  default (('-')) FOR [t7]
  alter table ##result add constraint [DF_result_t8]  default (('-')) FOR [t8]
  alter table ##result add constraint [DF_result_t9]  default (('-')) FOR [t9]
  alter table ##result add constraint [DF_result_t10]  default (('-')) FOR [t10]
  alter table ##result add constraint [DF_result_t11]  default (('-')) FOR [t11]
  alter table ##result add constraint [DF_result_t12]  default (('-')) FOR [t12]
  alter table ##result add constraint [DF_result_t13]  default (('-')) FOR [t13]
  alter table ##result add constraint [DF_result_t14]  default (('-')) FOR [t14]
  alter table ##result add constraint [DF_result_t15]  default (('-')) FOR [t15]
  alter table ##result add constraint [DF_result_t16]  default (('-')) FOR [t16]
  alter table ##result add constraint [DF_result_t17]  default (('-')) FOR [t17]
  alter table ##result add constraint [DF_result_t18]  default (('-')) FOR [t18]
  alter table ##result add constraint [DF_result_t19]  default (('-')) FOR [t19]
  alter table ##result add constraint [DF_result_t20]  default (('-')) FOR [t20]

  insert into ##result ([user_id], [uid])
    select [user_id], [uid] 
      from users where is_deleted = 0

  declare c cursor fast_forward for
    select tour_id from tours where (tour_num >= @from) and tour_num < (@from+@pagesize)
  open c
  fetch next from c into @tour_id 
  set @i = 1
  while (@@fetch_status = 0)
  begin
    set @s = 'update ##result ' +
      'set t' + ltrim(str(@i)) + '= ' +
        'case ' +
          'when win > lose then ''W'' ' +
          'when win < lose then ''L'' ' +
          'when win = lose then ''D'' ' +
        'end ' +
      'from ##result r ' +
        'inner join vw_tours_results tr on r.[user_id] = tr.[user_id] and tr.tour_id = '+str(@tour_id)
    exec (@s)  
    fetch next from c into @tour_id
    set @i += 1
  end
  close c
  deallocate c
    
  delete from ##result
    where t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12 +t13 + t14 + t15 + t16 + t17 + t18 + t19 + t20 =
      '--------------------'
  select * from ##result

  drop table ##result
end
GO

/****** Object:  StoredProcedure [dbo].[sp_matches_details_insert]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_matches_details_insert] (
  @match_id int,
  @detail_num tinyint,
  @home_team tinyint,
  @detail_date smalldatetime,
  @place nvarchar(100),
  @tournament_name nvarchar(50),
  @score varchar(10)
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    insert
      into
        matches_details
      (
        [match_id],
        [detail_num],
        [home_team],
        [detail_date],
        [place],
        [tournament_name],
        [score]
      ) 
      values
      (
        @match_id,
        @detail_num,
        @home_team,
        @detail_date,
        @place,
        @tournament_name,
        @score
      )

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [insert into matches_details]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end

GO

/****** Object:  StoredProcedure [dbo].[sp_matches_details_update]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_matches_details_update] (
  @match_id int,
  @detail_num tinyint,
  @home_team tinyint = null,
  @detail_date smalldatetime = null,
  @place nvarchar(100) = null,
  @tournament_name nvarchar(50) = null,
  @score varchar(10) = null
)
AS
begin
  SET NOCOUNT ON

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    update
        matches_details
      set
        [home_team] = case when @home_team is null then [home_team] else @home_team end,       
        [detail_date] = case when @detail_date is null then [detail_date] else @detail_date end,       
        [place] = case when @place is null then [place] else @place end,       
        [tournament_name] = case when @tournament_name is null then [tournament_name] else @tournament_name end,       
        [score] = case when @score is null then [score] else @score end
      where
        ([match_id] = @match_id) and ([detail_num] = @detail_num)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [update matches_details]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end

end

GO

/****** Object:  StoredProcedure [dbo].[sp_matches_insert]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_matches_insert] (
  @match_id int OUTPUT,
  @tour_id int,
  @order_num tinyint,
  @match_date smalldatetime,
  @place nvarchar(100),
  @tournament_name nvarchar(50),
  @club1_id smallint,
  @club1_results varchar(10),
  @club2_id smallint,
  @club2_results varchar(10),
  @stakes0 tinyint,
  @stakes1 tinyint,
  @stakes2 tinyint,
  @score varchar(10),
  @description varchar(MAX),
  @is_finished bit
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    if @match_id is null select @match_id = isnull(max([match_id]), 0)+1 from matches
    insert
      into
        matches
      (
        [match_id],
        [tour_id],
        [order_num],
        [match_date],
        [place],
        [tournament_name],
        [club1_id],
        [club1_results],
        [club2_id],
        [club2_results],
        [stakes0],
        [stakes1],
        [stakes2],
        [score],
        [description],
        [is_finished]
      ) 
      values
      (
        @match_id,
        @tour_id,
        @order_num,
        @match_date,
        @place,
        @tournament_name,
        @club1_id,
        @club1_results,
        @club2_id,
        @club2_results,
        @stakes0,
        @stakes1,
        @stakes2,
        @score,
        @description,
        @is_finished
      )

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [insert into matches]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end

GO

/****** Object:  StoredProcedure [dbo].[sp_matches_update]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_matches_update] (
  @match_id int,
  @match_date smalldatetime = null,
  @place nvarchar(100) = null,
  @tournament_name nvarchar(50) = null,
  @club1_id smallint = null,
  @club1_results varchar(10) = null,
  @club2_id smallint = null,
  @club2_results varchar(10) = null,
  @score varchar(10) = null,
  @description varchar(MAX) = null,
  @is_finished bit = null
)
AS
begin
  SET NOCOUNT ON

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    update
        matches
      set
        [match_date] = case when @match_date is null then [match_date] else @match_date end,       
        [place] = case when @place is null then [place] else @place end,       
        [tournament_name] = case when @tournament_name is null then [tournament_name] else @tournament_name end,       
        [club1_id] = case when @club1_id is null then [club1_id] else @club1_id end,       
        [club1_results] = case when @club1_results is null then [club1_results] else @club1_results end,       
        [club2_id] = case when @club2_id is null then [club2_id] else @club2_id end,       
        [club2_results] = case when @club2_results is null then [club2_results] else @club2_results end,       
        [score] = case when @score is null then [score] else @score end,       
        [description] = case when @description is null then [description] else @description end,       
        [is_finished] = case when @is_finished is null then [is_finished] else @is_finished end
      where
        ([match_id] = @match_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [update matches]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end

end

GO

/****** Object:  StoredProcedure [dbo].[sp_orders_insert]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_orders_insert] (
  @order_id int OUTPUT,
  @user_id int,
  @vk_order_id int,
  @item varchar(50),
  @cost int,
  @tour_id int
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    if @order_id is null select @order_id = isnull(max([order_id]), 0)+1 from orders
    insert
      into
        orders
      (
        [order_id],
        [user_id],
        [vk_order_id],
        [item],
        [cost],
        [tour_id]
      ) 
      values
      (
        @order_id,
        @user_id,
        @vk_order_id,
        @item,
        @cost,
        @tour_id
      )

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [insert into orders]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end

GO

/****** Object:  StoredProcedure [dbo].[sp_process_order]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_process_order] (
  @order_id int OUTPUT,
  @user_id int,
  @vk_order_id int,
  @item varchar(50),
  @cost int,
  @tour_id int
)
AS
begin
  SET NOCOUNT ON
  
  if (not exists(select * from orders where vk_order_id = @vk_order_id))
  begin
    declare @result int
    exec @result = sp_orders_insert @order_id OUTPUT, @user_id, @vk_order_id, @item, @cost, @tour_id
    if (@result = 0)
    begin
      if (charindex('-', @item) <> 0)
        return 1
      else  
        return 0
    end
    else
    begin
      set @order_id = 0
      return 0
    end
  end
  else
  begin
    select @order_id = order_id from orders where vk_order_id = @vk_order_id
    return 0
  end

  set @order_id = 0
  return 0
end

GO

/****** Object:  StoredProcedure [dbo].[sp_rivals_get_data]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_rivals_get_data] (
  @tour_id int = null,
  @user_id int
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

    if (@tour_id is null)
    begin
      select top 1 @tour_id = tour_id from tours where getdate() between [tour_start_date] and [tour_end_date] order by tour_id
    end
    
    select [tour_id]
      ,r.[user_id]
      ,[rival_id]
      ,[new_vk_uid]
      ,[rating_min]
      ,[rating_max]
      ,r.[club_id]
      ,[challenge_user_id]
      ,c.[club_code],c.[country_code],c.[club_name],c.[country_id],
      u.[uid],
      u2.[user_id] as cid, u2.[uid] as cuid
      into #tmp
      from rivals r
        left outer join [vw_clubs] c on r.club_id = c.club_id
        left outer join [users] u on u.[user_id] = r.[challenge_user_id]
        left outer join [users] u2 on u2.[user_id] in (select user_id from rivals where challenge_user_id = r.[user_id] and tour_id=@tour_id)
      where (tour_id = @tour_id and r.[user_id] = @user_id)
        
    if not exists(select * from #tmp) and exists(select user_id from rivals where challenge_user_id = @user_id and tour_id=@tour_id)
    begin
      select @tour_id, @user_id, null, null, null, null, null, null, null, null, null, null, null, u2.[user_id] as cid, u2.[uid] as cuid 
        from [users] u2 where u2.[user_id] in (select user_id from rivals where challenge_user_id = @user_id and tour_id=@tour_id)  
    end
    else
      select * from #tmp
    drop table #tmp
    
    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [insert into rivals]', @proc_name, @proc_error 
      print @proc_message
      return convert(int, @proc_error)
    end -- if @proc_error
  
end


GO

/****** Object:  StoredProcedure [dbo].[sp_rivals_insert]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_rivals_insert] (
  @tour_id int,
  @user_id int
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    insert
      into
        rivals
      (
        [tour_id],
        [user_id]
      ) 
      values
      (
        @tour_id,
        @user_id
      )

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [insert into rivals]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end

GO

/****** Object:  StoredProcedure [dbo].[sp_rivals_set_rival]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_rivals_set_rival] (
  @tour_id int,
  @user_id int,
  @rival_id int 
)
AS
begin
  SET NOCOUNT ON

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
  
    if (not exists(select * from rivals where ([tour_id] = @tour_id) and ([user_id] = @user_id)))
    begin
      exec [sp_rivals_insert] @tour_id, @user_id
    end
    
    update
        rivals
      set
        [rival_id] = @rival_id
      where
        ([tour_id] = @tour_id) and ([user_id] = @user_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [update rivals]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end

end


GO

/****** Object:  StoredProcedure [dbo].[sp_rivals_update]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_rivals_update] (
  @tour_id int = null,
  @user_id int,
  @new_vk_uid bigint = -1,
  @rating_min int = -1,
  @rating_max int = -1,
  @club_id smallint = -1,
  @challenge_user_id int = -1
)
AS
begin
  SET NOCOUNT ON

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
  
    if (@tour_id is null)
    begin
      select top 1 @tour_id = tour_id from tours where getdate() between [tour_start_date] and [tour_end_date] order by tour_id
    end

    if (not exists(select * from rivals where ([tour_id] = @tour_id) and ([user_id] = @user_id)))
    begin
      exec [sp_rivals_insert] @tour_id, @user_id
    end
    
    if (@challenge_user_id <> -1)
    begin
      declare @license_type tinyint
      select @license_type = license_type from users where ([user_id] = @user_id)
      if (@license_type <> 2) set @challenge_user_id = -1
    end
    
    update
        rivals
      set
        [new_vk_uid] = case when @new_vk_uid = -1 then [new_vk_uid] else @new_vk_uid end,       
        [rating_min] = case when @rating_min = -1 then [rating_min] else @rating_min end,       
        [rating_max] = case when @rating_max = -1 then [rating_max] else @rating_max end,       
        [club_id] = case when @club_id = -1 then [club_id] else @club_id end,       
        [challenge_user_id] = case when @challenge_user_id = -1 then [challenge_user_id] else @challenge_user_id end
      where
        ([tour_id] = @tour_id) and ([user_id] = @user_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [update rivals]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end

end

GO

/****** Object:  StoredProcedure [dbo].[sp_send_notifications]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_send_notifications] (
  @tour_id int,
  @type varchar(20)
)
as
begin  
  set nocount on
  declare @cmd varchar(4000), @tour_num int
  select @tour_num = tour_num from tours where tour_id = @tour_id
  set @cmd = 'c:\utils\curl\bin\curl -G -s -d type='+@type+' -d m='+convert(varchar(10), @tour_num)+' http://fightball.pro/vk/aspx/notifications.aspx'
  print @cmd
  exec xp_cmdshell @cmd
end  

GO

/****** Object:  StoredProcedure [dbo].[sp_set_robots_stakes]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_set_robots_stakes] (
  @tour_id int
)
as
begin  
  set nocount on

  begin tran

  select match_id, stakes0, stakes1, stakes2,
    case 
      when stakes0 > stakes1 then 
        case when stakes0 > stakes2 then stakes0 else stakes2 end
      else
        case when stakes1 > stakes2 then stakes1 else stakes2 end
      end as stakes
    into #tmp  
    from matches
    where tour_id = @tour_id 
    order by stakes desc
    
  select match_id, stakes0, stakes1, stakes2,
    case 
      when stakes0 < stakes1 then 
        case when stakes0 < stakes2 then stakes0 else stakes2 end
      else
        case when stakes1 < stakes2 then stakes1 else stakes2 end
      end as stakes
    into #tmp2  
    from matches
    where tour_id = @tour_id and match_id not in (select top 4 match_id from #tmp)
    order by stakes desc

  select match_id, stakes0, stakes1, stakes2,
    case 
      when stakes0 > stakes1 then 
        case when stakes1 > stakes2 then stakes1 else case when stakes0 > stakes2 then stakes2 else stakes0 end end
      else
        case when stakes0 > stakes2 then stakes0 else case when stakes1 > stakes2 then stakes2 else stakes1 end  end
      end as stakes
    into #tmp3  
    from matches
    where tour_id = @tour_id  and match_id not in (select top 4 match_id from #tmp union all select top 4 match_id from #tmp2)
    order by stakes desc

  create table #matches (match_id int, stakes tinyint, primary key (match_id))
  
  insert into #matches
    select top 4 match_id, case when stakes0 = stakes then 0 when stakes1 = stakes then 1 else 2 end from #tmp 
    
  insert into #matches
    select top 4 match_id, case when stakes0 = stakes then 0 when stakes1 = stakes then 1 else 2 end from #tmp2 

  insert into #matches
    select top 4 match_id, case when stakes0 = stakes then 0 when stakes1 = stakes then 1 else 2 end from #tmp3 
  
  declare @robot_id int
  declare c cursor fast_forward read_only for
    select robot_id from robots where robot_id in (select rival_id from rivals where rival_id < 0 and tour_id = @tour_id)
  open c
  
  fetch next from c into @robot_id
  while @@fetch_status = 0
  begin
    insert into robot_stakes
      select match_id, @robot_id, stakes from #matches
    fetch next from c into @robot_id
  end
  
  close c
  deallocate c  
  
  drop table #tmp
  drop table #tmp2
  drop table #tmp3
  drop table #matches

  commit tran
end  
GO

/****** Object:  StoredProcedure [dbo].[sp_set_tour_results]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_set_tour_results] (
  @tour_id int
)
AS
begin
set nocount on
declare @k1 int, @k2 int, @user_id int, @user_id2 int,
  @delta1 int, @delta2 int, @chup1 tinyint, @chup2 tinyint, 
  @nodif1 tinyint, @nodif2 tinyint, @win1 tinyint, @win2 tinyint,
  @lose1 tinyint, @lose2 tinyint, @draw1 tinyint, @draw2 tinyint, 
  @s tinyint, @s1 tinyint, @s2 tinyint, @stakes1 tinyint, @stakes2 tinyint,
  @stronger_expectation numeric(6,4), @weaker_expectation numeric(6,4),
  @user_club_id smallint, @user_club_id2 smallint,
  @club_id smallint, @club_id2 smallint,
  @chup_count1 tinyint, @chup_count2 tinyint,
  @chup1_club tinyint, @chup2_club tinyint,
  @chup_club1 tinyint, @chup_club2 tinyint,
  @chup1_0 tinyint, @chup2_0 tinyint,
  @chup1_1 tinyint, @chup2_1 tinyint,
  @chup1_2 tinyint, @chup2_2 tinyint,
  @chup1_3 tinyint, @chup2_3 tinyint,
  @chup1_4 tinyint, @chup2_4 tinyint,
  @chup1_5 tinyint, @chup2_5 tinyint,
  @chup1_6 tinyint, @chup2_6 tinyint,
  @chup11_0 tinyint, @chup22_0 tinyint,
  @chup11_1 tinyint, @chup22_1 tinyint,
  @chup11_2 tinyint, @chup22_2 tinyint,
  @chup11_3 tinyint, @chup22_3 tinyint,
  @chup11_4 tinyint, @chup22_4 tinyint,
  @chup11_5 tinyint, @chup22_5 tinyint,
  @chup11_6 tinyint, @chup22_6 tinyint,
  @psp1 float, @psp2 float,
  @goal_max1 tinyint, @goal_max2 tinyint,
  @goal_middle1 tinyint, @goal_middle2 tinyint,
  @goal_min1 tinyint, @goal_min2 tinyint,
  @smin tinyint, @smiddle tinyint, @smax tinyint,
  @country_id tinyint

if not exists(select * from locks where lock_type in ('set_tours_results'))
begin
  insert into locks values ('set_tours_results')
end

begin tran

/*  Даём участие в рейтингах тем, кто вызвал нового соперника */

select user_id into #tmp_new from users where user_id in (
  select user_id from rivals r where tour_id = @tour_id and new_vk_uid is not null
  and rival_id = (select user_id from users u where u.uid = r.new_vk_uid and is_deleted = 0)
  ) and is_rated = 0

  update users set is_rated = 1
    where user_id in (select user_id from #tmp_new)

  drop table #tmp_new

/*  ---- Даём участие в рейтингах тем, кто вызвал нового соперника */


delete from tours_results where tour_id = @tour_id
delete from tours_clubs_results where tour_id = @tour_id

declare c cursor fast_forward read_only for
  select r.[user_id], r.rival_id, u.club_id, isnull(u2.club_id, 0) from rivals r 
    inner join users u on r.[user_id] = u.[user_id]
    left outer join users u2 on r.[rival_id] = u2.[user_id]
    where tour_id = @tour_id and isnull(rival_id, 0) <> 0
open c
fetch next from c into @user_id, @user_id2, @user_club_id, @user_club_id2

while (@@fetch_status = 0)
begin
  if (not exists(select * from tours_results where tour_id = @tour_id and [user_id] = @user_id))
  begin
    set @k1 = (select user_rating from users where [user_id] = @user_id)
    set @k2 = case when @user_id2 > 0 then
      (select user_rating from users where [user_id] = @user_id2)
    else   
      (select rating from robots where [robot_id] = @user_id2)
    end
    
    set @delta1 = 0
    set @delta2 = 0
    set @stakes1 = 0
    set @stakes2 = 0
    set @chup_count1 = 0
    set @chup1 = 0
    set @chup_count2 = 0
    set @chup2 = 0
    set @chup1_club = 0
    set @chup2_club = 0
    set @chup_club1 = 0
    set @chup_club2 = 0
    set @chup1_0 = 0
    set @chup2_0 = 0
    set @chup1_1 = 0
    set @chup2_1 = 0
    set @chup1_2 = 0
    set @chup2_2 = 0
    set @chup1_3 = 0
    set @chup2_3 = 0
    set @chup1_4 = 0
    set @chup2_4 = 0
    set @chup1_5 = 0
    set @chup2_5 = 0
    set @chup1_6 = 0
    set @chup2_6 = 0
    set @chup11_0 = 0
    set @chup11_1 = 0
    set @chup11_2 = 0
    set @chup11_3 = 0
    set @chup11_4 = 0
    set @chup11_5 = 0
    set @chup11_6 = 0
    set @chup22_0 = 0
    set @chup22_1 = 0
    set @chup22_2 = 0
    set @chup22_3 = 0
    set @chup22_4 = 0
    set @chup22_5 = 0
    set @chup22_6 = 0
    set @nodif1 = 0
    set @nodif2 = 0
    set @win1 = 0
    set @win2 = 0
    set @lose1 = 0
    set @lose2 = 0
    set @draw1 = 0
    set @draw2 = 0
    set @goal_max1 = 0
    set @goal_max2 = 0
    set @goal_middle1 = 0
    set @goal_middle2 = 0
    set @goal_min1 = 0
    set @goal_min2 = 0
    set @smin = 0
    set @smiddle = 0
    set @smax = 0
    set @psp1 = 0
    set @psp2 = 0

declare @ms0 numeric(4, 1), @ms1 numeric(4, 1), @ms2 numeric(4, 1)
    declare m cursor fast_forward read_only for
      select m.stake_result, isnull(s.stakes, 99), isnull(s2.stakes, isnull(s3.stakes, 99)) as stakes2, m.flag, m.club1_id, m.club2_id, m.stakes0, m.stakes1, m.stakes2
        from vw_matches m
        left outer join stakes s on s.match_id = m.match_id and s.[user_id] = @user_id
        left outer join stakes s2 on s2.match_id = m.match_id and s2.[user_id] = @user_id2
        left outer join robot_stakes s3 on s3.match_id = m.match_id and s3.[robot_id] = @user_id2
        where tour_id = @tour_id    
    open m
    fetch next from m into @s, @s1, @s2, @country_id, @club_id, @club_id2, @ms0, @ms1, @ms2
    while (@@fetch_status = 0)
    begin
    
      if (@s1 <> 99)
        set @stakes1 = @stakes1 + 1
      if (@s2 <> 99)
        set @stakes2 = @stakes2 + 1

      if (@ms0 >= @ms1)
      begin
        
        if (@ms0 >= @ms2)
        begin
          set @smax = 0
          if (@ms1 > @ms2)
          begin
            set @smin = 2
            set @smiddle = 1
          end  
          else  
          begin
            set @smin = 1
            set @smiddle = 2
          end
        end
        else
        begin
          set @smax = 2
          set @smin = 1
          set @smiddle = 0
        end
        
      end
      else
      begin
        
        if (@ms1 >= @ms2)
        begin
          set @smax = 1
          if (@ms2 > @ms0)
          begin
            set @smin = 0
            set @smiddle = 2
          end  
          else  
          begin
            set @smin = 2
            set @smiddle = 0
          end
        end
        else
        begin
          set @smax = 2
          set @smin = 0
          set @smiddle = 1
        end
        
      end

      
      if (@country_id = 0 or @country_id > 6) and (@s1 <> 99) set @chup11_0 = @chup11_0 + 1
      if (@country_id = 1) and (@s1 <> 99) set @chup11_1 = @chup11_1 + 1
      if (@country_id = 2) and (@s1 <> 99) set @chup11_2 = @chup11_2 + 1
      if (@country_id = 3) and (@s1 <> 99) set @chup11_3 = @chup11_3 + 1
      if (@country_id = 4) and (@s1 <> 99) set @chup11_4 = @chup11_4 + 1
      if (@country_id = 5) and (@s1 <> 99) set @chup11_5 = @chup11_5 + 1
      if (@country_id = 6) and (@s1 <> 99) set @chup11_6 = @chup11_6 + 1

      if (@country_id = 0 or @country_id > 6) and (@s2 <> 99) set @chup22_0 = @chup22_0 + 1
      if (@country_id = 1) and (@s2 <> 99) set @chup22_1 = @chup22_1 + 1
      if (@country_id = 2) and (@s2 <> 99) set @chup22_2 = @chup22_2 + 1
      if (@country_id = 3) and (@s2 <> 99) set @chup22_3 = @chup22_3 + 1
      if (@country_id = 4) and (@s2 <> 99) set @chup22_4 = @chup22_4 + 1
      if (@country_id = 5) and (@s2 <> 99) set @chup22_5 = @chup22_5 + 1
      if (@country_id = 6) and (@s2 <> 99) set @chup22_6 = @chup22_6 + 1
      
      if (@country_id > 0 and @country_id < 7) and (@s1 <> 99) set @chup_club1 = @chup_club1 + 1
      if (@country_id > 0 and @country_id < 7) and (@s2 <> 99) set @chup_club2 = @chup_club2 + 1
      
      if (@s = @s1)
      begin
        set @chup_count1 = @chup_count1 + 1
        if (@country_id > 0 and @country_id < 7) set @chup1_club = @chup1_club + 1
        if (@country_id = 0 or @country_id > 6) set @chup1_0 = @chup1_0 + 1
        if @country_id = 1 set @chup1_1 = @chup1_1 + 1
        if @country_id = 2 set @chup1_2 = @chup1_2 + 1
        if @country_id = 3 set @chup1_3 = @chup1_3 + 1
        if @country_id = 4 set @chup1_4 = @chup1_4 + 1
        if @country_id = 5 set @chup1_5 = @chup1_5 + 1
        if @country_id = 6 set @chup1_6 = @chup1_6 + 1
        if ((@s = @smax) and (@s1 <> @s2)) set @goal_max1 = @goal_max1 + 1
        if ((@s = @smiddle) and (@s1 <> @s2)) set @goal_middle1 = @goal_middle1 + 1
        if ((@s = @smin) and (@s1 <> @s2)) set @goal_min1 = @goal_min1 + 1
      end  
      
      if (@s = @s2)
      begin
        set @chup_count2 = @chup_count2 + 1
        if (@country_id > 0 and @country_id < 7) set @chup2_club = @chup2_club + 1
        if (@country_id = 0 or @country_id > 6) set @chup2_0 = @chup2_0 + 1
        if @country_id = 1 set @chup2_1 = @chup2_1 + 1
        if @country_id = 2 set @chup2_2 = @chup2_2 + 1
        if @country_id = 3 set @chup2_3 = @chup2_3 + 1
        if @country_id = 4 set @chup2_4 = @chup2_4 + 1
        if @country_id = 5 set @chup2_5 = @chup2_5 + 1
        if @country_id = 6 set @chup2_6 = @chup2_6 + 1
        if ((@s = @smax) and (@s1 <> @s2)) set @goal_max2 = @goal_max2 + 1
        if ((@s = @smiddle) and (@s1 <> @s2)) set @goal_middle2 = @goal_middle2 + 1
        if ((@s = @smin) and (@s1 <> @s2)) set @goal_min2 = @goal_min2 + 1
      end  
      
      if (@s1 = @s2)
      begin
        set @nodif1 = @nodif1 + 1
        set @nodif2 = @nodif2 + 1
      end
      else
      begin
        if (@s = @s1)
        begin
          set @win1 = @win1 + 1
          set @lose2 = @lose2 + 1
        end
        else
        if (@s = @s2)
        begin
          set @win2 = @win2 + 1
          set @lose1 = @lose1 + 1
        end
        else
        begin
          set @draw1 = @draw1 + 1
          set @draw2 = @draw2 + 1
        end  
      end
      
      set @psp1 = @psp1 + (case when @s1 = 0 then @ms0 when @s1 = 1 then @ms1 when @s1 = 2 then @ms2 else 0 end)
      set @psp2 = @psp2 + (case when @s2 = 0 then @ms0 when @s2 = 1 then @ms1 when @s2 = 2 then @ms2 else 0 end)
      
      fetch next from m into @s, @s1, @s2, @country_id, @club_id, @club_id2, @ms0, @ms1, @ms2
    end
    close m
    deallocate m
    
    declare @K float, @G float, @WE1 float, @WE2 float
    set @K = convert(float, 20)
    set @G = case when abs(convert(float, @win1)-@win2) <= 1 then 1 when abs(convert(float, @win1)-@win2) = 2 then 1.5 else (abs(convert(float, @win1)-@win2)+11)/8 end
    set @WE1 = convert(float, 1) / (power(convert(float,10), -(convert(float, @k1-@k2)/400)) + 1)
    set @WE2 = convert(float, 1) / (power(convert(float,10), -(convert(float, @k2-@k1)/400)) + 1)
    
    set @delta1 = convert(int, round(@K*@G*((case when @win1>@win2 then 1 when @win1=@win2 then 0.5 else 0 end)-@WE1), 0))
    set @delta2 = convert(int, round(@K*@G*((case when @win2>@win1 then 1 when @win1=@win2 then 0.5 else 0 end)-@WE2), 0))

    if (@stakes1 <> 0)
    begin
      set @chup1 = convert(tinyint, round(convert(float, @chup_count1)/@stakes1*100, 0))
      set @psp1 = round(@psp1/@stakes1, 1)
    end
    else
    begin
      set @psp1 = 0
    end
      
    if (@stakes2 <> 0)
    begin
      set @chup2 = convert(tinyint, round(convert(float, @chup_count2)/@stakes2*100, 0))
      set @psp2 = round(@psp2/@stakes2, 1)
    end
    else
    begin
      set @psp2 = 0
    end

    declare @seria_wins smallint, @seria_nolose smallint, @seria_nowins smallint, @seria_lose smallint

    set @seria_wins = 0
    set @seria_nolose = 0
    set @seria_nowins = 0
    set @seria_lose = 0
    
    select @seria_wins = isnull(seria_wins, 0), @seria_nolose = isnull(seria_nolose, 0), @seria_nowins = isnull(seria_nowins, 0), @seria_lose = isnull(seria_lose, 0)
      from tours_results where tour_id = @tour_id-1 and [user_id] = @user_id
    
    insert into tours_results values (@tour_id, @user_id, @chup_count1, @chup1, @chup1_club, 
      @chup1_0, @chup11_0, @chup1_1, @chup11_1, @chup1_2, @chup11_2, @chup1_3, @chup11_3, @chup1_4, @chup11_4, @chup1_5, @chup11_5, @chup1_6, @chup11_6, @chup_count2, 
      @nodif1, @win1, @lose1, @draw1, @delta1, 0, 0, 0, 0, @stakes1, 1, @psp1, @goal_max1, @goal_middle1, @goal_min1, 0, 0, 0, 0, '', 0)
    update tours_results
      set
        seria_wins = case when @stakes1 <> 0 then case when @win1 > @win2 then @seria_wins + 1 else 0 end else @seria_wins end,
        seria_nolose = case when @stakes1 <> 0 then case when @win1 >= @win2 then @seria_nolose + 1 else 0 end else @seria_nolose end,
        seria_nowins = case when @stakes1 <> 0 then case when @win1 <= @win2 then @seria_nowins + 1 else 0 end else @seria_nowins end,
        seria_lose = case when @stakes1 <> 0 then case when @win1 < @win2 then @seria_lose + 1 else 0 end else @seria_lose end
      where tour_id = @tour_id and [user_id] = @user_id

    if (@user_id2 > 0)
    begin
      set @seria_wins = 0
      set @seria_nolose = 0
      set @seria_nowins = 0
      set @seria_lose = 0
      
      select @seria_wins = isnull(seria_wins, 0), @seria_nolose = isnull(seria_nolose, 0), @seria_nowins = isnull(seria_nowins, 0), @seria_lose = isnull(seria_lose, 0)
        from tours_results where tour_id = @tour_id-1 and [user_id] = @user_id2
        
      insert into tours_results values (@tour_id, @user_id2, @chup_count2, @chup2, @chup2_club, 
        @chup2_0, @chup22_0, @chup2_1, @chup22_1, @chup2_2, @chup22_2, @chup2_3, @chup22_3, @chup2_4, @chup22_4, @chup2_5, @chup22_5, @chup2_6, @chup22_6, @chup_count1, 
        @nodif2, @win2, @lose2, @draw2, @delta2, 0, 0, 0, 0, @stakes2, 1, @psp2, @goal_max2, @goal_middle2, @goal_min2, 0, 0, 0, 0, '', 0)
      update tours_results
        set
          seria_wins = case when @stakes2 <> 0 then case when @win2 > @win1 then @seria_wins + 1 else 0 end else @seria_wins end,
          seria_nolose = case when @stakes2 <> 0 then case when @win2 >= @win1 then @seria_nolose + 1 else 0 end else @seria_nolose end,
          seria_nowins = case when @stakes2 <> 0 then case when @win2 <= @win1 then @seria_nowins + 1 else 0 end else @seria_nowins end,
          seria_lose = case when @stakes2 <> 0 then case when @win2 < @win1 then @seria_lose + 1 else 0 end else @seria_lose end
        where tour_id = @tour_id and [user_id] = @user_id2
    end  
    
  end
  fetch next from c into @user_id, @user_id2, @user_club_id, @user_club_id2
end

close c
deallocate c  

declare @avgchup float

set @avgchup = (select avg(convert(float, chup_count)) from tours_results where [tour_id] = @tour_id)
if (@avgchup = 0) set @avgchup = 1

update tours_results 
  set [achup] = convert(float, chup_count)/@avgchup where [tour_id] = @tour_id

update users 
  set achup = isnull((select sum(r.achup)/count(*) from tours_results r where u.[user_id] = r.[user_id] and r.stakes_count <> 0 group by r.[user_id] having count(*) > 0), 1)
from users u

update users 
  set achup = 1
from users u
  where achup = 0

declare @luck_cnt int
create table #tmp_luck (user_id int, chup_win float, chup_lose float, achup float, chup_count tinyint, win tinyint, rival_chup tinyint, lose tinyint)
insert into #tmp_luck 
  select [user_id], 
    convert(float, ROW_NUMBER() over (order by case when r.win <> 0 then convert(float, r.chup_count)/r.win else 100 end, r.[user_id])), 
    convert(float, ROW_NUMBER() over (order by case when r.lose <> 0 then convert(float, r.rival_chup)/r.lose else 100 end desc, r.[user_id])),
    convert(float, ROW_NUMBER() over (order by r.rival_chup, r.[user_id])),
    r.chup_count, r.win, r.rival_chup, r.lose
    from tours_results r where r.[tour_id] = @tour_id and r.stakes_count <> 0
select @luck_cnt = count(*) from #tmp_luck

  
update t 
  set [luck] = 100-convert(tinyint, round((u.achup*0.5+u.chup_win*0.25+u.chup_lose*0.25)/@luck_cnt*100, 0))
  from tours_results t 
  inner join #tmp_luck u on u.[user_id] = t.[user_id]
  where t.[tour_id] = @tour_id

drop table #tmp_luck

insert into tours_results ([tour_id], [user_id])
  select @tour_id, u.[user_id] from users u
    where u.[user_id] in (select r.[user_id] from rivals r where r.rival_id is null and r.tour_id = @tour_id)
    
update r
  set
    seria_wins = isnull(r2.seria_wins, 0),
    seria_nolose = isnull(r2.seria_nolose, 0), 
    seria_nowins = isnull(r2.seria_nowins, 0), 
    seria_lose = isnull(r2.seria_lose, 0),
    luck = isnull(r2.luck, 0),
    psp = isnull(r2.psp, 0)
  from tours_results r
    left outer join tours_results r2 on r2.[user_id] = r.[user_id] and
      r2.tour_id = (select top 1 tour_id from tours_results tr where tr.[user_id] = r.[user_id] and tour_id < @tour_id order by tour_id desc)
  where r.tour_id = @tour_id and
    r.[user_id] in (select ri.[user_id] from rivals ri where ri.rival_id is null and ri.tour_id = @tour_id)

select u.[user_id], u.user_rating, u.user_exp, t.[tour_id], t.rating_delta, case when u.user_rating + t.rating_delta >= 0 then u.user_rating + t.rating_delta else 0 end, 
    case when t.rating_delta > 0 then u.user_exp + t.rating_delta else u.user_exp end
from users u
  inner join tours_results t on u.[user_id] = t.[user_id] and t.[tour_id] = @tour_id


update users 
  set user_rating = case when u.user_rating + t.rating_delta >= 0 then u.user_rating + t.rating_delta else 0 end, 
    user_exp = case when t.rating_delta > 0 then u.user_exp + t.rating_delta else u.user_exp end
from users u
  inner join tours_results t on u.[user_id] = t.[user_id] and t.[tour_id] = @tour_id


update users 
  set luck = isnull((select avg(luck) from tours_results r where u.[user_id] = r.[user_id] and r.stakes_count <> 0 group by r.[user_id]), 0)
from users u

update users
  set played_tours = (select count(*) from tours_results r where r.[user_id] = u.[user_id] and r.stakes_count <> 0),
  is_show_result = case when (select count(*) from tours_results r where r.tour_id = @tour_id and r.[user_id] = u.[user_id] and r.stakes_count <> 0 and r.win >= r.lose) <> 0
    then 1 else is_show_result end
  from users u

select [user_id], ROW_NUMBER() over (order by user_rating desc, [user_id]) as [rank]
into #tmp 
from users 
where is_rated = 1 and [played_tours] <> 0
order by user_rating desc, [user_id]

update users 
  set user_rank = isnull(t.[rank], 0)
  from users u
  left outer join #tmp t on u.user_id = t.user_id

drop table #tmp

update tours_results 
  set [rank] = u.[user_rank], rating = u.[user_rating], experience = u.[user_exp], is_rated = u.is_rated
  from tours_results t
  inner join users u on u.user_id = t.user_id
  where tour_id = @tour_id

----------------------- ЛУЧШИЕ РЕЗУЛЬТАТЫ ----------------------------------------------------


select user_id, convert(float, 0.0) as chup, experience, 0 as seria_wins, 0 as luck, 
  convert(float, 0.0) as chup1, convert(float, 0.0) as chup2, convert(float, 0.0) as chup3, convert(float, 0.0) as chup4, convert(float, 0.0) as chup5, convert(float, 0.0) as chup6, 
  100-psp as risk, 0 as win, [rank]
into #tmp_best from tours_results where tour_id = @tour_id

select r.user_id, 
  round(avg(convert(float, r.chup_count)), 1) as chup,
  max(seria_wins) as seria_wins,
  avg(luck) as luck,
  case when sum(r.chup5_count)<>0 then round(sum(convert(float, r.chup5))/sum(convert(float,  r.chup5_count))*100, 1) else 0 end as chup5,
  case when sum(r.chup1_count)<>0 then round(sum(convert(float, r.chup1))/sum(convert(float,  r.chup1_count))*100, 1) else 0 end as chup1,
  case when sum(r.chup2_count)<>0 then round(sum(convert(float, r.chup2))/sum(convert(float,  r.chup2_count))*100, 1) else 0 end as chup2,
  case when sum(r.chup3_count)<>0 then round(sum(convert(float, r.chup3))/sum(convert(float,  r.chup3_count))*100, 1) else 0 end as chup3,
  case when sum(r.chup4_count)<>0 then round(sum(convert(float, r.chup4))/sum(convert(float,  r.chup4_count))*100, 1) else 0 end as chup4,
  case when sum(r.chup6_count)<>0 then round(sum(convert(float, r.chup6))/sum(convert(float,  r.chup6_count))*100, 1) else 0 end as chup6,
  sum(win) as win
into #tmp2_best
from tours_results r 
where r.tour_id <= @tour_id and r.stakes_count <> 0
group by r.user_id

update #tmp_best
  set 
    chup = r.chup, seria_wins = r.seria_wins, luck = r.luck,
    chup1 = r.chup1, chup2 = r.chup2, chup3 = r.chup3, chup4 = r.chup4, chup5 = r.chup5, chup6 = r.chup6,
    win = r.win
from #tmp_best t
inner join #tmp2_best r on t.user_id = r.user_id

drop table #tmp2_best

declare @best_cnt int, @best tinyint, @b1 varchar(15), @b2 varchar(15), 
  @chupb float, @experienceb float, @seria_winsb float, @luckb float, @chup1b float, @chup2b float, @chup3b float,
  @chup4b float, @chup5b float, @chup6b float, @riskb float, @winb float,
  @p1 float, @p2 float, @p3 float, @p4 float, @p5 float, @p6 float, @p7 float, @p8 float, @p9 float, 
  @p10 float, @p11 float, @p12 float, @rankb int
select @best_cnt = count(*) from #tmp_best

declare c cursor fast_forward for
  select user_id, 
    chup, experience, seria_wins, luck, chup1, chup2, chup3, chup4, chup5, chup6, risk, win, [rank],
    round(convert(float, ROW_NUMBER() over (order by chup desc, [user_id]))/@best_cnt*100, 0) as p1,
    round(convert(float, ROW_NUMBER() over (order by experience desc, [user_id]))/@best_cnt*100, 0) as p2,
    round(convert(float, ROW_NUMBER() over (order by seria_wins desc, [user_id]))/@best_cnt*100, 0) as p3,
    round(convert(float, ROW_NUMBER() over (order by luck desc, [user_id]))/@best_cnt*100, 0) as p4,
    round(convert(float, ROW_NUMBER() over (order by chup1 desc, [user_id]))/@best_cnt*100, 0) as p5,
    round(convert(float, ROW_NUMBER() over (order by chup2 desc, [user_id]))/@best_cnt*100, 0) as p6,
    round(convert(float, ROW_NUMBER() over (order by chup3 desc, [user_id]))/@best_cnt*100, 0) as p7,
    round(convert(float, ROW_NUMBER() over (order by chup4 desc, [user_id]))/@best_cnt*100, 0) as p8,
    round(convert(float, ROW_NUMBER() over (order by chup5 desc, [user_id]))/@best_cnt*100, 0) as p9,
    round(convert(float, ROW_NUMBER() over (order by chup6 desc, [user_id]))/@best_cnt*100, 0) as p10,
    round(convert(float, ROW_NUMBER() over (order by risk desc, [user_id]))/@best_cnt*100, 0) as p11,
    round(convert(float, ROW_NUMBER() over (order by win desc, [user_id]))/@best_cnt*100, 0) as p12
  from #tmp_best
  order by user_id
open c
fetch next from c into @user_id, @chupb, @experienceb, @seria_winsb, @luckb, @chup1b, @chup2b, @chup3b,
  @chup4b, @chup5b, @chup6b, @riskb, @winb, @rankb, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9, @p10, @p11, @p12
while @@fetch_status = 0 
begin
  set @best = 0
  set @b1 = 'chup|'+convert(varchar(10), @chupb)
  set @b2 = 'luck|'+convert(varchar(10), @luckb)+'%'
  
  if (@best < 2 and @rankb < 10)
  begin
    if @best = 0
      set @b1 = 'place|'+convert(varchar(10), @rankb)
    else
      set @b2 = 'place|'+convert(varchar(10), @rankb)
    set @best += 1  
  end

  if (@best < 2 and @p1 <= 10)
  begin
    if @best = 0
      set @b1 = 'chup|'+convert(varchar(10), @chupb)
    else
      set @b2 = 'chup|'+convert(varchar(10), @chupb)
    set @best += 1  
  end
  
  if (@best < 2 and @p2 <= 10)
  begin
    if @best = 0
      set @b1 = 'exp|'+convert(varchar(10), @experienceb)
    else
      set @b2 = 'exp|'+convert(varchar(10), @experienceb)
    set @best += 1  
  end
  
  if (@best < 2 and @p3 <= 10)
  begin
    if @best = 0
      set @b1 = 'seria|'+convert(varchar(10), @seria_winsb)
    else
      set @b2 = 'seria|'+convert(varchar(10), @seria_winsb)
    set @best += 1  
  end
  
  if (@best < 2 and @p4 <= 10)
  begin
    if @best = 0
      set @b1 = 'luck|'+convert(varchar(10), @luckb)+'%'
    else
      set @b2 = 'luck|'+convert(varchar(10), @luckb)+'%'
    set @best += 1  
  end
  
  if (@best < 2 and @p5 <= 5)
  begin
    if @best = 0
      set @b1 = 'england|'+convert(varchar(10), @chup1b)+'%'
    else
      set @b2 = 'england|'+convert(varchar(10), @chup1b)+'%'
    set @best += 1  
  end
  
  if (@best < 2 and @p6 <= 5)
  begin
    if @best = 0
      set @b1 = 'germany|'+convert(varchar(10), @chup2b)+'%'
    else
      set @b2 = 'germany|'+convert(varchar(10), @chup2b)+'%'
    set @best += 1  
  end
  
  if (@best < 2 and @p7 <= 5)
  begin
    if @best = 0
      set @b1 = 'spain|'+convert(varchar(10), @chup3b)+'%'
    else
      set @b2 = 'spain|'+convert(varchar(10), @chup3b)+'%'
    set @best += 1  
  end
  
  if (@best < 2 and @p8 <= 5)
  begin
    if @best = 0
      set @b1 = 'italy|'+convert(varchar(10), @chup4b)+'%'
    else
      set @b2 = 'italy|'+convert(varchar(10), @chup4b)+'%'
    set @best += 1  
  end
  
  if (@best < 2 and @p9 <= 5)
  begin
    if @best = 0
      set @b1 = 'russia|'+convert(varchar(10), @chup5b)+'%'
    else
      set @b2 = 'russia|'+convert(varchar(10), @chup5b)+'%'
    set @best += 1  
  end
  
  if (@best < 2 and @p10 <= 5)
  begin
    if @best = 0
      set @b1 = 'france|'+convert(varchar(10), @chup6b)+'%'
    else
      set @b2 = 'france|'+convert(varchar(10), @chup6b)+'%'
    set @best += 1  
  end
  
  if (@best < 2 and @p11 <= 5)
  begin
    if @best = 0
      set @b1 = 'risk|'+convert(varchar(10), @riskb)+'%'
    else
      set @b2 = 'risk|'+convert(varchar(10), @riskb)+'%'
    set @best += 1  
  end
  
  if (@best < 2 and @p12 <= 5)
  begin
    if @best = 0
      set @b1 = 'goals|'+convert(varchar(10), @winb)
    else
      set @b2 = 'goals|'+convert(varchar(10), @winb)
    set @best += 1  
  end
  
  update tours_results set best = @b1+'|'+@b2 where tour_id = @tour_id and user_id = @user_id
  
  fetch next from c into @user_id, @chupb, @experienceb, @seria_winsb, @luckb, @chup1b, @chup2b, @chup3b,
    @chup4b, @chup5b, @chup6b, @riskb, @winb, @rankb, @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8, @p9, @p10, @p11, @p12
end  
close c
deallocate c
drop table #tmp_best

-----------------------------------------------------------------------------------------------
-----------------------  КЛУБЫ ----------------------------------------------------------------
-----------------------------------------------------------------------------------------------

insert into tours_clubs_results  
  select @tour_id, club_id, 0, 0, 0, 0
    from clubs

declare @club_cnt int
select @club_cnt = count(*) from users where is_rated = 1

select t.club_id, avg(u.[user_rating]) + convert(int, floor(convert(float, count(u.[user_id]))/@club_cnt*100*1.0)) as r,
  count(u.[user_id]) as cnt
  into #tmp2  
  from tours_clubs_results t
  inner join vw_users u on u.club_id = t.club_id and u.is_rated = 1
  where tour_id = @tour_id 
  group by t.club_id

update tours_clubs_results 
  set rating = tmp.r, users_count = tmp.cnt, rating_delta = tmp.r - c.club_rating
  from tours_clubs_results t
    inner join #tmp2 tmp on tmp.club_id = t.club_id
    inner join clubs c on c.club_id = t.club_id
  where tour_id = @tour_id  

drop table #tmp2
  
update clubs 
  set club_rating = t.rating
  from clubs c
  inner join tours_clubs_results t on c.club_id = t.club_id and tour_id = @tour_id  
  
select [club_id], ROW_NUMBER() over (order by club_rating desc) as [rank]
into #tmp3 from clubs 
order by club_rating desc

update tours_clubs_results 
  set [rank] = t.[rank]
  from tours_clubs_results r
  inner join #tmp3 t on r.club_id=t.club_id
  where tour_id = @tour_id

drop table #tmp3

-----------------------------------------------------------------------------------------------

commit tran

delete from locks where lock_type = 'set_tours_results'

end


GO

/****** Object:  StoredProcedure [dbo].[sp_stakes_delete]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_stakes_delete] (
  @match_id int,
  @user_id int
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    delete
      from
        stakes
      where
        ([match_id] = @match_id) and ([user_id] = @user_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [delete from stakes]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end

GO

/****** Object:  StoredProcedure [dbo].[sp_stakes_insert]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

                             
CREATE PROCEDURE [dbo].[sp_stakes_insert] (
  @match_id bigint,
  @user_id int,
  @stakes tinyint
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    declare @tour_id int
    set @tour_id = (select tour_id from matches where match_id=@match_id)
    if exists(select * from vw_tours where tour_id = @tour_id and [is_stakes_accepted] = 1)
    begin
      if (not exists(select * from stakes where [match_id]=@match_id and [user_id]=@user_id))
      begin
		    insert
		      into
			      stakes
		      (
			      [match_id],
			      [user_id],
			      [stakes]
		      ) 
		      values
		      (
			      @match_id,
			      @user_id,
			      @stakes
		      )
      end
      else
      begin
        update
          stakes
        set
          [stakes] = @stakes
        where
          [match_id]=@match_id and [user_id]=@user_id  
      end
    end  
    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [insert into stakes]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end

GO

/****** Object:  StoredProcedure [dbo].[sp_tours_delete]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_tours_delete] (
  @tour_id int
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    delete
      from
        tours
      where
        ([tour_id] = @tour_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [delete from tours]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end

GO

/****** Object:  StoredProcedure [dbo].[sp_tours_insert]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_tours_insert] (
  @tour_id int OUTPUT,
  @tour_num int,
  @tour_description varchar(500),
  @tour_start_date smalldatetime,
  @tour_end_date smalldatetime,
  @is_visible bit,
  @is_matches_finished bit
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    if @tour_id is null select @tour_id = isnull(max([tour_id]), 0)+1 from tours
    insert
      into
        tours
      (
        [tour_id],
        [tour_num],
        [tour_description],
        [tour_start_date],
        [tour_end_date],
        [is_visible],
        [is_matches_finished]
      ) 
      values
      (
        @tour_id,
        @tour_num,
        @tour_description,
        @tour_start_date,
        @tour_end_date,
        @is_visible,
        @is_matches_finished
      )

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [insert into tours]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    
    declare @i int, @match_id int, @d smalldatetime
    set @i = 1
    set @d = getdate()
    while (@i <= 12)
    begin
      set @match_id = null
      exec [sp_matches_insert] @match_id, @tour_id, @i, @d, '', '', 1, '', 1, '', 0, 0, 0, '0:0', '', 0
      set @i = @i + 1
    end
    
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end

GO

/****** Object:  StoredProcedure [dbo].[sp_tours_update]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_tours_update] (
  @tour_id int,
  @tour_num int = null,
  @tour_description varchar(500) = null,
  @tour_start_date smalldatetime = null,
  @tour_end_date smalldatetime = null,
  @is_visible bit = null,
  @is_matches_finished bit = null
)
AS
begin
  SET NOCOUNT ON

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200),
    @old_is_matches_finished bit
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  select @old_is_matches_finished = [is_matches_finished] from tours where ([tour_id] = @tour_id)
  begin tran
    update
        tours
      set
        [tour_num] = case when @tour_num is null then [tour_num] else @tour_num end,       
        [tour_description] = case when @tour_description is null then [tour_description] else @tour_description end,       
        [tour_start_date] = case when @tour_start_date is null then [tour_start_date] else @tour_start_date end,       
        [tour_end_date] = case when @tour_end_date is null then [tour_end_date] else @tour_end_date end,       
        [is_visible] = case when @is_visible is null then [is_visible] else @is_visible end,       
        [matches_finished_date] = case when @is_matches_finished is null then [matches_finished_date] 
          else case when (@is_matches_finished = 1 and [is_matches_finished] = 0) then getdate() else [matches_finished_date] end end,
        [is_matches_finished] = case when @is_matches_finished is null then [is_matches_finished] else @is_matches_finished end
      where
        ([tour_id] = @tour_id)
    if (@is_matches_finished = 1 and @old_is_matches_finished = 0)
    begin
      update users set is_rated = case when license_type > 0 and is_deleted = 0 then 1 else 0 end
      exec sp_set_tour_results @tour_id
      exec sp_update_awards @tour_id
    end
    
    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [update tours]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    if (@is_matches_finished = 1 and @old_is_matches_finished = 0)
      return -1
    else  
      return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end

end

GO

/****** Object:  StoredProcedure [dbo].[sp_update_awards]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_update_awards] (
  @tour_id int
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200), @user_id int,
    @award_id int, @s varchar(300), @d smalldatetime
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    
    set @d = getdate()
    
------------------ Медали -----------------------

    declare c cursor fast_forward read_only for 
      select t.[user_id] from tours_results t
        inner join users u on t.user_id = u.user_id 
        where tour_id = @tour_id and u.is_rated = 1 and stakes_count <> 0
        and chup_count = (select max(chup_count) from tours_results t1 where tour_id = @tour_id and is_rated = 1 and stakes_count <> 0)
    open c

    fetch next from c into @user_id
    while (@@fetch_status = 0)
    begin
      set @s = 'За лучший ЧУП в '+convert(varchar(5), @tour_id)+' туре'
      set @award_id = null
      exec sp_awards_insert @award_id, @tour_id, @user_id, 2, 0, @s, @d
      fetch next from c into @user_id
    end

    close c
    deallocate c

---

    declare @subtype tinyint, @seria smallint

    declare c cursor fast_forward read_only for 
      select t.[user_id], seria_wins,
        case
          when seria_wins >=10 and seria_wins % 5 = 0 then 2 
          when seria_wins = 7 then 1 
          when seria_wins = 3 then 0 
        end as subtype
        from tours_results t
        inner join users u on t.user_id = u.user_id 
        where tour_id = @tour_id and t.seria_wins >=3 and u.is_rated = 1 and stakes_count <> 0
    open c

    fetch next from c into @user_id, @seria, @subtype
    while (@@fetch_status = 0)
    begin
      set @s = 'За серию из '+convert(varchar(5), @seria)+' побед'
      set @award_id = null
      if (@subtype is not null)
        exec sp_awards_insert @award_id, @tour_id, @user_id, 2, @subtype, @s, @d
      fetch next from c into @user_id, @seria, @subtype
    end

    close c
    deallocate c

---

    declare c cursor fast_forward read_only for 
      select t.[user_id], seria_nolose,
        case
          when seria_nolose >= 15 and seria_nolose % 5 = 0 then 2 
          when seria_nolose = 10 then 1 
          when seria_nolose = 5 then 0 
        end as subtype
        from tours_results t 
        inner join users u on t.user_id = u.user_id 
        where tour_id = @tour_id and t.seria_nolose >=5 and u.is_rated = 1 and stakes_count <> 0
    open c

    fetch next from c into @user_id, @seria, @subtype
    while (@@fetch_status = 0)
    begin
      set @s = 'За серию без поражений в течение '+convert(varchar(5), @seria)+' туров'
      set @award_id = null
      if (@subtype is not null)
        exec sp_awards_insert @award_id, @tour_id, @user_id, 2, @subtype, @s, @d
      fetch next from c into @user_id, @seria, @subtype
    end

    close c
    deallocate c

---

    declare c cursor fast_forward read_only for 
      select t.[user_id], [dbo].[fn_get_big_win](tour_id, t.user_id) as seria,
        case
          when [dbo].[fn_get_big_win](tour_id, t.user_id) = 10 then 2 
          when [dbo].[fn_get_big_win](tour_id, t.user_id) = 5 then 1 
          when [dbo].[fn_get_big_win](tour_id, t.user_id) = 3 then 0 
        end as subtype
        from tours_results t 
        inner join users u on t.user_id = u.user_id 
        where tour_id = @tour_id and u.is_rated = 1 and stakes_count <> 0 and [dbo].[fn_get_big_win](tour_id, t.user_id) >= 3
    open c

    fetch next from c into @user_id, @seria, @subtype
    while (@@fetch_status = 0)
    begin
      set @s = 'За серию из '+convert(varchar(5), @seria)+' крупных побед'
      set @award_id = null
      if (@subtype is not null)
        exec sp_awards_insert @award_id, @tour_id, @user_id, 2, @subtype, @s, @d
      fetch next from c into @user_id, @seria, @subtype
    end

    close c
    deallocate c

---

    declare c cursor fast_forward read_only for 
      select t.[user_id], count(*),
        case
          when count(*) >= 100 and count(*) % 50 = 0 then 2 
          when count(*) = 50 then 1 
          when count(*) = 25 then 0 
        end as subtype
        from tours_results t 
        inner join users u on t.user_id = u.user_id 
        where tour_id <= @tour_id and u.is_rated = 1 and stakes_count <> 0
        group by t.user_id
        
    open c

    fetch next from c into @user_id, @seria, @subtype
    while (@@fetch_status = 0)
    begin
      set @s = 'За '+convert(varchar(5), @seria)+' сыгранных туров'
      set @award_id = null
      if (@subtype is not null)
        exec sp_awards_insert @award_id, @tour_id, @user_id, 2, @subtype, @s, @d
      fetch next from c into @user_id, @seria, @subtype
    end

    close c
    deallocate c

---

    declare c cursor fast_forward read_only for 
      select t.[user_id], sum(chup_count)-(sum(chup_count) % 100),
        case
          when sum(chup_count) >= 300 then 2 
          when sum(chup_count) < 300 and sum(chup_count) >= 200 then 1 
          when sum(chup_count) < 200 then 0 
        end as subtype
        from tours_results t 
        inner join users u on t.user_id = u.user_id 
        where tour_id <= @tour_id and u.is_rated = 1 and stakes_count <> 0 
        group by t.user_id
        having (sum(chup_count) % 100) < 
          isnull((select top 1 chup_count from tours_results t2 where t2.tour_id = @tour_id and t2.user_id = t.user_id and stakes_count <> 0 and chup_count > 0), 0)
        
    open c

    fetch next from c into @user_id, @seria, @subtype
    while (@@fetch_status = 0)
    begin
      set @s = 'За '+convert(varchar(5), @seria)+' набранных ЧУПов'
      set @award_id = null
      if (@subtype is not null)
        exec sp_awards_insert @award_id, @tour_id, @user_id, 2, @subtype, @s, @d
      fetch next from c into @user_id, @seria, @subtype
    end

    close c
    deallocate c

---

    declare c cursor fast_forward read_only for 
      select distinct t.[user_id] from tours_results t
        inner join users u on t.user_id = u.user_id 
        where tour_id = @tour_id and u.is_rated = 1 and stakes_count <> 0
        and t.[user_id] in (select [user_id] from stakes s inner join vw_matches m on m.tour_id = @tour_id and s.match_id = m.match_id
          where s.[user_id] = t.[user_id] and 
          (case when m.stakes0 <= 3 and s.stakes = 0 then 1 when m.stakes1 <= 3 and s.stakes = 1 then 1 when m.stakes2 <= 3 and s.stakes = 2 then 1 else 0 end) <> 0
          and m.stake_result = s.stakes
          )
    open c

    fetch next from c into @user_id
    while (@@fetch_status = 0)
    begin
      set @s = 'За успешный рискованный прогноз в '+convert(varchar(5), @tour_id)+' туре'
      set @award_id = null
      exec sp_awards_insert @award_id, @tour_id, @user_id, 2, 2, @s, @d
      fetch next from c into @user_id
    end

    close c
    deallocate c

---

------------------ /Медали ---------------------

------------------ Ордена ---------------------

    select @user_id = t.[user_id] from tours_results t
      where tour_id = @tour_id and [rank] = 1
    set @s = 'Был номером 1 в '+convert(varchar(5), @tour_id)+' туре'
    set @award_id = null
    exec sp_awards_insert @award_id, @tour_id, @user_id, 1, 1, @s, @d

---

    declare c cursor fast_forward read_only for 
      select t.[user_id] from tours_results t
        inner join users u on t.user_id = u.user_id 
        where tour_id = @tour_id and u.is_rated = 1 and chup_count = 12
    open c

    fetch next from c into @user_id
    while (@@fetch_status = 0)
    begin
      set @s = 'За 12 ЧУПов в '+convert(varchar(5), @tour_id)+' туре'
      set @award_id = null
      exec sp_awards_insert @award_id, @tour_id, @user_id, 1, 2, @s, @d
      fetch next from c into @user_id
    end

    close c
    deallocate c

------------------ /Ордена ---------------------

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [insert into awards]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end


GO

/****** Object:  StoredProcedure [dbo].[sp_update_matches_stakes]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_update_matches_stakes] (
  @tour_id int
)
AS
begin
set nocount on
declare @match_id int,
  @stakes0 float, @stakes1 float, @stakes2 float,
  @pstakes0 numeric(4, 1), @pstakes1 numeric(4, 1), @pstakes2 numeric(4, 1)

begin tran

declare c cursor for 
  select match_id from matches where tour_id = @tour_id
open c
fetch next from c into @match_id
while (@@fetch_status = 0)
begin
  select @stakes0 = count(*) from stakes where match_id = @match_id and stakes = 0
  select @stakes1 = count(*) from stakes where match_id = @match_id and stakes = 1
  select @stakes2 = count(*) from stakes where match_id = @match_id and stakes = 2
  set @pstakes1 = round(@stakes1 / (@stakes1+@stakes2+@stakes0) * 100, 1)
  set @pstakes2 = round(@stakes2 / (@stakes1+@stakes2+@stakes0) * 100, 1)
  set @pstakes0 = 100 - @pstakes1 - @pstakes2
  update matches set stakes0 = @pstakes0, stakes1 = @pstakes1, stakes2 = @pstakes2 where current of c
  fetch next from c into @match_id
end

close c
deallocate c

commit tran
end


GO

/****** Object:  StoredProcedure [dbo].[sp_update_stakes_majority]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_update_stakes_majority] (
  @tour_id int
)
AS
begin
  set nocount on
  
  exec sp_update_matches_stakes @tour_id

  declare @match_id int, @stakes int,
  @stakes0 numeric(4, 1), @stakes1 numeric(4, 1), @stakes2 numeric(4, 1)
  
  begin tran

    declare c cursor fast_forward for 
      select match_id, stakes0, stakes1, stakes2 from matches where tour_id = @tour_id
    open c
    fetch next from c into @match_id, @stakes0, @stakes1, @stakes2
    while (@@fetch_status = 0)
    begin
      set @stakes = 0
      if (@stakes1 > @stakes0)
      begin
        if (@stakes1 >= @stakes2) set @stakes = 1 else set @stakes = 2
      end
      else
      begin
        if (@stakes2 > @stakes0) set @stakes = 2
      end
      
      update stakes set stakes = @stakes where stakes = 99 and match_id = @match_id
      fetch next from c into @match_id, @stakes0, @stakes1, @stakes2
    end

    close c
    deallocate c

  commit tran
  
  exec sp_update_matches_stakes @tour_id

end



GO

/****** Object:  StoredProcedure [dbo].[sp_users_insert]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_users_insert] (
  @user_id int OUTPUT,
  @uid bigint,
  @club_id smallint,
  @user_rating int,
  @user_exp bigint,
  @user_rank int,
  @license_type tinyint, /* 0 - free, 1 - pro, 2 - vip */
  @license_expired smalldatetime
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    if (exists(select * from users where [uid] = @uid))
    begin
      if @user_id is null select @user_id = [user_id] from users where uid = @uid and is_deleted = 0
      exec [sp_users_update] @user_id, @uid, @club_id
    end
    else
    begin
      if @user_id is null select @user_id = isnull(max([user_id]), 0)+1 from users
      insert
        into
          users
        (
          [user_id],
          [uid],
          [club_id],
          [user_rating],
          [user_exp],
          [user_rank],
          [license_type],
          [license_expired]
        ) 
        values
        (
          @user_id,
          @uid,
          @club_id,
          @user_rating,
          @user_exp,
          @user_rank,
          @license_type,
          @license_expired
        )
      declare @tour_id int
      set @tour_id = isnull((select top 1 tour_id from vw_tours where [is_stakes_accepted]=1 order by tour_id), 0)
      if (exists(select * from rivals where new_vk_uid = @uid and tour_id = @tour_id))
      begin
        update rivals
          set [challenge_user_id] = @user_id
        where [user_id] = (select top 1 user_id from rivals where new_vk_uid = @uid and tour_id = @tour_id order by [user_id])
      end
    end

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [insert into users]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end

GO

/****** Object:  StoredProcedure [dbo].[sp_users_update]    Script Date: 03/02/2019 07:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_users_update] (
  @user_id int,
  @uid bigint = null,
  @club_id smallint = null,
  @user_rating int = null,
  @user_exp bigint = null,
  @user_rank int = null,
  @luck tinyint = null,
  @achup float = null,
  @license_type tinyint = null, /* 0 - free, 1 - pro, 2 - vip */
  @license_expired smalldatetime = null,
  @played_tours int = null
)
AS
begin
  SET NOCOUNT ON

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    update
        users
      set
        [uid] = case when @uid is null then [uid] else @uid end,       
        [club_id] = case when @club_id is null then [club_id] else @club_id end,       
        [user_rating] = case when @user_rating is null then [user_rating] else @user_rating end,       
        [user_exp] = case when @user_exp is null then [user_exp] else @user_exp end,       
        [user_rank] = case when @user_rank is null then [user_rank] else @user_rank end,       
        [luck] = case when @luck is null then [luck] else @luck end,       
        [achup] = case when @achup is null then [achup] else @achup end,       
        [license_type] = case when @license_type is null then [license_type] else @license_type end,       
        [license_expired] = case when @license_expired is null then [license_expired] else @license_expired end,       
        [played_tours] = case when @played_tours is null then [played_tours] else @played_tours end
      where
        ([user_id] = @user_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Ошибка выполнения! Процедура: %s, код ошибки: %s [update users]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Ошибка выполнения! Процедура: %s, код ошибки: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end

end

GO

