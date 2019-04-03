Return-Path: <SRS0=MeYK=SF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 030BEC4360F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Apr 2019 13:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA3092147C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Apr 2019 13:11:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="LY5iQE0N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfDCNLL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 09:11:11 -0400
Received: from mail-eopbgr820080.outbound.protection.outlook.com ([40.107.82.80]:16491
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725959AbfDCNLK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 09:11:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSKzy3hdpvMueH1beHNAYW2Gn2TKySoB8kdbnp97LuM=;
 b=LY5iQE0NHl0vrRWzWT+xOh+LnRks0zMGhfMKyUTr7820rogyHsQe92E/qJ9Zs/KZIYGZwRRuDvsEP9k/DMGJJhI+QQUjLKZ2X04Xg/7C5w56FYs584U1Mi1QvYHUIeLvoUpgnhA/RYVzl3yDgH9QIoBpro+ZIk6chx0v+crRJBE=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3753.namprd05.prod.outlook.com (10.167.163.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.7; Wed, 3 Apr 2019 13:11:08 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41%5]) with mapi id 15.20.1771.007; Wed, 3 Apr 2019
 13:11:08 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [RFC PATCH v9 11/11] trace-cmd: Add splice() recording from FIFO
 without additional pipe buffer
Thread-Topic: [RFC PATCH v9 11/11] trace-cmd: Add splice() recording from FIFO
 without additional pipe buffer
Thread-Index: AQHU6hyBQpNQWScpaUWmgsH5b4lG9aYqaSsA
Date:   Wed, 3 Apr 2019 13:11:07 +0000
Message-ID: <fe5cbfd1d91e83636d6b32c2522411aed471958d.camel@vmware.com>
References: <20190402134540.32321-1-kaslevs@vmware.com>
         <20190402134540.32321-12-kaslevs@vmware.com>
         <20190403085515.1652201a@gandalf.local.home>
In-Reply-To: <20190403085515.1652201a@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 684e0a00-1652-490f-424d-08d6b835d5ec
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600139)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR0501MB3753;
x-ms-traffictypediagnostic: MWHPR0501MB3753:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR0501MB375329E81F4E05255F0CE8ADDA570@MWHPR0501MB3753.namprd05.prod.outlook.com>
x-forefront-prvs: 0996D1900D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(366004)(346002)(396003)(189003)(199004)(97736004)(4744005)(71200400001)(229853002)(53936002)(6436002)(71190400001)(478600001)(68736007)(2351001)(476003)(6246003)(5660300002)(14454004)(6306002)(6512007)(66066001)(5640700003)(256004)(966005)(86362001)(36756003)(7736002)(305945005)(81166006)(8936002)(102836004)(6486002)(25786009)(486006)(6506007)(26005)(1730700003)(8676002)(6916009)(76176011)(105586002)(4326008)(6116002)(81156014)(99286004)(186003)(2906002)(316002)(106356001)(2616005)(118296001)(11346002)(2501003)(446003)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3753;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OEXvF5DG/GEws7b94ij+YJ/DIWXauVAkfUjVfAoY2oIN70iPqTw4MEzbPmMd1EIQFTyKbletS2Qxt01kNQtC+YHJ7E7vtFJ24E8OkCmx32r0qHXHgWwp1lqb/jg4bnlasl4bL9hgoF51xjwHypnj3eK6Mt9Lt+83qjdjSoOw/c5E1SFKKcejkU7XOwkVdgv+nePUcX2IfR4KKnTJlkuVQTNeZPxnOQ+bwBaFPT/ehNe9+uci9mjf0NqeU7v1E1lC/HE66xpPVdhBmMVglSz3wotEQIarGzQncAb5OHlqNwj6cE0E9YBWQdZtgIIcmptW83ADj+sB9DjASkPeootalzPjFTSRsOZ0VtbJyZw+5Tmc/Q48SyilnHtPwq6juSfCo+426kjww4oOR9cNrkoCQ/DZJvWB3RxvRAcT5+3SQ3g=
Content-Type: text/plain; charset="utf-8"
Content-ID: <719CF3991CB37C4E8C2541327A25C87C@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 684e0a00-1652-490f-424d-08d6b835d5ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2019 13:11:07.9300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3753
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCAyMDE5LTA0LTAzIGF0IDA4OjU1IC0wNDAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gT24gVHVlLCAgMiBBcHIgMjAxOSAxNjo0NTo0MCArMDMwMA0KPiBTbGF2b21pciBLYXNsZXYg
PGthc2xldnNAdm13YXJlLmNvbT4gd3JvdGU6DQo+IA0KPiA+ICsvKg0KPiA+ICsgKiBSZXR1cm5z
IC0xIG9uIGVycm9yLg0KPiA+ICsgKiAgICAgICAgICBvciBieXRlcyBvZiBkYXRhIHJlYWQuDQo+
ID4gKyAqLw0KPiA+ICtzdGF0aWMgbG9uZyBkaXJlY3Rfc3BsaWNlX2RhdGEoc3RydWN0IHRyYWNl
Y21kX3JlY29yZGVyICpyZWNvcmRlcikNCj4gPiArew0KPiA+ICsJc3RydWN0IHBvbGxmZCBwZmQg
PSB7DQo+ID4gKwkJLmZkID0gcmVjb3JkZXItPnRyYWNlX2ZkLA0KPiA+ICsJCS5ldmVudHMgPSBQ
T0xMSU4sDQo+ID4gKwl9Ow0KPiA+ICsJbG9uZyByZWFkOw0KPiA+ICsJaW50IHJldDsNCj4gPiAr
DQo+ID4gKwlyZXQgPSBwb2xsKCZwZmQsIDEsIFBPTExfVElNRU9VVF9NUyk7DQo+ID4gKwlpZiAo
cmV0IDwgMCkNCj4gPiArCQlyZXR1cm4gLTE7DQo+ID4gKw0KPiA+ICsJaWYgKCEocGZkLnJldmVu
dHMgfCBQT0xMSU4pKQ0KPiA+ICsJCXJldHVybiAwOw0KPiANCj4gV2h5IHRoZSBwb2xsaW5nIGNv
ZGUsIGFuZCBub3QganVzdCBibG9jayBvbiBzcGxpY2U/DQoNClRvIHdvcmsgYXJvdW5kIG9sZGVy
IGtlcm5lbHMgdGhhdCBkb24ndCBoYXZlIHRoZSBzcGxpY2UoMikNCk9fTk9OQkxPQ0tJTkcgZml4
WzFdIGZvciBwaXBlcy4NCg0KQW4gYWx0ZXJuYXRpdmUgd291bGQgYmUgdG8gY29uZmlndXJlIFNJ
R0lOVCBub3QgdG8gYXV0byByZXN0YXJ0DQpzeXNjYWxscyAod2hpY2ggaXMgdGhlIGRlZmF1bHQg
YWZhaWspLiBUaGVuIHNwbGljZSgyKSB3aWxsIHJldHVybg0KRUFHQUlOIGFuZCB3aWxsIGNhbiBy
ZXN0YXJ0IGl0IHdpdGggU1BMSUNFX0ZfTk9OQkxPQ0sgZmxhZyBvbi4NCg0KWzFdIA0KaHR0cHM6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXgu
Z2l0L2NvbW1pdC8/aWQ9ZWU1ZTAwMTE5NmQxMzQ1YjhmZWUyNTkyNWZmNWYxZDY3OTM2MDgxZQ0K
