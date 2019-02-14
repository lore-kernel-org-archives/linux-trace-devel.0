Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1820BC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 16:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D09FA21928
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 16:51:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="rYKj7QZz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393851AbfBNQvT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 11:51:19 -0500
Received: from mail-eopbgr700061.outbound.protection.outlook.com ([40.107.70.61]:65494
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731118AbfBNQvT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 11:51:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMVdQAKYJbaCE+kY3Lg00EQ5BnkxE6dLwHlZiJ7Id64=;
 b=rYKj7QZzcNOCJih4sxP6jPpfJ2b1KHy93Q5AQwPqBdaACINO6A1VtDDy5hArMpMlyKiSTkweHrAAQhPPhCbs0lEmLbM3bh6FW615BDx9rfHp5NtIyMimWdvIB0BpzJiJKCA45DyPQfQc1wjhzINxQMhSiOm7I7AxdvNyyldgSZg=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3887.namprd05.prod.outlook.com (10.167.141.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.8; Thu, 14 Feb 2019 16:51:17 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::9c6c:db1c:e297:7b13]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::9c6c:db1c:e297:7b13%3]) with mapi id 15.20.1622.013; Thu, 14 Feb 2019
 16:51:17 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] kernel-shark: sched-plugin: Initialize
 plugin_sched_context_handler to zeros
Thread-Topic: [PATCH] kernel-shark: sched-plugin: Initialize
 plugin_sched_context_handler to zeros
