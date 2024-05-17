Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906B913FD8D
	for <linux-trace-devel@vger.kernel.org>; Fri, 17 May 2024 19:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715973874; cv=fail; b=dlBKdA4OEUCQNih3P7BoysuDjq7RXolXvmaJm96fiPWMwbDix0xpVa+SqoV9kz7Iv53viJhri5O4l6A5twLjlAm2VgVxdG+oah8dKn2bdoOu61YTfZyH1iQNR9r8ByBNs7EW04EB/iAo/itMQaMIkgk9zucV02HStUK/nv2uenU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715973874; c=relaxed/simple;
	bh=fY/aaOx/wWTXjXpyNFjX9L0aBTiM7vtxPNW3J1jbPDY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RWJeplbgiNnwV7IaVsuv+LATHm6JyLQdnSlYE7pYU81Vpeku9zJYgZZ8xKkowCtp/gL0hr3O0rreffD1U1s+0vSdxZtv0s1dR+LfjMNe84REUlw2l9WjYEdsEvUVuNRFaeGE4gZDa+q0oAanKdmcgNpwP2+hbOY6AS3p+ldHZYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gIYiw5VB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Tnutjrjr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gIYiw5VB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Tnutjrjr"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44HGZg93000834;
	Fri, 17 May 2024 19:23:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=5zOUP40BakhjJQhl8Cr24wAWbDt5aKqQBZP2LKKeg50=;
 b=gIYiw5VBzWPUShLgDKQsywcjb6TWYejlKdEirGP7RhXPrHN5GeP6iQRcSL8aPyS7Wbi3
 fG4SukwDaR8WPFUroI7UQFx3YTYSgkYmG7YMc/DIoV8zAW86h84SGYQdWAn/fuZns5I9
 NMJFbugrPend/ZyPB5okl/Q2jqA+mxshl69FzirdOjU+8VqOlWLhGSJHqb6uqfifmk/S
 6zWxU6xwnLoRapne4+h27ursmtxFfigPXfQ+6zU713QVRD+zG+msGJjhVPcR7Er8tq6f
 QDMK4NutiCfqfHzcIp5XnZqyV3OF6+UUeLdOncPb9ohIp/4OfUGyD3/AzwHEiP6QObNQ yQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y3txc8ppd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 May 2024 19:23:57 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44HHoOd5000659;
	Fri, 17 May 2024 19:23:56 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y4fsvas4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 May 2024 19:23:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QbKUbF1LPaTad2/nwJJTkqE8EZUD4hXvXjDFNRmsaq2Lckz+Tc618YAkGCR7EMiXbPxRBbDADPStWMnD2mHNNPxN0yT9+tiTFm+TKN9rmdfaTFcwRdx12eoEzi6tLaED/TBCY8sQrj5CBw4TBapOyVtpqLvqGEYBd2MoGP4VBRcCnXhOzUE0EomL1/K0x+AwiZEZA45dnJDRVrNpnarWIDSx2NqVFgPXCUJUTKQRgPBm94kaypJGxgcBq6uCPBDgCx3qfuPfmPo0nkSL2zj6mYeh6KW838+k2nKXIG7iXLREDWMRRBxnhGHxAkG/wKcJJnqLisinZTaRu+NjywTWqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5zOUP40BakhjJQhl8Cr24wAWbDt5aKqQBZP2LKKeg50=;
 b=Gxu0/PvfL7LsvVM2v5vyMxh1Rl2CTs31Mzu6SUFc5p/HBccTMjXsWNlaPcpaPvRMhB9F3a1Z+1l89DDXA3L/k15nP1fYrShOTRUj/kWvbOrP1JGcXIq34V8v5Obf0Z44JXu+HDIQLgKoys+wR+biZ0ffbF/eiI4al3GUwrjr8RKzlfQc9bgqUoIhUqHkf4XSMYmk3MlmOSWB4edMzaPxNI1fvH7Uf1VvsmkUW0Yuiu/iuNuugQV7r0p4ehqvayAolVYFUV17S3mHmCTqnabirgbNmqwTIKHQIfr7pbLupBX/9e7/rFAY2PLNwQEFSYNdS3K2arHqPiL4nTKLKxV+/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5zOUP40BakhjJQhl8Cr24wAWbDt5aKqQBZP2LKKeg50=;
 b=Tnutjrjr3BqdScMVUKNjOTTz8MQciB/oTUY1oz6a3SkqvvZQb91GqphB+M1gziJ4bfckh15SZK0rZa8+/+DLWYWpTb1SvO6oloBSHCpBnO2bUm4s5cRyiPtEAq8X9ljDRVkr1vDj8+08jIme55BdfE5rdaVgnwDo9f5Mm4NlGQg=
