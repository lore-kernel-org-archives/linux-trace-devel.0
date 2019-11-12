Return-Path: <SRS0=qtAn=ZE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C14C43331
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Nov 2019 12:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A80B7206BB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Nov 2019 12:03:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="lLWgqQ8d";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="czcpWpbO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfKLMD7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 07:03:59 -0500
Received: from mail-eopbgr40052.outbound.protection.outlook.com ([40.107.4.52]:61815
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725944AbfKLMD7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 07:03:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1zyvAMxKt3+DkmIqhTE/TAQ2/TxKuZIvIoNbsM5UTk=;
 b=lLWgqQ8dQqSKhdp73cDxtCjqVI2pq4pMinlGCTHk7W0159jr/4ltUbIlb00uANtYb0O5TbMYW+SRN6L9P8mWoEz/eaUcObtmSO7HomLFME78olJBNUObYGJED2NhBI4jvshNogNmhPk8xQ/lWWvr7uiG/TSMQkEr5LJMM2J0PT0=
Received: from DB6PR0802CA0029.eurprd08.prod.outlook.com (2603:10a6:4:a3::15)
 by VE1PR08MB4672.eurprd08.prod.outlook.com (2603:10a6:802:a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.24; Tue, 12 Nov
 2019 12:03:51 +0000
Received: from VE1EUR03FT028.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::206) by DB6PR0802CA0029.outlook.office365.com
 (2603:10a6:4:a3::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2430.20 via Frontend
 Transport; Tue, 12 Nov 2019 12:03:51 +0000
Authentication-Results: spf=fail (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: Fail (protection.outlook.com: domain of arm.com does not
 designate 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT028.mail.protection.outlook.com (10.152.18.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2430.21 via Frontend Transport; Tue, 12 Nov 2019 12:03:51 +0000
Received: ("Tessian outbound 3fba803f6da3:v33"); Tue, 12 Nov 2019 12:03:48 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: c8d40a69b3629406
X-CR-MTA-TID: 64aa7808
Received: from c0b7b08ddfd3.1 (cr-mta-lb-1.cr-mta-net [104.47.10.59])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id F1304C64-8992-4D9C-8929-FFB4B3A9E0F6.1;
        Tue, 12 Nov 2019 12:03:43 +0000
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-db5eur03lp2059.outbound.protection.outlook.com [104.47.10.59])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c0b7b08ddfd3.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 12 Nov 2019 12:03:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/5NsX4Jf2MOw+gsD4Jgk7N9oNI544QFm9Hlga1zsLgEHrxhvFHANyXjcYkT1kpOQ7+ulhHGr52DlWCH4ETGbXtM2TDCljKX+FJxvQnu/OeanV5VVL860M/fq2W4bMhq2FK2iwUpWKHDkciPNhzIOBD4dgqHgmAUh3KPa2yqe0bkaKszpXaiDygJv/9970uBBTQPhT7fVyrgOqXHgTgPOGWIadg2KZv5Lso44m+jlOfTjHk2sLNKVhW0xCnV1KUUO7BEy+W+8/3L7/Sy9gQTqh+1OLGnTI+yPNdfJwCB5Sy+QNkjW5q3Mk5ihI7wQzduxlsBnMZBF8YhuWuxXVVRiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjWypwFu63jvCoR1VIBkSB8PhEmKLBQsQ3OjrOAKrt8=;
 b=ED6q69tGfnimE/B7TGIdwrJ6iGuz48WINVEDMIfnjzulz8ONsfNIVj7OGaKJaO4jk4DpfCwEHeL12R2K2W7Fo9ETRwpWBWlII3fHW/kYf+sjujUVKT7RjQ72EvXqSAoA8rPutsnX9d8lCWAJRItFPO6IQRr/t3JIYo1S20GmSAsmJBNPlZHUeDqwYhpIUnEsjDgtAepfl72C6D9seOFcHzU1h4e1A0LRWpI2DrHQfYPmNSpX/NAvcVvszz4i6z9Pa6+MdgOrI6PjaYne2ZNCznhWeaa5SfRtWTgtYa5rGEi+hTx7dNtNsE8QL8S5f5dhtxxm4zJsrx1BsBf40iLHJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=goodmis.org smtp.mailfrom=arm.com;
 dmarc=bestguesspass action=none header.from=arm.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjWypwFu63jvCoR1VIBkSB8PhEmKLBQsQ3OjrOAKrt8=;
 b=czcpWpbOyGTYndOqJjDU6h2657Nxb/pHfZFig3JFtb0iZkeRpoPNveMt3A7FNVdWXk/Lv/Xea0NZis9/RzAqpZr+FAHWUummJ/Wi53lwBGSbOkN9atzu0w7Iyr88Ke+8fn6PcEs/CFvV3TBjEtU+dL/OiaMNR2VMBQytp3E20ZQ=
Received: from HE1PR08CA0077.eurprd08.prod.outlook.com (2603:10a6:7:2a::48) by
 VI1PR0802MB2144.eurprd08.prod.outlook.com (2603:10a6:800:a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.24; Tue, 12 Nov
 2019 12:03:42 +0000
Received: from DB5EUR03FT007.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::202) by HE1PR08CA0077.outlook.office365.com
 (2603:10a6:7:2a::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.23 via Frontend
 Transport; Tue, 12 Nov 2019 12:03:42 +0000
Authentication-Results-Original: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; goodmis.org; dkim=none (message not signed)
 header.d=none;goodmis.org; dmarc=bestguesspass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com;
Received: from nebula.arm.com (40.67.248.234) by
 DB5EUR03FT007.mail.protection.outlook.com (10.152.20.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.2430.21 via Frontend Transport; Tue, 12 Nov 2019 12:03:41 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1415.2; Tue, 12 Nov
 2019 12:03:16 +0000
Received: from e120877-lin.cambridge.arm.com (10.1.194.81) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1415.2 via Frontend
 Transport; Tue, 12 Nov 2019 12:03:16 +0000
Date:   Tue, 12 Nov 2019 12:03:15 +0000
From:   Vincent Donnefort <vincent.donnefort@arm.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/2] trace-cmd: Add an option to set saved_cmdlines_size
Message-ID: <20191112120314.GA41032@e120877-lin.cambridge.arm.com>
References: <1573123866-348262-1-git-send-email-vincent.donnefort@arm.com>
 <1573123866-348262-2-git-send-email-vincent.donnefort@arm.com>
 <20191111175203.252cc439@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191111175203.252cc439@gandalf.local.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;IPV:NLI;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(39860400002)(189003)(199004)(336012)(426003)(76176011)(305945005)(356004)(486006)(81156014)(44832011)(8676002)(81166006)(86362001)(229853002)(7696005)(476003)(126002)(446003)(11346002)(33656002)(2906002)(8936002)(4326008)(106002)(16586007)(58126008)(316002)(46406003)(26005)(97756001)(70206006)(6246003)(1076003)(70586007)(55016002)(50466002)(47776003)(23726003)(478600001)(14444005)(186003)(6916009)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0802MB2144;H:nebula.arm.com;FPR:;SPF:Pass;LANG:en;PTR:InfoDomainNonexistent;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 491d4e36-3ba8-4bdb-6176-08d7676861fb
X-MS-TrafficTypeDiagnostic: VI1PR0802MB2144:|VE1PR08MB4672:
X-Microsoft-Antispam-PRVS: <VE1PR08MB46720EC461CF6A18B325788EE9770@VE1PR08MB4672.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
X-MS-Oob-TLC-OOBClassifiers: OLM:843;OLM:843;
X-Forefront-PRVS: 021975AE46
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: RkhtUCsv5qH4iYDG7Qdyuw6ri2Ll4YuJO9dJj6CiXm+2XTKEmIrpVylKXRwg0LIUamyjdL3dGJoiz33WqN666Usma8ETwJl1/p4Q0U93SaxE9/qtnk/72bC2ntZgS3dr8ZJvKzBDLlRqnqReugPfeQAjoaPtaHC6BQB86pEz/dKP1xq92l0ydKG3hXRQA10KlBKK/iJwSULGaYAZYybNeYubCl41q/lfaSS2koMXeR31/sHokXBGN+R+K2ABD1c3jCeh+JEAJuYBztFkrFvL8gmRtpaMRQ6PzOgdqCVhEaFOPZJ2r5rxTbdp9rrR/QaYaW8EMwxBcg+o6AEQGXAU5NKQxCh8Z8WlSDWCpmcL29lBM1cyircpU0SrtKPtwtH7IvTtHJTfXzu/xP7Qf8iJZPVEOG38xiGwSocDW7bbul0Ft0c7jpXSTJqewnqIiOlI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0802MB2144
Original-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; goodmis.org; dkim=none (message not signed)
 header.d=none;goodmis.org; dmarc=bestguesspass action=none
 header.from=arm.com;
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT028.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(136003)(39860400002)(376002)(1110001)(339900001)(40434004)(189003)(199004)(105606002)(2906002)(1076003)(47776003)(46406003)(70586007)(70206006)(26826003)(8746002)(6862004)(336012)(8936002)(11346002)(14444005)(5024004)(446003)(426003)(478600001)(76176011)(55016002)(7696005)(4326008)(186003)(305945005)(126002)(22756006)(44832011)(36906005)(58126008)(26005)(50466002)(6246003)(476003)(23726003)(486006)(8676002)(316002)(81156014)(86362001)(81166006)(33656002)(76130400001)(97756001)(229853002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR08MB4672;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Fail;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 28754089-1d58-4f5d-3691-08d767685c0a
Content-Transfer-Encoding: quoted-printable
X-Forefront-PRVS: 021975AE46
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aK7bvXKI0GFCv+Eoueuv7viDUecYs6cyr9ehSIkL56IYqXArybKdnb4aPOSdN6RqOfkDTLQFl1HjKY8fHFcuHJR6A3yH78tPKnwQqUHwe28oDEgo+1599H8vSjvwJUVL+4JAkqswq0ksyX8y4G5HdxL+X1TlVEAM94K0MBs42//eihjH3/WphRnMfZ01a4m5eJmuNVHZ6xgyu9MrgWypjX12Fx1imUTM4LPSKvQ4Fz5Tc76zOE1kyB4wmjqAXzQvYwbv4IvtF5tCEbbStAUwXGh3dmq73qvjXpN2uM49YTnk846FioTlWiaNwyzvlhYcTlnEQBDDJz6VWqwHRVPbb+ICc+JCGtb5zKMwt1gN808ncL2TFjqu7inm6pUDH8K9kbau+cwjJW3vcM7f/1QnnffcQd5GD7BboF42+TcSGjD9VRW8VKLvta9BkzPGtACB
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2019 12:03:51.2157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 491d4e36-3ba8-4bdb-6176-08d7676861fb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB4672
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Nov 11, 2019 at 05:52:03PM -0500, Steven Rostedt wrote:
> On Thu,  7 Nov 2019 10:51:06 +0000
> vincent.donnefort@arm.com wrote:
>
> > From: Vincent Donnefort <vincent.donnefort@arm.com>
> >
> > The tracing file saved_cmdlines_size allows setting the number of entri=
es
> > that saved_cmdlines will contain. The latter is then dumped into the
> > trace.dat file to map PIDs with comm. The default value is 128.
> >
> > Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
> >
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index 7260d27..a4e10a4 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -229,6 +229,7 @@ struct common_record_context {
> >     int topt;
> >     int do_child;
> >     int run_command;
> > +   int saved_cmdlines_size;
> >  };
> >
> >  static void add_reset_file(const char *file, const char *val, int prio=
)
> > @@ -1810,6 +1811,39 @@ static void set_options(void)
> >     }
> >  }
> >
> > +static void set_saved_cmdlines_size(struct common_record_context *ctx)
> > +{
> > +   char *path, *str;
> > +   int fd, len, ret;
> > +
> > +   if (!ctx->saved_cmdlines_size)
> > +           return;
> > +
> > +   path =3D tracecmd_get_tracing_file("saved_cmdlines_size");
> > +   if (!path)
> > +           goto err;
> > +
> > +   reset_save_file(path, RESET_DEFAULT_PRIO);
> > +
> > +   fd =3D open(path, O_WRONLY);
> > +   tracecmd_put_tracing_file(path);
> > +   if (fd < 0)
> > +           goto err;
> > +
> > +   len =3D asprintf(&str, "%d", ctx->saved_cmdlines_size);
> > +   if (len < 0)
> > +           die("%s couldn't allocate memory", __func__);
> > +
> > +   if (write(fd, str, len) > 0)
> > +           ret =3D 0;
> > +
> > +   close(fd);
> > +   free(str);
> > +err:
> > +   if (ret)
> > +           warning("Couldn't set saved_cmdlines_size");
> > +}
> > +
> >  static int trace_check_file_exists(struct buffer_instance *instance, c=
har *file)
> >  {
> >     struct stat st;
> > @@ -5480,7 +5514,7 @@ static void parse_record_options(int argc,
> >             if (IS_EXTRACT(ctx))
> >                     opts =3D "+haf:Fp:co:O:sr:g:l:n:P:N:tb:B:ksiT";
> >             else
> > -                   opts =3D "+hae:f:FA:p:cC:dDGo:O:s:r:vg:l:n:P:N:tb:R=
:B:ksSiTm:M:H:q";
> > +                   opts =3D "+hae:f:FA:p:cC:dDGo:O:s:r:vg:l:n:P:N:tb:R=
:B:kK:sSiTm:M:H:qK";
> >             c =3D getopt_long (argc-1, argv+1, opts, long_options, &opt=
ion_index);
> >             if (c =3D=3D -1)
> >                     break;
> > @@ -5741,6 +5775,9 @@ static void parse_record_options(int argc,
> >             case 'k':
> >                     keep =3D 1;
> >                     break;
> > +           case 'K':
> > +                   ctx->saved_cmdlines_size =3D atoi(optarg);
> > +                   break;
>
> Perhaps we should make this a long variable --cmdline-size(?), and not
> yet give it a short option.

Hi Steve,

Thank you for your review. I also thought that we could avoid having a new
option and try to write /proc/sys/kernel/threads-max into saved_cmdlines_si=
ze,
before recording the trace. Do you think that would be a more suitable
solution?

--
Vincent

>
> >             case 'i':
> >                     ignore_event_not_found =3D 1;
> >                     break;
> > @@ -5990,6 +6027,7 @@ static void record_trace(int argc, char **argv,
> >                     enable_events(instance);
> >     }
> >
> > +   set_saved_cmdlines_size(ctx);
> >     set_buffer_size();
> >     update_plugins(type);
> >     set_options();
> > diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
> > index b5788f7..ddfb480 100644
> > --- a/tracecmd/trace-usage.c
> > +++ b/tracecmd/trace-usage.c
> > @@ -47,6 +47,7 @@ static struct usage_help usage_help[] =3D {
> >             "          -b change kernel buffersize (in kilobytes per CP=
U)\n"
> >             "          -B create sub buffer and following events will b=
e enabled here\n"
> >             "          -k do not reset the buffers after tracing.\n"
> > +           "          -K change kernel saved_cmdlines_size\n"
>
> We would also want to update the man pages too.
>
> Thanks!
>
> -- Steve
>
> >             "          -i do not fail if an event is not found\n"
> >             "          -q print no output to the screen\n"
> >             "          --quiet print no output to the screen\n"
>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
