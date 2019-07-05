Return-Path: <SRS0=byw1=VC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4BEC5B57D
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 09:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA9042147A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 09:13:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="Yy8cW60/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfGEJNy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 05:13:54 -0400
Received: from mail-eopbgr700072.outbound.protection.outlook.com ([40.107.70.72]:34560
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbfGEJNy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 05:13:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etpIseYaoohdxsedwNyTNYjeNJoA3tqg5wC9QSpeM52bTP6minv4I1u4Y+ntIx3S0hOLIqUBAXz4pfeZ9XDmVPuwTbH1h+G6lOBtBnK0idtRlYDeqbjUFrJ8o3K6gmXOIafQGYC5MZ3SC9JKluusr85U8YpqwApCNS422wJs3yoHOxnaqQfYJ096jw9B5UgfQIC8SSgZCDYwq32G6QX1yjNxHg2C1qK7WPjiIcTG7aFA3ydvYgDC0hg5duq58y7yCWw5UfIGuYiDbZi7ig/N0T8jRp1t8FJboSUvCZG1GsksCynwXGnQY878DzcNbyJzFohGXRNtO6OOv66sHnUvBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6h7F9OaWsQfLNyyqjypq3RpEPfitmOwcVT1kihMqC18=;
 b=bhhVikAetWIdsNNH9q6jp05UNkyZmrPVWuwysWHFkYu+zlLK8EXxUfwdDC0C9w35A+CD3FFqN+YKdzOx6QAGJ2R8UEqoSGCSlGp6uLjMww5MYBeTlYyyfsNYlDN0CqIOvKzeHH5EZEys54I37JtnR2ft5MQMpMgLXsLkcdEf+SJzGBaHSMA0qGghf4tGc+G1JBQzpLKyMXZ5l1UtstjT6ariHl543sgLgkY8xkt0oXe9Td8LGcsbHNjY9Drsi4gG/NOxTn1EeuOJeS6F66P3EuRHDRKfiHB7+BBbmoG3k6ArltX5zxBDoj9iGeJUlpavXJR59IeewLwJIN3hkjEdhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=vmware.com;dmarc=pass action=none
 header.from=vmware.com;dkim=pass header.d=vmware.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6h7F9OaWsQfLNyyqjypq3RpEPfitmOwcVT1kihMqC18=;
 b=Yy8cW60/03c//TaKcOLzJuSZRJ2SD3wC1oO5wzMX1QyjZMdKSWON1tLtRoB8RZva7Z3RhRcAPZJFp6Cx7iZbw3/hAc9eghvIV+W9kU8Vj0l1oL1d2LaUya+KvCQ88LyOWIXH7RSBKdXZIEAuse6x7RHn8NHr4Rae1ArDbsRYBs4=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3804.namprd05.prod.outlook.com (10.167.163.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.6; Fri, 5 Jul 2019 09:13:49 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::4b8:7531:ae2c:4293]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::4b8:7531:ae2c:4293%3]) with mapi id 15.20.2052.010; Fri, 5 Jul 2019
 09:13:49 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 5/5] kernel-shark: Drop Freeglut as a compulsory
 dependency
Thread-Topic: [RFC PATCH v2 5/5] kernel-shark: Drop Freeglut as a compulsory
 dependency
Thread-Index: AQHVMZhf6GQW3kytb0irBbJfk747kaa7wKQA
Date:   Fri, 5 Jul 2019 09:13:48 +0000
Message-ID: <CAE0o1NvHQ5xOoR0vCqea4dDHhvNJx4G2C=7UuFDR0cQXDCi9cg@mail.gmail.com>
References: <20190703121023.16655-1-y.karadz@gmail.com>
 <20190703121023.16655-6-y.karadz@gmail.com>
