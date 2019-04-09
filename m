Return-Path: <SRS0=eAkL=SL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80730C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 14:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4218F20833
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 14:59:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="StOE2XWR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfDIO76 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 10:59:58 -0400
Received: from mail-eopbgr780083.outbound.protection.outlook.com ([40.107.78.83]:30544
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726396AbfDIO75 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 10:59:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ay8ITgUAFhdHMmOkBmu7d6UNdjo7zc1ShUac4cqxh7M=;
 b=StOE2XWRvnf+yGkivtP3jAumVOBDpAEnyrWmY0TjOsD5m4KVHPpt1IBcHYhV8flCtpexq1UHGDjZVqchaQAUutv9a8P1yzsowgpj3ggJF18CCBID1mTAickNWLyuiFdbU9BVwK08QaVSubtKg+yqGDkUSLkdpFeME01It1HoFsY=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3820.namprd05.prod.outlook.com (10.167.173.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.9; Tue, 9 Apr 2019 14:59:54 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41%5]) with mapi id 15.20.1792.007; Tue, 9 Apr 2019
 14:59:54 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Thread-Topic: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Thread-Index: AQHU7h2WcCXQDyjBs0OQUMjYOKqD5aYzwfgAgAAQu4CAABrHgA==
Date:   Tue, 9 Apr 2019 14:59:54 +0000
Message-ID: <CAE0o1NtOBbVGjHfYyqOhrCrmywSNjYWOprDU66uMTPx4hX4UGA@mail.gmail.com>
References: <20190404145603.13592-1-ykaradzhov@vmware.com>
 <20190404145603.13592-2-ykaradzhov@vmware.com> <20190408150102.GA6430@box>
 <20190408111308.301f30c1@gandalf.local.home>
 <0808d774-880a-f232-dda3-cd897120d86d@gmail.com>
 <20190409092349.3e7cb6e3@gandalf.local.home>
