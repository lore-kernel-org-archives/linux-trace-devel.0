Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92160C282DC
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 13:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D25520872
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 13:56:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="OYmzS/Z5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbfDQN4D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 09:56:03 -0400
Received: from mail-eopbgr720077.outbound.protection.outlook.com ([40.107.72.77]:1088
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730463AbfDQN4C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 09:56:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UbEcyd5PlFOFTYXwUjVhUd6FVqi9uVqxdMFA1DujDQs=;
 b=OYmzS/Z5weH1R/H4CfLd+vDI54z6QkAq7GJAhHpwqSNesrmVdUQsfNV1kTlcC5RqJhuYqaSNMmcQYZDqYRfaeKBgdvmoI8CjqVJ3tvoK0lauAa0dF0wTFnsn8xLu+i1PcBasfgZ+kQur1VmfrMX7K/49BaOMuyTVcXsWWwPZ9AY=
Received: from SN2PR05MB2767.namprd05.prod.outlook.com (10.167.19.136) by
 SN2PR05MB2477.namprd05.prod.outlook.com (10.166.213.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.6; Wed, 17 Apr 2019 13:55:58 +0000
Received: from SN2PR05MB2767.namprd05.prod.outlook.com
 ([fe80::f05a:1a3b:5967:ea3a]) by SN2PR05MB2767.namprd05.prod.outlook.com
 ([fe80::f05a:1a3b:5967:ea3a%5]) with mapi id 15.20.1792.020; Wed, 17 Apr 2019
 13:55:58 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/2] trace-cmd: remove parsing_failures APIs from
 libtraceevent
Thread-Topic: [PATCH 1/2] trace-cmd: remove parsing_failures APIs from
 libtraceevent
Thread-Index: AQHU84ruIUIIwv7/U0OKQVzd88iCPKY/ZfIAgACtrACAAEWjAIAACiWA
Date:   Wed, 17 Apr 2019 13:55:58 +0000
Message-ID: <CACqStockaqQu_7mn5L-+8=65wPSKPFVwh+2ChqAuV5PZoVA3Ug@mail.gmail.com>
References: <20190415125823.4011-1-tstoyanov@vmware.com>
 <20190416184832.2bb69162@gandalf.local.home>
 <CACqStoc1vyLp=8XavFoXBCrFQh7C5eruhhGoVLwqHS670TP06g@mail.gmail.com>
 <20190417091922.1e4c5f19@gandalf.local.home>
In-Reply-To: <20190417091922.1e4c5f19@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P195CA0061.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::38) To SN2PR05MB2767.namprd05.prod.outlook.com
 (2603:10b6:804:16::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAXZh81Cu+5xO+H7UjoEGivN3JwKDTl8XA5dpm/4UAtgI8I8CWKA
        V2sGSoM4KqmlcKdeN29nO2TBbUDABGGkGmAgdYw=
x-google-smtp-source: APXvYqw+6C4WT7MgTIk9oInXPZIMIxRxGNoV+kYT1+/8TJdYuDGVg9nHXwF6LwDSD4rLb/ng3ukvtDsNz1MqZAVm0Ds=
x-received: by 2002:adf:ed8f:: with SMTP id
 c15mr33771097wro.144.1555509352643; Wed, 17 Apr 2019 06:55:52 -0700 (PDT)
x-gmail-original-message-id: <CACqStockaqQu_7mn5L-+8=65wPSKPFVwh+2ChqAuV5PZoVA3Ug@mail.gmail.com>
x-originating-ip: [209.85.221.51]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 813c42b6-a8d2-450a-717e-08d6c33c6acf
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600140)(711020)(4605104)(2017052603328)(7193020);SRVR:SN2PR05MB2477;
x-ms-traffictypediagnostic: SN2PR05MB2477:
x-microsoft-antispam-prvs: <SN2PR05MB2477C21C912F5B9986351E77DC250@SN2PR05MB2477.namprd05.prod.outlook.com>
x-forefront-prvs: 0010D93EFE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(136003)(366004)(346002)(376002)(189003)(199004)(486006)(305945005)(76176011)(256004)(229853002)(476003)(446003)(11346002)(53936002)(14454004)(6486002)(86362001)(55446002)(7736002)(25786009)(6506007)(386003)(53546011)(52116002)(102836004)(186003)(26005)(105586002)(93886005)(6862004)(4326008)(106356001)(6246003)(2906002)(68736007)(5660300002)(61726006)(98316002)(66066001)(97736004)(8936002)(8676002)(81156014)(81166006)(6116002)(3846002)(61266001)(71190400001)(71200400001)(99286004)(478600001)(95326003)(316002)(498394004)(6436002)(9686003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR05MB2477;H:SN2PR05MB2767.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: L1g1mnudOclqMte3UFz/RFuWKtPs6KN4+uIc/z8gnMyUCm8yRPrUvWjyMC786bFj5/p6D1im26qMjTJrmuccTZmnT+WrWnokZ4U69LyE1crqNe8fWPFdf5iDamYk4hXTa3jfUwRVj/F0zS7YYyK18Uc7632bscVQ4pMf+Q+7pZ4Y1K3I1zvi7QXjpriwrxWJNtRL1NjsUV++RMR2xtxUDRNb/Ad58LI9OkElnGLGSyrX1A7PgzcmOFG0PgalFD87en7QrGuep30ktnSodTT4XXxbDOM3ddaQDAl2Ba66sXDWI758BiX73Gm00lo6p7BndPkNxagzIOZxCNz5y1OTqpPGD5CR7udvrqupCXd5yzKCiRG5MFwLOUbqBNIGTsRN2f/aSCEPrMc8p2IG/tdVGRmdmo4GKNheD+/oSFi8AdQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <865878A87F08B345BC8DCCE21425B372@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 813c42b6-a8d2-450a-717e-08d6c33c6acf
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2019 13:55:58.1721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR05MB2477
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCBBcHIgMTcsIDIwMTkgYXQgNDoxOSBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IE9uIFdlZCwgMTcgQXByIDIwMTkgMDk6MTA6MjYgKzAw
MDANCj4gVHp2ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJlLmNvbT4gd3JvdGU6DQo+
DQo+IExldCdzIG5vdCBhZGQgdGhpcy4gSW5zdGVhZCBhZGQgYSAicGFyc2luZ19mYWlsdXJlcyIg
dG8gdGhlDQo+ID4gPiB0cmFjZWNtZF9pbnB1dCBoYW5kbGUsIGFuZCBhZGQ6DQo+ID4gPg0KPiA+
ID4gaW50IHRyYWNlY21kX2dldF9wYXJzaW5nX2ZhaWx1cmVzKHN0cnVjdCB0cmFjZWNtZF9pbnB1
dCAqaGFuZGxlKQ0KPiA+ID4gew0KPiA+ID4gICAgICAgICByZXR1cm4gaGFuZGxlLT5wYXJzaW5n
X2ZhaWx1cmVzOw0KPiA+ID4gfQ0KPiA+ID4NCj4gPiBJIGhlc2l0YXRlZCBpZiB0byBhZGQgbmV3
IEFQSSwgb3IgdXNlIGFkZGl0aW9uYWwgcGFyYW1ldGVyIHRvIHRoZQ0KPiA+IGV4aXN0aW5nIGZ1
bmN0aW9ucy4NCj4gPiBUaGUgcmVhc29uIGZvciB0aGlzIGNoYW5nZSBpcyB0byByZW1vdmUgInBh
cnNpbmdfZmFpbHVyZXMiIGZyb20NCj4gPiB0cmFjZWV2ZW50IGxpYnJhcnksDQo+ID4gdGhhdCdz
IHdoeSBJIGRlY2lkZWQgbm90IHRvIG1vdmUgaXQgdG8gdHJhY2UtY21kIGxpYnJhcnkuIFVzaW5n
IG5ldw0KPiA+IGxpYnJhcnkgQVBJIGlzIG5pY2VyLA0KPiA+IEkgY2FuIHJlaW1wbGVtZW50IGl0
IGluIHRoaXMgd2F5LCBidXQgd2UgbWF5IGhhdmUgdGhlIHNhbWUgY29uY2VybnMNCj4gPiB3aGVu
IHRyYWNlLWNtZA0KPiA+IGxpYnJhcnkgY29tZXMgb3V0Lg0KPiA+DQo+DQo+IFRoYXQncyBhIHZh
bGlkIGNvbmNlcm4sIGJ1dCB0aGVyZSBpcyBhIGRpZmZlcmVuY2UgYmV0d2VlbiB0aGUNCj4gbGli
dHJhY2VldmVudCBhbmQgbGliZnRyYWNlIChvciB3aGF0ZXZlciB3ZSBkZWNpZGUgdG8gbmFtZSBp
dCA7LSkNCj4NCj4gVGhlIHRyYWNlLWNtZCBjb2RlIHdpbGwgYmUgYSBoaWdoZXIgbGV2ZWwgbGli
cmFyeSBvbiB0b3Agb2YNCj4gbGlidHJhY2VldmVudC4gVGhlIG1haW4gZGlmZmVyZW5jZSBpcyB0
aGF0IHRoZSB0cmFjZS1jbWQgY29kZSBoYXMNCj4gYWxnb3JpdGhtcyB0aGF0IGRlYWwgd2l0aCB0
aGUgY291bnRlciBidXQgdGhlIHRlcCBjb2RlIGRpZCBub3QuIFdlDQo+IGluY29ycmVjdGx5IGFk
ZGVkIHRoYXQgY291bnRlciB0byB0aGUgdGVwIGNvZGUgb25seSBiZWNhdXNlIGEgaGlnaGVyDQo+
IGxheWVyIG5lZWRlZCBpdC4gVGhlIHRlcCBsYXllciBkaWQgbm90IHVuZGVyc3RhbmQgdGhlIGNv
bnRleHQgb2YgdGhhdA0KPiBjb3VudGVyLg0KPg0KPiBNeSBjb25jZXJuIHdpdGggdGhlIGNvdW50
ZXIgaW4gdGhlIHRlcCBjb2RlIHdhcyB0aGF0IGl0IHdhcyBhdCB0aGUNCj4gd3JvbmcgbGV2ZWwu
IFRoYXQgaXMsIHRoZSB0ZXAgY29kZSBoYWQgbm8gcHJvY2Vzc2luZyBmb3IgdGhhdCBjb3VudGVy
Lg0KPiBUbyBwdXQgaXQgYSBkaWZmZXJlbnQgd2F5LCB0aGUgdGVwIGNvZGUgZGlkIG5vdCB1bmRl
cnN0YW5kIHRoZSBjb250ZXh0DQo+IG9mIHRoZSBjb3VudGVyLiBXZSBoYWQgdG8gYWRkIEFQSSB0
byBzZXQgYW5kIHJlc2V0IHRoYXQgY291bnRlciwgd2hpY2gNCj4gd2FzIGEgY2xlYXIgaW5kaWNh
dGlvbiB0aGF0IHRoZSB0ZXAgbGlicmFyeSBzaG91bGRuJ3QgYmUgdGhlIG9uZSB0bw0KPiBzdG9y
ZSBpdC4NCj4NCj4gTm93IGF0IHRoZSB0cmFjZS1jbWQgY29kZSBsZXZlbCAobGliZnRyYWNlKSwg
aXQgbW9zdCBkZWZpbml0ZWx5DQo+IHVuZGVyc3RhbmRzIHRoZSBjb250ZXh0IG9mIHRoYXQgY291
bnRlci4gVGh1cyB0aGUgY291bnRlciBzaG91bGQgYmUNCj4gc3RvcmVkIGF0IHRoYXQgbGV2ZWwu
IFdlIGRpZG4ndCBuZWVkIHRvIGFkZCBBUElzIHRvIHRoZSB0cmFjZS1jbWQgY29kZQ0KPiB0byBy
ZXNldCB0aGF0IGNvdW50ZXIsIG9yIGluY3JlbWVudCBpdC4gQmVjYXVzZSB0aGUgdHJhY2UtY21k
IGxpYnJhcnkNCj4ga25vd3MgdGhlIGNvbnRleHQgb2YgdGhlIGNvdW50ZXIuIFRoYXQncyBob3cg
b25lIGtub3dzIGlmIHRoZSBsaWJyYXJ5DQo+IHNob3VsZCBzdG9yZSB0aGUgY291bnRlciBvciBu
b3QuDQo+DQo+IExldCdzIG1ha2UgdGhlIHBhcnNpbmdfZmFpbHVyZXMgcGFydCBvZiB0aGUgdHJh
Y2VjbWRfaW5wdXQgaGFuZGxlciBhbmQNCj4gaXQgd2lsbCBzaW1wbGlmeSB0aGlzIHBhdGNoIHF1
aXRlIGEgYml0Lg0KPg0KPiBEb2VzIHRoYXQgbWFrZSBzZW5zZT8NCj4NCg0KWWVzLCBpdCBtYWtl
cyBzZW5zZS4gSSdsbCBwcmVwYXJlIHRoZSBuZXh0IHZlcnNpb24gb2YgdGhlIHBhdGNoLg0KDQo+
IC0tIFN0ZXZlDQo+DQo+DQo+ID4gPiA+ICt7DQo+ID4gPiA+ICsgICAgIHJldHVybiBfdHJhY2Vj
bWRfcmVhZF9oZWFkZXJzKGhhbmRsZSwgcGFyc2luZ19mYWlsdXJlcyk7DQo+ID4gPiA+ICt9DQo+
ID4gPiA+ICsNCj4gPiA+DQo+ID4gPiBbLi5dDQo+ID4gPg0KPiA+ID4gPiBkaWZmIC0tZ2l0IGEv
dHJhY2VjbWQvdHJhY2UtcmVhZC5jIGIvdHJhY2VjbWQvdHJhY2UtcmVhZC5jDQo+ID4gPiA+IGlu
ZGV4IDUyZmExYmQuLmZlMTE2Y2MgMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL3RyYWNlY21kL3RyYWNl
LXJlYWQuYw0KPiA+ID4gPiArKysgYi90cmFjZWNtZC90cmFjZS1yZWFkLmMNCj4gPiA+ID4gQEAg
LTE0MTcsNiArMTQxNyw3IEBAIHZvaWQgdHJhY2VfcmVwb3J0IChpbnQgYXJnYywgY2hhciAqKmFy
Z3YpDQo+ID4gPiA+ICAgICAgIHVuc2lnbmVkIGxvbmcgbG9uZyB0c29mZnNldCA9IDA7DQo+ID4g
PiA+ICAgICAgIHVuc2lnbmVkIGxvbmcgbG9uZyB0czJzZWNzID0gMDsNCj4gPiA+ID4gICAgICAg
dW5zaWduZWQgbG9uZyBsb25nIHRzMnNjOw0KPiA+ID4gPiArICAgICBpbnQgcGFyc2luZ19mYWls
dXJlczsNCj4gPiA+ID4gICAgICAgaW50IHNob3dfc3RhdCA9IDA7DQo+ID4gPiA+ICAgICAgIGlu
dCBzaG93X2Z1bmNzID0gMDsNCj4gPiA+ID4gICAgICAgaW50IHNob3dfZW5kaWFuID0gMDsNCj4g
PiA+ID4gQEAgLTE3MTQsMTAgKzE3MTUsMTAgQEAgdm9pZCB0cmFjZV9yZXBvcnQgKGludCBhcmdj
LCBjaGFyICoqYXJndikNCj4gPiA+ID4gICAgICAgICAgICAgICAgICAgICAgIHRyYWNlY21kX3By
aW50X2V2ZW50cyhoYW5kbGUsIHByaW50X2V2ZW50KTsNCj4gPiA+ID4gICAgICAgICAgICAgICAg
ICAgICAgIHJldHVybjsNCj4gPiA+ID4gICAgICAgICAgICAgICB9DQo+ID4gPiA+IC0NCj4gPiA+
ID4gLSAgICAgICAgICAgICByZXQgPSB0cmFjZWNtZF9yZWFkX2hlYWRlcnMoaGFuZGxlKTsNCj4g
PiA+ID4gKyAgICAgICAgICAgICBwYXJzaW5nX2ZhaWx1cmVzID0gMDsNCj4gPiA+ID4gKyAgICAg
ICAgICAgICByZXQgPSB0cmFjZWNtZF9yZWFkX2hlYWRlcnNfZmFpbHVyZXMoaGFuZGxlLCAmcGFy
c2luZ19mYWlsdXJlcyk7DQo+ID4gPg0KPiA+ID4gSGVyZSB3ZSBzaG91bGQgZG86DQo+ID4gPg0K
PiA+ID4gICAgICAgICAgICAgICAgIHJldCA9IHRyYWNlY21kX3JlYWRfaGVhZGVycyhoYW5kbGUp
Ow0KPiA+ID4NCj4gPiA+ID4gICAgICAgICAgICAgICBpZiAoY2hlY2tfZXZlbnRfcGFyc2luZykg
ew0KPiA+ID4gPiAtICAgICAgICAgICAgICAgICAgICAgaWYgKHJldCB8fCB0ZXBfZ2V0X3BhcnNp
bmdfZmFpbHVyZXMocGV2ZW50KSkNCj4gPiA+DQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAg
ICBpZiAocmV0IHx8IHRyYWNlY21kX2dldF9wYXJzaW5nX2ZhaWx1cmVzKGhhbmRsZSkpDQo+ID4g
Pg0KPiA+ID4gLS0gU3RldmUNCj4gPiA+DQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgICBp
ZiAocmV0IHx8IHBhcnNpbmdfZmFpbHVyZXMpDQo+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGV4aXQoRUlOVkFMKTsNCj4gPiA+ID4gICAgICAgICAgICAgICAgICAgICAgIGVs
c2UNCj4gPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZXhpdCgwKTsNCj4gPiA+
DQo+ID4NCj4gPg0KPg0KDQoNCi0tIA0KDQpUenZldG9taXIgKENlY28pIFN0b3lhbm92DQpWTXdh
cmUgT3BlbiBTb3VyY2UgVGVjaG5vbG9neSBDZW50ZXINCg==
