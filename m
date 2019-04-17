Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83464C10F12
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 09:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AF84206B6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 09:11:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="TuUbi48P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfDQJLJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 05:11:09 -0400
Received: from mail-eopbgr820087.outbound.protection.outlook.com ([40.107.82.87]:43648
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728856AbfDQJLJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 05:11:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIFx6Io/FSMjpuGjNOhgcRL8Tw2u5wan0VJao6EE0es=;
 b=TuUbi48Pf4mnCp2jqtEzUAlPyNq0fUGVCa8Ed0cA/eEbukfzncr+9w4ABD1Muogwl1J0JpB2Yc+cLMTw9OCMUER5TGizVIUO//pGDycuRxzrWPr9fCTCDJqt1koVMDNtRKT4knhyelrJUgwOVK9j4wBmfBtmbUMYx9l4AvbQAV8=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2427.namprd05.prod.outlook.com (10.167.10.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.5; Wed, 17 Apr 2019 09:10:27 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::99c4:3097:b606:1c00]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::99c4:3097:b606:1c00%12]) with mapi id 15.20.1813.009; Wed, 17 Apr
 2019 09:10:27 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/2] trace-cmd: remove parsing_failures APIs from
 libtraceevent
Thread-Topic: [PATCH 1/2] trace-cmd: remove parsing_failures APIs from
 libtraceevent
Thread-Index: AQHU84ruIUIIwv7/U0OKQVzd88iCPKY/ZfIAgACtrAA=
Date:   Wed, 17 Apr 2019 09:10:26 +0000
Message-ID: <CACqStoc1vyLp=8XavFoXBCrFQh7C5eruhhGoVLwqHS670TP06g@mail.gmail.com>
References: <20190415125823.4011-1-tstoyanov@vmware.com>
 <20190416184832.2bb69162@gandalf.local.home>
In-Reply-To: <20190416184832.2bb69162@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR06CA0014.eurprd06.prod.outlook.com
 (2603:10a6:20b:14::27) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAX7AOjya8outTV7wjztJCwYaNLxhXrN/M5cYOu0oiEzaILtv+ZV
        pCgIxbEvGpcKfy+QTVn0PyLORkc3ccsihBguIfc=
x-google-smtp-source: APXvYqyJRiC0LMYAaXx/uduWxdBi3NY8apmyIHvreoRsCT9jU7Aad92bbrMXZOLQtpteoV65/6NaUT4Ux1PS7sJW9lQ=
x-received: by 2002:a1c:e709:: with SMTP id e9mr31691086wmh.14.1555492220159;
 Wed, 17 Apr 2019 02:10:20 -0700 (PDT)
