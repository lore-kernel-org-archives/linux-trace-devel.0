Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2054.outbound.protection.outlook.com [40.107.241.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F1015855C
	for <linux-trace-devel@vger.kernel.org>; Mon, 14 Oct 2024 10:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.241.54
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728902596; cv=fail; b=SEAM3lZf1cg+8IhgxhhB4hLDNY2LHlTD3fAUt95K3e7abEoITRm2Cu6i3/epdzJo5aTeD1I5yQn0gfKjrrzZMBD4bdbc8KdkTZ4ouklvz6uEpl8jqh6Se9NM5KbIsdSxU6QRa+gebEYDBqIkL392l/aS95izJbd/80J5ZJvhnyc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728902596; c=relaxed/simple;
	bh=12DrIvQzDYexxoVhmPivGd2cwf4d8lporWPYanu8fyY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MSjUM0tUQ6MVDqNpf68aZSrB+puz4neh55/ezsr5m5cVccoPuJLU7UP8gyx01V9/ypHDNOCYbBam+Y3Nn/GsJrLNtsr4Gr4qvCH5fYtjrQMfCPJXhC31qJps9ElwvJljuV5UnVlJBhU2YVS964pue6EG0mK8ke5d6pOv+FVQlcI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Sgnht+Wj; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Sgnht+Wj; arc=fail smtp.client-ip=40.107.241.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Sgnht+Wj";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Sgnht+Wj"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=L4YEqzghTO7J9/3BiUJl2Cyb3vpf8BeYK4XZMLLFvw0pDWHO6H1UBebFDGjSPiczN3KOIjUIxnQEZVRBhOOolNnTXwlw0NQn/EMd1x+MSFYeWqSWicixTzX46wdn0GJZAUIqFb+dIVUcUtXNmdxQgwUfve47DLEGjyX4Mbk8lERbVHlAx7SwOe+iruzVwcGSGFi4dz7MAj+8k1q/n5hQjnsTRZ94y3U9jggPGRsYopf0evj4sMbnKFg5PpwnNoXeA6T+XtwPob9ALvCXXaSmWU76Ro9jRfXukzJofKYMf3KeTUSSlUQ6hwmeUTgOLL0LKj3N5yu3hR4+ojeOSuNVtw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+1Xx4l+3+cE6JT35SK0fiDZhdDRxS6ZIjCBwt6pO9Y=;
 b=hVC6UCewrwTXxX08oK7rl6y5GlfojrcRExp+usjBfQKIkD20fOX89Z9xhefxWoyq6AuTzyoyT4FV1EwbY1bDHioc63RIOZ/gwRYmQkYjAEwt2vK/o9lqwLoRJmaQZ37Kn+VkRyy7+VGGaUZt1+I62P1SokSSf90SrZjqrTsXx1pYNKQfgfbo3aRpBPdEoSS7BO6DtEz1hOPn0bVF1QKYeQuSXMO1L5u2RKIL3jpG/ALrKsF/WfWRSTSnUyjTwJDO2MbRViiOITCoRAktqLRw0yvytOoiQtQtApGWlj7Q9c45phN2aohPzo1UAmhtw3pKKHM5xKKUQebuOa9p+VF62w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+1Xx4l+3+cE6JT35SK0fiDZhdDRxS6ZIjCBwt6pO9Y=;
 b=Sgnht+Wju9eZfiYeHFN3EhxUs1OSRYW1MECcab7xKiR/c3j3RYwvEhlW0ExS+Rq19/fySMiFpsw/TZW+FvJ8I31b4CE7hvARepYVS562BQHVrCHaLRQwc0+d+zKjQnayKUWQ1zRWPUlxcqhD/Er2+s7e+yh8QgFghbRhIj6u0ic=
Received: from AM6PR04CA0012.eurprd04.prod.outlook.com (2603:10a6:20b:92::25)
 by DBBPR08MB10841.eurprd08.prod.outlook.com (2603:10a6:10:533::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Mon, 14 Oct
 2024 10:43:04 +0000
Received: from AMS0EPF000001AC.eurprd05.prod.outlook.com
 (2603:10a6:20b:92:cafe::88) by AM6PR04CA0012.outlook.office365.com
 (2603:10a6:20b:92::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27 via Frontend
 Transport; Mon, 14 Oct 2024 10:43:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AMS0EPF000001AC.mail.protection.outlook.com (10.167.16.152) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Mon, 14 Oct 2024 10:43:03 +0000
Received: ("Tessian outbound da7ba6582322:v473"); Mon, 14 Oct 2024 10:43:02 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 834e1cd3a0c76405
X-TessianGatewayMetadata: MnIP4E8x2qovMTc5bvIokHyg9HixgnoOm4U6UPmp0MWLCwvsvtGRTr1L35eVNl2r+KCWpJdSoU2vWl6VkURCbXa51AYzxLJc0BVLta976TGvWQY2Gv0P+0aCZ3jlKXF5XWTtyJRIH9Au0TiqcwvE1mRXnUc4NNKeV3+zJ+OPSD0=
X-CR-MTA-TID: 64aa7808
Received: from L12706e76b510.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 34872798-36CD-440F-AEC6-B1D242285393.1;
	Mon, 14 Oct 2024 10:42:56 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L12706e76b510.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 14 Oct 2024 10:42:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d9ihaiNTTne7MqLiF0QEMUpd/eevqmxzL0HAh+5Rs61TGu5Z10OfMc76WPqhIGF0pCD0L7gMXpPjYPdBIBUibfsjgRPBuVKqQn6hbSzvVo9R35RfoO+XtkRC7ce2hJKlT9n4N5zGWH9S4sKDQx1esI9q20w7h6ZXHeYpE272f85h9LzB5wKXeJq3l5tQEJBq7KX26weK4UyHe9SFIuKt2yBXOGh2c32ATwLliKJD87EULOTuOxuhCULyvDQqeBpIKady7Fwo+vQVS6u6rrz/YAVn/m9WXRKIWTCqYlLGLticQOBI8yBgpkQJP4ZBoqOkIAd5fhDWlieS+jUyiTKBww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+1Xx4l+3+cE6JT35SK0fiDZhdDRxS6ZIjCBwt6pO9Y=;
 b=B30MesO+EhlkaitXg9NCK+qxNpulXvpJXYd0oaP2R4hr8KNA2i5oARv8UB/etGs+OCQnl2Bk1DdNzMcds5YmFFlEfxfA/ej9+WE8L3psoJVR0l+Yi50FLrsk2ZqlhU6kdyAr3c0TBtU1ALwSfC/cxnJ/k7kX/+lv8O08Z2uljHAjX6ImbMB/wyxxqfEylxOp14En+LvCOwPjWChL1eTOOwBgmcVT48e71uiOIxPZkN82kqUq1Oajz9SLS16vi91du1xe/Gb8g4KipyPTu2V+rbUYhecD+D43dGytmKxceRIsJ8hl3vuRhHfVUGBzIs3/dmg5emIRYPPIWmIu8nGkQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+1Xx4l+3+cE6JT35SK0fiDZhdDRxS6ZIjCBwt6pO9Y=;
 b=Sgnht+Wju9eZfiYeHFN3EhxUs1OSRYW1MECcab7xKiR/c3j3RYwvEhlW0ExS+Rq19/fySMiFpsw/TZW+FvJ8I31b4CE7hvARepYVS562BQHVrCHaLRQwc0+d+zKjQnayKUWQ1zRWPUlxcqhD/Er2+s7e+yh8QgFghbRhIj6u0ic=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS2PR08MB8288.eurprd08.prod.outlook.com (2603:10a6:20b:557::8)
 by GVXPR08MB10864.eurprd08.prod.outlook.com (2603:10a6:150:154::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Mon, 14 Oct
 2024 10:42:54 +0000
Received: from AS2PR08MB8288.eurprd08.prod.outlook.com
 ([fe80::85a6:7b0e:5297:24a]) by AS2PR08MB8288.eurprd08.prod.outlook.com
 ([fe80::85a6:7b0e:5297:24a%7]) with mapi id 15.20.8048.017; Mon, 14 Oct 2024
 10:42:54 +0000
Message-ID: <0826237a-b391-41c5-ac1f-69e51864b5d8@arm.com>
Date: Mon, 14 Oct 2024 11:42:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] trace-cmd reset: Add option to preserve specific
 dynamic events
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20241010085350.3479149-1-metin.kaya@arm.com>
 <20241010085350.3479149-3-metin.kaya@arm.com>
 <20241011195411.0fe6dd81@gandalf.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20241011195411.0fe6dd81@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P265CA0129.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::20) To AS2PR08MB8288.eurprd08.prod.outlook.com
 (2603:10a6:20b:557::8)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS2PR08MB8288:EE_|GVXPR08MB10864:EE_|AMS0EPF000001AC:EE_|DBBPR08MB10841:EE_
X-MS-Office365-Filtering-Correlation-Id: 107e7b24-d75a-49eb-8d4d-08dcec3cfae9
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?WUN0UG5iWHdGYkxHbGxtUFZXbExraTFMd2JVNGdiK3VQeWtOMHo4bXNYL0Q2?=
 =?utf-8?B?Q1B4ZFNadFl2Q0VWTHRINXlWK2R2YnN5cHEzbWpHQWV1NVpUU1NNWGwrL1N5?=
 =?utf-8?B?cjJ0dXhHTHZSbmE3Szl3RTdJWnV1L2xmaVA4S0plaHR5ZEgyZmhsU0lPNXFF?=
 =?utf-8?B?SnRYT2VVbUY3aGg2UlFWa0tud2tEUFdRbHVrMEpLclZqYzByOGoxY2ZzSGhl?=
 =?utf-8?B?cTRxZHZMam14dCtEOEJzZS9yVlBNMG5sSXprdVRxa1JmRkFUdXZXQU53eitm?=
 =?utf-8?B?ejd2aXBWcHNXSEVMc05TenRZeitNT3RhUlBNR09JUDkrMUpWb20xZTY0d2JO?=
 =?utf-8?B?U2ZmUkliQ3dtSnZuQTNOaHRuRENqYXhLMEZibGh2bTRMSkU5VUMwMDFHNWc1?=
 =?utf-8?B?OFdyZUFZbnJBSmJlanQ5cm9Xa2wvMzJuREdWTzJOaFU1ODdpOVgyV3MwV3J5?=
 =?utf-8?B?TkxmMlFCd0lwekZFdTY3RERFdFpUSCswak5EbGlZU2lWNGpGakFTSS8wdjcx?=
 =?utf-8?B?ajBqTlJCWStjeVBzb0N1NUNzRFFHZVEyTUFXcHFCQ3YxZlZWbys4U01TUmcr?=
 =?utf-8?B?LytwbDNnUlN2T2ZuaTVYVjBteGdyeEFKcUtvRWZ3VkM0c2RCWVZnUG9kME5U?=
 =?utf-8?B?ZzhMdzNHdlVkajRqZytCdUZkaG05dHowNFdXR1pQMEc0dVVQYWZiUndldVoy?=
 =?utf-8?B?VWQ4dTdBMzc5Z3Z6azMxejZjYmZpV3MzN0V3dUJFd24wcEM4Rzd3Skhpai9j?=
 =?utf-8?B?T0U0SmJWUnFtd3I1ZlVoS1VtNE9heHowTFRFZERudStMZzJnQWozN29pT3VK?=
 =?utf-8?B?b0xEWGlHU0pLQTBqd2ZsYzljc1NGVGI1ZzB3L2FwRTl0RXl6MktycFpvVmo0?=
 =?utf-8?B?YjFSWjNUZ003UnhYV0ZRRlVwTkdIL3Zad0JEekRtcW03VDJMZ2p1QVlqaVJa?=
 =?utf-8?B?azRveGJ5dURmcTRnc3VYZ3haam9Od2c1YUtoejljZXZTMTFiUEVZYjlmUEpi?=
 =?utf-8?B?bllyS0d0TVY5RThlUWRDUEJmWFJteTZoVDE2V24vNVNCd201YzBjUXkzandF?=
 =?utf-8?B?cTB2L3pNRE1aVFlieW9yS0ZHVjg2Nk5mL2dnTEFtb2YvTWYxMXd3T1RJVWgv?=
 =?utf-8?B?VUR4eWJSREl6RFhVKytrMzg1UG05NUV4bGJWRE82MUh1QWxLVCt3Z3hzaGZU?=
 =?utf-8?B?dWVuYWw2WGt3emtGc2ZqeWFmRWpyQjBxMm8wTG84REpFU3pVYU9WL0xSckdJ?=
 =?utf-8?B?MUp5TnFXSis3bFo3a1V1UUUza1NuV3FBK3Q0cGcvb1JQVWtxeTJsUDFhOTlO?=
 =?utf-8?B?azQ5dzhYdXB0UHdGK2dWSllpeHFFOWFKTVdFK250eXBoVWliYnR6cWlka2Fy?=
 =?utf-8?B?ZmkreGdhTGhPT1pjQnBaN1VSUXZrWFNUcmdId0ptTVl2QTJCMU5INSt5ZGNy?=
 =?utf-8?B?VUpmRFBVMkw1T2pnQ1NCSnhwRmpJdEdnb0FPdkIrb0pSYXgzdjRCUzFlS1Rk?=
 =?utf-8?B?UXBrbHdKYW9wQ0VwSVRDV1dWYTV1SkJBOEpNNVFmQi9seUZVclUvMGpXV2oy?=
 =?utf-8?B?UlQrdjVkVWZ5NmxXQkM0SDNxaHhUM216K1hieEpHcU9oRnpFak4weW93V2I4?=
 =?utf-8?B?QjdyRm93ZTRpTG1qTXJWWTBUb2xvMmxLMENxRjNPbHBxVm5OY0l5aW44ZjEx?=
 =?utf-8?B?anhQSVRJc2p5QXRsaWphMm56dFlnSk9LWFQwNCtzYXBkWCtXTTJ4Ni9nPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB8288.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10864
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:20b:557::8];domain=AS2PR08MB8288.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001AC.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bcd326a4-9b6c-40da-dba6-08dcec3cf5c0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aDFLaHhKVjgxV0UvWXROSWtyUnFSM1dDMmYrbTJlM3UxcUNPSi9yQUVzeEh5?=
 =?utf-8?B?cmFTTW5xN2lrMk9PamRQVTRuMHF2eHMrYTl6NUhaZG85Wk5sL0tzeEdLQXJV?=
 =?utf-8?B?cmxmSGNKRDEzZmRibEg5eGdCMDlPSVhacVRMbUQ0WW0zZEpPSVl0WEswQkZi?=
 =?utf-8?B?OFlnS28zK2s3YjdTOGJmQUJOd1krbTBGbURRaXhacjIwTlRQdHRUT21NOEZ3?=
 =?utf-8?B?MjlvUmUzU00yQTd0dEIyUkJ1UGkrR3N0RlQ2cS9WSGJrYTcxQlIvSHA1Tk9m?=
 =?utf-8?B?RHZzbmMvOElqV0JxT01YblQ5anFtR3MvV2JwZGpHKzZuZUtPVkJyQ2MyTUsw?=
 =?utf-8?B?VVNsaHNodUl5V0t2cStsbFhKRlNSVTNlNlBxbDIrWUtYSVJjSURCK0JCVTBT?=
 =?utf-8?B?UUxEMCtmRmxGUHArZllxVnljNk1YUGx1TWZiYzczanNFNlUzUXFIaFZRYnhW?=
 =?utf-8?B?OGtMTjRIQzlVUnZYQURMNEdYOXgwN1pPQWRFZkptbTdEUjhrLytScU15NUsw?=
 =?utf-8?B?VUZmUiszOU9LczZEcEtvWGJjRERGQkJDY2F1bkpEd2ZKQXBFbXYwNS9HeWpU?=
 =?utf-8?B?blZHWVNaeW1pR2E0emFMMG1QemhHQ01hU1FyMlhjdjQ3SlMyOWxTMW9KV3Bs?=
 =?utf-8?B?cWR4UiszM0pVZVJTSjc5QmRNQkNNOXBFd01GaDNaaFNQTTZCVWd6K25YaElm?=
 =?utf-8?B?cUg1amp0T0hoaUVnVmpGMy90K0xHUDNtcmhHUmZDWXNaNGNnVU1rbWIrNmhQ?=
 =?utf-8?B?SEdFaytIOXNNWjFtbG9JTkhlMUkyUlcwRW5INGJoRFBrSEt0NlpmSS95WDBD?=
 =?utf-8?B?TVVCVFNKZnp0OFJjV2djQmY5RTRWY1Z2N1RwTjlhMkRpUDlBYWRkQmtrNjJz?=
 =?utf-8?B?Mkhoclk0SC9mN3dVdU5IR3daT2dpMTZJbzBkc3YwQjM5UGQ5TG1YY2tHVVVl?=
 =?utf-8?B?YWtObmRvbzZPRGNmVmN1RDM2M3ZtLzlDM2xUZXlMVE84VlJuaVdwSFM1OHFV?=
 =?utf-8?B?cTh4elJCdmZQc3Z6dXRiSS9md3VCbXVhVzdqZVU0UEtEQ2k5RlhOWkZITk5B?=
 =?utf-8?B?akpoemlNK3B3UGxobFE1dU5DcFRScTR6SnlQUng0WFl3UEE0eko0dm1odG5Z?=
 =?utf-8?B?am9iVXRST1JBVjVtSEY1Z1hnaTMrKzJ3SGg2OTlheG84MFY0ajlzQzFuZmE4?=
 =?utf-8?B?NTNYYWxhZzFwL2k2eCtsN083UXNEdXdhMGc5SUwvMWlRYnFvRUprVjhPckhM?=
 =?utf-8?B?NGc0enVZYmlVREwweFQ2K2tHMlBYaUNZT1VBQ21JVi9uanhSaDNHd0VmWE9G?=
 =?utf-8?B?MnRMdGJvTFRTSFFERTBmTVpQZFIxbEZtZkJKYzVGazRkcWtXVVg5YTFpTUZ4?=
 =?utf-8?B?MDAxYXE5dGY2a0lJclBseWdLZTk3bU05NDVwL3lRbm0vQWxYZnhYQW1MYURT?=
 =?utf-8?B?SFd0cDRrdjBPS0Ivc1BWdjdmYXljU1ZUbXhBeVdZa09qOGQrQXdrUWRyMHNQ?=
 =?utf-8?B?NXlWQWJCS2JDYkw2Zld0bVBua3p6emlYVUxyd3VhNHJpNTRaNUlCZ2xoelp2?=
 =?utf-8?B?NUd0OStSOGU0bi82N3NydG9WakpIM1l5REpZd01lS3BUejBtYTVOeTZ2S0Z2?=
 =?utf-8?B?Y09ZMllSNjM5dVBUa2pDN1ZUWnBBVWpRZE1LUmlnQjhXL09UaUpreDVHRDVv?=
 =?utf-8?B?eGFVcjNoMCs4Z25ERG11UnZ1cEg4MnUva1VtUFZDQllTMEhjUHQwL0ZvQnR0?=
 =?utf-8?B?bitEMzF6dERaR3FuVVNOTHArRWhyTnY2bmljaDJqa2xaYmdQNlByT0JkeXVv?=
 =?utf-8?B?UHIvUlg4VkRZbG0wQkZXVnRmbU84L0QwaGNOQ1pYL0FzNmVPUlBjN2dkOWNB?=
 =?utf-8?Q?7T7GCQEsyF2YS?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2024 10:43:03.0945
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 107e7b24-d75a-49eb-8d4d-08dcec3cfae9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AC.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10841

On 12/10/2024 12:54 am, Steven Rostedt wrote:

Hey Steve,

> On Thu, 10 Oct 2024 09:53:50 +0100
> Metin Kaya <metin.kaya@arm.com> wrote:
>
> Hi Metin,
>
>> One may want to preserve some of the dynamic events (e.g., kprobes)
>> during a trace-cmd reset. Thus, provide -k command line option for
>> trace-cmd reset to allow keeping specified events untouched during the
>> reset operation.
>>
>> For example, it's possible to prevent kprobes & kretprobes from being
>> destroyed in trace-cmd reset with this patch:
>>
>>      # Add kprobe and kretprobe for sys_open():
>>      $ echo 'p do_sys_open' > /sys/kernel/tracing/kprobe_events
>>      $ echo 1 > /sys/kernel/tracing/events/kprobes/p_do_sys_open_0/enabl=
e
>>      $ echo 'r do_sys_open' >> /sys/kernel/tracing/kprobe_events
>>      $ echo 1 > /sys/kernel/tracing/events/kprobes/r_do_sys_open_0/enabl=
e
>>      $ cat /sys/kernel/tracing/kprobe_events
>>      p:kprobes/p_do_sys_open_0 do_sys_open
>>      r128:kprobes/r_do_sys_open_0 do_sys_open
>>
>>      # Issue reset, but keep kprobes and kretprobes ('-k all' would keep
>>      # all existing dynamic events):
>>      $ trace-cmd reset -k kprobe -k kretprobe
>>      $ cat /sys/kernel/tracing/kprobe_events
>>      p:kprobes/p_do_sys_open_0 do_sys_open
>>      r128:kprobes/r_do_sys_open_0 do_sys_open
>>
>>      # Issue reset, but this time only keep kretprobes:
>>      $ trace-cmd reset -k kretprobe
>>      $ cat /sys/kernel/tracing/kprobe_events
>>      r128:kprobes/r_do_sys_open_0 do_sys_open
>>
>>      # Don't preserve any dynamic event:
>>      $ trace-cmd reset
>>      $ cat /sys/kernel/tracing/kprobe_events
>>      $
>>
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D219302
>> Signed-off-by: Metin Kaya <metin.kaya@arm.com>
>> ---
>>   tracecmd/trace-record.c | 59 ++++++++++++++++++++++++++++++++++++-----
>>   tracecmd/trace-usage.c  |  5 +++-
>>   2 files changed, 57 insertions(+), 7 deletions(-)
>>
>> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
>> index c695cd23..f80b386f 100644
>> --- a/tracecmd/trace-record.c
>> +++ b/tracecmd/trace-record.c
>> @@ -5399,11 +5399,15 @@ static void clear_error_log(void)
>>              clear_instance_error_log(instance);
>>   }
>>
>> -static void clear_all_dynamic_events(void)
>> +static void clear_all_dynamic_events(unsigned int exclude_types)
>>   {
>> -    /* Clear event probes first, as they may be attached to other dynam=
ic event */
>> -    tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_EPROBE, true);
>> -    tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_ALL, true);
>> +    /*
>> +     * Clear event probes first (if they are not excluded), as they may=
 be
>> +     * attached to other dynamic event.
>> +     */
>> +    if (!(TRACEFS_DYNEVENT_EPROBE & exclude_types))
>
> BTW, I prefer the variable first notation. Not "FLAG & var", but
> "var & FLAG" as that's the way I read it in English. I read it as
> "exclude_types has TRACEFS_DYNEVENT_EPROBE set" but the way it is written
> it sounds like: "TRACEFS_DYNEVENT_EPROBE has exclude_types set" in my hea=
d,
> and that confuses me.

