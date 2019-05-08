Return-Path: <SRS0=Ta82=TI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E49D7C04A6B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 May 2019 08:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94CAB20989
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 May 2019 08:51:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="sp48wtOq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfEHIvt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 May 2019 04:51:49 -0400
Received: from mail-eopbgr810080.outbound.protection.outlook.com ([40.107.81.80]:64728
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726387AbfEHIvt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 May 2019 04:51:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ab0inIH1ZoTNiOZvpCxtIMD1b2ICYEP3MDr8voAID/c=;
 b=sp48wtOqsYaLLLW0L0MSo9wzdG5atbeAMud46wWlTaRz/dagUsrr+/wOJ5StyH4FpHp23+Vq4zhhbyVRMhW+VZFSHeXMrI8bBbYY4izsjLubIDb5ASD8NfQpFEqUjUd3cW9gmm60lR56+HtKNa9y0YBLCfcoN9j4VnJGbNBweok=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3758.namprd05.prod.outlook.com (10.167.140.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.19; Wed, 8 May 2019 08:51:44 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::adee:313f:d88c:575c]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::adee:313f:d88c:575c%7]) with mapi id 15.20.1900.002; Wed, 8 May 2019
 08:51:44 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Alan Mikhak <amikhak@wirelessfabric.com>
CC:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] Compile kernel-shark with -fPIC option
Thread-Topic: [PATCH] Compile kernel-shark with -fPIC option
Thread-Index: AQHU+4PnBoKJ6xlVG0uL8z8vRNlDtqZNEoIAgBNz04CAAHkfAA==
Date:   Wed, 8 May 2019 08:51:43 +0000
Message-ID: <4fbab4f1-ba3e-c3cc-3de2-43b0903d4c59@vmware.com>
References: <1556209669-2610-1-git-send-email-amikhak@wirelessfabric.com>
 <20190425123436.4973bfa4@gandalf.local.home>
 <20190507213805.46bf7402@oasis.local.home>
