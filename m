Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A32FC31E46
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 14:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3450A2082C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 14:36:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="d8ilHagE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbfFLOgC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 10:36:02 -0400
Received: from mail-eopbgr780052.outbound.protection.outlook.com ([40.107.78.52]:10208
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726840AbfFLOgB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 10:36:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fEis2YzmEfkJA856rblQiN7ZLfUg7EOkE9cicp1kG0I=;
 b=d8ilHagETCp2P2aXq/jlHgw4RMqRQqSyezlu8jd3hDTjBKse/H2CZiFIdwi06l1okYBYXJzkzIStKsoCrOFShBNHDfQq//x6fBa4RiM8VkZN+TWHipDr9ylPUtKdaqSesvdN6yHEnvYGdJ5ZA68bEVZVvpGdGeE8UzaplzTarzk=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3839.namprd05.prod.outlook.com (10.167.150.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.9; Wed, 12 Jun 2019 14:34:52 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c%5]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 14:34:52 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "y.karadz@gmail.com" <y.karadz@gmail.com>
Subject: Re: [PATCH 1/2] kernel-shark: Fix a bug in
 ksmodel_set_next_bin_edge() part II
Thread-Topic: [PATCH 1/2] kernel-shark: Fix a bug in
 ksmodel_set_next_bin_edge() part II
Thread-Index: AQHVISo9FNyNOHKFB0u4NlsX4KPFIqaYE+OAgAABu4A=
Date:   Wed, 12 Jun 2019 14:34:52 +0000
Message-ID: <8451f71f-1078-9d64-5abf-3ed6f36403e1@vmware.com>
References: <20190612142053.14439-1-ykaradzhov@vmware.com>
 <20190612102831.15fca926@gandalf.local.home>
In-Reply-To: <20190612102831.15fca926@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR10CA0077.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::18) To SN4PR0501MB3903.namprd05.prod.outlook.com
 (2603:10b6:803:4d::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67f6a361-8d6f-4a75-0dd7-08d6ef432125
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN4PR0501MB3839;
x-ms-traffictypediagnostic: SN4PR0501MB3839:
x-microsoft-antispam-prvs: <SN4PR0501MB383926BEE89CF19EB696810DA0EC0@SN4PR0501MB3839.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(39860400002)(136003)(376002)(199004)(189003)(6506007)(36756003)(73956011)(54906003)(6916009)(66066001)(186003)(52116002)(102836004)(6436002)(386003)(26005)(6486002)(229853002)(316002)(66556008)(6246003)(71200400001)(99286004)(66476007)(76176011)(256004)(25786009)(71190400001)(64756008)(66446008)(66946007)(8676002)(31686004)(5660300002)(68736007)(81156014)(14444005)(6116002)(3846002)(4326008)(305945005)(14454004)(7736002)(478600001)(81166006)(486006)(446003)(476003)(31696002)(6512007)(2906002)(86362001)(2616005)(8936002)(11346002)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3839;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UlRT+cqDQsgOeamlFO+bq+2WF8hjBdqF5z902zS76gD4GseRyu6AFuBmA1BIBZvFcK9BSPJSpVtaf8IJSIhOJ239x8Wy4fQuFrF1uPstDDrhecugcSM/lA+4vCxGamnjPLBTsBUwfJSISNvv9tzktfy0K9Ot/uA/1nMn1X2e3TALHBCOYftkzCNkVU+r7cPydS6gcw0E2DP4ND37bY16k8u6Unvs02VfK20eiOzxF+ve8ciUy1cVF+jY1yfjrgb2kgyvV+xqAuYAOIeIge0PQbSVmy5mJUsquTpawBDurIQGBBPtT8U//6BfU7C4NbzjMuDYjDxRW97AhKE8PlYMerO0qhUArAdgSv7RR5RZp9vbHN+ZVwFRnucIPEhy4NFmUJgdZZOECHZd4REvc1uYbtMZaH/8KAFf+voWBur9Z9g=
Content-Type: text/plain; charset="utf-8"
Content-ID: <46955CC5B8AFA448A4074BFB8AE2E828@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67f6a361-8d6f-4a75-0dd7-08d6ef432125
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 14:34:52.0825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ykaradzhov@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3839
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

SGkgU3RldmVuLA0KDQpNeSBpZGVhIHdhcyB0byBtYWtlIGNsZWFyIHRoYXQgdGhvc2UgdHdvIHBh
dGNoZXMgYXJlIHN0cm9uZ2x5IGNvbm5lY3RlZCANCnRvIHRoZSBwYXRjaCBhbm90aGVyIHBhdGNo
IGNhbGxlZDoNCmtlcm5lbC1zaGFyazogRml4IGEgYnVnIGluIGtzbW9kZWxfc2V0X25leHRfYmlu
X2VkZ2UoKQ0KDQp3aGljaCB3YXMgc2VuZCBsb25nIHRpbWUgYWdvLg0KDQpTaG91bGQgSSByZXNl
bmQgd2l0aCBhbm90aGVyIHN1YmplY3Q/DQpUaGFua3MhDQpZb3JkYW4NCg0KDQpPbiAxMi4wNi4x
OSDQsy4gMTc6Mjgg0YcuLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToNCj4gDQo+IEhpIFlvcmRhbiwN
Cj4gDQo+IFBsZWFzZSB1c2UgYSBtb3JlIGRlc2NyaXB0aXZlIHN1YmplY3QuIFNlZWluZyBhICJw
YXJ0IElJIiBhbmQgYSAicGFydA0KPiBJSUkiIGluIGEgZ2l0IGxvZyAtLW9uZWxpbmUgaXNuJ3Qg
dmVyeSB1c2VmdWwuDQo+IA0KPiBTb21ldGhpbmcgbGlrZToNCj4gDQo+ICAga2VybmVsLXNoYXJr
OiBPbmx5IGluY3JlbWVudCB0aGUgdXBwZXIgZWRnZSBiaW4gd2l0aG91dCB0b3VjaGluZyBsb3dl
ciBlZGdlLg0KPiANCj4gT3Igc29tZXRoaW5nIHRoYXQgZGVzY3JpYmVzIHdoYXQgaXMgYmVpbmcg
ZG9uZSBpbiBhIGJpdCBtb3JlIGRldGFpbC4NCj4gDQo+IFRoYW5rcyENCj4gDQo+IC0tIFN0ZXZl
DQo+IA0KPiBPbiBXZWQsIDEyIEp1biAyMDE5IDE3OjIwOjUyICswMzAwDQo+IFlvcmRhbiBLYXJh
ZHpob3YgPHlrYXJhZHpob3ZAdm13YXJlLmNvbT4gd3JvdGU6DQo+IA0KPj4gT24gYSBmaXJzdCBn
bGFuY2UgdGhpcyBwYXRjaCBtYXkgbG9va3MgbGlrZSByZXZlcnRpbmcgY29tbWl0DQo+PiA5MzM2
ZGQ2YmNkMzggKGtlcm5lbC1zaGFyazogRml4IGEgYnVnIGluIGtzbW9kZWxfc2V0X25leHRfYmlu
X2VkZ2UoKSkNCj4+DQo+PiBUaGUgcG9pbnQgaXMgdGhhdCBmb3IgdGhlIGxhc3QgYmluIHdlIHdh
bnQgdG8gaW5jcmVtZW50IGl0cyB1cHBlciBlZGdlDQo+PiB1c2VkICB3aGVuIGNoZWNraW5nIGlm
IHRoZSBiaW4gaXMgZW1wdHksIGJ1dCB3ZSBkbyBub3Qgd2FudCB0byB0b3VjaA0KPj4gdGhlIGxv
d2VyIGVkZ2UgdGltZSB1c2VkIGJ5IGtzaGFya19maW5kX2VudHJ5X2J5X3RpbWUoKS4NCj4+DQo+
PiBTaWduZWQtb2ZmLWJ5OiBZb3JkYW4gS2FyYWR6aG92IDx5a2FyYWR6aG92QHZtd2FyZS5jb20+
DQo+PiAtLS0NCj4+ICAga2VybmVsLXNoYXJrL3NyYy9saWJrc2hhcmstbW9kZWwuYyB8IDIyICsr
KysrKysrKysrKysrKystLS0tLS0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDE2IGluc2VydGlvbnMo
KyksIDYgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2tlcm5lbC1zaGFyay9zcmMv
bGlia3NoYXJrLW1vZGVsLmMgYi9rZXJuZWwtc2hhcmsvc3JjL2xpYmtzaGFyay1tb2RlbC5jDQo+
PiBpbmRleCA5NzhjZDcwLi4wY2FjOTI0IDEwMDY0NA0KPj4gLS0tIGEva2VybmVsLXNoYXJrL3Ny
Yy9saWJrc2hhcmstbW9kZWwuYw0KPj4gKysrIGIva2VybmVsLXNoYXJrL3NyYy9saWJrc2hhcmst
bW9kZWwuYw0KPj4gQEAgLTI2MCwyMCArMjYwLDMwIEBAIHN0YXRpYyBzaXplX3Qga3Ntb2RlbF9z
ZXRfdXBwZXJfZWRnZShzdHJ1Y3Qga3NoYXJrX3RyYWNlX2hpc3RvICpoaXN0bykNCj4+ICAgc3Rh
dGljIHZvaWQga3Ntb2RlbF9zZXRfbmV4dF9iaW5fZWRnZShzdHJ1Y3Qga3NoYXJrX3RyYWNlX2hp
c3RvICpoaXN0bywNCj4+ICAgCQkJCSAgICAgIHNpemVfdCBiaW4sIHNpemVfdCBsYXN0X3JvdykN
Cj4+ICAgew0KPj4gLQlzaXplX3QgdGltZSwgbmV4dF9iaW4gPSBiaW4gKyAxOw0KPj4gKwlzaXpl
X3QgdGltZV9taW4sIHRpbWVfbWF4LCBuZXh0X2JpbiA9IGJpbiArIDE7DQo+PiAgIAlzc2l6ZV90
IHJvdzsNCj4+ICAgDQo+PiAtCS8qIENhbGN1bGF0ZSB0aGUgYmVnaW5uaW5nIG9mIHRoZSBuZXh0
IGJpbi4gKi8NCj4+IC0JdGltZSA9IGhpc3RvLT5taW4gKyBuZXh0X2JpbiAqIGhpc3RvLT5iaW5f
c2l6ZTsNCj4+ICsJLyogQ2FsY3VsYXRlIHRoZSBiZWdpbm5pbmcgYW5kIHRoZSBlbmQgb2YgdGhl
IG5leHQgYmluLiAqLw0KPj4gKwl0aW1lX21pbiA9IGhpc3RvLT5taW4gKyBuZXh0X2JpbiAqIGhp
c3RvLT5iaW5fc2l6ZTsNCj4+ICsJdGltZV9tYXggPSB0aW1lX21pbiArIGhpc3RvLT5iaW5fc2l6
ZTsNCj4+ICsJLyoNCj4+ICsJICogVGhlIHRpbWVzdGFtcCBvZiB0aGUgdmVyeSBsYXN0IGVudHJ5
IG9mIHRoZSBkYXRhc2V0IGNhbiBiZSBleGFjdGx5DQo+PiArCSAqIGVxdWFsIHRvIHRoZSB2YWx1
ZSBvZiB0aGUgdXBwZXIgZWRnZSBvZiB0aGUgcmFuZ2UuIFRoaXMgaXMgdmVyeQ0KPj4gKwkgKiBs
aWtlbHkgdG8gaGFwcGVuIHdoZW4gd2UgdXNlIGtzbW9kZWxfc2V0X2luX3JhbmdlX2JpbmluZygp
LiBJbiB0aGlzDQo+PiArCSAqIGNhc2Ugd2UgaGF2ZSB0byBpbmNyZWFzZSB0aGUgc2l6ZSBvZiB0
aGUgdmVyeSBsYXN0IGJpbiBpbiBvcmRlciB0bw0KPj4gKwkgKiBtYWtlIHN1cmUgdGhhdCB0aGUg
bGFzdCBlbnRyeSBvZiB0aGUgZGF0YXNldCB3aWxsIGZhbGwgaW50byBpdC4NCj4+ICsJICovDQo+
PiArCWlmIChuZXh0X2JpbiA9PSBoaXN0by0+bl9iaW5zIC0gMSkNCj4+ICsJCSsrdGltZV9tYXg7
DQo+PiAgIA0KPj4gICAJLyoNCj4+ICAgCSAqIEZpbmQgdGhlIGluZGV4IG9mIHRoZSBmaXJzdCBl
bnRyeSBpbnNpZGUNCj4+IC0JICogdGhlIG5leHQgYmluICh0aW1lc3RhbXAgPiB0aW1lKS4NCj4+
ICsJICogdGhlIG5leHQgYmluICh0aW1lc3RhbXAgPiB0aW1lX21pbikuDQo+PiAgIAkgKi8NCj4+
IC0Jcm93ID0ga3NoYXJrX2ZpbmRfZW50cnlfYnlfdGltZSh0aW1lLCBoaXN0by0+ZGF0YSwgbGFz
dF9yb3csDQo+PiArCXJvdyA9IGtzaGFya19maW5kX2VudHJ5X2J5X3RpbWUodGltZV9taW4sIGhp
c3RvLT5kYXRhLCBsYXN0X3JvdywNCj4+ICAgCQkJCQloaXN0by0+ZGF0YV9zaXplIC0gMSk7DQo+
PiAgIA0KPj4gLQlpZiAocm93IDwgMCB8fCBoaXN0by0+ZGF0YVtyb3ddLT50cyA+PSB0aW1lICsg
aGlzdG8tPmJpbl9zaXplKSB7DQo+PiArCWlmIChyb3cgPCAwIHx8IGhpc3RvLT5kYXRhW3Jvd10t
PnRzID49IHRpbWVfbWF4KSB7DQo+PiAgIAkJLyogVGhlIGJpbiBpcyBlbXB0eS4gKi8NCj4+ICAg
CQloaXN0by0+bWFwW25leHRfYmluXSA9IEtTX0VNUFRZX0JJTjsNCj4+ICAgCQlyZXR1cm47DQo+
IA0K
