Return-Path: <SRS0=Onan=RV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2CBC43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Mar 2019 21:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00CDB2133D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Mar 2019 21:04:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="k0ue0XEE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfCRVEY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Mar 2019 17:04:24 -0400
Received: from mail-eopbgr700042.outbound.protection.outlook.com ([40.107.70.42]:14177
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726832AbfCRVEY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Mar 2019 17:04:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AORmYBejFc0ovjcfbFQ5rESG4FITsIqLp6dyRiSSwEU=;
 b=k0ue0XEEkgB7jrcq+jB1TiXnEuXBqBEL0GeNSy8/Vz22gfRJ3R+SLejAgkwg6jezO9lkXVojQqsDgdwEANActBqfc9vdVnfoqPUxMlTzDBlY0wgLZkW2lLmGMW5x/1FdaS4EdRXZXPUTqv6DoUCckeDLXr5cgiriKDhgLNm+mMg=
Received: from BYAPR05MB5592.namprd05.prod.outlook.com (20.177.186.153) by
 BYAPR05MB4709.namprd05.prod.outlook.com (52.135.233.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.16; Mon, 18 Mar 2019 21:04:21 +0000
Received: from BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::c0d4:e960:b51:44cc]) by BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::c0d4:e960:b51:44cc%2]) with mapi id 15.20.1709.015; Mon, 18 Mar 2019
 21:04:21 +0000
From:   Matt Helsley <mhelsley@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
CC:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [Suspected Spam] [PATCH v4 01/46] tools/lib/traceevent: Implement
 libtraceevent man pages
Thread-Topic: [Suspected Spam] [PATCH v4 01/46] tools/lib/traceevent:
 Implement libtraceevent man pages
Thread-Index: AQHU1bQFQF24kx7pcE6yxfXUmo9uHqYR8OcA
Date:   Mon, 18 Mar 2019 21:04:21 +0000
Message-ID: <E6DB113F-62ED-48B3-8C8B-58BA28F634D4@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
 <20190308133654.21264-2-tstoyanov@vmware.com>
