Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8598220DF4
	for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2024 20:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721249119; cv=fail; b=PQnkgnacg5odVCWLZm8rQ7ij2df4ULNjWe895VYpTDvb/ndeuwzZypziHMeyMtJ26DOjBYXit3UuX2Zq3Q+aoUfBrdbfIzf/mC4+F3LHthpTzKUmkG7i4F9vNPFWmQDHLM2X77cRWkmltCtlPqpaPWl0X8GXmg43/CMPsWtKsMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721249119; c=relaxed/simple;
	bh=ZX3K9v3mqYVnUqA7+nY67NqTVsBwO2WrzRg77iJ4M98=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D/syvHn+OZpkljNLfcrPu+HB+1j/nlEPkE9BuExXQ7XvY36ewfnR2AeGBas9qOoCTzivrKypbyi00l0GlHlpjGOX3hi2yyjg60yZTbPgik54sSbgTaol74MBPAdIM9B/pTMU1Rche0O3/DaEetVZgk0NBbsc+CNvyGcT1B+j62g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eNDzXME3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jW21jd6l; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eNDzXME3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jW21jd6l"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46HKZckE025321;
	Wed, 17 Jul 2024 20:44:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=e7ZgkyiOC0aUG8BfHHhL+b9aHFmsfSPNMoJi9Nmjh8o=; b=
	eNDzXME3nyKzsMeMnbl7mYyz/D37azVrxnxKq98ZWYCfYyCfscxPL4EOR+8oZeqO
	n5ZGX9DI4UObed0VeBfecQElIwoHO2/P7yONV5ZWB/fIxEuy4keMualcRvftcQVM
	CJiPx1w467Wg76vBODq8YJLXjrNPSjyvnDMa/Ezyph9OXyFFYHKyRkWjzzhwPmyZ
	RmcOePM7vmBAOIkbCURdLoQlNAJ6telueYqVRVZui/7zFBk5GjLGxdwWkfohBzqX
	wKTJolL+Ur1dkxM/ACIDiqJYfQeGadCe4A6YHgkupet1IWYsMeFN62eicITPOXYf
	B2O0cqac2+SXObk4iUUnnw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40en4br0u4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jul 2024 20:44:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46HJHufd020094;
	Wed, 17 Jul 2024 20:44:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40dweyjjx6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jul 2024 20:44:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ciNm5sBY9nFD36/j8FEgsHVK6hyCak4237qvQRD48JPqnX8NM0FNc7izWxZ8F/B/3HrUL8WhSBNlXzctr8aiZ8HDuqpwkLahd3WIcJkdRSVZpZ9FjEY3d+mQBNAmpbxbcXBOtP47QTiaDJ4REuv/jOV6TggvWprmUMcLRhLMRNpAHyiMMUkP/3qRpnYsOdA/sbwOxA2cQrMnLSIgVOalI5kYraeCr8WMcBQCWUCIAQY2lEzgytCTdVMcM7PcyTBSsgHstCv+u82VgLKzARxfM75oGYZIQ3ROzmgRGpwW5bgDw6Bw+NCvpi15cYhOHb+BfwH2wOp8hxxX1YG3pGfRvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e7ZgkyiOC0aUG8BfHHhL+b9aHFmsfSPNMoJi9Nmjh8o=;
 b=yZKGfVdezyLoa/bZrOHPVw4mcjxpUlxgbKG5JHkqy1emYflktojyRE4+JipfR+1iM6fMpzgigKXXcNdrXDcejImnYl+389fOGQVoQ9ZJJKFuKs67HfM6QNAA4iZY73d9kVBhlSzQaNsL5YkMrxNEGdVUrNpDXw4rp4yikkGBDgTMAN3KTBb1Tih+mB9aYORKn7Qcc/lgKefuysFaSzjMNyHGMYcS/SYQ/cf/3faTeLNF5KWV8lTIEpseu148a5fOdEgz+7uRTkfQZYHwbDw241jwFI3GX6m8L+tqRvIZBjgz32ni9JxBgncJBUYPec52W6JLQOrKmw/SNa4hqAzJtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7ZgkyiOC0aUG8BfHHhL+b9aHFmsfSPNMoJi9Nmjh8o=;
 b=jW21jd6ltp0v6bH2s/5qD086kS7JFe5u2hOoW7h+/0k/LOjzhEin1BYQkrRGkcjXk/A88mLkKPfCE1bZFa8dmyz3YMbN35TJVOCewAL2DJDhQFIuu1rSwWVDFz+D38juznVSYfoZoGQS+7GoVcgB6e2W5iKmoSIzSUzlCW8bJns=
