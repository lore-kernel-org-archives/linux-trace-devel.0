Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11020140.outbound.protection.outlook.com [52.101.84.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AB621ABD7
	for <linux-trace-devel@vger.kernel.org>; Wed,  6 May 2026 19:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778094717; cv=fail; b=hUpXKGC6aeC6ViU+kBdvz3OvvWPjhUHkTcu7cU3sAa8Z1dnoDoT+G9l7FQIS3K44ZlyZfx4mD8Pek5sEuXYv5R5oGli/xeUQtcFaHcUB5q+tBF7QgqYTt9L1yq8P6l4kxKkO0UvG5FXYvwmvGPI0ZvixK9sPXf0vnZ6e0v/+h+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778094717; c=relaxed/simple;
	bh=jW0vz6CEEAIeA7i7g0rgJUwivcRvZ5GzOlwRfsyoPrg=;
	h=Message-ID:Date:To:From:Subject:Content-Type:MIME-Version; b=YZ/sRiY914cp9cSjSkivqUbUoDVyj5NkcQVl0XIpEcbhBFyMialC5u6KLK9lSByEiN1dhMxCwVu94ZBY0V5WLfAH1cRQGNhcxuN4Gq0byFNLcztudlcAiw7s8Zc3EpP2TEWy2jS2+67OpdTorRcxkOd6SVNib11+pFmDv4dPRCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tuxera.com; spf=pass smtp.mailfrom=tuxera.com; dkim=pass (2048-bit key) header.d=tuxera.com header.i=@tuxera.com header.b=h8BRA4Yo; arc=fail smtp.client-ip=52.101.84.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tuxera.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxera.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxera.com header.i=@tuxera.com header.b="h8BRA4Yo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rnVjaAZO8S11ejaaC6ZXIT2PsP5VFHKAMK8M1or3M8ogolNjaZvmd5cJ5svb6qx5BEFsvnwO3XmuCGzyG9K8uvFuAenM1dPH6yvQoAWuS9LR4LmG7NHG38shniQsAkc0ALw3RtBIo0EIb/FTFo3cSTf6/mOMR+OdReNo//514VjX94IX4s7BWOvr6FceAHAmcr5x7s3D2hg8bDAy5A9YQ8Vx4F8sMawSnnBuWJ5sUav5Wc/Z1LNEij5t7tXgfwy7SWsGsPvl8pdr0lgzNisytjG8FRHm4DmdugWsDVyAFQKznuL5DeAUUlZEX/9SLcGItrrLpsaEK4RHWlZKzByYzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zsk12mF2tZiEPPcQscbkZjvTu8ZVULG9zvOefu2UwOc=;
 b=DpTaf8fKOVGC5H4+JSMSupTusgJRJBI0+HCKBlJzRFS6QZWtJbBl/vZmHGrYtCvlpFCs/ZhGJftl2XXSD7ysRqhCAwTL/BJ+9XCcEGZN/OmSKo1lhWSyv8JuNKxzpS9aZaziye6W8X9sxFkMkm2IxnabS+KBRVCk2XoIS7HG/CxBp15Nxn9tHStR9U+FSPApjU3yEB4XkkcyNqQV92vzBI8AeuQC54lY2HQt9qLQnLYfqIv6HFS4JgaD5/UEG4Rx5HSTXFo9y93bwKduMmsouNoBbdMou8EGsu2F3/S7VuUtlrssc+i9FknCvstAEeb07KJLZKDil7so5Hjk2VWqUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=tuxera.com; dmarc=pass action=none header.from=tuxera.com;
 dkim=pass header.d=tuxera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tuxera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsk12mF2tZiEPPcQscbkZjvTu8ZVULG9zvOefu2UwOc=;
 b=h8BRA4YosNP/oaBqB/ZLepcS+sZNvert1cGdmCV94s5WnuptC4M6i9quuypPMnmERQFP0N/T8vlk+qjkWKimkRBDyhmlc7+qYuEBygdTRlAdmjXY2Y4m1NVZNRC1mVnbPbSI1qFYauccLKnEjWoY9v8b2xvfrTkx4CetMqOfeGRmqafQ4ztKQenwO+0bMVoowx0KpjaQhLhgvhiWp8PSBlysge2A6gWP/72OOCHoiWpwD/Qi5hvZC6r5sKpPf0gKG5fQ6HOBfkMSfFZdzTVr4c+XQECTSI2KpEZGn+PHsofMHsFGCIHr6ZnQIJNWKPyl3xsfBlRIn1xNWxg0v15drw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=tuxera.com;
Received: from VI1PR06MB5934.eurprd06.prod.outlook.com (2603:10a6:803:c9::16)
 by PAWPR06MB9934.eurprd06.prod.outlook.com (2603:10a6:102:4c8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 19:11:52 +0000
Received: from VI1PR06MB5934.eurprd06.prod.outlook.com
 ([fe80::df0a:b9f5:dc67:c037]) by VI1PR06MB5934.eurprd06.prod.outlook.com
 ([fe80::df0a:b9f5:dc67:c037%3]) with mapi id 15.20.9870.023; Wed, 6 May 2026
 19:11:52 +0000
Message-ID: <d6e07cd6-cb78-4119-a048-920ca58b4830@tuxera.com>
Date: Wed, 6 May 2026 22:11:51 +0300
User-Agent: Mozilla Thunderbird
To: linux-trace-devel@vger.kernel.org
Content-Language: en-US
From: Emil Thorsoe <ethorsoe@tuxera.com>
Subject: [PATCH v2] libtraceevent: read btf file in utest if mmap fails
Autocrypt: addr=ethorsoe@tuxera.com; keydata=
 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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GVZP280CA0076.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:274::13) To VI1PR06MB5934.eurprd06.prod.outlook.com
 (2603:10a6:803:c9::16)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR06MB5934:EE_|PAWPR06MB9934:EE_
X-MS-Office365-Filtering-Correlation-Id: 9428aefc-8e92-4306-df19-08deaba354ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	YoBnDqg9iuDX9NyZekO2rjJOGL3ootSkG8uI4tNlTJvMeKZKaxaMiLL56t1U5Kc2c1E58Hk17XLHp92A+fAtntb377mnDrJIR7et/Q9uiQBCfizurvE/QFRigTxgbaxaW2MKaetMsSaCa7QGdGVHrCogmysQZ6OxgrYmoAKzuEq9oGgNTRQeE3d09SImaoDeRWMTzT14CvGlhsBmVcEc+/ys1N5BpZsMql2RNNi7Rl95H9V6OLRpOSNH4cnxkqqQg13YtdK4Lp3njMVlGc+FYJTNjqNaC389SPyYgAQULZRiskHamu981QPqSRjj/6Xn+X7GfHi72rK2Tz7wkN21JRqFGCwG36lbLcJ0OTTaqiGvjgYE1D5aLg6izT06XRefKWg8d2IIeyST3/+/Qcj2ol9IOZsSdjaa72eDtDDLxRrVmKPoz70z0N7ffHRtpDi3hTJGrYgNqEXB9VSajlhw9uxbjSqyiAjbjSf0HsBrQo+dbyXlDbNtobWZqL0rhHC+djoGvLIQBsXCDP5DTw9Sei+2ZKsc8Fu3nbRQOV7o0hE9RNKVbDHn3cg7rWHlZ0AJKYc/pDmo9XTUJVQikGwlsoNHXQqgFQeW/ebUZsIJP9p27wc7gLDshfs3td6CG9Friwzk4LssdalJQfGEmh0jmnR6J2F2zdO+qPPPbkj+83qpy0r7Xkl908FcLQiQAlFU
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB5934.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(18002099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVNhYnFiT0tvcDVZWHpMWmtUWlA2WUdjVzREQ21ReHJUeGtYRmlFVTZBN0Qr?=
 =?utf-8?B?ak5NRnZPRnlYNVpJUlpDSWM3dDJ5NkVxRzBTYWR6b1FwbUJzdEFXb1ZRd2E1?=
 =?utf-8?B?UmszNGg2MjRiUnJDRUpZZ21IbjQyVXpmSlB1TlJTbGNFUXYyci9wSmNad00x?=
 =?utf-8?B?dHo1UHY1cy81K3VhcElHNzArK1BIdm5nbnhzNTJ5Z2VOU1FNTDhUazQzN1k1?=
 =?utf-8?B?c3J0STdzaS9jWGJTTFRhekdocUFoTFJuZjk1S2JwWmE4Q1JsemYxendCMWVh?=
 =?utf-8?B?RmVqVFVZVnZJYWJDNlZ6K2pZQVplV0JEZWRYdUt5ZVcwY1pwalI3eTZhaGlp?=
 =?utf-8?B?SlQweUxqcVI5NnhzUFpqL081K3ZRUlJzUGx5ckxOMmxkL00rM0FWdXpjaVdD?=
 =?utf-8?B?eFVpYzJmRmtVTnN3czdPZDNJQ2k0S2VXU2dQV1dtY0YzbmNkTGhGU2FOWUMx?=
 =?utf-8?B?blhXai8zR1NPTXkzdVkyY21JbG9rbkJGdEY4M2Fkc1FJTi9TNWpQTFlsREhj?=
 =?utf-8?B?eEUvc2QyL1FYTDRBSWpSMDlzM0NLYi91b2EzVDZINm1FS1VkdVNIVTF5R0Vu?=
 =?utf-8?B?MGIwaFZyQ1lyT1JOTVBVYnZhRkpQclV6OGhsNUNPN3d5RHFnL0MrMEx0MzR3?=
 =?utf-8?B?akNaNkNaWXdTWFJjaGV1Vkx4K2lpOCtOb3lvVTdzSEVsS2dVQ0lYMXQ3Mm5I?=
 =?utf-8?B?ZURVQithYnpzS1ZPcEtBeDJKVzJjNmg3cDJDczZERkc0U0xpMXEwMXA5MENQ?=
 =?utf-8?B?eUdjSGtUOWt3YXVwMkJjWXVKOG9PWFlaVEs5ZkpJSEpTVXJveHFEN0xRbU95?=
 =?utf-8?B?T2ZXbW15Nm9vOU1lYS9tUlZmWk5oMjBJNFlVR2xvYmY1L0JYRWk0WGtKcGti?=
 =?utf-8?B?TWRhWm13N2wvdHYxaVFTVXBSZ0JpQzZpaVZlWElSa1JRSlgyajdQcWkzc3ha?=
 =?utf-8?B?eno0cjZ0ck5vaHdLdW1VSDUyQjg1V1piRW1oRjBWTUVwZENrZ1plaEgyUWZ6?=
 =?utf-8?B?SjFRWkZHZFA5Uk9mRXZjUlNpNktsZHV3RFV2L3ZqOUFrMTNlaVlRejNoUXZj?=
 =?utf-8?B?bmtpT3pib1d3VDhERC8vSm93NEhJeXRhb3NkQWtNT1dVZmdTOU5CTFBYeFpG?=
 =?utf-8?B?VGtHYzVKbmFZMXRGcGZSQkowWFFoNjBidHlrUUs5V3h6VklVUGl5bFB3RFJT?=
 =?utf-8?B?UWdMVFA2ZU5FODlIcTFxSGN5R0ExcEw5dkJjWTZBbi9VVjVFL3VHN1hUdXVo?=
 =?utf-8?B?c2VHRkcrSDA3RjJ2aFJ0ZWNaWWtXQktHZUJ1ck5zcXdrU3Zrc3lhTENIV0kz?=
 =?utf-8?B?K1VLMy9VNk5kSENyQVdUT0d3VUR3SERKdVBSN2NaQmpOSTZZMEFiemdIc2xR?=
 =?utf-8?B?aHZTMkdIY1c4MkcrT01CT2dETWUzY1lQWll1KytJeVJjMnowTTlwQ0ZEWU4z?=
 =?utf-8?B?d3dUK3o4WlNRdCtxQm9VTWR1UktwbXBzZ3Azb2NSOC9xdW1PVzJhM1loVDF4?=
 =?utf-8?B?dzV2TXl1WEQ4VGVqWE9ITEZkV0JrMTlWZm1xWjdlQlpZQklWNUlhM3hZV3Ry?=
 =?utf-8?B?LzdObFQzcThmdGViYU0xeUpUK01ydUdrT1VodUhvYnpaTHJJR3V5bE1iVXRa?=
 =?utf-8?B?dnNaUXFNOE1zVFJ4OCtlMlFqdm9KaE85aVp3TFRCYTBWOUtMRmVGNldoZ2VY?=
 =?utf-8?B?YmxvNDhYeitLei8zb29tV0tXLzN3Wmd4RDc3VHRNWmtOdk9DQkkwaW8ydnZx?=
 =?utf-8?B?NXZGWWNnT0UvaExTSVRRR015UmM2TkJSUUdneUJZKzRTNzByMWhYc3lEeG1J?=
 =?utf-8?B?bzlDeTk5QlhWMHFWcE56bE5PLytiZ0VQRllTWCtLbUJTaHhIcjFXZXVFcS9N?=
 =?utf-8?B?UnFzYytQQnZ6L2ZaOXhNMndEUFFqemRydXZCRWQ4TjRpL3BOT2svdUhsVk1z?=
 =?utf-8?B?ZjlZNHI3WGV3bEZ6VUFyMzhMQlNtcUtCRVY0RFBYa1ZPLzYxelZkaXVReWlE?=
 =?utf-8?B?R050ZzVPZGtIUmp1eENvTndpZVVZeWpVeTRPWW1NVWUvMDJlYWhpUUNrbE4w?=
 =?utf-8?B?dG42N0pHSzBid1MwQWpiY1JLSitqcENqMEpzNUZRbnBoS1dDTm5vTW9YQ0cz?=
 =?utf-8?B?VllXNFZvYUZoa01wdUVqcnpFTFpMZWlrNlZuVzAxYysrSUJaU0tZdHZHaTRs?=
 =?utf-8?B?V2g5ckdUYlVlSUlPdGZaZjk1d3hMdDUzWll4QWVkQWFyYjE3cUowKzJKcE9N?=
 =?utf-8?B?YURtbldiU1JtVWlsUmYzVWw4RXlNRHJYNitpTTVodjZ0QjBScDVsUHJ4b2J4?=
 =?utf-8?B?QldPbEwwZ0pXb29xQ21JdjlzaWNCd2pZRFl3KzBqUWNWa08rN3JnUT09?=
X-OriginatorOrg: tuxera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9428aefc-8e92-4306-df19-08deaba354ae
X-MS-Exchange-CrossTenant-AuthSource: VI1PR06MB5934.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 19:11:52.5063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e7fd1de3-6111-47e9-bf5d-4c1ca2ed0b84
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LSljVwsNjrLmiv8HTOdHGGfcY9Jix0CLaqKLfIwXcmeGfIZU+SvLGFMrcLpoeXTI31iGceA9yeQjiJXUyMUk3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR06MB9934

When mmap of the btf file fails in utest, fall back to malloc and
read.

This mmap fails with ENODEV on i686 nix build on nixos-unstable.

Signed-off-by: Emil Thorsoe <ethorsoe@tuxera.com>
---
 utest/traceevent-utest.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index b62411c..7d09bf2 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -388,6 +388,7 @@ static void test_btf_read(void)
 	struct stat st;
 	void *buf;
 	int fd, nr = 6;
+	bool malloced = false;
 
 	fd = open("/sys/kernel/btf/vmlinux", O_RDONLY);
 	if (fd < 0) {
@@ -397,11 +398,23 @@ static void test_btf_read(void)
 	CU_TEST(fstat(fd, &st) == 0);
 
 	buf = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
-	CU_TEST(buf != MAP_FAILED);
-
+	if (buf == MAP_FAILED) {
+		malloced = true;
+		buf = malloc(st.st_size);
+		if (buf == NULL) {
+			printf("[FAILED TO ALLOCATE MEMORY FOR BTF FILE CONTENTS] ...");
+			close(fd);
+			return;
+		}
+		CU_TEST(read(fd, buf, st.st_size) == st.st_size);
+	}
 	CU_TEST(tep_load_btf(test_tep, buf, st.st_size) == 0);
 
-	munmap(buf, st.st_size);
+	if (malloced) {
+		free(buf);
+	} else {
+		munmap(buf, st.st_size);
+	}
 	close(fd);
 
 	trace_seq_init(s);
-- 
2.53.0
