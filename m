Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1C14206B
	for <linux-trace-devel@vger.kernel.org>; Sat, 28 Sep 2024 23:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727565409; cv=fail; b=WFLZcO1RlKPTT6cj08HaypY9A6YwDzcEn7lAcXGxlxejgC/l8ovjAho+0r+qrZrUTz+M+jO7QhgMeu94GMl3XUj7ih0aEzB5fKSRUChCRtKXMO54iypsq6aJFyJbPN06/R/U6dltqqWCWLslmh6cYPnzN0tRfHCDs0dS5hVTAPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727565409; c=relaxed/simple;
	bh=Kg8dHAvgEgE/kz68XA4aRlb85QWqVJiuM9TIYC5pKys=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Tt6BFKwyCRaUauoBTo0+s9ifTZkwI2wCA7l8u0oRdpoVNBM90Xp0GdkZdRN13EutWJUo48BuJIsByt/9sqXhQ4oondxwBIZdft4nIi8nPIqa5gdod9E0xdy8sEB7BK0IjCIyrkJ61vOEmVVV+uSZ/TA1EppI+i9X0NgSiFy/5Jk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I7Nyk0VB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ETAwOwiM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I7Nyk0VB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ETAwOwiM"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48SMxh9j029345;
	Sat, 28 Sep 2024 23:16:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=Rn7Hz7iM8pEbNdmNPp/53l6WaJJZ0804gcRZrEgAH
	Xk=; b=I7Nyk0VBQc8hMSnVFSrDQFnlgDCX0EzLJSh4OWpxepl4Y/aNIleAGMyrA
	r5gD7tSqdDbgL538jpC++HvlebsoWGP/evdBI1fvCJg79diejAhSFTbd+9IbpwGV
	HYqiXr9p1T7FfqcSuKAoQ+pIN0G5j6AepLDV8OAFWuE+iqEDxAe4RdlcNR6ezIbp
	ar+hBd/992a2KXkxP0MK8w0tnAJSUeYXdpSmGvtW4Qc0nzxwQhsCd0xqImrD4jPA
	u7wkhOIhE7qLBdHDRIqZKD+dnxGtgba/n22oH40z3ZIswYwMLz3WbMFaYK3tMFuc
	2HFX7n0M4sOBjDH3fLeLYcsRfqTog==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x9ucgu02-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Sep 2024 23:16:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48SHaJPE040473;
	Sat, 28 Sep 2024 23:16:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2048.outbound.protection.outlook.com [104.47.70.48])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x884rxtw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Sep 2024 23:16:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Czt+Vn9lYlxad5ANDOC6sy9unWNuKRQxqnh6D9l4FzQjz318bZ4Sj8PRiBSJoB9TW9CwM90nUk9PxPL+3ujqXhaLm15nxxZR/sos5KmZxHTZ+PrJ7c2FOZt178ztyEcDrftPwGLMX3bKBRBLL7+5kwgOo0YBYEF/OGzXvd+A9C0cYqPfv50IXi0Dv/QFdCNK0GY3FBPyHHr7S1hs6qz2ICxTUIG+47Lx6HBBUwLwFlUR3deu3sxMWBT8M0eBwc3HvVW6sG8AbCO5zsJDiz5QRiy7ITJey7HpfY7WujROmiIZjFKsxTwDmy75Q7NIjMFOBY2yjP6dEjqsUJlxXF+3AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rn7Hz7iM8pEbNdmNPp/53l6WaJJZ0804gcRZrEgAHXk=;
 b=TlmvQs2P0i7Bj4qo5nhFihRbs6pMoz3pwWvnfQ9/ZX6EOUFJRnbQY7l6uasx7nyOHyLq++p4nPaZxQk4ECqcewXM1JZx06PoxYKtqdPOQCnEWdQRdUDFNtCmZ3YLVtUYojA9ckAjDDeHFDcOIX0o3OOStFwoQirWSAZ6/r/oOxipZKKre0HJVXmPmUGwzvdpfbRhEx+HZARJUZ4COOLDwh0CmiDCrJIUSjapOrwfrGYgnahs22INPi8KGF+o1/ElWzEGw3hTaSdBcE9OKdLPZxIvnTJB6rSsBAJWxYmeum/geMfZdwgtfSHPGJDECgfZ7ggleJOE4WKbTbaQdu/IKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rn7Hz7iM8pEbNdmNPp/53l6WaJJZ0804gcRZrEgAHXk=;
 b=ETAwOwiM1nhkiLG5QwLG/h0oXj+D+v3NuGcrZG8ghDldaZCYpONz+0X1gv4VRh87lPwkcDKhRQQ1Dzfq2eZxKc7peq1XfcwKHy8EcnvlnVoHAx5GVK1Cp/ZmNBCVekv9AEUsVtSGnvWPdeHzcXm5oI5AV62Ydvb/SXx53wxMIoc=
