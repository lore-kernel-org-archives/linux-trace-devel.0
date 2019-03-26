Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42DDCC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 17:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A0E72063F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 17:34:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="en1fCjCE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731920AbfCZReH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 13:34:07 -0400
Received: from mail-eopbgr800074.outbound.protection.outlook.com ([40.107.80.74]:11136
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730441AbfCZReH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 13:34:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1ieLvvxcGJEGzESnQarLHuO2fNq9MrkDibGDic6w+0=;
 b=en1fCjCEQqYaGsfqdNgo+U58lQq/RtyYXpuAWVHklb/TdOiU4u+RNnu/9sJZE4Z6Ov6s+z9VUHgcXlT7p+8VhqQgxXMqnqUPtJDAZeIkUk2H+GXPudcjzABy27OA8CjXmsPP0zrttUhP52uvYyHk96SMk/ocpEVE7CWaMdD20h0=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3722.namprd05.prod.outlook.com (10.167.163.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.14; Tue, 26 Mar 2019 17:34:01 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41%5]) with mapi id 15.20.1750.010; Tue, 26 Mar 2019
 17:34:00 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v10 6/9] trace-cmd: Find and store pids of tasks, which
 run virtual CPUs of given VM
Thread-Topic: [PATCH v10 6/9] trace-cmd: Find and store pids of tasks, which
 run virtual CPUs of given VM
Thread-Index: AQHU4/oMQLmq0cOLp0qgdH/usIi5kQ==
Date:   Tue, 26 Mar 2019 17:33:56 +0000
Message-ID: <CAE0o1Ntcki4BKmhkF7xUSxwLRHr+FpZbP45gLmCAbh=s-5yp-Q@mail.gmail.com>
References: <20190326150651.25811-1-tstoyanov@vmware.com>
 <20190326150651.25811-7-tstoyanov@vmware.com>
