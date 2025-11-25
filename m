Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011046.outbound.protection.outlook.com [40.107.130.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEC027F749
	for <linux-trace-devel@vger.kernel.org>; Tue, 25 Nov 2025 15:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764083835; cv=fail; b=K6hIAUDOtrcIwT3p0gjQ8oqIZEsjBwubX0YaP1iSxrZ6D5rVmAYpL3XxJNwQtL5NK7VfVZ5L7d1fvhl05eBsdnqIkXj4IITSZKcKBkJ++8Cs6z/X/etE3L87mGJY+XqJ8pQ2vKKjz3zExPNJnHVbOneMWNTzXUq7WJprhbpjEXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764083835; c=relaxed/simple;
	bh=5NAiYUyMt1vdXJggQLZ6Fi/W+rxg1wMB2xRfYjLjX/Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Kq/7d0TGauUH6XHgNOq/dBpJGzRB+3jJAcMuC2UYdLlKalSKCbrKSPtpSuKnKov3qmO/lpwh0W8FOOhjs3KAqZwlZk/ADMuwU+kheHp6/VzpZLu3fihQZVMM6A9dqPaBmBT+p86bdQ6kEvE1UbNp6AFKd4opd3fEP3Ek/khFxko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=p2n77oMy; arc=fail smtp.client-ip=40.107.130.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="p2n77oMy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iNgkK3GoCMheFipoPwWUelrZo1NSLKLIcXCOJbVON6a9/oEJWkVMTO4B5h5WCKBx7kEZUlC9tlgpRUOm4XxW7Chy346nW6Zf6WHjFY8Okj70gLra31xlK3FlV3EeyHX2Djj+epWWdCY3AmB0SUYKW9DeFr00oSWPQF5NT+6iuwcx/vERIMqCpqibBp9NgQhiH2mf8NeGapcFsY14AkrcIp73eKFKuu2vYhntw0tKv2oSHzSsyjVea+In2pWOhmRH1TiYCL9g7K2sZJXNk/wvZlNBbmjsKg3wOG1fFFPDpur9MxcllycU9IGxXiFZRLaQyUkng5oJ8HteQc9EiSQRQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5NAiYUyMt1vdXJggQLZ6Fi/W+rxg1wMB2xRfYjLjX/Y=;
 b=NauDd1MwoB6Sphnuq97ulGN4czXA6HwWfnMpwSjt32vw21mcFed5EBH0DMs1HzYhruPi8S6yvsNUZeUf0B7pEN110FjDsOstVjpzTuD1kcGz48O+6mFjMNuafQVsSli5nxCLb8OntSjVpwqLyLgtRX9XOxEeUcikTOJnnX/qHLpfyxGuySClmVq9NiZ5+JrJJ4r/Qz40j+zbKTKwvY3PTq4Y1NyEM2M9zocJBi9TmUImR7LyOQXWU4XIcr2Mxq0+kWhWEaZTALNTh4qlzK8FpX+sFt9ErVQdWXys8BZDxq67OjhnjCayegD7LiyrLbHN5lUjh2c80D/lSF92ZHQcBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NAiYUyMt1vdXJggQLZ6Fi/W+rxg1wMB2xRfYjLjX/Y=;
 b=p2n77oMyGoq1LFQxGZ0hnptNAdfW8sTBDLgwEm4FBqZBRFCD/zqFy0cx2xMMjig/d1ABrNpBM8ENs4NAAHw1mnlJl+UHjjX6bfPvquYjnMtSdw+0Pb+W52VEDiZjlHtrm+C384a01pgfM/T8DGDG0Tg1SqWYd3PZTCkeui6yMW86o+TzdjvQuTRFloIxCrBiUwWVrPXwQxwPM1XjzY9JUiq0Nyi7tNYJ6uQaaY5j+WbMqBXhLxjMsEYiD0l+fCmrWishht8DFPcZZ7EtgNOwwOohsmlmdcD9KDZEWut1w4UVnI6yhNAUQhYUltXj8VTRwzBIEl6vx7coLeqWMNXQ2Q==
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:47f::13)
 by PAWPR10MB8258.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:388::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.18; Tue, 25 Nov
 2025 15:17:06 +0000
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe]) by DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe%4]) with mapi id 15.20.9366.009; Tue, 25 Nov 2025
 15:17:06 +0000