Received: from MW4PR10MB5749.namprd10.prod.outlook.com (2603:10b6:303:184::12)
 by SA2PR10MB4601.namprd10.prod.outlook.com (2603:10b6:806:f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.12; Sat, 28 Sep
 2024 23:16:30 +0000
Received: from MW4PR10MB5749.namprd10.prod.outlook.com
 ([fe80::9a04:a919:657a:7454]) by MW4PR10MB5749.namprd10.prod.outlook.com
 ([fe80::9a04:a919:657a:7454%4]) with mapi id 15.20.8026.009; Sat, 28 Sep 2024
 23:16:30 +0000
From: Libo Chen <libo.chen@oracle.com>
To: Yordan Karadzhov <y.karadz@gmail.com>
CC: "linux-trace-devel@vger.kernel.org" <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] kernel-shark: Multi-thread the computaion of CPU graph
Thread-Topic: [PATCH] kernel-shark: Multi-thread the computaion of CPU graph
Thread-Index: AQHbDZhDf050sLbWj0SN4/UVfNMw47JtS1aAgACSUoA=
Date: Sat, 28 Sep 2024 23:16:30 +0000
Message-ID: <5A815F28-ECF9-40E5-BC64-96BF6B732DA1@oracle.com>
References: <20240923090912.1261220-1-libo.chen@oracle.com>
 <66ae1d0b-8c24-00aa-e89c-515c545ca40b@gmail.com>
