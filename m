Return-Path: <SRS0=MeYK=SF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39138C4360F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Apr 2019 13:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 077D62084C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Apr 2019 13:17:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="FKaOXor2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfDCNRA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 09:17:00 -0400
Received: from mail-eopbgr710040.outbound.protection.outlook.com ([40.107.71.40]:25248
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726064AbfDCNRA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 09:17:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1bJoLGA5vUydw/lEBitmGIMMUO2LMHdLbqlG/7DEe4k=;
 b=FKaOXor2dKCJXryfzpRWvzBdp30C0SUi5xLO+o5L2Snwj4he3bOmmtDFAF0GvaweQPOn0M10ZTwFQMjzYWrBoGEqFyAue2+sKW43oDl8zvFIZGv3zrkLErkrP+fj1uVpdHYdIGAoKWYNSsbUWZpZ/CL50D4y3824fTETuVujZxo=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3804.namprd05.prod.outlook.com (10.167.163.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.11; Wed, 3 Apr 2019 13:16:57 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41%5]) with mapi id 15.20.1771.007; Wed, 3 Apr 2019
 13:16:57 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [RFC PATCH v9 11/11] trace-cmd: Add splice() recording from FIFO
 without additional pipe buffer
Thread-Topic: [RFC PATCH v9 11/11] trace-cmd: Add splice() recording from FIFO
 without additional pipe buffer
Thread-Index: AQHU6hyBQpNQWScpaUWmgsH5b4lG9aYqaSsAgAABoQA=
Date:   Wed, 3 Apr 2019 13:16:57 +0000
Message-ID: <340db7c3982e5eba9f4cf597d4fef39f7e001f21.camel@vmware.com>
References: <20190402134540.32321-1-kaslevs@vmware.com>
         <20190402134540.32321-12-kaslevs@vmware.com>
         <20190403085515.1652201a@gandalf.local.home>
         <fe5cbfd1d91e83636d6b32c2522411aed471958d.camel@vmware.com>
