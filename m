Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721C3C10F03
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 13:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3065C21900
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 13:10:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="J/6S6S+r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbfCVNKm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:10:42 -0400
Received: from mail-eopbgr770083.outbound.protection.outlook.com ([40.107.77.83]:52640
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730322AbfCVLdu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 07:33:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEziLdtLJ1Wxl+lXH0Du30x9cmjbaX/x9ULUNVsvOUE=;
 b=J/6S6S+r7izYdqGSQxQbOcEbYqdN7uMPLVNgPNe1TOLxSMmYPXWAxoaRmGhG7R4pxnXWbALHiS3B/Otb6C56VyzNqrAco2BU6mQ8kA+I6pmIQHCgQKhwEcBqfXnALJa/u8dyb4cqVfbszam0JNcnz38neUw50IumLIhC9PTCC+c=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1SPR00MB263.namprd05.prod.outlook.com (10.167.9.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.9; Fri, 22 Mar 2019 11:33:48 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec%4]) with mapi id 15.20.1730.013; Fri, 22 Mar 2019
 11:33:47 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Matt Helsley <mhelsley@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tools/lib/traceevent: Implement new traceevent APIs
 for accessing struct tep_handler fields
Thread-Topic: [PATCH 3/3] tools/lib/traceevent: Implement new traceevent APIs
 for accessing struct tep_handler fields
Thread-Index: AQHU3kWjl+JA/enZRUKSXDyrcXeTPaYUuHSAgAHIbgCAAQi3gA==
Date:   Fri, 22 Mar 2019 11:33:47 +0000
Message-ID: <CACqStof40CSX=rh3B53qAH+kPy6HvePu1Mw9LY1KNzgp93Sd8A@mail.gmail.com>
References: <20190319111924.17443-1-tstoyanov@vmware.com>
 <20190319111924.17443-4-tstoyanov@vmware.com>
 <854FD5EF-691D-4BF2-8A1D-FBF6863B5C19@vmware.com>
 <20190321154602.5c49bd38@gandalf.local.home>
In-Reply-To: <20190321154602.5c49bd38@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P195CA0105.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:86::46) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAXmmf96HWCThAvdReV0VLyI9YF5Wu83d3BrDJAB5SVhrvTM1DDZ
        u66vb/imsMPqEYZIs5dmcyG3lLOfBwnIF3t2dzo=
x-google-smtp-source: APXvYqyPYjBSKODJ7O2glP/GTU0jwIzaS8z+QwiZvkZtYUlqurKJWqni0hGuosLQJh0AAuqFTkpRFtJGRmsdEmV3OdQ=
x-received: by 2002:a5d:46c9:: with SMTP id g9mr5889465wrs.211.1553254421649;
 Fri, 22 Mar 2019 04:33:41 -0700 (PDT)
