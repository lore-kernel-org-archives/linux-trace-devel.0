Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2110.outbound.protection.outlook.com [40.107.21.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A4113DDB8
	for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jul 2024 14:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.110
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918283; cv=fail; b=HIvvaX+Ra5951wHgPYRQM+ce9B/j1941sexyUudSZ0SKItbJcHs3mwCJW/yc9IwrI7wWAfMcfuuTl9C1k+2nKasmt7eLn1izyY0vaadVm0fYYogMrUfFC/gEICx+4c+P2fqrs89ZvVQBDgIdCzEwHfuhsJLkwXIydyPPSezD6s8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918283; c=relaxed/simple;
	bh=0uYElVrjN7SOtj7s2R9aabbw/0FFc6LpAlsIL6fK+ME=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=cUS+Qk7nSpSOi23lsT8GwIHszPFlo5l7VJ/X+5xwmsG/AqLwdNJ3BaFdyt186byJMwA9lWk0J/Ma4H+gKskapFbICsr38UpJG5y6nbGc3elTQ8H2n5AIoj/HlB9NrG0U0DezWh3nPVvnBrXCeh5XFPrfV73gG9Of6oIKGukQ88E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cvut.cz; spf=pass smtp.mailfrom=cvut.cz; dkim=pass (2048-bit key) header.d=cvut.cz header.i=@cvut.cz header.b=Zyjb28jH; arc=fail smtp.client-ip=40.107.21.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cvut.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cvut.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cvut.cz header.i=@cvut.cz header.b="Zyjb28jH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZvMzfDd9Yqy1O5Kq4QsChpenam+YD10FaLtAUx1FVgqRwCQQbJ48w0CiXhBl4JPFGn/YTdKbGiTJEbCTEOi3Ttmo0u5GcysCT9ioyP/2r/HqWXsPRWypD96at61KX19g1OxmrSZdMbd1aeBcV6+nX4SY1JXinVPGE5KU0/9NriXbxDQwnT/IboI+z9zbIcxjD73Q1aGb7W7JnCXv1uVfbaAo92UJyRjMOwoxr1Y3kI0s5Opk9KWvBUudrivqPUB35azdUI77OmepJsGQC/6u0wkbQ6MIDXBTlq311ulbv0W9l8/fVE/dZFjqT9nyWhrrw/KQS0IrComBPrvqGGBuzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PEdeZBu+qmHx4gPYROJr6ZYQAs4Tf43vc5hEMZyICRk=;
 b=iKxG2ioXPnTgCXV0iUedYi/BWo/JgeYOUvvdWua0EMcWlAJyjg/bYZiD2fCkVPKrVzasSNQrN2UbZKyhQtWfQNXlwB094y828xB49LXfJZynWu+YBq7z90PD7Jorrbc6DLusNz4jPu5PQbYL8r23Pw9b5hAZzjDbdM+VWzpkrk/YOm/AO97VxtNr0yWwXw1y+8Mw2BfBCGnYEMh2odQDJpxERRqmhWAhQBA3wNPeWK+t3nOmoYhspSd+65EH51CHbMVszrRBYYDC4VNYVVHsqn1mK73nWb0AjxBk7HC+zznwN0b6n0e9AyVFq9r4Z/vCXaG/9T2uXos2PecI5/FV9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cvut.cz; dmarc=pass action=none header.from=cvut.cz; dkim=pass
 header.d=cvut.cz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cvut.cz; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEdeZBu+qmHx4gPYROJr6ZYQAs4Tf43vc5hEMZyICRk=;
 b=Zyjb28jH7tJo10DX4SC3azYlF+B+E/yqAIq2kJqy49SkcBXLMWa++RTVj+sdKd9qttR+MG0xJDpkB4MJPNUWkcEdcBvRd75xIY2CUXvnuD42M4QkmdA5ZHVu7KLPHRE7SsBCBXn2ri+MInnZSWbKcVbor1mB1C648iGeZorXAWLE8CpLeP7Pfet0CBGKiVl9JHS2mRjdqNgdbk53/QozWFQj9DICJ0b/ALQsoRLSUWv3K3/O831VHhQVgqbMGAkHPEzHhFmoVAcLJBrNb6z76AJH4E0zPL9PMQ/XeoJmFNspU7WWeQYnvgYFqf1VXnPmqTpewWnx85Jo4MLilqD5pw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cvut.cz;
Received: from DU2PR06MB8311.eurprd06.prod.outlook.com (2603:10a6:10:2d6::22)
 by AM8PR06MB7393.eurprd06.prod.outlook.com (2603:10a6:20b:367::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Thu, 25 Jul
 2024 14:37:55 +0000
Received: from DU2PR06MB8311.eurprd06.prod.outlook.com
 ([fe80::c5e7:9cbc:6bf2:3f8a]) by DU2PR06MB8311.eurprd06.prod.outlook.com
 ([fe80::c5e7:9cbc:6bf2:3f8a%7]) with mapi id 15.20.7784.017; Thu, 25 Jul 2024
 14:37:55 +0000
From: Michal Sojka <michal.sojka@cvut.cz>
To: linux-trace-devel@vger.kernel.org
Cc: Michal Sojka <michal.sojka@cvut.cz>
Subject: [PATCH] libtracefs: Documentation: Add missing documentation to meson.build
Date: Thu, 25 Jul 2024 16:37:32 +0200
Message-ID: <20240725143741.2415412-1-michal.sojka@cvut.cz>
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0004.eurprd08.prod.outlook.com
 (2603:10a6:803:104::17) To DU2PR06MB8311.eurprd06.prod.outlook.com
 (2603:10a6:10:2d6::22)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU2PR06MB8311:EE_|AM8PR06MB7393:EE_
X-MS-Office365-Filtering-Correlation-Id: 92f48125-b60d-4688-8958-08dcacb75efe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lWeC3aJV3iPry6nb+orlKTR8kE/0Y/X6br1nBPMrTaSROroeqsw49IAX9fBl?=
 =?us-ascii?Q?5snEabSiFWhx6zvLjepRdXRa3nC55tBG0oU3yiIZxGncygDipIYRn7On2YGG?=
 =?us-ascii?Q?/VdxYBaKo8AKUcCsPRbPLVco7UsT2KHGPK1aD7rOey9kuiC1LOqESbeFNzZo?=
 =?us-ascii?Q?Ks4FS4mCmlsaCyk+yMlRcYtdlwW7LD1RLX0WtUdOXVDmp/zmBfrl3f83Fp/u?=
 =?us-ascii?Q?Hi+/6udhFawZhJnigDcIzmnVpDHnEcoCcxQgv8FL8eg7fh0lEQBiAVunrfZ9?=
 =?us-ascii?Q?zi6et2cQy8sTzxCK7JxAwtsS+6s6FlJFKnS5siyJztMJSmnqUJZhrVe4uLew?=
 =?us-ascii?Q?ng1niGAmrFDU8ox41v4AhssXt+7qLU2qla/Hv21BKV2yUEHCbcgQyeaNfgSS?=
 =?us-ascii?Q?uFlJuBZAV2tF+RIUHAAHsGhu+mkwVme79fzfwj8Cld0wJiAcAMhUDWTLcciD?=
 =?us-ascii?Q?cqVTM29LPITTh2BYxPzLa5jQkyY4aL8a3HIPukB41+Cjd8O6Re4mmZhRcyDw?=
 =?us-ascii?Q?B8U0VU8JqH7fFmr4fgIv8yrEwRuh4F1B2AuG/Yvd7i57Y73gKyqHTMRV5HHa?=
 =?us-ascii?Q?W3NkACEndYjMddtNyByNd2ggiae58Z514CFWIjXfEHHz4U7ev8aXCPgzoezO?=
 =?us-ascii?Q?PHUDx7TMLMUIARKpgUVnvuLEyZ9mPCXVW+aQ0ZCsRKQPyb6mtaTdC6+nSAH8?=
 =?us-ascii?Q?uz0BJ1aUP/5voGODnhXxutC5kSGbSvmZROqxjML/gFhlolHUwkfjuoCoHLkA?=
 =?us-ascii?Q?RZRz9854g0VMisIRQaTvMNzHcE3xn93W20ydT2Q9wW9t7gnzKyhgj9bQz+Mj?=
 =?us-ascii?Q?RfUoRbOzcJtBp0wAyZioZRAD4UPAnh9NKiCtWllHtF3NaumTzqPTd7aUVH/Y?=
 =?us-ascii?Q?mCHkOFgvmY23Ks/WDPwBnC0Zcxb87ggrWjPdYGMdWsRrxlaSXdFQRxJFwNHo?=
 =?us-ascii?Q?zACtZQzx29+2KhRSsmsVjxZD2MSES7P77rPo9sqLs5hHMmgYVgSGivcXI8K3?=
 =?us-ascii?Q?u3LHdxhe5lirgqZtBPxQP1tDsgoahDg7Kv7CS9/Gkv0wWWUmwJgkknOuqI+L?=
 =?us-ascii?Q?4MmOI4WVKiXUe5ArZk46a1mQnPOrN0SAOY/7EnVmUA0tRbT2JdTclXYelzgt?=
 =?us-ascii?Q?nL1LpAF+yjUn86G+VTzHRSyY58SnPz/pxA6ZehV6FSw66JHwBisHuEo2Dk42?=
 =?us-ascii?Q?VWrfD6LMLb+suWCl2fCNWS8oTofwK2OO6o9M93+RkrZkbmbqvtDLqm2bxasK?=
 =?us-ascii?Q?C6M8NRwFagXM35bYmvYoQj/LczSUy4HPZXC1JOJ8VrJoLzo/gmcelrYThiHc?=
 =?us-ascii?Q?PhPmcpbFoQFOYxoAgF4tgsU+EnRnJISk40WL5r8KgZEzuw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR06MB8311.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TG8wbFrGhZo4oynZ8XEWTRVoVXtzkLYjPoh/e293ut+7nbzU9xUAdeeAVyJ0?=
 =?us-ascii?Q?OCoqLfzGQT12DU5adBA9EypD4kxFPbBCJ5pf9tJxYeTUS5yoWmi5JSssmwdm?=
 =?us-ascii?Q?Mf23/rQHCIfw3D1PnxWTcAhKIjn5Lu1BBOEL9fLC1f4LgknlcViVEJgVPpXM?=
 =?us-ascii?Q?XyaFjxAKaXHjzfWF6/rlSpcmvh5LWr9MFwBMI/dzNeLjFkK/yzA/cFzS2HZ6?=
 =?us-ascii?Q?fFFdquJgGP+HrWjquezr6G3fixWs+SZvz6bL76KCfqKpqQmbUw7OysX0IexD?=
 =?us-ascii?Q?SXnrl/e9ofTJANPuKHr/Go4I0Efa2gE5oNAnwWkJid/aGjGEbY4zTQiZeJAX?=
 =?us-ascii?Q?ZwBHNpYNHrZlWIosKK5gegsc7gcQD6Up4EvVgAWkvuFPtLsX9/WaH1mQ880M?=
 =?us-ascii?Q?dRHdeL0esJLVEuXzdlTz+BtSH+muu2aXoPbn94z915DxDsIYId/kWyZDGvQp?=
 =?us-ascii?Q?6Zic3K76x0VGapOo78nF4z5102iuNJEHYuaDO+G1ig84JzO/5i1H5D/2UA/L?=
 =?us-ascii?Q?9rByOt6ucL8OnTXEMDSxf4STQvFturpE9BqLwOk+BBSn3gkfkq3w5+49nZrr?=
 =?us-ascii?Q?Vtg7dTTstNkGsQRIM77rX5s92XUhEuJxgRctgThYVlJfXm4+iRTyzqpuk5KA?=
 =?us-ascii?Q?5Xyb4Nxp5mssrFSDdKbIK19M/dEaStWvdT8OimPF3edaF2ekbCgruTevxRVf?=
 =?us-ascii?Q?t8VGWsgRmaN3UulcEdXwfBfnMe6DjhUxar+BBs3WfSmFiWEl8NOkxvzBHppf?=
 =?us-ascii?Q?XHgTQcD6PCgWB8a0IJ+vJQi1AExcQ7T418J9Zf6fv5sueEBC17NgSvJAJixW?=
 =?us-ascii?Q?AZm+TOmRNGchUJctL8TKKU9jsEUFTlvqO27UleH1gRhym3koSi0M+MAUO9n7?=
 =?us-ascii?Q?kUG92A9zQoKjgrEU8SzhL1/6taLkKq2EKV9YUU8bPpdu2X8hnIj8uj4WJidt?=
 =?us-ascii?Q?eeuGLn3GBG21pmnihVT/69X7xDbbVxUnMaklY+Ak8tz3Fm1kavO/7Pr4tkbT?=
 =?us-ascii?Q?LXy9G9R5erBIsMhbHD/UG04BqSOxQ8g9jniDHdZ3fGCV04YGAfo//EK4AesL?=
 =?us-ascii?Q?zVDtXvPA5EdaY2IDgl4551RT9qu0SL+AbRfOAc+n51VBIiI4p8zVkHxUn/Sd?=
 =?us-ascii?Q?kLgWQtbf03LYSM7U6L3nZx4V5n9nnHIgRIZp9Ubmc4hIs21TRyI8Fr6mtX1h?=
 =?us-ascii?Q?htxQXRdI6JRCt7/SsCgpDEtljdZMK1KRqsn0st9XF4EltmlaxBodFzmdAral?=
 =?us-ascii?Q?GMi9eZyrqtqgGmiRJ1ojK9dITFXZE0HJgtTuVy61kDtYFoIGFVniTazwK1/3?=
 =?us-ascii?Q?q5RvUbD4QJR+HRBpvTe3i6HuSuzdOpbdj/XAMwBcijj3hyE0lcMKTWRU8xAv?=
 =?us-ascii?Q?EPuXKChzsUHqdmr5xkmnFeQanx3nVoD0wFrqNFs4MEwbvbDTUNyRp/byvCC4?=
 =?us-ascii?Q?32lYVgYsdU95BYiWcVWvdceZQxmObx6tAAxiKaEEdFNnP86W283pIBfLfIqn?=
 =?us-ascii?Q?3cvO3eF6QDWOOMGxEou6XC9V8x+cfC5jwnFrqX4Klv7UHqMO+cSdqWppjp8p?=
 =?us-ascii?Q?XrpSbULSs4+DrU6nnPI=3D?=
X-OriginatorOrg: cvut.cz
X-MS-Exchange-CrossTenant-Network-Message-Id: 92f48125-b60d-4688-8958-08dcacb75efe
X-MS-Exchange-CrossTenant-AuthSource: DU2PR06MB8311.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2024 14:37:55.4327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f345c406-5268-43b0-b19f-5862fa6833f8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qd4raLp9t1adJQg8Y9SJfiIxvPFk5vxKe0NU+0yZjuk2DEcwXsFIx9cnkrjc/WyX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR06MB7393

Makefile-based build uses $(wildcard libtracefs-*.txt) to
automatically find all documentation, but Meson needs explicit listing
of the source files. Recently added files were missing from the Meson
list and this commit adds them.

Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>
---
 Documentation/meson.build | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/meson.build b/Documentation/meson.build
index efb78b6..473135a 100644
--- a/Documentation/meson.build
+++ b/Documentation/meson.build
@@ -6,6 +6,8 @@
 
 sources = {
     'libtracefs-sqlhist.txt.1': '1',
+    'libtracefs-cpu-buf.txt': '3',
+    'libtracefs-cpu-map.txt': '3',
     'libtracefs-cpu-open.txt': '3',
     'libtracefs-cpu.txt': '3',
     'libtracefs-dynevents.txt': '3',
@@ -15,8 +17,10 @@ sources = {
     'libtracefs-events-tep.txt': '3',
     'libtracefs-events.txt': '3',
     'libtracefs-files.txt': '3',
+    'libtracefs-filter-pid.txt': '3',
     'libtracefs-filter.txt': '3',
     'libtracefs-function-filter.txt': '3',
+    'libtracefs-guest.txt': '3',
     'libtracefs-hist-cont.txt': '3',
     'libtracefs-hist-mod.txt': '3',
     'libtracefs-hist.txt': '3',
@@ -24,6 +28,8 @@ sources = {
     'libtracefs-instances-file-manip.txt': '3',
     'libtracefs-instances-files.txt': '3',
     'libtracefs-instances-manage.txt': '3',
+    'libtracefs-instances-stat.txt': '3',
+    'libtracefs-instances-subbuf.txt': '3',
     'libtracefs-instances-utils.txt': '3',
     'libtracefs-iterator.txt': '3',
     'libtracefs-kprobes.txt': '3',
@@ -33,6 +39,7 @@ sources = {
     'libtracefs-option-get.txt': '3',
     'libtracefs-option-misc.txt': '3',
     'libtracefs-options.txt': '3',
+    'libtracefs-snapshot.txt': '3',
     'libtracefs-sql.txt': '3',
     'libtracefs-stream.txt': '3',
     'libtracefs-synth2.txt': '3',
-- 
2.45.2