Received: from PH7PR10MB6379.namprd10.prod.outlook.com (2603:10b6:510:1a9::15)
 by CY5PR10MB6009.namprd10.prod.outlook.com (2603:10b6:930:2a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Fri, 17 May
 2024 19:23:53 +0000
Received: from PH7PR10MB6379.namprd10.prod.outlook.com
 ([fe80::c7da:13dd:aa4a:925b]) by PH7PR10MB6379.namprd10.prod.outlook.com
 ([fe80::c7da:13dd:aa4a:925b%2]) with mapi id 15.20.7544.052; Fri, 17 May 2024
 19:23:53 +0000
Message-ID: <65f2c9e0-46e0-474e-9245-c2a0d9f9b95c@oracle.com>
Date: Fri, 17 May 2024 12:23:46 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : Re: [PATCH 2/2] trace-cmd: Add ftrace options with
 fgraph retval option
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20240415154921.4998-1-jianfeng.w.wang@oracle.com>
 <20240415154921.4998-3-jianfeng.w.wang@oracle.com>
 <20240516205302.0cf9640d@rorschach.local.home>
 <a40c7f16-d3fd-4a30-987c-7a7d418ea5f3@oracle.com>
 <20240517150037.5db93c4d@gandalf.local.home>
Content-Language: en-US
From: Jianfeng Wang <jianfeng.w.wang@oracle.com>
In-Reply-To: <20240517150037.5db93c4d@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0021.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::9) To PH7PR10MB6379.namprd10.prod.outlook.com
 (2603:10b6:510:1a9::15)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6379:EE_|CY5PR10MB6009:EE_