x-gmail-original-message-id: <CACqStof40CSX=rh3B53qAH+kPy6HvePu1Mw9LY1KNzgp93Sd8A@mail.gmail.com>
x-originating-ip: [209.85.221.51]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f589a63c-2e28-4955-0c20-08d6aeba3f99
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600127)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:CY1SPR00MB263;
x-ms-traffictypediagnostic: CY1SPR00MB263:
x-microsoft-antispam-prvs: <CY1SPR00MB26391A174FE57988F8E624DDC430@CY1SPR00MB263.namprd05.prod.outlook.com>
x-forefront-prvs: 09840A4839
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(39860400002)(396003)(366004)(346002)(189003)(199004)(93886005)(81166006)(97736004)(11346002)(61266001)(86362001)(6436002)(4326008)(486006)(5660300002)(186003)(476003)(71190400001)(71200400001)(99286004)(25786009)(6862004)(9686003)(98316002)(81156014)(53936002)(8676002)(6246003)(52116002)(316002)(76176011)(6512007)(26005)(446003)(95326003)(6486002)(105586002)(498394004)(53546011)(102836004)(106356001)(7736002)(14454004)(66066001)(256004)(305945005)(3846002)(2906002)(54906003)(6506007)(386003)(6116002)(68736007)(61726006)(478600001)(229853002)(8936002)(55446002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1SPR00MB263;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: K1pP/nSSlDP1qpS/g0B/ZzO03vZVMkrl9gG62j5RxRRxojW0A3+DI6wlioTsGHtvqjkYTVoiUCllie22rA4CtrWERASQgb9QJzqN/P1Swr/1AzNgYsaeVcT16m0TxU8B3A+x+p2kD/UF+yc4O6o21itVuvhk6P8x58+RzMY7xYTRWs6ubyd3l9C/hiMEV1ba47TmLWpLgZFRAEUtlVmdDSVgCTSjgUwHK4X+298Gd79KA34ww3iCFGux3maBdeXxQzNCEolIec3R03nvRyuS5tLu0gGl+ShSiTQJnw5x7LInnwx/lyR6VKHiqKPnE3z5TvFsKC66pJt9Qbr0nma0nwLEZrSCUlbMk/wLwu0TGEEjL9ZtUccghl1dVNM+aoY9GSrSzwk1D+Itzc+6AptsmgGn6mfJxT9GTsj2HIXbqmk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5E89B891B57C44280E3AFF758ABD667@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f589a63c-2e28-4955-0c20-08d6aeba3f99
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2019 11:33:47.6721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1SPR00MB263
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVGh1LCBNYXIgMjEsIDIwMTkgYXQgOTo0NiBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IE9uIFdlZCwgMjAgTWFyIDIwMTkgMTY6MzI6MjUgKzAw
MDANCj4gTWF0dCBIZWxzbGV5IDxtaGVsc2xleUB2bXdhcmUuY29tPiB3cm90ZToNCj4NCj4gPiA+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgbG9uZyBsb25nICphZGRy
cCwgY2hhciAqKm1vZHApOw0KPiA+ID4gLXZvaWQgdGVwX3NldF9mbGFnKHN0cnVjdCB0ZXBfaGFu
ZGxlICp0ZXAsIGludCBmbGFnKTsNCj4gPiA+ICt2b2lkIHRlcF9zZXRfZmxhZyhzdHJ1Y3QgdGVw
X2hhbmRsZSAqdGVwLCBlbnVtIHRlcF9mbGFnIGZsYWcpOw0KPiA+ID4gK3ZvaWQgdGVwX3Jlc2V0
X2ZsYWcoc3RydWN0IHRlcF9oYW5kbGUgKnRlcCwgZW51bSB0ZXBfZmxhZyBmbGFnKTsNCj4gPiA+
ICtpbnQgdGVwX2NoZWNrX2ZsYWcoc3RydWN0IHRlcF9oYW5kbGUgKnRlcCwgZW51bSB0ZXBfZmxh
ZyBmbGFnKTsNCj4gPiA+DQo+ID4gPiBzdGF0aWMgaW5saW5lIGludCB0ZXBfaG9zdF9iaWdlbmRp
YW4odm9pZCkNCj4gPiA+IHsNCj4gPg0KPiA+IERvZXMgYW5vdGhlciBzZXJpZXMgcmVuYW1lIHRo
aXMgdG86IHRlcF9pc19ob3N0X2JpZ2VuZGlhbigpID8NCj4NCj4gSSd2ZSBiZWVuIGxvb2tpbmcg
YXQgdGhlIEFQSSBhbmQgSSB0aGluayB3ZSBkbyBuZWVkIHRvIG1ha2UgaXQgbW9yZQ0KPiBjb25z
aXN0ZW50LiBXaGF0IHdlIGN1cnJlbnRseSBoYXZlIGlzOg0KPg0KPg0KPiA+IHZvaWQgdGVwX3Nl
dF9mbGFnKHN0cnVjdCB0ZXBfaGFuZGxlICp0ZXAsIGVudW0gdGVwX2ZsYWcgZmxhZyk7DQo+ID4g
dm9pZCB0ZXBfcmVzZXRfZmxhZyhzdHJ1Y3QgdGVwX2hhbmRsZSAqdGVwLCBlbnVtIHRlcF9mbGFn
IGZsYWcpOw0KPg0KPiAoSSdsbCBpZ25vcmUgcGFyYW1ldGVycykNCj4NCj4gUmVuYW1lIHRvOiB2
b2lkIHRlcF9jbGVhcl9mbGFnKCkNCj4NCj4gPiBpbnQgdGVwX2NoZWNrX2ZsYWcoc3RydWN0IHRl
cF9oYW5kbGUgKnRlcCwgZW51bSB0ZXBfZmxhZyBmbGFnKTsNCj4NCj4gUmVuYW1lIHRvOiBib29s
IHRlcF90ZXN0X2ZsYWcoKQ0KPg0KPg0KPiA+DQo+ID4gaW50IHRlcF9ob3N0X2JpZ2VuZGlhbih2
b2lkKTsNCj4NCj4gUmVuYW1lIHRvOiBib29sIHRlcF9pc19iaWdlbmRpYW4oKQ0KDQpTdGV2ZW4s
IGludCB0ZXBfaG9zdF9iaWdlbmRpYW4odm9pZCkgYWN0dWFsbHkgY2hlY2tzIHRoZSBlbmRpYW5u
ZXNzIG9mDQp0aGUgaG9zdCAtDQpJIHRoaW5rIGl0IG1ha2VzIHNlbnMgImhvc3QiIHRvIGJlIHBh
cnQgb2YgQVBJJ3MgbmFtZS4gVGhlIG90aGVyIG9uZToNCmludCB0ZXBfaXNfaG9zdF9iaWdlbmRp
YW4oc3RydWN0IHRlcF9oYW5kbGUgKnBldmVudCkgY2hlY2tzIHRoZQ0KZW5kaWFubmVzcyBzdG9y
ZWQNCmluIHRoZSB0ZXBfaGFuZGxlLCBJIHRoaW5rIHdlIHNob3VsZCByZW1vdmUgImhvc3QiIGZy
b20gaXRzIG5hbWUuDQoNCj4NCj4gKEJyZWFrIGZyb20gdGhlIGNvbmZ1c2lvbiB0byB3aGF0IGEg
Imhvc3QiIGlzKQ0KPg0KPiA+DQo+ID4gaW50IHRlcF9zZXRfZnVuY3Rpb25fcmVzb2x2ZXIoc3Ry
dWN0IHRlcF9oYW5kbGUgKnBldmVudCwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
dGVwX2Z1bmNfcmVzb2x2ZXJfdCAqZnVuYywgdm9pZCAqcHJpdik7DQo+ID4gdm9pZCB0ZXBfcmVz
ZXRfZnVuY3Rpb25fcmVzb2x2ZXIoc3RydWN0IHRlcF9oYW5kbGUgKnBldmVudCk7DQo+ID4gaW50
IHRlcF9yZWdpc3Rlcl9jb21tKHN0cnVjdCB0ZXBfaGFuZGxlICpwZXZlbnQsIGNvbnN0IGNoYXIg
KmNvbW0sIGludCBwaWQpOw0KPiA+IGludCB0ZXBfb3ZlcnJpZGVfY29tbShzdHJ1Y3QgdGVwX2hh
bmRsZSAqcGV2ZW50LCBjb25zdCBjaGFyICpjb21tLCBpbnQgcGlkKTsNCj4gPiBpbnQgdGVwX3Jl
Z2lzdGVyX3RyYWNlX2Nsb2NrKHN0cnVjdCB0ZXBfaGFuZGxlICpwZXZlbnQsIGNvbnN0IGNoYXIg
KnRyYWNlX2Nsb2NrKTsNCj4gPiBpbnQgdGVwX3JlZ2lzdGVyX2Z1bmN0aW9uKHN0cnVjdCB0ZXBf
aGFuZGxlICpwZXZlbnQsIGNoYXIgKm5hbWUsDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAg
dW5zaWduZWQgbG9uZyBsb25nIGFkZHIsIGNoYXIgKm1vZCk7DQo+ID4gaW50IHRlcF9yZWdpc3Rl
cl9wcmludF9zdHJpbmcoc3RydWN0IHRlcF9oYW5kbGUgKnBldmVudCwgY29uc3QgY2hhciAqZm10
LA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBsb25nIGxvbmcgYWRk
cik7DQo+ID4gaW50IHRlcF9waWRfaXNfcmVnaXN0ZXJlZChzdHJ1Y3QgdGVwX2hhbmRsZSAqcGV2
ZW50LCBpbnQgcGlkKTsNCj4NCj4gUmVuYW1lIHRvOiBib29sIHRlcF9pc19waWRfcmVnaXN0ZXJl
ZCgpDQo+DQo+DQo+ID4NCj4gPiBpbnQgdGVwX2dldF9jcHVzKHN0cnVjdCB0ZXBfaGFuZGxlICpw
ZXZlbnQpOw0KPiA+IHZvaWQgdGVwX3NldF9jcHVzKHN0cnVjdCB0ZXBfaGFuZGxlICpwZXZlbnQs
IGludCBjcHVzKTsNCj4gPiBpbnQgdGVwX2dldF9sb25nX3NpemUoc3RydWN0IHRlcF9oYW5kbGUg
KnBldmVudCk7DQo+ID4gdm9pZCB0ZXBfc2V0X2xvbmdfc2l6ZShzdHJ1Y3QgdGVwX2hhbmRsZSAq
cGV2ZW50LCBpbnQgbG9uZ19zaXplKTsNCj4gPiBpbnQgdGVwX2dldF9wYWdlX3NpemUoc3RydWN0
IHRlcF9oYW5kbGUgKnBldmVudCk7DQo+ID4gdm9pZCB0ZXBfc2V0X3BhZ2Vfc2l6ZShzdHJ1Y3Qg
dGVwX2hhbmRsZSAqcGV2ZW50LCBpbnQgX3BhZ2Vfc2l6ZSk7DQo+ID4gaW50IHRlcF9maWxlX2Jp
Z2VuZGlhbihzdHJ1Y3QgdGVwX2hhbmRsZSAqcGV2ZW50KTsNCj4NCj4gUmVuYW1lIHRvOiBib29s
IHRlcF9pc19maWxlX2JpZ2VuZGlhbigpDQo+DQo+ID4gdm9pZCB0ZXBfc2V0X2ZpbGVfYmlnZW5k
aWFuKHN0cnVjdCB0ZXBfaGFuZGxlICpwZXZlbnQsIGVudW0gdGVwX2VuZGlhbiBlbmRpYW4pOw0K
PiA+IGludCB0ZXBfaXNfaG9zdF9iaWdlbmRpYW4oc3RydWN0IHRlcF9oYW5kbGUgKnBldmVudCk7
DQo+DQo+IFJlbmFtZSB0bzogYm9vbCB0ZXBfaXNfaG9zdF9iaWdlbmRpYW4oKQ0KPg0KPiA+IHZv
aWQgdGVwX3NldF9ob3N0X2JpZ2VuZGlhbihzdHJ1Y3QgdGVwX2hhbmRsZSAqcGV2ZW50LCBlbnVt
IHRlcF9lbmRpYW4gZW5kaWFuKTsNCj4gPiBpbnQgdGVwX2lzX2xhdGVuY3lfZm9ybWF0KHN0cnVj
dCB0ZXBfaGFuZGxlICpwZXZlbnQpOw0KPg0KPiBSZW5hbWUgdG86IGJvb2wgdGVwX2lzX2xhdGVu
Y3lfZm9ybWF0KCkNCj4NCj4gPiB2b2lkIHRlcF9zZXRfbGF0ZW5jeV9mb3JtYXQoc3RydWN0IHRl
cF9oYW5kbGUgKnBldmVudCwgaW50IGxhdCk7DQo+ID4gaW50IHRlcF9nZXRfaGVhZGVyX3BhZ2Vf
c2l6ZShzdHJ1Y3QgdGVwX2hhbmRsZSAqcGV2ZW50KTsNCj4gPiB2b2lkIHRlcF9zZXRfcGFyc2lu
Z19mYWlsdXJlcyhzdHJ1Y3QgdGVwX2hhbmRsZSAqdGVwLCBpbnQgcGFyc2luZ19mYWlsdXJlcyk7
DQo+ID4gaW50IHRlcF9nZXRfcGFyc2luZ19mYWlsdXJlcyhzdHJ1Y3QgdGVwX2hhbmRsZSAqdGVw
KTsNCj4gPiBpbnQgdGVwX2dldF9oZWFkZXJfcGFnZV90c19zaXplKHN0cnVjdCB0ZXBfaGFuZGxl
ICp0ZXApOw0KPg0KPiBSZW5hbWUgdG86IGludCB0ZXBfZ2V0X2hlYWRlcl90aW1lc3RhbXBfc2l6
ZSgpDQo+DQo+ID4gaW50IHRlcF9pc19vbGRfZm9ybWF0KHN0cnVjdCB0ZXBfaGFuZGxlICpwZXZl
bnQpOw0KPg0KPiBSZW5hbWUgdG86IGJvb2wgdGVwX2lzX29sZF9mb3JtYXQoKQ0KPg0KPiBUaGVz
ZSBjaGFuZ2VzIG1heSBuZWVkIHRvIGJlIGJyb2tlbiB1cCBpbnRvIHNlcGFyYXRlIHBhdGNoZXMu
DQo+DQo+IC0tIFN0ZXZlDQoNCg0KDQotLSANCg0KVHp2ZXRvbWlyIChDZWNvKSBTdG95YW5vdg0K
Vk13YXJlIE9wZW4gU291cmNlIFRlY2hub2xvZ3kgQ2VudGVyDQo=
