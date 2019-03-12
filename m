Return-Path: <SRS0=WSgK=RP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF9EC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 18:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AB5A206BA
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 18:48:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="TtA4GLkb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfCLSsd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Mar 2019 14:48:33 -0400
Received: from mail-eopbgr730060.outbound.protection.outlook.com ([40.107.73.60]:46976
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726558AbfCLSsc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Mar 2019 14:48:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nQrB2tcGONCeZJdwUEciWNNpSQOTaHK5XsWqkF8wm4s=;
 b=TtA4GLkbl1EUL9S0K+KRh8FwTlFJAngzMyKL99lkG03Co+76KnWhh58u5QFwtTcPBYeXezoSpi1YfDQWPzxsujgQNVmkt0yvFBkSIdKxUpKoyF25Zme5f2xEq/5wnlA0jF8M6fQywwTc2/oRKdul6CLDjqZM2CdI1q2HfBTh4yY=
Received: from CY1PR05MB2780.namprd05.prod.outlook.com (10.167.18.26) by
 CY1PR05MB2443.namprd05.prod.outlook.com (10.167.10.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.6; Tue, 12 Mar 2019 18:48:29 +0000
Received: from CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f]) by CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f%9]) with mapi id 15.20.1709.011; Tue, 12 Mar 2019
 18:48:29 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [RFC PATCH v8 05/13] trace-cmd: Add TRACE_REQ and TRACE_RESP
 messages
Thread-Topic: [RFC PATCH v8 05/13] trace-cmd: Add TRACE_REQ and TRACE_RESP
 messages
Thread-Index: AQHUyvLrCIRiN90oVkW3IqhfMvD6U6YIcmYA
Date:   Tue, 12 Mar 2019 18:48:28 +0000
Message-ID: <CAE0o1NtQE_Uux++2TRD0G+B4BY09Cwr6-qa84r4Dt3Os-hzyDw@mail.gmail.com>
References: <20190222180539.27439-1-kaslevs@vmware.com>
 <20190222180539.27439-6-kaslevs@vmware.com>
 <20190222160929.776ac227@gandalf.local.home>
In-Reply-To: <20190222160929.776ac227@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM6PR18CA0027.namprd18.prod.outlook.com
 (2603:10b6:5:15b::40) To CY1PR05MB2780.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::26)
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAX4+5b8M4Rxb/rwR/t+VKEeJ2U27EWUq5NE2rYwUuvycUUhtS3e
        36yZxeTXMVatzsrIUcPefmYE9F4P0J1lnkCqvA==
x-google-smtp-source: APXvYqzbKXC1KlSPK6XXQNGe/Xspnu95geY3lQvsj6P5Zju+733mBlUu5c41RFEGoIZ6b1Fjr8Z8Siouo6lEcxZc1vk=
x-received: by 2002:a05:660c:7c1:: with SMTP id
 e1mr2889062itl.73.1552416506142; Tue, 12 Mar 2019 11:48:26 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1NtQE_Uux++2TRD0G+B4BY09Cwr6-qa84r4Dt3Os-hzyDw@mail.gmail.com>
