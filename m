Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8E0C6FD1C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Mar 2023 14:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCNOvy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Mar 2023 10:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjCNOvw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Mar 2023 10:51:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DF7664F3
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Mar 2023 07:51:49 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32EDsPlH009587;
        Tue, 14 Mar 2023 14:51:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ZsRuI5m86lLsYE7kpl9jq/LtE94vkJck2ZdRpcCJFjg=;
 b=NUrmdz2olsxWJXyDcqNK0A+S6fxITq0DCeG+lOXQyt4eXanfMWKRFCKkIWTygP7KrtTT
 +IGYXSzaVEY1D4UPlFDtJnAt3cfrHMxgsaG++xHGp87ovAGkQSuhHzkVwxFzdcXbFFjT
 zm0yhSy2CUvgKaHqI6+lOaVuiBS63atCV2yk7d+qzDf5YRG/4LFtzyCPoa+YOe4yXiK2
 xgT/JjOIGn0RdTKNIyCKZ3LxaoHGvT/11kkAlLWPZ6AomvPOK6TROyRCvvT1Vo6ScCyi
 4AAeRNfy9CXgaqYYrViqOlScQqyDKGi2Yjf9BgXAKfAncybkKRU9vn8XtD7a5/XClSIO rQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8h8tejpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 14:51:45 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32EDQJJC008174;
        Tue, 14 Mar 2023 14:51:44 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g366ngt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 14:51:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neZ9amYJ8zD8zSNYwlDVK0NNA6uHuynaMDRRdeDj0hoCchAtYEkcFn45I4q40UI40RKuDe+8b9nJAbUJl4a4PZyYenUCxRDcYga/OiCYm8hRR5ohsoWU7RtAMbav3sJAnsoe9Txzo960Ok6lFcske5yC6yn5rJcaEjuauVaclTlBNNJBTLZQE0KYFCGtQZoJRj1O9EVZTlXEHNSuPABkwaxAVR7JeV0ZWLXBwXXwB2WHseMvn7Xj7/jFd48RIKFHVyywsD4MlTpIWtrgKmhYJhMCa/L03fhIYOsa36Lwf/kpvVsdhA4JTsrShZc2Z82IBbA8/PJmkmojfI9oV3wNXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZsRuI5m86lLsYE7kpl9jq/LtE94vkJck2ZdRpcCJFjg=;
 b=m0n5r2jwzSbT/d8wjLx6gjs0/ReQyqNGYoDuO5XFJtNKSwJwtRKyQFUXN9BvHqIyg2wHcGQ69vT+Td2jPw+3ht21eYp0e8uXwc1cKH3lfkLBTZijmdj9x7NqPC6gLXOyVzVIrI59UZ4yPxW4iBLUkMNn5UDBQTnvkx72Yj1AJC5IUo0hKWCW6plU+Zve4IuRUN6dpVzJemRdA9yLd8IWayevRP4i9g4QIzozXMrIcprcl/NtFU2aOYusKANIJPGeGwwCKIa209778yanx4uTsQAdFMoKcVKuOBGe8wpfLgQUuzs8vmQr5pHYOkqAgqJ0eSRzzhWchKX5Tue0vyPI/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsRuI5m86lLsYE7kpl9jq/LtE94vkJck2ZdRpcCJFjg=;
 b=ZLXgrZdip8EY+F98M7E25Kf2wf95VcZwERsCqnWvzVuA+/xw/n6tHtnVfXEpAsz8sOxe0vqvCAm2Zp6Qx6I3dFXoZep0ntedDEegGFmtZ68nHWoC6ZOu9u2FizYSSjMN2aUF7GPu7TCbpogOWnTYfYtz4cmSaW/DOUYW4qYEYx0=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DS7PR10MB7156.namprd10.prod.outlook.com (2603:10b6:8:e0::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Tue, 14 Mar 2023 14:51:42 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%6]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 14:51:42 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        John 'Warthog9' Hawley <warthog9@kernel.org>
Subject: Re: _sockaddr still not working?
Thread-Topic: _sockaddr still not working?
Thread-Index: AQHZVb/MKRJrq69o80yOxeVPVWeVD6747gEAgAFveIA=
Date:   Tue, 14 Mar 2023 14:51:42 +0000
Message-ID: <6460A8EF-292D-48A3-8472-BA0409ABFE99@oracle.com>
References: <AE6938E5-462C-40D2-8DB2-97704DF40093@oracle.com>
 <20230313125628.12ac6c3a@gandalf.local.home>
