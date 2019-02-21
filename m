Return-Path: <SRS0=APAm=Q4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9805C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Feb 2019 16:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C75F2083B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Feb 2019 16:39:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="cG0d7UTw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbfBUQjM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:39:12 -0500
Received: from mail-eopbgr790041.outbound.protection.outlook.com ([40.107.79.41]:53856
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727484AbfBUQjL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Feb 2019 11:39:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFnWb9joxjK/P0oTbV95GYjp3APLog+ECd5PkBDFzKE=;
 b=cG0d7UTwTPhqvaf+Qi1lJ5M78JOW+vK7XlwwUY5BISbG+M0Fk41/irfXeojsRkCUXFvj6WJxqaAASJ3KCbZliNse0Hubvrf4YkPc8vga1UTXciOwyKnA5wBgScBYHgUwzycnt5U7QZEyBWebRf9/IU4hLf9Toobycur+TG4BSb0=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3917.namprd05.prod.outlook.com (10.167.151.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.5; Thu, 21 Feb 2019 16:38:29 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::9c6c:db1c:e297:7b13]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::9c6c:db1c:e297:7b13%3]) with mapi id 15.20.1643.008; Thu, 21 Feb 2019
 16:38:29 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     Slavomir Kaslev <kaslevs@vmware.com>
CC:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 3/3] kernel-shark: Fix a bug in
 ksmodel_set_next_bin_edge()
Thread-Topic: [PATCH 3/3] kernel-shark: Fix a bug in
 ksmodel_set_next_bin_edge()
Thread-Index: AQHUyeLnFh7zgF3szkqjy355HcisWqXqbZAAgAAGYIA=
Date:   Thu, 21 Feb 2019 16:38:29 +0000
Message-ID: <793ef231-43fc-d00f-8681-6212cf021e7f@vmware.com>
References: <20190221124205.21115-1-ykaradzhov@vmware.com>
 <20190221124205.21115-4-ykaradzhov@vmware.com> <20190221161530.GA16009@box>
