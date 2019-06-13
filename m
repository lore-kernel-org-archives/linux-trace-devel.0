Return-Path: <SRS0=Le/E=UM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E57C31E4A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43D2D20B7C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:00:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="rSBDB1iU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732884AbfFMPA3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:00:29 -0400
Received: from mail-eopbgr730061.outbound.protection.outlook.com ([40.107.73.61]:37066
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732586AbfFMOsG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 10:48:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxKBxXpyqTq4ckZAhwG9YQFLrSK8VnKalhxW1gAWMaU=;
 b=rSBDB1iUWyoHeBr96Af+h43S4tzE1WMbXe5584kpuLdADq98Lu7+u57qBF7hJ30+8VCF+yAniAhPTGgw337/n3AgcRfaPxDBHRdb6POB8A/1p7Za+NAs3DcPjs9fqA4qys8gRMbKDLKLXeHPEgUlMTX6GqpDixre2s+Lhl3NhG8=
Received: from DM6PR05MB4044.namprd05.prod.outlook.com (20.176.71.154) by
 DM6PR05MB5004.namprd05.prod.outlook.com (20.177.223.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.5; Thu, 13 Jun 2019 14:48:03 +0000
Received: from DM6PR05MB4044.namprd05.prod.outlook.com
 ([fe80::c5ce:1ccd:9894:2181]) by DM6PR05MB4044.namprd05.prod.outlook.com
 ([fe80::c5ce:1ccd:9894:2181%7]) with mapi id 15.20.1987.010; Thu, 13 Jun 2019
 14:48:03 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/3] trace-cmd: Have --max-graph-depth only be part of
 instance
Thread-Topic: [PATCH 2/3] trace-cmd: Have --max-graph-depth only be part of
 instance
Thread-Index: AQHVIUuBSczqQun2cUSCH933qW9zqqaZq1SA
Date:   Thu, 13 Jun 2019 14:48:02 +0000
Message-ID: <CACqStofZOZrFJMh9WqJkK80LKhxugOHXeH2c0gDQpZhGO8Y=iw@mail.gmail.com>
References: <20190612181927.608151291@goodmis.org>
 <20190612182019.007518394@goodmis.org>
In-Reply-To: <20190612182019.007518394@goodmis.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR01CA0003.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:69::16) To DM6PR05MB4044.namprd05.prod.outlook.com
 (2603:10b6:5:8f::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAWKU6kgwQAJXeHv7skWmRc0+djNQgJRNQmRGFIB622Uq33+uXQr
        GF9l6ICrAuX4fY3L9XHQh8nM6amz+UJNf9neMb0=
x-google-smtp-source: APXvYqwlF+INkukfIasRNlqPFIsWRgG1xqnBEX0mERiAsctn1y3vWl1iRHj6nDPYcsZlexZmW81cV9qdmp106aFKjHY=
x-received: by 2002:a7b:cb01:: with SMTP id u1mr4461363wmj.153.1560437276609;
 Thu, 13 Jun 2019 07:47:56 -0700 (PDT)
x-gmail-original-message-id: <CACqStofZOZrFJMh9WqJkK80LKhxugOHXeH2c0gDQpZhGO8Y=iw@mail.gmail.com>
x-originating-ip: [209.85.128.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 349dcd73-de73-4825-01c9-08d6f00e2306
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR05MB5004;
x-ms-traffictypediagnostic: DM6PR05MB5004:
x-microsoft-antispam-prvs: <DM6PR05MB5004356C36B84D2597C13149DCEF0@DM6PR05MB5004.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(396003)(346002)(376002)(136003)(189003)(199004)(4326008)(305945005)(73956011)(66446008)(64756008)(66556008)(66476007)(66946007)(6862004)(9686003)(5660300002)(6512007)(53936002)(25786009)(8676002)(81166006)(81156014)(99286004)(256004)(61726006)(14444005)(95326003)(7736002)(6246003)(61266001)(446003)(102836004)(8936002)(52116002)(66066001)(316002)(6506007)(386003)(76176011)(476003)(11346002)(53546011)(86362001)(26005)(486006)(71200400001)(71190400001)(186003)(68736007)(2906002)(14454004)(6116002)(3846002)(55446002)(6436002)(6486002)(229853002)(498394004)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB5004;H:DM6PR05MB4044.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VAc1BGejkEpMV60RXt+cERWuCO8deHFndwKHIttOgOGy3lexFdLQeJLMlU5DiYocA/O1NY4FoMPaNXDz8Rpt+rCjtT51I7xgNoQp6FnUe+6wtRPoIbVGsHIgoFbMkNzmJnPbudA6X92qTVmUhoYPxrPsjUecUJA7eMUHd7wNk4fV6gzsPt9Eh4EPECCQjqLO3LzBAQO/FOl2fujdg2WHA8D7Bbe1JE1w39MfD+rzUBtNcLIBlvtiwnk3C+ZxYXoombzUXfM49X7SJSaIy5Y5n/TO+PQFHdTL8t3bqMc2Q96PigNbmfZr1sAclve5f6gbAr0VN9zgc6jKEV/5ZSxQ2oKJ459x78vGv/D7cEWbIbM5rOJODZIzggioDr+O0voJOGqPeNj+0/nDSNdN8BdoF/j5iG3CEDPmTN7ckvagtm4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <406EC72FDBBA3F4CA73542DC707C0324@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 349dcd73-de73-4825-01c9-08d6f00e2306
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 14:48:02.9677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tstoyanov@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB5004
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCBKdW4gMTIsIDIwMTkgYXQgOToxOSBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IEZyb206ICJTdGV2ZW4gUm9zdGVkdCAoVk13YXJlKSIg
PHJvc3RlZHRAZ29vZG1pcy5vcmc+DQo+DQo+IE5ldyBrZXJuZWxzIHdpbGwgYWxsb3cgZnVuY3Rp
b24gZ3JhcGggdHJhY2VyIHRvIGJlIHVzZWQgaW4gYW4gaW5zdGFuY2UsDQo+IHdoaWNoIG1lYW5z
IHRoYXQgdGhlIG1heF9ncmFwaF9kZXB0aCBmaWxlIHdpbGwgYmUgcGVyIGluc3RhbmNlIGFuZCBu
b3QganVzdA0KPiB0aGUgdG9wIGxldmVsIGZpbGUuIE1ha2UgdGhlIG1heF9ncmFwaF9kZXB0aCBh
c3NvY2lhdGVkIHRvIHRoZSBpbnN0YW5jZSBhbmQNCj4gbm90IHBhcnQgb2YgdGhlIHRyYWNlIHJl
Y29yZCBjb250ZXh0Lg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBTdGV2ZW4gUm9zdGVkdCAoVk13YXJl
KSA8cm9zdGVkdEBnb29kbWlzLm9yZz4NCj4gLS0tDQoNCkxvb2tzIE9LLg0KUmV2aWV3ZWQtYnk6
IFR6dmV0b21pciBTdG95YW5vdiA8dHN0b3lhbm92QHZtd2FyZS5jb20+DQoNCj4gIHRyYWNlY21k
L2luY2x1ZGUvdHJhY2UtbG9jYWwuaCB8ICAyICsrDQo+ICB0cmFjZWNtZC90cmFjZS1yZWNvcmQu
YyAgICAgICAgfCAyNyArKysrKysrKysrKysrKystLS0tLS0tLS0tLS0NCj4gIDIgZmlsZXMgY2hh
bmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQg
YS90cmFjZWNtZC9pbmNsdWRlL3RyYWNlLWxvY2FsLmggYi90cmFjZWNtZC9pbmNsdWRlL3RyYWNl
LWxvY2FsLmgNCj4gaW5kZXggYTFhMDZlOTE5NmI0Li4xY2FkM2NjYzRkZTcgMTAwNjQ0DQo+IC0t
LSBhL3RyYWNlY21kL2luY2x1ZGUvdHJhY2UtbG9jYWwuaA0KPiArKysgYi90cmFjZWNtZC9pbmNs
dWRlL3RyYWNlLWxvY2FsLmgNCj4gQEAgLTE4Myw2ICsxODMsOCBAQCBzdHJ1Y3QgYnVmZmVyX2lu
c3RhbmNlIHsNCj4gICAgICAgICBzdHJ1Y3QgdHJhY2VjbWRfbXNnX2hhbmRsZSAqbXNnX2hhbmRs
ZTsNCj4gICAgICAgICBzdHJ1Y3QgdHJhY2VjbWRfb3V0cHV0ICpuZXR3b3JrX2hhbmRsZTsNCj4N
Cj4gKyAgICAgICBjaGFyICAgICAgICAgICAgICAgICAgICAqbWF4X2dyYXBoX2RlcHRoOw0KPiAr
DQo+ICAgICAgICAgaW50ICAgICAgICAgICAgICAgICAgICAgZmxhZ3M7DQo+ICAgICAgICAgaW50
ICAgICAgICAgICAgICAgICAgICAgdHJhY2luZ19vbl9pbml0X3ZhbDsNCj4gICAgICAgICBpbnQg
ICAgICAgICAgICAgICAgICAgICB0cmFjaW5nX29uX2ZkOw0KPiBkaWZmIC0tZ2l0IGEvdHJhY2Vj
bWQvdHJhY2UtcmVjb3JkLmMgYi90cmFjZWNtZC90cmFjZS1yZWNvcmQuYw0KPiBpbmRleCBlZTM1
YWRhMTBkNmUuLjJkNzE2YTgxYWNiZiAxMDA2NDQNCj4gLS0tIGEvdHJhY2VjbWQvdHJhY2UtcmVj
b3JkLmMNCj4gKysrIGIvdHJhY2VjbWQvdHJhY2UtcmVjb3JkLmMNCj4gQEAgLTIwNyw3ICsyMDcs
NiBAQCBzdHJ1Y3QgY29tbW9uX3JlY29yZF9jb250ZXh0IHsNCj4gICAgICAgICBzdHJ1Y3QgYnVm
ZmVyX2luc3RhbmNlICppbnN0YW5jZTsNCj4gICAgICAgICBjb25zdCBjaGFyICpvdXRwdXQ7DQo+
ICAgICAgICAgY2hhciAqZGF0ZTJ0czsNCj4gLSAgICAgICBjaGFyICptYXhfZ3JhcGhfZGVwdGg7
DQo+ICAgICAgICAgaW50IGRhdGFfZmxhZ3M7DQo+DQo+ICAgICAgICAgaW50IHJlY29yZF9hbGw7
DQo+IEBAIC00ODkyLDkgKzQ4OTEsOSBAQCBzdGF0aWMgdm9pZCBwYXJzZV9yZWNvcmRfb3B0aW9u
cyhpbnQgYXJnYywNCj4gICAgICAgICAgICAgICAgICAgICAgICAgY3R4LT5kYXRhX2ZsYWdzIHw9
IERBVEFfRkxfT0ZGU0VUOw0KPiAgICAgICAgICAgICAgICAgICAgICAgICBicmVhazsNCj4gICAg
ICAgICAgICAgICAgIGNhc2UgT1BUX21heF9ncmFwaF9kZXB0aDoNCj4gLSAgICAgICAgICAgICAg
ICAgICAgICAgZnJlZShjdHgtPm1heF9ncmFwaF9kZXB0aCk7DQo+IC0gICAgICAgICAgICAgICAg
ICAgICAgIGN0eC0+bWF4X2dyYXBoX2RlcHRoID0gc3RyZHVwKG9wdGFyZyk7DQo+IC0gICAgICAg
ICAgICAgICAgICAgICAgIGlmICghY3R4LT5tYXhfZ3JhcGhfZGVwdGgpDQo+ICsgICAgICAgICAg
ICAgICAgICAgICAgIGZyZWUoY3R4LT5pbnN0YW5jZS0+bWF4X2dyYXBoX2RlcHRoKTsNCj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgY3R4LT5pbnN0YW5jZS0+bWF4X2dyYXBoX2RlcHRoID0gc3Ry
ZHVwKG9wdGFyZyk7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGlmICghY3R4LT5pbnN0YW5j
ZS0+bWF4X2dyYXBoX2RlcHRoKQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRp
ZSgiQ291bGQgbm90IGFsbG9jYXRlIG9wdGlvbiIpOw0KPiAgICAgICAgICAgICAgICAgICAgICAg
ICBicmVhazsNCj4gICAgICAgICAgICAgICAgIGNhc2UgT1BUX25vX2ZpbHRlcjoNCj4gQEAgLTUw
NTYsMTAgKzUwNTUsMTIgQEAgc3RhdGljIHZvaWQgcmVjb3JkX3RyYWNlKGludCBhcmdjLCBjaGFy
ICoqYXJndiwNCj4gICAgICAgICB1cGRhdGVfcGx1Z2lucyh0eXBlKTsNCj4gICAgICAgICBzZXRf
b3B0aW9ucygpOw0KPg0KPiAtICAgICAgIGlmIChjdHgtPm1heF9ncmFwaF9kZXB0aCkgew0KPiAt
ICAgICAgICAgICAgICAgZm9yX2FsbF9pbnN0YW5jZXMoaW5zdGFuY2UpDQo+IC0gICAgICAgICAg
ICAgICAgICAgICAgIHNldF9tYXhfZ3JhcGhfZGVwdGgoaW5zdGFuY2UsIGN0eC0+bWF4X2dyYXBo
X2RlcHRoKTsNCj4gLSAgICAgICAgICAgICAgIGZyZWUoY3R4LT5tYXhfZ3JhcGhfZGVwdGgpOw0K
PiArICAgICAgIGZvcl9hbGxfaW5zdGFuY2VzKGluc3RhbmNlKSB7DQo+ICsgICAgICAgICAgICAg
ICBpZiAoaW5zdGFuY2UtPm1heF9ncmFwaF9kZXB0aCkgew0KPiArICAgICAgICAgICAgICAgICAg
ICAgICBzZXRfbWF4X2dyYXBoX2RlcHRoKGluc3RhbmNlLCBpbnN0YW5jZS0+bWF4X2dyYXBoX2Rl
cHRoKTsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgZnJlZShpbnN0YW5jZS0+bWF4X2dyYXBo
X2RlcHRoKTsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgaW5zdGFuY2UtPm1heF9ncmFwaF9k
ZXB0aCA9IE5VTEw7DQo+ICsgICAgICAgICAgICAgICB9DQo+ICAgICAgICAgfQ0KPg0KPiAgICAg
ICAgIGFsbG9jYXRlX3NlcSgpOw0KPiBAQCAtNTE1NSwxMCArNTE1NiwxMiBAQCB2b2lkIHRyYWNl
X2V4dHJhY3QoaW50IGFyZ2MsIGNoYXIgKiphcmd2KQ0KPiAgICAgICAgIHVwZGF0ZV9wbHVnaW5z
KHR5cGUpOw0KPiAgICAgICAgIHNldF9vcHRpb25zKCk7DQo+DQo+IC0gICAgICAgaWYgKGN0eC5t
YXhfZ3JhcGhfZGVwdGgpIHsNCj4gLSAgICAgICAgICAgICAgIGZvcl9hbGxfaW5zdGFuY2VzKGlu
c3RhbmNlKQ0KPiAtICAgICAgICAgICAgICAgICAgICAgICBzZXRfbWF4X2dyYXBoX2RlcHRoKGlu
c3RhbmNlLCBjdHgubWF4X2dyYXBoX2RlcHRoKTsNCj4gLSAgICAgICAgICAgICAgIGZyZWUoY3R4
Lm1heF9ncmFwaF9kZXB0aCk7DQo+ICsgICAgICAgZm9yX2FsbF9pbnN0YW5jZXMoaW5zdGFuY2Up
IHsNCj4gKyAgICAgICAgICAgICAgIGlmIChpbnN0YW5jZS0+bWF4X2dyYXBoX2RlcHRoKSB7DQo+
ICsgICAgICAgICAgICAgICAgICAgICAgIHNldF9tYXhfZ3JhcGhfZGVwdGgoaW5zdGFuY2UsIGlu
c3RhbmNlLT5tYXhfZ3JhcGhfZGVwdGgpOw0KPiArICAgICAgICAgICAgICAgICAgICAgICBmcmVl
KGluc3RhbmNlLT5tYXhfZ3JhcGhfZGVwdGgpOw0KPiArICAgICAgICAgICAgICAgICAgICAgICBp
bnN0YW5jZS0+bWF4X2dyYXBoX2RlcHRoID0gTlVMTDsNCj4gKyAgICAgICAgICAgICAgIH0NCj4g
ICAgICAgICB9DQo+DQo+ICAgICAgICAgYWxsb2NhdGVfc2VxKCk7DQo+IC0tDQo+IDIuMjAuMQ0K
Pg0KPg0KDQoNCi0tDQoNClR6dmV0b21pciAoQ2VjbykgU3RveWFub3YNClZNd2FyZSBPcGVuIFNv
dXJjZSBUZWNobm9sb2d5IENlbnRlcg0K
