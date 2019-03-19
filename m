Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7286C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 18:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84A092082F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 18:21:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="koFc5MDi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfCSSVf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 14:21:35 -0400
Received: from mail-eopbgr740084.outbound.protection.outlook.com ([40.107.74.84]:12608
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726707AbfCSSVf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 14:21:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6PqJA4/MZdlAg9ceZK+9VvxTnzLnfsX9zILKBGO2cPA=;
 b=koFc5MDiv98ewEKJF3cQWZrI8UA5x+L3zMcqHn3viuylaPTga73DxCyolijuD2s1WSt5G1KV+bOzuro01cKYDjXC2S+vAFJlLjcBydP+B93LTcalsY/6zn+ACypDwyGjAN5fAF/mu8gQQnzdIVOIWHZDcA4rWC1FyO3vFoVnMog=
Received: from BYAPR05MB5592.namprd05.prod.outlook.com (20.177.186.153) by
 BYAPR05MB5704.namprd05.prod.outlook.com (20.178.48.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.11; Tue, 19 Mar 2019 18:21:31 +0000
Received: from BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::c0d4:e960:b51:44cc]) by BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::c0d4:e960:b51:44cc%2]) with mapi id 15.20.1709.015; Tue, 19 Mar 2019
 18:21:31 +0000
From:   Matt Helsley <mhelsley@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
CC:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 5/9] trace-cmd: Refactored few functions in
 trace-record.c
Thread-Topic: [PATCH v7 5/9] trace-cmd: Refactored few functions in
 trace-record.c
Thread-Index: AQHU3mxSAs5ByYGJHk+4iKFyVKMtNqYTREuA
Date:   Tue, 19 Mar 2019 18:21:30 +0000
Message-ID: <0FEA60D5-2542-498E-A494-C15B0B2AE0A4@vmware.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
 <20190319155536.19381-6-tstoyanov@vmware.com>
