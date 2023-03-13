Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D99C61DA4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Mar 2023 15:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjCMPXy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Mar 2023 11:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbjCMPXx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Mar 2023 11:23:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A4851C98
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Mar 2023 08:23:49 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32DCGauw004881;
        Mon, 13 Mar 2023 15:23:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=LLf4NIU3PXz3RUbFoXCNBnWNCw34DhMI0MGx+A+JCRw=;
 b=eGpX06Qq+aokF+fqnSaHVdpKEWnO7XDClznxRRPmPzQtdyOcCEz/XVrRxtGbfjtKJjBm
 WbiChRy7BZWs/evZXVkBoeL149pj5+IaV0kbe9YVToEvCarFFzUxW2QQWUwuRa0g0g4A
 8n83J9bWZrSSyZRcKejPi0zjRR7p+q1ros0tcMUQ+whpE2MHNOMMG/b5BV37AkGR9RMY
 o1i/Youn+FMZPbNRUKpwWQc/00BxIKbwd2FR7os5eTH/ZcdKQMmmMQsYgLruj9j+ej1b
 OTDuASZxqC7zXVWRCfEhMZu8LVJWGUAqhVsQI2/DonnkMpUx+sJ2U7nBe/LxcysDXqqi 3Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8j6u45dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Mar 2023 15:23:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32DESYIX033520;
        Mon, 13 Mar 2023 15:23:45 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g34jhge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Mar 2023 15:23:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vl4K+Sb2+5XVgk5hfc7LZhoq0zQiNg7jXH+fr4DHa6kNDouPphPBRg3dpeog8mLwUkZjuD8lF02f/plRAJB0Qez1j4Mb5TjRGGwWBTTr0uMwkhiqvQXDI5V9oS4DZVDcOqriTjRcg6qF8bW058CI5q6Bwk32p1uigku4mjrjkbTzHxMSsQnrU7B+NH5NbnxXKqpzLmYYzzyX61I9q+qYPf6jhXum5TKvSHaNtoQUVCzJq/N7kaj+B+HcGtrHdaJDLdVu2TaLZ7bTL1dqh+S9lr0qnMEK8E8rloP5dwYna57rtbkMlQp7Fe4FhzcO+6iW4S3biSDsaMtlcj+0LXrQ2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LLf4NIU3PXz3RUbFoXCNBnWNCw34DhMI0MGx+A+JCRw=;
 b=UBqo7EB4DMEwcnBe50J4UBnLDSkzt+tU/BxfwHqCrQPYgtYK4V9Gvmzk0H3ztLiYfFXSHxNAh0eHQiLJUmAhCcSpQSbWQOnjZkLDRL9blqYNO0hq/d3UKYgUfL4xlbXUMpWg/37xv5P7Mndu1Ozj6Z32VywmBkkvq9xCiidTlcRigXIMFOeNVBKfM+gjbzVJb7yAPZe9vbhYyUD/fGpGhbeDNcaBZVbUD80NvxD0kietiRe+Q5RmOsfk6zna1IFXQRGUBSL4ub93gtaWRUcEt1kxOFZopLiISVB+yQ8IZhDyBjfvBch6duBjKuvo/0vhD3cZ+/lPhlidkvDrSxi4tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LLf4NIU3PXz3RUbFoXCNBnWNCw34DhMI0MGx+A+JCRw=;
 b=mH7kRuF2tftuNIJ9l8CAkclxFYcfo6y+vTS72PxmqvSx1nVRz2s/UnxXUcPXGhCzE4K8BSt1Pc2nhV+YfD+u5eZQb/2jXqZv/YXZTK3OqSFUIGJ+2ddZf2k32r/aYEXGR7+KbS/3fZwiJJBZxWKU5NpSp089Hm1B131MBgfQoE8=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BLAPR10MB4898.namprd10.prod.outlook.com (2603:10b6:208:327::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.25; Mon, 13 Mar
 2023 15:23:42 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%6]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 15:23:42 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