In-Reply-To: <20190409092349.3e7cb6e3@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR20CA0018.namprd20.prod.outlook.com
 (2603:10b6:3:93::28) To MWHPR0501MB3772.namprd05.prod.outlook.com
 (2603:10b6:301:7a::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAUxmO3tPA4X+7BdUawJQzTvd+iFwrkLtIt9T34ww1YwAAK0r4ht
        1R3RYPM/D9cmJSfQAmzc80AQlTXYFFJ+6CExYw==
x-google-smtp-source: APXvYqx0hEv5IAyIiXKxwD9dLvJVAyn255RrOJyyoP9ziE8rzXeghgsfddoegJXxNz9u8di5E43q+n4UvdaGERiYLmY=
x-received: by 2002:a24:d11:: with SMTP id 17mr25199459itx.30.1554821991327;
 Tue, 09 Apr 2019 07:59:51 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1NtOBbVGjHfYyqOhrCrmywSNjYWOprDU66uMTPx4hX4UGA@mail.gmail.com>
x-originating-ip: [209.85.166.176]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6ed8da5-6d7b-4470-d7bb-08d6bcfc0606
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0501MB3820;
x-ms-traffictypediagnostic: MWHPR0501MB3820:
x-microsoft-antispam-prvs: <MWHPR0501MB3820786E5FBB1DC81D5B770FDA2D0@MWHPR0501MB3820.namprd05.prod.outlook.com>
x-forefront-prvs: 000227DA0C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(39860400002)(366004)(396003)(346002)(51444003)(199004)(189003)(14454004)(478600001)(4326008)(97736004)(106356001)(66066001)(6246003)(105586002)(53936002)(54206008)(305945005)(6862004)(8936002)(6116002)(61266001)(86362001)(7736002)(6512007)(81156014)(81166006)(498394004)(9686003)(8676002)(2906002)(4744005)(3846002)(11346002)(71200400001)(446003)(5660300002)(26005)(186003)(61726006)(386003)(6506007)(6486002)(229853002)(71190400001)(476003)(76176011)(68736007)(93886005)(102836004)(55446002)(25786009)(54906003)(316002)(256004)(95326003)(99286004)(52116002)(486006)(53546011)(6436002)(228453006);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3820;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TH0MsjgYXkssq/N5jJN0GTEUwAnBiUqiCO+lmkTe4dmBoTnkwrpzI0FXsMgXvpqGxXsmFHK9v89eAYAaGmO4EhmKgKo8TeOhnUZ7K4D1YqzzUX+FaocQrM7W9PiugY9AXeOjH4dWol5wF9DawCyvudRhDmca4lxSjay6QdgoYf4J7itzcSU6rq69/7zThxPFncUyLECXIq4fC76NufnHMbQf6C382jQETDuLseCLdbeC2CphrskxIlN8uP9OIHTsxXIkwPk4YwUh+ZyoEcTcVtpDJQC7scNuv9krfSTzpWIJ2ageiKelKp2QPPzBi68cARrmZiahaLi7aqObE1lTONRyPmAzEwK7540SXlWiaH0xSxg52yuuD6BI4Xb9I2bCPuMY9udRaivalIUo+6bir8K0Sb1/KI69PC9HQ4WAu4Y=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFF4D558ABB50140AF5A74F1BA4E6DB8@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6ed8da5-6d7b-4470-d7bb-08d6bcfc0606
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2019 14:59:54.1588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3820
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCBBcHIgOSwgMjAxOSBhdCA0OjI0IFBNIFN0ZXZlbiBSb3N0ZWR0IDxyb3N0ZWR0QGdv
b2RtaXMub3JnPiB3cm90ZToNCj4NCj4gT24gVHVlLCA5IEFwciAyMDE5IDE1OjIzOjU2ICswMzAw
DQo+ICJZb3JkYW4gS2FyYWR6aG92IChWTXdhcmUpIiA8eS5rYXJhZHpAZ21haWwuY29tPiB3cm90
ZToNCj4NCj4gPiBJIGNhbiBtYWtlIHRoZSBHVUkgdG8gY2hlY2sgaWYgX0tTX0NBQ0hFX0RJUiBp
cyBkZWZpbmVkIGFuZCBpZiBpdHMgdmFsdWUNCj4gPiAocGF0aCkgYmVsb25ncyB0byB0aGUgdXNl
ciB3aG8gcnVucyB0aGUgR1VJLiBJZiB0aGlzIGlzIG5vdCB0aGUgY2FzZSwNCj4gPiBUaGUgR1VJ
IHdpbGwgdXNlIHRoZSBkZWZhdWx0IGxvY2F0aW9uICh+L2NhY2hlL2tlcm5lbHNoYXJrKS4NCj4N
Cj4gQ2FuJ3Qgd2UganVzdCBtYWtlIGl0IHNvIHRoYXQgaXQgYWx3YXlzIGRvZXMgdGhpcyBwYXRo
Pw0KDQpEcm9wcGluZyBLU19DQUNIRV9ESVIgYXMgYnVpbGQgdGltZSBjb25zdGFudCBpbiBDTWFr
ZSBzb3VuZHMgZ3JlYXQuIEkNCnRoaW5rIHRoYXQgaGF2aW5nIGFuIGVudmlyb25tZW50IHZhcmlh
YmxlIG92ZXJyaWRlIGZvciBpdCBpcyBzdGlsbA0KdXNlZnVsLg0KDQpXZSBhbHNvIGhhdmUgdGhl
IHNhbWUgcHJvYmxlbSB3aXRoIEtTX0RJUiBhbmQgVFJBQ0VDTURfQklOX0RJUiB0aG91Z2guDQpU
aGV5IGJvdGggcG9pbnQgaW5zaWRlIHRoZSB0cmFjZS1jbWQgc291cmNlIGRpcmVjdG9yeSBmb3Ig
dGhlIHVzZXIgd2hvDQpidWlsdCBrZXJuZWxzaGFyayBhdG0uDQoNCkNoZWVycywNCg0KLS0gU2xh
dmkNCg==
