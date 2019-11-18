Return-Path: <SRS0=Fwee=ZK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 120EBC432C3
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Nov 2019 11:29:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C863D2067D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Nov 2019 11:29:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="3kId43Lq";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="Sz1XTkmY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfKRL3g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 06:29:36 -0500
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:43846
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726539AbfKRL3g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 06:29:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Otz24B7v1UWos/hDYeTW7dPpNTHZJP9llhtwi7EoFZs=;
 b=3kId43LqZecffSvn86zxeDgzCMSIxmCMN6jSIl+P47pGiTwXGzYA6xODLTkiV9XfM4zRTpenUS/59PmyEcGIczQjmWqZTG10YKE0laFfKmxUdhdg82X/BHXORqKLZTxE6vo40yJfcfQzUAV1ppdQC13wgjSQDak+JSMsppXfWgw=
Received: from VI1PR0802CA0044.eurprd08.prod.outlook.com
 (2603:10a6:800:a9::30) by AM6PR08MB4914.eurprd08.prod.outlook.com
 (2603:10a6:20b:cf::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.23; Mon, 18 Nov
 2019 11:29:26 +0000
Received: from DB5EUR03FT061.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::208) by VI1PR0802CA0044.outlook.office365.com
 (2603:10a6:800:a9::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.23 via Frontend
 Transport; Mon, 18 Nov 2019 11:29:26 +0000
Authentication-Results: spf=fail (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: Fail (protection.outlook.com: domain of arm.com does not
 designate 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT061.mail.protection.outlook.com (10.152.21.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23 via Frontend Transport; Mon, 18 Nov 2019 11:29:26 +0000
Received: ("Tessian outbound 0cf06bf5c60e:v33"); Mon, 18 Nov 2019 11:29:26 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 12cda17336344904
X-CR-MTA-TID: 64aa7808
Received: from c100fc60e737.1 (cr-mta-lb-1.cr-mta-net [104.47.0.58])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id E74A4BB1-D2D3-4B9F-B36C-C7624053B0E4.1;
        Mon, 18 Nov 2019 11:29:20 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01lp2058.outbound.protection.outlook.com [104.47.0.58])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c100fc60e737.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 18 Nov 2019 11:29:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QawAQVCyjbvm97rLr1xU0oQkcy2m1gW/npY0/lTwdZPtnbbeuaZd/VcFldRlzm1EJ5wViWmcRn2xpAdzyrZ8el+6wiDxdp/46UlklsxFVbKwYOgmxNvQIJqPDd+pkGFCD8PRkikBLkFrr9Z07dgvJsQIP9GAN5yWFaboCenlu+ZFCzkqP9KuC4zcMUDXm+sm2rLtUAktcqAntLFmgmboeRtfw9jfvBH6dbP3a/spMK74ZalAeBhh2aiRygKAHZfZjKnqjzfKWbQwtyvTHr1cJf+cfAj/sEcCqDFXPx1JhtSa0wioeKEgvEjY4mvw/wl+O/I8Rra+ZUtAt6bE8087Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZFrdqBszgE6FIpfdgaK0I0V3HhSP/uYf8uFKKRSzcw=;
 b=ei4xmkO4+96lMOCwEhQmJLNDjXSnE6nPlhJoGhXkbgwSaTouojYBGMDloNqWaScIfCWJpVkw5HUMsBJPqhsy+Dnf3niYHv2fcxANPoT7ny72rmKQXuukgdeN4C4IH7HqJjdeBfqS44872+0tX4/lLuDE9ypsMOlJawpOZfIM/XoN9PmkgtaekX7VHZrbKsxRaT/6BW2nTK2eDrF4YaLpJldFk9N3pgj60fbrU+aJZM5Evjrpir6WSUSQ8BiYiPIlAFRWvXhK13O1jlHkedGUt2ljmmFesuonwefHyf/xIfbL7EETG0JrIIbtG92kv/NZ8yCkvE6HBtY9Ij2IkREpvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZFrdqBszgE6FIpfdgaK0I0V3HhSP/uYf8uFKKRSzcw=;
 b=Sz1XTkmYSrIjghUpWXnlwwuZt/QZ8KRZC0FmdovGNI30/h+rZNch3mFb0lHoxz28NIWWFzaBzknaI0ecL3iuMW3IJ2Yohs/praQ/oh/bmWILENsdD8QSgURz+vlU0W4qNPoRMfjvZwBoDFyWDcMuLFzd1CCu1HRgf6baDgcRKCQ=
Received: from DB7PR08MB3468.eurprd08.prod.outlook.com (20.177.120.139) by
 DB7PR08MB3563.eurprd08.prod.outlook.com (20.177.121.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Mon, 18 Nov 2019 11:29:18 +0000
Received: from DB7PR08MB3468.eurprd08.prod.outlook.com
 ([fe80::313e:734c:22f6:1869]) by DB7PR08MB3468.eurprd08.prod.outlook.com
 ([fe80::313e:734c:22f6:1869%5]) with mapi id 15.20.2451.029; Mon, 18 Nov 2019
 11:29:18 +0000
From:   Matthew Clarkson <Matthew.Clarkson@arm.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
CC:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "joelaf@google.com" <joelaf@google.com>
Subject: Invoke trace event in registration callback function
Thread-Topic: Invoke trace event in registration callback function
Thread-Index: AQHVnf9kIQazFKuwrUu+N39Yjo6R2A==
Date:   Mon, 18 Nov 2019 11:29:18 +0000
Message-ID: <DB7PR08MB3468AE078C09C8605477EE73964D0@DB7PR08MB3468.eurprd08.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Matthew.Clarkson@arm.com; 
x-originating-ip: [217.140.106.49]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f88911eb-54d4-4ef1-805a-08d76c1a919b
X-MS-TrafficTypeDiagnostic: DB7PR08MB3563:|AM6PR08MB4914:
X-Microsoft-Antispam-PRVS: <AM6PR08MB491406CCD0144FFD746BA4DA964D0@AM6PR08MB4914.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
x-forefront-prvs: 0225B0D5BC
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(199004)(189003)(14454004)(9686003)(7736002)(102836004)(6506007)(81166006)(81156014)(256004)(33656002)(54906003)(8936002)(7696005)(6116002)(3846002)(74316002)(110136005)(55016002)(316002)(6436002)(6306002)(86362001)(478600001)(25786009)(4326008)(305945005)(99286004)(66446008)(64756008)(71200400001)(71190400001)(66556008)(66946007)(8676002)(66476007)(52536014)(91956017)(66066001)(5660300002)(76116006)(26005)(186003)(476003)(2501003)(486006)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR08MB3563;H:DB7PR08MB3468.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: fHIguMrZoMdzoMhhEsxtNvgqplIIsRrRKwWF+mVEfvE2PQ/1/a9W9qKuamnZS1G9OEBBK7WGRotge4kPRhPhVzwaKbRRi5vnkkOUe2qAwdxEMen4crmGTlCG3AvLg+27TQIILI4lK0nHLmUt/DtfyY8tXmQ00c9ugMfkE2XDIKQE5bNiwYZFSMG62xi15Vd6x14NK9z8NLh4pL5MED/Sk75j2doVmkzf/3iUle9rfUMzyjmsvfkHAcdXu2CDSAg0H4zxOV8ThtBZKBXN+SSaRM+RCi0RGaKr4jM0TAFAErqh78hAPJEMJpJ5EWoxfaw4S4NrJae97bglLTdJEk+eSIINQq0egYXxlZlei6SnAQC4lC73xgKxP0I9KH4gFDNMbhBG/LASD04NTXtwLmfKbe7ITuMjik1I/+wT/PoRSMC5c8Dcj/w1cOZSbEqTOqJQ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3563
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Matthew.Clarkson@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT061.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(136003)(376002)(1110001)(339900001)(40434004)(189003)(199004)(336012)(8676002)(450100002)(2501003)(3846002)(4326008)(316002)(47776003)(478600001)(14444005)(356004)(99286004)(33656002)(6306002)(126002)(9686003)(8746002)(54906003)(7696005)(186003)(102836004)(26005)(6506007)(476003)(22756006)(23756003)(486006)(2906002)(81156014)(81166006)(8936002)(55016002)(107886003)(6116002)(76130400001)(5024004)(66066001)(110136005)(70206006)(70586007)(25786009)(305945005)(74316002)(50466002)(14454004)(86362001)(52536014)(5660300002)(105606002)(26826003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR08MB4914;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Fail;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 0daed88a-b143-4f36-8151-08d76c1a8cdb
X-MS-Exchange-PUrlCount: 1
X-Forefront-PRVS: 0225B0D5BC
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pTHq2siAZcA+qvecACcIDYsJWtsYOizxSOTo/Ths0nDT0N67ojPgdcdAK6zvk4fG2xIN+/0bv56/mJ9if2Ddd+InCjfWHMaa6OCPIASCIyTvHg4uvlwinVyBzGkuw2X/DVa89KduXKSNH5IRsO79rT/GS3ZAnGdxoqxXCp00xehxRoPdnMCTHf+bKj0GNknbD8YMnIFewd/5sdNUYq33ds8a7L10Tmv118gpN/PGzQcERL5K3Kl91rIhJgX9pcnCI61e2T/k2YCSP0XAfZHFQ8EDmzcOIKHDR0nlrh2LVR5piFIYkBwh5cLGttmnlHXeIVcTWsCqCgI9T92Ce1I3+kmT6s9kbU9alrtLGFrfYgW8RBbrkfiY3SUlmRdpmAoJ7eGKAv2T3jcbCoxzcCZYoRa9A59nPxxyzihrJa4z4BPrhvG7D6TgWKclUAgjp5pUVfEqknUQKppWlSWpRRkcTpbWsRnKKUIll399W0kpYEs=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2019 11:29:26.3240
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f88911eb-54d4-4ef1-805a-08d76c1a919b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4914
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We are looking to introduce a power/gpu_frequency trace event for Mali GPUs=
. This integrates nicely with Google's Perfetto (https://perfetto.dev/) ftr=
ace reader to provide a graph of the GPU frequency against GPU workloads.

Google would like for the trace event to output the current GPU frequency w=
hen the tracepoint is activated. This is so that if there is no frequency c=
hange during the trace the current GPU frequency is known and an unchanging=
 frequency graph can be shown.

To do this we tried adding a registration function to the trace event:

        DEFINE_EVENT_FN(gpu, gpu_frequency,
                TP_PROTO(unsigned int frequency, unsigned int gpu_id),
                TP_ARGS(frequency, gpu_id),
                trace_gpu_frequency_register,  // <-- added
                trace_gpu_frequency_unregister
        );

Which invokes the trace point when registered:

        static void log_all_gpu_frequencies(void) {
                // In production would log the actual current GPU frequency
                printk("gpu: frequency: %lu\n", 5000);
                trace_gpu_frequency(5000, 0);
        }

        int trace_gpu_frequency_register(void) {
                printk("gpu: register\n");
                log_all_gpu_frequencies();
                return 0;
        }

        void trace_gpu_frequency_unregister(void) {
                printk("gpu: unregister\n");
        }

When performing a trace, there is no data received from the trace point eve=
n though the dmesg output shows that the registration callback was invoked.=
 Perfetto also does not receive the event either.

        $ sudo trace-cmd record -e power:gpu_frequency
        /sys/kernel/tracing/events/power/gpu_frequency
        Hit Ctrl^C to stop recording
        $ dmesg
        [Nov18 10:02] gpu: register
        [  +0.002699] gpu: frequency: 5000
        [  +7.783861] gpu: unregister

Is it acceptable to invoke a trace point in the registration callback? Is t=
he trace point not full initialized at that point?
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
