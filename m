Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D7ADC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 11:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 347122085A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 11:29:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="JH1O/xxD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfCSL3f (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 07:29:35 -0400
Received: from mail-eopbgr760051.outbound.protection.outlook.com ([40.107.76.51]:17863
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725934AbfCSL3e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 07:29:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9QX8dtwIzrIxG9Lp7fzTALH3+dngwpHtc5++ki7B/zU=;
 b=JH1O/xxDTYHYH3QWKP9fuRlYGta+j5qWNU8CkqC77lqn2nqbQF7L77WxmG8cvr3/QPHmSjSO0oZd03MWvQJJWHX//wCeNwRzmAfoarUjddwAkE44t8EN6BxcOWAqAazn4c783g8f4j8TztqT3MEf0YOrwNlGjfMxlvma0tJvbUc=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2716.namprd05.prod.outlook.com (10.167.18.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.6; Tue, 19 Mar 2019 11:28:52 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec%4]) with mapi id 15.20.1709.015; Tue, 19 Mar 2019
 11:28:52 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Matt Helsley <mhelsley@vmware.com>
CC:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [Suspected Spam] [PATCH v4 01/46] tools/lib/traceevent: Implement
 libtraceevent man pages
Thread-Topic: [Suspected Spam] [PATCH v4 01/46] tools/lib/traceevent:
 Implement libtraceevent man pages
Thread-Index: AQHU1bQFZnmLbA+Ajk2AOgmXJVv8hKYR8OiAgADxeAA=
Date:   Tue, 19 Mar 2019 11:28:52 +0000
Message-ID: <CACqStofZRRJkE2-ywKPJ2X3c4o0spWCaQZeuZ22yFpj2RVP1AQ@mail.gmail.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
 <20190308133654.21264-2-tstoyanov@vmware.com>
 <E6DB113F-62ED-48B3-8C8B-58BA28F634D4@vmware.com>
In-Reply-To: <E6DB113F-62ED-48B3-8C8B-58BA28F634D4@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P193CA0053.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:8e::30) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAV0fWX5lCarPRJmoGzJT+K0HmCAMeKo1o8GVTD9Bu/znIu9gJ3/
        /VPlqQhK4+oqt/JIPis1dFd5X4ubh7EoGdN88ps=
x-google-smtp-source: APXvYqwXbCYoOeqQchgAgSU6r0B403dPKEKvBx56CaZTKuYzsEIH8IAly3RagGClf+9wRP4/9y2ODOrkpOgc5sLGnHI=
x-received: by 2002:a1c:c18d:: with SMTP id
 r135mr3117641wmf.112.1552994927812; Tue, 19 Mar 2019 04:28:47 -0700 (PDT)
