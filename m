Return-Path: <SRS0=27yZ=PX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B2ADC43387
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Jan 2019 14:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41E5520656
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Jan 2019 14:21:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="hcAWdWcM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfAOOVP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Jan 2019 09:21:15 -0500
Received: from mail-eopbgr810072.outbound.protection.outlook.com ([40.107.81.72]:29328
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727049AbfAOOVO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Jan 2019 09:21:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMikzyzHTSIKqRXfiufsh6o9wbSrcdCQpohI+YyTI90=;
 b=hcAWdWcMuEeX+3WrYBQcuTIVSMPXYG0pmT7mwL8/PW7YEC2EDg5Nw6aDXEGPjCL+ggFIWM/5vY8q0X2AjZ0ZZwXofhTELUBG2YU394Ac9LWBUY5sUzB7zxqwVz2FlIWDzlAfmboKaDM3Chtp2iCvf2Lu2kVnFYb+J3Iafq8ReUU=
Received: from CY1PR05MB2780.namprd05.prod.outlook.com (10.167.18.26) by
 CY1PR05MB2475.namprd05.prod.outlook.com (10.167.10.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.20; Tue, 15 Jan 2019 14:21:11 +0000
Received: from CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::dcaf:ea32:61c2:a615]) by CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::dcaf:ea32:61c2:a615%10]) with mapi id 15.20.1537.018; Tue, 15 Jan
 2019 14:21:11 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: Re: [PATCH v3 3/6] trace-cmd: Add tracecmd_create_recorder_virt
 function
Thread-Topic: [PATCH v3 3/6] trace-cmd: Add tracecmd_create_recorder_virt
 function
Thread-Index: AQHUrFYD4wZU5HjnnUmPWIe2sjRgwKWwYmUA
Date:   Tue, 15 Jan 2019 14:21:11 +0000
Message-ID: <CAE0o1Ntmr0sxvdMbtdth_vG+aHQbY9vXDKb2Reep595xEasUyw@mail.gmail.com>
References: <20190114152800.31060-1-kaslevs@vmware.com>
 <20190114152800.31060-4-kaslevs@vmware.com>
 <20190114171046.6d46da9a@gandalf.local.home>
In-Reply-To: <20190114171046.6d46da9a@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR21CA0043.namprd21.prod.outlook.com
 (2603:10b6:3:ed::29) To CY1PR05MB2780.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::26)
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: AJcUukcf22fn7TJYf9/3ZEduVnIwCtdyiOK+JG7K5XVTj1Faw7mWLoVF
        8EUcpDugPhFqq3CK2pOBaMvSgTvB3dA12nEmZw==
x-google-smtp-source: ALg8bN7v3fIcooFDIQrrfArzeqrJ/Fu7W2P53Qx+kA26pUi84FERTSyAlLWMqs6sYhLkeQBcbjck3Y6B52NY0x/7tL8=
x-received: by 2002:a24:5608:: with SMTP id o8mr2514457itb.35.1547562068964;
 Tue, 15 Jan 2019 06:21:08 -0800 (PST)