In-Reply-To: <20190221161530.GA16009@box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DB7PR03CA0108.eurprd03.prod.outlook.com
 (2603:10a6:10:72::49) To SN4PR0501MB3903.namprd05.prod.outlook.com
 (2603:10b6:803:4d::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5869b1a6-ad66-4c19-dc91-08d6981b021a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:SN4PR0501MB3917;
x-ms-traffictypediagnostic: SN4PR0501MB3917:
x-microsoft-exchange-diagnostics: 1;SN4PR0501MB3917;20:1U56b1konTd9djN5/DtR+71fg/ukdct1LWwLgJm0zLqQAu2/6/zhSZ0GkuBzdri9hfVSZJL8mOkyBQhXT0THp9u5xoszGJdwm+twMc9dB/BTkZxrqQmqOOkGDJt+vKT0mennooFoYA0FrYXPfnByrg6ZK6uqPZX/nqGBjVuNviY=
x-microsoft-antispam-prvs: <SN4PR0501MB391700FCF476315E33AF1BD5A07E0@SN4PR0501MB3917.namprd05.prod.outlook.com>
x-forefront-prvs: 09555FB1AD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(376002)(39860400002)(136003)(396003)(199004)(189003)(51914003)(3846002)(6116002)(229853002)(6486002)(25786009)(5660300002)(105586002)(6436002)(106356001)(6506007)(36756003)(386003)(26005)(6512007)(11346002)(97736004)(2616005)(186003)(102836004)(31696002)(4326008)(476003)(6862004)(6246003)(86362001)(71190400001)(53936002)(486006)(446003)(71200400001)(31686004)(14454004)(37006003)(14444005)(81156014)(81166006)(8676002)(54906003)(2906002)(316002)(66066001)(99286004)(6636002)(68736007)(52116002)(256004)(7736002)(76176011)(8936002)(478600001)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3917;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WemFIjhZclGZ2yZmS1VMES2v3imwng9KrGhQeUF5uAJbdrjK6kZ0Wnwj5xXcDdtV0oSoCPpOImPKCjPuFlbvODzu5LJFdm7ETLx0VKg+j3TnYiLPlN9vm/wXhLt4C1O1QUc30AkHyhsO6QulntkpyYKZpbbBIXKJpmw0MHhfZF7bjhAC7vylBVlgyOil+ROgcl5M1zaV2onffFWS6/8ykHwW1Wdhi03k8QKPOvX5/PUbTCuzxF8JPT0ZnBfKkAIWzKulHht2yfpQPmHPvOYtyOGe78Zhttcw1MFoBvkIIA/v2XE+bZApx1SRNpmSN3ukw1z2Skz9dQIZTqIrT94Ac8KAACdPLX1vAuBHrNHigYEOFviWRsYuQNt+aMKt1NFgqUaMb896016AGPYoN6fESxJ8chCplOAYXMK8P/nVmmY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <56D86EF3462E3141A737EA8D4032AC3A@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5869b1a6-ad66-4c19-dc91-08d6981b021a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2019 16:38:27.8472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3917
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQoNCk9uIDIxLjAyLjE5INCzLiAxODoxNSDRhy4sIFNsYXZvbWlyIEthc2xldiB3cm90ZToNCj4g
T24gVGh1LCBGZWIgMjEsIDIwMTkgYXQgMDI6NDI6MDVQTSArMDIwMCwgWW9yZGFuIEthcmFkemhv
diB3cm90ZToNCj4+IFRoZSBtb2RpZmljYXRpb24gb2YgdGhlIGxhc3QgYmluIG9mIHRoZSBtb2Rl
bCBtYWtlcyBubyBzZW5zZSAodGhpcyBpcw0KPj4gbXkgbWlzdGFrZSkuIFRoZSBjb21tZW50IGFi
b3ZlIHRoZSBjb2RlIHRoYXQgaXMgZG9pbmcgdGhpcyBtb2RpZmljYXRpb24NCj4+IGlzIHBhcnRp
YWxseSBjb3JyZWN0LCBob3dldmVyIGl0IHNwZWFrcyBhYm91dCBpbmNyZWFzaW5nIHRoZSBzaXpl
IG9mDQo+PiB0aGUgbGFzdCBiaW4sIHdoaWxlIHRoZSBjb2RlIGJlbG93IHRoZSBjb21tZW50IGNo
YW5nZXMgdGhlIGxvd2VyIGVkZ2UNCj4+IG9mIHRoaXMgYmluLiBUaGUgYWN0dWFsIGluY3JlYXNl
IG9mIHRoZSBzaXplIG9mIHRoZSBsYXN0IGJpbiBpcyBkb25lIGluDQo+PiBrc21vZGVsX3NldF91
cHBlcl9lZGdlKCkgd2hlcmUgdGhlIGxvd2VyIGVkZ2Ugb2YgdGhlIFVwcGVyIE92ZXJmbG93IGJp
bg0KPj4gZ2V0cyBzaGlmdGVkIChtYXggKyAxKS4gVGhpcyBlZmZlY3RpdmVseSBpbmNyZWFzZXMg
dGhlIHNpemUgb2YgdGhlIGxhc3QgYmluLg0KPj4NCj4+IFJlcG9ydGVkLWJ5OiBUenZldG9taXIg
U3RveWFub3YgPHRzdG95YW5vdkB2bXdhcmUuY29tPg0KPj4gRml4ZXM6IGY5N2UzMWYwMCAoImtl
cm5lbC1zaGFyay1xdDogSW50cm9kdWNlIHRoZSB2aXN1YWxpemF0aW9uIG1vZGVsIC4uIikNCj4+
IFNpZ25lZC1vZmYtYnk6IFlvcmRhbiBLYXJhZHpob3YgPHlrYXJhZHpob3ZAdm13YXJlLmNvbT4N
Cj4+IC0tLQ0KPj4gICBrZXJuZWwtc2hhcmsvc3JjL2xpYmtzaGFyay1tb2RlbC5jIHwgOSAtLS0t
LS0tLS0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDkgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAt
LWdpdCBhL2tlcm5lbC1zaGFyay9zcmMvbGlia3NoYXJrLW1vZGVsLmMgYi9rZXJuZWwtc2hhcmsv
c3JjL2xpYmtzaGFyay1tb2RlbC5jDQo+PiBpbmRleCBiNmQzNjEyLi40YmQxZTJjIDEwMDY0NA0K
Pj4gLS0tIGEva2VybmVsLXNoYXJrL3NyYy9saWJrc2hhcmstbW9kZWwuYw0KPj4gKysrIGIva2Vy
bmVsLXNoYXJrL3NyYy9saWJrc2hhcmstbW9kZWwuYw0KPj4gQEAgLTI2NiwxNSArMjY2LDYgQEAg
c3RhdGljIHZvaWQga3Ntb2RlbF9zZXRfbmV4dF9iaW5fZWRnZShzdHJ1Y3Qga3NoYXJrX3RyYWNl
X2hpc3RvICpoaXN0bywNCj4+ICAgCS8qIENhbGN1bGF0ZSB0aGUgYmVnaW5uaW5nIG9mIHRoZSBu
ZXh0IGJpbi4gKi8NCj4+ICAgCXRpbWUgPSBoaXN0by0+bWluICsgbmV4dF9iaW4gKiBoaXN0by0+
YmluX3NpemU7DQo+PiAgIA0KPj4gLQkvKg0KPj4gLQkgKiBUaGUgdGltZXN0YW1wIG9mIHRoZSB2
ZXJ5IGxhc3QgZW50cnkgb2YgdGhlIGRhdGFzZXQgY2FuIGJlIGV4YWN0bHkNCj4+IC0JICogZXF1
YWwgdG8gdGhlIHZhbHVlIG9mIHRoZSB1cHBlciBlZGdlIG9mIHRoZSByYW5nZS4gVGhpcyBpcyB2
ZXJ5DQo+PiAtCSAqIGxpa2VseSB0byBoYXBwZW4gd2hlbiB3ZSB1c2Uga3Ntb2RlbF9zZXRfaW5f
cmFuZ2VfYmluaW5nKCkuIEluIHRoaXMNCj4+IC0JICogY2FzZSB3ZSBoYXZlIHRvIGluY3JlYXNl
IHRoZSBzaXplIG9mIHRoZSB2ZXJ5IGxhc3QgYmluIGluIG9yZGVyIHRvDQo+PiAtCSAqIG1ha2Ug
c3VyZSB0aGF0IHRoZSBsYXN0IGVudHJ5IG9mIHRoZSBkYXRhc2V0IHdpbGwgZmFsbCBpbnRvIGl0
Lg0KPj4gLQkgKi8NCj4+IC0JaWYgKG5leHRfYmluID09IGhpc3RvLT5uX2JpbnMgLSAxKQ0KPj4g
LQkJKyt0aW1lOw0KPj4gICAJLyoNCj4+ICAgCSAqIEZpbmQgdGhlIGluZGV4IG9mIHRoZSBmaXJz
dCBlbnRyeSBpbnNpZGUNCj4+ICAgCSAqIHRoZSBuZXh0IGJpbiAodGltZXN0YW1wID4gdGltZSku
DQo+PiAtLSANCj4+IDIuMTcuMQ0KPj4NCj4gDQo+IFBhdGNoZXMgMSwgMiBhbmQgMyBsb29rIGdv
b2QgdG8gbWUuDQo+IA0KPiBBY2tlZC1ieTogU2xhdm9taXIgS2FzbGV2IDxrYXNsZXZzQHZtd2Fy
ZS5jb20+DQo+IA0KPiBTaWRlIG5vdGU6IGtzbW9kZWxfc2hpZnRfYmFja3dhcmQva3Ntb2RlbF9z
aGlmdF9mb3J3YXJkIGxvb2sgcHJldHR5IHNpbWlsYXIuIENhbg0KPiB0aGV5IGJlIGdlbmVyYWxp
emVkIHRvIGFuIGVpdGhlci1kaXJlY3Rpb25hbCBrc21vZGVsX3NoaWZ0IHRha2luZyB0aGUgc2hp
ZnQNCj4gcGFyYW1ldGVyIGFzIHNpZ25lZD8gSWYga3Ntb2RlbF9zaGlmdF9iYWNrd2FyZC9rc21v
ZGVsX3NoaWZ0X2ZvcndhcmQgbmVlZCB0byBiZQ0KPiBrZXB0IGZvciBiYWNrd2FyZCBjb21wYXRp
YmlsaXR5LCB0aGV5IGNhbiBjYWxsIGtzbW9kZWxfc2hpZnQgKHdpdGggYSBmbGlwcGVkDQo+IHNp
Z24gaW4gdGhlIGJhY2t3YXJkIGNhc2UpLg0KPiANClRoYW5rcyBmb3IgdGhlIGNvbW1lbnQhDQpZ
b3UgYXJlIHJpZ2h0LiBJIHRoaW5rIHRoaXMgY2FuIGJlIGRvbmUsIGJ1dCBpbiBhIHNlcGFyYXRl
IHBhdGNoLg0KDQpZb3JkYW4NCg0KDQo+IFRoYW5rIHlvdSwNCj4gDQo+IC0tIFNsYXZpDQo+IA0K
