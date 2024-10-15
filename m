Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2069.outbound.protection.outlook.com [40.107.104.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EDC1FC7D4
	for <linux-trace-devel@vger.kernel.org>; Tue, 15 Oct 2024 13:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.104.69
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728999079; cv=fail; b=GQsDRzcqPyzMLjPOVWaYazRugcTwdBDKTs8wzv130kCj0sfXoKXyzxi13oY94ehXy16v12AUrNs7f2n0xESXQgSgRh5cveP0w22Qc8QteXaJmwOKQ9UZpzWm7dckFXVj4A5qoYjaQ6eDXWHgxbw2hYcrpp5q9cDtupl6Hfd8rS0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728999079; c=relaxed/simple;
	bh=INTHjchdPlmsAAP415H4yecaUmsPtmYRXUDRrUvEFXc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JBI/35qFRsrR/TY1xO7gSafBpnQfu9a0bIgHz7RDlyPTmLCnb1ps4/Gk8FZyZkoO9T/92SK7a2rF9oEmhyAY+wpkOvywXQQ2v8ipWBHA/24WWHS9wKc7PV50ywkNuLvIXHAbBfUUqV1HLc/61uzzNmyEbpL2IX3+744Zg8EodDs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ui8gMpKY; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ui8gMpKY; arc=fail smtp.client-ip=40.107.104.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ui8gMpKY";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ui8gMpKY"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GtniA6J3SXnzCSuWX1vRj9akzPAo/J4HpvN2G+ai1b0ZJriwwMe67XLBwRMIPsEPeiXJBGOEl6BdNPYScLN4KeDSWBlBfSs2zTIyWvIXWMQjIajVPuLBrG6IP+pCltjBy4KJx9VJ90G9lVwkH/ydzc3fF7QjYodPavdHWkDqYHmlQYva1DmM1rmN4U4HXbynGx8j+dOiFPayuI687MFgl3hc5nMBMcGxCszw9whaX89PckU4zQDgLLoBeEhrJ2RymZBce6LN3HodqBPIIpY2zufLgF5p/9AZ2vC3/4OPsdQ+MUe7lCvfZcKlJxpaGNjlpqw4yHEqMGR2jXyXx8KtMQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qu1+OrMG1u7XP4JKDy8VpqdHd61RsQ6pKmd7/RtcKWk=;
 b=O0fWyEg26a9p95XWbrdb9gm2b98z0Tut0koCzeY5JnOhypAfZurAJBPzxwOAsiv2aTb4NGEx8hde+nkmdJE234ghEIY5l2JfANB3wB7ngMd4X6W93Ke2dqpUUIaDVC4cs5LRpB9MEmYqsvM75jWZFfy1mR3ytZLLSUUAdp74mkfh+ps/aYOh9cY9t6HzwbDJhR+9R0hGjH39++wyNr12dCJAasWG+95yYTBC7+Ne2r6eBqkopwzMbdVFIZwjF6RsbCqFAuiPRDoFX60GG4P+0w5Xq0I1TOL5+n7ALDBKwba2PUO1X6s25zV2Isn4cn4Xh+wbdcD91/TWuX9fptWruQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qu1+OrMG1u7XP4JKDy8VpqdHd61RsQ6pKmd7/RtcKWk=;
 b=Ui8gMpKYUlPJau2jkH99hcse068J4Rz+7RkvnELJ/YJFsPCuq1Y2t5d1RGjveNYRIDs8s4FrB/sexU0wTPpWIHr+269hpkOe6xyjX2mseUIgvG1hJR22sCV17pqk5TPNHqFzgGtwTW4yv8qBmEJyCvHsNI2lXcCQRLcRopYPRpo=
Received: from AM0PR02CA0150.eurprd02.prod.outlook.com (2603:10a6:20b:28d::17)
 by AM8PR08MB6513.eurprd08.prod.outlook.com (2603:10a6:20b:366::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Tue, 15 Oct
 2024 13:31:10 +0000
Received: from AM3PEPF0000A78F.eurprd04.prod.outlook.com
 (2603:10a6:20b:28d:cafe::f2) by AM0PR02CA0150.outlook.office365.com
 (2603:10a6:20b:28d::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17 via Frontend
 Transport; Tue, 15 Oct 2024 13:31:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM3PEPF0000A78F.mail.protection.outlook.com (10.167.16.118) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Tue, 15 Oct 2024 13:31:10 +0000
Received: ("Tessian outbound 40ef283ec771:v473"); Tue, 15 Oct 2024 13:31:09 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 0f3785617a8d21de
X-TessianGatewayMetadata: dmzLjmimSU6FMiaFFmyfeLol5LyJI/xjKCa6t7mlLsFNH1vu6IY6tteeSnngUSNmCpcS0AX8YRrcLNdpLOuN0pp0HWWDKneCwgppBryUZCIZScem2aV8KrVZzYQWKDUYQ+G5mrW9Jl0rBm4lczqotGuyfrMCX+Pr2jKPBvvOuCc=
X-CR-MTA-TID: 64aa7808
Received: from L67d779e4cbf9.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id B658B4EF-E1B2-478D-9DF2-BD09BB10EBB9.1;
	Tue, 15 Oct 2024 13:31:02 +0000
Received: from EUR02-AM0-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L67d779e4cbf9.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 15 Oct 2024 13:31:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o22iItZZkRBRrpYHiEWZnrDKJmH6Lj2mz1Mg/+hZh7dDv+gOTBXEuCEKIDWOrUV5CilSkFG55jWhWNCnxo4Z3K574lh3/26UhECcLI7VtZhIA2Q+Fsw6EWknfhAOKHmWk4/5rMq3hh7XuWeheSbWUT4Z55V2mIkDCB9TQtCVv5jKadKZ7/dFJh+arEJFpx4l2bUASdjVOA7BbwnoQ9nupYGvXEav4oEp8l4LT3yxV1z/l75Vpj3e2vcf13HGi35HwQde2f9d17SIjcQuLmr2zrMPXVrITA0PGm7MWLpZwOLz+hV6JVQSq3/S2nMAaA4FoepFYexeiNde3sA7Iq1MSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qu1+OrMG1u7XP4JKDy8VpqdHd61RsQ6pKmd7/RtcKWk=;
 b=MA31VxHefI2wqmFdgTXmXlhSrUtYI7M3Fyvg42anIIN0BEY7kXM7o8iqA9kF3MMuVNs7saBl8JnNV7bF6KwxMITZAvZBEJSeLP9s+RpSxzzQX3OWQqb2aKX8JM7MxN5pRiUqTWRjyoMeHOLWExDk3GfsmnaNjbJ1uXxPAjlCG2W44XK6xdGMtuNMkTZpSRovsX9SiorSrikzUJphovZ3H6Y55EKtD1oy2bREWP8mXczAvLHgwNUfD+DkYGPitYz0uwA/t3jUTJgkgsjURMsA8eRnRuZT0VGlE/E5oYobCNlt8hudSZmylJmrFTIzTM0+ut+WmlNzvEOR0vlg6y6C1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qu1+OrMG1u7XP4JKDy8VpqdHd61RsQ6pKmd7/RtcKWk=;
 b=Ui8gMpKYUlPJau2jkH99hcse068J4Rz+7RkvnELJ/YJFsPCuq1Y2t5d1RGjveNYRIDs8s4FrB/sexU0wTPpWIHr+269hpkOe6xyjX2mseUIgvG1hJR22sCV17pqk5TPNHqFzgGtwTW4yv8qBmEJyCvHsNI2lXcCQRLcRopYPRpo=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS2PR08MB8288.eurprd08.prod.outlook.com (2603:10a6:20b:557::8)
 by DU0PR08MB7860.eurprd08.prod.outlook.com (2603:10a6:10:3b0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 13:31:00 +0000
Received: from AS2PR08MB8288.eurprd08.prod.outlook.com
 ([fe80::85a6:7b0e:5297:24a]) by AS2PR08MB8288.eurprd08.prod.outlook.com
 ([fe80::85a6:7b0e:5297:24a%7]) with mapi id 15.20.8048.017; Tue, 15 Oct 2024
 13:31:00 +0000
Message-ID: <d46e317c-075a-4c08-a6c8-db236130c35a@arm.com>
Date: Tue, 15 Oct 2024 14:30:58 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] trace-cmd reset: Add option to preserve specific
 events
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20241014123136.3890807-1-metin.kaya@arm.com>
 <20241014175905.03bec85a@gandalf.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20241014175905.03bec85a@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO6P123CA0042.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::13) To AS2PR08MB8288.eurprd08.prod.outlook.com
 (2603:10a6:20b:557::8)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS2PR08MB8288:EE_|DU0PR08MB7860:EE_|AM3PEPF0000A78F:EE_|AM8PR08MB6513:EE_
X-MS-Office365-Filtering-Correlation-Id: 0914b022-7e6a-43c3-0798-08dced1da1a1
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?cS9mbi9JRHpQRWJpbHM2N2doTWhCUnhpcWZDRzF4alh5SDJGU2Z0anZUcUM0?=
 =?utf-8?B?NmxaM1IzWHRUcitzcVVRNEpPTkY0b2lXUmZBMjE3RW1kK2YzRVEvMnk0TTdB?=
 =?utf-8?B?MStHZnpERlVmcTVpVUZ0UTJkTC8yQXFkM0x0c21zOEN2a2UvQzZycmcrZ2FQ?=
 =?utf-8?B?VHNIcnNhS3A4S2JMTFZ3WUk1WG9jRDdjZXNLV2NROWhLMnlOTkozblgvZHFH?=
 =?utf-8?B?UUtkTXdMZXY5cldwaENjSlNGMkNKd2xTV3o2SnNtWjlOOW1HcmRWWHJxL2di?=
 =?utf-8?B?Mkt1UzRiQ1FscG9CSUJBQmFvOS95aFZsbVdja3Z4UGMxRUc1NlU0Znc3YnFn?=
 =?utf-8?B?NmJwbzZOK1VoQVpnV2ZEQTl5RTFOUU1wWTcxMVpLNE1oYnFTQ1pzMkxwM09U?=
 =?utf-8?B?VGgySUV6RzVBcFpjV1J0WDFzb3pRSVBPVEljMkVRMTc4cG8vSXVYZFE3N2Jl?=
 =?utf-8?B?TzZEbkVadmdxWDdWcERwaThBSTd1RzdsQ3p4cGx0YTU5V1dBekJROEZUNU1S?=
 =?utf-8?B?S055L0prbkF2TkhGblJtOEtXRXRTT2ovYXhacko1LzFvZEtkeC9WaUFzUFRo?=
 =?utf-8?B?eGVGeXdGTHpwWDgyRUw1VGF4b3A3RzRLOTdHd05aODBQU2pDaHZxRmxFOUJD?=
 =?utf-8?B?QVM4eGdUNVRZSjRITjRYYytDVUhOZG9IS29XRzV3L0xrZXowTmJicFBVdlZL?=
 =?utf-8?B?dFUrcTlDek5BcWZnUmd6Um9kQWlCc1FtWEJ5U1FkT1hCZVNPV3pSVFd2dW8w?=
 =?utf-8?B?a1NETXNKNzdOQXVWZWI5UTl1NWw5Ym9IcEFvNEIzTEtnWFF0QTdvM2dub3cx?=
 =?utf-8?B?bHlzUzZobTJnTmptRHFMTXFTWTJqaWRHZWF1ditlbklMSG9GZitKT2x3bElS?=
 =?utf-8?B?THFTdE9lSTlLUjYvV2ZZRkI1K2tySmxETmNVd2ovOG9KS0c3eG1OclAyMjlC?=
 =?utf-8?B?cVd6M3hNdDdSWnBneTcrYjgrZUZWUHdiQkpvWnY5SnBMUkRLVUxYUjZ0Nllt?=
 =?utf-8?B?bWxCWUJQSlRINXJqRE1GV1dubldkMFlQcGF3cy9jeXQ2bjZBckt4MzJtRjZj?=
 =?utf-8?B?MVlwakY0Q3lqaHFCTTN1Ty9JOWQzVEJncmJVNFVRSFVTQW9GZVZVaTZpeDhM?=
 =?utf-8?B?eHZ1Y01PMzRrTUt1WDdTdmtROGkxekF5QWdudWFXVWNOb0RKTVl4WFZWb21E?=
 =?utf-8?B?MGh0V0VkTFAwRnBWb1FmR1lYa2VnUk0wNDI0b0E2Si91eGxLSnFmSElaK3da?=
 =?utf-8?B?Z093aEdYYVVYV3R1RVhwOUU1VlAzZFJGRmFCRFc1NUxBdEwyZUxiN252RGlM?=
 =?utf-8?B?RUpmV1BUa08wUHNRREIrYkZzU0tQZ1N2bWd4RW5FdE5jbkIrM0t4YUR0MmV4?=
 =?utf-8?B?bzdwWXkwL3hYYy9SemxVclFNMzAxU1dzS1cxZVhrbEVtTzR1YnRqUVVZZGdI?=
 =?utf-8?B?L2VreWN2cUZxZ0xPNnFCZDBFNVBkeG4rR0NudVBVdXd4OXJ6cXhGYXdGQi9h?=
 =?utf-8?B?bjQycEhWT1paUlpsc0VXSFVOUDByZ1pjYm9GV1RXU1lXYlhQU3c1MXRyZ3oz?=
 =?utf-8?B?dnFMbDRNaFlFTUFkOGpWc1NPUUFyR0EraFZUdmhpcHJJcW1teHhxV2E3WUFj?=
 =?utf-8?B?bjB0TGo0bDNpa2M1RzFGOGNQOUpMYm1oWTl2UGxxS05OdWpDNndiemRtUW9F?=
 =?utf-8?B?UzN5a2RYWGd4VmFucXNRZWtZZ2VnRTRpOTg3VTFKMlI0V0Voa1oyb21nPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB8288.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7860
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:20b:557::8];domain=AS2PR08MB8288.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A78F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	11ad1053-332e-415c-6951-08dced1d9ba4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|35042699022|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d250amdSS0tDcTZNUmtFRHl3SHNqM2tnM2xGek9naTFLa2Y3dlRnUzJuWmpn?=
 =?utf-8?B?a0FlL3ZHMDIvVWp5YUJIejQxZUgvYTVLS0VvalRZYTZzci9YTzNDcmFrN2dp?=
 =?utf-8?B?eWlZbXN5ZHUxZDVpKzVBMEREcHdLWU0rSnVxaWJHVCtVdlpaWmJwKzNOM2JV?=
 =?utf-8?B?bllhNklscWgzbE96VW9Ha1RzeHVTYmkvVkxyY1RQdTZEYmZ3c25CVmNOR2JC?=
 =?utf-8?B?RVNUeFBrWEloN3FnOE9SQ1dYYVM1T1BkNkIzeVdpWDkvYWF3OGhHeTFORjIw?=
 =?utf-8?B?N2ZKN1lFZFloTjA5R1VjS1YyU2oreWZTdUd6UFZ5M1Q0UTJETm5McjMwMUh4?=
 =?utf-8?B?d1FRbWV1Z2hsZnFsM1UvY2JSRVhOQ0Y0N2N3Mm1uRkxXbndBQzJCT0MyZVVv?=
 =?utf-8?B?R1J6NFl2NXNqSW9ENVd3VGlQVWFQT3M4eEJYbjlHLzlDSmZWdjJRR0dtN3Jr?=
 =?utf-8?B?RzhCSGhmNXg0VlhzdzRoRi9Fa3JjL3pnRDRTQ3hGcm9tc0VONkRMaVczKzVB?=
 =?utf-8?B?cHlHd2xsWnZvZ0MwdC9UL08yVmhZSzlkSld5czg3VE1lYlk3QzUvU2piQXhn?=
 =?utf-8?B?MzZjZjZrRmZBTzhsa0xhczhhYkZhWUFGWkJBTXdpY0o4aEhXa0pNS2NNQklj?=
 =?utf-8?B?QSsvK09nVVVzN0Q5aURVT3FkVGRwcVRyREtOdkJiSy9xNk5pQjFOMzV4cFBu?=
 =?utf-8?B?cGRLNkpQajJrY3diSC93SUlaWUZLbjdZR3dNWHVQNC9FOWl5WTRLMk85Tlhu?=
 =?utf-8?B?VFhKai9nQ2RKMGFFTVhYTTV2R3NzOTNHWmpyaXBhbjVkaWdqc2dOaXlpVVMr?=
 =?utf-8?B?clZxNFNvelJESUlZbWRTSkdGTmt6UisxWThJNGtYc0FSQzN3WlRGWmpDZlhE?=
 =?utf-8?B?Q2tQTXFyRnZncG5qZWNQMXp4MlU3akFNN0RyK0pDY1pUVjc0Y1QxMXhUbFA2?=
 =?utf-8?B?aVRYMXlNc3NKeTY5VUxHeC9tWml2SFhObGJESUVOVENETGFuK3lIdVJJalVr?=
 =?utf-8?B?MVRZTE9LK2M3ZkMxelhTSTNQczE4VWRKRTcrNS9LQ3JnTC9OQ2VZbFBvQlE5?=
 =?utf-8?B?MWMvQkN3MHp4V2ZiZDk3amxONVNBTzZuek5zcXcybFhEQVlreXFqa1krRUla?=
 =?utf-8?B?Z0NLaHgvandtUE9KSEMzZUMzdWJnbUZXTzNBSVowdHNMNE9QemE0V3NQYVBI?=
 =?utf-8?B?YTFoOTlCZkdqa2hvZ2I1amV2Y3NZbTZhUVU0WHMyZkZRNDBoeDVxNjREcTVZ?=
 =?utf-8?B?eU54S0hWNVZXZFVGUENnTi8yWlBaenZJbWx5MVJGRGhKQSs1eEdCRkRERklt?=
 =?utf-8?B?YmdjeW1iM1FVbnNzdHgzQUt4ZlgxVHhBRndhZnhTZHZDV3gxc2c5R0NkTGJF?=
 =?utf-8?B?RktUTHMyY3E2VUZvZ3BqOG1xLzRTcHo1eTAzZXZoWVhaYytpMjZDNTNrQzJF?=
 =?utf-8?B?MjVpWjZBbjN4V3d3d0xJOXNwcWl5K1dtb2JsVTl2VFRFN2dab0FiUkpETmdQ?=
 =?utf-8?B?ZjNxR2NLdFV2NHd3U2x1aXRCaUtWOW5qa2lMRHNOZzRiTG9xV1hlQVBvZlpK?=
 =?utf-8?B?aWxKMW0zSlZLUmxvaGpiN05FMlhOL29sVm95UW9YbFFaSm51dzg2bzRMZy9l?=
 =?utf-8?B?V0RudEJjRm1SdjFIQWhHc2NvdWNGajkxZG5UV1dZeFc2dGVaTmRhZXYyclB3?=
 =?utf-8?B?VXBUQkc4V2t6cm1tVGhVM3I0Q1ZldVNUSEd5WjlFSW52M2NqSHdydzNtUERO?=
 =?utf-8?B?WVI1eTJoTWI5S0xCRFM4eStoNHRYR0Z1NW9rN3hwYzdQRklxc3RhSW0zTXc1?=
 =?utf-8?B?aUhrWEdadWpGdko4VWRGNTRuTVBxNVBraEF0TWdPK01URVdLbGcyNWZ1bmJQ?=
 =?utf-8?Q?occrUipwzvK1C?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(35042699022)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 13:31:10.0662
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0914b022-7e6a-43c3-0798-08dced1da1a1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A78F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6513

On 14/10/2024 10:59 pm, Steven Rostedt wrote:
> On Mon, 14 Oct 2024 13:31:32 +0100
> Metin Kaya <metin.kaya@arm.com> wrote:
>
>> Changes since v1:
>> - Update man page for -k command line parameter of "trace-cmd reset".
>> - Add tab completion support for "trace-cmd reset".
>
> Thanks, I'll go ahead and apply this. But can you do me a favor, and add =
a
> test case to utest/tracecmd-utest.c that tests this. It should create a
> each of the types, start tracing, do the reset, and make sure that the -k
> keeps what is expected. Doesn't need to be too fancy.

I wrote the patch below, but noticed I'm unable to preserve uprobes
during reset. I verified trace-cmd tries to prevent
TRACEFS_DYNEVENT_UPROBE from being destroyed, but I cannot see them
after running "trace-cmd reset -k uprobe" command.
The same problem exists for uretprobe, too.
I confirmed utest uses correct trace-cmd executable.

Any ideas?

-->8--

commit 01d0822dc5e22a34155b0a70d56c67fa023ccacc
Author: Metin Kaya <metin.kaya@arm.com>
Date:   Tue Oct 15 09:34:49 2024 +0100

     trace-cmd utest: Add test cases for trace-cmd reset

     Implement test cases for dynamic event types kprobe, kretprobe, uprobe=
,
     uretprobe and eprobe.

     Verify resetting synthetic events by inserting a hook to
     test_trace_sqlhist_hist().

     While we are in the neighborhood, fix typo "ceated".

     Link:
https://lore.kernel.org/linux-trace-devel/20241014175905.03bec85a@gandalf.l=
ocal.home

     Signed-off-by: Metin Kaya <metin.kaya@arm.com>

diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
index 164f5da1..c1a12965 100644
--- a/utest/tracecmd-utest.c
+++ b/utest/tracecmd-utest.c
@@ -352,6 +352,11 @@ static void test_trace_sqlhist_hist(void)
        sleep(1);
        ret =3D grep_match(SYNTH_EVENT ":", "show", NULL);
        CU_TEST(ret =3D=3D 0);
+       /* Ensure synthetic events remain untouched after "trace-cmd reset =
-k
synth". */
+       ret =3D run_trace("reset", "-k", "synth", NULL);
+       CU_TEST(ret =3D=3D 0);
+       ret =3D grep_match(SYNTH_EVENT, "stat", NULL);
+       CU_TEST(ret =3D=3D 0);

        tracefs_instance_reset(NULL);
  }
