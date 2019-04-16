Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B35DC10F13
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 12:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E21F2206BA
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 12:37:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZYH+5I0Q";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="W2Vi/+Yg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfDPMhE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 08:37:04 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:28337 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfDPMhE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 08:37:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1555418224; x=1586954224;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zRRwS7wx04Jxs1TzXpWhctOVzx0KVpZfhOQiTE4MhEI=;
  b=ZYH+5I0Q6XWg1alxI6k0P4mkEjaDvPB0gQpTk9JyxJnA2B/BZjzG/C/y
   4ex1/gME3pFicdSzzlEXJnySV3WWE286gGuIY30fuzk4IrL8Vdz6HGZ8p
   EhAmdrYkf8v3GsJ2Aprtj1mS8OD/Z+kG5R4PWW1Tes0pfsIyeQvuu3Nu2
   gRwYbrh8WKho61AeCy32W2clIJvLXW8LriR1JZwjJ0a9fQjVoY3WAAfVR
   TzEydAeVDJMAy9JDNUPky8LvGj//Hx8He8hFQG2J9Isau6R5FX5iUu+fB
   rTfQ95sfEsxZdokdm5/7Uen8VFCWa/K22hmKWB8iaJlr9krZcwcKczL1N
   A==;
X-IronPort-AV: E=Sophos;i="5.60,357,1549900800"; 
   d="scan'208";a="111039830"
Received: from mail-bn3nam04lp2054.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.54])
  by ob1.hgst.iphmx.com with ESMTP; 16 Apr 2019 20:37:02 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector1-wdc-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDkeA2MU5uxixAaeItuZ2OxwIgseMSfx7hxY9Wiu7VM=;
 b=W2Vi/+YgdzKQFxft4CGuWsnXg+Y5Pg++2inVKDBMapFuHpJivPhYJ+n39V1D3zo/cLhDRF77d2V8xZtMGoBhjEXNi0Nmcjn83R7C6RkxblvUWQEDMlgfNw4Q3LVExLhJlZzuyf8BAyQLUc4tPW39ymqvIhAKpSYYszQYov4NfA0=
Received: from SN6PR04MB4925.namprd04.prod.outlook.com (52.135.114.82) by
 SN6PR04MB5040.namprd04.prod.outlook.com (52.135.116.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.19; Tue, 16 Apr 2019 12:37:00 +0000
Received: from SN6PR04MB4925.namprd04.prod.outlook.com
 ([fe80::18d2:ac1f:7c5e:186e]) by SN6PR04MB4925.namprd04.prod.outlook.com
 ([fe80::18d2:ac1f:7c5e:186e%2]) with mapi id 15.20.1813.011; Tue, 16 Apr 2019
 12:37:00 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Raul E Rangel <rrangel@chromium.org>
CC:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "djkurtz@chromium.org" <djkurtz@chromium.org>,
        "zwisler@chromium.org" <zwisler@chromium.org>,
        hongjiefang <hongjiefang@asrmicro.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Kyle Roeschley <kyle.roeschley@ni.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: RE: [PATCH v1 1/4] mmc: core: Add trace event for SD SCR response
Thread-Topic: [PATCH v1 1/4] mmc: core: Add trace event for SD SCR response
Thread-Index: AQHU8938wa4xmXZsFEqr8AFv37ojhaY93vyAgADa3NA=
Date:   Tue, 16 Apr 2019 12:36:59 +0000
Message-ID: <SN6PR04MB492517B439F0E5CB8F3CDC07FC240@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <20190415225241.70088-1-rrangel@chromium.org>
 <20190415193133.2cdbc6d0@gandalf.local.home>
In-Reply-To: <20190415193133.2cdbc6d0@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4da22ea5-f2d4-4210-7e7d-08d6c268388e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600140)(711020)(4605104)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:SN6PR04MB5040;
x-ms-traffictypediagnostic: SN6PR04MB5040:
wdcipoutbound: EOP-TRUE
x-microsoft-antispam-prvs: <SN6PR04MB5040596F5F3E12310D24A611FC240@SN6PR04MB5040.namprd04.prod.outlook.com>
x-forefront-prvs: 000947967F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(376002)(366004)(136003)(396003)(199004)(189003)(256004)(66066001)(6246003)(102836004)(14444005)(14454004)(86362001)(25786009)(55016002)(53936002)(478600001)(9686003)(7416002)(4326008)(72206003)(71200400001)(305945005)(81166006)(97736004)(8936002)(7736002)(52536014)(81156014)(8676002)(486006)(99286004)(68736007)(5660300002)(33656002)(476003)(105586002)(6436002)(7696005)(54906003)(106356001)(229853002)(26005)(6116002)(446003)(316002)(11346002)(110136005)(6506007)(3846002)(71190400001)(76176011)(74316002)(186003)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR04MB5040;H:SN6PR04MB4925.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Y73o+lGj6Dadzr3AQzCu2oLnMUIAnyI7CPtBB5l/Rlnu+JASFy2wkmcL766YmGlSXzLTpawGZWIGbowPsiXQkc3HKAZlqqpnpn/hOQT2aPj56kl6+QbztyBldaT31i/5XISS/MCjVl9pZ3ufiXVo4xxj2UYbZ9KajtEmNeG5UimMU3MFk705JwnmlPcZ3yayMZVBXrZRf2h7LoFxbQITZF7l39ZcPI3J96OUS3hfMR6lCDPnAQHT8GqaETjUI0hhysbGDpPbiKWLTlYKccBRofSH9quwW7Id68raYOX8sdyiB+w4jdVUYoh0gcFozP7pjroeGrq0iteoamkL2UV87e+qfr3Jd4FgUOVMrHrn2dKiEwS4jr7IGfvF1hKhMaSPSGQw41TzsrQ5TUIfrP5nVwr61MJngJ2XR81K89NLWtA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4da22ea5-f2d4-4210-7e7d-08d6c268388e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2019 12:36:59.9152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5040
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