From: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org" <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/1] libtracecmd: fix memory leak on partial reverse
 iteration
Thread-Topic: [PATCH 1/1] libtracecmd: fix memory leak on partial reverse
 iteration
Thread-Index: AQHcWu1yHuro//GboUuwDd+aQ7GpIrT9WwyAgAQ0cgCAAIHRAIABdfOA
Date: Tue, 25 Nov 2025 15:17:06 +0000
Message-ID: <aa7d58fc03dd7a43b51ad4daa8ad9e328a16883c.camel@siemens.com>
References: <20251121134749.1530855-1-felix.moessbauer@siemens.com>
		<20251121120117.20e82d9e@gandalf.local.home>
		<e113f523ef34efe5edab24d5dbad5cd40db9ea26.camel@siemens.com>
	 <20251124115840.7a4de310@gandalf.local.home>
In-Reply-To: <20251124115840.7a4de310@gandalf.local.home>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2-7 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB6828:EE_|PAWPR10MB8258:EE_
x-ms-office365-filtering-correlation-id: 364022d2-edd0-421c-a01e-08de2c35b224
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?SDE4UmZPWlR1ZnI5ck5NcHhPQUFQNFZ4OUk0ejJBa3BZUHY2ZjlJNVc2aWtZ?=
 =?utf-8?B?ZmJteXYxMjM1L1lURjFYMW83a2JCQmxQVnh0WktqYThtYlMvdkFTOTJ5a3NX?=
 =?utf-8?B?L0NhT09CT2hpQThuZTc1cHh4Njg1cVhOcDNJUUY2NTAwR1pOUzdnRGdTU29N?=
 =?utf-8?B?Q2Z0YnAvSSt5Z2pra3BaUkpDN1BnbEYzTXowLzFFUnpmRW40b0ZkakYxc2d3?=
 =?utf-8?B?NDNSNUpSUmlMVEd2NEhCdDRjSmtRMkI3REhYVXpVLzJmK2xXTzgvSDhHT1BZ?=
 =?utf-8?B?SFIzTE9rVmxzSTBSRkdadGVMNUVNUU44NXNNNys3ZFRtRmxXeEIyazRibXIz?=
 =?utf-8?B?UW5IQXYzQXBTV1hFY24vMnB2d21Pb3AydzBhRVdvOWVpNGV4ZE5KZjdxek5r?=
 =?utf-8?B?Vkd5ajVGdkZYMUh6eVNyTzNnN2pxK0RMdUwwWGM5eFVWOVA3TmtxSy85czFi?=
 =?utf-8?B?Q0pQb25kOFpLdGVSdkJiRmtIQkN0L3JDbVl5SlJaOEhVTzhYSURNUVY4Zksv?=
 =?utf-8?B?V3habTgxSXZqZDNONWhXRzRHb0FUYmVaT2hJcWU1YWNhMmlyRGNBU1NBRDRV?=
 =?utf-8?B?WnVuNThyWElSQmxuUHN3V3VMZThkc0duYVlObUpqaStKelFxRHpzMno4VHZt?=
 =?utf-8?B?eEJVZHNnMFRTclN0elpDUTNSeU5qZkZwK1ZzczJPZnVPWktsZVhsMTQza0ZK?=
 =?utf-8?B?OE5EL0JBY01acEo0MTFXc1FZTmV3WklXN084b0M1c04vRXU5K3JWYlJ5dXIr?=
 =?utf-8?B?dnJrSmVXUThFaTFqSFFrdjlhajBnVFZzVzdWZ09nZEcvOUFBcTVNVFJ4bDcr?=
 =?utf-8?B?OVRPRUtibmlQaks4RXBwTWdRakgzN0FHQkdLYU1vRWc5UjJGeDBKVWJDRmZL?=
 =?utf-8?B?K2s0QjRQTEhwUG5GUnJtc0M4OWx2V2x4YmNaejhoNkxCeGw5Um5DbFg3YnBO?=
 =?utf-8?B?aHhIK1d2K2l2NWFNZkEvWXVLZHZiU0xtSXJVcHRLZjJYSGR0Z1kxWXNydUdV?=
 =?utf-8?B?WExIcS9MK2pzOFkyUjIrZGlKK2FRdEJCNFpNSjU1QjEwcnJYSExidG5oNitG?=
 =?utf-8?B?QzJndGRKQTZCSGVUR1hSSllhYWdRL2pJY3pHVndyWko1OUhncUZGeG5DUXRF?=
 =?utf-8?B?QVk2MDdiaDBKMk5rR1d2KytlV0E1a2JCMnkzb1I0S3owR3h0eGxwcjl4KzJX?=
 =?utf-8?B?aDJZOUlhN0NvMVhNb1Vma3BXendONzFWZjI4NDYybEFBRjkzQUxSeVgzZmZW?=
 =?utf-8?B?dmZ4WUtiYnJHOGRJOEZOcitEencybldCbFN5bWp2ek9HNnFyTGVTMmZtbThJ?=
 =?utf-8?B?QXQ2Mk5KYlpmNFlrRm9SVzF6RE9BaVo4SFN5ajNYTGdydTA4TXgxVC8xU1Rt?=
 =?utf-8?B?VWE2QWlWMFJkNXdCUXZYalVrcXNMRENtdEdLd3lpNFBVcnk5cytXQytsOENs?=
 =?utf-8?B?N3Q2bUhhRXozcXVkUWpmb0JyaDl5N2Fnd3djMlpJazUvWlhkMjFOR2E1MVBw?=
 =?utf-8?B?N1k0V2Ryc2hQbUYxQldVODJTZ21EV1Q3d2p5SThtS01jcjhHaDlaQSsvMUdE?=
 =?utf-8?B?UFNjeEkrdyt1K0xDNTFGbWN5bHlmVWN4WktRUm95bHRSaTcrdkQxUkhZTlBG?=
 =?utf-8?B?OUNDR2VZYkhLL2FuUnhiVFg1QVhXYWRmaVM0eEcyVTVPN1Vjb0pHSTZEZzh5?=
 =?utf-8?B?NzJYOEoyS1dza3NzMTY0WVNaMG5aYS9kbTZRWHE4OVMraGpFeEJ0SVRkRWkx?=
 =?utf-8?B?TGQ3U3k1YjRSaVNEa0pzaW5wNEVmWWk2QnQrZnRvRVBRZGlXVERyQ3NIdkY2?=
 =?utf-8?B?MkdRWkkvZU5DQkNRZHpvd25nV1NWM0ZTMmYweGJnZXZZcDAvTVRrWTU5MllR?=
 =?utf-8?B?TW14MVlNd09TQ09pakd2Q21OdDNFTkZpOUJ2RStKSXN0V0lFYnJFVFVGNXMx?=
 =?utf-8?B?ekc4eU0wdzlxWG9pWUxQb2cwc0hlZEtpV3NiNjd3SFpKeDVDUVFubGNlTDFO?=
 =?utf-8?B?cW93aElyR3lzQU54WWFnaGRNSG1yenIrbmd6ZWpiQnpVRjdmK1VWWWxaRzNG?=
 =?utf-8?Q?z+cgS9?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R1FXODFtUlF0WlV6VlhSdzJRc1hWOGJsVUJpaW9iVlNqMmI0REx0ZXc5YlZV?=
 =?utf-8?B?WWh0eGFDV3orWk11NHJKa3NaSWFyZjUydkM4VHlua3N4eHVhWGJtUmhkTnZ1?=
 =?utf-8?B?bm90bEVZYnRJelg0dkZvR0hIOU9qdWsyaURDR2dZOUM1SFFUNG1GVENkNXBY?=
 =?utf-8?B?d0RUeGVrM1J4ZGRER0NjaUhRdEtQaEdwSzQ4QnBFUGZLSDZYUFB1b2JqSEtY?=
 =?utf-8?B?WWNqbkU1WFZoeGlydno3ZmdRZU9Kbm5ubTUzNXNNN281VFpUQTV3MTZ6ampM?=
 =?utf-8?B?RDE4K3c1aTVNdGtmWjB5TWx6VDBlWCtBeXRRajFnL295VmlqcVF2emQ2YzZl?=
 =?utf-8?B?QnVpWmV3SVJRUC8wL2dkL09ZV2lUUStDQTNjcERIQ3RmQzhUbzdoS2ljR0tF?=
 =?utf-8?B?TWZzL3FOam5DWDFvdGc1R2dYM3h5b2pnRWg2OWpnUVNWVkg3TW9mVnlUSTh6?=
 =?utf-8?B?YnBHSlRvWnZlaUxMZDhrQkF3VVBHOStXL3Rkc3U2QXNlaU1yOTI2cmxuMW1S?=
 =?utf-8?B?eHBKN3k1eUFXT25odDVWNUJqQzlrdzJDbUdqUjlLTkFsTXM4Tnl6V2JsdWow?=
 =?utf-8?B?QVVlRGZQRXhza0ZPZzZtV3lzQVJ5a0k4WVIvQ21FMitxYWFOdE10WUFDUWdJ?=
 =?utf-8?B?RzlvQU1HRUxvcExVMXdidE5QcnZhWG55ZEovUytnamVzdVdCejZkcXRmS1JH?=
 =?utf-8?B?RkNrOFRzM0JiUUNxQUl6VHRsUld4THdQRFVMWjVkM3BaR3gyeUVtUmhDVlU5?=
 =?utf-8?B?ajRlWXhOOVRHSEhpNEIzTHdWMmNzMFZpdDMyYXhaZFpqdGlMV0wwN3VsWnk3?=
 =?utf-8?B?RS8rRWpnZm5UMFBRN3V5Q3U5SzdNUDRNNWhnTVpFbnZwclZacWVUa0xOM2Rx?=
 =?utf-8?B?dnM4SE5kaENZdUhoeEJ4TC9teEhweGN2aW9hNTZqS3JLMnpvWk1IQzRsYStz?=
 =?utf-8?B?cFpWUVdMQWNKZmVRYzdKZk51RDlENnBPR3BlbEtoVEFWZFluN1lLMG8zTUhx?=
 =?utf-8?B?SVdQeDZXVHVGcU9jbUlseDl6RTZtU1UvdXYwMWRVb3pNeE9kNUU3bGZIYlI5?=
 =?utf-8?B?Q3czaUw0NzhvNlJNKy96ZHFpRzRxSkpwdlFCcjMwWURFTklJZWo1VnJTQUUv?=
 =?utf-8?B?eElVMGtJUktVcnBWUFR4cGp4VEJDRDdUWFcydzYveFowdkwxRmlMWHZDMHBE?=
 =?utf-8?B?Vlk3ZHNtc3lTM0liMGNKZ1B3T01ZaC9rUEZ0SFNCU3lkVk9Qa2RtZGtubHlt?=
 =?utf-8?B?SDBQVlNmMWxvWmxqQTd3cW4rV0pGOFAzaDBSZEtVUHYzUXhpRU82K0xsM292?=
 =?utf-8?B?NmFMQVdtSEJuTm1YdEtqVDhMK3dXTy9sMVVYd2F0aS8zdFNSWWorSGdsWEJL?=
 =?utf-8?B?QjhaNWt4L0UvQWI3Q2I5SmlnWWZaMXFTQ2tuWmdOR01NdVJOdkVaOVk2akV2?=
 =?utf-8?B?d0RjVDcxM2lBTlhCbFVaRGg5MjdVdXZsV25HckdXTjdoejhMZ04ranhvVXl6?=
 =?utf-8?B?QzFBUmxHaTB5SFNlSStKbjdLakdNYjdBU1B6UGM3ZFlZSzk2eWVCWjdsSmN6?=
 =?utf-8?B?NnFhY05ZQmUxUHlUR1JVQkoyaHNleEtjUlppODRaZUFFN3ZRaXo0WkN2TjJy?=
 =?utf-8?B?ZVdTVTMxVVNoSW51RGpZOXo4ZXYyZnN6UXpOdEpPUlRRb3lyQU9UKytMVUNY?=
 =?utf-8?B?ZmZLRmZ4NVpOWVpIMGZuMkRwR0NnUlFXd2RGRDE5MUc2Yzk5THhXYWdZdVNl?=
 =?utf-8?B?YysyS1RIN2tUTTFvdHUwT2ZJZ24vSGNtQ01JNnQwUDRlRi9BNFZyWWpBWnEy?=
 =?utf-8?B?ZEVPYU40VVltRFJZZzhxOXArekh1REc0UE4zQkJFV0xIR0VzelFOUmIxbUFL?=
 =?utf-8?B?d0lBbGZFMFhYVDZXYmFFQ0ZIRnBZdWlGRVUxcnpsenVJc3lhMFNWd0tJcnFG?=
 =?utf-8?B?cldJd2grZlVWeURMcHNkQWV2ZHpubjhaaWN6RVY3MGxRR0tPeVNUUjk0MC9j?=
 =?utf-8?B?NE9NZHZLVSs5R21GRWtmTTg4d3JUN2tiT1o1VUIxL24wNkpZMFBQMDJBbUNN?=
 =?utf-8?B?bGptUkFqaGFkMlVhdGdXWmVOdzY0ZGxreWtoUTBNcTVHUlVJQnoyWlV3Y3Nn?=
 =?utf-8?B?MWVRVEtoT01QSmRhSGhFS0Y0Nmd5ZStQWk40NmRMNXlhMEtBZXhOVG9rdGdp?=
 =?utf-8?Q?RyhyAaGhuBDBEJJKvFuFdOs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D6E315384091124483753ECDA86C1F8B@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 364022d2-edd0-421c-a01e-08de2c35b224
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2025 15:17:06.6206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kl5woKbjpyeRBaxBOogc3CV5RjPvUmj5fU6+0/tAJJaetooUG4YW8cuCnN3hRTtEJSRimwwTjcHmxVqsZxEAheqU//5qTPkDcKl5p0TmGLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR10MB8258

