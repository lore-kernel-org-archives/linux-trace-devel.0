Return-Path: <SRS0=Fk9f=SG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF23FC4360F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Apr 2019 14:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 844622147C
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Apr 2019 14:35:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="mMAdf16Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfDDOfZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Apr 2019 10:35:25 -0400
Received: from mail-eopbgr730081.outbound.protection.outlook.com ([40.107.73.81]:10095
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727341AbfDDOfZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Apr 2019 10:35:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IfQOfHuqZrBhDhhDvlhzt+KZMbhqSIJf1V0HIOIx9mM=;
 b=mMAdf16Zs4Xr3nvcM9nTfWoUpamuVdy5jYZrmEi0PIm24Ov0LpMwLcwlGvu46oND2rz+GLg82ejX+JMUwJf8I3nKXUIQd6gThIslldY8NyDNvDwRkTCU5GB+hAxPckDNLLA2y8Es5D/KIqFk+U7B0gonrYZtpVmmgDiE808UjBQ=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3712.namprd05.prod.outlook.com (10.167.140.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.11; Thu, 4 Apr 2019 14:35:22 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::9863:fa92:a642:b111]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::9863:fa92:a642:b111%2]) with mapi id 15.20.1771.007; Thu, 4 Apr 2019
 14:35:22 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Test sending plain text from Outlook
Thread-Topic: Test sending plain text from Outlook
Thread-Index: AQHU6vOiOzUErVNg3kKsDVa0JLKe7g==
Date:   Thu, 4 Apr 2019 14:35:22 +0000
Message-ID: <SN4PR0501MB39031F252456BEAE4E74FD75A0500@SN4PR0501MB3903.namprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-originating-ip: [146.247.46.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13904706-a772-4732-a0bd-08d6b90ac518
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600139)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:SN4PR0501MB3712;
x-ms-traffictypediagnostic: SN4PR0501MB3712:
x-microsoft-antispam-prvs: <SN4PR0501MB371264E426B7CFAA3C14497BA0500@SN4PR0501MB3712.namprd05.prod.outlook.com>
x-forefront-prvs: 0997523C40
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(366004)(376002)(39860400002)(136003)(47540400005)(199004)(189003)(52536014)(555874004)(558084003)(106356001)(2351001)(105586002)(2501003)(478600001)(81166006)(476003)(256004)(81156014)(25786009)(14454004)(4270600006)(33656002)(45080400002)(52230400001)(486006)(19618925003)(68736007)(8676002)(316002)(53936002)(2906002)(7696005)(71190400001)(6436002)(8936002)(86362001)(6116002)(5640700003)(3846002)(305945005)(7736002)(6916009)(99286004)(9686003)(74316002)(66066001)(26005)(186003)(97736004)(6506007)(55016002)(102836004)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3712;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: V/UQDGO2Wf56AZW0tzqsGYXUGzCcWUYL4BgBXqI9Pdsj1OjSSCIrjSUQj827AdKCvLcEr+DfChVnaf60BulfpKSga4OdMQuVM8DQws7Ys9If8HPtg6W/u80eQwSJV0fGU3+goXP4EgPO3O/LW3htUt1R7h0vHw4/1MLh7TKSiP8HcaFfO45773vX4zG0h5XYjOj9Yaft2vEQBmNozbXtyretqJ9TznYWdU7ghWIsqGzp6AAyDbxEH9rindfD3vXv0e0/VV+Nc3CgwlGr21mMmAZuMueEkquQdVcnGrdf/Jk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13904706-a772-4732-a0bd-08d6b90ac518
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2019 14:35:22.6070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3712
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

test email=0A=
