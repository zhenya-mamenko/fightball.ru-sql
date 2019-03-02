USE [fightball.pro]
GO

/****** Object:  Table [dbo].[awards]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[awards](
	[award_id] [int] NOT NULL,
	[tour_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[award_type] [tinyint] NOT NULL,
	[award_subtype] [tinyint] NOT NULL,
	[award_description] [varchar](100) NOT NULL,
	[date_achieve] [smalldatetime] NOT NULL,
	[date_lost] [smalldatetime] NULL,
 CONSTRAINT [PK_awards] PRIMARY KEY CLUSTERED 
(
	[award_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - кубок, 1 - орден, 2 - медаль' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'awards', @level2type=N'COLUMN',@level2name=N'award_type'
GO

USE [fightball.pro]
GO

/****** Object:  Table [dbo].[clubs]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[clubs](
	[club_id] [smallint] NOT NULL,
	[country_id] [tinyint] NOT NULL,
	[club_name] [varchar](50) NOT NULL,
	[club_national_name] [nvarchar](50) NOT NULL,
	[club_rating] [int] NOT NULL,
 CONSTRAINT [PK_clubs] PRIMARY KEY CLUSTERED 
(
	[club_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [fightball.pro]
GO

/****** Object:  Table [dbo].[config_values]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[config_values](
	[user_id] [int] NOT NULL,
	[config] [varchar](50) NOT NULL,
	[value] [varchar](100) NOT NULL,
 CONSTRAINT [PK_config_values] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC,
	[config] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [fightball.pro]
GO

/****** Object:  Table [dbo].[countries]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[countries](
	[country_id] [tinyint] NOT NULL,
	[country_name] [varchar](50) NOT NULL,
	[country_acrm] [varchar](2) NOT NULL,
 CONSTRAINT [PK_countries] PRIMARY KEY CLUSTERED 
(
	[country_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [fightball.pro]
GO

/****** Object:  Table [dbo].[locks]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[locks](
	[lock_type] [varchar](50) NOT NULL,
 CONSTRAINT [PK_locks] PRIMARY KEY CLUSTERED 
(
	[lock_type] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [fightball.pro]
GO

/****** Object:  Table [dbo].[matches]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[matches](
	[match_id] [int] NOT NULL,
	[tour_id] [int] NOT NULL,
	[order_num] [tinyint] NOT NULL,
	[match_date] [smalldatetime] NOT NULL,
	[place] [nvarchar](100) NOT NULL,
	[tournament_name] [nvarchar](50) NOT NULL,
	[club1_id] [smallint] NOT NULL,
	[club1_results] [varchar](10) NOT NULL,
	[club2_id] [smallint] NOT NULL,
	[club2_results] [varchar](10) NOT NULL,
	[stakes0] [numeric](4, 1) NOT NULL,
	[stakes1] [numeric](4, 1) NOT NULL,
	[stakes2] [numeric](4, 1) NOT NULL,
	[score] [varchar](10) NOT NULL,
	[description] [varchar](max) NOT NULL,
	[is_finished] [bit] NOT NULL,
 CONSTRAINT [PK_matches] PRIMARY KEY CLUSTERED 
(
	[match_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [fightball.pro]
GO

/****** Object:  Table [dbo].[matches_details]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[matches_details](
	[match_id] [int] NOT NULL,
	[detail_num] [tinyint] NOT NULL,
	[home_team] [tinyint] NOT NULL,
	[detail_date] [smalldatetime] NOT NULL,
	[place] [nvarchar](100) NOT NULL,
	[tournament_name] [nvarchar](50) NOT NULL,
	[score] [varchar](10) NOT NULL,
 CONSTRAINT [PK_matches_details] PRIMARY KEY CLUSTERED 
(
	[match_id] ASC,
	[detail_num] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [fightball.pro]
GO

/****** Object:  Table [dbo].[orders]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[orders](
	[order_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[vk_order_id] [int] NOT NULL,
	[item] [varchar](50) NOT NULL,
	[cost] [int] NOT NULL,
	[tour_id] [int] NOT NULL,
	[order_date] [datetime] NOT NULL,
 CONSTRAINT [PK_orders] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [fightball.pro]
GO

/****** Object:  Table [dbo].[pin_codes]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[pin_codes](
	[PIN] [varchar](32) NOT NULL,
	[type] [tinyint] NOT NULL,
	[expire_date] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_pin_codes] PRIMARY KEY CLUSTERED 
(
	[PIN] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [fightball.pro]
GO

/****** Object:  Table [dbo].[rating_headers]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[rating_headers](
	[header_id] [int] NOT NULL,
	[tab_id] [tinyint] NOT NULL,
	[col_id] [tinyint] NOT NULL,
	[header_name] [varchar](50) NOT NULL,
	[optional_name] [varchar](50) NOT NULL,
	[sql] [varchar](1500) NOT NULL,
	[join_table] [varchar](500) NOT NULL,
	[suffix] [varchar](10) NOT NULL,
 CONSTRAINT [PK_rating_headers] PRIMARY KEY NONCLUSTERED 
(
	[header_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [fightball.pro]
GO

/****** Object:  Table [dbo].[rivals]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[rivals](
	[tour_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[rival_id] [int] NULL,
	[new_vk_uid] [bigint] NULL,
	[rating_min] [int] NULL,
	[rating_max] [int] NULL,
	[club_id] [smallint] NULL,
	[challenge_user_id] [int] NULL,
 CONSTRAINT [PK_rivals] PRIMARY KEY CLUSTERED 
(
	[tour_id] ASC,
	[user_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [fightball.pro]
GO

/****** Object:  Table [dbo].[robot_stakes]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[robot_stakes](
	[match_id] [int] NOT NULL,
	[robot_id] [int] NOT NULL,
	[stakes] [tinyint] NOT NULL,
 CONSTRAINT [PK_robot_stakes] PRIMARY KEY CLUSTERED 
(
	[match_id] ASC,
	[robot_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [fightball.pro]
GO

/****** Object:  Table [dbo].[robots]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[robots](
	[robot_id] [int] NOT NULL,
	[rating] [int] NOT NULL,
 CONSTRAINT [PK_robots] PRIMARY KEY CLUSTERED 
(
	[robot_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [fightball.pro]
GO

/****** Object:  Table [dbo].[stakes]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stakes](
	[match_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[stakes] [tinyint] NOT NULL,
 CONSTRAINT [PK_stakes] PRIMARY KEY CLUSTERED 
(
	[match_id] ASC,
	[user_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [fightball.pro]
GO

/****** Object:  Table [dbo].[tours]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tours](
	[tour_id] [int] NOT NULL,
	[tour_num] [int] NOT NULL,
	[tour_description] [varchar](500) NOT NULL,
	[tour_start_date] [smalldatetime] NOT NULL,
	[tour_end_date] [smalldatetime] NOT NULL,
	[is_visible] [bit] NOT NULL,
	[is_matches_finished] [bit] NOT NULL,
	[matches_finished_date] [smalldatetime] NULL,
 CONSTRAINT [PK_tours] PRIMARY KEY CLUSTERED 
(
	[tour_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [fightball.pro]
GO

/****** Object:  Table [dbo].[tours_clubs_results]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tours_clubs_results](
	[tour_id] [int] NOT NULL,
	[club_id] [smallint] NOT NULL,
	[rating_delta] [int] NOT NULL,
	[rating] [int] NOT NULL,
	[rank] [int] NOT NULL,
	[users_count] [int] NOT NULL,
 CONSTRAINT [PK_clubs_resuts] PRIMARY KEY CLUSTERED 
(
	[tour_id] ASC,
	[club_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [fightball.pro]
GO

/****** Object:  Table [dbo].[tours_results]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tours_results](
	[tour_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[chup_count] [tinyint] NOT NULL,
	[chup] [tinyint] NOT NULL,
	[chup_club] [tinyint] NOT NULL,
	[chup0] [tinyint] NOT NULL,
	[chup0_count] [tinyint] NOT NULL,
	[chup1] [tinyint] NOT NULL,
	[chup1_count] [tinyint] NOT NULL,
	[chup2] [tinyint] NOT NULL,
	[chup2_count] [tinyint] NOT NULL,
	[chup3] [tinyint] NOT NULL,
	[chup3_count] [tinyint] NOT NULL,
	[chup4] [tinyint] NOT NULL,
	[chup4_count] [tinyint] NOT NULL,
	[chup5] [tinyint] NOT NULL,
	[chup5_count] [tinyint] NOT NULL,
	[chup6] [tinyint] NOT NULL,
	[chup6_count] [tinyint] NOT NULL,
	[rival_chup] [tinyint] NOT NULL,
	[nodifference] [tinyint] NOT NULL,
	[win] [tinyint] NOT NULL,
	[lose] [tinyint] NOT NULL,
	[draw] [tinyint] NOT NULL,
	[rating_delta] [int] NOT NULL,
	[rating] [int] NOT NULL,
	[rank] [int] NOT NULL,
	[experience] [int] NOT NULL,
	[luck] [tinyint] NOT NULL,
	[stakes_count] [tinyint] NOT NULL,
	[achup] [float] NOT NULL,
	[psp] [numeric](4, 1) NOT NULL,
	[goal_max] [tinyint] NOT NULL,
	[goal_middle] [tinyint] NOT NULL,
	[goal_min] [tinyint] NOT NULL,
	[seria_wins] [smallint] NOT NULL,
	[seria_nolose] [smallint] NOT NULL,
	[seria_nowins] [smallint] NOT NULL,
	[seria_lose] [smallint] NOT NULL,
	[best] [varchar](30) NOT NULL,
	[is_rated] [bit] NOT NULL,
 CONSTRAINT [PK_tours_resuts] PRIMARY KEY CLUSTERED 
(
	[tour_id] ASC,
	[user_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'число совпадающих прогнозов с соперником (нет гола)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tours_results', @level2type=N'COLUMN',@level2name=N'nodifference'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'число "забитых голов" -- угаданных результатов в расхождениях' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tours_results', @level2type=N'COLUMN',@level2name=N'win'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'число "пропущенных голов" -- неугаданных результатов в расхождениях' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tours_results', @level2type=N'COLUMN',@level2name=N'lose'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'изменение в рейтинге' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tours_results', @level2type=N'COLUMN',@level2name=N'rating_delta'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'отношение ЧУП к среднему ЧУП' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tours_results', @level2type=N'COLUMN',@level2name=N'achup'
GO

USE [fightball.pro]
GO

/****** Object:  Table [dbo].[users]    Script Date: 03/02/2019 07:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[users](
	[user_id] [int] NOT NULL,
	[uid] [bigint] NOT NULL,
	[club_id] [smallint] NOT NULL,
	[user_rating] [int] NOT NULL,
	[user_exp] [bigint] NOT NULL,
	[user_rank] [int] NOT NULL,
	[luck] [tinyint] NOT NULL,
	[achup] [float] NOT NULL,
	[license_type] [tinyint] NOT NULL,
	[license_expired] [smalldatetime] NULL,
	[played_tours] [int] NOT NULL,
	[is_show_result] [bit] NOT NULL,
	[is_rated] [bit] NOT NULL,
	[is_deleted] [bit] NOT NULL,
	[registration_date] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - free, 1 - pro, 2 - vip' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'users', @level2type=N'COLUMN',@level2name=N'license_type'
GO

ALTER TABLE [dbo].[awards]  WITH CHECK ADD  CONSTRAINT [FK_awards_tours] FOREIGN KEY([tour_id])
REFERENCES [dbo].[tours] ([tour_id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[awards] CHECK CONSTRAINT [FK_awards_tours]
GO

ALTER TABLE [dbo].[awards]  WITH CHECK ADD  CONSTRAINT [FK_awards_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO

ALTER TABLE [dbo].[awards] CHECK CONSTRAINT [FK_awards_users]
GO

ALTER TABLE [dbo].[awards] ADD  CONSTRAINT [DF_awards_award_type]  DEFAULT ((2)) FOR [award_type]
GO

ALTER TABLE [dbo].[awards] ADD  CONSTRAINT [DF_awards_award_subtype]  DEFAULT ((0)) FOR [award_subtype]
GO

ALTER TABLE [dbo].[awards] ADD  CONSTRAINT [DF_awards_award_description]  DEFAULT ('') FOR [award_description]
GO

ALTER TABLE [dbo].[awards] ADD  CONSTRAINT [DF_awards_date_achieve]  DEFAULT (getdate()) FOR [date_achieve]
GO

ALTER TABLE [dbo].[clubs]  WITH CHECK ADD  CONSTRAINT [FK_clubs_countries] FOREIGN KEY([country_id])
REFERENCES [dbo].[countries] ([country_id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[clubs] CHECK CONSTRAINT [FK_clubs_countries]
GO

ALTER TABLE [dbo].[clubs] ADD  CONSTRAINT [DF_clubs_club_rating]  DEFAULT ((0)) FOR [club_rating]
GO

ALTER TABLE [dbo].[matches]  WITH CHECK ADD  CONSTRAINT [FK_matches_tours] FOREIGN KEY([tour_id])
REFERENCES [dbo].[tours] ([tour_id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[matches] CHECK CONSTRAINT [FK_matches_tours]
GO

ALTER TABLE [dbo].[matches] ADD  CONSTRAINT [DF_matches_stakes0]  DEFAULT ((0)) FOR [stakes0]
GO

ALTER TABLE [dbo].[matches] ADD  CONSTRAINT [DF_matches_stakes1]  DEFAULT ((0)) FOR [stakes1]
GO

ALTER TABLE [dbo].[matches] ADD  CONSTRAINT [DF_matches_stakes2]  DEFAULT ((0)) FOR [stakes2]
GO

ALTER TABLE [dbo].[matches] ADD  CONSTRAINT [DF_matches_score]  DEFAULT ('') FOR [score]
GO

ALTER TABLE [dbo].[matches] ADD  CONSTRAINT [DF_matches_description]  DEFAULT ('') FOR [description]
GO

ALTER TABLE [dbo].[matches] ADD  CONSTRAINT [DF_matches_is_finished]  DEFAULT ((0)) FOR [is_finished]
GO

ALTER TABLE [dbo].[matches_details]  WITH CHECK ADD  CONSTRAINT [FK_matches_details_matches] FOREIGN KEY([match_id])
REFERENCES [dbo].[matches] ([match_id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[matches_details] CHECK CONSTRAINT [FK_matches_details_matches]
GO

ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FK_orders_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FK_orders_users]
GO

ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF_orders_cost]  DEFAULT ((0)) FOR [cost]
GO

ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF_orders_tour_id]  DEFAULT ((0)) FOR [tour_id]
GO

ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF_orders_order_date]  DEFAULT (getdate()) FOR [order_date]
GO

ALTER TABLE [dbo].[pin_codes] ADD  CONSTRAINT [DF_pin_codes_type]  DEFAULT ((1)) FOR [type]
GO

ALTER TABLE [dbo].[rating_headers] ADD  CONSTRAINT [DF_rating_headers_join_table]  DEFAULT ('') FOR [join_table]
GO

ALTER TABLE [dbo].[rating_headers] ADD  CONSTRAINT [DF_rating_headers_suffix]  DEFAULT ('') FOR [suffix]
GO

ALTER TABLE [dbo].[rivals]  WITH CHECK ADD  CONSTRAINT [FK_rivals_tours] FOREIGN KEY([tour_id])
REFERENCES [dbo].[tours] ([tour_id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[rivals] CHECK CONSTRAINT [FK_rivals_tours]
GO

ALTER TABLE [dbo].[rivals]  WITH CHECK ADD  CONSTRAINT [FK_rivals_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[rivals] CHECK CONSTRAINT [FK_rivals_users]
GO

ALTER TABLE [dbo].[robot_stakes]  WITH CHECK ADD  CONSTRAINT [FK_robot_stakes_matches] FOREIGN KEY([match_id])
REFERENCES [dbo].[matches] ([match_id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[robot_stakes] CHECK CONSTRAINT [FK_robot_stakes_matches]
GO

ALTER TABLE [dbo].[robot_stakes]  WITH CHECK ADD  CONSTRAINT [FK_robot_stakes_robots] FOREIGN KEY([robot_id])
REFERENCES [dbo].[robots] ([robot_id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[robot_stakes] CHECK CONSTRAINT [FK_robot_stakes_robots]
GO

ALTER TABLE [dbo].[stakes]  WITH CHECK ADD  CONSTRAINT [FK_stakes_matches] FOREIGN KEY([match_id])
REFERENCES [dbo].[matches] ([match_id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[stakes] CHECK CONSTRAINT [FK_stakes_matches]
GO

ALTER TABLE [dbo].[stakes]  WITH CHECK ADD  CONSTRAINT [FK_stakes_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[stakes] CHECK CONSTRAINT [FK_stakes_users]
GO

ALTER TABLE [dbo].[tours] ADD  CONSTRAINT [DF_tours_tour_description]  DEFAULT ('') FOR [tour_description]
GO

ALTER TABLE [dbo].[tours] ADD  CONSTRAINT [DF_tours_is_visible]  DEFAULT ((0)) FOR [is_visible]
GO

ALTER TABLE [dbo].[tours] ADD  CONSTRAINT [DF_tours_is_matches_finished]  DEFAULT ((0)) FOR [is_matches_finished]
GO

ALTER TABLE [dbo].[tours_clubs_results]  WITH CHECK ADD  CONSTRAINT [FK_clubs_results_clubs] FOREIGN KEY([club_id])
REFERENCES [dbo].[clubs] ([club_id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[tours_clubs_results] CHECK CONSTRAINT [FK_clubs_results_clubs]
GO

ALTER TABLE [dbo].[tours_clubs_results]  WITH CHECK ADD  CONSTRAINT [FK_clubs_results_tours] FOREIGN KEY([tour_id])
REFERENCES [dbo].[tours] ([tour_id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[tours_clubs_results] CHECK CONSTRAINT [FK_clubs_results_tours]
GO

ALTER TABLE [dbo].[tours_clubs_results] ADD  CONSTRAINT [DF_clubs_results_rating_delta]  DEFAULT ((0)) FOR [rating_delta]
GO

ALTER TABLE [dbo].[tours_clubs_results] ADD  CONSTRAINT [DF_clubs_results_rating]  DEFAULT ((0)) FOR [rating]
GO

ALTER TABLE [dbo].[tours_clubs_results] ADD  CONSTRAINT [DF_clubs_results_rank]  DEFAULT ((0)) FOR [rank]
GO

ALTER TABLE [dbo].[tours_clubs_results] ADD  CONSTRAINT [DF_clubs_results_users_count]  DEFAULT ((0)) FOR [users_count]
GO

ALTER TABLE [dbo].[tours_results]  WITH CHECK ADD  CONSTRAINT [FK_tours_results_tours] FOREIGN KEY([tour_id])
REFERENCES [dbo].[tours] ([tour_id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[tours_results] CHECK CONSTRAINT [FK_tours_results_tours]
GO

ALTER TABLE [dbo].[tours_results]  WITH CHECK ADD  CONSTRAINT [FK_tours_results_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[tours_results] CHECK CONSTRAINT [FK_tours_results_users]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_chup_count]  DEFAULT ((0)) FOR [chup_count]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_chup]  DEFAULT ((0)) FOR [chup]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_chup_club]  DEFAULT ((0)) FOR [chup_club]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_chup0]  DEFAULT ((0)) FOR [chup0]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_chup0_count]  DEFAULT ((0)) FOR [chup0_count]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_chup1]  DEFAULT ((0)) FOR [chup1]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_chup1_count]  DEFAULT ((0)) FOR [chup1_count]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_chup2]  DEFAULT ((0)) FOR [chup2]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_chup2_count]  DEFAULT ((0)) FOR [chup2_count]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_chup3]  DEFAULT ((0)) FOR [chup3]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_chup3_count]  DEFAULT ((0)) FOR [chup3_count]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_chup4]  DEFAULT ((0)) FOR [chup4]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_chup4_count]  DEFAULT ((0)) FOR [chup4_count]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_chup5]  DEFAULT ((0)) FOR [chup5]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_chup5_count]  DEFAULT ((0)) FOR [chup5_count]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_chup6]  DEFAULT ((0)) FOR [chup6]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_chup6_count]  DEFAULT ((0)) FOR [chup6_count]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_rival_chup]  DEFAULT ((0)) FOR [rival_chup]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_nodifference]  DEFAULT ((0)) FOR [nodifference]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_win]  DEFAULT ((0)) FOR [win]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_lose]  DEFAULT ((0)) FOR [lose]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_draw]  DEFAULT ((0)) FOR [draw]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_rating_delta]  DEFAULT ((0)) FOR [rating_delta]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_rating]  DEFAULT ((0)) FOR [rating]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_rank]  DEFAULT ((0)) FOR [rank]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_experience]  DEFAULT ((0)) FOR [experience]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_luck]  DEFAULT ((0)) FOR [luck]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_stakes_count]  DEFAULT ((0)) FOR [stakes_count]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_achup]  DEFAULT ((1)) FOR [achup]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_psp]  DEFAULT ((0)) FOR [psp]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_goal_max]  DEFAULT ((0)) FOR [goal_max]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_goal_middle]  DEFAULT ((0)) FOR [goal_middle]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_goal_min]  DEFAULT ((0)) FOR [goal_min]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_seria_wins]  DEFAULT ((0)) FOR [seria_wins]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_seria_nolose]  DEFAULT ((0)) FOR [seria_nolose]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_seria_nowins]  DEFAULT ((0)) FOR [seria_nowins]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_seria_lose]  DEFAULT ((0)) FOR [seria_lose]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_best]  DEFAULT ('') FOR [best]
GO

ALTER TABLE [dbo].[tours_results] ADD  CONSTRAINT [DF_tours_results_is_rated]  DEFAULT ((0)) FOR [is_rated]
GO

ALTER TABLE [dbo].[users] ADD  CONSTRAINT [DF_users_luck]  DEFAULT ((0)) FOR [luck]
GO

ALTER TABLE [dbo].[users] ADD  CONSTRAINT [DF_users_achup]  DEFAULT ((1)) FOR [achup]
GO

ALTER TABLE [dbo].[users] ADD  CONSTRAINT [DF_users_is_pro]  DEFAULT ((0)) FOR [license_type]
GO

ALTER TABLE [dbo].[users] ADD  CONSTRAINT [DF_users_played_tours]  DEFAULT ((0)) FOR [played_tours]
GO

ALTER TABLE [dbo].[users] ADD  CONSTRAINT [DF_users_is_show_result]  DEFAULT ((0)) FOR [is_show_result]
GO

ALTER TABLE [dbo].[users] ADD  CONSTRAINT [DF_users_is_rated]  DEFAULT ((0)) FOR [is_rated]
GO

ALTER TABLE [dbo].[users] ADD  CONSTRAINT [DF_users_is_deleted]  DEFAULT ((0)) FOR [is_deleted]
GO

ALTER TABLE [dbo].[users] ADD  CONSTRAINT [DF_users_registration_date]  DEFAULT (getdate()) FOR [registration_date]
GO

