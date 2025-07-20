Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022130.outbound.protection.outlook.com [52.101.66.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD14119924D
	for <linux-trace-devel@vger.kernel.org>; Sun, 20 Jul 2025 22:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.130
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753049797; cv=fail; b=d4Cja4KXN4mUWbkAvyFxg4dZNLo6ZGbhBfLiKSJEBY3g5RBwjzRIpGdfBd87GbiwXYDTeisz4Jhmjt7Ue7AHbNZb8b6y/RpUWMdHGYH9/XnguhD073HVJY+rTTi8vdt65DlMenHZRVgbY1BDSZu07AWXBiPrH8kxMtCMKsLU0j4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753049797; c=relaxed/simple;
	bh=MwKRNJr+UCSGOn7ojg2cQLKWw09QfWt5BJQhdgOJcig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p2EHk5JuxNvW4vO8Uzg2KwsmSEh43Q6QRbYy+Oii3YREDl2/jNskSpUynCZ5bHxQPYh+8+q6Gh31BhzeTjbCmEmX84ADgxWOxWEY/hAGAVUMq6fYaWaTSQeyu1XhG7WfxYtD5xNCspAY7m0m3Eyrr0h7yFuFX/JpJb6Zp/uGGjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cvut.cz; spf=pass smtp.mailfrom=cvut.cz; dkim=pass (2048-bit key) header.d=cvut.cz header.i=@cvut.cz header.b=qATp+3hL; arc=fail smtp.client-ip=52.101.66.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cvut.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cvut.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cvut.cz header.i=@cvut.cz header.b="qATp+3hL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NsILJ9cZhLZZkxFo0hgL0Xb2uVDeTGQ4Q+UgvG9IV60iNhARnaLNBAXW+G2Iwwnj2yTMyTeiI4MhkbYaZXIBEw5E0x2vhQVF8V3s20JDA932ZbtDdt/WA6EJjqOmWvUT6+0roZ5msoIya1diAacMaIyMWh+zvWFKAp285nzqnANMbEZN24k+h9NNaBLA3oDZzs+nR5wjkKqC0oviAe53w+BQC3jBjfqDUPrTLeIxQjiLEmwO27AV5C3oKLexfD6QZQqoTyetUnNVEFuiMYAW3rHl38xTcR1D+aivizYM0DSWMEchwzxiz45cwOwF1KcrUv1mhsm4HRSGvmuMTv+eXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tm0Fdd+3SkeiXhHWyn6TQhye1GeSfvzjflxeMawMxuY=;
 b=Ku0U/TR1BGSUGHizhcP4o7CdATrR8YB6VDz/2PTNiRZi6bCLigVxxgUzu7PZPMisTJ42QJlIlguxYwzNf/WhyzU8X1EsxjG8hYtxAQ+gARDcF/0thcBwlVR3UntxNNxebU8uxrSiJge6yqRgTNHGeRxKeS1vQVIT/nGAAiibumar8mLnpVfyCAHnKS57wmnwrsAZxWzN2OwBF0qi/0FLIRXSJ4IYcKrNYTiFJ6By3zCo6dM7b5xOyCsw55WNkd15XfNZG9Y9gJVzYSTJ13DXBd29sFs3ykTkR6oR7gqM67b4X5w7pnEmSy/N+BVRV943rVrTM1B1gGXalNjpyuwKjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cvut.cz; dmarc=pass action=none header.from=cvut.cz; dkim=pass
 header.d=cvut.cz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cvut.cz; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tm0Fdd+3SkeiXhHWyn6TQhye1GeSfvzjflxeMawMxuY=;
 b=qATp+3hLZ1yt0kSP79DeS4WVxxPMR0GqTYhqEINkRsoBQWDnPRzEMOT3hLBYLA6pk3uXdWK5xUQnonWv1ceu0sF+ZGv4m4la7fu58uF6v2GkL2sAUHFyNftnFRetJWT98eqFGGUCwQ25fvWVSh7153DVDiG/uRoid8nv6tCIAEM5S9/v8NjiixhyO/Ys3i22X2jkR1oogfUBUb24bLO/+nuwFjEV1dGToN4ZIyDovNkbVQiwFWwN/nqUBTXMW+jxBw4FoqXg2m4IIVUAxUKkF+tISKHP89EjcnuuXUArnvrZe1bDKfG20aFVRSQg85j1Sb/jkIJb8xURFRNJSb8+vw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cvut.cz;
Received: from PA3PR06MB9863.eurprd06.prod.outlook.com (2603:10a6:102:4b0::9)
 by DB9PR06MB7322.eurprd06.prod.outlook.com (2603:10a6:10:21a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Sun, 20 Jul
 2025 22:16:30 +0000
Received: from PA3PR06MB9863.eurprd06.prod.outlook.com
 ([fe80::cd97:3323:477a:3ed3]) by PA3PR06MB9863.eurprd06.prod.outlook.com
 ([fe80::cd97:3323:477a:3ed3%6]) with mapi id 15.20.8943.028; Sun, 20 Jul 2025
 22:16:30 +0000
From: Michal Sojka <michal.sojka@cvut.cz>
To: linux-trace-devel@vger.kernel.org
Cc: Michal Sojka <michal.sojka@cvut.cz>
Subject: [PATCH 2/2] libtracefs/Documentation: Fix markup in the man page
Date: Mon, 21 Jul 2025 00:16:17 +0200
Message-ID: <20250720221617.695311-2-michal.sojka@cvut.cz>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250720221617.695311-1-michal.sojka@cvut.cz>
References: <20250720221617.695311-1-michal.sojka@cvut.cz>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0255.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::22) To PA3PR06MB9863.eurprd06.prod.outlook.com
 (2603:10a6:102:4b0::9)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA3PR06MB9863:EE_|DB9PR06MB7322:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bbba7d8-200c-4a4a-281b-08ddc7db13bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|19092799006|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FB9dI2BaE8ilDCEKFiD+KqW9h0hqgID3Zh5hCx8a3mtEEGpBR4HCFflN4SAw?=
 =?us-ascii?Q?N1jR/epOXneUGd4FSafVe43WYO9ZyQeJC3WY4MKOACfkW5RDIHlz1ZZPXlba?=
 =?us-ascii?Q?NQCTnT8QOwiTge6ZFKi9f7HkIUUdg3HwIG3dOs6g4VsQ+sgv5z4J+8e9+qLG?=
 =?us-ascii?Q?C4rpJ9n7aOkXxWm6O6zCx9Mk7RwTSrzC9RncuVjwCyaLeIBF3q3Gvc9UWhFL?=
 =?us-ascii?Q?G+73S0gEceJXYAKXWRyLjDjKPhLsX8m98njLIbGYPLa55iy4BBw3htKd+2Ff?=
 =?us-ascii?Q?rWiXdexmFblzsuTaR8r4PoZI+LhgGkbuu0pX2mpygqK8sn1jkMkj95EqLlj2?=
 =?us-ascii?Q?gnrUTUTAkHEEZF5mTRrpQFj/Jw7cOIoPhDZ+0Vnt3KBzwjeYXwIAUqUMpUHP?=
 =?us-ascii?Q?ZDr334o6wF3odnGh8pUJ5eDKb7wIrSdSAxYKZCr+2vR4arpDwdecoBZjTn9b?=
 =?us-ascii?Q?vhZkYka4n7CN/Jrd1TO7QJp4treeC17XJc6CL52gDygkwDNjW7abJ3Dj/beh?=
 =?us-ascii?Q?lQiDa611k9H75X580O+wSvnl33PHTWQ+WnFlezV90qiPz1ksUnOddP8ZlqwH?=
 =?us-ascii?Q?YH4hM1VoRsxtXxDDFGjBXppOab9/+Htl5L4Hi/Bsja5MK58HcfTdGVhF624+?=
 =?us-ascii?Q?3aBJFRSGCCMudTAc0qMZP99LpjGSWosM47HkdR3eHnJD+GEFAKqc7PV72/10?=
 =?us-ascii?Q?UnNRt+ZGqJn8EyjTVNBhXAnDvPH6fwghL556sWnsxbwEyX35AyYzAwa1kFVL?=
 =?us-ascii?Q?lp/eBS0epdfrzlt/op0j1NZjBXUjyfTuVtyTER4ORpG+pmKca7f1QbnYoB4N?=
 =?us-ascii?Q?/AgnS9EwYN+GEbLCZnhXunPG1lWXt0zBvHrXuhhISaZKOt5X/8+YB+sz+wvF?=
 =?us-ascii?Q?ju6YGvLYgl20SPZS7kW+v44AM6c8s49P4C2TCn3UQuiVENlDd7+6VzkC26XW?=
 =?us-ascii?Q?6BAQo+scCdmKtmCCXO8A+VPoiXY7KTRFB6KtzCPvMsN2N8waM97DYwIhaVzy?=
 =?us-ascii?Q?ccwKRLuUCyn54NdcV9X89fgspzvATB6mY9ZDTy/NkFJXeQunL7b8a9bQ5wuP?=
 =?us-ascii?Q?NN6xI6MbtZ8FjgdebIXUP/n99Bn4l6OlUDg2tlfRfahRSU5F7lWzUJPUs/VF?=
 =?us-ascii?Q?iDiF1EvI0SqAlMGLJ2Zh+TTrcDfY+WlIx3a4qkBPa7Ue1SPPj193NZdnz+xI?=
 =?us-ascii?Q?jGc8MmDm+zKKfEJTyPtwezY2YIs+MU8zC9T8wBsi54ypnvnoVl9nj6EDAsyT?=
 =?us-ascii?Q?+WqR6Cb3fTRAZeBr28sZ2R5zIrf3WgptVrH/X8xybJcUb5oF0Fs2/p+rH9gI?=
 =?us-ascii?Q?4nH6N9jTtdO5XuZ65NAdttMjed4JlBQvcRT4NNGo6d8HtnmB7J8pJCLOjcNV?=
 =?us-ascii?Q?h9vqSqBWCcChJnM38HX4LV4um20I/1HShDPlc7ls0L19AawJRk9rs2utlI+x?=
 =?us-ascii?Q?gF/deCd5cCs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA3PR06MB9863.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TTEwngimY/8xMW8dO/jjvVqTQz4aKnhRL4xIFpkr44VrTgeXDZgoGPntjoYf?=
 =?us-ascii?Q?ktTNFxVRqYBg1OzKYXf2321omItppxKOTv0UoaFpZZGN/e0cgZiKgx3HE8Mh?=
 =?us-ascii?Q?84UKm7ZbvlL57TUVEXEhd1u1w60JEMOvxwJOuJx0K/Auolo4DqyZ3ue1te+6?=
 =?us-ascii?Q?mkRjxClKo6WTmIYSD1WUR8itvuHJljpncotcb3okgjH/6yJTmJcmgYjsWu/3?=
 =?us-ascii?Q?n1hLVtbhZWeXva0iWdes+WFJ9pnNkM25zFTuGp6SmileaBU7rcRgE1Y6lsqF?=
 =?us-ascii?Q?pC8zG6GzhXwbd+wHDXw0MH02srLbp+YRpV0mRc9wSs9h1qNO8dp8S/H70zoo?=
 =?us-ascii?Q?ZhwVtknx8H9fc9vs61CLYXSNk2H3vAfrfI9qnpoDKlQ/K1SC9Vmb7y6sS5i+?=
 =?us-ascii?Q?QXzl8AH2v9+nE5wjb474Vu/zjTSmaroQi+P3+NWyfuwy4Zf21qqDHLLP8IfR?=
 =?us-ascii?Q?NvcQgGRx7zca7SCquZvXWvxmhhNpqKg/BCBp4I5Qd8A1a3FfjFlX/IQIfGCz?=
 =?us-ascii?Q?9H41WoCWL6YWkkrWyLmqHtNNmgMQ/HQy8mQB/NINdRL1OS7WNrMnUm+KBzto?=
 =?us-ascii?Q?wpBvM9n/Bq7xDYo7sNV2P2rP0Y11ZY1Yu/PyJ86OusTOp0f1zRWWQ+lH1NKB?=
 =?us-ascii?Q?37mr6UeSs2Qej6aIsmqT66cM81xmjI3BcF8C9tdFvADyrRrkidxZfnZtaCiN?=
 =?us-ascii?Q?qMKGsS2GiqinXITPEco3ZdE0LF6XvQVOQwWHjxyD3dNmanD7+wzgr173V0Iz?=
 =?us-ascii?Q?A4VX5J3GI3rd8ao43v+d09ER8PIl705DFXCVy9y30cGA4C4XsRYbyP+Q9AJE?=
 =?us-ascii?Q?v+VkAWRibr1iAgm3t6f9LeplJsQA79R5nwswaUVoRuVQ0gEWq8yY+3sEt7To?=
 =?us-ascii?Q?uuDD53/CoXgjNIJHwVUjj3Jwa7ogol0sOviJ+pp8bV/kLf5ptLB3I2kVEmIa?=
 =?us-ascii?Q?dgtb4/QJgIDO/mUTF5VcYsESnOQxCKWMAc/r97rWXZVXKOgoQ0E0sY+eUUax?=
 =?us-ascii?Q?FCEESJlrZqJUs4B2O+dQ6Ctdqjq585fClPNrsvjf/IDuBTnYFWdWRmx0sByn?=
 =?us-ascii?Q?NbONbYEc0hRcpHhZ6a6L7iBO7WwNKMEm+OxnUfLGyA92hYHOIGwJxisFfOXJ?=
 =?us-ascii?Q?SZ5pUEuaJDnYMS+jtwexDYmbjQ416Pd6N10PL5GCyHrR71KMHy9LRG+YzHTw?=
 =?us-ascii?Q?Bzl5Zy6FWQxu4p5to5xbdEA6/uLag498apLhLF5yMzbzS4nxrkMCS6KVBGG5?=
 =?us-ascii?Q?hhhAmM0ucDzUg2M0B8DzAq6Du6ZL992eTRDNR4PP0/8m3VD3Nrv60WeKasKi?=
 =?us-ascii?Q?3SYdWiGd7dZ8dc76oh1MIGueUKg1/wEbu8uncB6eHDAxnLvI1PcvaM6woY6Y?=
 =?us-ascii?Q?Ca3Ma5y67WbVn/I0od8G/BTMN58CqdcZ+lB33bKw/byS+7Z1WY1srWrZE34Q?=
 =?us-ascii?Q?XJY/hCJgzOm29SwuiQxXjA9QkPocEuJVYlo42xEDOhMcKfKu3y5Fe0Sq9HqD?=
 =?us-ascii?Q?vAphOawoRFiy/3KoqrCj1HbUyrNAHN7KLQP+MTVBSWDMDLFq+5IAfrvrpZAY?=
 =?us-ascii?Q?gg9dGvPir2Q2XYdLavLgoKgCgfPLmmucmU4dYxrP?=
X-OriginatorOrg: cvut.cz
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bbba7d8-200c-4a4a-281b-08ddc7db13bd
X-MS-Exchange-CrossTenant-AuthSource: PA3PR06MB9863.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2025 22:16:30.0766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f345c406-5268-43b0-b19f-5862fa6833f8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 77kwZLIqhWFJy1lTk70T+v+MJo1Nrk9z4jqU0N2E/J+/afwP63+E7IoHQ2gepUaK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR06MB7322

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

