
-- =============================================
-- Author:		Johnny Frits
-- Create date: 15/11/2021
-- Description:	Get the current balance
-- =============================================
CREATE FUNCTION [dbo].[GetCurrentBalance] 
(
	-- Add the parameters for the function here
	@AccountId INT, 
	@Reference VARCHAR(6)
)
RETURNS NUMERIC(18,2)
AS
BEGIN

	DECLARE @CurrentBalance NUMERIC(18,2) = (
	
	SELECT TOP 1 SUM(T.Amount) OVER () AS CurrentBalance
	FROM (
		  SELECT AccountId, Reference, Amount 
		  FROM Yields
	
		  UNION ALL 
	
	      SELECT AccountId, Reference, Amount
	      FROM [Budget].[dbo].[AccountsPostings]
	) T
	WHERE T.AccountId = @AccountId AND
		  T.Reference = @Reference
	)
	RETURN IsNull(@CurrentBalance, 0)

END
GO
/****** Object:  UserDefinedFunction [dbo].[GetPreviousBalance]    Script Date: 25/11/2021 13:10:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Johnny Frits
-- Create date: 15/11/2021
-- Description:	Get the previous balance
-- =============================================
CREATE FUNCTION [dbo].[GetPreviousBalance] 
(
	-- Add the parameters for the function here
	@AccountId INT, 
	@Reference VARCHAR(6)
)
RETURNS NUMERIC(18,2)
AS
BEGIN

	DECLARE @PreviousBalance NUMERIC(18,2) = (
	
	SELECT TOP 1 SUM(T.Amount) OVER () AS PreviousBalance
	FROM (
		  SELECT AccountId, Reference, Amount 
		  FROM Yields
	
		  UNION ALL 
	
	      SELECT AccountId, Reference, Amount
	      FROM [Budget].[dbo].[AccountsPostings]
	) T
	WHERE T.AccountId = @AccountId AND
		  T.Reference < @Reference
	)
	RETURN IsNull(@PreviousBalance, 0)

END
GO
/****** Object:  UserDefinedFunction [dbo].[GetTotalBalance]    Script Date: 25/11/2021 13:10:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Johnny Frits
-- Create date: 15/11/2021
-- Description:	Get the total balance
-- =============================================
CREATE FUNCTION [dbo].[GetTotalBalance] 
(
	-- Add the parameters for the function here
	@AccountId INT, 
	@Reference VARCHAR(6)
)
RETURNS NUMERIC(18,2)
AS
BEGIN

	DECLARE @CurrentBalance NUMERIC(18,2) = dbo.GetPreviousBalance(@AccountId, @Reference) + dbo.GetCurrentBalance(@AccountId, @Reference)
	RETURN @CurrentBalance

END
GO
/****** Object:  Table [dbo].[Accounts]    Script Date: 25/11/2021 13:10:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Accounts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Color] [varchar](20) NULL,
 CONSTRAINT [PK_Accounts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccountsPostings]    Script Date: 25/11/2021 13:10:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountsPostings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[Reference] [varchar](6) NOT NULL,
	[Description] [varchar](150) NOT NULL,
	[Amount] [numeric](18, 2) NOT NULL,
 CONSTRAINT [PK_AccountsPostings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cards]    Script Date: 25/11/2021 13:10:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cards](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Color] [varchar](20) NULL,
 CONSTRAINT [PK_Cards] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CardsPostings]    Script Date: 25/11/2021 13:10:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CardsPostings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CardId] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[Reference] [varchar](6) NOT NULL,
	[Description] [varchar](150) NOT NULL,
	[ParcelNumber] [int] NULL,
	[Parcels] [int] NULL,
	[Amount] [numeric](18, 2) NOT NULL,
	[TotalAmount] [numeric](18, 2) NULL,
	[Others] [bit] NOT NULL,
 CONSTRAINT [PK_CardsPostings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 25/11/2021 13:10:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](150) NOT NULL,
	[Login] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Yields]    Script Date: 25/11/2021 13:10:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Yields](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[Date] [date] NULL,
	[Reference] [varchar](6) NOT NULL,
	[Amount] [numeric](18, 2) NOT NULL,
 CONSTRAINT [PK_Yields] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Accounts] ON 
GO
INSERT [dbo].[Accounts] ([Id], [UserId], [Name], [Color]) VALUES (1, 1, N'Casa', N'fff2cc')
GO
INSERT [dbo].[Accounts] ([Id], [UserId], [Name], [Color]) VALUES (2, 1, N'PicPay', N'22c25f')
GO
INSERT [dbo].[Accounts] ([Id], [UserId], [Name], [Color]) VALUES (3, 1, N'PicPay (BF)', N'ff3399')
GO
INSERT [dbo].[Accounts] ([Id], [UserId], [Name], [Color]) VALUES (4, 1, N'Casa (BF)', N'fff2cc')
GO
SET IDENTITY_INSERT [dbo].[Accounts] OFF
GO
SET IDENTITY_INSERT [dbo].[AccountsPostings] ON 
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (1, 2, CAST(N'2021-01-12' AS Date), N'202101', N'Rec. Empréstimo BF', CAST(920.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (2, 2, CAST(N'2021-01-11' AS Date), N'202101', N'Maquina Mamãe', CAST(1674.35 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (3, 2, CAST(N'2021-01-11' AS Date), N'202101', N'Pag. Bemol Mãe Antec.', CAST(125.65 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (4, 2, CAST(N'2021-01-12' AS Date), N'202101', N'Conserto Caixa', CAST(400.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (5, 2, CAST(N'2021-01-17' AS Date), N'202101', N'Pag. Tayse (gasolina)', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (6, 2, CAST(N'2021-01-18' AS Date), N'202101', N'Pag. Pedio Sutiã', CAST(-893.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (7, 2, CAST(N'2021-01-18' AS Date), N'202101', N'Rec. BF ref. Pedido sutiã', CAST(439.19 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (8, 2, CAST(N'2021-01-28' AS Date), N'202101', N'Rec. Cinthia', CAST(420.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (9, 2, CAST(N'2021-01-28' AS Date), N'202101', N'Rec. Cinthia', CAST(681.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (10, 2, CAST(N'2021-01-29' AS Date), N'202101', N'Rec. Salário', CAST(5055.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (11, 2, CAST(N'2021-01-29' AS Date), N'202101', N'Rec. Lucia', CAST(0.76 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (12, 2, CAST(N'2021-01-29' AS Date), N'202101', N'Transf. PagBank', CAST(0.96 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (13, 2, CAST(N'2021-01-29' AS Date), N'202101', N'Emprestado para BF', CAST(-1123.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (14, 2, CAST(N'2021-01-29' AS Date), N'202101', N'Rec. BF ref. Pedido sutiã', CAST(440.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (15, 2, CAST(N'2021-01-29' AS Date), N'202101', N'Rec. Sharla', CAST(266.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (16, 2, CAST(N'2021-01-29' AS Date), N'202101', N'Emp. BF pag. Frete', CAST(-70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (17, 2, CAST(N'2021-01-29' AS Date), N'202101', N'Rec. PicPay', CAST(10.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (18, 2, CAST(N'2021-01-30' AS Date), N'202101', N'Rec. Josi', CAST(211.80 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (19, 2, CAST(N'2021-01-30' AS Date), N'202101', N'Rec. Josi', CAST(773.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (20, 2, CAST(N'2021-01-30' AS Date), N'202101', N'Rec. Augusta (irmã Josi)', CAST(308.15 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (21, 2, CAST(N'2021-01-30' AS Date), N'202101', N'Transf. p/ BF ref. Pag. Augusta', CAST(-67.48 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (22, 2, CAST(N'2021-01-30' AS Date), N'202101', N'Transf. p/ BF ref. Pag. Josi', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (23, 2, CAST(N'2021-01-30' AS Date), N'202101', N'Rec. Empréstimo BF', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (24, 2, CAST(N'2021-01-30' AS Date), N'202101', N'Pag. + Devoluçao p/ Josi', CAST(-177.60 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (25, 2, CAST(N'2021-01-30' AS Date), N'202101', N'Saldo Josi em conta', CAST(177.60 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (26, 2, CAST(N'2021-01-30' AS Date), N'202101', N'Pag. Bemol Cinthia', CAST(-256.68 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (27, 2, CAST(N'2021-01-30' AS Date), N'202101', N'Pag. Bemol Josi', CAST(-210.25 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (28, 2, CAST(N'2021-01-30' AS Date), N'202101', N'Rec. iPhone', CAST(320.67 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (29, 2, CAST(N'2021-01-30' AS Date), N'202101', N'Rec. Empréstimo BF', CAST(13.81 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (30, 2, CAST(N'2021-02-01' AS Date), N'202101', N'Rec. BF ref. Minizinha', CAST(8.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (31, 2, CAST(N'2021-02-01' AS Date), N'202101', N'Rec. BF. ref. Pag. Gold', CAST(297.47 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (32, 2, CAST(N'2021-02-01' AS Date), N'202101', N'Pag. Fatura Gold', CAST(-2398.57 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (33, 2, CAST(N'2021-02-01' AS Date), N'202101', N'Pag. Fatura Nubank', CAST(-204.89 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (34, 2, CAST(N'2021-02-01' AS Date), N'202101', N'Pag. Fatura Neon', CAST(-741.53 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (35, 2, CAST(N'2021-02-01' AS Date), N'202101', N'Pag. Fatura C6 Bank', CAST(-3719.35 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (36, 2, CAST(N'2021-02-01' AS Date), N'202101', N'Pag. Fatura Carrefour', CAST(-350.52 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (37, 2, CAST(N'2021-02-01' AS Date), N'202101', N'Pag. Luz', CAST(-274.30 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (38, 2, CAST(N'2021-01-01' AS Date), N'202101', N'Pag. Caixa Econômica', CAST(-274.79 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (39, 2, CAST(N'2021-02-01' AS Date), N'202101', N'Pag. Condominio', CAST(-190.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (40, 2, CAST(N'2021-02-01' AS Date), N'202101', N'Pag. Internet', CAST(-89.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (41, 2, CAST(N'2021-02-02' AS Date), N'202101', N'Dinheiro conserto caixa', CAST(-400.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (42, 2, CAST(N'2021-02-02' AS Date), N'202101', N'Pag. Bemol Cinthia', CAST(-180.36 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (43, 2, CAST(N'2021-02-02' AS Date), N'202101', N'Rec. Empréstimo BF', CAST(898.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (44, 2, CAST(N'2021-02-02' AS Date), N'202101', N'Saldo Josi enviado p/ BF', CAST(-177.60 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (45, 2, CAST(N'2021-02-02' AS Date), N'202101', N'Rec. Paim (Netflix)', CAST(16.45 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (46, 2, CAST(N'2021-02-03' AS Date), N'202101', N'Rec. Paula', CAST(148.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (47, 2, CAST(N'2021-02-03' AS Date), N'202101', N'Rec. Pastora + Igreja', CAST(305.12 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (48, 2, CAST(N'2021-02-04' AS Date), N'202101', N'Rec. Mamae', CAST(150.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (49, 2, CAST(N'2021-02-04' AS Date), N'202101', N'Repasse BF', CAST(358.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (50, 2, CAST(N'2021-12-31' AS Date), N'202012', N'Saldo Dezembro', CAST(5335.52 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (51, 3, CAST(N'2021-02-04' AS Date), N'202102', N'Rec. Venda sutiã', CAST(23.75 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (52, 3, CAST(N'2021-02-04' AS Date), N'202102', N'Presente Bruna', CAST(-25.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (53, 3, CAST(N'2021-02-04' AS Date), N'202102', N'Pag. Castanhas Johanes', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (54, 3, CAST(N'2021-02-05' AS Date), N'202102', N'Depositado', CAST(350.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (55, 3, CAST(N'2021-02-05' AS Date), N'202102', N'Rec. Amanda vizinha', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (56, 3, CAST(N'2021-02-05' AS Date), N'202102', N'Rec. Karol', CAST(28.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (57, 3, CAST(N'2021-02-06' AS Date), N'202102', N'Rec. Andreia', CAST(40.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (58, 3, CAST(N'2021-02-07' AS Date), N'202102', N'Rec. Viviane', CAST(105.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (59, 3, CAST(N'2021-02-08' AS Date), N'202102', N'Rec. Venda sutiã Nilton', CAST(25.48 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (60, 3, CAST(N'2021-02-08' AS Date), N'202102', N'Rec. Leticia', CAST(145.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (61, 3, CAST(N'2021-02-08' AS Date), N'202102', N'Rec. Railson', CAST(59.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (62, 3, CAST(N'2021-02-08' AS Date), N'202102', N'Pag. Edina', CAST(-72.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (63, 3, CAST(N'2021-02-09' AS Date), N'202102', N'Rec. Beatriz', CAST(55.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (64, 3, CAST(N'2021-02-10' AS Date), N'202102', N'Pag. Bemol Josi', CAST(-365.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (65, 3, CAST(N'2021-02-13' AS Date), N'202102', N'Rec. Josi', CAST(200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (66, 3, CAST(N'2021-02-13' AS Date), N'202102', N'Rec. Josi Bemol', CAST(587.25 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (67, 3, CAST(N'2021-02-15' AS Date), N'202102', N'Pag. Compra Relógios', CAST(-501.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (68, 3, CAST(N'2021-02-15' AS Date), N'202102', N'Pag. Farinha', CAST(-350.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (69, 3, CAST(N'2021-02-15' AS Date), N'202102', N'Pag. Bemol Josi', CAST(-587.25 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (70, 3, CAST(N'2021-02-16' AS Date), N'202102', N'Pag. Frete', CAST(-80.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (71, 3, CAST(N'2021-02-16' AS Date), N'202102', N'Rec. Josi', CAST(35.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (72, 3, CAST(N'2021-02-16' AS Date), N'202102', N'Rec. Michelle', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (73, 3, CAST(N'2021-02-18' AS Date), N'202102', N'Pag. Karol Malafaia', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (74, 3, CAST(N'2021-02-19' AS Date), N'202102', N'Empréstimo JF', CAST(130.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (75, 3, CAST(N'2021-02-19' AS Date), N'202102', N'Pag. Pedido', CAST(-1149.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (76, 3, CAST(N'2021-02-20' AS Date), N'202102', N'Rec. Suellen', CAST(39.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (77, 3, CAST(N'2021-02-21' AS Date), N'202102', N'Rec. Dep. Dinheiro em casa', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (78, 3, CAST(N'2021-02-22' AS Date), N'202102', N'Pag. Lanche Andrezinho', CAST(-8.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (79, 3, CAST(N'2021-02-22' AS Date), N'202102', N'Pag. Emprestimo JF', CAST(-130.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (80, 3, CAST(N'2021-02-23' AS Date), N'202102', N'Empréstimo JF', CAST(347.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (81, 3, CAST(N'2021-02-23' AS Date), N'202102', N'Pag. Pedido', CAST(-347.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (82, 3, CAST(N'2021-02-27' AS Date), N'202102', N'Rec. Augusta', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (83, 3, CAST(N'2021-02-27' AS Date), N'202102', N'Rec. Depósito BF', CAST(200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (84, 3, CAST(N'2021-02-28' AS Date), N'202102', N'Rec. BF ref. C6 Bank', CAST(-115.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (85, 3, CAST(N'2021-02-28' AS Date), N'202102', N'Rec. BF ref. Iphone (Gold)', CAST(-62.34 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (86, 3, CAST(N'2021-02-28' AS Date), N'202102', N'Rec. BF ref. Minizinha', CAST(-8.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (87, 3, CAST(N'2021-03-02' AS Date), N'202102', N'Rec. Silane', CAST(72.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (88, 3, CAST(N'2021-03-02' AS Date), N'202102', N'Rec. Beatriz', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (89, 3, CAST(N'2021-03-03' AS Date), N'202102', N'Rec. Vanessa', CAST(80.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (90, 3, CAST(N'2021-03-03' AS Date), N'202102', N'Pag. Iphone (C6)', CAST(-258.33 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (91, 3, CAST(N'2021-03-04' AS Date), N'202102', N'Rec. Aurizete (pão)', CAST(35.28 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (92, 3, CAST(N'2021-03-04' AS Date), N'202102', N'Rec. Aurizete (pão)', CAST(45.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (93, 3, CAST(N'2021-03-05' AS Date), N'202102', N'Rec. Patricia', CAST(86.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (94, 3, CAST(N'2021-03-05' AS Date), N'202102', N'Rec. Viviane', CAST(300.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (95, 3, CAST(N'2021-03-05' AS Date), N'202102', N'Rec. Ariclene', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (96, 3, CAST(N'2021-03-05' AS Date), N'202102', N'Pag. Fatura Gold', CAST(-487.10 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (97, 3, CAST(N'2021-03-06' AS Date), N'202102', N'Rec. Amanda vizinha + Loyane', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (98, 3, CAST(N'2021-03-06' AS Date), N'202102', N'Rec. dinheiro depositado', CAST(200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (99, 3, CAST(N'2021-03-06' AS Date), N'202102', N'Pag. Emprestimo JF', CAST(-347.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (100, 2, CAST(N'2021-02-04' AS Date), N'202101', N'Pag. BTV B11', CAST(-1218.48 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (101, 2, CAST(N'2021-02-05' AS Date), N'202101', N'Depositado', CAST(150.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (102, 2, CAST(N'2021-02-08' AS Date), N'202101', N'Rec. Railson', CAST(61.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (103, 2, CAST(N'2021-02-19' AS Date), N'202101', N'Emprestado p/ BF', CAST(-130.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (104, 2, CAST(N'2021-02-21' AS Date), N'202101', N'Rec. Kerllyane', CAST(350.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (105, 2, CAST(N'2021-02-22' AS Date), N'202101', N'Rec. Emprestimo BF', CAST(130.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (106, 2, CAST(N'2021-02-23' AS Date), N'202101', N'Pag. Taxa Condomínio', CAST(-119.63 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (107, 2, CAST(N'2021-02-23' AS Date), N'202101', N'Emprestado p/ BF', CAST(-347.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (108, 2, CAST(N'2021-02-24' AS Date), N'202101', N'Licença Kaspersky', CAST(-39.59 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (109, 2, CAST(N'2021-02-25' AS Date), N'202101', N'Pag. conserto caixa', CAST(-400.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (110, 2, CAST(N'2021-02-26' AS Date), N'202101', N'Rec. Salário', CAST(5060.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (111, 2, CAST(N'2021-02-26' AS Date), N'202101', N'Rec. Lúcia Pgto Bemol', CAST(215.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (112, 2, CAST(N'2021-02-27' AS Date), N'202101', N'Rec. Sharla', CAST(267.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (113, 2, CAST(N'2021-02-27' AS Date), N'202101', N'Rec. Augusta', CAST(125.67 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (114, 2, CAST(N'2021-02-28' AS Date), N'202101', N'Rec. Josi', CAST(664.52 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (115, 2, CAST(N'2021-02-28' AS Date), N'202101', N'Pag. Bemol Ar Lucia', CAST(-214.70 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (116, 2, CAST(N'2021-02-28' AS Date), N'202101', N'Pag. Bemol Ar Josi', CAST(-214.70 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (117, 2, CAST(N'2021-02-28' AS Date), N'202101', N'Pag. Fatura Nubank', CAST(-115.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (118, 2, CAST(N'2021-02-28' AS Date), N'202101', N'Pag. Fatura Carrefour', CAST(-285.40 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (119, 2, CAST(N'2021-02-28' AS Date), N'202101', N'Pag. Bemol Ar Cinthia', CAST(-180.36 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (120, 2, CAST(N'2021-02-28' AS Date), N'202101', N'Pag. Action', CAST(-89.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (121, 2, CAST(N'2021-02-28' AS Date), N'202101', N'Pag. Luz', CAST(-221.92 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (122, 2, CAST(N'2021-02-28' AS Date), N'202101', N'Pag. Condominio', CAST(-190.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (123, 2, CAST(N'2021-02-28' AS Date), N'202101', N'Pag. Caixa', CAST(-274.78 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (124, 2, CAST(N'2021-02-28' AS Date), N'202101', N'Pag. Fatura Neon', CAST(-164.07 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (125, 2, CAST(N'2021-02-28' AS Date), N'202101', N'Rec. BF ref. C6 Bank', CAST(115.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (126, 2, CAST(N'2021-02-28' AS Date), N'202101', N'Rec. BF ref. Iphone (Gold)', CAST(62.34 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (127, 2, CAST(N'2021-02-28' AS Date), N'202101', N'Rec. BF ref. Minizinha', CAST(8.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (128, 2, CAST(N'2021-02-28' AS Date), N'202101', N'Rec. Paim', CAST(16.45 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (129, 2, CAST(N'2021-02-28' AS Date), N'202101', N'Rec. Cinthia', CAST(925.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (130, 2, CAST(N'2021-03-01' AS Date), N'202101', N'Pag. Bemol Triliche Cinthia', CAST(-256.68 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (131, 2, CAST(N'2021-03-01' AS Date), N'202101', N'Pag. Fatura Gold', CAST(-2381.82 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (132, 2, CAST(N'2021-03-01' AS Date), N'202101', N'Pag. Fatura Neon', CAST(-2252.34 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (133, 2, CAST(N'2021-03-03' AS Date), N'202101', N'Rec. Mamãe', CAST(270.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (134, 2, CAST(N'2021-03-03' AS Date), N'202101', N'Pag. Iphone (C6)', CAST(258.33 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (135, 2, CAST(N'2021-03-03' AS Date), N'202101', N'Rec. Igreja (caixa retorno)', CAST(126.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (136, 2, CAST(N'2021-03-05' AS Date), N'202101', N'Pag. Fatura Gold', CAST(487.10 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (137, 2, CAST(N'2021-03-06' AS Date), N'202101', N'Pag. Emprestimo JF', CAST(347.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (138, 2, CAST(N'2021-03-06' AS Date), N'202101', N'Rec. Emprestimo BF', CAST(400.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (139, 2, CAST(N'2021-03-08' AS Date), N'202101', N'Rec. Railson', CAST(59.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (140, 3, CAST(N'2020-12-31' AS Date), N'202001', N'Saldo Dezembro', CAST(716.69 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (141, 3, CAST(N'2021-01-12' AS Date), N'202101', N'Depósito Dinheiro em casa', CAST(350.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (142, 3, CAST(N'2021-01-12' AS Date), N'202101', N'Pag. Empréstimo JF', CAST(-920.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (143, 3, CAST(N'2021-01-14' AS Date), N'202101', N'Rec. Venda Labrea', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (144, 3, CAST(N'2021-01-15' AS Date), N'202101', N'Pag. Edna', CAST(-72.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (145, 3, CAST(N'2021-01-15' AS Date), N'202101', N'Rec. Karol Santana', CAST(130.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (146, 3, CAST(N'2021-01-15' AS Date), N'202101', N'Nayara Lábrea', CAST(45.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (147, 3, CAST(N'2021-01-15' AS Date), N'202101', N'Sharla', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (148, 3, CAST(N'2021-01-16' AS Date), N'202101', N'Rec. Amanda vizinha', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (149, 3, CAST(N'2021-01-18' AS Date), N'202101', N'Pag. JF ref. Pedido sutiã', CAST(-439.19 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (150, 3, CAST(N'2021-01-18' AS Date), N'202101', N'Pag. Cadernetas', CAST(-45.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (151, 3, CAST(N'2021-01-21' AS Date), N'202101', N'Rec. Cássia Lábrea', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (152, 3, CAST(N'2021-01-21' AS Date), N'202101', N'Rec. Yacimara', CAST(80.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (153, 3, CAST(N'2021-01-25' AS Date), N'202101', N'Rec. Shirlene', CAST(45.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (154, 3, CAST(N'2021-01-27' AS Date), N'202101', N'Rec. Diego', CAST(160.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (155, 3, CAST(N'2021-01-27' AS Date), N'202101', N'Rec. Jeciane', CAST(40.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (156, 3, CAST(N'2021-01-29' AS Date), N'202101', N'Rec. Eliane Mãe Erivelton', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (157, 3, CAST(N'2021-01-29' AS Date), N'202101', N'Pag. Johnny', CAST(-440.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (158, 3, CAST(N'2021-01-30' AS Date), N'202101', N'Rec. Augusta', CAST(67.48 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (159, 3, CAST(N'2021-01-30' AS Date), N'202101', N'Rec. Josi', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (160, 3, CAST(N'2021-01-30' AS Date), N'202101', N'Pag. Emp. p/ JF ref. a frete', CAST(-70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (161, 3, CAST(N'2021-01-30' AS Date), N'202101', N'Rec. Vendas Labrea', CAST(290.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (162, 3, CAST(N'2021-01-30' AS Date), N'202101', N'Pag. iPhone Gold', CAST(-62.34 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (163, 3, CAST(N'2021-01-30' AS Date), N'202101', N'Pag. iPhone C6 Bank', CAST(-258.33 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (164, 3, CAST(N'2021-01-30' AS Date), N'202101', N'Pag. Empréstimo JF', CAST(-13.81 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (165, 3, CAST(N'2021-01-31' AS Date), N'202101', N'Rec. venda sutiã', CAST(23.75 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (166, 3, CAST(N'2021-02-01' AS Date), N'202101', N'Rec. Suelen', CAST(37.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (167, 3, CAST(N'2021-02-01' AS Date), N'202101', N'Pag. Minizinha', CAST(-8.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (168, 3, CAST(N'2021-02-01' AS Date), N'202101', N'Rec. Vendas Labrea', CAST(540.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (169, 3, CAST(N'2021-02-01' AS Date), N'202101', N'Pag. Cartão Gold', CAST(-297.47 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (170, 3, CAST(N'2021-02-02' AS Date), N'202101', N'Rec. Helena Neres (Paula)', CAST(205.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (171, 3, CAST(N'2021-02-02' AS Date), N'202101', N'Dinheiro conserto caixa', CAST(400.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (172, 3, CAST(N'2021-02-02' AS Date), N'202101', N'Pag. empréstimo JF', CAST(-898.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (173, 3, CAST(N'2021-02-02' AS Date), N'202101', N'Saldo Josi rec. JF', CAST(177.60 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (174, 3, CAST(N'2021-02-02' AS Date), N'202101', N'Saldo Josi rec. Via transf.', CAST(187.80 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (175, 3, CAST(N'2021-02-03' AS Date), N'202101', N'Rec. Michelle', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (176, 3, CAST(N'2021-02-03' AS Date), N'202101', N'Rec. Paula', CAST(90.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (177, 3, CAST(N'2021-02-03' AS Date), N'202101', N'Rec. Bruna', CAST(105.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (178, 3, CAST(N'2021-02-03' AS Date), N'202101', N'Rec. Cassia (Lábrea)', CAST(80.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (179, 3, CAST(N'2021-02-03' AS Date), N'202101', N'Rec. Augusta (sutiã)', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (180, 3, CAST(N'2021-02-03' AS Date), N'202101', N'Rec. Rafaela', CAST(230.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (181, 3, CAST(N'2021-02-04' AS Date), N'202101', N'Rec. Vendas Labrea', CAST(600.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (182, 3, CAST(N'2021-02-04' AS Date), N'202101', N'Repassado JF', CAST(-358.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (183, 2, CAST(N'2021-03-01' AS Date), N'202103', N'Rec. Josi (Frete)', CAST(10.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (184, 2, CAST(N'2021-03-03' AS Date), N'202103', N'Rec. Pastora Cleide (Pedaleira)', CAST(180.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (185, 2, CAST(N'2021-03-06' AS Date), N'202103', N'Emprestado BF', CAST(-477.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (186, 2, CAST(N'2021-03-08' AS Date), N'202103', N'Rec. Empréstimo BF', CAST(477.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (187, 2, CAST(N'2021-03-22' AS Date), N'202103', N'Rec. venda teste', CAST(0.95 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (188, 2, CAST(N'2021-03-24' AS Date), N'202103', N'Rec. Salário', CAST(5420.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (189, 2, CAST(N'2021-03-25' AS Date), N'202103', N'Pag. Minizinha', CAST(8.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (190, 2, CAST(N'2021-03-25' AS Date), N'202103', N'Pag. Iphone', CAST(320.67 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (191, 2, CAST(N'2021-03-25' AS Date), N'202103', N'Pag. Fatura Gold', CAST(504.10 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (192, 2, CAST(N'2021-03-25' AS Date), N'202103', N'Pag. Fatura Nubank', CAST(112.93 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (193, 2, CAST(N'2021-03-25' AS Date), N'202103', N'Pag. Fatura Carrefour', CAST(205.47 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (194, 2, CAST(N'2021-03-25' AS Date), N'202103', N'Emprestado BF', CAST(-1881.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (195, 2, CAST(N'2021-03-25' AS Date), N'202103', N'Depósito ', CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (196, 2, CAST(N'2021-03-29' AS Date), N'202103', N'Troca Dinheiro/PicPay', CAST(-60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (197, 2, CAST(N'2021-03-29' AS Date), N'202103', N'Rec. p/ pag. Pedido', CAST(1000.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (198, 2, CAST(N'2021-03-30' AS Date), N'202103', N'Rec. Depósito', CAST(330.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (199, 2, CAST(N'2021-03-30' AS Date), N'202103', N'Rec. Empréstimo BF', CAST(37.60 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (200, 2, CAST(N'2021-03-30' AS Date), N'202103', N'Rec. Paim', CAST(16.45 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (201, 2, CAST(N'2021-03-30' AS Date), N'202103', N'Pag. Pregadores Agnes', CAST(-15.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (202, 2, CAST(N'2021-03-30' AS Date), N'202103', N'Rec. Cinthia C6', CAST(523.48 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (203, 2, CAST(N'2021-03-30' AS Date), N'202103', N'Rec. Cinthia Neon', CAST(49.11 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (204, 2, CAST(N'2021-03-30' AS Date), N'202103', N'Rec. Lucia', CAST(0.30 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (205, 2, CAST(N'2021-03-30' AS Date), N'202103', N'Rec. Josi', CAST(220.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (206, 2, CAST(N'2021-03-30' AS Date), N'202103', N'Pag. Bemol Josi', CAST(-214.70 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (207, 2, CAST(N'2021-03-30' AS Date), N'202103', N'Rec. Empréstimo BF', CAST(15.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (208, 2, CAST(N'2021-03-30' AS Date), N'202103', N'Rec. Empréstimo BF', CAST(260.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (209, 2, CAST(N'2021-03-31' AS Date), N'202103', N'Rec. Josi', CAST(182.55 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (210, 2, CAST(N'2021-04-01' AS Date), N'202103', N'Rec. Empréstimo BF', CAST(90.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (211, 2, CAST(N'2021-04-01' AS Date), N'202103', N'Rec. Paula', CAST(39.60 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (212, 2, CAST(N'2021-04-01' AS Date), N'202103', N'Pag. Fatura Gold', CAST(-5120.37 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (213, 2, CAST(N'2021-04-01' AS Date), N'202103', N'Pag. Fatura C6 Bank', CAST(-3053.22 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (214, 2, CAST(N'2021-04-01' AS Date), N'202103', N'Pag. Fatura Neon', CAST(-49.11 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (215, 2, CAST(N'2021-04-01' AS Date), N'202103', N'Pag. Fatura Nubank', CAST(-112.93 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (216, 2, CAST(N'2021-04-01' AS Date), N'202103', N'Pag. Fatura Carrefour', CAST(-216.36 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (217, 2, CAST(N'2021-04-01' AS Date), N'202103', N'Pag. Errado', CAST(-112.93 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (218, 2, CAST(N'2021-04-01' AS Date), N'202103', N'Pag. Conta de Luz', CAST(-328.92 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (219, 2, CAST(N'2021-04-01' AS Date), N'202103', N'Pag. Caixa', CAST(-274.79 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (220, 2, CAST(N'2021-04-01' AS Date), N'202103', N'Pag. Condomínio', CAST(-190.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (221, 2, CAST(N'2021-04-01' AS Date), N'202103', N'Pag. Internet', CAST(-89.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (222, 2, CAST(N'2021-04-01' AS Date), N'202103', N'Rec. Empréstimo BF', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (223, 2, CAST(N'2021-04-02' AS Date), N'202103', N'Rec. Pastores', CAST(345.08 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (224, 2, CAST(N'2021-04-02' AS Date), N'202103', N'Rec. Pag. Errado', CAST(112.93 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (225, 2, CAST(N'2021-04-08' AS Date), N'202103', N'Rec. Railson', CAST(59.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (226, 2, CAST(N'2021-04-08' AS Date), N'202103', N'Rec. Empréstimo BF', CAST(355.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (227, 3, CAST(N'2021-03-08' AS Date), N'202103', N'Rec. Erlande', CAST(55.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (228, 3, CAST(N'2021-03-08' AS Date), N'202103', N'Rec. Estorno pedido', CAST(920.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (229, 3, CAST(N'2021-03-08' AS Date), N'202103', N'Rec. Empréstimo BF', CAST(-477.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (230, 3, CAST(N'2021-03-09' AS Date), N'202103', N'Rec. Depósito', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (231, 3, CAST(N'2021-03-10' AS Date), N'202103', N'Empréstimo Rifa', CAST(152.06 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (232, 3, CAST(N'2021-03-10' AS Date), N'202103', N'Doação Elita', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (233, 3, CAST(N'2021-03-11' AS Date), N'202103', N'Pag. Damares', CAST(-30.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (234, 3, CAST(N'2021-03-12' AS Date), N'202103', N'Rec. Depósito', CAST(200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (235, 3, CAST(N'2021-03-16' AS Date), N'202103', N'Rec. Karol Santana ', CAST(115.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (236, 3, CAST(N'2021-03-16' AS Date), N'202103', N'Rec. Michelle ', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (237, 3, CAST(N'2021-03-16' AS Date), N'202103', N'Rec. Michelle ', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (238, 3, CAST(N'2021-03-18' AS Date), N'202103', N'Marmita ', CAST(-6.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (239, 3, CAST(N'2021-03-20' AS Date), N'202103', N'Pag. Bemol', CAST(-6.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (240, 3, CAST(N'2021-03-20' AS Date), N'202103', N'Rec. Vendas', CAST(136.89 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (241, 3, CAST(N'2021-03-20' AS Date), N'202103', N'Pag. Compra relógio ', CAST(-157.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (242, 3, CAST(N'2021-03-21' AS Date), N'202103', N'Pag. Vanessa', CAST(-40.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (243, 3, CAST(N'2021-03-22' AS Date), N'202103', N'Rec. Dalvinha', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (244, 3, CAST(N'2021-03-22' AS Date), N'202103', N'Pag. Roupinhas Isabella ', CAST(-68.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (245, 3, CAST(N'2021-03-22' AS Date), N'202103', N'Rec. Kalyne', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (246, 3, CAST(N'2021-03-22' AS Date), N'202103', N'Pag. Compra relógio ', CAST(-157.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (247, 3, CAST(N'2021-03-22' AS Date), N'202103', N'Rec. Depósito', CAST(200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (248, 3, CAST(N'2021-03-23' AS Date), N'202103', N'Rec. Dalvinha', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (249, 3, CAST(N'2021-03-25' AS Date), N'202103', N'Pag. Minizinha', CAST(-8.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (250, 3, CAST(N'2021-03-25' AS Date), N'202103', N'Pag. Iphone', CAST(-320.67 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (251, 3, CAST(N'2021-03-25' AS Date), N'202103', N'Pag. Fatura Gold', CAST(-504.10 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (252, 3, CAST(N'2021-03-25' AS Date), N'202103', N'Pag. Fatura Nubank', CAST(-112.93 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (253, 3, CAST(N'2021-03-25' AS Date), N'202103', N'Pag. Fatura Carrefour', CAST(-205.47 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (254, 3, CAST(N'2021-03-26' AS Date), N'202103', N'Rec. Dalvinha', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (255, 3, CAST(N'2021-03-28' AS Date), N'202103', N'Rec. Dalvinha', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (256, 3, CAST(N'2021-03-29' AS Date), N'202103', N'Troca Dinheiro/PicPay', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (257, 3, CAST(N'2021-03-29' AS Date), N'202103', N'Rec. p/ pag. Pedido', CAST(600.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (258, 3, CAST(N'2021-03-29' AS Date), N'202103', N'Pag. Pedido', CAST(-758.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (259, 3, CAST(N'2021-03-30' AS Date), N'202103', N'Rec. Empréstimo BF', CAST(-37.60 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (260, 3, CAST(N'2021-03-30' AS Date), N'202103', N'Rec. Cinthia Pijama Baby doll ', CAST(135.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (261, 3, CAST(N'2021-03-30' AS Date), N'202103', N'Rec. Cinthia Bolsa', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (262, 3, CAST(N'2021-03-30' AS Date), N'202103', N'Rec. Dalvinha', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (263, 3, CAST(N'2021-03-30' AS Date), N'202103', N'Rec. Empréstimo BF', CAST(-15.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (264, 3, CAST(N'2021-03-30' AS Date), N'202103', N'Rec. Empréstimo BF', CAST(-260.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (265, 3, CAST(N'2021-04-01' AS Date), N'202103', N'Rec. Damares', CAST(90.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (266, 3, CAST(N'2021-04-01' AS Date), N'202103', N'Rec. Empréstimo BF', CAST(-90.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (267, 3, CAST(N'2021-04-01' AS Date), N'202103', N'Rec. Janara (Mãe Thaise)', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (268, 3, CAST(N'2021-04-01' AS Date), N'202103', N'Rec. Empréstimo BF', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (269, 2, CAST(N'2021-04-06' AS Date), N'202104', N'Rec. Camila ', CAST(33.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (270, 2, CAST(N'2021-04-07' AS Date), N'202104', N'Emp. JF', CAST(-35.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (271, 2, CAST(N'2021-04-08' AS Date), N'202104', N'Rec. Kerllyane (emp. Dizimo)', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (272, 2, CAST(N'2021-04-08' AS Date), N'202104', N'Pag. Passagens', CAST(-1100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (273, 2, CAST(N'2021-04-09' AS Date), N'202104', N'Emp. p/ BF', CAST(-214.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (274, 2, CAST(N'2021-04-09' AS Date), N'202104', N'Pag. Pedido', CAST(-992.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (275, 2, CAST(N'2021-04-13' AS Date), N'202104', N'Pag. Emp. JF', CAST(214.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (276, 2, CAST(N'2021-04-14' AS Date), N'202104', N'Transf. p/ PagBank', CAST(-10.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (277, 2, CAST(N'2021-04-14' AS Date), N'202104', N'Cashback', CAST(36.19 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (278, 2, CAST(N'2021-04-14' AS Date), N'202104', N'Rec. Jairo', CAST(390.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (279, 2, CAST(N'2021-04-15' AS Date), N'202104', N'Transf. p/ PagBank', CAST(10.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (280, 2, CAST(N'2021-04-25' AS Date), N'202104', N'Kerllyane', CAST(245.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (281, 2, CAST(N'2021-04-27' AS Date), N'202104', N'Rec. Karol Malafaia', CAST(69.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (282, 2, CAST(N'2021-04-28' AS Date), N'202104', N'Salario', CAST(5420.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (283, 2, CAST(N'2021-04-29' AS Date), N'202104', N'Minizinha', CAST(8.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (284, 2, CAST(N'2021-04-29' AS Date), N'202104', N'Iphone', CAST(62.34 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (285, 2, CAST(N'2021-04-29' AS Date), N'202104', N'Iphone', CAST(258.33 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (286, 2, CAST(N'2021-04-29' AS Date), N'202104', N'BF (Gold)', CAST(135.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (287, 2, CAST(N'2021-04-29' AS Date), N'202104', N'BF (C6)', CAST(147.49 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (288, 2, CAST(N'2021-04-29' AS Date), N'202104', N'BF (Carrefour)', CAST(205.47 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (289, 2, CAST(N'2021-04-30' AS Date), N'202104', N'Rec. Johanes', CAST(80.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (290, 2, CAST(N'2021-04-30' AS Date), N'202104', N'Rec. Josi', CAST(177.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (291, 2, CAST(N'2021-04-30' AS Date), N'202104', N'Rec. Cinthia', CAST(915.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (292, 2, CAST(N'2021-04-30' AS Date), N'202104', N'Troco', CAST(5.60 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (293, 2, CAST(N'2021-04-30' AS Date), N'202104', N'Pag. Bemol', CAST(-35.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (294, 2, CAST(N'2021-04-30' AS Date), N'202104', N'Valor a menos errado PicPay', CAST(-1.94 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (295, 2, CAST(N'2021-05-01' AS Date), N'202104', N'Rec. Pastora', CAST(316.58 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (296, 2, CAST(N'2021-05-01' AS Date), N'202104', N'Pag. Fatura Gold', CAST(-2702.80 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (297, 2, CAST(N'2021-05-01' AS Date), N'202104', N'Pag. Fatura C6', CAST(-4175.62 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (298, 2, CAST(N'2021-05-01' AS Date), N'202104', N'Pag. Fatura Carrefour', CAST(-239.23 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (299, 2, CAST(N'2021-05-01' AS Date), N'202104', N'Rec. Venda celular', CAST(1799.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (300, 2, CAST(N'2021-05-02' AS Date), N'202104', N'Pag. Luz', CAST(-271.87 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (301, 2, CAST(N'2021-05-02' AS Date), N'202104', N'Pag. Caixa', CAST(-274.79 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (302, 2, CAST(N'2021-05-02' AS Date), N'202104', N'Pag. Condonimio', CAST(-190.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (303, 2, CAST(N'2021-05-02' AS Date), N'202104', N'Internet', CAST(-89.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (304, 2, CAST(N'2021-05-07' AS Date), N'202104', N'Rec. Paim', CAST(16.45 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (305, 3, CAST(N'2021-04-07' AS Date), N'202104', N'Rec. Venda', CAST(35.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (306, 3, CAST(N'2021-04-07' AS Date), N'202104', N'Emp. JF', CAST(35.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (307, 3, CAST(N'2021-04-07' AS Date), N'202104', N'Rep. Agnes', CAST(-70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (308, 3, CAST(N'2021-04-07' AS Date), N'202104', N'Rec. p/ pag. de frete', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (309, 3, CAST(N'2021-04-07' AS Date), N'202104', N'Rec. Jucy', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (310, 3, CAST(N'2021-04-07' AS Date), N'202104', N'Rec. Viviane ', CAST(205.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (311, 3, CAST(N'2021-04-08' AS Date), N'202104', N'Pag. Emp. JF', CAST(-355.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (312, 3, CAST(N'2021-04-08' AS Date), N'202104', N'Rec. Amanda (Vizinha)', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (313, 3, CAST(N'2021-04-08' AS Date), N'202104', N'Rec. Adriene', CAST(140.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (314, 3, CAST(N'2021-04-08' AS Date), N'202104', N'Rec. Kerllyane (emp. Dizimo)', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (315, 3, CAST(N'2021-04-09' AS Date), N'202104', N'Emp. p/ BF', CAST(214.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (316, 3, CAST(N'2021-04-09' AS Date), N'202104', N'Compra Relogios', CAST(-314.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (317, 3, CAST(N'2021-04-09' AS Date), N'202104', N'Rec. Jaderson', CAST(75.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (318, 3, CAST(N'2021-04-11' AS Date), N'202104', N'Rec. p/ pag. de frete', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (319, 3, CAST(N'2021-04-13' AS Date), N'202104', N'Rec. Dani', CAST(74.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (320, 3, CAST(N'2021-04-13' AS Date), N'202104', N'Pag. Emp. JF', CAST(-214.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (321, 3, CAST(N'2021-04-13' AS Date), N'202104', N'Rec. Mãe Amanda', CAST(40.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (322, 3, CAST(N'2021-04-14' AS Date), N'202104', N'Doação Élita', CAST(-25.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (323, 3, CAST(N'2021-04-15' AS Date), N'202104', N'Rec. Karol Santana', CAST(115.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (324, 3, CAST(N'2021-04-15' AS Date), N'202104', N'Frete', CAST(-110.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (325, 3, CAST(N'2021-04-16' AS Date), N'202104', N'Rec. p/ pag. de frete (prima)', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (326, 3, CAST(N'2021-04-16' AS Date), N'202104', N'Vendas Labrea', CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (327, 3, CAST(N'2021-04-17' AS Date), N'202104', N'Rec. Silane', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (328, 3, CAST(N'2021-04-24' AS Date), N'202104', N'Pag. frete', CAST(-150.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (329, 3, CAST(N'2021-04-27' AS Date), N'202104', N'Vendas Labrea', CAST(300.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (330, 3, CAST(N'2021-04-29' AS Date), N'202104', N'Samara Canutama', CAST(155.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (331, 3, CAST(N'2021-04-29' AS Date), N'202104', N'Minizinha', CAST(-8.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (332, 3, CAST(N'2021-04-29' AS Date), N'202104', N'Iphone', CAST(-62.34 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (333, 3, CAST(N'2021-04-29' AS Date), N'202104', N'Iphone', CAST(-258.33 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (334, 3, CAST(N'2021-04-29' AS Date), N'202104', N'BF (Gold)', CAST(-135.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (335, 3, CAST(N'2021-04-29' AS Date), N'202104', N'BF (C6)', CAST(-147.49 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (336, 3, CAST(N'2021-04-29' AS Date), N'202104', N'BF (Carrefour)', CAST(-205.47 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (337, 3, CAST(N'2021-04-30' AS Date), N'202104', N'Rec. Cinthia', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (338, 3, CAST(N'2021-04-30' AS Date), N'202104', N'Pag. Dani', CAST(-25.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (339, 3, CAST(N'2021-05-01' AS Date), N'202104', N'Rec. Katia', CAST(90.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (340, 3, CAST(N'2021-05-01' AS Date), N'202104', N'Rec. Josi', CAST(4.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (341, 3, CAST(N'2021-05-01' AS Date), N'202104', N'Rec. Dayane', CAST(115.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (342, 2, CAST(N'2021-05-06' AS Date), N'202105', N'Férias', CAST(7247.24 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (343, 2, CAST(N'2021-05-07' AS Date), N'202105', N'Bemol Thania', CAST(-89.98 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (344, 2, CAST(N'2021-05-07' AS Date), N'202105', N'Rec. Cash back', CAST(164.47 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (345, 2, CAST(N'2021-05-07' AS Date), N'202105', N'Pag. Bemol', CAST(-14.20 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (346, 2, CAST(N'2021-05-14' AS Date), N'202105', N'Rec. Francilene', CAST(559.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (347, 2, CAST(N'2021-05-20' AS Date), N'202105', N'Pag. Bíblia', CAST(-95.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (348, 2, CAST(N'2021-05-24' AS Date), N'202105', N'Pag. BF Gold', CAST(87.33 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (349, 2, CAST(N'2021-05-24' AS Date), N'202105', N'Pag. Iphone Gold', CAST(62.34 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (350, 2, CAST(N'2021-05-24' AS Date), N'202105', N'Pag. Iphone C6', CAST(258.33 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (351, 2, CAST(N'2021-05-24' AS Date), N'202105', N'Pag. Fatura C6 ', CAST(29.49 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (352, 2, CAST(N'2021-05-25' AS Date), N'202105', N'Rec. Francilene', CAST(216.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (353, 2, CAST(N'2021-05-28' AS Date), N'202105', N'Rec. Pastora Cleide', CAST(316.58 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (354, 2, CAST(N'2021-05-29' AS Date), N'202105', N'Rec. Cinthia', CAST(915.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (355, 2, CAST(N'2021-05-30' AS Date), N'202105', N'Rec. Josi', CAST(64.30 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (356, 2, CAST(N'2021-05-31' AS Date), N'202105', N'Fatura C6', CAST(-4718.78 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (357, 2, CAST(N'2021-05-31' AS Date), N'202105', N'Conta de luz', CAST(-213.09 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (358, 2, CAST(N'2021-05-31' AS Date), N'202105', N'Rec. Johanes', CAST(80.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (359, 2, CAST(N'2021-05-31' AS Date), N'202105', N'Rec. vendas ', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (360, 2, CAST(N'2021-05-31' AS Date), N'202105', N'Pag. Condomínio', CAST(-190.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (361, 2, CAST(N'2021-05-31' AS Date), N'202105', N'Pag. Fatura Carrefour', CAST(-4.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (362, 2, CAST(N'2021-05-31' AS Date), N'202105', N'Rec. Mirica', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (363, 2, CAST(N'2021-05-31' AS Date), N'202105', N'Pag. Fatura Gold', CAST(-2237.91 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (364, 2, CAST(N'2021-05-31' AS Date), N'202105', N'Pag. Caixa', CAST(-274.79 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (365, 2, CAST(N'2021-06-01' AS Date), N'202105', N'Rec. Lucia', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (366, 2, CAST(N'2021-06-05' AS Date), N'202105', N'Rec. Paim', CAST(16.45 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (367, 2, CAST(N'2021-06-21' AS Date), N'202105', N'Rec. Kerllyane', CAST(350.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (368, 3, CAST(N'2021-05-03' AS Date), N'202105', N'Compra Melissa', CAST(-30.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (369, 3, CAST(N'2021-05-03' AS Date), N'202105', N'Rec. Janara', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (370, 3, CAST(N'2021-05-04' AS Date), N'202105', N'Rec. Niziete', CAST(105.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (371, 3, CAST(N'2021-05-04' AS Date), N'202105', N'Rec. Erlande', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (372, 3, CAST(N'2021-05-04' AS Date), N'202105', N'Rec. Damares', CAST(110.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (373, 3, CAST(N'2021-05-05' AS Date), N'202105', N'Rec. Samira', CAST(120.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (374, 3, CAST(N'2021-05-05' AS Date), N'202105', N'Rec. Augusta', CAST(72.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (375, 3, CAST(N'2021-05-07' AS Date), N'202105', N'Patricia bl 29', CAST(110.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (376, 3, CAST(N'2021-05-07' AS Date), N'202105', N'Rec. Viviane', CAST(200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (377, 3, CAST(N'2021-05-08' AS Date), N'202105', N'Rec. Nete', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (378, 3, CAST(N'2021-05-08' AS Date), N'202105', N'Rec. vendas ', CAST(200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (379, 3, CAST(N'2021-05-08' AS Date), N'202105', N'Compra relógios', CAST(-361.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (380, 3, CAST(N'2021-05-09' AS Date), N'202105', N'Pag. pintura', CAST(-150.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (381, 3, CAST(N'2021-05-11' AS Date), N'202105', N'Pag. Melissas', CAST(-65.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (382, 3, CAST(N'2021-05-13' AS Date), N'202105', N'Rec. Silane', CAST(80.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (383, 3, CAST(N'2021-05-14' AS Date), N'202105', N'Rec. Amanda', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (384, 3, CAST(N'2021-05-17' AS Date), N'202105', N'Rec. Yaciara', CAST(230.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (385, 3, CAST(N'2021-05-24' AS Date), N'202105', N'Doação Cleo', CAST(-60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (386, 3, CAST(N'2021-05-24' AS Date), N'202105', N'Pag. BF Gold', CAST(-87.33 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (387, 3, CAST(N'2021-05-24' AS Date), N'202105', N'Pag. Iphone Gold', CAST(-62.34 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (388, 3, CAST(N'2021-05-24' AS Date), N'202105', N'Pag. Iphone C6', CAST(-258.33 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (389, 3, CAST(N'2021-05-24' AS Date), N'202105', N'Pag. Fatura C6 ', CAST(-29.49 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (390, 3, CAST(N'2021-05-25' AS Date), N'202105', N'Rec. Marceli', CAST(87.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (391, 3, CAST(N'2021-05-30' AS Date), N'202105', N'Rec. Josi', CAST(-64.30 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (392, 3, CAST(N'2021-05-31' AS Date), N'202105', N'Rec. vendas ', CAST(300.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (393, 3, CAST(N'2021-05-31' AS Date), N'202105', N'Rec. Marceli', CAST(88.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (394, 2, CAST(N'2021-05-28' AS Date), N'202106', N'Salario', CAST(1409.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (395, 2, CAST(N'2021-05-28' AS Date), N'202106', N'Rec. Mirica', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (396, 2, CAST(N'2021-06-01' AS Date), N'202106', N'Pag. Bemol ', CAST(-35.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (397, 2, CAST(N'2021-06-19' AS Date), N'202106', N'Pag. Entrada Carro', CAST(-13138.32 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (398, 2, CAST(N'2021-06-19' AS Date), N'202106', N'Rec. Kerllyane', CAST(150.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (399, 2, CAST(N'2021-06-22' AS Date), N'202106', N'Rec. Mirica', CAST(246.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (400, 2, CAST(N'2021-06-22' AS Date), N'202106', N'Pag. Bemol Mirica', CAST(-246.37 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (401, 2, CAST(N'2021-06-23' AS Date), N'202106', N'Rec. Nega', CAST(216.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (402, 2, CAST(N'2021-06-23' AS Date), N'202106', N'Salario', CAST(4155.83 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (403, 2, CAST(N'2021-06-30' AS Date), N'202106', N'Rec. Saldo FGTS', CAST(6951.11 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (404, 2, CAST(N'2021-06-30' AS Date), N'202106', N'Pag. Fatura C6 Bank', CAST(-5304.06 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (405, 2, CAST(N'2021-06-30' AS Date), N'202106', N'Pag. Fatura Gold', CAST(-1499.18 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (406, 2, CAST(N'2021-06-30' AS Date), N'202106', N'Pag. Fatura Carrefour', CAST(-10.39 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (407, 2, CAST(N'2021-06-30' AS Date), N'202106', N'Pag. Conta de luz', CAST(-61.14 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (408, 2, CAST(N'2021-06-30' AS Date), N'202106', N'Pag. Caixa', CAST(-274.79 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (409, 2, CAST(N'2021-06-30' AS Date), N'202106', N'Pag. Condominio', CAST(-190.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (410, 2, CAST(N'2021-06-30' AS Date), N'202106', N'Pag. Internet', CAST(-89.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (411, 2, CAST(N'2021-06-30' AS Date), N'202106', N'Rec/Pag BF', CAST(760.66 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (412, 2, CAST(N'2021-06-30' AS Date), N'202106', N'Rec. Cinthia', CAST(714.73 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (413, 2, CAST(N'2021-06-30' AS Date), N'202106', N'Rec. CITS', CAST(2177.84 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (414, 2, CAST(N'2021-06-30' AS Date), N'202106', N'Rec. Giovani', CAST(315.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (415, 2, CAST(N'2021-07-01' AS Date), N'202106', N'Rec. Lucia', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (416, 2, CAST(N'2021-07-02' AS Date), N'202106', N'Multa FGTS parte 1', CAST(5000.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (417, 2, CAST(N'2021-07-02' AS Date), N'202106', N'Rec. Josi', CAST(409.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (418, 2, CAST(N'2021-07-02' AS Date), N'202106', N'Pag. Bemol Josi', CAST(-407.21 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (419, 2, CAST(N'2021-07-02' AS Date), N'202106', N'Rec. BF', CAST(64.30 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (420, 2, CAST(N'2021-07-04' AS Date), N'202106', N'Rec. pastora Cleide', CAST(317.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (421, 2, CAST(N'2021-07-04' AS Date), N'202106', N'Rec. Paim', CAST(16.45 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (422, 2, CAST(N'2021-07-05' AS Date), N'202106', N'Escola Davi', CAST(-290.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (423, 2, CAST(N'2021-07-17' AS Date), N'202106', N'Rec. Kerllyane', CAST(200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (424, 3, CAST(N'2021-06-01' AS Date), N'202106', N'Pag. Bemol Thania', CAST(-86.54 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (425, 3, CAST(N'2021-06-04' AS Date), N'202106', N'Rec. Viviane', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (426, 3, CAST(N'2021-06-05' AS Date), N'202106', N'Rec. Samira', CAST(120.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (427, 3, CAST(N'2021-06-07' AS Date), N'202106', N'Pag. Luz mamãe', CAST(-113.39 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (428, 3, CAST(N'2021-06-08' AS Date), N'202106', N'Saque', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (429, 3, CAST(N'2021-06-11' AS Date), N'202106', N'Rec. Jaderson', CAST(35.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (430, 3, CAST(N'2021-06-11' AS Date), N'202106', N'Saque', CAST(-40.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (431, 3, CAST(N'2021-06-11' AS Date), N'202106', N'Bíblia Kerllyane', CAST(-40.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (432, 3, CAST(N'2021-06-11' AS Date), N'202106', N'Fraldas', CAST(-97.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (433, 3, CAST(N'2021-06-12' AS Date), N'202106', N'Rec. Erlande', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (434, 3, CAST(N'2021-06-14' AS Date), N'202106', N'Rec. Mãe da Amanda', CAST(130.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (435, 3, CAST(N'2021-06-16' AS Date), N'202106', N'Rec. Adriene irmã André', CAST(140.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (436, 3, CAST(N'2021-06-18' AS Date), N'202106', N'Rec. Amanda', CAST(63.71 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (437, 3, CAST(N'2021-06-19' AS Date), N'202106', N'Pag. Entrada Carro', CAST(-861.68 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (438, 3, CAST(N'2021-06-19' AS Date), N'202106', N'Rec. Vendas', CAST(1400.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (439, 3, CAST(N'2021-06-19' AS Date), N'202106', N'Saque', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (440, 3, CAST(N'2021-06-21' AS Date), N'202106', N'Pag. Deliane', CAST(-200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (441, 3, CAST(N'2021-06-28' AS Date), N'202106', N'Pag. Josi', CAST(-42.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (442, 3, CAST(N'2021-06-29' AS Date), N'202106', N'Rec. Jucy Labrea', CAST(150.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (443, 3, CAST(N'2021-06-30' AS Date), N'202106', N'Rec/Pag BF', CAST(-760.66 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (444, 3, CAST(N'2021-07-02' AS Date), N'202106', N'Rec. BF', CAST(-64.30 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (445, 2, CAST(N'2021-06-30' AS Date), N'202107', N'Rec. Mirica', CAST(85.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (446, 2, CAST(N'2021-07-02' AS Date), N'202107', N'Multa FGTS parte 2', CAST(8567.36 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (447, 2, CAST(N'2021-07-02' AS Date), N'202107', N'Pag. Bemol', CAST(-35.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (448, 2, CAST(N'2021-07-02' AS Date), N'202107', N'Pag. luz mamãe', CAST(-154.28 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (449, 2, CAST(N'2021-07-03' AS Date), N'202107', N'Rec. matrícula Davi', CAST(160.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (450, 2, CAST(N'2021-07-03' AS Date), N'202107', N'Dinheiro Nega', CAST(983.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (451, 2, CAST(N'2021-07-03' AS Date), N'202107', N'Pedido Nega', CAST(-979.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (452, 2, CAST(N'2021-07-06' AS Date), N'202107', N'Condução Davi', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (453, 2, CAST(N'2021-07-06' AS Date), N'202107', N'Condução Cinthia', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (454, 2, CAST(N'2021-07-06' AS Date), N'202107', N'Pag. Direcional juros de obra', CAST(-1318.63 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (455, 2, CAST(N'2021-07-07' AS Date), N'202107', N'Refrigerante', CAST(-5.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (456, 2, CAST(N'2021-07-08' AS Date), N'202107', N'Pag. Pedido', CAST(-6.18 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (457, 2, CAST(N'2021-07-08' AS Date), N'202107', N'Rec. Michelle', CAST(6.18 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (458, 2, CAST(N'2021-07-10' AS Date), N'202107', N'Pag. Farinha', CAST(-250.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (459, 2, CAST(N'2021-07-13' AS Date), N'202107', N'Pão', CAST(-3.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (460, 2, CAST(N'2021-07-13' AS Date), N'202107', N'Saque', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (461, 2, CAST(N'2021-07-14' AS Date), N'202107', N'Pag. Bolo', CAST(-60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (462, 2, CAST(N'2021-07-15' AS Date), N'202107', N'Salário 40%', CAST(3200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (463, 2, CAST(N'2021-07-15' AS Date), N'202107', N'Pag. Seguro carro', CAST(-2709.65 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (464, 2, CAST(N'2021-07-15' AS Date), N'202107', N'Rec. Parcial Cinthia', CAST(200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (465, 2, CAST(N'2021-07-15' AS Date), N'202107', N'Rec. p/ pag. Frete Nega', CAST(140.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (466, 2, CAST(N'2021-07-17' AS Date), N'202107', N'Compra Relógio', CAST(230.01 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (467, 2, CAST(N'2021-07-17' AS Date), N'202107', N'Compra Relógio', CAST(-179.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (468, 2, CAST(N'2021-07-17' AS Date), N'202107', N'Saque', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (469, 2, CAST(N'2021-07-17' AS Date), N'202107', N'Rec. Kerllyane', CAST(300.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (470, 2, CAST(N'2021-07-19' AS Date), N'202107', N'Rec. Nega', CAST(384.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (471, 2, CAST(N'2021-07-21' AS Date), N'202107', N'Pag. Deliane', CAST(-250.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (472, 2, CAST(N'2021-07-21' AS Date), N'202107', N'Saque', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (473, 2, CAST(N'2021-07-22' AS Date), N'202107', N'Rec. Mirica', CAST(246.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (474, 2, CAST(N'2021-07-22' AS Date), N'202107', N'Pag. Bemol Mirica', CAST(-246.37 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (475, 2, CAST(N'2021-07-22' AS Date), N'202107', N'Compra pão', CAST(-8.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (476, 2, CAST(N'2021-07-23' AS Date), N'202107', N'Pag. Frete', CAST(-80.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (477, 2, CAST(N'2021-07-25' AS Date), N'202107', N'Pag. Carro 1/48', CAST(-1300.49 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (478, 2, CAST(N'2021-07-26' AS Date), N'202107', N'Rec. Cinthia', CAST(744.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (479, 2, CAST(N'2021-07-26' AS Date), N'202107', N'Rec. BF Iphone', CAST(258.33 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (480, 2, CAST(N'2021-07-26' AS Date), N'202107', N'Rec. BF Iphone', CAST(62.34 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (481, 2, CAST(N'2021-07-26' AS Date), N'202107', N'Rec. BF C6', CAST(621.18 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (482, 2, CAST(N'2021-07-26' AS Date), N'202107', N'Rec. BF Carrefour', CAST(219.99 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (483, 2, CAST(N'2021-07-26' AS Date), N'202107', N'Rec. Cashback', CAST(10.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (484, 2, CAST(N'2021-07-30' AS Date), N'202107', N'Rec. Salario', CAST(3260.60 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (485, 2, CAST(N'2021-07-30' AS Date), N'202107', N'Pag. Boleto Deliane', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (486, 2, CAST(N'2021-07-30' AS Date), N'202107', N'Pag. Fatura C6 Bank', CAST(-12110.03 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (487, 2, CAST(N'2021-07-30' AS Date), N'202107', N'Pag. Pedido', CAST(-1000.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (488, 2, CAST(N'2021-07-30' AS Date), N'202107', N'Pag. Fatura Gold', CAST(-1803.75 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (489, 2, CAST(N'2021-07-30' AS Date), N'202107', N'Pag. Fatura Carrefour', CAST(-468.63 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (490, 2, CAST(N'2021-07-30' AS Date), N'202107', N'Pag. Fatura Nubank', CAST(-225.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (491, 2, CAST(N'2021-07-30' AS Date), N'202107', N'Rec. Imp. Renda', CAST(54.12 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (492, 2, CAST(N'2021-07-30' AS Date), N'202107', N'Rec. Johanes', CAST(225.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (493, 2, CAST(N'2021-07-30' AS Date), N'202107', N'Rec. Josi', CAST(579.16 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (494, 2, CAST(N'2021-07-30' AS Date), N'202107', N'Pag. Luz', CAST(-273.64 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (495, 2, CAST(N'2021-07-31' AS Date), N'202107', N'Rec. Lucia', CAST(474.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (496, 2, CAST(N'2021-08-01' AS Date), N'202107', N'Rec. Pastora', CAST(317.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (497, 2, CAST(N'2021-08-01' AS Date), N'202107', N'Oferta', CAST(-317.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (498, 2, CAST(N'2021-08-02' AS Date), N'202107', N'Dep. Bradesco', CAST(200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (499, 2, CAST(N'2021-08-02' AS Date), N'202107', N'Geovani', CAST(315.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (500, 2, CAST(N'2021-08-05' AS Date), N'202107', N'Pag. Internet', CAST(-89.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (501, 2, CAST(N'2021-08-05' AS Date), N'202107', N'Rec. Paim', CAST(16.45 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (502, 2, CAST(N'2021-08-10' AS Date), N'202107', N'Pag. Condomínio', CAST(-190.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (503, 2, CAST(N'2021-08-10' AS Date), N'202107', N'Pag. Caixa', CAST(-783.82 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (504, 2, CAST(N'2021-08-11' AS Date), N'202107', N'Pag. Escola Davi', CAST(-290.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (505, 2, CAST(N'2021-08-20' AS Date), N'202107', N'Rec. Cinthia', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (506, 3, CAST(N'2021-07-03' AS Date), N'202107', N'Pedido Nega', CAST(-885.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (507, 3, CAST(N'2021-07-08' AS Date), N'202107', N'Rec. Karol Santana', CAST(95.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (508, 3, CAST(N'2021-07-08' AS Date), N'202107', N'Rec. Mãe Amanda', CAST(150.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (509, 3, CAST(N'2021-07-08' AS Date), N'202107', N'Pag. Pedido', CAST(-493.82 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (510, 3, CAST(N'2021-07-08' AS Date), N'202107', N'Rec. Michelle', CAST(83.82 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (511, 3, CAST(N'2021-07-10' AS Date), N'202107', N'Rec. Erlande', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (512, 3, CAST(N'2021-07-12' AS Date), N'202107', N'Rec. Adriene', CAST(190.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (513, 3, CAST(N'2021-07-14' AS Date), N'202107', N'Rec. Karol Santana', CAST(105.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (514, 3, CAST(N'2021-07-19' AS Date), N'202107', N'Rec. Miuda', CAST(950.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (515, 3, CAST(N'2021-07-24' AS Date), N'202107', N'Rec. Damares', CAST(150.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (516, 3, CAST(N'2021-07-26' AS Date), N'202107', N'Rec. Cinthia', CAST(90.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (517, 3, CAST(N'2021-07-26' AS Date), N'202107', N'Rec. BF Iphone', CAST(-258.33 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (518, 3, CAST(N'2021-07-26' AS Date), N'202107', N'Rec. BF Iphone', CAST(-62.34 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (519, 3, CAST(N'2021-07-26' AS Date), N'202107', N'Rec. BF C6', CAST(-621.18 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (520, 3, CAST(N'2021-07-26' AS Date), N'202107', N'Rec. BF Carrefour', CAST(-219.99 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (521, 3, CAST(N'2021-07-28' AS Date), N'202107', N'Pag. Frete', CAST(-120.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (522, 3, CAST(N'2021-07-28' AS Date), N'202107', N'Rec. Karol Santana', CAST(200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (523, 3, CAST(N'2021-07-28' AS Date), N'202107', N'Rec. Karine', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (524, 3, CAST(N'2021-07-30' AS Date), N'202107', N'Rec. Nega', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (525, 3, CAST(N'2021-07-30' AS Date), N'202107', N'Rec. Damares', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (526, 3, CAST(N'2021-07-30' AS Date), N'202107', N'Pag. Pedido', CAST(-800.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (527, 3, CAST(N'2021-07-30' AS Date), N'202107', N'Pag. Ruana', CAST(-25.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (528, 2, CAST(N'2021-07-02' AS Date), N'202108', N'Multa FGTS parte 3', CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (529, 2, CAST(N'2021-07-28' AS Date), N'202108', N'Rec. Nega', CAST(73.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (530, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Oferta', CAST(-683.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (531, 2, CAST(N'2021-08-02' AS Date), N'202108', N'Pag. Bemol', CAST(-35.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (532, 2, CAST(N'2021-08-02' AS Date), N'202108', N'Compra tapete Agnes', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (533, 2, CAST(N'2021-08-04' AS Date), N'202108', N'Pag. Pedido', CAST(-1565.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (534, 2, CAST(N'2021-08-06' AS Date), N'202108', N'Rec. Lucia pag. Bemol', CAST(400.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (535, 2, CAST(N'2021-08-06' AS Date), N'202108', N'Rec. Beatriz pag. Bemol', CAST(200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (536, 2, CAST(N'2021-08-06' AS Date), N'202108', N'Pag. Bemol Lucia', CAST(-399.75 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (537, 2, CAST(N'2021-08-11' AS Date), N'202108', N'Pag. frete BF', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (538, 2, CAST(N'2021-08-11' AS Date), N'202108', N'Pag. frete Nega', CAST(-70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (539, 2, CAST(N'2021-08-11' AS Date), N'202108', N'Pag. Pedido', CAST(-880.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (540, 2, CAST(N'2021-08-12' AS Date), N'202108', N'Rec. Karol Santana', CAST(0.01 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (541, 2, CAST(N'2021-08-13' AS Date), N'202108', N'Rec. Nega', CAST(491.77 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (542, 2, CAST(N'2021-08-16' AS Date), N'202108', N'Rec. Salário', CAST(3200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (543, 2, CAST(N'2021-08-23' AS Date), N'202108', N'Rec. Mirica pag. Bemol', CAST(246.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (544, 2, CAST(N'2021-08-24' AS Date), N'202108', N'Emp. Mamãe', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (545, 2, CAST(N'2021-08-26' AS Date), N'202108', N'Pag. Deliane', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (546, 2, CAST(N'2021-08-26' AS Date), N'202108', N'Saque', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (547, 2, CAST(N'2021-08-26' AS Date), N'202108', N'Pag. Boleto Deliane', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (548, 2, CAST(N'2021-08-28' AS Date), N'202108', N'Rec. Salário', CAST(3123.95 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (549, 2, CAST(N'2021-08-28' AS Date), N'202108', N'Rec. BF Gold', CAST(64.01 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (550, 2, CAST(N'2021-08-28' AS Date), N'202108', N'Rec. BF C6', CAST(167.19 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (551, 2, CAST(N'2021-08-28' AS Date), N'202108', N'Rec. BF Carrefour', CAST(219.98 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (552, 2, CAST(N'2021-08-30' AS Date), N'202108', N'Rec. Cinthia', CAST(745.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (553, 2, CAST(N'2021-08-30' AS Date), N'202108', N'Rec. Érica', CAST(150.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (554, 2, CAST(N'2021-08-31' AS Date), N'202108', N'Rec. Josi', CAST(1132.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (555, 2, CAST(N'2021-08-31' AS Date), N'202108', N'Rec. Erica', CAST(200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (556, 2, CAST(N'2021-08-31' AS Date), N'202108', N'Rec. Cleide', CAST(318.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (557, 2, CAST(N'2021-08-31' AS Date), N'202108', N'Pag. pão', CAST(-6.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (558, 2, CAST(N'2021-08-31' AS Date), N'202108', N'Rec. BF', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (559, 2, CAST(N'2021-08-31' AS Date), N'202108', N'Pag. Carro', CAST(-1383.77 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (560, 2, CAST(N'2021-09-01' AS Date), N'202108', N'Rec. Johanes', CAST(225.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (561, 2, CAST(N'2021-09-01' AS Date), N'202108', N'Rec. Lucia', CAST(475.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (562, 2, CAST(N'2021-09-01' AS Date), N'202108', N'Pag. Fatura Nubank', CAST(-230.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (563, 2, CAST(N'2021-09-01' AS Date), N'202108', N'Pag. Fatura C6', CAST(-10046.13 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (564, 2, CAST(N'2021-09-01' AS Date), N'202108', N'Pag. Fatura Gold', CAST(-2172.39 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (565, 2, CAST(N'2021-09-01' AS Date), N'202108', N'Pag. Fatura Neon', CAST(-625.49 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (566, 2, CAST(N'2021-09-01' AS Date), N'202108', N'Pag. Fatura Carrefour', CAST(-468.53 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (567, 2, CAST(N'2021-09-01' AS Date), N'202108', N'Pag. Fatura PicPay', CAST(-398.78 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (568, 2, CAST(N'2021-09-01' AS Date), N'202108', N'Compra rifas Camila', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (569, 2, CAST(N'2021-09-02' AS Date), N'202108', N'Pag. Bemol Mirica', CAST(-247.35 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (570, 2, CAST(N'2021-09-02' AS Date), N'202108', N'Transf. Bradesco', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (571, 2, CAST(N'2021-09-02' AS Date), N'202108', N'Rec. Thania', CAST(78.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (572, 2, CAST(N'2021-09-02' AS Date), N'202108', N'Rec. Emp. BF', CAST(800.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (573, 2, CAST(N'2021-09-02' AS Date), N'202108', N'Rec. Giovani', CAST(315.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (574, 2, CAST(N'2021-09-03' AS Date), N'202108', N'Pag. Luz', CAST(-406.89 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (575, 2, CAST(N'2021-09-03' AS Date), N'202108', N'Pag. Internet', CAST(-89.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (576, 2, CAST(N'2021-09-07' AS Date), N'202108', N'Rec. Lucia', CAST(400.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (577, 2, CAST(N'2021-09-07' AS Date), N'202108', N'Pag. Bemol Lucia', CAST(-399.75 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (578, 2, CAST(N'2021-09-08' AS Date), N'202108', N'Pag. Bemol Bia', CAST(-280.68 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (579, 2, CAST(N'2021-09-08' AS Date), N'202108', N'Rec. Bia', CAST(80.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (580, 2, CAST(N'2021-09-08' AS Date), N'202108', N'Pag. Escola Davi', CAST(-135.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (581, 2, CAST(N'2021-09-09' AS Date), N'202108', N'Rec. BF', CAST(640.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (582, 2, CAST(N'2021-09-10' AS Date), N'202108', N'Pag. Caixa', CAST(-783.80 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (583, 2, CAST(N'2021-09-10' AS Date), N'202108', N'Pag. Condominio', CAST(-190.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (584, 2, CAST(N'2021-10-01' AS Date), N'202108', N'Rec. Paim', CAST(16.45 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (585, 3, CAST(N'2021-08-06' AS Date), N'202108', N'Rec. Carminha', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (586, 3, CAST(N'2021-08-12' AS Date), N'202108', N'Rec. Karol Santana', CAST(180.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (587, 3, CAST(N'2021-08-12' AS Date), N'202108', N'Rec. Loiane', CAST(69.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (588, 3, CAST(N'2021-08-12' AS Date), N'202108', N'Rec. Andresa', CAST(58.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (589, 3, CAST(N'2021-08-15' AS Date), N'202108', N'Rec. Daiane', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (590, 3, CAST(N'2021-08-16' AS Date), N'202108', N'Pag. Ketlen', CAST(-35.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (591, 3, CAST(N'2021-08-17' AS Date), N'202108', N'Rec. Miuda', CAST(420.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (592, 3, CAST(N'2021-08-20' AS Date), N'202108', N'Rec. Thayse', CAST(120.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (593, 3, CAST(N'2021-08-28' AS Date), N'202108', N'Rec. Camila vestido', CAST(120.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (594, 3, CAST(N'2021-08-28' AS Date), N'202108', N'Rec. BF Gold', CAST(-64.01 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (595, 3, CAST(N'2021-08-28' AS Date), N'202108', N'Rec. BF C6', CAST(-167.19 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (596, 3, CAST(N'2021-08-28' AS Date), N'202108', N'Rec. BF Carrefour', CAST(-219.98 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (597, 3, CAST(N'2021-08-29' AS Date), N'202108', N'Rec. Karol Malafaia', CAST(135.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (598, 3, CAST(N'2021-08-29' AS Date), N'202108', N'Pag. Vanessa', CAST(-24.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (599, 3, CAST(N'2021-08-29' AS Date), N'202108', N'Pag. Unha', CAST(-52.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (600, 3, CAST(N'2021-08-31' AS Date), N'202108', N'Rec. Loiane', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (601, 3, CAST(N'2021-08-31' AS Date), N'202108', N'Rec. BF', CAST(-70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (602, 3, CAST(N'2021-09-01' AS Date), N'202108', N'Pag. Frete', CAST(-80.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (603, 3, CAST(N'2021-09-02' AS Date), N'202108', N'Rec. Suellen', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (604, 3, CAST(N'2021-09-02' AS Date), N'202108', N'Rec. Paula', CAST(125.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (605, 3, CAST(N'2021-09-02' AS Date), N'202108', N'Rec. Augusta', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (606, 3, CAST(N'2021-09-02' AS Date), N'202108', N'Rec. Emp. BF', CAST(-800.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (607, 3, CAST(N'2021-09-02' AS Date), N'202108', N'Rec.m Damares', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (608, 3, CAST(N'2021-09-03' AS Date), N'202108', N'Rec. Lidiane', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (609, 3, CAST(N'2021-09-04' AS Date), N'202108', N'Rec. Adriene', CAST(190.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (610, 3, CAST(N'2021-09-08' AS Date), N'202108', N'Rec. Mãe da Amanda', CAST(80.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (611, 3, CAST(N'2021-09-08' AS Date), N'202108', N'Rec. Clene', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (612, 3, CAST(N'2021-09-08' AS Date), N'202108', N'Pag. Prima Kerllyane', CAST(-11.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (613, 3, CAST(N'2021-09-09' AS Date), N'202108', N'Rec. Karol Santana', CAST(92.51 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (614, 3, CAST(N'2021-09-09' AS Date), N'202108', N'Rec. BF', CAST(-640.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (615, 2, CAST(N'2021-09-07' AS Date), N'202109', N'Corte cabelo', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (616, 2, CAST(N'2021-09-12' AS Date), N'202109', N'Rec. Nega', CAST(411.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (617, 2, CAST(N'2021-09-14' AS Date), N'202109', N'Pag. Bemol', CAST(-63.75 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (618, 2, CAST(N'2021-09-14' AS Date), N'202109', N'Pag. Bemol', CAST(-43.60 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (619, 2, CAST(N'2021-09-14' AS Date), N'202109', N'Compra Talco', CAST(-13.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (620, 2, CAST(N'2021-09-15' AS Date), N'202109', N'Rescisão CITS', CAST(4928.02 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (621, 2, CAST(N'2021-09-15' AS Date), N'202109', N'Rec. Salário 40%', CAST(3603.82 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (622, 2, CAST(N'2021-09-16' AS Date), N'202109', N'Rec. Nega', CAST(536.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (623, 2, CAST(N'2021-09-16' AS Date), N'202109', N'Pag. Nega', CAST(-528.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (624, 2, CAST(N'2021-09-18' AS Date), N'202109', N'Rec. Gasolina Nega', CAST(30.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (625, 2, CAST(N'2021-09-19' AS Date), N'202109', N'Sportingbet', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (626, 2, CAST(N'2021-09-22' AS Date), N'202109', N'Rec. Bruna', CAST(135.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (627, 2, CAST(N'2021-09-22' AS Date), N'202109', N'Rec. Mirica', CAST(246.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (628, 2, CAST(N'2021-09-22' AS Date), N'202109', N'Pag. Bemol Mirica', CAST(-246.37 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (629, 2, CAST(N'2021-09-22' AS Date), N'202109', N'Recebimento  Sharla', CAST(27.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (630, 2, CAST(N'2021-09-25' AS Date), N'202109', N'Compra Lençois', CAST(-287.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (631, 2, CAST(N'2021-09-27' AS Date), N'202109', N'Pag. Boleto Deliane', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (632, 2, CAST(N'2021-09-27' AS Date), N'202109', N'Pag. Carro', CAST(-1300.49 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (633, 2, CAST(N'2021-09-30' AS Date), N'202109', N'Rec. Salário 60%', CAST(3540.89 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (634, 2, CAST(N'2021-09-30' AS Date), N'202109', N'Rec. Cinthia', CAST(773.63 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (635, 2, CAST(N'2021-09-30' AS Date), N'202109', N'Rec. BF Compra pastora', CAST(76.66 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (636, 2, CAST(N'2021-09-30' AS Date), N'202109', N'Rec. Pastora Cleide ', CAST(745.58 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (637, 2, CAST(N'2021-09-30' AS Date), N'202109', N'Pag. Fatura C6', CAST(-5903.98 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (638, 2, CAST(N'2021-09-30' AS Date), N'202109', N'Pag. Fatura Gold', CAST(-5680.70 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (639, 2, CAST(N'2021-09-30' AS Date), N'202109', N'Pag. Fatura Neon', CAST(-455.49 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (640, 2, CAST(N'2021-09-30' AS Date), N'202109', N'Pag. Fatura Nubank', CAST(-303.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (641, 2, CAST(N'2021-09-30' AS Date), N'202109', N'Pag. Fatura PicPay', CAST(-358.29 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (642, 2, CAST(N'2021-09-30' AS Date), N'202109', N'Pag. Fatura PagSeguro', CAST(-505.44 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (643, 2, CAST(N'2021-10-01' AS Date), N'202109', N'Rec. Camila', CAST(256.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (644, 2, CAST(N'2021-10-01' AS Date), N'202109', N'Rec. Thania', CAST(78.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (645, 2, CAST(N'2021-10-01' AS Date), N'202109', N'Rec. Josi', CAST(1672.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (646, 2, CAST(N'2021-10-01' AS Date), N'202109', N'Rec. BF fatura Gold', CAST(81.07 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (647, 2, CAST(N'2021-10-01' AS Date), N'202109', N'Rec. BF fatura Nubank', CAST(79.97 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (648, 2, CAST(N'2021-10-01' AS Date), N'202109', N'Pag. Fatura Carrefour ', CAST(-483.82 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (649, 2, CAST(N'2021-10-01' AS Date), N'202109', N'Pag. Sobrancelha', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (650, 2, CAST(N'2021-10-01' AS Date), N'202109', N'Rec. Paim', CAST(19.95 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (651, 2, CAST(N'2021-10-02' AS Date), N'202109', N'Rec. Kerllyane', CAST(350.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (652, 2, CAST(N'2021-10-02' AS Date), N'202109', N'Rec. Pag. Frete', CAST(30.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (653, 2, CAST(N'2021-10-04' AS Date), N'202109', N'Pag. Luz', CAST(-393.21 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (654, 2, CAST(N'2021-10-04' AS Date), N'202109', N'Pag. Internet', CAST(-89.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (655, 2, CAST(N'2021-10-04' AS Date), N'202109', N'Pag. Escola Davi', CAST(-220.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (656, 2, CAST(N'2021-10-11' AS Date), N'202109', N'Rec. Giovanni ', CAST(315.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (657, 2, CAST(N'2021-10-11' AS Date), N'202109', N'Pag. Caixa', CAST(-783.77 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (658, 2, CAST(N'2021-10-11' AS Date), N'202109', N'Pag. Condomínio ', CAST(-190.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (659, 2, CAST(N'2021-10-08' AS Date), N'202109', N'Rec. BF Fatura C6', CAST(150.32 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (660, 2, CAST(N'2021-10-16' AS Date), N'202109', N'Rec. BF Parcial fatura Carrefour', CAST(80.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (661, 2, CAST(N'2021-10-16' AS Date), N'202109', N'Rec. BF Parcial fatura Carrefour', CAST(69.98 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (662, 2, CAST(N'2021-10-20' AS Date), N'202109', N'Pag. Emprestimo JF', CAST(128.58 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (663, 2, CAST(N'2021-10-22' AS Date), N'202109', N'Rec. BF', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (664, 2, CAST(N'2021-10-22' AS Date), N'202109', N'Rec. BF', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (665, 2, CAST(N'2021-10-30' AS Date), N'202109', N'Rec. BF', CAST(8.42 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (666, 3, CAST(N'2021-09-09' AS Date), N'202109', N'Rec. Eliane', CAST(120.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (667, 3, CAST(N'2021-09-14' AS Date), N'202109', N'Carmem', CAST(125.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (668, 3, CAST(N'2021-09-14' AS Date), N'202109', N'Andreza', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (669, 3, CAST(N'2021-09-15' AS Date), N'202109', N'Compra Vestido ', CAST(-75.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (670, 3, CAST(N'2021-09-15' AS Date), N'202109', N'Pag. Paula', CAST(-25.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (671, 3, CAST(N'2021-09-16' AS Date), N'202109', N'Rec. Pastora Cleide ', CAST(90.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (672, 3, CAST(N'2021-09-16' AS Date), N'202109', N'Rec. Kelly', CAST(325.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (673, 3, CAST(N'2021-09-16' AS Date), N'202109', N'Pag. Kelly', CAST(-180.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (674, 3, CAST(N'2021-09-16' AS Date), N'202109', N'Rec. Suellen', CAST(26.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (675, 3, CAST(N'2021-09-16' AS Date), N'202109', N'Pag. Bemol', CAST(-190.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (676, 3, CAST(N'2021-09-16' AS Date), N'202109', N'Rec. Josi', CAST(200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (677, 3, CAST(N'2021-09-17' AS Date), N'202109', N'Karol Santana', CAST(67.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (678, 3, CAST(N'2021-09-17' AS Date), N'202109', N'Pedido BF ', CAST(-621.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (679, 3, CAST(N'2021-09-22' AS Date), N'202109', N'Rec. Cinthia', CAST(135.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (680, 3, CAST(N'2021-09-23' AS Date), N'202109', N'Rec. Shirlene', CAST(25.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (681, 3, CAST(N'2021-09-27' AS Date), N'202109', N'Pag. Salgado', CAST(-25.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (682, 3, CAST(N'2021-09-30' AS Date), N'202109', N'Rec. BF Compra pastora', CAST(-76.66 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (683, 3, CAST(N'2021-10-01' AS Date), N'202109', N'Rec. Cleo', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (684, 3, CAST(N'2021-10-01' AS Date), N'202109', N'Rec. BF fatura Gold', CAST(-81.07 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (685, 3, CAST(N'2021-10-01' AS Date), N'202109', N'Rec. BF fatura Nubank', CAST(-79.97 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (686, 3, CAST(N'2021-10-02' AS Date), N'202109', N'Rec. Pag. Frete', CAST(90.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (687, 3, CAST(N'2021-10-02' AS Date), N'202109', N'Rec. Debinha', CAST(43.92 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (688, 3, CAST(N'2021-10-04' AS Date), N'202109', N'Pag. Dívida Kerllyane', CAST(-64.93 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (689, 3, CAST(N'2021-10-11' AS Date), N'202109', N'Rec. Amanda ', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (690, 3, CAST(N'2021-10-08' AS Date), N'202109', N'Rec. BF Fatura C6', CAST(-150.32 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (691, 3, CAST(N'2021-10-16' AS Date), N'202109', N'Rec. Greicy', CAST(80.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (692, 3, CAST(N'2021-10-16' AS Date), N'202109', N'Rec. BF Parcial fatura Carrefour', CAST(-80.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (693, 3, CAST(N'2021-10-19' AS Date), N'202109', N'Rec. Amiga Josi', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (694, 3, CAST(N'2021-10-20' AS Date), N'202109', N'Pag. Emprestimo JF', CAST(-128.58 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (695, 3, CAST(N'2021-10-22' AS Date), N'202109', N'Rec. Jo', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (696, 3, CAST(N'2021-10-22' AS Date), N'202109', N'Rec. BF', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (697, 3, CAST(N'2021-10-22' AS Date), N'202109', N'Rec. Cinthia', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (698, 3, CAST(N'2021-10-22' AS Date), N'202109', N'Rec. BF', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (699, 3, CAST(N'2021-10-30' AS Date), N'202109', N'Rec. de Outubro ', CAST(8.42 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (700, 3, CAST(N'2021-10-30' AS Date), N'202109', N'Rec. BF', CAST(-8.42 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (701, 2, CAST(N'2021-09-30' AS Date), N'202110', N'Pag. Porta cozinha', CAST(-350.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (702, 2, CAST(N'2021-10-03' AS Date), N'202110', N'Lavagem carro', CAST(-30.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (703, 2, CAST(N'2021-10-04' AS Date), N'202110', N'Compras Labrea', CAST(-70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (704, 2, CAST(N'2021-10-04' AS Date), N'202110', N'Pag. Bemol', CAST(-38.60 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (705, 2, CAST(N'2021-10-04' AS Date), N'202110', N'Pag. Bemol', CAST(-69.93 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (706, 2, CAST(N'2021-10-05' AS Date), N'202110', N'Oferta Johnny', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (707, 2, CAST(N'2021-10-05' AS Date), N'202110', N'Pag. Andreia (Melissas)', CAST(-90.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (708, 2, CAST(N'2021-10-05' AS Date), N'202110', N'Pag. Roberney', CAST(-40.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (709, 2, CAST(N'2021-10-07' AS Date), N'202110', N'Emprestado p/ Cinthia ', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (710, 2, CAST(N'2021-10-07' AS Date), N'202110', N'Rest. pag. bemol Lúcia ', CAST(0.25 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (711, 2, CAST(N'2021-10-08' AS Date), N'202110', N'Pag. Restante escola Davi', CAST(-90.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (712, 2, CAST(N'2021-10-08' AS Date), N'202110', N'Rec. BF Fatura C6', CAST(0.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (713, 2, CAST(N'2021-10-11' AS Date), N'202110', N'Pão ', CAST(-6.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (714, 2, CAST(N'2021-10-11' AS Date), N'202110', N'Saque', CAST(-250.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (715, 2, CAST(N'2021-10-15' AS Date), N'202110', N'Adiantamento quinzenal', CAST(4921.28 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (716, 2, CAST(N'2021-10-15' AS Date), N'202110', N'Pag. Contribuição Confraternização ', CAST(-30.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (717, 2, CAST(N'2021-10-16' AS Date), N'202110', N'Rec. Nega', CAST(385.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (718, 2, CAST(N'2021-10-19' AS Date), N'202110', N'Pag. Bemol', CAST(-190.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (719, 2, CAST(N'2021-10-19' AS Date), N'202110', N'Compra Leite Agnes', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (720, 2, CAST(N'2021-10-22' AS Date), N'202110', N'Troca por dinheiro ', CAST(63.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (721, 2, CAST(N'2021-10-22' AS Date), N'202110', N'Rec. Bruna', CAST(135.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (722, 2, CAST(N'2021-10-22' AS Date), N'202110', N'Rec. Cinthia Emp.', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (723, 2, CAST(N'2021-10-22' AS Date), N'202110', N'Saque', CAST(-400.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (724, 2, CAST(N'2021-10-23' AS Date), N'202110', N'Pag. Deliane', CAST(-400.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (725, 2, CAST(N'2021-10-23' AS Date), N'202110', N'Corte cabelo', CAST(-60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (726, 2, CAST(N'2021-10-26' AS Date), N'202110', N'Pag. Carro', CAST(-1334.74 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (727, 2, CAST(N'2021-10-26' AS Date), N'202110', N'Marmita', CAST(-15.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (728, 2, CAST(N'2021-10-27' AS Date), N'202110', N'Pag. fatura Nubank ', CAST(-322.92 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (729, 2, CAST(N'2021-10-28' AS Date), N'202110', N'Rec. Sharla', CAST(375.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (730, 2, CAST(N'2021-10-28' AS Date), N'202110', N'Oferta pão', CAST(-10.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (731, 2, CAST(N'2021-10-29' AS Date), N'202110', N'Rec. Salário 60% + creche', CAST(4794.73 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (732, 2, CAST(N'2021-10-29' AS Date), N'202110', N'Rec. Cinthia', CAST(791.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (733, 2, CAST(N'2021-11-01' AS Date), N'202110', N'Rec. Josi', CAST(2075.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (734, 2, CAST(N'2021-11-01' AS Date), N'202110', N'Pag. Boleto Deliane', CAST(-70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (735, 2, CAST(N'2021-11-01' AS Date), N'202110', N'Rec. Camila', CAST(256.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (736, 2, CAST(N'2021-11-01' AS Date), N'202110', N'Pag. Fatura Gold', CAST(-1590.44 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (737, 2, CAST(N'2021-11-01' AS Date), N'202110', N'Pag. Fatura C6', CAST(-6215.23 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (738, 2, CAST(N'2021-11-01' AS Date), N'202110', N'Pag. Fatura Carrefour', CAST(-269.45 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (739, 2, CAST(N'2021-11-01' AS Date), N'202110', N'Pag. Fatura Elo', CAST(-52.05 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (740, 2, CAST(N'2021-11-01' AS Date), N'202110', N'Pag. Fatura ', CAST(-505.43 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (741, 2, CAST(N'2021-11-01' AS Date), N'202110', N'Pag. Neon', CAST(-455.49 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (742, 2, CAST(N'2021-11-01' AS Date), N'202110', N'Rec. Cleide ', CAST(734.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (743, 2, CAST(N'2021-11-02' AS Date), N'202110', N'Pag. boleto Cinthia ', CAST(-14.93 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (744, 2, CAST(N'2021-11-02' AS Date), N'202110', N'Rec. Paim', CAST(19.95 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (745, 2, CAST(N'2021-11-03' AS Date), N'202110', N'Pag. luz', CAST(-349.18 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (746, 2, CAST(N'2021-11-03' AS Date), N'202110', N'Rec. Thania', CAST(154.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (747, 2, CAST(N'2021-11-03' AS Date), N'202110', N'Pag. Internet', CAST(-89.90 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (748, 2, CAST(N'2021-11-03' AS Date), N'202110', N'Rec. BF', CAST(53.67 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (749, 2, CAST(N'2021-11-03' AS Date), N'202110', N'Rec. Geovane ', CAST(314.84 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (750, 2, CAST(N'2021-11-05' AS Date), N'202110', N'Pag. Fatura PìcPay', CAST(-340.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (751, 2, CAST(N'2021-11-05' AS Date), N'202110', N'Pag. Escola Davi', CAST(-290.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (752, 2, CAST(N'2021-11-10' AS Date), N'202110', N'Rec. BF', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (753, 2, CAST(N'2021-11-10' AS Date), N'202110', N'Pag. condomínio ', CAST(-190.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (754, 2, CAST(N'2021-11-10' AS Date), N'202110', N'Pag. Caixa', CAST(-783.77 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (755, 3, CAST(N'2021-10-07' AS Date), N'202110', N'Rec. Andreza', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (756, 3, CAST(N'2021-10-07' AS Date), N'202110', N'Dizimo Kerllyane', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (757, 3, CAST(N'2021-10-07' AS Date), N'202110', N'Rec. Loiane', CAST(42.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (758, 3, CAST(N'2021-10-08' AS Date), N'202110', N'Rec. Cleo', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (759, 3, CAST(N'2021-10-08' AS Date), N'202110', N'Rec. Joana ', CAST(25.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (760, 3, CAST(N'2021-10-08' AS Date), N'202110', N'Rec. BF Fatura C6', CAST(0.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (761, 3, CAST(N'2021-10-09' AS Date), N'202110', N'Pag. Frete', CAST(-70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (762, 3, CAST(N'2021-10-12' AS Date), N'202110', N'Unha ', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (763, 3, CAST(N'2021-10-16' AS Date), N'202110', N'Pag. BF Parcial fatura Carrefour', CAST(-69.98 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (764, 3, CAST(N'2021-10-30' AS Date), N'202110', N'Rec. Lidiane ', CAST(30.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (765, 3, CAST(N'2021-10-30' AS Date), N'202110', N'Pix Bradesco Kerllyane ', CAST(-10.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (766, 3, CAST(N'2021-10-30' AS Date), N'202110', N'Enviado para Setembro ', CAST(-8.42 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (767, 3, CAST(N'2021-11-03' AS Date), N'202110', N'Rec. Cleide ', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (768, 3, CAST(N'2021-11-03' AS Date), N'202110', N'Rec. BF', CAST(-53.67 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (769, 3, CAST(N'2021-11-03' AS Date), N'202110', N'Pag. Negociação', CAST(-64.93 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (770, 3, CAST(N'2021-11-09' AS Date), N'202110', N'Rec. Amanda', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (771, 3, CAST(N'2021-11-10' AS Date), N'202110', N'Rec. BF', CAST(-60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (772, 3, CAST(N'2021-11-19' AS Date), N'202110', N'Rec. Josi', CAST(65.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (773, 3, CAST(N'2021-11-19' AS Date), N'202110', N'Rec. BF', CAST(-65.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (774, 3, CAST(N'2021-11-20' AS Date), N'202110', N'Rec. Cinthia', CAST(80.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (775, 3, CAST(N'2021-11-20' AS Date), N'202110', N'Rec. BF', CAST(-9.21 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (776, 2, CAST(N'2021-11-19' AS Date), N'202110', N'Rec. BF', CAST(65.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (777, 2, CAST(N'2021-11-20' AS Date), N'202110', N'Rec. BF', CAST(9.21 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (778, 1, CAST(N'2021-01-16' AS Date), N'202101', N'Rec. Ruana', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (779, 1, CAST(N'2021-01-17' AS Date), N'202101', N'Pag. Nete máscaras', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (780, 1, CAST(N'2021-01-17' AS Date), N'202101', N'Retirada', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (781, 1, CAST(N'2021-01-17' AS Date), N'202101', N'Rec. Silane', CAST(120.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (782, 1, CAST(N'2021-01-21' AS Date), N'202101', N'Compra', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (783, 1, CAST(N'2021-01-25' AS Date), N'202101', N'Rec. Ruana Relogio 1', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (784, 1, CAST(N'2021-01-25' AS Date), N'202101', N'Rec. Ruana Relogio 2', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (785, 1, CAST(N'2021-01-25' AS Date), N'202101', N'Rec. Ruana Baby Doll', CAST(20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (786, 1, CAST(N'2021-01-25' AS Date), N'202101', N'Despesas', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (787, 1, CAST(N'2021-01-28' AS Date), N'202101', N'Peixe', CAST(-10.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (788, 1, CAST(N'2021-01-30' AS Date), N'202101', N'Pag. taxa de entrega', CAST(-25.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (789, 1, CAST(N'2021-01-30' AS Date), N'202101', N'Despesas', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (790, 1, CAST(N'2021-01-30' AS Date), N'202101', N'Rec. Ruana marido', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (791, 1, CAST(N'2021-01-30' AS Date), N'202101', N'Rec. Ruana', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (792, 1, CAST(N'2021-01-31' AS Date), N'202101', N'Almoço', CAST(-40.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (793, 1, CAST(N'2021-02-02' AS Date), N'202101', N'Pag. empréstimo JF', CAST(-225.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (794, 4, CAST(N'2021-02-08' AS Date), N'202102', N'Rec. Ruana', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (795, 4, CAST(N'2021-02-08' AS Date), N'202102', N'Retirada Johnny', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (796, 4, CAST(N'2021-02-15' AS Date), N'202102', N'Rec. Ruana', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (797, 4, CAST(N'2021-02-18' AS Date), N'202102', N'Retirada Johnny', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (798, 4, CAST(N'2021-02-18' AS Date), N'202102', N'Rec. Kaline', CAST(220.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (799, 4, CAST(N'2021-02-20' AS Date), N'202102', N'Compra Gasolina', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (800, 4, CAST(N'2021-02-20' AS Date), N'202102', N'Rec. Ruana', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (801, 4, CAST(N'2021-02-20' AS Date), N'202102', N'Depósito', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (802, 4, CAST(N'2021-02-21' AS Date), N'202102', N'Rec. Taciana', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (803, 4, CAST(N'2021-02-21' AS Date), N'202102', N'Valor a identificar', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (804, 4, CAST(N'2021-02-26' AS Date), N'202102', N'Despesas', CAST(-70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (805, 4, CAST(N'2021-02-26' AS Date), N'202102', N'Rec. Rosa', CAST(160.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (806, 4, CAST(N'2021-02-26' AS Date), N'202102', N'Rec. venda 2 sutiãs Andreza', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (807, 4, CAST(N'2021-02-27' AS Date), N'202102', N'Depósito', CAST(-200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (808, 4, CAST(N'2021-02-27' AS Date), N'202102', N'Retirada Johnny', CAST(-10.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (809, 4, CAST(N'2021-02-27' AS Date), N'202102', N'Pag. frete', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (810, 4, CAST(N'2021-03-01' AS Date), N'202102', N'Rec. Nete', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (811, 4, CAST(N'2021-03-05' AS Date), N'202103', N'Despesas', CAST(-30.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (812, 4, CAST(N'2021-03-05' AS Date), N'202103', N'Rec. Mãe Erivelton', CAST(120.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (813, 4, CAST(N'2021-03-06' AS Date), N'202103', N'Depósito', CAST(-200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (814, 4, CAST(N'2021-03-06' AS Date), N'202103', N'Rec. Ruana', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (815, 4, CAST(N'2021-03-06' AS Date), N'202103', N'Rec. Amiga Ruana', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (816, 4, CAST(N'2021-03-06' AS Date), N'202103', N'Rec. Adelce', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (817, 4, CAST(N'2021-03-07' AS Date), N'202103', N'Rec. Roni irmão Cinthia', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (818, 4, CAST(N'2021-03-07' AS Date), N'202103', N'Retirada prêmio rifa', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (819, 4, CAST(N'2021-03-09' AS Date), N'202103', N'Depósito', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (820, 4, CAST(N'2021-03-09' AS Date), N'202103', N'Rec. Adelce', CAST(61.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (821, 4, CAST(N'2021-03-11' AS Date), N'202103', N'Rec. Mãe Amanda', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (822, 4, CAST(N'2021-03-12' AS Date), N'202103', N'Depósito', CAST(-200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (823, 4, CAST(N'2021-03-15' AS Date), N'202103', N'Rec. Adelce', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (824, 4, CAST(N'2021-03-15' AS Date), N'202103', N'Rec. irmã  Adelce', CAST(45.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (825, 4, CAST(N'2021-03-15' AS Date), N'202103', N'Rec. Amiga Ruana', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (826, 4, CAST(N'2021-03-15' AS Date), N'202103', N'Retirada', CAST(-46.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (827, 4, CAST(N'2021-03-16' AS Date), N'202103', N'Pag. Frete ', CAST(-110.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (828, 4, CAST(N'2021-03-16' AS Date), N'202103', N'Rec. Rosa', CAST(160.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (829, 4, CAST(N'2021-03-17' AS Date), N'202103', N'Rec. Thais vizinha Cinthia', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (830, 4, CAST(N'2021-03-20' AS Date), N'202103', N'Rec. Dalvinha', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (831, 4, CAST(N'2021-03-20' AS Date), N'202103', N'Pag. Dani', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (832, 4, CAST(N'2021-03-20' AS Date), N'202103', N'Pag. Josi ', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (833, 4, CAST(N'2021-03-20' AS Date), N'202103', N'Churrasco ', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (834, 4, CAST(N'2021-03-21' AS Date), N'202103', N'Rec. Nayara', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (835, 4, CAST(N'2021-03-22' AS Date), N'202103', N'Rec. Ruana', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (836, 4, CAST(N'2021-03-22' AS Date), N'202103', N'Depósito ', CAST(-200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (837, 4, CAST(N'2021-03-22' AS Date), N'202103', N'Rec. Amiga Ruana', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (838, 4, CAST(N'2021-03-22' AS Date), N'202103', N'Retirada', CAST(-10.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (839, 4, CAST(N'2021-03-22' AS Date), N'202103', N'Rec. Kalyne', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (840, 4, CAST(N'2021-03-25' AS Date), N'202103', N'Rec. Nayara', CAST(160.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (841, 4, CAST(N'2021-03-25' AS Date), N'202103', N'Rec. Thaise', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (842, 4, CAST(N'2021-03-25' AS Date), N'202103', N'Rec. Emprétimo BF', CAST(-570.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (843, 1, CAST(N'2021-03-25' AS Date), N'202103', N'Rec. Emprétimo BF', CAST(570.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (844, 1, CAST(N'2021-03-25' AS Date), N'202103', N'Depósito ', CAST(-400.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (845, 1, CAST(N'2021-03-25' AS Date), N'202103', N'Retirada ', CAST(-70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (846, 1, CAST(N'2021-03-29' AS Date), N'202103', N'Troca Dinheiro/PicPay', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (847, 1, CAST(N'2021-03-30' AS Date), N'202103', N'Rec. Empréstimo BF', CAST(170.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (848, 1, CAST(N'2021-03-30' AS Date), N'202103', N'Depósito', CAST(-330.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (849, 1, CAST(N'2021-04-01' AS Date), N'202103', N'Pag. Emprestimo JF', CAST(270.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (850, 1, CAST(N'2021-04-01' AS Date), N'202103', N'Despesas', CAST(-10.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (851, 1, CAST(N'2021-04-08' AS Date), N'202103', N'Pag. Emp. BF', CAST(30.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (852, 4, CAST(N'2021-03-26' AS Date), N'202103', N'Rec. Vendas', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (853, 4, CAST(N'2021-03-28' AS Date), N'202103', N'Rec. Pastora Cleide', CAST(170.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (854, 4, CAST(N'2021-03-29' AS Date), N'202103', N'Troca Dinheiro/PicPay', CAST(-60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (855, 4, CAST(N'2021-03-30' AS Date), N'202103', N'Rec. Empréstimo BF', CAST(-170.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (856, 4, CAST(N'2021-03-31' AS Date), N'202103', N'Rec. Ruana', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (857, 4, CAST(N'2021-03-31' AS Date), N'202103', N'Rec. Adelce', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (858, 4, CAST(N'2021-03-31' AS Date), N'202103', N'Rec. Rosa', CAST(160.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (859, 4, CAST(N'2021-04-01' AS Date), N'202103', N'Pag. Emprestimo JF', CAST(-270.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (860, 4, CAST(N'2021-04-06' AS Date), N'202104', N'Rec. Mãe Erivelton', CAST(200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (861, 4, CAST(N'2021-04-07' AS Date), N'202104', N'Rec. BF', CAST(-35.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (862, 4, CAST(N'2021-04-07' AS Date), N'202104', N'Pag. Frete', CAST(-70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (863, 4, CAST(N'2021-04-07' AS Date), N'202104', N'Pag. Gustavo ', CAST(-30.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (864, 4, CAST(N'2021-04-08' AS Date), N'202104', N'Pag. Emp. JF', CAST(-30.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (865, 4, CAST(N'2021-04-08' AS Date), N'202104', N'Rec. Amiga Ruana', CAST(30.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (866, 4, CAST(N'2021-04-12' AS Date), N'202104', N'Despesas', CAST(-30.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (867, 4, CAST(N'2021-04-14' AS Date), N'202104', N'Rec. Michelle', CAST(105.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (868, 4, CAST(N'2021-04-14' AS Date), N'202104', N'Despesas', CAST(-40.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (869, 4, CAST(N'2021-04-14' AS Date), N'202104', N'Despesas', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (870, 4, CAST(N'2021-04-15' AS Date), N'202104', N'Rec. Rosa', CAST(160.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (871, 4, CAST(N'2021-04-15' AS Date), N'202104', N'Rec. Nete', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (872, 4, CAST(N'2021-04-15' AS Date), N'202104', N'Despesas', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (873, 4, CAST(N'2021-04-17' AS Date), N'202104', N'Despesas', CAST(-120.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (874, 4, CAST(N'2021-04-26' AS Date), N'202104', N'Despesas', CAST(-40.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (875, 4, CAST(N'2021-04-26' AS Date), N'202104', N'Rec. Adelce', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (876, 4, CAST(N'2021-05-01' AS Date), N'202104', N'Rec. Irmão Cinthia', CAST(90.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (877, 4, CAST(N'2021-05-01' AS Date), N'202104', N'Rec. Mãe Josi', CAST(160.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (878, 4, CAST(N'2021-05-01' AS Date), N'202104', N'Rec. Josi', CAST(140.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (879, 1, CAST(N'2021-04-06' AS Date), N'202104', N'Gastos ', CAST(-60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (880, 1, CAST(N'2021-04-06' AS Date), N'202104', N'Dízimo Kerllyane ', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (881, 1, CAST(N'2021-04-07' AS Date), N'202104', N'Rec. BF', CAST(35.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (882, 1, CAST(N'2021-04-09' AS Date), N'202104', N'Escola Davi', CAST(-150.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (883, 1, CAST(N'2021-04-14' AS Date), N'202104', N'Despesas', CAST(-15.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (884, 1, CAST(N'2021-04-26' AS Date), N'202104', N'Kerllyane', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (885, 1, CAST(N'2021-05-01' AS Date), N'202104', N'Rec. Igreja', CAST(210.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (886, 4, CAST(N'2021-05-02' AS Date), N'202105', N'Oferta', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (887, 4, CAST(N'2021-05-06' AS Date), N'202105', N'Lavagem ar', CAST(-125.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (888, 4, CAST(N'2021-05-06' AS Date), N'202105', N'Rec. 16 104', CAST(160.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (889, 4, CAST(N'2021-05-07' AS Date), N'202105', N'Compra Tinta', CAST(-90.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (890, 4, CAST(N'2021-05-07' AS Date), N'202105', N'Compra Relógio', CAST(-300.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (891, 4, CAST(N'2021-05-10' AS Date), N'202105', N'Rec. Marluce', CAST(105.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (892, 4, CAST(N'2021-05-13' AS Date), N'202105', N'Rec. Juci (Relog. Grafite) 1/2', CAST(160.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (893, 4, CAST(N'2021-05-13' AS Date), N'202105', N'Passagens carro', CAST(-180.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (894, 4, CAST(N'2021-05-12' AS Date), N'202105', N'Churrasco', CAST(-22.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (895, 4, CAST(N'2021-05-13' AS Date), N'202105', N'Churrasco', CAST(-24.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (896, 4, CAST(N'2021-05-12' AS Date), N'202105', N'Rec. Mãe Amanda', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (897, 4, CAST(N'2021-05-13' AS Date), N'202105', N'Despesas', CAST(-49.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (898, 4, CAST(N'2021-05-18' AS Date), N'202105', N'Zeramento', CAST(-145.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (899, 4, CAST(N'2021-05-25' AS Date), N'202105', N'Rec. Vendas', CAST(550.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (900, 4, CAST(N'2021-05-27' AS Date), N'202105', N'Pag. fotos Agnes', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (901, 4, CAST(N'2021-05-29' AS Date), N'202105', N'Retirada', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (902, 4, CAST(N'2021-05-29' AS Date), N'202105', N'Deposito', CAST(-300.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (903, 1, CAST(N'2021-05-02' AS Date), N'202105', N'Oferta', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (904, 1, CAST(N'2021-05-04' AS Date), N'202105', N'Retirada', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (905, 1, CAST(N'2021-05-06' AS Date), N'202105', N'Lavagem ar', CAST(-125.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (906, 1, CAST(N'2021-05-06' AS Date), N'202105', N'Retirada', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (907, 1, CAST(N'2021-05-07' AS Date), N'202105', N'Retirada', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (908, 1, CAST(N'2021-05-18' AS Date), N'202105', N'Zeramento', CAST(-45.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (909, 1, CAST(N'2021-05-27' AS Date), N'202105', N'Rec. Paula', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (910, 1, CAST(N'2021-05-29' AS Date), N'202105', N'Deposito', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (911, 4, CAST(N'2021-06-01' AS Date), N'202106', N'Rec. Pardal', CAST(300.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (912, 4, CAST(N'2021-06-04' AS Date), N'202106', N'Rec. Helena', CAST(60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (913, 4, CAST(N'2021-06-04' AS Date), N'202106', N'Retirada', CAST(-60.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (914, 4, CAST(N'2021-06-07' AS Date), N'202106', N'Retirada', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (915, 4, CAST(N'2021-06-10' AS Date), N'202106', N'Pag. Mãe', CAST(-300.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (916, 4, CAST(N'2021-06-29' AS Date), N'202106', N'Rec. Pastora Cleide', CAST(120.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (917, 4, CAST(N'2021-06-29' AS Date), N'202106', N'Retirada', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (918, 4, CAST(N'2021-07-01' AS Date), N'202106', N'Retirada', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (919, 4, CAST(N'2021-07-31' AS Date), N'202107', N'Rec. Venda', CAST(150.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (920, 4, CAST(N'2021-08-01' AS Date), N'202107', N'Oferta', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (921, 4, CAST(N'2021-08-01' AS Date), N'202107', N'Despesas', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (922, 1, CAST(N'2021-07-23' AS Date), N'202107', N'Rec. Kerllyane', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (923, 1, CAST(N'2021-07-23' AS Date), N'202107', N'Pag. Deliane', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (924, 1, CAST(N'2021-07-30' AS Date), N'202107', N'Rec. Deliane', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (925, 1, CAST(N'2021-08-01' AS Date), N'202107', N'Oferta', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (926, 4, CAST(N'2021-08-08' AS Date), N'202108', N'Rec. Irmã Josi', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (927, 4, CAST(N'2021-08-08' AS Date), N'202108', N'Rec. Pastora', CAST(76.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (928, 4, CAST(N'2021-08-08' AS Date), N'202108', N'Despesas', CAST(-6.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (929, 4, CAST(N'2021-08-11' AS Date), N'202108', N'Despesas', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (930, 4, CAST(N'2021-08-16' AS Date), N'202108', N'Rec. Marluce', CAST(150.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (931, 4, CAST(N'2021-08-16' AS Date), N'202108', N'Pag. Faxina', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (932, 4, CAST(N'2021-08-16' AS Date), N'202108', N'Despesas', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (933, 4, CAST(N'2021-08-18' AS Date), N'202108', N'Pag. frete', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (934, 4, CAST(N'2021-08-20' AS Date), N'202108', N'Rec. Suelen', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (935, 4, CAST(N'2021-08-20' AS Date), N'202108', N'Despesas', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (936, 4, CAST(N'2021-08-25' AS Date), N'202108', N'Rec. BF', CAST(-200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (937, 4, CAST(N'2021-09-05' AS Date), N'202108', N'Rec. Dani', CAST(65.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (938, 4, CAST(N'2021-09-05' AS Date), N'202108', N'Rec. Dani', CAST(25.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (939, 4, CAST(N'2021-09-08' AS Date), N'202108', N'Rec. Amanda', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (940, 4, CAST(N'2021-09-08' AS Date), N'202108', N'A identificar', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (941, 4, CAST(N'2021-09-09' AS Date), N'202108', N'Rec. BF', CAST(-240.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (942, 1, CAST(N'2021-08-25' AS Date), N'202108', N'Rec. BF', CAST(200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (943, 1, CAST(N'2021-08-25' AS Date), N'202108', N'Pag. Deliane', CAST(-200.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (944, 1, CAST(N'2021-09-02' AS Date), N'202108', N'Rec. Kerllyane', CAST(300.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (945, 1, CAST(N'2021-09-09' AS Date), N'202108', N'Rec. BF', CAST(240.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (946, 4, CAST(N'2021-08-04' AS Date), N'202108', N'Rec. Josi', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (947, 4, CAST(N'2021-09-30' AS Date), N'202109', N'Rec. Nayara', CAST(150.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (948, 4, CAST(N'2021-10-02' AS Date), N'202109', N'Pag. Frete', CAST(-150.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (949, 4, CAST(N'2021-10-16' AS Date), N'202109', N'Rec. Greicy', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (950, 4, CAST(N'2021-10-16' AS Date), N'202109', N'Rec. BF parcial fatura Carrefour', CAST(-70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (951, 4, CAST(N'2021-10-26' AS Date), N'202109', N'Rec. Josi', CAST(100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (952, 1, CAST(N'2021-09-16' AS Date), N'202109', N'Almoço mamãe ', CAST(-100.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (953, 1, CAST(N'2021-09-16' AS Date), N'202109', N'Despesas', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (954, 1, CAST(N'2021-09-18' AS Date), N'202109', N'Pag. Frete Nega', CAST(-70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (955, 1, CAST(N'2021-09-18' AS Date), N'202109', N'Gasolina Nega', CAST(-30.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (956, 1, CAST(N'2021-09-20' AS Date), N'202109', N'Pag. Deliane', CAST(-300.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (957, 1, CAST(N'2021-09-21' AS Date), N'202109', N'Retirada', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (958, 1, CAST(N'2021-10-16' AS Date), N'202109', N'Rec. BF parcial fatura Carrefour', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (959, 1, CAST(N'2021-11-19' AS Date), N'202109', N'Rec. Kerllyane', CAST(350.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (960, 4, CAST(N'2021-10-21' AS Date), N'202110', N'Rec. Jô', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (961, 4, CAST(N'2021-10-22' AS Date), N'202110', N'Rec. BF', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (962, 4, CAST(N'2021-10-26' AS Date), N'202110', N'Retirada', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (963, 4, CAST(N'2021-11-01' AS Date), N'202110', N'Rec. BF', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (964, 4, CAST(N'2021-11-10' AS Date), N'202110', N'Rec. Mãe Amanda ', CAST(120.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (965, 4, CAST(N'2021-11-10' AS Date), N'202110', N'Rec. BF Fatura Gold ', CAST(-31.07 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (966, 4, CAST(N'2021-11-10' AS Date), N'202110', N'Rec. BF Fatura C6', CAST(-6.65 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (967, 4, CAST(N'2021-11-10' AS Date), N'202110', N'Rec. BF Fatura PagSeguro ', CAST(-76.52 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (968, 4, CAST(N'2021-11-10' AS Date), N'202110', N'Rec. BF Fatura Nubank ', CAST(-5.76 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (969, 4, CAST(N'2021-11-19' AS Date), N'202110', N'Rec. Josi', CAST(80.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (970, 4, CAST(N'2021-11-19' AS Date), N'202110', N'Despesas', CAST(-10.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (971, 1, CAST(N'2021-10-19' AS Date), N'202110', N'Rec. igreja pag. bemol ', CAST(190.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (972, 1, CAST(N'2021-10-19' AS Date), N'202110', N'Pag. Celio', CAST(-150.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (973, 1, CAST(N'2021-10-19' AS Date), N'202110', N'Poupas', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (974, 1, CAST(N'2021-10-21' AS Date), N'202110', N'Compras', CAST(-10.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (975, 1, CAST(N'2021-10-22' AS Date), N'202110', N'Rec. BF', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (976, 1, CAST(N'2021-10-22' AS Date), N'202110', N'Troca por depósito ', CAST(-110.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (977, 1, CAST(N'2021-10-22' AS Date), N'202110', N'Despesas', CAST(-20.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (978, 1, CAST(N'2021-10-22' AS Date), N'202110', N'Saque', CAST(400.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (979, 1, CAST(N'2021-10-27' AS Date), N'202110', N'Rec. Deliane', CAST(70.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (980, 1, CAST(N'2021-11-01' AS Date), N'202110', N'Retirada', CAST(-50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (981, 1, CAST(N'2021-11-01' AS Date), N'202110', N'Rec. BF', CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (982, 1, CAST(N'2021-11-10' AS Date), N'202110', N'Rec. BF Fatura Gold ', CAST(31.07 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (983, 1, CAST(N'2021-11-10' AS Date), N'202110', N'Rec. BF Fatura C6', CAST(6.65 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (984, 1, CAST(N'2021-11-10' AS Date), N'202110', N'Rec. BF Fatura PagSeguro ', CAST(76.52 AS Numeric(18, 2)))
GO
INSERT [dbo].[AccountsPostings] ([Id], [AccountId], [Date], [Reference], [Description], [Amount]) VALUES (985, 1, CAST(N'2021-11-10' AS Date), N'202110', N'Rec. BF Fatura Nubank ', CAST(5.76 AS Numeric(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[AccountsPostings] OFF
GO
SET IDENTITY_INSERT [dbo].[Cards] ON 
GO
INSERT [dbo].[Cards] ([Id], [UserId], [Name], [Color]) VALUES (1, 1, N'Gold', N'bf8f00')
GO
INSERT [dbo].[Cards] ([Id], [UserId], [Name], [Color]) VALUES (2, 1, N'C6', N'e3e2e5')
GO
INSERT [dbo].[Cards] ([Id], [UserId], [Name], [Color]) VALUES (3, 1, N'PicPay', N'22c25f')
GO
INSERT [dbo].[Cards] ([Id], [UserId], [Name], [Color]) VALUES (4, 1, N'Nubank', N'820ad1')
GO
INSERT [dbo].[Cards] ([Id], [UserId], [Name], [Color]) VALUES (5, 1, N'Neon', N'00b0db')
GO
INSERT [dbo].[Cards] ([Id], [UserId], [Name], [Color]) VALUES (6, 1, N'Carrefour', N'009fb1')
GO
INSERT [dbo].[Cards] ([Id], [UserId], [Name], [Color]) VALUES (7, 1, N'PagSeguro', N'01a537')
GO
INSERT [dbo].[Cards] ([Id], [UserId], [Name], [Color]) VALUES (8, 1, N'Elo', N'002060')
GO
SET IDENTITY_INSERT [dbo].[Cards] OFF
GO
SET IDENTITY_INSERT [dbo].[CardsPostings] ON 
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (1, 1, CAST(N'2020-08-15' AS Date), N'202101', N'Iphone 6/12', NULL, NULL, CAST(62.34 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (2, 1, CAST(N'2020-05-15' AS Date), N'202101', N'Minizinha 9/12', NULL, NULL, CAST(8.90 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (3, 1, CAST(N'2021-01-15' AS Date), N'202101', N'Mamãe 9/10', NULL, NULL, CAST(269.90 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (4, 1, CAST(N'2020-07-11' AS Date), N'202101', N'Celular Mãe 7/10 (Raylson)', NULL, NULL, CAST(59.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (5, 1, CAST(N'2020-07-11' AS Date), N'202101', N'Celular Mãe 7/10', NULL, NULL, CAST(59.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (6, 1, CAST(N'2020-12-28' AS Date), N'202101', N'Cartao de Todos', NULL, NULL, CAST(23.10 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (7, 1, CAST(N'2020-04-23' AS Date), N'202101', N'A30s 9/12', NULL, NULL, CAST(101.57 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (8, 1, CAST(N'2020-10-15' AS Date), N'202101', N'Claro', NULL, NULL, CAST(39.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (9, 1, CAST(N'2020-12-27' AS Date), N'202101', N'Netflix', NULL, NULL, CAST(16.45 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (10, 1, CAST(N'2020-12-27' AS Date), N'202101', N'Netflix Paim', NULL, NULL, CAST(16.45 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (11, 1, CAST(N'2020-12-09' AS Date), N'202101', N'Google Drive', NULL, NULL, CAST(9.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (12, 1, CAST(N'2020-11-20' AS Date), N'202101', N'Pedaleira 3/12', NULL, NULL, CAST(179.08 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (13, 1, CAST(N'2020-11-25' AS Date), N'202101', N'Bolsas + Tenis Isabella 2/2', NULL, NULL, CAST(123.48 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (14, 1, CAST(N'2020-12-26' AS Date), N'202101', N'Disney+ 2/12', NULL, NULL, CAST(18.60 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (15, 1, CAST(N'2020-11-26' AS Date), N'202101', N'Udemy 2/3', NULL, NULL, CAST(31.20 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (16, 1, CAST(N'2020-11-27' AS Date), N'202101', N'Fone + Capa 2/3', NULL, NULL, CAST(94.74 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (17, 1, CAST(N'2020-11-30' AS Date), N'202101', N'Compras Gustavo 2/2', NULL, NULL, CAST(57.98 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (18, 1, CAST(N'2020-12-08' AS Date), N'202101', N'Compras roupas 2/3 = 231,40', NULL, NULL, CAST(77.13 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (19, 1, CAST(N'2020-12-08' AS Date), N'202101', N'Compras Roupa Agnes 2/2', NULL, NULL, CAST(116.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (20, 1, CAST(N'2020-12-08' AS Date), N'202101', N'Compras roupas Josi 2/3 = 272,90', NULL, NULL, CAST(90.96 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (21, 1, CAST(N'2020-12-12' AS Date), N'202101', N'Compra Kerllyane 2/2', NULL, NULL, CAST(56.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (22, 1, CAST(N'2020-12-23' AS Date), N'202101', N'Higienização cama', NULL, NULL, CAST(100.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (23, 1, CAST(N'2020-12-23' AS Date), N'202101', N'Insulfilm 1/2', NULL, NULL, CAST(115.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (24, 1, CAST(N'2020-12-23' AS Date), N'202101', N'Telas 1/2', NULL, NULL, CAST(130.64 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (25, 1, CAST(N'2020-12-24' AS Date), N'202101', N'Gás', NULL, NULL, CAST(88.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (26, 1, CAST(N'2020-12-26' AS Date), N'202101', N'Loja Nete 1/2', NULL, NULL, CAST(50.78 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (27, 1, CAST(N'2021-01-04' AS Date), N'202101', N'Farmacia', NULL, NULL, CAST(10.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (28, 1, CAST(N'2021-01-05' AS Date), N'202101', N'Site bella7fashion.com', NULL, NULL, CAST(173.99 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (29, 1, CAST(N'2021-01-05' AS Date), N'202101', N'Farmacia', NULL, NULL, CAST(21.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (30, 1, CAST(N'2021-01-06' AS Date), N'202101', N'Cordas baixo', NULL, NULL, CAST(219.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (31, 1, CAST(N'2021-01-07' AS Date), N'202101', N'Pag. venda teste site', NULL, NULL, CAST(1.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (32, 1, CAST(N'2021-01-09' AS Date), N'202101', N'Farmabem', NULL, NULL, CAST(33.80 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (33, 1, CAST(N'2021-01-10' AS Date), N'202101', N'Compra', NULL, NULL, CAST(13.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (34, 1, CAST(N'2021-01-24' AS Date), N'202101', N'Estorno anuidade', NULL, NULL, CAST(-70.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (35, 1, CAST(N'2020-08-15' AS Date), N'202101', N'Iphone 7/12', NULL, NULL, CAST(62.34 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (36, 1, CAST(N'2020-05-15' AS Date), N'202102', N'Minizinha 10/12', NULL, NULL, CAST(8.90 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (37, 1, CAST(N'2021-01-15' AS Date), N'202102', N'Mamãe 10/10', NULL, NULL, CAST(269.90 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (38, 1, CAST(N'2020-07-11' AS Date), N'202102', N'Celular Mãe 8/10 (Raylson)', NULL, NULL, CAST(59.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (39, 1, CAST(N'2020-07-11' AS Date), N'202102', N'Celular Mãe 8/10', NULL, NULL, CAST(59.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (40, 1, CAST(N'2020-12-28' AS Date), N'202102', N'Cartao de Todos', NULL, NULL, CAST(25.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (41, 1, CAST(N'2020-04-23' AS Date), N'202102', N'A30s 10/12', NULL, NULL, CAST(101.57 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (42, 1, CAST(N'2021-02-15' AS Date), N'202102', N'Claro', NULL, NULL, CAST(39.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (43, 1, CAST(N'2021-01-27' AS Date), N'202102', N'Netflix', NULL, NULL, CAST(16.45 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (44, 1, CAST(N'2021-01-27' AS Date), N'202102', N'Netflix Paim', NULL, NULL, CAST(16.45 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (45, 1, CAST(N'2021-02-08' AS Date), N'202102', N'Google Drive', NULL, NULL, CAST(9.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (46, 1, CAST(N'2020-11-20' AS Date), N'202102', N'Pedaleira 4/12', NULL, NULL, CAST(0.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (47, 1, CAST(N'2020-12-26' AS Date), N'202102', N'Disney+ 3/12', NULL, NULL, CAST(18.60 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (48, 1, CAST(N'2020-11-26' AS Date), N'202102', N'Udemy 3/3', NULL, NULL, CAST(31.20 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (49, 1, CAST(N'2020-11-27' AS Date), N'202102', N'Fone + Capa 3/3', NULL, NULL, CAST(94.74 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (50, 1, CAST(N'2020-12-08' AS Date), N'202102', N'Compras roupas 3/3 = 231,40', NULL, NULL, CAST(77.13 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (51, 1, CAST(N'2020-12-08' AS Date), N'202102', N'Compras roupas Josi 3/3 = 272,90', NULL, NULL, CAST(90.96 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (52, 1, CAST(N'2020-12-23' AS Date), N'202102', N'Insulfilm 2/2', NULL, NULL, CAST(115.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (53, 1, CAST(N'2020-12-23' AS Date), N'202102', N'Telas 2/2', NULL, NULL, CAST(130.64 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (54, 1, CAST(N'2020-12-26' AS Date), N'202102', N'Loja Nete 2/2', NULL, NULL, CAST(50.77 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (55, 1, CAST(N'2021-01-25' AS Date), N'202102', N'Joguinho Davi', NULL, NULL, CAST(7.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (56, 1, CAST(N'2021-02-04' AS Date), N'202102', N'Compras Agnes 1/2', NULL, NULL, CAST(248.21 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (57, 1, CAST(N'2021-02-04' AS Date), N'202102', N'Compra Melancia + Pupunha', NULL, NULL, CAST(32.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (58, 1, CAST(N'2021-02-08' AS Date), N'202102', N'Compra Josi 1/3', NULL, NULL, CAST(111.94 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (59, 1, CAST(N'2021-02-09' AS Date), N'202102', N'Estacionamento', NULL, NULL, CAST(8.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (60, 1, CAST(N'2021-02-09' AS Date), N'202102', N'Gasolina', NULL, NULL, CAST(30.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (61, 1, CAST(N'2021-02-09' AS Date), N'202102', N'Compras', NULL, NULL, CAST(16.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (62, 1, CAST(N'2021-02-13' AS Date), N'202102', N'Uber', NULL, NULL, CAST(14.83 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (63, 1, CAST(N'2021-02-15' AS Date), N'202102', N'Gasolina', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (64, 1, CAST(N'2021-02-15' AS Date), N'202102', N'Nova Era', NULL, NULL, CAST(128.12 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (65, 1, CAST(N'2021-02-17' AS Date), N'202102', N'Pedido BF 1/2', NULL, NULL, CAST(487.10 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (66, 1, CAST(N'2020-08-15' AS Date), N'202102', N'Iphone 7/12', NULL, NULL, CAST(62.34 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (67, 1, CAST(N'2020-08-15' AS Date), N'202103', N'Iphone 8/12', NULL, NULL, CAST(62.34 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (68, 1, CAST(N'2020-05-15' AS Date), N'202103', N'Minizinha 11/12', NULL, NULL, CAST(8.90 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (69, 1, CAST(N'2020-07-11' AS Date), N'202103', N'Celular Mãe 9/10 (Raylson)', NULL, NULL, CAST(59.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (70, 1, CAST(N'2020-07-11' AS Date), N'202103', N'Celular Mãe 9/10', NULL, NULL, CAST(59.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (71, 1, CAST(N'2020-12-28' AS Date), N'202103', N'Cartao de Todos', NULL, NULL, CAST(25.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (72, 1, CAST(N'2020-04-23' AS Date), N'202103', N'A30s 11/12', NULL, NULL, CAST(101.57 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (73, 1, CAST(N'2021-02-15' AS Date), N'202103', N'Claro', NULL, NULL, CAST(39.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (74, 1, CAST(N'2021-02-27' AS Date), N'202103', N'Netflix', NULL, NULL, CAST(16.45 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (75, 1, CAST(N'2021-02-27' AS Date), N'202103', N'Netflix Paim', NULL, NULL, CAST(16.45 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (76, 1, CAST(N'2021-02-27' AS Date), N'202103', N'Netflix Railson', NULL, NULL, CAST(13.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (77, 1, CAST(N'2021-02-08' AS Date), N'202103', N'Google Drive', NULL, NULL, CAST(9.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (78, 1, CAST(N'2020-11-20' AS Date), N'202103', N'Pedaleira 4/12', NULL, NULL, CAST(179.08 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (79, 1, CAST(N'2020-12-26' AS Date), N'202103', N'Disney+ 4/12', NULL, NULL, CAST(18.60 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (80, 1, CAST(N'2021-02-04' AS Date), N'202103', N'Compras Agnes 2/2', NULL, NULL, CAST(248.21 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (81, 1, CAST(N'2021-02-08' AS Date), N'202103', N'Compra Josi 2/3', NULL, NULL, CAST(111.93 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (82, 1, CAST(N'2021-02-17' AS Date), N'202103', N'Pedido BF 2/2', NULL, NULL, CAST(487.10 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (83, 1, CAST(N'2021-02-21' AS Date), N'202103', N'Diamantes Free Fire', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (84, 1, CAST(N'2021-02-22' AS Date), N'202103', N'Nova Era', NULL, NULL, CAST(401.82 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (85, 1, CAST(N'2021-02-23' AS Date), N'202103', N'Nova Era', NULL, NULL, CAST(17.83 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (86, 1, CAST(N'2021-02-27' AS Date), N'202103', N'Queijo', NULL, NULL, CAST(26.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (87, 1, CAST(N'2021-03-06' AS Date), N'202103', N'Compras', NULL, NULL, CAST(28.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (88, 1, CAST(N'2021-03-07' AS Date), N'202103', N'Churrasco', NULL, NULL, CAST(26.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (89, 1, CAST(N'2021-03-07' AS Date), N'202103', N'Churrasco', NULL, NULL, CAST(13.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (90, 1, CAST(N'2021-03-07' AS Date), N'202103', N'Sorvete', NULL, NULL, CAST(7.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (91, 1, CAST(N'2021-03-08' AS Date), N'202103', N'S20+', NULL, NULL, CAST(2969.10 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (92, 1, CAST(N'2021-03-08' AS Date), N'202103', N'Nova Era', NULL, NULL, CAST(6.55 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (93, 1, CAST(N'2021-03-11' AS Date), N'202103', N'Assinatura Amazon', NULL, NULL, CAST(9.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (94, 1, CAST(N'2021-03-11' AS Date), N'202103', N'Kit Ferramentas 1/2', NULL, NULL, CAST(39.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (95, 1, CAST(N'2021-03-12' AS Date), N'202103', N'Estacionamento', NULL, NULL, CAST(8.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (96, 1, CAST(N'2021-03-13' AS Date), N'202103', N'Uber', NULL, NULL, CAST(16.91 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (97, 1, CAST(N'2021-03-13' AS Date), N'202103', N'Uber', NULL, NULL, CAST(10.97 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (98, 1, CAST(N'2021-03-15' AS Date), N'202103', N'Recarga FF', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (99, 1, CAST(N'2021-03-15' AS Date), N'202103', N'Recarga FF', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (100, 1, CAST(N'2021-03-19' AS Date), N'202103', N'Estacionamento', NULL, NULL, CAST(8.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (101, 1, CAST(N'2021-03-20' AS Date), N'202103', N'Sacolas ', NULL, NULL, CAST(17.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (102, 1, CAST(N'2021-03-21' AS Date), N'202103', N'Sorvete', NULL, NULL, CAST(4.12 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (103, 1, CAST(N'2021-03-22' AS Date), N'202103', N'Amazon assinatura errada', NULL, NULL, CAST(89.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (104, 1, CAST(N'2021-03-22' AS Date), N'202103', N'Amazon', NULL, NULL, CAST(-6.44 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (105, 1, CAST(N'2021-03-22' AS Date), N'202103', N'Amazon assinatura errada', NULL, NULL, CAST(-89.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (106, 1, CAST(N'2020-08-15' AS Date), N'202104', N'Iphone 9/12', NULL, NULL, CAST(62.34 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (107, 1, CAST(N'2020-05-15' AS Date), N'202104', N'Minizinha 12/12', NULL, NULL, CAST(8.90 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (108, 1, CAST(N'2020-07-11' AS Date), N'202104', N'Celular Mãe 10/10 (Raylson)', NULL, NULL, CAST(59.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (109, 1, CAST(N'2020-07-11' AS Date), N'202104', N'Celular Mãe 10/10', NULL, NULL, CAST(59.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (110, 1, CAST(N'2020-12-28' AS Date), N'202104', N'Cartao de Todos', NULL, NULL, CAST(25.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (111, 1, CAST(N'2020-04-23' AS Date), N'202104', N'A30s 12/12', NULL, NULL, CAST(101.57 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (112, 1, CAST(N'2021-03-15' AS Date), N'202104', N'Claro', NULL, NULL, CAST(39.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (113, 1, CAST(N'2021-03-27' AS Date), N'202104', N'Netflix', NULL, NULL, CAST(16.45 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (114, 1, CAST(N'2021-03-27' AS Date), N'202104', N'Netflix Paim', NULL, NULL, CAST(16.45 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (115, 1, CAST(N'2021-03-27' AS Date), N'202104', N'Netflix Railson', NULL, NULL, CAST(13.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (116, 1, CAST(N'2021-04-09' AS Date), N'202104', N'Google Drive', NULL, NULL, CAST(9.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (117, 1, CAST(N'2020-11-20' AS Date), N'202104', N'Pedaleira 5/12', NULL, NULL, CAST(179.08 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (118, 1, CAST(N'2020-12-26' AS Date), N'202104', N'Disney+ 5/12', NULL, NULL, CAST(18.60 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (119, 1, CAST(N'2021-02-08' AS Date), N'202104', N'Compra Josi 3/3', NULL, NULL, CAST(111.93 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (120, 1, CAST(N'2021-03-11' AS Date), N'202104', N'Kit Ferramentas 2/2', NULL, NULL, CAST(39.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (121, 1, CAST(N'2021-03-25' AS Date), N'202104', N'Recarga', NULL, NULL, CAST(15.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (122, 1, CAST(N'2021-03-25' AS Date), N'202104', N'Compras Agnes', NULL, NULL, CAST(33.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (123, 1, CAST(N'2021-03-25' AS Date), N'202104', N'Bebe legal 1/2', NULL, NULL, CAST(44.15 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (124, 1, CAST(N'2021-03-25' AS Date), N'202104', N'Baiano', NULL, NULL, CAST(43.20 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (125, 1, CAST(N'2021-03-27' AS Date), N'202104', N'Consulta ', NULL, NULL, CAST(32.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (126, 1, CAST(N'2021-03-27' AS Date), N'202104', N'Exame Davi', NULL, NULL, CAST(102.30 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (127, 1, CAST(N'2021-03-27' AS Date), N'202104', N'C&A Davi 1/2', NULL, NULL, CAST(29.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (128, 1, CAST(N'2021-03-27' AS Date), N'202104', N'Shop Dope 1/3', NULL, NULL, CAST(49.94 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (129, 1, CAST(N'2021-03-27' AS Date), N'202104', N'Estacionamento ', NULL, NULL, CAST(8.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (130, 1, CAST(N'2021-03-28' AS Date), N'202104', N'Pizza ', NULL, NULL, CAST(37.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (131, 1, CAST(N'2021-03-31' AS Date), N'202104', N'Coema', NULL, NULL, CAST(36.03 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (132, 1, CAST(N'2021-03-31' AS Date), N'202104', N'Carteira + Cadarço 1/2', NULL, NULL, CAST(31.09 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (133, 1, CAST(N'2021-04-01' AS Date), N'202104', N'Gasolina', NULL, NULL, CAST(30.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (134, 1, CAST(N'2021-04-01' AS Date), N'202104', N'Tropical Via Norte 1/2', NULL, NULL, CAST(31.95 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (135, 1, CAST(N'2021-04-02' AS Date), N'202104', N'Estacionamento ', NULL, NULL, CAST(8.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (136, 1, CAST(N'2021-04-02' AS Date), N'202104', N'Bolo', NULL, NULL, CAST(105.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (137, 1, CAST(N'2021-04-03' AS Date), N'202104', N'Lavagem carro', NULL, NULL, CAST(35.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (138, 1, CAST(N'2021-04-03' AS Date), N'202104', N'A10s Cinthia 1/4', NULL, NULL, CAST(199.75 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (139, 1, CAST(N'2021-04-04' AS Date), N'202104', N'Refrigerante ', NULL, NULL, CAST(5.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (140, 1, CAST(N'2021-04-05' AS Date), N'202104', N'Compra ', NULL, NULL, CAST(17.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (141, 1, CAST(N'2021-04-05' AS Date), N'202104', N'Nova Era', NULL, NULL, CAST(64.18 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (142, 1, CAST(N'2021-04-07' AS Date), N'202104', N'Pelicula 1/2', NULL, NULL, CAST(26.48 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (143, 1, CAST(N'2021-04-09' AS Date), N'202104', N'Roda gigante', NULL, NULL, CAST(12.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (144, 1, CAST(N'2021-04-09' AS Date), N'202104', N'Almoço ', NULL, NULL, CAST(12.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (145, 1, CAST(N'2021-04-09' AS Date), N'202104', N'Shoping da Lingerie', NULL, NULL, CAST(47.60 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (146, 1, CAST(N'2021-04-09' AS Date), N'202104', N'Gasolina', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (147, 1, CAST(N'2021-04-10' AS Date), N'202104', N'Gas', NULL, NULL, CAST(80.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (148, 1, CAST(N'2021-04-11' AS Date), N'202104', N'Nova Era', NULL, NULL, CAST(66.81 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (149, 1, CAST(N'2021-04-13' AS Date), N'202104', N'Uber', NULL, NULL, CAST(8.59 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (150, 1, CAST(N'2021-04-14' AS Date), N'202104', N'Uber', NULL, NULL, CAST(9.72 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (151, 1, CAST(N'2021-04-14' AS Date), N'202104', N'IPTU 1/6', NULL, NULL, CAST(60.32 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (152, 1, CAST(N'2021-04-14' AS Date), N'202104', N'Recarga', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (153, 1, CAST(N'2021-04-14' AS Date), N'202104', N'Capinhas', NULL, NULL, CAST(40.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (154, 1, CAST(N'2021-04-14' AS Date), N'202104', N'Captador Jairo', NULL, NULL, CAST(390.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (155, 1, CAST(N'2021-04-14' AS Date), N'202104', N'Ultrassom', NULL, NULL, CAST(60.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (156, 1, CAST(N'2021-04-16' AS Date), N'202104', N'Consulta Davi', NULL, NULL, CAST(32.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (157, 1, CAST(N'2021-04-16' AS Date), N'202104', N'Gasolina', NULL, NULL, CAST(30.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (158, 1, CAST(N'2021-04-17' AS Date), N'202104', N'Camarão', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (159, 1, CAST(N'2021-04-17' AS Date), N'202104', N'Plugs', NULL, NULL, CAST(48.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (160, 1, CAST(N'2020-08-15' AS Date), N'202105', N'Iphone 10/12', NULL, NULL, CAST(62.34 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (161, 1, CAST(N'2020-12-28' AS Date), N'202105', N'Cartao de Todos', NULL, NULL, CAST(25.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (162, 1, CAST(N'2021-03-15' AS Date), N'202105', N'Claro', NULL, NULL, CAST(0.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (163, 1, CAST(N'2021-03-27' AS Date), N'202105', N'Netflix', NULL, NULL, CAST(16.45 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (164, 1, CAST(N'2021-03-27' AS Date), N'202105', N'Netflix Paim', NULL, NULL, CAST(16.45 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (165, 1, CAST(N'2021-03-27' AS Date), N'202105', N'Netflix Railson', NULL, NULL, CAST(13.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (166, 1, CAST(N'2021-03-08' AS Date), N'202105', N'Google Drive', NULL, NULL, CAST(9.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (167, 1, CAST(N'2020-11-20' AS Date), N'202105', N'Pedaleira 6/12', NULL, NULL, CAST(179.08 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (168, 1, CAST(N'2020-12-26' AS Date), N'202105', N'Disney+ 6/12', NULL, NULL, CAST(18.60 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (169, 1, CAST(N'2021-03-25' AS Date), N'202105', N'Bebe legal 2/2', NULL, NULL, CAST(44.15 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (170, 1, CAST(N'2021-03-27' AS Date), N'202105', N'C&A Davi 2/2', NULL, NULL, CAST(29.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (171, 1, CAST(N'2021-03-27' AS Date), N'202105', N'Shop Dope 2/3', NULL, NULL, CAST(49.93 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (172, 1, CAST(N'2021-03-31' AS Date), N'202105', N'Carteira + Cadarço 2/2', NULL, NULL, CAST(31.09 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (173, 1, CAST(N'2021-04-01' AS Date), N'202105', N'Tropical Via Norte 2/2', NULL, NULL, CAST(31.95 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (174, 1, CAST(N'2021-04-03' AS Date), N'202105', N'A10s Cinthia 2/4', NULL, NULL, CAST(199.75 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (175, 1, CAST(N'2021-04-07' AS Date), N'202105', N'Pelicula 2/2', NULL, NULL, CAST(26.48 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (176, 1, CAST(N'2021-04-14' AS Date), N'202105', N'IPTU 2/6', NULL, NULL, CAST(60.32 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (177, 1, CAST(N'2021-04-21' AS Date), N'202105', N'Nova Era', NULL, NULL, CAST(99.26 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (178, 1, CAST(N'2021-04-21' AS Date), N'202105', N'Máquina de cortar 1/2', NULL, NULL, CAST(24.15 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (179, 1, CAST(N'2021-04-22' AS Date), N'202105', N'Aparelho de pressão', NULL, NULL, CAST(124.40 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (180, 1, CAST(N'2021-04-23' AS Date), N'202105', N'Vivo Easy', NULL, NULL, CAST(29.33 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (181, 1, CAST(N'2021-04-24' AS Date), N'202105', N'Plugs', NULL, NULL, CAST(21.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (182, 1, CAST(N'2021-04-24' AS Date), N'202105', N'Plugs', NULL, NULL, CAST(19.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (183, 1, CAST(N'2021-04-24' AS Date), N'202105', N'Kenner 1/2', NULL, NULL, CAST(54.95 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (184, 1, CAST(N'2021-04-24' AS Date), N'202105', N'Tenis 1/2 (Lucia e Mirica) 70,00 + 50,00', NULL, NULL, CAST(119.99 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (185, 1, CAST(N'2021-04-24' AS Date), N'202105', N'Oculos Chillibeans 1/4', NULL, NULL, CAST(80.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (186, 1, CAST(N'2021-04-24' AS Date), N'202105', N'Camisa Flamengo 1/4', NULL, NULL, CAST(62.52 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (187, 1, CAST(N'2021-04-24' AS Date), N'202105', N'Adaptador Samsung 1/2', NULL, NULL, CAST(34.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (188, 1, CAST(N'2021-04-24' AS Date), N'202105', N'Bermudas 1/3', NULL, NULL, CAST(79.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (189, 1, CAST(N'2021-04-24' AS Date), N'202105', N'Estacionamento', NULL, NULL, CAST(8.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (190, 1, CAST(N'2021-04-30' AS Date), N'202105', N'Nova Era', NULL, NULL, CAST(25.78 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (191, 1, CAST(N'2021-05-04' AS Date), N'202105', N'Apa Móveis 1/6 (Francilene)', NULL, NULL, CAST(216.50 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (192, 1, CAST(N'2021-05-08' AS Date), N'202105', N'Strap Lock + Adaptador P2/P10', NULL, NULL, CAST(46.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (193, 1, CAST(N'2021-05-08' AS Date), N'202105', N'Plug', NULL, NULL, CAST(11.98 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (194, 1, CAST(N'2021-05-08' AS Date), N'202105', N'Sacolas BF', NULL, NULL, CAST(30.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (195, 1, CAST(N'2021-05-08' AS Date), N'202105', N'Sandália Havaianas', NULL, NULL, CAST(28.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (196, 1, CAST(N'2021-05-08' AS Date), N'202105', N'Porta palhetas', NULL, NULL, CAST(10.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (197, 1, CAST(N'2021-05-08' AS Date), N'202105', N'Capinha Paula', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (198, 1, CAST(N'2021-05-08' AS Date), N'202105', N'Tênis Davi 1/2', NULL, NULL, CAST(45.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (199, 1, CAST(N'2021-05-08' AS Date), N'202105', N'Torneira mamãe 1/2', NULL, NULL, CAST(68.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (200, 1, CAST(N'2021-05-08' AS Date), N'202105', N'Picanha mania', NULL, NULL, CAST(33.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (201, 1, CAST(N'2021-05-08' AS Date), N'202105', N'Máscara Lupo', NULL, NULL, CAST(22.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (202, 1, CAST(N'2021-05-08' AS Date), N'202105', N'O Boticário 1/2', NULL, NULL, CAST(66.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (203, 1, CAST(N'2021-05-08' AS Date), N'202105', N'Estacionamento', NULL, NULL, CAST(7.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (204, 1, CAST(N'2021-05-08' AS Date), N'202105', N'Uber', NULL, NULL, CAST(21.59 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (205, 1, CAST(N'2021-05-09' AS Date), N'202105', N'Ifood', NULL, NULL, CAST(13.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (206, 1, CAST(N'2020-08-15' AS Date), N'202106', N'Iphone 11/12', NULL, NULL, CAST(62.34 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (207, 1, CAST(N'2020-11-20' AS Date), N'202106', N'Pedaleira 7/12', NULL, NULL, CAST(179.08 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (208, 1, CAST(N'2020-12-26' AS Date), N'202106', N'Disney+ 7/12', NULL, NULL, CAST(0.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (209, 1, CAST(N'2021-03-27' AS Date), N'202106', N'Shop Dope 3/3', NULL, NULL, CAST(49.93 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (210, 1, CAST(N'2021-04-03' AS Date), N'202106', N'A10s Cinthia 3/4', NULL, NULL, CAST(199.75 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (211, 1, CAST(N'2021-04-14' AS Date), N'202106', N'IPTU 3/6', NULL, NULL, CAST(60.32 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (212, 1, CAST(N'2021-04-21' AS Date), N'202106', N'Máquina de cortar 2/2', NULL, NULL, CAST(24.15 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (213, 1, CAST(N'2021-04-24' AS Date), N'202106', N'Kenner 2/2', NULL, NULL, CAST(54.95 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (214, 1, CAST(N'2021-04-24' AS Date), N'202106', N'Tenis 2/2 (Lucia e Mirica) 70,00 + 50,00', NULL, NULL, CAST(119.99 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (215, 1, CAST(N'2021-04-24' AS Date), N'202106', N'Oculos Chillibeans 2/4', NULL, NULL, CAST(80.48 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (216, 1, CAST(N'2021-04-24' AS Date), N'202106', N'Camisa Flamengo 2/4', NULL, NULL, CAST(62.49 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (217, 1, CAST(N'2021-04-24' AS Date), N'202106', N'Adaptador Samsung 2/2', NULL, NULL, CAST(34.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (218, 1, CAST(N'2021-04-24' AS Date), N'202106', N'Bermudas 2/3', NULL, NULL, CAST(79.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (219, 1, CAST(N'2021-05-04' AS Date), N'202106', N'Apa Móveis 2/6 (Francilene)', NULL, NULL, CAST(216.50 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (220, 1, CAST(N'2021-05-08' AS Date), N'202106', N'Tênis Davi 2/2', NULL, NULL, CAST(44.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (221, 1, CAST(N'2021-05-08' AS Date), N'202106', N'Torneira mamãe 2/2', NULL, NULL, CAST(68.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (222, 1, CAST(N'2021-05-08' AS Date), N'202106', N'O Boticário 2/2', NULL, NULL, CAST(66.49 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (223, 1, CAST(N'2021-06-12' AS Date), N'202106', N'Recarga Free fire', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (224, 1, CAST(N'2021-06-19' AS Date), N'202106', N'Casa do Músico', NULL, NULL, CAST(44.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (225, 1, CAST(N'2021-06-19' AS Date), N'202106', N'Flagass', NULL, NULL, CAST(19.73 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (226, 1, CAST(N'2021-06-20' AS Date), N'202106', N'Padaria', NULL, NULL, CAST(11.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (227, 1, CAST(N'2020-08-15' AS Date), N'202107', N'Iphone 12/12', NULL, NULL, CAST(62.34 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (228, 1, CAST(N'2021-06-29' AS Date), N'202107', N'Cartao de Todos', NULL, NULL, CAST(25.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (229, 1, CAST(N'2020-11-20' AS Date), N'202107', N'Pedaleira 8/12', NULL, NULL, CAST(179.08 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (230, 1, CAST(N'2021-04-03' AS Date), N'202107', N'A10s Cinthia 4/4', NULL, NULL, CAST(199.75 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (231, 1, CAST(N'2021-04-14' AS Date), N'202107', N'IPTU 4/6', NULL, NULL, CAST(60.32 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (232, 1, CAST(N'2021-04-24' AS Date), N'202107', N'Oculos Chillibeans 3/4', NULL, NULL, CAST(80.48 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (233, 1, CAST(N'2021-04-24' AS Date), N'202107', N'Camisa Flamengo 3/4', NULL, NULL, CAST(62.49 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (234, 1, CAST(N'2021-04-24' AS Date), N'202107', N'Bermudas 3/3', NULL, NULL, CAST(79.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (235, 1, CAST(N'2021-05-04' AS Date), N'202107', N'Apa Móveis 3/6 (Francilene)', NULL, NULL, CAST(216.50 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (236, 1, CAST(N'2021-06-23' AS Date), N'202107', N'Uber', NULL, NULL, CAST(23.97 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (237, 1, CAST(N'2021-06-25' AS Date), N'202107', N'Udemy', NULL, NULL, CAST(0.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (238, 1, CAST(N'2021-06-25' AS Date), N'202107', N'Compra na bola', NULL, NULL, CAST(40.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (239, 1, CAST(N'2021-06-26' AS Date), N'202107', N'Controle TV', NULL, NULL, CAST(45.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (240, 1, CAST(N'2021-06-26' AS Date), N'202107', N'Compra', NULL, NULL, CAST(5.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (241, 1, CAST(N'2021-06-27' AS Date), N'202107', N'Uber', NULL, NULL, CAST(6.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (242, 1, CAST(N'2021-06-27' AS Date), N'202107', N'Uber', NULL, NULL, CAST(11.05 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (243, 1, CAST(N'2021-06-29' AS Date), N'202107', N'Udemy', NULL, NULL, CAST(22.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (244, 1, CAST(N'2021-07-01' AS Date), N'202107', N'Udemy', NULL, NULL, CAST(27.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (245, 1, CAST(N'2021-07-01' AS Date), N'202107', N'Uber', NULL, NULL, CAST(6.72 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (246, 1, CAST(N'2021-07-02' AS Date), N'202107', N'Aliexpress (adesivos carro)', NULL, NULL, CAST(25.92 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (247, 1, CAST(N'2021-07-04' AS Date), N'202107', N'Uber', NULL, NULL, CAST(8.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (248, 1, CAST(N'2021-07-04' AS Date), N'202107', N'Uber', NULL, NULL, CAST(6.44 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (249, 1, CAST(N'2021-07-05' AS Date), N'202107', N'Uber', NULL, NULL, CAST(8.98 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (250, 1, CAST(N'2021-07-05' AS Date), N'202107', N'Uber', NULL, NULL, CAST(7.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (251, 1, CAST(N'2021-07-05' AS Date), N'202107', N'Uber', NULL, NULL, CAST(6.94 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (252, 1, CAST(N'2021-07-08' AS Date), N'202107', N'Uber', NULL, NULL, CAST(6.94 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (253, 1, CAST(N'2021-07-11' AS Date), N'202107', N'Uber', NULL, NULL, CAST(9.91 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (254, 1, CAST(N'2021-07-13' AS Date), N'202107', N'Uber', NULL, NULL, CAST(15.94 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (255, 1, CAST(N'2021-07-17' AS Date), N'202107', N'Só Rossa 1/2 (Lucia)', NULL, NULL, CAST(474.50 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (256, 1, CAST(N'2021-07-17' AS Date), N'202107', N'Pag. Bemol', NULL, NULL, CAST(38.80 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (257, 1, CAST(N'2021-07-20' AS Date), N'202107', N'Nova Era', NULL, NULL, CAST(37.10 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (258, 1, CAST(N'2021-07-28' AS Date), N'202108', N'Cartao de Todos', NULL, NULL, CAST(25.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (259, 1, CAST(N'2021-08-09' AS Date), N'202108', N'Google Drive', NULL, NULL, CAST(9.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (260, 1, CAST(N'2020-11-20' AS Date), N'202108', N'Pedaleira 9/12', NULL, NULL, CAST(179.08 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (261, 1, CAST(N'2021-04-14' AS Date), N'202108', N'IPTU 5/6', NULL, NULL, CAST(60.32 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (262, 1, CAST(N'2021-04-24' AS Date), N'202108', N'Oculos Chillibeans 4/4', NULL, NULL, CAST(80.48 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (263, 1, CAST(N'2021-04-24' AS Date), N'202108', N'Camisa Flamengo 4/4', NULL, NULL, CAST(62.49 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (264, 1, CAST(N'2021-05-04' AS Date), N'202108', N'Apa Móveis 4/6 (Francilene)', NULL, NULL, CAST(216.50 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (265, 1, CAST(N'2021-07-17' AS Date), N'202108', N'Só Rossa 2/2 (Lucia)', NULL, NULL, CAST(474.50 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (266, 1, CAST(N'2021-07-26' AS Date), N'202108', N'Cocil 1/2', NULL, NULL, CAST(67.10 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (267, 1, CAST(N'2021-07-26' AS Date), N'202108', N'Ralo pia', NULL, NULL, CAST(10.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (268, 1, CAST(N'2021-07-27' AS Date), N'202108', N'Gummmy 1/6 - Nega', NULL, NULL, CAST(50.75 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (269, 1, CAST(N'2021-07-27' AS Date), N'202108', N'Gummmy 1/6 - Kerllyane', NULL, NULL, CAST(41.10 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (270, 1, CAST(N'2021-07-31' AS Date), N'202108', N'Drogaria', NULL, NULL, CAST(20.66 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (271, 1, CAST(N'2021-08-02' AS Date), N'202108', N'Youtube Premium', NULL, NULL, CAST(20.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (272, 1, CAST(N'2021-08-03' AS Date), N'202108', N'Nova Era', NULL, NULL, CAST(72.66 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (273, 1, CAST(N'2021-08-04' AS Date), N'202108', N'Soda cáustica', NULL, NULL, CAST(5.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (274, 1, CAST(N'2021-08-06' AS Date), N'202108', N'Nova Era', NULL, NULL, CAST(68.16 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (275, 1, CAST(N'2021-08-10' AS Date), N'202108', N'Erica', NULL, NULL, CAST(350.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (276, 1, CAST(N'2021-08-11' AS Date), N'202108', N'Uber Cleo', NULL, NULL, CAST(22.91 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (277, 1, CAST(N'2021-08-11' AS Date), N'202108', N'Baratão da Carne', NULL, NULL, CAST(225.95 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (278, 1, CAST(N'2021-08-11' AS Date), N'202108', N'Carregador Kerllyane', NULL, NULL, CAST(14.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (279, 1, CAST(N'2021-08-13' AS Date), N'202108', N'Bemol Farma', NULL, NULL, CAST(9.10 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (280, 1, CAST(N'2021-08-16' AS Date), N'202108', N'Marmitas', NULL, NULL, CAST(26.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (281, 1, CAST(N'2021-08-18' AS Date), N'202108', N'Foto + A4', NULL, NULL, CAST(22.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (282, 1, CAST(N'2021-08-23' AS Date), N'202108', N'Anuidade', NULL, NULL, CAST(36.25 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (283, 1, CAST(N'2021-09-08' AS Date), N'202109', N'Google Drive', NULL, NULL, CAST(9.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (284, 1, CAST(N'2020-11-20' AS Date), N'202109', N'Pedaleira 10/12', NULL, NULL, CAST(179.08 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (285, 1, CAST(N'2021-04-14' AS Date), N'202109', N'IPTU 6/6', NULL, NULL, CAST(60.32 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (286, 1, CAST(N'2021-05-04' AS Date), N'202109', N'Apa Móveis 5/6 (Francilene)', NULL, NULL, CAST(216.50 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (287, 1, CAST(N'2021-07-26' AS Date), N'202109', N'Cocil 2/2', NULL, NULL, CAST(67.09 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (288, 1, CAST(N'2021-07-27' AS Date), N'202109', N'Gummmy 2/6 - Nega', NULL, NULL, CAST(50.75 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (289, 1, CAST(N'2021-07-27' AS Date), N'202109', N'Gummmy 2/6 - Kerllyane', NULL, NULL, CAST(41.08 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (290, 1, CAST(N'2021-08-24' AS Date), N'202109', N'Udemy', NULL, NULL, CAST(27.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (291, 1, CAST(N'2021-08-25' AS Date), N'202109', N'Vivo Easy', NULL, NULL, CAST(39.99 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (292, 1, CAST(N'2021-08-28' AS Date), N'202109', N'Cartão de todos', NULL, NULL, CAST(50.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (293, 1, CAST(N'2021-09-03' AS Date), N'202109', N'Drogaria', NULL, NULL, CAST(29.73 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (294, 1, CAST(N'2021-09-10' AS Date), N'202109', N'Hub USB', NULL, NULL, CAST(25.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (295, 1, CAST(N'2021-09-14' AS Date), N'202109', N'Notebook ', NULL, NULL, CAST(4815.12 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (296, 1, CAST(N'2021-09-15' AS Date), N'202109', N'Chupeta', NULL, NULL, CAST(18.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (297, 1, CAST(N'2021-09-21' AS Date), N'202109', N'Mercado Pago (nível 6) 1/12', NULL, NULL, CAST(13.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (298, 1, CAST(N'2021-09-22' AS Date), N'202109', N'Anuidade', NULL, NULL, CAST(36.25 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (299, 1, CAST(N'2021-10-08' AS Date), N'202110', N'Google Drive', NULL, NULL, CAST(9.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (300, 1, CAST(N'2020-11-20' AS Date), N'202110', N'Pedaleira 11/12', NULL, NULL, CAST(179.08 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (301, 1, CAST(N'2021-05-04' AS Date), N'202110', N'Apa Móveis 6/6 (Francilene)', NULL, NULL, CAST(216.50 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (302, 1, CAST(N'2021-07-27' AS Date), N'202110', N'Gummmy 3/6 - Nega', NULL, NULL, CAST(50.75 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (303, 1, CAST(N'2021-07-27' AS Date), N'202110', N'Gummmy 3/6 - Kerllyane', NULL, NULL, CAST(41.08 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (304, 1, CAST(N'2021-09-21' AS Date), N'202110', N'Mercado Pago (nível 6) 2/12', NULL, NULL, CAST(0.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (305, 1, CAST(N'2021-09-22' AS Date), N'202110', N'Uber Sharla', NULL, NULL, CAST(22.93 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (306, 1, CAST(N'2021-09-25' AS Date), N'202110', N'Prado Som Cinthia 1/3', NULL, NULL, CAST(64.98 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (307, 1, CAST(N'2021-09-25' AS Date), N'202110', N'Loja Olimpica Cintia (266,00) 1/3', NULL, NULL, CAST(88.68 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (308, 1, CAST(N'2021-09-25' AS Date), N'202110', N'Torra Cinthia (332,91) 1/3', NULL, NULL, CAST(110.97 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (309, 1, CAST(N'2021-09-25' AS Date), N'202110', N'Armand (299,00) 1/3', NULL, NULL, CAST(99.68 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (310, 1, CAST(N'2021-09-25' AS Date), N'202110', N'Controle', NULL, NULL, CAST(40.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (311, 1, CAST(N'2021-09-25' AS Date), N'202110', N'Compra Cinthia', NULL, NULL, CAST(15.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (312, 1, CAST(N'2021-09-25' AS Date), N'202110', N'Casa do Musico (159,00) 1/3', NULL, NULL, CAST(53.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (313, 1, CAST(N'2021-09-25' AS Date), N'202110', N'Panificadora - Cinthia', NULL, NULL, CAST(21.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (314, 1, CAST(N'2021-09-25' AS Date), N'202110', N'Claro Flex', NULL, NULL, CAST(39.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (315, 1, CAST(N'2021-09-25' AS Date), N'202110', N'Vivo Easy', NULL, NULL, CAST(39.99 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (316, 1, CAST(N'2021-09-28' AS Date), N'202110', N'Cartao de todos', NULL, NULL, CAST(25.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (317, 1, CAST(N'2021-09-29' AS Date), N'202110', N'Cabo USB', NULL, NULL, CAST(45.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (318, 1, CAST(N'2021-09-29' AS Date), N'202110', N'Periotrat', NULL, NULL, CAST(22.53 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (319, 1, CAST(N'2021-09-29' AS Date), N'202110', N'Estacionamento', NULL, NULL, CAST(5.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (320, 1, CAST(N'2021-09-29' AS Date), N'202110', N'Torra Torra (284,89) 1/2', NULL, NULL, CAST(142.45 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (321, 1, CAST(N'2021-09-29' AS Date), N'202110', N'Lanche shopping', NULL, NULL, CAST(21.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (322, 1, CAST(N'2021-09-29' AS Date), N'202110', N'Nova Era', NULL, NULL, CAST(10.42 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (323, 1, CAST(N'2021-09-30' AS Date), N'202110', N'Melancia e banana', NULL, NULL, CAST(37.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (324, 1, CAST(N'2021-10-07' AS Date), N'202110', N'Uber', NULL, NULL, CAST(9.97 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (325, 1, CAST(N'2021-10-11' AS Date), N'202110', N'Baratão da Carne 1/2', NULL, NULL, CAST(54.02 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (326, 1, CAST(N'2021-10-11' AS Date), N'202110', N'Sunga', NULL, NULL, CAST(29.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (327, 1, CAST(N'2021-10-11' AS Date), N'202110', N'Drogaria', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (328, 1, CAST(N'2021-10-11' AS Date), N'202110', N'Blusa termica 1/2', NULL, NULL, CAST(29.95 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (329, 1, CAST(N'2021-10-20' AS Date), N'202110', N'Uber', NULL, NULL, CAST(7.43 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (330, 1, CAST(N'2021-10-25' AS Date), N'202110', N'Anuidade', NULL, NULL, CAST(36.25 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (331, 2, CAST(N'2020-08-15' AS Date), N'202101', N'Iphone 6/12', NULL, NULL, CAST(258.33 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (332, 2, CAST(N'2020-11-19' AS Date), N'202101', N'Sandalia Kerllyane 2/2', NULL, NULL, CAST(59.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (333, 2, CAST(N'2020-11-26' AS Date), N'202101', N'Compras Paula 2/2', NULL, NULL, CAST(83.50 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (334, 2, CAST(N'2020-12-02' AS Date), N'202101', N'Compra Gustavo 2/2', NULL, NULL, CAST(74.25 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (335, 2, CAST(N'2020-12-02' AS Date), N'202101', N'Compras Gustavo 2/2', NULL, NULL, CAST(101.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (336, 2, CAST(N'2020-12-18' AS Date), N'202101', N'Sofá 2/10', NULL, NULL, CAST(390.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (337, 2, CAST(N'2020-12-23' AS Date), N'202101', N'Pastel', NULL, NULL, CAST(16.70 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (338, 2, CAST(N'2020-12-26' AS Date), N'202101', N'Nova Era Josi', NULL, NULL, CAST(49.80 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (339, 2, CAST(N'2020-12-26' AS Date), N'202101', N'Nova Era Josi', NULL, NULL, CAST(146.79 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (340, 2, CAST(N'2020-12-30' AS Date), N'202101', N'Josi + Kerlly = 370,45 (1/3) Josi 229,05', NULL, NULL, CAST(76.35 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (341, 2, CAST(N'2020-12-30' AS Date), N'202101', N'Josi + Kerlly = 370,45 (1/3) Kerlly 141,40', NULL, NULL, CAST(47.14 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (342, 2, CAST(N'2020-12-30' AS Date), N'202101', N'Roupa Isabella', NULL, NULL, CAST(19.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (343, 2, CAST(N'2020-12-30' AS Date), N'202101', N'Meia Isabella', NULL, NULL, CAST(6.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (344, 2, CAST(N'2021-01-03' AS Date), N'202101', N'Ferragens Josi 1/2', NULL, NULL, CAST(175.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (345, 2, CAST(N'2021-01-04' AS Date), N'202101', N'Microfone 1/12', NULL, NULL, CAST(133.75 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (346, 2, CAST(N'2021-01-04' AS Date), N'202101', N'Fones + Power Click 1/12', NULL, NULL, CAST(160.25 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (347, 2, CAST(N'2021-01-09' AS Date), N'202101', N'Lavagem carro', NULL, NULL, CAST(25.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (348, 2, CAST(N'2021-01-09' AS Date), N'202101', N'Caixa Retorno igreja 1/10', NULL, NULL, CAST(126.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (349, 2, CAST(N'2021-01-11' AS Date), N'202101', N'Maquina Mamãe', NULL, NULL, CAST(1674.35 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (350, 2, CAST(N'2021-01-13' AS Date), N'202101', N'Farmabem', NULL, NULL, CAST(31.33 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (351, 2, CAST(N'2021-01-13' AS Date), N'202101', N'Frutas', NULL, NULL, CAST(25.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (352, 2, CAST(N'2021-01-15' AS Date), N'202101', N'Merenda', NULL, NULL, CAST(11.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (353, 2, CAST(N'2021-01-20' AS Date), N'202101', N'Merenda', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (354, 2, CAST(N'2021-01-21' AS Date), N'202101', N'Refrigerante', NULL, NULL, CAST(6.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (355, 2, CAST(N'2021-01-04' AS Date), N'202101', N'IOF', NULL, NULL, CAST(1.11 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (356, 2, CAST(N'2020-08-15' AS Date), N'202102', N'Iphone 7/12', NULL, NULL, CAST(258.33 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (357, 2, CAST(N'2020-12-18' AS Date), N'202102', N'Sofá 3/10', NULL, NULL, CAST(390.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (358, 2, CAST(N'2020-12-30' AS Date), N'202102', N'Josi + Kerlly = 370,45 (2/3) Josi 211,85', NULL, NULL, CAST(70.62 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (359, 2, CAST(N'2020-12-30' AS Date), N'202102', N'Josi + Kerlly = 370,45 (2/3) Kerlly 158,60', NULL, NULL, CAST(52.86 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (360, 2, CAST(N'2021-01-03' AS Date), N'202102', N'Ferragens Josi 2/2', NULL, NULL, CAST(175.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (361, 2, CAST(N'2021-01-04' AS Date), N'202102', N'Microfone 2/12', NULL, NULL, CAST(133.65 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (362, 2, CAST(N'2021-01-04' AS Date), N'202102', N'Fones + Power Click 2/12', NULL, NULL, CAST(160.25 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (363, 2, CAST(N'2021-01-09' AS Date), N'202102', N'Caixa Retorno igreja 2/10', NULL, NULL, CAST(126.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (364, 2, CAST(N'2021-01-25' AS Date), N'202102', N'Goma', NULL, NULL, CAST(7.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (365, 2, CAST(N'2021-01-25' AS Date), N'202102', N'Tablet 1/8', NULL, NULL, CAST(58.14 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (366, 2, CAST(N'2021-01-29' AS Date), N'202102', N'Geladeira + Bebedouro (Cinthia) 1/8', NULL, NULL, CAST(503.48 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (367, 2, CAST(N'2021-01-29' AS Date), N'202102', N'Purificador 1/8', NULL, NULL, CAST(45.29 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (368, 2, CAST(N'2021-02-01' AS Date), N'202102', N'Passagem Gustavo 1/6 (652,27)', NULL, NULL, CAST(108.72 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (369, 2, CAST(N'2021-02-01' AS Date), N'202102', N'Sanduíche', NULL, NULL, CAST(22.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (370, 2, CAST(N'2021-02-02' AS Date), N'202102', N'Churrasco', NULL, NULL, CAST(17.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (371, 2, CAST(N'2021-02-08' AS Date), N'202102', N'Produto p/ rosto (Kerllyane)', NULL, NULL, CAST(115.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (372, 2, CAST(N'2021-02-13' AS Date), N'202102', N'Compra', NULL, NULL, CAST(8.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (373, 2, CAST(N'2020-08-15' AS Date), N'202103', N'Iphone 8/12', NULL, NULL, CAST(258.33 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (374, 2, CAST(N'2020-12-18' AS Date), N'202103', N'Sofá 4/10', NULL, NULL, CAST(390.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (375, 2, CAST(N'2020-12-30' AS Date), N'202103', N'Josi + Kerlly = 370,45 (3/3) Josi 211,85', NULL, NULL, CAST(70.62 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (376, 2, CAST(N'2020-12-30' AS Date), N'202103', N'Josi + Kerlly = 370,45 (3/3) Kerlly 158,60', NULL, NULL, CAST(52.86 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (377, 2, CAST(N'2021-01-04' AS Date), N'202103', N'Microfone 3/12', NULL, NULL, CAST(133.65 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (378, 2, CAST(N'2021-01-04' AS Date), N'202103', N'Fones + Power Click 3/12', NULL, NULL, CAST(160.25 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (379, 2, CAST(N'2021-01-09' AS Date), N'202103', N'Caixa Retorno igreja 3/10', NULL, NULL, CAST(126.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (380, 2, CAST(N'2021-01-25' AS Date), N'202103', N'Tablet 2/8', NULL, NULL, CAST(58.11 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (381, 2, CAST(N'2021-01-29' AS Date), N'202103', N'Geladeira + Bebedouro (Cinthia) 2/8', NULL, NULL, CAST(503.48 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (382, 2, CAST(N'2021-01-29' AS Date), N'202103', N'Purificador 2/8', NULL, NULL, CAST(45.23 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (383, 2, CAST(N'2021-02-01' AS Date), N'202103', N'Passagem Gustavo 2/6 (652,27)', NULL, NULL, CAST(108.71 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (384, 2, CAST(N'2021-02-20' AS Date), N'202103', N'Consulta Davi', NULL, NULL, CAST(32.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (385, 2, CAST(N'2021-02-20' AS Date), N'202103', N'Frango assado', NULL, NULL, CAST(25.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (386, 2, CAST(N'2021-02-20' AS Date), N'202103', N'Compra frutas', NULL, NULL, CAST(25.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (387, 2, CAST(N'2021-02-21' AS Date), N'202103', N'Pizza', NULL, NULL, CAST(37.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (388, 2, CAST(N'2021-02-22' AS Date), N'202103', N'Minoxidil', NULL, NULL, CAST(218.41 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (389, 2, CAST(N'2021-02-22' AS Date), N'202103', N'Gás', NULL, NULL, CAST(95.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (390, 2, CAST(N'2021-02-23' AS Date), N'202103', N'Torneira', NULL, NULL, CAST(49.80 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (391, 2, CAST(N'2021-02-23' AS Date), N'202103', N'Material escolar Gustavo', NULL, NULL, CAST(31.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (392, 2, CAST(N'2021-02-25' AS Date), N'202103', N'Compras Paula', NULL, NULL, CAST(39.60 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (393, 2, CAST(N'2021-02-25' AS Date), N'202103', N'Cabos                                     122,00', NULL, NULL, CAST(62.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (394, 2, CAST(N'2021-02-25' AS Date), N'202103', N'Cabos Douglas + Thalles     122,00', NULL, NULL, CAST(60.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (395, 2, CAST(N'2021-02-25' AS Date), N'202103', N'Corte cabelo', NULL, NULL, CAST(21.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (396, 2, CAST(N'2021-02-27' AS Date), N'202103', N'Capa + Películas', NULL, NULL, CAST(75.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (397, 2, CAST(N'2021-02-28' AS Date), N'202103', N'Pizza', NULL, NULL, CAST(35.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (398, 2, CAST(N'2021-02-28' AS Date), N'202103', N'Refrigerante', NULL, NULL, CAST(6.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (399, 2, CAST(N'2021-03-04' AS Date), N'202103', N'Compra', NULL, NULL, CAST(8.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (400, 2, CAST(N'2021-03-06' AS Date), N'202103', N'Compra', NULL, NULL, CAST(6.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (401, 2, CAST(N'2021-03-12' AS Date), N'202103', N'Melissas', NULL, NULL, CAST(92.95 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (402, 2, CAST(N'2021-02-22' AS Date), N'202103', N'IOF', NULL, NULL, CAST(13.93 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (403, 2, CAST(N'2021-03-14' AS Date), N'202103', N'Compra', NULL, NULL, CAST(15.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (404, 2, CAST(N'2021-03-14' AS Date), N'202103', N'Nova Era ', NULL, NULL, CAST(165.38 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (405, 2, CAST(N'2021-03-15' AS Date), N'202103', N'Nova Era', NULL, NULL, CAST(29.01 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (406, 2, CAST(N'2021-03-15' AS Date), N'202103', N'Copo descartáveis ', NULL, NULL, CAST(3.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (407, 2, CAST(N'2020-08-15' AS Date), N'202104', N'Iphone 9/12', NULL, NULL, CAST(258.33 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (408, 2, CAST(N'2020-12-18' AS Date), N'202104', N'Sofá 5/10', NULL, NULL, CAST(390.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (409, 2, CAST(N'2021-01-04' AS Date), N'202104', N'Microfone 4/12', NULL, NULL, CAST(133.65 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (410, 2, CAST(N'2021-01-04' AS Date), N'202104', N'Fones + Power Click 4/12', NULL, NULL, CAST(160.25 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (411, 2, CAST(N'2021-01-09' AS Date), N'202104', N'Caixa Retorno igreja 4/10', NULL, NULL, CAST(126.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (412, 2, CAST(N'2021-01-25' AS Date), N'202104', N'Tablet 3/8', NULL, NULL, CAST(58.11 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (413, 2, CAST(N'2021-01-29' AS Date), N'202104', N'Geladeira + Bebedouro (Cinthia) 3/8', NULL, NULL, CAST(503.48 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (414, 2, CAST(N'2021-01-29' AS Date), N'202104', N'Purificador 3/8', NULL, NULL, CAST(45.23 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (415, 2, CAST(N'2021-02-01' AS Date), N'202104', N'Passagem Gustavo 3/6 (652,27)', NULL, NULL, CAST(108.71 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (416, 2, CAST(N'2021-03-22' AS Date), N'202104', N'Venda teste', NULL, NULL, CAST(1.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (417, 2, CAST(N'2021-03-23' AS Date), N'202104', N'Compra', NULL, NULL, CAST(7.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (418, 2, CAST(N'2021-03-23' AS Date), N'202104', N'Passagem Johnny                1/6 (788,86)', NULL, NULL, CAST(161.56 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (419, 2, CAST(N'2021-03-23' AS Date), N'202104', N'Passagem Kerllyane           1/6 (533,90)', NULL, NULL, CAST(89.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (420, 2, CAST(N'2021-03-23' AS Date), N'202104', N'Passagem Davi e Isabella 1/6 (929,10)', NULL, NULL, CAST(154.85 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (421, 2, CAST(N'2021-03-23' AS Date), N'202104', N'Passagem Gustavo              1/6 (669,00)', NULL, NULL, CAST(111.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (422, 2, CAST(N'2021-03-23' AS Date), N'202104', N'Nova Era', NULL, NULL, CAST(327.32 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (423, 2, CAST(N'2021-03-24' AS Date), N'202104', N'Pastel', NULL, NULL, CAST(29.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (424, 2, CAST(N'2021-03-26' AS Date), N'202104', N'Compras ', NULL, NULL, CAST(12.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (425, 2, CAST(N'2021-03-27' AS Date), N'202104', N'Farmácia ', NULL, NULL, CAST(39.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (426, 2, CAST(N'2021-03-30' AS Date), N'202104', N'Fones KZ Karol 1/6', NULL, NULL, CAST(11.50 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (427, 2, CAST(N'2021-03-30' AS Date), N'202104', N'Fones KZ Douglas-Thalles 1/6', NULL, NULL, CAST(23.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (428, 2, CAST(N'2021-03-30' AS Date), N'202104', N'Fones KZ 1/6', NULL, NULL, CAST(23.85 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (429, 2, CAST(N'2021-04-02' AS Date), N'202104', N'Compras ', NULL, NULL, CAST(12.20 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (430, 2, CAST(N'2021-04-02' AS Date), N'202104', N'Compras ', NULL, NULL, CAST(22.10 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (431, 2, CAST(N'2021-04-02' AS Date), N'202104', N'Sorvetes', NULL, NULL, CAST(12.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (432, 2, CAST(N'2021-04-03' AS Date), N'202104', N'Cinthia (Led)', NULL, NULL, CAST(180.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (433, 2, CAST(N'2021-04-03' AS Date), N'202104', N'Douglas', NULL, NULL, CAST(28.20 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (434, 2, CAST(N'2021-04-05' AS Date), N'202104', N'Ceramica Cinthia 1/2', NULL, NULL, CAST(200.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (435, 2, CAST(N'2021-04-06' AS Date), N'202104', N'Roupas Davi e Bellinha 1/2', NULL, NULL, CAST(181.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (436, 2, CAST(N'2021-04-06' AS Date), N'202104', N'Vestido Kerllyane', NULL, NULL, CAST(92.60 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (437, 2, CAST(N'2021-04-06' AS Date), N'202104', N'Camila ', NULL, NULL, CAST(15.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (438, 2, CAST(N'2021-04-06' AS Date), N'202104', N'Camila ', NULL, NULL, CAST(18.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (439, 2, CAST(N'2021-04-10' AS Date), N'202104', N'C&A Josi 1/3', NULL, NULL, CAST(64.32 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (440, 2, CAST(N'2021-04-13' AS Date), N'202104', N'Sobrancelha', NULL, NULL, CAST(31.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (441, 2, CAST(N'2021-04-14' AS Date), N'202104', N'Kamabras 1/3', NULL, NULL, CAST(32.01 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (442, 2, CAST(N'2021-04-14' AS Date), N'202104', N'Riachuelo 1/3', NULL, NULL, CAST(26.60 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (443, 2, CAST(N'2021-04-14' AS Date), N'202104', N'C&A 1/2', NULL, NULL, CAST(29.49 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (444, 2, CAST(N'2021-04-14' AS Date), N'202104', N'Capinha Risomar', NULL, NULL, CAST(25.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (445, 2, CAST(N'2021-04-14' AS Date), N'202104', N'Compras Paula 1/2', NULL, NULL, CAST(54.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (446, 2, CAST(N'2021-04-14' AS Date), N'202104', N'Compra Kerllyane', NULL, NULL, CAST(8.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (447, 2, CAST(N'2021-04-16' AS Date), N'202104', N'Baratão da Carne Johanes 1/2', NULL, NULL, CAST(79.97 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (448, 2, CAST(N'2021-04-16' AS Date), N'202104', N'Baratão da Carne 1/3', NULL, NULL, CAST(261.89 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (449, 2, CAST(N'2021-04-16' AS Date), N'202104', N'Compra', NULL, NULL, CAST(5.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (450, 2, CAST(N'2021-04-16' AS Date), N'202104', N'Remédio Verruga', NULL, NULL, CAST(15.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (451, 2, CAST(N'2021-04-18' AS Date), N'202104', N'Compra', NULL, NULL, CAST(7.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (452, 2, CAST(N'2020-08-15' AS Date), N'202105', N'Iphone 10/12', NULL, NULL, CAST(258.33 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (453, 2, CAST(N'2020-12-18' AS Date), N'202105', N'Sofá 6/10', NULL, NULL, CAST(390.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (454, 2, CAST(N'2021-01-04' AS Date), N'202105', N'Microfone 5/12', NULL, NULL, CAST(133.65 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (455, 2, CAST(N'2021-01-04' AS Date), N'202105', N'Fones + Power Click 5/12', NULL, NULL, CAST(160.25 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (456, 2, CAST(N'2021-01-09' AS Date), N'202105', N'Caixa Retorno igreja 5/10', NULL, NULL, CAST(126.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (457, 2, CAST(N'2021-01-25' AS Date), N'202105', N'Tablet 4/8', NULL, NULL, CAST(58.11 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (458, 2, CAST(N'2021-01-29' AS Date), N'202105', N'Geladeira + Bebedouro (Cinthia) 4/8', NULL, NULL, CAST(503.48 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (459, 2, CAST(N'2021-01-29' AS Date), N'202105', N'Purificador 4/8', NULL, NULL, CAST(45.23 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (460, 2, CAST(N'2021-02-01' AS Date), N'202105', N'Passagem Gustavo 4/6 (652,27)', NULL, NULL, CAST(108.71 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (461, 2, CAST(N'2021-03-23' AS Date), N'202105', N'Passagem Johnny                2/6 (788,86)', NULL, NULL, CAST(125.46 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (462, 2, CAST(N'2021-03-23' AS Date), N'202105', N'Passagem Kerllyane           2/6 (533,90)', NULL, NULL, CAST(88.98 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (463, 2, CAST(N'2021-03-23' AS Date), N'202105', N'Passagem Davi e Isabella 2/6 (929,10)', NULL, NULL, CAST(154.85 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (464, 2, CAST(N'2021-03-23' AS Date), N'202105', N'Passagem Gustavo              2/6 (669,00)', NULL, NULL, CAST(111.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (465, 2, CAST(N'2021-03-30' AS Date), N'202105', N'Fones KZ Douglas-Thalles 2/6', NULL, NULL, CAST(34.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (466, 2, CAST(N'2021-03-30' AS Date), N'202105', N'Fones KZ 2/6', NULL, NULL, CAST(23.83 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (467, 2, CAST(N'2021-04-05' AS Date), N'202105', N'Ceramica Cinthia 2/2', NULL, NULL, CAST(200.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (468, 2, CAST(N'2021-04-06' AS Date), N'202105', N'Roupas Davi e Bellinha 2/2', NULL, NULL, CAST(181.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (469, 2, CAST(N'2021-04-10' AS Date), N'202105', N'C&A Josi 2/3', NULL, NULL, CAST(64.30 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (470, 2, CAST(N'2021-04-14' AS Date), N'202105', N'Kamabras 2/3', NULL, NULL, CAST(31.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (471, 2, CAST(N'2021-04-14' AS Date), N'202105', N'Riachuelo 2/3', NULL, NULL, CAST(26.60 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (472, 2, CAST(N'2021-04-14' AS Date), N'202105', N'C&A 2/2', NULL, NULL, CAST(29.49 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (473, 2, CAST(N'2021-04-14' AS Date), N'202105', N'Compras Paula 2/2', NULL, NULL, CAST(54.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (474, 2, CAST(N'2021-04-16' AS Date), N'202105', N'Baratão da Carne Johanes 2/2', NULL, NULL, CAST(79.96 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (475, 2, CAST(N'2021-04-16' AS Date), N'202105', N'Baratão da Carne 2/3', NULL, NULL, CAST(261.88 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (476, 2, CAST(N'2021-04-27' AS Date), N'202105', N'Tratamento dentário 1/4', NULL, NULL, CAST(100.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (477, 2, CAST(N'2021-04-29' AS Date), N'202105', N'Compra', NULL, NULL, CAST(8.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (478, 2, CAST(N'2021-05-02' AS Date), N'202105', N'Churrasco', NULL, NULL, CAST(13.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (479, 2, CAST(N'2021-05-02' AS Date), N'202105', N'Drogaria Ágape (Lábrea)', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (480, 2, CAST(N'2021-05-03' AS Date), N'202105', N'Compra (Lábrea)', NULL, NULL, CAST(152.83 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (481, 2, CAST(N'2021-05-06' AS Date), N'202105', N'Drogaria Lucia', NULL, NULL, CAST(25.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (482, 2, CAST(N'2021-05-09' AS Date), N'202105', N'Bagagem 1/2', NULL, NULL, CAST(50.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (483, 2, CAST(N'2021-05-08' AS Date), N'202105', N'Pedido Nega', NULL, NULL, CAST(558.98 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (484, 2, CAST(N'2021-05-08' AS Date), N'202105', N'Paraná', NULL, NULL, CAST(28.85 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (485, 2, CAST(N'2021-05-13' AS Date), N'202105', N'Paraná', NULL, NULL, CAST(14.40 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (486, 2, CAST(N'2021-05-14' AS Date), N'202105', N'Carne', NULL, NULL, CAST(12.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (487, 2, CAST(N'2021-05-15' AS Date), N'202105', N'Canaã', NULL, NULL, CAST(373.48 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (488, 2, CAST(N'2021-05-18' AS Date), N'202105', N'Canaã', NULL, NULL, CAST(19.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (489, 2, CAST(N'2021-05-19' AS Date), N'202105', N'Atacarejo', NULL, NULL, CAST(26.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (490, 2, CAST(N'2021-05-19' AS Date), N'202105', N'Drogaria Lucia', NULL, NULL, CAST(12.25 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (491, 2, CAST(N'2021-05-20' AS Date), N'202105', N'Claro Flex', NULL, NULL, CAST(39.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (492, 2, CAST(N'2021-05-20' AS Date), N'202105', N'Churrasco', NULL, NULL, CAST(12.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (493, 2, CAST(N'2020-08-15' AS Date), N'202106', N'Iphone 11/12', NULL, NULL, CAST(258.33 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (494, 2, CAST(N'2020-12-18' AS Date), N'202106', N'Sofá 7/10', NULL, NULL, CAST(390.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (495, 2, CAST(N'2021-01-04' AS Date), N'202106', N'Microfone 6/12', NULL, NULL, CAST(133.65 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (496, 2, CAST(N'2021-01-04' AS Date), N'202106', N'Fones + Power Click 6/12', NULL, NULL, CAST(160.25 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (497, 2, CAST(N'2021-01-09' AS Date), N'202106', N'Caixa Retorno igreja 6/10', NULL, NULL, CAST(126.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (498, 2, CAST(N'2021-01-25' AS Date), N'202106', N'Tablet 5/8', NULL, NULL, CAST(58.11 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (499, 2, CAST(N'2021-01-29' AS Date), N'202106', N'Geladeira + Bebedouro (Cinthia) 5/8', NULL, NULL, CAST(503.48 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (500, 2, CAST(N'2021-01-29' AS Date), N'202106', N'Purificador 5/8', NULL, NULL, CAST(45.23 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (501, 2, CAST(N'2021-02-01' AS Date), N'202106', N'Passagem Gustavo 5/6 (652,27)', NULL, NULL, CAST(108.71 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (502, 2, CAST(N'2021-03-23' AS Date), N'202106', N'Passagem Johnny                3/6 (788,86)', NULL, NULL, CAST(125.46 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (503, 2, CAST(N'2021-03-23' AS Date), N'202106', N'Passagem Kerllyane           3/6 (533,90)', NULL, NULL, CAST(88.98 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (504, 2, CAST(N'2021-03-23' AS Date), N'202106', N'Passagem Davi e Isabella 3/6 (929,10)', NULL, NULL, CAST(154.85 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (505, 2, CAST(N'2021-03-23' AS Date), N'202106', N'Passagem Gustavo              3/6 (669,00)', NULL, NULL, CAST(111.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (506, 2, CAST(N'2021-03-30' AS Date), N'202106', N'Fones KZ Douglas-Thalles 3/6', NULL, NULL, CAST(34.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (507, 2, CAST(N'2021-03-30' AS Date), N'202106', N'Fones KZ 3/6', NULL, NULL, CAST(23.83 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (508, 2, CAST(N'2021-04-10' AS Date), N'202106', N'C&A Josi 3/3', NULL, NULL, CAST(64.30 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (509, 2, CAST(N'2021-04-14' AS Date), N'202106', N'Kamabras 3/3', NULL, NULL, CAST(31.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (510, 2, CAST(N'2021-04-14' AS Date), N'202106', N'Riachuelo 3/3', NULL, NULL, CAST(26.60 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (511, 2, CAST(N'2021-04-16' AS Date), N'202106', N'Baratão da Carne 3/3', NULL, NULL, CAST(261.88 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (512, 2, CAST(N'2021-04-27' AS Date), N'202106', N'Tratamento dentário 2/4', NULL, NULL, CAST(100.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (513, 2, CAST(N'2021-05-09' AS Date), N'202106', N'Bagagem 2/2', NULL, NULL, CAST(50.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (514, 2, CAST(N'2021-05-21' AS Date), N'202106', N'Paraná', NULL, NULL, CAST(16.97 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (515, 2, CAST(N'2021-05-21' AS Date), N'202106', N'Paraná', NULL, NULL, CAST(74.70 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (516, 2, CAST(N'2021-05-24' AS Date), N'202106', N'Carne', NULL, NULL, CAST(40.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (517, 2, CAST(N'2021-05-24' AS Date), N'202106', N'Paraná', NULL, NULL, CAST(277.40 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (518, 2, CAST(N'2021-05-24' AS Date), N'202106', N'Vivo Easy', NULL, NULL, CAST(39.99 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (519, 2, CAST(N'2021-05-24' AS Date), N'202106', N'Giovani Baixo 1/10', NULL, NULL, CAST(314.82 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (520, 2, CAST(N'2021-05-27' AS Date), N'202106', N'Netflix', NULL, NULL, CAST(29.45 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (521, 2, CAST(N'2021-05-27' AS Date), N'202106', N'Netflix Paim', NULL, NULL, CAST(16.45 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (522, 2, CAST(N'2021-05-30' AS Date), N'202106', N'Paraná', NULL, NULL, CAST(66.67 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (523, 2, CAST(N'2021-06-01' AS Date), N'202106', N'YouTube Premium', NULL, NULL, CAST(20.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (524, 2, CAST(N'2021-06-02' AS Date), N'202106', N'Drogaria Lucia', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (525, 2, CAST(N'2021-06-02' AS Date), N'202106', N'Paraná', NULL, NULL, CAST(103.63 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (526, 2, CAST(N'2021-06-05' AS Date), N'202106', N'Paraná', NULL, NULL, CAST(23.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (527, 2, CAST(N'2021-06-07' AS Date), N'202106', N'Passagens ônibus 1/2', NULL, NULL, CAST(465.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (528, 2, CAST(N'2021-06-07' AS Date), N'202106', N'Passagem Kerllyane 1/2', NULL, NULL, CAST(400.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (529, 2, CAST(N'2021-06-08' AS Date), N'202106', N'São Francisco', NULL, NULL, CAST(16.74 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (530, 2, CAST(N'2021-06-08' AS Date), N'202106', N'Paraná', NULL, NULL, CAST(25.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (531, 2, CAST(N'2021-06-08' AS Date), N'202106', N'Churrasco', NULL, NULL, CAST(34.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (532, 2, CAST(N'2021-06-08' AS Date), N'202106', N'Google', NULL, NULL, CAST(9.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (533, 2, CAST(N'2021-06-08' AS Date), N'202106', N'Paraná', NULL, NULL, CAST(23.11 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (534, 2, CAST(N'2021-06-10' AS Date), N'202106', N'Almoço', NULL, NULL, CAST(41.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (535, 2, CAST(N'2021-06-10' AS Date), N'202106', N'Pastel', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (536, 2, CAST(N'2021-06-10' AS Date), N'202106', N'Refrigerante', NULL, NULL, CAST(5.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (537, 2, CAST(N'2021-06-10' AS Date), N'202106', N'Disney Plus', NULL, NULL, CAST(27.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (538, 2, CAST(N'2021-06-11' AS Date), N'202106', N'Farmácia', NULL, NULL, CAST(14.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (539, 2, CAST(N'2021-06-12' AS Date), N'202106', N'Nova Era', NULL, NULL, CAST(93.26 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (540, 2, CAST(N'2021-06-14' AS Date), N'202106', N'Drogaria Agape', NULL, NULL, CAST(25.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (541, 2, CAST(N'2021-06-16' AS Date), N'202106', N'Baratão da Carne', NULL, NULL, CAST(49.06 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (542, 2, CAST(N'2021-06-19' AS Date), N'202106', N'Claro flex internet adicional', NULL, NULL, CAST(14.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (543, 2, CAST(N'2021-06-20' AS Date), N'202106', N'Nova Era', NULL, NULL, CAST(82.98 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (544, 2, CAST(N'2021-06-15' AS Date), N'202106', N'Compra em Lábrea', NULL, NULL, CAST(54.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (545, 2, CAST(N'2020-08-15' AS Date), N'202107', N'Iphone 12/12', NULL, NULL, CAST(258.33 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (546, 2, CAST(N'2020-12-18' AS Date), N'202107', N'Sofá 8/10', NULL, NULL, CAST(390.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (547, 2, CAST(N'2021-01-04' AS Date), N'202107', N'Microfone 7/12', NULL, NULL, CAST(133.65 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (548, 2, CAST(N'2021-01-04' AS Date), N'202107', N'Fones + Power Click 7/12', NULL, NULL, CAST(160.25 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (549, 2, CAST(N'2021-01-09' AS Date), N'202107', N'Caixa Retorno igreja 7/10', NULL, NULL, CAST(126.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (550, 2, CAST(N'2021-01-25' AS Date), N'202107', N'Tablet 6/8', NULL, NULL, CAST(58.11 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (551, 2, CAST(N'2021-01-29' AS Date), N'202107', N'Geladeira + Bebedouro (Cinthia) 6/8', NULL, NULL, CAST(503.48 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (552, 2, CAST(N'2021-01-29' AS Date), N'202107', N'Purificador 6/8', NULL, NULL, CAST(45.23 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (553, 2, CAST(N'2021-02-01' AS Date), N'202107', N'Passagem Gustavo 6/6 (652,27)', NULL, NULL, CAST(108.71 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (554, 2, CAST(N'2021-03-23' AS Date), N'202107', N'Passagem Johnny                4/6 (788,86)', NULL, NULL, CAST(125.46 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (555, 2, CAST(N'2021-03-23' AS Date), N'202107', N'Passagem Kerllyane           4/6 (533,90)', NULL, NULL, CAST(88.98 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (556, 2, CAST(N'2021-03-23' AS Date), N'202107', N'Passagem Davi e Isabella 4/6 (929,10)', NULL, NULL, CAST(154.85 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (557, 2, CAST(N'2021-03-23' AS Date), N'202107', N'Passagem Gustavo              4/6 (669,00)', NULL, NULL, CAST(111.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (558, 2, CAST(N'2021-03-30' AS Date), N'202107', N'Fones KZ Douglas-Thalles 4/6', NULL, NULL, CAST(34.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (559, 2, CAST(N'2021-03-30' AS Date), N'202107', N'Fones KZ 4/6', NULL, NULL, CAST(23.83 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (560, 2, CAST(N'2021-04-27' AS Date), N'202107', N'Tratamento dentário 3/4', NULL, NULL, CAST(100.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (561, 2, CAST(N'2021-05-24' AS Date), N'202107', N'Giovani Baixo 2/10', NULL, NULL, CAST(314.79 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (562, 2, CAST(N'2021-06-07' AS Date), N'202107', N'Passagem Kerllyane 2/2', NULL, NULL, CAST(399.99 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (563, 2, CAST(N'2021-06-07' AS Date), N'202107', N'Passagens ônibus 2/2', NULL, NULL, CAST(465.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (564, 2, CAST(N'2021-06-20' AS Date), N'202107', N'Claro', NULL, NULL, CAST(39.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (565, 2, CAST(N'2021-06-21' AS Date), N'202107', N'Ana', NULL, NULL, CAST(22.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (566, 2, CAST(N'2021-06-22' AS Date), N'202107', N'Baratão da Carne', NULL, NULL, CAST(594.03 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (567, 2, CAST(N'2021-06-22' AS Date), N'202107', N'Estacionamento', NULL, NULL, CAST(8.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (568, 2, CAST(N'2021-06-22' AS Date), N'202107', N'Gasolina', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (569, 2, CAST(N'2021-06-23' AS Date), N'202107', N'Gasolina', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (570, 2, CAST(N'2021-06-23' AS Date), N'202107', N'Entrada Carro 1/2', NULL, NULL, CAST(5500.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (571, 2, CAST(N'2021-06-24' AS Date), N'202107', N'Aliexpress 1/2', NULL, NULL, CAST(184.08 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (572, 2, CAST(N'2021-06-24' AS Date), N'202107', N'Vivo Easy', NULL, NULL, CAST(39.99 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (573, 2, CAST(N'2021-06-27' AS Date), N'202107', N'Netflix', NULL, NULL, CAST(29.45 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (574, 2, CAST(N'2021-06-27' AS Date), N'202107', N'Netflix Paim', NULL, NULL, CAST(16.45 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (575, 2, CAST(N'2021-07-09' AS Date), N'202107', N'Disney Plus', NULL, NULL, CAST(27.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (576, 2, CAST(N'2021-07-08' AS Date), N'202107', N'Google', NULL, NULL, CAST(9.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (577, 2, CAST(N'2021-06-26' AS Date), N'202107', N'Mirica', NULL, NULL, CAST(85.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (578, 2, CAST(N'2021-06-26' AS Date), N'202107', N'Vestido Kerllyane 1/2', NULL, NULL, CAST(60.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (579, 2, CAST(N'2021-06-26' AS Date), N'202107', N'Nega (Descontado Kerllyane)', NULL, NULL, CAST(52.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (580, 2, CAST(N'2021-06-26' AS Date), N'202107', N'Nega (Descontado Kerllyane)', NULL, NULL, CAST(2.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (581, 2, CAST(N'2021-06-26' AS Date), N'202107', N'Nega', NULL, NULL, CAST(18.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (582, 2, CAST(N'2021-06-27' AS Date), N'202107', N'Josi - Comepi 1/3', NULL, NULL, CAST(111.41 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (583, 2, CAST(N'2021-06-28' AS Date), N'202107', N'Compra', NULL, NULL, CAST(5.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (584, 2, CAST(N'2021-06-29' AS Date), N'202107', N'Estorno Aliexpress', NULL, NULL, CAST(-37.43 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (585, 2, CAST(N'2021-07-01' AS Date), N'202107', N'YouTube Premium', NULL, NULL, CAST(20.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (586, 2, CAST(N'2021-07-01' AS Date), N'202107', N'Nova Era', NULL, NULL, CAST(104.59 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (587, 2, CAST(N'2021-07-02' AS Date), N'202107', N'Aliexpress 1/2 (Fone Gustavo)', NULL, NULL, CAST(40.87 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (588, 2, CAST(N'2021-07-03' AS Date), N'202107', N'Kamabras 1/6', NULL, NULL, CAST(40.18 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (589, 2, CAST(N'2021-07-03' AS Date), N'202107', N'Compra', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (590, 2, CAST(N'2021-07-03' AS Date), N'202107', N'Nega (Tropical  1/2)', NULL, NULL, CAST(80.80 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (591, 2, CAST(N'2021-07-03' AS Date), N'202107', N'Mochila Davi 1/5', NULL, NULL, CAST(52.98 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (592, 2, CAST(N'2021-07-03' AS Date), N'202107', N'Compra', NULL, NULL, CAST(44.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (593, 2, CAST(N'2021-07-03' AS Date), N'202107', N'Compra', NULL, NULL, CAST(43.80 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (594, 2, CAST(N'2021-07-04' AS Date), N'202107', N'Bolo', NULL, NULL, CAST(22.60 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (595, 2, CAST(N'2021-07-04' AS Date), N'202107', N'Pizza', NULL, NULL, CAST(37.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (596, 2, CAST(N'2021-07-05' AS Date), N'202107', N'Nova Era', NULL, NULL, CAST(61.09 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (597, 2, CAST(N'2021-07-05' AS Date), N'202107', N'Drogaria', NULL, NULL, CAST(33.88 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (598, 2, CAST(N'2021-07-08' AS Date), N'202107', N'Compra', NULL, NULL, CAST(10.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (599, 2, CAST(N'2021-08-07' AS Date), N'202107', N'Josi - Fuga de Lula 1/4', NULL, NULL, CAST(467.75 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (600, 2, CAST(N'2021-08-07' AS Date), N'202107', N'Tenis Kerllyane 1/4', NULL, NULL, CAST(32.25 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (601, 2, CAST(N'2021-07-08' AS Date), N'202107', N'Compra Agnes 1/2', NULL, NULL, CAST(34.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (602, 2, CAST(N'2021-07-08' AS Date), N'202107', N'Nova Era', NULL, NULL, CAST(166.77 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (603, 2, CAST(N'2021-07-12' AS Date), N'202107', N'Compra', NULL, NULL, CAST(27.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (604, 2, CAST(N'2021-07-13' AS Date), N'202107', N'Nova Era', NULL, NULL, CAST(103.71 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (605, 2, CAST(N'2021-07-15' AS Date), N'202107', N'Nega - Shop do Pé 1/2', NULL, NULL, CAST(69.90 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (606, 2, CAST(N'2021-07-15' AS Date), N'202107', N'Kerllyane - Shop do Pé 1/2', NULL, NULL, CAST(34.95 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (607, 2, CAST(N'2021-07-15' AS Date), N'202107', N'Compra', NULL, NULL, CAST(10.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (608, 2, CAST(N'2021-07-19' AS Date), N'202107', N'Gás', NULL, NULL, CAST(100.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (609, 2, CAST(N'2021-07-20' AS Date), N'202107', N'Claro', NULL, NULL, CAST(39.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (610, 2, CAST(N'2020-12-18' AS Date), N'202108', N'Sofá 9/10', NULL, NULL, CAST(390.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (611, 2, CAST(N'2021-01-04' AS Date), N'202108', N'Microfone 8/12', NULL, NULL, CAST(133.65 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (612, 2, CAST(N'2021-01-04' AS Date), N'202108', N'Fones + Power Click 8/12', NULL, NULL, CAST(160.25 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (613, 2, CAST(N'2021-01-09' AS Date), N'202108', N'Caixa Retorno igreja 8/10', NULL, NULL, CAST(126.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (614, 2, CAST(N'2021-01-25' AS Date), N'202108', N'Tablet 7/8', NULL, NULL, CAST(58.11 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (615, 2, CAST(N'2021-01-29' AS Date), N'202108', N'Purificador 7/8', NULL, NULL, CAST(45.23 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (616, 2, CAST(N'2021-01-29' AS Date), N'202108', N'Geladeira + Bebedouro (Cinthia) 7/8', NULL, NULL, CAST(503.48 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (617, 2, CAST(N'2021-03-23' AS Date), N'202108', N'Passagem Kerllyane           5/6 (533,90)', NULL, NULL, CAST(88.98 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (618, 2, CAST(N'2021-03-23' AS Date), N'202108', N'Passagem Gustavo              5/6 (669,00)', NULL, NULL, CAST(111.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (619, 2, CAST(N'2021-03-23' AS Date), N'202108', N'Passagem Johnny                5/6 (788,86)', NULL, NULL, CAST(125.46 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (620, 2, CAST(N'2021-03-23' AS Date), N'202108', N'Passagem Davi e Isabella 5/6 (929,10)', NULL, NULL, CAST(154.85 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (621, 2, CAST(N'2021-03-30' AS Date), N'202108', N'Fones KZ 5/6', NULL, NULL, CAST(23.83 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (622, 2, CAST(N'2021-03-30' AS Date), N'202108', N'Fones KZ Douglas-Karol-Thalles 5/6', NULL, NULL, CAST(34.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (623, 2, CAST(N'2021-04-27' AS Date), N'202108', N'Tratamento dentário 4/4', NULL, NULL, CAST(100.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (624, 2, CAST(N'2021-05-24' AS Date), N'202108', N'Giovani Baixo 3/10', NULL, NULL, CAST(314.79 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (625, 2, CAST(N'2021-05-27' AS Date), N'202108', N'Netflix Paim', NULL, NULL, CAST(16.45 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (626, 2, CAST(N'2021-06-23' AS Date), N'202108', N'Entrada Carro 2/2', NULL, NULL, CAST(5500.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (627, 2, CAST(N'2021-06-24' AS Date), N'202108', N'Aliexpress 2/2', NULL, NULL, CAST(184.08 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (628, 2, CAST(N'2021-06-26' AS Date), N'202108', N'Vestido Kerllyane 2/2', NULL, NULL, CAST(60.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (629, 2, CAST(N'2021-06-27' AS Date), N'202108', N'Josi - Comepi 2/3', NULL, NULL, CAST(111.41 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (630, 2, CAST(N'2021-06-29' AS Date), N'202108', N'Reembolso Aliexpress', NULL, NULL, CAST(-37.44 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (631, 2, CAST(N'2021-07-02' AS Date), N'202108', N'Aliexpress 1/2 (Fone Gustavo)', NULL, NULL, CAST(40.87 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (632, 2, CAST(N'2021-07-03' AS Date), N'202108', N'Kamabras 2/6', NULL, NULL, CAST(40.16 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (633, 2, CAST(N'2021-07-03' AS Date), N'202108', N'Mochila Davi 2/5', NULL, NULL, CAST(52.98 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (634, 2, CAST(N'2021-07-03' AS Date), N'202108', N'Nega (Tropical  2/2)', NULL, NULL, CAST(80.80 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (635, 2, CAST(N'2021-07-08' AS Date), N'202108', N'Compra Agnes 2/2', NULL, NULL, CAST(34.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (636, 2, CAST(N'2021-07-15' AS Date), N'202108', N'Kerllyane - Shop do Pé 2/2', NULL, NULL, CAST(34.95 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (637, 2, CAST(N'2021-07-15' AS Date), N'202108', N'Nega - Shop do Pé 2/2', NULL, NULL, CAST(69.90 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (638, 2, CAST(N'2021-07-22' AS Date), N'202108', N'Baratão da Carne', NULL, NULL, CAST(18.39 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (639, 2, CAST(N'2021-07-23' AS Date), N'202108', N'Bemol Farma', NULL, NULL, CAST(18.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (640, 2, CAST(N'2021-07-23' AS Date), N'202108', N'Corte cabelo', NULL, NULL, CAST(40.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (641, 2, CAST(N'2021-07-23' AS Date), N'202108', N'Lavagem do carro', NULL, NULL, CAST(45.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (642, 2, CAST(N'2021-07-23' AS Date), N'202108', N'Tropical Multiloja (Thania) 1/2', NULL, NULL, CAST(77.70 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (643, 2, CAST(N'2021-07-23' AS Date), N'202108', N'Mercado livre 1/4', NULL, NULL, CAST(84.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (644, 2, CAST(N'2021-07-23' AS Date), N'202108', N'Mercado livre 1/4', NULL, NULL, CAST(143.91 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (645, 2, CAST(N'2021-07-23' AS Date), N'202108', N'Baratão da Carne', NULL, NULL, CAST(411.81 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (646, 2, CAST(N'2021-07-24' AS Date), N'202108', N'Sorvete', NULL, NULL, CAST(8.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (647, 2, CAST(N'2021-07-24' AS Date), N'202108', N'Meias Davi', NULL, NULL, CAST(15.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (648, 2, CAST(N'2021-07-24' AS Date), N'202108', N'Tênis Davi', NULL, NULL, CAST(23.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (649, 2, CAST(N'2021-07-24' AS Date), N'202108', N'Tropical 1/2', NULL, NULL, CAST(24.80 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (650, 2, CAST(N'2021-07-24' AS Date), N'202108', N'Vivo Easy', NULL, NULL, CAST(39.99 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (651, 2, CAST(N'2021-07-27' AS Date), N'202108', N'Netflix', NULL, NULL, CAST(29.45 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (652, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Estorno Google', NULL, NULL, CAST(-1.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (653, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Google (compra não realizada por mim)', NULL, NULL, CAST(1.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (654, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Google (compra não realizada por mim)', NULL, NULL, CAST(1.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (655, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Google (compra não realizada por mim)', NULL, NULL, CAST(1.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (656, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Google (compra não realizada por mim)', NULL, NULL, CAST(1.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (657, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Google (compra não realizada por mim)', NULL, NULL, CAST(2.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (658, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Google (compra não realizada por mim)', NULL, NULL, CAST(3.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (659, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Google (compra não realizada por mim)', NULL, NULL, CAST(3.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (660, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Google (compra não realizada por mim)', NULL, NULL, CAST(3.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (661, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Google (compra não realizada por mim)', NULL, NULL, CAST(3.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (662, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Google (compra não realizada por mim)', NULL, NULL, CAST(3.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (663, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Refrigerante', NULL, NULL, CAST(5.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (664, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Google (compra não realizada por mim)', NULL, NULL, CAST(5.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (665, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Google (compra não realizada por mim)', NULL, NULL, CAST(7.56 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (666, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Estorno Google', NULL, NULL, CAST(-7.56 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (667, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Estorno Google', NULL, NULL, CAST(-1.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (668, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Estorno Google', NULL, NULL, CAST(-1.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (669, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Estorno Google', NULL, NULL, CAST(-1.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (670, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Estorno Google', NULL, NULL, CAST(-3.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (671, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Estorno Google', NULL, NULL, CAST(-3.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (672, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Estorno Google', NULL, NULL, CAST(-3.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (673, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Estorno Google', NULL, NULL, CAST(-3.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (674, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Estorno Google', NULL, NULL, CAST(-5.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (675, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Estorno Google', NULL, NULL, CAST(-2.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (676, 2, CAST(N'2021-08-01' AS Date), N'202108', N'Estorno Google', NULL, NULL, CAST(-3.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (677, 2, CAST(N'2021-08-07' AS Date), N'202108', N'Tenis Kerllyane 2/4', NULL, NULL, CAST(32.25 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (678, 2, CAST(N'2021-08-07' AS Date), N'202108', N'Josi - Fuga de Lula 2/4', NULL, NULL, CAST(467.75 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (679, 2, CAST(N'2020-12-18' AS Date), N'202109', N'Sofá 10/10', NULL, NULL, CAST(390.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (680, 2, CAST(N'2021-01-04' AS Date), N'202109', N'Microfone 9/12', NULL, NULL, CAST(133.65 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (681, 2, CAST(N'2021-01-04' AS Date), N'202109', N'Fones + Power Click 9/12', NULL, NULL, CAST(160.25 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (682, 2, CAST(N'2021-01-09' AS Date), N'202109', N'Caixa Retorno igreja 9/10', NULL, NULL, CAST(126.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (683, 2, CAST(N'2021-01-25' AS Date), N'202109', N'Tablet 8/8', NULL, NULL, CAST(58.11 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (684, 2, CAST(N'2021-01-29' AS Date), N'202109', N'Geladeira + Bebedouro (Cinthia) 8/8', NULL, NULL, CAST(503.48 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (685, 2, CAST(N'2021-01-29' AS Date), N'202109', N'Purificador 8/8', NULL, NULL, CAST(45.23 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (686, 2, CAST(N'2021-03-23' AS Date), N'202109', N'Passagem Johnny                6/6 (788,86)', NULL, NULL, CAST(125.46 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (687, 2, CAST(N'2021-03-23' AS Date), N'202109', N'Passagem Kerllyane           6/6 (533,90)', NULL, NULL, CAST(88.98 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (688, 2, CAST(N'2021-03-23' AS Date), N'202109', N'Passagem Davi e Isabella 6/6 (929,10)', NULL, NULL, CAST(154.85 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (689, 2, CAST(N'2021-03-23' AS Date), N'202109', N'Passagem Gustavo              6/6 (669,00)', NULL, NULL, CAST(111.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (690, 2, CAST(N'2021-03-30' AS Date), N'202109', N'Fones KZ Douglas-Thalles 6/6', NULL, NULL, CAST(34.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (691, 2, CAST(N'2021-03-30' AS Date), N'202109', N'Fones KZ 6/6', NULL, NULL, CAST(23.83 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (692, 2, CAST(N'2021-05-24' AS Date), N'202109', N'Giovani Baixo 4/10', NULL, NULL, CAST(314.79 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (693, 2, CAST(N'2021-08-27' AS Date), N'202109', N'Netflix', NULL, NULL, CAST(19.95 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (694, 2, CAST(N'2021-08-27' AS Date), N'202109', N'Netflix Paim', NULL, NULL, CAST(19.95 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (695, 2, CAST(N'2021-06-27' AS Date), N'202109', N'Josi - Comepi 3/3', NULL, NULL, CAST(111.41 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (696, 2, CAST(N'2021-07-03' AS Date), N'202109', N'Kamabras 3/6', NULL, NULL, CAST(40.16 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (697, 2, CAST(N'2021-07-03' AS Date), N'202109', N'Mochila Davi 3/5', NULL, NULL, CAST(52.98 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (698, 2, CAST(N'2021-08-07' AS Date), N'202109', N'Josi - Fuga de Lula 3/4', NULL, NULL, CAST(467.75 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (699, 2, CAST(N'2021-08-07' AS Date), N'202109', N'Tenis Kerllyane 3/4', NULL, NULL, CAST(32.25 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (700, 2, CAST(N'2021-07-23' AS Date), N'202109', N'Mercado livre 2/4', NULL, NULL, CAST(84.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (701, 2, CAST(N'2021-07-23' AS Date), N'202109', N'Mercado livre 2/4', NULL, NULL, CAST(143.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (702, 2, CAST(N'2021-07-24' AS Date), N'202109', N'Tropical 2/2', NULL, NULL, CAST(24.80 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (703, 2, CAST(N'2021-08-20' AS Date), N'202109', N'Álcool', NULL, NULL, CAST(50.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (704, 2, CAST(N'2021-08-21' AS Date), N'202109', N'Sacolas BF', NULL, NULL, CAST(30.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (705, 2, CAST(N'2021-08-21' AS Date), N'202109', N'Tropical Atacadao', NULL, NULL, CAST(56.80 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (706, 2, CAST(N'2021-08-21' AS Date), N'202109', N'Fuga de Lula 1/3 Josi ', NULL, NULL, CAST(197.34 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (707, 2, CAST(N'2021-08-21' AS Date), N'202109', N'Romanel 1/3 Josi (401,58) > 137,37', NULL, NULL, CAST(45.79 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (708, 2, CAST(N'2021-08-21' AS Date), N'202109', N'Romanel 1/3 Kerllyane (401,58) > 264,21', NULL, NULL, CAST(88.07 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (709, 2, CAST(N'2021-08-21' AS Date), N'202109', N'Camila 1/3', NULL, NULL, CAST(255.70 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (710, 2, CAST(N'2021-08-21' AS Date), N'202109', N'Baratao da Carne', NULL, NULL, CAST(681.44 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (711, 2, CAST(N'2021-08-22' AS Date), N'202109', N'Pizza', NULL, NULL, CAST(52.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (712, 2, CAST(N'2021-08-23' AS Date), N'202109', N'Bico mamadeira', NULL, NULL, CAST(25.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (713, 2, CAST(N'2021-08-23' AS Date), N'202109', N'Pastel', NULL, NULL, CAST(24.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (714, 2, CAST(N'2021-08-26' AS Date), N'202109', N'Cama Josi 1/10', NULL, NULL, CAST(253.48 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (715, 2, CAST(N'2021-08-27' AS Date), N'202109', N'Claro', NULL, NULL, CAST(39.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (716, 2, CAST(N'2021-08-28' AS Date), N'202109', N'Gas', NULL, NULL, CAST(100.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (717, 2, CAST(N'2021-08-28' AS Date), N'202109', N'Fuga de Lula Josi', NULL, NULL, CAST(130.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (718, 2, CAST(N'2021-08-28' AS Date), N'202109', N'Compra de 250,00 Josi 1/3', NULL, NULL, CAST(83.34 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (719, 2, CAST(N'2021-08-29' AS Date), N'202109', N'Linguiça', NULL, NULL, CAST(20.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (720, 2, CAST(N'2021-09-01' AS Date), N'202109', N'Estacionamento', NULL, NULL, CAST(8.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (721, 2, CAST(N'2021-09-01' AS Date), N'202109', N'Estacionamento', NULL, NULL, CAST(8.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (722, 2, CAST(N'2021-09-01' AS Date), N'202109', N'Drogaria', NULL, NULL, CAST(21.64 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (723, 2, CAST(N'2021-09-03' AS Date), N'202109', N'Chupeta', NULL, NULL, CAST(18.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (724, 2, CAST(N'2021-09-08' AS Date), N'202109', N'Nova Era', NULL, NULL, CAST(64.53 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (725, 2, CAST(N'2021-09-08' AS Date), N'202109', N'Nova Era Cintia', NULL, NULL, CAST(28.99 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (726, 2, CAST(N'2021-09-16' AS Date), N'202109', N'Nova Era', NULL, NULL, CAST(81.15 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (727, 2, CAST(N'2021-09-16' AS Date), N'202109', N'Nova Era', NULL, NULL, CAST(59.53 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (728, 2, CAST(N'2021-09-17' AS Date), N'202109', N'Pastel', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (729, 2, CAST(N'2021-09-18' AS Date), N'202109', N'Baratao da Carne', NULL, NULL, CAST(51.05 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (730, 2, CAST(N'2021-09-18' AS Date), N'202109', N'Tacacá', NULL, NULL, CAST(14.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (731, 2, CAST(N'2021-07-23' AS Date), N'202109', N'Tropical Multiloja (Thania) 2/2', NULL, NULL, CAST(77.70 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (732, 2, CAST(N'2021-09-19' AS Date), N'202109', N'Lavagem do carro ', NULL, NULL, CAST(31.21 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (733, 2, CAST(N'2021-09-20' AS Date), N'202109', N'Presente Liz', NULL, NULL, CAST(12.98 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (734, 2, CAST(N'2021-09-20' AS Date), N'202109', N'Amendoim', NULL, NULL, CAST(5.97 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (735, 2, CAST(N'2021-01-04' AS Date), N'202110', N'Microfone 10/12', NULL, NULL, CAST(133.65 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (736, 2, CAST(N'2021-01-04' AS Date), N'202110', N'Fones + Power Click 10/12', NULL, NULL, CAST(160.25 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (737, 2, CAST(N'2021-01-09' AS Date), N'202110', N'Caixa Retorno igreja 10/10', NULL, NULL, CAST(126.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (738, 2, CAST(N'2021-05-24' AS Date), N'202110', N'Giovani Baixo 5/10', NULL, NULL, CAST(314.79 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (739, 2, CAST(N'2021-09-27' AS Date), N'202110', N'Netflix ', NULL, NULL, CAST(19.95 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (740, 2, CAST(N'2021-09-27' AS Date), N'202110', N'Netflix Paim', NULL, NULL, CAST(19.95 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (741, 2, CAST(N'2021-07-03' AS Date), N'202110', N'Kamabras 4/6', NULL, NULL, CAST(40.16 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (742, 2, CAST(N'2021-07-03' AS Date), N'202110', N'Mochila Davi 4/5', NULL, NULL, CAST(52.98 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (743, 2, CAST(N'2021-08-07' AS Date), N'202110', N'Josi - Fuga de Lula 4/4', NULL, NULL, CAST(467.75 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (744, 2, CAST(N'2021-08-07' AS Date), N'202110', N'Tenis Kerllyane 4/4', NULL, NULL, CAST(32.25 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (745, 2, CAST(N'2021-07-23' AS Date), N'202110', N'Mercado livre 3/4', NULL, NULL, CAST(84.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (746, 2, CAST(N'2021-07-23' AS Date), N'202110', N'Mercado livre 3/4', NULL, NULL, CAST(143.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (747, 2, CAST(N'2021-08-21' AS Date), N'202110', N'Fuga de Lula 2/3 Josi ', NULL, NULL, CAST(197.33 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (748, 2, CAST(N'2021-08-21' AS Date), N'202110', N'Romanel 2/3 Josi (401,58) > 137,37', NULL, NULL, CAST(45.79 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (749, 2, CAST(N'2021-08-21' AS Date), N'202110', N'Romanel 2/3 Kerllyane (401,58) > 264,21', NULL, NULL, CAST(88.07 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (750, 2, CAST(N'2021-08-21' AS Date), N'202110', N'Camila 2/3', NULL, NULL, CAST(255.70 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (751, 2, CAST(N'2021-08-26' AS Date), N'202110', N'Cama Josi 2/10', NULL, NULL, CAST(253.39 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (752, 2, CAST(N'2021-08-28' AS Date), N'202110', N'Compra de 250,00 Josi 2/3', NULL, NULL, CAST(83.33 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (753, 2, CAST(N'2021-09-21' AS Date), N'202110', N'Pastel', NULL, NULL, CAST(24.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (754, 2, CAST(N'2021-09-22' AS Date), N'202110', N'Compra Agnes', NULL, NULL, CAST(29.80 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (755, 2, CAST(N'2021-09-22' AS Date), N'202110', N'Compras Agnes 1/2', NULL, NULL, CAST(32.65 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (756, 2, CAST(N'2021-09-22' AS Date), N'202110', N'Cordão  Sharla 1/4', NULL, NULL, CAST(375.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (757, 2, CAST(N'2021-09-22' AS Date), N'202110', N'Compra', NULL, NULL, CAST(40.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (758, 2, CAST(N'2021-09-22' AS Date), N'202110', N'Gasolina ', NULL, NULL, CAST(200.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (759, 2, CAST(N'2021-09-22' AS Date), N'202110', N'Pizza', NULL, NULL, CAST(48.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (760, 2, CAST(N'2021-09-23' AS Date), N'202110', N'Caderno Davi', NULL, NULL, CAST(10.35 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (761, 2, CAST(N'2021-09-24' AS Date), N'202110', N'Assaí', NULL, NULL, CAST(544.31 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (762, 2, CAST(N'2021-09-24' AS Date), N'202110', N'Leite Agnes', NULL, NULL, CAST(51.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (763, 2, CAST(N'2021-09-24' AS Date), N'202110', N'Trempe fogão 1/3', NULL, NULL, CAST(102.05 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (764, 2, CAST(N'2021-09-25' AS Date), N'202110', N'Torra Torra (289,93) 1/2', NULL, NULL, CAST(144.97 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (765, 2, CAST(N'2021-09-25' AS Date), N'202110', N'Torra Torra (47,95) 1/2', NULL, NULL, CAST(23.98 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (766, 2, CAST(N'2021-09-25' AS Date), N'202110', N'Josi 1/2', NULL, NULL, CAST(19.95 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (767, 2, CAST(N'2021-09-25' AS Date), N'202110', N'Nega 1/2', NULL, NULL, CAST(44.90 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (768, 2, CAST(N'2021-09-25' AS Date), N'202110', N'Nova Era (fraldas) 259,90', NULL, NULL, CAST(51.80 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (769, 2, CAST(N'2021-09-25' AS Date), N'202110', N'Nova Era (fraldas) 259,90 Josi', NULL, NULL, CAST(208.10 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (770, 2, CAST(N'2021-09-26' AS Date), N'202110', N'Compra na Bola (Kerllyane e Gustavo)', NULL, NULL, CAST(29.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (771, 2, CAST(N'2021-09-28' AS Date), N'202110', N'Nova Era', NULL, NULL, CAST(123.20 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (772, 2, CAST(N'2021-09-30' AS Date), N'202110', N'Filtro 1/2', NULL, NULL, CAST(53.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (773, 2, CAST(N'2021-09-30' AS Date), N'202110', N'Farmabem', NULL, NULL, CAST(66.14 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (774, 2, CAST(N'2021-09-30' AS Date), N'202110', N'Mercado livre Josi 1/3 ', NULL, NULL, CAST(416.66 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (775, 2, CAST(N'2021-10-01' AS Date), N'202110', N'Compra', NULL, NULL, CAST(15.10 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (776, 2, CAST(N'2021-10-03' AS Date), N'202110', N'Baratão da carne', NULL, NULL, CAST(100.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (777, 2, CAST(N'2021-10-03' AS Date), N'202110', N'Lanche na bola', NULL, NULL, CAST(33.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (778, 2, CAST(N'2021-10-04' AS Date), N'202110', N'Nova Era', NULL, NULL, CAST(82.76 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (779, 2, CAST(N'2021-10-05' AS Date), N'202110', N'Nova Era', NULL, NULL, CAST(114.91 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (780, 2, CAST(N'2021-10-06' AS Date), N'202110', N'Estacionamento', NULL, NULL, CAST(8.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (781, 2, CAST(N'2021-10-06' AS Date), N'202110', N'Capinha Celular', NULL, NULL, CAST(42.80 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (782, 2, CAST(N'2021-10-07' AS Date), N'202110', N'Foto 3x4', NULL, NULL, CAST(10.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (783, 2, CAST(N'2021-10-07' AS Date), N'202110', N'Nova Era', NULL, NULL, CAST(4.13 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (784, 2, CAST(N'2021-10-07' AS Date), N'202110', N'Chica Chicosa Thania 1/2', NULL, NULL, CAST(153.50 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (785, 2, CAST(N'2021-10-08' AS Date), N'202110', N'Nova Era', NULL, NULL, CAST(127.61 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (786, 2, CAST(N'2021-10-09' AS Date), N'202110', N'Estacionamento', NULL, NULL, CAST(5.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (787, 2, CAST(N'2021-10-09' AS Date), N'202110', N'Cartão de Todos', NULL, NULL, CAST(25.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (788, 2, CAST(N'2021-10-09' AS Date), N'202110', N'Compra', NULL, NULL, CAST(26.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (789, 2, CAST(N'2021-10-09' AS Date), N'202110', N'Compra', NULL, NULL, CAST(7.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (790, 2, CAST(N'2021-10-09' AS Date), N'202110', N'Torra Torra 1/2', NULL, NULL, CAST(28.63 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (791, 2, CAST(N'2021-10-09' AS Date), N'202110', N'Via Norte 1/2', NULL, NULL, CAST(69.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (792, 2, CAST(N'2021-10-09' AS Date), N'202110', N'Bobs', NULL, NULL, CAST(9.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (793, 2, CAST(N'2021-10-09' AS Date), N'202110', N'Tropical', NULL, NULL, CAST(8.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (794, 2, CAST(N'2021-10-11' AS Date), N'202110', N'Torra Torra 1/2', NULL, NULL, CAST(32.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (795, 2, CAST(N'2021-10-12' AS Date), N'202110', N'Melancia e banana', NULL, NULL, CAST(35.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (796, 2, CAST(N'2021-10-12' AS Date), N'202110', N'Nova Era', NULL, NULL, CAST(27.11 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (797, 2, CAST(N'2021-10-13' AS Date), N'202110', N'Polpa', NULL, NULL, CAST(24.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (798, 2, CAST(N'2021-10-21' AS Date), N'202110', N'Pastel', NULL, NULL, CAST(24.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (799, 2, CAST(N'2021-10-20' AS Date), N'202110', N'Netflix ', NULL, NULL, CAST(39.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (800, 2, CAST(N'2021-01-04' AS Date), N'202111', N'Microfone 11/12', NULL, NULL, CAST(133.65 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (801, 2, CAST(N'2021-01-04' AS Date), N'202111', N'Fones + Power Click 11/12', NULL, NULL, CAST(160.25 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (802, 2, CAST(N'2021-05-24' AS Date), N'202111', N'Giovani Baixo 6/10', NULL, NULL, CAST(314.79 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (803, 2, CAST(N'2021-05-27' AS Date), N'202111', N'Netflix ', NULL, NULL, CAST(0.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (804, 2, CAST(N'2021-05-27' AS Date), N'202111', N'Netflix Paim', NULL, NULL, CAST(0.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (805, 2, CAST(N'2021-07-03' AS Date), N'202111', N'Kamabras 5/6', NULL, NULL, CAST(40.16 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (806, 2, CAST(N'2021-07-03' AS Date), N'202111', N'Mochila Davi 5/5', NULL, NULL, CAST(52.98 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (807, 2, CAST(N'2021-07-23' AS Date), N'202111', N'Mercado livre 4/4', NULL, NULL, CAST(84.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (808, 2, CAST(N'2021-07-23' AS Date), N'202111', N'Mercado livre 4/4', NULL, NULL, CAST(143.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (809, 2, CAST(N'2021-08-21' AS Date), N'202111', N'Fuga de Lula 3/3 Josi ', NULL, NULL, CAST(197.33 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (810, 2, CAST(N'2021-08-21' AS Date), N'202111', N'Romanel 3/3 Josi (401,58) > 137,37', NULL, NULL, CAST(45.79 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (811, 2, CAST(N'2021-08-21' AS Date), N'202111', N'Romanel 3/3 Kerllyane (401,58) > 264,21', NULL, NULL, CAST(88.07 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (812, 2, CAST(N'2021-08-21' AS Date), N'202111', N'Camila 3/3', NULL, NULL, CAST(255.70 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (813, 2, CAST(N'2021-08-26' AS Date), N'202111', N'Cama Josi 3/10', NULL, NULL, CAST(253.39 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (814, 2, CAST(N'2021-08-28' AS Date), N'202111', N'Compra de 250,00 Josi 3/3', NULL, NULL, CAST(83.33 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (815, 2, CAST(N'2021-09-22' AS Date), N'202111', N'Compras Agnes 1/2', NULL, NULL, CAST(32.65 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (816, 2, CAST(N'2021-09-22' AS Date), N'202111', N'Cordão  Sharla 2/4', NULL, NULL, CAST(375.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (817, 2, CAST(N'2021-09-24' AS Date), N'202111', N'Trempe fogão 2/3', NULL, NULL, CAST(102.05 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (818, 2, CAST(N'2021-09-25' AS Date), N'202111', N'Torra Torra (289,93) 2/2', NULL, NULL, CAST(144.96 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (819, 2, CAST(N'2021-09-25' AS Date), N'202111', N'Torra Torra (47,95) 2/2', NULL, NULL, CAST(23.97 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (820, 2, CAST(N'2021-09-25' AS Date), N'202111', N'Josi 2/2', NULL, NULL, CAST(19.95 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (821, 2, CAST(N'2021-09-25' AS Date), N'202111', N'Nega 2/2', NULL, NULL, CAST(44.90 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (822, 2, CAST(N'2021-09-30' AS Date), N'202111', N'Filtro 2/2', NULL, NULL, CAST(53.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (823, 2, CAST(N'2021-09-30' AS Date), N'202111', N'Mercado livre Josi 2/3 ', NULL, NULL, CAST(416.66 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (824, 2, CAST(N'2021-10-07' AS Date), N'202111', N'Chica Chicosa Thania 2/2', NULL, NULL, CAST(153.50 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (825, 2, CAST(N'2021-10-09' AS Date), N'202111', N'Torra Torra 2/2', NULL, NULL, CAST(28.62 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (826, 2, CAST(N'2021-10-09' AS Date), N'202111', N'Via Norte 2/2', NULL, NULL, CAST(69.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (827, 2, CAST(N'2021-10-11' AS Date), N'202111', N'Torra Torra 2/2', NULL, NULL, CAST(32.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (828, 2, CAST(N'2021-10-23' AS Date), N'202111', N'Gasolina ', NULL, NULL, CAST(200.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (829, 2, CAST(N'2021-10-24' AS Date), N'202111', N'Refrigerante', NULL, NULL, CAST(5.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (830, 2, CAST(N'2021-10-25' AS Date), N'202111', N'Leite Agnes', NULL, NULL, CAST(50.49 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (831, 2, CAST(N'2021-10-29' AS Date), N'202111', N'Baratão da Carne', NULL, NULL, CAST(285.26 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (832, 2, CAST(N'2021-10-29' AS Date), N'202111', N'Farmácia ', NULL, NULL, CAST(32.13 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (833, 2, CAST(N'2021-11-03' AS Date), N'202111', N'Nova Era ', NULL, NULL, CAST(82.93 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (834, 2, CAST(N'2021-11-03' AS Date), N'202111', N'Fralda Cinthia ', NULL, NULL, CAST(58.99 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (835, 2, CAST(N'2021-11-03' AS Date), N'202111', N'Baratao da Carne 1/2', NULL, NULL, CAST(55.56 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (836, 2, CAST(N'2021-11-04' AS Date), N'202111', N'Cinema', NULL, NULL, CAST(34.35 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (837, 2, CAST(N'2021-11-04' AS Date), N'202111', N'Sorvetes Bobs', NULL, NULL, CAST(9.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (838, 2, CAST(N'2021-11-06' AS Date), N'202111', N'So Rossa Yaciara 1/2', NULL, NULL, CAST(68.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (839, 2, CAST(N'2021-11-07' AS Date), N'202111', N'Gasolina ', NULL, NULL, CAST(200.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (840, 2, CAST(N'2021-11-09' AS Date), N'202111', N'Sobrancelha', NULL, NULL, CAST(22.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (841, 2, CAST(N'2021-11-09' AS Date), N'202111', N'Nova Era ', NULL, NULL, CAST(156.02 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (842, 2, CAST(N'2021-11-10' AS Date), N'202111', N'SSD Shopee 1/2', NULL, NULL, CAST(125.97 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (843, 2, CAST(N'2021-11-11' AS Date), N'202111', N'Materiais Info Shopee 1/2', NULL, NULL, CAST(25.23 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (844, 2, CAST(N'2021-11-11' AS Date), N'202111', N'Comepi Josi 1/3', NULL, NULL, CAST(73.31 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (845, 2, CAST(N'2021-11-11' AS Date), N'202111', N'C&A Kerllyane 1/3', NULL, NULL, CAST(50.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (846, 2, CAST(N'2021-11-11' AS Date), N'202111', N'Poupa', NULL, NULL, CAST(19.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (847, 2, CAST(N'2021-11-11' AS Date), N'202111', N'Nova Era ', NULL, NULL, CAST(62.33 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (848, 2, CAST(N'2021-11-12' AS Date), N'202111', N'Importadora Éden Bruna', NULL, NULL, CAST(170.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (849, 2, CAST(N'2021-11-12' AS Date), N'202111', N'Transby Shop 1/2', NULL, NULL, CAST(53.96 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (850, 2, CAST(N'2021-11-13' AS Date), N'202111', N'Baratao da Carne 1/2', NULL, NULL, CAST(180.14 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (851, 2, CAST(N'2021-11-14' AS Date), N'202111', N'Refrigerante', NULL, NULL, CAST(5.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (852, 2, CAST(N'2021-11-14' AS Date), N'202111', N'Sorvete bola', NULL, NULL, CAST(6.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (853, 2, CAST(N'2021-11-14' AS Date), N'202111', N'Janta na Bola', NULL, NULL, CAST(30.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (854, 2, CAST(N'2021-11-16' AS Date), N'202111', N'Pastel', NULL, NULL, CAST(24.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (855, 2, CAST(N'2021-11-16' AS Date), N'202111', N'Smartphones Raimundo 1/10', NULL, NULL, CAST(448.25 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (856, 2, CAST(N'2021-11-17' AS Date), N'202111', N'Iphone Johanes 1/10', NULL, NULL, CAST(427.45 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (857, 2, CAST(N'2021-11-17' AS Date), N'202111', N'Tenis Isabella', NULL, NULL, CAST(41.97 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (858, 2, CAST(N'2021-11-18' AS Date), N'202111', N'Capinhas Johanes', NULL, NULL, CAST(60.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (859, 2, CAST(N'2021-11-18' AS Date), N'202111', N'Estacionamento', NULL, NULL, CAST(10.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (860, 2, CAST(N'2021-11-18' AS Date), N'202111', N'Veneza', NULL, NULL, CAST(40.58 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (861, 2, CAST(N'2021-11-18' AS Date), N'202111', N'Nova Era ', NULL, NULL, CAST(74.40 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (862, 5, CAST(N'2020-10-15' AS Date), N'202101', N'Peles Douglas 4/6', NULL, NULL, CAST(49.11 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (863, 5, CAST(N'2020-10-30' AS Date), N'202101', N'Tintao 3/3 - Augusta', NULL, NULL, CAST(125.67 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (864, 5, CAST(N'2020-11-07' AS Date), N'202101', N'Kamabras 3/3 - Josi', NULL, NULL, CAST(134.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (865, 5, CAST(N'2020-12-22' AS Date), N'202101', N'Sapatinho luxo - Cinthia', NULL, NULL, CAST(79.90 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (866, 5, CAST(N'2020-12-23' AS Date), N'202101', N'Mao dupla - Cinthia', NULL, NULL, CAST(59.90 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (867, 5, CAST(N'2020-12-23' AS Date), N'202101', N'Studio Z - Cinthia', NULL, NULL, CAST(69.98 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (868, 5, CAST(N'2020-12-23' AS Date), N'202101', N'Mn Calçados - Cinthia', NULL, NULL, CAST(39.99 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (869, 5, CAST(N'2020-12-23' AS Date), N'202101', N'Sh. Via Norte 1/2 - Cinthia', NULL, NULL, CAST(114.97 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (870, 5, CAST(N'2020-12-23' AS Date), N'202101', N'Sh. Via Norte - Cinthia', NULL, NULL, CAST(68.01 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (871, 5, CAST(N'2020-10-15' AS Date), N'202102', N'Peles Douglas 5/6', NULL, NULL, CAST(49.11 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (872, 5, CAST(N'2020-10-30' AS Date), N'202102', N'Sh. Via Norte 2/2 - Cinthia', NULL, NULL, CAST(114.96 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (873, 5, CAST(N'2020-10-15' AS Date), N'202103', N'Peles Douglas 6/6', NULL, NULL, CAST(49.11 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (874, 5, CAST(N'2021-07-26' AS Date), N'202108', N'Nega 1/6', NULL, NULL, CAST(73.26 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (875, 5, CAST(N'2021-07-26' AS Date), N'202108', N'Nega 2/6', NULL, NULL, CAST(0.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (876, 5, CAST(N'2021-07-28' AS Date), N'202108', N'Motos CIA - Josi', NULL, NULL, CAST(70.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (877, 5, CAST(N'2021-07-28' AS Date), N'202108', N'Ana Nina Praia - Josi', NULL, NULL, CAST(100.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (878, 5, CAST(N'2021-08-14' AS Date), N'202108', N'Transby Shop 1/4 - Josi', NULL, NULL, CAST(382.23 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (879, 5, CAST(N'2021-07-26' AS Date), N'202109', N'Nega 2/6', NULL, NULL, CAST(73.26 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (880, 5, CAST(N'2021-08-14' AS Date), N'202109', N'Transby Shop 2/4 - Josi', NULL, NULL, CAST(382.23 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (881, 5, CAST(N'2021-07-26' AS Date), N'202110', N'Nega 3/6', NULL, NULL, CAST(73.26 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (882, 5, CAST(N'2021-08-14' AS Date), N'202110', N'Transby Shop 3/4 - Josi', NULL, NULL, CAST(382.23 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (883, 5, CAST(N'2021-07-26' AS Date), N'202111', N'Nega 4/6', NULL, NULL, CAST(73.26 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (884, 5, CAST(N'2021-08-14' AS Date), N'202111', N'Transby Shop 4/4 - Josi', NULL, NULL, CAST(382.23 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (885, 2, CAST(N'2021-07-26' AS Date), N'202112', N'Nega 5/6', NULL, NULL, CAST(73.26 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (886, 2, CAST(N'2021-07-26' AS Date), N'202112', N'Nega 6/6 (jogar pra janeiro)', NULL, NULL, CAST(0.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (887, 4, CAST(N'2020-11-28' AS Date), N'202101', N'Compra Augusta 3/4', NULL, NULL, CAST(115.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (888, 4, CAST(N'2020-11-30' AS Date), N'202101', N'Compras Gustavo 2/2', NULL, NULL, CAST(34.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (889, 4, CAST(N'2020-11-30' AS Date), N'202101', N'Compras Gustavo 2/2', NULL, NULL, CAST(44.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (890, 4, CAST(N'2021-01-12' AS Date), N'202101', N'Recarga', NULL, NULL, CAST(10.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (891, 4, CAST(N'2020-11-28' AS Date), N'202102', N'Compra Augusta 4/4', NULL, NULL, CAST(115.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (892, 4, CAST(N'2021-03-17' AS Date), N'202103', N'Baratão (dinheiro rifa)', NULL, NULL, CAST(92.93 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (893, 4, CAST(N'2021-03-17' AS Date), N'202103', N'Cabo celular', NULL, NULL, CAST(20.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (894, 4, CAST(N'2021-07-09' AS Date), N'202107', N'Mercado Livre Johanes 1/2', NULL, NULL, CAST(225.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (895, 4, CAST(N'2021-07-09' AS Date), N'202108', N'Mercado Livre Johanes 2/2', NULL, NULL, CAST(225.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (896, 4, CAST(N'2021-07-28' AS Date), N'202108', N'Refrigerante', NULL, NULL, CAST(5.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (897, 4, CAST(N'2021-08-28' AS Date), N'202109', N'Compra na bola', NULL, NULL, CAST(12.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (898, 4, CAST(N'2021-08-28' AS Date), N'202109', N'Compra na bola', NULL, NULL, CAST(6.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (899, 4, CAST(N'2021-09-06' AS Date), N'202109', N'Torra Torra Bruna 1/2', NULL, NULL, CAST(134.95 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (900, 4, CAST(N'2021-09-06' AS Date), N'202109', N'Torra Torra Kerllyane 1/2', NULL, NULL, CAST(79.97 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (901, 4, CAST(N'2021-09-07' AS Date), N'202109', N'Baratao da carne', NULL, NULL, CAST(21.10 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (902, 4, CAST(N'2021-09-10' AS Date), N'202109', N'Fralda Bebe Cha', NULL, NULL, CAST(34.98 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (903, 4, CAST(N'2021-08-28' AS Date), N'202109', N'Compra na bola', NULL, NULL, CAST(14.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (904, 4, CAST(N'2021-09-06' AS Date), N'202110', N'Torra Torra Bruna 2/2', NULL, NULL, CAST(134.95 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (905, 4, CAST(N'2021-09-06' AS Date), N'202110', N'Torra Torra Kerllyane 2/2', NULL, NULL, CAST(79.97 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (906, 4, CAST(N'2021-10-14' AS Date), N'202110', N'Gás Cinthia', NULL, NULL, CAST(108.00 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (907, 4, CAST(N'2021-10-20' AS Date), N'202111', N'Fraldas Thania', NULL, NULL, CAST(300.28 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (908, 4, CAST(N'2021-10-20' AS Date), N'202111', N'Nova Era', NULL, NULL, CAST(186.30 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (909, 4, CAST(N'2021-10-20' AS Date), N'202111', N'Fraldas Cinthia', NULL, NULL, CAST(51.80 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (910, 4, CAST(N'2021-10-20' AS Date), N'202111', N'Mamadeiras Paula 1/2', NULL, NULL, CAST(52.50 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (911, 4, CAST(N'2021-10-22' AS Date), N'202111', N'Renner', NULL, NULL, CAST(19.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (912, 4, CAST(N'2021-10-22' AS Date), N'202111', N'MM', NULL, NULL, CAST(28.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (913, 4, CAST(N'2021-10-22' AS Date), N'202111', N'Tropical Atacadao 1/2', NULL, NULL, CAST(52.40 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (914, 4, CAST(N'2021-10-20' AS Date), N'202112', N'Mamadeiras Kerlly 2/2', NULL, NULL, CAST(52.50 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (915, 4, CAST(N'2021-10-22' AS Date), N'202112', N'Tropical Atacadao 2/2', NULL, NULL, CAST(52.40 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (916, 6, CAST(N'2020-09-04' AS Date), N'202101', N'Mesa (Paula) 4/4', NULL, NULL, CAST(64.97 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (917, 6, CAST(N'2020-09-11' AS Date), N'202101', N'Sorte Grande', NULL, NULL, CAST(4.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (918, 6, CAST(N'2020-12-12' AS Date), N'202101', N'Passagem Sharla 2/3', NULL, NULL, CAST(266.66 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (919, 6, CAST(N'2020-12-25' AS Date), N'202101', N'Anuidade', NULL, NULL, CAST(13.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (920, 6, CAST(N'2020-09-11' AS Date), N'202102', N'Sorte Grande', NULL, NULL, CAST(4.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (921, 6, CAST(N'2020-12-12' AS Date), N'202102', N'Passagem Sharla 3/3', NULL, NULL, CAST(266.66 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (922, 6, CAST(N'2021-02-05' AS Date), N'202102', N'Compra', NULL, NULL, CAST(14.28 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (923, 6, CAST(N'2021-02-05' AS Date), N'202102', N'Descontos', NULL, NULL, CAST(-0.44 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (924, 6, CAST(N'2020-09-11' AS Date), N'202103', N'Sorte Grande', NULL, NULL, CAST(4.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (925, 6, CAST(N'2021-03-01' AS Date), N'202103', N'Dafiti (BF) 1/2', NULL, NULL, CAST(205.47 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (926, 6, CAST(N'2021-03-19' AS Date), N'202103', N'Carrefour', NULL, NULL, CAST(5.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (927, 6, CAST(N'2020-09-11' AS Date), N'202104', N'Sorte Grande', NULL, NULL, CAST(4.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (928, 6, CAST(N'2021-03-01' AS Date), N'202104', N'Dafiti (BF) 2/2', NULL, NULL, CAST(205.47 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (929, 6, CAST(N'2021-03-29' AS Date), N'202104', N'Carrefour', NULL, NULL, CAST(28.86 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (930, 6, CAST(N'2021-09-11' AS Date), N'202105', N'Sorte Grande', NULL, NULL, CAST(4.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (931, 6, CAST(N'2021-09-11' AS Date), N'202106', N'Sorte Grande', NULL, NULL, CAST(4.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (932, 6, CAST(N'2021-06-19' AS Date), N'202106', N'Creme Dental', NULL, NULL, CAST(5.49 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (933, 6, CAST(N'2021-06-26' AS Date), N'202107', N'TV Cinthia 1/12', NULL, NULL, CAST(229.75 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (934, 6, CAST(N'2021-07-02' AS Date), N'202107', N'Dafiti 1/3 BF', NULL, NULL, CAST(219.99 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (935, 6, CAST(N'2021-07-11' AS Date), N'202107', N'Seguro da sorte', NULL, NULL, CAST(4.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (936, 6, CAST(N'2021-07-25' AS Date), N'202107', N'Anuidade', NULL, NULL, CAST(13.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (937, 6, CAST(N'2021-06-26' AS Date), N'202108', N'TV Cinthia 2/12', NULL, NULL, CAST(229.66 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (938, 6, CAST(N'2021-07-02' AS Date), N'202108', N'Dafiti 2/3 BF', NULL, NULL, CAST(219.98 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (939, 6, CAST(N'2021-07-11' AS Date), N'202108', N'Sorte grande', NULL, NULL, CAST(4.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (940, 6, CAST(N'2021-07-25' AS Date), N'202108', N'Anuidade', NULL, NULL, CAST(13.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (941, 6, CAST(N'2021-06-26' AS Date), N'202109', N'TV Cinthia 3/12', NULL, NULL, CAST(229.66 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (942, 6, CAST(N'2021-07-02' AS Date), N'202109', N'Dafiti 3/3 BF', NULL, NULL, CAST(219.98 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (943, 6, CAST(N'2021-09-12' AS Date), N'202109', N'Creme dental ', NULL, NULL, CAST(8.38 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (944, 6, CAST(N'2021-09-01' AS Date), N'202109', N'YouTube premium ', NULL, NULL, CAST(20.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (945, 6, CAST(N'2021-09-11' AS Date), N'202109', N'Sorte grande', NULL, NULL, CAST(4.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (946, 6, CAST(N'2021-06-26' AS Date), N'202110', N'TV Cinthia 4/12', NULL, NULL, CAST(229.66 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (947, 6, CAST(N'2021-10-01' AS Date), N'202110', N'YouTube premium ', NULL, NULL, CAST(20.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (948, 6, CAST(N'2021-10-11' AS Date), N'202110', N'Sorte grande', NULL, NULL, CAST(4.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (949, 6, CAST(N'2021-10-21' AS Date), N'202110', N'Anuidade', NULL, NULL, CAST(13.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (950, 6, CAST(N'2021-06-26' AS Date), N'202111', N'TV Cinthia 5/12', NULL, NULL, CAST(229.66 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (951, 6, CAST(N'2021-11-01' AS Date), N'202111', N'YouTube premium ', NULL, NULL, CAST(20.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (952, 6, CAST(N'2021-11-11' AS Date), N'202111', N'Sorte grande', NULL, NULL, CAST(4.90 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (953, 6, CAST(N'2021-06-26' AS Date), N'202112', N'TV Cinthia 6/12', NULL, NULL, CAST(229.66 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (954, 3, CAST(N'2021-07-26' AS Date), N'202108', N'Gasolina', NULL, NULL, CAST(100.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (955, 3, CAST(N'2021-08-02' AS Date), N'202108', N'Gasolina', NULL, NULL, CAST(100.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (956, 3, CAST(N'2021-08-12' AS Date), N'202108', N'Gasolina', NULL, NULL, CAST(50.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (957, 3, CAST(N'2021-08-16' AS Date), N'202108', N'Gasolina', NULL, NULL, CAST(48.75 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (958, 3, CAST(N'2021-08-24' AS Date), N'202108', N'Gasolina', NULL, NULL, CAST(100.03 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (959, 3, CAST(N'2021-09-01' AS Date), N'202109', N'Gasolina', NULL, NULL, CAST(100.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (960, 3, CAST(N'2021-09-06' AS Date), N'202109', N'Gasolina', NULL, NULL, CAST(194.99 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (961, 3, CAST(N'2021-09-12' AS Date), N'202109', N'Vitoria', NULL, NULL, CAST(63.30 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (962, 3, CAST(N'2021-10-03' AS Date), N'202110', N'Gasolina', NULL, NULL, CAST(150.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (963, 3, CAST(N'2021-10-09' AS Date), N'202110', N'Gasolina', NULL, NULL, CAST(190.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (964, 7, CAST(N'2021-08-23' AS Date), N'202109', N'Pastora Cleide 1/3', NULL, NULL, CAST(505.44 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (965, 7, CAST(N'2021-08-23' AS Date), N'202110', N'Pastora Cleide 2/3', NULL, NULL, CAST(505.43 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (966, 7, CAST(N'2021-08-23' AS Date), N'202111', N'Pastora Cleide 3/3', NULL, NULL, CAST(505.43 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (967, 8, CAST(N'2021-10-15' AS Date), N'202110', N'Leite Agnes', NULL, NULL, CAST(42.03 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (968, 8, CAST(N'2021-10-18' AS Date), N'202110', N'Farmacia', NULL, NULL, CAST(10.02 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (969, 8, CAST(N'2021-10-24' AS Date), N'202111', N'Gas', NULL, NULL, CAST(108.00 AS Numeric(18, 2)), NULL, 0)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (970, 8, CAST(N'2021-11-01' AS Date), N'202111', N'Pistola Deliane 1/4', NULL, NULL, CAST(41.54 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (971, 8, CAST(N'2021-11-01' AS Date), N'202111', N'Empréstimo Deliane 1/12', NULL, NULL, CAST(532.10 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (972, 8, CAST(N'2021-11-04' AS Date), N'202111', N'Curso Dani 1/12', NULL, NULL, CAST(69.90 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (973, 8, CAST(N'2021-11-01' AS Date), N'202112', N'Pistola Deliane 2/4', NULL, NULL, CAST(41.53 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (974, 8, CAST(N'2021-11-01' AS Date), N'202112', N'Empréstimo Deliane 2/12', NULL, NULL, CAST(532.10 AS Numeric(18, 2)), NULL, 1)
GO
INSERT [dbo].[CardsPostings] ([Id], [CardId], [Date], [Reference], [Description], [ParcelNumber], [Parcels], [Amount], [TotalAmount], [Others]) VALUES (975, 8, CAST(N'2021-11-04' AS Date), N'202112', N'Curso Dani 2/12', NULL, NULL, CAST(69.90 AS Numeric(18, 2)), NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[CardsPostings] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 
GO
INSERT [dbo].[Users] ([Id], [Name], [Login], [Password]) VALUES (1, N'Johnny Frits', N'johnny', N'123')
GO
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET IDENTITY_INSERT [dbo].[Yields] ON 
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (1, 2, CAST(N'2021-01-15' AS Date), N'202101', CAST(16.66 AS Numeric(18, 2)))
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (2, 2, CAST(N'2021-02-15' AS Date), N'202102', CAST(17.79 AS Numeric(18, 2)))
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (3, 2, CAST(N'2021-03-15' AS Date), N'202103', CAST(30.71 AS Numeric(18, 2)))
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (4, 2, CAST(N'2021-04-15' AS Date), N'202104', CAST(17.44 AS Numeric(18, 2)))
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (5, 2, CAST(N'2021-05-15' AS Date), N'202105', CAST(54.92 AS Numeric(18, 2)))
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (6, 2, CAST(N'2021-06-15' AS Date), N'202106', CAST(34.50 AS Numeric(18, 2)))
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (7, 2, CAST(N'2021-07-15' AS Date), N'202107', CAST(80.25 AS Numeric(18, 2)))
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (8, 2, CAST(N'2021-08-15' AS Date), N'202108', CAST(48.98 AS Numeric(18, 2)))
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (9, 2, CAST(N'2021-09-15' AS Date), N'202109', CAST(33.80 AS Numeric(18, 2)))
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (10, 2, CAST(N'2021-10-15' AS Date), N'202110', CAST(24.64 AS Numeric(18, 2)))
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (11, 2, CAST(N'2021-11-03' AS Date), N'202111', CAST(1.44 AS Numeric(18, 2)))
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (12, 2, CAST(N'2021-11-04' AS Date), N'202111', CAST(1.40 AS Numeric(18, 2)))
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (13, 2, CAST(N'2021-11-05' AS Date), N'202111', CAST(1.44 AS Numeric(18, 2)))
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (14, 2, CAST(N'2021-11-08' AS Date), N'202111', CAST(1.25 AS Numeric(18, 2)))
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (15, 2, CAST(N'2021-11-09' AS Date), N'202111', CAST(1.24 AS Numeric(18, 2)))
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (16, 2, CAST(N'2021-11-10' AS Date), N'202111', CAST(1.26 AS Numeric(18, 2)))
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (17, 2, CAST(N'2021-11-12' AS Date), N'202111', CAST(0.74 AS Numeric(18, 2)))
GO
INSERT [dbo].[Yields] ([Id], [AccountId], [Date], [Reference], [Amount]) VALUES (18, 2, CAST(N'2021-11-13' AS Date), N'202111', CAST(0.74 AS Numeric(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[Yields] OFF
GO
ALTER TABLE [dbo].[Accounts]  WITH CHECK ADD  CONSTRAINT [FK_Accounts_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Accounts] CHECK CONSTRAINT [FK_Accounts_Users]
GO
ALTER TABLE [dbo].[AccountsPostings]  WITH CHECK ADD  CONSTRAINT [FK_AccountsPostings_Accounts] FOREIGN KEY([AccountId])
REFERENCES [dbo].[Accounts] ([Id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[AccountsPostings] CHECK CONSTRAINT [FK_AccountsPostings_Accounts]
GO
ALTER TABLE [dbo].[Cards]  WITH CHECK ADD  CONSTRAINT [FK_Cards_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Cards] CHECK CONSTRAINT [FK_Cards_Users]
GO
ALTER TABLE [dbo].[CardsPostings]  WITH CHECK ADD  CONSTRAINT [FK_CardsPostings_Cards] FOREIGN KEY([CardId])
REFERENCES [dbo].[Cards] ([Id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CardsPostings] CHECK CONSTRAINT [FK_CardsPostings_Cards]
GO
ALTER TABLE [dbo].[Yields]  WITH CHECK ADD  CONSTRAINT [FK_Yields_Accounts] FOREIGN KEY([AccountId])
REFERENCES [dbo].[Accounts] ([Id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Yields] CHECK CONSTRAINT [FK_Yields_Accounts]
GO
USE [master]
GO
ALTER DATABASE [Budget] SET  READ_WRITE 
GO
