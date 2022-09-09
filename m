Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C666ECAAD3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Sep 2022 18:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiIISBM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Sep 2022 14:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiIISAv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Sep 2022 14:00:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D635E56D
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Sep 2022 11:00:49 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 289G9NiM000489
        for <linux-trace-devel@vger.kernel.org>; Fri, 9 Sep 2022 18:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=7/9a1njiOSS9OqkLbXJWKJbXysyQrpmMvWYa1CtptbM=;
 b=ELZgT6UiTECDX44EG5gx4OpOJD7Mfe97YqkFBH8C/Thht132RQ+BwAPz4IDxqCsBQk34
 8+rIc79qS1wXKqS1FWEDG9aMAsNnZPsc6xo8NT1bJyO2Wh92PX2YSTzSRknfD+0qRhBL
 c2Y03dUdHgY9s3Q3rOzsGoip7zOR5YpRcMQTYAFy5Xd41Iz3OcVfDHA3jKWr2GMzVlJT
 /79is/XWpCDOr5/ifTAWG+Rrsix2RajCy+hozVXZj6AK2FXp3ZGWwu6ftPB2e53z/zqs
 FLBjjccSMtF4Xe4M9SGw5r7+YV3SLa3Euqlr+XAuzWUleltEmx8RgzbtvCoa4XvJAPPF 2g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jbwq2r40r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Sep 2022 18:00:48 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 289GA4xS029277
        for <linux-trace-devel@vger.kernel.org>; Fri, 9 Sep 2022 18:00:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jbwcexcbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Sep 2022 18:00:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABZn4Pg9eNgfgancnESpb0NxK0yUjO4UO/WTm/+ONM7X6UgZLVDy9R62rpaKfVKvRPUMhPs9GBACve5Vg4qMKbBBahA2gxSYmRc7fwx+Gy7h8FDiL9/4m7jo+0rsPUN1EhPW6MZj/PqWdfUZsOO7Iz7T+KjVwGpVH4Tj7J+455FwqIqTN5LV1cljABHg0Td+k0MvojeLp0ckW1L/VqQRlTsPsslYTqzrclKsUt5z+Ixsj/LgC4DKwurf4rMGDZ6mGKn6Ki9AYsaSryGvd/+domz5XJRUymzEuXAlLS2kk/Y73RXtjqcLDwISkUPYGg63XdsGr33WkTQDCaXnrPfsbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7/9a1njiOSS9OqkLbXJWKJbXysyQrpmMvWYa1CtptbM=;
 b=apnruN6PNMXUCUxm/F33RPxlNqnL9JRraOo5zziP/cDMY1BLXma+g1CTaAnsSs5wvRSgmxwi9shXSrCKfAu0qMbhmd09wXpufCYKRjh8qCXZnJlOVv72SYQZ8Nw0X86vSU6zUYrXtbiuTXr04htYeDG0ATKHWcnRNKS3SLsekEfZNVUxS9s9Q+p5I9LlV6+tzoT8sfUtwtIz6C51FHTv1tgItmC/eiuGLgtQpD2ZMPUF8+cmuuLoAyn0IoeLWMky34oquKZ2eXVn7FDwgQ9KlOY+Dsy58BnZQ8hJ0AjFZnSW7w90zJ33Cb/aUoDItFkz9Hd2q2jzKiV8KFOByc/hNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/9a1njiOSS9OqkLbXJWKJbXysyQrpmMvWYa1CtptbM=;
 b=lvlwMqX+AnN/2ccOeWJ42twti3BHu3hf4IbtBAkSuxSJ8H21DygdHddttA4WhtnQzFkdSB2VfLTJZ5KQN7P5nAFJOMnECwzurA4Vvc1SrTT5Ii7O2Ah9F3TwR636Pl305qeib2iafkymhWO/PlCGmZTiFl7lc+yTfUtTDmNOoXg=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SA2PR10MB4779.namprd10.prod.outlook.com (2603:10b6:806:11f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Fri, 9 Sep
 2022 18:00:45 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::25d6:da15:34d:92fa]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::25d6:da15:34d:92fa%4]) with mapi id 15.20.5612.021; Fri, 9 Sep 2022
 18:00:45 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtraceevent: Add processing of __get_sockaddr() and
 __get_sockaddr_rel()
Thread-Topic: [PATCH] libtraceevent: Add processing of __get_sockaddr() and
 __get_sockaddr_rel()
