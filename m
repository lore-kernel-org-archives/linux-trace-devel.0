Return-Path: <SRS0=Onan=RV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2872CC43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Mar 2019 21:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFF662133D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Mar 2019 21:03:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="lPI/81DI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfCRVDa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Mar 2019 17:03:30 -0400
Received: from mail-eopbgr800047.outbound.protection.outlook.com ([40.107.80.47]:56672
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726832AbfCRVDa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Mar 2019 17:03:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+aI/1JT/4qXOk27DC/I6KaI43E8+mbpyKigicJCt7I=;
 b=lPI/81DIv9f/Bbcl9crhTYWsXXKi0yfYE4dMzRt+NeQRw1soajNVC3TPNJIMZYiHov8xL1ule48boAVk1N49xvYYyVV6cb88+kP1ItHdnoHTkzGEbudFCt5SgSJ02tLVM05fRY6WrY43L2iqG7iEN8Y923LTkK4Yi9WI73Ij9Rc=
Received: from BYAPR05MB5592.namprd05.prod.outlook.com (20.177.186.153) by
 BYAPR05MB4933.namprd05.prod.outlook.com (52.135.235.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.16; Mon, 18 Mar 2019 21:03:21 +0000
Received: from BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::c0d4:e960:b51:44cc]) by BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::c0d4:e960:b51:44cc%2]) with mapi id 15.20.1709.015; Mon, 18 Mar 2019
 21:03:21 +0000
From:   Matt Helsley <mhelsley@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v4] tools/lib/traceevent: Change description of few APIs
Thread-Topic: [PATCH v4] tools/lib/traceevent: Change description of few APIs
Thread-Index: AQHU2waywHuRr1GN/0q6/vkCeh6knKYR5fuA
Date:   Mon, 18 Mar 2019 21:03:21 +0000
Message-ID: <8B1136D3-BD5A-49E8-B007-12D00050687A@vmware.com>
References: <20190315081123.21723-1-tstoyanov@vmware.com>
In-Reply-To: <20190315081123.21723-1-tstoyanov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mhelsley@vmware.com; 
x-originating-ip: [47.33.181.168]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9bb147fa-c351-4c7d-cd61-08d6abe5278e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4933;
x-ms-traffictypediagnostic: BYAPR05MB4933:
x-microsoft-antispam-prvs: <BYAPR05MB493391B90D1C17215CAF8006A0470@BYAPR05MB4933.namprd05.prod.outlook.com>
x-forefront-prvs: 098076C36C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(346002)(376002)(136003)(199004)(189003)(99286004)(11346002)(81156014)(446003)(54906003)(25786009)(105586002)(2616005)(478600001)(2906002)(76176011)(316002)(6246003)(6862004)(81166006)(6486002)(8676002)(66066001)(8936002)(6436002)(82746002)(229853002)(37006003)(14454004)(6636002)(3846002)(6116002)(5660300002)(97736004)(186003)(71190400001)(26005)(106356001)(486006)(83716004)(68736007)(4326008)(102836004)(305945005)(71200400001)(6506007)(53936002)(53546011)(36756003)(86362001)(33656002)(256004)(7736002)(476003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4933;H:BYAPR05MB5592.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YAZLVZ9qvoa0vWNITWg7mEgAAuTWKMfTa/JFbi06NAfXqAeI55+gn0NKtmzo2aWn8SkGEZlpa/5QWQB/xZ7Ar8IElEAJKtvdDcKYXJ7AVvHaDz24mtTF+ZSO6c34KvGnyCWNVDeOUc0ESCNzmP6wDYnbpcC0IMtrXFfmBQYmPy4WBV1nyWvpI63kbXw58kbN4Zth3QixhUvjIu9YipBMpGynVzr9cNefJ0Lbh1OIrSFmAEv+S1W615UpjVYGtLQw/LxGJ1v7i4OoLzReUBGmo9Mx+dDTQXwt0JS/3r1QLZ4GOypKjD6yVwkd9TYo/gA78lqrJLy/PbgeHyPuj4g2vcAQCcYz9cpUifpLjDOoRD94aya6iD4YgQjZTz6Gg8Cv665IB24I8YJ9MBZMS2XLgixop2BMf3ZB3x4n0tunYHs=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22A48AFCEB525E47B2180A321873E711@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb147fa-c351-4c7d-cd61-08d6abe5278e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2019 21:03:21.7353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4933
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



> On Mar 15, 2019, at 1:11 AM, Tzvetomir Stoyanov <tstoyanov@vmware.com> wr=
ote:
>=20
> APIs descriptions should describe the purpose of the
> function, its parameters and return value. While working
> on man pages implementation, I noticed mismatches in the
> descriptions of few APIs. This patch changes the description
> of these APIs, making them consistent with the man pages:
> tep_print_num_field(), tep_print_func_field(),
> tep_get_header_page_size(), tep_get_long_size(),
> tep_set_long_size(), tep_get_page_size() and
> tep_set_page_size().
>=20
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
> tools/lib/traceevent/event-parse-api.c | 21 ++++++++++++---------
> tools/lib/traceevent/event-parse.c     |  4 ++--
> 2 files changed, 14 insertions(+), 11 deletions(-)
>=20
> diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceeven=
t/event-parse-api.c
> index d4368dcc16ea..2d5d3642e3e9 100644
> --- a/tools/lib/traceevent/event-parse-api.c
> +++ b/tools/lib/traceevent/event-parse-api.c
> @@ -100,10 +100,10 @@ tep_data2host8(struct tep_handle *pevent, unsigned =
long long data)
> }
>=20
> /**
> - * tep_get_header_page_size - get size of the header page
> + * tep_get_header_page_size - get the size of a long integer, in kernel =
context

Just want to check If this comment change correct. Given the function name =
it looks a bit odd compared to the comment for tep_get_long_size().

>  * @pevent: a handle to the tep_handle
>  *
> - * This returns size of the header page
> + * This returns the size of a long integer, in kernel context
>  * If @pevent is NULL, 0 is returned.
>  */
> int tep_get_header_page_size(struct tep_handle *pevent)
> @@ -140,10 +140,11 @@ void tep_set_cpus(struct tep_handle *pevent, int cp=
us)
> }
>=20
> /**
> - * tep_get_long_size - get the size of a long integer on the current mac=
hine
> + * tep_get_long_size - get the size of a long integer on the traced mach=
ine
>  * @pevent: a handle to the tep_handle
>  *
> - * This returns the size of a long integer on the current machine
> + * This returns the size of a long integer on the machine,
> + * where the trace is generated
>  * If @pevent is NULL, 0 is returned.
>  */
