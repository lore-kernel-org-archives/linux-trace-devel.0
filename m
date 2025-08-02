Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11020105.outbound.protection.outlook.com [52.101.84.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210C21E9B21
	for <linux-trace-devel@vger.kernel.org>; Sat,  2 Aug 2025 07:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.105
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754120179; cv=fail; b=fzHl3SdiQsdgkAVksB6I1MKAf2q53Q9RpiAc1KmQiJwtLT7IKgSTUNbiZbOqZOMZhvP4M6igIESnGxCK76wwpxH9H83cUissyOPL4+NKkGDtJxiA+BhhgSYTPoedmLuRCdDYnFtr23yQw3cawBPGCVInszOGt0VRF2BPlKTzVWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754120179; c=relaxed/simple;
	bh=MwKRNJr+UCSGOn7ojg2cQLKWw09QfWt5BJQhdgOJcig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RWtIPl1UINgdxzClGU0ZkwD5YNizk9sVo1fLsZVsIqd8LSn7W4KVP+KR/pO8se0cMCTdsb9Lvi+AewP0lS1GuXgkyCctYCyHHBUHBLZSyaa5kIZqVYx8Pn3IlGHj/JDddloi4j2mrMs+DmJt9Pk9YrIUgXNMsfZpEK7OOekjkyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cvut.cz; spf=pass smtp.mailfrom=cvut.cz; dkim=pass (2048-bit key) header.d=cvut.cz header.i=@cvut.cz header.b=XDJapczk; arc=fail smtp.client-ip=52.101.84.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cvut.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cvut.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cvut.cz header.i=@cvut.cz header.b="XDJapczk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DdxQ9SEFyOo8bR76brgcFiNzVqt2kgx/AJIkBkxAnI7h2k0GZBnQI+yTvAw0oQlfolVA4zlGopE2lKeX0QUxutgxsBL8hTBWpOhtb2CmrEdyTK9IMNhcoT5JBYkeGJ/aM6m17XIGOdpcEf6uD5C3jTYxbixB5RPenuL9XPMrDy55lY5qsUBwQvDlAjRyxumUbB/wX1b/pWqUzi569wUSRYe098qzETx+a0VGYmcwDrgXpY2Ek8tNGbLOCYVxyP/XimtxpVkIT0uB3mUtocISPnwE47wtSe69pJrPEA+zqp1rVpWVB6E2tb7xO5Nm/iG04QjBt/grKW0MXhtO1r2lkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tm0Fdd+3SkeiXhHWyn6TQhye1GeSfvzjflxeMawMxuY=;
 b=yvSTC67ku16JdVoGFc8PYjeCwp+4tqPBiM/ATmQS9y0rBMrvKc7YkrksAg5E7/ZafVxK6QkXC3b/a9XaAreYgn+BSN7nqidv2zG5x7vvfyKoJEDJYvJF+TjseKy9SwqgFv6Cg0yvkLLmrygvWA9wDw6Gk9sucwyIarSqq6cgSs1NI/fTvo1BcQS1rzJGVh7U0/8v89SjcDk5KsiMcyXFiIMUphkh1BqPKdoGvfK2uaXwOfJse8bL160u49zYibhLVzyHVOQnrbGJIXF6F5G/zBFX5leeInoK8T8bfSutXjZGemEmcrBp9qEbLKf5Pb95NYx1qbQylmexoknHFUh4eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cvut.cz; dmarc=pass action=none header.from=cvut.cz; dkim=pass
 header.d=cvut.cz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cvut.cz; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tm0Fdd+3SkeiXhHWyn6TQhye1GeSfvzjflxeMawMxuY=;
 b=XDJapczkhDrp8PpIxr1G9Hrd2tlwNkdEfkJ+83KUbibh+CB8J4A8KEwJ1gzb7+I1b3FAtpTtWOG31/YbksEObwhsM5ctR1pvIxZBUh3oaBmhevIrO9CVzVP4B6/8H8MjawiE8K7ME5eo/AZzjeoAUISAVCYLdEa7vlau8ZRZeiDrbPnTk8LAGF0zOmTaOD9rqH6th3PaKCobe+r4kroGvElXTZUbWrWXZXUkYMUkCylyrZDdfitZ7UUtTzkYsBd080rMUj5UpCmShy6ZaB35FWp9WEPwvVAC3b4TaWPBfmln591frd5gfrwpK8rN7oMyHYu4R93RE79zKx8Y/G8Cqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cvut.cz;
Received: from PA3PR06MB9863.eurprd06.prod.outlook.com (2603:10a6:102:4b0::9)
 by PR3PR06MB6666.eurprd06.prod.outlook.com (2603:10a6:102:6a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.17; Sat, 2 Aug
 2025 07:36:13 +0000
Received: from PA3PR06MB9863.eurprd06.prod.outlook.com
 ([fe80::cd97:3323:477a:3ed3]) by PA3PR06MB9863.eurprd06.prod.outlook.com
 ([fe80::cd97:3323:477a:3ed3%6]) with mapi id 15.20.8989.017; Sat, 2 Aug 2025
 07:36:12 +0000
From: Michal Sojka <michal.sojka@cvut.cz>
To: linux-trace-devel@vger.kernel.org
Cc: Michal Sojka <michal.sojka@cvut.cz>
Subject: [PATCH v2 2/2] libtracefs/Documentation: Fix markup in the man page
Date: Sat,  2 Aug 2025 09:35:58 +0200
Message-ID: <20250802073558.493881-1-michal.sojka@cvut.cz>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250728143433.1114222-1-michal.sojka@cvut.cz>
References: <20250728143433.1114222-1-michal.sojka@cvut.cz>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0062.eurprd04.prod.outlook.com
 (2603:10a6:802:2::33) To PA3PR06MB9863.eurprd06.prod.outlook.com
 (2603:10a6:102:4b0::9)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA3PR06MB9863:EE_|PR3PR06MB6666:EE_
X-MS-Office365-Filtering-Correlation-Id: 30000b1e-81cf-42ca-d792-08ddd197416b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|19092799006|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3MOU4XqrO5xgsjDjIVk99lGrrRUUg8UDNUulsShjy/ljEJzcT4vJeDPNXkaL?=
 =?us-ascii?Q?bPgVdmp6FXzwwQnNTKDVU6Nj6dMafs+g0wThBU2Gsx3vpBVxPSRXj0L0FaWM?=
 =?us-ascii?Q?3K1VdKpqAVmJyGa5ow3iu3JaE92eTkhCnlbTrGi+hFw0OamqnCkxL/WQq65d?=
 =?us-ascii?Q?1BJxtKrlm4+y3g2WPTLhxmUHUagF2/0i0Bwp7Kd5htxmpzY3bAKnc41H+nOU?=
 =?us-ascii?Q?OpR8M02yGWqNlkxTIBLasj7DTRpOxlviMi6ZwrtTfGo4eAiivPAVnFOmrLO6?=
 =?us-ascii?Q?bStHgG92q7AzEuwbAC6KIbZiE0R125ZzBzZNwuuCsmyERf6K2giTyNwumDUM?=
 =?us-ascii?Q?ITabP5YqdImUY4JQlCo8p3D8WYNRlC1XXGvgJiZJD+uC4SVS77MFltLsNamF?=
 =?us-ascii?Q?qBs1VQvPpCa5iNl0RZQOSJ5OWwFDxPYD6Rw3miBAl53PYf20aESOcNq18Yxn?=
 =?us-ascii?Q?IyM276UQUR/aVsMyYrZa4UavGwHodcEysmqlWQZgBExtpLvPUM3ETdV+Wnka?=
 =?us-ascii?Q?Qu6UPoYVx+X904shL7P6eJaZ922FoGzV4DshffYhonVm8t7kuhtcy0LCAdgT?=
 =?us-ascii?Q?3BN655jXp3tTJkvtqU1fJ9FMPUAUwSgfJnhJ3IpD69j3+j/ynhWfLBB3Yfhs?=
 =?us-ascii?Q?DAefGWbXUGQ+u2i76RAJxUPPJ4KAHbGRYciIK5ffyMesJ6pb0TvkSsi6oCWz?=
 =?us-ascii?Q?ECF3QS4aikEQMOb5ZQCvWNiCCaos5qHyYVe/dO9RnTDGDCq5JnQYthV/jxV7?=
 =?us-ascii?Q?CZVvHIUSK7kt8ouebmDRXboSZ22sxCGuY2TXVQ5smKO6x8vNWnqyfsZXO2yy?=
 =?us-ascii?Q?izHhbnfobqopv6pzQi0moAbHVuh6RZdhkW6Qy26V6YZn6rc7pkBu0KXr94xT?=
 =?us-ascii?Q?h/jO9kDyC4DZ6riV/UOklR27IWry8SSjTTwLeDWgJ7DrdsmJvudU0qTE7SHA?=
 =?us-ascii?Q?aSSB35rBB6hKRZXH95UpJwgczFOFnc2cdi9cBgxHvFcjMmvPLKAKj9iP1XSN?=
 =?us-ascii?Q?2U5XaJu2wFgpOOakY8EpJNTQpB8WVw6iLkTP9HGz4tWwS3/pTnv/LSWuXD3b?=
 =?us-ascii?Q?itj+l0aATs++cVvAWb3XVbzStEetP6oqj76C2m2NgDj0YPfAqzy4qW6SUDKn?=
 =?us-ascii?Q?nhPKQakaSXXcf3Qm77wHNB161cjMqe0wUlxl+YbpU3wNXK6CZOA1ts34L9TM?=
 =?us-ascii?Q?4GZvCM1UUtwMWbDv2c9iyBGbik76NcnXnjwQjLmZswIuhuikCCytAI3c3onO?=
 =?us-ascii?Q?VqAGq7PQ15Z6cy62PTHg3vjiRkrJBM9JXsXbY6n+HK1CoundVB/o0hd97w+t?=
 =?us-ascii?Q?3QFvk79C5/p8iajUMLonHIXofFh1tSJ8HAFqX/ZqTqS7iZvGzFOGHrXghOkS?=
 =?us-ascii?Q?cJys8epy7KI6nJZU0rsEkNNoJz3PMKVGiRw8tvDTyqCHkho3VB6sEKq0snn3?=
 =?us-ascii?Q?iCmqQnt4Pm8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA3PR06MB9863.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q1NRAinHGOTLAP9fiGOglHH32Rl2KJG5D/hSEiNwSsp1wWoQ5s4/QM7Kc3Ri?=
 =?us-ascii?Q?19jUVeifLBzF4bI/0ekcVj1QrPkj2/x1f16HWdSnzdv03U2C3eF6bpLplqJf?=
 =?us-ascii?Q?+wHUIopwEIh72LM63C0TWc6dBvHNjA0A/UaGSMKWuuXemQe/CIK7K7YJr1ya?=
 =?us-ascii?Q?ILOd055SRFCiBtTB6ZuY1WMPjTxpTC2dW3rAbljEzQ+GCl9yf890RXZxUEE0?=
 =?us-ascii?Q?C75KI052gpms2A9q0mGrC2D3/F9Hb9iyqAnbnEanXeaKYkNovqpxkENvJjv5?=
 =?us-ascii?Q?h/XCL8pn35iy9co6BhMRgGZ3t6aKNgx8jF7wMbx6udYVDt40R9vbTv4BMGSN?=
 =?us-ascii?Q?ZSZ7yPm4D3KwyVTjKPNDHEkAgGk6lq1ByqvCiP7X/4T0j8d+BpIOysE5e1VH?=
 =?us-ascii?Q?TA7XzAPUfSPh/K3C8Ie6l3ztq65fmpjty+V9DvKV1aAT9jO+OmdiXPlFsD/S?=
 =?us-ascii?Q?p7I8e50AGoRIleC7tdkkIhfDkB8J8JrRcn/HaOCa5PPc4O2hYTe4masqVw09?=
 =?us-ascii?Q?ZIRcsSbLA8D9GmymgnI1Gc1m1wis4koUtM2p4aCUJCUXVCFvSXsvpEoy3t2P?=
 =?us-ascii?Q?c6KYXeuh2fqB5s3ugnad8kKOlKfeH4/6aaEfNZD6K8ZbTPROShXLByCqxyWq?=
 =?us-ascii?Q?Q4lEfMYfETCMDjZYyTXwvRHwbu3llup55lE8PlHtMJrT4f/tGESTaQe50ODT?=
 =?us-ascii?Q?YUWf/lBuZrl74JG7A/8w7FxlAcP2xr5s/b72xmuTokqQn2Bcr17YM4LQF2V4?=
 =?us-ascii?Q?71+EiEO8LCTxBfKDQ9ztqpPLbV4QjDOtsA4XZY76rxzYw6UOJbS5fEUMoEIG?=
 =?us-ascii?Q?4DB7w0pReYgRiXmlUwZ+Q2IbsTsklf4bWMzNlNg8Y20x72b2NrX3NLzdiBG9?=
 =?us-ascii?Q?qpn53AbC93HB49JvXprwsUY0zmE36EVBGKGnqFdsujLzJKzfSMvlgWV6oggH?=
 =?us-ascii?Q?686WXFiDe6Hr3Ztbo69p3CgTUnA7Itp6gr2WyTAyUGIHz2Pfk7my/s8tb3j+?=
 =?us-ascii?Q?b8yZjytIaSsc4PYS0OW/0v/nei4z1Sx4iqT0Hzkv0nGKPSKtO2rCU6hOBwMg?=
 =?us-ascii?Q?qqEDLi/v1LiNoQMPGjCHdx0/ni1fma0S7F8ZUYLhTKtnhjsNPJq0Vnk9aSFL?=
 =?us-ascii?Q?/C/QT1Ih0vfllw/51jmZWAz2GJIgGngNGL+kpkcQsp4oHgB+zdUnZrnXNkxS?=
 =?us-ascii?Q?wyXN/AU0NNUTRAibqUuE9CyHIvIX6szThnp+cAUFzIY69bQW9P5o2PYaQb49?=
 =?us-ascii?Q?ixr14QVUOLZGhvoJKnk9ljaStG+mz5V07gamA/41LE237e5NRA5HWkDAravX?=
 =?us-ascii?Q?K+tMMYX3iW+AFdatbzOXtYAHTbqHQbYjHCOOutAzzdE9OGLUX8ur28nCBQ1n?=
 =?us-ascii?Q?MKr+yY97pvvt/jo+Q2DZzNRRS+/wKq6/02OcINhv0Mzjbil/jUdqvjzCt6LR?=
 =?us-ascii?Q?ez7F1LwiVkeAyNJ9fp6h0HiKzsDjdxaSiIIzrGREv1Y5Q7+EaGfkfUnUSSN2?=
 =?us-ascii?Q?GUYET+cFs4OoWx1E2rCtibgaGCQUvI9tzYVV3/GAXGKnT7K+2K5V8gJEGUjV?=
 =?us-ascii?Q?WQ28V7K138YXdfOmYRM=3D?=
X-OriginatorOrg: cvut.cz
X-MS-Exchange-CrossTenant-Network-Message-Id: 30000b1e-81cf-42ca-d792-08ddd197416b
X-MS-Exchange-CrossTenant-AuthSource: PA3PR06MB9863.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2025 07:36:12.5816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f345c406-5268-43b0-b19f-5862fa6833f8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i4WugVU2KY6j5O9PnODQlEYy5uuNyBx1BNuhOnrGppIIAnswK7gOiLYwGiDQWBQx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR06MB6666

Starting star was missing.

Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>
---
 Documentation/libtracefs-instances-manage.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-instances-manage.txt b/Documentation/libtracefs-instances-manage.txt
index 4e5c645..72f177a 100644
--- a/Documentation/libtracefs-instances-manage.txt
+++ b/Documentation/libtracefs-instances-manage.txt
@@ -42,7 +42,7 @@ The *tracefs_instance_destroy()* removes the instance from the system, but
 does not free the structure. *tracefs_instance_free()* must still be called
 on _instance_.
 
-The tracefs_instance_alloc()* function allocates a new tracefs_instance structure
+The *tracefs_instance_alloc()* function allocates a new tracefs_instance structure
 for existing trace instance. If the instance does not exist in the system, the function
 fails. The _tracing_dir_ parameter points to the system trace directory. It can be
 NULL, then default system trace directory is used. This parameter is useful to allocate
-- 
2.50.0

