Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDFCC31E46
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 07:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5330E206BA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 07:34:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="u1qpFPY4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfFLHes (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 03:34:48 -0400
Received: from mail-eopbgr740078.outbound.protection.outlook.com ([40.107.74.78]:45939
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725959AbfFLHer (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 03:34:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ds6MWhaO9c0yFaA3yAVRCHl8QZ+y3uEvIOVw9I6cak=;
 b=u1qpFPY4my7Jbs6h6TDakJhuUlV/4Fv6TYVNIujmIYdur6dYWVPPFWrfqOAr7QCRZ6Qf3BHkkTOMw7scYNCSN97prPn29Cs2JNPAfYEdZLYB6uZz5OzgVVpBd1Np0uoBv3xyhJDN5ujr97Z6liLIrSOb23wwhqnppI3B9otvGfo=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3774.namprd05.prod.outlook.com (10.167.140.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Wed, 12 Jun 2019 07:34:35 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c%5]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 07:34:35 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     Alan Mikhak <alanmikhak@gmail.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     Alan Mikhak <amikhak@wirelessfabric.com>
Subject: Re: [PATCH] Fix compiler error in KsSession.cpp on Raspberry Pi 3
Thread-Topic: [PATCH] Fix compiler error in KsSession.cpp on Raspberry Pi 3
Thread-Index: AQHVINMxkbg6AOObv0iYg+xa645zVqaXoN6A
Date:   Wed, 12 Jun 2019 07:34:35 +0000
Message-ID: <b0108c01-00f4-fc5e-7fef-03e6984f361e@vmware.com>
References: <20190612035902.16366-1-amikhak@wirelessfabric.com>
In-Reply-To: <20190612035902.16366-1-amikhak@wirelessfabric.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR08CA0158.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::12) To SN4PR0501MB3903.namprd05.prod.outlook.com
 (2603:10b6:803:4d::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9cb4c37b-aa23-40a2-2043-08d6ef086a91
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN4PR0501MB3774;
x-ms-traffictypediagnostic: SN4PR0501MB3774:
x-microsoft-antispam-prvs: <SN4PR0501MB37748354856BFE7AC565005AA0EC0@SN4PR0501MB3774.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(6029001)(136003)(39860400002)(396003)(376002)(366004)(346002)(189003)(199004)(3846002)(73956011)(2906002)(256004)(8936002)(14444005)(11346002)(2501003)(6116002)(316002)(110136005)(229853002)(5660300002)(2201001)(53936002)(86362001)(6486002)(31696002)(64756008)(66476007)(66946007)(66556008)(6512007)(66446008)(6436002)(66066001)(6246003)(486006)(4326008)(25786009)(26005)(71190400001)(446003)(71200400001)(476003)(36756003)(478600001)(52116002)(7736002)(76176011)(81156014)(8676002)(99286004)(68736007)(386003)(6506007)(186003)(102836004)(14454004)(2616005)(305945005)(31686004)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3774;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cp8l66Yksf0tYyOC85LDFlU1MlZRS2cN/Mz3sqYLBL+GGRpHmYxbSjvVMnTuGJP440z/x0s2+mBFiOx8qzfzzl4DxexKLY9KAgez2CYlF2rLcPzFXRkHXRCxCFnF4UaDirixRjUSC1Ghz4R3VsQn0gnWz4GZ6OoUIz5NV5e+yebjK2vvAQq9rRphS638m2mHRxq+dsdgV8nZ0HMHOCNG5hGCyI3pmCjZqn+hmxZwk01UOfd3ozJhTu3af39U+vgQmLWa/BhyTUtlt9kGImfF+/E9al6y6K4pw6mh9isksbwQDvdigmg8Pz99n7HgTl9f5dAVnFzGE6k6RNnpQFxnXcN6JwS+vKsJbu/hq9KUNozMJzJpMXts3HxuYkv56D7q+T50ySsCkm+fuUSBBxx5eCgcp5CETtZI7TKWPS11k+8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB76E79FFE594E4A9F9AE806783B5691@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cb4c37b-aa23-40a2-2043-08d6ef086a91
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 07:34:35.0823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ykaradzhov@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3774
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQoNCk9uIDEyLjA2LjE5INCzLiA2OjU5INGHLiwgQWxhbiBNaWtoYWsgd3JvdGU6DQo+IEZpeCBj
b21waWxlciBlcnJvciBhdCBLc1Nlc3Npb24uY3BwOjQ1NzozMCBvbiBSYXNwYmVycnkgUGkgMw0K
PiANCj4gRml4IGJ5IGNoYW5naW5nIHRoZSB0eXBlIG9mIGxvY2FsIHZhcmlhYmxlICdwb3MnIGZy
b20gdWludDY0X3QgdG8NCj4gc2l6ZV90IGluIEtzU2Vzc2lvbjo6bG9hZER1YWxNYXJrZXIoKS4N
Cj4gDQo+IEtzU2Vzc2lvbi5jcHA6NDU3OjMwOiBlcnJvcjogbm8gbWF0Y2hpbmcgZnVuY3Rpb24g
Zm9yIGNhbGwgdG8NCj4g4oCYS3NTZXNzaW9uOjpfZ2V0TWFya2VyKGNvbnN0IGNoYXIgWzZdLCB1
aW50NjRfdCop4oCZDQo+ICAgIGlmIChfZ2V0TWFya2VyKCJtYXJrQSIsICZwb3MpKSB7DQo+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBeDQo+IEluIGZpbGUgaW5jbHVkZWQgZnJvbSBL
c1Nlc3Npb24uY3BwOjE0OjA6DQo+IEtzU2Vzc2lvbi5ocHA6OTc6Nzogbm90ZTogY2FuZGlkYXRl
Og0KPiAgIGJvb2wgS3NTZXNzaW9uOjpfZ2V0TWFya2VyKGNvbnN0IGNoYXIqLCBzaXplX3QqKQ0K
PiAgICBib29sIF9nZXRNYXJrZXIoY29uc3QgY2hhciogbmFtZSwgc2l6ZV90ICpwb3MpOw0KPiAg
ICAgICAgIF5+fn5+fn5+fn4NCj4gS3NTZXNzaW9uLmhwcDo5Nzo3OiBub3RlOiAgIG5vIGtub3du
IGNvbnZlcnNpb24gZm9yDQo+IGFyZ3VtZW50IDIgZnJvbSDigJh1aW50NjRfdCoge2FrYSBsb25n
IGxvbmcgdW5zaWduZWQgaW50Kn3igJkNCj4gdG8g4oCYc2l6ZV90KiB7YWthIHVuc2lnbmVkIGlu
dCp94oCZDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbGFuIE1pa2hhayA8YW1pa2hha0B3aXJlbGVz
c2ZhYnJpYy5jb20+DQo+IC0tLQ0KPiAgIGtlcm5lbC1zaGFyay9zcmMvS3NTZXNzaW9uLmNwcCB8
IDIgKy0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9rZXJuZWwtc2hhcmsvc3JjL0tzU2Vzc2lvbi5jcHAgYi9rZXJu
ZWwtc2hhcmsvc3JjL0tzU2Vzc2lvbi5jcHANCj4gaW5kZXggOWQ4Njc3Ni4uYTU4MWJiZiAxMDA2
NDQNCj4gLS0tIGEva2VybmVsLXNoYXJrL3NyYy9Lc1Nlc3Npb24uY3BwDQo+ICsrKyBiL2tlcm5l
bC1zaGFyay9zcmMvS3NTZXNzaW9uLmNwcA0KPiBAQCAtNDUwLDcgKzQ1MCw3IEBAIHZvaWQgS3NT
ZXNzaW9uOjpzYXZlRHVhbE1hcmtlcihLc0R1YWxNYXJrZXJTTSAqZG0pDQo+ICAgICovDQo+ICAg
dm9pZCBLc1Nlc3Npb246OmxvYWREdWFsTWFya2VyKEtzRHVhbE1hcmtlclNNICpkbSwgS3NUcmFj
ZUdyYXBoICpncmFwaHMpDQo+ICAgew0KPiAtCXVpbnQ2NF90IHBvczsNCj4gKwlzaXplX3QgcG9z
Ow0KPiAgIA0KPiAgIAlkbS0+cmVzZXQoKTsNCj4gICAJZG0tPnNldFN0YXRlKER1YWxNYXJrZXJT
dGF0ZTo6QSk7DQo+IA0KDQoNCkhpIEFsYW4sDQpUaGFua3MgYSBsb3QgZm9yIHRoaXMgZml4IQ0K
DQpSZXZpZXdlZC1ieTogWW9yZGFuIEthcmFkemhvdiA8eWthcmFkemhvdkB2bXdhcmUuY29tPg0K
DQpJIGFtIHJlYWxseSBjdXJpb3VzIHRvIGtub3cgaG93IGRvZXMgS2VybmVsU2hhcmsgbG9vayBh
bmQgZmVlbCBvbiANClJhc3BiZXJyeSBQaS4gV291bGQgeW91IHNoYXJlZCB3aXRoIHVzIHlvdXIg
aW1wcmVzc2lvbnMuDQpIb25lc3RseSwgSSB3aWxsIGJlIHN1cnByaXNlZCBpZiBldmVyeXRoaW5n
IHdvcmtzIGZpbmUgOykNCg0KQ2hlZXJzLA0KWW9yZGFuDQo=
