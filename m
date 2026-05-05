Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11023116.outbound.protection.outlook.com [40.107.159.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BC437E2E8
	for <linux-trace-devel@vger.kernel.org>; Tue,  5 May 2026 20:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778012572; cv=fail; b=m5bFCSnvgv5r/6Ftq/rla+gdU3jI9TjXQ6kSMEMPzK96sXkHPvnNijocKtbX2tT8KggdU75huzMnuEMriKxiIEgJjZ3l4tJspF4DqK5LuYwqvuS5cyPEgQ0JHcrv/xCfNVd5oIc16IbLz7PihLAZII1KgPyn055LWGFLAFVzfZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778012572; c=relaxed/simple;
	bh=BebhMYE1BzjmW85NzB18cdP7JxwRYjDOxYApAVEgxo8=;
	h=Message-ID:Date:To:From:Subject:Content-Type:MIME-Version; b=HPQhEGPXIOoHAlha1WwcpqZ3xnh2MEacAWGijICZr93pVIFtIg7uw/dxUrlmqCuncTPbyJabZ17DUNyLiQnTynCldHgtH3XY8GslIrqnu3QRTAjc9CKM8B3vT2x1NslcKwE2T/IjuWcUlMXAdmQeym/qEIHd975xH0lm+EUNFM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tuxera.com; spf=pass smtp.mailfrom=tuxera.com; dkim=pass (2048-bit key) header.d=tuxera.com header.i=@tuxera.com header.b=lL8Ac1HI; arc=fail smtp.client-ip=40.107.159.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tuxera.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxera.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxera.com header.i=@tuxera.com header.b="lL8Ac1HI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ugf0mwIXI6+ZHjku1TzfkDHNKKpVl6t+lQq3o2BehmJJhvuMZYdBhoFjCjg3kzkxTetCHhwrGsylJg648TPsPbCINeL3sVnK3ILPDnp5xLyLlFuZXd4PFZPXzxSMm4KJyKpIB/K1xK0zul06nLfuRF8FJiQzRe5Y/B99BmyZ7Uys2QNaGyQNoENzNKjtq+SXO5pmLLnLF7Ppjmc2EDtyp9VVBtols5xYPXDKfuURWRLZf7KGWIZQ+G8qSgOSfxczRFt+1CjIHLGqmHP/DoBtChilXUD9oqW1eUNjwDNSHfvjxywxnQU8cBQUlpp5E0gh+swb+D13D1JgZPlnwTdZjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+NzxYz07LayGk+bojU5FZDS+ysuTkAhyIJrOFcXkt8=;
 b=LnIlzzFynQ/HscNkThz8U3TSHr6h0YO8YTZhEbW1UNNTliMCZ+0tMpiPssrB048RMyRboAX8r1pvvhU7SBWI+1yCHM75RwmG0+McPyubQJCcOmX33RSJhzjU/Wh78yGE+fAdOmTfz9fhccenm8upTxvQhi6f6BVWedAe3a9wGfYnIcPxvkjiteb1UCGL18sdn9wh/9Q5Bt9CisUkzxYwWoM04fRu2WHTESrFMiTXE5k2HYdMzv/IE9CE7AFkAC3JHcgw3bJ4UIUJyjXFUmvghYKqQhgmEluyqaH6mZojQoCARIeiptoSWNlHuB33UiTsbRp3Xoe6ZGge0nUt5rh4nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=tuxera.com; dmarc=pass action=none header.from=tuxera.com;
 dkim=pass header.d=tuxera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tuxera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+NzxYz07LayGk+bojU5FZDS+ysuTkAhyIJrOFcXkt8=;
 b=lL8Ac1HImqjP0k3qcA8c2LG4pjXaXQBW7M4jaBoDDP+C57L+NpqBrZiNVkVy+ZdLWRw9sEbm114dskmXrj7JpUewvdbk6jgJQcjQoy5+Ltwavrjy0LCFDx8mwBQ1RyZqt7HI18b2LIQ+sQWR/6OrJf7aIo0w/zyoKg4DbTqoNgFndhTSiyjfuMs+ytW2nxN2uqLeUjiy9YZYs5DkLP4ItpPggzp6FVwQheorPGX4JT1B+UKds+cExoTpeW8jez93KpgOvYzm+sUsUUiEX+F+A9IwEHxQPbPFcIip7DVVM/jO3GyQwx7FbijVxLrMfvcDCJtyobCM22YU7+fliIC0aw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=tuxera.com;
Received: from VI1PR06MB5934.eurprd06.prod.outlook.com (2603:10a6:803:c9::16)
 by GVUPR06MB10816.eurprd06.prod.outlook.com (2603:10a6:150:32e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 20:22:45 +0000
Received: from VI1PR06MB5934.eurprd06.prod.outlook.com
 ([fe80::df0a:b9f5:dc67:c037]) by VI1PR06MB5934.eurprd06.prod.outlook.com
 ([fe80::df0a:b9f5:dc67:c037%3]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 20:22:45 +0000
Message-ID: <2677c065-b9c9-4fd1-a4a8-de4f027a0b58@tuxera.com>
Date: Tue, 5 May 2026 23:22:44 +0300
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-trace-devel@vger.kernel.org
From: Emil Thorsoe <ethorsoe@tuxera.com>
Subject: libtraceevent: bail out of utest if mmap fails
Autocrypt: addr=ethorsoe@tuxera.com; keydata=
 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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GVX0EPF0005F6A1.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::129) To VI1PR06MB5934.eurprd06.prod.outlook.com
 (2603:10a6:803:c9::16)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR06MB5934:EE_|GVUPR06MB10816:EE_
X-MS-Office365-Filtering-Correlation-Id: 5535bcdc-96eb-4dec-16c8-08deaae41175
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	yKp1u3qndFoxKA5InUVWd/q0AryvAKLLZcYOWmvseT8eRYbnDlvXiOZ68eCgLk9uDdONCx7fk9UDiFSD6+aMAmcnXhIBYERs9kEUm7RSOfqzfKf00P67DszJdyxpOIgVYcTp99La65YmyFDVyCmnnS/Kf8xvNHDa4pWrLMCzJSjfGDiKJme65lzQgOTr0qmzje01wPCyK5FazA+IU4zL6praLl4Pxfl1e+kkU/GR7Lu8FwHFDBy55U0HaBZO6HktOnLhxP5y2ldxlKiATyzS4ovPkskszVW+eInWhsZtszZvt+UkACIOD68l6pJg8DJhsNCR5lElFCpoCgB1lIhMouX84TrLX3gOiAtL9JD22h5s4KmdtZmWTxqpYQg89x4hyjM19VKg3aN7vDNz4W28jJf7HkSO0Oh+D8gWjli9duOzHMUsGCitPfbeFeZ7fEPFY6zZmDHnslQuXB8flmQTvbeLEdhZ7kvvmgVVjLKy/uOEQNCZZh93+D38WYFx2UHt9AbwP2ttOWX+jZbvjQB6uqWXQnMvdpn5/490TlB+FeGmADd21tNZt4z3bPGauSFUSpHkAfc+Bji6iBU7XNMGGyPC0WUEZ16i31YeqPQKPn4hlzKVaeCf+BLA8nLV/M1J5S3Jc6gZoLEsLxNSJCnXkP/5skwSVvkw+KDEIZ4uwsYGv2PdkaYb4ayXAEvM4EeU
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB5934.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WXpJTXE0YnVidzhkREZ1a0d6aDZqaWE1MHA2ZGtyQUdyRngvNWRtWENjSHV0?=
 =?utf-8?B?cjlSQU0wSVphd0ZXNjBLVDFFNGZjdjJKcFhMT3ArTkxBMmZmNlJKMndRYzBQ?=
 =?utf-8?B?bkNCcGxRZVA3TXJ3NmVtVTVHQ2RqbmpsTjFTdnBYQWw0U2VYaVpkemtQMnJU?=
 =?utf-8?B?djE5SHNWdnhRQll0Nlo5dWhGOXpIL2U4L0h5UnlHSC9zaWc4dUw2eW1yVGcz?=
 =?utf-8?B?UURBbzlwTWZLUjNuOWM0SGhlN01XT3hHcmJ5SmNGSkpmL2JVQ3puQkx5d2Vj?=
 =?utf-8?B?NVYvVUsyNjBpWm1TUzRlQWFkTkQ2Sk5lRVlyb1NVdTFwTE5xWGRRbG5EQUND?=
 =?utf-8?B?cXY0RktOVktjY0hnYUZsd0pPeXNJNGppQ2xqMmIvdTBRa2tZcDNWWjEvemJY?=
 =?utf-8?B?a0w2bktIOHNLT0V6MGppMTJ6Y0MvMEdoejRyYnd6SVgrZFJ4Y291cXpXbmVv?=
 =?utf-8?B?K3BIblU3Q0s3WUJBRTBEaGordGtLTWNWVW9TUU9BNStUbU5HOEZRU0FScnFm?=
 =?utf-8?B?UzM1Y1FORGFTdmI5S1ZWTVltNFBaYlEyZ2tQRFF6RnVSNUVMUk9paTk3YnVW?=
 =?utf-8?B?WjlORStIK090cUszTmdNQWNwMkpiNExmVHpJR3ZpL1lPd3FzQ28vTldjZEg4?=
 =?utf-8?B?OExBUnBxcjQzS1VJN05lRS9xeGgzTXMxem1PTmhraVlIckxQbWhhK2p5WFds?=
 =?utf-8?B?ZnIvbEJOZFhZYks3MEt3S2NiOVdXWjBoaFRtd3MzM1JCQkRWRjRGZGsreTBm?=
 =?utf-8?B?ZnVQUHRRanA3akplV3draXBHVGxRVXZlVW9pV3lCWm1KY0cxdG9Vcm1KaDhR?=
 =?utf-8?B?bzhHK0dkYnUxNE50OFFkNHBCM2JqeHB1QXRkZFlEb0dqQVBvZ2dnaGlUSHgz?=
 =?utf-8?B?OUkzZVZqUTE4STl4TE94Q09lbEJ5SFJZSjdUUUxJbnl2ekNMbmlndHFJQ3Ja?=
 =?utf-8?B?di8xOHdIczAvamFaSWpHUExvRDhORnN5aHMvcTdGbmpnZVpqTHlnS1BLbnBM?=
 =?utf-8?B?NytjMkl6RWw5dHhwMlBmdTl4Y3JOYUVpZm8zUmZHV3JtUFFLUWJXdHVUanYx?=
 =?utf-8?B?VEw5LzJEdUx4Kzdlb2tjZzdIZFlYbVRmTUtoSzZkdThZRjZ0TWdQZjJQak9T?=
 =?utf-8?B?L0w5QnR0amh2QUo2bFhuWTJpSUxBcUpFK3hoeVlGVERwOXZmQWtSQzNDWXdJ?=
 =?utf-8?B?NWtLZ1FrYlNoSDJyeU5GN2FmekRrQXVaMHl0ejRzQ08ySkpLa0NkQTYwRXR2?=
 =?utf-8?B?b0tZZEZQZU1lbUx0REFBeHQzdWExWE1QbzFwSlZmVVplV2xxWURGdzJweUY0?=
 =?utf-8?B?bjlOOWxEN1Z6M2I0NlRRaDZLTFpkVTlvWUR1Y3hrWTg3STVwTWhLbDIrOWVm?=
 =?utf-8?B?dGwwNG5UTDRmR1VJMWZVNW54RStjaEZySWVaYUFtWE5TNG9DcXpVZmhWTmt5?=
 =?utf-8?B?blFuN3c4NURCRmV5YTJzZStiNXV1SGRtTmNHTi82T3k4L0szQ1dBRENEMG1z?=
 =?utf-8?B?UEdtSnNsK01qZjNrNWlhblNZd1FEcWN3Y3dhN01IQzk4amVCVUdmd0o1cUxC?=
 =?utf-8?B?dmpzOFllSE53MnB1KzlzdUp4UEcreGoyVlpJUkpxUHI2Yk82S3B4a3cxYjZI?=
 =?utf-8?B?U1pCdWFkSmZTRnBKS0N2a3hHczNwT3RMK0ZUdmRIYW5RTVRwdVY1SE05dlM2?=
 =?utf-8?B?N21tS01BSFA0YkYyeEFDWG5YMWR6aExMTDUxcEtzQ1Njc1ZMc3g2aFdjUzIw?=
 =?utf-8?B?U1A0K0tvMkVFOGtoYndXSkVEMEhBL1ZRcUx6TWtKZzdPdlpza0gzMzQ5bThM?=
 =?utf-8?B?NGpwVmhYdGNhTEtjRjAwWTdWLzJob2lWalB4WUlhQzl3djJHYnVZTXVTNHN4?=
 =?utf-8?B?VFZSSjJlZFpPWUlNZnpLbmRkVW9XWWxjbWJBV2VIZGVkZkppcENhVHY0V041?=
 =?utf-8?B?d1EzNnFnOGcxU0hjZlExN0Rkb1VBRmFBQ09CUmpJT3p3bVdhOVF3NGxYTy9v?=
 =?utf-8?B?OVdqcXh4c2lsMWtjVXNWWFNrNGVsd2loRlRIeTZYYjRxSlRGN0tsU0NUaFJh?=
 =?utf-8?B?REVkKzMrM080VXJMaG5RR2krUXNxRnI3ZEN2RGpoRHhNeWIvbzJTZUlZUzEv?=
 =?utf-8?B?QVZZaFdTOTJ6YmJHS2ZadnorZG91V3Jpa09veGxvaDdqWEMrSEFLQ2k3TVhY?=
 =?utf-8?B?TzBOQkVSK0kyM0hMRFRYbVowTlFoRWlHZVRMOTNwamg0c0R4RXRuMUdwNU9T?=
 =?utf-8?B?dVQ5d0svOTBEVXBEdUZJMlE5N1lCa3BnUkFNNUlzcVRWcTdWUmVTZzdLcWds?=
 =?utf-8?B?T1dROXNLam9hMnE1TlQyNnprdmUrcU9iNWJxc29vUmxEeWN5aW42UT09?=
X-OriginatorOrg: tuxera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5535bcdc-96eb-4dec-16c8-08deaae41175
X-MS-Exchange-CrossTenant-AuthSource: VI1PR06MB5934.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 20:22:45.6454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e7fd1de3-6111-47e9-bf5d-4c1ca2ed0b84
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Amp1p1UUnDPeMALHCAJ5yxORnqe9r6wKCkQn4aN7OgfnZEI4kpN0HG+8EwFMKI8vfAa0rK91Fk4NvRRFuab0Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVUPR06MB10816

Just like, when failing to open the BTF file, failing to
mmap the BTF is testing the test environment, not the code.

This mmap fails with ENODEV on i686 nix build on nixos-unstable.

Just bail out without failing the test, when mmap fails.

Signed-off-by: Emil Thorsoe <ethorsoe@tuxera.com>
---
 utest/traceevent-utest.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index b62411c..df98fa1 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -397,8 +397,11 @@ static void test_btf_read(void)
 	CU_TEST(fstat(fd, &st) == 0);
 
 	buf = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
-	CU_TEST(buf != MAP_FAILED);
-
+	if (buf == MAP_FAILED) {
+		printf("[KERNEL DOES NOT ALLOW MMAP OF BTF FILE] ...");
+		close(fd);
+		return;
+	}
 	CU_TEST(tep_load_btf(test_tep, buf, st.st_size) == 0);
 
 	munmap(buf, st.st_size);
