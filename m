Return-Path: <SRS0=+uc8=UK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D085C4321A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jun 2019 12:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D3C120896
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jun 2019 12:40:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="Lw0PUK4d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbfFKMko (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 Jun 2019 08:40:44 -0400
Received: from mail-eopbgr710085.outbound.protection.outlook.com ([40.107.71.85]:38935
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726713AbfFKMkn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Jun 2019 08:40:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6L8C5rx0rcaIYEodUYKROMrMkegY3zU6al2MAQOWoko=;
 b=Lw0PUK4dydkPHcBNJUki8DPV0NsIBwgTNq/x+62iDer6ZLSKCHJIkR3J1S7FafSqmIpQYyumJ1BNSEBZ6tMUlNdfAQWWvZnhpFs1oodjxF0TrlKTc87lgna4lIlIvefYlR4xKPmuTItv33irk2uzHgO6sCwsRO6eG8x6i8ibYbg=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3819.namprd05.prod.outlook.com (10.167.163.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Tue, 11 Jun 2019 12:40:38 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b122:e6f8:6c8e:6519]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b122:e6f8:6c8e:6519%5]) with mapi id 15.20.1987.004; Tue, 11 Jun 2019
 12:40:38 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Add trace-cmd report --version to extract
 version info
Thread-Topic: [PATCH] trace-cmd: Add trace-cmd report --version to extract
 version info
Thread-Index: AQHVH/TOO4zZb9wL8Eeu2K1GqANatKaWZdIA
Date:   Tue, 11 Jun 2019 12:40:38 +0000
Message-ID: <0fd41ca481c3154c915e70ded50592314ae86cbb.camel@vmware.com>
References: <20190604082440.724d7d95@oasis.local.home>
         <20190604124826.6716-1-kaslevs@vmware.com>
         <20190610212706.2505bffe@oasis.local.home>
In-Reply-To: <20190610212706.2505bffe@oasis.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a80ff73e-6f1f-4cf4-d701-08d6ee6a01aa
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR0501MB3819;
x-ms-traffictypediagnostic: MWHPR0501MB3819:
x-microsoft-antispam-prvs: <MWHPR0501MB381938ECED90B56394961C2DDAED0@MWHPR0501MB3819.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 006546F32A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(39860400002)(376002)(396003)(199004)(189003)(118296001)(81156014)(256004)(14454004)(2906002)(81166006)(8676002)(1730700003)(316002)(6512007)(6486002)(4744005)(8936002)(6116002)(86362001)(4326008)(6436002)(305945005)(3846002)(68736007)(71200400001)(7736002)(6246003)(478600001)(54906003)(5640700003)(5660300002)(2351001)(25786009)(486006)(36756003)(66066001)(446003)(229853002)(6506007)(26005)(71190400001)(66476007)(99286004)(53936002)(76116006)(64756008)(91956017)(66946007)(66556008)(2501003)(102836004)(66446008)(73956011)(6916009)(476003)(2616005)(186003)(11346002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3819;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t8LeOIBh8C5WjMVeyDGfRtevsm4ZLwLbqD8/pbOJsOgaKdiDXeU2MV9G9J0kzo9Vm5TV4oRBZm7yc4ZZ715bK3ll/7qNwra5+peIUWL+tX384hYKMroOotEnUzHtqFsV3a2KqO9QQDvlP2nMI3ngBdFmDstHzKb5tr7MgMoyP6wJ6Zv8biyHwTFAqR0hkQGpR1CL7+ygeel74bLsBgAqr8pSFyx/ynPCorWANQgVvs1b/lgIFDxF+ImxyKE9sI6LhB9dMdfe6iJ7yYwwPJMA+ny6+pCFDrLJ1lZX/PWPHSXGMNrLZ9zeRku+9V6Lg0vvC+c5W9x9GEk8+oCpzbYBP7PAL0wTFfuw52dlzEU/5j5ZelRiakGQB7Mf6pKbrg/3IZ9RqheQBPGbq74Vs4MkneTkyzHNmbQtDpV1QstJMdE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A28A0A7AC65A634C9143BAD2435C57FB@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a80ff73e-6f1f-4cf4-d701-08d6ee6a01aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2019 12:40:38.0981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kaslevs@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3819
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gTW9uLCAyMDE5LTA2LTEwIGF0IDIxOjI3IC0wNDAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gRnJvbTogIlN0ZXZlbiBSb3N0ZWR0IChWTXdhcmUpIiA8cm9zdGVkdEBnb29kbWlzLm9yZz4N
Cj4gDQo+IE5vdyB0aGF0IHRoZSB0cmFjZS5kYXQgZmlsZSBjYW4gc2F2ZSB0aGUgdmVyc2lvbiBv
ZiB0aGUgZXhlY3V0YWJsZQ0KPiB0aGF0IHdhcw0KPiB1c2VkIHRvIGNyZWF0ZSBpdCwgc2F2ZSB0
aGF0IGluZm9ybWF0aW9uLiBUaGlzIHdpbGwgYmUgdXNlZnVsIGlmIGENCj4gdXNlciBoYXMNCj4g
YSBwcm9ibGVtIHdpdGggYSB0cmFjZS5kYXQgZmlsZS4gSXQgY2FuIGxldCB0aGUgZGV2ZWxvcGVy
cyBrbm93IHdoYXQNCj4gdmVyc2lvbg0KPiB3YXMgdXNlZCB0byBjcmVhdGUgaXQuIFdlIG5lZWQg
YSB3YXkgdG8gZXh0cmFjdCB0aGlzIGluZm9ybWF0aW9uLg0KPiBBZGRpbmcgYQ0KPiBuZXcgIi0t
dmVyc2lvbiIgdG8gdHJhY2UtY21kIHJlcG9ydCB3aWxsIGRpc3BsYXkgdGhlIHNhdmVkIHZlcnNp
b24gaW4NCj4gdGhlDQo+IHRyYWNlLmRhdCBmaWxlIGlmIGl0IGV4aXN0cy4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IFN0ZXZlbiBSb3N0ZWR0IChWTXdhcmUpIDxyb3N0ZWR0QGdvb2RtaXMub3JnPg0K
PiAtLS0NCg0KTG9va3MgZ3JlYXQuDQoNClJldmlld2VkLWJ5OiBTbGF2b21pciBLYXNsZXYgPGth
c2xldnNAdm13YXJlLmNvbT4NCg0KQ2hlZXJzIQ0KDQotLSBTbGF2aQ0K
