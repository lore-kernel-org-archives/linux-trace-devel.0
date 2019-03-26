Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB248C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 17:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0A1320823
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 17:35:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="n0UtSgrh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfCZRfz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 13:35:55 -0400
Received: from mail-eopbgr700078.outbound.protection.outlook.com ([40.107.70.78]:37793
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726207AbfCZRfz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 13:35:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eflf4YtQHHysz3kGytW2r+vmxeiNGruJaqNojqo1NEI=;
 b=n0UtSgrhrv+/lx17hFqttbahkqwxnhY4e0Bm+1bgEozWr/oTBvtpMJgZ0VRTTW7OzaUy8YSvMzVbr7/7Tz1c8CmMQipn5t02DyBioaouEcunhQAHuqRUCDvphfDfcJKmaswuCCwt6CjSnQrukjGPlvhCsTlRwFdXPCIwa9XoiR0=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3820.namprd05.prod.outlook.com (10.167.173.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.14; Tue, 26 Mar 2019 17:35:47 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41%5]) with mapi id 15.20.1750.010; Tue, 26 Mar 2019
 17:35:47 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v10 8/9] trace-cmd: Implemented new option in trace.dat
 file: TRACECMD_OPTION_TIME_SHIFT
Thread-Topic: [PATCH v10 8/9] trace-cmd: Implemented new option in trace.dat
 file: TRACECMD_OPTION_TIME_SHIFT
Thread-Index: AQHU4/pZLFvVasKfrUyfJnLDavba1Q==
Date:   Tue, 26 Mar 2019 17:35:47 +0000
Message-ID: <CAE0o1Nv2NYa7G58kF9QfS5dV-Lz_h1FAyADtK=fhTBTDp0O0yg@mail.gmail.com>
References: <20190326150651.25811-1-tstoyanov@vmware.com>
 <20190326150651.25811-9-tstoyanov@vmware.com>
In-Reply-To: <20190326150651.25811-9-tstoyanov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YQBPR0101CA0057.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::34) To MWHPR0501MB3772.namprd05.prod.outlook.com
 (2603:10b6:301:7a::28)
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAVULPQpW3TMpcDGattj3z4PoY1o6BAgXE5sxtYLBRj9mzLZ0dqe
        Inco5fvjPh268TGIeXFI6l0Cu14BiL/S6iSJWg==
x-google-smtp-source: APXvYqxSAEe7EehBybjXRFQOGUEGkTkNS+/byFPbMcc/7oUji2DxNdO/9Kg8Dfc7eFmuEPdqz19h5KMUyPpxyDP0fZ4=
x-received: by 2002:a6b:e317:: with SMTP id u23mr1845105ioc.206.1553621422959;
 Tue, 26 Mar 2019 10:30:22 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1Nv2NYa7G58kF9QfS5dV-Lz_h1FAyADtK=fhTBTDp0O0yg@mail.gmail.com>
