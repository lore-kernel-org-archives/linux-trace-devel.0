Return-Path: <SRS0=5+qO=TC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357C5C43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 15:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D414020675
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 15:23:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="LZIsprsZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfEBPXa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 May 2019 11:23:30 -0400
Received: from mail-eopbgr700051.outbound.protection.outlook.com ([40.107.70.51]:58080
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727042AbfEBPXa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 May 2019 11:23:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OdNSrZdBHH1lOgsftRLRTs9k6PxBPHvYYn8gjb9jYUc=;
 b=LZIsprsZtYUuKQo/UtVXHZlmZDSJXQlxZ6ZZabHIXhGOkqhzYJDg+A7Ouydmb3U4JUAZE1XRYnN6xVmuKY5qRkZ/luXez0Yn5FXaK3GmvWHkY4Jrg1o2QnhagLpOwFWAhOFCZQYXXUkcS3I0or3mhYQatD6sGR0yxpal/5vNluw=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2778.namprd05.prod.outlook.com (10.167.18.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Thu, 2 May 2019 15:23:28 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::780b:622f:d7c6:1003]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::780b:622f:d7c6:1003%3]) with mapi id 15.20.1878.004; Thu, 2 May 2019
 15:23:28 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v5 27/30] tools/lib/traceevent: Man pages for tep plugins
 APIs
Thread-Topic: [PATCH v5 27/30] tools/lib/traceevent: Man pages for tep plugins
 APIs
Thread-Index: AQHU8TULiY0hkkZ7xkymYiFdeVM9baZVmq4AgAJ4z4A=
Date:   Thu, 2 May 2019 15:23:27 +0000
Message-ID: <CACqStocBTaULG=DHX3_uJTAzki3fnPN+mdKoiYgQ9bCD-iUPyQ@mail.gmail.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
 <20190412133811.15878-28-tstoyanov@vmware.com>
 <20190430213816.61705657@oasis.local.home>
In-Reply-To: <20190430213816.61705657@oasis.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR05CA0091.eurprd05.prod.outlook.com
 (2603:10a6:208:136::31) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAVAbfjyeBflFUwweuuhHgxEuwpQf7s8ZDeG1vRqj309FpT56jKg
        lfS7b1udWqsGNB8MlOyRiYrA8Ptud1qMoCAnOyc=
x-google-smtp-source: APXvYqzve3ShG2nt11pol6Z9I/FqJTkM7Jjw/2Lu8AuPFy0wd7pZqTM2W4krdt4Ydh8xt4P5JLtONa9V9jrhLRkpD6Y=
x-received: by 2002:a7b:c25a:: with SMTP id b26mr2638626wmj.123.1556810602851;
 Thu, 02 May 2019 08:23:22 -0700 (PDT)
