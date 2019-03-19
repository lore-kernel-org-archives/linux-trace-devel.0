Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5ADC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 16:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44CA02064A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 16:35:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="QXclNA54"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfCSQfe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 12:35:34 -0400
Received: from mail-eopbgr680063.outbound.protection.outlook.com ([40.107.68.63]:32000
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726876AbfCSQfd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 12:35:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FV3KTOLH9/UrYcobjOsIFp75zU4KLeJ9wI08cBpscgw=;
 b=QXclNA54UwnKhG0IXvn5CknBWhk2fhAqhZwoh1G0r/eSFekmeviEntjdLG8P2ort10B8k+vJLdf1YYWJ9X79Fj9ySKrkfaZz4fcI1xYs/bwbAxGYWDmzAL4OLZl+PrOkVNapXu32WZq0ULkTIuWXxOup+Pl+feVjn3G/CUOcka8=
Received: from CY1PR05MB2780.namprd05.prod.outlook.com (10.167.18.26) by
 CY1PR05MB2441.namprd05.prod.outlook.com (10.167.10.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.5; Tue, 19 Mar 2019 16:35:28 +0000
Received: from CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f]) by CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f%9]) with mapi id 15.20.1730.003; Tue, 19 Mar 2019
 16:35:28 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 6/9] trace-cmd: Find and store pids of tasks, which run
 virtual CPUs of given VM
Thread-Topic: [PATCH v7 6/9] trace-cmd: Find and store pids of tasks, which
 run virtual CPUs of given VM
Thread-Index: AQHU3nHCXVhQmYqSy0+bsRTdqxjTDA==
Date:   Tue, 19 Mar 2019 16:35:28 +0000
Message-ID: <CAE0o1NtR+bEXYUP_suHJMfAXnXmtSPPMzSZrunoP5mp5VeNL_A@mail.gmail.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
 <20190319155536.19381-7-tstoyanov@vmware.com>
In-Reply-To: <20190319155536.19381-7-tstoyanov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YQBPR0101CA0071.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::48) To CY1PR05MB2780.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAU3AN6TkE3NKXfmGjumSitbG0RVMOZdOkmSKgdiwJEN9BFBk9iR
        Bu9wLrsUTEdbSBm8zlOFHdAe6XuTEVoBG1Itig==
x-google-smtp-source: APXvYqywwp0Bfz/LDIGtkbyb2PmwL6v7aKa6LffLCme6+c9oweWbusspDRFzNZElgJMyd/tYLnfhktNbYnfXGOsdBdg=
x-received: by 2002:a5e:9e02:: with SMTP id i2mr2258693ioq.238.1553013323915;
 Tue, 19 Mar 2019 09:35:23 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1NtR+bEXYUP_suHJMfAXnXmtSPPMzSZrunoP5mp5VeNL_A@mail.gmail.com>
