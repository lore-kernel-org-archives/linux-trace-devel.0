Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1552C1411DE
	for <linux-trace-devel@vger.kernel.org>; Mon, 24 Mar 2025 10:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742810930; cv=fail; b=J8oU3rNG+wtnwP2HNLXMPew2/HsLb4VlFiOROkZ8B6jOeP0MwGOQHCwIaEH54/+Pya50KlHQRG18gchyUtPGDcelGSQeam3Qx63dtQzuvOSKEGkDarcLeU1Yj9w1ljb8b7JdKkQ6SYobrViSGCKBLUu35SMS8NY3Of27RQEm2No=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742810930; c=relaxed/simple;
	bh=t+fBOuR9ygJbEyCUnOxMACNv02+FZQZrmmQn0xeyg5E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CfpMLZEPSzsMJkPXk19Y/yy6vFQ1+rz375wm5Nvi6BVXhX5fbvTM7Zo9DKnnRcEFiPX0dQYiLeTd49p9VmC5zdbyeZbFve84zMbUfSZTL57MeQIqO0aAtvuSZr+CB34/YS1KuUupbSP8B3z/gUf7sQ9k8RPVth+1xPaecXXslEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eIbA3ze+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eP45ec/7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eIbA3ze+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eP45ec/7"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52O7uGeC014779;
	Mon, 24 Mar 2025 10:08:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=NK+dCrOA5zTZU8ReTwrNwPtlVYqXdljN8uNkAKJ9Tj0=; b=
	eIbA3ze+Vrm1Giq4YlEDfEsHubv+mDGAbp5x3t4d3jXpz5GjdaegrF83117Vc81U
	cAQWMoViWSv8NjSMMvS3FqCKkUxSX7bStCpaVFcMDeKFg4wNs59IN2yL7N26nk6a
	7zb6qJtDhSCr3HmXwh8poS9jUezSKvYT2w5T4fa5asMbjSvMH1DBDUwbTObnvg5K
	VYo/2/udiXk48kLboJ9svQThRTi1f6gQ5v7dn30R9kGr7odSDnmF12hkzmH0SNho
	LGCm3AQhL/5D8iRu3utPI+gePuSG5cO4XZ1Ns04rW/jidJbhGwvIoTvK6gWRnVF2
	e+/RBdvmJDxuo67ko86sJg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hncrkgke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Mar 2025 10:08:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52O91gxa008236;
	Mon, 24 Mar 2025 10:08:46 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2042.outbound.protection.outlook.com [104.47.58.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45jj6sam6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Mar 2025 10:08:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kZxMW2oXujAmEVwi5PP4mBi05S2NYtibcq/tU68fymM/gy6bmXTsvHWtrdqeN8eV2gq7M0aZNdwJCkljQRuYHmxe54O4oHhRXfCQXORzfDY4o6xT3Smdq8Q5y6rZ2NQ7Og1gM4HeFlGWN7UuZhZZ31+YZmKaOoRYWZGMlxoIJeW0/SeResY8spI9yrAI8YALl2LCW/ckPbR7W70hutbCzsgaW2dSS1ir9snJX2rGSrd0+e6SQQjJCDZDhSouI6N3hnr71LRu/xkwdsVWlP80ttDhxajxBJoJ5obqydQneKV97QFl08XOn4cen0e6Zz0FYVo8Io93XNFSrW7qUa1zkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NK+dCrOA5zTZU8ReTwrNwPtlVYqXdljN8uNkAKJ9Tj0=;
 b=v4PW6ziWwt8SzTof1F1t0ist5GTyJTShB3/cjUoBqLH0N6ceYUQLcl38tdK6M70L/ggtPUNumQPvS20TY50tfCdgy6HXjRzIa+Uw7qaTyseB/fgkU/UdSIetAq3Q+7vIR4OtDK4SVm31IqpgGQrbltEb26Ve7cAD81CCRnr4KOILH0da8FCt3kWOzwYhKcaKs39Dx93TKf1Hwyy8IQoZqnezvO9m9yJn1wCBPF2IYoXvzvKVAJwJJqrr20gnlBUJIDQdBQJegGMTCibL8Zfv3N4JMyUcr4m94eH5VK1ilT3RwmkyB04YRWCfGxW0CNx65+C20iNjjsIHPRhWuRkVFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NK+dCrOA5zTZU8ReTwrNwPtlVYqXdljN8uNkAKJ9Tj0=;
 b=eP45ec/7No60UP+5g3buBi2XLXMcLIKBGLijpNJalTUV1Eu7xuVYaieamHfgJ02z05YBcc+VXsbeTj9HKrU9T45Ux0a58ESNNIMrrA8HUZE3N0PMIxpTOC+0k3MGf1g+s1ld3UCFySsewsKJlv8NXMvV2ShO+af+NrIZbIetXyU=
Received: from MW4PR10MB5749.namprd10.prod.outlook.com (2603:10b6:303:184::12)
 by PH7PR10MB6057.namprd10.prod.outlook.com (2603:10b6:510:1ff::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 10:08:44 +0000
Received: from MW4PR10MB5749.namprd10.prod.outlook.com
 ([fe80::9a04:a919:657a:7454]) by MW4PR10MB5749.namprd10.prod.outlook.com
 ([fe80::9a04:a919:657a:7454%3]) with mapi id 15.20.8534.040; Mon, 24 Mar 2025
 10:08:44 +0000
Message-ID: <9a1b5626-c28b-49ea-bc86-6bcdd41cc02c@oracle.com>
Date: Mon, 24 Mar 2025 03:08:42 -0700
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH RESEND v2] kernel-shark: Multi-thread the computaion of
 stream/combo plots
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
References: <20250314220719.1065523-1-libo.chen@oracle.com>
 <435352f3-ee9b-f592-a474-f55fe09a78cf@gmail.com>
Content-Language: en-US
From: Libo Chen <libo.chen@oracle.com>
In-Reply-To: <435352f3-ee9b-f592-a474-f55fe09a78cf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8PR07CA0016.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::24) To MW4PR10MB5749.namprd10.prod.outlook.com
 (2603:10b6:303:184::12)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR10MB5749:EE_|PH7PR10MB6057:EE_
