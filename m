Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F71C3A5A2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1986B2080F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:18:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="GUmDiPKI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388623AbfITPSn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 11:18:43 -0400
Received: from mail-eopbgr740045.outbound.protection.outlook.com ([40.107.74.45]:51040
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387520AbfITPSn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 11:18:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FxsM7uQZCFtbrYOCmFRBxJPnmy00MGKcH7VlC2a0R4wrt3GPAvchJJctd1PUVg0OeFePvDtyOztdteFZKV/oMa4Y+X/JbQdFD2ZyXNJ/IFky7iw943PMZ5Nc4m42LcSRvQQxIJ2whhhKhteKYHfAo53KkGU3ko/OcYPe6OkRzGNSbfDjR/q4+AyunIx2QVO7+8L07lNVIe5AZAggBLw/XIMHBGVPHXTlGKB0Mi2HrJgat0qNZsKKDy/6d25ERb7qx2GzyHDpLc9MawI9Xf2p6goXEenXfgJgML/xFt3X2Nv3tvRy9kL5DgVIS3KAYkdehWYQDGRtXQuaNS0ANEiBkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuM0KSLOt1lw2noOUUgq68XRP8tamgdFuc02tqIxQA8=;
 b=BpVLjRU/FsiLLBoSyBin884wQcvlgC+eGSoUna6L3ZU4r8JbNqVN0fTNxfS5waPG0ofVtiU2/7W1n+nrJKHXFyFNj956BTspNro2YKKwbKNCffeJZNorEv8U95cryf+Y5jjpQGsdpolnaJo1uyBlMMhs/9VaHHwUA7vTzDEtoVbdBQ88MDdeequO4C+qmbXy/jNjo0ZKHsIwfT4NgNttoqYGdWcrj/F6hj4x9Dlb4ZlKl8mSnzL4hN6xpcRxWCjoQZw6wUC89Fm1K3ZHM6fSLe1pum3E1MCWjLweAQjyQZ1xJ4n+R00QvBz5J4tjNq8nhEwpo4EPjv/u3t0KWBzv4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuM0KSLOt1lw2noOUUgq68XRP8tamgdFuc02tqIxQA8=;
 b=GUmDiPKIXqKc1YX5LKzWuKAIqOyMKoEORe++ywqE72EM/yJENd+ghahXZ9Ut3n/Z+GVbP4cXHXj3CiyFqnoAgtY8+rkwXswic59vBXg+o/J/Cb34x/b3FsitUT9J4ONgTSnmToWx764ZfXatzh3Vc+czdwV4yogUZI1oj+KMGvQ=
Received: from SN6PR05MB4045.namprd05.prod.outlook.com (52.135.66.139) by
 SN6PR05MB5501.namprd05.prod.outlook.com (52.135.109.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.11; Fri, 20 Sep 2019 15:18:37 +0000
Received: from SN6PR05MB4045.namprd05.prod.outlook.com
 ([fe80::5dd0:4ccb:3dbf:91f9]) by SN6PR05MB4045.namprd05.prod.outlook.com
 ([fe80::5dd0:4ccb:3dbf:91f9%7]) with mapi id 15.20.2284.009; Fri, 20 Sep 2019
 15:18:37 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 5/5] tools/lib/traceevent: Round up in tep_print_event()
 time precision
Thread-Topic: [PATCH 5/5] tools/lib/traceevent: Round up in tep_print_event()
 time precision
Thread-Index: AQHVbcWPyAu5/TOsSkSmNfdqhD0oFac0sbiA
Date:   Fri, 20 Sep 2019 15:18:37 +0000
Message-ID: <CACqStoch-exxzRUd1TCfDSPV1ojw4+QV-y=Z0jWLQPRk1cHohw@mail.gmail.com>
References: <20190918020334.344561631@goodmis.org>
 <20190918020530.974032887@goodmis.org>
In-Reply-To: <20190918020530.974032887@goodmis.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0004.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::17) To SN6PR05MB4045.namprd05.prod.outlook.com
 (2603:10b6:805:26::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAX/P61ZbbdTuAK9P8DWUhUd9On63SXzrcxffOmaXAGCO7wDnNi9
        d5nlKzUmyBzXf8LYjLxxiaKt2imTr441v0e6yqY=
x-google-smtp-source: APXvYqwZ/SmwmcJgeA2nIGpITpraYgT44Y5+vJCagZvXHCqRf4mvSBZTIe8D1WDpn8rjbbck2LBkfZpAA2uxJQZ9WjY=
x-received: by 2002:adf:fe07:: with SMTP id n7mr1070371wrr.90.1568992712034;
 Fri, 20 Sep 2019 08:18:32 -0700 (PDT)
x-gmail-original-message-id: <CACqStoch-exxzRUd1TCfDSPV1ojw4+QV-y=Z0jWLQPRk1cHohw@mail.gmail.com>
x-originating-ip: [209.85.221.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fcc7fdcd-9c52-448e-a58d-08d73dddcf2f
x-ms-traffictypediagnostic: SN6PR05MB5501:
x-microsoft-antispam-prvs: <SN6PR05MB5501C8BB7DFABF48FB7055E9DC880@SN6PR05MB5501.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0166B75B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(199004)(189003)(305945005)(95326003)(14454004)(8676002)(186003)(6486002)(2906002)(8936002)(76176011)(386003)(52116002)(81166006)(478600001)(229853002)(81156014)(3846002)(6116002)(99286004)(61266001)(6862004)(4326008)(6246003)(316002)(6436002)(9686003)(6512007)(7736002)(446003)(11346002)(498394004)(25786009)(6506007)(53546011)(66066001)(476003)(486006)(5660300002)(256004)(86362001)(26005)(71190400001)(14444005)(66946007)(66476007)(66556008)(66446008)(64756008)(55446002)(71200400001)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB5501;H:SN6PR05MB4045.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bJJblRr0ipPOlwrOe7C+Dakb99r+xaWutEfLjWLvlbboi5yTArjGlQfofw1aCFj/gIndTcQutTTJL54zNRB8PZjC2pCQFxxOYXhpOWYigCgLboWdhpIcxxu2PrbtVxo0yH0Yfw3nxXQFGq3WVir78EsNgkHPedB1Bfafkr0BB5h5Cgg+Nkrlu+Fhxcn3epU40QDB7ZdUzEMelfeB8v+wEwIFOhJNoVBuApMXVNpGDb5pCCq7EL6KVc16Q/YmW991H5d1HPsz62qQo/PoUcOIDWbNTPq70YUziFDJZ0OcqKCmvUw3rRgzfjXUASb9wkmlkMNGVSpNiZJY/Fkf5zbe2HLnhjZD8b1ltiBPFrnbLEWzDAWPis00ETGXwUFY8K4wuo5bHVUebATsjflDS3Hx8byyASH/jkPPFNjfDVHX5xY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E7B9F5D74F72E4DB975D005683F847F@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcc7fdcd-9c52-448e-a58d-08d73dddcf2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2019 15:18:37.1856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0iz+qLIDelz0Kg7K6u444qfkF5yXoMgs7S/dUlZQ+TeqnNXWBdztUtJZVx4XlzGxyx17tXM48lAo/dl2Sy9pEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB5501
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCBTZXAgMTgsIDIwMTkgYXQgNTowMyBBTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IEZyb206ICJTdGV2ZW4gUm9zdGVkdCAoVk13YXJlKSIg
PHJvc3RlZHRAZ29vZG1pcy5vcmc+DQo+DQo+IFdoZW4gdGVzdGluZyB0aGUgb3V0cHV0IG9mIHRo
ZSBvbGQgdHJhY2UtY21kIGNvbXBhcmVkIHRvIHRoZSBvbmUgdGhhdCB1c2VzDQo+IHRoZSB1cGRh
dGVkIHRlcF9wcmludF9ldmVudCgpIGxvZ2ljLCBpdCB3YXMgZGlmZmVyZW50IGluIHRoYXQgdGhl
IHRpbWUgc3RhbXANCj4gcHJlY2lzaW9uIGluIHRoZSBvbGQgZm9ybWF0IHdvdWxkIHJvdW5kIHVw
IHRvIHRoZSBuZWFyZXN0IHByZWNpc2lvbiwgd2hlcmUNCj4gYXMgdGhlIG5ldyBsb2dpYyB0cnVu
Y2F0ZXMuIEJyaW5nIGJhY2sgdGhlIG9sZCBtZXRob2Qgb2Ygcm91bmRpbmcgdXAuDQo+DQo+IFNp
Z25lZC1vZmYtYnk6IFN0ZXZlbiBSb3N0ZWR0IChWTXdhcmUpIDxyb3N0ZWR0QGdvb2RtaXMub3Jn
Pg0KPiAtLS0NCj4gIGxpYi90cmFjZWV2ZW50L2V2ZW50LXBhcnNlLmMgfCA0ICsrKy0NCj4gIDEg
ZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4NCj4gZGlmZiAt
LWdpdCBhL2xpYi90cmFjZWV2ZW50L2V2ZW50LXBhcnNlLmMgYi9saWIvdHJhY2VldmVudC9ldmVu
dC1wYXJzZS5jDQo+IGluZGV4IGQxMDg1YWFiOWM0My4uN2ZiYmJjY2FiNzhhIDEwMDY0NA0KPiAt
LS0gYS9saWIvdHJhY2VldmVudC9ldmVudC1wYXJzZS5jDQo+ICsrKyBiL2xpYi90cmFjZWV2ZW50
L2V2ZW50LXBhcnNlLmMNCj4gQEAgLTU1MjcsOCArNTUyNywxMCBAQCBzdGF0aWMgdm9pZCBwcmlu
dF9ldmVudF90aW1lKHN0cnVjdCB0ZXBfaGFuZGxlICp0ZXAsIHN0cnVjdCB0cmFjZV9zZXEgKnMs
DQo+ICAgICAgICAgaWYgKGRpdnN0ciAmJiBpc2RpZ2l0KCooZGl2c3RyICsgMSkpKQ0KPiAgICAg
ICAgICAgICAgICAgZGl2ID0gYXRvaShkaXZzdHIgKyAxKTsNCj4gICAgICAgICB0aW1lID0gcmVj
b3JkLT50czsNCj4gLSAgICAgICBpZiAoZGl2KQ0KPiArICAgICAgIGlmIChkaXYpIHsNCj4gKyAg
ICAgICAgICAgICAgIHRpbWUgKz0gZGl2IC8gMjsNCj4gICAgICAgICAgICAgICAgIHRpbWUgLz0g
ZGl2Ow0KPiArICAgICAgIH0NCj4gICAgICAgICBwciA9IHByZWM7DQo+ICAgICAgICAgd2hpbGUg
KHByLS0pDQo+ICAgICAgICAgICAgICAgICBwMTAgKj0gMTA7DQo+IC0tDQo+IDIuMjAuMQ0KPg0K
Pg0KDQpMb29rcyBnb29kIHRvIG1lLg0KUmV2aWV3ZWQtYnk6IFR6dmV0b21pciBTdG95YW5vdiAo
Vk13YXJlKSA8dHouc3RveWFub3ZAZ21haWwuY29tPg0KDQotLSANClR6dmV0b21pciAoQ2Vjbykg
U3RveWFub3YNClZNd2FyZSBPcGVuIFNvdXJjZSBUZWNobm9sb2d5IENlbnRlcg0K
