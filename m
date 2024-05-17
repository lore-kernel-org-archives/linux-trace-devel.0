Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB56313DDCD
	for <linux-trace-devel@vger.kernel.org>; Fri, 17 May 2024 18:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715971841; cv=fail; b=K+/NDQDrt5H8K9dNA7KggHlvoRK1AJdoZ+XDheD6z7yosU9hlQPRFE0B9nqHB/9GfwTyuYm47rYLNlWd0GSKKYlXWOnv+rKSLXwLMqlZssiPhOnd6vklxBqiJPi+gwzwK/ReN4o7fSCTOmXRDYHO9cKXfdcjaN51vx9/qfHdAdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715971841; c=relaxed/simple;
	bh=28FHPXc0HaxUh7xaWek/MgF9mgkLP3RpmH8C1cfD0zQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=siDUOAKNBYdz6NB+p2CCR/zCGgqNh/7VVdTzcm1LUR0LPJ+RTq9E2Acf//XH/tyXWqn+1CPvAbH0H3IlLKSn8ujqrepLJu8U21JZziI/1mrYo8h+E7diWnTexW6vEFlFus9Aj0LzMsTkm5yBLodOR4Llrop9mALSb0KfRvwmEtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IZqr16x8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jDP/X915; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IZqr16x8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jDP/X915"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44HGdgOk015331;
	Fri, 17 May 2024 18:50:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=hJxabF/OZ8x0/E93wZjROSH9RAnysE42tFPrutZ4W5A=;
 b=IZqr16x8mT2fZ7MttlSqOw2n1uTGZmVSn78nU9lmRTGvixQzeCiyjjgfhjhFMvfS1m+7
 Un87U9RVdSK2K5JnmFuaeO8BBmw2dDkxeVYrnmbzyPJo4/PvGDTT0fcDNjkg3ExErYvf
 WbRSCJd7c0pJl7n93oRBJe+3PChBvL+F5o10vjCyUhUEnRrzdd99/aT4UP1T/8XiZlx0
 NMg3vfYluQLm+vB/QGtXXuU8H2ZD/Ak1akwHgtKg6zFQWjeljfZ1NsMKj27yLs5IJfes
 qcKEb0Zh/SEyrINHKzT1GeELl7+Ic81OxPKlal6IgOwiHxSrDCr6e9ISNhdgllwbVgJc dw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y3tx3a8d5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 May 2024 18:50:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44HIO2HN018747;
	Fri, 17 May 2024 18:50:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y1y4cdgck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 May 2024 18:50:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GAuH6/8Jz7bc67E9qn9kVbNSPhaoVzsnBrd3DUJjoYLiolm5D9IuWwzAQOtB4ihYxkb5y6oALqM5Pfywz4FcHvDSB6hcbohydOUSAeXRc8iLuySGs526o8VlqsFdZUSTDLDecv4WnqlL6q/R4QR9mlQ9kf/LZCTybqh9eUXcZdtE3BGFmxdm0V2m5XYXKno2pu4mZm58IEeTY8nK+AMgyWsneZKM+vEo+wGqO3eROwYiE2haLa0ai+Mk1L0Ka8FmUlcOca8bmvsnqmK2hkNlsNRW4tjD35FrzY9aeU9A8IjxRtgZX/BFkqJ0BCwSeBxBA8sWe7YzpK9Y54lSmX+r5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJxabF/OZ8x0/E93wZjROSH9RAnysE42tFPrutZ4W5A=;
 b=VIeNAvj+4E15EP8iwtaCuib7ni63aJgOcBuo4ZqcZfZelVHICjrR03t+RVOgcZ+Dp0NIKxWvr9dFd+ho8SvQA6E6q7X4DRDGM4eHYZ4hDtdYeZHcvpWMU/Ycy7aDZQS2Vt42t8kqijKGU6CsOH8qg7911iFLC71rh+r3atyZnJbAv+zEdNx7U4356ovDyjxykioWcuGzoumLHo+0w2jR9JdUF/Nw+pMN7qHHsw8nNLrMo6GZOcv+NmtEJsT0Lpnj8LRxwQ6WjuzLYq8XeqZkDJgsTRCYF0JjLLDT2NSNTw1lgutd4s1T6DA/62e+xXCR9CfCMe16EdghW/WuSAlF8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJxabF/OZ8x0/E93wZjROSH9RAnysE42tFPrutZ4W5A=;
 b=jDP/X915aWplBXshmHrS7sz76fjRTzabLCthbUKpyp1TzM1bCnqZczaSjvk+sV9jD2IBIDwk6IQuJ8n4JUxxBxK2FuziqzLATkfUGJvTiGbz5zXNWbLEY/ivT9DRb15FPclXKS8KnnsPd2x4sf/v+Xfi+OxB2jzI/VAd0nryyXI=