In-Reply-To: <20190703121023.16655-6-y.karadz@gmail.com>
Reply-To: "slavomir.kaslev@gmail.com" <slavomir.kaslev@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CH2PR12CA0030.namprd12.prod.outlook.com
 (2603:10b6:610:57::40) To MWHPR0501MB3772.namprd05.prod.outlook.com
 (2603:10b6:301:7a::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAVI7q4vdtK5EF9sUNvTEW1saNKa5f5QkCmK0m0p+Bpgdus91Aq/
        pOBmaZji0fNd1FvHrVK7aizeq8mJZcKMAFPnhA==
x-google-smtp-source: APXvYqzCPCqVqCRt6ThnoFwldRchDOL2oyELH8JfAJLXjl6vx1n/cNF0sCZ4PUy2Ei5NFzTik246ZvzzHSh7lR2JmJI=
x-received: by 2002:a05:6638:29a:: with SMTP id
 c26mr3136838jaq.98.1562318024214; Fri, 05 Jul 2019 02:13:44 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1NvHQ5xOoR0vCqea4dDHhvNJx4G2C=7UuFDR0cQXDCi9cg@mail.gmail.com>
x-originating-ip: [209.85.166.49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 422b4fd8-4487-404d-de9f-08d7012916b6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR0501MB3804;
x-ms-traffictypediagnostic: MWHPR0501MB3804:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR0501MB3804D8351476BCC834920E61DAF50@MWHPR0501MB3804.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 008960E8EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(396003)(346002)(39860400002)(189003)(199004)(53546011)(386003)(6116002)(3846002)(61726006)(81156014)(86362001)(8676002)(6506007)(9686003)(43066004)(498394004)(99286004)(6436002)(11346002)(6306002)(6512007)(5660300002)(446003)(81166006)(53936002)(14454004)(102836004)(6246003)(66806009)(966005)(68736007)(76176011)(486006)(71200400001)(71190400001)(61266001)(6486002)(66066001)(229853002)(55446002)(25786009)(8936002)(476003)(52116002)(8796002)(6862004)(4326008)(2906002)(2860700004)(256004)(66476007)(316002)(95326003)(22416003)(54906003)(478600001)(64756008)(7736002)(305945005)(186003)(66556008)(73956011)(66946007)(26005)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3804;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VS54JF+5AZwNUwOOX0XGN6DFWa3ZD//L4aFKhhqd97NGMFn+KtoJdwEQccYHUYvUWR2Lu/jXETyqFXoUXRCZwBbYG7RBbGp6FGqChasDZaU4k04RDORvXHdsGqsvwCNiexMNS57vEY03tZsqG9qWw4rZShbWcU1NLoeDoKg1Ct6dzFC9JwynbcYYx5o/urReDnL7W0To+iIk1Sm0ldSty90zwv+JpyJ4BXsrwHx50IV6MLAK88dPw8mqRXW811mAI8GvzeY2hUDO1nN7LuadP9Q2i4Nsm+UxibtZsxorFv4FViRk4BH3RYvwD3XjyZC3G+4TyZbGFLjgDqvS5pb+XfmkmConglWNfgC7JNDk5fJJhVeSU/+IoDYhdQOyi7ybQB4HQG9BOmCoW6mg6MNO0KXtWYCDRW9ktCCquBaPlOU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE70AF2FB244C84481D54A79B7C1810B@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 422b4fd8-4487-404d-de9f-08d7012916b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2019 09:13:48.3754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kaslevs@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3804
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCBKdWwgMywgMjAxOSBhdCAzOjExIFBNIFlvcmRhbiBLYXJhZHpob3YgKFZNd2FyZSkN
Cjx5LmthcmFkekBnbWFpbC5jb20+IHdyb3RlOg0KPg0KPiBGcmVlZ2x1dCBpcyBub3QgYSBuZWNl
c3NhcnkgZGVwZW5kZW5jeSBmb3IgcHJvZ3JhbXMgbGlrZSB0aGUNCj4gS2VybmVsU2hhcmsgR1VJ
IHRoYXQgYXJlIHVzaW5nIFF0IGZvciB3aW5kb3cgYW5kIE9wZW5HTCBjb250ZXh0DQo+IG1hbmFn
ZW1lbnQuIEN1cnJlbnRseSBpdCBpcyBiZWVuIHVzZWQgb25seSBieSB0aGUgZGF0YSBwbG90dGlu
Zw0KPiBleGFtcGxlIChkYXRhcGxvdC5jcHApLg0KPg0KPiBTdWdnZXN0ZWQtYnk6IFNsYXZvbWly
IEthc2xldiA8a2FzbGV2c0B2bXdhcmUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBZb3JkYW4gS2Fy
YWR6aG92IChWTXdhcmUpIDx5LmthcmFkekBnbWFpbC5jb20+DQo+IC0tLQ0KPiAga2VybmVsLXNo
YXJrL2J1aWxkL2RlZmYuaC5jbWFrZSAgICAgIHwgIDMgKysrDQo+ICBrZXJuZWwtc2hhcmsvZXhh
bXBsZXMvQ01ha2VMaXN0cy50eHQgfCAxMCArKysrKysrLS0tDQo+ICBrZXJuZWwtc2hhcmsvc3Jj
L0NNYWtlTGlzdHMudHh0ICAgICAgfCAgNCArKy0tDQo+ICBrZXJuZWwtc2hhcmsvc3JjL0tzR0xX
aWRnZXQuY3BwICAgICAgfCAgNCAtLS0tDQo+ICBrZXJuZWwtc2hhcmsvc3JjL0tzUGxvdFRvb2xz
LmNwcCAgICAgfCAgNCAtLS0tDQo+ICBrZXJuZWwtc2hhcmsvc3JjL2xpYmtzaGFyay1wbG90LmMg
ICAgfCAxNyArKysrKysrKy0tLS0tLS0tLQ0KPiAga2VybmVsLXNoYXJrL3NyYy9saWJrc2hhcmst
cGxvdC5oICAgIHwgIDIgKy0NCj4gIDcgZmlsZXMgY2hhbmdlZCwgMjEgaW5zZXJ0aW9ucygrKSwg
MjMgZGVsZXRpb25zKC0pDQo+DQpbLi4uXQ0KPiBkaWZmIC0tZ2l0IGEva2VybmVsLXNoYXJrL3Ny
Yy9saWJrc2hhcmstcGxvdC5jIGIva2VybmVsLXNoYXJrL3NyYy9saWJrc2hhcmstcGxvdC5jDQo+
IGluZGV4IDE5ODI0OTQuLjMyZTJhZTkgMTAwNjQ0DQo+IC0tLSBhL2tlcm5lbC1zaGFyay9zcmMv
bGlia3NoYXJrLXBsb3QuYw0KPiArKysgYi9rZXJuZWwtc2hhcmsvc3JjL2xpYmtzaGFyay1wbG90
LmMNCj4gQEAgLTE5LDYgKzE5LDcgQEANCj4NCj4gIC8vIEtlcm5lbFNoYXJrDQo+ICAjaW5jbHVk
ZSAibGlia3NoYXJrLXBsb3QuaCINCj4gKyNpbmNsdWRlICJLc0NtYWtlRGVmLmhwcCINCj4NCj4g
IC8qDQo+ICAgKiBTVEIgVHJ1ZVR5cGUgKHNpbmdsZS1maWxlIHB1YmxpYyBkb21haW4gbGlicmFy
eSkNCj4gQEAgLTMxLDYgKzMyLDEwIEBADQo+ICAjZGVmaW5lIFNUQlRUX1NUQVRJQw0KPiAgI2lu
Y2x1ZGUgInN0Yl90cnVldHlwZS5oIg0KPg0KPiArI2lmZGVmIEdMVVRfRk9VTkQNCj4gKw0KPiAr
I2luY2x1ZGUgPEdML2ZyZWVnbHV0Lmg+DQo+ICsNCj4gIC8qKg0KPiAgICogQGJyaWVmIENyZWF0
ZSBhbiBlbXB0eSBzY2VuZSBmb3IgZHJhd2luZy4NCj4gICAqDQo+IEBAIC01NSwxNyArNjAsMTEg
QEAgdm9pZCBrc3Bsb3RfbWFrZV9zY2VuZShpbnQgd2lkdGgsIGludCBoZWlnaHQpDQo+ICAgICAg
ICAgLyogT3BlbiB0aGUgc2NyZWVuIHdpbmRvdy4gKi8NCj4gICAgICAgICBnbHV0Q3JlYXRlV2lu
ZG93KCJLZXJuZWxTaGFyayBQbG90Iik7DQo+DQo+IC0gICAgICAgLyoNCj4gLSAgICAgICAgKiBT
ZXQgdGhlIG9yaWdpbiBvZiB0aGUgY29vcmRpbmF0ZSBzeXN0ZW0gdG8gYmUgdGhlIHRvcCBsZWZ0
IGNvcm5lci4NCj4gLSAgICAgICAgKiBUaGUgIlkiIGNvb3JkaW5hdGUgaXMgaW52ZXJ0ZWQuDQo+
IC0gICAgICAgICovDQo+IC0gICAgICAgZ2x1T3J0aG8yRCgwLCB3aWR0aCwgaGVpZ2h0LCAwKTsN
Cj4gLSAgICAgICBnbFZpZXdwb3J0KDAsIDAsIHdpZHRoLCBoZWlnaHQpOw0KPiAtDQo+IC0gICAg
ICAgZ2xNYXRyaXhNb2RlKEdMX1BST0pFQ1RJT04pOw0KPiAtICAgICAgIGdsTG9hZElkZW50aXR5
KCk7DQo+ICsgICAgICAga3NwbG90X3Jlc2l6ZV9vcGVuZ2wod2lkdGgsIGhlaWdodCk7DQo+ICB9
DQo+DQo+ICsjZW5kaWYgLy8gR0xVVF9GT1VORA0KDQpJIHRoaW5rIHdlIHNob3VsZG4ndCBsaW5r
IGxpYmtzaGFyay1wbG90IHdpdGggR0xVVCBldmVuIGlmIGl0J3MNCmF2YWlsYWJsZSBvbiB0aGUg
c3lzdGVtIGFuZCBsZXQgdXNlcnMgb2YgdGhlIGxpYnJhcnkgZGVjaWRlIHdoZXRoZXINCnRoZXkg
bmVlZCBpdC4gVGhlIGdsdXQgY29kZSBpbiB0aGlzIGZ1bmN0aW9uIGlzIHByZXR0eSBzdGFuZGFy
ZCBHTFVUDQppbml0aWFsaXphdGlvbiB3aGljaCB1c2VycyB3b3VsZCB3YW50IHRvIGNvbnRyb2wg
YW55d2F5IGFuZCB0aGVyZSdzIG5vDQpwb2ludCBpbiBwcm92aWRpbmcgaXQgaGVyZS4NCg0KRHJv
cHBpbmcgR0xVVCBhcyBsaWJrc2hhcmstcGxvdCBkZXBlbmRlbmN5IHdvdWxkIGltcGx5IEdMVSBu
ZWVkcyB0byBiZQ0KYWRkZWQgYXMgZGVwZW5kZW5jeSBmb3IgdGhlIGdsdU9ydGhvMkQoKSBmdW5j
dGlvbiAoR0xVVCBkZXBlbmRzIG9uIEdMVQ0Kc28gdGhhdCdzIGhvdyB3ZSd2ZSBiZWVuIHBpY2tp
bmcgdXAgR0xVIHRpbGwgbm93KS4gQWx0ZXJuYXRpdmVseSwgd2UNCmNhbiBkcm9wIEdMVSBhbHRv
Z2V0aGVyIGFzIGRlcGVuZGVuY3kgYnkgaW1wbGVtZW50aW5nIGdsdU9ydGhvMkQoKQ0Kb3Vyc2Vs
dmVzIChieSB1c2luZyBzb21ldGhpbmcgbGlrZSB0aGlzWzFdIGFuZCBnbExvYWRNYXRyaXgoKSBp
dCkuDQoNClsxXSBodHRwczovL2dpdGh1Yi5jb20vc2thc2xldi9jYXRtdWxsLWNsYXJrL2Jsb2Iv
ZTcxNDJkZDI3MDE3NmEzOGMxODBmZDc0YjY3ZGE3NDBlYTY4OTkxYy9tYXRoeC5jI0wxNjkNCg0K
Q2hlZXJzLA0KDQotLSBTbGF2aQ0K
