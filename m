Return-Path: <SRS0=gVBF=RY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EBD2C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 10:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34F89218B0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 10:03:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="b6pEovNG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbfCUKD0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 06:03:26 -0400
Received: from mail-eopbgr730077.outbound.protection.outlook.com ([40.107.73.77]:5359
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728214AbfCUKD0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 06:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0A4uGcJiAp39jpEzDpA/XNe/qQ53Hi4pPyWQ4JXk5M=;
 b=b6pEovNGWK91R2PvCXHnvyMwv3RR7MQv/Kl2F3muXpWMSbDi+1mUhspqPvA4U7GhPeTkNMHPI1JlKQFd2ic2/CVppX4IUooGOFcBFvs5mNvvt6/CD6lWywk0p+DhN5FAuPSQWazwrFxWPoGg0d//grbJpkl9OEZmId6P24WlGl8=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2428.namprd05.prod.outlook.com (10.167.10.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.9; Thu, 21 Mar 2019 10:03:23 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec%4]) with mapi id 15.20.1730.013; Thu, 21 Mar 2019
 10:03:23 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Matt Helsley <mhelsley@vmware.com>
CC:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tools/lib/traceevent: Implement new traceevent APIs
 for accessing struct tep_handler fields
Thread-Topic: [PATCH 3/3] tools/lib/traceevent: Implement new traceevent APIs
 for accessing struct tep_handler fields
Thread-Index: AQHU3kWjl+JA/enZRUKSXDyrcXeTPaYUuHSAgAEljwA=
Date:   Thu, 21 Mar 2019 10:03:23 +0000
Message-ID: <CACqStofWc3178z+2bk_LTSfcZ=Q2y8PDtWmr9yeDxOuBus=CBw@mail.gmail.com>
References: <20190319111924.17443-1-tstoyanov@vmware.com>
 <20190319111924.17443-4-tstoyanov@vmware.com>
 <854FD5EF-691D-4BF2-8A1D-FBF6863B5C19@vmware.com>
In-Reply-To: <854FD5EF-691D-4BF2-8A1D-FBF6863B5C19@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P195CA0086.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:86::27) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAWOJKSLtGWOOuzdL4LNTK6XqJ39ksshFaT/sOg2hA1KUVJaX4th
        FUmgC0LkrmYqb+UcI29IzpovD7ww+xxoy/MWx9E=
x-google-smtp-source: APXvYqzKk4uWivU0nGHpDYdbXvZpZyGrspgfnHfkKKF5O9v3ZYZjVDvOWVjM6KeVLMPMK6VF/RuYKAGoy67maskl+cU=
x-received: by 2002:a5d:6883:: with SMTP id h3mr1859298wru.215.1553162597820;
 Thu, 21 Mar 2019 03:03:17 -0700 (PDT)
