Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4460C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 13:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C1CA20811
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 13:57:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="i32NWApI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfCMN5T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 09:57:19 -0400
Received: from mail-eopbgr710049.outbound.protection.outlook.com ([40.107.71.49]:53783
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726754AbfCMN5S (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 09:57:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69jyllmJ0rU5VafU6E5j51XmN6fzU3rGZHyshzamdX0=;
 b=i32NWApIWHBMyMCFFr2NswwXeKS2fp314f/rM2wH4Lt8VqhVAgYITTRQ6nHdoSMx9wUSu5+AYQ/J8HvfNpGBdbly+tpV7hTRadFRydIBwzHKV6giRu02Acw8BUqKPERLTq8TxwogKpOUlsi38RWaWCcFhNJ5qg67lkeVyil/S3s=
Received: from DM5PR0501MB3893.namprd05.prod.outlook.com (10.167.108.32) by
 DM5PR0501MB3734.namprd05.prod.outlook.com (10.167.107.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.6; Wed, 13 Mar 2019 13:57:16 +0000
Received: from DM5PR0501MB3893.namprd05.prod.outlook.com
 ([fe80::e54a:7d5:311:61eb]) by DM5PR0501MB3893.namprd05.prod.outlook.com
 ([fe80::e54a:7d5:311:61eb%5]) with mapi id 15.20.1709.011; Wed, 13 Mar 2019
 13:57:16 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] kernel-shark: Fix a bug in ksmodel_zoom
Thread-Topic: [PATCH v2 2/4] kernel-shark: Fix a bug in ksmodel_zoom
Thread-Index: AQHU1PyMD+OvMnxmgUy/c0kQ6Gnv3aYJneKAgAABcYA=
Date:   Wed, 13 Mar 2019 13:57:16 +0000
Message-ID: <569517bb-9eb6-01a4-a90c-d79c4713c0fe@vmware.com>
References: <20190307154316.19194-1-ykaradzhov@vmware.com>
 <20190307154316.19194-3-ykaradzhov@vmware.com>
 <20190313095159.6b2609b2@gandalf.local.home>
In-Reply-To: <20190313095159.6b2609b2@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR09CA0106.eurprd09.prod.outlook.com
 (2603:10a6:803:78::29) To DM5PR0501MB3893.namprd05.prod.outlook.com
 (2603:10b6:4:7b::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00fb9d98-e763-4025-b3c4-08d6a7bbcce8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:DM5PR0501MB3734;
x-ms-traffictypediagnostic: DM5PR0501MB3734:
x-microsoft-antispam-prvs: <DM5PR0501MB3734F1196264962EB3AADCE6A04A0@DM5PR0501MB3734.namprd05.prod.outlook.com>
x-forefront-prvs: 09752BC779
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(39860400002)(376002)(396003)(136003)(199004)(189003)(6116002)(2906002)(3846002)(4744005)(76176011)(81156014)(8676002)(52116002)(26005)(476003)(2616005)(66066001)(386003)(6506007)(6486002)(6436002)(6916009)(6246003)(53936002)(486006)(186003)(36756003)(102836004)(446003)(11346002)(6512007)(31696002)(86362001)(99286004)(31686004)(316002)(478600001)(229853002)(81166006)(305945005)(106356001)(105586002)(25786009)(7736002)(68736007)(4326008)(8936002)(256004)(14454004)(71200400001)(97736004)(71190400001)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR0501MB3734;H:DM5PR0501MB3893.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tqb9LJ0ASgyMfO4FM5ASXJlFsKFpsxsFCfJ40Nx2ZwGKqb1aBypc+GUEBIgWm782viGh/Fe0dvyBf0pgpG2TqU0sSmISjIfP8fHqoIBgrjEHpFfNA9324F1gyBvLYF/YPZ46iikYj6ZrYdoHHv1aKPQWu3s13dqg33Zu4jRPTVQaWEGxoHKoyTaolIVmYMW7W2hHPNN5dDGUe1AZqMjy7xdW1uEoNjzfw9zi43ufn9EYuu9/cCkh9flg1WRhfHzskMMx5q0Ap5nsxhRh4MrTzqvTjaBIBSsA0S1PRU0vdJH2Aq8jSf6s7boloTWlMy8rKXmx1msxZJn43xX4Umv2PNbFJbGhkm339denp0EPjgcof5lU93vGZAhS6a8dyjeqEKpTaEPOqpHta0erX3AXSnWpjyH2ZT9icA5/JbZM5KI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <81D4E8E1912EF14C91135468B93B9C10@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00fb9d98-e763-4025-b3c4-08d6a7bbcce8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2019 13:57:16.1451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0501MB3734
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQoNCk9uIDEzLjAzLjE5INCzLiAxNTo1MSDRhy4sIFN0ZXZlbiBSb3N0ZWR0IHdyb3RlOg0KPiBP
biBUaHUsICA3IE1hciAyMDE5IDE3OjQzOjE0ICswMjAwDQo+IFlvcmRhbiBLYXJhZHpob3YgPHlr
YXJhZHpob3ZAdm13YXJlLmNvbT4gd3JvdGU6DQo+IA0KPj4gV2hlbiB6b29taW5nLWluIHRoZSBt
b2RlbCBpcyBzdXBwb3NlZCB0byBhdm9pZCBvdmVyLXpvb21pbmcgYnkNCj4+IHJlY2FsY3VsYXRp
b24gdGhlIFNjYWxlIGZhY3Rvci4gVGhlIG5ldyB2YWx1ZSBvZiB0aGUgU2NhbGUgZmFjdG9yIGlz
DQo+PiBzdXBwb3NlZCB0byBiZSBzdWNoIHRoYXQgdGhlIHNpemUgb2YgdGhlIGJpbiBjYW5ub3Qg
YmUgc21hbGxlciB0aGFuIDUNCj4+IG5zLiBUaGlzIHBhdGNoIGZpeGVzIGEgbmFpdmUgYnVnIGlu
IHRoZSB3YXkgdGhlIG5ldyBzY2FsZSB2YWx1ZSBpcw0KPj4gY2FsY3VsYXRlZC4NCj4gDQo+IEJU
Vywgd2hhdCBpZiB0aGUgcmVzb2x1dGlvbiBvZiB0aW1lIHN0YW1wcyBpc24ndCBpbiBucywgYW5k
IHdlIGNhbiBoYXZlDQo+IG1vcmUgdGhhbiBvbmUgZXZlbnQgaW4gYSA1IHVuaXQgYmluLiBEb2Vz
IHRoYXQgbWVhbiB3ZSBuZXZlciBkaXNwbGF5DQo+IG11bHRpcGxlIGV2ZW50cyBpbiB0aGF0IHNt
YWxsIG9mIGEgdGltZSBzY2FsZT8NCg0KRm9yIHRoZSBtb21lbnQgWWVzLg0KV2UgaGF2ZSB0byBt
YWtlIHRoaXMgdmFsdWUgKDUgdW5pdHMgL25zKSBhIHBhcmFtZXRlciB0aGF0IGNhbiBiZSBjb25m
aWd1cmVkLg0KDQpZb3JkYW4NCg0KPiANCj4gLS0gU3RldmUNCj4gDQo=
