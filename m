Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F12C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 17:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 214D12064A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 17:39:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="ofq05HLa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfCKRjO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 13:39:14 -0400
Received: from mail-eopbgr790042.outbound.protection.outlook.com ([40.107.79.42]:38656
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726641AbfCKRjO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 13:39:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zkOdKA2nM1+P6NYvOj6ECQXHxjQ+YDZkfifiemC0l8=;
 b=ofq05HLaE9IlkY7W9APloTE/8yoo5S0ZjzAWBi5fyb9Ta0yYVXP7jZLvaZWRZ18ex9dq4FqUKlAo4FNUYdQQAHnZV5uNA7ZL1mctFBlsu20rWIMTEcl3GBq0Rzi8gW+lPabZaOxSk96nRl+ykxjgwWtktNy6t0X6Ckhk0NOLgsw=
Received: from DM5PR0501MB3893.namprd05.prod.outlook.com (10.167.108.32) by
 DM5PR0501MB3863.namprd05.prod.outlook.com (10.167.108.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.12; Mon, 11 Mar 2019 17:39:12 +0000
Received: from DM5PR0501MB3893.namprd05.prod.outlook.com
 ([fe80::e54a:7d5:311:61eb]) by DM5PR0501MB3893.namprd05.prod.outlook.com
 ([fe80::e54a:7d5:311:61eb%5]) with mapi id 15.20.1709.011; Mon, 11 Mar 2019
 17:39:11 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     Slavomir Kaslev <slavomir.kaslev@gmail.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/4] kernel-shark: Define addPlugin method for
 KsPluginManager
Thread-Topic: [PATCH 1/4] kernel-shark: Define addPlugin method for
 KsPluginManager
Thread-Index: AQHU1dJoSjjo2Rnq4Umj9o3i49Hf/6YGYO4AgABWDYA=
Date:   Mon, 11 Mar 2019 17:39:11 +0000
Message-ID: <3a983bd7-1c93-4bfe-8ead-ff98eefbc6a8@vmware.com>
References: <20190308171405.15266-1-ykaradzhov@vmware.com>
 <20190308171405.15266-2-ykaradzhov@vmware.com>
 <CAE0o1Nv7xkKyFnpYYT4vfpwpQYc_LiNKPuv7aAf7PYUoEUkCTQ@mail.gmail.com>
In-Reply-To: <CAE0o1Nv7xkKyFnpYYT4vfpwpQYc_LiNKPuv7aAf7PYUoEUkCTQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR08CA0098.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::24) To DM5PR0501MB3893.namprd05.prod.outlook.com
 (2603:10b6:4:7b::32)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.87.198.56]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca023902-86bc-4272-cadd-08d6a64878b3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:DM5PR0501MB3863;