T24gTW9uLCAyMDI1LTExLTI0IGF0IDExOjU4IC0wNTAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gT24gTW9uLCAyNCBOb3YgMjAyNSAwOToxNDowNiArMDAwMA0KPiAiTU9FU1NCQVVFUiwgRmVs
aXgiIDxmZWxpeC5tb2Vzc2JhdWVyQHNpZW1lbnMuY29tPiB3cm90ZToNCj4gDQo+ID4gSGksDQo+
ID4gDQo+ID4gd2hpbGUgdGhpbmtpbmcgYWJvdXQgaXQgYWdhaW4sIEkgbm90aWNlZCB0aGF0IHRo
ZSBjYWxsYmFjayBiYXNlZA0KPiA+IGl0ZXJhdGlvbiBpbnRlcmZhY2UgcmVsaWVzIG9uIHNvbWUg
YXNzdW1wdGlvbnMgd2hpY2ggYXJlIG5vdA0KPiA+IGRvY3VtZW50ZWQuIFdoaWxlIHByb2JhYmx5
IG9idmlvdXMsIGl0IHNob3VsZCBiZSBkb2N1bWVudGVkIHdoYXQgaXMgTk9UDQo+ID4gYWxsb3dl
ZCB0byBiZSBkb25lIGluc2lkZSB0aGUgY2FsbGJhY2sgKGkuZS4gY2FsbGluZyBhbnkgDQo+ID4g
dHJhY2VjbWRfaXRlcmF0ZV8qIGZ1bmN0aW9uLCBidXQgYWxzbyBjYWxsaW5nIHRyYWNlY21kX3Jl
YWRfKiBhbmQNCj4gPiBhbGlrZT8pLg0KPiANCj4gQWdyZWVkIHRoYXQgdGhpcyBzaG91bGQgYmUg
ZG9jdW1lbnRlZC4gSSB3b3VsZG4ndCBzYXkgaXQgaXMgIk5PVCIgYWxsb3dlZCwNCj4gYnV0IGlu
c3RlYWQgc3BlY2lmeSB3aGF0IHRoZSBzaWRlIGVmZmVjdHMgYXJlLg0KDQpBZ3JlZSwgbWFrZXMg
c2Vuc2UuDQoNCj4gDQo+IEkgdGhpbmsgc3RhdGluZyBob3cgdGhlIGl0ZXJhdG9yIGlzIHNvbWV3
aGF0IGltcGxlbWVudGVkIGlzIGdvb2QsIGFzIGl0DQo+IHNob3VsZCBhbGxvdyB0aGUgdXNlciB0
byBhc3N1bWUgaXRzIGJlaGF2aW9yLg0KPiANCj4gQmFzaWNhbGx5IHNheWluZyB0aGF0IHRoZSBp
bnRlcm5hbCBjdXJzb3Igb2YgdGhlIGl0ZXJhdG9yIGlzOg0KPiANCj4gICBkbyB7DQo+IAlyZWNv
cmQgPSB0cmFjZWNtZF9yZWFkX25leHRfZGF0YShoYW5kbGUsICZjcHUpOw0KPiAJaWYgKCFyZWNv
cmQpDQo+IAkJYnJlYWs7DQo+IAlyZXQgPSBjYWxsYmFjayhoYW5kbGUsIHJlY29yZCwgY3B1LCBk
YXRhKTsNCj4gICB9IHdoaWxlICghcmV0KTsNCj4gDQo+IEFuZCBzdGF0ZSB0aGF0IGFueSByZWFk
cyBpbiB0aGUgY2FsbGJhY2sgY2FuIGNoYW5nZSB0aGUgaXRlcmF0b3IsIGFuZCBjYXVzZQ0KPiBp
dCB0byBiZWhhdmUgZGlmZmVyZW50bHksIGp1c3QgbGlrZSBpdCB3b3VsZCBpbiB0aGUgYWJvdmUg
Y29kZS4NCg0KSSdtIGp1c3Qgd29uZGVyaW5nIGlmIGFsbCBwb3NzaWJsZSAvIHJlYXNvbmFibGUg
dXNlciBpbnRlcmFjdGlvbnMgbGVhZA0KdG8gYSBzdGF0ZSB0aGF0IGRvZXMgbm90IGxlYWsgbWVt
b3J5LiBBbnl3YXlzLCBqdXN0IGRvY3VtZW50aW5nIGl0IGlzDQpJTUhPIHN1ZmZpY2llbnQuDQoN
Cj4gDQo+IEhtbSwgbXkgZml4IG9mIHRoZSByZXZlcnNlIGNvZGUgaGFkIHRoZSBsYXN0IHJlY29y
ZCBnZXQgcmVhZCBhZ2Fpbi4gVGhhdCdzDQo+IGRpZmZlcmVudCB0aGFuIHRoZSBpdGVyYXRvciBp
dHNlbGYuIEkgc2hvdWxkIGdldCByaWQgb2YgdGhlICItIDQiIGFuZCBtYWtlDQo+IHRoZSBjb250
aW51ZSByZWFkIHRoZSBuZXh0IHJlY29yZCBhZnRlciB0aGUgb25lIGxhc3QgcmVhZCB0b28uDQoN
ClllcCENCg0KRmVsaXgNCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gLS0gU3RldmUNCg0KLS0gDQpT
aWVtZW5zIEFHDQpMaW51eCBFeHBlcnQgQ2VudGVyDQpGcmllZHJpY2gtTHVkd2lnLUJhdWVyLVN0
ci4gMw0KODU3NDggR2FyY2hpbmcsIEdlcm1hbnkNCg0K
