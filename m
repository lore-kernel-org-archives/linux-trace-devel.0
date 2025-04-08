Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013000.outbound.protection.outlook.com [52.101.72.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36182620C9
	for <linux-trace-devel@vger.kernel.org>; Tue,  8 Apr 2025 07:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.0
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744098315; cv=fail; b=gIUsEthAnAvFM8g3KzyeTaAVy2EXazNfyYODVXqsdiazcOupmsU/LXb5w2dD4eWvc1QNp+uUm3Qhv0bhWkQ9VWeKyn9iKN3gtTFieu20xJfKMc8FvsB460QXIx9VwtFXVcIkSsP33cEhQ35rPlvLshRKCiUxfgewaLKP1BruJ6E=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744098315; c=relaxed/simple;
	bh=sdCUGT5issjCQgKRocmD1Fms6ofisxN9thG43lFW3QU=;
	h=Message-ID:Date:Subject:To:References:Cc:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LnJaVDD9DatBY31Zc2bOkJWBEBUOOrygAiTYOcI5p1JUwghZb0yvv2f49xGrofgEVeqx8eRaoMi/dOymDNqUTqLpCYYyYLHwed8FFIznhJDOSIbfRyqQAZX3qVxiqX1DU29vpnn776aRoGiiRtnBDIjkTuMmUI+OO/XaSm2Z7f8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mgSAa6TL; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mgSAa6TL; arc=fail smtp.client-ip=52.101.72.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mgSAa6TL";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mgSAa6TL"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rFUA/5KEAxgocDZTqcXx5s69adLTGT+YJiF1gpSHBxNAR+KKX9kVLmekbvKaW7hpnG/hCy4yTg5MsbrCyhm9y8/GBbUYNYxX0FsMmNDZuRDBlhdiAaKaAuzAemvXDl27y+wYd4iZuQfAdBuP/rm5czaS/KQL8gZDkCUVMjOPoagFcYriQtXI73EH64nXQJAgfnKBq5wt3FOHHQRMnuv9fm1mrWzEfcDWvlZnF8jEAuBAqTfijyyoPxsGR2bOqzQ0oYB5aTVJDlHCyb3KmXHJlf/EA2hSa6eGCHtgZcnayBHlzKGRSallAt2gny0qfGyGoXoMbY1vCA2yw0j6SVttAw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KCnLaibFPjrj+PCsoCzh8FrSc7+qqjU4lUOZxSFEJyY=;
 b=tj3ZfjL6mLyQIFTMb5mt4FyrZwdHINEtgqFq50ChfqynLtQkgWslO7m6sQO3aj/nzkXhuSdELVVldkFIQR2RABfkCK7KLZR5/G7PAvpqblEnZgGgawhFWLZTRZKuDvRvmZvumSArM0kkzZzxd2RkEgYcf1LopoBj/MWsVvPtZmO+A3rilNfqbPpIH10ajmaXd9DqUJnWx6ytgSikg2JVknkPr3i4KMgqgmGfVLiVPi66AqydVcuvErtuw9whUN2b6pqD42iwPiZGo0TAAVXXYH8lUd2oi/w6h7OJVLH1ST83NY/S1U+rG9Qkg2KoDmpc+9b5oFsObUn4uZPxvXlZCA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=fail (sender ip is
 4.158.2.129) smtp.rcpttodomain=goodmis.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCnLaibFPjrj+PCsoCzh8FrSc7+qqjU4lUOZxSFEJyY=;
 b=mgSAa6TLOwzGEhZmz/OxQ8mgHmDq1+J4opHy98PXMoEiRRdVLkDutBjw9JOQV1+p7vwM+P0t/PGrUPxbWk9BTX0rUpqp3V2VhgvQqTwXAFzD8qTEHZOVi6qct2hEwxoysdAImciHzcKDBvEXJikrBW+x7VEGkq6K3kinsUF0LjA=
Received: from PAZP264CA0083.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fa::10)
 by DBBPR08MB10747.eurprd08.prod.outlook.com (2603:10a6:10:536::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Tue, 8 Apr
 2025 07:45:08 +0000
Received: from AMS1EPF0000004E.eurprd04.prod.outlook.com
 (2603:10a6:102:1fa:cafe::9b) by PAZP264CA0083.outlook.office365.com
 (2603:10a6:102:1fa::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.35 via Frontend Transport; Tue,
 8 Apr 2025 07:45:08 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Fail (protection.outlook.com: domain of arm.com does not
 designate 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com;
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004E.mail.protection.outlook.com (10.167.16.139) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.22
 via Frontend Transport; Tue, 8 Apr 2025 07:45:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZFJ993xin7xrWWjUPRLp7Uui4F3Q3f7OGL4goJhDhq8zeogRxnnEh2Taev4Gws8OCVUbi75/O/YD4ZQHhX7zJ2oknDCQJNeVrzkt7pYzw3+OUMCq+8zK8XYyNr0Ty2N9O933GdjfLxICtEUws8geDBd7LzYxPBYMt7cr6CZg9QhGtKreoP4BKHUpDvoORyQFwlDPf1y4S03u2jsmiWJhQ5T2yLaDxOs1j1XUBImafife4X09tcHXz5XKGY4iFdJM9DKeqhGBJq2TJayrHUhmvPbSyrBtrx8g9hmMRUHS6m/x/s/TI7DQ+RLJ8k32rsvMHgJuXitqVf+nX39j2W5edA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KCnLaibFPjrj+PCsoCzh8FrSc7+qqjU4lUOZxSFEJyY=;
 b=BzC1zs5u1+lSQMACktpTNrqMsbXFJFIvQ2lM+wQswpD3RDOM6YcEwLIpaPom2YnVy4le+ju0jSBnun+3VCkYibKEIdRbU33LvJz0pte3mHCseqtwV7mbUVB81WzQBsn8O8eqfyCFtuv909i+M+eAsBAV1r5kKUvz5nIkmpkTCGYXIRKejhJ5JfEty4QeOTI2x512C5l+JVoBWpoPrBHueI5bMorQx4dF5cllfNrE8qJ1GvlGdL6Er2qwJw2uTH/uEeC/3AdDupBlUuK4Tf7YMXoUu7Qzy+DVIhkWZKIsCjD5/jDAuDw6z3kyRFaX5FiDJOzIheSWvK41e91yayIPhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCnLaibFPjrj+PCsoCzh8FrSc7+qqjU4lUOZxSFEJyY=;
 b=mgSAa6TLOwzGEhZmz/OxQ8mgHmDq1+J4opHy98PXMoEiRRdVLkDutBjw9JOQV1+p7vwM+P0t/PGrUPxbWk9BTX0rUpqp3V2VhgvQqTwXAFzD8qTEHZOVi6qct2hEwxoysdAImciHzcKDBvEXJikrBW+x7VEGkq6K3kinsUF0LjA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS2PR08MB8288.eurprd08.prod.outlook.com (2603:10a6:20b:557::8)
 by DBBPR08MB5883.eurprd08.prod.outlook.com (2603:10a6:10:206::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.35; Tue, 8 Apr
 2025 07:44:33 +0000
Received: from AS2PR08MB8288.eurprd08.prod.outlook.com
 ([fe80::85a6:7b0e:5297:24a]) by AS2PR08MB8288.eurprd08.prod.outlook.com
 ([fe80::85a6:7b0e:5297:24a%6]) with mapi id 15.20.8606.029; Tue, 8 Apr 2025
 07:44:33 +0000
Message-ID: <f4744965-3e68-46ff-8951-a78427c60a0c@arm.com>
Date: Tue, 8 Apr 2025 08:44:32 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libtracefs: Fix mistaken update to TRACEFS_STACKTRACE
 macro
To: Steven Rostedt <rostedt@goodmis.org>
References: <20250407172013.6aa58191@gandalf.local.home>
Content-Language: en-US
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20250407172013.6aa58191@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO2P123CA0056.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::20) To AS2PR08MB8288.eurprd08.prod.outlook.com
 (2603:10a6:20b:557::8)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS2PR08MB8288:EE_|DBBPR08MB5883:EE_|AMS1EPF0000004E:EE_|DBBPR08MB10747:EE_
X-MS-Office365-Filtering-Correlation-Id: b5f71189-3ff4-428d-da58-08dd7671486b
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?aUFnYzVua0lPSG1iV3Y4bWhwN1JCT2VFOUhlRDZ0MWU2UWMxcjltNE83QW5W?=
 =?utf-8?B?enNVbUtNa0Z0VWdsWVY1ZzJSRVNsVitHWFNxWGtZV29YVElBRkl1YjFsRFlZ?=
 =?utf-8?B?bERiRk9hNUV2YkFaT2lVNmdqL1lZTmEzK2RnWnp0TXpMdWQrQk1FYkR2Nnc4?=
 =?utf-8?B?MDUxQUs0cEtWbXowVkhGcDc2T1VTVFpFT2ZDVE9UdzhSN09tS1FOWGp1eWd1?=
 =?utf-8?B?RjEvRTZGNGVRUkZTa0psSUpLdUxRRUJFTFdUamJYNzJlQ1pTTGprWmtTU2pP?=
 =?utf-8?B?dkx2V0JOYWt0Z3JVdlAwTTE3Z2RiSzc2VXRUZDV1aWtadnZNYmFLeDZxMGJz?=
 =?utf-8?B?TEF6bjBjMmlNRlVUWElKc0RxNGJRU1V1NUJQK25adGpWTDZWL1lCa1ppZlhV?=
 =?utf-8?B?dXFFQmZEUnY1V2xqWFNpVmJaeUMrZmNtL2pJL0xHajdpTFprbUdvQlBJYUY5?=
 =?utf-8?B?TXRkcGpGdGhQaWxYMWJ0QnBhdmsyeHI4Y0l6WXBOeHZXTWJQOFp4RVAzQUIw?=
 =?utf-8?B?OTdueGhSRnJDWGxSb1g3bVY5NHplU1AwWnk4SUl1OWIvSXNtWnFldWFQTW5E?=
 =?utf-8?B?ZFdjaTdqQlFrZjRkYjA5NjYwUGpzWG81RVFETXFUTDJnNlpDeW5VWW5OaVZy?=
 =?utf-8?B?TzVaaHVWUnRMSkRPQUNnSVRrVGlGcUF3UmJGdk5MYzIvNERUT0xKRlZPZTl1?=
 =?utf-8?B?dGRFR1hFOVcxanVlRUUyL3ZRQTZheHlRZmJIVnhnSEpPMFhlUktBWnhkRU1F?=
 =?utf-8?B?QVJvL2tmdExxWEgwejNNbXJ1VzE3Z0pIN1JyakFNbkNEVnpCUWxqUmYwQXNu?=
 =?utf-8?B?WnJRNkFPRForQjFIRUkwY3orRHl0L0RMR2xrRFdQdSt4L2lyeEJyTDdvL0ha?=
 =?utf-8?B?QVhJUi90T2QwWDFNMTNXaDFmY1RpRHpvNExMa2FXTFhrRDBDMGJESkFPM3Vn?=
 =?utf-8?B?bmY3KzQyZXo3bGVqcndhS1J4a2h3WmdnRG9zb1UydGIyV1NkVFJ4Kzh6TzNl?=
 =?utf-8?B?OWtJZ0NWOG8yKzJNM08ydG1iUW1ySUpQUUpZSEVLTzNQOTFzd2tIMEJ4TDZ2?=
 =?utf-8?B?VkZrV00xOE0zVklsKzVkWjZVNjNid0NXVENxZ1MzS1JtSzhXWnN5ZCs5dERP?=
 =?utf-8?B?RHlvaFB5b3luQUhZbmdQVFlRY2htdWZoR0ZrcHV6ZmE3S2tES0tiekkyeTFw?=
 =?utf-8?B?djRhbnBFMndFTkltYkROVXhoblVablQwTXlMc05ETE5qSGlJZjNNaXhRdDY1?=
 =?utf-8?B?aDk1QVlDN3JPOGFJWDJKWmoyOVJ6YlNxWE5EMnBEZDVYOTFFVHJMTklIV3Z3?=
 =?utf-8?B?bjYzVU1Xd2h3TTVERC80TnZWKzhuVWYxSlU1RTdmZlRvL21BcmtQcHpGelJm?=
 =?utf-8?B?K202MVljUUFJVldwMVVQVWFlazhySmVIQjZNUEF2OVhrVFlPcTRFaGlBZ25D?=
 =?utf-8?B?aGdjTUNEMUZkaHo1QmJ0Si9qNHFWLzdxMkJCNWRLWE95V0JwMHdTQTlLL2s5?=
 =?utf-8?B?ajYvZXc5d282LzhSZ2pJVnVpSUV6TWRvdmJPMzhVMUlSUzcrNVl4UUVXcDBm?=
 =?utf-8?B?U1JHMnAwQ24xTWFWVGRMK0hyeXJ3RElqeGZDSVpUZ2V6N29iUlcyN1VFalpa?=
 =?utf-8?B?cVZ2aWlCNm5LV0UvdG1WNmpIMnlyaVhBYzhLT1ZDRHczMmx0cTN3TkdWWlI4?=
 =?utf-8?B?RUJLbnIwOTVab2tJWVdEVkd0V0g0V1o3OVpIR3o2ekMwQktacGhKTjJXTDN3?=
 =?utf-8?B?MkNiWHVaWE0wbmdXRnI5NnBhdjkrNU9YUFNERzI4L0Yzc3ZRNG05QUdlbk1W?=
 =?utf-8?B?emkrRDBVSGRzMXZUMHFqZThyaW9WZTRRcHNuM2ZOOS93ZTlIRENqVFlVdlE4?=
 =?utf-8?Q?gE8Bjam/M2AJL?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB8288.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB5883
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004E.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4e648b7f-cbee-4e8e-0135-08dd767133fe
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|82310400026|376014|36860700013|35042699022|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OEROajJXNTFYalRZLzkzQXJsbE5rY1dqM1FlMnk4WDlDaVRVSHA3VDlwUlhG?=
 =?utf-8?B?cTJ1OFpFOUZTUEc3dmZ1MFpIU0hJZkhja3hPcDhzcHBEMUdhWlpXems1Ujdh?=
 =?utf-8?B?OXJRM2wvRGd1ZVEwc2tUaWJxMUdWUmpjK1pMa1piMmlZOVFuSzlQdHJETWUz?=
 =?utf-8?B?cUZqeW5LZmMwVlBNci9DSmVieXBRRHlLeHdQUVJ5U3BVMzU1MjZ6TDdJM1NS?=
 =?utf-8?B?Wm1SVm42NGpFSUhMRXJyckFEOE1RSGpqY2h1aG0zVkwvQmliU010Y1BWcitM?=
 =?utf-8?B?Nlo5eWJHRm5LMEZxUGsxTGJoNmY2akZMa0lFcmR0WW1yUTZ1NzRkVXBaMmIr?=
 =?utf-8?B?clN0dDhMKysrOWg1d3A5d0J4OGM3T3M1RG9BV0ViNGlCRzA1NDV5L09oZjQv?=
 =?utf-8?B?eTluZ2FlcVp3d1NsZ0gzOEt1R2hMZHBwTWQ4MnlJTTdSMjN5ZkNYMlBSaEp3?=
 =?utf-8?B?eUR4VGx1NDdudlVmS0dJUFUrRlV6OWNLYXdONk1Nc2ltdGFDVnNOeEt2Tmxn?=
 =?utf-8?B?eWZvRVVvTDNISE9HeUlqMVhyd0V1aGd2cEJkMzd3WDFPS1QycnNwWHBZUmIv?=
 =?utf-8?B?ZDdTUE9JUXE5MWpVSFZiVDVmT0FlK0dzZFdhYjM1YS9PRlRma0tIdXVRVWgr?=
 =?utf-8?B?aXBkV0N5VDRIUmJHeUM5Qk1nQ3hibnZVY0h0aGxHSnZ0OGxYWUh5ejAybnc5?=
 =?utf-8?B?cTJqTERVS3B1aUNkbTNrbUluMElxRnUxKzBuQTk0cjkweG05eThhWSsvUDBa?=
 =?utf-8?B?TmFjU1Z3NmxOd2hySkN1NGpQanNmZzZSVVJzejFxOEZMQjdzLzBVNk93QXJH?=
 =?utf-8?B?ZENPd3JlYm9tZWRHeVpUMDRvY01CYkxkT1ZONUkvM1J1bUNuS1J6bWhIVVE4?=
 =?utf-8?B?YUFyK2F4UDlLeDlPNU9LVnFzZFNIUzBtRG5XR3ZZWmcyeUgwcTV4MkN3Szkr?=
 =?utf-8?B?SnF3enEvS3hRWGpHRjZlZjNXRmQ0bndZc1RzK0krVU5sSXdGUmo0STNIdjFN?=
 =?utf-8?B?TUVveW1RNlJqd3laVlU2WTc1R0ZCY1U3QktYbzNhTXp1VFZFNXBKSlBwZGM1?=
 =?utf-8?B?cUZoVmdiWU0zNTI0a2hrQm9Xc0NwY1VIZjAyWVZLQ1EvTGNmdld6ZGhzRXRM?=
 =?utf-8?B?cWhvRk9UVURtS3I0S2hERnVoemlaRzh5ZlF0eGF1L1FTSitkYTRRSEhIbm9R?=
 =?utf-8?B?aXEzbjRwb1F0ODZrRVZWbVE4K0xFVmw0dllOVFZjazhzTGU3U1gyRlZFMDRC?=
 =?utf-8?B?ellpejZEZVR6MFhycUJ2YW4xZ0F4RnE2ZWdnUzIvU0VEYUVjYlRSQVB2MWFs?=
 =?utf-8?B?MUIzQlpIaTArRCtLbVJaVGRIVXJWTlFMeTFld1U3cUJ2UDZYZytya1EwN3ZS?=
 =?utf-8?B?VE9iQWFXZ21FRzJYQnZ3dTRULzBSMU94TDNBRGlpaDRoOG1sbytBVkxoT0FL?=
 =?utf-8?B?dGRrU3M0MnF2amRTME1BRS9tT3J6cDF2MUlpV2lONDM2WSt0ZVZocUJvenNl?=
 =?utf-8?B?VFNudkRxcXltMUVrVUJwWCtjK1NIMFduT2lxZE5qNmhOSTFoYXZiN1hMbmtr?=
 =?utf-8?B?VTZaQ25hMGZoRi84eDRMZEUrM1hEN0lvc2hYVFFaVXFjZnpPN1ExMmhxdjFW?=
 =?utf-8?B?Y1N4bDA2anJTK2hhTVMxaVY2UDZqbitYZEVja1lFV3V3eEIyTGd5VDN5Z25h?=
 =?utf-8?B?YkkrUXpqdU1YcVZhekdlSjNPeTBKUUFOZEtEeU9qOEh2Q3dsYlBRNE1OMGhO?=
 =?utf-8?B?blNZR2dvWjRYdEdXNGkxU2ErOEY4ZVhyNjNkU3dFa2dtMWE4M0pSTUpvd2xD?=
 =?utf-8?B?ajE0VFBtM1ZmS051dG1Yb1pVdlloTm9DekRQL2hocEdYZmZiRWZtUVkwTlI1?=
 =?utf-8?B?ZFBxaWxRdEloZFU3MzVRWExtZ0twWnVENWwxODhkYTRjMWhvS09SRVU2RWpF?=
 =?utf-8?B?MTlRMFRkRmhWRSt2cWg1Tk5rRFAyVzlGMHpyTzVmb2t5NTFkaXYwaE93RlpU?=
 =?utf-8?Q?Wy0YP9h7UzmrhwuBt/NPJJBjraKvu4=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(82310400026)(376014)(36860700013)(35042699022)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 07:45:07.4575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5f71189-3ff4-428d-da58-08dd7671486b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004E.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10747

On 07/04/2025 10:20 PM, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>
> The change that converted generic names to variables to start with "tfs_"
> was a bit too aggressive and ended up changing the string name of
> "common_stacktrace" which broke trace_sql():
>
> When running sqlhist, it would get the following error:
>
>    # ./bin/sqlhist -n wake_lat 'select start.pid, start.common_stacktrace=
, TIMESTAMP_DELTA_USECS as delta from sched_waking as start join sched_swit=
ch as end on start.pid =3D end.next_pid'
>    Failed creating synthetic event!: Success
>    select start.pid, start.common_stacktrace, TIMESTAMP_DELTA_USECS as de=
lta from sched_waking as start join sched_switch as end on start.pid =3D en=
d.next_pid
>                      ^
>    ERROR: 'start.common_stacktrace'
>    Field 'common_stacktrace' not part of event sched_waking
>
> When it should have produced:
>
>    # ./bin/sqlhist -n wake_lat 'select start.pid, start.common_stacktrace=
, TIMESTAMP_DELTA_USECS as delta from sched_waking as start join sched_swit=
ch as end on start.pid =3D end.next_pid'
>    echo 's:wake_lat pid_t pid; unsigned long common_stacktrace[]; u64 del=
ta;' >> /sys/kernel/tracing/dynamic_events
>    echo 'hist:keys=3Dpid:__arg_15169_2=3Dpid,__arg_15169_4=3Dcommon_stack=
trace,__arg_15169_5=3Dcommon_timestamp.usecs' >> /sys/kernel/tracing/events=
/sched/sched_waking/trigger
>    echo 'hist:keys=3Dnext_pid:__pid_15169_1=3D$__arg_15169_2,__common_sta=
cktrace_15169_3=3D$__arg_15169_4,__delta_15169_6=3Dcommon_timestamp.usecs-$=
__arg_15169_5:onmatch(sched.sched_waking).trace(wake_lat,$__pid_15169_1,$__=
common_stacktrace_15169_3,$__delta_15169_6)' >> /sys/kernel/tracing/events/=
sched/sched_switch/trigger
>

test_instance_trace_sql() has similar test cases, but they seem to pass
even without the fix in this patch, IIUC. If that's the case, should we
extend the unit tests to catch this kind of issues earlier?

> Fixes: a2bfb49f ("libtracefs: utest: Rename private functions to fix stat=
ic building")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>   include/tracefs.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/tracefs.h b/include/tracefs.h
> index b4e2e30..b6e0f6b 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -593,7 +593,7 @@ int tracefs_event_verify_filter(struct tep_event *eve=
nt, const char *filter,
>   #define TRACEFS_TIMESTAMP "common_timestamp"
>   #define TRACEFS_TIMESTAMP_USECS "common_timestamp.usecs"
>
> -#define TRACEFS_STACKTRACE "tfs_common_stacktrace"
> +#define TRACEFS_STACKTRACE "common_stacktrace"
>
>   enum tracefs_synth_handler {
>       TRACEFS_SYNTH_HANDLE_NONE       =3D 0,

Reviewed-by: Metin Kaya <metin.kaya@arm.com>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