Received: from PH7PR10MB6379.namprd10.prod.outlook.com (2603:10b6:510:1a9::15)
 by BL3PR10MB6091.namprd10.prod.outlook.com (2603:10b6:208:3b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Wed, 17 Jul
 2024 20:44:46 +0000
Received: from PH7PR10MB6379.namprd10.prod.outlook.com
 ([fe80::c7da:13dd:aa4a:925b]) by PH7PR10MB6379.namprd10.prod.outlook.com
 ([fe80::c7da:13dd:aa4a:925b%3]) with mapi id 15.20.7762.027; Wed, 17 Jul 2024
 20:44:46 +0000
Message-ID: <228cdfa6-29a5-4647-aefb-7fa04c1b1a00@oracle.com>
Date: Wed, 17 Jul 2024 13:44:43 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] trace-cmd: Add ftrace options for the fgraph
 retval feature
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20240521213730.67993-1-jianfeng.w.wang@oracle.com>
 <20240521213730.67993-3-jianfeng.w.wang@oracle.com>
 <20240717145028.73683d09@rorschach.local.home>
Content-Language: en-US
From: Jianfeng Wang <jianfeng.w.wang@oracle.com>
In-Reply-To: <20240717145028.73683d09@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:a03:60::42) To PH7PR10MB6379.namprd10.prod.outlook.com
 (2603:10b6:510:1a9::15)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6379:EE_|BL3PR10MB6091:EE_