CC:     John 'Warthog9' Hawley <warthog9@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: _sockaddr still not working?
Thread-Topic: _sockaddr still not working?
Thread-Index: AQHZVb/LQSMVzPPu0EGWr2TgWaw8FA==
Date:   Mon, 13 Mar 2023 15:23:42 +0000
Message-ID: <AE6938E5-462C-40D2-8DB2-97704DF40093@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|BLAPR10MB4898:EE_
x-ms-office365-filtering-correlation-id: c552cb6d-b05b-4a65-8311-08db23d6ee20
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UeiRlYJ8Vz9kA9/nm3CiD8sq0KiLxElzdZWRa4mXoKw+UYMfncErgYcdlLSr4wqwvPriZUN4uyqPDvPns3AkUxh6ByiMzdWAVo0MZPnbb9UErMVs7sY8vX4Ya65AflBamJTaCXzEGIC4WXwJT+ObumZzjIGcOteRrLd0SsrdN6YARzg3FJjvF2lQX/I5COXC0WeFrqFONlEZxV2LAvglLf/bab/cUNjEzK6fVEPSTchTIlk0KebX/Z2FcM2YZxH/QVMT1R+3iTZjtn/jImm8PFOoUqHFRciWBxLoAY58P9NJY/zKaVQm93VN9qBHG8aKlbVW6t+dEgIDvAIUqzhSYFe9FwKuLJSzKIn6NzomoBbyFUvRhg7E16gHRnfg+xpb0IXj1b8qNX9uVrEIyucbwDyqSz4Oe3M9fX0oKbfsG4AkxGsonpyQHVhcGivNXFr/jfdcgHXTDHRY3tYlQnofP9lwwogtaB+5QYSzgu+U4eTODYsQhG8zO8xGS1OPSaQtPuNwDDP2Nxi1ccYZcmS5d9Lhb4/c3ZEzYjH2jo+V7ZWx2SHrvua5SeFSejXL+ia0smpq5li9zaA1K+H3wSW5kqnQsSqHMZdzBuRLXspyfBJgFKlncSzRgRs0M6NK5/NL1PvRCA90ENGa0+5U1tMS+aNOyZNYvnaQy3i6SpJ560tQCj/bnfj3xsUF/zycX3F2bsssRMRn/mtTbQ7Tl5rK+iwR8McJDAsOMqOyDPu/+TE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199018)(36756003)(86362001)(33656002)(6916009)(26005)(186003)(41300700001)(6506007)(6512007)(5660300002)(4326008)(2616005)(8936002)(316002)(54906003)(71200400001)(478600001)(91956017)(66446008)(8676002)(66476007)(66556008)(64756008)(76116006)(66946007)(6486002)(122000001)(38070700005)(38100700002)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mGls938r3S34gcfEdxxfRB8JSYMY+/l9q/KjbxXlnTWRNPs1wIKBojzrOqS0?=
 =?us-ascii?Q?Qw7ngH0TJe/rX1JixVDkgr4O7qVOC5EFpVD9QCTeiPcuADumKNbbCao5Jwin?=
 =?us-ascii?Q?Frw2/zme06Dbta+yAWaemZrqh/rABJ9lJhCKl6lIMxZk1VbJ5cDKX6tuHm32?=
 =?us-ascii?Q?nOJCj/3Plo9x8DaStO2NZAZdQdR6KD17jphSYSlfgx6+ZDR+aUvlmCe7qcpJ?=
 =?us-ascii?Q?7q4wiCaxSQ+CbRNAji4/MkHwxzZEFw5AEkTHRuTydAknXNg7ks3JTuliKhxH?=
 =?us-ascii?Q?6AhO0hE19xE6YVpbNjPTvHuJ6noYxenVTZe4IHvNxuDLiizT6UkQ2cXMj3pD?=
 =?us-ascii?Q?M43WdeKPIZZfG3tty5GbUixKW3EQjQRAlcHRF5xUtthiG+RcZp3mbWMZ9a6q?=
 =?us-ascii?Q?ilYn7wKPM6fEENNghaeOW19VEFilsm207JPF2J5HSk9eLu8Sj1+u45oq/+0q?=
 =?us-ascii?Q?CleRcdnyboNj4hFAjFXPQbukZEE13FNcoRAIXzmqSC92Sre0t4RTMZ4E72J3?=
 =?us-ascii?Q?ni1MEJ4HD/Y3FU+6FCCcDa1C53efgxvpci/KSn+UIIaHkisL3rHwz55CIb+l?=
 =?us-ascii?Q?1UjHwADikqZdp/sV6M4Hgr3VnHRUSWzbvKzPUszwK4wFEen/cnnfB69VsGtD?=
 =?us-ascii?Q?ekorJPqKm2NsWx9o+1wRlQYCNivs+nH7AF4M2ITMRAugHnulbmVrWjiZvkVp?=
 =?us-ascii?Q?CpP5MqVN+4xEUWn6hsJMwd/IpCk3GoXTe3owgnB9w0SZqKUBXGxLz80xKFWI?=
 =?us-ascii?Q?njuok+8BGkvtqad/e/sDuh9tYlr61kKxMbSHFKqXzX+C8FKemeSC+oSS+Nt1?=
 =?us-ascii?Q?xfu+mALMlDV+nEB5lpVXZ0Q/AS4+oldkhYGiBAYETC3VaQ3erkNH9Kcm0xD+?=
 =?us-ascii?Q?fMYpQ6FUtCCw/wx+QjJfbMgWLb8mF8aJMnYX+k8AkJz2rdrLGoCOQ5M28PhK?=
 =?us-ascii?Q?SxQV/zRxZPxVTgR2n10vSeaCq5Jii10G2rHAuHryxPdxnkDSMgH6ml1LMsgc?=
 =?us-ascii?Q?1az5Vt5uzk8FEaI4CyIS1qPY1tkyhtfrdwSiygb4uLzvz0iq5XKOTYj8Snoe?=
 =?us-ascii?Q?pHfQTXZ4jE8cbUpcLL2yrsq3qm0zc2xvzP7vR+fGKgnBGpvyXCJf7BuvU+mU?=
 =?us-ascii?Q?1fuCWnY6wPFRfSEev31KuVAd5r+8Rie/df8+vaxvGXeNfo4o2xkkmNuUfHIt?=
 =?us-ascii?Q?Ih3n7YvGJdslouxqZokH2jpddSMsZbru7uoItsmo9uuUfJ9HxTNuSQp5CSQY?=
 =?us-ascii?Q?p5eA6UGYT0DjKOFNVlEl+PDh153cGxZ9jJetmJGwE3Wd9mp5J2NkSTaMCDl0?=
 =?us-ascii?Q?KtRjOFXJOsFf4ri4fx/80++M4OLdcitMXVa2E6Ukm1MysEqgduG6AqehBIS/?=
 =?us-ascii?Q?IDQrZwA2Dl2xt8jed+cipb22GQro58SmBNFmishwNy+wdEPoUITapqfDYAX5?=
 =?us-ascii?Q?coS407juoeXTn+6aJguG7TeQSmIw4NlSc28S8RaIZixI9EGz6ey1EQS/QLJ6?=
 =?us-ascii?Q?anpMbhbcMvvyegJp53KjilAdyLY2KamRcAkWiC3fUEcYiyA323N7yo2C0cem?=
 =?us-ascii?Q?kmsMJ9tyTzu5IA878Y/okuaDwMBmULbJJSHb9S9YWjv8qM+YhjEIQhsNDjCU?=
 =?us-ascii?Q?QA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A9C1B4E45303DE46AF7AEB6DD83B84B3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: fwISq4DlJmDiVR9QCo+1b83AtF+ml38X54opb9HO6uUQ541d8ovJ7IVht3z0t3AYJqlldBRo7Umq2IIFQM39N5TzJupZeHKfFIwqIh6bpk/wxJDl1gt+7rwTogf1KgjXiXZTGtAyl2VWk+kPbvIsGorKvbwKxqQ60o2e7ZpDLb7sR6XCrimRPusm1VhjrjMxh0ACUdFaZGL3oqGzj7JS34C4KRA/chSAqvppf/Bj6u0v9phSUtE24ZsKw7tWbgj607ABeX6YSVvSyRUpD/OZabLG/O6iwIFgFbJ/e2cKkNUhbY1HLmZ5zhYqvjsRiBuXYxy0OgmSWs3qHJLBmjdDYzd5dpPsY2wG+FORo+YI7Tu6g/gVCO08/IUXNKWQ8kV59ldDp5Dsj9o3QdHfp/SZujFtrEyRCSugDAKtZ+hen6MqS9rW07wZA+eChPajJSMaGJtbsUaOimR/eIxKIwucLuMXd+FWlAHp44q3eyiTYDg7munTYuJAdmGnmhhk4Vzr6ATIj1Kvk2eKVmtXNHC+RkTNdE3HpbPSne97BdY0XrWx+8/aaX6QAtqFvs/lbv60s5Z8CuqcOnbRnzIWcBUsdSSLB+vKyOOf2trlN/ltC0E1zGkXr/Rue+ezW0ZHWsyukKBHzER4x9hVDpCSAfp0MRYUg3FZ8bN7zFaBuRVu7FWhHvx/PYyobDupsQxw/z7ekGd6jB+So6OkYUCWBvByrgxy1giPyt1eJP2csHAuoJb/S9Al4EJKXPnez5MiQ5KQxWqyy9rq63EGYEK5ODI/eKYtjdGQ+P6ObCzxHOeLzPEU9IbnkaA2O7PcbadK77J5
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c552cb6d-b05b-4a65-8311-08db23d6ee20
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 15:23:42.7513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0fQyU7XFQC8Sa4KzRsxn5CoZxTSeGITzntg2flxWfLL8w/znbNMKrFMfIwKRF+/OKEa/q3Djn7y1Cug/EqvZBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4898
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_07,2023-03-13_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=422 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303130119
X-Proofpoint-GUID: RyA8-rho8nf09_4g1DssyFU-xZ4l2vN8
X-Proofpoint-ORIG-GUID: RyA8-rho8nf09_4g1DssyFU-xZ4l2vN8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Sorry to be a squeaky wheel, but I've got a system running Fedora 37 latest=
 and the _sockaddr trace macros still are not working:


          <idle>-0     [004]  1016.727319: svc_xprt_enqueue:     [FAILED TO=
 PARSE] server=3DARRAY[02, 00, 08, 01, 00, 00, 00, 00, 00, 00, 00, 00, 00, =
00, 00, 00] client=3D<CE>mn flags=3D0x4c83 netns_ino=3D4026531840 pid=3D130=
2
            nfsd-1302  [005]  1016.727358: svc_xprt_dequeue:     [FAILED TO=
 PARSE] server=3DARRAY[02, 00, 08, 01, 00, 00, 00, 00, 00, 00, 00, 00, 00, =
00, 00, 00] client=3D<88><AC>K flags=3D0x4c83 netns_ino=3D4026531840 wakeup=
=3D0x2d
            nfsd-1302  [005]  1016.727513: svcsock_new_socket:   type=3DSTR=
EAM family=3DAF_INET
            nfsd-1302  [005]  1016.727526: svc_xprt_enqueue:     [FAILED TO=
 PARSE] server=3DARRAY[02, 00, 08, 01, c0, a8, 01, 33, 00, 00, 00, 00, 00, =
00, 00, 00] client=3DARRAY[02, 00, 02, bc, c0, a8, 01, c6, 00, 00, 00, 00, =
00, 00, 00, 00] flags=3D0x4819 netns_ino=3D4026531840 pid=3D1300
            nfsd-1302  [005]  1016.727529: svc_xprt_accept:      [FAILED TO=
 PARSE] server=3DARRAY[02, 00, 08, 01, c0, a8, 01, 33, 00, 00, 00, 00, 00, =
00, 00, 00] client=3DARRAY[02, 00, 02, bc, c0, a8, 01, c6, 00, 00, 00, 00, =
00, 00, 00, 00] flags=3D0x4819 netns_ino=3D4026531840 protocol=3Dtcp servic=
e=3Dnfsd

These tracepoints are no good until _sockaddr fields can be parsed by user =
space tooling on everyday distributions.

--
Chuck Lever


