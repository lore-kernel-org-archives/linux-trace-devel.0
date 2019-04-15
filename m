Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 691A1C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 22:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2616B2087C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 22:55:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="OPIlFHdY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfDOWz2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 18:55:28 -0400
Received: from mail-eopbgr690055.outbound.protection.outlook.com ([40.107.69.55]:12512
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbfDOWz1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 18:55:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xw37DCXereRrSp6JkfnSsXmB7Jo6IoshhR7wOAckZ98=;
 b=OPIlFHdYlzsEhLlr8d7sXJMTcGz+L4ebnTMRr+BA1oq6OsRGbCDzCqYA/wUdolHCAAh/y+itK4oZCE4BGu1zXTJe5r8Flb1jfh/6GOEwQddDF+9RAxbN0wCGc84OkF2I4yqz8fY0/JvZky73oFECtjUnSFdmITbPKgaWpZTu2AY=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3883.namprd05.prod.outlook.com (10.167.173.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.9; Mon, 15 Apr 2019 22:55:24 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::3949:85c0:3b7b:136e]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::3949:85c0:3b7b:136e%5]) with mapi id 15.20.1813.009; Mon, 15 Apr 2019
 22:55:24 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "pauld@redhat.com" <pauld@redhat.com>,
        "jbacik@fb.com" <jbacik@fb.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: Re: [PATCH v2 1/2] trace-cmd: Optimize how pid filters are expressed
Thread-Topic: [PATCH v2 1/2] trace-cmd: Optimize how pid filters are expressed
Thread-Index: AQHU89Z9SlTzVR4cm0SlbHt4w5k/A6Y91PCA
Date:   Mon, 15 Apr 2019 22:55:24 +0000
Message-ID: <da9af70eb678d7a0c1cfd1c2565df96743df712f.camel@vmware.com>
References: <20190415164739.17223-1-kaslevs@vmware.com>
         <20190415164739.17223-2-kaslevs@vmware.com>
         <20190415175919.637f28f6@gandalf.local.home>