X-MS-Office365-Filtering-Correlation-Id: c89e8c08-e043-4c48-3d22-08dca6a14b05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?OFhwVGR6bzYvRU9FMVR5ZGxxSWRFbVk2TFZ6WjQ2VnIyTUxJT0dpVjZFZXVC?=
 =?utf-8?B?Rks5L1BpMlRXRWdJcHZqSGFXVFhvZWNGU29wbENPUzUxSTFlTWFvKzNDOXh5?=
 =?utf-8?B?YU9TWStzUW5UY2hIRVlCSmJXblRkbllqMU9DNkF5NkpLY3dsbEg1bVUyaWg0?=
 =?utf-8?B?NExsSWhjd1lCV3h5NnBzdEh0U2J4VzR1eXVMaVI0RnVUTDR2ci82UDhSMXVS?=
 =?utf-8?B?M3NsQUhRbVNrNFZaclFTUlA5UXZrZnFVQjd6OVZQeXJjT1MxeUtwQTZUT1hL?=
 =?utf-8?B?bzVTR2lybmpncVRyYzA0bHYwaGJ3MHNyeGhOQS9Bd3JRZHlIZzNzYmYwN2Mw?=
 =?utf-8?B?Nm0yQ25SM3YzbHpOaVZTWU04emU4KytNRTRnNWNaUmd3V1BWaWFpb1BlUTdU?=
 =?utf-8?B?SFltKzFNMldWVlJvTVdNcGs1MUVCa3BaU1B3Ynp3QzVsZkxIQjgwTGdEbGtE?=
 =?utf-8?B?Z2JnRkxKQnJFRHNGSkErQTc2RUxUam1IK3FOTmZZTFlFWFViazVqdWlScXdJ?=
 =?utf-8?B?OWR5bDlrZHAzMTN4K05RcUJ4cEtzTTN5NHh1ZUZQcWNmNGVyNmJJMGozWW1w?=
 =?utf-8?B?aENheTcxR1pHK1ljTGFrU0d3aSttTlZiaENFdFpXQU5aenBqSEc5dENMbjhq?=
 =?utf-8?B?UVA4eVNrcFBXdVlGb0lFdElqQlQ5cDNHTjNwUTNYSTZpKzdEZ0VjYW5NMWxj?=
 =?utf-8?B?MVpQVHRibzNTMFlxOGtZTkVpaVU3cXNPTS8vdGxWdG1jYVBqNmRBKzF1TkRi?=
 =?utf-8?B?ZWQ3T3hKMG9uTVBwSkFkZXVMU1Z1QnVXQVZTalZGMHF5dEY1bWVKNm0zMU9t?=
 =?utf-8?B?UUZTYVY5dGcvZEluVU5tbm9ia1lBN2RrL1JvYm5mYU12enNoOEFwdUNSNVNq?=
 =?utf-8?B?SVBUYjJJVU00Y0M0NTBTN2xJREZ5K2pYUmFGSnJDYVlJRHY2aEcySGp4bEdD?=
 =?utf-8?B?Z2dZancxVHphdE5kdm5ZQk9uZ0twSVVzWS9wUnp4NUJDaVBaaE5jaTloWlM4?=
 =?utf-8?B?Q3FxU1AzNkowVk1EZnlwYWV5azBlOHF4dTZ0V3UxWTgvakpRZHBQeGltUDRY?=
 =?utf-8?B?K0VpVkZCbFFRQkR3WWZwVWwvbjVNTkEzNG5WT3VvNmVNS0RwVHRIUnJzSC8w?=
 =?utf-8?B?QTdvZS82RGt6RS9reEJjRFUyMjREdXlZa1BmOVFRaU44RjhjTXAxemlKaTdG?=
 =?utf-8?B?bEpuR3VDZmwrZ0dhR0Z5aENibjFsa09uUnZySUVRQ2tkZm8yRk9RWHZRSTJx?=
 =?utf-8?B?L0NiTzBDTDVjc204bmNjR2dXVTd3OVlkMk5pU29lN1BNbUFqc01MZGN2Wktx?=
 =?utf-8?B?SStDNkRaMDBZQlBJTlFBZkxEVG54ZXpjUWVRUmtWNWFpSTcvOThJKzhxSmJi?=
 =?utf-8?B?dkNPZG1vclpydmQyUFluSEhMdFU1elRnUHZWdVp5NlNHZGtDcEN5cjl4SnVh?=
 =?utf-8?B?L3dsRHFsR0JMcklWczZla1pOa2tiQlZDTlZZNXJ4Smx1dWpPUmxTMldxV2pq?=
 =?utf-8?B?MFFjMjMrbkRLL2Vqalc2bU5uQ1V0UWNNMElhbitBTE0rVElhaHE1MVZQK3Zu?=
 =?utf-8?B?UVlGYVlEQnZkWEY4WXd0bjdaRjI0SGFXRFRINFI0bnJEbHhPUVdldmNmczc2?=
 =?utf-8?B?OWg4VWp6MFNuL0VaRitOMW1BNzF6RjI5eGVrTjZRNHNOOXVXWmpjT2xrdHZp?=
 =?utf-8?B?bjNaa2pmOEJhd25XUmxtSlFmNVNubHhGZk9sa1RNdTdGRFZJV1hNK0lyNlIx?=
 =?utf-8?B?T29EOVlQbEpOcGVrS29jak5ta01UYUhwL243VUgvbitxTGFybFpiczM5VjdK?=
 =?utf-8?B?UFErR1BYN2VFSUEyRmE3Zz09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6379.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?OG9lYVZPTDYvakhmMi9HMkRJZEVGdGpaOVZmTHhvNzhnMVM4cXAxVldIRmpN?=
 =?utf-8?B?V3hpQ1ZoVEhjTzg3VXlBT3hGR0t1ZDJWcjdDNC9vdHh0ZWtZcDJlM3ArMU1C?=
 =?utf-8?B?aTkwWDNxR21ienM4Skw1aE9LTGNqMWVUbG9NVWJwbUdGeWpoR0g5RGo1TlNa?=
 =?utf-8?B?U04wWDNUYXB0eUxTS2ZqYXhPNjZBaVA1bVN2ZzZ6MWN2ZlM5bmJlNmNPN3d4?=
 =?utf-8?B?cG9pU3hsOG9NKzJsSlAwYW5MRHY0cjl6RHFuUnUrWTZTdXBQN0xGdEdWQ0Y5?=
 =?utf-8?B?RXVFQzhMYzBpMzZlNFNHUWJDVWtQZFB2N1FxVUFRTDI4dXZzWWJXblE4bzhJ?=
 =?utf-8?B?ZHBmZDY3UHRFTU4vdVNKNFNzVkE5OG1FSkt0WFFmZWxQeXhUeCtVbVZuQVMy?=
 =?utf-8?B?VngyMDhYbTJsZ0p3LzVsaTRRdnNKZCtjbnRFaEZObkNPZEY5RFVMQ2hhckMv?=
 =?utf-8?B?K2JUTjNRdDc2MUNNNi9SNlUyVUhGOFVGOHI4S2xZcDAyYXoySmNZZVh2Zm9m?=
 =?utf-8?B?UCtoZXJDODZxa3B2QUErNTNqalBFWFoyditkVUhJcVVyb1hWaFRNN0lBVWtR?=
 =?utf-8?B?UEx6N0JXUEEzMUZzdnRKRFdZWUp5NUZObmsrTnBtMlg5Q3lBeEJqS1A3TTU5?=
 =?utf-8?B?Q0grdGVIcUpGZWlNeHQ3VENXSDJMNVVUM3hrWklMRTV1Nm5yOURpSTVML09Q?=
 =?utf-8?B?Kzl6V1V6RkRyb3BiVXRaYTNaa0RIUG1wTW04Y2xTVXV5SFI4TElDRmNLbFh5?=
 =?utf-8?B?R1JTSlVsZytVdHVsRTNDY2M1NkFuc2xKNUFGZncrb3B0TFRsUjliQ2djbzkv?=
 =?utf-8?B?MTlCdjJXVWp2ejl5blMyQ0srZFRTVFRka011UDBwV3QyMXQxQVg5YU5mMExP?=
 =?utf-8?B?TzhkZ2RhQlZtU1RKKzBzUGVsekhoOEVsV3hMbDkvSlIxSHBuL2ViMVlidDhS?=
 =?utf-8?B?WUlmRmUxUXlKWlN0WjE0RkU4V1MvSHlRRTZ2U205aU9GSUtSMG9OK3Fvd0JZ?=
 =?utf-8?B?TzF6WmJ1ZFhid1JFM05NMVRlVy9XYURjMENidWpLTTlQanhlN1kvQnlLV05a?=
 =?utf-8?B?UmM3SVB1MWZaQmluSjhWckpMeTJsQ2h0K1MyZWNLM081d05Ub25KNGNFSitQ?=
 =?utf-8?B?ejJBVnFBRFVNTE8xaDFHcVNWb3JNU05OSXBWMVdYSVhqRzVRNENIL1NocHBl?=
 =?utf-8?B?eDU2WnoxYThpMTEySFNZc1YrVTQ0L1JzZnZZSzVJWVdFU0V3MWdoUmpxZkhv?=
 =?utf-8?B?VG9Sbi84SVJ1d0FjQ0M1aE9JOGMwRW91SW90Q21TNENoZWQrZUl1N1BZMHVE?=
 =?utf-8?B?WWJhcTQ3TjNVbHdYTk5pSGY3MWRRUFY3cVhTU3ZBUDZmbmgwQkVDVGljNUEy?=
 =?utf-8?B?U254MTBqQjVkOXpoVzh4MjUyb29hTU1KNll3WU9CZEpxM3JNMUFuYjFRNGVk?=
 =?utf-8?B?YVBNVXBqNDhtL2RVKzFEK3h3UytTRU9rYTdxSDhvdUtHUi9ZYkZmQldoMFEx?=
 =?utf-8?B?TVBOdUtXSG80TmFXNVIxVmYwK1ppSHVFR2xGU2RaekdueUIybk1CWjV3cjM4?=
 =?utf-8?B?b2MyMkRySkd5Qm5CRmN1YVJhYklXcm1LaTRTNFFheUk1bUlvWnArSFErS2U4?=
 =?utf-8?B?dVRlYW93Q3dTaXRrL1dqUldHdnV0OGJDUk9PYkF2K2hCTVcvRGF3eUFIUVZH?=
 =?utf-8?B?cDVnczg4THFYNk40NUxaUlAwdnErSnNQVW5heUtJU3dQbVF2VktFSEl5UXlF?=
 =?utf-8?B?cHd6Yks0dWlsbEg0eUptZW1CemdTQ2R4SFp1MGhEcEdmMjluM2M3N2V0bFd6?=
 =?utf-8?B?RXlrcDhQQThoNm9aMjl2aVRBbmZJaDVKcWNxTC9nVHdSdHArRjU1YkxDU3NI?=
 =?utf-8?B?cWZFMEhDa1lyZEZFV3pzeXI1ZFNydGxsaXNtUDZVNmtldmY3ZFZidmh0NXVQ?=
 =?utf-8?B?NFNaanR1Z0tkSDkyaVhEa3AvT05MNkErWlpDLzBkQ2pYTkVON3BLSGhEOFNi?=
 =?utf-8?B?SXlpVjc3bkVtbldkN3d3cTE0SVpzL0JnZWtvMU9DazdBZ1crTzJoMkdTa2M1?=
 =?utf-8?B?MEt1RENmdHpFbXNMbDZ0NE5HRkpxV1lhL0RzT1hseWNIQUEwc3JzREYrOTVT?=
 =?utf-8?B?NWc4TFR4VUd1aUVDdkVmcWlhUVphUmtUaHpOL2J6dExyaWphTUltU0EwcW4z?=
 =?utf-8?Q?IiTyAjc7FA6PjHKu7f14EnU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	abN+JsxGEbZRN5B/xD9qF3LXpEwHJvte71315VAPaL16uK2lbLJGyM5sqCHHm7P/PAUvREsJVaZ/cjabZNLymhDhHVrEqdMVF1tHC+QUAaPUhOS3fiH4sB7gUYeLPQkCRtccwfptxCTWK9KF/H4RgEb2HMfkyPUIMzzZ9KQbNPZmgKlkBETtQikvRaNpLVjmTKegQnb1nDs9FaYd7qINRJnVeCX0jmMdaXZTSZ1Izb0XI4BeTBAn2UvxdBOUQwxpdIrPxSQq5UL4UakEodC17IQ+tWKBbpLT1UNYfvUwnVaVIkvI1ZeROTAnl/3fh4h4GpgqAlVRcZE265SiROuqVIK7rR1Sg00dqarjhsgYP3hBOsRBKWlld9+0QMaRakpTgFd1VeV1M1J/yRlVF6cYt8s0LSOgsSxPy24j744/me7rY9uhtkMsTqMQGPx9U+QFBpXw5X0L6ylT5B21OUt6BmAlQH74gMIw0QBbyDJr8lw2/P0pA26IBzWHqbdhMg2c9k2FjWIn9eA9lFrlqgz4iG0l/wxBH0BxVvKA3iGyIbPcExaP0IYX4+RHzg9sJriAD08MIOb+/BdUb9m4uMclEX/EZ3ttucJlhNVd0AP715w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c89e8c08-e043-4c48-3d22-08dca6a14b05
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB6379.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 20:44:45.9433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9X+OEDFAtAu+6yrlaCn4n5Yj3N2Bi2h5f/QNjmz+Waqv2wyZO23Ghpoy3oExH4xjupXoZYao7Zsdl22OQFVY3iTdKzZ2Q7xzxB9czpLFMOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6091
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-17_15,2024-07-17_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407170157
X-Proofpoint-ORIG-GUID: KpGCrAAuYyGuaZh4k1kQuyzcTbDYsREW
X-Proofpoint-GUID: KpGCrAAuYyGuaZh4k1kQuyzcTbDYsREW



