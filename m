Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545B918027
	for <linux-trace-devel@vger.kernel.org>; Wed, 26 Mar 2025 23:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743032798; cv=fail; b=LzTy34nuwssCh6lFziW34VodwGUycwkFm3qKCIUn54Te0vxBeO5WnPPdNelpDqPrguHriPf6EDID41pxcP2YjvFbD00+08BaOsDRnVTWAePSWzNcp5TIHXE5N8eF6lGb/0eOlLQXONl1ExYE86Saxh2GpGXRBRrZP/xsvCU4wW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743032798; c=relaxed/simple;
	bh=++5TSwG6ayTHlSU3MRDnZetaSTtrGJMcHGbp5AO8QwU=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fVXXnp2dyblstjYpksrpYeVItl23camNBqb6YLr8G+4WE2KnBPP4Y+KFYGpMT9Z2dhA0QmOIDyiQEaDXiN0YGbc/X05/aiRDRmI1VC02X4d+0m6LZQLc/L1NaHTLniEB5c6vJNzJ9zsIrA6SEAkWAySsZhDt9SlGeG1+XFp5fuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D8pjVrfE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=H/jGPM4C; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D8pjVrfE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="H/jGPM4C"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52QK0Zrw028474;
	Wed, 26 Mar 2025 23:46:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=yfvBcyDrLizQyOsjausaG3251YFojIwiT1EIApBCeAc=; b=
	D8pjVrfEdywXjRzCatVW5jbtdqYipLqgrsJzWx285k524gkRRgcW30JMlMaBkTQ0
	xBXpbvC0Bk372n+n0i5wzmNlmuBKbqpD6MY27prV/qw3y89VHoMIEQa6GsOLtANr
	SiE2w84cQQL6Aw0CkkaeQEjzmM2hE/C4GZ7QBDjyWFji2T7MuY+CgpByK5kY4Qcn
	AnIXjE/ARK8hg7+ZWiggqHJu/m7ateEACRPOApbg7yZB7FJbPA5TuEYhIA+iT/La
	bs6a3O3MZeJvYnQga8/8Xx0RyOTYuexpD7u8aRF5tujllcF+1FfjaqCX0M1H424a
	/3Thj1i5Rscrb4zaotucnQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hncrtxmf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 23:46:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52QNYKub029581;
	Wed, 26 Mar 2025 23:46:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45jjc32u01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 23:46:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tdisvVOy1wHp1F9DmFAPoXNJvBIufigoJrI8zZft2Zfaowo7xMjrl3cN1QPl16lkzx4cIxZVfncR1loozgc86F1s69k6Pa+ieV00rFvKiXoqiIGV7TMPN4ZlP2Is6/5ZMDOLnNoWRx2/NS5ahG1nxq8yd1Dt04gIX9me84xvJyeUElD+vYrvUxCnKnV77RCSHqyYcJpN0XaywWsVgK2SouULWZpsH5ih1C/PsSIXbFAtYyuW+19rwSnSkAS2qxD7lyuPquW4sf5H1w72S3L7TX+6D9epIHtq5iaEDFJ334XCJGt9pUL76cmIkrQ96l4Cww53tIXbZfAmxlVDErxL7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfvBcyDrLizQyOsjausaG3251YFojIwiT1EIApBCeAc=;
 b=o1xAPpfa4ybuUmuV0tZHClVwAHtcAKUYGQpsobdfKSvkhVb7+oTLvhJgK62OUshRAcUcrwGiHiBvNBGwsbLNapHC2DmvUO61IpQsuZV08Lvk6ybvlAfMIrrB+gsNwVUsEFl98AIA2kJjMeJlB8ZkIouawn1EVBCDYMvswCtvBUdYYsLEu3OphAerLzjQIVBYPiDojRyd4WIJsRVNMxo5G1xLx1EcFze5YmcWOZ33avrneVtUhFSy25LA2P2X+6wjIwwT1Nk82z4NnM+j5GAw7RgyTXI0AVXRkuEvfuhqukyrVpl+6wlF3zcyl0rrJB/C8SmXMvnPrA9G4gQvMsSoWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfvBcyDrLizQyOsjausaG3251YFojIwiT1EIApBCeAc=;
 b=H/jGPM4CodkGkTWNA7wcFSzlo40Fx+Y0qDhPszwAGRSuPOxFGgJefkiqT9w1e3O8LaThfauUAip05tCcdDuO+M5daJcCovPwEdmdJu3NrzE6swN+tiJw/qYmDQS+TWGmvxGCm/0WZ+epdY9JoFmDhMyqOHdY0GczcNyFNoz+sQk=