Thread-Index: AQHYiw2z4Yyo8yAWH06ey2/yMR4Nza3X1gsA
Date:   Fri, 9 Sep 2022 18:00:45 +0000
Message-ID: <0BB398D4-F990-4875-B222-47826788836B@oracle.com>
References: <20220628122350.434ec8df@gandalf.local.home>
In-Reply-To: <20220628122350.434ec8df@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SA2PR10MB4779:EE_
x-ms-office365-filtering-correlation-id: 1584e822-2eaf-4694-9406-08da928d37e3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mbXV2EROG+FPkKhZ6wsDoasnK+r6+/jOZeW/OIKI+pkB32a+yg59ETVF/jx1SlDe4fDlcb9ruZoXKh4PozmJQyGTGle23fNYcVDxKWLvlWqvZcT6PM3Brh+scHiTx55Mrt/DbwBLJWLPFaCISfbceEZMSHFqd5YofGni68pyotkxfBcYNTGZw+xO6P45E0cqBBnP9JZze49Tdvr0mKDY6uWyWCr29KWb3YHHvVOt9FYcCH42+h7n3QGKVodIONgXIUuvq9Anh1btMI3e+ON6hDPW23USwLKV6Kmpjx+dbecOLmz2W03oRJxkQtcNAHc+ot7ovcUmgC0NqbSQOEz1h0D31BVkSDoU6d0SDcUTfHh98kZ9AkXh7FpSHdyaGmDsoxQVL6Nmf4wqd/YzoIFEgVreilu+PKiudunDGvwmrGO0C1rtVsKbVOUwXqnWwoKtH7uWO64maOWGrh8D+7QBz//Iq1XsHtDVddvPeKJyVyQ7+NWQY/l2Ur4d1CULWqjCpGERtTjwo2Aj5pq6mmloELFuNvtq4E9E10NQQ1575OkpHInrA0eC/l6cVguV2yzemaPKwf6xLZJ3j2gT2oveGJloitojWNsZtOrXOp64aykwP42mfM/X2t0Bx0yb94DsnmGdg8E/m03EldBWKiCW3jQKLRGOCNxIj2BhtJqaPG8l6hMj2wVW4lRX2tX+qG9COjRwQIcPNQqXVnapd+dxtLh40RLtyXp8Z0N4KE6n/b6xEshDLpy9ZXx6qhtVJ4HKDshgssNlvxCGKRmRjwlORA3gppkSLWpCiHDdC6AiH7ponurp9lw1bfKCGRzhlX37UiqZV4tQilEJkIbioc9J3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(39860400002)(376002)(366004)(346002)(2906002)(66556008)(5660300002)(8936002)(6506007)(26005)(53546011)(38100700002)(33656002)(6512007)(38070700005)(76116006)(91956017)(66946007)(66476007)(66446008)(64756008)(36756003)(41300700001)(8676002)(86362001)(6916009)(316002)(122000001)(6486002)(2616005)(966005)(478600001)(186003)(71200400001)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xf6zYkK84yNFXLPx/DYRnRcWm7KL+XmeXqEb4NOzJfLvhfMDzXrXJKNMM+ec?=
 =?us-ascii?Q?2/ykcrLuxXRM8UfgSykZgzl1gNigg5m4CCa87cNU1DoSZIo8pAdnBbeDs9Y3?=
 =?us-ascii?Q?lst6Wp+wHAeqZB5X709HYa23SnlsAKzQor5GV+C0vqmf1ZtZZG4HfaWZ6NLG?=
 =?us-ascii?Q?iMqbqrfMBF8dJT3bKxrxeb5z9ZBVWcsknCRBBAm3bGsCYTXy1KvUMj0BjI3X?=
 =?us-ascii?Q?2ChVmvUyypdDY2LRuV4z7qREct1ierMjAIc82zEGP/MRMm68SVbQObTgPvX5?=
 =?us-ascii?Q?1w8u0XT2p/mkVrXJTYuvfCz5+VnXmyTWnBuFM8FW3txwQJ8iJFGWtnnzkyyJ?=
 =?us-ascii?Q?MlLsPZZLhXRgVv7YtNymKUvhHJTkT3rVxGpONY1yMtb06rJFzBI/Y6kFmQ+2?=
 =?us-ascii?Q?XTYZMWNnwcwYb+KqLmaxE9UWxFB+IiAF4Dk72EgUagy4xiq2U+bioANfnTqJ?=
 =?us-ascii?Q?LPxOab2N87trVzgmnRzhB1ywwbvbvh/SD1aEyUfNwyuyRY1kTyu/njZI8X68?=
 =?us-ascii?Q?XLPT3wxGFRncygzlX+DMeMKQI6R48A6gMJo58xaMNQAk9Y9mdq8jhtNYRyTT?=
 =?us-ascii?Q?kSF84y6AWTT5SXO1C8nUJild7kLXJ1Fdba1l5zF4OM11cHdDxc5ltffm0h3u?=
 =?us-ascii?Q?Yqaway7i7pNvRjEOTZ8rb2vsl4KSYxHH9EKmse1agHozbmbB3Dp7mpykJ+WW?=
 =?us-ascii?Q?JJFeANYQT6Rli8LPeNd8i5lqyKe18bMQ0LgFqc1W4HExRgoakUJYPUKaC/Lw?=
 =?us-ascii?Q?RmkVREv8XbMUYogi2u1xiLF/zlXUarBWwZWH7jObuP3BHSZHzAFlQFi3Et1X?=
 =?us-ascii?Q?bAWuUeD8n3iP0Jdh8IKZ1qB5NjGWu0EsY2o2zkaochF6UGrhIWjQa2Vy1i9u?=
 =?us-ascii?Q?eeDC61TB3vHj80T1YZaENUUgxu8sXYxOLYNFh0Y95+C7OcVqk0vACRjabR33?=
 =?us-ascii?Q?U5iZXx7iCBkgv2BffnmTZSg32/+BNz6+STfmTYSxQOR0CLDuTsDmb0fZiw4m?=
 =?us-ascii?Q?GK3vkyt5rmBbTG1qlsFpRq1SaGy8oZpAoAJrKez/+yoh8wGQfdVRYCtlNqGK?=
 =?us-ascii?Q?TjBmiuUbunVvjFKic3o/umauPTxM0aKSs/qlguoWmaDOAMAfxkYndbttXaEu?=
 =?us-ascii?Q?AQvT31Qp1oIO1jgVN88a0gHqMsfn6bMvPWZ4f0KfIv6iKSVNj3ANZd8gd3Ea?=
 =?us-ascii?Q?UaUgRxkZw/DjyhgbOkhxAlh10vJa3TbuyOZG8YhX8X63LHHHvc+Pwo9rCIrs?=
 =?us-ascii?Q?xRJueBSfKmB/n08vJyAw0oYM4T8vqjTirQ7LZTXxWPamDopewYduwoX+qdIV?=
 =?us-ascii?Q?HYjppTkBlGRy2AV/EhOZffdisyKZ63BKumo5RGNB2+zj1PR/Ise6mCBJfZsf?=
 =?us-ascii?Q?uakWK/k87qju9CioBOQ7LvO4XrkSPSzelGxDeP3RsNU7O9W1AspW1yAewh/R?=
 =?us-ascii?Q?n34TC7M5HX+W5C6YP2Eik206z0M72coBi+rT+WWSWT5PFtSO/qe/hrWIaDQC?=
 =?us-ascii?Q?dAurfHB9TIlBD6LBUF7VVhRGU0GJgVhnagpY7kBe/xI6Vk6v/u2LEJHf7z5K?=
 =?us-ascii?Q?TVK4Y2zztt/OyXoAFT6H+u6uPijR+wIbhxCPjtui3EnkYLBCOEF6CM5qS72g?=
 =?us-ascii?Q?pA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <61FD76748FC7A7409F581B98694804D7@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1584e822-2eaf-4694-9406-08da928d37e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2022 18:00:45.1583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0mft1eU8Z4+yPCXEf3Md6+W/N5dib2txB2DlJ0kgoAfkeH8X47vailstCEhlAiHaXt10WV6dDCd7G38CX4geNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4779
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-09_08,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209090063
X-Proofpoint-GUID: 99cJQYGoN57uuSz-Mbn_T-dyzW3tlll2
X-Proofpoint-ORIG-GUID: 99cJQYGoN57uuSz-Mbn_T-dyzW3tlll2
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


