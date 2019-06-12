Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B6DFC31E46
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 14:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 587092082C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 14:28:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="Onxdx0be"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437325AbfFLO2n (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 10:28:43 -0400
Received: from mail-eopbgr750075.outbound.protection.outlook.com ([40.107.75.75]:59405
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437330AbfFLO2m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 10:28:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=COEY4MuTh6wd0oQ45ASyI2Su6MNcPToBjP4jSEN4J6Q=;
 b=Onxdx0bejUA9RwNNinnoNYTbs1nBO4I7Cehcg+DQtMgENimqTahcWcy77XpO+W8SU76lB8+wqKK9QDW5l9wf9u/6HmkA4WOoFaicxjJDCtCAGbs5PgbtrNREBdVTvtefEawJE9XeKxed9TR7/Jjmja/A0FhPMieuLy26GzRQEiA=
Received: from DM5PR0501MB3767.namprd05.prod.outlook.com (10.167.107.158) by
 DM5PR0501MB3879.namprd05.prod.outlook.com (10.167.108.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.5; Wed, 12 Jun 2019 14:28:37 +0000
Received: from DM5PR0501MB3767.namprd05.prod.outlook.com
 ([fe80::483c:b180:be3e:3323]) by DM5PR0501MB3767.namprd05.prod.outlook.com
 ([fe80::483c:b180:be3e:3323%4]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 14:28:37 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Make the version defines part of tc-version.h
Thread-Topic: [PATCH] trace-cmd: Make the version defines part of tc-version.h
Thread-Index: AQHVIR2XCaHUhXS7IUytHIJE3s5GD6aYFAGA
Date:   Wed, 12 Jun 2019 14:28:36 +0000
Message-ID: <70e900ae868289f182f8e4d3bc457aa62d8443aa.camel@vmware.com>
References: <20190612085136.248a4a0e@gandalf.local.home>
In-Reply-To: <20190612085136.248a4a0e@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-originating-ip: [146.247.46.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa1cf022-9759-4da9-1f2f-08d6ef4241f0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM5PR0501MB3879;
x-ms-traffictypediagnostic: DM5PR0501MB3879:
x-microsoft-antispam-prvs: <DM5PR0501MB3879606C8C1DC81204D1DBC0DAEC0@DM5PR0501MB3879.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(346002)(376002)(136003)(199004)(189003)(86362001)(8936002)(1730700003)(2906002)(8676002)(68736007)(81166006)(81156014)(2616005)(446003)(11346002)(91956017)(71190400001)(71200400001)(486006)(476003)(4744005)(6116002)(3846002)(256004)(14444005)(7736002)(305945005)(5660300002)(26005)(36756003)(478600001)(53936002)(66066001)(186003)(66476007)(66556008)(64756008)(73956011)(76116006)(66446008)(6512007)(14454004)(25786009)(102836004)(5640700003)(66946007)(6506007)(316002)(2351001)(76176011)(4326008)(6436002)(6486002)(99286004)(229853002)(2501003)(6246003)(118296001)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR0501MB3879;H:DM5PR0501MB3767.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: L6nsPQiSu8zqZ6fnFrdv6M5i3aDgHS1bieWTx7EDsqN3NijGuw9two7R8/tNsQntvslh5vMpfQP5I+jXRPE0ZvIoIC2CZHnWr59lOsAYOlbFRRtrAEjdEfXFhSfPvh3YJBHozIGV00V5zwV5nC20uZ+6KmIuVNcaBzcDZ2RTc4bLAUYBUbsnv+U4CCewfnJbn9/rQkvXvcc74Di59uD1rwy1QcHxK53vZRjtyOEUGFSAztY14rLew0DHYs5o/wARM2cTA65Eln5y1DcTWZScrIjpBiLvOmDUo24eLiX7ZqGrCO/XwBMkuQJWIWgdSm+dhLg0LmGAY6UzhMtfZWy+JS8lj7qqrk5R7xoBRxpYC4idUaBDtRQDIpKu64mvoCOZzJIhUEwIdLmM2mUCwt2SWulvIVFN2jxn2mOZhonqIJI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6FD9FB9BD4675F40AF5B279528EBFF29@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa1cf022-9759-4da9-1f2f-08d6ef4241f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 14:28:37.1010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kaslevs@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0501MB3879
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCAyMDE5LTA2LTEyIGF0IDA4OjUxIC0wNDAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gRnJvbTogIlN0ZXZlbiBSb3N0ZWR0IChWTXdhcmUpIiA8cm9zdGVkdEBnb29kbWlzLm9yZz4N
Cj4gDQo+IE1vdmUgdGhlIHZlcnNpb24gc3RyaW5nIGNyZWF0aW9ucyBhcyBwYXJ0IG9mIHRoZSB0
Yy12ZXJzaW9uLmggZmlsZSwNCj4gYW5kIGhhdmUNCj4gdHJhY2UtcmVjb3JkLmMgaW5jbHVkZSBh
bmQgdXNlIHRoYXQuIFRoZSBWRVJTSU9OX1NUUklORyBpcyBhbHJlYWR5DQo+IGRlZmluZWQNCj4g
YW5kIG9ic29sZXRlcyBUUkFDRUNNRF9WRVJTSU9OLiBGb3IgY29uc2lzdGVuY3ksIHVzZSBWRVJT
SU9OX0dJVCB0bw0KPiBkZWZpbmUNCj4gdGhlIGdpdCBzaGExLiBBbHNvLCBhZGQgbG9naWMgdG8g
ZGV0ZWN0IGlmIHRoZSBzb3VyY2UgZmlsZSBpcyBhIGdpdA0KPiByZXBvLA0KPiBhbmQgdXNlICJu
b3QtYS1naXQtcmVwbyIgYXMgdGhlIHNoYTEgaWYgaXQgaXMgbm90IGZvdW5kLiBBZGQgYSAiKyIg
dG8NCj4gdGhlDQo+IGVuZCBvZiB0aGUgZ2l0IHNoYTEgaWYgdGhlIHJlcG8gaGFzIG1vZGlmaWNh
dGlvbnMgaW4gaXQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTdGV2ZW4gUm9zdGVkdCAoVk13YXJl
KSA8cm9zdGVkdEBnb29kbWlzLm9yZz4NCg0KVGhhbmtzLCBTdGV2ZW4uIEkgY29tcGxldGVseSBt
aXNzZWQgdGMtdmVyc2lvbi5oIGhlYWRlcidzIGV4aXN0ZW5jZSBpbg0KdGhlIGluaXRpYWwgcGF0
Y2guDQoNClJldmlld2VkLWJ5OiBTbGF2b21pciBLYXNsZXYgPGthc2xldnNAdm13YXJlLmNvbT4N
Cg0KQ2hlZXJzLA0KDQotLVNsYXZpDQo=
