Return-Path: <SRS0=onCu=SZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D824AC10F14
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 14:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A0D8214AE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 14:15:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="lAT2b5R4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfDWOPh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 10:15:37 -0400
Received: from mail-eopbgr720065.outbound.protection.outlook.com ([40.107.72.65]:16480
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726659AbfDWOPh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 10:15:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzLwLLWf4xGzpwVB1QK6YDEhHR530mDWGcHZOs0H7cg=;
 b=lAT2b5R4J+jzRGTyx9E2rNS4HjxVqGDKf86HPDNJN9HjFUBQ6QIioC8st1nvD9P6RlISJB6DNxaVntf5D3JIpvmr8/YvQo3/+Fz6oqhVQNYl4uYUle4fZ+BczPxHwD0W+tj0H5XMZb37xuU2fja5CCBnVsrWEiJ4TbkpD3fIn50=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2523.namprd05.prod.outlook.com (10.167.11.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.6; Tue, 23 Apr 2019 14:15:34 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::99c4:3097:b606:1c00]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::99c4:3097:b606:1c00%12]) with mapi id 15.20.1835.010; Tue, 23 Apr
 2019 14:15:34 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Slavomir Kaslev <kaslevs@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2] trace-cmd: Load trace-cmd plugins from build folder,
 if exists
Thread-Topic: [PATCH v2] trace-cmd: Load trace-cmd plugins from build folder,
 if exists
Thread-Index: AQHU+bronI65iI5TDU+bPiYnjDYuAaZJuGqAgAAGLICAAAvngA==
Date:   Tue, 23 Apr 2019 14:15:34 +0000
Message-ID: <CACqStocb_PcT-aqbyagF5-V-sXpeVGUA7YD3HB25yUAWd1z=+Q@mail.gmail.com>
References: <20190423095658.3907-1-tstoyanov@vmware.com>
 <f9e75bf11ee9507ebe8b1e3d6c34c4db9322da97.camel@vmware.com>
 <20190423093241.12235bb8@gandalf.local.home>
In-Reply-To: <20190423093241.12235bb8@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P194CA0069.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::46) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAV//OJSFWhD2nMmI3Adqo1ByHdJdxbburWIu0VSc30shQ9Q+p0C
        3gko6J17Y3bF438+KmrxeYXppJ9RMb6NKt14nGU=
x-google-smtp-source: APXvYqz75Re/0cMLUcK5xGaAQpFcbiIpYi51T3pk5lZw/9cSLK0lcvedPCtSAfwCRRS4EatKt6T8l/V5FQD85JmV4HA=
x-received: by 2002:a1c:7610:: with SMTP id r16mr2338320wmc.21.1556028928973;
 Tue, 23 Apr 2019 07:15:28 -0700 (PDT)
