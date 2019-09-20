Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18096C3A5A2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C630B208C0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:08:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="NcXBrAKs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391592AbfITPIv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 11:08:51 -0400
Received: from mail-eopbgr780057.outbound.protection.outlook.com ([40.107.78.57]:2785
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389978AbfITPIu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 11:08:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+Kcyc78eES8HeGtX7FSyer61VqVNu9SoctyAeyBVYTtnmNwUsQKl+6mg1jrdNVrDHWvZ7L1OQN8APyvjDfLRYRMqARYbG14d/jSaDeXdq7OTvuXjY7nM9o3eErNBnKq/HnC7/cpbinr70cXwWGTufxFEkpciq1jmnt9rRC2LNmh6D/4g/uuPCaUbPIs4jCQ9I/MyZkM7oPrTvg5aZ4to/HVRYw0QSPLvPCOlBndpyIdinzGZYxuysRvCkr05/PV8X/iaK3s5GaA6+ki0vsyQAqx5BgJThjRRfJUuVNsFVV28C0uTY+H3HUp5PKkPiDkQdf/2YHqslnmU4HbF5i53g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRdPHunY/iERQF2ZDLxrJ4ZRS0BXprKeSqIVu9a3PJU=;
 b=E1abqg2TfF0ahr82AEs/KJM+1LL9gDUXzS6qbKfKwjmgpJjWEVmoasnX5XezH3NAzWTERZ6eaM8vcKrQSaZ3GLMSuEMT5U/3e/enIyrWjE52Au1DYMOS7WDajJ1ryb/TZO/Q904jDiLnSahf5VZgsumX13WD/78SGlznzn3hH8PPpzsWuyVKOUotqkE16QhSO5/igorY7BXF6eEpslUze3sRjdEV4XYiCWVrUOJy5TldSFiEnaOepxoxpsePb3i6GslbB9wN0cDJI6v0EQyI9X1GDODkWgWggFDmL7GK1276hVU17KJQZ1Nnml0rOMr+WbPjHFW+JvHqH+Gac1keyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRdPHunY/iERQF2ZDLxrJ4ZRS0BXprKeSqIVu9a3PJU=;
 b=NcXBrAKsnjTkFZNDWygsADDle0oc7vsDL6TvRpLyxZh0Nrrm6WpnbmP3C+YqkBtEPRnKOzq6fRocColcsxJ36A+9r9gvSJFnK2Cnhw1/b0xfS/x2f/EUUyI5Pv0bNTY2+DRSe1OJVhQZHLHndyRye+8kWayJl96OfZbVIJQpJcE=
Received: from SN6PR05MB4045.namprd05.prod.outlook.com (52.135.66.139) by
 SN6PR05MB5535.namprd05.prod.outlook.com (52.135.111.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.10; Fri, 20 Sep 2019 15:08:47 +0000
Received: from SN6PR05MB4045.namprd05.prod.outlook.com
 ([fe80::5dd0:4ccb:3dbf:91f9]) by SN6PR05MB4045.namprd05.prod.outlook.com
 ([fe80::5dd0:4ccb:3dbf:91f9%7]) with mapi id 15.20.2284.009; Fri, 20 Sep 2019
 15:08:47 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/5] trace-cmd: Separate out time diff code in
 trace_show_data()
Thread-Topic: [PATCH 2/5] trace-cmd: Separate out time diff code in
 trace_show_data()
Thread-Index: AQHVbcWaEvp9B1hs10i1q3U3MWf3pKc0rvmA
Date:   Fri, 20 Sep 2019 15:08:47 +0000
Message-ID: <CACqStodaoEJr4DOnAFdp7ZAdeu-Yz7HhwOtgqQKfiZyY7gD8nw@mail.gmail.com>
References: <20190918020334.344561631@goodmis.org>
 <20190918020530.499901908@goodmis.org>
In-Reply-To: <20190918020530.499901908@goodmis.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR05CA0035.eurprd05.prod.outlook.com
 (2603:10a6:208:55::48) To SN6PR05MB4045.namprd05.prod.outlook.com
 (2603:10b6:805:26::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAVYgcC+IBlRg+dBBLcS4WZq9V0wzbU4xnFhRTvSpbuu8bi2XtQt
        TS0uXmq0MfDOX4YuKbIfbTZ5bVfQscfSm/mdT5c=
x-google-smtp-source: APXvYqyKFtaxId+HkFvY9MfYzd5tMpkcYr/Tcu0pInC8mZbNv3Gtn24oT6kAObdT3jkv8ik8CruHCuj4CZE63X4SAvg=
x-received: by 2002:adf:c504:: with SMTP id q4mr13267168wrf.266.1568992121637;
 Fri, 20 Sep 2019 08:08:41 -0700 (PDT)
x-gmail-original-message-id: <CACqStodaoEJr4DOnAFdp7ZAdeu-Yz7HhwOtgqQKfiZyY7gD8nw@mail.gmail.com>
x-originating-ip: [209.85.221.51]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5394a3d1-7044-48f0-af4c-08d73ddc6fb6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:SN6PR05MB5535;
x-ms-traffictypediagnostic: SN6PR05MB5535:
x-microsoft-antispam-prvs: <SN6PR05MB5535454CBA622D0E299FF876DC880@SN6PR05MB5535.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:161;
x-forefront-prvs: 0166B75B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(199004)(189003)(52116002)(66446008)(99286004)(4326008)(316002)(95326003)(25786009)(76176011)(6862004)(3846002)(61266001)(6486002)(229853002)(66066001)(6116002)(8676002)(6512007)(5660300002)(486006)(9686003)(81166006)(81156014)(2906002)(256004)(476003)(26005)(6246003)(102836004)(66946007)(6436002)(14454004)(186003)(498394004)(478600001)(55446002)(66556008)(64756008)(53546011)(11346002)(6506007)(386003)(446003)(71190400001)(71200400001)(86362001)(8936002)(7736002)(305945005)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB5535;H:SN6PR05MB4045.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cFQIyjRjr8pBlrTJgZMH3mk6NGkMHYl6705SVtU1KoU05IaARlFtc43SeBZUNGjTBez/Z3T/kwnUakkm0m2Fs6561uz5zotymAaC3mQooPIWB0bg9hPP/nKUbKC9AqZaWBy3avFU5LG0LuKkOU/PB4oVJmmIzF/dqvpq6wCkCTtHjDI3W1jA4DJEymFm32p+MIVxpx+jRPYa5KSJHV/yDbPHB72KMClKHlWTERLSgbLjA+YyhHM9IgAS0vrNy5D35KEj1/zJCQTCg3idJLOl+nPrUB/YU2UCIE6mnL1XqLJAOKQUvV+C3t348de9UzA62V8vgOGpGX0cr3Gp2hHx4BNYNh2C0EpkZ4phIvEN+U5P094T8LvNpEcRIFYNttyCMTVL6ImkvGALiZJH+1EGKOmp4h+VxLbL2Sevy3DuZpw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BDC4175766DC5744BAE87F871CBDCCB4@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5394a3d1-7044-48f0-af4c-08d73ddc6fb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2019 15:08:47.4346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GQ/xmlEgGkHkeZlbt7IvLYiSYM3CNagk82dDp0erVjYO8eX3b78BcU/PFCr+iTP3/DnbBD9RKMclp5meanaSyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB5535
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCBTZXAgMTgsIDIwMTkgYXQgNTowMyBBTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IEZyb206ICJTdGV2ZW4gUm9zdGVkdCAoVk13YXJlKSIg
PHJvc3RlZHRAZ29vZG1pcy5vcmc+DQo+DQo+IFRvIG1ha2UgaXQgZWFzaWVyIHRvIGNvbnZlcnQg
dG8gdGhlIG5ldyB0ZXBfcHJpbnRfZXZlbnQoKSBmb3JtYXQsIHVzZSB0aGUNCj4gb3BlbiBjb2Rl
ZCB2ZXJzaW9uIG9mIHRoZSB0cmFjaW5nIGRhdGEgcmVnYXJkbGVzcyBpZiBhIGRpZmZlcmVudCB0
aW1lc3RhbXANCj4gaXMgdG8gYmUgdXNlZC4NCj4NCj4gU2lnbmVkLW9mZi1ieTogU3RldmVuIFJv
c3RlZHQgKFZNd2FyZSkgPHJvc3RlZHRAZ29vZG1pcy5vcmc+DQo+IC0tLQ0KPiAgdHJhY2VjbWQv
dHJhY2UtcmVhZC5jIHwgMTcgKysrKysrKysrLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA5
IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS90cmFjZWNt
ZC90cmFjZS1yZWFkLmMgYi90cmFjZWNtZC90cmFjZS1yZWFkLmMNCj4gaW5kZXggYzE0ZTg3Zjc2
YTMyLi4wMWQ5MDQ5NjRlZGYgMTAwNjQ0DQo+IC0tLSBhL3RyYWNlY21kL3RyYWNlLXJlYWQuYw0K
PiArKysgYi90cmFjZWNtZC90cmFjZS1yZWFkLmMNCj4gQEAgLTc1Nyw2ICs3NTcsNyBAQCB2b2lk
IHRyYWNlX3Nob3dfZGF0YShzdHJ1Y3QgdHJhY2VjbWRfaW5wdXQgKmhhbmRsZSwgc3RydWN0IHRl
cF9yZWNvcmQgKnJlY29yZCkNCj4gIHsNCj4gICAgICAgICB0cmFjZWNtZF9zaG93X2RhdGFfZnVu
YyBmdW5jID0gdHJhY2VjbWRfZ2V0X3Nob3dfZGF0YV9mdW5jKGhhbmRsZSk7DQo+ICAgICAgICAg
c3RydWN0IHRlcF9oYW5kbGUgKnBldmVudDsNCj4gKyAgICAgICBzdHJ1Y3QgdGVwX2V2ZW50ICpl
dmVudDsNCj4gICAgICAgICBzdHJ1Y3QgdHJhY2Vfc2VxIHM7DQo+ICAgICAgICAgaW50IGNwdSA9
IHJlY29yZC0+Y3B1Ow0KPiAgICAgICAgIGJvb2wgdXNlX3RyYWNlX2Nsb2NrOw0KPiBAQCAtNzkz
LDE0ICs3OTQsMTMgQEAgdm9pZCB0cmFjZV9zaG93X2RhdGEoc3RydWN0IHRyYWNlY21kX2lucHV0
ICpoYW5kbGUsIHN0cnVjdCB0ZXBfcmVjb3JkICpyZWNvcmQpDQo+ICAgICAgICAgICAgICAgICB9
DQo+ICAgICAgICAgfQ0KPiAgICAgICAgIHVzZV90cmFjZV9jbG9jayA9IHRyYWNlY21kX2dldF91
c2VfdHJhY2VfY2xvY2soaGFuZGxlKTsNCj4gKyAgICAgICBldmVudCA9IHRlcF9maW5kX2V2ZW50
X2J5X3JlY29yZChwZXZlbnQsIHJlY29yZCk7DQo+ICsgICAgICAgdGVwX3ByaW50X2V2ZW50X3Rh
c2socGV2ZW50LCAmcywgZXZlbnQsIHJlY29yZCk7DQo+ICsgICAgICAgdGVwX3ByaW50X2V2ZW50
X3RpbWUocGV2ZW50LCAmcywgZXZlbnQsIHJlY29yZCwNCj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB1c2VfdHJhY2VfY2xvY2spOw0KPiAgICAgICAgIGlmICh0c2RpZmYpIHsNCj4gICAg
ICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgbG9uZyByZWNfdHMgPSByZWNvcmQtPnRzOw0KPiAt
ICAgICAgICAgICAgICAgc3RydWN0IHRlcF9ldmVudCAqZXZlbnQ7DQo+DQo+IC0gICAgICAgICAg
ICAgICBldmVudCA9IHRlcF9maW5kX2V2ZW50X2J5X3JlY29yZChwZXZlbnQsIHJlY29yZCk7DQo+
IC0gICAgICAgICAgICAgICB0ZXBfcHJpbnRfZXZlbnRfdGFzayhwZXZlbnQsICZzLCBldmVudCwg
cmVjb3JkKTsNCj4gLSAgICAgICAgICAgICAgIHRlcF9wcmludF9ldmVudF90aW1lKHBldmVudCwg
JnMsIGV2ZW50LCByZWNvcmQsDQo+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB1c2VfdHJhY2VfY2xvY2spOw0KPiAgICAgICAgICAgICAgICAgYnVmWzBdID0gMDsNCj4g
ICAgICAgICAgICAgICAgIGlmICh1c2VfdHJhY2VfY2xvY2sgJiYgIXRlcF90ZXN0X2ZsYWcocGV2
ZW50LCBURVBfTlNFQ19PVVRQVVQpKQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICByZWNfdHMg
PSAocmVjX3RzICsgNTAwKSAvIDEwMDA7DQo+IEBAIC04MTEsOSArODExLDEwIEBAIHZvaWQgdHJh
Y2Vfc2hvd19kYXRhKHN0cnVjdCB0cmFjZWNtZF9pbnB1dCAqaGFuZGxlLCBzdHJ1Y3QgdGVwX3Jl
Y29yZCAqcmVjb3JkKQ0KPiAgICAgICAgICAgICAgICAgfQ0KPiAgICAgICAgICAgICAgICAgbGFz
dF90cyA9IHJlY190czsNCj4gICAgICAgICAgICAgICAgIHRyYWNlX3NlcV9wcmludGYoJnMsICIg
JS04cyIsIGJ1Zik7DQo+IC0gICAgICAgICAgICAgICB0ZXBfcHJpbnRfZXZlbnRfZGF0YShwZXZl
bnQsICZzLCBldmVudCwgcmVjb3JkKTsNCj4gLSAgICAgICB9IGVsc2UNCj4gLSAgICAgICAgICAg
ICAgIHRlcF9wcmludF9ldmVudChwZXZlbnQsICZzLCByZWNvcmQsIHVzZV90cmFjZV9jbG9jayk7
DQo+ICsgICAgICAgfQ0KPiArDQo+ICsgICAgICAgdGVwX3ByaW50X2V2ZW50X2RhdGEocGV2ZW50
LCAmcywgZXZlbnQsIHJlY29yZCk7DQo+ICsNCj4gICAgICAgICBpZiAocy5sZW4gJiYgKihzLmJ1
ZmZlciArIHMubGVuIC0gMSkgPT0gJ1xuJykNCj4gICAgICAgICAgICAgICAgIHMubGVuLS07DQo+
ICAgICAgICAgaWYgKHRyYWNlY21kX2dldF9kZWJ1ZygpKSB7DQo+IC0tDQo+IDIuMjAuMQ0KPg0K
Pg0KDQpMb29rcyBnb29kIHRvIG1lLg0KUmV2aWV3ZWQtYnk6IFR6dmV0b21pciBTdG95YW5vdiAo
Vk13YXJlKSA8dHouc3RveWFub3ZAZ21haWwuY29tPg0KDQoNCi0tIA0KVHp2ZXRvbWlyIChDZWNv
KSBTdG95YW5vdg0KVk13YXJlIE9wZW4gU291cmNlIFRlY2hub2xvZ3kgQ2VudGVyDQo=