In-Reply-To: <20230313125628.12ac6c3a@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DS7PR10MB7156:EE_
x-ms-office365-filtering-correlation-id: 4d36b37d-05d5-489a-b315-08db249b9fc2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: POoRQcRde1s6zMF1d/fS4vRtnBfr3rbMeUqMYhc89QKixB3JSp5MYy9I3V0fJA7NpyjJ81Gc21zx7r+JzUxDOGkU5AW5I2qT8Avn7n1OpMBIuPwqo/XX0sD8GcZ/7wOg4HQLgsul6Y3x/cKHMMe5CEwGt+VqyHcJE1ZzV80jbU7wDMOIQWuzR94fuvmuge3JlKmmQUoMsVQRUL9Hwki8FjqjxlZVOk0JB/Nx/FcYVdN4u9QXKdgTjH8kAKfDrizwOBgU9hLuv7SA3u0wz5G7z7iPBQH1wmeNLYCQUgoByHZL9UDA6NBI4SgPX3VvSF0fpStGN1Tpmlb40/SYeVLk/qGAJjmhcrBkoJJT4kLmdXfCb+KyiQ/XLp9ERDkUzlUnOKHAApujf/Y0UX5iSNxH2PPBBE+ys+qfgWHMlCH/omwBkBMOrWR80Vy1wVFUI9kyIENWLsBHJIqM6FoUixrjVwMtT9Mn44JrqYCkaVKN+AR/SibO/djhkWBJ0uSbW6bmSolrTW00BKjtntdYJo7IaiBF3BKuYvtc2Jpura3KwPa8ICSTeg1fzJY/jy3Js3YtZjDSu9y+VznhrgI3otoW73xfwpzu8muOGMOhjd4uOYXa2NmyC0bDOf6cvVFfhNIIaZHyx/f8q7lL9m2pvq5VeoXdK/4xeawSfRqhdRY+GYW/Zc5mNGUFhbKS7g+VplXJD3eMnklyabeI3D1ehoSX5pfigkRni3BnxDIs4F5DX3I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199018)(86362001)(38070700005)(33656002)(36756003)(6916009)(478600001)(8936002)(91956017)(41300700001)(2906002)(5660300002)(54906003)(76116006)(66446008)(8676002)(316002)(66946007)(66556008)(4326008)(64756008)(66476007)(38100700002)(122000001)(6512007)(186003)(53546011)(6506007)(6486002)(71200400001)(26005)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FJHV0FYS66ZHvqUQuIuOUuGfhAt2VbiKHaMkWdyYRC7pfmt0NewmKtXuvFIJ?=
 =?us-ascii?Q?R0CpPVjivEVryULb78G92uo7IVER/Sq+Whh9ZFvc0pq58fH1vwi3JJFuWhRP?=
 =?us-ascii?Q?QQUEOWAeUp3fmxpcN7BjFauuTUef1RtPi0/ea8tP/LEjdpM8p1GfPxuj3ZEy?=
 =?us-ascii?Q?HJ7PvRkQXOXz+qTTE2ahorot8ygEJ+tsublTqhtRVUaH04g6PSkk3yKhZDFp?=
 =?us-ascii?Q?sZ5g2+GQfgCAb/JXpBbnTiKNcznM8VbQaEKTIisufTJqlEddsUpiVf/TF3c0?=
 =?us-ascii?Q?nTZckPgTBPdV7uIbMSetK3CLgQJNiz/gCmPsia/egO7/oFZ29TN7rEqVP78a?=
 =?us-ascii?Q?ukZ84IUIEv3v9vnpsKTOPo9RGm5LTvXWnPMXTlCl4Lj0DNthWAhFlVC5oEf9?=
 =?us-ascii?Q?/875/Yd+ZWaG6ZVRdsJumcfaW0WNPjKiDgzVR9ENGCsa55nLg197PT4BVyre?=
 =?us-ascii?Q?XnypoyIonELfdmYBL4y1DBswwqiOZwDwsuYHygQhozCJsGwBs36Nnow1uYg2?=
 =?us-ascii?Q?j9AHF/iIU7oW05fZREG0n7MF72v9Xs7ir5KsyszI4PRpZmqXjSfnjMP8Ovwd?=
 =?us-ascii?Q?+nRnObdfpGn92foRMrJpIixDjsIrqZBlLTrxK9J3LWBBKqxCxYiT3Z+Vj+wS?=
 =?us-ascii?Q?x1Emz5XHqOShUm+Iz5/L9vnS7omqkCYbEQJWjAiQ008HDUYotaxru4q6/tj3?=
 =?us-ascii?Q?xlWiTMj4xnFtWZEev4Bl/6uAP3DnFk1jxLiZPlHoMxtXhJ9qJwELeOd3ROpm?=
 =?us-ascii?Q?h02xEZfhs+YFk/ml1VyttyxFPOPTDLeIMLRWlfxzBVKeO9G7yGMdJh5yQQLp?=
 =?us-ascii?Q?7BZWXrniYRA07i2ntqwMXLRS+vLzSCBiB3QjLMS94tYvA7Nv+9FCIYj1fRwA?=
 =?us-ascii?Q?TF414P7P179aogPki6IxcA0kwdyn/MTCsh3BCmej1DhhmA6WXlQX5q8E/Utv?=
 =?us-ascii?Q?z69cS0h12KqcYA8kr6GvTxl7kQV1Pw17PRJqhK0wNPuyX8nWhdEcWtMFl9a5?=
 =?us-ascii?Q?+MjHrATIpE8KLlvMYsAPEaLnCKTmu0EQT4RAN5hgjWovME6tExKYhxbH89Mk?=
 =?us-ascii?Q?DqH5w+iWbPrGSfWQyUBCGK3hQNAuEe+WTeJ5/rYEXYGmYE0aICcxcPh6UUM1?=
 =?us-ascii?Q?c8adNiDAP09pHjBpWBCtJgCT7ap+hgLpRnlKluyTkdjh7nmhejVlv+S/eeVv?=
 =?us-ascii?Q?tAcs0QgP/st8X+IR4ka+VKwYYA17O4dap9MtHtOLI95VZ8jRSCMGOCA/G+Na?=
 =?us-ascii?Q?75ClIfgigsjGXOah4jimR7+tnwJ9EyBQ0C0Gk1Km408U1luwjnfCSSwGXfTc?=
 =?us-ascii?Q?LezpZxVx1w1hzkAFSM+nsOJwlvtwu+yStkdtQOAIumgRWg8m27AiNh9bpd2g?=
 =?us-ascii?Q?Oj9JijNnoGvi/WReJCdYDmjfTIxR+bk/w5cghHQuDAl5cMAOlJFBUOJNrwOD?=
 =?us-ascii?Q?mk8hAY6qoBxSBQPraDp1h6OCK98ReaQVdu93mHdxL9wVt5X5o4F7SjFpJttj?=
 =?us-ascii?Q?8oq29IERgh4nLBbPMhhbE2VGrOYhS65VLM6WdqGGlnOH/+hCdTsoETQoCJQZ?=
 =?us-ascii?Q?KgLRdzqaSnQ6FsEU5iM+qC3CXRqSK0lnQLik+iaVM9Ozj3wLCtHtu9tFnfyU?=
 =?us-ascii?Q?lA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7C5E64F8F8E98646849C2DD209BCED39@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NUAnqj+ZPjWv04CarLEXhZRmTPXJ9NcBFKXfV2Z/hYFhtDxxpQ4XnmY0Q5NSaSYMO5cFb7v4IFDra8JOPikNMaipdS49Yf2UfDtR6DHgPTp6Yn2UVip5+G87FkRanAvUiUxOSFOj8l2v9JNM29Ak7PklUHB/6vH0BF1oHb5sRCw69TnA64v5WT9ob81Lf8Gtqk7iovalbZfld1uML4iNG4yLsmX8/5fvfp1Rr529PtfGyULEaQUsSjYsoVqlypw+JLY96f0DihmQvaYLwhhfetLDlL1QSZwnrFsxlravM9ryvbVFuwO7LGhNUCsrSe+knaS7uzHc4y34T4H8q6Xt8n8kLzDy8LkafsfC1kYA438LV62QmocH4DtsSKoV/bzExaVQ36YmgiQgSqWuPSgTPTYV2aaQatgDzw2+cfwK8mEYHVmmY1XrvPuQaUOvchJulvbeV+hIpGtgsQTEcmmDt2nfhuS0dcRb9Eqge72VUPFw0LyOezGmolTwRo7MpXuL/vJMfnxG1QzGwf1Mko8dZIEkFj8jDrejOKUbj4b93nP7Bd7G6j5WnovJNKf3z/6S/n5/GFmRTDE0g5E1eNVomjMC9bKFlarWvONMC9oLcKYeQejMIVgRq2qA9YXknGyoAJuyyQGOOiIJIFy7RvYUQnI6Nk0DvyOf9htScINtdim2n0AHUaZkyq8MhgakAI8EkIrvBHi6syyyx1imiS/UfyekGlLtBqviWIBSP2a4d32wehXEIfCfhcQP+ig0VuD8dxaJR7zm+d4/r/4uCSr+u8xlSU3G3Z/aVRiJeepzDMwMZ5vdWOzD+EzqcwR9FsOW
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d36b37d-05d5-489a-b315-08db249b9fc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 14:51:42.1300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gnk2UZh/aBl1+dTFA1d0MNg2e8woPvV+oFrLfVQQIh/qKrkraARxCWveCBui6ZSoV3PkjUKLtBzLmkAJJ+ZFGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7156
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-14_08,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140125
X-Proofpoint-ORIG-GUID: Zl1JNL_bAX430GZrDKiX6VTrrw-CNhN8
X-Proofpoint-GUID: Zl1JNL_bAX430GZrDKiX6VTrrw-CNhN8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



