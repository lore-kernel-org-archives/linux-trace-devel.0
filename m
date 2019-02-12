Return-Path: <SRS0=4mzf=QT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 100E2C282C4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Feb 2019 17:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B49B120700
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Feb 2019 17:09:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="AbkDXi08"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731318AbfBLRJp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:09:45 -0500
Received: from mail-eopbgr770087.outbound.protection.outlook.com ([40.107.77.87]:35232
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728085AbfBLRJp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Feb 2019 12:09:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3FUadKci5iJvkWUgiDnb7yQ71FdwU/hREsXNXwuIns=;
 b=AbkDXi08q0abdLqq+K2HSvneMHMLgPVCKCJtjAXIiMKh/YxEfpelMTlSDcYuGxfIwMZk7BIdCfQgPg0mGbFaQiUSC+rn545YBf4qXdmO6PhI24Zj7o5RPhWZhye7MbcUbkL7CALbduzmHSh/0b6SEg4XhuT32/emXEXCI36uYZE=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3791.namprd05.prod.outlook.com (10.167.150.156) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.11; Tue, 12 Feb 2019 17:09:42 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::9c6c:db1c:e297:7b13]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::9c6c:db1c:e297:7b13%3]) with mapi id 15.20.1622.013; Tue, 12 Feb 2019
 17:09:42 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/4] kernel-shark: Consolidate duplicate code of the
 sched_wakeup events
Thread-Topic: [PATCH 2/4] kernel-shark: Consolidate duplicate code of the
 sched_wakeup events
Thread-Index: AQHUwahMfaf0d19QQEaazCWyd2zWC6XaSxuAgABiOoCAAbrPgA==
Date:   Tue, 12 Feb 2019 17:09:41 +0000
Message-ID: <d942c9f8-58a5-4475-5bd8-c0bd2060cc92@vmware.com>
References: <20190211011807.714634783@goodmis.org>
 <20190211012153.982548008@goodmis.org>
 <9c610142-ee8d-5801-6077-33d7d39acaf9@vmware.com>
 <20190211094433.296d3beb@gandalf.local.home>
