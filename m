Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DFFC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 10:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 325152077B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 10:39:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="ZZpnixbV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbfCOKjh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 06:39:37 -0400
Received: from mail-eopbgr710081.outbound.protection.outlook.com ([40.107.71.81]:36447
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727578AbfCOKjf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 06:39:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0qJ60ADy4AJOPQ7LIyEA4+VjmoG92B6+Nrb28lTM20=;
 b=ZZpnixbVQsHuNie7cdIOdYYCCmJ6P7bUa70tyixIN4QqH3R8yurN65lcZ28WtDItP2tRHG8PxMSIlXCiiY4GkS8hwbKWASgqt2euZzXIKzOlSMx/mMyPdAGhJhk7ZAjM0gIS0tHGo9OJreDBsdjG9FQaxg8xl9ybud8iEBG/4vM=
Received: from CY1PR05MB2780.namprd05.prod.outlook.com (10.167.18.26) by
 CY1PR05MB2665.namprd05.prod.outlook.com (10.167.10.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.13; Fri, 15 Mar 2019 10:39:31 +0000
Received: from CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f]) by CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f%9]) with mapi id 15.20.1730.003; Fri, 15 Mar 2019
 10:39:31 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v6 1/9] trace-cmd: Implemented new lib API:
 tracecmd_local_events_system()
Thread-Topic: [PATCH v6 1/9] trace-cmd: Implemented new lib API:
 tracecmd_local_events_system()
Thread-Index: AQHU2xtf1AqodXYp+ES59xhtlrBSgg==
Date:   Fri, 15 Mar 2019 10:39:31 +0000
Message-ID: <CAE0o1Nt28njv4LVCRPf3ABam-4mD1315q-7CDypeG4dE9H5t=w@mail.gmail.com>
References: <20190315083754.27532-1-tstoyanov@vmware.com>
 <20190315083754.27532-2-tstoyanov@vmware.com>
In-Reply-To: <20190315083754.27532-2-tstoyanov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YTXPR0101CA0050.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:1::27) To CY1PR05MB2780.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAUXlv+qHTodzbtVj4LXnkkPKts3bRt34rq9mFVtKmjmg48UJOpT
        SwVZ/Au3RziYx0HOkI5i1Xz5l6D5M+C7/Fzskw==
x-google-smtp-source: APXvYqxYwHjWyfxHO1jAnhgMO8LSbV+nE1hE5ZKIfN8jHCy7qdGcHj728cTj5WBGEZjT2FnlzT5vVamNbyDb6Bcbmq0=
x-received: by 2002:a5d:9947:: with SMTP id v7mr1799484ios.81.1552646369451;
 Fri, 15 Mar 2019 03:39:29 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1Nt28njv4LVCRPf3ABam-4mD1315q-7CDypeG4dE9H5t=w@mail.gmail.com>