Received: from PH7PR10MB6379.namprd10.prod.outlook.com (2603:10b6:510:1a9::15)
 by PH7PR10MB5724.namprd10.prod.outlook.com (2603:10b6:510:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.30; Fri, 17 May
 2024 18:50:34 +0000
Received: from PH7PR10MB6379.namprd10.prod.outlook.com
 ([fe80::c7da:13dd:aa4a:925b]) by PH7PR10MB6379.namprd10.prod.outlook.com
 ([fe80::c7da:13dd:aa4a:925b%2]) with mapi id 15.20.7544.052; Fri, 17 May 2024
 18:50:32 +0000
Message-ID: <a40c7f16-d3fd-4a30-987c-7a7d418ea5f3@oracle.com>
Date: Fri, 17 May 2024 11:50:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] trace-cmd: Add ftrace options with fgraph retval
 option
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20240415154921.4998-1-jianfeng.w.wang@oracle.com>
 <20240415154921.4998-3-jianfeng.w.wang@oracle.com>
 <20240516205302.0cf9640d@rorschach.local.home>
Content-Language: en-US
From: Jianfeng Wang <jianfeng.w.wang@oracle.com>
In-Reply-To: <20240516205302.0cf9640d@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0054.prod.exchangelabs.com
 (2603:10b6:208:25::31) To PH7PR10MB6379.namprd10.prod.outlook.com
 (2603:10b6:510:1a9::15)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6379:EE_|PH7PR10MB5724:EE_
