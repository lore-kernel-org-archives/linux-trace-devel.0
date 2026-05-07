Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021114.outbound.protection.outlook.com [40.107.130.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75823F9F48
	for <linux-trace-devel@vger.kernel.org>; Thu,  7 May 2026 14:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.114
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778163810; cv=fail; b=ajJ9odx+dx8Ub3CgX7qf7U2asVNkqF8NkulJ8/3BS4vt+83pquC+IDxOiSQwWKSu0tYR10zRITMWjb/8A22yLmEZ9QQu0ZmgKMCs14OWgH5G6wBTQT0PlHSfQ9xRKjUDapTDf1T5jwaXXOz+CyqJ+LzObK8n3iGDF2dQNCxK9C4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778163810; c=relaxed/simple;
	bh=DSmuEChvpPEa1snZRy3Q635EZ1ZYUA657e5Os3O2npk=;
	h=Message-ID:Date:To:From:Subject:Content-Type:MIME-Version; b=IDuEY6cw25G0sHtfKfx0FF5tZtN+l40JKOUfXscAKSt4WK3Sr13AwPTyUlN791JgayzbnkLsEsDNEDI2MtF5dWoWTSLcqSocQ1gpBBs6tB19EEKSVsJU2KM1rGnpT6GlI1wp3bODYqEmI7G9O/jkLfvzJEa8YOuOfm4cgZchSkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tuxera.com; spf=pass smtp.mailfrom=tuxera.com; dkim=pass (2048-bit key) header.d=tuxera.com header.i=@tuxera.com header.b=dynCFWB5; arc=fail smtp.client-ip=40.107.130.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tuxera.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxera.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxera.com header.i=@tuxera.com header.b="dynCFWB5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fc8Js4yMJGSHAnhJlJaF/gTdbKWKaOklo1+tZWk3duGgDMEG0sF84g+VrPNHWxSYyHYHXad69Viryb8V3hqVkOuYO4NsjXx/aTchAS2xFr5qsyPwrgTCojskOjbsEvq3TIJyOiwOtWUNR5B9XjXu6v0oA3zCWkYU4XPpQAC5d84xK1LAzArofgLntal3ARXBkinwus7MihjVsEUu13Sq68aYdkcLRXWjrM+q4+HJzN54dT8myxmc3DCb24BgohXwzu1FZy0tI/IOZZPUtL35gA9nFAyiQsK5uCyNZtu7Rf1Ow+cou3C4kNClVGs3ZsWosv/72ZLBL1Cbnvyu/obwaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sgURNP0tt3Gg6cZEZ2g8IV7bO7DXm0wP6fDHbPwDpXY=;
 b=SvQaMtwSQNeXIl5VR5ymyaN6jY1e0fCR6ibH/9syK6Vn0kCzrTZ1drGUn1e9VwqGjbbdkExSvDakW/oveaKUJGVBBb51hOoiKRdYWGrNgJHVOwuw2dlQ/XtVvZg97o8iQGI5bLgzXDsN44swLS/J0OdqI18ZjlfpSNLDA4ToEuW6m+mlZQm18AFbkaOaeK+Mf19LIGPpJpkz4JnInDwxx2htfyk6AL/6OVLQ80E9kVcBGoLFhV5yGfhYFYcnW2nfiNuQUtV5xU0E8cbtSDXFB8glqjmekX4/500vFLY5bNFw2GycXEqbpOyjzT6sW3JGGW0G8v5RNasWhZa8fF519Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=tuxera.com; dmarc=pass action=none header.from=tuxera.com;
 dkim=pass header.d=tuxera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tuxera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sgURNP0tt3Gg6cZEZ2g8IV7bO7DXm0wP6fDHbPwDpXY=;
 b=dynCFWB5ktCuajNcpxleg6u4ajKJg4pclzCt5iI1k8BCzN5oML3clAg28Ip/QiGnQrZj1UZyc5+vXSfiXo+7ggCb64IEFDCAbVa6iUoCLp6IOIDBLInW4AJBhjQQjS3Dciynga0GSwkSW3kM7KEyByvNjwBFPLecyUqGPi9ldUaKvyd1eQMEiSi1urI+yd8WeTejQup8dlhOMX4i6cFjYzd7C+ccZWcIFabsF5RKzRb3Ycc0CdqpxA29Ju8Ele3kWKphPfJOQGrMczNCSW1ntTAdVN1uq3bhfd8pJJwbrqggpfvJp1Xz02Hh5pUGZCgk0WJKUMdpgT0GKbPxW9fPBQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=tuxera.com;
Received: from VI1PR06MB5934.eurprd06.prod.outlook.com (2603:10a6:803:c9::16)
 by VI2PR06MB9855.eurprd06.prod.outlook.com (2603:10a6:800:293::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 14:23:23 +0000
Received: from VI1PR06MB5934.eurprd06.prod.outlook.com
 ([fe80::df0a:b9f5:dc67:c037]) by VI1PR06MB5934.eurprd06.prod.outlook.com
 ([fe80::df0a:b9f5:dc67:c037%3]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 14:23:23 +0000
Message-ID: <7940a891-2af7-4ae1-ad5f-3cf7960df529@tuxera.com>
Date: Thu, 7 May 2026 17:23:22 +0300
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-trace-devel@vger.kernel.org
From: Emil Thorsoe <ethorsoe@tuxera.com>
Subject: [PATCH v2] libtraceevent: fix type of args in test_btf_read
Autocrypt: addr=ethorsoe@tuxera.com; keydata=
 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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GVX0EPF0005F72F.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::2cf) To VI1PR06MB5934.eurprd06.prod.outlook.com
 (2603:10a6:803:c9::16)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR06MB5934:EE_|VI2PR06MB9855:EE_
X-MS-Office365-Filtering-Correlation-Id: ae68bc6e-de64-4bb6-b2dd-08deac44324e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	eES0VLwV4fosXGyFNxb1mw7+YXTEpszwzolSXqUwvgjizIGT/pBa92b5oMcoRCELQFzUEBSnAOO1hv6vpw+nFQEnf8AL5lzZSsnnmQpS/cbz1/stwj2rThPXA6uQXQhBkQO6NBZv0bD+ietmF+5hvTqUbil1dYiVo2zRdk4sm+yzutCOfwfSxwaByDXqsCLPKPnjLflCORl38QN0Z/orQ6+eqpv0VDBbZhGWaCS7YioRg6ZFcPYSJjdg0OJDw0+Pq4ZPID2QE92Is2U8cUXPEfSGlxJ/GQr+hDWz5xVqb2wyds3oPsKo3Hk42ALDHW2USwmlVuq+ZfswZ/Inh423ckh1Lh6kOM5fE6K8Jm7zfBAFDtBewv25fGDmhT+B+E0jtibp/t7vK65oHwt9Tap0TpvfDnLbw7FIyEx4aMq8xOxL0Lp/xzgReaVmO60gL8r9bMqXvXAGB4eaxC0sjXBwDdHgxljspevok0oAVVBl2M2kOZE6E8RkEo7XMO67JYv8IRa+NGwWVxFtk34gZORYQ9dRneY/+3clLzTxdo1+483iRnu4da3c1sQq4lE7MP1E4RD/eLppp0GoNBrnOirZkRXWEpG/71a0sTaKrPr9W9ouv5gfjFyMdQe3OgEdpXW+953xHoH263x2iL1lTpS/hbO5l9NX4jF1zHatfo0/zH9fwGCl2apKFLEPFDJtPlP8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB5934.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTc2SldnSktDdEt5OEFWRUowZ1dyVWcxT1liWkpDWFdtQlZUM2ZYMWY2V01Z?=
 =?utf-8?B?eVNUSDRvYWNKWE9rTWN0cGVRTThhczBpR21PaDRXMndNNWx3eng0RGQyTXls?=
 =?utf-8?B?RE5ySUlvN0dkZ1pJQjlhQVgySWRiNnRsWTFONy9Kczd3YURXMTN0Z2pzeHhM?=
 =?utf-8?B?a2tmN1VwMmRPY0JLSnhCZzhNT3VOWHNzOHZsaWZHN1BNSXptdVh6cUNsNi8y?=
 =?utf-8?B?KzN0dGxrdWFLZlB5Zm5RVW4vQnBXaTF4aVJuUTM2dVNMcVltTTNtRVNqOHFO?=
 =?utf-8?B?UzA0YjRyaC81VXErLy8rYm9FOVdTcDdBVms3ZmN4Y0NzUlVsN2o0YWs5OVZv?=
 =?utf-8?B?TWZ1dldXNWRDdS9YMUxHZ2UxOGFFL0hiR0pBQ3lsTXA3VVhnN1hjTUpYK3Jr?=
 =?utf-8?B?MHBjcEdnMDlwMU55aVpHalJxd1dJN2FZeXo1WFViRTBtT3VsVFhXVEMwMVpP?=
 =?utf-8?B?dS9sbTFnU241ajVHb3dpcE9ydmJSWlFkMUVQdUo3dXFnMUVoREY4ODZ3UlVK?=
 =?utf-8?B?ZVNiWmEvN3NjSCt3WXAxOTZKNE96eDdMUHV3d0NEYU9udHNXRXlXb21Xc0RF?=
 =?utf-8?B?MGpWUkxuNDhDVkRPb0RsSWsycElzR3pEZUM5MGpQRzlmdTlHV1RVekk1dEJr?=
 =?utf-8?B?bkNoZFhUNTBVSXY1Q21IaEdrZmRZWlBHNkJpVjIwN3prTWliOEU1UjRVK2dE?=
 =?utf-8?B?TU1sSlF1azVxeEZPdXA0Yk44Q1pnMWRlK0VQWlVnK3krdkJVOFhmYjFicEVJ?=
 =?utf-8?B?SDRnMlJGTndxZDV3cVArejhUNFhJYVczSFM3eWFlK0VWcmx5UlZOZkYyWkZo?=
 =?utf-8?B?Qzg4cSs5MEloZ0JwMmgvais4NlIyN3p2ZUtzZDYvVTM0UkwrUkFQMWxYT1lM?=
 =?utf-8?B?N0Jpc0w0amR2d1NXMkdsYzdhL1RGcmVpSTZUbitFajY1dVVpYllSeUR0S3JX?=
 =?utf-8?B?dzBkTjVncGlHZDIwNllRL0prcktBRld1aU92bGw1RVRhRHpFY2F6TW9NY2l3?=
 =?utf-8?B?bFUyUTN4NElJMFFWUCtyZEh1OE4yTTZjTlN5Um5TdlpPNVNPLzNRZTM4SHVS?=
 =?utf-8?B?NnVldW9xZlBSNTRFOCt5UHZqZ09BK2tKcTVmY2JGdDJRYU41NEp0M25GSHVk?=
 =?utf-8?B?ZkNOWmdnUFFBUVkzQVpWUWhCUlpONVZqWTNGOXEzT0FmYW4yZjJ2SGxxOWlH?=
 =?utf-8?B?bC9HVU9RQ056WUQwT3RWQU1lbHFrRVJWa05pUm1JdjNweXJDQW83ZzF1UTg0?=
 =?utf-8?B?WnlwVjR1Q055bEpqdlV4YngyY0YvMkZaZklaNDF4NW0rRVNJekMwZVJ2QXRi?=
 =?utf-8?B?dmgrRVZYQklJNmhxcWxvdGVHZGNha05DN2crZUNTcHllVTQxNTR5Y216TGFM?=
 =?utf-8?B?Q3BLZ3BRMFRmcWdtcUZ5NmJwNUdNQkF5UlBLazMzMnZSSmdBS1ErcGdnTkJZ?=
 =?utf-8?B?T3RBVTNINi9mMHJsak54THhzSFR2U0JUbnlsREdvazFBUE1kTEZIL0tLeUh1?=
 =?utf-8?B?d1ExR0dKczFhNFZFS3VEUkg5T0QyY2hnTXg3N3MvMlF5akthcUlmMFEzczMx?=
 =?utf-8?B?dmJnSkhPNUNoQTdoNkUzaTdldnlvYURCNFgwWnBCSU1SREhrVTlOM29Rc2Er?=
 =?utf-8?B?bUdlTDVwc2E3R3BIeE1nQ2hHUzJqQ3NMNTBGQUVzcnNMVkpiNTVKUVlTU2Uz?=
 =?utf-8?B?NkdMc3dUQU5udHNsT1FOZlhNbG5VNXJLeWVaekwzeTBGa1NadDBjdmZwYlBK?=
 =?utf-8?B?NUpNL3F1SzBoQXE1ZmpITi9CaGV2NnY3QzhBeitJbCtaUU9uSG93bEozWFhu?=
 =?utf-8?B?aGJxeEZRZXVCbXRGamN1Wkd2Q1RaTTdCcW44MW9haEpac1dFcVhNaWRnMDkr?=
 =?utf-8?B?VkMrR0V1bExPb2U2d1p1MHBUMS8wemVUZzgzNVJLRFc3b0NCV1NMdG14UjVS?=
 =?utf-8?B?cXRSOVNVQ2ZZL0hUNEszZXA2SjdkMk5aT0tITEZpdkJndk4xbTNyRzZuUGpn?=
 =?utf-8?B?N2oyQklEbiswTVYxQVJEQnczNHZXZyt0c1FEK2lJeTRJQ2xIdFpEblk1Sjg1?=
 =?utf-8?B?eExmK3B5UjNJSkFaSWZUZ3htYWg0dVcvY0xRTHNTOHJnejZTeXIveHY3ZDU5?=
 =?utf-8?B?cEljUk1VYUdBajNvbUl6bGh0Ykcrb3MzMVQ5ekR5RlhzVHBMdmJtQk5jODVF?=
 =?utf-8?B?dkFSMmw5cnFzVk12TVBLOWxkVUMzMkZUMHBMejc4eEhyU3NTWkcxZy8zd0Rh?=
 =?utf-8?B?N1VPdE1SUllDQzFyKzlMT09IN3ZCSE44a29KbjJIN2hEaWxIdTlxZmg2K1Rt?=
 =?utf-8?B?eDh0OHJtcEl6OUFRdUpMVWo3NnBqUlFPMXpEYXkxbmcvRDJ6L056QT09?=
X-OriginatorOrg: tuxera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae68bc6e-de64-4bb6-b2dd-08deac44324e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR06MB5934.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 14:23:23.6399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e7fd1de3-6111-47e9-bf5d-4c1ca2ed0b84
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DaYjYDJ6TwZmza34MmHcd9q2l+JEjEHJsmqHoxx+cvFqll/lg4CK+sCzSPJUw2IWIIF9h8dSge+GNA4KMC/lFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR06MB9855

On 32-bit system args contains values that do not fit in 32 long,
use uint64_t.

Signed-off-by: Emil Thorsoe <ethorsoe@tuxera.com>
---
 utest/traceevent-utest.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index 7d09bf2..ea64166 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -8,6 +8,7 @@
  */
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdint.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
@@ -382,7 +383,7 @@ static void test_parse_sizeof_undef(void)
 
 static void test_btf_read(void)
 {
-	unsigned long args[] = {0x7ffe7d33f3d0, 0, 0, 0, 0, 0};
+	uint64_t args[] = {0x7ffe7d33f3d0, 0, 0, 0, 0, 0};
 	const char *func = "getname_flags";
 	struct trace_seq *s = test_seq;
 	struct stat st;
@@ -420,7 +421,7 @@ static void test_btf_read(void)
 	trace_seq_init(s);
 	trace_seq_printf(s, "%s(", func);
 
-	CU_TEST(tep_btf_print_args(test_tep, s, args, nr, sizeof(long), func) == 0);
+	CU_TEST(tep_btf_print_args(test_tep, s, args, nr, sizeof(*args), func) == 0);
 
 	trace_seq_puts(s, ")\n");
 	trace_seq_terminate(s);
-- 
2.53.0