x-gmail-original-message-id: <CACqStocb_PcT-aqbyagF5-V-sXpeVGUA7YD3HB25yUAWd1z=+Q@mail.gmail.com>
x-originating-ip: [209.85.128.49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b878875-44fd-459f-80b2-08d6c7f626a0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:CY1PR05MB2523;
x-ms-traffictypediagnostic: CY1PR05MB2523:
x-microsoft-antispam-prvs: <CY1PR05MB25236DA157BE03B7294C000ADC230@CY1PR05MB2523.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0016DEFF96
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(346002)(39860400002)(366004)(136003)(199004)(189003)(51444003)(2906002)(86362001)(4326008)(66946007)(256004)(66446008)(73956011)(61266001)(55446002)(81166006)(478600001)(186003)(6862004)(6246003)(95326003)(26005)(64756008)(66476007)(54906003)(66556008)(8676002)(81156014)(229853002)(61726006)(66066001)(8936002)(52116002)(53546011)(102836004)(316002)(3846002)(386003)(6436002)(6506007)(53936002)(6116002)(6486002)(71190400001)(76176011)(498394004)(97736004)(6512007)(9686003)(5660300002)(25786009)(99286004)(486006)(305945005)(7736002)(11346002)(68736007)(14454004)(446003)(98316002)(476003)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2523;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 82dlMNoITw2U/VB9AUGuyvQzD8CUBXvXK2VU8gr5RWjkAYGzy7Kd8npCVo48oCQdxQOwhKPYIuuB2mqAtVyfSCuEU+2G3GPXyRwRxsW+PcKNXgc4LQeeA3pPu1JNX+VixEF0BRKmWL6fWHT3f/fN5Mr7psSLRp5U4/RW98A/mcrY6giPHGXg5rKqKm83ivglQxEHWMZXL3vtcIt5FYyb/wXGkBJ92LpI57KBSh/51Uouj3so+HrWBOKk1U4TnphpxmzpqqzNVwE1D7p9YxiBLgorz6578mXSRw1ELwsUzsVSRj9iPkQt4dmzIG+HSjGkrPV0Y4AisV6ZfuJhWzqh1PMrkmCMjAZTyC9tH/lb59zeA7KAVT3GGLvCNSja8sdpmfuONFk0WIBm8vJdxuNU2wa8H0vzBfjEg8OfRX0vyss=
Content-Type: text/plain; charset="utf-8"
Content-ID: <26CCD30238605A4C869814E46A396836@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b878875-44fd-459f-80b2-08d6c7f626a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2019 14:15:34.6011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2523
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCBBcHIgMjMsIDIwMTkgYXQgNDozMiBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IE9uIFR1ZSwgMjMgQXByIDIwMTkgMTM6MTA6MzUgKzAw
MDANCj4gU2xhdm9taXIgS2FzbGV2IDxrYXNsZXZzQHZtd2FyZS5jb20+IHdyb3RlOg0KPg0KPg0K
PiA+ID4gK3N0YXRpYyBjaGFyICp0cmFjZV91dGlsX2dldF9zb3VyY2VfcGx1Z2luc19kaXIodm9p
ZCkNCj4gPiA+ICt7DQo+ID4gPiArICAgY2hhciAqcGx1Z2lucyA9ICIvcGx1Z2lucyI7DQo+ID4g
PiArICAgY2hhciBwYXRoW1BBVEhfTUFYKzFdOw0KPiA+ID4gKyAgIGludCBzbGFzaCA9IDA7DQo+
ID4gPiArICAgaW50IHJldDsNCj4gPiA+ICsNCj4gPiA+ICsgICByZXQgPSByZWFkbGluaygiL3By
b2Mvc2VsZi9leGUiLCBwYXRoLCBQQVRIX01BWCk7DQo+ID4gPiArICAgaWYgKHJldCA+IFBBVEhf
TUFYIHx8IHJldCA8IDApDQo+ID4gPiArICAgICAgICAgICByZXR1cm4gTlVMTDsNCj4gPiA+ICsN
Cj4gPiA+ICsgICB3aGlsZSAocmV0KSB7DQo+ID4gPiArICAgICAgICAgICBpZiAoJy8nID09IHBh
dGhbcmV0LS1dKQ0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICBzbGFzaCsrOw0KPiA+ID4gKyAg
ICAgICAgICAgaWYgKHNsYXNoID09IDIpIHsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgcGF0
aFtyZXQrMV0gPSAwOw0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICBpZiAoc3RybGVuKHBhdGgp
ICsgc3RybGVuKHBsdWdpbnMpID4gUEFUSF9NQVgpDQo+ID4gPiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgYnJlYWs7DQo+ID4gPiArICAgICAgICAgICAgICAgICAgIHN0cmNhdChwYXRoLCBw
bHVnaW5zKTsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgcmV0dXJuIHN0cmR1cChwYXRoKTsN
Cj4gPiA+ICsgICAgICAgICAgIH0NCj4gPiA+ICsgICB9DQo+ID4NCj4gPiBMb29rcyBnb29kLiBJ
IHRoaW5rIHRoYXQgdGhpcyB3aGlsZSgpIGxvb3AgY2FuIGJlIHNpbXBsaWZpZWQgdXNpbmcgdGhl
DQo+ID4gc3RhbmRhcmQgbGlicmFyeSB0byBzb21ldGhpbmcgbGlrZToNCj4gPg0KPiA+ICAgICAg
IGNoYXIgcmVzb2x2ZWRbUEFUSF9NQVgrMV07DQo+ID4NCj4gPiAgICAgICBkaXJuYW1lKHBhdGgp
Ow0KPiA+ICAgICAgIHN0cmNhdChwYXRoLCAiLy4uL3BsdWdpbnMiKTsNCj4gPiAgICAgICBpZiAo
IXJlYWxwYXRoKHBhdGgsIHJlc29sdmVkKSkNCj4gPiAgICAgICAgICAgICAgIHJldHVybiBOVUxM
Ow0KPiA+DQo+ID4gVGhlIHJlYWxwYXRoKCkgYWJvdmUgaXMgYWxzbyBub3Qgc3RyaWN0bHkgbmVj
ZXNzYXJ5Lg0KPg0KPiBPcjoNCj4NCj4gICAgICAgICBjaGFyICpwOw0KPg0KPiAgICAgICAgIGRp
cm5hbWUocGF0aCk7DQo+ICAgICAgICAgcCA9IHN0cnJjaHIocGF0aCwgJy8nKTsNCj4gICAgICAg
ICBpZiAoIXApDQo+ICAgICAgICAgICAgICAgICByZXR1cm4gTlVMTDsNCj4gICAgICAgICAvKiBJ
dCdzIG9ubHkgaW4gdGhlIHNvdXJjZSBpZiB3ZSBhcmUgaW4gdGhlIHRyYWNlY21kIGRpcmVjdG9y
eSAqLw0KPiAgICAgICAgIGlmIChzdHJjbXAocCwgIi90cmFjZWNtZCIpICE9IDApDQo+ICAgICAg
ICAgICAgICAgICByZXR1cm4gTlVMTDsNCj4NCj4gICAgICAgICBzdHJjcHkocCwgIi9wbHVnaW5z
Iik7DQo+DQo+DQo+IC0tIFN0ZXZlDQo+DQoNCkl0IG1ha2VzIHNlbnNlIHRvIGNoZWNrIGZvciB0
cmFjZWNtZCBkaXJlY3RvcnksIHRob3VnaCBpdCBuYXJyb3dzIHRoZQ0KdXNlIGNhc2VzLiBJJ2xs
IHNlbmQgdGhlIG5leHQgdmVyc2lvbiB3aXRoIHRoaXMuDQoNCi0tIA0KVHp2ZXRvbWlyIChDZWNv
KSBTdG95YW5vdg0KVk13YXJlIE9wZW4gU291cmNlIFRlY2hub2xvZ3kgQ2VudGVyDQo=