In-Reply-To: <20190415175919.637f28f6@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-originating-ip: [151.251.250.145]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d948b53-f113-4969-8f22-08d6c1f571ff
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600140)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR0501MB3883;
x-ms-traffictypediagnostic: MWHPR0501MB3883:
x-microsoft-antispam-prvs: <MWHPR0501MB3883137417EE425D9E421C3ADA2B0@MWHPR0501MB3883.namprd05.prod.outlook.com>
x-forefront-prvs: 000800954F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(366004)(396003)(136003)(346002)(189003)(199004)(25786009)(71190400001)(11346002)(446003)(6512007)(36756003)(105586002)(118296001)(71200400001)(106356001)(68736007)(6486002)(478600001)(26005)(7736002)(107886003)(2501003)(5660300002)(486006)(102836004)(5640700003)(97736004)(66066001)(6506007)(476003)(316002)(2616005)(54906003)(53936002)(2906002)(8936002)(14444005)(256004)(229853002)(3846002)(99286004)(6916009)(4326008)(81166006)(81156014)(8676002)(305945005)(6436002)(86362001)(186003)(1730700003)(76176011)(14454004)(6116002)(6246003)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3883;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nthIHT9c/js1BWOR3WlKbHDT8iOveGI0XMY+/T9u5dT7YP21obgTEKwAwhJrQUXHfNBZOVKW60lPeehOS3fkG3t1TCrWZ6q5i3Lj3Y//RGzMFhJLX8VDgty18epcwTm+eNdHTP5uSzrzc9gZZmOr7+UhyRcyQmGDpEgx9Ix3pWqJpFp4R/v1jtDyQHhqm/Kwum83SFon6l2aoTFI04pKphS4/9xonYHrSbf1lOqrsp0QR22bSAztqkkKXsHXV49pbuKYUayBJ10L5cE/H8/ndu2mA0Ww5O/8+xSUFi2L0Aei72GBXj+v5/pfhl+KdL489quu7k+8pCLGUY6VNy8zMvkZjqbtg/aeZY1PUX29wt8TBaxEP4laAfw68f17ntb36MJx9tuH7hgw+R9Ht2e6gEkK6JJW3DmN4UwgJQG06ts=
Content-Type: text/plain; charset="utf-8"
Content-ID: <746E16F5CB2A734589F23C524822AE2B@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d948b53-f113-4969-8f22-08d6c1f571ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2019 22:55:24.1234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3883
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gTW9uLCAyMDE5LTA0LTE1IGF0IDE3OjU5IC0wNDAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gT24gTW9uLCAxNSBBcHIgMjAxOSAxOTo0NzozOCArMDMwMA0KPiBTbGF2b21pciBLYXNsZXYg
PGthc2xldnNAdm13YXJlLmNvbT4gd3JvdGU6DQo+IA0KPiA+IEV4cHJlc3MgcGlkIGZpbHRlcnMg
YXMgYWxsb3dlZC9kaXNhbGxvd2VkIGZpbHRlciByYW5nZXMNCj4gPiANCj4gPiAgIChwaWQ+PTEw
MCYmcGlkPD0xMDMpICANCj4gPiANCj4gPiBpbnN0ZWFkIG9mIHNwZWNpZnlpbmcgdGhlbSBwZXIg
cGlkDQo+ID4gDQo+ID4gICAocGlkPT0xMDB8fHBpZD09MTAxfHxwaWQ9PTEwMnx8cGlkPT0xMDMp
DQo+ID4gDQo+ID4gVGhpcyBtYWtlcyB0aGUgc2l6ZSBvZiB0aGUgcmVzdWx0aW5nIGZpbHRlciBz
bWFsbGVyIChhbmQgZmFzdGVyKQ0KPiA+IGFuZCBhdm9pZHMNCj4gPiBvdmVyZmxvd2luZyB0aGUg
ZmlsdGVyIHNpemUgbGltaXQgb2Ygb25lIHBhZ2Ugd2hpY2ggd2UgY2FuIGhpdCBvbg0KPiA+IGJp
Z2dlcg0KPiA+IG1hY2hpbmVzIChzYXkgPjE2MCBDUFVzKS4NCj4gDQo+IEV4Y2VwdCBpdCBicmVh
a3MgaWYgd2UgaGF2ZSBhIHNwbGl0Lg0KPiANCj4gSSByYW4gdGhpczoNCj4gDQo+ICBoYWNrYmVu
Y2ggMTAgJg0KPiAgdHJhY2VjbWQvdHJhY2UtY21kIHJlY29yZCAtZSBzY2hlZF9zd2l0Y2ggY2F0
DQo+IC9zeXMva2VybmVsL2RlYnVnL3RyYWNpbmcvZXZlbnRzL3NjaGVkL3NjaGVkX3N3aXRjaC9m
aWx0ZXINCj4gDQo+IA0KPiBUaW1lOiAwLjA5Mw0KPiAoY29tbW9uX3BpZDw2OTU5fHxjb21tb25f
cGlkPjY5NjkpfHwoY29tbW9uX3BpZDw2OTQ1fHxjb21tb25fcGlkPjY5NTcNCj4gKXx8KG5leHRf
cGlkPDY5NTl8fG5leHRfcGlkPjY5NjkpfHwobmV4dF9waWQ8Njk0NXx8bmV4dF9waWQ+Njk1NykN
Cj4gDQo+IFRoaXMgd2FzIHRoZSBvdXRwdXQuIFNob3dpbmcgdGhhdCB3ZSBoYWQgY29tbW9uX3Bp
ZCBmcm9tIDY5NTkgLSA2OTY5DQo+IGFuZCA2OTQ1IC0gNjk1NyAoYSA2OTU4IHdhcyBtaXNzaW5n
KSwgYW5kIGJlY2F1c2Ugb2YgdGhpcywgd2Ugbm93DQo+IHRyYWNlDQo+IGFsbCBwcm9jZXNzZXMg
YmVjYXVzZSAoY29tbW9uX3BpZCA8IDY5NTkgfHwgY29tbW9uX3BpZCA+IDY5NTcpIGlzDQo+IGFs
d2F5cyB0cnVlLg0KPiANCj4gV2UgbmVlZCBhbiAiJiYiIHRoZXJlIHNvbWV3aGVyZS4gVGhhdCBz
aG91bGQgaGF2ZSBiZWVuOg0KPiANCj4gKChjb21tb25fcGlkPDY5NTl8fGNvbW1vbl9waWQ+Njk2
OSkmJihjb21tb25fcGlkPDY5NDV8fGNvbW1vbl9waWQ+Njk1DQo+IDcpKXx8KChuZXh0X3BpZDw2
OTU5fHxuZXh0X3BpZD42OTY5KSYmKG5leHRfcGlkPDY5NDV8fG5leHRfcGlkPjY5NTcpKQ0KDQpH
b29kIGNhdGNoLiBJJ3ZlIG1pc3JlYWQgaG93IHRoZSBvcmlnaW5hbCBjb2RlIHdvcmtlZC4gSXQg
YXBwZW5kcw0KZXhjbHVkZSBmaWx0ZXJzIHdpdGggJiYgYW5kIG5vbi1leGNsdWRlIHdpdGggfHwu
IEknbGwgc2VuZCBhIGZpeCBpbiB2My4NCg0KLS0gU2xhdmkNCg0K
