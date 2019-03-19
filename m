Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4838C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 10:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7238D206BA
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 10:35:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="Bvu8877D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfCSKfO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:35:14 -0400
Received: from mail-eopbgr790087.outbound.protection.outlook.com ([40.107.79.87]:18496
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbfCSKfL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 06:35:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwx16BFBDruINR8pGolozvRZA7ixhuheRh12cquwbL8=;
 b=Bvu8877De3EvSwICUyrNW9CJE6w3oMf/AM99W/cfsbqFSv1Knxb3ozkOrgMaHAmfuG4u0MZR0NC4KmnIQ2jstfSX2MYKVOZV26fd8BbMqdJzSuC5LHyLaLbYXtqaeTBxT2cVEItMRqQAxS22BmH37Tpy0DAnSsPCavMxOYZ7Zgg=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2442.namprd05.prod.outlook.com (10.167.10.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.8; Tue, 19 Mar 2019 10:35:05 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec%4]) with mapi id 15.20.1709.015; Tue, 19 Mar 2019
 10:35:05 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Matt Helsley <mhelsley@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v4] tools/lib/traceevent: Change description of few APIs
Thread-Topic: [PATCH v4] tools/lib/traceevent: Change description of few APIs
Thread-Index: AQHU2way0HWuJwblVkCnBJsSYB2ap6YR5fuAgADiuAA=
Date:   Tue, 19 Mar 2019 10:35:05 +0000
Message-ID: <CACqStofty+o7r_RasESWrv5PA8-hvXWFG+ha76Pf-6A+GZuaYw@mail.gmail.com>
References: <20190315081123.21723-1-tstoyanov@vmware.com>
 <8B1136D3-BD5A-49E8-B007-12D00050687A@vmware.com>
In-Reply-To: <8B1136D3-BD5A-49E8-B007-12D00050687A@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P194CA0060.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::37) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAUz2p3jJoGoIpc3Nlz2noZbe6vDmzwYnFz03ZXxpdyA3rFihz/a
        G4RjkKUxzSogLfUekQpzH+0SOlYTQcTyMQTr10Q=
x-google-smtp-source: APXvYqxBCMCv2eePY+WTfaTXmYcCC8xcaPfidu3UfaTSwy7h/UmX9lcSVNSnsqJtVwUVyX7ISZYXB/6ksl21DVduxNo=
x-received: by 2002:adf:e443:: with SMTP id t3mr4857851wrm.257.1552991699429;
 Tue, 19 Mar 2019 03:34:59 -0700 (PDT)
