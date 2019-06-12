Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A27C31E46
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 08:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92E3D2080A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 08:17:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="GVqGSwJY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfFLIRm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 04:17:42 -0400
Received: from mail-eopbgr750070.outbound.protection.outlook.com ([40.107.75.70]:22152
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726586AbfFLIRm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 04:17:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2a9t0HT49jrpgLvU6QUq8I1wWLfgapFythPb2GLmbo=;
 b=GVqGSwJYEO5l7QLPZgSYVaEAiiFxVoH+MHIo8qMTL3FyRIPUGhEFUGfz8SCewmxzHXK2v7hC1OELreeQqCleDsQvjSj2Z4VL0t2OkmqOXsTkU6pp7gb1LFVIT5bKbtZm2PRr5FYJPEnBVahZPiKSpGf/x3ecfFi1bswgJ2oCF0c=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3789.namprd05.prod.outlook.com (10.167.141.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Wed, 12 Jun 2019 08:17:38 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c%5]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 08:17:38 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     Alan Mikhak <alanmikhak@gmail.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     Alan Mikhak <amikhak@wirelessfabric.com>
Subject: Re: [PATCH] Fix compiler error in KsSession.cpp on Raspberry Pi 3
Thread-Topic: [PATCH] Fix compiler error in KsSession.cpp on Raspberry Pi 3
Thread-Index: AQHVINMxkbg6AOObv0iYg+xa645zVqaXrOaA
Date:   Wed, 12 Jun 2019 08:17:38 +0000
Message-ID: <876ffbbd-1574-3b06-c856-8b1930013bde@vmware.com>
References: <20190612035902.16366-1-amikhak@wirelessfabric.com>
In-Reply-To: <20190612035902.16366-1-amikhak@wirelessfabric.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR08CA0151.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::29) To SN4PR0501MB3903.namprd05.prod.outlook.com
 (2603:10b6:803:4d::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91a5b61e-256d-4db8-e986-08d6ef0e6e77
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN4PR0501MB3789;
x-ms-traffictypediagnostic: SN4PR0501MB3789:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <SN4PR0501MB37896AB545A277BBC8B365EAA0EC0@SN4PR0501MB3789.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(6029001)(136003)(366004)(346002)(376002)(39860400002)(396003)(189003)(199004)(51444003)(3846002)(8936002)(66446008)(446003)(4744005)(2906002)(2501003)(4326008)(6116002)(229853002)(36756003)(53936002)(2616005)(476003)(6512007)(6306002)(11346002)(25786009)(6486002)(102836004)(486006)(478600001)(86362001)(68736007)(7736002)(6436002)(256004)(31696002)(2201001)(14454004)(6246003)(305945005)(31686004)(966005)(66556008)(386003)(6506007)(8676002)(26005)(71190400001)(316002)(71200400001)(81156014)(76176011)(81166006)(5660300002)(64756008)(110136005)(52116002)(66066001)(66476007)(66946007)(99286004)(186003)(73956011);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3789;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FZYgwkzcbDy/ReFw6uhdz1LvS5NaF9qg/e1lOXbIV0J4kIuqQgchw41wzevm9KU2qI3d9XWUltPOpM9qPWkDAIInDbLMFzBrmj3Bphsxr5puhWVQF+DvzmiwveAvIyILfuXKD4AO8bzQf4IXl2r9P26uwVQ/9SkAhMfrdsIYMkgkptRMk24rZYb28J/3LtAuCessX/HmHeH5OmZ9u2RmLRHm2UfBa3i81UWHCz86LOLl2viKq4pMr+r7Yuoz4xeHEy1aDM9wqQWSi62Aj4WhmWr6tacoUjmqpSw2lAY2rPS79WEgdcXRrugIdPI9fJEEnNHPNgXAHYlwlEs30+RoaC7lI8bHCMY1ROtyS9nSvNZ8FZGhaXGmBOxLTGzivcZVjhM17Ex84XUPVG0mbZQehMhaobg1FKmr07el+UerUVk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <98BD061B36365F4181E7A9B50F2F977A@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91a5b61e-256d-4db8-e986-08d6ef0e6e77
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 08:17:38.3875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ykaradzhov@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3789
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

SGkgQWxhbiwNCg0KSSBqdXN0IG5vdGljZWQgdGhhdCB5b3UgY3JlYXRlZCBjb3VwbGUgb2YgaXNz
dWVzIGluIHRoZSBpc3N1ZSB0cmFja2VyIG9mIA0KdGhlIFN0ZXZlbidzIG1pcnJvciByZXBvIG9u
IEdpdEh1Yi4gUGxlYXNlIG5vdGUgdGhhdCB0aGUgb2ZmaWNpYWwgDQpyZXBvc2l0b3J5IG9mIHRo
ZSBwcm9qZWN0IGlzIGhlcmUNCiAgaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL3V0aWxz
L3RyYWNlLWNtZC90cmFjZS1jbWQuZ2l0Lw0KDQphbmQgdGhhdCB0aGUgaXNzdWUgdHJhY2tlciB0
aGF0IHdlIHVzZSBpcyBoZXJlDQogDQpodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvYnVnbGlz
dC5jZ2k/Y29tcG9uZW50PVRyYWNlLWNtZCUyRktlcm5lbHNoYXJrJnByb2R1Y3Q9VG9vbHMmcmVz
b2x1dGlvbj0tLS0NCg0KQWxzbyBJIHdvdWxkIGxpa2UgdG8gYXNrIHlvdSB0byBjb3B5IHRoZSBj
b250ZW50IG9mIHRoZSB0cmFjZSBkYXRhIA0KdmlzdWFsaXphdGlvbiBpc3N1ZSBpbiB0aGUgb2Zm
aWNpYWwgaXNzdWUgdHJhY2tlciwgYmVjYXVzZSBJIGZpbmQgeW91ciANCmludmVzdGlnYXRpb25z
IGludGVyZXN0aW5nLCBhbmQgSSB0aGluayB0aGF0IHRoaXMgaW5mb3JtYXRpb24gY2FuIGJlIA0K
dXNlZnVsIGZvciBzb21lb25lIGVsc2UgaGF2aW5nIHRoZSBzYW1lIHByb2JsZW0uDQoNClRoYW5r
cyENCllvcmRhbg0KDQo=