X-MS-Office365-Filtering-Correlation-Id: d68d1101-bc24-4975-ebfb-08dd6abbdc02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VnhhZ0FEdE1vbmxyRm0zT01zUGJoYW9wTk9NemhNdnZDa3Q0OUsyTkR0Tloy?=
 =?utf-8?B?MVZkS0lrS3UzaGV4V2t6YmErNFFrenNjZk1jTFlpUjArZFBxQW83MjNNbkxC?=
 =?utf-8?B?ZW95aXZBWTArT3hPZE9PQXREemJaa0pDejJGSStxWGxsb3VaZ0dDeHU0VHMz?=
 =?utf-8?B?VkNGdmtKOHZkQVdSNkZFd1htTjNVZDRJTGErOHgwaTV5QmIrVE1UQnRTU1ZL?=
 =?utf-8?B?QTlPazRnWnpUc0FiV1U5WjZxc0hJdmlDUEdYN3pYQkoyWHRlY3dvN1lFNFcz?=
 =?utf-8?B?dHg3UG0xZ2dWMkRwSFJDRm1MVVlBSkM5bExyeC9sSTU2aUtHYmJ5TTJCMk1Y?=
 =?utf-8?B?MndqMDU1SVdSK1pDeXRLUzBSejlQNVIwWTN6NElWTXJISm9aWGQ0ek8vQkQw?=
 =?utf-8?B?RUY5QWVPTHFVUzJ0ZEx4NlB1NWw2SnZFTjUxblM4YVU0N241amt5NXdydFh4?=
 =?utf-8?B?VDg1czJ2Z09QM205WTJNRnR5L0p0RDl6eTVpRUZmNVNVM3NiVnhJSVIrbTlF?=
 =?utf-8?B?NTBnSmFTRC83amE0SnVTVXdvc0MrdHZYT05GZWdVZ2xNYVoyejR2b1NMb1Vv?=
 =?utf-8?B?SGtkQi9waDkyQ3FKS1duRmNJYWNzc2xIWUNVV1ZwQm80OG4yQ0V1ZGhvREFJ?=
 =?utf-8?B?VWlnU254ZUpmcVJPYldqSE9US1R3ZWVwYnFHTW1ZZ2RXWWNNeXJTZDRrOVgr?=
 =?utf-8?B?NHVrSDQxTE1JYitIeTl0dG93ZmwvL2lxZWNUNTJzVEtSUUIrMFc4a1JIQ0Vw?=
 =?utf-8?B?Vk52QlFVNWpCVGk5eC9VTVozR0lua3poWjlSRnVWVmxNU2hVQnZlZGlmNlBI?=
 =?utf-8?B?dC9hU3pUUHpHcThMdzhCRGd3cC9IamZHbDFKVll1SGE3QW12YzZnY1VBSjlx?=
 =?utf-8?B?SzQrNzNSNzUySFFBckZXWVR6Sm5uZlJkTk1ucWlzendNRDZRbGI0MWQ2K1Yw?=
 =?utf-8?B?aGtpODlrMDVrLzkxSUc0YnV6ZHBNa1hJbHZPejlQSWNEcWQrcWNxWlIrMWlq?=
 =?utf-8?B?dTRDbUc5UlVkWERMVHdLa0ZzRlRTR0N4WXZtSC9xS2h1OCtocmRHR1Y1YTk2?=
 =?utf-8?B?ZUphcnZnRlkwMUY0ZzE2d0pISDkzSEt0eGR6M2JwY0Y3dTQzNWwrMGxpRC8x?=
 =?utf-8?B?aTlSMGdZK20vVmt5VXVWa01TNm56ekR4TTRSMzUwZkJyWituVkFWWG9BRFo3?=
 =?utf-8?B?NnRvL2JYQjltWEJNTVF5RWRNZ1licGJmRFpobk5MdHVuTkVTcWZqY3BHdjJm?=
 =?utf-8?B?ZGRsSFhCeWtRbUgzUGJCblZBOU02aUtjMW9XMmZvbGdaWkN3MHZ2NVM5VXJE?=
 =?utf-8?B?dWJIekJpcEpXN2RzTkI4eC9FMXBGbDJ3Qjh1bGIvVTU3NmQrcytkZjhxcG5n?=
 =?utf-8?B?bEFkVmJPZ25xT2J4YWxIOVFVV1FsRk10d0FtZi9HNGc5STFJSFJ2b3pIeSsx?=
 =?utf-8?B?N2I3UklxU3lPejAzV01BRnV5b0tIUFhOUzZUL2ZGbFlBSWRPUTQ4RGNQYkNa?=
 =?utf-8?B?NXpyMDRGZE43b2lNVFFLMnlqQTBDRWF5VThwRVJEWFhhWnNmR2thQW1IZ20w?=
 =?utf-8?B?Y1lrVEc2YXJHckdUays1RmFFNWdSVzBCY2llRWNNZVB1Z3cyd3R6REc3MVF1?=
 =?utf-8?B?YWRmcW44SUlFcDNvUjBVRGxTM0cyR3hHUFY2c2t6ckFwa250Mlg2Y2xnelJo?=
 =?utf-8?B?bDRrSzY4L2lIc1BoR21sM0FGWk9IeUJQb2Z1WEExaVpjdmYyQVM5aGVUTTRo?=
 =?utf-8?B?c0x3QldXQ1dIMC9QV3hwMGtwd2paREE4ZTh1QVVWbldvNWxqQ2xmWHNJSGJ4?=
 =?utf-8?B?eGVSTi81SHdQQ0ZjL3BJWjkzcmMrcW9HaEtVK2NUbHAyOTMyZVpTZTZ2aVFw?=
 =?utf-8?Q?BPvqd+/kZVl3j?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR10MB5749.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHdSdkNVTFFHbEdQZG1XeXlBVVFqdFk0bHlhQk9ta2Y3M3hBVzdOQmFUYUpY?=
 =?utf-8?B?d2d5MStMQ256TEdKSnNzVDB4Z0o5OUUrbGJlUDRlcjZzQVR1enBoUnFCYkdy?=
 =?utf-8?B?c0xiQmxzVDcxRlNsNjR2a0hPbVBKNGdlZnR5SGQ2NlFHU1FSWmlreG9SdTZw?=
 =?utf-8?B?SUlWcjQveUlQRHdiRC9valBMRkJ4YUJpTHV6QnNudDU4ZXFuakwwMDB5QnF0?=
 =?utf-8?B?dC9RRlFOd2g5UjlRb2ZYM0lxWU5iQ09mQmtNdSsrUUJ6VFo1NUhNRUFqSklL?=
 =?utf-8?B?amY5bHdGSDl6U1UrTzVrNzBTeFNzQzZ5clV2UmxvQm1WTXNOcVBzVFRKWjlJ?=
 =?utf-8?B?aFNaYisrK3owcUJpeVRQVWlQZ05wdzBQNGFpUGxwcHhZamIxemJRLzdQVmUy?=
 =?utf-8?B?aWtWbjVjVllhYTdSditsZHhZWS8weWZXZUE1U3VCa3Z0SjdzNmhxdSt0dDVB?=
 =?utf-8?B?eDhFdk5KWTlHSFgxekh2K3FjRGZnODcxak5pWCtkMXdFU0VzcmVlUU9ZaXRW?=
 =?utf-8?B?RHVKbzl6QmFuSnFyVlFONkJueVo1RzFwQndzdDRSNVRnQVVnWHd1dURQREN4?=
 =?utf-8?B?eFFPSlFhcnVWeWdIUVQ3MFZrZStET2g5OVRrOU40SHdOM2RuZUMrcGx0ZlFx?=
 =?utf-8?B?ei9CVVM4WEM2L0cwcDBuN3J5OXR0YVZRWlBseG5ZU0JaVXlDSDEwMkJvTEpQ?=
 =?utf-8?B?VUxCcGhYcDZNZkp3SW5zN3lsOXRtZCtPaW50dTZlQjNiV2NhMkx0MlJaMnc3?=
 =?utf-8?B?cHpwajhKQk1sSUIxeVpLcUNlTVplMVJ2bXIxTWZDaUl2WEJxU0Rib2U4TmRv?=
 =?utf-8?B?Vm1pZUFKNW1rVWhlTG90TlFCY3NtaU1jR1QvYWw1akFMeTg4UU1HUDI3NGhP?=
 =?utf-8?B?Nit0TzZES0lCWm8vSXNNdkJ2eURKd2F5ZkU1N0VmakZESmp6WVlVTXBBb3ht?=
 =?utf-8?B?RUVrMEQxdnVGdWpHemRxZUdUbHRaTEcrbmVkN3czOWZWMlpnMzR1WHp6ZWcy?=
 =?utf-8?B?TTUxK01wVUxDNkVBbFpKZTlwM0JJSjlKRkZ0bFhRY1M0UzIxSG1XVm5qa2po?=
 =?utf-8?B?Q0hGUEpRaWFHRG9TVmNBbytoUW5la2Jwc1J1RVorRDlrWmxhRUhFV3VKS0Fs?=
 =?utf-8?B?Z2Vrc3ZlTkVtTHczRHlRMWNkMStIMG9mLzcyYlZKK1h4TE1FSEZGNjMxMTR5?=
 =?utf-8?B?OU1Vc1lPdFBnNWhiQUZHVDdYOXlkUzhxSUx3TjhVUjg2VllDOUJ4MmpKdWRG?=
 =?utf-8?B?NUUzRmN2MFR3c243cVdpQjJWS2pnSXBIcjFTYStodzNyR01RNlRJRWZ6T21t?=
 =?utf-8?B?UG1nazJhMXZZSXU5QmhMVGhKVVgzd2VzbndBd3RlREpGT3NnVFBHMDhuOHZF?=
 =?utf-8?B?NXZHSkt4T0NwbUk1NGR0Wlg4V09YNkUxSTA1Y3hwSStacmExRmpEQngzbjUy?=
 =?utf-8?B?YzQzamM4Z3hEMU0zSnZtNGpMOU5EeVhTcER6SElNSG56cmZVM2llUytmbmZv?=
 =?utf-8?B?OHVWcjZIR1B3aTVzWGpkQkZHbkJpcmdPRVZ1d3ZZNGJMenFQOXNSaWdJREFq?=
 =?utf-8?B?ZWhJRFg1YWVkQkJhYUhvYUhXbXNTcDZCY2Z4cjk1MUxleEhIT0N1cnhkWHFL?=
 =?utf-8?B?dXd6bkt3eFdqNDlyU3BuUE5nUlY4MXBLb25sOG42ZkhKQWFYc2RKZXd0T0pn?=
 =?utf-8?B?eVRIMUdqb1JCMUc2aWszbjY0dEtFaFA3dHlkcGlnS2pQTlJUNHMxSDE3ck9J?=
 =?utf-8?B?T2htZFZhN0xDSkVMSTNqZmh0Z2N2Y3hLeUtaOERsSEpGSzJXaCtJNkRPUHoz?=
 =?utf-8?B?TjdtQnpyc29Pbk0zZytMNkp0WUhRWFBaZnlQVWIwVXZVMGJZRzBHbkpFeU5P?=
 =?utf-8?B?TERETndEbzFoYUNPckg4QlYxcjBnQjhQUXgzSVd5SzV6ZWxSVXRnWEMrRWNk?=
 =?utf-8?B?aGpQOGNUN3FCRmJvUzNqNlRXTnp6TVU0R0pZdG9FVXdWcTJLcW9ROFhpMmt5?=
 =?utf-8?B?dytKNHArSWk2MHlweHFxMHlBRWZzbkVNRkl5SS8xbmEzcVBvdWt1aWlsMy8v?=
 =?utf-8?B?QnpTellVYjhHTWNVeU1TNERZcWpRb3dxQnkyR0JSYitKd3dNUTdCVjhIa05F?=
 =?utf-8?Q?N1PEx2pJZtmNY3/ycEniSuLsf?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ds6JA3B2tpibDrpv5/RlAZK7ThPKHU7NhpAsMfSctVsHAfDw724k+s2vZ6UUuASWHqP1qfm+PzqPB2ta2wT9IWAB5xBhmunGH7L3+zcc1UKTItKgdGGGWEOlS5oVXYtWip8PMoYp1b0oTTp67g1n/FdaFfs9jYtx7wPQyHkda38XSxYeDxCiKvDEMkKbho57rFpgss9hbIoconlngCABBkB+yS/w+F526pWUQZQ4/uyakjKIw5+eyn/qC18CQRWIMvhucG9Uycw8tcnT7MRdA7Daaza5IMH8HlLm+kczWnmrL4zRaqx8W4QGGtEawMRl2rCFA9GSBXsQsFIM3IFVk/amt2CQhObCsGbUZN/3UZSzlcqGvF/g2DkyFD4ylehVoD/+PQvzjWsvca3IIb/dFl7/ct5XvMO6oTKApjF64eja2FNMkZOFujDFXEbMY6zKXn1zJje0IC+/GXK5FKfNQcYkDDBuuHpYaaioOYKJ67v6gwAc+vnF5NdCYZgEYwK3LUEKJlPuC1WQw1cYiNFHOOJ9d+Ec3/wtd0rbXOTqblkLHvGDSQIauEJrhCSgHyOXnRYDwu5sfZpWDDVpsnNy2zZW5HGMR6ScP6GHOBhEkHM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d68d1101-bc24-4975-ebfb-08dd6abbdc02