x-gmail-original-message-id: <CAE0o1Ntmr0sxvdMbtdth_vG+aHQbY9vXDKb2Reep595xEasUyw@mail.gmail.com>
x-originating-ip: [209.85.166.182]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY1PR05MB2475;20:5kCT2lkVc7TE9ptPYSzNcw4tjdKxlEixylMp6zE1+Axosa8Dau0MVVrHClqu6Z8lXWpyMc4MG/xRHE8asQKsByy9ApPkhwMjkFqgGGDbe/91Cv6+kRagZEj5syTgtKY/KwwFE3HHqOreGdUfo5lEk+jYfYcDbShFwxU/72uNPdU=
x-ms-office365-filtering-correlation-id: f3f28c73-221d-4705-2da9-08d67af4b2b7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600109)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2475;
x-ms-traffictypediagnostic: CY1PR05MB2475:
x-microsoft-antispam-prvs: <CY1PR05MB2475B0DFECCD52D71491E5B2DA810@CY1PR05MB2475.namprd05.prod.outlook.com>
x-forefront-prvs: 0918748D70
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(346002)(396003)(366004)(136003)(189003)(199004)(99286004)(9686003)(71200400001)(71190400001)(106356001)(4326008)(6486002)(33896004)(305945005)(229853002)(97736004)(476003)(105586002)(25786009)(486006)(76176011)(52116002)(11346002)(2906002)(5660300001)(498394004)(7736002)(6512007)(446003)(6246003)(186003)(256004)(14444005)(6436002)(478600001)(8936002)(8676002)(53546011)(81156014)(386003)(81166006)(6862004)(6506007)(6346003)(316002)(54906003)(3846002)(55446002)(61726006)(95326003)(107886003)(66066001)(26005)(102836004)(14454004)(53936002)(68736007)(6116002)(61266001)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2475;H:CY1PR05MB2780.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SHrhwm7gqrDugdQoaYpKFdD3bFTrebPyOefRHN2SU0ccM7o4Mr5yUW+zgxrfTbfyQbmuYEeJkkMTbbXxzb2OvTEXKLljArSQOHFy6/tAFTBMprABoGlv5XL/6biVsQALc0hVdDiu3EI3DRCO2IJL1CNDe9u4govI6obU3Bhx9gZsk2h6rY2I8EnoZSdULYjE7XgyX5IIigSPm1qTBKsZILr/SUERL7HX4GG+itTGEB3Zs48+IpxT93ltBNkVjhA6KJRQa1usNoeI2LFQqIdUNderer5r0mSliK46/dKE3sIbiJg1Hm1SUbfeXqChcUC1+z3/w+rT57T8UzHKPvDUf2UFbYa/Kqap8FxnSigpxWdWF7g4tWsylJOEORqo1A9NOY3LMi6ahots+JTUtV+qna3PN+njkT7iHa8gEh+LLTo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D5380EB459DCF4BB9C2C2728CDF1940@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3f28c73-221d-4705-2da9-08d67af4b2b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2019 14:21:10.8451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2475
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCBKYW4gMTUsIDIwMTkgYXQgMTI6MTIgQU0gU3RldmVuIFJvc3RlZHQgPHJvc3RlZHRA
Z29vZG1pcy5vcmc+IHdyb3RlOg0KPg0KPiBPbiBNb24sIDE0IEphbiAyMDE5IDE3OjI3OjU3ICsw
MjAwDQo+IFNsYXZvbWlyIEthc2xldiA8a2FzbGV2c0B2bXdhcmUuY29tPiB3cm90ZToNCj4NCj4N
Cj4gPiBAQCAtMTk0LDggKzE5Niw5IEBAIHRyYWNlY21kX2NyZWF0ZV9idWZmZXJfcmVjb3JkZXJf
ZmQoaW50IGZkLCBpbnQgY3B1LCB1bnNpZ25lZCBmbGFncywgY29uc3QgY2hhciAqDQo+ID4gICAg
ICAgcmV0dXJuIHRyYWNlY21kX2NyZWF0ZV9idWZmZXJfcmVjb3JkZXJfZmQyKGZkLCAtMSwgY3B1
LCBmbGFncywgYnVmZmVyLCAwKTsNCj4gPiAgfQ0KPiA+DQo+ID4gLXN0cnVjdCB0cmFjZWNtZF9y
ZWNvcmRlciAqDQo+ID4gLXRyYWNlY21kX2NyZWF0ZV9idWZmZXJfcmVjb3JkZXIoY29uc3QgY2hh
ciAqZmlsZSwgaW50IGNwdSwgdW5zaWduZWQgZmxhZ3MsIGNvbnN0IGNoYXIgKmJ1ZmZlcikNCj4g
PiArc3RhdGljIHN0cnVjdCB0cmFjZWNtZF9yZWNvcmRlciAqDQo+ID4gK19fdHJhY2VjbWRfY3Jl
YXRlX2J1ZmZlcl9yZWNvcmRlcihjb25zdCBjaGFyICpmaWxlLCBpbnQgY3B1LCB1bnNpZ25lZCBm
bGFncywNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IGNoYXIgKmJ1
ZmZlcikNCj4gPiAgew0KPiA+ICAgICAgIHN0cnVjdCB0cmFjZWNtZF9yZWNvcmRlciAqcmVjb3Jk
ZXI7DQo+ID4gICAgICAgaW50IGZkOw0KPiA+IEBAIC0yNTgsNiArMjYxLDI2IEBAIHRyYWNlY21k
X2NyZWF0ZV9idWZmZXJfcmVjb3JkZXJfbWF4a2IoY29uc3QgY2hhciAqZmlsZSwgaW50IGNwdSwg
dW5zaWduZWQgZmxhZ3MsDQo+ID4gICAgICAgZ290byBvdXQ7DQo+ID4gIH0NCj4gPg0KPiA+ICtz
dHJ1Y3QgdHJhY2VjbWRfcmVjb3JkZXIgKg0KPiA+ICt0cmFjZWNtZF9jcmVhdGVfYnVmZmVyX3Jl
Y29yZGVyKGNvbnN0IGNoYXIgKmZpbGUsIGludCBjcHUsIHVuc2lnbmVkIGZsYWdzLA0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IGNoYXIgKmJ1ZmZlcikNCj4gPiArew0K
PiA+ICsgICAgIHJldHVybiBfX3RyYWNlY21kX2NyZWF0ZV9idWZmZXJfcmVjb3JkZXIoZmlsZSwg
Y3B1LCBmbGFncywgYnVmZmVyKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RydWN0IHRyYWNlY21k
X3JlY29yZGVyICoNCj4gPiArdHJhY2VjbWRfY3JlYXRlX3JlY29yZGVyX3ZpcnQoY29uc3QgY2hh
ciAqZmlsZSwgaW50IGNwdSwgaW50IHRyYWNlX2ZkKQ0KPg0KPiBBcyB0aGlzIGxvb2tzIHRvIGJl
IHNvbWV0aGluZyB0aGF0IG1heSBiZSBhIGxpYnJhcnkgY2FsbCBzb21lZGF5LCBJDQo+IHdvdWxk
IGtlZXAgZmxhZ3MgYXMgYSBwYXJhbWV0ZXIuDQo+DQo+ID4gK3sNCj4gPiArICAgICBzdHJ1Y3Qg
dHJhY2VjbWRfcmVjb3JkZXIgKnJlY29yZGVyOw0KPiA+ICsNCj4gPiArICAgICByZWNvcmRlciA9
IF9fdHJhY2VjbWRfY3JlYXRlX2J1ZmZlcl9yZWNvcmRlcigNCj4gPiArICAgICAgICAgICAgIGZp
bGUsIGNwdSwgVFJBQ0VDTURfUkVDT1JEX05PU1BMSUNFLCBOVUxMKTsNCj4NCj4gVGhlbiB5b3Ug
Y291bGQgcGFzcyB0aGlzIGFzOg0KPg0KPiAgICAgICAgIHJlY29yZGVyID0gX190cmFjZWNtZF9j
cmVhdGVfYnVmZmVyX3JlY29yZGVyKGZpbGUsIGNwdSwNCj4gICAgICAgICAgICAgICAgICAgICAg
ICAgZmxhZ3MgfCBUUkFDRUNNRF9SRUNPUkRfTk9TUExJQ0UsIE5VTEwpOw0KPg0KDQpNYWtlcyBz
ZW5zZSBidXQgKGNvbnRpbnVlcyBiZWxvdykNCg0KPiAtLSBTdGV2ZQ0KPg0KPiA+ICsgICAgIGlm
IChyZWNvcmRlcikNCj4gPiArICAgICAgICAgICAgIHJlY29yZGVyLT50cmFjZV9mZCA9IHRyYWNl
X2ZkOw0KDQppdCdzIHRoaXMgcGFydCB0aGF0IGNhbm5vdCBiZSBkb25lIG91dHNpZGUgb2YgdHJh
Y2UtcmVjb3JkZXIuYyBzaW5jZQ0KYHJlY29yZGVyLT50cmFjZV9mZGAgaXMgbm90IGV4cG9zZWQu
DQpgdHJhY2VjbWRfY3JlYXRlX3JlY29yZGVyX3ZpcnRgIGp1c3QgYWxsb3dzIGEgdXNlciB0byBw
cm92aWRlIGhpcyBvd24NCmZpbGUgZGVzY3JpcHRvciBmcm9tIHdoZXJlIHRyYWNpbmcgZGF0YSBz
aG91bGQgYmUgcmVhZCAoaW4gdGhpcyBjYXNlDQpmcm9tIHRoZSBhZ2VudCdzIHZzb2NrIHNvY2tl
dHMpDQoNCk9uIGFuIHVucmVsYXRlZCBub3RlLCB0aGUgVFJBQ0VDTURfUkVDT1JEX05PU1BMSUNF
IGZsYWcgaXMgb25seSBuZWVkZWQNCm9uIExpbnV4IHZlcnNpb24gPDQuMjAuIERvIHdlIHdhbnQg
dG8gZGV0ZWN0IGlmIHNwbGljaW5nIG9uIHZzb2NrDQpzb2NrZXRzIHdvcmtzIG9uIHN0YXJ0dXAg
YW5kIHVzZSB0aGlzIGZsYWcgb25seSBpZiBuZWNlc3Nhcnk/DQoNCj4gPiArDQo+ID4gKyAgICAg
cmV0dXJuIHJlY29yZGVyOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdHJ1Y3QgdHJhY2VjbWRfcmVj
b3JkZXIgKnRyYWNlY21kX2NyZWF0ZV9yZWNvcmRlcl9mZChpbnQgZmQsIGludCBjcHUsIHVuc2ln
bmVkIGZsYWdzKQ0KPiA+ICB7DQo+ID4gICAgICAgY29uc3QgY2hhciAqdHJhY2luZzsNCj4NCg==