On 7/17/24 11:50 AM, Steven Rostedt wrote:
> On Tue, 21 May 2024 14:37:30 -0700
> Jianfeng Wang <jianfeng.w.wang@oracle.com> wrote:
> 
>> Add two internal options for fgraph: fgraph:retval-skip and
>> fgraph:retval-hex. By default, trace-cmd will print each function's
>> return value at the function_graph exit point, if the kernel supports
>> the fgraph-retval feature. If users want to skip the output of
>> functions' return values, then set fgraph:retval-skip. Alternatively,
>> users can set fgraph:retval-hex to force the return values to be
>> printed in hex format.
>>
>> Here are example commands:
>>> trace-cmd report -O fgraph:retval-skip
>>> trace-cmd report -O fgraph:retval-hex  
> 
> I would like to see a -O fgraph:retval-dec
> 
> As by default most is shown in hex, having an option to do that would
> be great.
> 
> -- Steve
> 
> 

Hi Steve,

Sorry, I am confused about this.

Do you suggesting adding one more option fgraph:retval-dec or
replacing fgraph:retval-hex with fgraph:retval-dec (and making the hex
format as the default)?

Currently, the patch prints return values in decimal by default
(without any input), while users can specify fgraph:retval-hex to let
numbers printed in hex.

Thanks for your comments.

