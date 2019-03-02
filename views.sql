USE [fightball.pro]
GO

/****** Object:  View [dbo].[vw_awards]    Script Date: 03/02/2019 07:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[vw_awards] (
  [award_id],
  [tour_id],
  [user_id],
  [award_type], /* 0 - кубок, 1 - орден, 2 - медаль */
  [award_subtype],
  [award_description],
  [date_achieve],
  [date_lost],
  [text_date]
)
AS
  select 
    [award_id],
    [tour_id],
    [user_id],
    [award_type],
    [award_subtype],
    [award_description],
    [date_achieve],
    [date_lost],
    case when [date_lost] is not null then 'с ' else '' end + 
      convert(varchar(10), [date_achieve], 104) +
      case when [date_lost] is not null then
        ' по ' + convert(varchar(10), [date_lost], 104)
        else ''
      end
  from
    awards



GO

/****** Object:  View [dbo].[vw_clubs]    Script Date: 03/02/2019 07:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_clubs] (
  [club_id],
  [club_code],
  [country_id],
  [country_code],
  [country_acrm],
  [country_name],
  [club_name],
  [club_national_name],
  [club_rating],
  [cnt]
)
AS
  select 
    [club_id],
    right('000'+convert(varchar(3), [club_id]), 3),
    c.[country_id],
    cn.[country_code],
    cn.country_acrm,
    cn.country_name,
    [club_name],
    [club_national_name],
    [club_rating],
    (select count (*) from users where is_deleted = 0 and users.club_id=c.club_id)
  from
    clubs c
    inner join vw_countries cn on cn.country_id = c.country_id



GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 213
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_clubs'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_clubs'
GO

/****** Object:  View [dbo].[vw_config_values]    Script Date: 03/02/2019 07:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_config_values] (
  [user_id],
  [config],
  [value]
)
AS
  select 
    [user_id],
    [config],
    [value]
  from
    config_values

GO

/****** Object:  View [dbo].[vw_countries]    Script Date: 03/02/2019 07:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_countries] (
  [country_id],
  [country_code],
  [country_name],
  [country_acrm]
)
AS
  select 
    [country_id],
    right('00'+convert(varchar(2), [country_id]), 2),
    [country_name],
    [country_acrm]
  from
    countries

GO

/****** Object:  View [dbo].[vw_matches]    Script Date: 03/02/2019 07:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [dbo].[vw_matches] (
  [match_id],
  [tour_id],
  [order_num],
  [match_date],
  [match_text_date],
  [place],
  [tournament_name],
  [club1_id],
  [club1_code],
  [club1_name],
  [club1_results],
  [club1_goals],
  [club2_id],
  [club2_code],
  [club2_name],
  [club2_results],
  [club2_goals],
  [stakes0],
  [stakes1],
  [stakes2],
  [score],
  [description],
  [flag],
  [is_finished],
  [stake_result]
)
AS
  select 
    [match_id],
    [tour_id],
    [order_num],
    [match_date],
    convert(varchar(10), [match_date], 104) + ' ' + convert(varchar(5), [match_date], 108),
    [place],
    [tournament_name],
    [club1_id],
    c1.[club_code],
    c1.[club_name],
    [club1_results],
    case when [score] = '' then '-' else substring([score], 1, charindex(':', [score])-1) end,
    [club2_id],
    c2.[club_code],
    c2.[club_name],
    [club2_results],
    case when [score] = '' then '-' else substring([score], charindex(':', [score])+1, 2) end,
    [stakes0],
    [stakes1],
    [stakes2],
    [score],
    [description],
    case when c1.country_id = c2.country_id then c1.country_code else '00' end,
    case when [is_finished] = 1 then 1 else 0 end,
    case
      when [score] = '' then 99 
      when substring([score], 1, charindex(':', [score])-1) = substring([score], charindex(':', [score])+1, 2) then 0
      when convert(tinyint, substring([score], 1, charindex(':', [score])-1)) > convert(tinyint, substring([score], charindex(':', [score])+1, 2)) then 1
      else 2 end
  from
    matches m
    inner join vw_clubs c1 on m.club1_id = c1.club_id
    inner join vw_clubs c2 on m.club2_id = c2.club_id







GO

/****** Object:  View [dbo].[vw_matches_details]    Script Date: 03/02/2019 07:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_matches_details] (
  [match_id],
  [detail_num],
  [home_team],
  [home_team_code],
  [detail_date],
  [detail_text_date],
  [place],
  [tournament_name],
  [score]
)
AS
  select 
    [match_id],
    [detail_num],
    [home_team],
    right('000'+convert(varchar(3), [home_team]), 3),
    [detail_date],
    convert(varchar(10), [detail_date], 104) + ' ' + convert(varchar(5), [detail_date], 108),
    [place],
    [tournament_name],
    [score]
  from
    matches_details

GO

/****** Object:  View [dbo].[vw_orders]    Script Date: 03/02/2019 07:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_orders] (
  [order_id],
  [user_id],
  [vk_order_id],
  [item],
  [cost],
  [tour_id],
  [order_date]
)
AS
  select 
    [order_id],
    [user_id],
    [vk_order_id],
    [item],
    [cost],
    [tour_id],
    [order_date]
  from
    orders

GO

/****** Object:  View [dbo].[vw_pin_codes]    Script Date: 03/02/2019 07:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_pin_codes] (
  [PIN],
  [type],
  [type_name],
  [expire_date],
  [text_expire_date]
)
AS
  select 
    [PIN],
    [type],
    case when [type] = 1 then 'profi' when [type] = 2 then 'premium' else '' end,
    [expire_date],
    convert(varchar(10), [expire_date], 104)
  from
    pin_codes



GO

/****** Object:  View [dbo].[vw_rating_headers]    Script Date: 03/02/2019 07:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_rating_headers] (
  [header_id],
  [tab_id],
  [col_id],
  [header_name],
  [optional_name],
  [sql],
  [join_table],
  [suffix]
)
AS
  select 
    [header_id],
    [tab_id],
    [col_id],
    [header_name],
    case when [optional_name] = '' then [header_name] else [optional_name] end,
    [sql],
    [join_table],
    [suffix]
  from
    rating_headers



GO

/****** Object:  View [dbo].[vw_rivals]    Script Date: 03/02/2019 07:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_rivals] (
  [tour_id],
  [user_id],
  [rival_id],
  [new_vk_uid],
  [rating_min],
  [rating_max],
  [club_id],
  [challenge_user_id]
)
AS
  select 
    [tour_id],
    [user_id],
    [rival_id],
    [new_vk_uid],
    [rating_min],
    [rating_max],
    [club_id],
    [challenge_user_id]
  from
    rivals

GO

/****** Object:  View [dbo].[vw_robot_stakes]    Script Date: 03/02/2019 07:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[vw_robot_stakes] (
  [match_id],
  [robot_id],
  [stakes]
)
AS
  select 
    [match_id],
    [robot_id],
    [stakes]
  from
    robot_stakes


GO

/****** Object:  View [dbo].[vw_robots]    Script Date: 03/02/2019 07:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[vw_robots] (
  [robot_id],
  [rating]
)
AS
  select 
    [robot_id],
    [rating]
  from
    robots



GO

/****** Object:  View [dbo].[vw_stakes]    Script Date: 03/02/2019 07:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_stakes] (
  [match_id],
  [user_id],
  [stakes]
)
AS
  select 
    [match_id],
    [user_id],
    [stakes]
  from
    stakes

GO

/****** Object:  View [dbo].[vw_tours]    Script Date: 03/02/2019 07:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










CREATE VIEW [dbo].[vw_tours] (
  tour_id,
  tour_num,
  tour_description,
  tour_start_date,
  text_tour_start_date,
  tour_end_date,
  text_tour_end_date,
  is_visible,
  is_stakes_accepted,
  is_matches_finished,
  matches_count,
  matches_finished_date,
  tour_first_match_date,
  tour_last_match_date
)
AS
  select
    tour_id,
    tour_num,
    tour_description,
    tour_start_date,
    convert(varchar(10), tour_start_date, 104)+' '+convert(varchar(5), tour_start_date, 108),
    tour_end_date,
    convert(varchar(10), tour_end_date, 104)+' '+convert(varchar(5), tour_end_date, 108),
    case when (tour_start_date < getdate()) or (is_visible = 1) then 1 else 0 end,
    case when ((tour_start_date < getdate()) and (tour_end_date > getdate())) then 1 else 0 end,
    case when is_matches_finished = 1 then 1 else 0 end,
    (select count(*) from matches m where m.tour_id = t.tour_id),
    matches_finished_date,
    (select match_date from matches m where m.tour_id = t.tour_id and order_num = 1),
    (select match_date from matches m where m.tour_id = t.tour_id and order_num = 12)
  from
    tours t










GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tours"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 3
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_tours'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_tours'
GO

/****** Object:  View [dbo].[vw_tours_clubs_results]    Script Date: 03/02/2019 07:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_tours_clubs_results] (
  [tour_id],
  [club_id],
  [rating_delta],
  [rating],
  [rank],
  [users_count]
)
AS
  select 
    [tour_id],
    [club_id],
    [rating_delta],
    [rating],
    [rank],
    [users_count]
  from
    tours_clubs_results

GO

/****** Object:  View [dbo].[vw_tours_results]    Script Date: 03/02/2019 07:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[vw_tours_results] (
  [tour_id],
  [user_id],
  [chup_count],
  [chup],
  [chup_club],
  [chup0],
  [chup0_count],
  [chup1],
  [chup1_count],
  [chup2],
  [chup2_count],
  [chup3],
  [chup3_count],
  [chup4],
  [chup4_count],
  [chup5],
  [chup5_count],
  [chup6],
  [chup6_count],
  [rival_chup],
  [nodifference], /* число совпадающих прогнозов с соперником (нет гола) */
  [win], /* число "забитых голов" -- угаданных результатов в расхождениях */
  [lose], /* число "пропущенных голов" -- неугаданных результатов в расхождениях */
  [draw], /* число "ничьих" -- когда оба не угадали */
  [rating_delta], /* изменение в рейтинге */
  [rating],
  [rank],
  [experience],
  [luck],
  [stakes_count],
  [achup],
  [psp],
  [goal_max],
  [goal_middle],
  [goal_min],
  [seria_wins],
  [seria_nolose],
  [seria_nowins],
  [seria_lose],
  [is_rated]
)
AS
  select 
    [tour_id],
    [user_id],
    [chup_count],
    [chup],
    [chup_club],
    [chup0],
    [chup0_count],
    [chup1],
    [chup1_count],
    [chup2],
    [chup2_count],
    [chup3],
    [chup3_count],
    [chup4],
    [chup4_count],
    [chup5],
    [chup5_count],
    [chup6],
    [chup6_count],
    [rival_chup],
    [nodifference],
    [win],
    [lose],
    [draw],
    [rating_delta],
    [rating],
    [rank],
    [experience],
    [luck],
    [stakes_count],
    [achup],
    [psp],
    [goal_max],
    [goal_middle],
    [goal_min],
    [seria_wins],
    [seria_nolose],
    [seria_nowins],
    [seria_lose],
    [is_rated]
  from
    tours_results r