x-gmail-original-message-id: <CACqStocBTaULG=DHX3_uJTAzki3fnPN+mdKoiYgQ9bCD-iUPyQ@mail.gmail.com>
x-originating-ip: [209.85.128.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f758e20d-7a38-48a2-bd4c-08d6cf121fdc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:CY1PR05MB2778;
x-ms-traffictypediagnostic: CY1PR05MB2778:
x-microsoft-antispam-prvs: <CY1PR05MB27786238E79C2908E194BD68DC340@CY1PR05MB2778.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0025434D2D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(39860400002)(376002)(199004)(189003)(486006)(6512007)(305945005)(11346002)(446003)(95326003)(9686003)(186003)(229853002)(498394004)(53936002)(2906002)(6246003)(99286004)(25786009)(76176011)(386003)(6506007)(66446008)(6436002)(14454004)(3846002)(52116002)(7736002)(102836004)(476003)(6116002)(73956011)(66556008)(6486002)(86362001)(6862004)(66066001)(55446002)(4326008)(5660300002)(53546011)(478600001)(26005)(66946007)(64756008)(66476007)(316002)(71190400001)(81166006)(61726006)(14444005)(8936002)(8676002)(81156014)(68736007)(71200400001)(256004)(61266001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2778;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lGM6L/l2iGbnjuRGbcfuNgrol+ZUbJ75jE759UfjqOitzNKVf/QTQrwpol7L9XtNZE//hBrXMzHhYuAnFMA2TiPPb79ir1+R8vj8fiVsedIOb5x6GBZvJLJGczAl5c4m8sBXsevRaRJb5DjIhbfYSSLBOFA7+jQb/iBI6KdowzOfpq1d85twcpwNo/LqAop5Zkh0cWPUtMR3XCweyAf7M1Nl+84ftIOHm8i5JizI4rpM1KAbFwe2TY0XO/nPR3yu15bV+hiLtjM3jGZUcgXFiazXAzKVbXGRrZJgBIk5TPslLEkZlUvG3o05f6YGwgiTzBY7qUu1y3fZCjHsk+snV/IgmY7YvjbRDKzqLWtMKBSEiRJE7GAGdr8G1CosKqBwKSpuSRMae/pIag279Ngdsbn7aFE5CdWi7dBaD65HR5g=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E00FF83DC40A2F44A02CD77AF010D851@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f758e20d-7a38-48a2-bd4c-08d6cf121fdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2019 15:23:27.9232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2778
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCBNYXkgMSwgMjAxOSBhdCA0OjM4IEFNIFN0ZXZlbiBSb3N0ZWR0IDxyb3N0ZWR0QGdv
b2RtaXMub3JnPiB3cm90ZToNCj4NCj4gT24gRnJpLCAxMiBBcHIgMjAxOSAxNjozODowOCArMDMw
MA0KPiBUenZldG9taXIgU3RveWFub3YgPHRzdG95YW5vdkB2bXdhcmUuY29tPiB3cm90ZToNCj4N
Cj4gPiArREVTQ1JJUFRJT04NCj4gPiArLS0tLS0tLS0tLS0NCj4gPiArVGhlIF90ZXBfbG9hZF9w
bHVnaW5zKClfIGZ1bmN0aW9uIGxvYWRzIGFsbCBwbHVnaW5zLCBsb2NhdGVkIGluIHRoZSBwbHVn
aW4NCj4gPiArZGlyZWN0b3JpZXMuIFRoZSBfdGVwXyBhcmd1bWVudCBpcyB0cmFjZSBldmVudCBw
YXJzZXIgY29udGV4dC4NCj4gPiArVGhlIHBsdWdpbiBkaXJlY3RvcmllcyBhcmUgOg0KPiA+ICtb
dmVyc2VdDQo+ID4gKy0tDQo+ID4gKyAgICAgLSBTeXN0ZW0ncyBwbHVnaW4gZGlyZWN0b3J5LCBk
ZWZpbmVkIGF0IHRoZSBsaWJyYXJ5IGNvbXBpbGUgdGltZS4gSXQNCj4gPiArICAgICAgIGRlcGVu
ZHMgb24gdGhlIGxpYnJhcnkgaW5zdGFsbGF0aW9uIHByZWZpeCBhbmQgdXN1YWxseSBpcw0KPiA+
ICsgICAgICAgXyhpbnN0YWxsX3ByZWZmaXgpL2xpYi90cmFjZWV2ZW50L3BsdWdpbnNfDQo+ID4g
KyAgICAgLSBEaXJlY3RvcnksIGRlZmluZWQgYnkgdGhlIGVudmlyb25tZW50IHZhcmlhYmxlIF9U
UkFDRUVWRU5UX1BMVUdJTl9ESVJfDQo+ID4gKyAgICAgLSBVc2VyJ3MgcGx1Z2luIGRpcmVjdG9y
eSwgbG9jYXRlZCBhdCBffi8udHJhY2VldmVudC9wbHVnaW5zXw0KPg0KPiBXZSBzaG91bGQgY2hh
bmdlIHRoaXMgdG8gYmU6DQo+DQo+ICB+Ly5jb25maWcvdHJhY2VldmVudC9wbHVnaW5zL3BsdWdp
bnNfKi5zbw0KPg0KQ3VycmVudCBkaXJlY3RvcnkgaXMgfi8udHJhY2VldmVudC9wbHVnaW5zLiBJ
IHN1Z2dlc3QgdG8gcmVsZWFzZSB0aGUNCm1hbiBwYWdlIGluIHRoaXMgd2F5LCBhbmQgbGF0ZXIN
CndoZW4gd2UgY2hhbmdlIHRoZSBsaWJyYXJ5LCB0byB1cGRhdGUgdGhlIG1hbiBwYWdlIHdpdGgg
dGhlIG5ldyBwYXRoLg0KRG8geW91IHByZWZlciB0byBjaGFuZ2UNCnRoZSBwYXRoIGluIHRoZSBj
b2RlIGJlZm9yZSByZWxlYXNpbmcgdGhlIG1hbiBwYWdlcyA/DQoNCj4gLS0gU3RldmUNCg0KDQoN
Ci0tIA0KVHp2ZXRvbWlyIChDZWNvKSBTdG95YW5vdg0KVk13YXJlIE9wZW4gU291cmNlIFRlY2hu
b2xvZ3kgQ2VudGVyDQo=