In-Reply-To: <20190211094433.296d3beb@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR06CA0138.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::31) To SN4PR0501MB3903.namprd05.prod.outlook.com
 (2603:10b6:803:4d::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5d7555a-a5ae-40d0-e554-08d6910ce0ba
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:SN4PR0501MB3791;
x-ms-traffictypediagnostic: SN4PR0501MB3791:
x-microsoft-exchange-diagnostics: 1;SN4PR0501MB3791;20:hQKj/bXAbeKLRmefnKuhnLs9DMTnbSWabW3cafbtOzs9w0RUIZbagcgqCg0V1qqWmnsJNHxxIgX8tgG+CPuXsiZHSnTzg7sG5iPzhZjRsPv9SgI6Grf6X775sn5Z+OB9aafLKkgAo1NZ/DMCfaFLeGN3MS+GDE584hEUWKepRGY=
x-microsoft-antispam-prvs: <SN4PR0501MB37914D4EBDFA5F37DD4380D0A0650@SN4PR0501MB3791.namprd05.prod.outlook.com>
x-forefront-prvs: 0946DC87A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(376002)(396003)(366004)(346002)(199004)(189003)(99286004)(66066001)(76176011)(446003)(6116002)(6436002)(71190400001)(14454004)(6246003)(2906002)(6512007)(316002)(229853002)(52116002)(11346002)(186003)(86362001)(3846002)(110136005)(478600001)(2616005)(36756003)(26005)(97736004)(486006)(8936002)(476003)(25786009)(31686004)(53936002)(105586002)(102836004)(6506007)(7736002)(68736007)(31696002)(106356001)(4326008)(256004)(14444005)(71200400001)(81156014)(81166006)(386003)(6486002)(305945005)(93886005)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3791;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dP5Xa1aOgtqxPBBU5NdL6GPHC8gBHrl8u1hrNbDXkpo1IyxoM9BdxKHiYyLjY762uIsw8stFDmw34cZP63SoXZLb+Z6JtsQP42NKdodd6P1lMjBO60TMf0o31zK6ZbnoDts2akDWzH3ARebskNINMO1uXQeD0jkY1W9WBlGT5rwTPXcEiK/g2HCnKtr6gBeieFG+XcPvy/EzimaZ0UPDw/y8EVOyZGnYvfU5SjyWxh4vw23XSqdUlkdoW20NtInUiF+q9purE8lV27byAb54qc98lGployUlcVtrizJZPLApeqstc47gb2/Jfd/n6W+QyGhP9eXhB0/g6LLWX+6fhdxYaQgYkKvv9fKwKP4Zbpf0HL3tM2NKdUWIys2yqIqej8YSvyuNqxFkjXC95TV/fHsY+KmMqmX/35JhzF9xp2I=
Content-Type: text/plain; charset="utf-8"
Content-ID: <884F08A017D16D4094CC6309BFE52FF1@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5d7555a-a5ae-40d0-e554-08d6910ce0ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2019 17:09:40.7197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3791
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQoNCk9uIDExLjAyLjE5INCzLiAxNjo0NCDRhy4sIFN0ZXZlbiBSb3N0ZWR0IHdyb3RlOg0KPiBP
biBNb24sIDExIEZlYiAyMDE5IDA4OjUzOjE2ICswMDAwDQo+IFlvcmRhbiBLYXJhZHpob3YgPHlr
YXJhZHpob3ZAdm13YXJlLmNvbT4gd3JvdGU6DQo+IA0KPiBIaSBZb3JkYW4sDQo+IA0KPiBUaGFu
a3MgZm9yIHJldmlld2luZywgeW91IHBvaW50ZWQgb3V0IHRoaW5ncyBJIGV4cGVjdGVkIHlvdSB0
byA7LSkNCj4gDQo+Pj4gQEAgLTEzOSwxNyArMTUwLDUxIEBAIHN0YXRpYyB2b2lkIHBsdWdpbl9y
ZWdpc3Rlcl9jb21tYW5kKHN0cnVjdCBrc2hhcmtfY29udGV4dCAqa3NoYXJrX2N0eCwNCj4+PiAg
ICAJCQl0ZXBfcmVnaXN0ZXJfY29tbShrc2hhcmtfY3R4LT5wZXZlbnQsIGNvbW0sIHBpZCk7DQo+
Pj4gICAgfQ0KPj4+ICAgIA0KPj4+IC1zdGF0aWMgaW50IHBsdWdpbl9nZXRfcmVjX3dha2V1cF9u
ZXdfcGlkKHN0cnVjdCB0ZXBfcmVjb3JkICpyZWNvcmQpDQo+Pg0KPj4gVGhpcyBwYXRjaCBzaWxl
bnRseSByZW1vdmVzIHRoZSAicGx1Z2luX2dldF9yZWNfd2FrZXVwX25ld19waWQoKSINCj4+IGZ1
bmN0aW9uIHdoaWNoIGlzIHRoZSBlcXVpdmFsZW50IG9mICJwbHVnaW5fZ2V0X3JlY193YWtldXBf
cGlkKCkiLCBidXQNCj4+IGZvciAid2FrZXVwX25ldyIgZXZlbnRzLiBJIGd1ZXNzLCB5b3UgYXJl
IHJlbW92aW5nDQo+PiAicGx1Z2luX2dldF9yZWNfd2FrZXVwX25ld19waWQoKSIgaGVyZSwgYmVj
YXVzZSBpdCBpcyBkZWZpbmVkIHN0YXRpYyBidXQNCj4+IGluIGZhY3QgdGhlcmUgaXMgbm8gcmVh
c29uIGZvciAicGx1Z2luX2dldF9yZWNfd2FrZXVwX3BpZCgpIiBiZWluZw0KPj4gbm9uLXN0YXRp
YyAodGhpcyBpcyBteSBtaXN0YWtlKS4gU28ganVzdCB0byBrZWVwIGV2ZXJ5dGhpbmcgY29uc2lz
dGVudCwNCj4+IHBsZWFzZSBkbyB0aGUgcmVtb3ZhbCBvZiAicGx1Z2luX2dldF9yZWNfd2FrZXVw
X25ld19waWQoKSIgaW4gdGhlIG5leHQNCj4+IHBhdGNoICh0b2dldGhlciB3aXRoIHRoZSByZW1v
dmFsIG9mICJwbHVnaW5fZ2V0X3JlY193YWtldXBfcGlkKCkiKS4NCj4+DQo+IA0KPiBBY3R1YWxs
eSwgSSBkaWRuJ3QgcmVhbGx5IHNpbGVudGx5IHJlbW92ZSBpdC4gV2l0aG91dCByZW1vdmluZyBp
dCwgZ2NjDQo+IHdvdWxkIGNvbXBsYWluIHRoYXQgdGhlcmUncyBhIHN0YXRpYyBmdW5jdGlvbiBu
b3QgYmVpbmcgdXNlZCwgYW5kDQo+IHRoYXQncyBhIG5vLW5vIGZvciBhIHBhdGNoIHRvIGNhdXNl
IGEgbmV3IHdhcm5pbmcuIEl0J3MgZmluZSB0byByZW1vdmUNCj4gc3RhdGljIGZ1bmN0aW9ucyB3
aGVuIHJlbW92aW5nIHRoZWlyIHVzZXJzIGluIHRoZSBjb2RlIHRoYXQgaXMgYmVpbmcNCj4gbW9k
aWZpZWQuDQo+IA0KPiBOb3csIEkgd291bGQgaGF2ZSBhbHNvIHJlbW92ZWQgcGx1Z2luX2dldF9y
ZWNfd2FrZXVwX3BpZCgpLCBidXQgYmVjYXVzZQ0KPiB0aGF0J3MgYSBnbG9iYWwgZnVuY3Rpb24s
IGl0IGRvZXNuJ3QgY2F1c2UgdGhlIHdhcm5pbmcsIGFuZCBtYXkgYWxzbyBiZQ0KPiBwb3NzaWJs
eSB1c2VkIG91dHNpZGUgb2YgdGhhdCBmaWxlIChhbmQgYnkgY29kZSBJJ20gbm90IHdvcmtpbmcg
d2l0aCkuDQo+IA0KPiBUaGF0J3Mgd2h5IEkgcmVtb3ZlZCB0aGUgc3RhdGljIG9uZSBoZXJlLiBJ
dCdzIHJlcXVpcmVkIGJlY2F1c2Ugd2l0aG91dA0KPiBkb2luZyBzbywgaXQgY2F1c2VzIGdjYyB0
byBnZW5lcmF0ZSBhIHdhcm5pbmcuIEFuZCB0aGUgcmVhc29uIGZvcg0KPiByZW1vdmluZyB0aGUg
b3RoZXIgZnVuY3Rpb24gd2FzIGJlY2F1c2UgaXQgaXMgZ2xvYmFsIG91dHNpZGUgb2YgdGhlDQo+
IGNvZGUgdGhhdCBJIGNoYW5nZWQsIHdoaWNoIHJlcXVpcmVzIGEgc2VwYXJhdGUgcGF0Y2guIE5v
dyBpZiBib3RoIHdlcmUNCj4gZ2xvYmFsLCBJIHdvdWxkIGJlIGFibGUgdG8gcmVtb3ZlIHRoZW0g
dG9nZXRoZXIgaW4gYSBzZXBhcmF0ZSBwYXRjaCwgb3INCj4gaWYgYm90aCB3ZXJlIHN0YXRpYywg
SSB3b3VsZCBoYXZlIHJlbW92ZWQgYm90aCBoZXJlLiBCdXQgc2luY2Ugb25lJ3MNCj4gZ2xvYmFs
IGFuZCBvbmUncyBzdGF0aWMsIHRoZXkgbmVlZCB0byBiZSByZW1vdmVkIGluIHNlcGFyYXRlIHBs
YWNlcy4NCj4gDQo+IE1ha2Ugc2Vuc2U/DQoNClllcywgdGhpcyBtYWtlcyBzZW5zZS4NCg0KPiAN
Cj4+DQo+Pj4gK2ludCBmaW5kX3dha2V1cF9waWQoc3RydWN0IGtzaGFya19jb250ZXh0ICprc2hh
cmtfY3R4LCBzdHJ1Y3Qga3NoYXJrX2VudHJ5ICplLA0KPj4+ICsJCSAgICBzdHJ1Y3QgdGVwX2V2
ZW50ICp3YWtldXBfZXZlbnQsIHN0cnVjdCB0ZXBfZm9ybWF0X2ZpZWxkICpwaWRfZmllbGQpDQo+
Pj4gICAgew0KPj4+IC0Jc3RydWN0IHBsdWdpbl9zY2hlZF9jb250ZXh0ICpwbHVnaW5fY3R4ID0N
Cj4+PiAtCQlwbHVnaW5fc2NoZWRfY29udGV4dF9oYW5kbGVyOw0KPj4+ICsJc3RydWN0IHRlcF9y
ZWNvcmQgKnJlY29yZDsNCj4+PiAgICAJdW5zaWduZWQgbG9uZyBsb25nIHZhbDsNCj4+PiAgICAJ
aW50IHJldDsNCj4+PiAgICANCj4+PiAtCXJldCA9IHRlcF9yZWFkX251bWJlcl9maWVsZChwbHVn
aW5fY3R4LT5zY2hlZF93YWtldXBfbmV3X3BpZF9maWVsZCwNCj4+PiAtCQkJCSAgICByZWNvcmQt
PmRhdGEsICZ2YWwpOw0KPj4+ICsJaWYgKCF3YWtldXBfZXZlbnQgfHwgZS0+ZXZlbnRfaWQgIT0g
d2FrZXVwX2V2ZW50LT5pZCkNCj4+PiArCQlyZXR1cm4gLTE7DQo+Pj4gICAgDQo+Pj4gLQlyZXR1
cm4gcmV0ID8gOiB2YWw7DQo+Pj4gKwlyZWNvcmQgPSB0cmFjZWNtZF9yZWFkX2F0KGtzaGFya19j
dHgtPmhhbmRsZSwgZS0+b2Zmc2V0LCBOVUxMKTsNCj4+PiArCXJldCA9IHRlcF9yZWFkX251bWJl
cl9maWVsZChwaWRfZmllbGQsIHJlY29yZC0+ZGF0YSwgJnZhbCk7DQo+Pj4gKwlmcmVlX3JlY29y
ZChyZWNvcmQpOw0KPj4+ICsNCj4+PiArCWlmIChyZXQpDQo+Pj4gKwkJcmV0dXJuIC0xOw0KPj4+
ICsNCj4+PiArCXJldHVybiB2YWw7DQo+Pj4gK30NCj4+PiArDQo+Pj4gK3N0YXRpYyBib29sIHdh
a2V1cF9tYXRjaF9yZWNfcGlkKHN0cnVjdCBwbHVnaW5fc2NoZWRfY29udGV4dCAqcGx1Z2luX2N0
eCwNCj4+PiArCQkJCSBzdHJ1Y3Qga3NoYXJrX2NvbnRleHQgKmtzaGFya19jdHgsDQo+Pj4gKwkJ
CQkgc3RydWN0IGtzaGFya19lbnRyeSAqZSwNCj4+PiArCQkJCSBpbnQgcGlkKQ0KPj4+ICt7DQo+
Pj4gKwlzdHJ1Y3QgdGVwX2V2ZW50ICp3YWtldXBfZXZlbnRzW10gPSB7DQo+Pj4gKwkJcGx1Z2lu
X2N0eC0+c2NoZWRfd2FrZXVwX2V2ZW50LA0KPj4+ICsJCXBsdWdpbl9jdHgtPnNjaGVkX3dha2V1
cF9uZXdfZXZlbnQsDQo+Pj4gKwl9Ow0KPj4+ICsJc3RydWN0IHRlcF9mb3JtYXRfZmllbGQgKndh
a2V1cF9maWVsZHNbXSA9IHsNCj4+PiArCQlwbHVnaW5fY3R4LT5zY2hlZF93YWtldXBfcGlkX2Zp
ZWxkLA0KPj4+ICsJCXBsdWdpbl9jdHgtPnNjaGVkX3dha2V1cF9uZXdfcGlkX2ZpZWxkLA0KPj4+
ICsJfTsNCj4+PiArCWludCBpLCB3YWtldXBfcGlkID0gLTE7DQo+Pj4gKw0KPj4+ICsJZm9yIChp
ID0gMDsgaSA8IHNpemVvZih3YWtldXBfZXZlbnRzKSAvIHNpemVvZih3YWtldXBfZXZlbnRzWzBd
KTsgaSsrKSB7DQo+Pj4gKwkJd2FrZXVwX3BpZCA9IGZpbmRfd2FrZXVwX3BpZChrc2hhcmtfY3R4
LCBlLCB3YWtldXBfZXZlbnRzW2ldLCB3YWtldXBfZmllbGRzW2ldKTsNCj4+PiArCQlpZiAod2Fr
ZXVwX3BpZCA+PSAwKQ0KPj4+ICsJCQlicmVhazsNCj4+PiArCX0NCj4+PiArDQo+Pj4gKwlpZiAo
d2FrZXVwX3BpZCA+PSAwICYmIHdha2V1cF9waWQgPT0gcGlkKQ0KPj4+ICsJCXJldHVybiB0cnVl
Ow0KPj4+ICsNCj4+PiArCXJldHVybiBmYWxzZTsNCj4+PiAgICB9DQo+Pj4gICAgDQo+Pj4gICAg
LyoqDQo+Pj4gQEAgLTE2OCwzMSArMjEzLDEyIEBAIGJvb2wgcGx1Z2luX3dha2V1cF9tYXRjaF9y
ZWNfcGlkKHN0cnVjdCBrc2hhcmtfY29udGV4dCAqa3NoYXJrX2N0eCwNCj4+PiAgICAJCQkJIGlu
dCBwaWQpDQo+Pj4gICAgew0KPj4+ICAgIAlzdHJ1Y3QgcGx1Z2luX3NjaGVkX2NvbnRleHQgKnBs
dWdpbl9jdHg7DQo+Pj4gLQlzdHJ1Y3QgdGVwX3JlY29yZCAqcmVjb3JkID0gTlVMTDsNCj4+PiAt
CWludCB3YWtldXBfcGlkID0gLTE7DQo+Pj4gICAgDQo+Pj4gICAgCXBsdWdpbl9jdHggPSBwbHVn
aW5fc2NoZWRfY29udGV4dF9oYW5kbGVyOw0KPj4+ICAgIAlpZiAoIXBsdWdpbl9jdHgpDQo+Pj4g
ICAgCQlyZXR1cm4gZmFsc2U7DQo+Pj4gICAgDQo+Pj4gLQlpZiAocGx1Z2luX2N0eC0+c2NoZWRf
d2FrZXVwX2V2ZW50ICYmDQo+Pj4gLQkgICAgZS0+ZXZlbnRfaWQgPT0gcGx1Z2luX2N0eC0+c2No
ZWRfd2FrZXVwX2V2ZW50LT5pZCkgew0KPj4+IC0JCXJlY29yZCA9IHRyYWNlY21kX3JlYWRfYXQo
a3NoYXJrX2N0eC0+aGFuZGxlLCBlLT5vZmZzZXQsIE5VTEwpOw0KPj4+IC0JCXdha2V1cF9waWQg
PSBwbHVnaW5fZ2V0X3JlY193YWtldXBfcGlkKHJlY29yZCk7DQo+Pj4gLQl9DQo+Pj4gLQ0KPj4+
IC0JaWYgKHBsdWdpbl9jdHgtPnNjaGVkX3dha2V1cF9uZXdfZXZlbnQgJiYNCj4+PiAtCSAgICBl
LT5ldmVudF9pZCA9PSBwbHVnaW5fY3R4LT5zY2hlZF93YWtldXBfbmV3X2V2ZW50LT5pZCkgew0K
Pj4+IC0JCXJlY29yZCA9IHRyYWNlY21kX3JlYWRfYXQoa3NoYXJrX2N0eC0+aGFuZGxlLCBlLT5v
ZmZzZXQsIE5VTEwpOw0KPj4+IC0JCXdha2V1cF9waWQgPSBwbHVnaW5fZ2V0X3JlY193YWtldXBf
bmV3X3BpZChyZWNvcmQpOw0KPj4+IC0JfQ0KPj4+IC0NCj4+PiAtCWZyZWVfcmVjb3JkKHJlY29y
ZCk7DQo+Pj4gLQ0KPj4+IC0JaWYgKHdha2V1cF9waWQgPj0gMCAmJiB3YWtldXBfcGlkID09IHBp
ZCkNCj4+PiAtCQlyZXR1cm4gdHJ1ZTsNCj4+PiAtDQo+Pj4gLQlyZXR1cm4gZmFsc2U7DQo+Pj4g
KwlyZXR1cm4gd2FrZXVwX21hdGNoX3JlY19waWQocGx1Z2luX2N0eCwga3NoYXJrX2N0eCwgZSwg
cGlkKTsNCj4+PiAgICB9DQo+Pj4gICANCj4+DQo+PiBJIHNlZSBubyBwb2ludCBpbiBkZWZpbmlu
ZyAic3RhdGljIGJvb2wgd2FrZXVwX21hdGNoX3JlY19waWQoKSIgYW5kIHRoZW4NCj4+IGhhdmlu
ZyAicGx1Z2luX3dha2V1cF9tYXRjaF9yZWNfcGlkKCkiIHdoaWNoIGlzIGRvaW5nIG5vdGhpbmcg
YnV0IGp1c3QNCj4+IGNhbGxpbmcgdGhpcyBzdGF0aWMgZnVuY3Rpb24uDQo+IA0KPiBJdCdzIGJl
Y2F1c2Ugb2YgdGhlIGluaXRpYWxpemF0aW9uIG9mIHdha2V1cF9ldmVudHMgYW5kIHdha2V1cF9m
aWVsZHMuDQo+IA0KPiAJc3RydWN0IHRlcF9ldmVudCAqd2FrZXVwX2V2ZW50c1tdID0gew0KPiAJ
CXBsdWdpbl9jdHgtPnNjaGVkX3dha2luZ19ldmVudCwNCj4gCQlwbHVnaW5fY3R4LT5zY2hlZF93
YWtldXBfZXZlbnQsDQo+IAkJcGx1Z2luX2N0eC0+c2NoZWRfd2FrZXVwX25ld19ldmVudCwNCj4g
CX07DQo+IAlzdHJ1Y3QgdGVwX2Zvcm1hdF9maWVsZCAqd2FrZXVwX2ZpZWxkc1tdID0gew0KPiAJ
CXBsdWdpbl9jdHgtPnNjaGVkX3dha2luZ19waWRfZmllbGQsDQo+IAkJcGx1Z2luX2N0eC0+c2No
ZWRfd2FrZXVwX3BpZF9maWVsZCwNCj4gCQlwbHVnaW5fY3R4LT5zY2hlZF93YWtldXBfbmV3X3Bp
ZF9maWVsZCwNCj4gCX07DQo+IA0KPiBXaGljaCBhcmUgaW5pdGlhbGl6ZWQgYnkgdGhlIHZhbHVl
cyBpbiBwbHVnaW5fY3R4LCBidXQgcGx1Z2luX2N0eCBpcw0KPiBub3QgaW5pdGlhbGl6ZWQgdW50
aWwgYWZ0ZXIgdGhlIHN0YXRpYyBpcyBzZXQgdXA6DQo+IA0KPiAJcGx1Z2luX2N0eCA9IHBsdWdp
bl9zY2hlZF9jb250ZXh0X2hhbmRsZXI7DQo+IAlpZiAoIXBsdWdpbl9jdHgpDQo+IAkJcmV0dXJu
IGZhbHNlOw0KPiANCj4gVGh1cyB0byBoYW5kbGUgdGhpcyBjYXNlLCBJIHNpbXBseSBtb3ZlZCB0
aGUgY29kZSBpbnRvIGEgaGVscGVyDQo+IGZ1bmN0aW9uLCBhbmQgaGFkIHRoZSBtYWluIGZ1bmN0
aW9uIGp1c3QgaW5pdGlhbGl6ZSBwbHVnaW5fY3R4IChyZXR1cm4NCj4gaWYgTlVMTCksIGFuZCB0
aGVuIGNhbGwgdGhlIGhlbHBlciBmdW5jdGlvbiB0aGF0IGNhbiBpbml0aWFsaXplIHRoZQ0KPiBh
cnJheXMgb24gdGhlIHN0YWNrLg0KPiANCj4gTWFrZSBzZW5zZT8NCj4gDQoNClRoaXMgaXMgT0sg
YXMgd2VsbC4NCg0KVGhhbmsgeW91IHZlcnkgbXVjaCENCllvcmRhbg0KDQo+IC0tIFN0ZXZlDQo+
IA0KPiANCj4+DQo+PiBFdmVyeXRoaW5nIGVsc2UgaW4gdGhpcyBwYXRjaCBzZXJpZXMgaXMgT0su
DQo+Pg0KPj4gVGhhbmsgeW91IHZlcnkgbXVjaCENCj4+IFlvcmRhbg0KPj4NCj4+DQo+PiBSZXZp
ZXdlZC1ieTogWW9yZGFuIEthcmFkemhvdiA8eWthcmFkemhvdkB2bXdhcmUuY29tPg0KPj4NCj4+
DQo+Pj4gICAgLyoqDQo+Pj4gICAgDQo+IA0K