x-gmail-original-message-id: <CACqStofWc3178z+2bk_LTSfcZ=Q2y8PDtWmr9yeDxOuBus=CBw@mail.gmail.com>
x-originating-ip: [209.85.221.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 322ca417-6437-44fe-847a-08d6ade473da
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2428;
x-ms-traffictypediagnostic: CY1PR05MB2428:
x-microsoft-antispam-prvs: <CY1PR05MB242837CDC834A7371725D5B3DC420@CY1PR05MB2428.namprd05.prod.outlook.com>
x-forefront-prvs: 0983EAD6B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(39860400002)(136003)(366004)(396003)(199004)(189003)(66066001)(3846002)(8936002)(6116002)(6512007)(76176011)(9686003)(54906003)(71190400001)(71200400001)(446003)(95326003)(229853002)(68736007)(316002)(6506007)(6246003)(386003)(6436002)(26005)(6862004)(486006)(98316002)(25786009)(8676002)(256004)(6486002)(14444005)(186003)(61726006)(4326008)(61266001)(5660300002)(99286004)(498394004)(53546011)(478600001)(11346002)(55446002)(476003)(305945005)(105586002)(86362001)(102836004)(53936002)(97736004)(7736002)(81166006)(14454004)(6636002)(81156014)(52116002)(2906002)(106356001)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2428;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7K80vn6vQlLs0cvK6wKU3kEMCT66X9pU+gdN540xV69eQoqxmBI/zpkjQhoetIIBzv2wmmiU32cpv5Va/J0ldHX/4JH3aadoZX64yyvA0Cor/sozamPh2NG0A5B0u6JLo+aovnwNj8XMzIVjhLCiibUo0bkt/GS08QHJQup2PdL6fPlV5L1kobKJHbx12kC6EKx+82NYfvKY50x2xPHfHo2RUkBDu5eRM0y4WUHLZX0zP8IfWQ016PED6NMK+0Oi+q6eartihS8/8f32L4cIkmphokvB9FyDuhunTBcMOd+9R5Z/cUIpCBw4jegSXvNgx4Ezl3FzQH1UUVmyc1d6Zy9vwfsSNsQn5K1F9Sq6qD2pxs6PmB1iQ7rG/y0xNLC7yf4LlWNgr7umSz5AC5//v9ZVxS1BYX9dpM7yXwE6Los=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F3B4968F03D67649B07FF553D853A4D7@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 322ca417-6437-44fe-847a-08d6ade473da
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2019 10:03:23.1716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2428
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCBNYXIgMjAsIDIwMTkgYXQgNjozMiBQTSBNYXR0IEhlbHNsZXkgPG1oZWxzbGV5QHZt
d2FyZS5jb20+IHdyb3RlOg0KPg0KPHNuaXQ+DQo+ID4NCj4gPiBzdGF0aWMgaW5saW5lIGludCB0
ZXBfaG9zdF9iaWdlbmRpYW4odm9pZCkNCj4gPiB7DQo+DQo+IERvZXMgYW5vdGhlciBzZXJpZXMg
cmVuYW1lIHRoaXMgdG86IHRlcF9pc19ob3N0X2JpZ2VuZGlhbigpID8NCj4NCj4gQ2hlZXJzLA0K
PiAgICAgIC1NYXR0DQo+DQoNClRoaXMgb25lIGlzIGEgbGl0dGxlIGJpdCBjb25mdXNpbmcsIHRo
ZXJlIGFyZSB0d28gZGlmZmVyZW50IEFQSXM6DQppbnQgdGVwX2hvc3RfYmlnZW5kaWFuKHZvaWQp
IC0gdXNlZCBpbiBwZXJmLCBjaGVja3MgdGhlIGJ5dGUgb3JkZXIgb2YNCnRoZSBsb2NhbCBtYWNo
aW5lDQppbnQgdGVwX2lzX2hvc3RfYmlnZW5kaWFuKHN0cnVjdCB0ZXBfaGFuZGxlICpwZXZlbnQp
IC0gY2hlY2tzIHRoZQ0Kb3JkZXIsIHN0b3JlZCBpbiB0aGUgdGVwX2hhbmRsZXINCg0KSSByZW1l
bWJlciB0aGF0IHdlIGRpc2N1c3NlZCB0aGlzIHdpdGggU3RldmVuIGxhc3QgeWVhciwgYW5kIGRl
Y2lkZWQNCnRvIGtlZXAgYm90aCBvZiB0aGVtLiBJJ20gbm90DQphd2FyZSBvZiBhbGwgdXNlIGNh
c2VzLCBhbmQgd2hhdCBpcyB0aGUgcHVycG9zZSBvZiB0ZXBfaXNfaG9zdF9iaWdlbmRpYW4oKSBB
UEkgPw0KDQotLSANCg0KVHp2ZXRvbWlyIChDZWNvKSBTdG95YW5vdg0KVk13YXJlIE9wZW4gU291
cmNlIFRlY2hub2xvZ3kgQ2VudGVyDQo=
