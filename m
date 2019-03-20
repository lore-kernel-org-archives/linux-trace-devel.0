Return-Path: <SRS0=0SC1=RX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A53CFC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Mar 2019 15:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 614652146E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Mar 2019 15:06:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="DE0OfILd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbfCTPG4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 11:06:56 -0400
Received: from mail-eopbgr810043.outbound.protection.outlook.com ([40.107.81.43]:17312
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725988AbfCTPGz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 11:06:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OeqRLpi2ma7VCZqHwjDvJkD6v9lIenCBMYEjQa5m0c0=;
 b=DE0OfILdGXg0OKqiR4Xhru98ROfykbeZhEfF9AE/xp6JQcqoI5iyk9v0fCb/wZ/qgq4/C3AsTIWamgwIDgasB1XNq0WRoqBCzgCoEeHDXknDDZYY91sidCiAYmuc4baOiBIrEvLORXB8Usy0SUt6hX5vHirS2BvIZh1Q8cW2zZM=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2523.namprd05.prod.outlook.com (10.167.10.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.16; Wed, 20 Mar 2019 15:06:52 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec%4]) with mapi id 15.20.1730.013; Wed, 20 Mar 2019
 15:06:52 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Slavomir Kaslev <kaslevs@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 9/9] trace-cmd [POC]: Implemented timestamps synch
 algorithm, using vsock events.
Thread-Topic: [PATCH v7 9/9] trace-cmd [POC]: Implemented timestamps synch
 algorithm, using vsock events.
Thread-Index: AQHU3ncvl3wcWa60k0WrVCA/aOrP2qYUoBUA
Date:   Wed, 20 Mar 2019 15:06:52 +0000
Message-ID: <CACqStoe8yCn1Q4gp-rLVDm4ca8gqrN9Owz9=g1LLQtr54jcNeA@mail.gmail.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
 <20190319155536.19381-10-tstoyanov@vmware.com>
 <CAE0o1NvsHhROnXesVHT08HfPO_FC3EjxXrkfqkPsF6SB=6Z2Lg@mail.gmail.com>
In-Reply-To: <CAE0o1NvsHhROnXesVHT08HfPO_FC3EjxXrkfqkPsF6SB=6Z2Lg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0701CA0051.eurprd07.prod.outlook.com
 (2603:10a6:203:2::13) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAVmwlmaK6Nyl+fH9ajj6KmDmpAnARWgc3XWkzsWv0+cBZtPZOTC
        bALp17xEJqoDSb2t9gixW560y8hN/nRp3HMpW4Q=
x-google-smtp-source: APXvYqyIbcKfJ+JR61zg5Fj3uyiqYiqWhpZOgyt/rmSexK+ONhw/ZDCSrrrrcDBThzKRJ/x8jQGVNoq+qXiEunF0qoM=
x-received: by 2002:a5d:4887:: with SMTP id g7mr22511552wrq.51.1553094406981;
 Wed, 20 Mar 2019 08:06:46 -0700 (PDT)
