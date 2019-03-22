Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B65C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 15:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9D0C20850
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 15:38:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="CUeOvgio"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfCVPiQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 11:38:16 -0400
Received: from mail-eopbgr790048.outbound.protection.outlook.com ([40.107.79.48]:4272
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727304AbfCVPiK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 11:38:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmgKYQBkrPDOTrB5O59fGei1O717p+xpOMe+6tV6cWo=;
 b=CUeOvgioAbhyHjcAZOhKWfk9aGbQut9GTPbvwsgHWTnVqm6ntWBuYHCtg1vE+ogdEC+H2EpbYDvKAW8wp/KOLMInYHteUZ5ViF1fvg+iJkwFYr+fllIRap+dhmIyguOVFafcryQSrN3NzhneKx9anJTu82a/LYRkNUsrtp6oAOk=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2715.namprd05.prod.outlook.com (10.167.18.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.12; Fri, 22 Mar 2019 15:38:07 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec%4]) with mapi id 15.20.1730.013; Fri, 22 Mar 2019
 15:38:07 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] tools/lib/traceevent: Implement new traceevent
 APIs for accessing struct tep_handler fields
Thread-Topic: [PATCH v2 3/3] tools/lib/traceevent: Implement new traceevent
 APIs for accessing struct tep_handler fields
Thread-Index: AQHU4LBO2kh9ZK6mr0u1ze11e3clHqYXxD6AgAAExYA=
Date:   Fri, 22 Mar 2019 15:38:07 +0000
Message-ID: <CACqStode6KGtHdf--bx_2vkEb5u0+cWxzTFFJvQRMwRu4R9EKw@mail.gmail.com>
References: <20190322130742.13753-1-tstoyanov@vmware.com>
 <20190322130742.13753-4-tstoyanov@vmware.com>
 <20190322112041.1d3d9364@gandalf.local.home>
In-Reply-To: <20190322112041.1d3d9364@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P191CA0001.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8b::14) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAUwLXuWmV2Gtw6RjnSRWL2XCMBtgqv22yW45gWxky6mI3eiQHjU
        R3TGIE5nSacog/b9jVkxLJ0daewRNZ0/wzjJ7N4=
x-google-smtp-source: APXvYqx5niNwScEb3IpllFyxpn3gaI3TXn4Q3nej4wYP/Xb+yh+50pG88C9NgZMjyu7+rIjmGZdhnxGUX+VZ2d9Twb4=
x-received: by 2002:a5d:46c9:: with SMTP id g9mr6689878wrs.211.1553269076947;
 Fri, 22 Mar 2019 08:37:56 -0700 (PDT)
