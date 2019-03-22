Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7985C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 12:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AD542183E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 12:49:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="siZlhVdf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732780AbfCVMtY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 08:49:24 -0400
Received: from mail-eopbgr750082.outbound.protection.outlook.com ([40.107.75.82]:25934
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733270AbfCVMtX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 08:49:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxmwmzpUg6MoNvy0MllVFGW3NfB15+W19vMAZgD+NUE=;
 b=siZlhVdf7lh5oz35EJKVlIBP4SGCvVBgvNQOxoWti3QmDxJqKaRAl19JLUC4+REqSNg8t8c6O7D1+VaV3ayWsHb3o1eRd15C/oZYw+8HQkLg5aVeO1B0Vi/1Ot6NpRgYZPKM9QfXFLB0uOzXg6CihqowfOUbrz+l+YBMDswuNZ8=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2666.namprd05.prod.outlook.com (10.167.11.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.13; Fri, 22 Mar 2019 12:49:17 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec%4]) with mapi id 15.20.1730.013; Fri, 22 Mar 2019
 12:49:17 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Matt Helsley <mhelsley@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tools/lib/traceevent: Implement new traceevent APIs
 for accessing struct tep_handler fields
Thread-Topic: [PATCH 3/3] tools/lib/traceevent: Implement new traceevent APIs
 for accessing struct tep_handler fields
Thread-Index: AQHU3kWjl+JA/enZRUKSXDyrcXeTPaYUuHSAgAHIbgCAAQi3gIAADBUAgAAJBAA=
Date:   Fri, 22 Mar 2019 12:49:17 +0000
Message-ID: <CACqStoejVbMfAp2homPJbWEifOS9+cGDNKNhZyLhmSY9OM_t3Q@mail.gmail.com>
References: <20190319111924.17443-1-tstoyanov@vmware.com>
 <20190319111924.17443-4-tstoyanov@vmware.com>
 <854FD5EF-691D-4BF2-8A1D-FBF6863B5C19@vmware.com>
 <20190321154602.5c49bd38@gandalf.local.home>
 <CACqStof40CSX=rh3B53qAH+kPy6HvePu1Mw9LY1KNzgp93Sd8A@mail.gmail.com>
 <20190322081644.7762c325@gandalf.local.home>
In-Reply-To: <20190322081644.7762c325@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR08CA0003.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::15) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAVCbTF5efZgkuajYLhdp//GlMtfaGLH0c6F/H9g+4iNWSNczCUS
        HMC3g0ny+Yp4x2/TZ6Na//UhI8x+wWLcE0F6yio=
x-google-smtp-source: APXvYqxgH7xkKPArIcjCTl/kCFT1bFY+B5ZTfjj1Bzx/Noxq9yKkH86zsdEl+tR+wEEwY4rQTCCvJfB1u0MwSLujdQc=
x-received: by 2002:a5d:6883:: with SMTP id h3mr6218537wru.215.1553258953311;
 Fri, 22 Mar 2019 05:49:13 -0700 (PDT)