Gotcha. Will fix the ordering to ease reading.

>
>> +            tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_EPROBE, true)=
;
>> +    tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_ALL & ~exclude_types,=
 true);
>>   }
>>
>>   static void clear_func_filters(void)
>> @@ -6036,11 +6040,51 @@ void trace_restart(int argc, char **argv)
>>      exit(0);
>>   }
>>
>> +/**
>> + * find_dynevent_type - Find string formatted dynamic event type
>> + *                  in "enum tracefs_dynevent_type".
>> + *
>> + * @type: Dynamic event type in string format.
>> + *
>> + * Returns an unsigned int value for the event specified in @type.
>> + */
>> +static unsigned int find_dynevent_type(const char *type)
>> +{
>> +    /* WARN: Should be kept in sync with "enum tracefs_dynevent_type". =
*/
>> +    if (!strcmp(type, "kprobe"))
>> +            return TRACEFS_DYNEVENT_KPROBE;
>> +    else if (!strcmp(type, "kretprobe"))
>> +            return TRACEFS_DYNEVENT_KRETPROBE;
>> +    else if (!strcmp(type, "uprobe"))
>> +            return TRACEFS_DYNEVENT_UPROBE;
>> +    else if (!strcmp(type, "uretprobe"))
>> +            return TRACEFS_DYNEVENT_URETPROBE;
>> +    else if (!strcmp(type, "eprobe"))
>> +            return TRACEFS_DYNEVENT_EPROBE;
>> +    else if (!strcmp(type, "synth"))
>> +            return TRACEFS_DYNEVENT_SYNTH;
>> +    else if (!strcmp(type, "all"))
>> +            /*
>> +             * Unfortunately TRACEFS_DYNEVENT_ALL does not work here.
>> +             * Because tracefs_dynevent_destroy_all() assumes 0 means a=
ll
>> +             * and destroys all dynamic events.
>> +             */
>> +            return (TRACEFS_DYNEVENT_KPROBE |
>> +                    TRACEFS_DYNEVENT_KRETPROBE |
>> +                    TRACEFS_DYNEVENT_UPROBE |
>> +                    TRACEFS_DYNEVENT_URETPROBE |
>> +                    TRACEFS_DYNEVENT_EPROBE |
>> +                    TRACEFS_DYNEVENT_SYNTH);
>
> return is not a function. You don't need the parenthesis.

Sure. Removed them.

>
>> +    else
>> +            die("Invalid event type '%s'!\n", type);
>> +}
>> +
>>   void trace_reset(int argc, char **argv)
>>   {
>>      int c;
>>      int topt =3D 0;
>>      struct buffer_instance *instance =3D &top_instance;
>> +    unsigned int excluded_types =3D 0;
>>
>>      init_top_instance();
>>
>> @@ -6048,7 +6092,7 @@ void trace_reset(int argc, char **argv)
>>      int last_specified_all =3D 0;
>>      struct buffer_instance *inst; /* iterator */
>>
>> -    while ((c =3D getopt(argc-1, argv+1, "hab:B:td")) >=3D 0) {
>> +    while ((c =3D getopt(argc-1, argv+1, "hab:B:tdk:")) >=3D 0) {
>>
>>              switch (c) {
>>              case 'h':
>> @@ -6102,6 +6146,9 @@ void trace_reset(int argc, char **argv)
>>                              instance->flags &=3D ~BUFFER_FL_KEEP;
>>                      }
>>                      break;
>> +            case 'k':
>> +                    excluded_types |=3D find_dynevent_type(optarg);
>> +                    break;
>>              default:
>>                      usage(argv);
>>                      break;
>> @@ -6112,7 +6159,7 @@ void trace_reset(int argc, char **argv)
>>      set_buffer_size();
>>      clear_filters();
>>      clear_triggers();
>> -    clear_all_dynamic_events();
>> +    clear_all_dynamic_events(excluded_types);
>>      clear_error_log();
>>      /* set clock to "local" */
>>      reset_clock();
>> diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
>> index 8bbf2e3e..f159e5e1 100644
>> --- a/tracecmd/trace-usage.c
>> +++ b/tracecmd/trace-usage.c
>> @@ -193,7 +193,7 @@ static struct usage_help usage_help[] =3D {
>>      {
>>              "reset",
>>              "disable all kernel tracing and clear the trace buffers",
>> -            " %s reset [-b size][-B buf][-a][-d][-t]\n"
>> +            " %s reset [-b size][-B buf][-k event][-a][-d][-t]\n"
>>              "          Disables the tracer (may reset trace file)\n"
>>              "          Used in conjunction with start\n"
>>              "          -b change the kernel buffer size (in kilobytes p=
er CPU)\n"
>> @@ -201,6 +201,9 @@ static struct usage_help usage_help[] =3D {
>>              "          -B reset the given buffer instance (may specify =
multiple -B)\n"
>>              "          -a reset all instances (except top one)\n"
>>              "          -t reset the top level instance (useful with -B =
or -a)\n"
>> +            "          -k keep dynamic event during reset. Valid values=
 are:\n"
>> +            "              'kprobe', 'kretprobe', 'uprobe', 'uretprobe'=
,\n"
>> +            "              'eprobe', 'synth' and 'all'.\n"
>>      },
>>      {
>>              "clear",
>
> Could you send a patch that updates the man page:
>
>     Documentation/trace-cmd/trace-cmd-reset.1.txt
>
> As well as one that handles bash completion, so people don't need to
> remember what to type.
>
>     tracecmd/trace-cmd.bash

Ah, missed that part. Sorry.

Thanks a lot for the review.
Will post v2 in a short while.

>
> Thanks,
>
> -- Steve
>

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