Best,
-Jianfeng

>>
>> Signed-off-by: Jianfeng Wang <jianfeng.w.wang@oracle.com>
>> ---
>>  lib/trace-cmd/trace-ftrace.c | 22 ++++++++++++++++++----
>>  1 file changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
>> index 2b4e49a5..d2378833 100644
>> --- a/lib/trace-cmd/trace-ftrace.c
>> +++ b/lib/trace-cmd/trace-ftrace.c
>> @@ -26,6 +26,18 @@ struct tep_plugin_option trace_ftrace_options[] = {
>>  		.description =
>>  		"Show the depth of each entry",
>>  	},
>> +	{
>> +		.name = "retval-skip",
>> +		.plugin_alias = "fgraph",
>> +		.description =
>> +		"Skip printing function retval in function graph",
>> +	},
>> +	{
>> +		.name = "retval-hex",
>> +		.plugin_alias = "fgraph",
>> +		.description =
>> +		"Print function retval in hex at function exit in function graph",
>> +	},
>>  	{
>>  		.name = NULL,
>>  	}
>> @@ -33,6 +45,8 @@ struct tep_plugin_option trace_ftrace_options[] = {
>>  
>>  static struct tep_plugin_option *fgraph_tail = &trace_ftrace_options[0];
>>  static struct tep_plugin_option *fgraph_depth = &trace_ftrace_options[1];
>> +static struct tep_plugin_option *fgraph_retval_skip = &trace_ftrace_options[2];
>> +static struct tep_plugin_option *fgraph_retval_hex = &trace_ftrace_options[3];
>>  
>>  static int find_ret_event(struct tracecmd_ftrace *finfo, struct tep_handle *pevent)
>>  {
>> @@ -235,8 +249,8 @@ print_graph_entry_leaf(struct trace_seq *s,
>>  		ret = trace_seq_printf(s, " (%lld)", depth);
>>  
>>  	/* Return Value */
>> -	if (ret && fgraph_retval_supported) {
>> -		if (!IS_LINUX_ERR_VALUE(retval))
>> +	if (ret && fgraph_retval_supported && !fgraph_retval_skip->set) {
>> +		if (fgraph_retval_hex->set || !IS_LINUX_ERR_VALUE(retval))
>>  			ret = trace_seq_printf(s, " (ret=0x%llx)", retval);
>>  		else
>>  			ret = trace_seq_printf(s, " (ret=%lld)", retval);
>> @@ -385,8 +399,8 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
>>  		trace_seq_printf(s, " (%lld)", depth);
>>  
>>  	/* Return Value */
>> -	if (fgraph_retval_supported) {
>> -		if (!IS_LINUX_ERR_VALUE(retval))
>> +	if (fgraph_retval_supported && !fgraph_retval_skip->set) {
>> +		if (fgraph_retval_hex->set || !IS_LINUX_ERR_VALUE(retval))
>>  			trace_seq_printf(s, " (ret=0x%llx)", retval);
>>  		else
>>  			trace_seq_printf(s, " (ret=%lld)", retval);
> 