In-Reply-To: <20190507213805.46bf7402@oasis.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DB8PR09CA0022.eurprd09.prod.outlook.com
 (2603:10a6:10:a0::35) To SN4PR0501MB3903.namprd05.prod.outlook.com
 (2603:10b6:803:4d::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28424df9-843d-4d2a-b9ed-08d6d3926516
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:SN4PR0501MB3758;
x-ms-traffictypediagnostic: SN4PR0501MB3758:
x-microsoft-antispam-prvs: <SN4PR0501MB3758A8EC01B05C80DF45E8F8A0320@SN4PR0501MB3758.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0031A0FFAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(346002)(376002)(366004)(136003)(51914003)(199004)(189003)(256004)(186003)(2616005)(25786009)(486006)(4326008)(476003)(66476007)(11346002)(8676002)(66446008)(229853002)(73956011)(3846002)(6486002)(66946007)(446003)(66556008)(26005)(52116002)(64756008)(2906002)(316002)(6116002)(53936002)(76176011)(102836004)(6506007)(386003)(6246003)(5660300002)(71200400001)(71190400001)(68736007)(31686004)(14454004)(36756003)(478600001)(86362001)(31696002)(66066001)(7736002)(305945005)(6436002)(8936002)(81156014)(110136005)(99286004)(81166006)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3758;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KzSoGJEcfHrVr4mQNA1aE9qEYaOdZkVMzcyC3U6ZVjbAghbFn/ZkZdSH291PUn7kClPXBMneNv8WiQpQgansD8w1OAwP7aOsCLuuA7xOLCrfRj3p9G9NUdVUA5nwnwmMBgshSnAcZUxyzpJakDmBE25L2kzNcjAgnyRGbMds91LDtbOXn1Ldw70g9AkdiffihET0wZ6AAHGZuiEeBpmmEfAp7KpcJdUalGlMKphD6bhRJgS0nScvDw4wUEgHjJVFu5bF/2hba4PSTCtBTybX0DEQda+IVX4u59TGrPfOlHZVTVn7T7kH2cmh+Py2SZneYNT2Kx2hnZEUaYygkcOBoP8mvII3nadqHlVjQTnQ3Wg2b5yoyl+NSTLZWQP91B68371i2U87SNORkguUlv7rwI/GFJ+k/Ytv0boUDYXiHHE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F9FFE0D9446C5644A1B3CA30ECFEF60B@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28424df9-843d-4d2a-b9ed-08d6d3926516
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2019 08:51:43.8065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3758
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQoNCk9uIDguMDUuMTkg0LMuIDQ6Mzgg0YcuLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToNCj4gT24g
VGh1LCAyNSBBcHIgMjAxOSAxMjozNDozNiAtMDQwMA0KPiBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVk
dEBnb29kbWlzLm9yZz4gd3JvdGU6DQo+IA0KPj4gSGkgQWxhbiwNCj4+DQo+PiBUaGFua3MgZm9y
IHRoZSBwYXRjaC4gRllJLCBpdCdzIGJlc3QgdG8gYWxzbyBDYw0KPj4gbGludXgtdHJhY2UtZGV2
ZWxAdmdlci5rZXJuZWwub3JnIHdoZW4gc2VuZGluZyBwYXRjaGVzLg0KPj4NCj4+IE9uIFRodSwg
MjUgQXByIDIwMTkgMDk6Mjc6NDkgLTA3MDANCj4+IEFsYW4gTWlraGFrIDxhbWlraGFrQHdpcmVs
ZXNzZmFicmljLmNvbT4gd3JvdGU6DQo+Pg0KPj4+IEZyb206IEFsYW4gTWlraGFrIDxhbWlraGFr
QHdpcmVsZXNzZmFicmljLmNvbT4NCj4+Pg0KPj4+IFJlc29sdmUgbGlua2VyIHJlbG9jYXRpb24g
ZXJyb3Igd2hlbiBsaW5raW5nIGxpYmtzaGFyay5zby4wLjkuOA0KPj4+IHdpdGggY21ha2Ugb24g
YXJtdjdsLCBhYXJjaDY0LCBhbmQgc29tZSB4ODZfNjQgcGxhdGZvcm1zLg0KPj4+DQo+Pj4gVWJ1
bnR1IDE2LjA0ICh4ZW5pYWwpIG9uIHg4Nl82NDoNCj4+PiByZWxvY2F0aW9uIFJfWDg2XzY0XzMy
IGFnYWluc3QgYC5yb2RhdGEuc3RyMS4xJyBjYW4gbm90IGJlIHVzZWQgd2hlbg0KPj4+IG1ha2lu
ZyBhIHNoYXJlZCBvYmplY3Q7IHJlY29tcGlsZSB3aXRoIC1mUElDDQo+Pj4NCj4+PiBEZWJpYW4g
OS44IChzdHJldGNoKSBvbiB4ODZfNjQ6DQo+Pj4gcmVsb2NhdGlvbiBSX1g4Nl82NF9UUE9GRjMy
IGFnYWluc3QgYHNlcScgY2FuIG5vdCBiZSB1c2VkIHdoZW4gbWFraW5nDQo+Pj4gYSBzaGFyZWQg
b2JqZWN0OyByZWNvbXBpbGUgd2l0aCAtZlBJQw0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogQWxh
biBNaWtoYWsgPGFtaWtoYWtAd2lyZWxlc3NmYWJyaWMuY29tPg0KPj4+IC0tLQ0KPj4+ICAga2Vy
bmVsLXNoYXJrL0NNYWtlTGlzdHMudHh0IHwgNCArKy0tDQo+Pj4gICAxIGZpbGUgY2hhbmdlZCwg
MiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL2tl
cm5lbC1zaGFyay9DTWFrZUxpc3RzLnR4dCBiL2tlcm5lbC1zaGFyay9DTWFrZUxpc3RzLnR4dA0K
Pj4+IGluZGV4IDFhZWU4NTguLmFjMTc2NDIgMTAwNjQ0DQo+Pj4gLS0tIGEva2VybmVsLXNoYXJr
L0NNYWtlTGlzdHMudHh0DQo+Pj4gKysrIGIva2VybmVsLXNoYXJrL0NNYWtlTGlzdHMudHh0DQo+
Pj4gQEAgLTMyLDggKzMyLDggQEAgZW5kaWYgKFF0NVdpZGdldHNfRk9VTkQpDQo+Pj4gICBzZXQo
TElCUkFSWV9PVVRQVVRfUEFUSCAgICAiJHtLU19ESVJ9L2xpYiIpDQo+Pj4gICBzZXQoRVhFQ1VU
QUJMRV9PVVRQVVRfUEFUSCAiJHtLU19ESVJ9L2JpbiIpDQo+Pj4gICANCj4+PiAtc2V0KENNQUtF
X0NfRkxBR1MgICAiJHtDTUFLRV9DX0ZMQUdTfSAtV2FsbCAtZyAtcHRocmVhZCIpDQo+Pj4gLXNl
dChDTUFLRV9DWFhfRkxBR1MgIiR7Q01BS0VfQ1hYX0ZMQUdTfSAtV2FsbCAtZyAtc3RkPWMrKzEx
IC1wdGhyZWFkIikNCj4+PiArc2V0KENNQUtFX0NfRkxBR1MgICAiJHtDTUFLRV9DX0ZMQUdTfSAt
V2FsbCAtZyAtcHRocmVhZCAtZlBJQyIpDQo+Pj4gK3NldChDTUFLRV9DWFhfRkxBR1MgIiR7Q01B
S0VfQ1hYX0ZMQUdTfSAtV2FsbCAtZyAtc3RkPWMrKzExIC1wdGhyZWFkIC1mUElDIikNCj4+DQo+
PiBZb3JkYW4sDQo+Pg0KPj4gQ2FuIHlvdSB0YWtlIGEgbG9vayBhdCB0aGlzIHBhdGNoIGFuZCBh
ZGQgYSBSZXZpZXdlZC1ieSB0YWcgaWYgeW91IGFyZQ0KPj4gZ29vZCB3aXRoIGl0Pw0KPiANCj4g
VGhpcyBzbGlwcGVkIHRocm91Z2ggdGhlIGNyYWNrcy4gWW9yZGFuLCBhcmUgeW91IGdvb2Qgd2l0
aCB0aGlzPw0KPiANCg0KSSBhbSBzb3JyeSBmb3IgdGhlIHNsb3cgcmVhY3Rpb24hDQoNClJldmll
d2VkLWJ5OiBZb3JkYW4gS2FyYWR6aG92IDx5a2FyYWR6aG92QHZtd2FyZS5jb20+DQoNCg0KQ2hl
ZXJzLA0KWW9yZGFuDQoNCg0KPiAtLSBTdGV2ZQ0KPiANCj4+DQo+Pj4gICANCj4+PiAgIGlmKE5P
VCBfSU5TVEFMTF9QUkVGSVgpDQo+Pj4gICAJc2V0KF9JTlNUQUxMX1BSRUZJWCAiL3Vzci9sb2Nh
bCIpDQo+IA0K
