Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E0AC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 13:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6394120684
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 13:11:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="V5kB6/vL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfDONLy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 09:11:54 -0400
Received: from mail-eopbgr810041.outbound.protection.outlook.com ([40.107.81.41]:14368
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726785AbfDONLx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 09:11:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2hjk88ysJOZ9CtqErKPM+jHlmqCf9CEtdSpb3M4S7c=;
 b=V5kB6/vLqAc7Io8kVYO9mH6FfWDt4cgkejKfPArBHYoSeK9PW/0TrETgNilQLUwoHiXoKySsTCa++qY45gjIfZ6ZqPB0kquqp2vABIzNCnyp8TuwDD0kjpBf/lxV31ppLS1Ca23bSjQHeY810HJLaHg8xUuS5m4gpseMUKfC9uo=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3769.namprd05.prod.outlook.com (10.167.163.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.9; Mon, 15 Apr 2019 13:11:50 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::3949:85c0:3b7b:136e]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::3949:85c0:3b7b:136e%5]) with mapi id 15.20.1813.009; Mon, 15 Apr 2019
 13:11:50 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     "y.karadz@gmail.com" <y.karadz@gmail.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Thread-Topic: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Thread-Index: AQHU7h2WcCXQDyjBs0OQUMjYOKqD5aYzwfgAgAAQu4CAABrHgIAAAywAgAAJaACACSAaAIAAIy0A
Date:   Mon, 15 Apr 2019 13:11:50 +0000
Message-ID: <2dc82f7955ca15cfe906ef98eb6980bdd14067e0.camel@vmware.com>
References: <20190404145603.13592-1-ykaradzhov@vmware.com>
         <20190404145603.13592-2-ykaradzhov@vmware.com> <20190408150102.GA6430@box>
         <20190408111308.301f30c1@gandalf.local.home>
         <0808d774-880a-f232-dda3-cd897120d86d@gmail.com>
         <20190409092349.3e7cb6e3@gandalf.local.home>
         <CAE0o1NtOBbVGjHfYyqOhrCrmywSNjYWOprDU66uMTPx4hX4UGA@mail.gmail.com>
         <20190409111100.28297adb@gandalf.local.home>
         <CAE0o1Nv_JgHpTHgwpLhw7dkyxqW_u-rRUBMojgzPENCwVUDbmg@mail.gmail.com>
         <edebede3-e508-022e-5d71-13226cd2df58@gmail.com>