GO

/****** Object:  View [dbo].[vw_users]    Script Date: 03/02/2019 07:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [dbo].[vw_users] (
  [user_id],
  [uid],
  [club_id],
  [club_code],
  [country_id],
  [country_code],
  [country_acrm],
  [country_name],
  [club_name],
  [club_national_name],
  [club_rating],
  [user_rating],
  [user_exp],
  [user_rank],
  [luck],
  [achup],
  [license_type], /* 0 - free, 1 - pro, 2 - vip */
  [license_expired],
  [license_expired_text],
  [played_tours],
  [is_show_result],
  [is_rated],
  [is_deleted]
)
AS
  select 
    [user_id],
    [uid],
    u.[club_id],
    c.[club_code],
    c.[country_id],
    c.[country_code],
    c.[country_acrm],
    c.[country_name],
    c.[club_name],
    c.[club_national_name],
    c.[club_rating],
    u.[user_rating],
    u.[user_exp],
    u.[user_rank],
    u.[luck],
    u.[achup],
    u.[license_type],
    u.[license_expired],
    case when u.[license_expired] is null then ''
      else convert(varchar(10), u.[license_expired], 104) + ' ' + convert(varchar(5), u.[license_expired], 108) end,
    u.played_tours,
    u.[is_show_result],
    u.[is_rated],
    u.[is_deleted]
  from
    users u
    inner join vw_clubs c on c.club_id = u.club_id




GO