> On Jun 28, 2022, at 12:23 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>=20
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>=20
> The macros __get_sockaddr() and __get_sockaddr_rel() are now added in the
> TRACE_EVENT() helper functions and can be used to retrieve dynamically
> saved sockaddr structures that hold IP addresses. Update libtraceevent to
> handle them.
>=20
> Link: https://lore.kernel.org/all/25C37F40-7D8E-41C6-961F-0774C8138CCB@or=
acle.com/
>=20
> Reported-by: Chuck Lever III <chuck.lever@oracle.com>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

This is a freshly-updated Fedora 36 system running v6.0-rc4,
and the __sockaddr stuff still doesn't work.

       mount.nfs-1639  [002]   406.390138: svc_xprt_enqueue:     [FAILED TO=
 PARSE] server=3DARRAY[02, 00, 8a, 97, 00, 00, 00, 00, 00, 00, 00, 00, 00, =
00, 00, 00] client=3D<E8>sl flags=3D0x4c03 netns_ino=3D4026531840 pid=3D0
       mount.nfs-1639  [002]   406.390360: svcsock_new_socket:   type=3DSTR=
EAM family=3DAF_INET6 (listener)
       mount.nfs-1639  [002]   406.390361: svc_xprt_enqueue:     [FAILED TO=
 PARSE] server=3DARRAY[0a, 00, a7, e7, 00, 00, 00, 00, 00, 00, 00, 00, 00, =
00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00] client=3D*<FC>%=
 flags=3D0x4c03 netns_ino=3D4026531840 pid=3D0
       mount.nfs-1639  [002]   406.390439: rpc_task_begin:       task:00000=
