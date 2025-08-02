Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021092.outbound.protection.outlook.com [52.101.65.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305EC1E5729
	for <linux-trace-devel@vger.kernel.org>; Sat,  2 Aug 2025 07:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754120321; cv=fail; b=VAKT/EUHeAPtfqygmlyNy29Oa7EA85zJhpAA+gX4x8QjqFBgWFUmU8TTh42EOKX3WWgtNdXcIODKvU9FDmFaOu+L/6mjloX0NeNAEQ5e/Az+Qn+A6d2v2X8kZQc6TnrYSLjKOBO+bQrezSZR27UtwUA1JbMQVfP4wuTuUU4Tj94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754120321; c=relaxed/simple;
	bh=mWH9cG8DdYDgfCCyEAudK2m81+tE1wm7jCgZc2YshDE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=H6+PdVp2uaMhxRIoxOsqf8cMrytmsi3s88tPbHRES3Ugue4kJczGITiunAsxX+JAEA0kgnuqd6ohGoZBQqqWUPXR+/DVaZTtHEN1DaAJvLCpDIZFng1mhjOn5YqZuQ84gbUcc273SyUrtJ+LabZthB5cClTy5S8eUi7+U0MWRhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cvut.cz; spf=pass smtp.mailfrom=cvut.cz; dkim=pass (2048-bit key) header.d=cvut.cz header.i=@cvut.cz header.b=MMRiXDq7; arc=fail smtp.client-ip=52.101.65.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cvut.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cvut.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cvut.cz header.i=@cvut.cz header.b="MMRiXDq7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uEy1lEvdzzXYLeeK/daSNamz76VUwewdX4XI3GxdThwnWdDuDA1vYYMdFVq/DrsD8YbYlyaEjc2Ru+uofqgEgVzDWlO37S4cLS2OjShrQ6YErf+GDvktutCT5CejFALMyVDFN7TtVZUgwnygh18ye8+QUefgNNjfRFgUkoGtExLceClD0bN0EwOzifL0q1MEIFM7yNQhTw6h1y/KudUJxOQ3rv8V54QOGcnPjDXdtP0anBGRNY5xDOqR1FH7SGxE2pRyDlfU7LLp/UNBDVHkgcQngpR1HKA9uDK5owvHGa5ovws6tBx9/CcNdbUYHBc/ZJoDqPrJpMCkeOGG4pe0GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mWH9cG8DdYDgfCCyEAudK2m81+tE1wm7jCgZc2YshDE=;
 b=WBefdjjSgQsmMgy62eZw1mvqWWWSslU7Z3UnMX9rTTLhuNZnxdh/yPaa24QLX5SPT6eCAtMS+K5rwZbplNA/DN8wgCGrsBgSVbBSciu3ZgDX1OMSjMutRFkAGmoMfLGaQSBdJBncp7Lt3sEgzGqdgTpzdv8cwlmRn5SIzHqsKhfocnXJhHJ/UbbxSYGNcG1I1z97Hi7uwK8WOOQZObOQCrfBAMuM2kcBY2m51RvJ+m1LoZr6mkudLfa3o32akv87xyeBvR+KZqr1n23ZCRnam+EpgL58e3m7Ci4uojiy/lV5KUf/6LolPmeo9WYsauyVsT07O3K7JfnjE57tF/fktA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cvut.cz; dmarc=pass action=none header.from=cvut.cz; dkim=pass
 header.d=cvut.cz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cvut.cz; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mWH9cG8DdYDgfCCyEAudK2m81+tE1wm7jCgZc2YshDE=;
 b=MMRiXDq7S9HZGw24Nu8gf8JabDIccYgh3ddVHCpU4n97AnYRhUlCjJQVh2C5b7MjUexcXP0KUvykkiAd6n3EEEpILXH+pQYDoqs/4MLOJjqN+2SOdn7w2D1pEqxmxXo7g7BLN0/c3i8d5geTpDDYoVxOa5EV3J7duADTAgiNSB/CV+sxbA+BU2bH8KnxevhnY+YOdFM8+7/QDE9TQ7J3HmPBjIOVp2boJYWew+qACGgkHXUgutOJ05y1Hq/4ukOWLkQoEKtymAK2DlZAD+JSybPPgSOieY5sry/LolHjTa76jKIjzKQ1T0MBzSzpZI/zxpF0CIEFTmKOgJ+mtWg9Kw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cvut.cz;
Received: from PA3PR06MB9863.eurprd06.prod.outlook.com (2603:10a6:102:4b0::9)
 by AM9PR06MB7923.eurprd06.prod.outlook.com (2603:10a6:20b:3ab::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Sat, 2 Aug
 2025 07:38:36 +0000
Received: from PA3PR06MB9863.eurprd06.prod.outlook.com
 ([fe80::cd97:3323:477a:3ed3]) by PA3PR06MB9863.eurprd06.prod.outlook.com
 ([fe80::cd97:3323:477a:3ed3%6]) with mapi id 15.20.8989.017; Sat, 2 Aug 2025
 07:38:36 +0000
From: Michal Sojka <michal.sojka@cvut.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] libtracefs: utest: Return non-zero exit code
 when something fails
In-Reply-To: <20250801214747.21876847@batman.local.home>
References: <20250720221617.695311-1-michal.sojka@cvut.cz>
 <20250728143433.1114222-1-michal.sojka@cvut.cz>
 <20250801214747.21876847@batman.local.home>
Date: Sat, 02 Aug 2025 09:38:35 +0200
Message-ID: <87seiai35w.fsf@steelpick.2x.cz>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0148.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::32) To PA3PR06MB9863.eurprd06.prod.outlook.com
 (2603:10a6:102:4b0::9)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA3PR06MB9863:EE_|AM9PR06MB7923:EE_