X-MS-Exchange-CrossTenant-AuthSource: MW4PR10MB5749.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2025 10:08:44.1019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +sZxsU8yOxGHRko2l9PrdWmhVvLmojUG/EVyxEqrJcVRufp2YywaR+cd7NGwsAxeQNBlC6V+5rQvP4Ey3jmGCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6057
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-24_04,2025-03-21_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503240073
X-Proofpoint-GUID: poHaCJPw0sH0guszGn9K2hWIB9L3Hu44
X-Proofpoint-ORIG-GUID: poHaCJPw0sH0guszGn9K2hWIB9L3Hu44



On 3/23/25 09:01, Yordan Karadzhov wrote:
> Hi Libo,
> Please see my comments below.
> 
> On 3/15/25 00:07, Libo Chen wrote:
>> Parallelize _newCPUGraph() and _newTaskGraph() calls to dramatically
>> speed up graph rendering particularly for traces from very large systems.
>>
>> OpenMP technically is a new dependency here, but it's part of GCC, so long
>> as your GCC >= v4.9, the libgomp library will make the code compiled.
>>
>> Signed-off-by: Libo Chen <libo.chen@oracle.com>
>> ---
>>   CMakeLists.txt     |  6 ++++++
>>   src/KsGLWidget.cpp | 25 +++++++++++++++++++++++--
>>   2 files changed, 29 insertions(+), 2 deletions(-)
>>
>> diff --git a/CMakeLists.txt b/CMakeLists.txt
>> index 988bfd6..7847177 100644
>> --- a/CMakeLists.txt
>> +++ b/CMakeLists.txt
>> @@ -84,6 +84,12 @@ set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
>>   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -Wextra -pthread -fPIC -fno-common")
>>   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pthread -fPIC -fno-common")
>>   +find_package(OpenMP 3.2.5)
>> +if (OPENMP_FOUND)
>> +    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   ${OpenMP_C_FLAGS}")
>> +    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
>> +endif(OPENMP_FOUND)
>> +
>>   set(CMAKE_CXX_STANDARD 17)
>>   set(CMAKE_CXX_STANDARD_REQUIRED ON)
>>   set(CMAKE_CXX_EXTENSIONS OFF)
>> diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
>> index 9311d98..004d64b 100644
>> --- a/src/KsGLWidget.cpp
>> +++ b/src/KsGLWidget.cpp
>> @@ -13,6 +13,9 @@
>>   #include <GL/glut.h>
>>   #include <GL/gl.h>
>>   +// OpenMP
>> +#include <omp.h>
>> +
>>   // KernelShark
>>   #include "libkshark-plugin.h"
>>   #include "KsGLWidget.hpp"
>> @@ -688,25 +691,43 @@ void KsGLWidget::_makeGraphs()
>>           return graph;
>>       };
>>   +    omp_set_num_threads(omp_get_num_procs());
> I think I already asked you to check if it is possible to move this to the constructor of the widget so that it is called just once. If there is some reason why this is not possible, at least provide some explanation.
Hi Yordan, thanks for your review.

