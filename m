Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 774B6C3A5A2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 16:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CC46208C0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 16:06:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="nObFcrgT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389205AbfITQG1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 12:06:27 -0400
Received: from mail-eopbgr700064.outbound.protection.outlook.com ([40.107.70.64]:36173
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387964AbfITQG0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 12:06:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYWvMPuLVK/F8PK6ApSfQMA/1jAUDEyc2H7yalAlSCNUs6hvFsJz0IrBIl2l0Wu099t5MxfXy/4dQ2UBJqIdVZHWLvz/a5Zy9inSCMmZoG2NhM29Ks2EGwcDAq1yueLh3EvAwxgTx83vUad321UaCOrkzu6Xc7Mp37tlS8HuFYLwcmoXI6AcLm4l0/wUBNXG0fxIPs8DXxyIGidiWgvaABY9E13CMvARzJEbyjuh6V9twhrGbpgBFlJ4GF0mfwTBslTTDfd0n5MDkfpXHcaEQtINC6Xllb4a5Z+xDhr/0UI3er67yvjA+ezMkQthFR44nucxZF3W+nl6iOIwMiZgEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FnGA3yn+wiMuJxINmiw/IOq8xWH5QNrjYJZrvSyy8g=;
 b=cMmEJU5Pdlt2ci/GMPTE/uD6XnCO2QY6suHHcRXc+hjNrVc6umYz1nABzr+DMrCV9XEhBPyEgZuAM3YjZUbJRCHeuaET2GNfywv8E+pJv9odqM8XZC4SVPa4iEIMN7159EGO8/bjJCJz7kAibEaDfbkiWgMsPbHv9laFvv/j/9fIFW53E8iNHSuGcka116q7lqWt7xXMxd85tT5SRZkiZWTOhVxHr9rIMup21M0Axqzh/VIb59+a5q1yRVGvN0bSUyZABkHocB+chvV2Ge1UjA75Lzzcgy3n/IvUfcIinrDxbN05u6ln6dbBHeavzvtA4wfiBu7PPfiRjN+v6cycnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FnGA3yn+wiMuJxINmiw/IOq8xWH5QNrjYJZrvSyy8g=;
 b=nObFcrgTyxfOwPFY6UXS9YLv7z4Vho0m1iB2uWbhlMar5/RZfW4w8zmjHFrpNX/BH9Nytzd/JgZ509ATyAqY8OU12XJVIe1nJZhJ235zCiD8QfV7C9j9sIJyuyHV5HLPQ+ZajYcFGxKx/xEEVG8Mz+UwlAPdGEIyhb55V49b40w=
Received: from SN6PR05MB4045.namprd05.prod.outlook.com (52.135.66.139) by
 SN6PR05MB4080.namprd05.prod.outlook.com (52.135.66.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.17; Fri, 20 Sep 2019 16:06:24 +0000
Received: from SN6PR05MB4045.namprd05.prod.outlook.com
 ([fe80::5dd0:4ccb:3dbf:91f9]) by SN6PR05MB4045.namprd05.prod.outlook.com
 ([fe80::5dd0:4ccb:3dbf:91f9%7]) with mapi id 15.20.2284.009; Fri, 20 Sep 2019
 16:06:24 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 4/5] libtraceevent, perf tools: Changes in
 tep_print_event_* APIs
Thread-Topic: [PATCH 4/5] libtraceevent, perf tools: Changes in
 tep_print_event_* APIs
Thread-Index: AQHVbcWPYaCArkZ+GUaSaBvBli7q7KczncEAgAEhTAA=
Date:   Fri, 20 Sep 2019 16:06:23 +0000
Message-ID: <CACqStococL=0ty5OGwAx9Xs7mHhXUpoGdN8qXQTKMJbZnBq3Yw@mail.gmail.com>
References: <20190918020334.344561631@goodmis.org>
 <20190918020530.818038260@goodmis.org>
 <20190919185036.6fde0c6b@gandalf.local.home>
In-Reply-To: <20190919185036.6fde0c6b@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR05CA0096.eurprd05.prod.outlook.com
 (2603:10a6:208:136::36) To SN6PR05MB4045.namprd05.prod.outlook.com
 (2603:10b6:805:26::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAU8jOnb6GdCHrfq4fXNPLfDJTjOMK6Q9Q05af1RmW9OW+FNNhmS
        TUt9j7h/IImTQoQjtfilRyq+e6/Xpyaqu9T2VLY=
x-google-smtp-source: APXvYqxpatVjFk3BCTdn1Mqrc56qJw8fpA8SaopOCAUdgVM1kIwhXnFR93sH2N/enQ+Ky9hsUH88lar7sYHC1lN+DHA=
x-received: by 2002:adf:e5c2:: with SMTP id a2mr11600932wrn.320.1568995577219;
 Fri, 20 Sep 2019 09:06:17 -0700 (PDT)
x-gmail-original-message-id: <CACqStococL=0ty5OGwAx9Xs7mHhXUpoGdN8qXQTKMJbZnBq3Yw@mail.gmail.com>
x-originating-ip: [209.85.221.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09dfd721-655b-4d04-235d-08d73de47b6d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN6PR05MB4080;
x-ms-traffictypediagnostic: SN6PR05MB4080:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <SN6PR05MB408083EE305EC066DA5FB32CDC880@SN6PR05MB4080.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0166B75B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(346002)(136003)(376002)(199004)(189003)(102836004)(66556008)(66476007)(66446008)(64756008)(186003)(53546011)(4326008)(66946007)(476003)(386003)(6506007)(446003)(95326003)(256004)(61266001)(26005)(11346002)(66066001)(45080400002)(14454004)(8936002)(478600001)(81166006)(81156014)(5660300002)(486006)(55446002)(99286004)(52116002)(76176011)(8676002)(966005)(86362001)(7736002)(25786009)(6246003)(71200400001)(71190400001)(305945005)(6862004)(6116002)(3846002)(316002)(9686003)(6486002)(6436002)(498394004)(6306002)(229853002)(6512007)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB4080;H:SN6PR05MB4045.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 73bYCwxvTloM8AypNkJU/SK8uod5oSJy+0QJ/eHv6QfGhK0UTOAhlCIfzZeTEz9jEpkru60Tp6iSyTuUGJdQTZ9oStiezqjzAIbjRUl/kGuireKQNKbBcDONglxGcu8nzeOdZQBfnUL5nK2KcMDOCYCmh20Vww2fU7wbe3+VvJLgAdJpAXcDzs/Fw9dY+Gmp+VWZ87SxhtoDqaN5VlHQHCdeo/+TaG8sJyn7R0arZNFWriAHm7oPm45g4VYFzvIuL5NyT1vFhnRe+PdVEGPOpRPn2HkrR6MuqCuKGssvnzd/6tdKJylmlpbmMOVeiklIVK6PtRxv/wEO087DxCUvKMaJfw1rX2lShH9Dg3idaSjHnDJTNsOIe/9imihHBF/42MDPYYRrRq516uufeKRE3XVPPFv0q35bMmg6h+QQS40=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0F4B4E66BB669649997E93999662A9D0@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09dfd721-655b-4d04-235d-08d73de47b6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2019 16:06:23.3259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z2i1FEUU8ymY/T2VXDiu96IF1UNdppSbtBZAd1JKfe6hvJTUjkeElk93oZPhuKS+Th5bF/XglRhuPjzidfKlFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB4080
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gRnJpLCBTZXAgMjAsIDIwMTkgYXQgMTo1MCBBTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IE9uIFR1ZSwgMTcgU2VwIDIwMTkgMjI6MDM6MzggLTA0
MDANCj4gU3RldmVuIFJvc3RlZHQgPHJvc3RlZHRAZ29vZG1pcy5vcmc+IHdyb3RlOg0KPg0KPiA+
IEZyb206IFR6dmV0b21pciBTdG95YW5vdiA8dHN0b3lhbm92QHZtd2FyZS5jb20+DQo+ID4NCj4g
PiBMaWJ0cmFjZWV2ZW50IEFQSXMgZm9yIHByaW50aW5nIHZhcmlvdXMgdHJhY2UgZXZlbnRzIGlu
Zm9ybWF0aW9uIGFyZQ0KPiA+IGNvbXBsaWNhdGVkLCB0aGVyZSBhcmUgY29tcGxleCBleHRyYSBw
YXJhbWV0ZXJzLiBUbyBjb250cm9sIHRoZSB3YXkNCj4gPiBldmVudCBpbmZvcm1hdGlvbiBpcyBw
cmludGVkLCB0aGUgdXNlciBzaG91bGQgY2FsbCBhIHNldCBvZiBmdW5jdGlvbnMgaW4NCj4gPiBh
IHNwZWNpZmljIHNlcXVlbmNlLg0KPiA+DQo+ID4gVGhlc2UgQVBJcyBhcmUgcmVpbXBsZW1lbnRl
ZCB0byBwcm92aWRlIGEgbW9yZSBzaW1wbGUgaW50ZXJmYWNlIGZvcg0KPiA+IHByaW50aW5nIGV2
ZW50IGluZm9ybWF0aW9uLg0KPiA+DQo+ID4gUmVtb3ZlZCBBUElzOg0KPiA+DQo+ID4gICAgICAg
dGVwX3ByaW50X2V2ZW50X3Rhc2soKQ0KPiA+ICAgICAgIHRlcF9wcmludF9ldmVudF90aW1lKCkN
Cj4gPiAgICAgICB0ZXBfcHJpbnRfZXZlbnRfZGF0YSgpDQo+ID4gICAgICAgdGVwX2V2ZW50X2lu
Zm8oKQ0KPiA+ICAgICAgIHRlcF9pc19sYXRlbmN5X2Zvcm1hdCgpDQo+ID4gICAgICAgdGVwX3Nl
dF9sYXRlbmN5X2Zvcm1hdCgpDQo+ID4gICAgICAgdGVwX2RhdGFfbGF0ZW5jeV9mb3JtYXQoKQ0K
PiA+ICAgICAgIHRlcF9zZXRfcHJpbnRfcmF3KCkNCj4gPg0KPiA+IEEgbmV3IEFQSSBmb3IgcHJp
bnRpbmcgZXZlbnQgaW5mb3JtYXRpb24gaXMgaW50cm9kdWNlZDoNCj4gPiAgICB2b2lkIHRlcF9w
cmludF9ldmVudChzdHJ1Y3QgdGVwX2hhbmRsZSAqdGVwLCBzdHJ1Y3QgdHJhY2Vfc2VxICpzLA0K
PiA+ICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgdGVwX3JlY29yZCAqcmVjb3JkLCBjb25z
dCBjaGFyICpmbXQsIC4uLik7DQo+ID4gd2hlcmUgImZtdCIgaXMgYSBwcmludGYtbGlrZSBmb3Jt
YXQgc3RyaW5nLCBmb2xsb3dlZCBieSB0aGUgZXZlbnQNCj4gPiBmaWVsZHMgdG8gYmUgcHJpbnRl
ZC4gU3VwcG9ydGVkIGZpZWxkczoNCj4gPiAgVEVQX1BSSU5UX1BJRCwgIiVkIiAtIGV2ZW50IFBJ
RA0KPiA+ICBURVBfUFJJTlRfQ1BVLCAiJWQiIC0gZXZlbnQgQ1BVDQo+ID4gIFRFUF9QUklOVF9D
T01NLCAiJXMiIC0gZXZlbnQgY29tbWFuZCBzdHJpbmcNCj4gPiAgVEVQX1BSSU5UX05BTUUsICIl
cyIgLSBldmVudCBuYW1lDQo+ID4gIFRFUF9QUklOVF9MQVRFTkNZLCAiJXMiIC0gZXZlbnQgbGF0
ZW5jeQ0KPiA+ICBURVBfUFJJTlRfVElNRSwgJWQgLSBldmVudCB0aW1lIHN0YW1wLiBBIGRpdmlz
b3IgYW5kIHByZWNpc2lvbg0KPiA+ICAgIGNhbiBiZSBzcGVjaWZpZWQgYXMgcGFydCBvZiB0aGlz
IGZvcm1hdCBzdHJpbmc6DQo+ID4gICAgIiVwcmVjaXNpb24uZGl2aXNvcmQiLiBFeGFtcGxlOg0K
PiA+ICAgICIlMy4xMDAwZCIgLSBkaXZpZGUgdGhlIHRpbWUgYnkgMTAwMCBhbmQgcHJpbnQgdGhl
IGZpcnN0IDMgZGlnaXRzDQo+ID4gICAgYmVmb3JlIHRoZSBkb3QuIFRodXMsIHRoZSB0aW1lIHN0
YW1wICIxMjM0NTYwMDAiIHdpbGwgYmUgcHJpbnRlZCBhcw0KPiA+ICAgICIxMjMuNDU2Ig0KPiA+
ICBURVBfUFJJTlRfSU5GTywgIiVzIiAtIGV2ZW50IGluZm9ybWF0aW9uLg0KPiA+ICBURVBfUFJJ
TlRfSU5GT19SQVcsICIlcyIgLSBldmVudCBpbmZvcm1hdGlvbiwgaW4gcmF3IGZvcm1hdC4NCj4g
Pg0KPiA+IEV4YW1wbGU6DQo+ID4gICB0ZXBfcHJpbnRfZXZlbnQodGVwLCBzLCByZWNvcmQsICIl
MTZzLSUtNWQgWyUwM2RdICVzICU2LjEwMDBkICVzICVzIiwNCj4gPiAgICAgICAgICAgICAgICAg
VEVQX1BSSU5UX0NPTU0sIFRFUF9QUklOVF9QSUQsIFRFUF9QUklOVF9DUFUsDQo+ID4gICAgICAg
ICAgICAgICAgIFRFUF9QUklOVF9MQVRFTkNZLCBURVBfUFJJTlRfVElNRSwgVEVQX1BSSU5UX05B
TUUsIFRFUF9QUklOVF9JTkZPKTsNCj4gPiBPdXRwdXQ6DQo+ID4gICAgICAgbHMtMTEzMTQgWzAw
NV0gZC5oLiAxODUyMDcuMzY2MzgzIGZ1bmN0aW9uIF9fd2FrZV91cA0KPiA+DQo+ID4gU2lnbmVk
LW9mZi1ieTogVHp2ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJlLmNvbT4NCj4gPiBD
YzogQW5kcmV3IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4NCj4gPiBDYzogSmly
aSBPbHNhIDxqb2xzYUByZWRoYXQuY29tPg0KPiA+IENjOiBOYW1oeXVuZyBLaW0gPG5hbWh5dW5n
QGtlcm5lbC5vcmc+DQo+ID4gQ2M6IGxpbnV4LXRyYWNlLWRldmVsQHZnZXIua2VybmVsLm9yZw0K
PiA+IENjOiBQYXRyaWNrIE1jTGVhbiA8Y2h1dHpwYWhAZ2VudG9vLm9yZz4NCj4gPiBMaW5rOiBo
dHRwczovL25hbTA0LnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cCUz
QSUyRiUyRmxvcmUua2VybmVsLm9yZyUyRmxpbnV4LXRyYWNlLWRldmVsJTJGMjAxOTA4MDEwNzQ5
NTkuMjIwMjMtMi10ei5zdG95YW5vdiU0MGdtYWlsLmNvbSZhbXA7ZGF0YT0wMiU3QzAxJTdDdHN0
b3lhbm92JTQwdm13YXJlLmNvbSU3Q2I0M2UyOGY2MThkYjRkMWNjYzQ5MDhkNzNkNTNjYWViJTdD
YjM5MTM4Y2EzY2VlNGI0YWE0ZDZjZDgzZDlkZDYyZjAlN0MwJTdDMCU3QzYzNzA0NTMwMjQyMDUy
NTQwOSZhbXA7c2RhdGE9WFZ5JTJGcHJxU1ZrSFZVSjBWaTFnU2VRd25IbWM4MmtpcG5rTWJOJTJC
YVdtaUElM0QmYW1wO3Jlc2VydmVkPTANCj4gPiBMaW5rOiBodHRwczovL25hbTA0LnNhZmVsaW5r
cy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cCUzQSUyRiUyRmxvcmUua2VybmVsLm9y
ZyUyRmxrbWwlMkYyMDE5MDgwNTIwNDM1NS4wNDExMzIwMzAlNDBnb29kbWlzLm9yZyZhbXA7ZGF0
YT0wMiU3QzAxJTdDdHN0b3lhbm92JTQwdm13YXJlLmNvbSU3Q2I0M2UyOGY2MThkYjRkMWNjYzQ5
MDhkNzNkNTNjYWViJTdDYjM5MTM4Y2EzY2VlNGI0YWE0ZDZjZDgzZDlkZDYyZjAlN0MwJTdDMCU3
QzYzNzA0NTMwMjQyMDUzNTQwNiZhbXA7c2RhdGE9TGJ1VTdFZjJTbGJsNiUyQlZDdHc3RFJ6VjVU
UnA1R3JjZUQ2RSUyRlo4TGJHS00lM0QmYW1wO3Jlc2VydmVkPTANCj4gPiBTaWduZWQtb2ZmLWJ5
OiBBcm5hbGRvIENhcnZhbGhvIGRlIE1lbG8gPGFjbWVAcmVkaGF0LmNvbT4NCj4gPiBbIEFkZGVk
IHN1cHBvcnQgZm9yIHRyYWNlLWNtZCB0cmFjZS1yZWFkLmMgXQ0KPiA+IFNpZ25lZC1vZmYtYnk6
IFN0ZXZlbiBSb3N0ZWR0IChWTXdhcmUpIDxyb3N0ZWR0QGdvb2RtaXMub3JnPg0KPg0KPg0KPiBJ
IG5lZWRlZCB0byBtb2RpZnkgdGhpcyB3aXRoIHRoZSBmb2xsb3dpbmcgY2hhbmdlczoNCj4NCj4g
ZGlmZiAtLWdpdCBhL2tlcm5lbC1zaGFyay9zcmMvbGlia3NoYXJrLmMgYi9rZXJuZWwtc2hhcmsv
c3JjL2xpYmtzaGFyay5jDQo+IGluZGV4IDQ3ZWM5YzIxLi40MjA3YWU2ZiAxMDA2NDQNCj4gLS0t
IGEva2VybmVsLXNoYXJrL3NyYy9saWJrc2hhcmsuYw0KPiArKysgYi9rZXJuZWwtc2hhcmsvc3Jj
L2xpYmtzaGFyay5jDQo+IEBAIC0xMTAzLDcgKzExMDMsNyBAQCBzdGF0aWMgY29uc3QgY2hhciAq
a3NoYXJrX2dldF9sYXRlbmN5KHN0cnVjdCB0ZXBfaGFuZGxlICpwZSwNCj4gICAgICAgICAgICAg
ICAgIHJldHVybiBOVUxMOw0KPg0KPiAgICAgICAgIHRyYWNlX3NlcV9yZXNldCgmc2VxKTsNCj4g
LSAgICAgICB0ZXBfZGF0YV9sYXRlbmN5X2Zvcm1hdChwZSwgJnNlcSwgcmVjb3JkKTsNCj4gKyAg
ICAgICB0ZXBfcHJpbnRfZXZlbnQocGUsICZzZXEsIHJlY29yZCwgIiVzIiwgVEVQX1BSSU5UX0xB
VEVOQ1kpOw0KPiAgICAgICAgIHJldHVybiBzZXEuYnVmZmVyOw0KPiAgfQ0KPg0KPiBAQCAtMTEx
Nyw3ICsxMTE3LDcgQEAgc3RhdGljIGNvbnN0IGNoYXIgKmtzaGFya19nZXRfaW5mbyhzdHJ1Y3Qg
dGVwX2hhbmRsZSAqcGUsDQo+ICAgICAgICAgICAgICAgICByZXR1cm4gTlVMTDsNCj4NCj4gICAg
ICAgICB0cmFjZV9zZXFfcmVzZXQoJnNlcSk7DQo+IC0gICAgICAgdGVwX2V2ZW50X2luZm8oJnNl
cSwgZXZlbnQsIHJlY29yZCk7DQo+ICsgICAgICAgdGVwX3ByaW50X2V2ZW50KHBlLCAmc2VxLCBy
ZWNvcmQsICIlcyIsIFRFUF9QUklOVF9JTkZPKTsNCj4NCj4gICAgICAgICAvKg0KPiAgICAgICAg
ICAqIFRoZSBldmVudCBpbmZvIHN0cmluZyBjb250YWlucyBhIHRyYWlsaW5nIG5ld2xpbmUuDQo+
DQo+DQo+IC0tIFN0ZXZlDQoNCkNoYW5nZXMgbG9va3MgT0ssIHRoYW5rcyBTdGV2ZW4uDQpSZXZp
ZXdlZC1ieTogVHp2ZXRvbWlyIFN0b3lhbm92IChWTXdhcmUpIDx0ei5zdG95YW5vdkBnbWFpbC5j
b20+DQoNCg0KDQotLSANClR6dmV0b21pciAoQ2VjbykgU3RveWFub3YNClZNd2FyZSBPcGVuIFNv
dXJjZSBUZWNobm9sb2d5IENlbnRlcg0K
