Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78801C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 19:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4035C20811
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 19:08:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="gOwjzYmX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfCSTIr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 15:08:47 -0400
Received: from mail-eopbgr730077.outbound.protection.outlook.com ([40.107.73.77]:11072
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726768AbfCSTIr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 15:08:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bb+9Ygx4pwE6mePTTgZkVevgLJ20vgrWaSFWvGDcWtE=;
 b=gOwjzYmXzeVdDoDr5InU+TGSRajlea6+lCEVA11q9MCPpfhyVI6E3gwKl36JxE5tuYYLi2yyxcH6uoBls5J3XsAl/UlLBQDIZu/yE+jIZo59D5R1U250cggoez+JK2vp0ebgZHW82AB9h6z32s6P+pVl6tP0rbhTMBGTEt1s8gw=
Received: from BYAPR05MB5592.namprd05.prod.outlook.com (20.177.186.153) by
 BYAPR05MB5062.namprd05.prod.outlook.com (20.177.230.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.13; Tue, 19 Mar 2019 19:08:44 +0000
Received: from BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::c0d4:e960:b51:44cc]) by BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::c0d4:e960:b51:44cc%2]) with mapi id 15.20.1709.015; Tue, 19 Mar 2019
 19:08:44 +0000
From:   Matt Helsley <mhelsley@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v4 36/46] tools/lib/traceevent: Man pages for
 tep_set_function_resolver() and tep_reset_function_resolver()
Thread-Topic: [PATCH v4 36/46] tools/lib/traceevent: Man pages for
 tep_set_function_resolver() and tep_reset_function_resolver()
Thread-Index: AQHU2dhXNiMi3l7KWk+ZYOEKLJz3qKYTWqGA
Date:   Tue, 19 Mar 2019 19:08:43 +0000
Message-ID: <C4095F27-B76B-4889-9F0F-BFBEFD769F87@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
 <20190308133654.21264-37-tstoyanov@vmware.com>
 <20190313160656.66ca66ae@gandalf.local.home>
In-Reply-To: <20190313160656.66ca66ae@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [73.25.163.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3966ca81-678f-43ea-d5fe-08d6ac9e4e6e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB5062;
x-ms-traffictypediagnostic: BYAPR05MB5062:
x-microsoft-antispam-prvs: <BYAPR05MB5062BFDA4748FC062C068472A0400@BYAPR05MB5062.namprd05.prod.outlook.com>
x-forefront-prvs: 0981815F2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(366004)(346002)(199004)(189003)(478600001)(3846002)(2906002)(4326008)(486006)(316002)(99286004)(54906003)(86362001)(105586002)(305945005)(106356001)(7736002)(97736004)(68736007)(14454004)(6116002)(66066001)(33656002)(229853002)(4744005)(36756003)(6916009)(71200400001)(6486002)(81166006)(71190400001)(8676002)(83716004)(81156014)(6436002)(6346003)(102836004)(76176011)(256004)(446003)(476003)(11346002)(53546011)(6512007)(2616005)(6246003)(53936002)(25786009)(82746002)(26005)(6506007)(8936002)(5660300002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5062;H:BYAPR05MB5592.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mhelsley@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VKLQk2mcfMoe5SJJFnQEEPrZ0f9aGwcJCGQDEYqUu63ufxifvPw0BUoPx8YidCvZE1M+ZlBypP6wyu64iG+np2Vi0NjkhOMSDzIcVzbtnTo0y4nPjH1aRgK4yNyRTalvLr1Kh/cJ7MQzIG8cwLBELx40q883K4YF7iZGGPwJvXQVPaeZXMlLwaWXG3OEyVwEg1HPbzPdd1eLvJetM/tnANnqxz/V7u/mkowtewEToXAlZPKZ5YroVIBa9m8SA4idzPunfodurRhQcs785f7YQlFS1L3RGdNd/Uw7EHEpdFwg9ZSTIJUomdppY7asU5g5p+b8ZMdogmS9K445cjz3VBZYpXWvc4gU+3fSmaA3/8IBCsObmaFU1DHmwPx47FcffUCvBVOJgsE+pfeabLZ25BSXWyUjHvEH2iPjNkDSBHY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <43A0100632CA6342BD382D8255067FFC@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3966ca81-678f-43ea-d5fe-08d6ac9e4e6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2019 19:08:43.8459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5062
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


> On Mar 13, 2019, at 1:06 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>=20
> On Fri,  8 Mar 2019 15:36:44 +0200
> Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:
>=20
>> Create man pages for tep_set_function_resolver() and tep_reset_function_=
resolver()
>> as part of the libtraceevent APIs.
>>=20
>>=20
>=20
> These could probably be added to the tep_register_function() man pages
> as well.
>=20
> -- Steve

The content itself looks good and this makes sense to me.

Cheers,
     -Matt=
