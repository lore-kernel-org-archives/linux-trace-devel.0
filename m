Return-Path: <SRS0=3hMC=P6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A4DC282C3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jan 2019 13:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDBE920855
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jan 2019 13:28:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="GYE5PVTo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbfAVN2X (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Jan 2019 08:28:23 -0500
Received: from mail-eopbgr800059.outbound.protection.outlook.com ([40.107.80.59]:61364
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727936AbfAVN2X (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Jan 2019 08:28:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZ3GRf+hJyGHAucCiil9BZk/LPA5xU/Q8ekKf/8hUsc=;
 b=GYE5PVToxiNuqYHaKIt73DJSwsn/iDNl6afV7SAnLOHStExjo5WCTbQuAEmjIUIp9lyQqBkIuE7XAu+FCkxjEK7VJus0eYVuz/Pa/li7X5wCBkV7W3XtnPf0w5+wEnz/fhKjzQWo2zNwpVKeA0yZzhw/6hCGroC70ijadTRwdZ4=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2443.namprd05.prod.outlook.com (10.167.10.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.14; Tue, 22 Jan 2019 13:28:20 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::a193:f46c:290f:3ca5]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::a193:f46c:290f:3ca5%3]) with mapi id 15.20.1558.016; Tue, 22 Jan 2019
 13:28:20 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/7] trace-cmd: Added new option in trace.dat file for
 negative time offsets
Thread-Topic: [PATCH 2/7] trace-cmd: Added new option in trace.dat file for
 negative time offsets
Thread-Index: AQHUrdBQrEF8qMzkyEKm4lwhUUhU96W5dhsAgAHa3QA=
Date:   Tue, 22 Jan 2019 13:28:19 +0000
Message-ID: <CACqStocW=2c-uTMJ==biTsxLjx9Fr-xgUMQrP0kd7a8rSxPH2Q@mail.gmail.com>
References: <20190116191838.32127-1-tstoyanov@vmware.com>
 <20190116191838.32127-3-tstoyanov@vmware.com>
 <20190121040806.6fce022f@vmware.local.home>
In-Reply-To: <20190121040806.6fce022f@vmware.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P194CA0096.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::37) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: AJcUuke3E34Gj0z6doPQn8antdCs1mZqV3EudOojoxIcPvGlk9C5FE02
        7rDjiwd9tH0v/7knEw3FkVYHaYHlV8ePoADGke0=
x-google-smtp-source: ALg8bN4oGk2dBJquvR7E4Zw9BYEAorwEidiU+x40q9V5uDXd8dJr2/djx72MYIyBrA2nIV3omJnlKCjfXSQTgPqjQRc=
x-received: by 2002:adf:ce86:: with SMTP id r6mr34487681wrn.257.1548163694083;
 Tue, 22 Jan 2019 05:28:14 -0800 (PST)