x-gmail-original-message-id: <CACqStofZRRJkE2-ywKPJ2X3c4o0spWCaQZeuZ22yFpj2RVP1AQ@mail.gmail.com>
x-originating-ip: [209.85.128.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 912f213e-b6dc-4da2-bc28-08d6ac5e106e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2716;
x-ms-traffictypediagnostic: CY1PR05MB2716:
x-microsoft-antispam-prvs: <CY1PR05MB271616B5CBF192A3512C48CCDC400@CY1PR05MB2716.namprd05.prod.outlook.com>
x-forefront-prvs: 0981815F2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(346002)(136003)(376002)(199004)(189003)(26005)(186003)(316002)(61266001)(99286004)(6636002)(86362001)(256004)(6346003)(14444005)(9686003)(6506007)(5660300002)(6512007)(498394004)(6862004)(68736007)(97736004)(3846002)(305945005)(71200400001)(6486002)(6116002)(53546011)(95326003)(66066001)(102836004)(71190400001)(76176011)(386003)(54906003)(52116002)(14454004)(55446002)(81156014)(229853002)(478600001)(25786009)(2906002)(476003)(11346002)(6246003)(81166006)(446003)(8676002)(486006)(4326008)(6436002)(7736002)(61726006)(106356001)(53936002)(105586002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2716;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NRCiGOAU29laXK299VdbV6KiDqolvbEAbAPZZGxjK5m3/uThr2M5W9tMd9YmWP7SaOLK6SinZQhHD9ZCTD5cb+bdC7cnw1uZ/zPNalVrzr0epFGnmgx7qrQllnv37n3WWx16tljAiEcqrSh/S/dC/CMxeA7TQ75jWDlZKS1ZE4a0DmiUOeMSYtjjySmN9D/J60iCqh7zKxirh20otNbbF6Hfx/oJ872kCoXmis02e/pFjJ971teK/TvylrlQ/e4tG+wiZBqzK4rN2MbzKJIHwod3RQlJNOqm4PtBG5FoQHVXSLd0H3EUL716gj25ZoK9liczBkyKIkmsGlNrKyoeb/V0eaVElwcThN04Q4zNwVeg1firb2/xpgG1w5qlHhKkXRxkRZJgiLYu/8mcQiL9/rhAswge6ZHpUyCPRJswpnk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <02D99279C120CF41AF78C0765F416B72@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 912f213e-b6dc-4da2-bc28-08d6ac5e106e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2019 11:28:52.6113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2716
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gTW9uLCBNYXIgMTgsIDIwMTkgYXQgMTE6MDQgUE0gTWF0dCBIZWxzbGV5IDxtaGVsc2xleUB2
bXdhcmUuY29tPiB3cm90ZToNCj4NCj4NCj4NCj4gPiBPbiBNYXIgOCwgMjAxOSwgYXQgNTozNiBB
TSwgVHp2ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJlLmNvbT4gd3JvdGU6DQo+ID4N
Cj4gPiBUaGlzIHBhdGNoIGFkZHMgaW5pdGlhbCBzdXBwb3J0IGZvciBsaWJ0cmFjZWV2ZW50IG1h
biBwYWdlcyAtDQo+ID4gRG9jdW1lbnRhdGlvbiBkaXJlY3RvcnksIHRlbXBsYXRlcywgY29uZmln
dXJhdGlvbnMsIE1ha2VmaWxlcy4NCj4gPiBUaGUgZmlyc3QgbWFuIHBhZ2UgaXMgYWxzbyBwYXJ0
IG9mIHRoZSBwYXRjaCAtIHN1bW1hcnkgb2YgdGhlDQo+ID4gbGlicmFyeSBhbmQgYWxsIGl0cyBB
UElzLiBCdWlsZGluZyBvZiB0aGUgZG9jdW1lbnRhdGlvbiBpcw0KPiA+IGludGVncmF0ZWQgaW50
byB0aGUgbGlidHJhY2VldmVudCBidWlsZCBwcm9jZXNzLCBuZXcgdGFyZ2V0cyBhcmUNCj4gPiBh
ZGRlZCB0byBpdHMgTWFrZWZpbGU6DQo+ID4gbWFrZSBkb2MNCj4gPiBtYWtlIGRvYy1jbGVhbg0K
PiA+IG1ha2UgZG9jLWluc3RhbGwNCj4gPiBtYWtlIGRvYy11bmluc3RhbGwNCj4gPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IFR6dmV0b21pciBTdG95YW5vdiA8dHN0b3lhbm92QHZtd2FyZS5jb20+DQo+
ID4gLS0tDQo+ID4gdG9vbHMvbGliL3RyYWNlZXZlbnQvRG9jdW1lbnRhdGlvbi9NYWtlZmlsZSAg
IHwgMjA1ICsrKysrKysrKysrKysrKysrKw0KPiA+IC4uLi90cmFjZWV2ZW50L0RvY3VtZW50YXRp
b24vYXNjaWlkb2MuY29uZiAgICB8ICA5MSArKysrKysrKw0KPiA+IC4uLi9Eb2N1bWVudGF0aW9u
L2xpYnRyYWNlZXZlbnQudHh0ICAgICAgICAgICB8IDE5OCArKysrKysrKysrKysrKysrKw0KPiA+
IC4uLi90cmFjZWV2ZW50L0RvY3VtZW50YXRpb24vbWFucGFnZS0xLjcyLnhzbCB8ICAxNCArKw0K
PiA+IC4uLi90cmFjZWV2ZW50L0RvY3VtZW50YXRpb24vbWFucGFnZS1iYXNlLnhzbCB8ICAzNSAr
KysNCj4gPiAuLi4vRG9jdW1lbnRhdGlvbi9tYW5wYWdlLWJvbGQtbGl0ZXJhbC54c2wgICAgfCAg
MTcgKysNCj4gPiAuLi4vRG9jdW1lbnRhdGlvbi9tYW5wYWdlLW5vcm1hbC54c2wgICAgICAgICAg
fCAgMTMgKysNCj4gPiAuLi4vRG9jdW1lbnRhdGlvbi9tYW5wYWdlLXN1cHByZXNzLXNwLnhzbCAg
ICAgfCAgMjEgKysNCj4gPiB0b29scy9saWIvdHJhY2VldmVudC9NYWtlZmlsZSAgICAgICAgICAg
ICAgICAgfCAgMTMgKysNCj4gPiA5IGZpbGVzIGNoYW5nZWQsIDYwNyBpbnNlcnRpb25zKCspDQo+
ID4gY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL2xpYi90cmFjZWV2ZW50L0RvY3VtZW50YXRpb24v
TWFrZWZpbGUNCj4gPiBjcmVhdGUgbW9kZSAxMDA2NDQgdG9vbHMvbGliL3RyYWNlZXZlbnQvRG9j
dW1lbnRhdGlvbi9hc2NpaWRvYy5jb25mDQo+ID4gY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL2xp
Yi90cmFjZWV2ZW50L0RvY3VtZW50YXRpb24vbGlidHJhY2VldmVudC50eHQNCj4gPiBjcmVhdGUg
bW9kZSAxMDA2NDQgdG9vbHMvbGliL3RyYWNlZXZlbnQvRG9jdW1lbnRhdGlvbi9tYW5wYWdlLTEu
NzIueHNsDQo+ID4gY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL2xpYi90cmFjZWV2ZW50L0RvY3Vt
ZW50YXRpb24vbWFucGFnZS1iYXNlLnhzbA0KPiA+IGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy9s
aWIvdHJhY2VldmVudC9Eb2N1bWVudGF0aW9uL21hbnBhZ2UtYm9sZC1saXRlcmFsLnhzbA0KPiA+
IGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy9saWIvdHJhY2VldmVudC9Eb2N1bWVudGF0aW9uL21h
bnBhZ2Utbm9ybWFsLnhzbA0KPiA+IGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy9saWIvdHJhY2Vl
dmVudC9Eb2N1bWVudGF0aW9uL21hbnBhZ2Utc3VwcHJlc3Mtc3AueHNsDQo+DQo+DQo+ID4gPHNu
aXA+DQo+DQo+DQo+ID4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi90cmFjZWV2ZW50L01ha2VmaWxl
IGIvdG9vbHMvbGliL3RyYWNlZXZlbnQvTWFrZWZpbGUNCj4gPiBpbmRleCBmNjUyNDMxMzdkNmQu
LjM3NjRlMDAzZDFjYyAxMDA2NDQNCj4gPiAtLS0gYS90b29scy9saWIvdHJhY2VldmVudC9NYWtl
ZmlsZQ0KPiA+ICsrKyBiL3Rvb2xzL2xpYi90cmFjZWV2ZW50L01ha2VmaWxlDQo+ID4gQEAgLTUz
LDYgKzUzLDcgQEAgcGtnY29uZmlnX2RpciA/PSAkKHdvcmQgMSwkKHNoZWxsICQoUEtHX0NPTkZJ
RykgICAgICAgICAgICAgXA0KPiA+DQo+ID4gZXhwb3J0IG1hbl9kaXIgbWFuX2Rpcl9TUSBJTlNU
QUxMDQo+ID4gZXhwb3J0IERFU1RESVIgREVTVERJUl9TUQ0KPiA+ICtleHBvcnQgRVZFTlRfUEFS
U0VfVkVSU0lPTg0KPiA+DQo+ID4gc2V0X3BsdWdpbl9kaXIgOj0gMQ0KPiA+DQo+ID4gQEAgLTMx
Myw2ICszMTQsMTggQEAgY2xlYW46DQo+ID4gICAgICAgICAgICAgICAkKFJNKSBUUkFDRUVWRU5U
LUNGTEFHUyB0YWdzIFRBR1M7IFwNCj4gPiAgICAgICAgICAgICAgICQoUk0pICQoUEtHX0NPTkZJ
R19GSUxFKQ0KPiA+DQo+IG5pdDogSSBub3RpY2UgeW914oCZcmUgYWRkaW5nIG5ldyB0YXJnZXRz
IHdoaWNoIHNob3VsZCBwcm9iYWJseSBiZSBhZGRlZCB0byBQSE9OWS4gZS5nLjoNCj4NCj4gUEhP
TlkgKz0gZG9jDQo+ID4gK2RvYzoNCj4gPiArICAgICAkKGNhbGwgZGVzY2VuZCxEb2N1bWVudGF0
aW9uKQ0KPiA+ICsNCj4NCj4gUEhPTlkgKz0gZG9jLWNsZWFuDQo+ID4gK2RvYy1jbGVhbjoNCj4g
PiArICAgICAkKGNhbGwgZGVzY2VuZCxEb2N1bWVudGF0aW9uLGNsZWFuKQ0KPiA+ICsNCj4NCj4g
UEhPTlkgKz0gZG9jLWluc3RhbGwNCj4gPiArZG9jLWluc3RhbGw6DQo+ID4gKyAgICAgJChjYWxs
IGRlc2NlbmQsRG9jdW1lbnRhdGlvbixpbnN0YWxsKQ0KPiA+ICsNCj4gPiArZG9jLXVuaW5zdGFs
bDoNCj4gPiArICAgICAkKGNhbGwgZGVzY2VuZCxEb2N1bWVudGF0aW9uLHVuaW5zdGFsbCkNCj4g
PiArDQo+DQo+IFJldmlld2VkLWJ5OiBNYXR0IEhlbHNsZXkgPG1oZWxzbGV5QHZtd2FyZS5jb20+
DQoNClRoYW5rcyBNYXR0LCBJJ2xsIGFkZCBpdCBpbiB0aGUgbmV4dCB2ZXJzaW9uIG9mIHRoZSBw
YXRjaC4NCg0KDQotLSANCg0KVHp2ZXRvbWlyIChDZWNvKSBTdG95YW5vdg0KVk13YXJlIE9wZW4g
U291cmNlIFRlY2hub2xvZ3kgQ2VudGVyDQo=