x-gmail-original-message-id: <CACqStoejVbMfAp2homPJbWEifOS9+cGDNKNhZyLhmSY9OM_t3Q@mail.gmail.com>
x-originating-ip: [209.85.221.51]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2331bae4-645c-4a89-284d-08d6aec4cb94
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2666;
x-ms-traffictypediagnostic: CY1PR05MB2666:
x-microsoft-antispam-prvs: <CY1PR05MB26667B9ED2AD7B96205B6CBEDC430@CY1PR05MB2666.namprd05.prod.outlook.com>
x-forefront-prvs: 09840A4839
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(366004)(136003)(396003)(376002)(199004)(189003)(5660300002)(61726006)(95326003)(316002)(478600001)(61266001)(99286004)(68736007)(305945005)(26005)(2906002)(7736002)(3846002)(53546011)(186003)(52116002)(25786009)(256004)(486006)(446003)(102836004)(476003)(11346002)(71190400001)(71200400001)(86362001)(6116002)(386003)(6506007)(53936002)(6246003)(76176011)(66066001)(55446002)(4326008)(14454004)(81166006)(8676002)(8936002)(81156014)(498394004)(97736004)(6436002)(54906003)(105586002)(106356001)(93886005)(6486002)(9686003)(6512007)(6862004)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2666;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lWNgoTiYAhZiXMoCAmsBmBGomCbD+pTK+sttiYR11KyZqjK4HE59KOMT83PRbqvEUSc/GGR+svtWTSoE/qoPxi7oifeRzmCeKhRQ8c2uWmoN1Wjf0IBNOvddxIx3GSzwjwI51102I5nP3/lrOw+P34unEa8c4o4HY2tAInzo0TCZ9cZ0DYcuR1hXSIWu6LmkR/nZtnUE1cFgTrS2yZNRlGYCBrY5BJrJ6/GOarpYMRCAM01ifdVYzwExNVXw4klgcEtCG14VZYr5gANTgRfd6hE+OgQyf03WRiirg14U9kvx8l/qUlQZLwI20dKzbOC2eFTObDR/JX8W8h3RXTvk3tVedK4Mctotq2W3btcCW/Tu6HtfCfnTnSyjnbYgKy4CKdQq7d8LHr1RU0uRurzGzQSPbUjj8Is5o5Z73AxcHRw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1F0888B87B46F41915E8B9DC190DDD3@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2331bae4-645c-4a89-284d-08d6aec4cb94
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2019 12:49:17.5334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2666
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gRnJpLCBNYXIgMjIsIDIwMTkgYXQgMjoxNiBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IE9uIEZyaSwgMjIgTWFyIDIwMTkgMTE6MzM6NDcgKzAw
MDANCj4gVHp2ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJlLmNvbT4gd3JvdGU6DQo+
DQo+DQo+ID4gPiA+DQo+ID4gPiA+IGludCB0ZXBfaG9zdF9iaWdlbmRpYW4odm9pZCk7DQo+ID4g
Pg0KPiA+ID4gUmVuYW1lIHRvOiBib29sIHRlcF9pc19iaWdlbmRpYW4oKQ0KPiA+DQo+ID4gU3Rl
dmVuLCBpbnQgdGVwX2hvc3RfYmlnZW5kaWFuKHZvaWQpIGFjdHVhbGx5IGNoZWNrcyB0aGUgZW5k
aWFubmVzcyBvZg0KPiA+IHRoZSBob3N0IC0NCj4gPiBJIHRoaW5rIGl0IG1ha2VzIHNlbnMgImhv
c3QiIHRvIGJlIHBhcnQgb2YgQVBJJ3MgbmFtZS4gVGhlIG90aGVyIG9uZToNCj4gPiBpbnQgdGVw
X2lzX2hvc3RfYmlnZW5kaWFuKHN0cnVjdCB0ZXBfaGFuZGxlICpwZXZlbnQpIGNoZWNrcyB0aGUN
Cj4gPiBlbmRpYW5uZXNzIHN0b3JlZA0KPiA+IGluIHRoZSB0ZXBfaGFuZGxlLCBJIHRoaW5rIHdl
IHNob3VsZCByZW1vdmUgImhvc3QiIGZyb20gaXRzIG5hbWUuDQo+ID4NCj4NCj4gSSBoYXRlIHRo
ZSB3b3JkICJob3N0IiBoZXJlLiBCZWNhdXNlIHdoYXQgd291bGQgeW91IGdldCBpZiB5b3UgcnVu
IHRoaXMNCj4gb24gYSBndWVzdD8gWW91IGdldCB0aGUgImd1ZXN0IiBlbmRpYW5lc3MgKHdoaWNo
IG1heSBwb3NzaWJseSBiZSBub3QNCj4gdGhlIHNhbWUgYXMgdGhlIGhvc3QgKGlmIGVtdWxhdGVk
KSkuDQo+DQo+DQo+IEkgd2FudCB0byBrZWVwIHRoaXMgYXMgInRlcF9pc19iaWdlbmRpYW4oKSIg
YXMgaXQgZG9lc24ndCB0YWtlIGENCj4gcGFyYW1ldGVyLCBhbmQgaXMgb2J2aW91cyB0byB3aGF0
IGl0IGlzIHJldHVybmluZy4NCj4NCj4gPiA+ID4gaW50IHRlcF9maWxlX2JpZ2VuZGlhbihzdHJ1
Y3QgdGVwX2hhbmRsZSAqcGV2ZW50KTsNCj4gPiA+DQo+ID4gPiBSZW5hbWUgdG86IGJvb2wgdGVw
X2lzX2ZpbGVfYmlnZW5kaWFuKCkNCj4gPiA+DQo+ID4gPiA+IHZvaWQgdGVwX3NldF9maWxlX2Jp
Z2VuZGlhbihzdHJ1Y3QgdGVwX2hhbmRsZSAqcGV2ZW50LCBlbnVtIHRlcF9lbmRpYW4gZW5kaWFu
KTsNCj4gPiA+ID4gaW50IHRlcF9pc19ob3N0X2JpZ2VuZGlhbihzdHJ1Y3QgdGVwX2hhbmRsZSAq
cGV2ZW50KTsNCj4gPiA+DQo+ID4gPiBSZW5hbWUgdG86IGJvb2wgdGVwX2lzX2hvc3RfYmlnZW5k
aWFuKCkNCj4gPiA+DQo+DQo+IExldCdzIHJlbmFtZSB0aGlzIHRvOg0KPg0KPiB2b2lkIHRlcF9z
ZXRfbG9jYWxfYmlnZW5kaWFuKCkNCj4gYm9vbCB0ZXBfaXNfbG9jYWxfYmlnZW5kaWFuKCkNCj4N
Cj4gSXQgY2FuIGJlIGFyZ3VlZCB0aGF0IHRoaXMgY291bGQgYmUgZm9yIHRoZSBhYm92ZSAodGVz
dCB0aGlzIG1hY2hpbmUpLA0KPiBidXQgc2luY2UgdGhlICJ0ZXN0IHRoaXMgbWFjaGluZSIgZG9l
c24ndCB0YWtlIGEgcGFyYW1ldGVyLCBidXQgInRlc3QNCj4gdGhlIHBldmVudCBiaWdlbmRpYW4i
IGRvZXMsIEkgd2FudCBpdCB0byBiZSBjb25zaXN0ZW50IHdpdGgNCj4gdGVwX2lzX2ZpbGVfYmln
ZW5kaWFuKCksIHdoaWNoIGFsc28gdGFrZXMgYSBwYXJhbWV0ZXIuDQo+DQo+ICAgIGJvb2wgdGVw
X2lzX2JpZ2VuZGlhbih2b2lkKTsNCj4gICAgYm9vbCB0ZXBfaXNfZmlsZV9iaWdlbmRpYW4oc3Ry
dWN0IHRlcF9oYW5kbGUgKnRlcCk7DQo+ICAgIGJvb2wgdGVwX2lzX2xvY2FsX2JpZ2VuZGlhbihz
dHJ1Y3QgdGVwX2hhbmRsZSAqdGVwKTsNCj4NCj4gc2VlbXMgbW9yZSBjb25zaXN0ZW50IHRoYW46
DQo+DQo+ICAgIGJvb2wgdGVwX2lzX2xvY2FsX2JpZ2VuZGlhbih2b2lkKTsNCj4gICAgYm9vbCB0
ZXBfaXNfZmlsZV9iaWdlbmRpYW4oc3RydWN0IHRlcF9oYW5kbGUgKnRlcCk7DQo+ICAgIGJvb2wg
dGVwX2lzX2JpZ2VuZGlhbihzdHJ1Y3QgdGVwX2hhbmRsZSAqdGVwKTsNCj4NCj4gU28gbGV0cyBn
byB3aXRoIHRoZSBmaXJzdCBvbmUuDQo+DQo+IE1ha2Ugc2Vuc2U/DQo+DQo+IC0tIFN0ZXZlDQoN
ClllcywgdGhhbmtzIFN0ZXZlbg0KDQotLSANCg0KVHp2ZXRvbWlyIChDZWNvKSBTdG95YW5vdg0K
Vk13YXJlIE9wZW4gU291cmNlIFRlY2hub2xvZ3kgQ2VudGVyDQo=