In-Reply-To: <20190308133654.21264-2-tstoyanov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [47.33.181.168]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1ebaf82-88ce-4809-91c7-08d6abe54b0d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4709;
x-ms-traffictypediagnostic: BYAPR05MB4709:
x-microsoft-antispam-prvs: <BYAPR05MB47091292416D2264376C503EA0470@BYAPR05MB4709.namprd05.prod.outlook.com>
x-forefront-prvs: 098076C36C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(366004)(346002)(396003)(199004)(189003)(76176011)(53546011)(33656002)(6506007)(8676002)(81166006)(81156014)(105586002)(316002)(186003)(446003)(6346003)(26005)(102836004)(4326008)(8936002)(106356001)(305945005)(6862004)(5660300002)(6246003)(14454004)(7736002)(53936002)(97736004)(6512007)(86362001)(66066001)(2616005)(25786009)(71190400001)(71200400001)(83716004)(99286004)(54906003)(37006003)(11346002)(476003)(478600001)(486006)(229853002)(82746002)(6486002)(6436002)(6116002)(68736007)(3846002)(2906002)(256004)(14444005)(36756003)(6636002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4709;H:BYAPR05MB5592.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mhelsley@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ne/qRWljwO8mnM18iqs80lOjWz3jZOG48KflAGsZ5FEm3iPC+Y/QuHruZ8D71cECXmLcdMBZ3BMiO0JhoaJiMokZoYgx2MVBApli/nOSDD8TTVKGYlx3IYSKM+nU24JMTRnbex+thTyPY8VNFnC5WR7bYhKc8+Pn7U2RxH53/OnxXru7A+0yxKl9pFgU2K49ZjI2f2uQPbSwpHx8TlkJm6GEzWAoTYvGqA8HaqKqzmr+dRIymmddVsKxKmNinEhNLicHmxoBRygEJFPXLz+3CqnfBOU5n+p6yD8ecTVvuebx3SYTF62ckoZVuQI1mWu9QMUT2LBGIsgg1FGRXnc2kVH3QRgKCvLp85yB7N5L/iiyf4kTh0xQxUBspLDnzfIOLoxp/yyOcvdcg1EOlHoea203J3QAvY9X1aDYFONqeV8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <456DC2C8FDC45D42ABFFFFE50F08FD6C@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1ebaf82-88ce-4809-91c7-08d6abe54b0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2019 21:04:21.2133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4709
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQoNCj4gT24gTWFyIDgsIDIwMTksIGF0IDU6MzYgQU0sIFR6dmV0b21pciBTdG95YW5vdiA8dHN0
b3lhbm92QHZtd2FyZS5jb20+IHdyb3RlOg0KPiANCj4gVGhpcyBwYXRjaCBhZGRzIGluaXRpYWwg
c3VwcG9ydCBmb3IgbGlidHJhY2VldmVudCBtYW4gcGFnZXMgLQ0KPiBEb2N1bWVudGF0aW9uIGRp
cmVjdG9yeSwgdGVtcGxhdGVzLCBjb25maWd1cmF0aW9ucywgTWFrZWZpbGVzLg0KPiBUaGUgZmly
c3QgbWFuIHBhZ2UgaXMgYWxzbyBwYXJ0IG9mIHRoZSBwYXRjaCAtIHN1bW1hcnkgb2YgdGhlDQo+
IGxpYnJhcnkgYW5kIGFsbCBpdHMgQVBJcy4gQnVpbGRpbmcgb2YgdGhlIGRvY3VtZW50YXRpb24g
aXMNCj4gaW50ZWdyYXRlZCBpbnRvIHRoZSBsaWJ0cmFjZWV2ZW50IGJ1aWxkIHByb2Nlc3MsIG5l
dyB0YXJnZXRzIGFyZQ0KPiBhZGRlZCB0byBpdHMgTWFrZWZpbGU6DQo+IG1ha2UgZG9jDQo+IG1h
a2UgZG9jLWNsZWFuDQo+IG1ha2UgZG9jLWluc3RhbGwNCj4gbWFrZSBkb2MtdW5pbnN0YWxsDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBUenZldG9taXIgU3RveWFub3YgPHRzdG95YW5vdkB2bXdhcmUu
Y29tPg0KPiAtLS0NCj4gdG9vbHMvbGliL3RyYWNlZXZlbnQvRG9jdW1lbnRhdGlvbi9NYWtlZmls
ZSAgIHwgMjA1ICsrKysrKysrKysrKysrKysrKw0KPiAuLi4vdHJhY2VldmVudC9Eb2N1bWVudGF0
aW9uL2FzY2lpZG9jLmNvbmYgICAgfCAgOTEgKysrKysrKysNCj4gLi4uL0RvY3VtZW50YXRpb24v
bGlidHJhY2VldmVudC50eHQgICAgICAgICAgIHwgMTk4ICsrKysrKysrKysrKysrKysrDQo+IC4u
Li90cmFjZWV2ZW50L0RvY3VtZW50YXRpb24vbWFucGFnZS0xLjcyLnhzbCB8ICAxNCArKw0KPiAu
Li4vdHJhY2VldmVudC9Eb2N1bWVudGF0aW9uL21hbnBhZ2UtYmFzZS54c2wgfCAgMzUgKysrDQo+
IC4uLi9Eb2N1bWVudGF0aW9uL21hbnBhZ2UtYm9sZC1saXRlcmFsLnhzbCAgICB8ICAxNyArKw0K
PiAuLi4vRG9jdW1lbnRhdGlvbi9tYW5wYWdlLW5vcm1hbC54c2wgICAgICAgICAgfCAgMTMgKysN
Cj4gLi4uL0RvY3VtZW50YXRpb24vbWFucGFnZS1zdXBwcmVzcy1zcC54c2wgICAgIHwgIDIxICsr
DQo+IHRvb2xzL2xpYi90cmFjZWV2ZW50L01ha2VmaWxlICAgICAgICAgICAgICAgICB8ICAxMyAr
Kw0KPiA5IGZpbGVzIGNoYW5nZWQsIDYwNyBpbnNlcnRpb25zKCspDQo+IGNyZWF0ZSBtb2RlIDEw
MDY0NCB0b29scy9saWIvdHJhY2VldmVudC9Eb2N1bWVudGF0aW9uL01ha2VmaWxlDQo+IGNyZWF0
ZSBtb2RlIDEwMDY0NCB0b29scy9saWIvdHJhY2VldmVudC9Eb2N1bWVudGF0aW9uL2FzY2lpZG9j
LmNvbmYNCj4gY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL2xpYi90cmFjZWV2ZW50L0RvY3VtZW50
YXRpb24vbGlidHJhY2VldmVudC50eHQNCj4gY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL2xpYi90
cmFjZWV2ZW50L0RvY3VtZW50YXRpb24vbWFucGFnZS0xLjcyLnhzbA0KPiBjcmVhdGUgbW9kZSAx
MDA2NDQgdG9vbHMvbGliL3RyYWNlZXZlbnQvRG9jdW1lbnRhdGlvbi9tYW5wYWdlLWJhc2UueHNs
DQo+IGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy9saWIvdHJhY2VldmVudC9Eb2N1bWVudGF0aW9u
L21hbnBhZ2UtYm9sZC1saXRlcmFsLnhzbA0KPiBjcmVhdGUgbW9kZSAxMDA2NDQgdG9vbHMvbGli
L3RyYWNlZXZlbnQvRG9jdW1lbnRhdGlvbi9tYW5wYWdlLW5vcm1hbC54c2wNCj4gY3JlYXRlIG1v
ZGUgMTAwNjQ0IHRvb2xzL2xpYi90cmFjZWV2ZW50L0RvY3VtZW50YXRpb24vbWFucGFnZS1zdXBw
cmVzcy1zcC54c2wNCg0KDQo+IDxzbmlwPg0KDQoNCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi90
cmFjZWV2ZW50L01ha2VmaWxlIGIvdG9vbHMvbGliL3RyYWNlZXZlbnQvTWFrZWZpbGUNCj4gaW5k
ZXggZjY1MjQzMTM3ZDZkLi4zNzY0ZTAwM2QxY2MgMTAwNjQ0DQo+IC0tLSBhL3Rvb2xzL2xpYi90
cmFjZWV2ZW50L01ha2VmaWxlDQo+ICsrKyBiL3Rvb2xzL2xpYi90cmFjZWV2ZW50L01ha2VmaWxl
DQo+IEBAIC01Myw2ICs1Myw3IEBAIHBrZ2NvbmZpZ19kaXIgPz0gJCh3b3JkIDEsJChzaGVsbCAk
KFBLR19DT05GSUcpIAkJXA0KPiANCj4gZXhwb3J0IG1hbl9kaXIgbWFuX2Rpcl9TUSBJTlNUQUxM
DQo+IGV4cG9ydCBERVNURElSIERFU1RESVJfU1ENCj4gK2V4cG9ydCBFVkVOVF9QQVJTRV9WRVJT
SU9ODQo+IA0KPiBzZXRfcGx1Z2luX2RpciA6PSAxDQo+IA0KPiBAQCAtMzEzLDYgKzMxNCwxOCBA
QCBjbGVhbjoNCj4gCQkkKFJNKSBUUkFDRUVWRU5ULUNGTEFHUyB0YWdzIFRBR1M7IFwNCj4gCQkk
KFJNKSAkKFBLR19DT05GSUdfRklMRSkNCj4gDQpuaXQ6IEkgbm90aWNlIHlvdeKAmXJlIGFkZGlu
ZyBuZXcgdGFyZ2V0cyB3aGljaCBzaG91bGQgcHJvYmFibHkgYmUgYWRkZWQgdG8gUEhPTlkuIGUu
Zy46DQoNClBIT05ZICs9IGRvYw0KPiArZG9jOg0KPiArCSQoY2FsbCBkZXNjZW5kLERvY3VtZW50
YXRpb24pDQo+ICsNCg0KUEhPTlkgKz0gZG9jLWNsZWFuDQo+ICtkb2MtY2xlYW46DQo+ICsJJChj
YWxsIGRlc2NlbmQsRG9jdW1lbnRhdGlvbixjbGVhbikNCj4gKw0KDQpQSE9OWSArPSBkb2MtaW5z
dGFsbA0KPiArZG9jLWluc3RhbGw6DQo+ICsJJChjYWxsIGRlc2NlbmQsRG9jdW1lbnRhdGlvbixp
bnN0YWxsKQ0KPiArDQo+ICtkb2MtdW5pbnN0YWxsOg0KPiArCSQoY2FsbCBkZXNjZW5kLERvY3Vt
ZW50YXRpb24sdW5pbnN0YWxsKQ0KPiArDQoNClJldmlld2VkLWJ5OiBNYXR0IEhlbHNsZXkgPG1o
ZWxzbGV5QHZtd2FyZS5jb20+