Received: from MW4PR10MB5749.namprd10.prod.outlook.com (2603:10b6:303:184::12)
 by SJ2PR10MB7013.namprd10.prod.outlook.com (2603:10b6:a03:4c6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Wed, 26 Mar
 2025 23:46:24 +0000
Received: from MW4PR10MB5749.namprd10.prod.outlook.com
 ([fe80::9a04:a919:657a:7454]) by MW4PR10MB5749.namprd10.prod.outlook.com
 ([fe80::9a04:a919:657a:7454%3]) with mapi id 15.20.8534.040; Wed, 26 Mar 2025
 23:46:23 +0000
Message-ID: <e36ddd07-1e90-4fa8-8153-ed519e0994d5@oracle.com>
Date: Wed, 26 Mar 2025 16:46:21 -0700
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH RESEND v2] kernel-shark: Multi-thread the computaion of
 stream/combo plots
From: Libo Chen <libo.chen@oracle.com>
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
References: <20250314220719.1065523-1-libo.chen@oracle.com>
 <435352f3-ee9b-f592-a474-f55fe09a78cf@gmail.com>
 <9a1b5626-c28b-49ea-bc86-6bcdd41cc02c@oracle.com>
Content-Language: en-US
In-Reply-To: <9a1b5626-c28b-49ea-bc86-6bcdd41cc02c@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR01CA0045.prod.exchangelabs.com (2603:10b6:208:23f::14)
 To MW4PR10MB5749.namprd10.prod.outlook.com (2603:10b6:303:184::12)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR10MB5749:EE_|SJ2PR10MB7013:EE_