002@00000002 flags=3DDYNAMIC|NO_ROUND_ROBIN|SOFT|TIMEOUT|NORTO|CRED_NOREF r=
unstate=3DACTIVE status=3D0 action=3D0x0
       mount.nfs-1639  [002]   406.390440: rpc_task_run_action:  task:00000=
002@00000002 flags=3DDYNAMIC|NO_ROUND_ROBIN|SOFT|TIMEOUT|NORTO|CRED_NOREF r=
unstate=3DRUNNING|ACTIVE status=3D0 action=3Dcall_start
       mount.nfs-1639  [002]   406.390440: rpc_request:          task:00000=
002@00000002 nfsv4 SETCLIENTID (sync)
  NFSv4 callback-1642  [006]   406.390440: svc_xprt_dequeue:     [FAILED TO=
 PARSE] server=3DARRAY[02, 00, 8a, 97, 00, 00, 00, 00, 00, 00, 00, 00, 00, =
00, 00, 00] client=3D<CA>d^F flags=3D0x4c83 netns_ino=3D4026531840 wakeup=
=3D0x18325fae

# dnf list libtrace\*
Last metadata expiration check: 1:27:00 ago on Fri 09 Sep 2022 12:31:57 PM =
EDT.
Installed Packages
libtracecmd.x86_64                         1.1.3-2.fc36                 @up=
dates
libtraceevent.x86_64                       1.5.3-2.fc36                 @up=
dates
libtracefs.x86_64                          1.3.1-2.fc36                 @up=
dates
Available Packages
libtracecmd.i686                           1.1.0-3.fc36                 fed=
ora =20
libtracecmd-devel.i686                     1.1.0-3.fc36                 fed=
ora =20
libtracecmd-devel.x86_64                   1.1.3-2.fc36                 upd=
ates=20
libtraceevent.i686                         1.5.3-2.fc36                 upd=
ates=20
libtraceevent-devel.i686                   1.5.3-2.fc36                 upd=
ates=20
libtraceevent-devel.x86_64                 1.5.3-2.fc36                 upd=
ates=20
libtracefs.i686                            1.3.1-2.fc36                 upd=
ates=20
libtracefs-devel.i686                      1.3.1-2.fc36                 upd=
ates=20
libtracefs-devel.x86_64                    1.3.1-2.fc36                 upd=
ates=20
# dnf list trace-cmd\*
Last metadata expiration check: 1:27:09 ago on Fri 09 Sep 2022 12:31:57 PM =
EDT.
Installed Packages
trace-cmd.x86_64                          3.0.3-2.fc36                  @up=
dates
Available Packages
trace-cmd-python3.x86_64                  3.0.3-2.fc36                  upd=
ates=20
# dnf repolist
repo id                        repo name
fedora                         Fedora 36 - x86_64
fedora-cisco-openh264          Fedora 36 openh264 (From Cisco) - x86_64
fedora-modular                 Fedora Modular 36 - x86_64
updates                        Fedora 36 - x86_64 - Updates
updates-modular                Fedora Modular 36 - x86_64 - Updates
#=20


> ---
> src/event-parse.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/src/event-parse.c b/src/event-parse.c
> index 823333a3bde4..b252c4d890a0 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -3485,7 +3485,9 @@ process_function(struct tep_event *event, struct te=
p_print_arg *arg,
> 		return process_bitmask(event, arg, tok);
> 	}
> 	if (strcmp(token, "__get_dynamic_array") =3D=3D 0 ||
> -	    strcmp(token, "__get_rel_dynamic_array") =3D=3D 0) {
> +	    strcmp(token, "__get_rel_dynamic_array") =3D=3D 0 ||
> +	    strcmp(token, "__get_sockaddr") =3D=3D 0 ||
> +	    strcmp(token, "__get_sockaddr_rel") =3D=3D 0) {
> 		free_token(token);
> 		return process_dynamic_array(event, arg, tok);
> 	}
> --=20
> 2.35.1
>=20

--
Chuck Lever