x-ms-traffictypediagnostic: DM5PR0501MB3863:
x-microsoft-antispam-prvs: <DM5PR0501MB3863CA92A8235183A18284B1A0480@DM5PR0501MB3863.namprd05.prod.outlook.com>
x-forefront-prvs: 09730BD177
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(6029001)(366004)(346002)(136003)(396003)(376002)(39860400002)(189003)(199004)(229853002)(6486002)(68736007)(105586002)(106356001)(31686004)(2906002)(6116002)(3846002)(54906003)(316002)(66066001)(6246003)(486006)(14444005)(8936002)(256004)(478600001)(53936002)(6506007)(386003)(446003)(2616005)(476003)(102836004)(7736002)(53546011)(6436002)(36756003)(305945005)(71200400001)(6512007)(71190400001)(14454004)(5660300002)(31696002)(6916009)(25786009)(186003)(4326008)(6346003)(99286004)(86362001)(8676002)(81156014)(81166006)(97736004)(52116002)(76176011)(26005)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR0501MB3863;H:DM5PR0501MB3893.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Zppa0XJdV2Q9nc2Fochdw9/qJ45E0rkZmyotPYIEINXFNTF61DlpTh50Q6rHokOXzfo59a2j++NzSe9yH5m3iNHmxpA0N61Qkjup4Y4VapUTOjCIQdy81pytqwS+l2pYjgZxaa8BQuDEeYtgzSl2kPonxPimXMIZhF/ULUV7UxHOECjJL9HcagLiuBFk8yMAsjJaq7XX3vERjfT3G2LDgeIWLfxU4b2/gcQSq5HKtB1lgnPd8Jy4hibvIRbzzi52bagTTgRO6KLf8t/NlTGmCBZfBATFyFpMxN/1SAQX3iELD5Ejk1QCry5/4BwIEoBNwrmEfsB++eb+HI8F7PmyPco94d3s5f8crc5o90OwC7ElcRQPC7hSY1owZoHS4X4+WE1j6YdIiV8EKBMPX8gmrbZZA299uFiHuHR2zrsgWlk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <325ADA1FC546124CA3F44C5D3ADDB3EF@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca023902-86bc-4272-cadd-08d6a64878b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2019 17:39:11.9356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0501MB3863
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQoNCk9uIDExLjAzLjE5INCzLiAxNDozMSDRhy4sIFNsYXZvbWlyIEthc2xldiB3cm90ZToNCj4g
T24gRnJpLCBNYXIgOCwgMjAxOSBhdCA3OjE0IFBNIFlvcmRhbiBLYXJhZHpob3YgPHlrYXJhZHpo
b3ZAdm13YXJlLmNvbT4gd3JvdGU6DQo+Pg0KPj4gVGhlIG1ldGhvZCBjYW4gYmUgdXNlZCB0byBy
ZWdpc3RlciBhbmQgbG9hZCBhIHVzZXItZGVmaW5lZCBwbHVnaW4uDQo+PiBBbGwgb3RoZXIgcHJl
dmlvdXNseSBsb2FkZWQgcGx1Z2lucyB3aWxsIGJlIHJlbG9hZGVkLg0KPj4NCj4+IFNpZ25lZC1v
ZmYtYnk6IFlvcmRhbiBLYXJhZHpob3YgPHlrYXJhZHpob3ZAdm13YXJlLmNvbT4NCj4+IC0tLQ0K
Pj4gICBrZXJuZWwtc2hhcmsvc3JjL0tzVXRpbHMuY3BwIHwgMTcgKysrKysrKysrKysrKysrKysN
Cj4+ICAga2VybmVsLXNoYXJrL3NyYy9Lc1V0aWxzLmhwcCB8ICAzICsrKw0KPj4gICAyIGZpbGVz
IGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKykNCj4+DQo+PiBkaWZmIC0tZ2l0IGEva2VybmVsLXNo
YXJrL3NyYy9Lc1V0aWxzLmNwcCBiL2tlcm5lbC1zaGFyay9zcmMvS3NVdGlscy5jcHANCj4+IGlu
ZGV4IGQ3YjE3NTMuLjRkMDViZGEgMTAwNjQ0DQo+PiAtLS0gYS9rZXJuZWwtc2hhcmsvc3JjL0tz
VXRpbHMuY3BwDQo+PiArKysgYi9rZXJuZWwtc2hhcmsvc3JjL0tzVXRpbHMuY3BwDQo+PiBAQCAt
NTk2LDYgKzU5NiwyMyBAQCB2b2lkIEtzUGx1Z2luTWFuYWdlcjo6dW5yZWdpc3RlclBsdWdpbihj
b25zdCBRU3RyaW5nICZwbHVnaW4pDQo+PiAgICAgICAgICB9DQo+PiAgIH0NCj4+DQo+PiArLyoq
IEBicmllZiBBZGQgdG8gdGhlIGxpc3QgYW5kIGxvYWQgYSB1c2VyLXByb3ZpZGVkIHBsdWdpbi4g
QWxsIG90aGVyDQo+PiArICogICAgICAgIHByZXZpb3VzbHkgbG9hZGVkIHBsdWdpbnMgd2lsbCBi
ZSByZWxvYWRlZC4NCj4+ICsgKg0KPj4gKyAqIEBwYXJhbSBmaWxlTmFtZTogdGhlIGxpYnJhcnkg
ZmlsZSAoLnNvKSBvZiB0aGUgcGx1Z2luLg0KPj4gKyovDQo+PiArdm9pZCBLc1BsdWdpbk1hbmFn
ZXI6OmFkZFBsdWdpbihjb25zdCBRU3RyaW5nICZmaWxlTmFtZSkNCj4+ICt7DQo+PiArICAgICAg
IGtzaGFya19jb250ZXh0ICprc2hhcmtfY3R4KG51bGxwdHIpOw0KPj4gKw0KPj4gKyAgICAgICBp
ZiAoIWtzaGFya19pbnN0YW5jZSgma3NoYXJrX2N0eCkpDQo+PiArICAgICAgICAgICAgICAgcmV0
dXJuOw0KPj4gKw0KPj4gKyAgICAgICBrc2hhcmtfaGFuZGxlX3BsdWdpbnMoa3NoYXJrX2N0eCwg
S1NIQVJLX1BMVUdJTl9DTE9TRSk7DQo+PiArICAgICAgIHJlZ2lzdGVyUGx1Z2luKGZpbGVOYW1l
KTsNCj4+ICsgICAgICAga3NoYXJrX2hhbmRsZV9wbHVnaW5zKGtzaGFya19jdHgsIEtTSEFSS19Q
TFVHSU5fSU5JVCk7DQo+PiArfQ0KPiANCj4gQ2FsbGluZyBhZGRQbHVnaW4oKSBzZXZlcmFsIHRp
bWVzIGluIGEgcm93IHdpbGwgcmVpbml0aWFsaXplIGFsbA0KPiBhbHJlYWR5IHJlZ2lzdGVyZWQg
cGx1Z2lucyBzZXZlcmFsIHRpbWVzIGFuZCBsZWFkIHRvIHF1YWRyYXRpYw0KPiBjb21wbGV4aXR5
LiBUaGlzIHNlZW1zIHdyb25nIHRvIG1lLg0KPiANCj4gTWF5YmUgd2Ugc2hvdWxkIHNwbGl0IGFk
ZGluZyBwbHVnaW5zIGZyb20gKHJlLSlpbml0aWFsaXppbmcgdGhlbSBzbw0KPiB0aGF0IG9uZSBj
YW4gYWRkIHNldmVyYWwgcGx1Z2lucyBhbmQgdGhlbiBoYXZlIGluaXRpYWxpemVkIG9uY2Ugd2hl
bg0KPiB0aGV5IGFyZSBhY3R1YWxseSBuZWVkZWQgdG8gcnVuLiBXZHl0Pw0KPiANCg0KSGkgU2xh
dmksDQoNCktzUGx1Z2luTWFuYWdlciBpcyBhIGhlbHBlciBjbGFzcyBmb3IgdGhlIEdVSS4gSXQg
b25seSBkb2VzIHdoYXQgdGhlIEdVSSANCmlzIHN1cHBvc2VkIHRvIGRvLiBDdXJyZW50bHkgdGhl
IGRpYWxvZyB0aGF0IGFsbG93cyB0byBsb2FkIHVzZXIgcGx1Z2lucyANCnByb3ZpZGVzIGxvYWRp
bmcgb25seSBvbmUgcGx1Z2luIGF0IGEgdGltZSwgc28gdGhlIEtzUGx1Z2luTWFuYWdlciANCnBy
b3ZpZGVzIG9ubHkgdGhpcyBmdW5jdGlvbmFsaXR5Lg0KDQpTbyB0aGUgcXVlc3Rpb25zIGlzOiBk
byB3ZSB3YW50IGEgZGlhbG9nIHRoYXQgbG9hZHMgbXVsdGlwbGUgcGx1Z2lucyANCndpdGggb25l
IGNsaWNrPw0KDQpPbiB0aGUgb3RoZXIgaGFuZCB3ZSBkbyBlbmNvdXJhZ2UgdGhlIHVzZXJzIHRv
IHVzZSB0aGUgS2VybmVsU2hhcmsgDQpsaWJyYXJ5IGZvciBtYWtpbmcgY3VzdG9tIGFwcGxpY2F0
aW9ucy4gVGhpcyBpcyB0aGUgbW90aXZhdGlvbiBmb3IgDQpoYXZpbmcgdGhlIEMgQVBJLCBidXQg
S3NQbHVnaW5NYW5hZ2VyIGl0IGlzIG5vdCBwYXJ0IG9mIHRoaXMgQVBJLiANCktzUGx1Z2luTWFu
YWdlciBvcGVyYXRlcyBvbiB0b3Agb2YgdGhlIEFQSSBhbmQgaXMgaW50ZW5kZWQgdG8gYmUgdXNl
ZCANCm9ubHkgYnkgdGhlIEdVSSBjb2RlLg0KDQpJbmRlZWQgdGhlIEMgQVBJIGl0c2VsZiBzZXBh
cmF0ZXMgYWRkaW5nIHBsdWdpbnMgZnJvbSB0aGVyZSBpbml0aWFsaXppbmcuDQoNClRoYW5rcyBh
IGxvdCENClkuDQoNCg0KPiAtLVNsYXZpIA0KPiANCj4+ICsNCj4+ICAgLyoqIFVubG9hZCBhbGwg
cGx1Z2lucy4gKi8NCj4+ICAgdm9pZCBLc1BsdWdpbk1hbmFnZXI6OnVubG9hZEFsbCgpDQo+PiAg
IHsNCj4+IGRpZmYgLS1naXQgYS9rZXJuZWwtc2hhcmsvc3JjL0tzVXRpbHMuaHBwIGIva2VybmVs
LXNoYXJrL3NyYy9Lc1V0aWxzLmhwcA0KPj4gaW5kZXggY2I5NWI0Zi4uYWU3ZjZkMSAxMDA2NDQN
Cj4+IC0tLSBhL2tlcm5lbC1zaGFyay9zcmMvS3NVdGlscy5ocHANCj4+ICsrKyBiL2tlcm5lbC1z
aGFyay9zcmMvS3NVdGlscy5ocHANCj4+IEBAIC0yMTAsNiArMjEwLDkgQEAgcHVibGljOg0KPj4N
Cj4+ICAgICAgICAgIHZvaWQgcmVnaXN0ZXJQbHVnaW4oY29uc3QgUVN0cmluZyAmcGx1Z2luKTsN
Cj4+ICAgICAgICAgIHZvaWQgdW5yZWdpc3RlclBsdWdpbihjb25zdCBRU3RyaW5nICZwbHVnaW4p
Ow0KPj4gKw0KPj4gKyAgICAgICB2b2lkIGFkZFBsdWdpbihjb25zdCBRU3RyaW5nICZmaWxlTmFt
ZSk7DQo+PiArDQo+PiAgICAgICAgICB2b2lkIHVubG9hZEFsbCgpOw0KPj4NCj4+ICAgICAgICAg
IHZvaWQgdXBkYXRlUGx1Z2lucyhRVmVjdG9yPGludD4gcGx1Z2luSWQpOw0KPj4gLS0NCj4+IDIu
MTkuMQ0KPj4NCj4gDQo+IA0K