In-Reply-To: <edebede3-e508-022e-5d71-13226cd2df58@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-originating-ip: [151.251.250.145]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f72d2034-b2c1-450f-22d1-08d6c1a3ec5c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600140)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR0501MB3769;
x-ms-traffictypediagnostic: MWHPR0501MB3769:
x-microsoft-antispam-prvs: <MWHPR0501MB37690786C55300DD57D52B3EDA2B0@MWHPR0501MB3769.namprd05.prod.outlook.com>
x-forefront-prvs: 000800954F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(86362001)(486006)(5660300002)(2906002)(6436002)(6486002)(6116002)(97736004)(256004)(229853002)(3846002)(478600001)(53936002)(316002)(93886005)(102836004)(4326008)(26005)(25786009)(6246003)(6512007)(71190400001)(14454004)(305945005)(71200400001)(7736002)(76176011)(68736007)(105586002)(8936002)(11346002)(110136005)(476003)(2616005)(66066001)(81156014)(8676002)(54906003)(446003)(118296001)(186003)(2501003)(99286004)(36756003)(106356001)(6506007)(81166006)(228453006);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3769;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2UF+QkQDBQ86ltNPQEizTGTCjzV8BiB1ES2ocWkmsvpXWXyy6x1WkOYm9s6XY9sKQIhkZOCQLNRHuHEqXZWEGMJD0WruYGf+8LR09xuGvIcnU3nXeKCUQ6OjSyLMmsz71gpWxnSzpjsyrILPJ6OTBf8tA74NAP4IbscGQuLv9qdlwJVobcwm8yasNhz07FtIU/a4H/b46OCa1e6Jj5otvdkefXnJ01ASREKM1s0jnTOnwFRrDj/8OefYLjYAxAlx06gEIGNVmtZhnKTY9aaDnqXjVXReI98KTM9grhAdu0uZNySqJBXudkiR2h3y8DItBU+EBdve1vyLvWEDVa+aBJbY9g83gcgjDxz7x9IRJMAq6NuWchHGtPBee/viLd8RiZoY4LF4Z4UBZ4T+9+sEfKG120bgmWe7224UDYta934=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D95FF8BD998D4498C775E960393238B@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f72d2034-b2c1-450f-22d1-08d6c1a3ec5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2019 13:11:50.6373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3769
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gTW9uLCAyMDE5LTA0LTE1IGF0IDE0OjA1ICswMzAwLCBZb3JkYW4gS2FyYWR6aG92IChWTXdh
cmUpIHdyb3RlOg0KPiANCj4gT24gOS4wNC4xOSDQsy4gMTg6NDQg0YcuLCBTbGF2b21pciBLYXNs
ZXYgd3JvdGU6DQo+ID4gVGhlIHByb2JsZW0gaXMgdGhlIHdheSB0aGV5IGFyZSBkZWZpbmVkIGF0
bToNCj4gPiANCj4gPiAjIEZpcnN0IHNlYXJjaCBpbiB0aGUgdXNlciBwcm92aWRlZCBwYXRocy4N
Cj4gPiBmaW5kX3BhdGgoVFJBQ0VDTURfQklOX0RJUiAgICAgIE5BTUVTICB0cmFjZS1jbWQNCj4g
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBQQVRIUyAgJEVOVntUUkFDRV9DTUR9
L3RyYWNlY21kLw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAk
e0NNQUtFX1NPVVJDRV9ESVJ9Ly4uL3RyYWMNCj4gPiBlY21kLw0KPiA+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIE5PX0RFRkFVTFRfUEFUSCkNCj4gPiANCj4gPiBUaGlzIHdpbGwg
bmV2ZXIgZXZhbHVhdGUgdG8gL3Vzci9iaW4gd2hpY2ggaXMgd2hhdCBpdCBzaG91bGQgYmUgZm9y
DQo+ID4gZGlzdHJvIGJ1aWxkcy4NCj4gDQo+IEkgdGhpbmsgdGhlcmUgaXMgYSBiaXQgb2YgY29u
ZnVzaW9uIGhlcmUuIFRoZSBjb2RlIGFib3ZlIHdpbGwgbmV2ZXIgDQo+IHNlYXJjaCBpbiAvdXNy
L2Jpbi4gVGhpcyBzdGF0ZW1lbnQgaXMgY29ycmVjdC4NCj4gDQo+IEhvd2V2ZXIgaWYgdGhpcyBz
ZWFyY2ggZmFpbHMgd2Ugd2lsbCBwZXJmb3JtIGFub3RoZXIgc2VhcmNoIHRoYXQNCj4gd2lsbCAN
Cj4gdGhpcyB0aW1lIHNlYXJjaCBpbiAvdXNyL2Jpbi4gTG9vayBmZXcgbGluZXMgYmVsb3cNCj4g
aW4gIEZpbmRUcmFjZUNtZC5jbWFrZS4NCg0KQWgsIEkgbWlzc2VkIHRoYXQuDQoNCj4gDQo+IFRo
ZSByZWFzb24gZm9yIHRoaXMgaXMgdG8gYXZvaWQgY29uZnVzaW9uIGluIHRoZSBjYXNlIHdoZW4g
dGhlIHVzZXINCj4gaGFzIA0KPiB0aGUgZGlzdHJvIHBhY2thZ2UgaW5zdGFsbGVkLCBidXQgaW4g
dGhlIHNhbWUgdGltZSBpcyB0cnlpbmcgdG8NCj4gYnVpbGQgDQo+IEtlcm5lbFNoYXJrIGZyb20g
c291cmNlLiBXZSB3YW50IGluIHRoaXMgY2FzZSB0aGUgR1VJIHRvIGxpbmsgd2l0aA0KPiB0aGUg
DQo+IHZlcnNpb24gb2YgdGhlIHRyYWNlLWNtZCBsaWJyYXJ5IHRoYXQgaXMgYmVpbmcgYnVpbGQg
KG5vdCB0aGUgb25lDQo+IGZyb20gDQo+IHRoZSBwYWNrYWdlKS4NCg0KU28gaG93IHNob3VsZCBJ
IGJ1aWxkIGtlcm5lbHNoYXJrIGFmdGVyIGEgY2xlYW4gZ2l0IGNsb25lIGZvciBhIGRpc3Rybw0K
YnVpbGQ/IEluIHBhcnRpY3VsYXIsIHdoYXQgc2VxdWVuY2Ugb2YgY29tbWFuZHMgZG8gSSBuZWVk
IHRvIHJ1biBzbw0KdGhhdCBJIGdldCBmdWxseSBidWlsZCBrZXJuZWxzaGFyayB3aXRoIGFsbCBj
b25zdGFudHMgcG9pbnRpbmcgdG8gdGhlDQpjb3JyZWN0IHBsYWNlcyAoc2F5IFRSQUNFQ01EX0JJ
Tl9ESVIgPSAvdXNyL2JpbikuIElmIHRoaXMgaXMgbm90DQpzdXBwb3JldGVkIHlldCAoYW5kIEkg
dGhpbmsgaXQncyBub3QgYXRtKSwgd2Ugc2hvdWxkIGF0IGxlYXN0IGhhdmUgYQ0KcGxhbiBob3cg
d2Ugd2FudCB0byBnbyBhYm91dCBkb2luZyBpdC4gQSBzY3JpcHQgZG9pbmcgc29tZXRoaW5nIGlz
DQphbHdheXMgYmV0dGVyIHRoYXQgZG9jdW1lbnRpbmcgaG93IHRvIGFjaGlldmUgdGhlIHNhbWUu
DQoNCi0tIFNsYXZpDQoNCj4gDQo+IFRoYW5rcyENCj4gWW9yZGFuDQo+IA0KPiANCg==