x-gmail-original-message-id: <CACqStoe8yCn1Q4gp-rLVDm4ca8gqrN9Owz9=g1LLQtr54jcNeA@mail.gmail.com>
x-originating-ip: [209.85.221.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8aad89ea-b49f-41c6-ba57-08d6ad45aeeb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2523;
x-ms-traffictypediagnostic: CY1PR05MB2523:
x-microsoft-antispam-prvs: <CY1PR05MB25238DE2768D582BFDD7292CDC410@CY1PR05MB2523.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(39860400002)(136003)(366004)(189003)(199004)(71200400001)(53936002)(98316002)(66066001)(61726006)(61266001)(68736007)(81166006)(6862004)(6436002)(8936002)(486006)(71190400001)(14454004)(4326008)(6486002)(99286004)(8676002)(55446002)(6246003)(81156014)(6636002)(229853002)(54906003)(478600001)(95326003)(102836004)(106356001)(316002)(25786009)(305945005)(105586002)(86362001)(186003)(446003)(6506007)(386003)(11346002)(6116002)(9686003)(476003)(3846002)(6512007)(53546011)(498394004)(5660300002)(2906002)(76176011)(7736002)(97736004)(6346003)(26005)(52116002)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2523;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UiTQrzaIhRqSv3mXaSKGjHh9mRuJvujh4eW1NMlCZV41+xarpKZkH3r3I0a4usCxP7H64u6JNAFcC3rpQ8atgiOXHBSuc8bTTKoIpL2o/9wHq+q1AX7Wd3c/vyXiJ/Uj9TRRuVx1GPLJNHyKVIf7kMJEsamtUy08XEF9uPIoFmI7sftqw16xu0QrH1TR6omAf6YOFvzfnEN/UdDpx4DEAedJNSOtzCp7VaY/IKDxg8bDxdUzFpyF/REwrL6SOicAGee28SU7m6GBzsWOpTjHzO72m12e1SH1shfDIG7Czt6Ymk69oyMWO+bORCCFG3prRcpBGfAFyWa5zWjsVrGBs8eO4rBBVpTRnDy/MMEM1mGkeXKc2ABgTxuLs+Ae2TBBs5PY+rOisd9zrGJLoS5no561a0Q+ysqJqt13iPN9+WI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <23FEF115AA53E541BAE7F688765AF588@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aad89ea-b49f-41c6-ba57-08d6ad45aeeb
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 15:06:52.3480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2523
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCBNYXIgMTksIDIwMTkgYXQgNzoxNCBQTSBTbGF2b21pciBLYXNsZXYgPGthc2xldnNA
dm13YXJlLmNvbT4gd3JvdGU6DQo+DQo+IE9uIFR1ZSwgTWFyIDE5LCAyMDE5IGF0IDU6NTYgUE0g
VHp2ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJlLmNvbT4gd3JvdGU6DQo+ID4NCj4g
PiBUaGlzIGlzIGEgUE9DIHBhdGNoLCBpbXBsZW1lbnRpbmcgYW4gYWxnb3JpdGhtIGZvciBzeW5j
aW5nIHRpbWVzdGFtcHMgYmV0d2Vlbg0KPiA+IGhvc3QgYW5kIGd1ZXN0IG1hY2hpbmVzLCB1c2lu
ZyB2c29jayB0cmFjZSBldmVudHMgdG8gY2F0Y2ggdGhlIGhvc3QgLyBndWVzdCB0aW1lLg0KPiA+
DQo+ID4gU2lnbmVkLW9mZi1ieTogVHp2ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJl
LmNvbT4NCj4gPiAtLS0NCj4gPiAgaW5jbHVkZS90cmFjZS1jbWQvdHJhY2UtY21kLmggIHwgIDIx
ICstDQo+ID4gIHRyYWNlY21kL01ha2VmaWxlICAgICAgICAgICAgICB8ICAgMSArDQo+ID4gIHRy
YWNlY21kL2luY2x1ZGUvdHJhY2UtbG9jYWwuaCB8ICAzMyArLQ0KPiA+ICB0cmFjZWNtZC90cmFj
ZS1hZ2VudC5jICAgICAgICAgfCAgMTMgKy0NCj4gPiAgdHJhY2VjbWQvdHJhY2UtbXNnLmMgICAg
ICAgICAgIHwgMjA4ICsrKysrKysrLQ0KPiA+ICB0cmFjZWNtZC90cmFjZS1yZWNvcmQuYyAgICAg
ICAgfCAgODUgKysrLQ0KPiA+ICB0cmFjZWNtZC90cmFjZS10aW1lc3luYy5jICAgICAgfCA4MjUg
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIDcgZmlsZXMgY2hhbmdlZCwg
MTE1MCBpbnNlcnRpb25zKCspLCAzNiBkZWxldGlvbnMoLSkNCj4gPiAgY3JlYXRlIG1vZGUgMTAw
NjQ0IHRyYWNlY21kL3RyYWNlLXRpbWVzeW5jLmMNCj4gPg0KDQo+ID4gLS0tIGEvdHJhY2VjbWQv
TWFrZWZpbGUNCj4gPiArKysgYi90cmFjZWNtZC9NYWtlZmlsZQ0KPiA+IEBAIC0zMiw2ICszMiw3
IEBAIFRSQUNFX0NNRF9PQkpTICs9IHRyYWNlLWxpc3Qubw0KPiA+ICBUUkFDRV9DTURfT0JKUyAr
PSB0cmFjZS1vdXRwdXQubw0KPiA+ICBUUkFDRV9DTURfT0JKUyArPSB0cmFjZS11c2FnZS5vDQo+
ID4gIFRSQUNFX0NNRF9PQkpTICs9IHRyYWNlLW1zZy5vDQo+ID4gK1RSQUNFX0NNRF9PQkpTICs9
IHRyYWNlLXRpbWVzeW5jLm8NCj4NCj4gU2hvdWxkbid0IHRoaXMgYmUgb24gb25seSBpZiAkVlNP
Q0tfREVGSU5FRCwgc2FtZSBhcyB0cmFjZS1hZ2VudC5vIGJlbG93Pw0KDQpCeSBkZXNpZ24sIHRy
YWNlLWFnZW50LmMgc2hvdWxkIGhhbmRsZSBhbGwgdGltZXN0YW1wIHN5bmMgbG9naWMsIG5vdA0K
b25seSB2c29jayByZWxhdGF0ZWQgb25lLg0KQ3VycmVudGx5IHdlIHJlbHkgb25seSBvbiB2c29j
ayBldmVudHMsIGJ1dCB3ZSBtaWdodCBoYXZlIHRpbWVzdGFtcA0Kc3luYyB3aGljaCBkb2VzIG5v
dA0KZGVwZW5kIG9uIHZzb2NrcyBpbiB0aGUgZnV0dXJlLg0KDQo+DQo+ID4NCj4gPiAgaWZlcSAo
JChWU09DS19ERUZJTkVEKSwgMSkNCj4gPiAgVFJBQ0VfQ01EX09CSlMgKz0gdHJhY2UtYWdlbnQu
bw0KDQoNCj4gPiArLy8jZGVmaW5lIFRTWU5DX1JCVUZGRVJfREVCVUcNCj4gPiArc3RhdGljIGlu
dCBmaW5kX3Jhd19ldmVudHMoc3RydWN0IHRlcF9oYW5kbGUgKnRlcCwNCj4gPiArICAgICAgICAg
ICAgICAgICAgIHN0cnVjdCBidWZmZXJfaW5zdGFuY2UgKmluc3RhbmNlLA0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgc3RydWN0IHRyYWNlY21kX3RpbWVfc3luY19ldmVudCAqZXZlbnRzKQ0KPiA+
ICt7DQo+ID4gKyAgICAgICBzdHJ1Y3QgdHJhY2VjbWRfdGltZV9zeW5jX2V2ZW50ICpldmVudHNf
YXJyYXkgPSBOVUxMOw0KPiA+ICsgICAgICAgaW50IGV2ZW50c19jb3VudCA9IDA7DQo+ID4gKyAg
ICAgICBpbnQgZXZlbnRzX3NpemUgPSAwOw0KPiA+ICsgICAgICAgdW5zaWduZWQgaW50IHBfc2l6
ZTsNCj4gPiArICAgICAgIGludCB0cyA9IDA7DQo+ID4gKyAgICAgICB2b2lkICpwYWdlOw0KPiA+
ICsgICAgICAgY2hhciAqcGF0aDsNCj4gPiArICAgICAgIGNoYXIgKmZpbGU7DQo+ID4gKyAgICAg
ICBESVIgKmRpcjsNCj4NCj4gYGRpcmAgaXMgdW51c2VkIGJlc2lkZXMgZ2V0dGluZyBvcGVuZWQg
YW5kIGNsb3NlZCBiZWxvdywgcmVtb3ZlIGl0Pw0KPiBPciBpcyBpdCBzdXBwb3NlZCB0byBjaGVj
ayBmb3IgdGhlIGV4aXN0ZW5jZSBvZiBzdWNoIGZvbGRlcj8gSWYgc28sDQo+IG1heWJlIGEgc3Rh
dCgpIHdpbGwgc3VmZmljZSBvciByZWx5IG9uIHRoYXQgb3BlbmluZyBmaWxlcyBpbnNpZGUgdGhp
cw0KPiBkaXJlY3Rvcnkgd2lsbCBmYWlsIHRvby4NCj4NCkknbGwgcmVtb3ZlIGl0LCBJIHRoaW5r
IHRoZXJlIGlzIG5vIG5lZWQgdG8gY2hlY2sgaWYgaXQgZXhpc3RzLg0KDQo+ID4gKyAgICAgICBw
YXRoID0gZ2V0X2luc3RhbmNlX2ZpbGUoaW5zdGFuY2UsICJwZXJfY3B1Iik7DQo+ID4gKyAgICAg
ICBpZiAoIXBhdGgpDQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiB0czsNCj4gPiArDQo+ID4g
KyAgICAgICBkaXIgPSBvcGVuZGlyKHBhdGgpOw0KPiA+ICsgICAgICAgaWYgKCFkaXIpDQo+ID4g
KyAgICAgICAgICAgICAgIGdvdG8gb3V0Ow0KPiA+ICsNCj4gPiArICAgICAgIGxlbiA9IHN0cmxl
bihwYXRoKTsNCj4gPiArICAgICAgIGZpbGUgPSBtYWxsb2MobGVuICsgc3RybGVuKCJ0cmFjZV9w
aXBlX3JhdyIpICsgMzIpOw0KPg0KPiBIb3cgYWJvdXQgaGF2aW5nIGZpbGUgZGVmaW5lZCBhcw0K
Pg0KPiAgICAgY2hhciBmaWxlW1BBVEhfTUFYXTsNCj4NCj4gYW5kIGF2b2lkIGFsbG9jYXRpb24g
YW5kIGNvbXB1dGluZyBob3cgbXVjaCBzcGFjZSB3ZSBuZWVkIGZvciBpdD8NCg0KVGhhbmtzLCBJ
J2xsIGFkZCBpdCBpbiB0aGUgbmV4dCB2ZXJzaW9uIG9mIHRoZSBwYXRjaC4NCg0KPg0KPiA+ICtz
dGF0aWMgdm9pZCBnZXRfdnNvY2tldF9wYXJhbXMoaW50IGZkLCB1bnNpZ25lZCBpbnQgKmxjaWQs
IHVuc2lnbmVkIGludCAqbHBvcnQsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHVuc2lnbmVkIGludCAqcmNpZCwgdW5zaWduZWQgaW50ICpycG9ydCkNCj4NCj4gVGhpcyBzdGF0
aWMgZnVuY3Rpb24gaXMgY2FsbGVkIG9ubHkgb25jZSBpbiB0aGlzIGZpbGUgYW5kIG5ldmVyIHdp
dGgNCj4gTlVMTCBvdXRwdXQgYXJndW1lbnRzLiBJIHRoaW5rIHdlIGNhbiBzYWZlbHkgZHJvcCBh
bGwgTlVMTCBwb2ludGVyDQo+IGNoZWNrcyBpbiBpdCBhbmQgc2ltcGxpZnkgaXQuDQo+DQoNClRo
YXQncyB0cnVlLCB0aGUgcmVhc29uIGZvciB0aG9zZSBjaGVja3MgaXMgdGhhdCBpbiBvbmUgb2Yg
dGhlDQpwcmV2aW91cyB2ZXJzaW9ucyBvZg0KdGhlIHBhdGNoIGl0IHdhcyBjYWxsZWQgd2l0aCBO
VUxMIHBvaW50ZXJzLiBJJ2xsIHJlbW92ZSB0aGUgY2hlY2tzLg0KDQo+ID4gK3RyYWNlY21kX2Ns
b2NrX2NvbnRleHRfbmV3KHN0cnVjdCB0cmFjZWNtZF9tc2dfaGFuZGxlICptc2dfaGFuZGxlLA0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zdCBjaGFyICpjbG9ja19zdHIsDQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgIGVudW0gY2xvY2tfc3luY19jb250ZXh0IGlk
KQ0KPiA+ICt7DQo+ID4gKyAgICAgICBzdHJ1Y3QgdHJhY2VjbWRfY2xvY2tfc3luYyAqY2xvY2tf
Y29udGV4dDsNCj4gPiArICAgICAgIHN0cnVjdCB0ZXBfZXZlbnQgKmV2ZW50Ow0KPiA+ICsgICAg
ICAgdW5zaWduZWQgaW50IGkgPSAwOw0KPiA+ICsNCj4gPiArICAgICAgIHN3aXRjaCAoaWQpIHsN
Cj4gPiArI2lmZGVmIFZTT0NLDQo+ID4gKyAgICAgICBjYXNlIENMT0NLX0tWTV9YODZfVlNPQ0tf
SE9TVDoNCj4gPiArICAgICAgIGNhc2UgQ0xPQ0tfS1ZNX1g4Nl9WU09DS19HVUVTVDoNCj4gPiAr
ICAgICAgICAgICAgICAgYnJlYWs7DQo+ID4gKyNlbmRpZg0KPiA+ICsgICAgICAgZGVmYXVsdDog
Lyogbm90IHN1cHBvcnRlZCBjbG9jayBzeW5jIGNvbnRleHQgKi8NCj4gPiArICAgICAgICAgICAg
ICAgcmV0dXJuIE5VTEw7DQo+ID4gKyAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAgaWYgKGlk
ID49IENMT0NLX0NPTlRFWFRfTUFYIHx8IE5VTEwgPT0gbXNnX2hhbmRsZSkNCj4gPiArICAgICAg
ICAgICAgICAgcmV0dXJuIE5VTEw7DQo+ID4gKyAgICAgICBjbG9ja19jb250ZXh0ID0gY2FsbG9j
KDEsIHNpemVvZihzdHJ1Y3QgdHJhY2VjbWRfY2xvY2tfc3luYykpOw0KPiA+ICsgICAgICAgaWYg
KCFjbG9ja19jb250ZXh0KQ0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gTlVMTDsNCj4gPiAr
ICAgICAgIGNsb2NrX2NvbnRleHQtPmNsb2NrX2NvbnRleHRfaWQgPSBpZDsNCj4gPiArICAgICAg
IGNsb2NrX2NvbnRleHRfY29weShjbG9ja19jb250ZXh0LA0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgIGNsb2NrX3N5bmNbaWRdLmZ0cmFjZV9wYXJhbXMsIGNsb2NrX3N5bmNbaWRdLmV2
ZW50cyk7DQo+ID4gKw0KPiA+ICsgICAgICAgZ2V0X3Zzb2NrZXRfcGFyYW1zKG1zZ19oYW5kbGUt
PmZkLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICYoY2xvY2tfY29udGV4dC0+bG9j
YWxfY2lkKSwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAmKGNsb2NrX2NvbnRleHQt
PmxvY2FsX3BvcnQpLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICYoY2xvY2tfY29u
dGV4dC0+cmVtb3RlX2NpZCksDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgJihjbG9j
a19jb250ZXh0LT5yZW1vdGVfcG9ydCkpOw0KPg0KPiBOaXQ6IHBhcmVudGhlc2lzIGFyZSBub3Qg
bmVlZGVkOg0KPg0KPiAgICAgICBnZXRfdnNvY2tldF9wYXJhbXMobXNnX2hhbmRsZS0+ZmQsDQo+
ICAgICAgICAgICAgICAgICAgICAgICAgICAmY2xvY2tfY29udGV4dC0+bG9jYWxfY2lkLA0KPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgJmNsb2NrX2NvbnRleHQtPmxvY2FsX3BvcnQsDQo+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAmY2xvY2tfY29udGV4dC0+cmVtb3RlX2NpZCwNCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgICZjbG9ja19jb250ZXh0LT5yZW1vdGVfcG9ydCk7DQo+DQo+
ID4gKw0KDQpUaGFua3MgU2xhdmkNCg0KDQotLSANCg0KVHp2ZXRvbWlyIChDZWNvKSBTdG95YW5v
dg0KVk13YXJlIE9wZW4gU291cmNlIFRlY2hub2xvZ3kgQ2VudGVyDQo=
