Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93050C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 15:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 644522183E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 15:39:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="Jk6QEl3a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbfCVPjQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 11:39:16 -0400
Received: from mail-eopbgr790074.outbound.protection.outlook.com ([40.107.79.74]:11913
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726788AbfCVPjP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 11:39:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4F/t44q18evF0X6IgDm8eA0d3fR7Mscy1faCEjmjY6I=;
 b=Jk6QEl3aFVmTC1xkLUHUSGXgVH8heD9bfa/MZiWhTKd7XGoxVC2I3L72pBZAQ9fpauLizwgONlwp6KMrU01WmWsqPt2IF+tTwQsL9HSj7jMLO29q7ydTJ3+OFXFRErXmIxEhAabT5Jyx4i0iihVY+bu2O6/ylwUlDBI5Zp/iqgs=
Received: from CY1PR05MB2780.namprd05.prod.outlook.com (10.167.18.26) by
 CY1PR05MB2697.namprd05.prod.outlook.com (10.167.11.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.12; Fri, 22 Mar 2019 15:39:11 +0000
Received: from CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f]) by CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f%9]) with mapi id 15.20.1730.003; Fri, 22 Mar 2019
 15:39:11 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Change tracecmd_msg's buf member type to char
 *
Thread-Topic: [PATCH] trace-cmd: Change tracecmd_msg's buf member type to char
 *
Thread-Index: AQHU4MOGVljMvMEBtEuJItHgRZ2gkqYXyS4A
Date:   Fri, 22 Mar 2019 15:39:11 +0000
Message-ID: <CAE0o1Nvph5RHtEuT7rQMtrLyA76B4yVb8rxFKQupYzNLdTkFpw@mail.gmail.com>
References: <20190322150105.24136-1-kaslevs@vmware.com>
 <20190322112542.0bf2e37d@gandalf.local.home>
In-Reply-To: <20190322112542.0bf2e37d@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:4:3b::34) To CY1PR05MB2780.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::26)
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAWUUHc7OR0H/lf5Xnhd2EbHMDQ/ASYONcEYDHKXOCMBN81rlV6a
        7eGVPP1aSHWHQx95xrdzRXx5YHIpf8VeYzXYaw==
x-google-smtp-source: APXvYqyUoDU2PwdRdlqetbKecpI/VHdnxHvjJYhXtWRaYoYM11LwCumCtHpeavN/8Sj3p+tS3tirMxCwfJVyFAkbGPU=
x-received: by 2002:a05:660c:7c1:: with SMTP id
 e1mr1787493itl.73.1553269146584; Fri, 22 Mar 2019 08:39:06 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1Nvph5RHtEuT7rQMtrLyA76B4yVb8rxFKQupYzNLdTkFpw@mail.gmail.com>