In-Reply-To: <66ae1d0b-8c24-00aa-e89c-515c545ca40b@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR10MB5749:EE_|SA2PR10MB4601:EE_
x-ms-office365-filtering-correlation-id: 49299b07-9703-4f5b-a9e3-08dce01395b8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?vs+diSF6HVu4xF9O9zpOkXtZe6gH2l8zW8lYRouT+7zTUuejOhMyr/rZUZAL?=
 =?us-ascii?Q?DSpTK5AHvwf5mz2mc0WqogCh3PpxGdwE022uKwsSuzMwkwr3dPMLSG1SBh4C?=
 =?us-ascii?Q?INGxaYcGSxWH/Lnl6rB1l2dvQN6cJX6s15REmyXJNjBvIE8dpfLsQVL7i8a/?=
 =?us-ascii?Q?CespCReUCsW8D52X16uNn8+0Z886S5vHS7FthNt44M7XqhkAQqJDxwkXQZQh?=
 =?us-ascii?Q?F4u7qIAYKvNbhUDHGefSr4rNayTOCPoc4k7ylk3oiRkpYlsj2A07quH1vDmr?=
 =?us-ascii?Q?juojoUIPqoVPM5uMhMKKdrdHHN98XHym5jTLRWh7pJEHyjkf17b1OhJndztP?=
 =?us-ascii?Q?duQFxn7y/S3K5dn0kByEIZMSf81DWKcaK5KJKOJBia0L7RY9MCJKrfKhNnrN?=
 =?us-ascii?Q?L4s09xEVJKmBudrG38ZisYB8Uua4mgSn6DsJpV+kTB7eae6dxBH2b7BKFkHy?=
 =?us-ascii?Q?Iryc/DQ4g/0NKojgn9Rg29HcHq8hDMhbPTy/faJCgyK8O8hmiB9aTLlxE3Er?=
 =?us-ascii?Q?AfGHR7IhfUsWVjsoXrm4b5n+FFQ49AJMTpL6P77mWGLjj/XXU/beWSbZ0Avo?=
 =?us-ascii?Q?xXDipynK0iGOzR3jACaHwhYcfjS2gNtKyJY49tK7rRZpQD9GMu8EGUVPwMxJ?=
 =?us-ascii?Q?+eq2FDQpP5jfzTiqjgPDGHvIPQWnOx3M64/mO/7i2KKE66TP9/cghG0Opldb?=
 =?us-ascii?Q?KLXy3QA+mWeVZIPfbPhm5ACRa29EPaJw5xdwz3325tRu9D3itNtSOH8rGdss?=
 =?us-ascii?Q?Bq9EURKRFbh8pg3z9cVq4HQ94Jl28UzmSQP8htX9XpeGT1ushFfgkK7YGB9G?=
 =?us-ascii?Q?P9SUVhcsf1cZ0Vrd1xRTG0r6583q7SURp8ookmm6P8qAhWL1DidxsO/penkZ?=
 =?us-ascii?Q?3PDnfFlkD0zE3Jt/1vdcw/bClBk3uKdspBePdItw9y6/UzN/Jc6qnOqtJjpu?=
 =?us-ascii?Q?bQHxhBCwCE3y4nq1ScMf7tqjybwmqlnUJK3muUB61UtRt3yN6IenZG238596?=
 =?us-ascii?Q?W7H/zEl9jJmzF0ym1Mc2RgHK9/qoiRSI04KTseR2wlOs0H/Spqoz9Qakqr87?=
 =?us-ascii?Q?LgntXjAUG9l1xTXKOFLnOhJzc/moAs4QiD2pS81TEf6lIZFLIDqBZqlos7eI?=
 =?us-ascii?Q?zhAARf6c+FtSbev5W+AI61aG8V0gFb7HGGCFJusDKaSEk20wSPjH3+v00eR0?=
 =?us-ascii?Q?sZWll94/YqLQLaVJhuF4FaHAgFCR9H7n/vczOpQUNuiXkvqCVwBIpeO63OwP?=
 =?us-ascii?Q?Y3IEKIC0wIW4SrMHGTQNgP3lKkNWDB8HKTh9OnncfWTnoMDykb3/xiriv1jg?=
 =?us-ascii?Q?8LKInSJbB4xVzg5/OwZ8mTa5R0RZ4wFIiFzoPy6QIGIfNg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR10MB5749.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Os0t3W+yTUh19m309KZLKu95XlCzaksHz+YYCPCHPMa3hxdcfzLi26EZZdm1?=
 =?us-ascii?Q?RlH6nzDfVNpM+ZERCruA5ojE8MS9Fps8zWHYa2qsZuBbRUdqIBQJqy1m7uQs?=
 =?us-ascii?Q?hJ4DPUWJPKUeVP6O8ZbCP/ImIgR2dkWWbGJ540C28cBhjUW9rVjlvbsXqP2U?=
 =?us-ascii?Q?tSuquUtgWMxnuLoFHYqwuB1KEEaZEgkbi7A553yL6qfqXmZVrfrB2jnOxH9L?=
 =?us-ascii?Q?ZB9Kok/sWTb9aZSkLt+YEYwfsM3oy1oimEnUOAnrTKpZ2YK0xiuQFHKIVSPo?=
 =?us-ascii?Q?sJeJw9rx6UVdDjmkYf28OZ7fnxHuTbzM0wwJHop1FFsifD+PGI+vF+bX/aXy?=
 =?us-ascii?Q?q4FKD0g46882QX/vAMNcIxbyjKcTSv90WUz+CG5shVvQWO+XuzYIiwaTDhh1?=
 =?us-ascii?Q?FJ/9qzuzT/ytsaRMC63RA3y53CsnLuteORrzDFY2NN39ihcQ8GvZe46KomjE?=
 =?us-ascii?Q?DApxjqwu5ihf9pkx95wPfXVfSq5oazrPlW/1oq8eX4oA78Hh8PLcUIY5RZ3+?=
 =?us-ascii?Q?ZaX3L9hYRqMcByZNED4rfHzxwK80pdb3I2cXzSqfnbTdk5LdESgtRsCNNuIz?=
 =?us-ascii?Q?iIBUixEOE15ibNix/uBN3tau/PXFp8Fj5wQCdUBSxoYEW7GOUmSe8x6hRs+z?=
 =?us-ascii?Q?E6OHn2Xm0RJ5sKcvjZtImspgzeQ/kAH+0jL9mEWef0Q8gvRn96pt7XsXg7Gd?=
 =?us-ascii?Q?gUmtK98nz0UHa++U1ZkLM/7snImtu0I7kP6GOq+JvpV85McAR4jxokQXEClS?=
 =?us-ascii?Q?inRWKk/VtocR+4SuQ4IApVaS8xApSkKQsYUkh9SY/6IZ6Ibe3Hu+soX4bL9a?=
 =?us-ascii?Q?ra3xiRAOtd1kK7YkgO1/Q3emDjCPLB2rrgnx2Yadltjm952A9RxJlBiiprQX?=
 =?us-ascii?Q?z7eZRv/4STXtTSIc098ZwtVr42MwZxwqyzlkOFzFBQi2WLajCJOtkFGHF37b?=
 =?us-ascii?Q?jteRidqzQr0X1rZ8eVIF/wA8rUC3natXEoCjJORwx8jUxT9Sg1wErnUcufQ+?=
 =?us-ascii?Q?US3ENyAlHEx9k/INmwEPeUjLBebqgxKZO/SbiIxvwAjanxWCAGYhV8Fq9vWq?=
 =?us-ascii?Q?PunQGHAnCzaHli95cMd+afQwSkq5asxjrR2CVSXlUI2hOSNRW7UgVu4nWGEy?=
 =?us-ascii?Q?Q3AHTesS5CYZxqNt/DxGNogbyUEcB4fkJ3ULrtgE9OYQZ36DKXN/+T/Try6b?=
 =?us-ascii?Q?3zq585y8BB9P/iqK+mQtmU73NRxZm0B/d0HEp5ATEBYyU5ZA/miywyGrnY17?=
 =?us-ascii?Q?3e2xubtU+TDoIx6C3AyECOu0zZdD3BF8dTHA2iAk1MnRESR0mKsP8cjD4Ibo?=
 =?us-ascii?Q?mIxJbc7sgRUVpneGhlmKAst5XJDLgTgXJBQaUHDQGajtDzY/E06+C0fFGyZa?=
 =?us-ascii?Q?i98z6G/ZyQFUmTRuQ1IPG200vDQRqZQLquuqykqZqtFzSO5MUaU9AFxLGmtc?=
 =?us-ascii?Q?jC18aG4Okv7didlL3VN4xNvkygDTQPsFP6zCM9MRvP87H221w6Kxf34XFwb/?=
 =?us-ascii?Q?g0houxfAh4t57+XlvAjz0eO171G5VL5DJWB+BrI5LFP52N3tEYEFnejzHNg/?=
 =?us-ascii?Q?7flz4Bj0osz+NHJCJKLZIvnui8TL34AyO5UMuCgM?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B9FB930CFF7AA446B3175A0ED2709BEA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+nD3qu4c8AmUP6+1vhJPODdO5owvTAGJseF2Hsgc/Vjd3LE87+2FTvVTCpN/O17AD25d8eIALXRCgSL1ZEByGux6j2zBXiZKjspio3jP3KFEm8nmtvL4uFCzQ9yAt4fUZFRYPQjOa86820m98VJdsGl4tQqKqcIYVksRR075kGQjNeve3XTgrkyOlI+vEBLSRMWRVLjIrzyG730JuKSJI5lr+Jdqi6zpdVhv6paGi1V+YnarBP7gy5vWFEcUJhKyKGTt8qoih2FHFUe6AZDQRlPtS8LvU0FJimE4SwJl6m9PtdvBjSgk99ua5MHG5k+/oMZBYJQ0VsNU3oZlfbOZ2UZtq6cch8QWjyhkjK4+F6PBynryx45VXYYtbnjJr6HUDS8QxPF/kyENkblwsceTi8z3IRK1pn9DT4HxzxWDWK/HpNTFP5N9NmLJvhqzKI148SYYDQ+jxtEqMP/BRm3xqOo6cHHVz/u28rpqJV0k3+37tAt2THsx/ZEuxxaZeT2aVAa7TXFnkPx+jQqGbcMOJWjT8B4/G6EfkCmSr0b+Psogz2EdryxFE/0Xeth7Xyc9iXDANoox/UpBXbGlW1WemQJINkgF9O3Kae1rbCvQtYM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR10MB5749.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49299b07-9703-4f5b-a9e3-08dce01395b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2024 23:16:30.0255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MZ3Cs4AAmrEMxzpLbX40rIKRzLbgXE4m202Sb5uyBAKcxKtdOCQZ+lu+q6XNo/LPk3W8JJ/2m5lMGXAJ1KvjSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4601
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-28_18,2024-09-27_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409280179
X-Proofpoint-GUID: n5Nnp-HK7G7j1j8dWZSRmJ0OqNQo5vZH
X-Proofpoint-ORIG-GUID: n5Nnp-HK7G7j1j8dWZSRmJ0OqNQo5vZH

