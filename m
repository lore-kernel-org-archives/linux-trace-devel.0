Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A20C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 23:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 112822082F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 23:25:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="i2xt+IMV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfC0XZE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 19:25:04 -0400
Received: from mail-eopbgr760080.outbound.protection.outlook.com ([40.107.76.80]:3616
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726055AbfC0XZE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 19:25:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJPhLalaHfzmqfzsQptv6WJJzN5STI3uCQWA3+vmPBk=;
 b=i2xt+IMVzBpr3jjgmmdwo8Kq7oK4NkOH9cE9LhInROUTYA5czmW1jIOFuUMpaDD4lMmZQ3t6hKUKGiZAjA1UH9Qkexcsq1PJyNvCfUZF7P8hqTh1ABOqovCLuhiwmXhTFTVbIsa9tEb3NfBTj6VUA3hczaqg0dYYCZIGdfSH7Uw=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3881.namprd05.prod.outlook.com (10.167.173.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.13; Wed, 27 Mar 2019 23:25:01 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41%5]) with mapi id 15.20.1750.010; Wed, 27 Mar 2019
 23:25:01 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: Re: [RFC 7/7] kernel-shark: Add basic example demonstrating the NumPy
 interface
Thread-Topic: [RFC 7/7] kernel-shark: Add basic example demonstrating the
 NumPy interface
Thread-Index: AQHU5PRMftAUGyN58UyMwSeXlygv5Q==
Date:   Wed, 27 Mar 2019 23:25:01 +0000
Message-ID: <CAE0o1Nv+LoROA9sgj=+ByRH8CH8htKH7DnTgAh58j6ZnyEWn1A@mail.gmail.com>
References: <20190327160323.31654-1-ykaradzhov@vmware.com>
 <20190327160323.31654-8-ykaradzhov@vmware.com>