>=20
> On Mon, 15 Apr 2019 16:52:38 -0600
> Raul E Rangel <rrangel@chromium.org> wrote:
>=20
> > Example:
> > sd_scr: mmc0: version: 2, spec3: 1, width: 5, cmds: 0, raw: {0x2b58000,=
0x0}
> >
> > Signed-off-by: Raul E Rangel <rrangel@chromium.org>
> > ---
> >
> >  drivers/mmc/core/sd.c      |  4 ++++
> >  include/trace/events/mmc.h | 42
> ++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 46 insertions(+)
> >
> > diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
> > index 265e1aeeb9d8..3bed7c4b6d75 100644
> > --- a/drivers/mmc/core/sd.c
> > +++ b/drivers/mmc/core/sd.c
> > @@ -21,6 +21,8 @@
> >  #include <linux/mmc/mmc.h>
> >  #include <linux/mmc/sd.h>
> >
> > +#include <trace/events/mmc.h>
> > +
> >  #include "core.h"
> >  #include "card.h"
> >  #include "host.h"
> > @@ -200,6 +202,7 @@ static int mmc_decode_scr(struct mmc_card *card)
> >  	if (scr_struct !=3D 0) {
> >  		pr_err("%s: unrecognised SCR structure version %d\n",
> >  			mmc_hostname(card->host), scr_struct);
> > +		trace_sd_scr(card, NULL);
> >  		return -EINVAL;
> >  	}
> >
> > @@ -221,6 +224,7 @@ static int mmc_decode_scr(struct mmc_card *card)
> >
> >  	if (scr->sda_spec3)
> >  		scr->cmds =3D UNSTUFF_BITS(resp, 32, 2);
> > +	trace_sd_scr(card, scr);
> >  	return 0;
> >  }
> >
> > diff --git a/include/trace/events/mmc.h b/include/trace/events/mmc.h
> > index 7b706ff21335..e45258e8a6cb 100644
> > --- a/include/trace/events/mmc.h
> > +++ b/include/trace/events/mmc.h
> > @@ -10,6 +10,48 @@
> >  #include <linux/mmc/host.h>
> >  #include <linux/tracepoint.h>
> >
> > +TRACE_EVENT(sd_scr,
As all 3 new trace events (csd, scr, and ssr) are pretty close,
You might want to find a common ground and declare an event class.

Thanks,
Avri

> > +
> > +	TP_PROTO(struct mmc_card *card, struct sd_scr *scr),
> > +
> > +	TP_ARGS(card, scr),
> > +
> > +	TP_STRUCT__entry(
> > +		__array(u32,			raw,	2)
> > +		__field(unsigned char,		sda_vsn)
> > +		__field(unsigned char,		sda_spec3)
> > +		__field(unsigned char,		bus_widths)
> > +		__field(unsigned char,		cmds)
> > +		__string(name,			mmc_hostname(card->host))
> > +	),
> > +
> > +	TP_fast_assign(
> > +		memcpy(__entry->raw, card->raw_scr, sizeof(card-
> >raw_scr));
>=20
> Having the memcpy() size be that of the source is dangerous. Not that
> the destination will every be smaller, but I would highly suggest
> either trying to see if "sizeof(__entry->raw)" works or at worse,
> sizeof(u32)*2.
>=20
> -- Steve
>=20
> > +		if (scr) {
> > +			__entry->sda_vsn =3D scr->sda_vsn;
> > +			__entry->sda_spec3 =3D scr->sda_spec3;
> > +			__entry->bus_widths =3D scr->bus_widths;
> > +			__entry->cmds =3D scr->cmds;
> > +		} else {
> > +			__entry->sda_vsn =3D 0;
> > +			__entry->sda_spec3 =3D 0;
> > +			__entry->bus_widths =3D 0;
> > +			__entry->cmds =3D 0;
> > +		}
> > +		__assign_str(name, mmc_hostname(card->host));
> > +	),
> > +
> > +	TP_printk("%s: version: %d, spec3: %d, width: %d, cmds: %d, "
> > +		"raw: %s",
> > +		  __get_str(name),
> > +		  __entry->sda_vsn,
> > +		  __entry->sda_spec3,
> > +		  __entry->bus_widths,
> > +		  __entry->cmds,
> > +		  __print_array(__entry->raw, 2, sizeof(u32))
> > +	)
> > +);
> > +
> >  TRACE_EVENT(mmc_request_start,
> >
> >  	TP_PROTO(struct mmc_host *host, struct mmc_request *mrq),