X-MS-Office365-Filtering-Correlation-Id: a2afc112-ee81-4259-524a-08dd6cc06aad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QUtLdjNjL0J0R0RsdWt2bU9wcDNYTDZQeVExRnd2UTVBeUQ5TnZvMXM0STM2?=
 =?utf-8?B?YnNEUm1vUjBtemRaUnlmdllwcmRXZlREcnlxWHJvUmJCRWJHRmoySGw3dWhy?=
 =?utf-8?B?YjBscCtQbFppYkdwU2VqUDl6bno4aXRpZ0ZuNWlyV3pYZHBWb3BmOWIxUjNu?=
 =?utf-8?B?QXdNM0ErN2NMUWRkQVd0MU90VW1USnJ2NElnREYrdWpGeFVXQ1VHM2l0NHI4?=
 =?utf-8?B?Y25aOFJCWmxxMjlNcUFQOEE0V3VTRkh5c2FRSGRRL25aeWxRcVJVVENWK0hQ?=
 =?utf-8?B?S2Z5aExZK0VtVUx1RmltV1IrTW11cW5DYkh6RnBVL1VnbEVUa1VlUlJ5Q3Fh?=
 =?utf-8?B?OWNsQXBxbTk4Sk1GNzZISVNYR0thMWR5ODJwSVdWeUh0SmI3TkxqbUtwQzdQ?=
 =?utf-8?B?U2JwZjlYanhFa3Y3N1kwdU5ldy9FOTc3dlZTUUM4YTh0TUgrQVh1ZUw1YUZ5?=
 =?utf-8?B?NXZ6dmpYcUp0dEs4NDEzMnFIMk5aVE1sVks0WTRqUkptak5SWGJFWk56RS9o?=
 =?utf-8?B?d3B6enNzelNhd1c3WXd4M25EdWtBVzZoSVZ0NWVjdUx6S1NvQW9BMzJGbGxH?=
 =?utf-8?B?NUF2Qk1SSTVJS2Z6UEV2YzBMQmQvUlowdlJ3UWVFY0hFakx2OVd3OXNuZkoy?=
 =?utf-8?B?N2x3ajN0RHRXdWJSREVNQjVkcUY3Z045SWFUZVJmMGVncHBhVVFYdEwvUUxw?=
 =?utf-8?B?MHV5K3djYUNET2p2aWNJMGhJa0NnUm5jckxEUnp0NjI2UVM0T1ZzdW0wUkZi?=
 =?utf-8?B?MUhmcGtTNzltQ3VVd3I4aTFYM1hEQXZ5Ty92TE0wNkd5MlNWRnBSZ0Q2RVhJ?=
 =?utf-8?B?djFpMS9Rb25hZ01JZzA3aVFHYlE1NE9IM0NEc1U4blh5MEFQTWJOTGsrOWM2?=
 =?utf-8?B?Y3B5VytaSER1RlJLM1hPT1R5aHV5WjFZSFRwd0hRZ0pwcFVEUWFIV3h3R2ZI?=
 =?utf-8?B?eExsL3d2Nm9mSjRZTkI1UDhKbmdtZGdoUEpGVmRabFVOZFN4bWdwbGxDcngx?=
 =?utf-8?B?RjVLcFRTbHlBVzFuKzVOeDFIQXNWajJ5Z3doZVZ3RnZoMEUxOW9WNnpQRmMy?=
 =?utf-8?B?SWRlbnhlc1BSRzlobGtPeUowazNiZTlYczVmK2l4ckdmUEE1cHVSMUlpVmtG?=
 =?utf-8?B?bFRIOWMvMVhMMnkvMVR6b3lEQk9hSlh5QlFmNUIwL1V0UzAzNUptMkxEQUts?=
 =?utf-8?B?SW0xTHRuRm04eDU2VHVuQm85V1FqQk5aeDl0NHBDQnVLRmtoWm9Ya0x5SHhR?=
 =?utf-8?B?VUJ2ZnhreFZUZHpWazdPNkNkRTBkeWZlZU9Hc1dLRWhkVUcvVUhuQWRxa2ww?=
 =?utf-8?B?a09nRjZYQWdWbGdwWVZEYW9hVWdFV1VLY25SbmNXcG5wQlQ2MS9uclFUc29J?=
 =?utf-8?B?Z3pBUEUwM0EzUWkyMy9KT3BWRUVSK1NabW9jVm5LU1Evd21YcEU0b0NsTW1m?=
 =?utf-8?B?ZHU1YVNiRlVxTlkrSVduaHI4QkV4cmNMTlltY1F4MEpsNlFlRFVLL0prcUFG?=
 =?utf-8?B?OXB5ZFZwUUx1aERtb25MUmY0RUdKOXBBYnZFdTlKTXdvQXlZSkd0RkpiZDJj?=
 =?utf-8?B?V2psUWJZWG1FRStIOUJEQWMyeVZuZDJDN2NOT3lnazcxaUkrdEUyOTZCblpX?=
 =?utf-8?B?TllUTHdBZzhidnlBQTFFaWxqQkNSQjV4MkFKaUJZNkNCa2dNQ1c5UFljWnVS?=
 =?utf-8?B?cUI1Wms2b3BHOE5uanVWL3MwR0hLZlNnendlZVN3NDFjZ2NKcXBCUjNwQVhH?=
 =?utf-8?B?RkVIeisrS1V0UWw3Z3NaS0Vqa1ZkL085WW5MUzU1Z0RtWEdlSnRoQmZjK0NL?=
 =?utf-8?B?b0diT3c1N1ZrMW9qVXVCNzNmY1FURVdtQzBUTnVrdWEvVDd0RjNJa2IrcWtJ?=
 =?utf-8?Q?iY1o1X+6zx+Jl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR10MB5749.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eVJNM0NTZ1k3YVhZRFlscjNxQWxIa3d5bDJtbC9vSVhHRVVWaExwTFdlOGRD?=
 =?utf-8?B?M01XMTR1aGtOS2xvMEt0N2sxbG9zNlZwaGpqZlJETy9ZUWN6ckN0akFWVDhM?=
 =?utf-8?B?ZGMvYzRlZHR2alZRaWxOYlBmZGI3YlBVUHl2WnRjOXVTZjN5R0JpN2hrNTA5?=
 =?utf-8?B?TEVnZUZqdThkWkQ0K285UFNNL1R4WThTT3FTNlBmdUgxZE9IY01IbUE0S1FY?=
 =?utf-8?B?UnRSbkJlSDJzRmhMMktORFFUVDRnaWduNW9GbWNJTSt0eThJYXplcVNNUUJy?=
 =?utf-8?B?VEJtMlFEYjArd3VneUxLTEVyelFNQWVPZUUwdXM4TmZ2TjNyVGxnZzllNU9t?=
 =?utf-8?B?UHFzVFV1VzdkS3Ryc2J1aWRiQ2xwdFBSRloyN2E0NWtTOUlHcmVJck5yKzd1?=
 =?utf-8?B?T2szbThScXVtRXhzKzRZYkZKSHNEcEtiblVsMS9DUEtQNmxib1UzTDRMR3RU?=
 =?utf-8?B?TzdLeXROeG5MMG1WNXpNaldKcTB3TXdveFJBZnNnQUhzL2NROFVyR0x0NW5a?=
 =?utf-8?B?UzFZWmwrOUI2WnlyL2QvazI4MVE4QVFmTjI0L0J2N085VXVkblR3YXZSSEsw?=
 =?utf-8?B?N3I0T25SM3N4QWhWRUtpNytTWG45NGtpWFBzbjhzUGQzY2lGWUQ4NllPYzlO?=
 =?utf-8?B?RnNpWjdEalJ4T2p2b3ZLRmhKYUxVNXh5LzVteE9UWU9Uemlua1c2cUUzTVRW?=
 =?utf-8?B?bm1ZbzBSU2s3QVJCWXlGblkrL0E1dldWZjE1Y0xtV3lBZ2o5OCs2NmFsNWwx?=
 =?utf-8?B?Vm4zb01JSUl1cTQ2T01wTlZ4ajFsQmNuWkVhWGdtQy9jZktlclFucmVlcmhy?=
 =?utf-8?B?LzMzS2dzcmRIMDFoajV1dDgzbU9nOG11ZUkwWFVWZjBFL3JsNnhNUHMxb1ZI?=
 =?utf-8?B?QWE3aE8vVVhiK0tRUlFFenFScDNWT1M3aWU1citIay9IMGl3WG83Szhxb3Qy?=
 =?utf-8?B?N1A2c05meU9kRXg1R2cyUzF0WGU0akdhMTZld0lCSko0Q05TNGp3VnJJR25M?=
 =?utf-8?B?dUdNcXRLMzg5cTFNMG5UZ2hDdFhNVXM0cisrUk41U3R3ZHNjYlhrNkZEd0R3?=
 =?utf-8?B?RnMvNjJnLzliWnE3LzgvL0pjcytoSmJQd2t6UnRwei82Z1dUVWltUUtCZkdR?=
 =?utf-8?B?emlJQmpPRnM2SjFaRTRKZnRLZkFJbEZHaVJkY0xZMzEyMTd4UEJSZ2Z6OFNz?=
 =?utf-8?B?L1dka1pjQ1VqbnBZOTduei82bU9XTmNHR0ZTV0FLRWhuSm4yMHpXU2xBMmcr?=
 =?utf-8?B?allLa05DM0lqQ0I1Y2tsSmFvWmo0YWJEZXRucnp4WEpDekYwdytoOXpGbUkv?=
 =?utf-8?B?MlNieXhLV2hVUkplTmY0VmduSEpqZE94YjVQbWd3dStCQmU2TTdhUHVaZXBx?=
 =?utf-8?B?RUFHeS9SSHhwTUVlVkpwNHhkajdCOTRCRlFjeGJVQlBmS1Z0ZVE4djRtd2w4?=
 =?utf-8?B?dkVmaVEvd0crWkRDNzZpTU1GMUlHa0YvcXlIWk9xYjFmTkE2SnlrVys3ZkRw?=
 =?utf-8?B?WDNHbGRTMDZGNjhiVTNsQ1NsK3U4cWVmSkN2cTE1bnFoOW9QWkVXSEtGb0NS?=
 =?utf-8?B?S0Ztd2VIMVMxOVZlVlhhRURQNmMwYWxLdHd3cStqV0l4VFVvdDY3VmEzaGVt?=
 =?utf-8?B?bHdjWWxjQjhNWFlRVU9YMUl4Z0E3Wkg0U01GVmZwQ2hBSEV1VktCSVVYcEd5?=
 =?utf-8?B?M2lPZmdWTnhwb1NUMjVQL0tJeEpVaW9GQ3Z5U2sxK1NQZjZyNm9ETGpOejdM?=
 =?utf-8?B?L0tockVEdXZ4RzJGK3BoVlJ3eVhkalo0SkloZlRkNHV0clVFTCsyN1VSOERo?=
 =?utf-8?B?bkxrYTNzK0JMLzVlc29EVmcvWVcxUXo2NmkrMEFSS29JelBEVndaZXB0SHhJ?=
 =?utf-8?B?Z1dWd3JjdW5uOUJQa29ibHJYRnRScUFubG5BTnBvbXJpVmJIWGEzOTMzT1A3?=
 =?utf-8?B?V0p3TEtrWTJFcVFLbmJ1MXlEN2hoNW9oNERGTXhON1hjbmtPaDN5WVZCN1k5?=
 =?utf-8?B?WG85ZTdZRU5rZDBkek41eWROVkRPd1RFa0h2b3E4bVdYQ0NxTzFwNTE4VDVp?=
 =?utf-8?B?N1Bhcmg5aVJTVTFkVGJoQnp1RFl0aHpZMThUYXY1UEJCUFBJemdiSWdUMjVp?=
 =?utf-8?Q?X5Ou4mOtAP0JFsBiaiXsGKRVa?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C25l8wUf7t+46foctfr6Mq45EQS1PSSNE4EpDkM3ZLgn2oysUD9sCJtoyd+mGCHkWqxeOchPWVc9ZTinc6d1Dxija4T1l9g1DGNK8GIjIlqxxx+3oVeQfFnfFemOtENSdB16q8lxpaDZunlJSTtRxDilsvQOiOCvMt9HKbYCCpUeDbGLMhNLS+ksw5Ph2LedQmzzUIiyqZlKIpzTy0Uy7fcHYcR38gL/ElPZFCRMcp18KEEzPsn4/6RcOM+t7ftLAHAr73gn1OAaIFDzCAtj5NXLcHvsyF9qxmJP2uioxymvSHWfejCCQDzw8RPEGdpn/0cRZbx0K7htpnPi5ay0F96zkxnCzKsjjK4Ex3I3ddEFNNuO5ibgLBUQ7X0MmvPN7fJcuzqrzuqznEuYYmANPCnHTYcJ/4BGIEQZ73bS8ZFxoPwmoYUoQIq6TOL9omvI+SG1BVKbmxm4F/r9dNz/J6eJ/xR7/lEsjg2hn+Ad9T5mNPKM/nz+nVkjwSC/I+a1xOd5u2JLF8ffWZZU1ffjD9sOuYZM7YocYNq1cqziEXB9SaHgsjjrH0uzcyS8MiYYrclC/DRrw803c+chNLrMW+tgOAUqjGIbdN9ilm51yvc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2afc112-ee81-4259-524a-08dd6cc06aad