x-gmail-original-message-id: <CACqStocW=2c-uTMJ==biTsxLjx9Fr-xgUMQrP0kd7a8rSxPH2Q@mail.gmail.com>
x-originating-ip: [209.85.221.51]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY1PR05MB2443;20:b0kme0Qi509xDQYU6pKBQnBDXz+t4fx6ZhnULJi4l1DfKIs9KDqAvs+m45fPr+WxWpGNTQZ3FU7HKpl5La1xu+jT32DtPzSPUhjSTXcWM8qFX8TvnYhx8hfH4z9G05hVoKpwWqhkDHTiONuL68DseECg/PRNvdYfcIkMkv8HBpU=
x-ms-office365-filtering-correlation-id: 789f0cb8-99be-4503-253f-08d6806d7911
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600109)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2443;
x-ms-traffictypediagnostic: CY1PR05MB2443:
x-microsoft-antispam-prvs: <CY1PR05MB24433143FA2FE5EF2E6B87E0DC980@CY1PR05MB2443.namprd05.prod.outlook.com>
x-forefront-prvs: 0925081676
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(346002)(136003)(376002)(396003)(199004)(189003)(6512007)(9686003)(66066001)(3846002)(76176011)(95326003)(55446002)(106356001)(6436002)(105586002)(52116002)(6486002)(498394004)(99286004)(6116002)(256004)(68736007)(61266001)(86362001)(97736004)(316002)(186003)(81156014)(14454004)(81166006)(8936002)(6346003)(98316002)(102836004)(26005)(25786009)(478600001)(11346002)(446003)(6246003)(305945005)(4326008)(486006)(53936002)(71190400001)(53546011)(71200400001)(229853002)(2906002)(7736002)(6506007)(476003)(6862004)(386003)(8676002)(33896004)(61726006);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2443;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: y8BIFJYWMJ7w3KsfM6JzyLD4EFByTAhZBJfQfbLhYzAGv+hhX4rWUbY0mi19XXHQJ7HxvmWb+CwuzV0w17DsdGAc/4w7MX2TjYeww62D4f//Rl/ywDJfst6tNPnJE/WHqDtANIajXSfumI7xCC2IJM0DjJBvkZYwPs+ixVD36DFw4eecv3VFm/hL8LD/v22QPRAOCn90H/XcOmoc3t9fhrzdHFWXP7jSKI2N8jOhleo6S1oLXUv7IxgJRGwHwO4lnKyt/fnoKC4HG4FBnTQPMtPYEUiGJXjL4HZD+0Ak5XuwtCtOoIUAUij/zJ1PnILHx++LuUR1cNEn2CsO6QvfodiT9NZMsjK1uvz5fqNBCGr4pJFxZjScCptCN53DAW+ySLkRbtpQMV3YBLQGVLPKaBn/D2BO/jc8PgH2+UgVrt4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <37529F47D48068428C1A8300F5451CB4@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 789f0cb8-99be-4503-253f-08d6806d7911
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2019 13:28:19.0461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2443
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gTW9uLCBKYW4gMjEsIDIwMTkgYXQgMTE6MDggQU0gU3RldmVuIFJvc3RlZHQgPHJvc3RlZHRA
Z29vZG1pcy5vcmc+IHdyb3RlOg0KPg0KPiBPbiBXZWQsIDE2IEphbiAyMDE5IDIxOjE4OjMzICsw
MjAwDQo+IFR6dmV0b21pciBTdG95YW5vdiA8dHN0b3lhbm92QHZtd2FyZS5jb20+IHdyb3RlOg0K
Pg0KPiA+IGRpZmYgLS1naXQgYS9saWIvdHJhY2UtY21kL3RyYWNlLWlucHV0LmMgYi9saWIvdHJh
Y2UtY21kL3RyYWNlLWlucHV0LmMNCj4gPiBpbmRleCBiNjI4NTcwLi5kZTE1ZDRiIDEwMDY0NA0K
PiA+IC0tLSBhL2xpYi90cmFjZS1jbWQvdHJhY2UtaW5wdXQuYw0KPiA+ICsrKyBiL2xpYi90cmFj
ZS1jbWQvdHJhY2UtaW5wdXQuYw0KPiA+IEBAIC0yMTUxLDYgKzIxNTEsNyBAQCBzdGF0aWMgaW50
IGhhbmRsZV9vcHRpb25zKHN0cnVjdCB0cmFjZWNtZF9pbnB1dCAqaGFuZGxlKQ0KPiA+ICAgICAg
ICAgICAgICAgICAgICAgICBoYW5kbGUtPnRzX29mZnNldCArPSBvZmZzZXQ7DQo+ID4gICAgICAg
ICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICAgICAgICAgICAgICAgY2FzZSBUUkFDRUNNRF9P
UFRJT05fT0ZGU0VUOg0KPiA+ICsgICAgICAgICAgICAgY2FzZSBUUkFDRUNNRF9PUFRJT05fT0ZG
U0VUX046DQo+ID4gICAgICAgICAgICAgICAgICAgICAgIC8qDQo+ID4gICAgICAgICAgICAgICAg
ICAgICAgICAqIFNpbWlsYXIgdG8gZGF0ZSBvcHRpb24sIGJ1dCBqdXN0IGFkZHMgYW4NCj4gPiAg
ICAgICAgICAgICAgICAgICAgICAgICogb2Zmc2V0IHRvIHRoZSB0aW1lc3RhbXAuDQo+ID4gQEAg
LTIxNTgsNyArMjE1OSwxMSBAQCBzdGF0aWMgaW50IGhhbmRsZV9vcHRpb25zKHN0cnVjdCB0cmFj
ZWNtZF9pbnB1dCAqaGFuZGxlKQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICBpZiAoaGFuZGxl
LT5mbGFncyAmIFRSQUNFQ01EX0ZMX0lHTk9SRV9EQVRFKQ0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICBvZmZzZXQgPSBz
dHJ0b2xsKGJ1ZiwgTlVMTCwgMCk7DQo+ID4gLSAgICAgICAgICAgICAgICAgICAgIGhhbmRsZS0+
dHNfb2Zmc2V0ICs9IG9mZnNldDsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgaWYgKG9wdGlv
biA9PSBUUkFDRUNNRF9PUFRJT05fT0ZGU0VUX04pIHsNCj4NCj4gSW5zdGVhZCBvZiBhZGRpbmcg
YSBuZXcgb3B0aW9uLCBjb3VsZG4ndCB3ZSBqdXN0IG1ha2Ugb3B0aW9uIGEgImxvbmcNCj4gbG9u
ZyIgYW5kIHNhdmUgYSBuZWdhdGl2ZSBudW1iZXIgaW4gdGhlIHRyYWNlLmRhdCBmaWxlPyBzdHJ0
b2xsKCkNCj4gc2hvdWxkIGJlIGFibGUgdG8gaGFuZGxlIGl0Lg0KDQpZZXMsICB3ZSBjYW4gbWFr
ZSBpbiBsb25nIGxvbmcsIGJ1dCB0aGlzIHdpbGwgYnJlYWsgdGhlIGJhY2t3YXJkIGNvbXBhdGli
aWxpdHkuDQpUaGUgb2xkIHZlcnNpb25zIG9mICB0cmFjZS1jbWQgd2lsbCBnZXQgY29uZnVzZWQs
IGFzIHRoZXkgd2lsbCBjYXN0IGl0DQp0byB1bnNpZ25lZC4NClRoYXQncyB3aHkgSSBhZGRlZCBh
IG5ldyBvcHRpb24sIGluIHRoaXMgd2F5IG9sZCB0cmFjZS1jbWQgdmVyc2lvbnMNCndpbGwgbm90
IHJlYWQgdGhlDQpuZWdhdGl2ZSBvZmZzZXQgYXQgYWxsLg0KDQo+DQo+IC0tIFN0ZXZlDQo+DQo+
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGhhbmRsZS0+dHNfb2Zmc2V0
ID4gb2Zmc2V0KQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaGFu
ZGxlLT50c19vZmZzZXQgLT0gb2Zmc2V0Ow0KPiA+ICsgICAgICAgICAgICAgICAgICAgICB9IGVs
c2UNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICBoYW5kbGUtPnRzX29mZnNldCAr
PSBvZmZzZXQ7DQo+ID4gICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICAgICAgICAg
ICAgICAgY2FzZSBUUkFDRUNNRF9PUFRJT05fQ1BVU1RBVDoNCj4gPiAgICAgICAgICAgICAgICAg
ICAgICAgYnVmW3NpemUtMV0gPSAnXG4nOw0KDQoNCg0KLS0gDQoNClR6dmV0b21pciAoQ2Vjbykg
U3RveWFub3YNClZNd2FyZSBPcGVuIFNvdXJjZSBUZWNobm9sb2d5IENlbnRlcg0K