x-gmail-original-message-id: <CACqStoc1vyLp=8XavFoXBCrFQh7C5eruhhGoVLwqHS670TP06g@mail.gmail.com>
x-originating-ip: [209.85.128.44]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78f04b78-ead5-4cc4-81cb-08d6c31487e2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600140)(711020)(4605104)(2017052603328)(7193020);SRVR:CY1PR05MB2427;
x-ms-traffictypediagnostic: CY1PR05MB2427:
x-microsoft-antispam-prvs: <CY1PR05MB2427074487DC7950F031773DDC250@CY1PR05MB2427.namprd05.prod.outlook.com>
x-forefront-prvs: 0010D93EFE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(376002)(366004)(346002)(189003)(199004)(478600001)(7736002)(229853002)(14454004)(4326008)(25786009)(9686003)(8676002)(81166006)(6512007)(81156014)(11346002)(99286004)(52116002)(102836004)(446003)(476003)(498394004)(486006)(98316002)(86362001)(26005)(68736007)(76176011)(95326003)(305945005)(6246003)(53546011)(66066001)(386003)(6506007)(256004)(316002)(106356001)(71190400001)(2906002)(186003)(105586002)(61266001)(6862004)(55446002)(5660300002)(6486002)(53936002)(6436002)(6116002)(97736004)(71200400001)(61726006)(3846002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2427;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NgSn42JDObTroX92yzo8TCD6uOXCAiQm8CAhI73fTp+r9FlbTIkhIoAcvvbOgGbBJHQEXkXq0+kW9Hy7xjgDDCLL5zjTzPE3kVM8WJ+f+jf/eMw6MJ1RxJohzmfsCuCfmLmw1JjjQPape7T1DuKlP7Xcf9P808/O5zONwLhRIpycS7IcoYH4DP1d/+JqJuICVr+KrSptsma23Jvbtzm4LoE0jB6Knl30OL81DFrZQqsu0vmNSr9bpcBdtARFNyn7D9xKm5Hl7Zh1FLBwmH097h3SMM4zXPBRooMtoREh/37ANLJt8djlzcOtZiAmV6Y/YAMtSfpJBGTqIpN8Oq24ivhaapXRh5uftcRQs5wW1jGKsbSxHK7Bp9cnitWUa4lQpj7TrjRqD+VRU42RlCVOaNHi43w+Ri13vs82kptqkgI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A5A21D478D79554BA25B0D0B05FFBFCC@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f04b78-ead5-4cc4-81cb-08d6c31487e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2019 09:10:26.8506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2427
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

SGkgU3RldmVuLA0KDQpPbiBXZWQsIEFwciAxNywgMjAxOSBhdCAxOjQ4IEFNIFN0ZXZlbiBSb3N0
ZWR0IDxyb3N0ZWR0QGdvb2RtaXMub3JnPiB3cm90ZToNCj4NCi4uLi4NCj4gPiArLyoqDQo+ID4g
KyAqIHRyYWNlY21kX3JlYWRfaGVhZGVyc19mYWlsdXJlcyAtIHJlYWQgdGhlIGhlYWRlciBpbmZv
cm1hdGlvbiBmcm9tIHRyYWNlLmRhdA0KPiA+ICsgKiBAaGFuZGxlOiBpbnB1dCBoYW5kbGUgZm9y
IHRoZSB0cmFjZS5kYXQgZmlsZQ0KPiA+ICsgKiBAcGFyc2luZ19mYWlsdXJlczogcmV0dXJuIG51
bWJlciBvZiBmYWlsdXJlcyB3aGlsZSBwYXJzaW5nIHRoZSBldmVudCBmaWxlcw0KPiA+ICsgKg0K
PiA+ICsgKiBUaGlzIHJlYWRzIHRoZSB0cmFjZS5kYXQgZmlsZSBmb3IgdmFyaW91cyBpbmZvcm1h
dGlvbi4gTGlrZSB0aGUNCj4gPiArICogZm9ybWF0IG9mIHRoZSByaW5nIGJ1ZmZlciwgZXZlbnQg
Zm9ybWF0cywgZnRyYWNlIGZvcm1hdHMsIGthbGxzeW1zDQo+ID4gKyAqIGFuZCBwcmludGsuDQo+
ID4gKyAqLw0KPiA+ICtpbnQgdHJhY2VjbWRfcmVhZF9oZWFkZXJzX2ZhaWx1cmVzKHN0cnVjdCB0
cmFjZWNtZF9pbnB1dCAqaGFuZGxlLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGludCAqcGFyc2luZ19mYWlsdXJlcykNCj4NCj4gTGV0J3Mgbm90IGFkZCB0aGlzLiBJbnN0
ZWFkIGFkZCBhICJwYXJzaW5nX2ZhaWx1cmVzIiB0byB0aGUNCj4gdHJhY2VjbWRfaW5wdXQgaGFu
ZGxlLCBhbmQgYWRkOg0KPg0KPiBpbnQgdHJhY2VjbWRfZ2V0X3BhcnNpbmdfZmFpbHVyZXMoc3Ry
dWN0IHRyYWNlY21kX2lucHV0ICpoYW5kbGUpDQo+IHsNCj4gICAgICAgICByZXR1cm4gaGFuZGxl
LT5wYXJzaW5nX2ZhaWx1cmVzOw0KPiB9DQo+DQpJIGhlc2l0YXRlZCBpZiB0byBhZGQgbmV3IEFQ
SSwgb3IgdXNlIGFkZGl0aW9uYWwgcGFyYW1ldGVyIHRvIHRoZQ0KZXhpc3RpbmcgZnVuY3Rpb25z
Lg0KVGhlIHJlYXNvbiBmb3IgdGhpcyBjaGFuZ2UgaXMgdG8gcmVtb3ZlICJwYXJzaW5nX2ZhaWx1
cmVzIiBmcm9tDQp0cmFjZWV2ZW50IGxpYnJhcnksDQp0aGF0J3Mgd2h5IEkgZGVjaWRlZCBub3Qg
dG8gbW92ZSBpdCB0byB0cmFjZS1jbWQgbGlicmFyeS4gVXNpbmcgbmV3DQpsaWJyYXJ5IEFQSSBp
cyBuaWNlciwNCkkgY2FuIHJlaW1wbGVtZW50IGl0IGluIHRoaXMgd2F5LCBidXQgd2UgbWF5IGhh
dmUgdGhlIHNhbWUgY29uY2VybnMNCndoZW4gdHJhY2UtY21kDQpsaWJyYXJ5IGNvbWVzIG91dC4N
Cg0KPiA+ICt7DQo+ID4gKyAgICAgcmV0dXJuIF90cmFjZWNtZF9yZWFkX2hlYWRlcnMoaGFuZGxl
LCBwYXJzaW5nX2ZhaWx1cmVzKTsNCj4gPiArfQ0KPiA+ICsNCj4NCj4gWy4uXQ0KPg0KPiA+IGRp
ZmYgLS1naXQgYS90cmFjZWNtZC90cmFjZS1yZWFkLmMgYi90cmFjZWNtZC90cmFjZS1yZWFkLmMN
Cj4gPiBpbmRleCA1MmZhMWJkLi5mZTExNmNjIDEwMDY0NA0KPiA+IC0tLSBhL3RyYWNlY21kL3Ry
YWNlLXJlYWQuYw0KPiA+ICsrKyBiL3RyYWNlY21kL3RyYWNlLXJlYWQuYw0KPiA+IEBAIC0xNDE3
LDYgKzE0MTcsNyBAQCB2b2lkIHRyYWNlX3JlcG9ydCAoaW50IGFyZ2MsIGNoYXIgKiphcmd2KQ0K
PiA+ICAgICAgIHVuc2lnbmVkIGxvbmcgbG9uZyB0c29mZnNldCA9IDA7DQo+ID4gICAgICAgdW5z
aWduZWQgbG9uZyBsb25nIHRzMnNlY3MgPSAwOw0KPiA+ICAgICAgIHVuc2lnbmVkIGxvbmcgbG9u
ZyB0czJzYzsNCj4gPiArICAgICBpbnQgcGFyc2luZ19mYWlsdXJlczsNCj4gPiAgICAgICBpbnQg
c2hvd19zdGF0ID0gMDsNCj4gPiAgICAgICBpbnQgc2hvd19mdW5jcyA9IDA7DQo+ID4gICAgICAg
aW50IHNob3dfZW5kaWFuID0gMDsNCj4gPiBAQCAtMTcxNCwxMCArMTcxNSwxMCBAQCB2b2lkIHRy
YWNlX3JlcG9ydCAoaW50IGFyZ2MsIGNoYXIgKiphcmd2KQ0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICB0cmFjZWNtZF9wcmludF9ldmVudHMoaGFuZGxlLCBwcmludF9ldmVudCk7DQo+ID4gICAg
ICAgICAgICAgICAgICAgICAgIHJldHVybjsNCj4gPiAgICAgICAgICAgICAgIH0NCj4gPiAtDQo+
ID4gLSAgICAgICAgICAgICByZXQgPSB0cmFjZWNtZF9yZWFkX2hlYWRlcnMoaGFuZGxlKTsNCj4g
PiArICAgICAgICAgICAgIHBhcnNpbmdfZmFpbHVyZXMgPSAwOw0KPiA+ICsgICAgICAgICAgICAg
cmV0ID0gdHJhY2VjbWRfcmVhZF9oZWFkZXJzX2ZhaWx1cmVzKGhhbmRsZSwgJnBhcnNpbmdfZmFp
bHVyZXMpOw0KPg0KPiBIZXJlIHdlIHNob3VsZCBkbzoNCj4NCj4gICAgICAgICAgICAgICAgIHJl
dCA9IHRyYWNlY21kX3JlYWRfaGVhZGVycyhoYW5kbGUpOw0KPg0KPiA+ICAgICAgICAgICAgICAg
aWYgKGNoZWNrX2V2ZW50X3BhcnNpbmcpIHsNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgaWYg
KHJldCB8fCB0ZXBfZ2V0X3BhcnNpbmdfZmFpbHVyZXMocGV2ZW50KSkNCj4NCj4gICAgICAgICAg
ICAgICAgICAgICAgICAgaWYgKHJldCB8fCB0cmFjZWNtZF9nZXRfcGFyc2luZ19mYWlsdXJlcyho
YW5kbGUpKQ0KPg0KPiAtLSBTdGV2ZQ0KPg0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBpZiAo
cmV0IHx8IHBhcnNpbmdfZmFpbHVyZXMpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgZXhpdChFSU5WQUwpOw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICBlbHNlDQo+ID4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgZXhpdCgwKTsNCj4NCg0KDQotLSANCg0KVHp2ZXRv
bWlyIChDZWNvKSBTdG95YW5vdg0KVk13YXJlIE9wZW4gU291cmNlIFRlY2hub2xvZ3kgQ2VudGVy
DQo=
