Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C29DC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 16:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23463222DA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 16:33:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="GQyz10L/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405227AbfBNQdG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 11:33:06 -0500
Received: from mail-eopbgr690068.outbound.protection.outlook.com ([40.107.69.68]:63120
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405161AbfBNQdG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 11:33:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pAv5bkonIvITaU0ofQT3NLbtDgpaXG7g+OqD2hnoNeY=;
 b=GQyz10L/TWPAw8DIbla8J+1429BYTc64J5vt8fVDjC2Cxhebhgwp4wl/APZDt/5A6ElqFuLN5WidGcDNGi1WWJtDILTlZnVMnQg8v+ejNTjagzZm+V8TCPSu3YPZqU4KBkik/cby/8SXvsXCOuZfVbRCgqn43/hDYr8hIweiJFg=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3902.namprd05.prod.outlook.com (10.167.141.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.9; Thu, 14 Feb 2019 16:33:04 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::9c6c:db1c:e297:7b13]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::9c6c:db1c:e297:7b13%3]) with mapi id 15.20.1622.013; Thu, 14 Feb 2019
 16:33:04 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] kernel-shark: sched-plugin: Initialize
 plugin_sched_context_handler to zeros
Thread-Topic: [PATCH] kernel-shark: sched-plugin: Initialize
 plugin_sched_context_handler to zeros
Thread-Index: AQHUxH3fs1Ho/gWemUqbBwkVkVC+/KXffOaA
Date:   Thu, 14 Feb 2019 16:33:03 +0000
Message-ID: <5c50aff8-2e73-9ea5-4c21-648274a674ee@vmware.com>
References: <20190214105635.3e0e1570@gandalf.local.home>
In-Reply-To: <20190214105635.3e0e1570@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0323.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::23) To SN4PR0501MB3903.namprd05.prod.outlook.com
 (2603:10b6:803:4d::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3edb98e0-c0d4-4970-85b9-08d6929a1773
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:SN4PR0501MB3902;
x-ms-traffictypediagnostic: SN4PR0501MB3902:
x-microsoft-exchange-diagnostics: 1;SN4PR0501MB3902;20:VHHu+NJ4lbcRpPQcuCcF3Fyk2zdAnovGGmyYtfyBK5qAV3fErMIkH7lPi33w76VBUc40nizNQeg6zR8CEfugg7rs2umsvcuLE1VJwee9DCXtzUnK0eVOwGb7EZZIAVxrQQ23un6EgmRSSa9vQdrDPnp7bJ+bAgaovcpi0AsxUNQ=
x-microsoft-antispam-prvs: <SN4PR0501MB39023F3CF5624DFC2169A6EFA0670@SN4PR0501MB3902.namprd05.prod.outlook.com>
x-forefront-prvs: 09480768F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(366004)(39860400002)(136003)(199004)(189003)(478600001)(8936002)(53936002)(68736007)(229853002)(6116002)(7736002)(305945005)(31686004)(6436002)(6486002)(14454004)(8676002)(81156014)(81166006)(3846002)(6512007)(316002)(105586002)(106356001)(6916009)(25786009)(99286004)(71190400001)(36756003)(71200400001)(66066001)(2616005)(476003)(486006)(446003)(2906002)(11346002)(31696002)(6246003)(86362001)(26005)(102836004)(14444005)(97736004)(6506007)(386003)(76176011)(4326008)(52116002)(256004)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3902;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Bvv/ES92v2UIcaAh3iB/vwHiE1PnVN4Tq0D8di2OEcOx8haiGWk6B1v+Czy3yZsYWTYyrydjK8TebdELC05FGea+e4eA20YsOyaSdSbdk7PXfl0qe16Mm5nW5xeanImLXqPeG78iKPCvF0fzLETJDpZkeplxxzdg+suA+xqBF+7G6r0jpFd1dFssziN97QInisIcptzZ3rmZ7Ayul907YLD63VW36c4ovHpzMKhj/YvXa5k+UXVBB3K59boXjiPdE8vbTePhEDU7X1ydHJtLZQ93Z4XnLq9MefuL/yO5GsVvvFDfwRc4N1pr9ez/gDhVk5vEpgFvbqmkcIiVs4SIerKlOQd4Z0qLXfZ5wom1L1heRCA8xRVLIMU4QpWtS1dTfC+TmhqClATxHi5/RVZMW65tra+gfrr2GBI21Os0V/0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <45C204B2D850004189725F8DD1D67BD3@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3edb98e0-c0d4-4970-85b9-08d6929a1773
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2019 16:33:02.9645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3902
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
Ow0KPiANCg0KbWFrZXMgcGVyZmVjdCBzZW5zZS4NCg0KVGhhbmtzIQ0KWW9yZGFuDQo=
