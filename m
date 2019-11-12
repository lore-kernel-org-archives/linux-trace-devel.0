Return-Path: <SRS0=qtAn=ZE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D80C43331
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Nov 2019 19:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A4CB206BA
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Nov 2019 19:03:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="S2KPu9yG";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="cR2Z5yS0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfKLTDA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 14:03:00 -0500
Received: from mail-eopbgr150073.outbound.protection.outlook.com ([40.107.15.73]:9358
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726718AbfKLTDA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 14:03:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wif9vQBAFWgVfcBINEg93mQZvYoXfqc69w310XfbRPs=;
 b=S2KPu9yG3XfsqipAXZnSQGJeZsksL6yEG5p1JgyRCeK2LABFYAGQ/ut0yJGIn14NXKruoTR3a/NZyWcWAStQFx5eX6BupBZoEtCJlV42JFNveQw8SEAm2euRXryx4QPJsvL1SsyDwy6F19LvcKpFxz32HLibsfUv5IDdIgI9gqs=
Received: from VI1PR08CA0140.eurprd08.prod.outlook.com (2603:10a6:800:d5::18)
 by VE1PR08MB4704.eurprd08.prod.outlook.com (2603:10a6:802:b0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.22; Tue, 12 Nov
 2019 19:01:13 +0000
Received: from VE1EUR03FT026.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::205) by VI1PR08CA0140.outlook.office365.com
 (2603:10a6:800:d5::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.23 via Frontend
 Transport; Tue, 12 Nov 2019 19:01:13 +0000
Authentication-Results: spf=fail (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: Fail (protection.outlook.com: domain of arm.com does not
 designate 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT026.mail.protection.outlook.com (10.152.18.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.21 via Frontend Transport; Tue, 12 Nov 2019 19:01:13 +0000
Received: ("Tessian outbound 081de437afc7:v33"); Tue, 12 Nov 2019 19:01:13 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 5ef2e5ffaa5c3008
X-CR-MTA-TID: 64aa7808
Received: from 118d14eda259.1 (cr-mta-lb-1.cr-mta-net [104.47.0.57])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 167BD1AC-501B-41B7-88E9-82742F237DEE.1;
        Tue, 12 Nov 2019 19:01:08 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01lp2057.outbound.protection.outlook.com [104.47.0.57])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 118d14eda259.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 12 Nov 2019 19:01:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGW81VCOAMCq1TiSL5gdU3xw3JRBRLVXaEz3q1Y6pVRfRZGj7ZCwrpgmk9zaJhkrKZ/8W0HQvf5cNiAIhwdu7Rp9GypL9aDA42qo0xihFeOQJ65poBMtipk/Mr6o6ZKGP6wxv5+rTX7JW+8eKQC/XlZ+N/cc/2rTAleiNonKureYEGqnvY1V9lrAM1IpDOjoyrhZR9MpXuAPndWH4UheAqogRT4/jA6WtOVXz9i/yXY8GOHudvIRyzgPfR+jRTDhwKVqoGLrzjZA3yTDh7gqtqE8b3V/102wQx/vPllBJHPYi7k4SJcxRMo2jqzy1iDeeX+ycl6435IjHE2I5TZbCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYEP3kS/t89fHCNUH5WXtc5cYvXG1nMYy1HtzqifvDM=;
 b=RU8NGZCHYL7yzVAaaUKNWGnhJiCBWb7HbY2fMJLGZL8I6MVMMannw96I6oSNhzSg1wmrcNQ+RfnAdf9TFCIMFPet9J3N7mNVadgWKOE5oZQBoBULrxafWXU6kL/V4SsDXrAJtg1kV37rTS0mISjmweLm/0dXbucf2pdAkORzs56mlibRUBFXeqHeVitz1HEFctDcN0wT11yzFLncvae9wEv2MmHWhd+PiOWPBrwd1yNsL5GkFDxQXnn2Mf6oCsKMvScpBJE/GhLDy+B55bf6IxfIndVVkLuSwns0y+RX3zlfmUrNmXX/9QWOkto3YR8HxvSSHZhzwLaZxZx+zFp2kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=goodmis.org smtp.mailfrom=arm.com;
 dmarc=bestguesspass action=none header.from=arm.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYEP3kS/t89fHCNUH5WXtc5cYvXG1nMYy1HtzqifvDM=;
 b=cR2Z5yS0AfQsgO5ZDeU/wFzdD1/dtNOlGRpt76n6tTIP4XymSIAK25cKZvbnBAgaZ8MoXWOtgr8zzmlOQALf348i8F4GnNUMLURElCMoXn9c9oTnYHXVhqGQ0IIZOdujEPM+xzk8O4/NCsPvUsyPOgJgQCiiHL4UsLjtn84JC28=
Received: from AM4PR08CA0043.eurprd08.prod.outlook.com (2603:10a6:205:2::14)
 by AM6PR08MB5240.eurprd08.prod.outlook.com (2603:10a6:20b:ec::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.22; Tue, 12 Nov
 2019 19:01:05 +0000
Received: from VE1EUR03FT017.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::205) by AM4PR08CA0043.outlook.office365.com
 (2603:10a6:205:2::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2451.22 via Frontend
 Transport; Tue, 12 Nov 2019 19:01:05 +0000
Authentication-Results-Original: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; goodmis.org; dkim=none (message not signed)
 header.d=none;goodmis.org; dmarc=bestguesspass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com;
Received: from nebula.arm.com (40.67.248.234) by
 VE1EUR03FT017.mail.protection.outlook.com (10.152.18.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.20.2430.21 via Frontend Transport; Tue, 12 Nov 2019 19:01:04 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1415.2; Tue, 12 Nov
 2019 19:01:03 +0000
Received: from e120877-lin.cambridge.arm.com (10.1.194.81) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1415.2 via Frontend
 Transport; Tue, 12 Nov 2019 19:01:03 +0000
Date:   Tue, 12 Nov 2019 19:01:02 +0000
From:   Vincent Donnefort <vincent.donnefort@arm.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/2] trace-cmd: Add an option to set saved_cmdlines_size
Message-ID: <20191112190101.GA178419@e120877-lin.cambridge.arm.com>
References: <1573123866-348262-1-git-send-email-vincent.donnefort@arm.com>
 <1573123866-348262-2-git-send-email-vincent.donnefort@arm.com>
 <20191111175203.252cc439@gandalf.local.home>
 <20191112120314.GA41032@e120877-lin.cambridge.arm.com>
 <20191112094037.651a156f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191112094037.651a156f@gandalf.local.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;IPV:NLI;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(39860400002)(396003)(199004)(189003)(97756001)(23726003)(70206006)(8936002)(2906002)(1076003)(106002)(70586007)(33656002)(4326008)(305945005)(486006)(76176011)(81156014)(81166006)(26005)(8676002)(44832011)(7696005)(186003)(16586007)(47776003)(50466002)(58126008)(5660300002)(316002)(86362001)(55016002)(46406003)(478600001)(426003)(6916009)(229853002)(11346002)(446003)(336012)(126002)(476003)(356004)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR08MB5240;H:nebula.arm.com;FPR:;SPF:Pass;LANG:en;PTR:InfoDomainNonexistent;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d550efd5-56c7-4218-52b0-08d767a2b021
X-MS-TrafficTypeDiagnostic: AM6PR08MB5240:|VE1PR08MB4704:
X-Microsoft-Antispam-PRVS: <VE1PR08MB470471D78E4286B055698787E9770@VE1PR08MB4704.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;OLM:10000;
X-Forefront-PRVS: 021975AE46
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: yuW0YvD24IUZMTH7vGMdDVcbXFNYmp+9vbj5CRYkTsJtHkFeKogRAds+iujUxcH77EoQWsU8Tio0HIudar74wLUz/sBF1W377PTWKS3QTzIA9Ksq2aUoDudXBxXAKq81ZdeymSrmlovd7e2fZYEU++X224eFliO7WgbA0j1zxkl3O4MBopK/hZJtDy5o1U1gddlJnnwPrvvG36q8GvPhVKpoEA5DXKj4QvaVJIY3vvA2tBLnVeuStaWaJfhQFilclK770FqNBA+DDp1KcSTyik/dpWjdL0xGW+iVcyRwAm4OJunzlQrdCcmxb1k3Gd7rwhfH76ZlfZEH5MSD+B5Fz5mDMSrQEfDo8SOaNvdPJ9xijItTD+7SOFrD1dog2KUecMS2q3JKDe/MhYiCNMhHKF0PLCPQ82yUk3K2nPd9jKs4H5B9bnDVioHKe1WDWope
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB5240
Original-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; goodmis.org; dkim=none (message not signed)
 header.d=none;goodmis.org; dmarc=bestguesspass action=none
 header.from=arm.com;
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT026.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(396003)(376002)(136003)(1110001)(339900001)(199004)(189003)(40434004)(186003)(105606002)(8676002)(305945005)(229853002)(81156014)(5660300002)(50466002)(426003)(336012)(2906002)(81166006)(22756006)(26005)(76176011)(8936002)(7696005)(76130400001)(476003)(11346002)(8746002)(1076003)(23726003)(44832011)(47776003)(5024004)(55016002)(4326008)(6246003)(478600001)(446003)(14444005)(70206006)(6862004)(70586007)(486006)(33656002)(97756001)(86362001)(316002)(126002)(36906005)(26826003)(46406003)(58126008);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR08MB4704;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Fail;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 2fc976de-aabf-4a9a-9a65-08d767a2ab01
Content-Transfer-Encoding: quoted-printable
X-Forefront-PRVS: 021975AE46
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dxSgk3Em+SjELdSRQXvipxpfELksZ5vtdeUuuSwVzBCkewXUf/f7MWZ+JiN7QRgz3XUmd5faL05T2gN0iEOsW/AcQuwQivjDk3TWc/gh58QdjKsjo4yvzvPrSQIAvSPXj36+Un+sJusjJNtcQozFeW4yFPs8KROMMaWdbjwakLMf9zF2KnoXFQpyoqxTt1fa5GJ8IWr8BZW8ER6UUmgcZtWYoNqLy7wDElTK5R4nRdVkrr0EeQBms9IgZQRKMaa1ur4ej5V/bO6r2/VyULmvOVemjbazmayqJdJ2D8iZdbiIZa5URg6IFl4Dv+Vv0OAxbi30B88q30EIV3LQa+D4vD8Fr9LVXP77iBx3v7goyceAUwjCAELajx7mCYy2YYM89Vp6wD4SiXnhL7JLd495NqLz0DKv9FFxM8Mgug+J5TBoNGVQHamrS1bCnZgkRuoZ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2019 19:01:13.2390
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d550efd5-56c7-4218-52b0-08d767a2b021
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB4704
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Nov 12, 2019 at 09:40:37AM -0500, Steven Rostedt wrote:
> On Tue, 12 Nov 2019 12:03:15 +0000
> Vincent Donnefort <vincent.donnefort@arm.com> wrote:
>
> > Hi Steve,
> >
> > Thank you for your review. I also thought that we could avoid having a =
new
> > option and try to write /proc/sys/kernel/threads-max into saved_cmdline=
s_size,
> > before recording the trace. Do you think that would be a more suitable
> > solution?
>
> That's an interesting approach. I still think that having a parameter
> would be good as well, but then use the threads-max approach if one is
> not supplied.
>
> -- Steve

This was not a good idea in the end. We can't rely on the sysctl entries
threads-max or pid_max, as the pid/comm map is static and the maximum is
defined by PID_MAX_DEFAULT. I do not see any way of getting this value from
user-space.

We could though, as an alternative, use a hard-coded value of 32768 for
--cmdlines-size. Without being perfect, this should still be true for most =
of
the systems. PID_MAX_DEFAULT depends on CONFIG_BASE_SMALL and hasn't change=
d
since Linux started using Git.

--
Vincent
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