x-originating-ip: [209.85.166.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22002284-728c-4f83-36a0-08d6ac88e530
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2441;
x-ms-traffictypediagnostic: CY1PR05MB2441:
x-microsoft-antispam-prvs: <CY1PR05MB24414E647F31DD0C9BB0188CDA400@CY1PR05MB2441.namprd05.prod.outlook.com>
x-forefront-prvs: 0981815F2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(39860400002)(396003)(346002)(136003)(189003)(199004)(55446002)(6246003)(53936002)(14454004)(26005)(316002)(99286004)(54906003)(2906002)(81156014)(81166006)(52116002)(186003)(4326008)(8676002)(76176011)(498394004)(66066001)(6636002)(6116002)(11346002)(53546011)(229853002)(61266001)(305945005)(86362001)(7736002)(102836004)(5660300002)(476003)(14444005)(105586002)(256004)(106356001)(97736004)(95326003)(6512007)(8936002)(6506007)(3846002)(25786009)(486006)(446003)(6862004)(386003)(71200400001)(71190400001)(6486002)(68736007)(61726006)(9686003)(6436002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2441;H:CY1PR05MB2780.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xfbDQaUagCU89S642l7xGB7c1DjbglPsPMlUO8o0mAqh/KiX0gT5VESsIC9ipYjUoTgM1uziKgqeWI59ibcufrnqLtA/B6UoZrwXM4a5PWtpv/bjc0a1+L2cjt+Cn9EojVZ6wg+jNobEiAjI4J+KHvJvn0pyzD+6RnhH41K1VUlcLE7qry4FT8qTPe5V73iPjDVvuS5dESgMx55fPeQGnY5sC2G+NGkbFEjbejdM9XO5cnMMN2/pOeudQojk9ysOkRaaAcpB374mstLJGy9ob26Zw7OntUhWXhGzJMJ82aeLJMCE8J8kDOYyodl6jUcIpe5dRlpedQMMnmeLCU+oMwQrlO9HD/9MOJC33nN6ZI5ELPBeui/vR5RlxgUEwh5TvCMZ1ybbU4cgn2ryp0fftj0FE1C38nuOxev4oHcidhc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <582C43A425BE3147A2ABD611036B74E8@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22002284-728c-4f83-36a0-08d6ac88e530
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2019 16:35:28.4219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2441
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCBNYXIgMTksIDIwMTkgYXQgNTo1NiBQTSBUenZldG9taXIgU3RveWFub3YgPHRzdG95
YW5vdkB2bXdhcmUuY29tPiB3cm90ZToNCj4NCj4gSW4gb3JkZXIgdG8gbWF0Y2ggaG9zdCBhbmQg
Z3Vlc3QgZXZlbnRzLCBhIG1hcHBpbmcgYmV0d2VlbiBndWVzdCBWQ1BVDQo+IGFuZCB0aGUgaG9z
dCB0YXNrLCBydW5uaW5nIHRoaXMgVkNQVSBpcyBuZWVkZWQuIEV4dGVuZGVkIGV4aXN0aW5nDQo+
IHN0cnVjdCBndWVzdCB0byBob2xkIHN1Y2ggbWFwcGluZyBhbmQgYWRkZWQgbG9naWMgaW4gcmVh
ZF9xZW11X2d1ZXN0cygpDQo+IGZ1bmN0aW9uIHRvIGluaXRpYWxpemUgaXQuIEltcGxlbWVudGVk
IGEgbmV3IGludGVybmFsIEFQSSwNCj4gZ2V0X2d1ZXN0X3ZjcHVfcGlkKCksIHRvIHJldHJpZXZl
IFZDUFUtdGFzayBtYXBwaW5nIGZvciBnaXZlbiBWTS4NCj4NCj4gU2lnbmVkLW9mZi1ieTogVHp2
ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJlLmNvbT4NCj4gLS0tDQo+ICB0cmFjZWNt
ZC9pbmNsdWRlL3RyYWNlLWxvY2FsLmggfCAgMSArDQo+ICB0cmFjZWNtZC90cmFjZS1yZWNvcmQu
YyAgICAgICAgfCA1NiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICAyIGZp
bGVzIGNoYW5nZWQsIDU3IGluc2VydGlvbnMoKykNCj4NCj4gZGlmZiAtLWdpdCBhL3RyYWNlY21k
L2luY2x1ZGUvdHJhY2UtbG9jYWwuaCBiL3RyYWNlY21kL2luY2x1ZGUvdHJhY2UtbG9jYWwuaA0K
PiBpbmRleCA4NDEzMDU0Li42MmY1ZTQ3IDEwMDY0NA0KPiAtLS0gYS90cmFjZWNtZC9pbmNsdWRl
L3RyYWNlLWxvY2FsLmgNCj4gKysrIGIvdHJhY2VjbWQvaW5jbHVkZS90cmFjZS1sb2NhbC5oDQo+
IEBAIC0yNDUsNiArMjQ1LDcgQEAgaW50IHRyYWNlY21kX2xvY2FsX2NwdV9jb3VudCh2b2lkKTsN
Cj4gIHZvaWQgdHJhY2VjbWRfc2V0X2Nsb2NrKHN0cnVjdCBidWZmZXJfaW5zdGFuY2UgKmluc3Rh
bmNlKTsNCj4gIHZvaWQgdHJhY2VjbWRfcmVtb3ZlX2luc3RhbmNlKHN0cnVjdCBidWZmZXJfaW5z
dGFuY2UgKmluc3RhbmNlKTsNCj4NCj4gK2ludCBnZXRfZ3Vlc3RfdmNwdV9waWQodW5zaWduZWQg
aW50IGd1ZXN0X2NpZCwgdW5zaWduZWQgaW50IGd1ZXN0X3ZjcHUpOw0KPiAgLyogTm8gbG9uZ2Vy
IGluIGV2ZW50LXV0aWxzLmggKi8NCj4gIHZvaWQgX19ub3JldHVybiBkaWUoY29uc3QgY2hhciAq
Zm10LCAuLi4pOyAvKiBDYW4gYmUgb3ZlcnJpZGVuICovDQo+ICB2b2lkICptYWxsb2Nfb3JfZGll
KHVuc2lnbmVkIGludCBzaXplKTsgLyogQ2FuIGJlIG92ZXJyaWRkZW4gKi8NCj4gZGlmZiAtLWdp
dCBhL3RyYWNlY21kL3RyYWNlLXJlY29yZC5jIGIvdHJhY2VjbWQvdHJhY2UtcmVjb3JkLmMNCj4g
aW5kZXggMzk1MDI0Mi4uOGM4ZTQ2ZiAxMDA2NDQNCj4gLS0tIGEvdHJhY2VjbWQvdHJhY2UtcmVj
b3JkLmMNCj4gKysrIGIvdHJhY2VjbWQvdHJhY2UtcmVjb3JkLmMNCj4gQEAgLTI3NDYsMTAgKzI3
NDYsMTIgQEAgc3RhdGljIGJvb2wgaXNfZGlnaXRzKGNvbnN0IGNoYXIgKnMpDQo+ICAgICAgICAg
cmV0dXJuIHRydWU7DQo+ICB9DQo+DQo+ICsjZGVmaW5lIFZDUFVTX01BWCAyNTYNCj4gIHN0cnVj
dCBndWVzdCB7DQo+ICAgICAgICAgY2hhciAqbmFtZTsNCj4gICAgICAgICBpbnQgY2lkOw0KPiAg
ICAgICAgIGludCBwaWQ7DQo+ICsgICAgICAgaW50IGNwdV9waWRbVkNQVVNfTUFYXTsNCj4gIH07
DQo+DQo+ICBzdGF0aWMgc3RydWN0IGd1ZXN0ICpndWVzdHM7DQo+IEBAIC0yNzY3LDYgKzI3Njks
NDUgQEAgc3RhdGljIGNoYXIgKmdldF9xZW11X2d1ZXN0X25hbWUoY2hhciAqYXJnKQ0KPiAgICAg
ICAgIHJldHVybiBhcmc7DQo+ICB9DQo+DQo+ICtzdGF0aWMgdm9pZCByZWFkX3FlbXVfZ3Vlc3Rz
X3BpZHMoY2hhciAqZ3Vlc3RfdGFzaywgc3RydWN0IGd1ZXN0ICpndWVzdCkNCj4gK3sNCj4gKyAg
ICAgICBzdHJ1Y3QgZGlyZW50ICplbnRyeV90Ow0KPiArICAgICAgIGNoYXIgcGF0aFtQQVRIX01B
WF07DQo+ICsgICAgICAgdW5zaWduZWQgaW50IHZjcHU7DQoNCk1heWJlIGtlZXAgdmNwdSBzaWdu
ZWQgaW50IHRvIGF2b2lkIGltcGxpY2l0IGNvbnZlcnNpb24gZnJvbSBhc3NpZ25pbmcNCnRoZSBy
ZXN1bHQgb2YgYXRvaSgpPyBXZSBjaGVjayBpZiBpdCdzIG5lZ2F0aXZlIHJpZ2h0IGFmdGVyIHRo
aXMuDQoNCj4gKyAgICAgICBjaGFyICpidWYgPSBOVUxMOw0KPiArICAgICAgIERJUiAqZGlyOw0K
PiArICAgICAgIEZJTEUgKmZ0Ow0KPiArICAgICAgIHNpemVfdCBuOw0KDQpJbml0aWFsaXplIG4g
dG8gemVybyBiZWZvcmUgcGFzc2luZyBpdCB0byBnZXRsaW5lKCkuIE9UT0ggYm90aCBnbGliYw0K
YW5kIG11c2wgaGFuZGxlIGdldGRlbGltKCkvZ2V0bGluZSgpIGNvcnJlY3RseSB3aGVuIHRoZSBm
aXJzdCBhcmd1bWVudA0KaXMgTlVMTCwgZGlzcmVnYXJkaW5nIHRoZSBzZWNvbmQuIEkgc3RpbGwg
dGhpbmsgaXQncyBjbGVhcmVyIGlmIG4gZ2V0cw0KaW5pdGlhbGl6ZWQuDQoNCj4gKw0KPiArICAg
ICAgIHNucHJpbnRmKHBhdGgsIHNpemVvZihwYXRoKSwgIi9wcm9jLyVzL3Rhc2siLCBndWVzdF90
YXNrKTsNCj4gKyAgICAgICBkaXIgPSBvcGVuZGlyKHBhdGgpOw0KPiArICAgICAgIGlmICghZGly
KQ0KPiArICAgICAgICAgICAgICAgcmV0dXJuOw0KPiArDQo+ICsgICAgICAgZm9yIChlbnRyeV90
ID0gcmVhZGRpcihkaXIpOyBlbnRyeV90OyBlbnRyeV90ID0gcmVhZGRpcihkaXIpKSB7DQoNCk5p
dDogIGB3aGlsZSAoKGVudHJ5ID0gcmVhZGRpcihkaXIpKSkge2AgaXMgbW9yZSBjb21tb24gdGhy
b3VnaG91dCB0aGUgY29kZS4NCg0KPiArICAgICAgICAgICAgICAgaWYgKCEoZW50cnlfdC0+ZF90
eXBlID09IERUX0RJUiAmJiBpc19kaWdpdHMoZW50cnlfdC0+ZF9uYW1lKSkpDQo+ICsgICAgICAg
ICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KPiArDQo+ICsgICAgICAgICAgICAgICBzbnByaW50
ZihwYXRoLCBzaXplb2YocGF0aCksICIvcHJvYy8lcy90YXNrLyVzL2NvbW0iLA0KPiArICAgICAg
ICAgICAgICAgICAgICAgICAgZ3Vlc3RfdGFzaywgZW50cnlfdC0+ZF9uYW1lKTsNCj4gKyAgICAg
ICAgICAgICAgIGZ0ID0gZm9wZW4ocGF0aCwgInIiKTsNCj4gKyAgICAgICAgICAgICAgIGlmICgh
ZnQpDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KPiArICAgICAgICAgICAg
ICAgaWYgKGdldGxpbmUoJmJ1ZiwgJm4sIGZ0KSA8IDApDQo+ICsgICAgICAgICAgICAgICAgICAg
ICAgIGdvdG8gbmV4dDsNCj4gKyAgICAgICAgICAgICAgIGlmIChzdHJuY21wKGJ1ZiwgIkNQVSAi
LCA0KSAhPSAwKQ0KPiArICAgICAgICAgICAgICAgICAgICAgICBnb3RvIG5leHQ7DQo+ICsNCj4g
KyAgICAgICAgICAgICAgIHZjcHUgPSBhdG9pKGJ1Zis0KTsNCj4gKyAgICAgICAgICAgICAgIGlm
ICghKHZjcHUgPj0gMCAmJiB2Y3B1IDwgVkNQVVNfTUFYKSkNCj4gKyAgICAgICAgICAgICAgICAg
ICAgICAgZ290byBuZXh0Ow0KPiArICAgICAgICAgICAgICAgZ3Vlc3QtPmNwdV9waWRbdmNwdV0g
PSBhdG9pKGVudHJ5X3QtPmRfbmFtZSk7DQo+ICsNCj4gK25leHQ6DQo+ICsgICAgICAgICAgICAg
ICBmY2xvc2UoZnQpOw0KPiArICAgICAgIH0NCg0KYGJ1ZmAgbmVlZHMgdG8gZ2V0IGZyZWUoKS1l
ZCBhZnRlciB0aGUgbG9vcCBlbmRzLg0KDQo+ICt9DQo+ICsNCj4gIHN0YXRpYyB2b2lkIHJlYWRf
cWVtdV9ndWVzdHModm9pZCkNCj4gIHsNCj4gICAgICAgICBzdGF0aWMgYm9vbCBpbml0aWFsaXpl
ZDsNCj4gQEAgLTI4MjgsNiArMjg2OSw4IEBAIHN0YXRpYyB2b2lkIHJlYWRfcWVtdV9ndWVzdHMo
dm9pZCkNCj4gICAgICAgICAgICAgICAgIGlmICghaXNfcWVtdSkNCj4gICAgICAgICAgICAgICAg
ICAgICAgICAgZ290byBuZXh0Ow0KPg0KPiArICAgICAgICAgICAgICAgcmVhZF9xZW11X2d1ZXN0
c19waWRzKGVudHJ5LT5kX25hbWUsICZndWVzdCk7DQo+ICsNCj4gICAgICAgICAgICAgICAgIGd1
ZXN0cyA9IHJlYWxsb2MoZ3Vlc3RzLCAoZ3Vlc3RzX2xlbiArIDEpICogc2l6ZW9mKCpndWVzdHMp
KTsNCj4gICAgICAgICAgICAgICAgIGlmICghZ3Vlc3RzKQ0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICBkaWUoIkNhbiBub3QgYWxsb2NhdGUgZ3Vlc3QgYnVmZmVyIik7DQo+IEBAIC0yODczLDYg
KzI5MTYsMTkgQEAgc3RhdGljIGNoYXIgKnBhcnNlX2d1ZXN0X25hbWUoY2hhciAqZ3Vlc3QsIGlu
dCAqY2lkLCBpbnQgKnBvcnQpDQo+ICAgICAgICAgcmV0dXJuIGd1ZXN0Ow0KPiAgfQ0KPg0KPiAr
aW50IGdldF9ndWVzdF92Y3B1X3BpZCh1bnNpZ25lZCBpbnQgZ3Vlc3RfY2lkLCB1bnNpZ25lZCBp
bnQgZ3Vlc3RfdmNwdSkNCj4gK3sNCj4gKyAgICAgICBpbnQgaTsNCj4gKw0KPiArICAgICAgIGlm
ICghZ3Vlc3RzIHx8IGd1ZXN0X3ZjcHUgPj0gVkNQVVNfTUFYKQ0KPiArICAgICAgICAgICAgICAg
cmV0dXJuIC0xOw0KPiArDQo+ICsgICAgICAgZm9yIChpID0gMDsgaSA8IGd1ZXN0c19sZW47IGkr
KykNCj4gKyAgICAgICAgICAgICAgIGlmIChndWVzdF9jaWQgPT0gZ3Vlc3RzW2ldLmNpZCkNCj4g
KyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIGd1ZXN0c1tpXS5jcHVfcGlkW2d1ZXN0X3Zj
cHVdOw0KPiArICAgICAgIHJldHVybiAtMTsNCj4gK30NCj4gKw0KPiAgc3RhdGljIHZvaWQgc2V0
X3ByaW8oaW50IHByaW8pDQo+ICB7DQo+ICAgICAgICAgc3RydWN0IHNjaGVkX3BhcmFtIHNwOw0K
PiAtLQ0KPiAyLjIwLjENCj4NCg==
