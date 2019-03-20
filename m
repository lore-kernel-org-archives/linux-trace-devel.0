Return-Path: <SRS0=0SC1=RX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 657A3C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Mar 2019 14:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10364213F2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Mar 2019 14:14:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="pkM7LeRO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfCTOOH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:14:07 -0400
Received: from mail-eopbgr810078.outbound.protection.outlook.com ([40.107.81.78]:6016
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726067AbfCTOOH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 10:14:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jD+lusofGff7CEzkxTLU3okIhz/W2lBQyMr6vTRobfw=;
 b=pkM7LeRODaMFdmTQdnu2AWOPdXNY4gddWAaEKVs74MIoknXO7khK0eIxNn5Bl8Nl5QYMKK3uO0AuWb8iET8PAowaM5SQIQ25Vmruve/0oamb3rItCNvMx6ag2j75FyS6mqA7ZGelAQNXYnt/3vjqqb4zqXfHQ0FOiB9Y0UcTKV4=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2730.namprd05.prod.outlook.com (10.167.18.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.8; Wed, 20 Mar 2019 14:14:03 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec%4]) with mapi id 15.20.1730.013; Wed, 20 Mar 2019
 14:14:03 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Matt Helsley <mhelsley@vmware.com>
CC:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 5/9] trace-cmd: Refactored few functions in
 trace-record.c
Thread-Topic: [PATCH v7 5/9] trace-cmd: Refactored few functions in
 trace-record.c
Thread-Index: AQHU3mxTAEBUeJy+d06A42BJvaYIFqYTREwAgAFNHAA=
Date:   Wed, 20 Mar 2019 14:14:03 +0000
Message-ID: <CACqStodWOOPAi0Y36Xp5u=Ny0e+acmys=HUV4qxLB+3sqeAPBw@mail.gmail.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
 <20190319155536.19381-6-tstoyanov@vmware.com>
 <0FEA60D5-2542-498E-A494-C15B0B2AE0A4@vmware.com>
In-Reply-To: <0FEA60D5-2542-498E-A494-C15B0B2AE0A4@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR05CA0027.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::40) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAXlbCgxO199QYy5SJ5ThIC3gNa6z4nFTvTdxPRZaWZWccXWj/mi
        gsQ2nc0gMVb9FSSRJAx6NUjk0c5jFRgbxzQE2x8=
x-google-smtp-source: APXvYqyKfHswBlc0SFw63WvTI7uw49B1MAMriVgSNjNbdx+AskWuQLgcoSOH2FeQRHLie+C7bB6K/bPCmpF9e0WM71U=
x-received: by 2002:a1c:1a46:: with SMTP id a67mr8087736wma.21.1553091236299;
 Wed, 20 Mar 2019 07:13:56 -0700 (PDT)
