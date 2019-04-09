Return-Path: <SRS0=eAkL=SL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F08C8C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 13:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0D21205ED
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 13:33:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="Tl5O9ErE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfDINdj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 09:33:39 -0400
Received: from mail-eopbgr780058.outbound.protection.outlook.com ([40.107.78.58]:55232
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbfDINdj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 09:33:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QmOzXET8nbjB6W6/gxC+M2GcxcgjzHJcPmV64592qZc=;
 b=Tl5O9ErEyGQC2pWiK5RBJLJPDrzkMzrKlsUTTdfPDnc9LSe0eFJTT/LW7fFISWqLQ+fWV88DU+Y7WrIVoFEHHZlKu8Rp4LaSyGP8UdS2t4odHUj7K/KxfAsttU3otFvr4l35XQ+QJGbGz39XMeoVY4RJpyUDIrMcKhIxvgDYeCQ=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3725.namprd05.prod.outlook.com (10.167.150.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.11; Tue, 9 Apr 2019 13:33:33 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::9863:fa92:a642:b111]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::9863:fa92:a642:b111%2]) with mapi id 15.20.1792.009; Tue, 9 Apr 2019
 13:33:33 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
CC:     Slavomir Kaslev <kaslevs@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Thread-Topic: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Thread-Index: AQHU7hvpxSwj+3SMbEW799lauKWXPKYyXu0AgAFjDgCAABC8gIAAAq8A
Date:   Tue, 9 Apr 2019 13:33:33 +0000
Message-ID: <e025cbfd-5d82-34c8-9c3c-47172ee24a22@vmware.com>
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
x-clientproxiedby: VI1PR06CA0164.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::21) To SN4PR0501MB3903.namprd05.prod.outlook.com
 (2603:10b6:803:4d::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 341df30b-7aca-4315-cab8-08d6bceff611
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:SN4PR0501MB3725;
x-ms-traffictypediagnostic: SN4PR0501MB3725:
x-microsoft-antispam-prvs: <SN4PR0501MB3725798F189C59403557BCF4A02D0@SN4PR0501MB3725.namprd05.prod.outlook.com>
x-forefront-prvs: 000227DA0C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(396003)(346002)(366004)(136003)(189003)(199004)(11346002)(54906003)(6436002)(6486002)(256004)(478600001)(14454004)(71190400001)(71200400001)(4744005)(99286004)(93886005)(316002)(476003)(106356001)(486006)(105586002)(2616005)(31686004)(86362001)(68736007)(229853002)(25786009)(110136005)(31696002)(5660300002)(446003)(97736004)(76176011)(6246003)(4326008)(386003)(26005)(186003)(66066001)(6512007)(53936002)(6506007)(52116002)(305945005)(102836004)(7736002)(81156014)(81166006)(3846002)(8676002)(8936002)(2906002)(6116002)(36756003)(228453006);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3725;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0doyb9Fw5HXkUp4bn1hWSAcyJY/astv9/QJhB2hDpz0eF59u0s963SOvhPWQ80dm9QhsjCveKJxV9otuI0hrkefbi0PZ9CIDs4+i97AAsIPFprOw1oyZRIwbbSb0Y99lk988lyfOxGpFk/5s4z+lD3k3kx1nHE1oZwbC2zzoGV+VrMBeWYrqjwOhpfHrsuZB+j00cECjbgiAyToVYeeX//n52/1UIc/DIyKvNTwC49UtIGZiILxkdrXJt2uu78YdK3Vgc6WUYR2FtikKWIFUP21lh5JnpSSkeh8ohNKHpULilzfIW7zpa4ppIipvXJUSyjX5HvCV9OIENvaKimRCqQVLk4QfxfbV8I2z+k4T7dUNusloi7HdSrf8AG68VKvMj/Aq/X5afcFtBpVCGwtSy3eB2atCeRa3ldcMoDTyow4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <64AE83CEEDCA6046BFD77ADB8262767B@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 341df30b-7aca-4315-cab8-08d6bceff611
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2019 13:33:33.5373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3725
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQoNCk9uIDkuMDQuMTkg0LMuIDE2OjIzINGHLiwgU3RldmVuIFJvc3RlZHQgd3JvdGU6DQo+IE9u
IFR1ZSwgOSBBcHIgMjAxOSAxNToyMzo1NiArMDMwMA0KPiAiWW9yZGFuIEthcmFkemhvdiAoVk13
YXJlKSIgPHkua2FyYWR6QGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPj4gSSBjYW4gbWFrZSB0aGUg
R1VJIHRvIGNoZWNrIGlmIF9LU19DQUNIRV9ESVIgaXMgZGVmaW5lZCBhbmQgaWYgaXRzIHZhbHVl
DQo+PiAocGF0aCkgYmVsb25ncyB0byB0aGUgdXNlciB3aG8gcnVucyB0aGUgR1VJLiBJZiB0aGlz
IGlzIG5vdCB0aGUgY2FzZSwNCj4+IFRoZSBHVUkgd2lsbCB1c2UgdGhlIGRlZmF1bHQgbG9jYXRp
b24gKH4vY2FjaGUva2VybmVsc2hhcmspLg0KPiANCj4gQ2FuJ3Qgd2UganVzdCBtYWtlIGl0IHNv
IHRoYXQgaXQgYWx3YXlzIGRvZXMgdGhpcyBwYXRoPw0KDQpUaGlzIHdpbGwgYmUgYSBncmVhdCBz
aW1wbGlmaWNhdGlvbiA6LSkNClllcywgd2UgY2FuLg0KDQpUaGFua3MhDQpZb3JkYW4NCg0KDQo+
IA0KPiAtLSBTdGV2ZQ0KPiANCg==
