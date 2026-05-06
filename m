Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11020123.outbound.protection.outlook.com [52.101.69.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BE121ABD7
	for <linux-trace-devel@vger.kernel.org>; Wed,  6 May 2026 19:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.123
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778094815; cv=fail; b=J224Xch1BkxYPlEeFhJPz3Gm7djMUX6Obqfjvm29mMqj7dOgxOCnemUm3IQfe1Yx6XAqlNhhYFg8elHqyvnG2+8+Uek9OyoLTr3Dsm6c8t2WArAWO/qMJuCVfXvX6pTr620t5RQgstZ6mqB/hU5HW4PG80pvJHQKqqgyrElSMX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778094815; c=relaxed/simple;
	bh=prRuAYH0ASX+Q/Njj7PNReUpYhMiEwMQnsoeBbjIhYQ=;
	h=Message-ID:Date:To:From:Subject:Content-Type:MIME-Version; b=H8a02NhmoC+srg/ue8G8sDF8h/uqMuWutu8jwZHBIn4EeZbIBzXQUjPcUVdx9AgzN7IZa2j/aqUNwAsVzOWqAK0uJ6MXPsqaKR1EokBovzuZwOSrxSiH2upYfPTMYiLKRHCp82W7mayRkGS/JevKXI5KfD5Ru/pix5bpoZaTWIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tuxera.com; spf=pass smtp.mailfrom=tuxera.com; dkim=pass (2048-bit key) header.d=tuxera.com header.i=@tuxera.com header.b=gDK6Z79/; arc=fail smtp.client-ip=52.101.69.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tuxera.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxera.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxera.com header.i=@tuxera.com header.b="gDK6Z79/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bVXOASPjKByr2Z9UD8dEr1UScSiSC7zBCLX0EJb19Go1/fw/8y82e4SZg2ODe3fK8P3hpfajt1LEmxzAJW3yHmcObywgm0LOoLCmaaYV1B+QBZZXLnX7tuMx74QpLNTXyNNT7zNdPByBiEk+Sp/XgRRsmJT9a0IpnogygwXp3Mp4UIFAsck7RofGUgRiplzmxLZhz1l2/iDEcryCf2sBYPchIoRWLDAOutff6atHkcrRsxQWuCfkzi3gwxotPhrdJi3zicIRyPDSjSflJwApyyjdwxwBK4GcOOho6ToTkLPlhsmlzQXFGaPRzq2EADtx7Gn+LVnABGhXee+7djq7VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O2nfI10HrTsZTwpaVlJO89/bw95FgIDSJFMpdQGdzQQ=;
 b=HDGTY53PYE2ok4A4OnSKDpn0u7HOyZ6SBliW0fVnruEkq4yZOefyOYjVuaMgda3lwP0J73ygPzaFoLJD6HRfqdXnEu2PYm0paUy6pXKzFdOFoS6c5Ev+f0oayc6pC992jkmEATRyetvvSAD1NVK+9TGLczoUHILhvodDLRBy0ecPLTjhmWa6gsywSrqulMq2ev8yCm4YDud0C2/muH5lLljcdQDhWKeSuzL31uCCdjV5iQ6iILsU3W7L5oJu85Olp/dgCwVl67ruWuRODE3PB1fugLdUVDFPILh2mWrXdoUelMSFbceZUprhmqZE4kfhQRP9ov9jasbjRFBCAxhRrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=tuxera.com; dmarc=pass action=none header.from=tuxera.com;
 dkim=pass header.d=tuxera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tuxera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2nfI10HrTsZTwpaVlJO89/bw95FgIDSJFMpdQGdzQQ=;
 b=gDK6Z79/lb9p0V7zQwug4Qr5mCt17IXtaPSZoOhzP9OKVR2aauEbgrCtBaBRYHGH1yo16Rlc1IjUOCrCT7pv8Zl5n2EOfU3slw0REiQtuh5iPLdpvdOObxB4Eu3QL7l4st1ApYRlc1j/BDfOi8IhSlh0/Hhi8CR7Zw5ZR1a8O4lZesBa6qqX5GrArOaU9UwnQ0JR5rWMBlsZNsbRMAvxll8+ckdsYo3N8Ahg/Iq+9iTxU2ElVJrrdShtstRGfKoywj4qmCr++m7AxD+K7EAiwGvcnIN8dHyZLBkc4QaddT4e/zXz4Mx3JRfJwksRUEy3I0HcmCUZFMv+Rk88nx86xw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=tuxera.com;
Received: from VI1PR06MB5934.eurprd06.prod.outlook.com (2603:10a6:803:c9::16)
 by PAWPR06MB9934.eurprd06.prod.outlook.com (2603:10a6:102:4c8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 19:13:31 +0000
Received: from VI1PR06MB5934.eurprd06.prod.outlook.com
 ([fe80::df0a:b9f5:dc67:c037]) by VI1PR06MB5934.eurprd06.prod.outlook.com
 ([fe80::df0a:b9f5:dc67:c037%3]) with mapi id 15.20.9870.023; Wed, 6 May 2026
 19:13:31 +0000
Message-ID: <aff46fb0-3c88-4fc7-b619-ed68c919338c@tuxera.com>
Date: Wed, 6 May 2026 22:13:30 +0300
User-Agent: Mozilla Thunderbird
To: linux-trace-devel@vger.kernel.org
Content-Language: en-US
From: Emil Thorsoe <ethorsoe@tuxera.com>
Subject: [PATCH] libtraceevent: fix type of args in test_btf_read
Autocrypt: addr=ethorsoe@tuxera.com; keydata=
 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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GVZP280CA0081.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:274::8) To VI1PR06MB5934.eurprd06.prod.outlook.com
 (2603:10a6:803:c9::16)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR06MB5934:EE_|PAWPR06MB9934:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ff52769-7c96-4200-7993-08deaba38fe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	D576ALuObNeZ10dEW88oNmbAyi4dNbj5UIAWurRXSCdlBRJqM2avuKnr4dERvyQY8MuUWyrKEzICeXqm8y81kQdT2DeLRRniI2YMxVXC7SOhl4V4Xw2oejVauKxOLIHMYs4v66Sp23WLFQ9M7u+m+cu4TEhJtDn18wrmTWV1Kem7Fe6Os6DV03WWXluVq75o6mUKKrr0Bdkte7okAJpvkCTMcB6Rc43+zukWiSUpIyhPQMFpl9kh/W1vOa+TmKXKDKwKGg/CSg58v7rvjpmO1IyUJ1mEw/qAZBOU0A/Z8Ggct1hWTvxKyiMzsj7u/RtCC/1CAaKCdOH0TuT845gDUpVUt3A/cyXmERlQkDYgJ1FgaNfeh4HREnmqM6/ayE+o5ETqE9fRzb7QhAyp0ha0cTTbKH4idWHte2EwiNCiQYc1bKZza6djs3DKAQ7dZsC4TglSztBsIRlH5Lg3fzPgAnd+UlJjgqE6xYyU2vycYt4AhHFN1YN9JUEeIw+OqIDe9ItwlV4peIExt9RuEtqeWS+h44Ce3Do3siW4Nc9d9c3UNv2tJJMCrK7s4xYOcX0iCvY6kq7m9ub4jX1nT4oyigtKeJR9g1ojYHvnmqtR5IT6Saw/61q1LopHhQC4QWw5TLykrI5WMQx/uzT7yrjcVpAkONPJe1KLn8xWv46RRHSld4ESfsaAc2fTrJYxkdOd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB5934.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(18002099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZlV4b1ZiOHdNY21hcll2YUNSd09aVDhGV1JvSFAwRm1FUGJ4UVBWdjZhTWU5?=
 =?utf-8?B?UXJ6dGJxSDFjdWdlN3FpQ0xRdVhrUy9HcDFTVmNXd1IwakIxVXpoTVVINkdH?=
 =?utf-8?B?YzlXNDlpZ3BsaEtTWE96cS90YWx4dnlWR3doRHFseW90ckJPTjNXcG1DdlZH?=
 =?utf-8?B?Nkt5KzFhZ1BHUXZaSnNvc1FJREdJc3JMckg5U1ZQSDZGQWN3Vld3ZXBSZHdj?=
 =?utf-8?B?Uko5bWxzWENqOGZCMDJvNVpFN3FEM2Q3d3pJYm85ZVJyOGw5enpzTndzc1ZW?=
 =?utf-8?B?UHk3dUgyclNDUXJhWkQ3RnloaXBOYmdnN09Obzc4Wng2NVFnYmVldDhFK0FC?=
 =?utf-8?B?OEZuOXBSZWNmKzZOYW13TjE0emZkdEZtYnptb0RVeVhUVHlZN0o2T0liMWNm?=
 =?utf-8?B?Z2t5NVV1d3NYUmRLWFB0STFEMmJKZjRjc1BQZnBtZlVtQW5MTEdUMWQwSlZC?=
 =?utf-8?B?Mkw0OWpacE5kYitlczFIaVZ3aVRzOWFXbkYwV01xSU5yVFFNeVE0Nm41bFJR?=
 =?utf-8?B?Y3FiWmV6cDhKYnNxSVkybThXQi9xSHBKOGlrWjNFZ3djQTJUK2JsU0ZaeWhy?=
 =?utf-8?B?M1dHaDVWZWV4R0NUanpTVTUxVnhsd1lEblFWdmd3OHBTRkYxTGJxWWtmeHhm?=
 =?utf-8?B?aHQ3d0Q5K2c3MjJpSWdlbHgrNVZVRVJFRDUzWmZ0RGxvdkVxN1Y5RUI4T1FX?=
 =?utf-8?B?bUZTQ2lPemZGQzhndnFXTjduemo4eDdBTHlUZEs3K3JEc1FEVm1mYnBoSTlU?=
 =?utf-8?B?YWZ5SElxSEZEaGhDVlFvQTlhZ2dEeE9wVURlNkY2WHRGdGI5ME9BOTVsWkUy?=
 =?utf-8?B?a1ZlNkc4Z1N0aUk1MS8veUV2NWxFVVZoRC9DR1YwbGE0L244bnBWM3VEcGVk?=
 =?utf-8?B?dW1DSko4UUp1L1NIRnJEbGJxcjJJNmZ5NjN4TTM1Q0dzcUJxWEtYUWhBVE9E?=
 =?utf-8?B?d29Zb1krVllBUktxQk9vdHRvYk9vd2V0MXdTdEVzUEFaQWRUdmhvUjhkemIx?=
 =?utf-8?B?S1VnWEo4MU1FUm9lS1d0TWplWXVaT0ozNlQ2d1poS2pZclNQYnR4aXVXY21m?=
 =?utf-8?B?L0lGTXRwWmpBY3k5bE9HSVhrbTY5UU1aT2pwY1lnUjgyQ0FHR1laY0M4K29N?=
 =?utf-8?B?SWpSL2JMc2ljTXljOFNaRFUwd0hhVXFTVi9BV3hTSXBBbUdDaGtlSjExcWtX?=
 =?utf-8?B?Vkx1aFE2YVBaT1VuVzBPcG5UdmdCWExINDlCd29wbGFTbm50MFp5WmZNUDJH?=
 =?utf-8?B?amJZVmVxWVljR3J6eUhhZGFGR2h4Y0tZeExKNmxYMEg5RkFmWjA4YzBIY2RO?=
 =?utf-8?B?eVMrUXpPZzFiSmdkcHFkbjYzaGd5Y0wwMllrdVN0UW50VTNsZFF0c01QZEdU?=
 =?utf-8?B?Z0VEaW82WTJSUjExQjYrUWlXMUxjeVJvWEY0aXNSNzUrVHR0SjJueHp4dE83?=
 =?utf-8?B?V1lsT2pUb2dMdG5KdWZHQ21GSmkrNUQvUXYwaTFETU0xSXhYMGQ5ZlhDUzBE?=
 =?utf-8?B?c05wVExhY1R0ZVBsM092azk0UXl1bjZhMGlHUW45bENlUGtobWR5S2pLMmlu?=
 =?utf-8?B?U2VXTEMwUFkxSFFYVXdLZlhtVHFjN3J3Mlh4b2YwbWFjYTVSZXhvYW9SanRY?=
 =?utf-8?B?TDZ4Z2NoMjNhcFNXdm1xL1o0dzd4VlJJR0oxYTJEaEdVR050ZmUybFZoNmN5?=
 =?utf-8?B?VXBrN0tWbFZDbXVpTGI3RGprdEcvYmh1ZXd0UmpTMjcrbG9NV3drek1kNWVj?=
 =?utf-8?B?WEVHd0NDWmwxQTk2NE01amROOTB1S1k5TlFDOUlLU0ZKZ256ZkptcE5rYUkw?=
 =?utf-8?B?NEU5Mi9GSU5scXY3RW1PZVlmZUJzLzJZUHlWZGplWFBuWkxxaUl0Z0RPUk1o?=
 =?utf-8?B?eUYyQk5abTVhQ0N6TDJjQW9NUGQzVXcrYUk2Ymk1RzYvTmIrY1UwNHFVblNN?=
 =?utf-8?B?akNsbVhLcEI5b3E4WFpYTzFweTY5eGgxTGZab1V1WklzOHNrVU5DaCtVWis3?=
 =?utf-8?B?Q1dtaXhwSk1mTVgrdUt5cU1JRTJ2SkhkcDIxZHBweGxMKzh5SVM5VGhkMVEr?=
 =?utf-8?B?aWZtMDlUSitUYkxuOStkYWNlNVlHRHFSNWtVdEVSbjBxUDNJNmluUEFKZWUw?=
 =?utf-8?B?Qy9vMGFHYjFsRy9ZL2hrL3FzcmxDWWxVRXN6UTNtUVk5UE00RVNwa2llY0Mz?=
 =?utf-8?B?eGI0MTFsZUF6NmpQU2dLQ2pKSS9PdTJSUXlzenB3c2V1UmxUY3pRQ1d5bm9S?=
 =?utf-8?B?Zy9ydEZ3eTZLMm9kMGpBampsQnlkRGlOakR3emRHdTNyLzhxZGVjdngyL3lh?=
 =?utf-8?B?V3N3empJSWdEclNBajJaWTFQUXVyaVNnQysrelhIbWNmLzhHd1ZuUT09?=
X-OriginatorOrg: tuxera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ff52769-7c96-4200-7993-08deaba38fe3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR06MB5934.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 19:13:31.6408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e7fd1de3-6111-47e9-bf5d-4c1ca2ed0b84
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: orTAs52I3AVwN/I5Oww46P2hErOCKUEdxcU+Zs+gFEjZ6g/z367bbNHUhV0O9CvfSl0tRHJUKxPQzRGiM8xCLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR06MB9934

On 32-bit system args contains values that do not fit in 32 long,
use uint64_t.

Signed-off-by: Emil Thorsoe <ethorsoe@tuxera.com>
---
 utest/traceevent-utest.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index 7d09bf2..6980a29 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -382,7 +382,7 @@ static void test_parse_sizeof_undef(void)
 
 static void test_btf_read(void)
 {
-	unsigned long args[] = {0x7ffe7d33f3d0, 0, 0, 0, 0, 0};
+	uint64_t args[] = {0x7ffe7d33f3d0, 0, 0, 0, 0, 0};
 	const char *func = "getname_flags";
 	struct trace_seq *s = test_seq;
 	struct stat st;
@@ -420,7 +420,7 @@ static void test_btf_read(void)
 	trace_seq_init(s);
 	trace_seq_printf(s, "%s(", func);
 
-	CU_TEST(tep_btf_print_args(test_tep, s, args, nr, sizeof(long), func) == 0);
+	CU_TEST(tep_btf_print_args(test_tep, s, args, nr, sizeof(*args), func) == 0);
 
 	trace_seq_puts(s, ")\n");
 	trace_seq_terminate(s);
-- 
2.53.0