x-gmail-original-message-id: <CACqStodWOOPAi0Y36Xp5u=Ny0e+acmys=HUV4qxLB+3sqeAPBw@mail.gmail.com>
x-originating-ip: [209.85.128.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61db7a67-0bf7-46e8-3721-08d6ad3e4dd7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2730;
x-ms-traffictypediagnostic: CY1PR05MB2730:
x-microsoft-antispam-prvs: <CY1PR05MB273047CDE937C4041006580EDC410@CY1PR05MB2730.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(39860400002)(136003)(346002)(396003)(189003)(199004)(8676002)(476003)(6116002)(6486002)(61266001)(105586002)(53936002)(6246003)(98316002)(486006)(229853002)(6436002)(9686003)(66066001)(68736007)(81166006)(305945005)(5660300002)(11346002)(6512007)(498394004)(7736002)(81156014)(106356001)(61726006)(316002)(14454004)(76176011)(54906003)(446003)(95326003)(99286004)(186003)(2906002)(6346003)(52116002)(53546011)(6862004)(26005)(386003)(6506007)(256004)(478600001)(14444005)(8936002)(71200400001)(55446002)(86362001)(3846002)(6636002)(4326008)(97736004)(71190400001)(102836004)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2730;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: w/tn1svd1igWm14aGJ3LNSwyxfuR4UvyU1uBgeNyKR2Q02CRcEAo0WM9+lXx0fXh7PW6iL6LZwc+i8iCDmtdeVsFrIsVohZePGZ5bWrCJEdEDiUnKOsT0Iznaj58It4CiRTCyoLbv6KelvpTy+fh9MAnikv3F0qNbgVZ4PjFIyqQ6ZnTlMRBtoUkj0uJKcRoyNzzHHAuZJKbcr540MeumcxYJ97ykQwWFr6CEIBUdX21ymnkzIn2dp+YRfkYnpQYObA2Rg5X62e1woRsA0OvQ+oWonMrosyVFnGpflIR0Sb2gl35p+RgN1KRmcC1IuErOLNzAtoym9M6sT3hBRgiGV8sQsLkVT31trl6IxFliXb4R335yuk+j6SCItt2Xrhcm6YR9WGR3almjJ12BAOoDni/eX5Fjq7fZEQZCfAvG4I=
Content-Type: text/plain; charset="utf-8"
Content-ID: <282C7755ABC8B54CACE944C9A9DDDE97@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61db7a67-0bf7-46e8-3721-08d6ad3e4dd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 14:14:03.0405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2730
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCBNYXIgMTksIDIwMTkgYXQgODoyMSBQTSBNYXR0IEhlbHNsZXkgPG1oZWxzbGV5QHZt
d2FyZS5jb20+IHdyb3RlOg0KPg0KPg0KPg0KPiA+IE9uIE1hciAxOSwgMjAxOSwgYXQgODo1NSBB
TSwgVHp2ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJlLmNvbT4gd3JvdGU6DQo+ID4N
Cj4gPiBJbiBvcmRlciB0byByZXVzZSB0aGUgY29kZSBpbnNpZGUgdGhlIHRyYWNlLWNtZCBhcHBs
aWNhdGlvbiwgZmV3DQo+ID4gZnVuY3Rpb25zIGZyb20gdHJhY2UtcmVjb3JkLmMgYXJlIHJlZmFj
dG9yZWQ6DQo+ID4gIC0gbWFrZV9pbnN0YW5jZXMoKSBhbmQgdHJhY2VjbWRfcmVtb3ZlX2luc3Rh
bmNlcygpIGFyZSBzcGxpdGVkLg0KPiA+IE5ldyBvbmVzIGFyZSBjcmVhdGVkOiB0cmFjZWNtZF9t
YWtlX2luc3RhbmNlKCkgYW5kIHRyYWNlY21kX3JlbW92ZV9pbnN0YW5jZSgpLA0KPiA+IHdoaWNo
IGFyZSB2aXNpYmxlIG91dHNpZGUgdGhlIHRyYWNlLXJlY29yZC5jDQo+ID4gIC0gRm9sbG93aW5n
IGZ1bmN0aW9ucyBhcmUgbWFkZSBub24tc3RhdGljOiB0cmFjZWNtZF9pbml0X2luc3RhbmNlKCkN
Cj4gPiBnZXRfaW5zdGFuY2VfZGlyKCksIHdyaXRlX2luc3RhbmNlX2ZpbGUoKSwgd3JpdGVfdHJh
Y2luZ19vbigpLA0KPiA+IHRyYWNlY21kX3NldF9jbG9jaygpDQo+ID4gIC0gTmV3IGZ1bmN0aW9u
IGlzIGltcGxlbWVudGVkOiB0cmFjZWNtZF9sb2NhbF9jcHVfY291bnQoKSwgYW4gaW50ZXJuYWwN
Cj4gPiBBUEkgdG8gZ2V0IGxvY2FsX2NwdV9jb3VudC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IFR6dmV0b21pciBTdG95YW5vdiA8dHN0b3lhbm92QHZtd2FyZS5jb20+DQo+ID4gLS0tDQo+ID4g
dHJhY2VjbWQvaW5jbHVkZS90cmFjZS1sb2NhbC5oIHwgIDkgKysrKw0KPiA+IHRyYWNlY21kL3Ry
YWNlLXJlY29yZC5jICAgICAgICB8IDg3ICsrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0t
LS0NCj4gPiAyIGZpbGVzIGNoYW5nZWQsIDU4IGluc2VydGlvbnMoKyksIDM4IGRlbGV0aW9ucygt
KQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL3RyYWNlY21kL2luY2x1ZGUvdHJhY2UtbG9jYWwuaCBi
L3RyYWNlY21kL2luY2x1ZGUvdHJhY2UtbG9jYWwuaA0KPiA+IGluZGV4IGQ3YmRiMWYuLjg0MTMw
NTQgMTAwNjQ0DQo+ID4gLS0tIGEvdHJhY2VjbWQvaW5jbHVkZS90cmFjZS1sb2NhbC5oDQo+ID4g
KysrIGIvdHJhY2VjbWQvaW5jbHVkZS90cmFjZS1sb2NhbC5oDQo+ID4gQEAgLTIzNSw2ICsyMzUs
MTUgQEAgdm9pZCB1cGRhdGVfZmlyc3RfaW5zdGFuY2Uoc3RydWN0IGJ1ZmZlcl9pbnN0YW5jZSAq
aW5zdGFuY2UsIGludCB0b3B0KTsNCj4gPiB2b2lkIHNob3dfaW5zdGFuY2VfZmlsZShzdHJ1Y3Qg
YnVmZmVyX2luc3RhbmNlICppbnN0YW5jZSwgY29uc3QgY2hhciAqbmFtZSk7DQo+ID4NCj4gPiBp
bnQgY291bnRfY3B1cyh2b2lkKTsNCj4gPiArdm9pZCB3cml0ZV90cmFjaW5nX29uKHN0cnVjdCBi
dWZmZXJfaW5zdGFuY2UgKmluc3RhbmNlLCBpbnQgb24pOw0KPiA+ICtjaGFyICpnZXRfaW5zdGFu
Y2VfZGlyKHN0cnVjdCBidWZmZXJfaW5zdGFuY2UgKmluc3RhbmNlKTsNCj4gPiAraW50IHdyaXRl
X2luc3RhbmNlX2ZpbGUoc3RydWN0IGJ1ZmZlcl9pbnN0YW5jZSAqaW5zdGFuY2UsDQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgIGNvbnN0IGNoYXIgKmZpbGUsIGNvbnN0IGNoYXIgKnN0ciwgY29u
c3QgY2hhciAqdHlwZSk7DQo+ID4gK3ZvaWQgdHJhY2VjbWRfaW5pdF9pbnN0YW5jZShzdHJ1Y3Qg
YnVmZmVyX2luc3RhbmNlICppbnN0YW5jZSk7DQo+ID4gK3ZvaWQgdHJhY2VjbWRfbWFrZV9pbnN0
YW5jZShzdHJ1Y3QgYnVmZmVyX2luc3RhbmNlICppbnN0YW5jZSk7DQo+ID4gK2ludCB0cmFjZWNt
ZF9sb2NhbF9jcHVfY291bnQodm9pZCk7DQo+ID4gK3ZvaWQgdHJhY2VjbWRfc2V0X2Nsb2NrKHN0
cnVjdCBidWZmZXJfaW5zdGFuY2UgKmluc3RhbmNlKTsNCj4gPiArdm9pZCB0cmFjZWNtZF9yZW1v
dmVfaW5zdGFuY2Uoc3RydWN0IGJ1ZmZlcl9pbnN0YW5jZSAqaW5zdGFuY2UpOw0KPiA+DQo+ID4g
LyogTm8gbG9uZ2VyIGluIGV2ZW50LXV0aWxzLmggKi8NCj4gPiB2b2lkIF9fbm9yZXR1cm4gZGll
KGNvbnN0IGNoYXIgKmZtdCwgLi4uKTsgLyogQ2FuIGJlIG92ZXJyaWRlbiAqLw0KPiA+IGRpZmYg
LS1naXQgYS90cmFjZWNtZC90cmFjZS1yZWNvcmQuYyBiL3RyYWNlY21kL3RyYWNlLXJlY29yZC5j
DQo+ID4gaW5kZXggMTc3MDYwZC4uMzk1MDI0MiAxMDA2NDQNCj4gPiAtLS0gYS90cmFjZWNtZC90
cmFjZS1yZWNvcmQuYw0KPiA+ICsrKyBiL3RyYWNlY21kL3RyYWNlLXJlY29yZC5jDQo+ID4NCj4N
Cj4gPHNuaXBwZWQ+DQo+DQo+ID4gLXN0YXRpYyB2b2lkIHNldF9jbG9jayhzdHJ1Y3QgYnVmZmVy
X2luc3RhbmNlICppbnN0YW5jZSkNCj4gPiArdm9pZCB0cmFjZWNtZF9zZXRfY2xvY2soc3RydWN0
IGJ1ZmZlcl9pbnN0YW5jZSAqaW5zdGFuY2UpDQo+ID4gew0KPiA+ICAgICAgIGNoYXIgKnBhdGg7
DQo+ID4gICAgICAgY2hhciAqY29udGVudDsNCj4gPiBAQCAtNDMxNiw0OSArNDMxNCw1NyBAQCBz
dGF0aWMgdm9pZCBjbGVhcl9mdW5jX2ZpbHRlcnModm9pZCkNCj4gPiAgICAgICB9DQo+ID4gfQ0K
PiA+DQo+ID4gLXN0YXRpYyB2b2lkIG1ha2VfaW5zdGFuY2VzKHZvaWQpDQo+ID4gK3ZvaWQgdHJh
Y2VjbWRfbWFrZV9pbnN0YW5jZShzdHJ1Y3QgYnVmZmVyX2luc3RhbmNlICppbnN0YW5jZSkNCj4g
PiB7DQo+ID4gLSAgICAgc3RydWN0IGJ1ZmZlcl9pbnN0YW5jZSAqaW5zdGFuY2U7DQo+ID4gICAg
ICAgc3RydWN0IHN0YXQgc3Q7DQo+ID4gICAgICAgY2hhciAqcGF0aDsNCj4gPiAgICAgICBpbnQg
cmV0Ow0KPiA+DQo+ID4gKyAgICAgcGF0aCA9IGdldF9pbnN0YW5jZV9kaXIoaW5zdGFuY2UpOw0K
PiA+ICsgICAgIHJldCA9IHN0YXQocGF0aCwgJnN0KTsNCj4gPiArICAgICBpZiAocmV0IDwgMCkg
ew0KPiA+ICsgICAgICAgICAgICAgcmV0ID0gbWtkaXIocGF0aCwgMDc3Nyk7DQo+DQo+IEhlcmUg
aXMgdGhlIG1rZGlyIC4uLg0KPg0KPiA+ICsgICAgICAgICAgICAgaWYgKHJldCA8IDApDQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgIGRpZSgibWtkaXIgJXMiLCBwYXRoKTsNCj4gPiArICAgICB9
IGVsc2UNCj4gPiArICAgICAgICAgICAgIC8qIERvbid0IGRlbGV0ZSBpbnN0YW5jZXMgdGhhdCBh
bHJlYWR5IGV4aXN0ICovDQo+ID4gKyAgICAgICAgICAgICBpbnN0YW5jZS0+ZmxhZ3MgfD0gQlVG
RkVSX0ZMX0tFRVA7DQo+ID4gKyAgICAgdHJhY2VjbWRfcHV0X3RyYWNpbmdfZmlsZShwYXRoKTsN
Cj4gPiArDQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyB2b2lkIG1ha2VfaW5zdGFuY2VzKHZv
aWQpDQo+ID4gK3sNCj4gPiArICAgICBzdHJ1Y3QgYnVmZmVyX2luc3RhbmNlICppbnN0YW5jZTsN
Cj4gPiArDQo+ID4gICAgICAgZm9yX2VhY2hfaW5zdGFuY2UoaW5zdGFuY2UpIHsNCj4gPiAgICAg
ICAgICAgICAgIGlmIChpc19ndWVzdChpbnN0YW5jZSkpDQo+ID4gICAgICAgICAgICAgICAgICAg
ICAgIGNvbnRpbnVlOw0KPiA+ICsgICAgICAgICAgICAgdHJhY2VjbWRfbWFrZV9pbnN0YW5jZShp
bnN0YW5jZSk7DQo+ID4gKyAgICAgfQ0KPiA+ICt9DQo+ID4NCj4gPiAtICAgICAgICAgICAgIHBh
dGggPSBnZXRfaW5zdGFuY2VfZGlyKGluc3RhbmNlKTsNCj4gPiAtICAgICAgICAgICAgIHJldCA9
IHN0YXQocGF0aCwgJnN0KTsNCj4gPiAtICAgICAgICAgICAgIGlmIChyZXQgPCAwKSB7DQo+ID4g
LSAgICAgICAgICAgICAgICAgICAgIHJldCA9IG1rZGlyKHBhdGgsIDA3NzcpOw0KPiA+IC0gICAg
ICAgICAgICAgICAgICAgICBpZiAocmV0IDwgMCkNCj4gPiAtICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBkaWUoIm1rZGlyICVzIiwgcGF0aCk7DQo+ID4gLSAgICAgICAgICAgICB9IGVsc2UN
Cj4gPiAtICAgICAgICAgICAgICAgICAgICAgLyogRG9uJ3QgZGVsZXRlIGluc3RhbmNlcyB0aGF0
IGFscmVhZHkgZXhpc3QgKi8NCj4gPiAtICAgICAgICAgICAgICAgICAgICAgaW5zdGFuY2UtPmZs
YWdzIHw9IEJVRkZFUl9GTF9LRUVQOw0KPiA+IC0gICAgICAgICAgICAgdHJhY2VjbWRfcHV0X3Ry
YWNpbmdfZmlsZShwYXRoKTsNCj4gPiArdm9pZCB0cmFjZWNtZF9yZW1vdmVfaW5zdGFuY2Uoc3Ry
dWN0IGJ1ZmZlcl9pbnN0YW5jZSAqaW5zdGFuY2UpDQo+ID4gK3sNCj4gPiArICAgICBjaGFyICpw
YXRoOw0KPiA+ICsNCj4gPiArICAgICBpZiAoaW5zdGFuY2UtPnRyYWNpbmdfb25fZmQgPiAwKSB7
DQo+ID4gKyAgICAgICAgICAgICBjbG9zZShpbnN0YW5jZS0+dHJhY2luZ19vbl9mZCk7DQo+ID4g
KyAgICAgICAgICAgICBpbnN0YW5jZS0+dHJhY2luZ19vbl9mZCA9IDA7DQo+ID4gICAgICAgfQ0K
PiA+ICsgICAgIHBhdGggPSBnZXRfaW5zdGFuY2VfZGlyKGluc3RhbmNlKTsNCj4gPiArICAgICB0
cmFjZWNtZF9wdXRfdHJhY2luZ19maWxlKHBhdGgpOw0KPiA+IH0NCj4gPg0KPiA+IHZvaWQgdHJh
Y2VjbWRfcmVtb3ZlX2luc3RhbmNlcyh2b2lkKQ0KPiA+IHsNCj4gPiAgICAgICBzdHJ1Y3QgYnVm
ZmVyX2luc3RhbmNlICppbnN0YW5jZTsNCj4gPiAtICAgICBjaGFyICpwYXRoOw0KPiA+IC0gICAg
IGludCByZXQ7DQo+ID4NCj4gPiAgICAgICBmb3JfZWFjaF9pbnN0YW5jZShpbnN0YW5jZSkgew0K
PiA+ICAgICAgICAgICAgICAgLyogT25seSBkZWxldGUgd2hhdCB3ZSBjcmVhdGVkICovDQo+ID4g
ICAgICAgICAgICAgICBpZiAoaXNfZ3Vlc3QoaW5zdGFuY2UpIHx8IChpbnN0YW5jZS0+ZmxhZ3Mg
JiBCVUZGRVJfRkxfS0VFUCkpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0K
PiA+IC0gICAgICAgICAgICAgaWYgKGluc3RhbmNlLT50cmFjaW5nX29uX2ZkID4gMCkgew0KPiA+
IC0gICAgICAgICAgICAgICAgICAgICBjbG9zZShpbnN0YW5jZS0+dHJhY2luZ19vbl9mZCk7DQo+
ID4gLSAgICAgICAgICAgICAgICAgICAgIGluc3RhbmNlLT50cmFjaW5nX29uX2ZkID0gMDsNCj4g
PiAtICAgICAgICAgICAgIH0NCj4gPiAtICAgICAgICAgICAgIHBhdGggPSBnZXRfaW5zdGFuY2Vf
ZGlyKGluc3RhbmNlKTsNCj4gPiAtICAgICAgICAgICAgIHJldCA9IHJtZGlyKHBhdGgpOw0KPg0K
PiBCdXQgdGhpcyBybWRpciBpcyBub3QgbW92ZWQgdG8gdHJhY2VjbWRfcmVtb3ZlX2luc3RhbmNl
KCkg4oCUIGl04oCZcyBsb3N0LiBUaGlzIGxvb2tzIGxpa2UgaXTigJlzIGludHJvZHVjaW5nIGEg
YnVnLg0KDQpUaGFua3MgTWF0dCwgdGhpcyBvbmUgaXMgZnJvbSB2MSBvZiB0aGUgcGF0Y2hzZXQs
IEkgZGlkbid0IG5vdGljZSBpdC4NCkknbGwgYWRkIHRoZSBybWRpcigpIGNhbGwgaW4gdGhlIG5l
eHQgdmVyc2lvbi4NClRoZXJlIGlzIHNvbWUgZ2VuZXJhbCBwcm9ibGVtIHdpdGggZGVsZXRpbmcg
aW5zdGFuY2VzLCBvciAobW9zdA0KcHJvYmFibHkpIEkgY2Fubm90IGZpZ3VyZSBvdXQgd2hhdCBp
dCB0aGUgcHJvcGVyIHdheQ0KdG8gZGVsZXRlIGEgZnRyYWNlIGluc3RhbmNlIC0gZXZlbiBhZnRl
ciB0aGUgY2FsbCB0byBybWRpcigpIGluDQp0cmFjZWNtZF9yZW1vdmVfaW5zdGFuY2UoKSwgdGhl
IGluc3RhbmNlIGRpciBpcyBzdGlsbCB0aGVyZS4NCkkgdHJpZWQgdG8gcnVuICJybSAtcmYgcGF0
aF90b19pbnN0YW5jZV9kaXIiIGZyb20gdGhlIHNoZWxsIChhdCByb290KSwNCmFmdGVyIHRoZSB0
cmFjZS1jbWQgaXMgZXhlY3V0ZWQsIGdvdCBhIGxvdCBvZg0KIk9wZXJhdGlvbiBub3QgcGVybWl0
dGVkIiBlcnJvcnMgYW5kIHRoZSBpbnN0YW5jZSBkaXIgaXMgbm90IGRlbGV0ZWQuDQoNCj4NCj4g
PiAtICAgICAgICAgICAgIGlmIChyZXQgPCAwKQ0KPiA+IC0gICAgICAgICAgICAgICAgICAgICBk
aWUoInJtZGlyICVzIiwgcGF0aCk7DQo+ID4gLSAgICAgICAgICAgICB0cmFjZWNtZF9wdXRfdHJh
Y2luZ19maWxlKHBhdGgpOw0KPiA+ICsgICAgICAgICAgICAgdHJhY2VjbWRfcmVtb3ZlX2luc3Rh
bmNlKGluc3RhbmNlKTsNCj4gPiAgICAgICB9DQo+ID4gfQ0KPg0KPiA8c25pcHBlZD4NCj4NCj4g
VGhlIHJlc3QgbG9va3MgZmluZS4NCj4NCj4gQ2hlZXJzLA0KPiAgICAgICAtTWF0dCBIZWxzbGV5
DQo+DQoNCg0KLS0gDQoNClR6dmV0b21pciAoQ2VjbykgU3RveWFub3YNClZNd2FyZSBPcGVuIFNv
dXJjZSBUZWNobm9sb2d5IENlbnRlcg0K
