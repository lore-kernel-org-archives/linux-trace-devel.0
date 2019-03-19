Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83D3C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 18:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 879DE2082F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 18:29:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="pXmFq18C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfCSS3r (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 14:29:47 -0400
Received: from mail-eopbgr800088.outbound.protection.outlook.com ([40.107.80.88]:34240
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726751AbfCSS3r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 14:29:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1W9lRo6PpwrgNm++c1vuovI6KcivwCPiCBeu4+VdKTo=;
 b=pXmFq18CqF0JeQAI+uA0Va0AU4GVL1NFwX4yVpEzm7PAWEQ5o7ygQX2hSqNvsB88mEw71y/pApyBp8UrDMdZ/BIyUlYThWUFYrSbdNsvf7a2IEXwhtwsYuul3QlXP4YAzOLRWye0pCltMNLcxBaJYRKH7SB1OnKRgp14TqE98pU=
Received: from BYAPR05MB5592.namprd05.prod.outlook.com (20.177.186.153) by
 BYAPR05MB6200.namprd05.prod.outlook.com (20.178.55.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.13; Tue, 19 Mar 2019 18:29:39 +0000
Received: from BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::c0d4:e960:b51:44cc]) by BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::c0d4:e960:b51:44cc%2]) with mapi id 15.20.1709.015; Tue, 19 Mar 2019
 18:29:39 +0000
From:   Matt Helsley <mhelsley@vmware.com>
To:     Slavomir Kaslev <kaslevs@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 9/9] trace-cmd [POC]: Implemented timestamps synch
 algorithm, using vsock events.
Thread-Topic: [PATCH v7 9/9] trace-cmd [POC]: Implemented timestamps synch
 algorithm, using vsock events.
Thread-Index: AQHU3nc7j9tIIY/jzkWhZFJ9obVWMKYTO76AgAADPwCAAAd+gA==
Date:   Tue, 19 Mar 2019 18:29:39 +0000
Message-ID: <83964D3D-EE42-46B7-871E-7716749AB87B@vmware.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
 <20190319155536.19381-10-tstoyanov@vmware.com>
 <CAE0o1NvsHhROnXesVHT08HfPO_FC3EjxXrkfqkPsF6SB=6Z2Lg@mail.gmail.com>
 <20190319135111.0061eddb@gandalf.local.home>
 <CAE0o1NtchyejDbn_xCDjDmVLmP8vRF-Gv2SZSoigbxYR1Gc2dw@mail.gmail.com>
In-Reply-To: <CAE0o1NtchyejDbn_xCDjDmVLmP8vRF-Gv2SZSoigbxYR1Gc2dw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mhelsley@vmware.com; 
x-originating-ip: [73.25.163.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9962215-1d05-42d7-ce86-08d6ac98d8f3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB6200;
x-ms-traffictypediagnostic: BYAPR05MB6200:
x-microsoft-antispam-prvs: <BYAPR05MB6200AE89591C26BE1D16FD40A0400@BYAPR05MB6200.namprd05.prod.outlook.com>
x-forefront-prvs: 0981815F2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(39860400002)(376002)(366004)(346002)(189003)(199004)(86362001)(99286004)(229853002)(81166006)(81156014)(82746002)(26005)(256004)(83716004)(8676002)(186003)(8936002)(6436002)(6486002)(68736007)(486006)(4744005)(2906002)(3846002)(93886005)(37006003)(6636002)(316002)(54906003)(446003)(76176011)(2616005)(476003)(11346002)(102836004)(71200400001)(71190400001)(6116002)(53546011)(6506007)(6246003)(53936002)(97736004)(33656002)(66066001)(6512007)(4326008)(6862004)(478600001)(105586002)(7736002)(305945005)(14454004)(106356001)(36756003)(25786009)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB6200;H:BYAPR05MB5592.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:3;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IXcgltb7JqfE4vdXddhkQ8vOwulmaa0ip6lyssqgQR4Gwlo1rAs68pm9WCgaksSPqnrnMHoB+qOrMXiTFGN04mEDKpNNwnfxv/XIYa71A29USWm1K5hz0nU3dZbICt1/rdabiD8CPAyxpqyuBojchAFvhkVghhxYtF3DJhVPrw3XTC4mENRGQJc6Z0S7Edw1iP0zxXUBLM9YaEslWMhsZfIt3UJ03qJnjSFv7PihegHTX7NPpsOJfyn+UJgV7qSV+etHoWYlW+hpG6efnyzVHyj7PxKLnanb+f4/JXTIahKdvJ9WM7GT+mnSJFgnemVyMzCga4lViii7REvTr04k96Kt+gsolkQf++pJvYvY90BkkP5BcbqPL2MxEwGPByB5pTU7SOCv9XBZs4QP3ugIjg0fuYPCskIfhx6gtB0SRZ0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F4B1C2771885E54F8E04EFEFE1EA6B67@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9962215-1d05-42d7-ce86-08d6ac98d8f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2019 18:29:39.3066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB6200
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



> On Mar 19, 2019, at 11:02 AM, Slavomir Kaslev <kaslevs@vmware.com> wrote:
>=20
> On Tue, Mar 19, 2019 at 7:52 PM Steven Rostedt <rostedt@goodmis.org> wrot=
e:
>>=20
>> Just an FYI, when replying to large patches, it's recommended to crop
>> the message to the specifics, that way people don't need to scroll down
>> forever, and most likely will miss a response. Some kernel developers I
>> know would ignore replies if they are not properly cropped.
>>=20
>> In some cases, that includes me ;-) (If I scroll more than 3 pages, and
>> don't see a response, I sometimes stop there).
>=20
> Good point, I'll start doing that. Thanks.
>=20
> -- Slavi

Thank you! I, for one, really appreciate folks who take the time to trim th=
e context. When I do it, I like to mark removed parts with (including newli=
nes)

<snip>

or

<snipped>

just so everyone knows something got removed from the quoted email.

Cheers,
     -Matt=