X-MS-Office365-Filtering-Correlation-Id: a7c0bb09-d4c6-4c55-9149-08dc76a23a9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?RFBQTXdSRDExdU1vZFJsYmpIZXUwa0dyTXJNdmJ3akxnTjg1Um1xWGNYbXQ4?=
 =?utf-8?B?dGYydTdsN2x1cVhJVGxsdUZ1RGlJYldqLzdCb2U2REJwbThUa2xwQ2pwcWlu?=
 =?utf-8?B?bTFZellCdmFzbG9hYlczMnQyNGd4QllpeVdYVEZoTnlwTlA2bWhIZjhUakVT?=
 =?utf-8?B?YVMzaFcwVGdjd3oxcnB0MWFhV1ZRbXZjaTFXNzh1WnRCTHU3LzFWQnpPQm42?=
 =?utf-8?B?dFZRTXZHZDlHZkwyZHFZRUhnYjZuaDQyZkl3b3dJZGRLVlZxR3MxSVhpVmk3?=
 =?utf-8?B?R1JFdDVMVmtFaVExbmNhQ09yQjdFeFdCOVRCQWFrNkdxQk9FNzdvTmhJd2Nr?=
 =?utf-8?B?SkN4dFg0Tm9SUERxcjVPRG9sYm1jUFQ4eEVUT3pYV1R1WHZYNnYyWk04Vldt?=
 =?utf-8?B?b25TdUoxZFUxY3UxSXVjLzhxc0xRcmpXVWxLVGcwSEJDeHB3VFNoUUgzMVRL?=
 =?utf-8?B?RW03bGxrTWJPTFdtWmJITVcvQ3FrbVpOWTN1TUZYU3NjNWQzZXVlUnZGT2ho?=
 =?utf-8?B?Z1hjNHZPY0hhWkdGaGNET3lCWjcwTjNIRGQ4Vk44c1ZnWjI1cDNNZTZvWSt5?=
 =?utf-8?B?NXFCMDZsRmxlUUl0eVNNSTA1RzMwVGk3aEI4dWZkeitQOXdHZ0dySm0xS0Vv?=
 =?utf-8?B?N2wrYmNpL3hJdnNCbDZFYnJTaWkraldIMVZ4SUpWSVF2ek9EdjJldVpOQmJB?=
 =?utf-8?B?K3ljeWVVVE5hMXJRZUFFUnlpTlNiQSs3SWUxbDhFZklzaXNHdk9EQWYwWVJZ?=
 =?utf-8?B?WWxMK3c5amtjTUlndHFoM29PUWlKZytidVZVYmJ2UVIzRXR0MHJTWlpqOFpw?=
 =?utf-8?B?UTFObGNiVUMrRTNNMk1KUEliRkRNQkFPN2Q5ZVRkNXJjTkVTMDRPUXNab0Vr?=
 =?utf-8?B?NjQ3bmlxL3FYOEFoOS9ZWWJ2bVNYK2tBOXJRTXFaTmxEWEx6Q2dtNXNmZU4v?=
 =?utf-8?B?UmZwNzd2UDJROFlxWUg3UGRpSW5yR0F5WDdTWGRxWmlTaHV3RzNtRlNtVWVi?=
 =?utf-8?B?SHYrbGVDWG9hV2ZzVnd2MG1XM2RjZGcyeko2dTZtcFZpUWVYRC9IWk5LNm8y?=
 =?utf-8?B?c2hXOWY3YWVlQ3JDWXZjTUh5Q0VOTzJGZDZ1d2ZJcHREbktIamF5encrT0ZU?=
 =?utf-8?B?NFU1Qks0OFFaUE1nd2FKcUpDZE5qek1STFQ0VDZkL0hCd1dNbmlaS1RsbU9O?=
 =?utf-8?B?a0w2Rkt0TUJ6ZGU2SitQNDRBV0ZaaXZpTHQ2eVR5MlMzSUg5R2htREFjbkJH?=
 =?utf-8?B?K0lBbURqbzJaRjlyOGMrc05obzB3NUd6ZW5nNXRneFVUWmNmY0N0NEVpdUpL?=
 =?utf-8?B?cnNYajIwNERoMitrMm5GWXQ4N005eDVrSGpYMUdtVTBKbzhIaWpGNGtKOWFW?=
 =?utf-8?B?Zi9oTm9NQ1pOTDY0VFkwUjdIMCtCZmZQSmd3TTlvdnZrZzU3eUtwVzZYOVVR?=
 =?utf-8?B?VXFMeDNPTUt4SFBzaTE1V29SYkJoWWdHcUQ2NFJzeHhHd0dWZlpYY1pBZC9J?=
 =?utf-8?B?M2tDNTlYbm4rSzNTc1l5T3JrN2pEQ0lqRUZhTXBVamtjN3ljMkVlMk9BRGlM?=
 =?utf-8?B?dnJ0RUxFSytuZWZhR1RWTnV5MjVXVU5TdlBWRmlUdXJlQjFrTDNwS25oMWJF?=
 =?utf-8?B?SnZ6SUtNNGpUbmpkQU1GcDFEaVk4cTJJUng3NTJlVTNTVjRmd0dqZWthNkh6?=
 =?utf-8?B?U1RqM2Z4RUdOdlZOT0RrVmprcDh4bk9mU1Y4akVPUWVmaDl2U210bXVRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6379.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bjBzcFZsbFpESDUwYUZicXF0Q0JtS2Q1NU5jbWZwWTRaU1lzVVNjUk9IcGhI?=
 =?utf-8?B?YmZ6dkF4Vm96UHhtZENYSWdkY3N4VlBldHpZWUJqNDd5U3oyZHVWUU9nWkRs?=
 =?utf-8?B?QWpWZnIvWFF0MVU5ak9xYml6NDdsN0dVdmJuKzdwc3lGTXNvbTVLRkRGVnM3?=
 =?utf-8?B?dkJ5Qmdab3RhM1pGWitMaDdkam1WYWN5UTNQLzhhRnZoRGxQYW9DVE5PSDZS?=
 =?utf-8?B?MVk2Y1dBWDBMQldPaWRjYlZmeXdHUzdqZERMSENWdEUvWUkrWGhHbVlVcENu?=
 =?utf-8?B?Mkk4MXN1aEs3d2s3UUppaGJYMGd2MnhGaUJjTVJROXdrTHd2c2ppZS94MEFG?=
 =?utf-8?B?Wi9QcmxlZnZ3U1g0bzREUXNGSWFJM3Ftb1BpKzJOQzgxWU8xZ3hjTmpUNDFu?=
 =?utf-8?B?VTJza1RzLzcxbWFaNW9EMGEyRFFwcnNOOXpaWUQxVTNNT05iYUQxNmxyVEZq?=
 =?utf-8?B?cGRBcUtiR3F5YkR4TDErYTZmMUdRUVJ4bk9McjVMZmJHWVZGbWhPeG1jdW1w?=
 =?utf-8?B?azluazhwSFlLZFRsYXF0N2xxbG1rcVhzWlBEUUE4Nnkzd1FNR3d6V0NDNTBC?=
 =?utf-8?B?b080N2xrZjAxbmdVV1l2VjZJaWNsRE81SWo2ajRnSG8xUHc0ekhYQVpWTkZ6?=
 =?utf-8?B?azVtc0ErUnpyN09wT0x3cEN1c0tZUWNybUZwVjMycGJtbnplWXBFU3JCaFZF?=
 =?utf-8?B?c1U3Vnhuajk5Wkg5T0I3ajNEVkhqRVZzZ290VGFmL0NhK3JNcWNyajlKQmto?=
 =?utf-8?B?MmVySUYwN085Sk5wYUVGSmdMSEk3dmNESTZaUTN4NUxhZStiejk2RUczOXZk?=
 =?utf-8?B?czh0ZTRaR0pqSkFlQk1TZi84bk42a2g1dGFQSzhidTRRWm15NEZ2TFdtYThz?=
 =?utf-8?B?Q2haSVhJV05jVUM2UGwwTWFKTUFRWHRCNTdteiszZGxYbENXWFFMa1QybUpK?=
 =?utf-8?B?eHBkZHdwYXBGU0NEbW0yMElSZWFseTlXV3lyQ09NOVVVQXN5R0xwa2ZKd2hM?=
 =?utf-8?B?VTVXY3NTVmNNYlN3UWlDemNFeDJWY0RuR3A3cXFnL3FZTFgxdytqakpsRVQx?=
 =?utf-8?B?cUc1WStZSVlYWGltSXhOOWo5KzRibys1WEhJZmFML0FSYjZXUUQ4bWh4djNU?=
 =?utf-8?B?c1Z4Qy8rOE4yU1hpaGY0eDFnbFVoRUxKRkVSVmNOdzJWSTlpcUNYVytJVHR1?=
 =?utf-8?B?QmEzNDdFUmU0OWlqUm5vSWNyMlFRM0ZoeVl1SGVZMEc5UGVJVURUaGFBMEF5?=
 =?utf-8?B?czlBSVpnZ1pRVUZQakVONDNLcUplWVlCUTB0OFJHYktQUnN6ZVZWUUo3akFG?=
 =?utf-8?B?aHhLc2xodGx6ZVNXRkdFeXpFdkNyaUo2UWJ6WVozTFF5dGZUUlhjeUltSXdp?=
 =?utf-8?B?TlE5MGpqWkVsekhLcVZYT3NPdVo3NWc3bTBRMmdWaGVoWFRMKzMwSmU1U1V1?=
 =?utf-8?B?OHZMOTlJcXNiUUlJMlhNMnZRT0o1RkRHektvb2dwRHJlUmZzdWM0eDUyK1Va?=
 =?utf-8?B?bFJUNzgxNmNZcVVPc0RsRlJEcmQ0YWN0UWI4UnFxR1NhVkpOaWJQZzJpamRo?=
 =?utf-8?B?RTdiS2Y0K1Q3d2tmQlA3VllZSkFHd0pETUtNVGZkOXVpT282cHlIcFpKUzZO?=
 =?utf-8?B?ZVF5UUsvRmJtNTBkK2pTM1VzdVdnd0JWbUp1czdVOXRYOHg2d2FPT0xiRGg1?=
 =?utf-8?B?dVRYVGErQ1F4Tm5ISWFLS1ZxV2RQSE5kU3lONEpIU0hIeDdybDBLZ29lNnR1?=
 =?utf-8?B?MGNYWHVpc3FLYzcxUTNENWNLS1BaZDRBZmRndHlWejZFdnBhQnYrQU1DbXhW?=
 =?utf-8?B?Y0V0Y3NJczNwd3VIaDNvcm9KVGI3R1k3WStkOGtuWDFxSzN3ZGttZ1VZc1RH?=
 =?utf-8?B?UHQwT3pOdUszWGhsRm5KSU5ZQ0hlelQvbXQ3Wjc1Um8wYWJnL3U2RjFIVnVB?=
 =?utf-8?B?NGx0MFdOMVhiT0RweXI3NWNpaVJzSFlybGc3WlR4ZmNFYmFHelBwdnBvSENy?=
 =?utf-8?B?UWVwQkhJTmxxa0MvMXplM25nc1VvWk1DZkhkZk94aTNkQ1FpOHlIK1ZzU3lu?=
 =?utf-8?B?ckVpdTlyZjdzYStsR0VsRnBHNk53dmxPd2lPWmIvRW9GRXIzOVpTN1cwOCs5?=
 =?utf-8?B?QnN2OFBZUGhCaWpLQyt2YjEvckFGOVgwWlpIbXBROTZKL01EcGJTQngvQXJT?=
 =?utf-8?B?Tmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	TMHjXsWC4s/JKMFlK2a2jYjXnDDZOtXPjK4hACOGgE/alNwe467i2TzGbOOIV4cLyMf/P/hoHj2ym0KY+2ZOl46aZkfX44zew6ETn6gb7xqcusah6afsDXm90QAxNJpiy2KfWm5TTpYy0Hm1vMSKlmrrJHQl1eGlG9rK40qHzUHz/dVss8ofDo10UNfySYhEmMYJws2ZBCM1msuqY3rcaGHi4p2gZDgns+Z4VYVtCW1PpEDLMwYe1xixsy609VBcfh/KRX3LNgVpDB6s/3qaVtNljyfb1mAHbTB8KfiAplD86FzkoD+ZEli7DcMHknzXD5axDLdN9ueC6eIZxv951qFm9jDZQHcDexQZF+JX9fdkDW1OU9mylDEzLv6UGmvVJ1zvZ0SUTLilykOPCyEJphCnZyZieoAkbymlpWgjz6x46r5BaKJHH728IcIsR9vqvGAbP6GmuUduKlzCZbSLnR+Hp5v98LZqMuEdyDRd6AzqQEtlXNAmOOqOS+OV52bne8qraZG7pA0RzGHqi8rYgGYw57mIrdfOXdW/NHnW8DrPCt8OPClrwmIf024S1C+eAiAmzTyI0yDld6ziTUB//nodauqqrpCMvwCwMEUSl88=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7c0bb09-d4c6-4c55-9149-08dc76a23a9a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB6379.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 18:50:32.1754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WwLpdFRsYAvyHVV/Ios3AGy3ip38SOxSj65fFt5gvLGTYBvNXwefgTphTdc5M8+vxwbSE9pmrb1IbjQFCvnopTJXqNwXI0BuMyHfj3JyZy8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-17_09,2024-05-17_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405170146