In-Reply-To: <20190319155536.19381-6-tstoyanov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mhelsley@vmware.com; 
x-originating-ip: [73.25.163.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b70ae6e-61b2-41af-7fc3-08d6ac97b5e7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB5704;
x-ms-traffictypediagnostic: BYAPR05MB5704:
x-microsoft-antispam-prvs: <BYAPR05MB57047EF28C92F11CE3D9BF19A0400@BYAPR05MB5704.namprd05.prod.outlook.com>
x-forefront-prvs: 0981815F2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(366004)(346002)(396003)(376002)(189003)(199004)(478600001)(486006)(8676002)(476003)(5660300002)(305945005)(7736002)(81156014)(66066001)(36756003)(25786009)(82746002)(81166006)(97736004)(2616005)(6246003)(4326008)(14444005)(256004)(37006003)(6862004)(316002)(2906002)(54906003)(53936002)(14454004)(6436002)(68736007)(86362001)(76176011)(53546011)(11346002)(83716004)(3846002)(8936002)(33656002)(6486002)(446003)(71200400001)(186003)(26005)(102836004)(6506007)(6116002)(106356001)(99286004)(6636002)(229853002)(71190400001)(105586002)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5704;H:BYAPR05MB5592.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EWRE12IgradRhqhE4p4v8w6Ne2clRjPEpAeFfpPhdK9SS1dvl+z2M/i82m1fswomVDMRDdlbpL6d2IijF8i0k2kGjaR1whgdoHfT985wGaCnnY5BeVwaNkpl5E5r6f1MSKTjCRPOtxvGnFEKM+O+XLg2MY3yk3FYIATZeDMkvVohZvnumSWBykZBhIvtg+PcLxSomyumjIeJo9ObIE06SxG0LJXZHbpVGGYR98mnSJVrB64bx2NrCl3t9bfT5MUOhuVx0PI/1C3ypmKP87SMD6qKNzDws5wlaWuuzZD78ehP7MNO4RHtfxaKMsLTLCH1OpDoDMN1bUMR6+FEWia67RBbn8hYV6x3F7rpGKBtywITRsUQrhopelU/5U9Cw6aMLTMag/El6mNB192HxSItDnfOV7WqlWBGzGqafIarefU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D272D96CEF334B40A1A0E9D1A386D780@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b70ae6e-61b2-41af-7fc3-08d6ac97b5e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2019 18:21:30.9249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5704
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQoNCj4gT24gTWFyIDE5LCAyMDE5LCBhdCA4OjU1IEFNLCBUenZldG9taXIgU3RveWFub3YgPHRz
dG95YW5vdkB2bXdhcmUuY29tPiB3cm90ZToNCj4gDQo+IEluIG9yZGVyIHRvIHJldXNlIHRoZSBj
b2RlIGluc2lkZSB0aGUgdHJhY2UtY21kIGFwcGxpY2F0aW9uLCBmZXcNCj4gZnVuY3Rpb25zIGZy
b20gdHJhY2UtcmVjb3JkLmMgYXJlIHJlZmFjdG9yZWQ6DQo+ICAtIG1ha2VfaW5zdGFuY2VzKCkg
YW5kIHRyYWNlY21kX3JlbW92ZV9pbnN0YW5jZXMoKSBhcmUgc3BsaXRlZC4NCj4gTmV3IG9uZXMg
YXJlIGNyZWF0ZWQ6IHRyYWNlY21kX21ha2VfaW5zdGFuY2UoKSBhbmQgdHJhY2VjbWRfcmVtb3Zl
X2luc3RhbmNlKCksDQo+IHdoaWNoIGFyZSB2aXNpYmxlIG91dHNpZGUgdGhlIHRyYWNlLXJlY29y
ZC5jDQo+ICAtIEZvbGxvd2luZyBmdW5jdGlvbnMgYXJlIG1hZGUgbm9uLXN0YXRpYzogdHJhY2Vj
bWRfaW5pdF9pbnN0YW5jZSgpDQo+IGdldF9pbnN0YW5jZV9kaXIoKSwgd3JpdGVfaW5zdGFuY2Vf
ZmlsZSgpLCB3cml0ZV90cmFjaW5nX29uKCksDQo+IHRyYWNlY21kX3NldF9jbG9jaygpDQo+ICAt
IE5ldyBmdW5jdGlvbiBpcyBpbXBsZW1lbnRlZDogdHJhY2VjbWRfbG9jYWxfY3B1X2NvdW50KCks
IGFuIGludGVybmFsDQo+IEFQSSB0byBnZXQgbG9jYWxfY3B1X2NvdW50Lg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogVHp2ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJlLmNvbT4NCj4gLS0t
DQo+IHRyYWNlY21kL2luY2x1ZGUvdHJhY2UtbG9jYWwuaCB8ICA5ICsrKysNCj4gdHJhY2VjbWQv
dHJhY2UtcmVjb3JkLmMgICAgICAgIHwgODcgKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0t
LS0tLQ0KPiAyIGZpbGVzIGNoYW5nZWQsIDU4IGluc2VydGlvbnMoKyksIDM4IGRlbGV0aW9ucygt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL3RyYWNlY21kL2luY2x1ZGUvdHJhY2UtbG9jYWwuaCBiL3Ry
YWNlY21kL2luY2x1ZGUvdHJhY2UtbG9jYWwuaA0KPiBpbmRleCBkN2JkYjFmLi44NDEzMDU0IDEw
MDY0NA0KPiAtLS0gYS90cmFjZWNtZC9pbmNsdWRlL3RyYWNlLWxvY2FsLmgNCj4gKysrIGIvdHJh
Y2VjbWQvaW5jbHVkZS90cmFjZS1sb2NhbC5oDQo+IEBAIC0yMzUsNiArMjM1LDE1IEBAIHZvaWQg
dXBkYXRlX2ZpcnN0X2luc3RhbmNlKHN0cnVjdCBidWZmZXJfaW5zdGFuY2UgKmluc3RhbmNlLCBp
bnQgdG9wdCk7DQo+IHZvaWQgc2hvd19pbnN0YW5jZV9maWxlKHN0cnVjdCBidWZmZXJfaW5zdGFu
Y2UgKmluc3RhbmNlLCBjb25zdCBjaGFyICpuYW1lKTsNCj4gDQo+IGludCBjb3VudF9jcHVzKHZv
aWQpOw0KPiArdm9pZCB3cml0ZV90cmFjaW5nX29uKHN0cnVjdCBidWZmZXJfaW5zdGFuY2UgKmlu
c3RhbmNlLCBpbnQgb24pOw0KPiArY2hhciAqZ2V0X2luc3RhbmNlX2RpcihzdHJ1Y3QgYnVmZmVy
X2luc3RhbmNlICppbnN0YW5jZSk7DQo+ICtpbnQgd3JpdGVfaW5zdGFuY2VfZmlsZShzdHJ1Y3Qg
YnVmZmVyX2luc3RhbmNlICppbnN0YW5jZSwNCj4gKwkJCWNvbnN0IGNoYXIgKmZpbGUsIGNvbnN0
IGNoYXIgKnN0ciwgY29uc3QgY2hhciAqdHlwZSk7DQo+ICt2b2lkIHRyYWNlY21kX2luaXRfaW5z
dGFuY2Uoc3RydWN0IGJ1ZmZlcl9pbnN0YW5jZSAqaW5zdGFuY2UpOw0KPiArdm9pZCB0cmFjZWNt
ZF9tYWtlX2luc3RhbmNlKHN0cnVjdCBidWZmZXJfaW5zdGFuY2UgKmluc3RhbmNlKTsNCj4gK2lu
dCB0cmFjZWNtZF9sb2NhbF9jcHVfY291bnQodm9pZCk7DQo+ICt2b2lkIHRyYWNlY21kX3NldF9j
bG9jayhzdHJ1Y3QgYnVmZmVyX2luc3RhbmNlICppbnN0YW5jZSk7DQo+ICt2b2lkIHRyYWNlY21k
X3JlbW92ZV9pbnN0YW5jZShzdHJ1Y3QgYnVmZmVyX2luc3RhbmNlICppbnN0YW5jZSk7DQo+IA0K
PiAvKiBObyBsb25nZXIgaW4gZXZlbnQtdXRpbHMuaCAqLw0KPiB2b2lkIF9fbm9yZXR1cm4gZGll
KGNvbnN0IGNoYXIgKmZtdCwgLi4uKTsgLyogQ2FuIGJlIG92ZXJyaWRlbiAqLw0KPiBkaWZmIC0t
Z2l0IGEvdHJhY2VjbWQvdHJhY2UtcmVjb3JkLmMgYi90cmFjZWNtZC90cmFjZS1yZWNvcmQuYw0K
PiBpbmRleCAxNzcwNjBkLi4zOTUwMjQyIDEwMDY0NA0KPiAtLS0gYS90cmFjZWNtZC90cmFjZS1y
ZWNvcmQuYw0KPiArKysgYi90cmFjZWNtZC90cmFjZS1yZWNvcmQuYw0KPiANCg0KPHNuaXBwZWQ+
DQoNCj4gLXN0YXRpYyB2b2lkIHNldF9jbG9jayhzdHJ1Y3QgYnVmZmVyX2luc3RhbmNlICppbnN0
YW5jZSkNCj4gK3ZvaWQgdHJhY2VjbWRfc2V0X2Nsb2NrKHN0cnVjdCBidWZmZXJfaW5zdGFuY2Ug
Kmluc3RhbmNlKQ0KPiB7DQo+IAljaGFyICpwYXRoOw0KPiAJY2hhciAqY29udGVudDsNCj4gQEAg
LTQzMTYsNDkgKzQzMTQsNTcgQEAgc3RhdGljIHZvaWQgY2xlYXJfZnVuY19maWx0ZXJzKHZvaWQp
DQo+IAl9DQo+IH0NCj4gDQo+IC1zdGF0aWMgdm9pZCBtYWtlX2luc3RhbmNlcyh2b2lkKQ0KPiAr
dm9pZCB0cmFjZWNtZF9tYWtlX2luc3RhbmNlKHN0cnVjdCBidWZmZXJfaW5zdGFuY2UgKmluc3Rh
bmNlKQ0KPiB7DQo+IC0Jc3RydWN0IGJ1ZmZlcl9pbnN0YW5jZSAqaW5zdGFuY2U7DQo+IAlzdHJ1
Y3Qgc3RhdCBzdDsNCj4gCWNoYXIgKnBhdGg7DQo+IAlpbnQgcmV0Ow0KPiANCj4gKwlwYXRoID0g
Z2V0X2luc3RhbmNlX2RpcihpbnN0YW5jZSk7DQo+ICsJcmV0ID0gc3RhdChwYXRoLCAmc3QpOw0K
PiArCWlmIChyZXQgPCAwKSB7DQo+ICsJCXJldCA9IG1rZGlyKHBhdGgsIDA3NzcpOw0KDQpIZXJl
IGlzIHRoZSBta2RpciAuLi4NCg0KPiArCQlpZiAocmV0IDwgMCkNCj4gKwkJCWRpZSgibWtkaXIg
JXMiLCBwYXRoKTsNCj4gKwl9IGVsc2UNCj4gKwkJLyogRG9uJ3QgZGVsZXRlIGluc3RhbmNlcyB0
aGF0IGFscmVhZHkgZXhpc3QgKi8NCj4gKwkJaW5zdGFuY2UtPmZsYWdzIHw9IEJVRkZFUl9GTF9L
RUVQOw0KPiArCXRyYWNlY21kX3B1dF90cmFjaW5nX2ZpbGUocGF0aCk7DQo+ICsNCj4gK30NCj4g
Kw0KPiArc3RhdGljIHZvaWQgbWFrZV9pbnN0YW5jZXModm9pZCkNCj4gK3sNCj4gKwlzdHJ1Y3Qg
YnVmZmVyX2luc3RhbmNlICppbnN0YW5jZTsNCj4gKw0KPiAJZm9yX2VhY2hfaW5zdGFuY2UoaW5z
dGFuY2UpIHsNCj4gCQlpZiAoaXNfZ3Vlc3QoaW5zdGFuY2UpKQ0KPiAJCQljb250aW51ZTsNCj4g
KwkJdHJhY2VjbWRfbWFrZV9pbnN0YW5jZShpbnN0YW5jZSk7DQo+ICsJfQ0KPiArfQ0KPiANCj4g
LQkJcGF0aCA9IGdldF9pbnN0YW5jZV9kaXIoaW5zdGFuY2UpOw0KPiAtCQlyZXQgPSBzdGF0KHBh
dGgsICZzdCk7DQo+IC0JCWlmIChyZXQgPCAwKSB7DQo+IC0JCQlyZXQgPSBta2RpcihwYXRoLCAw
Nzc3KTsNCj4gLQkJCWlmIChyZXQgPCAwKQ0KPiAtCQkJCWRpZSgibWtkaXIgJXMiLCBwYXRoKTsN
Cj4gLQkJfSBlbHNlDQo+IC0JCQkvKiBEb24ndCBkZWxldGUgaW5zdGFuY2VzIHRoYXQgYWxyZWFk
eSBleGlzdCAqLw0KPiAtCQkJaW5zdGFuY2UtPmZsYWdzIHw9IEJVRkZFUl9GTF9LRUVQOw0KPiAt
CQl0cmFjZWNtZF9wdXRfdHJhY2luZ19maWxlKHBhdGgpOw0KPiArdm9pZCB0cmFjZWNtZF9yZW1v
dmVfaW5zdGFuY2Uoc3RydWN0IGJ1ZmZlcl9pbnN0YW5jZSAqaW5zdGFuY2UpDQo+ICt7DQo+ICsJ
Y2hhciAqcGF0aDsNCj4gKw0KPiArCWlmIChpbnN0YW5jZS0+dHJhY2luZ19vbl9mZCA+IDApIHsN
Cj4gKwkJY2xvc2UoaW5zdGFuY2UtPnRyYWNpbmdfb25fZmQpOw0KPiArCQlpbnN0YW5jZS0+dHJh
Y2luZ19vbl9mZCA9IDA7DQo+IAl9DQo+ICsJcGF0aCA9IGdldF9pbnN0YW5jZV9kaXIoaW5zdGFu
Y2UpOw0KPiArCXRyYWNlY21kX3B1dF90cmFjaW5nX2ZpbGUocGF0aCk7DQo+IH0NCj4gDQo+IHZv
aWQgdHJhY2VjbWRfcmVtb3ZlX2luc3RhbmNlcyh2b2lkKQ0KPiB7DQo+IAlzdHJ1Y3QgYnVmZmVy
X2luc3RhbmNlICppbnN0YW5jZTsNCj4gLQljaGFyICpwYXRoOw0KPiAtCWludCByZXQ7DQo+IA0K
PiAJZm9yX2VhY2hfaW5zdGFuY2UoaW5zdGFuY2UpIHsNCj4gCQkvKiBPbmx5IGRlbGV0ZSB3aGF0
IHdlIGNyZWF0ZWQgKi8NCj4gCQlpZiAoaXNfZ3Vlc3QoaW5zdGFuY2UpIHx8IChpbnN0YW5jZS0+
ZmxhZ3MgJiBCVUZGRVJfRkxfS0VFUCkpDQo+IAkJCWNvbnRpbnVlOw0KPiAtCQlpZiAoaW5zdGFu
Y2UtPnRyYWNpbmdfb25fZmQgPiAwKSB7DQo+IC0JCQljbG9zZShpbnN0YW5jZS0+dHJhY2luZ19v
bl9mZCk7DQo+IC0JCQlpbnN0YW5jZS0+dHJhY2luZ19vbl9mZCA9IDA7DQo+IC0JCX0NCj4gLQkJ
cGF0aCA9IGdldF9pbnN0YW5jZV9kaXIoaW5zdGFuY2UpOw0KPiAtCQlyZXQgPSBybWRpcihwYXRo
KTsNCg0KQnV0IHRoaXMgcm1kaXIgaXMgbm90IG1vdmVkIHRvIHRyYWNlY21kX3JlbW92ZV9pbnN0
YW5jZSgpIOKAlCBpdOKAmXMgbG9zdC4gVGhpcyBsb29rcyBsaWtlIGl04oCZcyBpbnRyb2R1Y2lu
ZyBhIGJ1Zy4NCg0KPiAtCQlpZiAocmV0IDwgMCkNCj4gLQkJCWRpZSgicm1kaXIgJXMiLCBwYXRo
KTsNCj4gLQkJdHJhY2VjbWRfcHV0X3RyYWNpbmdfZmlsZShwYXRoKTsNCj4gKwkJdHJhY2VjbWRf
cmVtb3ZlX2luc3RhbmNlKGluc3RhbmNlKTsNCj4gCX0NCj4gfQ0KDQo8c25pcHBlZD4NCg0KVGhl
IHJlc3QgbG9va3MgZmluZS4NCg0KQ2hlZXJzLA0KICAgICAgLU1hdHQgSGVsc2xleQ0KDQo=