X-MS-Exchange-CrossTenant-AuthSource: MW4PR10MB5749.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 23:46:23.7753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RfDSP23SBm1/5QCQxw8rieGxPvtZp/LqXVHMUUDXif9Ykhy5WASVTRzPPy+F1lWhIq4wb9NJaqg9Betd6BmPeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7013
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-26_09,2025-03-26_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503260148
X-Proofpoint-GUID: nB0FlE1B9aN1GIzK223b9vcUfGwdoIA-
X-Proofpoint-ORIG-GUID: nB0FlE1B9aN1GIzK223b9vcUfGwdoIA-



On 3/24/25 03:08, Libo Chen wrote:
> 
> 
> On 3/23/25 09:01, Yordan Karadzhov wrote:
>> Hi Libo,
>> Please see my comments below.
>>
>> On 3/15/25 00:07, Libo Chen wrote:
>>> Parallelize _newCPUGraph() and _newTaskGraph() calls to dramatically
>>> speed up graph rendering particularly for traces from very large systems.
>>>
>>> OpenMP technically is a new dependency here, but it's part of GCC, so long
>>> as your GCC >= v4.9, the libgomp library will make the code compiled.
>>>
>>> Signed-off-by: Libo Chen <libo.chen@oracle.com>
>>> ---
>>>   CMakeLists.txt     |  6 ++++++
>>>   src/KsGLWidget.cpp | 25 +++++++++++++++++++++++--
>>>   2 files changed, 29 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/CMakeLists.txt b/CMakeLists.txt
>>> index 988bfd6..7847177 100644
>>> --- a/CMakeLists.txt
>>> +++ b/CMakeLists.txt
>>> @@ -84,6 +84,12 @@ set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
>>>   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -Wextra -pthread -fPIC -fno-common")
>>>   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pthread -fPIC -fno-common")
>>>   +find_package(OpenMP 3.2.5)
>>> +if (OPENMP_FOUND)
>>> +    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   ${OpenMP_C_FLAGS}")
>>> +    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
>>> +endif(OPENMP_FOUND)
>>> +
>>>   set(CMAKE_CXX_STANDARD 17)
>>>   set(CMAKE_CXX_STANDARD_REQUIRED ON)
>>>   set(CMAKE_CXX_EXTENSIONS OFF)
>>> diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
>>> index 9311d98..004d64b 100644
>>> --- a/src/KsGLWidget.cpp
>>> +++ b/src/KsGLWidget.cpp
>>> @@ -13,6 +13,9 @@
>>>   #include <GL/glut.h>
>>>   #include <GL/gl.h>
>>>   +// OpenMP
>>> +#include <omp.h>
>>> +
>>>   // KernelShark
>>>   #include "libkshark-plugin.h"
>>>   #include "KsGLWidget.hpp"
>>> @@ -688,25 +691,43 @@ void KsGLWidget::_makeGraphs()
>>>           return graph;
>>>       };
>>>   +    omp_set_num_threads(omp_get_num_procs());
>> I think I already asked you to check if it is possible to move this to the constructor of the widget so that it is called just once. If there is some reason why this is not possible, at least provide some explanation.
> Hi Yordan, thanks for your review.
> 
> oops I missed that, will move it over.
>>
>>>       for (auto it = _streamPlots.begin(); it != _streamPlots.end(); ++it) {
>>>           sd = it.key();
>>> +        QVector<KsPlot::Graph *> cpuGraphs(it.value()._cpuList.count());
>>> +        QVector<KsPlot::Graph *> taskGraphs(it.value()._taskList.count());
>>> +
>>>           /* Create CPU graphs according to the cpuList. */
>>>           it.value()._cpuGraphs = {};
>>> +        #pragma omp parallel for
>>>           for (auto const &cpu: it.value()._cpuList) {
>>> -            g = lamAddGraph(sd, _newCPUGraph(sd, cpu), _vSpacing);
>>> +            int idx = it.value()._cpuList.indexOf(cpu);
>>
>> Maybe I do not understand what you want to do here, but this looks over-complicated to me. Isn't it equivalent to having simply
>>
>>         for (size_t idx = 0; idx < nCpus; ++idx) {
>>              int cpu = it.value()._cpuList[idx];
>>
> I think _cpuList isn't exactly the same as [0..nCpus) here. In a default plot, some idle cpus may not be appended to the vector
> 
> 	/* Do not add plots for idle CPUs. */
> 	if (!kshark_hash_id_find(stream->idle_cpus, cpu))
> 		plotVec.append(cpu);
> 
> Also you can set a subset of CPUs to show, so _cpuList could be quite random. 
> 
Never mind, you're right. I got myself confused here. Will send you v3 soon. Thanks
> 
> Best,
> Libo
>> The same comment applies for the other loop below.
>>
>>> +            cpuGraphs[idx] = _newCPUGraph(sd, cpu);
>>> +        }
>>> +        QVectorIterator<KsPlot::Graph *> itCpuGraphs(cpuGraphs);
>>> +        while (itCpuGraphs.hasNext()) {
>>> +            g = lamAddGraph(sd, itCpuGraphs.next(), _vSpacing);
>>>               it.value()._cpuGraphs.append(g);
>>>           }
>>>             /* Create Task graphs according to the taskList. */
>>>           it.value()._taskGraphs = {};
>>> +        #pragma omp parallel for
>>>           for (auto const &pid: it.value()._taskList) {
>>> -            g = lamAddGraph(sd, _newTaskGraph(sd, pid), _vSpacing);
>>> +            int idx = it.value()._taskList.indexOf(pid);
>>> +            taskGraphs[idx] = _newTaskGraph(sd, pid);
>>> +        }
>>> +        QVectorIterator<KsPlot::Graph *> itTaskGraphs(taskGraphs);
>>> +        while (itTaskGraphs.hasNext()) {
>>> +            g = lamAddGraph(sd, itTaskGraphs.next(), _vSpacing);
>>>               it.value()._taskGraphs.append(g);
>>>           }
>>> +
>> Please remove this empty line.
>>
>> Beside those minor things, the patch looks good to me. Please address the comments and I will be happy to apply your patch.
>>
>> Thanks for helping us improve KerrnelShark!
>>
>> Cheers,
>> Yordan
>>>       }
>>>         for (auto &c: _comboPlots) {
>>>           int n = c.count();
>>> +        #pragma omp parallel for
>>>           for (int i = 0; i < n; ++i) {
>>>               sd = c[i]._streamId;
>>>               if (c[i]._type & KSHARK_TASK_DRAW) {
> 