x-gmail-original-message-id: <CACqStode6KGtHdf--bx_2vkEb5u0+cWxzTFFJvQRMwRu4R9EKw@mail.gmail.com>
x-originating-ip: [209.85.221.50]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71f4f7c4-28cb-4ddd-5c46-08d6aedc614e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600127)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2715;
x-ms-traffictypediagnostic: CY1PR05MB2715:
x-microsoft-antispam-prvs: <CY1PR05MB27156FABF18AB9A323BF5D47DC430@CY1PR05MB2715.namprd05.prod.outlook.com>
x-forefront-prvs: 09840A4839
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(316002)(186003)(486006)(61726006)(256004)(106356001)(476003)(446003)(11346002)(105586002)(3846002)(6116002)(6486002)(6436002)(229853002)(478600001)(2906002)(14454004)(68736007)(8936002)(9686003)(6512007)(26005)(4326008)(6862004)(25786009)(53936002)(6246003)(102836004)(52116002)(76176011)(386003)(6506007)(53546011)(5660300002)(99286004)(95326003)(7736002)(81156014)(8676002)(81166006)(61266001)(66066001)(498394004)(97736004)(305945005)(71190400001)(55446002)(86362001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2715;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZqC2223fQhrQ98JezdIjeQISnVSbT/y6f9Y4UBwKWSXMftbUAq3aUZZLSPZCblvxF2/hzTdmbV2HcU9yeRzST8/3xCWd4c8DhaBfhs8YcUP2500dZvrsWpToFbbeYguSUnRT0Mtn157KvcxrKW5iA+blJ24NeVqhv2HMI27gMeG6mBC/8bzZRwF0tQTcK16YiuZRRpt4T9igAsV7wk+pYN2v1JL7WFKJ2T9pCS2ttrSXMwI/Oe3UL4BLGqFh1RD2wwso5JHlbT5ejNHZTo3NHTVJO5D6cthpf8PHCTm8xYjXutlo0pK9uZrcUAwyl/3aZU7fclxuvGjGZjwoF5fahLtVoUi/Vwz1etFJlIDgEFcmtNG68XYw5GVmO3++X/oBfFO0Y73/7M6j3byEGMek5IDkn540dqa+d/jaPVof9d4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B43CDBAA63CB44CA9AD1C957C403D46@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f4f7c4-28cb-4ddd-5c46-08d6aedc614e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2019 15:38:07.1139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2715
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gRnJpLCBNYXIgMjIsIDIwMTkgYXQgNToyMCBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQouLi4NCj4gPiArLyoqDQo+ID4gKyAqIHRlcF9nZXRfcGFy
c2luZ19mYWlsdXJlcyAtIGdldCB0aGUgcGFyc2luZyBmYWlsdXJlcyBmbGFnDQo+ID4gKyAqIEB0
ZXA6IGEgaGFuZGxlIHRvIHRoZSB0ZXBfaGFuZGxlDQo+ID4gKyAqDQo+ID4gKyAqIFRoaXMgcmV0
dXJucyB2YWx1ZSBvZiBmbGFnICJwYXJzaW5nX2ZhaWx1cmVzIg0KPiA+ICsgKiBJZiBAdGVwIGlz
IE5VTEwsIDAgaXMgcmV0dXJuZWQuDQo+ID4gKyAqLw0KPiA+ICtpbnQgdGVwX2dldF9wYXJzaW5n
X2ZhaWx1cmVzKHN0cnVjdCB0ZXBfaGFuZGxlICp0ZXApDQo+ID4gK3sNCj4gPiArICAgICBpZiAo
dGVwKQ0KPiA+ICsgICAgICAgICAgICAgcmV0dXJuIHRlcC0+cGFyc2luZ19mYWlsdXJlczsNCj4g
PiArICAgICByZXR1cm4gMDsNCj4gPiArfQ0KPg0KPiBIbW0sIGFjdHVhbGx5IEkgdGhpbmsgd2Ug
Y2FuIGdldCByaWQgb2YgdGhlIHBhcnNpbmcgZmFpbHVyZXMNCj4gY29tcGxldGVseSwgYW5kIHVz
ZSBhbm90aGVyIG1lY2hhbmlzbSB0byByZXBvcnQgdGhlc2UgZXJyb3JzLg0KPg0KPiBPciBiZXR0
ZXIgeWV0LCBoYXZlIHRlcF9wYXJzZV9ldmVudCgpIHNldCBpdCBpbnRlcm5hbGx5IGFuZCBoYXZl
Og0KPg0KPiAgdGVwX2hhc19mYWlsdXJlcygpIC0gcmV0dXJucyB0cnVlIGlmIHRlcF9wYXJzZV9l
dmVudCgpIGZhaWxlZA0KPiAgdGVwX2NsZWFyX2ZhaWx1cmVzKCkgLSByZXNldHMgc28gdGVwX2hh
c19mYWlsdXJlcygpIHJldHVybnMgZmFsc2UNCj4NCj4NCk9rLCBJJ2xsIHJlbW92ZSB0ZXBfZ2V0
X3BhcnNpbmdfZmFpbHVyZXMoKSBmcm9tIHRoaXMgcGF0Y2guIFRoaXMgbW9kaWZpY2F0aW9uDQpz
aG91bGQgYmUgaW50cm9kdWNlZCB3aXRoIGl0cyBvd24gcGF0Y2guDQoNCj4gPiArDQo+ID4gKy8q
Kg0KPiA+ICsgKiB0ZXBfaXNfb2xkX2Zvcm1hdCAtIGdldCBpZiBhbiBvbGQga2VybmVsIGlzIHVz
ZWQNCj4NCj4gICAgIC0gcmV0dXJucyB0cnVlIGlmIHRoZSBkYXRhIGlzIGZyb20gYW4gb2xkIGtl
cm5lbA0KPg0KPiA+ICsgKiBAdGVwOiBhIGhhbmRsZSB0byB0aGUgdGVwX2hhbmRsZQ0KPiA+ICsg
Kg0KPiA+ICsgKiBUaGlzIHJldHVybnMgdHJ1ZSwgaWYgYW4gb2xkIGtlcm5lbCBpcyB1c2VkIHRv
IGdlbmVyYXRlIHRoZSB0cmFjaW5nIGV2ZW50cyBvcg0KPiA+ICsgKiBmYWxzZSBpZiBhIG5ldyBr
ZXJuZWwgaXMgdXNlZC4gT2xkIGtlcm5lbHMgZGlkIG5vdCBoYXZlIGhlYWRlciBwYWdlIGluZm8u
DQo+ID4gKyAqIElmIEBwZXZlbnQgaXMgTlVMTCwgZmFsc2UgaXMgcmV0dXJuZWQuDQo+ID4gKyAq
Lw0KPiA+ICtib29sIHRlcF9pc19vbGRfZm9ybWF0KHN0cnVjdCB0ZXBfaGFuZGxlICp0ZXApDQo+
ID4gK3sNCj4gPiArICAgICBpZiAodGVwKQ0KPiA+ICsgICAgICAgICAgICAgcmV0dXJuICEhKHRl
cC0+b2xkX2Zvcm1hdCk7DQo+ID4gKyAgICAgcmV0dXJuIGZhbHNlOw0KPiA+ICt9DQo+ID4gKw0K
PiA+ICsvKioNCj4gPiArICogdGVwX3NldF9wcmludF9yYXcgLSBzZXQgYSBmbGFnIHRvIGZvcmNl
IHByaW50IGluIHJhdyBmb3JtYXQNCj4gPiArICogQHRlcDogYSBoYW5kbGUgdG8gdGhlIHRlcF9o
YW5kbGUNCj4gPiArICogQHByaW50X3JhdzogdGhlIG5ldyB2YWx1ZSBvZiB0aGUgcHJpbnRfcmF3
IGZsYWcNCj4gPiArICoNCj4gPiArICogVGhpcyBzZXRzIGEgZmxhZyB0byBmb3JjZSBwcmludCBp
biByYXcgZm9ybWF0DQo+ID4gKyAqLw0KPiA+ICt2b2lkIHRlcF9zZXRfcHJpbnRfcmF3KHN0cnVj
dCB0ZXBfaGFuZGxlICp0ZXAsIGludCBwcmludF9yYXcpDQo+ID4gK3sNCj4gPiArICAgICBpZiAo
dGVwKQ0KPiA+ICsgICAgICAgICAgICAgdGVwLT5wcmludF9yYXcgPSBwcmludF9yYXc7DQo+ID4g
K30NCj4gPiArDQo+ID4gKy8qKg0KPiA+ICsgKiB0ZXBfc2V0X3ByaW50X3JhdyAtIHNldCBhIGZs
YWcgdG8gdGVzdCBhIGZpbHRlciBzdHJpbmcNCj4NCj4gICB0ZXBfc2V0X3Rlc3RfZmlsdGVycyAt
DQo+DQo+ID4gKyAqIEB0ZXA6IGEgaGFuZGxlIHRvIHRoZSB0ZXBfaGFuZGxlDQo+ID4gKyAqIEB0
ZXN0X2ZpbHRlcnM6IHRoZSBuZXcgdmFsdWUgb2YgdGhlIHRlc3RfZmlsdGVycyBmbGFnDQo+ID4g
KyAqDQo+ID4gKyAqIFRoaXMgc2V0cyBhIGZsYWcgdG8gZmp1c3QgdGVzdCBhIGZpbHRlciBzdHJp
bmcuIElmIHRoaXMgZmxhZyBpcyBzZXQsDQo+DQo+ICBUaGlzIGNhdXNlcyB0aGUgdGVwX2ZpbHRl
cl9hZGRfZmlsdGVyX3N0cigpIHRvIHNpbXBseSBwcmludCB0aGUgZmlsdGVyDQo+ICBpbnN0ZWFk
IG9mIGFkZGluZyBpdC4NCj4NCj4gTm90ZSwgd2Ugc2hvdWxkIHJlbW92ZSB0aGUgImV4aXQoMCki
IGZyb20gdGVwX2ZpbHRlcl9hZGRfZmlsdGVyX3N0cigpDQo+IGFuZCBoYXZlIHRoZSBjYWxsZXJz
IGRvIHRoZSBleGl0LiBBIGxpYnJhcnkgZnVuY3Rpb24gc2hvdWxkIG5vdCBjYWxsDQo+IGV4aXQu
DQo+DQo+IC0tIFN0ZXZlDQo+DQo+DQo+ID4gKyAqIHdoZW4gYSBmaWx0ZXIgc3RyaW5nIGlzIGFk
ZGVkLCB0aGVuIGl0IHdpbGwgcHJpbnQgdGhlIGZpbHRlcnMgc3RyaW5ncw0KPiA+ICsgKiB0aGF0
IHdlcmUgY3JlYXRlZCBhbmQgZXhpdC4NCj4gPiArICovDQo+ID4gK3ZvaWQgdGVwX3NldF90ZXN0
X2ZpbHRlcnMoc3RydWN0IHRlcF9oYW5kbGUgKnRlcCwgaW50IHRlc3RfZmlsdGVycykNCj4gPiAr
ew0KPiA+ICsgICAgIGlmICh0ZXApDQo+ID4gKyAgICAgICAgICAgICB0ZXAtPnRlc3RfZmlsdGVy
cyA9IHRlc3RfZmlsdGVyczsNCj4gPiArfQ0KPiA+IGRpZmYgLS1naXQgYS90b29scy9saWIvdHJh
Y2VldmVudC9ldmVudC1wYXJzZS1sb2NhbC5oIGIvdG9vbHMvbGliL3RyYWNlZXZlbnQvZXZlbnQt
cGFyc2UtbG9jYWwuaA0KPiA+IGluZGV4IDM1ODMzZWUzMmQ2Yy4uYzVjOGViNGM0YWI3IDEwMDY0
NA0KPiA+IC0tLSBhL3Rvb2xzL2xpYi90cmFjZWV2ZW50L2V2ZW50LXBhcnNlLWxvY2FsLmgNCj4g
PiArKysgYi90b29scy9saWIvdHJhY2VldmVudC9ldmVudC1wYXJzZS1sb2NhbC5oDQo+ID4gQEAg
LTgzLDYgKzgzLDggQEAgc3RydWN0IHRlcF9oYW5kbGUgew0KPiA+ICAgICAgIHN0cnVjdCBldmVu
dF9oYW5kbGVyICpoYW5kbGVyczsNCj4gPiAgICAgICBzdHJ1Y3QgdGVwX2Z1bmN0aW9uX2hhbmRs
ZXIgKmZ1bmNfaGFuZGxlcnM7DQo+ID4NCj4gPiArICAgICBpbnQgcGFyc2luZ19mYWlsdXJlczsN
Cj4gPiArDQo+ID4gICAgICAgLyogY2FjaGUgKi8NCj4gPiAgICAgICBzdHJ1Y3QgdGVwX2V2ZW50
ICpsYXN0X2V2ZW50Ow0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi90cmFjZWV2ZW50
L2V2ZW50LXBhcnNlLmggYi90b29scy9saWIvdHJhY2VldmVudC9ldmVudC1wYXJzZS5oDQo+ID4g
aW5kZXggYWVjNDhmMmFlYThhLi40YjY0NjU4MzM0ZGUgMTAwNjQ0DQo+ID4gLS0tIGEvdG9vbHMv
bGliL3RyYWNlZXZlbnQvZXZlbnQtcGFyc2UuaA0KPiA+ICsrKyBiL3Rvb2xzL2xpYi90cmFjZWV2
ZW50L2V2ZW50LXBhcnNlLmgNCj4gPiBAQCAtNDA5LDYgKzQwOSw4IEBAIHZvaWQgdGVwX3ByaW50
X3BsdWdpbnMoc3RydWN0IHRyYWNlX3NlcSAqcywNCj4gPiAgdHlwZWRlZiBjaGFyICoodGVwX2Z1
bmNfcmVzb2x2ZXJfdCkodm9pZCAqcHJpdiwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgdW5zaWduZWQgbG9uZyBsb25nICphZGRycCwgY2hhciAqKm1vZHApOw0KPiA+ICB2
b2lkIHRlcF9zZXRfZmxhZyhzdHJ1Y3QgdGVwX2hhbmRsZSAqdGVwLCBpbnQgZmxhZyk7DQo+ID4g
K3ZvaWQgdGVwX2NsZWFyX2ZsYWcoc3RydWN0IHRlcF9oYW5kbGUgKnRlcCwgZW51bSB0ZXBfZmxh
ZyBmbGFnKTsNCj4gPiArYm9vbCB0ZXBfY2hlY2tfZmxhZ3Moc3RydWN0IHRlcF9oYW5kbGUgKnRl
cCwgZW51bSB0ZXBfZmxhZyBmbGFncyk7DQo+ID4NCj4gPiAgc3RhdGljIGlubGluZSBpbnQgdGVw
X2hvc3RfYmlnZW5kaWFuKHZvaWQpDQo+ID4gIHsNCj4gPiBAQCAtNTY1LDYgKzU2NywxMiBAQCB2
b2lkIHRlcF9zZXRfaG9zdF9iaWdlbmRpYW4oc3RydWN0IHRlcF9oYW5kbGUgKnBldmVudCwgZW51
bSB0ZXBfZW5kaWFuIGVuZGlhbik7DQo+ID4gIGludCB0ZXBfaXNfbGF0ZW5jeV9mb3JtYXQoc3Ry
dWN0IHRlcF9oYW5kbGUgKnBldmVudCk7DQo+ID4gIHZvaWQgdGVwX3NldF9sYXRlbmN5X2Zvcm1h
dChzdHJ1Y3QgdGVwX2hhbmRsZSAqcGV2ZW50LCBpbnQgbGF0KTsNCj4gPiAgaW50IHRlcF9nZXRf
aGVhZGVyX3BhZ2Vfc2l6ZShzdHJ1Y3QgdGVwX2hhbmRsZSAqcGV2ZW50KTsNCj4gPiArdm9pZCB0
ZXBfc2V0X3BhcnNpbmdfZmFpbHVyZXMoc3RydWN0IHRlcF9oYW5kbGUgKnRlcCwgaW50IHBhcnNp
bmdfZmFpbHVyZXMpOw0KPiA+ICtpbnQgdGVwX2dldF9wYXJzaW5nX2ZhaWx1cmVzKHN0cnVjdCB0
ZXBfaGFuZGxlICp0ZXApOw0KPiA+ICtpbnQgdGVwX2dldF9oZWFkZXJfcGFnZV90c19zaXplKHN0
cnVjdCB0ZXBfaGFuZGxlICp0ZXApOw0KPiA+ICtib29sIHRlcF9pc19vbGRfZm9ybWF0KHN0cnVj
dCB0ZXBfaGFuZGxlICpwZXZlbnQpOw0KPiA+ICt2b2lkIHRlcF9zZXRfcHJpbnRfcmF3KHN0cnVj
dCB0ZXBfaGFuZGxlICp0ZXAsIGludCBwcmludF9yYXcpOw0KPiA+ICt2b2lkIHRlcF9zZXRfdGVz
dF9maWx0ZXJzKHN0cnVjdCB0ZXBfaGFuZGxlICp0ZXAsIGludCB0ZXN0X2ZpbHRlcnMpOw0KPiA+
DQo+ID4gIHN0cnVjdCB0ZXBfaGFuZGxlICp0ZXBfYWxsb2Modm9pZCk7DQo+ID4gIHZvaWQgdGVw
X2ZyZWUoc3RydWN0IHRlcF9oYW5kbGUgKnBldmVudCk7DQo+DQoNCg0KLS0gDQoNClR6dmV0b21p
ciAoQ2VjbykgU3RveWFub3YNClZNd2FyZSBPcGVuIFNvdXJjZSBUZWNobm9sb2d5IENlbnRlcg0K
