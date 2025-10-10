Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021110.outbound.protection.outlook.com [52.101.65.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29322F5331
	for <linux-trace-devel@vger.kernel.org>; Fri, 10 Oct 2025 13:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.110
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102329; cv=fail; b=MdbmTLOFhW0WSG9FoDQAtYLMbtRFlK4fatLOu48bWNRhZCHuf+yApSJpQSR0XbKSgGnPdg/G1rYDaE5hrWaKb5Qawyf7NB3yFkfxgej8v/xF8BW/oChrbiJ+o2qJkpRQYgCNPCazK2u2TmZXCdH9bCq8/3lP/gJbfbPgIensEXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102329; c=relaxed/simple;
	bh=PGGO+Ys7j2v+poyheU79T0iL61P748I6A11IOaxl2p0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ptLrghtmINEn/8H10E0kNmLDx6PWCaju4ko+90hRBYrkbIMnKMOmDw2s9SMzIuivKRo++lDl/UWPbKj/bRFfMQ2EnJzyshGQ3prkIPYoWus7O3cRmUPjFTWwJ61c5PtNOF0n9RKUkNVb1Tc4XY6BIjmwY/P62lGdOkoztnD4k/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cvut.cz; spf=pass smtp.mailfrom=cvut.cz; dkim=pass (2048-bit key) header.d=cvut.cz header.i=@cvut.cz header.b=Uew2IfK8; arc=fail smtp.client-ip=52.101.65.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cvut.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cvut.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cvut.cz header.i=@cvut.cz header.b="Uew2IfK8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DjAnKd5KMwlUwtYc3rkBrZI6HCOK3ULWAUQfpCAfM00SggrZEwHrvBL89s7+St+YA1+WgvEYrQ84QHClZryEB1AlAiT+KSrcLxxMKyCFiVcF1kR10Z/BVrllLn15/NoaiahuMphukLDoGcZdIH57Y+n7TPMp5WQJMbL4+hLAUTIkPx0LI8yG71BhUz4n93WJc19hP2EHP0PqArgOrdXyIdlnlKgsvHDWV9jg7T9m4fL5kpi1Wf5Mh9CEzaSAQ3oy7kw825NBcH1MH/uOVaCat+dofzhBygoSgBXG9JTav/XqTxzEDXbHa/J6tiCFLk8LOFKdxgHF2bu/R+8Ry3uqVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mAnx3kztLBhEeNaHBX2po3sAxsH68mbGMsa2LZBcMC0=;
 b=nx5l3BfUtkKQwMZ3Mol/h69aj/6L9jFeGlrWNdIBn1BEP1XWLX6ShXcRCXI6jLKeBzn3/OsVE5h1OLfhPZrF6tn5OD54b4/bICgY9dQXKu4qrQ3jt0BJGwOgNWyjw7iAzHhL+9twRHARg9EqaeV8ZwUQIWu3Biv+GYliKnZGCYHNc68eJ1p1Ys3wGnzjW8jiNICprRVAgfdbC4a9giumJpobuxxggYXvDjTAjYPZPZjMS/lLdP5XmElPR5kJWe/wyy3iyf2AYfa+upryUFt+gHR260eCJzSo3zpHkQsQ61gp5Tx7TWHU1XypeMqP0O+5nr85EVTW1f8iuaO018ShpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cvut.cz; dmarc=pass action=none header.from=cvut.cz; dkim=pass
 header.d=cvut.cz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cvut.cz; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mAnx3kztLBhEeNaHBX2po3sAxsH68mbGMsa2LZBcMC0=;
 b=Uew2IfK8FAzoQmv02pqENVmLGos5uV5RycOzPJ7/AxAavnYr/6RXdFo02nRz/vqF61Sw9K8Y3MhWQZYAyteHQvmNw5VdNbaiPUzM3nKWToTTJSjZWRo8hA/dfa3hIRYN7LePGs+Q6ZiUOaajoaGdp/MdkOiZWH7touNVXtU7FbGc1vSD/wOUTl3bBScTbLB1h2zdl/iWoqm1hHICDdz4qi+evyzx8gXSR+66YA97v2+KeIz8exUXuVn3od6B65b9oZNrtcZCqlrgxmJ5UWMbIJGSKw4a82hM+uYwkTgY5gkfePejdM9RH5Y+yDU9xLeBCal7Adsu2gW09a30ELzreA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cvut.cz;
Received: from PA6PR06MB10275.eurprd06.prod.outlook.com (2603:10a6:102:520::7)
 by PA1PR06MB9750.eurprd06.prod.outlook.com (2603:10a6:102:44e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 13:18:44 +0000
Received: from PA6PR06MB10275.eurprd06.prod.outlook.com
 ([fe80::66eb:4fb9:84:d479]) by PA6PR06MB10275.eurprd06.prod.outlook.com
 ([fe80::66eb:4fb9:84:d479%5]) with mapi id 15.20.9203.009; Fri, 10 Oct 2025
 13:18:44 +0000
From: Michal Sojka <michal.sojka@cvut.cz>
To: linux-trace-devel@vger.kernel.org
Cc: Michal Sojka <michal.sojka@cvut.cz>
Subject: [PATCH] kernelshark: Allow building with CMake 4+
Date: Fri, 10 Oct 2025 15:17:15 +0200
Message-ID: <20251010131715.1123934-1-michal.sojka@cvut.cz>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0107.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::36) To PA6PR06MB10275.eurprd06.prod.outlook.com
 (2603:10a6:102:520::7)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA6PR06MB10275:EE_|PA1PR06MB9750:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bf2c781-42f0-4b0a-7b2a-08de07ff8988
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|19092799006|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eycsFHWrnFeGQKzqE5PxEADkLKEfqtDRTQ/GDw9c9GoBbEdvC1bKxexIbI0f?=
 =?us-ascii?Q?C4Bd13zPbLwGhUg9OFrmm15Tg/tUzj8YbDFC5haNoyKXi6kzr4LfzIBq6vmD?=
 =?us-ascii?Q?xZiZewPuO1t2NrGEs1V6X7gSeIPlUjcG0BVHNjW6yifMhYJ4yqQxYl+T9g7X?=
 =?us-ascii?Q?f7e0QxDWek5rSJKnLdltr5TKT75pt8VypKyKgcKOlPwYqjMhYTR30/lTMWmN?=
 =?us-ascii?Q?4JQxenNo24WyIKthKEK5O7wNh3rGWCj2IMKLKl2lYOeoDCxFu3f8ELCs6o7J?=
 =?us-ascii?Q?k0U02my2684lJLxizIWy/WEv6/7xu2bYcVtkLhUdRXCGf5Bb57NcrARvpXkD?=
 =?us-ascii?Q?Lo1pwAGtHcask+/xijVEdgkJmvdf+fy2wxgbooL6ACYG36GTFZVjqt5tDUKl?=
 =?us-ascii?Q?JCJQs6QF82Qj/Bau9c8zXmhFAYR+U8GGgPr2besEVixVjnBlAB58Kn+o0ckN?=
 =?us-ascii?Q?6J4+keU7rNAXmbRtsG2GJ8bPeM/F7J6IBzLxSWIs1WcVCWrMer0gBi+wy+Am?=
 =?us-ascii?Q?4p/J9EcXSgWtgsaHluQbtNKDyo3plHZKHE7opYojtSp6jlIOEr1WOvHDpcJH?=
 =?us-ascii?Q?uqR1gYOw44pIoJywA7JxsQL5mBRW9YXyUyNZuQ0O2hIP902MavEteg+JGYrk?=
 =?us-ascii?Q?bFgvv8mAAPzOckt5TOHst4EOndD+tjYERbc4UATXe8BqJHTrX2jb3+JWxJ7f?=
 =?us-ascii?Q?iIDFW+JjxQYReHLcpF/OnIRhLTXPrFVoxMCj2hXMlu5VFmBHLvkGeQj+zzax?=
 =?us-ascii?Q?HtTTBGqOp2wtAaXMD8Ze9eh5SGrstXDF55/ukybXspXXkWqx0W3cgSMF/sX5?=
 =?us-ascii?Q?HKK/A/M/08X6+9u5cXFQvSb4sUOZBSsH33l9eWWyw7xtzgKUSwPBqwaEQsaC?=
 =?us-ascii?Q?ONUMX1HiaEZ4bK0wHmo36r339ukE/ID4hIapJfcXsUUcn5w3VCnhd8js4N9u?=
 =?us-ascii?Q?eg3fMCdvGptFC+uMHkfpBRzFCHRiu7S2Klq6mtZRdKBzk4QpDhIQ1Kd2IVvt?=
 =?us-ascii?Q?y4iglkZgKdBPNWcHPSNV8sEgn2I0dKoLtL3KcTi/ZapINr30d9cjHQbW4t7p?=
 =?us-ascii?Q?txbCybBeVXW7sOb8zShLtgHzS7YsC5jH0FecVnClnss/BeFR+pJhfX38r7yb?=
 =?us-ascii?Q?NedyhibgO9tT4355nG2qjrxh2mfGWV03aUI1k/szmdaTMAt2fosN92z9knVc?=
 =?us-ascii?Q?xWKCqxTPCKzukQzdtNmaJ2LNWZy+s2msOdZpQfqs2NpSynl1A7ZKq38VQAA0?=
 =?us-ascii?Q?yqNKNRTuarIhhrpC/9QRnyyVT4WdsKr7PH1s7xwNrOQUI9W03NgVfgr3Wf4E?=
 =?us-ascii?Q?uAQivoqGWiQNQpzzDzjnz48wSHaRt6ACo1lKrj71xzY/SJ+29ZfmNuVA8oAc?=
 =?us-ascii?Q?rgi5kEdAeeUfhZWIOS6NDOeV9UEejuHN5pHYQE3+zQimx0UA2w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA6PR06MB10275.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BXiUWLsjsiKmO7GQMZZfoPSt7OrgPIw46RXVf0GdIA49zLQeADmdgEvt2d2P?=
 =?us-ascii?Q?dkjkpt4fGnkOLNZMTGwgNYZwOfle3qA9DiaSEO4r4J1VzGDK2kkxoaCzxa4J?=
 =?us-ascii?Q?Dnu/l6w0vRC0tIyqPu953MGEEButeQ5XlZ0emlPPmGJGgpULdUUyzaJjsHsF?=
 =?us-ascii?Q?BDF7TLnwrI4w7mdu9x72MwdBXOTwwHnzRZ/4iddx3bXIw3/xz4khRvUtwDBf?=
 =?us-ascii?Q?We3dUv54l7u5qfP5F74FNevsJ97Nw1IAzzX4PqWOJgYcLRXOLonDDgU7TeOD?=
 =?us-ascii?Q?DXw4qILEUtOwDxHGTI+5MphU2Qq4EpjMWRtUF6Ufk2n74dbZMv9l3AI6BpXx?=
 =?us-ascii?Q?7lH9timVFmH6aZA+MZbKVEEOiuS2TWAZ4GUY4JP4ldwkI+yTE8jC4l46Yv8Y?=
 =?us-ascii?Q?kqtONnpHFsOypNYLE9XqyfT9t6L8KNk0fjNSCDM+u84dBCQzafwFS7387VTN?=
 =?us-ascii?Q?LBi1nm34fWOpixZXBHyRULSZZ2lVfZVseu0W9tYd0bZOud7lztiNNXHrHLzF?=
 =?us-ascii?Q?zQHHOEPgP9P+AgZDLjGeU5eRuu9ehi1tux9j5COJ+Ofq3lNkVDOBsqKD6yuW?=
 =?us-ascii?Q?NdF3sN1FeSexzo+a0H7oAAvrvKLwgIfcZVtavi5jo/uKpO1aTCRCQ7BdHa8B?=
 =?us-ascii?Q?yQr63aXwHNNXsDNK+C02niBoeim13EsrMnN8BEE3dIV8UyrB1f1t8DE80Lo6?=
 =?us-ascii?Q?uragXYAlGHxFsyB2IjSAMVncotF6mc02rv4qSaBGHDv56oG65mNtxAl2bZcr?=
 =?us-ascii?Q?MiVaqWBIO5mTZH8wbtL+c7LktIUKg9oxqJjjqNqSEtpHTULWr96GwN/8ko3U?=
 =?us-ascii?Q?6ur7QU+q7wCI3oC/Gb6h0qcsBKYkEhsKm12pxZ3YNuo6C738Z1/pLF2TB9IB?=
 =?us-ascii?Q?wdDTCxLro3Kv65u4fP2C9JyRADGHRU/w+7WsNtQhJoNKY4ebvoLE8KdK5xCg?=
 =?us-ascii?Q?Xa4h3DboT1eKs6Pmr/kAQm2MUu46dK3GeE8n0YkNkGuzkqtQkCu+V8doUhbr?=
 =?us-ascii?Q?U0FIyP8gyY0Vc89q617LtzUf+VvTrrIDiJiSN/SH/wYg1gpngfAYOgC25lLx?=
 =?us-ascii?Q?YNdy8e6TAwksRCYQT0mhMX5GqCWhtuwiyiJoJoVDqBF6HrCOgy8nl74kXNAn?=
 =?us-ascii?Q?Chi1WH6F0FQhTn189dUIr772bpq+nSY1Cm1mg039JI4xROFqNLQuwZ+T/N72?=
 =?us-ascii?Q?0ZndJQ7wtFSYzapcvAGjBjFVI3rHXbfDIVytyzqkvXvcKUnSio0vucl6BnCM?=
 =?us-ascii?Q?EneZd9YWD/sV14CylExbbhfmCgyeWMSHyspHARYxNr0YOugX0lKnqVhULLkD?=
 =?us-ascii?Q?PmimlptXoIIdWVXwcLTch8sOxnnLhGgpVgDFpvk1m8yE9LQOsKmVu1TCYdCd?=
 =?us-ascii?Q?EpdYWHrvtPbh+ot9o9ntvSy6yMF+sYowQyWVjmZMIIjzsLVvBB+c3kxuo/8j?=
 =?us-ascii?Q?0AD3x3aYAi71AsGvaVK2OCPOH3x7G0zF1EMNSDDSosqgS3GIZRCCLx4AThIy?=
 =?us-ascii?Q?h2SEd4rpRFV1tuQ+2hnrZLtpk8c6tjNWS2xn0J7ewPn9sDG44yS8nuwqSlmr?=
 =?us-ascii?Q?Wh9zqyYrs6b/mGf26G8=3D?=
X-OriginatorOrg: cvut.cz
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bf2c781-42f0-4b0a-7b2a-08de07ff8988
X-MS-Exchange-CrossTenant-AuthSource: PA6PR06MB10275.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 13:18:43.9834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f345c406-5268-43b0-b19f-5862fa6833f8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kmUZdB78aMVFkD6ILN4xXpXfmlD+4Og73MkQuHTmCFuyAsPAXBspakcBlgmXP8XQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA1PR06MB9750

CMake 4.0 removed compatibility with versions of CMake older than 3.5
[1]. In order to builde Kernelshark with CMake 4, at least version 3.5
needs to be declared. However, versions older than 3.10 are deprecated
so it's probably better to upgrade directly to 3.10.

To support builds with older CMake, as before, we use the "..." syntax
in cmake_minimum_required [3].

[1]: https://cmake.org/cmake/help/latest/release/4.0.html#deprecated-and-removed-features
[2]: https://cmake.org/cmake/help/latest/release/3.31.html#deprecated-and-removed-features
[3]: https://cmake.org/cmake/help/latest/command/cmake_minimum_required.html#command:cmake_minimum_required

Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>
---
 CMakeLists.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 6aa1a5b..54ff97c 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -1,5 +1,5 @@
 # Check if cmake has the required version
-cmake_minimum_required(VERSION 3.1.2 FATAL_ERROR)
+cmake_minimum_required(VERSION 3.1.2...3.10)
 
 # Set the name and version of the project
 project(kernel-shark)
-- 
2.51.0