@@ -598,6 +603,159 @@ static void test_trace_library_read_back(void)
        tracecmd_close(handle);
  }

+static void test_trace_reset_kprobe(void)
+{
+       int ret;
+       FILE *fp;
+
+       /* Create a simple kprobe for do_sys_open */
+       fp =3D fopen("/sys/kernel/tracing/kprobe_events", "w");
+       CU_TEST(fp !=3D NULL);
+       fprintf(fp, "p do_sys_open");
+       fclose(fp);
+
+       /* Ensure the kprobe is listed in "trace-cmd stat" output. */
+       ret =3D grep_match("p:kprobes/p_do_sys_open_0 do_sys_open", "stat",=
 NULL);
+       CU_TEST(ret =3D=3D 0);
+
+       /* Issue "trace-cmd reset", but keep kprobes. */
+       ret =3D run_trace("reset", "-k", "kprobe", NULL);
+       CU_TEST(ret =3D=3D 0);
+
+       /* Verify the kprobe's existence after reset. */
+       ret =3D grep_match("p:kprobes/p_do_sys_open_0 do_sys_open", "stat",=
 NULL);
+       CU_TEST(ret =3D=3D 0);
+}
+
+static void test_trace_reset_kretprobe(void)
+{
+       int ret;
+       FILE *fp;
+
+       /* Create a simple kretprobe for do_sys_open */
+       fp =3D fopen("/sys/kernel/tracing/kprobe_events", "w");
+       CU_TEST(fp !=3D NULL);
+       fprintf(fp, "r do_sys_open");
+       fclose(fp);
+
+       /* Ensure the kretprobe is listed in "trace-cmd stat" output. */
+       ret =3D grep_match("r128:kprobes/r_do_sys_open_0 do_sys_open", "sta=
t",
NULL);
+       CU_TEST(ret =3D=3D 0);
+
+       /* Issue "trace-cmd reset", but keep kretprobes. */
+       ret =3D run_trace("reset", "-k", "kretprobe", NULL);
+       CU_TEST(ret =3D=3D 0);
+
+       /* Verify the kretprobe's existence after reset. */
+       ret =3D grep_match("r128:kprobes/r_do_sys_open_0 do_sys_open", "sta=
t",
NULL);
+       CU_TEST(ret =3D=3D 0);
+}
+
+static void test_trace_reset_uprobe(void)
+{
+       int ret;
+       FILE *fp;
+
+       /* Create a simple uprobe for do_sys_open */
+       fp =3D fopen("/sys/kernel/tracing/uprobe_events", "w");
+       CU_TEST(fp !=3D NULL);
+       fprintf(fp, "p /bin/bash:0x4245c0");
+       fclose(fp);
+
+       /* Ensure the uprobe is listed in "trace-cmd stat" output. */
+       ret =3D grep_match("p:uprobes/p_bash_0x4245c0
/bin/bash:0x00000000004245c0", "stat", NULL);
+       CU_TEST(ret =3D=3D 0);
+
+       /* Issue "trace-cmd reset", but keep uprobes. */
+       ret =3D run_trace("reset", "-k", "uprobe", NULL);
+       CU_TEST(ret =3D=3D 0);
+
+       /* Verify the uprobe's existence after reset. */
+       ret =3D grep_match("p:uprobes/p_bash_0x4245c0
/bin/bash:0x00000000004245c0", "stat", NULL);
+       CU_TEST(ret =3D=3D 0); // TODO: FAILS!
+}
+
+static void test_trace_reset_uretprobe(void)
+{
+       int ret;
+       FILE *fp;
+
+       /* Create a simple uretprobe for do_sys_open */
+       fp =3D fopen("/sys/kernel/tracing/uprobe_events", "w");
+       CU_TEST(fp !=3D NULL);
+       fprintf(fp, "r /bin/bash:0x4245c0");
+       fclose(fp);
+
+       /* Ensure the uretprobe is listed in "trace-cmd stat" output. */
+       ret =3D grep_match("r:uprobes/p_bash_0x4245c0
/bin/bash:0x00000000004245c0", "stat", NULL);
+       CU_TEST(ret =3D=3D 0);
+
+       /* Issue "trace-cmd reset", but keep uretprobes. */
+       ret =3D run_trace("reset", "-k", "uretprobe", NULL);
+       CU_TEST(ret =3D=3D 0);
+
+       /* Verify the uretprobe's existence after reset. */
+       ret =3D grep_match("r:uprobes/p_bash_0x4245c0
/bin/bash:0x00000000004245c0", "stat", NULL);
+       CU_TEST(ret =3D=3D 0); // TODO: FAILS!
+}
+
+static void test_trace_reset_eprobe(void)
+{
+       int ret;
+       bool matched =3D false;
+       size_t l =3D 0;
+       ssize_t n;
+       char *buf =3D NULL;
+       struct tracefs_dynevent *deprobe;
+       FILE *fp;
+
+       deprobe =3D tracefs_eprobe_alloc(NULL, "sopen_in", "syscalls",
"sys_enter_openat", NULL);
+       CU_TEST(deprobe !=3D NULL);
+
+       ret =3D tracefs_dynevent_create(deprobe);
+       CU_TEST(ret =3D=3D 0);
+
+       /* Issue "trace-cmd reset", but keep eprobes. */
+       ret =3D run_trace("reset", "-k", "eprobe", NULL);
+       CU_TEST(ret =3D=3D 0);
+
+       /* Verify the eprobe's existence after reset. */
+       fp =3D fopen("/sys/kernel/tracing/dynamic_events", "r");
+       CU_TEST(fp !=3D NULL);
+
+       while ((n =3D getline(&buf, &l, fp)) !=3D -1) {
+               if (!strcmp(buf, "e:eprobes/sopen_in syscalls.sys_enter_ope=
nat\n")) {
+                       matched =3D true;
+                       break;
+               }
+       }
+       free(buf);
+
+       fclose(fp);
+
+       CU_TEST(matched =3D=3D true);
+
+       ret =3D tracefs_dynevent_destroy(deprobe, false);
+       CU_TEST(ret =3D=3D 0);
+
+       tracefs_dynevent_free(deprobe);
+}
+
+static void test_trace_reset(void)
+{
+       int ret;
+
+       test_trace_reset_kprobe();
+       test_trace_reset_kretprobe();
+       test_trace_reset_uprobe();
+       test_trace_reset_uretprobe();
+       test_trace_reset_eprobe();
+
+       /* Destroy all dynamic events. */
+       ret =3D run_trace("reset", NULL);
+       CU_TEST(ret =3D=3D 0);
+}
+
  static int test_suite_destroy(void)
  {
        unlink(TRACECMD_FILE);
@@ -639,7 +797,7 @@ void test_tracecmd_lib(void)

        suite =3D CU_add_suite(TRACECMD_SUITE, test_suite_init,
test_suite_destroy);
        if (suite =3D=3D NULL) {
-               fprintf(stderr, "Suite \"%s\" cannot be ceated\n", TRACECMD=
_SUITE);
+               fprintf(stderr, "Suite \"%s\" cannot be created\n", TRACECM=
D_SUITE);
                return;
        }
        CU_add_test(suite, "Simple record and report",
@@ -656,4 +814,5 @@ void test_tracecmd_lib(void)
                    test_trace_library_read_back);
        CU_add_test(suite, "Test max length",
                    test_trace_record_max);
+       CU_add_test(suite, "Simple reset", test_trace_reset);
  }

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