Thread-Index: AQHUxH3fs1Ho/gWemUqbBwkVkVC+/KXfgf6A
Date:   Thu, 14 Feb 2019 16:51:16 +0000
Message-ID: <14705a52-1b95-33a0-97a9-8478e9b55447@vmware.com>
References: <20190214105635.3e0e1570@gandalf.local.home>
In-Reply-To: <20190214105635.3e0e1570@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0128.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::20) To SN4PR0501MB3903.namprd05.prod.outlook.com
 (2603:10b6:803:4d::23)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82c96df0-c44d-411b-333c-08d6929ca307
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:SN4PR0501MB3887;
x-ms-traffictypediagnostic: SN4PR0501MB3887:
x-microsoft-exchange-diagnostics: 1;SN4PR0501MB3887;20:OxMSrvdxLc1yNM1U7jtK28857MMGQ7+TidCms+ub6+fCkAtTPUu2Wl7uAn9bq1BOCkEDL5pJjsf/OPNowrs6luEXYRNI4Ac64yv//f1hz4R60OQVO3cdUWqbxNfABXm5iFdEQjiUlcN0QqrwATrNbFQrVufBz80DDxbRUyNZZws=
x-microsoft-antispam-prvs: <SN4PR0501MB3887B43482B0A78D6BB8CF41A0670@SN4PR0501MB3887.namprd05.prod.outlook.com>
x-forefront-prvs: 09480768F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(366004)(396003)(346002)(199004)(189003)(26005)(2906002)(31686004)(14454004)(68736007)(6116002)(3846002)(71190400001)(71200400001)(6506007)(102836004)(386003)(76176011)(478600001)(6916009)(6346003)(52116002)(99286004)(81156014)(81166006)(256004)(486006)(476003)(2616005)(446003)(105586002)(11346002)(8676002)(8936002)(186003)(31696002)(106356001)(86362001)(316002)(6486002)(14444005)(4326008)(305945005)(6512007)(53936002)(25786009)(36756003)(6246003)(97736004)(229853002)(7736002)(6436002)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3887;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jEFUw/d7VtC0bFw1UmDg8U2lj6lNzqK84KyyeSiY+k1BncBAJm5otvym7hWec4I6zn7Jtfi6UPD26akIwqHf+VV8gFpJ0n8S1hJGs7zrYnXhzr5xfsqBBdKgtUcy4cQGdm9cevwuf9mUtdIhbf26+f252hwGyYp/pPW149055EV7luG+lywSlh/PLlzm3uKVG7yZvajKWQaVX1NRkm/qlrhc7xzOdjgO3rTWtOxqpUcpFjRTkslaPqWnQpD1/6MEDmf+B0gQTALVaRV5VpFmxWhhIMy6zt32j7EG69r4D2sSCnZOitywcr8qOFS3McUVCXyzQ8c3aY/rN+aPcTbsBreTAenboAPeHUwex5hUYptM0oZEtEDX4ReUnWp0t403Y6AhPlnSsRi13QZv7IqgVVFibtuZkSMPYyXio6P6OFg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B08B55A36F84D94BB67328D791AC23A0@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c96df0-c44d-411b-333c-08d6929ca307
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2019 16:51:16.1241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3887
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQoNCk9uIDE0LjAyLjE5INCzLiAxNzo1NiDRhy4sIFN0ZXZlbiBSb3N0ZWR0IHdyb3RlOg0KPiBG
cm9tOiAiU3RldmVuIFJvc3RlZHQgKFZNd2FyZSkiIDxyb3N0ZWR0QGdvb2RtaXMub3JnPg0KPiAN
Cj4gTm93IHRoYXQgdGhlIHNjaGVkIHBsdWdpbiBvbmx5IHJlcXVpcmVzIGEgc2luZ2xlIHdha2V1
cCBldmVudCB0byBwcm9jZXNzIHRoZQ0KPiB3YWtldXAgbGF0ZW5jeSBib3hlcywgdGhlcmUncyBu
byBndWFyYW50ZWUgdGhhdCBhbGwgdGhlIHdha2V1cCBldmVudHMgc2F2ZWQNCj4gaW4gcGx1Z2lu
X3NjaGVkX2NvbnRleHRfaGFuZGxlciB3aWxsIGJlIGluaXRpYWxpemVkLg0KPiANCj4gQWxsb2Nh
dGUgcGx1Z2luX3NjaGVkX2NvbnRleHRfaGFuZGxlciB0byB6ZXJvcyB3aXRoIGNhbGxvYygpIGlu
c3RlYWQgb2YNCj4gbWFsbG9jKCkgdG8gbWFrZSBzdXJlIHRoZSBwb2ludGVycyBpdCBoYXMgYXJl
IE5VTEwgYW5kIG5vdCBsZWZ0DQo+IHVuaW5pdGlhbGl6ZWQuDQo+IA0KPiBGaXhlczogZTUwZDNi
YmZjOWE0ICgia2VybmVsLXNoYXJrOiBBZGQgc2NoZWRfd2FraW5nIGV2ZW50IHByb2Nlc3Npbmcg
dG8gc2NoZWRfd2FraW5nIikNCj4gU2lnbmVkLW9mZi1ieTogU3RldmVuIFJvc3RlZHQgKFZNd2Fy
ZSkgPHJvc3RlZHRAZ29vZG1pcy5vcmc+DQo+IC0tLQ0KPiAgIGtlcm5lbC1zaGFyay9zcmMvcGx1
Z2lucy9zY2hlZF9ldmVudHMuYyB8IDIgKy0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9rZXJuZWwtc2hhcmsvc3Jj
L3BsdWdpbnMvc2NoZWRfZXZlbnRzLmMgYi9rZXJuZWwtc2hhcmsvc3JjL3BsdWdpbnMvc2NoZWRf
ZXZlbnRzLmMNCj4gaW5kZXggMTRmOGVkYjIuLjY4NzM0ZDRkIDEwMDY0NA0KPiAtLS0gYS9rZXJu
ZWwtc2hhcmsvc3JjL3BsdWdpbnMvc2NoZWRfZXZlbnRzLmMNCj4gKysrIGIva2VybmVsLXNoYXJr
L3NyYy9wbHVnaW5zL3NjaGVkX2V2ZW50cy5jDQo+IEBAIC00OSw3ICs0OSw3IEBAIHN0YXRpYyBi
b29sIHBsdWdpbl9zY2hlZF9pbml0X2NvbnRleHQoc3RydWN0IGtzaGFya19jb250ZXh0ICprc2hh
cmtfY3R4KQ0KPiAgIAlhc3NlcnQocGx1Z2luX3NjaGVkX2NvbnRleHRfaGFuZGxlciA9PSBOVUxM
KTsNCj4gICANCj4gICAJcGx1Z2luX3NjaGVkX2NvbnRleHRfaGFuZGxlciA9DQo+IC0JCW1hbGxv
YyhzaXplb2YoKnBsdWdpbl9zY2hlZF9jb250ZXh0X2hhbmRsZXIpKTsNCj4gKwkJY2FsbG9jKDEs
IHNpemVvZigqcGx1Z2luX3NjaGVkX2NvbnRleHRfaGFuZGxlcikpOw0KPiAgIAlpZiAoIXBsdWdp
bl9zY2hlZF9jb250ZXh0X2hhbmRsZXIpIHsNCj4gICAJCWZwcmludGYoc3RkZXJyLA0KPiAgIAkJ
CSJGYWlsZWQgdG8gYWxsb2NhdGUgbWVtb3J5IGZvciBwbHVnaW5fc2NoZWRfY29udGV4dC5cbiIp
Ow0KPiANCg0KUmV2aWV3ZWQtYnk6IFlvcmRhbiBLYXJhZHpob3YgPHlrYXJhZHpob3ZAdm13YXJl
LmNvbT4NCg==
