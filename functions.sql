USE [fightball.pro]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_best_rating]    Script Date: 03/02/2019 07:56:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[fn_get_best_rating] (
  @user_id int,
  @tour_id int
)
RETURNS varchar(100)
AS
BEGIN
  declare @v int, @cnt int, @result varchar(100)
  if (@tour_id = 0)
  begin
    select @cnt=count(*) from [users] where is_deleted = 0
    select @v=count(*)+1 from [users] u
      where u.user_rating > (select user_rating from users where [user_id] = @user_id)
  end
  else
  begin
    select @cnt=count(*) from tours_results where stakes_count <> 0 and tour_id = @tour_id
    select @v=count(*)+1 from tours_results where stakes_count <> 0 and tour_id = @tour_id
      and rating > (select rating from tours_results where [user_id] = @user_id and tour_id = @tour_id)
  end
  set @result = convert(varchar(10), round(convert(float, @v)/@cnt*100, 0))+'%'
  if (@v <= 10) 
  begin
    set @v = case when @v <= 3 then 3 when @v <=5 then 5 else 10 end
    set @result = convert(varchar(10), @v)
  end
  return @result
END



GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_big_win]    Script Date: 03/02/2019 07:56:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[fn_get_big_win](
  @tour_id int,
  @user_id int
)
RETURNS tinyint
AS
BEGIN
  declare @result tinyint, @a int
  set @result = 0
  declare c cursor fast_forward read_only for
    select top (10) convert(int, win)-lose as a from tours_results
      where [user_id] = @user_id and stakes_count <> 0 and tour_id <= @tour_id
      order by [tour_id] desc
  open c
  fetch next from c into @a
  while (@@fetch_status = 0)
  begin
    if (@a >= 3)
    begin
      set @result += 1
    end
    else
    begin
      break
    end  
    fetch next from c into @a
  end
  close c
  deallocate c    
  return @result
END


GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_chup_history]    Script Date: 03/02/2019 07:56:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_get_chup_history](
  @user_id int, @last tinyint
)
RETURNS varchar(200)
AS
BEGIN
  declare @result varchar(200), @tour_id int, @chup_count tinyint, @rival_chup tinyint
  set @result = ''
  declare c cursor fast_forward read_only for
    select top (@last) t.[tour_num], r.chup_count, r.rival_chup 
      from tours_results r
        inner join tours t on r.tour_id = t.tour_id
      where [user_id] = @user_id and stakes_count <> 0
      order by r.[tour_id] desc
  open c
  fetch next from c into @tour_id, @chup_count, @rival_chup
  while (@@fetch_status = 0)
  begin
    set @result = '[' + convert(varchar(10), @tour_id) + ', ' + convert(varchar(10), @chup_count) + ', ' + convert(varchar(10), @rival_chup) + ']' +
      (case when @result <> '' then ', ' + @result else '' end)
    fetch next from c into @tour_id, @chup_count, @rival_chup
  end
  close c
  deallocate c    
  return @result
END

GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_chup_rank]    Script Date: 03/02/2019 07:56:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_get_chup_rank] (
  @user_id int
)
RETURNS int
AS
BEGIN
  declare @result int, @i int, @id int, @v float
  set @result = 0
  set @i = 0
  declare c cursor for
    select u.[user_id], avg(convert(float, r.chup_count)) as v
      from [vw_users] u
      inner join tours_results r on r.[user_id] = u.[user_id]
      where (u.is_rated = 1 or u.[user_id] = @user_id) and r.stakes_count <> 0
      group by u.[user_id]
      order by v desc, [user_id]
  open c
  fetch next from c into @id, @v
  while (@@fetch_status = 0)
  begin
    set @i = @i + 1
    if (@id = @user_id)
    begin
      close c
      deallocate c  
      return @i
    end
    fetch next from c into @id, @v
  end
  close c
  deallocate c  
  return @result
END

GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_exp_rank]    Script Date: 03/02/2019 07:56:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[fn_get_exp_rank] (
  @user_id int
)
RETURNS varchar(100)
AS
BEGIN
  declare @result varchar(100), @i int, @id int, @v bigint
  set @result = ''
  set @i = 0
  declare c cursor for
    select u.[user_id], u.user_exp as v
      from [vw_users] u
      where u.is_rated = 1 or u.[user_id] = @user_id
      order by v desc, [user_id]
  open c
  fetch next from c into @id, @v
  while (@@fetch_status = 0)
  begin
    set @i = @i + 1
    if (@id = @user_id)
    begin
      break
    end
    fetch next from c into @id, @v
  end
  close c
  deallocate c  
  
  set @v = @i
  
  declare @delta bigint, @tour_id int
  select @tour_id = isnull(max(tour_id), 0) from tours_results where [user_id] = @user_id and stakes_count <> 0
  set @tour_id = isnull((select top 1 tour_id from tours_results where [user_id] = @user_id and stakes_count <> 0 and tour_id < @tour_id order by tour_id desc), 0)
  
  set @i = 0
  set @delta = 0
  declare c cursor for
    select r.[user_id], r.[experience] as v
      from tours_results r
      inner join vw_users u on r.user_id = u.user_id
      where r.stakes_count <> 0 and (u.is_rated = 1 or u.[user_id] = @user_id) and r.tour_id = @tour_id 
      order by v desc, r.[user_id]
  open c
  fetch next from c into @id, @delta
  if (@@fetch_status = 0)
  begin
    while (@@fetch_status = 0)
    begin
      set @i = @i + 1
      if (@id = @user_id)
      begin
        break
      end
      fetch next from c into @id, @delta
    end
  end
  else
    set @i = -1
  close c
  deallocate c  
  
  
  set @delta = @v - @i
  
  set @result = convert(varchar(10), @v) + ', ' + convert(varchar(10), abs(@delta)) + ', ' +
    case when @i = -1 then '-' when @delta > 0 then 'down' else 'up' end
    
  return @result
END


GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_luck_rank]    Script Date: 03/02/2019 07:56:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_get_luck_rank] (
  @user_id int
)
RETURNS varchar(100)
AS
BEGIN
  declare @result varchar(100), @i int, @id int, @v float
  set @result = ''
  set @i = 0
  declare c cursor for
    select u.[user_id], u.luck as v
      from [vw_users] u
      where (u.is_rated = 1) or ([user_id] = @user_id)
      order by v desc, [user_id]
  open c
  fetch next from c into @id, @v
  while (@@fetch_status = 0)
  begin
    set @i = @i + 1
    if (@id = @user_id)
    begin
      break
    end
    fetch next from c into @id, @v
  end
  close c
  deallocate c  
  
  declare @delta int, @tour_id int, @rank int
  select @tour_id = isnull(max(tour_id), 0) from tours_results where [user_id] = @user_id and stakes_count <> 0
  set @rank = isnull((select avg(luck) from tours_results r where tour_id < @tour_id and r.[user_id] = @user_id and r.stakes_count <> 0 group by r.[user_id]), 0)
  --set @rank = isnull((select top 1 convert(int, luck) from tours_results where tour_id < @tour_id  and [user_id] = @user_id and stakes_count <> 0 order by tour_id desc), -1)
  set @delta = convert(int, @v) - @rank
  
  set @result = convert(varchar(10), @i) + ', ' + convert(varchar(10), abs(@delta)) + ', ' +
    case when @rank = -1 then '-' when @delta < 0 then 'down' else 'up' end
    
  return @result
END

GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_luck_rank2]    Script Date: 03/02/2019 07:56:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[fn_get_luck_rank2] (
  @user_id int
)
RETURNS varchar(100)
AS
BEGIN
  declare @result varchar(100), @i int, @id int, @v int, @rank int
  set @result = ''
  set @i = 0
  declare @delta int, @tour_id int
  select @tour_id = isnull(max(tour_id), 0) from tours_results where [user_id] = @user_id and stakes_count <> 0 and is_rated = 1
  ;with q (user_id, rank) as (select user_id, ROW_NUMBER() over (order by luck desc, [user_id]) from users where is_rated = 1 or user_id = @user_id)
  select @v = rank from q where user_id = @user_id
  set @v = isnull(@v, 0)
  set @tour_id = isnull((select top 1 tour_id from tours_results 
    where tour_id < @tour_id and [user_id] = @user_id and stakes_count <> 0 order by tour_id desc), 0)
  ;with q (user_id, rank) as (select r.user_id, ROW_NUMBER() over (order by r.luck desc, r.[user_id]) from tours_results r inner join users u on u.user_id = r.user_id where r.tour_id = @tour_id and (u.is_rated = 1 or u.user_id = @user_id) and r.stakes_count <> 0)
  select @rank = rank from q where user_id = @user_id
  set @rank = isnull(@rank, -1)
  set @delta = @v - @rank
  
  set @result = convert(varchar(10), @v) + ', ' + convert(varchar(10), abs(@delta)) + ', ' +
    case when @rank =-1 then '-' when @delta > 0 then 'down' else 'up' end
  return @result
END


GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_match_stakes_stats]    Script Date: 03/02/2019 07:56:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_get_match_stakes_stats] 
(
  @match_id bigint,
  @user_id int
)
RETURNS varchar(10)
AS
BEGIN
	DECLARE @result varchar(10), @cnt int
  select @cnt = count(*) from stakes where match_id = @match_id
  set @result = '33|34|33';
  if (@cnt >= 10)
  begin
    declare @allow_show bit
    set @allow_show = 1
    
    if (@allow_show = 1)
    begin
      declare @cnt1 int, @cnt2 int
      select
        @cnt1 = sum(case when stakes = 1 then 1 else 0 end),
        @cnt2 = sum(case when stakes = 2 then 1 else 0 end)
      from 
        stakes
      where
        match_id = @match_id
      set @cnt1 = convert(int, (convert(float, @cnt1) / convert(float, @cnt))*100)
      set @cnt2 = convert(int, (convert(float, @cnt2) / convert(float, @cnt))*100)
      set @cnt = 100 - @cnt1 - @cnt2
      set @result = convert(varchar(3), @cnt1) +  '|' + convert(varchar(3), @cnt) + '|' +
        convert(varchar(3), @cnt2)
    end
  end

	RETURN @result

END

GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_proud]    Script Date: 03/02/2019 07:56:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[fn_get_proud] (
  @user_id int,
  @tour_id int
)
RETURNS varchar(100)
AS
BEGIN
  declare @result varchar(100)
  set @result = 'chup|5.5|luck|100%|1200'
  if (@tour_id = 0) select @tour_id = max(tour_id) from tours_results where user_id = @user_id
  set @result = isnull((select best+'|'+convert(varchar(10), rating) from tours_results where user_id = @user_id and tour_id = @tour_id), @result)
  return @result
END




GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_rank_history]    Script Date: 03/02/2019 07:56:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_get_rank_history](
  @user_id int, @last smallint
)
RETURNS varchar(5000)
AS
BEGIN
  declare @result varchar(5000), @rank int
  set @result = ''
  declare c cursor fast_forward read_only for
    select top (@last) [rank] from tours_results
      where [user_id] = @user_id and stakes_count <> 0
      order by [tour_id] desc
  open c
  fetch next from c into @rank
  while (@@fetch_status = 0)
  begin
    set @result = convert(varchar(10), @rank) + (case when @result <> '' then ', ' + @result else '' end)
    fetch next from c into @rank 
  end
  close c
  deallocate c    
  return @result
END

GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_rating_history]    Script Date: 03/02/2019 07:56:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_get_rating_history](
  @user_id int, @last smallint
)
RETURNS varchar(5000)
AS
BEGIN
  declare @result varchar(5000), @rating int
  set @result = ''
  declare c cursor fast_forward read_only for
    select top (@last) [rating] from tours_results
      where [user_id] = @user_id and stakes_count <> 0
      order by [tour_id] desc
  open c
  fetch next from c into @rating
  while (@@fetch_status = 0)
  begin
    set @result = convert(varchar(10), @rating) + (case when @result <> '' then ', ' + @result else '' end)
    fetch next from c into @rating 
  end
  close c
  deallocate c    
  return @result
END

GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_rating_status]    Script Date: 03/02/2019 07:56:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[fn_get_rating_status] (
  @user_id int
)
RETURNS varchar(100)
AS
BEGIN
  declare @result varchar(100), @i int, @id int, @v int
  set @result = ''
  ;
  with q_users ([rank], [user_id], [v])
  as
  (
    select top 100 (ROW_NUMBER() over (order by u.user_rating desc, [user_id])), u.[user_id], u.user_rating
      from [vw_users] u
      where u.is_rated = 1 or [user_id] = @user_id
      order by u.user_rating desc, [user_id]
  )
  select @i=isnull([rank], 1000) from q_users where [user_id] = @user_id
    
  declare @mr int
  select @mr = max(rating) from tours_results where [user_id] = @user_id
  select @v=[user_rating] from users where [user_id] = @user_id
  
  if (@i <= 10) 
  begin
    set @result = 'В десятке лучших!'
  end
  else if (@i <= 100)
  begin
    set @result = 'В сотне лучших!'
  end
  else if (@v = @mr)
  begin
    set @result = 'Максимальный рейтинг!'
  end
  else 
  begin
    declare @cnt int
    select @cnt=count(*) from [users] where is_deleted = 0
    select @v=count(*)+1 from [users] u
      where u.user_rating > (select user_rating from users where [user_id] = @user_id)
    select @i=count(*)+1 from [users] u
      where u.user_exp > (select user_exp from users where [user_id] = @user_id)
    set @result = case when @v < @i then 'Рейтинг выше,<br>чем у '+convert(varchar(10), 100-round(convert(float, @v)/@cnt*100, 0))+'% Лиги!'
      else 'Опыт больше,<br>чем у '+convert(varchar(10), 100-round(convert(float, @i)/@cnt*100, 0))+'% Лиги!' end
  end
  
  return @result
END



GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_stakes_diff]    Script Date: 03/02/2019 07:56:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_get_stakes_diff]
(
  @v int
)
RETURNS int
AS
BEGIN
  declare @i int, @cnt int, @mask int
  set @i = 1
  set @cnt = 0
  while (@i <= 12)
  begin
    set @mask = power(4, @i) - power(4, @i-1)
    if (@v & @mask <> 0) set @cnt += 1
    set @i += 1
  end
  return @cnt
END


GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_stakes_mask]    Script Date: 03/02/2019 07:56:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_get_stakes_mask]
(
  @tour_id int,
  @user_id int
)
RETURNS int
AS
BEGIN
	declare @result int, @stakes tinyint, @i tinyint
	set @result = 0
	declare c cursor fast_forward read_only for
	  select s.stakes from stakes s
	    inner join matches m on s.match_id=m.match_id and m.tour_id=@tour_id
	  where [user_id] = @user_id order by m.order_num
	open c
	set @i = 0
	fetch next from c into @stakes
	while @@fetch_status = 0
	begin
	  set @result = @result + case when @stakes = 1 then power(2, @i) when @stakes = 2 then power(2, @i+1) else 0 end
	  fetch next from c into @stakes
	  set @i = @i + 2
	end
	close c
	deallocate c  
	return @result
END


GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_style_data]    Script Date: 03/02/2019 07:56:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_get_style_data] (
  @user_id int
)
RETURNS varchar(100)
AS
BEGIN
  declare @result varchar(100)
  set @result = ''

  declare @delta float, @tour_id int, @psp float, @pr float
  select @tour_id = isnull(max(tour_id), 0) from tours_results where [user_id] = @user_id
  set @psp = isnull((select top 1 psp from tours_results where tour_id = @tour_id and [user_id] = @user_id order by tour_id desc), 0)
  set @pr = isnull((select top 1 psp from tours_results where tour_id < @tour_id and [user_id] = @user_id order by tour_id desc), -1)
  set @delta = @psp - @pr
  
  set @result = convert(varchar(10), round(@psp, 2)) + ', ' + convert(varchar(10), abs(round(@delta, 1))) + ', ' +
    case when @pr = -1 then '-' when @delta < 0 then 'down' else 'up' end
    
  return @result
END

GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_tours_history]    Script Date: 03/02/2019 07:56:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[fn_get_tours_history](
  @user_id int, @last tinyint
)
RETURNS varchar(1000)
AS
BEGIN
  declare @result varchar(1000), @tour_id int, @tour_num int, @res tinyint, @win tinyint, @lose tinyint, @r_id int, @r_uid bigint, @club_code varchar(5), @club_name varchar(100)
  set @result = ''
  declare c cursor fast_forward read_only for
    select top (@last) r.tour_id, t.tour_num, case when r.win > r.lose then 1 when r.win = r.lose then 2 else 3 end,
      r.win, r.lose, isnull(u.[user_id], 0), isnull(u.uid, 0), isnull(u.club_code, ''), isnull(u.club_name, '')
    from tours_results r
      inner join tours t on r.tour_id = t.tour_id
      left outer join rivals rr on r.tour_id = rr.tour_id and r.[user_id] = rr.[user_id]
      left outer join vw_users u on u.[user_id] = rr.[rival_id]
      where r.[user_id] = @user_id and stakes_count <> 0
      order by r.[tour_id] desc
  open c
  fetch next from c into @tour_id, @tour_num, @res, @win, @lose, @r_id, @r_uid, @club_code, @club_name
  while (@@fetch_status = 0)
  begin
    set @result = '{ "tour_id": ' + convert(varchar(10), @tour_id) + ', "tour_num": ' + convert(varchar(10), @tour_num) + 
      ', "result": ' + convert(varchar(10), @res) + 
      ', "win": ' + convert(varchar(10), @win) + ', "lose": ' + convert(varchar(10), @lose) + 
      ', "rival": { "id": ' + convert(varchar(10), @r_id) + ', "uid": ' + convert(varchar(10), @r_uid) + 
      ', "club_code": "' + @club_code + '", "club_name": "' + @club_name + 
      '" } }' + (case when @result <> '' then ', ' + @result else '' end)
    fetch next from c into @tour_id, @tour_num, @res, @win, @lose, @r_id, @r_uid, @club_code, @club_name
  end
  close c
  deallocate c    
  return @result
END



GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_user_psp]    Script Date: 03/02/2019 07:56:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_get_user_psp] (
  @tour_id int,
  @user_id int
) RETURNS float
AS
begin
  declare @psp1 float, @stakes1 tinyint
  set @psp1 = 0
  set @stakes1 = 0
  
  declare @ms0 numeric(4, 1), @ms1 numeric(4, 1), @ms2 numeric(4, 1), @s1 tinyint

  declare m cursor fast_forward read_only for
    select isnull(s.stakes, 99), m.stakes0, m.stakes1, m.stakes2
      from vw_matches m
      left outer join stakes s on s.match_id = m.match_id and s.[user_id] = @user_id
      where tour_id = @tour_id    
  open m
  fetch next from m into @s1, @ms0, @ms1, @ms2
  while (@@fetch_status = 0)
  begin

    if (@s1 <> 99)
      set @stakes1 = @stakes1 + 1

    set @psp1 = @psp1 + (case when @s1 = 0 then @ms0 when @s1 = 1 then @ms1 when @s1 = 2 then @ms2 else 0 end)
    fetch next from m into @s1, @ms0, @ms1, @ms2
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
  
  return @psp1
  
end
GO

