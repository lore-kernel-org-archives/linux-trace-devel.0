Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF89C3A5A2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 250002086A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:10:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="Mf745D1E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389665AbfITPKQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 11:10:16 -0400
Received: from mail-eopbgr750087.outbound.protection.outlook.com ([40.107.75.87]:18695
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387614AbfITPKP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 11:10:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9qlXMtYY0bnjcXZkMF3nadMbtIa02DcQ/jPzzrb5IUfB5kWaB7iIcZSxDk0eYEunQbsHTWXwiO++/qC+zImJlFRjeaYM/lvGvXAr0amu6r7s5GOoXBFB6td4aYFycPPF/n1BM3C0uv0pHB38kElIy4uA5WI0WVXTxHK9sZgz8/tFUg+7Znv5VmcPq1bn90jw833TaDLk4gThcVR7KslGVIxRIeX8cIZo/aXqm1b5DMHePu65i5U2GSbTMdwosZ3WoVj2fiLYIhKSpEi/B22lIULJAjkU1b2N2mjCmTZqpf3ektPkdDV/2+WT7A/WfCpHaCBZnVDIG7JN0dUjBfKdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7e5+q/+PiLeMufKKs2fI9zd8dd+MJha8kXbuVIcoN3o=;
 b=ZDd5hoXXRW2VdpmzttH6IfHiXbFDh3+h2AKaVPmXnTeOASJbAauCoYzDPM23cG9lYvgpLfhUkXzGDcr0bCkwaFvLsQHy7eMYRenpNdVa1Do3Kn9jQJRepemROwqr6NC8EthuW9Q+HbEKgdNL6x5gXv52YfzeNzMuV6mQZolre+FYSNTqx8mCKXGB4J7vC4ywC+F193hx2XfoY9B3RnN/AfHTk81s5oryQb35DR2cU1pMU8FdBAlVzZIYelOoCeIAow18+kMx60uv73uviTIwjRyieF6SI1Uy3DphvPrv7aeVrYENHXzH7Ifi3vAxs8kq3/IWxcVB7sU3sSadkQg6iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7e5+q/+PiLeMufKKs2fI9zd8dd+MJha8kXbuVIcoN3o=;
 b=Mf745D1EjAEjw20PTUgzugKM8dMAeUneSzJqmsigYuJ59wMHgKYCZwFNo4GfJt0UPwhe+1+MD1cph7vgyiKl4n/fdB0WWsfgxVO6JHxE0z4IEd4g/Y3J8NlYjwtxlsmtG+tmJzE9RvY+seZ/eueM62/AY37EmmA6ifQqHpApa5g=
Received: from SN6PR05MB4045.namprd05.prod.outlook.com (52.135.66.139) by
 SN6PR05MB5600.namprd05.prod.outlook.com (52.135.111.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.10; Fri, 20 Sep 2019 15:10:00 +0000
Received: from SN6PR05MB4045.namprd05.prod.outlook.com
 ([fe80::5dd0:4ccb:3dbf:91f9]) by SN6PR05MB4045.namprd05.prod.outlook.com
 ([fe80::5dd0:4ccb:3dbf:91f9%7]) with mapi id 15.20.2284.009; Fri, 20 Sep 2019
 15:10:00 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 3/5] trace-cmd: Add check for trace_clock using usecs into
 tracecmd_parse_trace_clock()
Thread-Topic: [PATCH 3/5] trace-cmd: Add check for trace_clock using usecs
 into tracecmd_parse_trace_clock()
Thread-Index: AQHVbcWOE8KGstepDEWYpTWq8kW+R6c0r1MA
Date:   Fri, 20 Sep 2019 15:10:00 +0000
Message-ID: <CACqStodY5sf=NACzqOFQQu-kDxTkXsUv5Uz3nTeTkzz9bOgORw@mail.gmail.com>
References: <20190918020334.344561631@goodmis.org>
 <20190918020530.655810800@goodmis.org>
In-Reply-To: <20190918020530.655810800@goodmis.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR05CA0153.eurprd05.prod.outlook.com
 (2603:10a6:207:3::31) To SN6PR05MB4045.namprd05.prod.outlook.com
 (2603:10b6:805:26::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAWVDW128KgbchzGUA0TH01AzIAVp9gYpVudrAjFA2O7TqO2GStE
        4a3voQjBEQLkZQpTjcVq+ZTuMsriwGWytcI67gw=
x-google-smtp-source: APXvYqwbcP1MAwcP6Xxt5K/QxAXZ/NQ+EC9qlSpHwKFO+NL4XU3uOY4nj4TUOLgVOD2+37ixr3/VW7mvnumPvKKkudc=
x-received: by 2002:a1c:4384:: with SMTP id
 q126mr4250883wma.153.1568992195890; Fri, 20 Sep 2019 08:09:55 -0700 (PDT)
x-gmail-original-message-id: <CACqStodY5sf=NACzqOFQQu-kDxTkXsUv5Uz3nTeTkzz9bOgORw@mail.gmail.com>
x-originating-ip: [209.85.128.47]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b63a86e-8507-4795-1125-08d73ddc9b11
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN6PR05MB5600;
x-ms-traffictypediagnostic: SN6PR05MB5600:
x-microsoft-antispam-prvs: <SN6PR05MB56009911667EEFF82575974CDC880@SN6PR05MB5600.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0166B75B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(189003)(199004)(86362001)(6862004)(316002)(4326008)(71190400001)(498394004)(71200400001)(186003)(229853002)(3846002)(6436002)(478600001)(25786009)(6116002)(11346002)(446003)(6486002)(14454004)(66066001)(26005)(102836004)(6506007)(486006)(386003)(53546011)(476003)(81156014)(66476007)(5660300002)(256004)(8676002)(99286004)(2906002)(66946007)(95326003)(61266001)(6512007)(9686003)(6246003)(66556008)(64756008)(66446008)(52116002)(81166006)(305945005)(55446002)(7736002)(76176011)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB5600;H:SN6PR05MB4045.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UoqHOKPis04GD5Ssa5mqqHeOw9TOTLpjA8BRsa10lRkiFACRwPZNrCt2V6nMEfLwIMPp1OSa/pkbEGXmieLKlfgtBejuPT2okG4LAZOZTBERKM1RuePaT42J8wIa3h0dqYB4SMq+lPCcz9d6ihG3W59RvJ7o42v+OLJVarq9Xto6aqawZ1Bpe1662Q+VqDLn/Jh04nznQFwi5v5xwyVlMaN6ShnucY2acANehf8OG2l4AgFbaTF70XzlDm0+9OD+gIeUExrBTlA6SP3p0FGT/3bv8EvmJ+SpLEv5h0NjgUGI2vlgEgIuabp5LLtkpM+Tv1IE4qVFW24DWoos1F8v5hbrQgz7XfxP7nKXSDVEjsaCOWVgQbRKExd5sQvd1/vInHLnQIbaJbda+4AmxlkHta7GLDP4NBW31kMfz32sB9M=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B5FEA679F3B494ABC2544FFA93C8069@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b63a86e-8507-4795-1125-08d73ddc9b11
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2019 15:10:00.2149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TSr4hpbcgZvdZGteOQDk03w/bjHyhwl/+Pmgu8Fzk+NaQeGwX9KBaA1xTokNkLzZPaIbJON38ewnLLVSDCrukw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB5600
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCBTZXAgMTgsIDIwMTkgYXQgNTowMyBBTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IEZyb206ICJTdGV2ZW4gUm9zdGVkdCAoVk13YXJlKSIg
PHJvc3RlZHRAZ29vZG1pcy5vcmc+DQo+DQo+IEluIHByZXBhcmF0aW9uIGZvciB1c2luZyB0aGUg
bmV3IHRlcF9wcmludF9ldmVudCgpIGZvcm1hdCwgbW92ZSB0aGUgbG9naWMgb2YNCj4gY2hlY2tp
bmcgaWYgdGhlIHRyYWNlX2Nsb2NrIHVzZWQgc2hvdWxkIGJlIGRlZmF1bHQgYXMgcHJpbnRlZCBp
biB1c2VjcyBpbnRvDQo+IHRyYWNlY21kX3BhcnNlX3RyYWNlX2Nsb2NrKCkgd2hlbiBpdCBwYXJz
ZXMgdGhlIHRyYWNlX2Nsb2NrLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBTdGV2ZW4gUm9zdGVkdCAo
Vk13YXJlKSA8cm9zdGVkdEBnb29kbWlzLm9yZz4NCj4gLS0tDQo+ICBpbmNsdWRlL3RyYWNlLWNt
ZC90cmFjZS1jbWQuaCB8IDEgKw0KPiAgbGliL3RyYWNlLWNtZC90cmFjZS1pbnB1dC5jICAgfCA4
ICsrKysrKysrDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKQ0KPg0KPiBkaWZm
IC0tZ2l0IGEvaW5jbHVkZS90cmFjZS1jbWQvdHJhY2UtY21kLmggYi9pbmNsdWRlL3RyYWNlLWNt
ZC90cmFjZS1jbWQuaA0KPiBpbmRleCBlYjM2YTFmMjBjMzAuLjdjM2JjMjIyOTQ2MSAxMDA2NDQN
Cj4gLS0tIGEvaW5jbHVkZS90cmFjZS1jbWQvdHJhY2UtY21kLmgNCj4gKysrIGIvaW5jbHVkZS90
cmFjZS1jbWQvdHJhY2UtY21kLmgNCj4gQEAgLTg3LDYgKzg3LDcgQEAgZW51bSB7DQo+ICAgICAg
ICAgVFJBQ0VDTURfRkxfSUdOT1JFX0RBVEUgICAgICAgICA9ICgxIDw8IDApLA0KPiAgICAgICAg
IFRSQUNFQ01EX0ZMX0JVRkZFUl9JTlNUQU5DRSAgICAgPSAoMSA8PCAxKSwNCj4gICAgICAgICBU
UkFDRUNNRF9GTF9MQVRFTkNZICAgICAgICAgICAgID0gKDEgPDwgMiksDQo+ICsgICAgICAgVFJB
Q0VDTURfRkxfSU5fVVNFQ1MgICAgICAgICAgICA9ICgxIDw8IDMpLA0KPiAgfTsNCj4NCj4gIHN0
cnVjdCB0cmFjZWNtZF9mdHJhY2Ugew0KPiBkaWZmIC0tZ2l0IGEvbGliL3RyYWNlLWNtZC90cmFj
ZS1pbnB1dC5jIGIvbGliL3RyYWNlLWNtZC90cmFjZS1pbnB1dC5jDQo+IGluZGV4IDU1MzNkNDJm
ZDdjMi4uNzNmMjdhNGU1MGQwIDEwMDY0NA0KPiAtLS0gYS9saWIvdHJhY2UtY21kL3RyYWNlLWlu
cHV0LmMNCj4gKysrIGIvbGliL3RyYWNlLWNtZC90cmFjZS1pbnB1dC5jDQo+IEBAIC0yNTgyLDYg
KzI1ODIsMTQgQEAgc3RhdGljIHZvaWQgZXh0cmFjdF90cmFjZV9jbG9jayhzdHJ1Y3QgdHJhY2Vj
bWRfaW5wdXQgKmhhbmRsZSwgY2hhciAqbGluZSkNCj4gICAgICAgICBzc2NhbmYoZGF0YSwgIiVt
cyIsICZjbG9jayk7DQo+ICAgICAgICAgLyogVE9ETzogcmVwb3J0IGlmIGl0IGZhaWxzIHRvIGFs
bG9jYXRlICovDQo+ICAgICAgICAgaGFuZGxlLT50cmFjZV9jbG9jayA9IGNsb2NrOw0KPiArDQo+
ICsgICAgICAgaWYgKCFjbG9jaykNCj4gKyAgICAgICAgICAgICAgIHJldHVybjsNCj4gKw0KPiAr
ICAgICAgIGlmICghc3RyY21wKGNsb2NrLCAibG9jYWwiKSB8fCAhc3RyY21wKGNsb2NrLCAiZ2xv
YmFsIikNCj4gKyAgICAgICAgICAgfHwgIXN0cmNtcChjbG9jaywgInVwdGltZSIpIHx8ICFzdHJj
bXAoY2xvY2ssICJwZXJmIikNCj4gKyAgICAgICAgICAgfHwgIXN0cm5jbXAoY2xvY2ssICJtb25v
IiwgNCkpDQo+ICsgICAgICAgICAgICAgICBoYW5kbGUtPmZsYWdzIHw9IFRSQUNFQ01EX0ZMX0lO
X1VTRUNTOw0KPiAgfQ0KPg0KPiAgdm9pZCB0cmFjZWNtZF9wYXJzZV90cmFjZV9jbG9jayhzdHJ1
Y3QgdHJhY2VjbWRfaW5wdXQgKmhhbmRsZSwNCj4gLS0NCj4gMi4yMC4xDQo+DQo+DQoNCkxvb2tz
IE9LLg0KUmV2aWV3ZWQtYnk6IFR6dmV0b21pciBTdG95YW5vdiAoVk13YXJlKSA8dHouc3RveWFu
b3ZAZ21haWwuY29tPg0KDQotLSANClR6dmV0b21pciAoQ2VjbykgU3RveWFub3YNClZNd2FyZSBP
cGVuIFNvdXJjZSBUZWNobm9sb2d5IENlbnRlcg0K