X-MS-Office365-Filtering-Correlation-Id: daef8162-b931-4394-17ad-08ddd197975d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|19092799006|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PXYPLkOIn2DFodtYOu9h50XPJGLsRvFi0ZjfajDRr9zX+aqrMUPun8PIfmcV?=
 =?us-ascii?Q?pLVoVAJl/WpmSDQ0Xg0WOg4deB+Fgf3JObwY4w30PpI+pzONoxmRrOZkA8+z?=
 =?us-ascii?Q?2A0x9b48qmIVhQ7Q21JNzakoNq+Z6gWKOGKRs96MDFXkWE0/ivjciqdUw27K?=
 =?us-ascii?Q?qIaCZS3YaXuwVFwJdw5RQ627PHo5BxfYo3Ux/Gbnq2dEgSbV0YHqr0meT7nq?=
 =?us-ascii?Q?/OuC9/fi+IHRMOsz0FqdDT3+WJFxSNvWKFwfwEKz+qEEe8IchDouFn2N4ee5?=
 =?us-ascii?Q?dIb1bJZJ68llcu7hvU8FmWxM/bylS8CHgpaOL7dyS/SyiWexn+QgG22D+Jzd?=
 =?us-ascii?Q?qr1K5k4l4fBG9ExT0ki2sbLJPb7pQrNlPGNr/mVEdWnsVWNw8fyD678EOIiR?=
 =?us-ascii?Q?CGSIgXcROpXW4S1ST5ivndNZObozS6PU/jxIr0Z68DnS5ZMw2u8Vfs/xApIq?=
 =?us-ascii?Q?CVB8VoWPsNCrPiVff52FiCClj3bx/+U+N0stFHNgYYbgBnXg+3CRMzGOrK+K?=
 =?us-ascii?Q?WjdFGyFhwRhEL7dJuQVN0OXkyHMfRUemhTz3xm5hyeG8wdgB8pZcw3XlZwt+?=
 =?us-ascii?Q?0j9TWI/ZksCq15mWs7letXVSECT+u4XU1ar6WEAGgMFCfK7I/c6TgkbHk4r2?=
 =?us-ascii?Q?AgSMKwaVrTQ5tadv8JBB9WeFH32Jzuqbx5TYMPXZkoawVlYxowDC18Ja/R2U?=
 =?us-ascii?Q?l2WVO1jUak/tcfEUGEhvtAhOY50QjkpDK3dnYJT6kWpRQWCtWwCQ9a52xDMU?=
 =?us-ascii?Q?N+iirKQpbphzTKszKNYgfwZa1qsdhwvnbCpNZq6KPdZ50yMN8EIwj4SKBJHh?=
 =?us-ascii?Q?agFhDuHvEU4GlZiF42mqeu5p0dWCh5ZTZpp+609gw67igEBvHvvu3X2g49fV?=
 =?us-ascii?Q?j18bVRgkaGJlXgVbMj3cP/KbFYTLZI9APUJbWCmcPpYFnfJo0sExa/P4hlsr?=
 =?us-ascii?Q?feDHFELgnxv3Fzx4b1oA557Lw9FAbr0xeTaBnG7OpghBcbl/BVmN6+/YDFwX?=
 =?us-ascii?Q?CY8h0NDRLZ2aIsCg7/eC4ybBgeCo/STGu/bhbJFNgeziPCaq8nm67C7OcjZm?=
 =?us-ascii?Q?9Q69CYBY1t2P48BscPfonAAsFmXm6ZHgXKeLF1Tmv7l2BWmTjqtJ7lgQZVLV?=
 =?us-ascii?Q?5Cf/LkNHYM9sxtC+tEvpyAFutZXuwdSvha0TYjVv9R6hmyXMhwNvtQfR5Yyb?=
 =?us-ascii?Q?d7ALs6+Nc10UBJ2tg6gMlftcjpm7DQOYruNzvkNi9wpP9QzOUSDcm90t950v?=
 =?us-ascii?Q?i4QgZ/m07kToIn/hGTrXvdM2OhsxF6VmtEnLEUE6cirlRX0bk+2iL0+L+4BR?=
 =?us-ascii?Q?VB2wY2DC9ispYt3VgBhcqAuVGaImQtJYMWWwNgxERMXe4OflAGkcU9qzy/Y+?=
 =?us-ascii?Q?OImqfsAPXB4puuRKEC+3cS9PgFioC/cB5ryNpC+ztNKiGOlTbZmLhJGClKic?=
 =?us-ascii?Q?NpQIP18L2vU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA3PR06MB9863.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gfmIHyWnEGfTtTZy7WNm/tQr54F+Q5OKBf/yhKowFLKT+mvhJXGza4sTm/2z?=
 =?us-ascii?Q?ebd218XXZyGd6AokXg4ITpKFD26BQx1CzRMk/Ce8CZ6/c71R8pwc6zvF3QIg?=
 =?us-ascii?Q?PHrWLHkj5ddaEC9p6PbCtry1LOWbobK1X7ktEb3HBuS9MOIXTMMvoQ/AJly0?=
 =?us-ascii?Q?BIG9IcWOSYt/luB3AAOLTEpTyUgach1t0jdxhxfP5UN/XIEuRcpcRyXRjSa9?=
 =?us-ascii?Q?Hkhw+6nEED82ndNoe/73zweZAY2fOC+U2hVtGZpOfZa7rlQLuercUFzSa9eV?=
 =?us-ascii?Q?8x80/az1RueIiNM2azWFoBj/Es5kFfbup+Aj9Inhx8CLKWAlktyX0ZxS4CCp?=
 =?us-ascii?Q?kQ3oGJIhrOAerSqrH70RY782+i7Wz/PbKwMITduCE8Xq1reSKWSV0/X++2bk?=
 =?us-ascii?Q?qeDG2EXGQ1VdC2dHt9T41mTqJu3El8Aew+/+lkqdbfRfbXLeLt9cyHuFwMt9?=
 =?us-ascii?Q?jSEnLOesl7tagbLpc/hgRslDtCEPBCMvwrXIRzvH5tdLax3ayCGstmttRIAZ?=
 =?us-ascii?Q?qcj+Rv5csALay63JDiqcWu9xvCsduN79CPLjGNvpEgVxon/lXbiIU1TrlLi5?=
 =?us-ascii?Q?mPKtvDYNM40kcWRPGGyy8Z4nhiNX9l96EE3cO3/T+TuR74rEtA+cWDDIoKv+?=
 =?us-ascii?Q?M/OJIwxuGvJ3G2posaN/1rUzh865mu21DtaqTcdKVp5B8hGTBxncaps1F7GM?=
 =?us-ascii?Q?0VZMcLFdF2X3qvOlyx1vIjQp68Qv9z+EW45gtG5PvNZpLY/A6sPcc6dIp19e?=
 =?us-ascii?Q?kgHlV+Gew9vNsepHdgM2a28CaBtd8cRGWnPcNQ8vLYbqF2uP/UGFe7YfIMVK?=
 =?us-ascii?Q?0uqBbflYLuIPuKffWyNs1+4GdjBuBKT38acTHvV9XOXdhKxE6boA/PBBq8fO?=
 =?us-ascii?Q?ELLL6IZ0296HSVs+QKuxsptffs+DQ0LdSfiKUPLAHdg5oohMiuZfix3Al5+c?=
 =?us-ascii?Q?XtnI5ukzqZaIFSamMnFN5ozSrrdD08EQmK2fp+EbjtAFVBEOvuouJh5+EyIc?=
 =?us-ascii?Q?yaUXnUhOD+KdNXSfo3J39XkSBNEqxIYWFdCBCA/FSSXGNleXuH0r9bIuZVJX?=
 =?us-ascii?Q?fn8Vi3c1WZDb8EiP82SAm8H9dBez4gCQAbPRWpPZpxlGK9s1gXJDeLGxQJV8?=
 =?us-ascii?Q?/2y0K0gv2Wi+mJRw1o0rAyNRWar0KsizCUTd/HNi+GZAiEKlSj7qNKS5WsrY?=
 =?us-ascii?Q?SokUiattqCgZu+dr6dbn76wRfTxshRALhE63hgYaxNMdnoYZokZnoSAmhwZf?=
 =?us-ascii?Q?gvtyw7Qn12sd+5GQmiCeugnUFsPxMBJlrh9t4Yhe8/9Dy7T7xTVWmyonBzR0?=
 =?us-ascii?Q?4xQShJCR6EsvjzLw1quSRKvedWi3MLWQ2VscY/jlu4eEASmYSGNpHUUNZ1mw?=
 =?us-ascii?Q?mBpuOE7ozZCkgPFKYYBBZckkQVeg7ixTp75VhZV1s5jqz8zfotXUqA5IrlZ2?=
 =?us-ascii?Q?K162mM70xGKxyTUHjoxdbpJFoIBt5OF+7xkumLNc2aNRH8pXwvLvRopgrxvV?=
 =?us-ascii?Q?t97vIq2A19dwM7WzI02FQuDElFjINWi1hmz6wUUTR7oi0llCT6ul8wMxrlHB?=
 =?us-ascii?Q?187/tJ6FKluoVZjXE5TTVutOTZlMgA8J5KnvWv7L?=
X-OriginatorOrg: cvut.cz
X-MS-Exchange-CrossTenant-Network-Message-Id: daef8162-b931-4394-17ad-08ddd197975d
X-MS-Exchange-CrossTenant-AuthSource: PA3PR06MB9863.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2025 07:38:36.8259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f345c406-5268-43b0-b19f-5862fa6833f8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gusgitJ46AUyDZT3r6qXrjj5cRmpHe/ON2TxC0r0WrSio2MUjyR5lTeXRMC+pfiq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR06MB7923

On Fri, Aug 01 2025, Steven Rostedt wrote:
> This is a "v2" of just 1/2. I don't see a 2/2 of this version.

2/2 is actually independent on 1/2 and didn't change in v2 so I didn't
send it. Sorry for the confusion. I've sent it now as a reply to v2 1/2.

Thanks
-Michal