(Resend in plain text)

Hi Yordan,

> On Sep 28, 2024, at 07:32, Yordan Karadzhov <y.karadz@gmail.com> wrote:
>=20
> Hi Libo,
>=20
> I like the idea of the patch, however a bit of extra work is needed befor=
e merging it. See my comments in the code below.
>=20
> On 9/23/24 12:09, Libo Chen wrote:
>> Parallelize _newCPUGraph() calls to dramatically speed up
>> graph rendering particularly for traces from very large systems.
>> OpenMP technically is a new dependency here, but it's so embedded
>> with GCC toolchains, as long as your GCC is not older than v4.9,
>> the libgomp library that comes with it will work.
>> Signed-off-by: Libo Chen <libo.chen@oracle.com>
>> ---
>>  CMakeLists.txt     |  5 +++++
>>  src/KsGLWidget.cpp | 15 ++++++++++++++-
>>  2 files changed, 19 insertions(+), 1 deletion(-)
>> diff --git a/CMakeLists.txt b/CMakeLists.txt
>> index c36d757..8dd9ff9 100644
>> --- a/CMakeLists.txt
>> +++ b/CMakeLists.txt
>> @@ -84,6 +84,11 @@ set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
>>  set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -Wextra -pthread -fPIC -fno=
-common")
>>  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pthread -fPIC -f=
no-common")
>>  +find_package(OpenMP 3.2.5)
>> +if (OPENMP_FOUND)
>> +    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   ${OpenMP_C_FLAGS}")
>> +    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
>=20
> The "if" must be closed.