> On Mar 13, 2023, at 12:56 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>=20
> On Mon, 13 Mar 2023 15:23:42 +0000
> Chuck Lever III <chuck.lever@oracle.com> wrote:
>=20
>> Sorry to be a squeaky wheel, but I've got a system running Fedora 37 lat=
est and the _sockaddr trace macros still are not working:
>>=20
>>=20
>>          <idle>-0     [004]  1016.727319: svc_xprt_enqueue:     [FAILED =
TO PARSE] server=3DARRAY[02, 00, 08, 01, 00, 00, 00, 00, 00, 00, 00, 00, 00=
, 00, 00, 00] client=3D<CE>mn flags=3D0x4c83 netns_ino=3D4026531840 pid=3D1=
302
>>            nfsd-1302  [005]  1016.727358: svc_xprt_dequeue:     [FAILED =
TO PARSE] server=3DARRAY[02, 00, 08, 01, 00, 00, 00, 00, 00, 00, 00, 00, 00=
, 00, 00, 00] client=3D<88><AC>K flags=3D0x4c83 netns_ino=3D4026531840 wake=
up=3D0x2d
>>            nfsd-1302  [005]  1016.727513: svcsock_new_socket:   type=3DS=
TREAM family=3DAF_INET
>>            nfsd-1302  [005]  1016.727526: svc_xprt_enqueue:     [FAILED =
TO PARSE] server=3DARRAY[02, 00, 08, 01, c0, a8, 01, 33, 00, 00, 00, 00, 00=
, 00, 00, 00] client=3DARRAY[02, 00, 02, bc, c0, a8, 01, c6, 00, 00, 00, 00=
, 00, 00, 00, 00] flags=3D0x4819 netns_ino=3D4026531840 pid=3D1300
>>            nfsd-1302  [005]  1016.727529: svc_xprt_accept:      [FAILED =
TO PARSE] server=3DARRAY[02, 00, 08, 01, c0, a8, 01, 33, 00, 00, 00, 00, 00=
, 00, 00, 00] client=3DARRAY[02, 00, 02, bc, c0, a8, 01, c6, 00, 00, 00, 00=
, 00, 00, 00, 00] flags=3D0x4819 netns_ino=3D4026531840 protocol=3Dtcp serv=
ice=3Dnfsd
>>=20
>> These tracepoints are no good until _sockaddr fields can be parsed by us=
er space tooling on everyday distributions.
>>=20
>=20
> I believe libtraceevent 1.7.1 handles this. I'm guessing that you are ask=
ing
> for Fedora to supply this.

Indeed. Not an upstream issue, then. I'll file a bug with Red Hat.


> John, are you still maintaining this package for Fedora?
>=20
> I use Debian, and it looks to be at 1.7.1.
>=20
> -- Steve

--
Chuck Lever