X-Proofpoint-GUID: Blzn1R5BbP_KUuT53q73sTGYcIOV62v9
X-Proofpoint-ORIG-GUID: Blzn1R5BbP_KUuT53q73sTGYcIOV62v9



On 5/16/24 5:53 PM, Steven Rostedt wrote:
> 
> Finally got the time to look at these patches ;-)
> 
> On Mon, 15 Apr 2024 08:49:21 -0700
> Jianfeng Wang <jianfeng.w.wang@oracle.com> wrote:
> 
>> +++ b/lib/trace-cmd/trace-ftrace.c
>> @@ -23,6 +23,12 @@ struct tep_plugin_option trace_ftrace_options[] = {
>>  		.description =
>>  		"Show the depth of each entry",
>>  	},
>> +	{
>> +		.name = "retval",
>> +		.plugin_alias = "fgraph",
>> +		.description =
>> +		"Print function retval at function exit in function graph",
>> +	},
> 
> Honestly, I don't think this should be an option. Or if it is, it
> should be default on. If the retval exists in the trace, it should just
> be printed. Why ask the user to show it when they spent the time to
> enable it in the recording?
> 
> Thanks!
> 
> -- Steve
> 

Thanks for your response!

I make it a default-off option because the feature changes the output format of
the 'trace-cmd report'. So to be on the safe side, keep the original format by
default. Also, the kernel has options (i.e., options/funcgraph-retval and
options/funcgraph-retval-hex) to enable printing functions' retval in trace.log

From my point of view, I'd like to see the retval on by default. If you are
okay, I'd like to make it default on and add an option to display retval in hex.

>>  	{
>>  		.name = NULL,
>>  	}