x-originating-ip: [209.85.166.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 736737b4-0f4a-4e58-f9ce-08d6a71b50f4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2443;
x-ms-traffictypediagnostic: CY1PR05MB2443:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-microsoft-antispam-prvs: <CY1PR05MB2443798C5B557123F8EE0F21DA490@CY1PR05MB2443.namprd05.prod.outlook.com>
x-forefront-prvs: 09749A275C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(39860400002)(346002)(396003)(199004)(189003)(52314003)(54094003)(99286004)(486006)(7736002)(6506007)(305945005)(53546011)(386003)(76176011)(26005)(498394004)(446003)(6862004)(11346002)(97736004)(9686003)(6512007)(102836004)(52116002)(95326003)(66066001)(61266001)(86362001)(8936002)(15650500001)(256004)(25786009)(316002)(6246003)(6486002)(71200400001)(71190400001)(186003)(106356001)(478600001)(4326008)(2906002)(6116002)(6436002)(81166006)(81156014)(476003)(5660300002)(8676002)(229853002)(53936002)(3846002)(55446002)(61726006)(14454004)(68736007)(105586002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2443;H:CY1PR05MB2780.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uqAiaU/rY9LA3Tbj6PV+Rea/dzOmiSQPPBZAhf5Yylm6Wncpbv9YbVDEUJY4GNZ3zqCiM+3sUNvQic7QFtjwpl5Hy31tU1L9+/vDlM7qqwsvSZwJLlgJFZRrOr92yyVZNOX7wPVVhJnc1bJWZd9wfDIlYEIKPilTmVS72X3rK+LyrJCqrN5JESNA16pDUksG7S4Fwhvdid0HjXzKyLH0ZxpSMZsOdcSgN4blSCZX+prd9+C3/B4ij7Yk8tEyjFHue2o7doJhZbY0fkobCnHV8QXiacd8ogPQyebI73jzzS22qpsNWDTABRcdcwCoxqKxK6SV7gikACZdDs/UXnqAMp2ydvJq9tpsalLR7VckQB44NSllytqC+dHTfnrVN1GBsPg0KKOBv0VuoxrnjdkRIvVgEQIyn5c8v5o9UXVer+Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4AC01A40EEFDAF49AB1DA0931714DBAD@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 736737b4-0f4a-4e58-f9ce-08d6a71b50f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2019 18:48:28.9806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2443
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gRnJpLCBGZWIgMjIsIDIwMTkgYXQgMTE6MDkgUE0gU3RldmVuIFJvc3RlZHQgPHJvc3RlZHRA
Z29vZG1pcy5vcmc+IHdyb3RlOg0KPg0KPiBPbiBGcmksIDIyIEZlYiAyMDE5IDIwOjA1OjMxICsw
MjAwDQo+IFNsYXZvbWlyIEthc2xldiA8a2FzbGV2c0B2bXdhcmUuY29tPiB3cm90ZToNCj4NCj4g
PiArc3RhdGljIGludCBtYWtlX3RyYWNlX3Jlc3Aoc3RydWN0IHRyYWNlY21kX21zZyAqbXNnLA0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgICBpbnQgcGFnZV9zaXplLCBpbnQgbnJfY3B1cywg
dW5zaWduZWQgaW50ICpwb3J0cykNCj4NCj4gSSB3b25kZXIgaWYgd2Ugc2hvdWxkIGp1c3QgaGF2
ZSBhIGdlbmVyaWMgImFyZ2MiLyJhcmd2IiBwcm90b2NvbCB0bw0KPiBzZW5kIGR5bmFtaWMgYW1v
dW50cyBvZiBkYXRhLCBhbmQgbm90IGhhdmUgc3BlY2lmaWMgZHluYW1pYyBtZXNzYWdlcz8NCj4N
Cj4gUGVyaGFwcyBwYXNzIHRoZSBudW1iZXJzIGFzIEFTQ0lJPyBBbmQgdGhlbiBjb252ZXJ0ZWQg
dGhlbSBhdCB0aGUgb3RoZXINCj4gZW5kLiBXZSBuZWVkIHRvIGhhbmRsZSBudG9oIGFueXdheSwg
c28gYSBjb252ZXJzaW9uIChhbGJlaXQgYSBmYXN0IG9uZSkNCj4gaXMgcHJvYmFibHkgZG9uZSBh
bnl3YXkuDQo+DQo+IFdlIGNvdWxkIHNlbmQ6DQo+ICBpbnQgYXJnYyA9ICA2Ow0KPiAgY2hhciAq
KmFyZ3YgPSB7ICI0MDk2IiwgIjE2IiwgIjMzNDQ1IiwgIjMzNDQ2IiwgIjMzNDQ4IiwgIjMzNDQ5
IiB9Ow0KPg0KPiBPciwgaWYgeW91IGFyZSBub3QgY29tZm9ydGFibGUgd2l0aCBzZW5kaW5nIEFT
Q0lJIGFuZCBjb252ZXJ0aW5nLCB3aGF0DQo+IGFib3V0IGhhdmUgYSBzcGVjaWZpYyAic2VuZGlu
ZyBhbiBhcnJheSBvZiBudW1iZXJzIj8NCj4NCj4gIGludCBhcmdjID0gNjsNCj4gIGludCAqYXJn
diA9IHsgNDA5NiwgMTYsIDMzNDQ1LCAzMzQ0NiwgMzM0NDgsIDMzNDQ5IH07DQo+DQo+IFRob3Vn
aHRzPw0KDQpJIGRvbid0IHNlZSBhbnkgZHJhd2JhY2tzIG9mIHRoaXMgYXBwcm9hY2ggKG1vZHVs
byBhIGJpdCBvZg0KYXJpdGhtZXRpYykuIEkgaW1wbGVtZW50ZWQgaXQgdGhlIHdheSBpdCBpcyBm
b2xsb3dpbmcgaG93IHRoZSBsaXN0ZW5lcg0KaXMgc2VuZGluZyBwb3J0IG51bWJlcnMgYmFjayB0
byB0aGUgcmVjb3JkaW5nIHByb2Nlc3MuDQoNClNob3VsZCB3ZSBhbHNvIHN3aXRjaCB0aGUgbGlz
dGVuZXIgdG8gdXNlIHRoZSBzYW1lIGVuY29kaW5nIG9mIHBvcnRzDQp3aXRoIHByb3RvY29sIFYz
IGJlZm9yZSB0aGUgbmV4dCByZWxlYXNlPw0KDQpIb3cgYWJvdXQgb3B0aW9ucyAod2hpY2ggaXMg
dGhlIG9ubHkgb3RoZXIgbm9uLXRleHQgdXNlIG9mIHRoZQ0KdmFyaWFibGUgYnVmZmVyIHBhcnQg
b2YgbWVzc2FnZXMpPyBDdXJyZW50bHkgdGhlIG9ubHkgb3B0aW9uIGluIHVzZSBpcw0KTVNHT1BU
X1VTRVRDUCBhbmQgY2FuIGJlY29tZSBzaW1wbHkgInRjcCIgb24gdGhlIHdpcmUuDQoNCldlIGNh
biB0aGVuIGhhdmUgYSBjb252ZW50aW9uIHRoYXQgdGhlIGJ1ZmZlciBhdCB0aGVuIGVuZCBvZiBt
ZXNzYWdlcw0KaXMgYWx3YXlzIHRleHQgYW5kIGRyb3AgdGhlIHNlY29uZCB1bmlvbiBpbiB0cmFj
ZWNtZF9tc2cuDQoNCi0tIFNsYXZpDQoNCj4NCj4gLS0gU3RldmUNCj4NCj4gPiArew0KPiA+ICsg
ICAgIGludCBwb3J0c19zaXplID0gbnJfY3B1cyAqIHNpemVvZigqbXNnLT5wb3J0X2FycmF5KTsN
Cj4gPiArICAgICBpbnQgaTsNCj4gPiArDQo+ID4gKyAgICAgbXNnLT5oZHIuc2l6ZSA9IGh0b25s
KG50b2hsKG1zZy0+aGRyLnNpemUpICsgcG9ydHNfc2l6ZSk7DQo+ID4gKyAgICAgbXNnLT50cmFj
ZV9yZXNwLmNwdXMgPSBodG9ubChucl9jcHVzKTsNCj4gPiArICAgICBtc2ctPnRyYWNlX3Jlc3Au
cGFnZV9zaXplID0gaHRvbmwocGFnZV9zaXplKTsNCj4gPiArDQo+ID4gKyAgICAgbXNnLT5wb3J0
X2FycmF5ID0gbWFsbG9jKHBvcnRzX3NpemUpOw0KPiA+ICsgICAgIGlmICghbXNnLT5wb3J0X2Fy
cmF5KQ0KPiA+ICsgICAgICAgICAgICAgcmV0dXJuIC1FTk9NRU07DQo+ID4gKw0KPiA+ICsgICAg
IGZvciAoaSA9IDA7IGkgPCBucl9jcHVzOyBpKyspDQo+ID4gKyAgICAgICAgICAgICBtc2ctPnBv
cnRfYXJyYXlbaV0gPSBodG9ubChwb3J0c1tpXSk7DQo+ID4gKw0KPiA+ICsgICAgIHJldHVybiAw
Ow0KPiA+ICt9DQo+ID4gKw0KPiA+ICtpbnQgdHJhY2VjbWRfbXNnX3NlbmRfdHJhY2VfcmVzcChz
dHJ1Y3QgdHJhY2VjbWRfbXNnX2hhbmRsZSAqbXNnX2hhbmRsZSwNCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgaW50IG5yX2NwdXMsIGludCBwYWdlX3NpemUsDQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGludCAqcG9ydHMpDQo+ID4gK3sNCj4g
PiArICAgICBzdHJ1Y3QgdHJhY2VjbWRfbXNnIG1zZzsNCj4gPiArICAgICBpbnQgcmV0Ow0KPiA+
ICsNCj4gPiArICAgICB0cmFjZWNtZF9tc2dfaW5pdChNU0dfVFJBQ0VfUkVTUCwgJm1zZyk7DQo+
ID4gKyAgICAgcmV0ID0gbWFrZV90cmFjZV9yZXNwKCZtc2csIHBhZ2Vfc2l6ZSwgbnJfY3B1cywg
cG9ydHMpOw0KPiA+ICsgICAgIGlmIChyZXQgPCAwKQ0KPiA+ICsgICAgICAgICAgICAgcmV0dXJu
IHJldDsNCj4gPiArDQo+ID4gKyAgICAgcmV0dXJuIHRyYWNlY21kX21zZ19zZW5kKG1zZ19oYW5k
bGUtPmZkLCAmbXNnKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiAraW50IHRyYWNlY21kX21zZ19yZWN2
X3RyYWNlX3Jlc3Aoc3RydWN0IHRyYWNlY21kX21zZ19oYW5kbGUgKm1zZ19oYW5kbGUsDQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGludCAqbnJfY3B1cywgaW50ICpwYWdlX3Np
emUsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGludCAqKnBv
cnRzKQ0KPiA+ICt7DQo+ID4gKyAgICAgc3RydWN0IHRyYWNlY21kX21zZyBtc2c7DQo+ID4gKyAg
ICAgc3NpemVfdCBidWZfbGVuOw0KPiA+ICsgICAgIGludCBpLCByZXQ7DQo+ID4gKw0KPiA+ICsg
ICAgIHJldCA9IHRyYWNlY21kX21zZ19yZWN2KG1zZ19oYW5kbGUtPmZkLCAmbXNnKTsNCj4gPiAr
ICAgICBpZiAocmV0IDwgMCkNCj4gPiArICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+ID4gKw0K
PiA+ICsgICAgIGlmIChudG9obChtc2cuaGRyLmNtZCkgIT0gTVNHX1RSQUNFX1JFU1ApIHsNCj4g
PiArICAgICAgICAgICAgIHJldCA9IC1FTk9UU1VQOw0KPiA+ICsgICAgICAgICAgICAgZ290byBv
dXQ7DQo+ID4gKyAgICAgfQ0KPiA+ICsNCj4gPiArICAgICBidWZfbGVuID0gbnRvaGwobXNnLmhk
ci5zaXplKSAtIE1TR19IRFJfTEVOIC0gbnRvaGwobXNnLmhkci5jbWRfc2l6ZSk7DQo+ID4gKyAg
ICAgaWYgKGJ1Zl9sZW4gPD0gMCB8fA0KPiA+ICsgICAgICAgICBidWZfbGVuICE9IHNpemVvZigq
bXNnLnBvcnRfYXJyYXkpICogbnRvaGwobXNnLnRyYWNlX3Jlc3AuY3B1cykpIHsNCj4gPiArICAg
ICAgICAgICAgIHJldCA9IC1FSU5WQUw7DQo+ID4gKyAgICAgICAgICAgICBnb3RvIG91dDsNCj4g
PiArICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICpucl9jcHVzID0gbnRvaGwobXNnLnRyYWNlX3Jl
c3AuY3B1cyk7DQo+ID4gKyAgICAgKnBhZ2Vfc2l6ZSA9IG50b2hsKG1zZy50cmFjZV9yZXNwLnBh
Z2Vfc2l6ZSk7DQo+ID4gKyAgICAgKnBvcnRzID0gY2FsbG9jKCpucl9jcHVzLCBzaXplb2YoKipw
b3J0cykpOw0KPiA+ICsgICAgIGlmICghKnBvcnRzKSB7DQo+ID4gKyAgICAgICAgICAgICByZXQg
PSAtRU5PTUVNOw0KPiA+ICsgICAgICAgICAgICAgZ290byBvdXQ7DQo+ID4gKyAgICAgfQ0KPiA+
ICsgICAgIGZvciAoaSA9IDA7IGkgPCAqbnJfY3B1czsgaSsrKQ0KPiA+ICsgICAgICAgICAgICAg
KCpwb3J0cylbaV0gPSBudG9obChtc2cucG9ydF9hcnJheVtpXSk7DQo+ID4gKw0KPiA+ICsgICAg
IG1zZ19mcmVlKCZtc2cpOw0KPiA+ICsgICAgIHJldHVybiAwOw0KPiA+ICsNCj4gPiArb3V0Og0K
PiA+ICsgICAgIGVycm9yX29wZXJhdGlvbigmbXNnKTsNCj4gPiArICAgICBpZiAocmV0ID09IC1F
T1BOT1RTVVBQKQ0KPiA+ICsgICAgICAgICAgICAgaGFuZGxlX3VuZXhwZWN0ZWRfbXNnKG1zZ19o
YW5kbGUsICZtc2cpOw0KPiA+ICsgICAgIG1zZ19mcmVlKCZtc2cpOw0KPiA+ICsgICAgIHJldHVy
biByZXQ7DQo+ID4gK30NCj4NCg==
