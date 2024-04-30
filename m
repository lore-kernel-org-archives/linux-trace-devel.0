Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EEDCA6F
	for <linux-trace-devel@vger.kernel.org>; Tue, 30 Apr 2024 22:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714517171; cv=fail; b=MT+NcjUA8CpDYpe0/BScjX8ixTNkWFmGxWccY0ZPQp0LU4AA1nu85vb9jTQHD1K/FWHmisyx4qOgYfeSUc5X/VXeYKU1bdBUi1yE0ef8mAu9b0y3cR0CUyLw8d5EQjGU+UvT7isHbzbII+nuiSFwPjJP7cnJsoYCor19FX9s3ME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714517171; c=relaxed/simple;
	bh=deXNMDvuOyn+tlF8lLHiFmww43SL2LZKwj+3eJ4Isq4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j93nLOXXLHu2wEXPw9zobyuIIrH9pPSTVqxKBtjdWdJm+fgRDeZ+1DrRicnfsP0u2KVb5morYVtNnU7b08yrmiWgMuDxc0aFmZeMRt3Mnh2ZK8rdKFfLpHEG+OCDHk4cacxJ6KyEUsbOQkO3qNARe/cHJO5eBqRvO/NxywsjVBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mUXVGuOG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tk50y1BW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mUXVGuOG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tk50y1BW"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UKU0nK017761;
	Tue, 30 Apr 2024 22:46:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=dZQy4nOiGzINkri66aBWaqSIr2nS1asHz/VRWZb/1vk=;
 b=mUXVGuOGBxp9ninSsMUYVRl0AiKgienJ8RIZ4qAIXWFFT30q6h/7UIUVTs+UsACN5f0l
 MF4SR7qGd13M0zh5ZYq8zp1WN4PP1NmAdMbVrLxB5KJJZpg0y1Y6TWbj/0+nqE7OmNbJ
 j7gxzvv0UaPn/ZhZvKBby6XEx1OB7lamGm6DwJdaPOpn2nHOgW5fasDY2nFmiuCnPZrZ
 fmbrd/yTCXOcyfMbsmCwsdw+zJBxtQ2HGPqNmXCkG8JhIc7qGhjkyteoYnloQPWJp0Cy
 YVsU8aJg9hra6270vn3axa2hb6GwJgdX8Zlxj4g/hNDxRlT53hF/ikqu+a6OpmfX6Kj2 NQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrswvpa6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 22:46:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43ULMHji033267;
	Tue, 30 Apr 2024 22:46:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt8ddhx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 22:46:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DC0mCFEyfDNIYEpMUJUL5Kn12/UGbHjdgMMlhMGYrQvqq37+iG7533zZ3UMot+aQZ4ZiZwBQXDwsUBbue2RzrJt6kTu4auBcuumnmWLUqtphdxWCtY9I+WxVhapJYlPzV4nhlgTumAEWbomeNctb14O46LnI7sAtT2CepZezjTkN543snvhdqUSDDYdtZelKExa2cP2qV1JikbN6cfECCFMn2l3V2FtlYKYp8iMlvcALUosTsj0hNei7ZXxsfzu8ZnXCD2IbgMIsQlPZ5M3WyT+0uzocHFVkdP5w3Ij39VrP+wfp4xvkgLy9hw8OHxFhctLsWKRoVW/m4unaRhqVsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dZQy4nOiGzINkri66aBWaqSIr2nS1asHz/VRWZb/1vk=;
 b=MS4lTO+YnmEEaJzYPFNjoU2MhvXajOHUP1YAzMMflLCcXgZ12jQdsGJkmlKrOrEQ+QEjxdtH//lzCs7QBNlB3QCd55i3QyRVYEVw2/YhbPc5TYV3qnhCmoe3wuE8p6ZTJlXAvvnBK4WpcjDIQqEmqChNYIXtCZyAkjmhO+kIpSJMTHOysElE38gynpPWNGMM5W+ac6jbkzpF+Xp5dpya6Lug+GPOhML58XmDJsTwl0wHBsiOo9OR28fdLYADZm10dP2kWGjXsdt4KEyWxN8UXh/C0R/Fe5eVQAi9HSSpqF77cGBecuaXoEkXG4JTlI91C9Hlwt8svkkGEC9WznMAVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZQy4nOiGzINkri66aBWaqSIr2nS1asHz/VRWZb/1vk=;
 b=tk50y1BWXrU9gGfX/3PUh+SUWe8Jlyxg8+gbc1HSo7NY2a6Dp7BFDX3ELBJx/kh7icT8EEDs9cp3aB8Xqbz1g7RgRqfA7yBKoVyVY3uihg2DpsD8jhJaC8TThwTzoSSRlIcsi1kU6QRk+2nA98LNTB/a6sCky7LVpeT9ldPzeXw=