x-originating-ip: [209.85.166.49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b926d4e-1b3c-4392-a07c-08d6a93281f5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2665;
x-ms-traffictypediagnostic: CY1PR05MB2665:
x-microsoft-antispam-prvs: <CY1PR05MB2665351EDE3F8776E515C8CADA440@CY1PR05MB2665.namprd05.prod.outlook.com>
x-forefront-prvs: 09778E995A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(346002)(366004)(39860400002)(396003)(376002)(199004)(189003)(229853002)(2906002)(105586002)(61726006)(61266001)(6512007)(14444005)(9686003)(106356001)(6636002)(6246003)(498394004)(256004)(14454004)(53936002)(55446002)(81156014)(6862004)(68736007)(8936002)(4326008)(8676002)(52116002)(476003)(486006)(7736002)(386003)(66066001)(305945005)(6506007)(102836004)(25786009)(53546011)(76176011)(71190400001)(6486002)(6436002)(98316002)(54906003)(3846002)(5660300002)(81166006)(71200400001)(186003)(478600001)(6116002)(86362001)(26005)(316002)(11346002)(446003)(95326003)(97736004)(99286004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2665;H:CY1PR05MB2780.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SrJmD9zadQP/Qa/UFDz266O2/QsPb0KIqIoS87WU4m070XpnSZez2lghWKLbkim+C2zoQVi3x9ImIxcirJx0kQJF0rx79uhf+3lVce2nKT32dq/QkRwCJkhDslnURnVLIjQavX4NXlKAnCnIGNUHSRCAlVPJpxb14OoSQA0FOodw8AiDxVmY8A5xU7+al+RCKwsIZM+H7f+NJFwpUjVSN4sNKOp7+yKFNEPaFLJVCrFdFvcSPi5lG0yV0ilxFq9QGsQMMucj28TGNtDXo9/OIIAAQhpqGpvCafkfTnDf7JXuw//Y/9oZzGTMadfbKgcvLlY6ReN/UhTIGlsTGO5BiknUkqbmA0kUwdYp8bw+ugHLDOnZm6Mvxlc64G1tqG2Awx9WB37JC08ZHIYJLII/t7f9q4oMylRhUt7E+VAASNo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF2A87F37702D04C85A1F70AFEFD547A@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b926d4e-1b3c-4392-a07c-08d6a93281f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2019 10:39:31.6073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2665
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gRnJpLCBNYXIgMTUsIDIwMTkgYXQgMTA6MzggQU0gVHp2ZXRvbWlyIFN0b3lhbm92DQo8dHN0
b3lhbm92QHZtd2FyZS5jb20+IHdyb3RlOg0KPg0KPiBUaGUgbmV3IHRyYWNlY21kIGxpYiBBUEkg
dHJhY2VjbWRfbG9jYWxfZXZlbnRzX3N5c3RlbSgpIGNyZWF0ZXMNCj4gYSB0ZXAgaGFuZGxlciBh
bmQgaW5pdGlhbGl6ZXMgaXQgd2l0aCB0aGUgZXZlbnRzIG9mIHRoZQ0KPiBzcGVjaWZpZWQgc3Vi
c3lzdGVtcy4NCj4NCj4gU2lnbmVkLW9mZi1ieTogVHp2ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFu
b3ZAdm13YXJlLmNvbT4NCj4gLS0tDQo+ICBpbmNsdWRlL3RyYWNlLWNtZC90cmFjZS1jbWQuaCB8
ICAyICsNCj4gIGxpYi90cmFjZS1jbWQvdHJhY2UtdXRpbC5jICAgIHwgOTUgKysrKysrKysrKysr
KysrKysrKysrKysrLS0tLS0tLS0tLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgNjcgaW5zZXJ0aW9u
cygrKSwgMzAgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3RyYWNlLWNt
ZC90cmFjZS1jbWQuaCBiL2luY2x1ZGUvdHJhY2UtY21kL3RyYWNlLWNtZC5oDQo+IGluZGV4IDI3
YmE4OWQuLjIxZjgzZTIgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvdHJhY2UtY21kL3RyYWNlLWNt
ZC5oDQo+ICsrKyBiL2luY2x1ZGUvdHJhY2UtY21kL3RyYWNlLWNtZC5oDQo+IEBAIC0zMiw2ICsz
Miw4IEBAIHZvaWQgdHJhY2VjbWRfdW5sb2FkX3BsdWdpbnMoc3RydWN0IHRlcF9wbHVnaW5fbGlz
dCAqbGlzdCwgc3RydWN0IHRlcF9oYW5kbGUgKnBlDQo+ICBjaGFyICoqdHJhY2VjbWRfZXZlbnRf
c3lzdGVtcyhjb25zdCBjaGFyICp0cmFjaW5nX2Rpcik7DQo+ICBjaGFyICoqdHJhY2VjbWRfc3lz
dGVtX2V2ZW50cyhjb25zdCBjaGFyICp0cmFjaW5nX2RpciwgY29uc3QgY2hhciAqc3lzdGVtKTsN
Cj4gIHN0cnVjdCB0ZXBfaGFuZGxlICp0cmFjZWNtZF9sb2NhbF9ldmVudHMoY29uc3QgY2hhciAq
dHJhY2luZ19kaXIpOw0KPiArc3RydWN0IHRlcF9oYW5kbGUgKnRyYWNlY21kX2xvY2FsX2V2ZW50
c19zeXN0ZW0oY29uc3QgY2hhciAqdHJhY2luZ19kaXIsDQo+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IGNoYXIgKiBjb25zdCAqc3lzX25hbWVz
KTsNCj4gIGludCB0cmFjZWNtZF9maWxsX2xvY2FsX2V2ZW50cyhjb25zdCBjaGFyICp0cmFjaW5n
X2Rpciwgc3RydWN0IHRlcF9oYW5kbGUgKnBldmVudCk7DQo+ICBjaGFyICoqdHJhY2VjbWRfbG9j
YWxfcGx1Z2lucyhjb25zdCBjaGFyICp0cmFjaW5nX2Rpcik7DQo+DQo+IGRpZmYgLS1naXQgYS9s
aWIvdHJhY2UtY21kL3RyYWNlLXV0aWwuYyBiL2xpYi90cmFjZS1jbWQvdHJhY2UtdXRpbC5jDQo+
IGluZGV4IGI1YWVhMzkuLmNhMzJmY2YgMTAwNjQ0DQo+IC0tLSBhL2xpYi90cmFjZS1jbWQvdHJh
Y2UtdXRpbC5jDQo+ICsrKyBiL2xpYi90cmFjZS1jbWQvdHJhY2UtdXRpbC5jDQo+IEBAIC0xMTE5
LDQzICsxMTE5LDI1IEBAIHN0YXRpYyBpbnQgcmVhZF9oZWFkZXIoc3RydWN0IHRlcF9oYW5kbGUg
KnBldmVudCwgY29uc3QgY2hhciAqZXZlbnRzX2RpcikNCj4gICAgICAgICByZXR1cm4gcmV0Ow0K
PiAgfQ0KPg0KPiAtLyoqDQo+IC0gKiB0cmFjZWNtZF9sb2NhbF9ldmVudHMgLSBjcmVhdGUgYSBw
ZXZlbnQgZnJvbSB0aGUgZXZlbnRzIG9uIHN5c3RlbQ0KPiAtICogQHRyYWNpbmdfZGlyOiBUaGUg
ZGlyZWN0b3J5IHRoYXQgY29udGFpbnMgdGhlIGV2ZW50cy4NCj4gLSAqDQo+IC0gKiBSZXR1cm5z
IGEgcGV2ZW50IHN0cnVjdHVyZSB0aGF0IGNvbnRhaW5zIHRoZSBwZXZlbnRzIGxvY2FsIHRvDQo+
IC0gKiB0aGUgc3lzdGVtLg0KPiAtICovDQo+IC1zdHJ1Y3QgdGVwX2hhbmRsZSAqdHJhY2VjbWRf
bG9jYWxfZXZlbnRzKGNvbnN0IGNoYXIgKnRyYWNpbmdfZGlyKQ0KPiArc3RhdGljIGJvb2wgY29u
dGFpbnMoY29uc3QgY2hhciAqbmFtZSwgY29uc3QgY2hhciAqIGNvbnN0ICpuYW1lcykNCj4gIHsN
Cj4gLSAgICAgICBzdHJ1Y3QgdGVwX2hhbmRsZSAqcGV2ZW50ID0gTlVMTDsNCj4gLQ0KPiAtICAg
ICAgIHBldmVudCA9IHRlcF9hbGxvYygpOw0KPiAtICAgICAgIGlmICghcGV2ZW50KQ0KPiAtICAg
ICAgICAgICAgICAgcmV0dXJuIE5VTEw7DQo+IC0NCj4gLSAgICAgICBpZiAodHJhY2VjbWRfZmls
bF9sb2NhbF9ldmVudHModHJhY2luZ19kaXIsIHBldmVudCkpIHsNCj4gLSAgICAgICAgICAgICAg
IHRlcF9mcmVlKHBldmVudCk7DQo+IC0gICAgICAgICAgICAgICBwZXZlbnQgPSBOVUxMOw0KPiAt
ICAgICAgIH0NCj4gLQ0KPiAtICAgICAgIHJldHVybiBwZXZlbnQ7DQo+ICsgICAgICAgaWYgKCFu
YW1lcykNCj4gKyAgICAgICAgICAgICAgIHJldHVybiBmYWxzZTsNCj4gKyAgICAgICBmb3IgKDsg
Km5hbWVzOyBuYW1lcysrKQ0KPiArICAgICAgICAgICAgICAgaWYgKHN0cmNtcChuYW1lLCAqbmFt
ZXMpID09IDApDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiB0cnVlOw0KPiArICAg
ICAgIHJldHVybiBmYWxzZTsNCj4gIH0NCj4NCj4gLS8qKg0KPiAtICogdHJhY2VjbWRfZmlsbF9s
b2NhbF9ldmVudHMgLSBGaWxsIGEgcGV2ZW50IHdpdGggdGhlIGV2ZW50cyBvbiBzeXN0ZW0NCj4g
LSAqIEB0cmFjaW5nX2RpcjogVGhlIGRpcmVjdG9yeSB0aGF0IGNvbnRhaW5zIHRoZSBldmVudHMu
DQo+IC0gKiBAcGV2ZW50OiBBbGxvY2F0ZWQgcGV2ZW50IHdoaWNoIHdpbGwgYmUgZmlsbGVkDQo+
IC0gKg0KPiAtICogUmV0dXJucyB3aGV0aGVyIHRoZSBvcGVyYXRpb24gc3VjY2VlZGVkDQo+IC0g
Ki8NCj4gLWludCB0cmFjZWNtZF9maWxsX2xvY2FsX2V2ZW50cyhjb25zdCBjaGFyICp0cmFjaW5n
X2Rpciwgc3RydWN0IHRlcF9oYW5kbGUgKnBldmVudCkNCj4gK3N0YXRpYyBpbnQgdHJhY2VjbWRf
ZmlsbF9sb2NhbF9ldmVudHNfc3lzdGVtKGNvbnN0IGNoYXIgKnRyYWNpbmdfZGlyLA0KPiArICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgdGVwX2hhbmRs
ZSAqcGV2ZW50LA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBjb25zdCBjaGFyICogY29uc3QgKnN5c19uYW1lcykNCj4gIHsNCj4gKyAgICAgICBpbnQgcmV0
LCBmYWlsdXJlID0gMDsNCj4gICAgICAgICBzdHJ1Y3QgZGlyZW50ICpkZW50Ow0KPiAgICAgICAg
IGNoYXIgKmV2ZW50c19kaXI7DQo+ICAgICAgICAgc3RydWN0IHN0YXQgc3Q7DQo+ICAgICAgICAg
RElSICpkaXI7DQo+IC0gICAgICAgaW50IHJldCwgZmFpbHVyZSA9IDA7DQo+DQo+ICAgICAgICAg
aWYgKCF0cmFjaW5nX2RpcikNCj4gICAgICAgICAgICAgICAgIHJldHVybiAtMTsNCj4gQEAgLTEx
ODksNyArMTE3MSw4IEBAIGludCB0cmFjZWNtZF9maWxsX2xvY2FsX2V2ZW50cyhjb25zdCBjaGFy
ICp0cmFjaW5nX2Rpciwgc3RydWN0IHRlcF9oYW5kbGUgKnBldmVuDQo+ICAgICAgICAgICAgICAg
ICBpZiAoc3RyY21wKG5hbWUsICIuIikgPT0gMCB8fA0KPiAgICAgICAgICAgICAgICAgICAgIHN0
cmNtcChuYW1lLCAiLi4iKSA9PSAwKQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICBjb250aW51
ZTsNCj4gLQ0KPiArICAgICAgICAgICAgICAgaWYgKHN5c19uYW1lcyAmJiAhY29udGFpbnMobmFt
ZSwgc3lzX25hbWVzKSkNCg0KWW91IGNhbiBkcm9wIHRoZSBmaXJzdCBjaGVjayBzaW5jZSBpdCdz
IGJlaW5nIGRvbmUgaW4gY29udGFpbnMoKQ0KYW55d2F5IGFzIFN0ZXZlbiBzdWdnZXN0ZWQuDQoN
CiAgICAgICAgICAgICAgaWYgKCFjb250YWlucyhuYW1lLCBzeXNfbmFtZXMpKQ0KDQpUaGFua3Mh
DQoNCi0tIFNsYXZpDQoNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7DQo+ICAg
ICAgICAgICAgICAgICBzeXMgPSBhcHBlbmRfZmlsZShldmVudHNfZGlyLCBuYW1lKTsNCj4gICAg
ICAgICAgICAgICAgIHJldCA9IHN0YXQoc3lzLCAmc3QpOw0KPiAgICAgICAgICAgICAgICAgaWYg
KHJldCA8IDAgfHwgIVNfSVNESVIoc3Quc3RfbW9kZSkpIHsNCj4gQEAgLTEyMTcsNiArMTIwMCw1
OCBAQCBpbnQgdHJhY2VjbWRfZmlsbF9sb2NhbF9ldmVudHMoY29uc3QgY2hhciAqdHJhY2luZ19k
aXIsIHN0cnVjdCB0ZXBfaGFuZGxlICpwZXZlbg0KPiAgICAgICAgIHJldHVybiByZXQ7DQo+ICB9
DQo+DQo+ICsvKioNCj4gKyAqIHRyYWNlY21kX2xvY2FsX2V2ZW50c19zeXN0ZW0gLSBjcmVhdGUg
YSB0ZXAgZnJvbSB0aGUgZXZlbnRzIG9mIHRoZSBzcGVjaWZpZWQgc3Vic3lzdGVtLg0KPiArICoN
Cj4gKyAqIEB0cmFjaW5nX2RpcjogVGhlIGRpcmVjdG9yeSB0aGF0IGNvbnRhaW5zIHRoZSBldmVu
dHMuDQo+ICsgKiBAc3lzX25hbWU6IEFycmF5IG9mIHN5c3RlbSBuYW1lcywgdG8gbG9hZCB0aGUg
ZXZlbnRzIGZyb20uDQo+ICsgKiBUaGUgbGFzdCBlbGVtZW50IGZyb20gdGhlIGFycmF5IG11c3Qg
YmUgTlVMTA0KPiArICoNCj4gKyAqIFJldHVybnMgYSB0ZXAgc3RydWN0dXJlIHRoYXQgY29udGFp
bnMgdGhlIHRlcCBsb2NhbCB0bw0KPiArICogdGhlIHN5c3RlbS4NCj4gKyAqLw0KPiArc3RydWN0
IHRlcF9oYW5kbGUgKnRyYWNlY21kX2xvY2FsX2V2ZW50c19zeXN0ZW0oY29uc3QgY2hhciAqdHJh
Y2luZ19kaXIsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGNvbnN0IGNoYXIgKiBjb25zdCAqc3lzX25hbWVzKQ0KPiArew0KPiArICAgICAgIHN0cnVj
dCB0ZXBfaGFuZGxlICp0ZXAgPSBOVUxMOw0KPiArDQo+ICsgICAgICAgdGVwID0gdGVwX2FsbG9j
KCk7DQo+ICsgICAgICAgaWYgKCF0ZXApDQo+ICsgICAgICAgICAgICAgICByZXR1cm4gTlVMTDsN
Cj4gKw0KPiArICAgICAgIGlmICh0cmFjZWNtZF9maWxsX2xvY2FsX2V2ZW50c19zeXN0ZW0odHJh
Y2luZ19kaXIsIHRlcCwgc3lzX25hbWVzKSkgew0KPiArICAgICAgICAgICAgICAgdGVwX2ZyZWUo
dGVwKTsNCj4gKyAgICAgICAgICAgICAgIHRlcCA9IE5VTEw7DQo+ICsgICAgICAgfQ0KPiArDQo+
ICsgICAgICAgcmV0dXJuIHRlcDsNCj4gK30NCj4gKw0KPiArLyoqDQo+ICsgKiB0cmFjZWNtZF9s
b2NhbF9ldmVudHMgLSBjcmVhdGUgYSBwZXZlbnQgZnJvbSB0aGUgZXZlbnRzIG9uIHN5c3RlbQ0K
PiArICogQHRyYWNpbmdfZGlyOiBUaGUgZGlyZWN0b3J5IHRoYXQgY29udGFpbnMgdGhlIGV2ZW50
cy4NCj4gKyAqDQo+ICsgKiBSZXR1cm5zIGEgcGV2ZW50IHN0cnVjdHVyZSB0aGF0IGNvbnRhaW5z
IHRoZSBwZXZlbnRzIGxvY2FsIHRvDQo+ICsgKiB0aGUgc3lzdGVtLg0KPiArICovDQo+ICtzdHJ1
Y3QgdGVwX2hhbmRsZSAqdHJhY2VjbWRfbG9jYWxfZXZlbnRzKGNvbnN0IGNoYXIgKnRyYWNpbmdf
ZGlyKQ0KPiArew0KPiArICAgICAgIHJldHVybiB0cmFjZWNtZF9sb2NhbF9ldmVudHNfc3lzdGVt
KHRyYWNpbmdfZGlyLCBOVUxMKTsNCj4gK30NCj4gKw0KPiArLyoqDQo+ICsgKiB0cmFjZWNtZF9m
aWxsX2xvY2FsX2V2ZW50cyAtIEZpbGwgYSBwZXZlbnQgd2l0aCB0aGUgZXZlbnRzIG9uIHN5c3Rl
bQ0KPiArICogQHRyYWNpbmdfZGlyOiBUaGUgZGlyZWN0b3J5IHRoYXQgY29udGFpbnMgdGhlIGV2
ZW50cy4NCj4gKyAqIEBwZXZlbnQ6IEFsbG9jYXRlZCBwZXZlbnQgd2hpY2ggd2lsbCBiZSBmaWxs
ZWQNCj4gKyAqDQo+ICsgKiBSZXR1cm5zIHdoZXRoZXIgdGhlIG9wZXJhdGlvbiBzdWNjZWVkZWQN
Cj4gKyAqLw0KPiAraW50IHRyYWNlY21kX2ZpbGxfbG9jYWxfZXZlbnRzKGNvbnN0IGNoYXIgKnRy
YWNpbmdfZGlyLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHRlcF9o
YW5kbGUgKnBldmVudCkNCj4gK3sNCj4gKyAgICAgICByZXR1cm4gdHJhY2VjbWRfZmlsbF9sb2Nh
bF9ldmVudHNfc3lzdGVtKHRyYWNpbmdfZGlyLCBwZXZlbnQsIE5VTEwpOw0KPiArfQ0KPiArDQo+
ICAvKioNCj4gICAqIHRyYWNlY21kX2xvY2FsX3BsdWdpbnMgLSByZXR1cm5zIGFuIGFycmF5IG9m
IGF2YWlsYWJsZSB0cmFjZXIgcGx1Z2lucw0KPiAgICogQHRyYWNpbmdfZGlyOiBUaGUgZGlyZWN0
b3J5IHRoYXQgY29udGFpbnMgdGhlIHRyYWNpbmcgZGlyZWN0b3J5DQo+IC0tDQo+IDIuMjAuMQ0K
Pg0K
