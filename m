Return-Path: <SRS0=JD1t=VF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6D6C606BA
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Jul 2019 14:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 384D1214AF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Jul 2019 14:02:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="1DG1tn1J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfGHOCy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 10:02:54 -0400
Received: from mail-eopbgr790087.outbound.protection.outlook.com ([40.107.79.87]:54496
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728928AbfGHOCx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 10:02:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gdhouE1rfDAVQOv0NQtbVSUY1NZdoEcA8UoZJ8tVrLYTfhGA6oUKiYbDwhV02RdssrCulZyMfCwgSvQbK1hpeXbKgV/FCh0h+wzGt30wJ5c6gMWNdln/bWg/AZoKuwNBdjd4zajCLIWxGgdTc9aANC1jMhVHWdeDnW+XkNoPwuRXSQ+h0EKmVjnGGE0EUBrKWPEPRXM6C2eegXDkq2f3VPLZIq8ICrYL5vi2V8p9Bc7ijCexgPyEizCB/kvbNk7RoCG2bkKDkbMp+mg3Ng9CEWK75MCJd7vydM+WAnbGMhZqRYxAh9aXQNugNvhFznrccDuPRuW12E1UK4cDREL7hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GemuNVfI+R+l5lV2g/nWoPZKsfsGPP3ZxhdVGvwnnNE=;
 b=Kx8RtgSBbYnj1aBXfUO2qm0LQ8G6i1k/liOcvjNSCB7myy11D7Xgr22E/nhyVfhRZRAfLbVbfBiZCytrqGuy64uiWWttrfu0UMDnTkpgnwO2rP1qcLnShbUBjmcBup27Ti7Ob9/LulQK10AHYYQnAOBZ//MVAbHi/RvIlSLegsXXr91VJFn8mYI/XA5ORJzxH4pLIdAbqduCOFwws/xyXpRgYs9z6TOzpHbYxWIO+R4MaDB829w/eWjIiz0hJCZYEMaVEGArUYZOcrPmFnX2kyB+aPTmn//6cTyIG9nq7TPv/epYgO5VDWJpgq0RHtjbdDtkEQkMbx952bDjg+PY6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=vmware.com;dmarc=pass action=none
 header.from=vmware.com;dkim=pass header.d=vmware.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GemuNVfI+R+l5lV2g/nWoPZKsfsGPP3ZxhdVGvwnnNE=;
 b=1DG1tn1JLR81aQf99PxCk1yrJzAIhnh4pfC+aQZHI5wmb+muOPS3/zv5AiM8AoUhXIK7YrgTtTkxVtHW0E5irkeMowZ0pJ87EiHfOv+vhHmABg1+9UDQTOimou9OPYAviae/ckNdrybxgVZuTHsA0sk7FJOfitlkoLkQk4ifgCc=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3696.namprd05.prod.outlook.com (10.167.140.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Mon, 8 Jul 2019 14:02:11 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::61ba:402c:4241:bf3]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::61ba:402c:4241:bf3%4]) with mapi id 15.20.2073.008; Mon, 8 Jul 2019
 14:02:11 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3] kernel-shark: Define a CMAKE_BUILD_TYPE "Package"
Thread-Topic: [PATCH v3] kernel-shark: Define a CMAKE_BUILD_TYPE "Package"
Thread-Index: AQHVNW5Nqz0e+nSDRkKYlYnYrkODR6bAtqYAgAAJ+4A=
Date:   Mon, 8 Jul 2019 14:02:11 +0000
Message-ID: <30a439a4-fd66-cbed-5c6d-08fa2af22a82@vmware.com>
References: <20190708091945.439-1-y.karadz@gmail.com>
 <20190708092632.0062411b@gandalf.local.home>