x-originating-ip: [209.85.166.169]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b2cc3f9-676e-4764-b921-08d6aedc8715
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2697;
x-ms-traffictypediagnostic: CY1PR05MB2697:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CY1PR05MB2697C57D8241CAAC28A5A253DA430@CY1PR05MB2697.namprd05.prod.outlook.com>
x-forefront-prvs: 09840A4839
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(346002)(136003)(39860400002)(396003)(189003)(199004)(43544003)(229853002)(9686003)(6512007)(498394004)(7736002)(305945005)(71200400001)(6486002)(26005)(4326008)(71190400001)(6346003)(6306002)(2906002)(102836004)(186003)(6436002)(106356001)(54206008)(256004)(61266001)(86362001)(4744005)(66066001)(105586002)(14454004)(55446002)(76176011)(478600001)(966005)(97736004)(53546011)(6506007)(386003)(52116002)(61726006)(316002)(6116002)(3846002)(8676002)(53936002)(476003)(8936002)(6862004)(81166006)(81156014)(68736007)(5660300002)(11346002)(6246003)(486006)(25786009)(446003)(99286004)(95326003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2697;H:CY1PR05MB2780.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gz0NtZ6E6Erp4ExI1OR8asGqAPnbYyfutNbBzYYhXNLxPQo8Ipa2G2ai8R6ovMbPaw6hUqIKRXudUWPImLrO9DiMruqTHBozNhorpduLXk0V7nmImhDj9hLqx6ArOkuaO7jQyhLCxNpr7J/jcs9KTZnqwnH0udHT46LnXxJ+n6XTa0Y4mFk644hkmaVrQk0ydP7wNZAI/Q7oe+oGzxAF96dK4lnhkj5S1x82KEu7kyEbUqlrwiEpgflPi5O8t32EngINwo+rPnOIh49i5D9EDYRpO+Eolu5jpEAWI7fSQ8nlWru9X9davQLJvHgzfUGTnyVz6MGCsL5JT6FHSszNQxTufY9VHLVGF3DpWftm0D/cOJvCenkC0qC/T4kQglgSxko/A97qfF0bcP34Z4U1mZFyCLllMPIKBBD6FqIGv0Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A52D0F492750F54B8647FC6777D4AA2F@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b2cc3f9-676e-4764-b921-08d6aedc8715
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2019 15:39:11.1927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2697
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gRnJpLCBNYXIgMjIsIDIwMTkgYXQgNToyNSBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IE9uIEZyaSwgMjIgTWFyIDIwMTkgMTc6MDE6MDUgKzAy
MDANCj4gU2xhdm9taXIgS2FzbGV2IDxrYXNsZXZzQHZtd2FyZS5jb20+IHdyb3RlOg0KPg0KPiA+
IE5vdyB0aGF0IHRoZSBidWZmZXIgZm9yIHByb3RvY29sIFYzIG1lc3NhZ2VzIGlzIGFsd2F5cyB0
ZXh0LCBpdCBtYWtlcyBzZW5zZSB0bw0KPiA+IGhhdmUgaXQgZGVjbGFyZWQgYXMgc3VjaCBhbmQg
ZHJvcCBhIGZldyBjYXN0cy4NCj4NCj4gSXMgaXQgYWx3YXlzIHRleHQ/DQo+DQo+IFdoZW4gZGVi
dWdnaW5nIHRoZSBsaXN0ZW5lciBJIHNhdyB0aGUgbWV0YSBkYXRhIHNlbnQgYXMgbm9uIHRleHQu
DQo+DQo+ICB0cmFjZWNtZF9tc2dfZGF0YV9zZW5kKCkNCj4NCj4gU2VuZHMgdGhlIGRhdGEgaW4g
YmluYXJ5LCBub3QgdGV4dC4gV2hpY2ggaXMgd2hhdCB3ZSB3YW50Lg0KDQpZb3UncmUgY29tcGxl
dGVseSByaWdodC4gSSBzdGlsbCB0aGluayB0aGF0IGl0IG1ha2VzIHNlbnNlIHRvIGhhdmUNCnRo
YXQgcGF0Y2ggZ28gaW4sIG1heWJlIHdpdGggcmV3cml0dGVuIGNvbW1pdCBtZXNzYWdlLg0KSW4g
dHJhY2VjbWRfbXNnX3JlYWRfZGF0YSgpWzFdIHdlIGRvIHBvaW50ZXIgYXJpdGhtZXRpYyBvbiB2
b2lkDQpwb2ludGVyIHdoaWNoIGlzIHVuZGVmaW5lZCBiZWhhdmlvciAodGhvdWdoIGdjYyBhbGxv
d3MgaXQgdW5sZXNzDQotcGVkYW50aWMtZXJyb3JzIGlzIHBhc3NlZCkgYW5kIHRoaXMgcGF0Y2gg
d2lsbCB0YWtlIGNhcmUgb2YgaXQuDQoNClNob3VsZCBJIHJlc2VuZCBvciBkcm9wIGl0Pw0KDQpb
MV0gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvcm9zdGVk
dC90cmFjZS1jbWQuZ2l0L3RyZWUvdHJhY2VjbWQvdHJhY2UtbXNnLmMjbjY2NQ0KDQotLSBTbGF2
aQ0K