Whoops, will fix that=20

>> +
>>  set(CMAKE_CXX_STANDARD 17)
>>  set(CMAKE_CXX_STANDARD_REQUIRED ON)
>>  set(CMAKE_CXX_EXTENSIONS OFF)
>> diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
>> index 9311d98..00a1951 100644
>> --- a/src/KsGLWidget.cpp
>> +++ b/src/KsGLWidget.cpp
>> @@ -13,6 +13,9 @@
>>  #include <GL/glut.h>
>>  #include <GL/gl.h>
>>  +// OpenMP
>> +#include <omp.h>
>> +
>>  // KernelShark
>>  #include "libkshark-plugin.h"
>>  #include "KsGLWidget.hpp"
>> @@ -690,10 +693,20 @@ void KsGLWidget::_makeGraphs()
>>     for (auto it =3D _streamPlots.begin(); it !=3D _streamPlots.end(); +=
+it) {
>>   sd =3D it.key();
>> + QVector<KsPlot::Graph *> cpuGraphs(it.value()._cpuList.count());
>> + QVector<KsPlot::Graph *> taskGraphs(it.value()._taskList.count());
>> +
>>   /* Create CPU graphs according to the cpuList. */
>>   it.value()._cpuGraphs =3D {};
>> + omp_set_num_threads(omp_get_num_procs());
>=20
> Not sure how setting the thread number works in opm, but I would guess th=
at you have to do it just once. If this is the case, please move the the li=
ne above to the constructor. Note that _makeGraphs() gets executed almost e=
very time you do something in the GUI (zoom, shift, select event, ...)

Yeah, I did think about setting it once but the only reason I was consideri=
ng not doing that is one can plug/unplug or online/offline CPUs while kerne=
lshark is running. This is somewhat an edge case on baremetals but could be=
 more common in VMs. I will take your advice here unless somebody in the fu=
ture starts to complain about it and TBH one should probably not change the=
 number of online CPUs while having CPU intensive workloads running.=20

>> + #pragma omp parallel for
>>   for (auto const &cpu: it.value()._cpuList) {
>> - g =3D lamAddGraph(sd, _newCPUGraph(sd, cpu), _vSpacing);
>> + int idx =3D it.value()._cpuList.indexOf(cpu);
>> + cpuGraphs[idx] =3D _newCPUGraph(sd, cpu);
>> + }
>> + QVectorIterator<KsPlot::Graph *> itCpuGraphs(cpuGraphs);
>> + while (itCpuGraphs.hasNext()) {
>> + g =3D lamAddGraph(sd, itCpuGraphs.next(), _vSpacing);
>>   it.value()._cpuGraphs.append(g);
>>   }
>> =20
>=20
> I wonder why you add this optimization only for the CPU graphs? Please do=
 the same for the Task and Combo graphs as well.

Haha, it was intentional. I was just trying to gauge interest on this optim=
ization. I will send out a new one to include other graphs.=20

Best,
Libo =20

> Thanks!
> Yordan