In-Reply-To: <20190708092632.0062411b@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR0802CA0010.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::20) To SN4PR0501MB3903.namprd05.prod.outlook.com
 (2603:10b6:803:4d::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4db90b13-1a98-4329-d109-08d703acdf3d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN4PR0501MB3696;
x-ms-traffictypediagnostic: SN4PR0501MB3696:
x-microsoft-antispam-prvs: <SN4PR0501MB36965009FAFF709755F7D1D1A0F60@SN4PR0501MB3696.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00922518D8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(136003)(376002)(396003)(199004)(189003)(71200400001)(229853002)(71190400001)(110136005)(6246003)(316002)(6486002)(8676002)(6436002)(31696002)(53936002)(5660300002)(8936002)(478600001)(99286004)(7736002)(305945005)(6512007)(486006)(36756003)(64756008)(25786009)(186003)(66446008)(66476007)(26005)(2616005)(73956011)(66946007)(476003)(11346002)(446003)(31686004)(66556008)(86362001)(66066001)(52116002)(76176011)(81166006)(81156014)(386003)(6506007)(5024004)(3846002)(6116002)(14454004)(102836004)(2906002)(256004)(68736007)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3696;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GBm3rGBY338ItFfgRhXP+GIYXi8UJ1eGVyrj4Isa+hPQpXmGIBeWaNYKLLQqR1qqsQb65oRtYJxIyF5XTqFUrvfP+1Tw2jr3mDoNMdyBUw0xwmOktNz1E1LS9MoKUdL2/lPMS9mORxrI0RbjhTShM6eiNDs5orp83nYzKcSNwKAqfDNtIqx6HARxJSaBNgf7Pj9uHS6qephA3PSDbSixXJZ+CF56iSJ+r+5yBkF7Q72v8o/Wed9vB/r2TuE5t8MWaIE+TL5RTJXI1T9TOVj3WNHMtAuCb1EotMErx4mMvznCb+2haP14577mTI9Lv0lF5fljZeNkxbDdFQNnurzjRo+T6SZQvKiAGxAptn4kwQ4PHYLr3ZbmecXL18kh/0As4y2MYX6ai0IIEdrQ1/4or//xIfrtVcDydwiA0VxS7tg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB86BE8DB0381B47AC182EFFF4467C08@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4db90b13-1a98-4329-d109-08d703acdf3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2019 14:02:11.4301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ykaradzhov@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3696
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQoNCk9uIDguMDcuMTkg0LMuIDE2OjI2INGHLiwgU3RldmVuIFJvc3RlZHQgd3JvdGU6DQo+IE9u
IE1vbiwgIDggSnVsIDIwMTkgMTI6MTk6NDUgKzAzMDANCj4gIllvcmRhbiBLYXJhZHpob3YgKFZN
d2FyZSkiIDx5LmthcmFkekBnbWFpbC5jb20+IHdyb3RlOg0KPiANCj4+IEZyb206IFlvcmRhbiBL
YXJhZHpob3YgPHlrYXJhZHpob3ZAdm13YXJlLmNvbT4NCj4+DQo+PiBBIHNwZWNpYWwgYnVpbGQg
dHlwZSBkZWRpY2F0ZWQgZm9yIHBhY2thZ2UgbWFpbnRhaW5lcnMgaXMgYWRkZWQuDQo+PiBCeSBk
ZWZhdWx0IHRoaXMgYnVpbGQgdHlwZSBhZGRzIHRoZSAiLU8zIiBjb21waWxlciBmbGFnLiBVc2Vy
cw0KPj4gY2FuIGNob3NlIHRoZWlyIG93biBjb21waWxlciBmbGFncyBieSBwcm92aWRpbmcgdGhl
IGNvcnJlc3BvbmRpbmcNCj4+IENNQUtFX1hYWFhfRkxBR1NfUEFDS0FHRSBDb21tYW5kLUxpbmUg
b3B0aW9ucy4NCj4+DQo+PiBJZiBubyB0eXBlcyBpcyBzcGVjaWZpZWQsIHRoZSBidWlsZCB0eXBl
IHdpbGwgYmUgIkRlYnVnIi4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBZb3JkYW4gS2FyYWR6aG92
IDx5a2FyYWR6aG92QHZtd2FyZS5jb20+DQo+Pg0KPiANCj4gVGhhbmtzIFlvcmRhbiENCj4gDQo+
IEkgYXBwbGllZCBhbmQgcHVzaGVkIG1vc3QgeW91ciBwYXRjaGVzIHVwc3RyZWFtLg0KPiANCj4g
SSBzdGFydGVkIHRvIHBsYXkgYSBsaXR0bGUgd2l0aCB0aGUgcmVjb3JkIGZlYXR1cmUsIGFuZCBm
b3VuZCBzb21lDQo+IGlzc3Vlcy4NCj4gDQo+ICAgMSkgSXQgc3RpbGwgYWRkcyBhIC1lJ2V2ZW50
JyBmb3IgYWxsIGV2ZW50cyB3aGVuIGEgc3lzdGVtIGlzIHNlbGVjdGVkLg0KPiAgICAgIENhbiB3
ZSBqdXN0IG1ha2UgaXQgdXNlIHRoZSBzeXN0ZW0/IC1laXJxIGluc3RlYWQgb2YNCj4gICAgICAt
ZWlycTppcnFfaGFuZGxlcl9lbnRyeSAtZWlycTppcnFfaGFuZGxlcl9leGl0IC1laXJxLi4uDQo+
IA0KPiAgIDIpIFdoZW4gSSBleGVjdXRlZCBpdCwgaXQgZ2F2ZSBtZSBhbiBlcnJvciwgYW5kIHRo
ZW4gY3Jhc2hlZA0KPiAgICAgIGtlcm5lbHNoYXJrLiBJdCBzaG91bGQgY2hlY2sgdGhlIHN0YXR1
cyBvZiB0aGUgcnVuIGJlZm9yZSBpdCB0cmllcw0KPiAgICAgIHRvIHJlbG9hZCBpdC4NCj4gDQo+
ICAgMykgSSBzYXZlZCB0aGUgcmVwb3J0IGFzIHRoZSByZWNvcmRlciB3YXMgc3RpbGwgcnVubmlu
ZyAoYnV0DQo+ICAgICAga2VybmVsc2hhcmsgY3Jhc2hlZCkuIEFuZCB0aGVuIHdoZW4gSSBsb2Fk
ZWQgdGhlIHJlcG9ydCAoYXR0YWNoZWQpDQo+ICAgICAgaXQganVzdCBleGVjdXRlZCBpdC4gVGhl
ICJpbXBvcnQiIHNob3VsZCBqdXN0IHB1bGwgaXQgaW4gYW5kIGxvYWQNCj4gICAgICB0aGUgc2V0
dGluZ3MuIFRoaXMgd2F5LCBvbmUgY291bGQgbWFrZSB1cGRhdGVzIHRvIGEgZGVmYXVsdCBzYXZl
ZA0KPiAgICAgIHJlY29yZC4NCj4gDQo+IFRoZXNlIHByb2JhYmx5IHNob3VsZCBiZSBmaXhlZCBi
ZWZvcmUga3MxLjAgaXMgcmVsZWFzZWQuDQo+IA0KDQpUaGFua3MgU3RldmVuIQ0KDQpJIGFncmVl
IHRoYXQgd2UgaGF2ZSB0byBnZXQgdGhlc2UgcHJvYmxlbXMgZml4ZWQgYmVmb3JlIGtzMS4wLiBD
YW4gd2UgDQpoYXZlIGEgcXVpY2sgWm9vbSBub3csIGJlY2F1c2UgSSBhbSBub3Qgc3VyZSBJIHVu
ZGVyc3RhbmQgdGhlIHNlcXVlbmNlIA0Kb2YgYWN0aW9ucyAoaW4gMiBhbmQgMykgdGhhdCBtYWRl
IGl0IGNyYXNoaW5nLg0KDQpUaGFua3MhDQpZb3JkYW4NCg0KPiBUaGFua3MhDQo+IA0KPiAtLSBT
dGV2ZQ0KPiANCg==