In-Reply-To: <20190326150651.25811-7-tstoyanov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YQXPR0101CA0007.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:15::20) To MWHPR0501MB3772.namprd05.prod.outlook.com
 (2603:10b6:301:7a::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAVr34+mEHkRHoUb5JcIKSEos6mAN6NqVmVZLAF/5ZfgDMyscUbR
        avD17lAz8eH52nuXTV2O4EFtUwtmusMDFerwng==
x-google-smtp-source: APXvYqxkNXWLA/qOfnuRNw21O7y/uhXyEsJ2MFHSCK5JoshXzfhWLbb6ie5EvTg28JXK0WK8IQiHKuXiXwlYLyECTFc=
x-received: by 2002:a24:6a8b:: with SMTP id l133mr79334itc.92.1553621632213;
 Tue, 26 Mar 2019 10:33:52 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1Ntcki4BKmhkF7xUSxwLRHr+FpZbP45gLmCAbh=s-5yp-Q@mail.gmail.com>
x-originating-ip: [209.85.166.180]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f00cbdac-5c93-4c05-fb3c-08d6b2113919
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600127)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:MWHPR0501MB3722;
x-ms-traffictypediagnostic: MWHPR0501MB3722:
x-microsoft-antispam-prvs: <MWHPR0501MB3722FE4040B549FCCC67642ADA5F0@MWHPR0501MB3722.namprd05.prod.outlook.com>
x-forefront-prvs: 09888BC01D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(396003)(39860400002)(376002)(199004)(189003)(71200400001)(61726006)(9686003)(6512007)(71190400001)(3846002)(105586002)(229853002)(5660300002)(76176011)(98316002)(6486002)(6116002)(52116002)(305945005)(256004)(14444005)(7736002)(25786009)(6436002)(498394004)(106356001)(6862004)(6666004)(6246003)(53936002)(4326008)(95326003)(99286004)(6636002)(14454004)(97736004)(86362001)(478600001)(2906002)(54906003)(55446002)(186003)(8676002)(11346002)(446003)(8936002)(81156014)(81166006)(53546011)(386003)(6506007)(26005)(66066001)(486006)(68736007)(476003)(61266001)(102836004)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3722;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qPeCZ0jxfVSTqqJ9nKw5/b1gVGI8POrsKanScZmqYed0+VeyD9qjw5AzaFIwnAeQerxyEkBXtP/uXZVYbdtUcJtIKVxQW8cQCDEaZa/N5i1cVu8+GWTGYMOB/P8NCCpb70o/CvdwclIIN8dO/kRMKwh26x+wDuF0UwW3siVaeFb8BHMbeY2wRn35jEgFPHZYomvFJRfVE6CAJAUm8Y/WT+SFfKnOlI9dtnStI5NI0VNZZ2sD3GGbbRquREBaxcPQ/zl0VujYUc7gpT3rCZcyZ5HdOS55atvc7b2YZULRmTCq1OoS0cIJjtLjcySD9TFD3AogiIMccrangsLaGNGBG1SjlNb+1qsYhYEXJgNG5TKL/AEVAw9AMQBVB0TAXfYy0cjJZ0JF99Z2p3sk1c+LW46/1OtphGXoL6iItpkiRNY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFED3C6C7997F44586EBD0E685117DE1@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f00cbdac-5c93-4c05-fb3c-08d6b2113919
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2019 17:33:56.7730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3722
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCBNYXIgMjYsIDIwMTkgYXQgNTowNyBQTSBUenZldG9taXIgU3RveWFub3YgPHRzdG95
YW5vdkB2bXdhcmUuY29tPiB3cm90ZToNCj4NCj4gSW4gb3JkZXIgdG8gbWF0Y2ggaG9zdCBhbmQg
Z3Vlc3QgZXZlbnRzLCBhIG1hcHBpbmcgYmV0d2VlbiBndWVzdCBWQ1BVDQo+IGFuZCB0aGUgaG9z
dCB0YXNrLCBydW5uaW5nIHRoaXMgVkNQVSBpcyBuZWVkZWQuIEV4dGVuZGVkIGV4aXN0aW5nDQo+
IHN0cnVjdCBndWVzdCB0byBob2xkIHN1Y2ggbWFwcGluZyBhbmQgYWRkZWQgbG9naWMgaW4gcmVh
ZF9xZW11X2d1ZXN0cygpDQo+IGZ1bmN0aW9uIHRvIGluaXRpYWxpemUgaXQuIEltcGxlbWVudGVk
IGEgbmV3IGludGVybmFsIEFQSSwNCj4gZ2V0X2d1ZXN0X3ZjcHVfcGlkKCksIHRvIHJldHJpZXZl
IFZDUFUtdGFzayBtYXBwaW5nIGZvciBnaXZlbiBWTS4NCj4NCj4gU2lnbmVkLW9mZi1ieTogVHp2
ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJlLmNvbT4NCj4gLS0tDQo+ICB0cmFjZWNt
ZC9pbmNsdWRlL3RyYWNlLWxvY2FsLmggfCAgMSArDQo+ICB0cmFjZWNtZC90cmFjZS1yZWNvcmQu
YyAgICAgICAgfCA1NyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICAyIGZp
bGVzIGNoYW5nZWQsIDU4IGluc2VydGlvbnMoKykNCj4NCj4gZGlmZiAtLWdpdCBhL3RyYWNlY21k
L2luY2x1ZGUvdHJhY2UtbG9jYWwuaCBiL3RyYWNlY21kL2luY2x1ZGUvdHJhY2UtbG9jYWwuaA0K
PiBpbmRleCA4NDEzMDU0Li42MmY1ZTQ3IDEwMDY0NA0KPiAtLS0gYS90cmFjZWNtZC9pbmNsdWRl
L3RyYWNlLWxvY2FsLmgNCj4gKysrIGIvdHJhY2VjbWQvaW5jbHVkZS90cmFjZS1sb2NhbC5oDQo+
IEBAIC0yNDUsNiArMjQ1LDcgQEAgaW50IHRyYWNlY21kX2xvY2FsX2NwdV9jb3VudCh2b2lkKTsN
Cj4gIHZvaWQgdHJhY2VjbWRfc2V0X2Nsb2NrKHN0cnVjdCBidWZmZXJfaW5zdGFuY2UgKmluc3Rh
bmNlKTsNCj4gIHZvaWQgdHJhY2VjbWRfcmVtb3ZlX2luc3RhbmNlKHN0cnVjdCBidWZmZXJfaW5z
dGFuY2UgKmluc3RhbmNlKTsNCj4NCj4gK2ludCBnZXRfZ3Vlc3RfdmNwdV9waWQodW5zaWduZWQg
aW50IGd1ZXN0X2NpZCwgdW5zaWduZWQgaW50IGd1ZXN0X3ZjcHUpOw0KPiAgLyogTm8gbG9uZ2Vy
IGluIGV2ZW50LXV0aWxzLmggKi8NCj4gIHZvaWQgX19ub3JldHVybiBkaWUoY29uc3QgY2hhciAq
Zm10LCAuLi4pOyAvKiBDYW4gYmUgb3ZlcnJpZGVuICovDQo+ICB2b2lkICptYWxsb2Nfb3JfZGll
KHVuc2lnbmVkIGludCBzaXplKTsgLyogQ2FuIGJlIG92ZXJyaWRkZW4gKi8NCj4gZGlmZiAtLWdp
dCBhL3RyYWNlY21kL3RyYWNlLXJlY29yZC5jIGIvdHJhY2VjbWQvdHJhY2UtcmVjb3JkLmMNCj4g
aW5kZXggZWFjZjdkMi4uNzJhOGVkMyAxMDA2NDQNCj4gLS0tIGEvdHJhY2VjbWQvdHJhY2UtcmVj
b3JkLmMNCj4gKysrIGIvdHJhY2VjbWQvdHJhY2UtcmVjb3JkLmMNCj4gQEAgLTI3NDYsMTAgKzI3
NDYsMTIgQEAgc3RhdGljIGJvb2wgaXNfZGlnaXRzKGNvbnN0IGNoYXIgKnMpDQo+ICAgICAgICAg
cmV0dXJuIHRydWU7DQo+ICB9DQo+DQo+ICsjZGVmaW5lIFZDUFVTX01BWCAyNTYNCj4gIHN0cnVj
dCBndWVzdCB7DQo+ICAgICAgICAgY2hhciAqbmFtZTsNCj4gICAgICAgICBpbnQgY2lkOw0KPiAg
ICAgICAgIGludCBwaWQ7DQo+ICsgICAgICAgaW50IGNwdV9waWRbVkNQVVNfTUFYXTsNCj4gIH07
DQo+DQo+ICBzdGF0aWMgc3RydWN0IGd1ZXN0ICpndWVzdHM7DQo+IEBAIC0yNzY3LDYgKzI3Njks
NDYgQEAgc3RhdGljIGNoYXIgKmdldF9xZW11X2d1ZXN0X25hbWUoY2hhciAqYXJnKQ0KPiAgICAg
ICAgIHJldHVybiBhcmc7DQo+ICB9DQo+DQo+ICtzdGF0aWMgdm9pZCByZWFkX3FlbXVfZ3Vlc3Rz
X3BpZHMoY2hhciAqZ3Vlc3RfdGFzaywgc3RydWN0IGd1ZXN0ICpndWVzdCkNCj4gK3sNCj4gKyAg
ICAgICBzdHJ1Y3QgZGlyZW50ICplbnRyeV90Ow0KPiArICAgICAgIGNoYXIgcGF0aFtQQVRIX01B
WF07DQo+ICsgICAgICAgY2hhciAqYnVmID0gTlVMTDsNCj4gKyAgICAgICBzaXplX3QgbiA9IDA7
DQo+ICsgICAgICAgaW50IHZjcHU7DQo+ICsgICAgICAgRElSICpkaXI7DQo+ICsgICAgICAgRklM
RSAqZnQ7DQoNCk5pdDogSSB0aGluayB0aGUgZW50cnlfdC9mdCBhcmUgbGVmdCBvdmVycyBmcm9t
IGJlZm9yZSB3aGVuIHRoaXMNCmZ1bmN0aW9uIHdhcyBpbmxpbmVkIGluIHJlYWRfcWVtdV9ndWVz
dHMoKS4gQ2FuIHlvdSBjaGFuZ2UgdGhlbSB0bw0KZW50cnkvZiBub3cgdGhhdCB0aGVyZSdzIG5v
IG5hbWUgY29sbGlzaW9uPw0KDQpDaGVlcnMsDQoNCi0tIFNsYXZpDQo=