oops I missed that, will move it over.
> 
>>       for (auto it = _streamPlots.begin(); it != _streamPlots.end(); ++it) {
>>           sd = it.key();
>> +        QVector<KsPlot::Graph *> cpuGraphs(it.value()._cpuList.count());
>> +        QVector<KsPlot::Graph *> taskGraphs(it.value()._taskList.count());
>> +
>>           /* Create CPU graphs according to the cpuList. */
>>           it.value()._cpuGraphs = {};
>> +        #pragma omp parallel for
>>           for (auto const &cpu: it.value()._cpuList) {
>> -            g = lamAddGraph(sd, _newCPUGraph(sd, cpu), _vSpacing);
>> +            int idx = it.value()._cpuList.indexOf(cpu);
> 
> Maybe I do not understand what you want to do here, but this looks over-complicated to me. Isn't it equivalent to having simply
> 
>         for (size_t idx = 0; idx < nCpus; ++idx) {
>              int cpu = it.value()._cpuList[idx];
> 
I think _cpuList isn't exactly the same as [0..nCpus) here. In a default plot, some idle cpus may not be appended to the vector

	/* Do not add plots for idle CPUs. */
	if (!kshark_hash_id_find(stream->idle_cpus, cpu))
		plotVec.append(cpu);

Also you can set a subset of CPUs to show, so _cpuList could be quite random. 


Best,
Libo
> The same comment applies for the other loop below.
> 
>> +            cpuGraphs[idx] = _newCPUGraph(sd, cpu);
>> +        }
>> +        QVectorIterator<KsPlot::Graph *> itCpuGraphs(cpuGraphs);
>> +        while (itCpuGraphs.hasNext()) {
>> +            g = lamAddGraph(sd, itCpuGraphs.next(), _vSpacing);
>>               it.value()._cpuGraphs.append(g);
>>           }
>>             /* Create Task graphs according to the taskList. */
>>           it.value()._taskGraphs = {};
>> +        #pragma omp parallel for
>>           for (auto const &pid: it.value()._taskList) {
>> -            g = lamAddGraph(sd, _newTaskGraph(sd, pid), _vSpacing);
>> +            int idx = it.value()._taskList.indexOf(pid);
>> +            taskGraphs[idx] = _newTaskGraph(sd, pid);
>> +        }
>> +        QVectorIterator<KsPlot::Graph *> itTaskGraphs(taskGraphs);
>> +        while (itTaskGraphs.hasNext()) {
>> +            g = lamAddGraph(sd, itTaskGraphs.next(), _vSpacing);
>>               it.value()._taskGraphs.append(g);
>>           }
>> +
> Please remove this empty line.
> 
> Beside those minor things, the patch looks good to me. Please address the comments and I will be happy to apply your patch.
> 
> Thanks for helping us improve KerrnelShark!
> 
> Cheers,
> Yordan
>>       }
>>         for (auto &c: _comboPlots) {
>>           int n = c.count();
>> +        #pragma omp parallel for
>>           for (int i = 0; i < n; ++i) {
>>               sd = c[i]._streamId;
>>               if (c[i]._type & KSHARK_TASK_DRAW) {