In-Reply-To: <fe5cbfd1d91e83636d6b32c2522411aed471958d.camel@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7da855f7-fae5-4987-20fa-08d6b836a64d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0501MB3804;
x-ms-traffictypediagnostic: MWHPR0501MB3804:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR0501MB380433FD28D9FC5719647894DA570@MWHPR0501MB3804.namprd05.prod.outlook.com>
x-forefront-prvs: 0996D1900D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(346002)(376002)(366004)(39860400002)(199004)(189003)(2501003)(6246003)(186003)(26005)(105586002)(99286004)(2351001)(6916009)(102836004)(6506007)(76176011)(25786009)(4326008)(2906002)(71190400001)(305945005)(6512007)(6306002)(53936002)(7736002)(256004)(71200400001)(476003)(486006)(66066001)(5660300002)(446003)(3846002)(6116002)(966005)(86362001)(478600001)(6436002)(5640700003)(118296001)(2616005)(11346002)(106356001)(316002)(8936002)(8676002)(68736007)(81156014)(1730700003)(81166006)(97736004)(14454004)(36756003)(229853002)(93886005)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3804;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HCvKcAy1x4iT0kjUJOFu+EfTSgqHCM9XzHLd/JJhu+fU5ck8vMAEFrrsmZfHn4MtL399R6HI5jx6o8xumj7x9T+6gKco3j8GBnZTciZysqacnL79c5kRGZM//nRILA8lTYovRWzfp/ZVR5I4yoN6ZvkWMkOBkfld2xBt/9x51/0Vt+plaCFPdctp192RhOUB5b3OkWYMo+UbfaE6NU9Y7D+93fqBlXCccB1dw37+PqxCuAl5WShMaLSCfW2qZX8gbaoV00q/K4rGulPeIcl4ylfdVOwUV44E5xxS7FJzuKnHH4IXBw7QLWp48biUQohYBqcDTLKBUSWNSq9G69lOBBPlMqHiPYvZC9J6LioC851hsK05DxGRJKip47LNOYgJ84kN9XTfYI8yxMacZ/90+cenYOFRh5bggGBDIv6eehE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A0A111853685444A3957A1DB9B7DDCF@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da855f7-fae5-4987-20fa-08d6b836a64d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2019 13:16:57.5329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3804
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCAyMDE5LTA0LTAzIGF0IDE2OjExICswMzAwLCBTbGF2b21pciBLYXNsZXYgd3JvdGU6
DQo+IE9uIFdlZCwgMjAxOS0wNC0wMyBhdCAwODo1NSAtMDQwMCwgU3RldmVuIFJvc3RlZHQgd3Jv
dGU6DQo+ID4gT24gVHVlLCAgMiBBcHIgMjAxOSAxNjo0NTo0MCArMDMwMA0KPiA+IFNsYXZvbWly
IEthc2xldiA8a2FzbGV2c0B2bXdhcmUuY29tPiB3cm90ZToNCj4gPiANCj4gPiA+ICsvKg0KPiA+
ID4gKyAqIFJldHVybnMgLTEgb24gZXJyb3IuDQo+ID4gPiArICogICAgICAgICAgb3IgYnl0ZXMg
b2YgZGF0YSByZWFkLg0KPiA+ID4gKyAqLw0KPiA+ID4gK3N0YXRpYyBsb25nIGRpcmVjdF9zcGxp
Y2VfZGF0YShzdHJ1Y3QgdHJhY2VjbWRfcmVjb3JkZXINCj4gPiA+ICpyZWNvcmRlcikNCj4gPiA+
ICt7DQo+ID4gPiArCXN0cnVjdCBwb2xsZmQgcGZkID0gew0KPiA+ID4gKwkJLmZkID0gcmVjb3Jk
ZXItPnRyYWNlX2ZkLA0KPiA+ID4gKwkJLmV2ZW50cyA9IFBPTExJTiwNCj4gPiA+ICsJfTsNCj4g
PiA+ICsJbG9uZyByZWFkOw0KPiA+ID4gKwlpbnQgcmV0Ow0KPiA+ID4gKw0KPiA+ID4gKwlyZXQg
PSBwb2xsKCZwZmQsIDEsIFBPTExfVElNRU9VVF9NUyk7DQo+ID4gPiArCWlmIChyZXQgPCAwKQ0K
PiA+ID4gKwkJcmV0dXJuIC0xOw0KPiA+ID4gKw0KPiA+ID4gKwlpZiAoIShwZmQucmV2ZW50cyB8
IFBPTExJTikpDQo+ID4gPiArCQlyZXR1cm4gMDsNCj4gPiANCj4gPiBXaHkgdGhlIHBvbGxpbmcg
Y29kZSwgYW5kIG5vdCBqdXN0IGJsb2NrIG9uIHNwbGljZT8NCj4gDQo+IFRvIHdvcmsgYXJvdW5k
IG9sZGVyIGtlcm5lbHMgdGhhdCBkb24ndCBoYXZlIHRoZSBzcGxpY2UoMikNCj4gT19OT05CTE9D
S0lORyBmaXhbMV0gZm9yIHBpcGVzLg0KPiANCj4gQW4gYWx0ZXJuYXRpdmUgd291bGQgYmUgdG8g
Y29uZmlndXJlIFNJR0lOVCBub3QgdG8gYXV0byByZXN0YXJ0DQo+IHN5c2NhbGxzICh3aGljaCBp
cyB0aGUgZGVmYXVsdCBhZmFpaykuIFRoZW4gc3BsaWNlKDIpIHdpbGwgcmV0dXJuDQo+IEVBR0FJ
TiBhbmQgd2lsbCBjYW4gcmVzdGFydCBpdCB3aXRoIFNQTElDRV9GX05PTkJMT0NLIGZsYWcgb24u
DQogIF5FSU5UUg0KDQo+IA0KPiBbMV0gDQo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC9jb21taXQvP2lkPWVlNWUwMDEx
OTZkMTM0NWI4ZmVlMjU5MjVmZjVmMWQ2NzkzNjA4MWUNCg==