In-Reply-To: <20190327160323.31654-8-ykaradzhov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:3:23::20) To MWHPR0501MB3772.namprd05.prod.outlook.com
 (2603:10b6:301:7a::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAXj3LteOG2C2dqg7cJV0qvTGM5ICzMbPmJWNaDO1F+//L/hAUjL
        4wF//XdZXKgv6a/IJXf1UYL3Vgi0jKR0+/fHyQ==
x-google-smtp-source: APXvYqwj28LQ/JoKA31y78JSRV1BdtenzsojuoYNnMGZ38Gk/Qzmcn2ECqjYMlWDAJC7Jyk9Q2r2xuinOg4XyVZpBoc=
x-received: by 2002:a02:9a02:: with SMTP id b2mr5524345jal.120.1553729097681;
 Wed, 27 Mar 2019 16:24:57 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1Nv+LoROA9sgj=+ByRH8CH8htKH7DnTgAh58j6ZnyEWn1A@mail.gmail.com>
x-originating-ip: [209.85.166.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8c0913b-44e6-4eae-d4ae-08d6b30b6e7e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:MWHPR0501MB3881;
x-ms-traffictypediagnostic: MWHPR0501MB3881:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR0501MB3881930B56B1812BE91EA4B7DA580@MWHPR0501MB3881.namprd05.prod.outlook.com>
x-forefront-prvs: 0989A7979C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(366004)(376002)(39860400002)(396003)(136003)(346002)(199004)(189003)(5660300002)(55446002)(229853002)(25786009)(6486002)(14454004)(95326003)(61726006)(478600001)(256004)(107886003)(71200400001)(71190400001)(8676002)(52116002)(68736007)(4326008)(6862004)(966005)(6436002)(99286004)(76176011)(2906002)(81156014)(3846002)(81166006)(6116002)(6246003)(98316002)(54906003)(53936002)(498394004)(6506007)(53546011)(386003)(6306002)(9686003)(6512007)(316002)(102836004)(8936002)(26005)(66066001)(61266001)(11346002)(106356001)(186003)(105586002)(486006)(86362001)(6636002)(446003)(476003)(97736004)(7736002)(305945005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3881;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eQm5SuF7mmDazWE1CPAauWKP1G2v/p25MwKYSvS/4d0GFjknpW/KbBWTT0bn5VeYZZ68QNxMthDL4gIlHcjjaheVMI3Dokf8rz1xbdEYDOELv3NXHuswo41xQZ7gY4H3dsnspe38lf6I00OcM52+3CqoA2RGxC0xrYRNqbOUEz+rNkxs4tLyH2X09h3/QJT1nYOVZy/U7Pbf3HYZWwy8SNsLqkoddowz1+U6LDEM8EESi+PFT+s+DwFzNVqVctGUInuL4B65oDFaPMB/kxhqOyd2WjWAjsRTace8dFoB6tVC73w7tfC79rSFMn+v1cUwKsuG9Ei8z/00w1Qa7NEm1xb9AAUeh2vkziV2HEVcaxSH3ZPv5l6uSL7n/4r35r2222Iiy2Q/zYCORwYITnexaaodLmPBhVGH2p2XeDHTYp8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <691E578AF82CFF4DAB71833BEF4A4E85@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c0913b-44e6-4eae-d4ae-08d6b30b6e7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2019 23:25:01.0169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3881
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCBNYXIgMjcsIDIwMTkgYXQgNjowNCBQTSBZb3JkYW4gS2FyYWR6aG92IDx5a2FyYWR6
aG92QHZtd2FyZS5jb20+IHdyb3RlOg0KPg0KPiBUaGUgZXhhbXBsZSBzY3JpcHQgcGxvdHMgdGhl
IGRpc3RyaWJ1dGlvbiAoaGlzdG9ncmFtKSBvZiB0aGUgcHVsc2VhdWRpbw0KPiB3YWtlLXVwIHRp
bWVzIGFuZCBmaW5kcyB0aGUgYmlnZ2VzdCBsYXRlbmN5LiBUaGUgc2NyaXB0IGFsc28gZ2VuZXJh
dGVzDQo+IGEgS2VybmVsU2hhcmsgc2Vzc2lvbiBkZXNjcmlwdG9yIGZpbGUgKEpTT04pLiBUaGUg
c2Vzc2lvbiBkZXNjcmlwdG9yIGZpbGUNCj4gY2FuIGJlIHVzZWQgYnkgdGhlIEtlcm5lbFNoZXJr
IEdVSSB0byBvcGVuIGEgc2Vzc2lvbiB3aGljaCB3aWxsIGRpcmVjdGx5DQo+IHZpc3VhbGl6ZSB0
aGUgbGFyZ2VzdCB3YWtlLXVwIGxhdGVuY3kuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IFlvcmRhbiBL
YXJhZHpob3YgPHlrYXJhZHpob3ZAdm13YXJlLmNvbT4NCj4gLS0tDQo+ICBrZXJuZWwtc2hhcmsv
YmluL3NjaGVkX3dha2V1cC5weSB8IDk2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
DQo+ICAxIGZpbGUgY2hhbmdlZCwgOTYgaW5zZXJ0aW9ucygrKQ0KPiAgY3JlYXRlIG1vZGUgMTAw
NzU1IGtlcm5lbC1zaGFyay9iaW4vc2NoZWRfd2FrZXVwLnB5DQo+DQo+IGRpZmYgLS1naXQgYS9r
ZXJuZWwtc2hhcmsvYmluL3NjaGVkX3dha2V1cC5weSBiL2tlcm5lbC1zaGFyay9iaW4vc2NoZWRf
d2FrZXVwLnB5DQoNCjxzbmlwPg0KDQo+ICt3aGlsZSAoaSA+PSAwKToNCj4gKyAgaWYgKGV2dFtp
XSA9PSBzc19laWQpOg0KDQpUaG9zZSB3aGlsZSAoLi4uKXMgYW5kIGlmICguLi4pcyBhcmUgdmVy
eSBDIHN0eWxlIFB5dGhvbiBjb2RlIDopDQpVc3VhbGx5IHBhcmVudGhlc2VzIGFyZSBuZWVkZWQg
b25seSB3aGVuIHRoZSBleHByZXNzaW9uIGluc2lkZSBpcyB0b28NCmxvbmcgYW5kIG9uZSB3YW50
cyB0byBicmVhayBpdCBvbiBzZXZlcmFsIGxpbmVzLg0KDQpTaW5jZSB3ZSBkb24ndCBoYXZlIGEg
Ymxlc3NlZCBQeXRob24gc3R5bGUgZ3VpZGUsIEkgd291bGQgc3VnZ2VzdA0Kc3RpY2tpbmcgdG8g
cGVwOFsxXS4gVGhlcmUncyBhbHNvIGEgcGVwOCBjaGVja2VyIHRvb2xbMl0gd2hpY2ggY29tZXMN
CmhhbmR5IGFuZCBjYW4gcG9pbnQgb3V0IHVuaWRpb21hdGljIGNvZGUuDQoNCkNoZWVycywNCg0K
LS0gU2xhdmkNCg0KWzFdIGh0dHBzOi8vd3d3LnB5dGhvbi5vcmcvZGV2L3BlcHMvcGVwLTAwMDgv
DQpbMl0gYGFwdCBpbnN0YWxsIHBlcDhgIG9uIERlYmlhbiBzeXN0ZW1zDQo=
