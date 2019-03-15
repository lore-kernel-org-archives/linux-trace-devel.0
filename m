Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BECEC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 06:20:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4192721872
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 06:20:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="fWQ7EbCH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbfCOGUL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 02:20:11 -0400
Received: from mail-eopbgr790078.outbound.protection.outlook.com ([40.107.79.78]:35920
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728266AbfCOGUL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 02:20:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnJ2Aim7m6fnYedz7IWNI2YD2GFX9IG5ZkBh+LJE/jg=;
 b=fWQ7EbCHCzc8k3cxeJAi7TB7k+6ZnUAT9GODIo3dH2jhytlLzfa0nApwU8TrcjzVQIeJzOVnGIPh05a8LtPpjHJD7Only85z14qo104mkA48LWUhmIu37MfC2beyg1cFM7t6HdPEQJBH37bnbjCSj5aJR2iDK57WeIG5Bc2J8d8=
Received: from DM5PR0501MB3893.namprd05.prod.outlook.com (10.167.108.32) by
 DM5PR0501MB3895.namprd05.prod.outlook.com (10.167.108.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.10; Fri, 15 Mar 2019 06:20:08 +0000
Received: from DM5PR0501MB3893.namprd05.prod.outlook.com
 ([fe80::e54a:7d5:311:61eb]) by DM5PR0501MB3893.namprd05.prod.outlook.com
 ([fe80::e54a:7d5:311:61eb%5]) with mapi id 15.20.1709.011; Fri, 15 Mar 2019
 06:20:08 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 6/6] kernel-shark-qt: Fix bug in plugin actions
 execution
Thread-Topic: [PATCH v2 6/6] kernel-shark-qt: Fix bug in plugin actions
 execution
Thread-Index: AQHUqDvJSnYFhv+hBEm6/MBJ0Nv4RKYMM/EAgAABPICAAGiWgA==
Date:   Fri, 15 Mar 2019 06:20:08 +0000
Message-ID: <6b2a660a-8e48-805f-851e-8593189e00dc@vmware.com>
References: <20190109130945.28519-1-ykaradzhov@vmware.com>
 <20190109130945.28519-7-ykaradzhov@vmware.com>
 <20190109115253.70c0bc18@gandalf.local.home>
 <20190314200114.4c5abf5b@gandalf.local.home>
 <20190314200539.7bfd90e2@gandalf.local.home>
In-Reply-To: <20190314200539.7bfd90e2@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR0101CA0050.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::18) To DM5PR0501MB3893.namprd05.prod.outlook.com
 (2603:10b6:4:7b::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a98560da-696c-4700-6137-08d6a90e4557
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:DM5PR0501MB3895;
x-ms-traffictypediagnostic: DM5PR0501MB3895:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM5PR0501MB3895CEEE1A0F8407C1A20026A0440@DM5PR0501MB3895.namprd05.prod.outlook.com>
x-forefront-prvs: 09778E995A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(346002)(366004)(136003)(376002)(199004)(189003)(54534003)(256004)(66066001)(486006)(229853002)(8936002)(93886005)(4326008)(105586002)(68736007)(8676002)(106356001)(81156014)(186003)(31686004)(6246003)(11346002)(478600001)(476003)(2616005)(25786009)(7736002)(305945005)(446003)(97736004)(966005)(386003)(6506007)(5660300002)(52116002)(81166006)(76176011)(36756003)(99286004)(102836004)(6916009)(6512007)(6306002)(316002)(31696002)(53936002)(3846002)(6116002)(6486002)(6436002)(14454004)(26005)(86362001)(2906002)(71190400001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR0501MB3895;H:DM5PR0501MB3893.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vGb/QICB3PmL8gpumLPVAY7tzsfwN5sVKbI0ViP3PfJvAeVRWb2ezOGHrt6s/D42TrcsCHuApmhM84mGeUbsBiiDyk7DGrG7BmdcWnYeRNfdxh7u5hM3dJsKZ4JSklBFY0iocMyPn6Q3b1vrqfMg02YLIhZrimNl3ygUrY4gYPAjcTFHQrQ9jgYyNJ5vh223M2LG9IEIojbNsaoDomnfB9touVs9gDpmsunTczvWpcH0MY39RJtbHp9CqdDnnyZWNxW7oWuZVN170BZAsJuoax6tOxDRvW7HtfKpaib8jaebRR4XJy011clPbWsL/3SAkBy+fRy2D7OEHkDalniEdAQVTVQvOWRERtegieMpyPYJG++o6kGffegv7U4Jap+VB6RMGi9qJgFmwKRL4Ev6v89ewprDdzRGrQZ1TniWLV0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BD0E0227AFC9C499A103751008C56D8@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a98560da-696c-4700-6137-08d6a90e4557
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2019 06:20:08.2237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0501MB3895
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQoNCk9uIDE1LjAzLjE5INCzLiAyOjA1INGHLiwgU3RldmVuIFJvc3RlZHQgd3JvdGU6DQo+IE9u
IFRodSwgMTQgTWFyIDIwMTkgMjA6MDE6MTQgLTA0MDANCj4gU3RldmVuIFJvc3RlZHQgPHJvc3Rl
ZHRAZ29vZG1pcy5vcmc+IHdyb3RlOg0KPiANCj4+IFBpbmc/DQo+IA0KPiBBY3R1YWxseSB0aGlz
IGlzIG1hcmtlZCBhcyBzdXBlcnNlZGVkIGluIHBhdGNod29yay4gSXMgaXQ/DQo+IA0KDQpJIHRo
aW5rIHRoaXMgb25lIHdhcyBiZWVuIHB1c2hlZA0KDQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vdXRpbHMvdHJhY2UtY21kL3RyYWNlLWNtZC5naXQvY29tbWl0Lz9pZD1mYmJhNmE5NTUz
M2RiMGQ0MmU2ZTlhOTI0MWZkYTM2MTZiOGYwM2EwDQoNClRoYW5rcyENCllvcmRhbg0KDQoNCj4g
LS0gU3RldmUNCj4gDQo+Pg0KPj4gT24gV2VkLCA5IEphbiAyMDE5IDExOjUyOjUzIC0wNTAwDQo+
PiBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBnb29kbWlzLm9yZz4gd3JvdGU6DQo+Pg0KPj4+IE9u
IFdlZCwgIDkgSmFuIDIwMTkgMTU6MDk6NDUgKzAyMDANCj4+PiBZb3JkYW4gS2FyYWR6aG92IDx5
a2FyYWR6aG92QHZtd2FyZS5jb20+IHdyb3RlOg0KPj4+ICAgIA0KPj4+PiBQbHVnaW4tcHJvdmlk
ZWQgYWN0aW9ucyBhcmUgZXhlY3V0ZWQgd2hlbiBsb2FkaW5nIHRoZSBkYXRhLiBUaGVzZQ0KPj4+
PiBhY3Rpb25zIGNhbiBiZSB1c2VkIHRvIG1vZGlmeSB0aGUgY29udGFpbiBvZiB0aGUga3NoYXJr
X2VudHJpZXMNCj4+Pg0KPj4+ICJtb2RpZnkgdGhlIGNvbnRhaW4gb2YiID8NCj4+PiAgICANCj4+
Pj4gZ2VuZXJhdGVkIGJ5IGEgZ2l2ZW4gZXZlbnQgdHlwZSBhbmQgd2UgY29uc2lkZXIgdGhlIGNh
c2Ugb2YgaGF2aW5nDQo+Pj4+IG1vcmUgdGhhbiBvbmUgcGx1Z2luLXByb3ZpZGVkIGFjdGlvbnMg
cGVyIGV2ZW50IHR5cGUuIEhvd2V2ZXIsIHRoZSBjb2RlDQo+Pj4NCj4+PiAgICJtb3JlIHRoYW4g
b25lIHBsdWdpbi1wcm92aWRlZCBhY3Rpb25zIHBlciBldmVudCB0eXBlLiIgYWxzbyBkb2Vzbid0
DQo+Pj4gICBtYWtlIHNlbnNlLg0KPj4+ICAgIA0KPj4+PiB0aGF0IGhhbmRsZXMgdGhlIGNhc2Ug
b2YgbXVsdGlwbGUgYWN0aW9ucyBwZXItZXZlbnQgaGFzIGEgYnVnLiBUaGUgImlmIg0KPj4+PiB3
YXMgaW50cm9kdWNlZCB3aXRoIHRoZSBpZGVhIHRoYXQgb25seSB0aGUgbGFzdCBwZXItZXZlbnQg
YWN0aW9uIHdpbGwNCj4+Pj4gbW9kaWZ5IHRoZSBLU19QTFVHSU5fVU5UT1VDSEVEIGZsYWcgb2Yg
dGhlIGVudHJ5LCBidXQgaXQgbWlzYmVoYXZlcyBpbg0KPj4+PiB0aGUgY2FzZSBvZiBhIHNpbmds
ZSBwZXItZXZlbnQgYWN0aW9uIGluIHRoZSBsaXN0LCBmb2xsb3dlZCBieSBhY3Rpb25zDQo+Pj4+
IGZvciBvdGhlciBldmVudHMuDQo+Pj4NCj4+PiBQYXRjaCBsb29rcyBmaW5lLCBidXQgY2FuIHlv
dSByZXNlbmQgd2l0aCBhIGNsZWFuZXIgY2hhbmdlIGxvZz8NCj4+Pg0KPj4+IFRoYW5rcyENCj4+
Pg0KPj4+IC0tIFN0ZXZlDQo+Pj4gICAgDQo+Pj4+DQo+Pj4+IFNpZ25lZC1vZmYtYnk6IFlvcmRh
biBLYXJhZHpob3YgPHlrYXJhZHpob3ZAdm13YXJlLmNvbT4NCj4+Pj4gLS0tDQo+Pj4+ICAga2Vy
bmVsLXNoYXJrLXF0L3NyYy9saWJrc2hhcmsuYyB8IDMgKy0tDQo+Pj4+ICAgMSBmaWxlIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9uKCspLCAyIGRlbGV0aW9ucygtKQ0KPj4+Pg0KPj4+PiBkaWZmIC0tZ2l0
IGEva2VybmVsLXNoYXJrLXF0L3NyYy9saWJrc2hhcmsuYyBiL2tlcm5lbC1zaGFyay1xdC9zcmMv
bGlia3NoYXJrLmMNCj4+Pj4gaW5kZXggNTk4ZWE1Mi4uOWFiMmQ1NyAxMDA2NDQNCj4+Pj4gLS0t
IGEva2VybmVsLXNoYXJrLXF0L3NyYy9saWJrc2hhcmsuYw0KPj4+PiArKysgYi9rZXJuZWwtc2hh
cmstcXQvc3JjL2xpYmtzaGFyay5jDQo+Pj4+IEBAIC03NTAsOCArNzUwLDcgQEAgc3RhdGljIHNp
emVfdCBnZXRfcmVjb3JkcyhzdHJ1Y3Qga3NoYXJrX2NvbnRleHQgKmtzaGFya19jdHgsDQo+Pj4+
ICAgCQkJCQkJCQkJCWVudHJ5LT5ldmVudF9pZCkpKSB7DQo+Pj4+ICAgCQkJCQlldnRfaGFuZGxl
ci0+ZXZlbnRfZnVuYyhrc2hhcmtfY3R4LCByZWMsIGVudHJ5KTsNCj4+Pj4gICAJCQkJCWV2dF9o
YW5kbGVyID0gZXZ0X2hhbmRsZXItPm5leHQ7DQo+Pj4+IC0JCQkJCWlmICghZXZ0X2hhbmRsZXIp
DQo+Pj4+IC0JCQkJCQllbnRyeS0+dmlzaWJsZSAmPSB+S1NfUExVR0lOX1VOVE9VQ0hFRF9NQVNL
Ow0KPj4+PiArCQkJCQllbnRyeS0+dmlzaWJsZSAmPSB+S1NfUExVR0lOX1VOVE9VQ0hFRF9NQVNL
Ow0KPj4+PiAgIAkJCQl9DQo+Pj4+ICAgDQo+Pj4+ICAgCQkJCXBpZCA9IGVudHJ5LT5waWQ7DQo+
Pj4gICAgDQo+IA0K