X-MS-Office365-Filtering-Correlation-Id: 072fb5d6-211c-420c-c023-08dc76a6e362
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?eGJ4dk9JaU0vOXNSRUNLSWFReXNSTDRhOUwrUmhlSWJvVmx6Mk9BRXBvSDVS?=
 =?utf-8?B?V0ZuSXkxcE4zNXh2QVh6VURxdWN3RkVBc2cxVHdhcUJpd1cyT1A3UTBHTFQz?=
 =?utf-8?B?dWJublE5K1NQMTczNzlOR3YvTWdPdVhtSFVjS3J0bFRIczhvd3IzRWVwbktD?=
 =?utf-8?B?d0xHS3M2RmMxZHV2UUc5ZDc4aG4vUlZvSVlLQ2ttSTlSSGVtdEhXaVRTbkRr?=
 =?utf-8?B?bzY1c2tkM29rTkc4eHN3OHlGako1YkQ4MnFzQWNsanNkWnArMmhuYjFmRnkv?=
 =?utf-8?B?Y2l5Q1FndWY5M0lpOGppU25Icm1yQy9xMWMzUWNOZHhnRVV1akRkSFVYek9Q?=
 =?utf-8?B?VkQxdnA3NDVrN3lFRDRua3FYMlE3aEY0Rm9NN3NOVmVRNk1JM1dVZWZkdE8z?=
 =?utf-8?B?N1R6WkUrTzJhSTdsYmEvaHJheGJTUys0Ymt1WVpGTjFCUVZjcmpUaFB3NzNE?=
 =?utf-8?B?anZHc0ZOelNXTEN0M0c0dnllb3FYRE9QT1ErdWdZSGlzcHp6cDVtMlU3WWdh?=
 =?utf-8?B?c005WFVPUG9ubFhubnp4YWtySHBFUDlLMUlNc0FURkhjWHArTkN5VS8wSWNj?=
 =?utf-8?B?K3dNcWxPdHZJN1NNbE9yMU9vZUtMZU1BOFhVZDhXMHdYOVZrVnN4dDBwb1dN?=
 =?utf-8?B?N2dlOStaNUNOWExWemJ6cFZKeFZTYUNtVGVPUzVMRjRYRHAydFN3YUlUUWJS?=
 =?utf-8?B?TUJGOXRYWlVkbjB5L2o2eG82QlpvUXZ3dW44RE8wYnJMRmllNkoxNUhKZ3c1?=
 =?utf-8?B?NzNQaXVNeEFLUlFzZ0hzQmJFbzNJd0FMMTFVK0diekUrTW1FbzJDdW9aK2Ex?=
 =?utf-8?B?ZjFUMjVjUlNwOXJNbmF2cGJPMCtiY3NHeStFMVhZZ1RPeFB1aVdVWDdMTS9y?=
 =?utf-8?B?RWxLdFFpU0tWbC9vNXlnMTNqSW5JL3dzVzhwUllSNTlJQ2ZHQzF3RVlxdXh4?=
 =?utf-8?B?UVF5Y1RUaVM0SWcwQ2lWcE5mRVdRV3I4a1ZqOUFLZnpIUklIVGwzSTY0bzY5?=
 =?utf-8?B?MmR3eUNqWnZCNFNBYllIWGxYZXhLRmhEWU1DSEk2MzRKc3VQZmgvdkx1Wkk2?=
 =?utf-8?B?UDJnV3BSb2RJQWxmNEhtRHFNcS80UWVJVWk2NkVrK3A4ZUd0Q21KN085M3NU?=
 =?utf-8?B?OEtkRjRTenVMR0hub2dPVUZKQWJzMXBXWlg3KzRIcVpaRWpwbHlFQ3VWRTdQ?=
 =?utf-8?B?K2huTFAvZVB1cVExTk9SMVEyU21ha0d5ZlVtUHBFLzlVWVdEWVUza1daK0JI?=
 =?utf-8?B?Y1JyVnZFVyttaGtnNUwxSXBESjQxRkRCUk41Y29mZVRwdjA4TTQvWDg5ZUxn?=
 =?utf-8?B?czlpRFpyS0xOemVPSEd0TjdseXQxVXZORDBmY2RBZ056ZWRMZFBHanJqaytl?=
 =?utf-8?B?Ykg2S3cwQkZFNWJPZlVvbDBhRFZUUW1CeHBOTjRDWk5ic2gyRW01WHJGUm9z?=
 =?utf-8?B?b2RUbzduMWFNU28wU3kwYlRXRHpvcURhUjJYRUhNWkpOUTZkQjFmVkhWeEUy?=
 =?utf-8?B?R0RzU0NUTHF2bmNVUldTUkhKL3pTeGgxN2xDYm1nOGJpZVNXK2F0STNaNFVI?=
 =?utf-8?B?NlBDTHoxak40eXBjYXVWTVE4bElRc3c4R3dsbzdGQm1JOVZ1VUVTL2E1UklY?=
 =?utf-8?B?MUNHQ0hjNWVXUm9ZQVl3K0QrUjc1NlNtMU94QmVGRjFQL2twR0NaQVpTQWhw?=
 =?utf-8?B?cGRIREdFamQ2RGwwTnVyclk5L1c5dllIbjlROGxrYWdHWTBFc3JTcTl3PT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6379.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WkphUHY4a0d5ejRGOGVEYm1BWHE1NzB5SVNIYjV2cXRhUisyNTNmS0JrQWNj?=
 =?utf-8?B?d3NLWHZiVWpHd3A4bEEwcVNYOS9vQUF3akx5S1NWdFJLTnVQblZUdWJjaVZP?=
 =?utf-8?B?RFRpQ3hqUVdqTXVKZmpUdWVFdStzUW1MeEJxTkFmS2FvZFlpU0M2dTcySDYv?=
 =?utf-8?B?VGM3eG1kTGV5b28wR3lBamJPQnpoL2llZjY2QUNGWWhoSWxzMDBMOFBZL21v?=
 =?utf-8?B?VGMzWndudk9uVG5RaDhnYmIxazhrUlFYM0hlb1RPNGpYSHZaWGhCcysvejND?=
 =?utf-8?B?azN5S0NmVS94cWJ5WG1vbnA5aXhCb1UzWFBYMms3clFQVjMwa0NiVC9STjBp?=
 =?utf-8?B?K1dUTm1rZjhVd0NGemNvWUpSSXpPbDBIamFuVmFianZoRXFhS25wRWp0T3BS?=
 =?utf-8?B?RlBNZHNtRTVGcGhtOTdodlNCMWdxS054T2VKZHJTWFQ1UllzbVdxQms4SWZ2?=
 =?utf-8?B?aHI3eWZweDBOUlZoQzdrK3EwWndnMlgxdGRuS3VpUk5oYjd2U3BHSTdEcVZL?=
 =?utf-8?B?YUhUVlk2bGNLVFBWMDdHNjE1YkZVb2I1a25FRkN1SGNZOG5zNlFVbE9DOTQ0?=
 =?utf-8?B?Y1VOYmtNUlJtSlVmTFZzMVhxMTR2b1dQd2tSb0tSdkxMSmVkT2pDTGdrZk5B?=
 =?utf-8?B?UExjSG9TYW1HUFVGM043VVdwYjhDM0tUVnVnTTljd01XNEE0MDY3SXFJNGRp?=
 =?utf-8?B?N3pxZTRtQXpkQ3d4bkdLTlBxTVNPYm1zbTVERnNMUnN5bmxYa1VuWVlkcmI1?=
 =?utf-8?B?WmljTnhncWtHZ2ZralBuL2owNWQxVEIyVnQycWloNm1mcHZER1hQSmVIUEVO?=
 =?utf-8?B?RDJLQllGWEVoNmJQUk1mZ1kvQkRVVDIxU2hsTHY1UjdabzRzaDJwUUVaVVFD?=
 =?utf-8?B?RFJGZW5KU1gyK0xkSkhyNEdFQjdpd1V3b0FaQ3NUWGowVUhxR2V5c1JYeld1?=
 =?utf-8?B?T3lTRWlNNVFTSWtBNUJ3SHZvN2tJZ054YU01c2MyaFFJSW5ZdGxYdTIxeWlZ?=
 =?utf-8?B?eXpGRDhRZWpITUxsMWMvMUpqK0JqcXRaNkI3Vk5qSHkyNDY5QW52eVBmNEp5?=
 =?utf-8?B?RjEzUUdTaEN1S0xtSE1lM1FRNTMxd0RudnNuMnBmZU8rV0p3SzJ2TUxLKzJR?=
 =?utf-8?B?U0hnelhvNDRSN2JjRFNTRjRYL3NDMkdDcUdNY0VGMDU0Z1RtYTRRVisyQW4x?=
 =?utf-8?B?RjBCb3E2M3hzZk1vT1grc0dLeS9obzFVN0QzWVBURlNCWURrV2tQa243ZlNS?=
 =?utf-8?B?ejMyQzhSemhzaGlHOXhsNGtydld4NitQL3Z2NGlNNWZxZDVMZzFBWFFPVTFH?=
 =?utf-8?B?MWhVbnZZRTdzc04wclZBWEhMRCt5QVNXWkJJS2g0aDdzNTQxclFNYjM2ckpB?=
 =?utf-8?B?TEVTUTM4bjFJQWxmLy9naXh4Z0JzUC9xa0UwdlY0eDcrQ01CRU1BSTFDMWJi?=
 =?utf-8?B?UDI3NVFtVmprQUFUYkpQR2JVSGxXR09uMTdRZ00wVWJUdUkzcEV4YkRxbURF?=
 =?utf-8?B?ZDJhNk9SUHB2MGhLVWlXU2lWdUJsY3h5V1BjVC90aUFmd1FJd0YyWHI5ZW9r?=
 =?utf-8?B?eHBpdi9lZW9WblZUQzROdmF1UkJPUVQ0WU9pd1VraklDUmkvTGlVM0dDS0E0?=
 =?utf-8?B?N0dsT0x1eFNvRDc0Zkdaejl6am5Dd1RhV2gzSy8rQnpMU01JVlh2MXoxZ0lL?=
 =?utf-8?B?Q1J5WGNmVWxZUkFKV296U0VIK1FVb3c3aHF2WkZKZWJudlArQVNMVWs1Y0c5?=
 =?utf-8?B?UllQTTQ4VmEvWW1DQmdxTzUrRlNzUG1ER2dTLzlaQnZhWXJnUHVVZnR2emNY?=
 =?utf-8?B?T2tRaFpVd3EwemtMZ1l6M2U3MUova3RUcmdQL1RYeXpKZFlLZEN1MTlsZjJu?=
 =?utf-8?B?b2ZtTUdaNEhFdE5ZOHpaZXRiempoTU85YjRHaHV6VDh2akpkT1NVb3FUbDBQ?=
 =?utf-8?B?T2pUanlIZFUvOTRQQ1dZY1dOZ0x6YlFqRm0yREFac2c3UW5DU25CSU5UYllE?=
 =?utf-8?B?bzVCdVJSVjBVVFpsS1d0OVQ0cnAwYWY5VS8zWG9IN3A5bStJNVFicjV0L1N1?=
 =?utf-8?B?SUtGRlNCRUtyQldRRFJSNDYvOG95NlZraXFSNGlPaVJ6M1pudkpwQUxDejRC?=
 =?utf-8?B?Mzc1OUF5WHQrelVEaUtLemh1ei9za3Y4OHRUV2t0QlUveTFNSityZlVxV01N?=
 =?utf-8?B?M0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Gui0LWgXF5InzIElg8VsxcljpGUWwqcUB4TYZRq6Xr93PzYz/PUJ4UiLX3h6vWJoSDfcQg2YZlyGdGMIYzpcKIemya6OBF/zqyA9HgL70NV8xReIUF9i++JYpmt9jz6Q3iKE+tdUhHS3gYqBq4NRnv9l7yiw+OUAFlVqR6I3Tp7KGYkjqW53O4PUj42VF290bQE9SQ/dnJqjRzh9ZXS5CTX7KLpD6DdGHQKXVjp12rZ0Sq2blcsXwfZaiz7BFBuxL+H+Rhge0kK865sNcSYQJmj7XaDiLsEcwU5fmsB8PIPbN7VwUMA4LujHW+UC4rENM8NEIOF7songlC33UxLKyhY+vKalJgr5HQRH5AT6C2bcIKv3iZIi++6Jlvv/OsclkS78NTaNMFhGvTIarcd+LdMnNleOhTBvkl7ABAQOayqBIKywPQlKLB862vN6Sec0VdxuZWBYQWfMAAuG3aMZ7K8myZ5YY+Dw3zAE7Z1004JDze1nMvPcbY0ZUIUhjQddzok2R9mM+cvDXnt+nzR9PCJZ9+i1DqSff7HZcGKXxRaX2wHQPLqWax0z1E5vOKh+5TrNrNSIwowx13w1tv1K88IB0hTTIeyUl24n81qu1H4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 072fb5d6-211c-420c-c023-08dc76a6e362
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB6379.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 19:23:53.3791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mRODUQ4c9zAzKxhgjSypxJDJ7ch/6DH+v8zHLfzf7aaxRWicG06MUzwbCuZsRuNOqKn4hF6SJrJ3eF1blr5227LMmgPlJ3PmMREnERfCvCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6009
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-17_09,2024-05-17_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405170150
X-Proofpoint-GUID: KWzzWCVCGfI7P7VQuMqLj1I91XcTqQQ3
X-Proofpoint-ORIG-GUID: KWzzWCVCGfI7P7VQuMqLj1I91XcTqQQ3


On 5/17/24 12:00 PM, Steven Rostedt wrote:
> On Fri, 17 May 2024 11:50:29 -0700
> Jianfeng Wang <jianfeng.w.wang@oracle.com> wrote:
> 
>>> Honestly, I don't think this should be an option. Or if it is, it
>>> should be default on. If the retval exists in the trace, it should just
>>> be printed. Why ask the user to show it when they spent the time to
>>> enable it in the recording?
>>>
> 
>>
>> I make it a default-off option because the feature changes the output format of
>> the 'trace-cmd report'. So to be on the safe side, keep the original format by
>> default. Also, the kernel has options (i.e., options/funcgraph-retval and
>> options/funcgraph-retval-hex) to enable printing functions' retval in trace.log
>>
>> >From my point of view, I'd like to see the retval on by default. If you are  
>> okay, I'd like to make it default on and add an option to display retval in hex.
> 
> Yeah, we can keep both as an option, but make the retval default on.
> 
> It will not change default behavior, as it should only be shown if retval
> was recorded in the first place. If it wasn't recorded, the behavior should
> be the same regardless of if the retval option is enabled or not in the
> trace-cmd output.
> 
> -- Steve

SGTM. I will send a v2.

Thanks,
Jianfeng