x-originating-ip: [209.85.166.53]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17d2efe3-3180-4b02-bf73-08d6b2117b6c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600127)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:MWHPR0501MB3820;
x-ms-traffictypediagnostic: MWHPR0501MB3820:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-microsoft-antispam-prvs: <MWHPR0501MB3820B8B8D0915249EC29E83DDA5F0@MWHPR0501MB3820.namprd05.prod.outlook.com>
x-forefront-prvs: 09888BC01D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(346002)(396003)(366004)(199004)(189003)(9686003)(61726006)(76176011)(498394004)(86362001)(54906003)(7736002)(55446002)(476003)(26005)(486006)(8676002)(6636002)(81166006)(478600001)(6246003)(8936002)(71200400001)(71190400001)(102836004)(81156014)(305945005)(446003)(6862004)(66066001)(105586002)(106356001)(186003)(97736004)(4326008)(11346002)(386003)(99286004)(2906002)(53546011)(6486002)(6436002)(6506007)(68736007)(53936002)(256004)(95326003)(14454004)(52116002)(61266001)(6116002)(316002)(3846002)(5660300002)(98316002)(6512007)(25786009)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3820;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:3;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tCoIVpR/dmnXUBhJLQbBnhcVw7HV9wb8Df6YGFsRxaaxcSEwA3hsHPwWTU2XMbzNVBsnRd/knPVcS/j+0miFl2nbSnm2X73dHVR0Vgy/mwlZOk4NmOGGIEXKiD2hep0WYPjKQPgPYl52AeALpDL4UE/DZlwzASfWN9R9ZGzN+7C3eBdZLviJeDTtLO3ax6KNyDsFCcsRvdYwJEIRNR8JEhKBvlEke8UvKns/uEbeD8iE35e3k11L0pLLa/jSaJ5ar0s++yqxNOuA20mdDVAx4o/IwuZWwklqpKLFBfwC0TGXZh4/Y13bjaCW6sx2EAxCdba7JtxXx7vqJAQX+ZICbgCG2j5Y4RU8K5AJJ2iHf8EEqm5sEiQ3JZZkChT+kYbFaPnxlA76hcRV7esebcw0EgCdxppg+y5u5yhYM/yc/iA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0FB29A83CCAA54FB0DCA80F9E654A88@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17d2efe3-3180-4b02-bf73-08d6b2117b6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2019 17:35:47.7338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3820
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCBNYXIgMjYsIDIwMTkgYXQgNTowNyBQTSBUenZldG9taXIgU3RveWFub3YgPHRzdG95
YW5vdkB2bXdhcmUuY29tPiB3cm90ZToNCg0KPHNuaXA+DQoNCj4gK3N0YXRpYyBpbnQgdHN5bmNf
b2Zmc2V0X2NtcChjb25zdCB2b2lkICphLCBjb25zdCB2b2lkICpiKQ0KPiArew0KPiArICAgICAg
IHN0cnVjdCB0c19vZmZzZXRfc2FtcGxlICp0c19hID0gKHN0cnVjdCB0c19vZmZzZXRfc2FtcGxl
ICopYTsNCj4gKyAgICAgICBzdHJ1Y3QgdHNfb2Zmc2V0X3NhbXBsZSAqdHNfYiA9IChzdHJ1Y3Qg
dHNfb2Zmc2V0X3NhbXBsZSAqKWI7DQo+ICsNCj4gKyAgICAgICBpZiAodHNfYS0+dGltZSA+IHRz
X2ItPnRpbWUpDQo+ICsgICAgICAgICAgICAgICByZXR1cm4gMTsNCj4gKyAgICAgICBpZiAodHNf
YS0+dGltZSA8IHRzX2ItPnRpbWUpDQo+ICsgICAgICAgICAgICAgICByZXR1cm4gLTE7DQo+ICsg
ICAgICAgcmV0dXJuIDA7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyB2b2lkIHRzeW5jX29mZnNldF9s
b2FkKHN0cnVjdCB0cmFjZWNtZF9pbnB1dCAqaGFuZGxlLCBjaGFyICpidWYpDQo+ICt7DQo+ICsg
ICAgICAgaW50IGksIGo7DQo+ICsgICAgICAgbG9uZyBsb25nICpidWY4ID0gKGxvbmcgbG9uZyAq
KWJ1ZjsNCj4gKw0KPiArICAgICAgIGZvciAoaSA9IDA7IGkgPCBoYW5kbGUtPnRzX3NhbXBsZXNf
Y291bnQ7IGkrKykgew0KPiArICAgICAgICAgICAgICAgaGFuZGxlLT50c19zYW1wbGVzW2ldLnRp
bWUgPSB0ZXBfcmVhZF9udW1iZXIoaGFuZGxlLT5wZXZlbnQsDQo+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBidWY4K2ksIDgpOw0KPiAr
ICAgICAgICAgICAgICAgaGFuZGxlLT50c19zYW1wbGVzW2ldLm9mZnNldCA9IHRlcF9yZWFkX251
bWJlcihoYW5kbGUtPnBldmVudCwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgYnVmOCtoYW5kbGUtPnRzX3NhbXBsZXNfY291bnQraSwgOCk7DQo+ICsg
ICAgICAgfQ0KPiArICAgICAgIHFzb3J0KGhhbmRsZS0+dHNfc2FtcGxlcywNCj4gKyAgICAgICAg
ICAgICBoYW5kbGUtPnRzX3NhbXBsZXNfY291bnQsIHNpemVvZihzdHJ1Y3QgdHNfb2Zmc2V0X3Nh
bXBsZSksDQo+ICsgICAgICAgICAgICAgdHN5bmNfb2Zmc2V0X2NtcCk7DQo+ICsgICAgICAgLyog
RmlsdGVyIHBvc3NpYmxlIHNhbXBsZXMgd2l0aCBlcXVhbCB0aW1lICovDQo+ICsgICAgICAgZm9y
IChpID0gMCwgaiA9IDA7IGkgPCBoYW5kbGUtPnRzX3NhbXBsZXNfY291bnQ7IGkrKykgew0KPiAr
ICAgICAgICAgICAgICAgaWYgKGkgPT0gMCB8fA0KPiArICAgICAgICAgICAgICAgICAgIGhhbmRs
ZS0+dHNfc2FtcGxlc1tpXS50aW1lICE9IGhhbmRsZS0+dHNfc2FtcGxlc1tpLTFdLnRpbWUpIHsN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgaGFuZGxlLT50c19zYW1wbGVzW2orK10gPSBoYW5k
bGUtPnRzX3NhbXBsZXNbaV07DQo+ICsgICAgICAgICAgICAgICB9DQo+ICsgICAgICAgfQ0KDQpo
YW5kbGUtPnRzX3NhbXBsZXNfY291bnQgaXMgbmV2ZXIgY29ycmVjdGVkIGhlcmUgaW4gY2FzZSB0
aGVyZSBhcmUNCnNhbXBsZXMgd2l0aCBkdXBsaWNhdGUgdGltZXN0YW1wcy4NCg0KICAgIGhhbmRs
ZS0+dHNfc2FtcGxlc19jb3VudCA9IGo7DQoNCj4gK30NCj4gKw0KPiAgc3RhdGljIGludCBoYW5k
bGVfb3B0aW9ucyhzdHJ1Y3QgdHJhY2VjbWRfaW5wdXQgKmhhbmRsZSkNCj4gIHsNCj4gICAgICAg
ICBsb25nIGxvbmcgb2Zmc2V0Ow0KPiBAQCAtMjExMSw2ICsyMjEzLDcgQEAgc3RhdGljIGludCBo
YW5kbGVfb3B0aW9ucyhzdHJ1Y3QgdHJhY2VjbWRfaW5wdXQgKmhhbmRsZSkNCj4gICAgICAgICBz
dHJ1Y3QgaW5wdXRfYnVmZmVyX2luc3RhbmNlICpidWZmZXI7DQo+ICAgICAgICAgc3RydWN0IGhv
b2tfbGlzdCAqaG9vazsNCj4gICAgICAgICBjaGFyICpidWY7DQo+ICsgICAgICAgaW50IHRzeW5j
Ow0KDQpOaXQ6IHMvdHN5bmMvc2FtcGVzX3NpemU/DQoNCj4gICAgICAgICBpbnQgY3B1czsNCj4N
Cj4gICAgICAgICBmb3IgKDs7KSB7DQo+IEBAIC0yMTU1LDYgKzIyNTgsMjUgQEAgc3RhdGljIGlu
dCBoYW5kbGVfb3B0aW9ucyhzdHJ1Y3QgdHJhY2VjbWRfaW5wdXQgKmhhbmRsZSkNCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgb2Zmc2V0ID0gc3RydG9sbChidWYsIE5VTEwsIDApOw0KPiAgICAg
ICAgICAgICAgICAgICAgICAgICBoYW5kbGUtPnRzX29mZnNldCArPSBvZmZzZXQ7DQo+ICAgICAg
ICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiArICAgICAgICAgICAgICAgY2FzZSBUUkFDRUNN
RF9PUFRJT05fVElNRV9TSElGVDoNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgLyoNCj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICogaW50ICg0IGJ5dGVzKSBjb3VudCBvZiB0aW1lc3RhbXAg
b2Zmc2V0cy4NCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICogbG9uZyBsb25nIGFycmF5IG9m
IHNpemUgW2NvdW50XSBvZiB0aW1lcywNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICogICAg
ICB3aGVuIHRoZSBvZmZzZXRzIHdlcmUgY2FsY3VsYXRlZC4NCj4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICogbG9uZyBsb25nIGFycmF5IG9mIHNpemUgW2NvdW50XSBvZiB0aW1lc3RhbXAgb2Zm
c2V0cy4NCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICovDQo+ICsgICAgICAgICAgICAgICAg
ICAgICAgIGlmIChoYW5kbGUtPmZsYWdzICYgVFJBQ0VDTURfRkxfSUdOT1JFX0RBVEUpDQo+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+ICsgICAgICAgICAgICAgICAg
ICAgICAgIGhhbmRsZS0+dHNfc2FtcGxlc19jb3VudCA9IHRlcF9yZWFkX251bWJlcihoYW5kbGUt
PnBldmVudCwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGJ1ZiwgNCk7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHRz
eW5jID0gKHNpemVvZihsb25nIGxvbmcpKmhhbmRsZS0+dHNfc2FtcGxlc19jb3VudCk7DQo+ICsg
ICAgICAgICAgICAgICAgICAgICAgIGlmIChzaXplICE9ICg0KygyKnRzeW5jKSkpDQo+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+ICsgICAgICAgICAgICAgICAgICAg
ICAgIGhhbmRsZS0+dHNfc2FtcGxlcyA9IG1hbGxvYygyKnRzeW5jKTsNCj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgaWYgKCFoYW5kbGUtPnRzX3NhbXBsZXMpDQo+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9NRU07DQo+ICsgICAgICAgICAgICAgICAgICAgICAg
IHRzeW5jX29mZnNldF9sb2FkKGhhbmRsZSwgYnVmKzQpOw0KPiArICAgICAgICAgICAgICAgICAg
ICAgICBicmVhazsNCj4gICAgICAgICAgICAgICAgIGNhc2UgVFJBQ0VDTURfT1BUSU9OX0NQVVNU
QVQ6DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGJ1ZltzaXplLTFdID0gJ1xuJzsNCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgY3B1c3RhdHMgPSByZWFsbG9jKGNwdXN0YXRzLCBjcHVzdGF0
c19zaXplICsgc2l6ZSArIDEpOw0KPiAtLQ0KPiAyLjIwLjENCj4NCg==