Received: from SN7PR10MB6382.namprd10.prod.outlook.com (2603:10b6:806:26e::20)
 by MW5PR10MB5806.namprd10.prod.outlook.com (2603:10b6:303:193::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Tue, 30 Apr
 2024 22:46:01 +0000
Received: from SN7PR10MB6382.namprd10.prod.outlook.com
 ([fe80::8d0a:d43b:a278:b0ce]) by SN7PR10MB6382.namprd10.prod.outlook.com
 ([fe80::8d0a:d43b:a278:b0ce%5]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 22:46:01 +0000
Message-ID: <dc8a27e0-ce39-42b0-ad44-dc6f64005921@oracle.com>
Date: Tue, 30 Apr 2024 15:45:43 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] trace-cmd: Add ftrace options with fgraph retval
 option
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org
References: <20240415154921.4998-1-jianfeng.w.wang@oracle.com>
 <20240415154921.4998-3-jianfeng.w.wang@oracle.com>
Content-Language: en-US
From: Jianfeng Wang <jianfeng.w.wang@oracle.com>
In-Reply-To: <20240415154921.4998-3-jianfeng.w.wang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0161.namprd03.prod.outlook.com
 (2603:10b6:a03:338::16) To SN7PR10MB6382.namprd10.prod.outlook.com
 (2603:10b6:806:26e::20)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR10MB6382:EE_|MW5PR10MB5806:EE_
X-MS-Office365-Filtering-Correlation-Id: 87385809-8c7e-4a28-c155-08dc69674f4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?M1EyWjhSS0dvaTNqK3JEVkg5NFZBNi9ueTNKd0NCMmJMNG9FejNMUVlIcTV6?=
 =?utf-8?B?dkRtS0xHVVBrc3M4Tmgzamt4dElTZ29PK0Q5cXMrcFJxY2pQTFhVTHdqMm03?=
 =?utf-8?B?MmNaZkliS2E5bk1GVU54TTNTWnJKb2RCdHpSUjlhaTFPZ25lWkp0VzJLN0E4?=
 =?utf-8?B?T2wvVnJHbmxpQVI0VGpaamkwdDZ6bzlJRlhoQzlWUDNicHRlSG90THJDODJD?=
 =?utf-8?B?N0dEelY5UFV4eW5uTzN2WW03UGpZaDZ4RUhMdEtCTTk0NDhDWWN5c21tVXpF?=
 =?utf-8?B?L1lSc0I5ZHdGYW53YUgwQzlUNjV4SmwvdFdscHlvSzlFVk5OMWRCdkZnV2Ft?=
 =?utf-8?B?ZWJIYWxvUURWa2FIdDUvMy9JQWp1dUNSNUt5cEE5N1ZvN2dhQUFsNkcwUTFH?=
 =?utf-8?B?Q05ZWUQ5QmUrZ3RRT0JvN1lleDIzVUtBQys5WGJhZGx2Y2FpNlVjWkNRK0tE?=
 =?utf-8?B?b3BqbDZnQm9aQURkWjZ5T1NUVndoRStKU1hYQnd4Y2xKNk0vQ1FTeFBhT05T?=
 =?utf-8?B?NGpMc01hdzloSzRrTS9yRDZrMWZUakxaRE05bHJMVnBjSXZSV1hQdkkyUENq?=
 =?utf-8?B?a0xhOXZoV2RRaFBBZTF4czBpNmFuTCtKZHdHR3JuQ3Q3UTZDVEpVbHBZUG9v?=
 =?utf-8?B?dFpSWVZ5cWZhYnYwN3REWTgxZWp5NUpsUG8zcExhNXRhQldkcEZ1MXJiSGlD?=
 =?utf-8?B?UWxZMVg1RElrRXVkcWVSbFplUlFEYk9CYUxhcG9OL2pobXlIOFQ1UTZzczRp?=
 =?utf-8?B?T3lMSlYzZzJhWmpoMHViQjdhcGRDNGQ3cGgwdy96eGJZRDg2ekYyQVFzTWJZ?=
 =?utf-8?B?NjN0c1VwWlk3Y0FXWk9ZUTgzbFJHS2U1Z3JTTTh0MHhvY29FUHhjYURmOERY?=
 =?utf-8?B?eXgzdlVCa09lRFgrb0pmMlhCbVRxQ2RkRW1xNTh2aDlNOWxDd2MzemMvbVp0?=
 =?utf-8?B?THZvV3Y0dFk3RFFJOHhDMjBJckdSVzNYREN6eTg4VmhyUG5IMThtdTNyYlZL?=
 =?utf-8?B?UC9JRzNkUnF0UTB4Y2xGQUJ4VG5vUTZxTFkxb0RKa1gralNtYndtWWUrRnZa?=
 =?utf-8?B?K1pGVHhLRHA0Y2ZTWDYzcGNmWjRQUHZhRzN6UEtGZnNaYjVQSXhSMlltVDEy?=
 =?utf-8?B?RnNncllDRWRxRnVjRTU0Y2pEb3NEbFptdVRBczlYd1VkZ2hUQTErYmFNYlZ0?=
 =?utf-8?B?YVhyYmhxU25xTEZHMEJhZzFjQTNBOWlTUjVzSnd6bEl0c2ZJTGhLVzE5NjlJ?=
 =?utf-8?B?eC90UmZMYm9hZzVPTDIya3dvUmpTTFZabFNxS2UwVlRSYVB4VDJOdDVZK2V3?=
 =?utf-8?B?OUtManBMaWx4U1ZWVkZnQVJpZitHcGZtTWF3aytEb1QxbGlPR2VDVjhLaU1M?=
 =?utf-8?B?SGJpZHdJOGJrNFkxWkxIN0xJYUFSM0pqY0VTVitNMStKREJ4aGtWVnRDd3FG?=
 =?utf-8?B?bVlxekcxTGMvRkxGVGxTMTZXVWI3YmQ4MzB1L0U0cTU5NzJHRU1KdzVpTUlt?=
 =?utf-8?B?elNJdzJiUkJjVG5qUm1FZmxJczRHclhTcnhRQVowZlVUUDB4Wk43K2NVRVR2?=
 =?utf-8?B?c1NmRDE3UUpGb0NmUG12NlM3RGxST1hWOC84OVhlTFc3aGQrNTBmZm1EdjZM?=
 =?utf-8?B?Q0cySFpUTTdiSEljR2NBNFVRNFlVRFl4ZWdBbm9XemZ1TzNRWlBtRXNKNm5y?=
 =?utf-8?B?UFJQbTVvMGpsU0MxZ3pWcmZXRmVxTytCb1UyVmlqeHJpdkluL3d4MTVRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR10MB6382.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZVJScUsya3JXYzljMGN3V29iRzFYL043NCtXcm5QTUNROEcwUlBBZXA0ZGY5?=
 =?utf-8?B?UjI5eWpYRVdhZUR5cE5ST0ViaVB3SjlyalEvYXJ3VmJ1akMyOVhlT3FFNnZy?=
 =?utf-8?B?S2swZ0NkSExSdGdSSk5ORkd3cm5XbGZVZmNxRlFjZ1FZY0cxZFVGTml5dXdC?=
 =?utf-8?B?WmZQVVlZYzIzcUlFRy9BbWVVRUVhOWUyN0JxN0VEZmFRYmY1cGhFSStVS3dG?=
 =?utf-8?B?cE1CMXRSUDc3MHhVbFV2YmZXS3plVFhqNTZObTVpQ2lXZUc0NXl2cDNlZXV6?=
 =?utf-8?B?QnhPZkdaWVAralR3c08vaWcxdWZXVDVJOEJSTWRTT05VaEZnb0xBQ01UTytX?=
 =?utf-8?B?YzZSSzhlUmdib3pzbExvbGkvRW9SaXBYOUlpTGFjbmJyQWFOaGZwcnFsYWEw?=
 =?utf-8?B?dTR3eEFkdjFodk9vVGtCaU9RK005NVk5Mnd0WXlwbjlyb0dVUFNVWWJiZ21z?=
 =?utf-8?B?Z3VLaXNGaTg5ZmRrUjAzMDVreUhEQVRIclREQks2dFhsbUdrLy8zdDR2ejFT?=
 =?utf-8?B?dzMxazVwdGRMUjlsWS94bnpEaGJ1UitpYlo0SjBUVTRwYUJDcmZhNVpyWGNG?=
 =?utf-8?B?UXVqZXpiaHRDaVY2UXlPNXllMGlONm9nMmJHQmhqTGJ1bkkyRXUwMmErejVS?=
 =?utf-8?B?dEdQaVg5aUVUWUV5MGVYZ3lldTZoTks0cVg5VW1TTmJKUkhVSnQwN0lKMVNx?=
 =?utf-8?B?bWlmTlZrWlNNdFdlTFMvUEEyZm9jU0Q4bmprbnFaNHU0bFNnVWNCQzErVkVp?=
 =?utf-8?B?ZERKQTRwSTIwd2krL2szaGFtc2Fybm5PTlFRNEpwb0ZBMVVpQUQ2QUhIS01F?=
 =?utf-8?B?VjhoeXFCOWRRS25ySTlnVnRwQ28rTERxYkhJb0JCeHgzRFl4ZUNZSUtKL3E0?=
 =?utf-8?B?MFUzMDZSSEgvcWlDWU11TUJiMzFvMEJyM2lrUjVnNU1YdGJ6a29SbHM0VXFn?=
 =?utf-8?B?Yy90bldYenljTUNvVHZBZDQwbDRRMnBtdWZnZEVqNTY2c2xwS0dadzBnNG0y?=
 =?utf-8?B?allNaWlmRTBTZzhGQVA0bVdRUUQxblhwSWZBdjNlckZkbVdVM0dubEswbWZH?=
 =?utf-8?B?Q2R4Q1RDcm1LYVozQUdGTG0xclh3SW94MzhaaDdMNEQveTdabVRMaitreXF0?=
 =?utf-8?B?Qld5dHJNUkI5bWZlUCtrQjhvZG1kNjZycnRiRmdyQjNOQms0MTJVbmlXWDJw?=
 =?utf-8?B?UXViZWFIKzVnb040YllBUmNaNWMrUnV4RC9hVEpiVzZMSXQ2Tmp2enF6ZFFG?=
 =?utf-8?B?SkZnazBQWE1RYk5uY2g4VTNBRE9rOTNGZmhIWTZrU2Z2d0IvOGdHWHllT3lk?=
 =?utf-8?B?Q1NzY3dNYm1QYmhJeVNQT1V2dFZyWE9JakJFOFRVRVRnbDdiU1ZSLzhrZGVT?=
 =?utf-8?B?UjduVTlQT1QybzJkb3V0aE9GLyt2eGRodEFVY25ycFpNNUpXZXZwL1BPWjhj?=
 =?utf-8?B?dWFzNmUzd0x5bFpLSWFha3hXV2pwTS9WNlFFcExrYmZMaGtRbTZlMGhEV2Fl?=
 =?utf-8?B?Sm1wQ2Z6NU54TlVGWUp6WWtaVzJjejk2VVFMRWlwTUxBb1U4alhNYWlCOFhC?=
 =?utf-8?B?dEdLQ0lEaVozNnJDWm01eEpiT0MrL052Z0NLbEZmTmFZUzdhWGdSZlg4MzFT?=
 =?utf-8?B?eHNyL29NRGlpeE14QkNsUnZTMk1seGRvU21JK0dXUUxrb1pXRndLQjA0b29p?=
 =?utf-8?B?Q0JwZXdnQ00rNG9mNUhLTW5DMHhEUFZFS01LemJnNnVFNEJYdHg2TTVGcUN3?=
 =?utf-8?B?ZWxDOUFNMG5PcEZ5TFJxZUJIU2VXUWp0SmhtaCtuaUZNcnVGc0ZEalI0N1Z6?=
 =?utf-8?B?WlpCdE5naHBESExTY2RVdjc2WDFLRFNuS0NjWEVCRDJGbnFYYjJocnV3dWkr?=
 =?utf-8?B?dzdVSzN5cDltQnFQYTh3RVhVaEZxWXQ2NDhld0lQTEo2N0VoVXI3aEU2Ykd4?=
 =?utf-8?B?cCtpYlFsaFl5NUVTcXdpK0t4aXV3RVVOSlZPdVRiTTgrQXpoYW1CRXVnTW9N?=
 =?utf-8?B?ZTlJaloyZ0M2T2E2aGo3MnBMemk5Vkp5WERtVE5qZm5yVGpaYkRRc0ZqTkRL?=
 =?utf-8?B?SnJSR0c0eThYNmRVQWVFVGhlS1dOck1vQlk0TnFuL2F4MUZLRHJ6ZEZWRG1H?=
 =?utf-8?B?a3gzT1VIekdtVEk5R2dhWmNtQUYrZWtMeXZ3QURXSHM4cHpnR0U2bVhDZW90?=
 =?utf-8?B?QVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	lANRa2Pz+8qzKEjvQWlFi6Yhebp+BuziP/G74MrdL19MwLv/ensvQLH7MYRvsQx4zliGi5TbhKWBKVfE5gW8FtdshILaW4RkK+oqZGD2qitnjLfO9cMXlw7vXcoelEEXyoxdSgULLMDOFahB/Y55TmnHR+9Ikx9QZTKIMrhpfHZFpz7/i+u/AMMWAlxlTvWxp6dAQ2Z5lUeS1mpqsxQneQ/xv+3JOvrPMozpIFU+AFU+RO77QvHIcmupdZIRkjXGbpWNP5HVNrbf8+mf2hKlTbfLNKmEtvPYDTeNX/X7cIF6F50qM+1Wp1M1rL35SoNseI08QNkGvsRf0jkkvdlEVQV1JNAR76XFzhG7x2tEVB2jCxjlmE62Dl+374g6j5ekockE+XkPvipDv2rp/yl1+dh5uJrHiIQ+lZYxPrDF1dBqa+NZOxiP+5TiJgCo6RBVYJi+7BY9YuN9d/dZhM7+maHTUWPYui3gO68E7aZCT5KiRy/r1Zl+C3MShDmoooUSXMa0NZATdNtmKYv2zda8XR5VPYSAJ7xShUUObb1dPexcwxFeseQGJB1+d6vFBfk0D5kuuzdof1HZzvOJ0kJtKd7CkTQCxn+kvuO6N6d2MmY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87385809-8c7e-4a28-c155-08dc69674f4a
X-MS-Exchange-CrossTenant-AuthSource: SN7PR10MB6382.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 22:46:01.4175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OXd0fjiVUL3Cob84IRQQ0jZkTBEPesLDRejlYyhbcQod6w3AFW+Ang4BNtUyren1c9IORLTzuPtPT//SIFDIEUgfRzX3EoYwENcgg5l5LEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_14,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404300160
X-Proofpoint-GUID: oP1ni3FhQA1l5GcCqGAhN6OlnZPCbUv2
X-Proofpoint-ORIG-GUID: oP1ni3FhQA1l5GcCqGAhN6OlnZPCbUv2


On 4/15/24 8:49 AM, Jianfeng Wang wrote:
> Added internal options for ftrace, and included a fgraph:retval
> option that will print the function names at the function exit.
> When the option is set and the function_graph retval feature is
> supported by the kernel, each function's return value will be
> printed as '(ret=retval)'.
> 
> Signed-off-by: Jianfeng Wang <jianfeng.w.wang@oracle.com>
> ---
>  lib/trace-cmd/trace-ftrace.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
> index cb05d88c..fecc3d69 100644
> --- a/lib/trace-cmd/trace-ftrace.c
> +++ b/lib/trace-cmd/trace-ftrace.c
> @@ -23,6 +23,12 @@ struct tep_plugin_option trace_ftrace_options[] = {
>  		.description =
>  		"Show the depth of each entry",
>  	},
> +	{
> +		.name = "retval",
> +		.plugin_alias = "fgraph",
> +		.description =
> +		"Print function retval at function exit in function graph",
> +	},
>  	{
>  		.name = NULL,
>  	}
> @@ -30,6 +36,7 @@ struct tep_plugin_option trace_ftrace_options[] = {
>  
>  static struct tep_plugin_option *fgraph_tail = &trace_ftrace_options[0];
>  static struct tep_plugin_option *fgraph_depth = &trace_ftrace_options[1];
> +static struct tep_plugin_option *fgraph_retval = &trace_ftrace_options[2];
>  
>  static int find_ret_event(struct tracecmd_ftrace *finfo, struct tep_handle *pevent)
>  {
> @@ -232,7 +239,7 @@ print_graph_entry_leaf(struct trace_seq *s,
>  		ret = trace_seq_printf(s, " (%lld)", depth);
>  
>  	/* Return Value */
> -	if (ret && fgraph_retval_supported)
> +	if (ret && fgraph_retval->set && fgraph_retval_supported)
>  		ret = trace_seq_printf(s, " (ret=%lld)", retval);
>  
>  	return ret;
> @@ -378,7 +385,7 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
>  		trace_seq_printf(s, " (%lld)", depth);
>  
>  	/* Return Value */
> -	if (fgraph_retval_supported)
> +	if (fgraph_retval->set && fgraph_retval_supported)
>  		trace_seq_printf(s, " (ret=%lld)", retval);
>  
>  	return 0;

Kindly ask for reviews on this patchset :)

Here, I include a more detailed effect of this patchset.

* Record process
The trace-cmd record process is not changed.

# trace-cmd record -p function_graph -P 4331

trace-cmd can communicate with the kernel to get the actual funcgraph_exit
event format. If the kernel supports ftrace-retval, then trace-cmd will
use the updated event format that has "retval" field.

* Report process
By default, trace-cmd won't print each function's retval.

# trace-cmd report

However, if one wants to turn it on and the kernel supports the feature,
do the following (through fgraph plugin options):

# trace-cmd report -O fgraph:depth -O fgraph:tailprint -O fgraph:retval

The output looks like this:

  <idle>-0     [012] d....   361.071503: funcgraph_entry:                   |  switch_mm_irqs_off() { (0)
  <idle>-0     [012] d....   361.071507: funcgraph_entry:        0.491 us   |    load_new_mm_cr3(); (1) (ret=0)
  <idle>-0     [012] d....   361.071508: funcgraph_entry:        0.251 us   |    switch_ldt(); (1) (ret=0)
  <idle>-0     [012] d....   361.071508: funcgraph_exit:         5.901 us   |  } /* switch_mm_irqs_off */ (0) (ret=0)

Each function's return value will be printed at the function's return point.