x-gmail-original-message-id: <CACqStofty+o7r_RasESWrv5PA8-hvXWFG+ha76Pf-6A+GZuaYw@mail.gmail.com>
x-originating-ip: [209.85.221.53]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df545ed2-50ab-4f16-92ca-08d6ac568cc3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2442;
x-ms-traffictypediagnostic: CY1PR05MB2442:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-microsoft-antispam-prvs: <CY1PR05MB244200012B1EA295CEFC9011DC400@CY1PR05MB2442.namprd05.prod.outlook.com>
x-forefront-prvs: 0981815F2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(39860400002)(376002)(346002)(199004)(189003)(53936002)(76176011)(6486002)(61266001)(229853002)(106356001)(105586002)(498394004)(61726006)(6436002)(6636002)(6512007)(9686003)(5660300002)(52116002)(99286004)(95326003)(6116002)(3846002)(6246003)(53546011)(8936002)(102836004)(386003)(6506007)(26005)(25786009)(186003)(4326008)(6862004)(7736002)(68736007)(486006)(2906002)(476003)(316002)(446003)(14454004)(305945005)(54906003)(11346002)(86362001)(478600001)(71200400001)(71190400001)(8676002)(81166006)(81156014)(66066001)(55446002)(97736004)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2442;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vq2OCR6egXzgnWzofsoLTRa4kKUSdjbT0DnV3mykxbRwMDKXV1VxUjvFq03IYivbeks5+vM3CnZsggJtBAimJC6LY5Nx9G69rvzUmhkCPTuePHuXWIarBgFOjPFEIRw/FaVUd2XFBH7JHJ5hpfFgm2azBHOiwl3aoN5ezmsL7cfgtOP5i2PM7CqY9vwOcbQjPzsVRpzuQBREKhtLU02UCkL1qymH+uCeSsT7iES/TddSelJvf2nuwZFWp5A5+oP+8tP17x8MTzgmZigJbU2g9Hi3tP/AbbkLqJAeW3ne0lhtolppOSYdJuRQEcFATXkpRkHBk6zIWGDMxzha0vsR+J+Nso6RFXxCSW6qMVqMcqoEC3/jOlPHhxKEPAdWyMzumJGYiiR3WEM9O34Pn0+dWjOkXtz3dYHSM0KRi+jJCxc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <688FBC5351F73442ACFD10EFA521BD2F@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df545ed2-50ab-4f16-92ca-08d6ac568cc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2019 10:35:05.3840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2442
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gTW9uLCBNYXIgMTgsIDIwMTkgYXQgMTE6MDMgUE0gTWF0dCBIZWxzbGV5IDxtaGVsc2xleUB2
bXdhcmUuY29tPiB3cm90ZToNCj4NCj4NCj4NCj4gPiBPbiBNYXIgMTUsIDIwMTksIGF0IDE6MTEg
QU0sIFR6dmV0b21pciBTdG95YW5vdiA8dHN0b3lhbm92QHZtd2FyZS5jb20+IHdyb3RlOg0KPiA+
DQo+ID4gQVBJcyBkZXNjcmlwdGlvbnMgc2hvdWxkIGRlc2NyaWJlIHRoZSBwdXJwb3NlIG9mIHRo
ZQ0KPiA+IGZ1bmN0aW9uLCBpdHMgcGFyYW1ldGVycyBhbmQgcmV0dXJuIHZhbHVlLiBXaGlsZSB3
b3JraW5nDQo+ID4gb24gbWFuIHBhZ2VzIGltcGxlbWVudGF0aW9uLCBJIG5vdGljZWQgbWlzbWF0
Y2hlcyBpbiB0aGUNCj4gPiBkZXNjcmlwdGlvbnMgb2YgZmV3IEFQSXMuIFRoaXMgcGF0Y2ggY2hh
bmdlcyB0aGUgZGVzY3JpcHRpb24NCj4gPiBvZiB0aGVzZSBBUElzLCBtYWtpbmcgdGhlbSBjb25z
aXN0ZW50IHdpdGggdGhlIG1hbiBwYWdlczoNCj4gPiB0ZXBfcHJpbnRfbnVtX2ZpZWxkKCksIHRl
cF9wcmludF9mdW5jX2ZpZWxkKCksDQo+ID4gdGVwX2dldF9oZWFkZXJfcGFnZV9zaXplKCksIHRl
cF9nZXRfbG9uZ19zaXplKCksDQo+ID4gdGVwX3NldF9sb25nX3NpemUoKSwgdGVwX2dldF9wYWdl
X3NpemUoKSBhbmQNCj4gPiB0ZXBfc2V0X3BhZ2Vfc2l6ZSgpLg0KPiA+DQo+ID4gU2lnbmVkLW9m
Zi1ieTogVHp2ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJlLmNvbT4NCj4gPiAtLS0N
Cj4gPiB0b29scy9saWIvdHJhY2VldmVudC9ldmVudC1wYXJzZS1hcGkuYyB8IDIxICsrKysrKysr
KysrKy0tLS0tLS0tLQ0KPiA+IHRvb2xzL2xpYi90cmFjZWV2ZW50L2V2ZW50LXBhcnNlLmMgICAg
IHwgIDQgKystLQ0KPiA+IDIgZmlsZXMgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygrKSwgMTEgZGVs
ZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL3RyYWNlZXZlbnQvZXZl
bnQtcGFyc2UtYXBpLmMgYi90b29scy9saWIvdHJhY2VldmVudC9ldmVudC1wYXJzZS1hcGkuYw0K
PiA+IGluZGV4IGQ0MzY4ZGNjMTZlYS4uMmQ1ZDM2NDJlM2U5IDEwMDY0NA0KPiA+IC0tLSBhL3Rv
b2xzL2xpYi90cmFjZWV2ZW50L2V2ZW50LXBhcnNlLWFwaS5jDQo+ID4gKysrIGIvdG9vbHMvbGli
L3RyYWNlZXZlbnQvZXZlbnQtcGFyc2UtYXBpLmMNCj4gPiBAQCAtMTAwLDEwICsxMDAsMTAgQEAg
dGVwX2RhdGEyaG9zdDgoc3RydWN0IHRlcF9oYW5kbGUgKnBldmVudCwgdW5zaWduZWQgbG9uZyBs
b25nIGRhdGEpDQo+ID4gfQ0KPiA+DQo+ID4gLyoqDQo+ID4gLSAqIHRlcF9nZXRfaGVhZGVyX3Bh
Z2Vfc2l6ZSAtIGdldCBzaXplIG9mIHRoZSBoZWFkZXIgcGFnZQ0KPiA+ICsgKiB0ZXBfZ2V0X2hl
YWRlcl9wYWdlX3NpemUgLSBnZXQgdGhlIHNpemUgb2YgYSBsb25nIGludGVnZXIsIGluIGtlcm5l
bCBjb250ZXh0DQo+DQo+IEp1c3Qgd2FudCB0byBjaGVjayBJZiB0aGlzIGNvbW1lbnQgY2hhbmdl
IGNvcnJlY3QuIEdpdmVuIHRoZSBmdW5jdGlvbiBuYW1lIGl0IGxvb2tzIGEgYml0IG9kZCBjb21w
YXJlZCB0byB0aGUgY29tbWVudCBmb3IgdGVwX2dldF9sb25nX3NpemUoKS4NCg0KSXQgaXMgYSBj
b3B5IC8gcGFzdGUgZXJyb3IsDQpUaGFua3MgTWF0dA0KDQoNCj4NCj4gPiAgKiBAcGV2ZW50OiBh
IGhhbmRsZSB0byB0aGUgdGVwX2hhbmRsZQ0KPiA+ICAqDQo+ID4gLSAqIFRoaXMgcmV0dXJucyBz
aXplIG9mIHRoZSBoZWFkZXIgcGFnZQ0KPiA+ICsgKiBUaGlzIHJldHVybnMgdGhlIHNpemUgb2Yg
YSBsb25nIGludGVnZXIsIGluIGtlcm5lbCBjb250ZXh0DQo+ID4gICogSWYgQHBldmVudCBpcyBO
VUxMLCAwIGlzIHJldHVybmVkLg0KPiA+ICAqLw0KPiA+IGludCB0ZXBfZ2V0X2hlYWRlcl9wYWdl
X3NpemUoc3RydWN0IHRlcF9oYW5kbGUgKnBldmVudCkNCj4gPiBAQCAtMTQwLDEwICsxNDAsMTEg
QEAgdm9pZCB0ZXBfc2V0X2NwdXMoc3RydWN0IHRlcF9oYW5kbGUgKnBldmVudCwgaW50IGNwdXMp
DQo+ID4gfQ0KPiA+DQo+ID4gLyoqDQo+ID4gLSAqIHRlcF9nZXRfbG9uZ19zaXplIC0gZ2V0IHRo
ZSBzaXplIG9mIGEgbG9uZyBpbnRlZ2VyIG9uIHRoZSBjdXJyZW50IG1hY2hpbmUNCj4gPiArICog
dGVwX2dldF9sb25nX3NpemUgLSBnZXQgdGhlIHNpemUgb2YgYSBsb25nIGludGVnZXIgb24gdGhl
IHRyYWNlZCBtYWNoaW5lDQo+ID4gICogQHBldmVudDogYSBoYW5kbGUgdG8gdGhlIHRlcF9oYW5k
bGUNCj4gPiAgKg0KPiA+IC0gKiBUaGlzIHJldHVybnMgdGhlIHNpemUgb2YgYSBsb25nIGludGVn
ZXIgb24gdGhlIGN1cnJlbnQgbWFjaGluZQ0KPiA+ICsgKiBUaGlzIHJldHVybnMgdGhlIHNpemUg
b2YgYSBsb25nIGludGVnZXIgb24gdGhlIG1hY2hpbmUsDQo+ID4gKyAqIHdoZXJlIHRoZSB0cmFj
ZSBpcyBnZW5lcmF0ZWQNCj4gPiAgKiBJZiBAcGV2ZW50IGlzIE5VTEwsIDAgaXMgcmV0dXJuZWQu
DQo+ID4gICovDQoNCg0KDQotLQ0KDQpUenZldG9taXIgKENlY28pIFN0b3lhbm92DQpWTXdhcmUg
T3BlbiBTb3VyY2UgVGVjaG5vbG9neSBDZW50ZXINCg==
