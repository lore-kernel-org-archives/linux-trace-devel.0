Return-Path: <SRS0=cvyc=QO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFC3C282C2
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Feb 2019 12:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 008BA20823
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Feb 2019 12:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="rxzmJqT3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfBGMws (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Feb 2019 07:52:48 -0500
Received: from mail-eopbgr710076.outbound.protection.outlook.com ([40.107.71.76]:16064
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726769AbfBGMws (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Feb 2019 07:52:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ii1I/h3JM95gt7tg3ehHHp1MHoR1EaRjYAgsRrlXqds=;
 b=rxzmJqT3+/jIOe9KF2U3C42PXXwZ8WSEdIY8lllqS11q53s8leVd7cIjN7Fv0OwZTl+IQDcp1CQyHFDzjYu8yFpi6rVUxP5geiY3LylI6vJSRMXCpnUCGfexbpH+jHSpPaIq6FxuEwny9S0pTNPoneDX0Wnn7Rq0wcprJNbBXQg=
Received: from CY1PR05MB2780.namprd05.prod.outlook.com (10.167.18.26) by
 CY1PR05MB2713.namprd05.prod.outlook.com (10.167.18.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.11; Thu, 7 Feb 2019 12:52:04 +0000
Received: from CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::dcaf:ea32:61c2:a615]) by CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::dcaf:ea32:61c2:a615%11]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 12:52:04 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: Re: [PATCH 6/8] trace-cmd: Make tracecmd_msg_send_close return error
 code if any
Thread-Topic: [PATCH 6/8] trace-cmd: Make tracecmd_msg_send_close return error
 code if any
Thread-Index: AQHUvWWN3MacYyD83Uq2bZjeqvY8Q6XUTPyA
Date:   Thu, 7 Feb 2019 12:52:03 +0000
Message-ID: <CAE0o1Nuafu4H2fjf6oskCuCuXk-BB5y5D+Y0S-6mWfsYT9GPPw@mail.gmail.com>
References: <20190204070855.8921-1-kaslevs@vmware.com>
 <20190204070855.8921-7-kaslevs@vmware.com>
 <20190205101449.6d7ed6d2@gandalf.local.home>
In-Reply-To: <20190205101449.6d7ed6d2@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR16CA0008.namprd16.prod.outlook.com
 (2603:10b6:3:c0::18) To CY1PR05MB2780.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::26)
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: AHQUAualKX9VyuoFI8iigrY3jsMcuLmdEZ+sF+OazqPob+s6v2eBoZwG
        XBmT1ZYmHVD5d4aA/kIOvyZXfiMThNqJI//2QQ==
x-google-smtp-source: AHgI3IZieR3V6dP2zHQY12gUMTO/cVm9rapP11HkT8rH+WjeZ4sVbZtgEDLGQAacvoA+zhhKI7UM2stTJGufbby4D9U=
x-received: by 2002:a05:660c:a8d:: with SMTP id
 m13mr4696490itk.73.1549543920677; Thu, 07 Feb 2019 04:52:00 -0800 (PST)
x-gmail-original-message-id: <CAE0o1Nuafu4H2fjf6oskCuCuXk-BB5y5D+Y0S-6mWfsYT9GPPw@mail.gmail.com>
x-originating-ip: [209.85.166.171]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY1PR05MB2713;20:foB2N2ktukp6jrCDWRks0NP/i5ZF1e57f8A/3mS6Uu0Xup/ixEoD+DaZd20GkCz58jU2+yholrhs73hAS8LRJwl3zMjZSldUwNfsU5PUvnI3aFTgyrAmjzpdwrPvjr4vETBXShW+yIdPUmfSxLWWW+mNG2rR/f1Q4KmmMGwLlR8=
x-ms-office365-filtering-correlation-id: 7e07c7ed-7979-4714-ce0f-08d68cfb0ee2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2713;
x-ms-traffictypediagnostic: CY1PR05MB2713:
x-microsoft-antispam-prvs: <CY1PR05MB2713F1E2BED7343FDAB25F4DDA680@CY1PR05MB2713.namprd05.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(346002)(366004)(39860400002)(199004)(54534003)(189003)(71190400001)(486006)(71200400001)(316002)(107886003)(4326008)(11346002)(68736007)(53546011)(6506007)(476003)(52116002)(446003)(386003)(86362001)(7736002)(186003)(33896004)(14454004)(97736004)(76176011)(2906002)(478600001)(8936002)(305945005)(102836004)(256004)(6346003)(105586002)(66066001)(498394004)(61726006)(6862004)(81156014)(55446002)(6512007)(81166006)(14444005)(54906003)(53936002)(26005)(25786009)(99286004)(6246003)(106356001)(8676002)(6116002)(3846002)(6436002)(61266001)(229853002)(6486002)(9686003)(95326003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2713;H:CY1PR05MB2780.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: S+IXPZS8tz1SB9GkhxCU4qJZz4gMI34kYCtwpIARtUFwZts/oslXOIwvEAdfvtk/gxEhWrkGRqSx0553ssi/Q67adUF1Wvl1guHI23pv3i4TSH5B2kXvgqKqf8Xq9bbiHLens1lX90QeopUr36H45CnZb3M1zp6B6TTK3ZlvmtpGZQ613PKg6rd909fkMcLQwujGBqGu/2Os6wFSG0M5d6JVqXn60YfYKHhxzO08VP/XJPpRrzHrqgzGnP9+OlpPWkVZBkz+5an+sT4sQP4TdPw0i6yFWdjifMw7gwSgh/gLkc1ryyMghBuQAsS9h9ODzqjsoIeLvQv9p6Y6A5Pp2B9foqukbSUsuL70txA/XghxkF0X0l5nZ2V2GGr3VwCRyqdFoIkvQCE+IDjylKLOz7cCUT2J9IaZASHU/wyQ6eY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE8D2BA7B1F2184AA91BFF78364BE89B@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e07c7ed-7979-4714-ce0f-08d68cfb0ee2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 12:52:03.3918
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2713
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCBGZWIgNSwgMjAxOSBhdCA1OjE0IFBNIFN0ZXZlbiBSb3N0ZWR0IDxyb3N0ZWR0QGdv
b2RtaXMub3JnPiB3cm90ZToNCj4NCj4gT24gTW9uLCAgNCBGZWIgMjAxOSAwOTowODo1MyArMDIw
MA0KPiBTbGF2b21pciBLYXNsZXYgPGthc2xldnNAdm13YXJlLmNvbT4gd3JvdGU6DQo+DQo+IEkg
YWNjZXB0ZWQgeW91ciBwYXRjaGVzIHVwIHRvIGhlcmUgd2l0aCBzb21lIHNsaWdodCBtb2RpZmlj
YXRpb25zIHRvDQo+IHRoZSBzdWJqZWN0cyBhbmQgY2hhbmdlIGxvZ3MuIE5vdGUsIHdoZW4gcmVm
ZXJlbmNpbmcgZnVuY3Rpb24gbmFtZXMsDQo+IGl0cyBtb3N0bHkgZGVzaXJhYmxlIHRvIGFkZCBh
ICIoKSIgdG8gdGhlIGVuZCBvZiB0aGVtIHRvIG1ha2UgaXQgc3RhbmQNCj4gb3V0IHRoYXQgdGhl
eSBhcmUgZnVuY3Rpb25zLiBMaWtlIHRyYWNlY21kX21zZ19zZW5kX2Nsb3NlKCkuDQo+DQo+IEJ1
dCwgdGhpcyBwYXRjaCBuZWVkcyBhIGNoYW5nZSBsb2cgdG8gZXhwbGFpbiB3aHkgdGhpcyBmdW5j
dGlvbiBzaG91bGQNCj4gcmV0dXJuIGFuIGVycm9yIGNvZGUuIElzIHNvbWV0aGluZyBnb2luZyB0
byByZWx5IG9uIGl0IGluIHRoZSBmdXR1cmU/DQoNCkFwb2xvZ2llcyBmb3IgdGhlIGVtcHR5IGNv
bW1pdCBtZXNzYWdlIG9uIHRoaXMgb25lLCBzb21laG93IGl0IHNsaXBwZWQNCm1lIGJlZm9yZSBz
ZW5kaW5nLg0KDQpUaGUgaW50ZW50aW9uIGZvciB0aGlzIHBhdGNoIHdhcyBzaW1wbHkgc3R5bGlz
dGljLCBhcyB3aXRoIGNsb3NlKCkNCndoaWNoIHJldHVybnMgZXJyb3IgY29kZSBidXQgaXQncyBz
ZWxkb20gY2hlY2tlZC4NCg0KRmVlbCBmcmVlIHRvIGRyb3AgaXQgaWYgeW91IGZpbmQgdGhhdCB1
bm5lY2Vzc2FyeS4gUGF0Y2ggNyBhbmQgOCBkb24ndA0KZGVwZW5kIG9uIGl0LiBTaG91bGQgSSBy
ZXNlbmQgdGhlbT8NCg0KLS0gU2xhdmkNCg0KDQo+DQo+IC0tIFN0ZXZlDQo+DQo+DQo+DQo+ID4g
U2lnbmVkLW9mZi1ieTogU2xhdm9taXIgS2FzbGV2IDxrYXNsZXZzQHZtd2FyZS5jb20+DQo+ID4g
LS0tDQo+ID4gIGluY2x1ZGUvdHJhY2UtY21kL3RyYWNlLWNtZC5oIHwgMiArLQ0KPiA+ICB0cmFj
ZWNtZC90cmFjZS1tc2cuYyAgICAgICAgICB8IDQgKystLQ0KPiA+ICAyIGZpbGVzIGNoYW5nZWQs
IDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9p
bmNsdWRlL3RyYWNlLWNtZC90cmFjZS1jbWQuaCBiL2luY2x1ZGUvdHJhY2UtY21kL3RyYWNlLWNt
ZC5oDQo+ID4gaW5kZXggMzNmMzUyYi4uMGFiMjNmNiAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRl
L3RyYWNlLWNtZC90cmFjZS1jbWQuaA0KPiA+ICsrKyBiL2luY2x1ZGUvdHJhY2UtY21kL3RyYWNl
LWNtZC5oDQo+ID4gQEAgLTMxOCw3ICszMTgsNyBAQCBpbnQgdHJhY2VjbWRfbXNnX3NlbmRfaW5p
dF9kYXRhKHN0cnVjdCB0cmFjZWNtZF9tc2dfaGFuZGxlICptc2dfaGFuZGxlLA0KPiA+ICBpbnQg
dHJhY2VjbWRfbXNnX2RhdGFfc2VuZChzdHJ1Y3QgdHJhY2VjbWRfbXNnX2hhbmRsZSAqbXNnX2hh
bmRsZSwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IGNoYXIgKmJ1Ziwg
aW50IHNpemUpOw0KPiA+ICBpbnQgdHJhY2VjbWRfbXNnX2ZpbmlzaF9zZW5kaW5nX2RhdGEoc3Ry
dWN0IHRyYWNlY21kX21zZ19oYW5kbGUgKm1zZ19oYW5kbGUpOw0KPiA+IC12b2lkIHRyYWNlY21k
X21zZ19zZW5kX2Nsb3NlX21zZyhzdHJ1Y3QgdHJhY2VjbWRfbXNnX2hhbmRsZSAqbXNnX2hhbmRs
ZSk7DQo+ID4gK2ludCB0cmFjZWNtZF9tc2dfc2VuZF9jbG9zZV9tc2coc3RydWN0IHRyYWNlY21k
X21zZ19oYW5kbGUgKm1zZ19oYW5kbGUpOw0KPiA+DQo+ID4gIC8qIGZvciBzZXJ2ZXIgKi8NCj4g
PiAgaW50IHRyYWNlY21kX21zZ19pbml0aWFsX3NldHRpbmcoc3RydWN0IHRyYWNlY21kX21zZ19o
YW5kbGUgKm1zZ19oYW5kbGUpOw0KPiA+IGRpZmYgLS1naXQgYS90cmFjZWNtZC90cmFjZS1tc2cu
YyBiL3RyYWNlY21kL3RyYWNlLW1zZy5jDQo+ID4gaW5kZXggYjRiNThkNC4uYzI0NDI0YiAxMDA2
NDQNCj4gPiAtLS0gYS90cmFjZWNtZC90cmFjZS1tc2cuYw0KPiA+ICsrKyBiL3RyYWNlY21kL3Ry
YWNlLW1zZy5jDQo+ID4gQEAgLTU0OSwxMiArNTQ5LDEyIEBAIGludCB0cmFjZWNtZF9tc2dfc2Vu
ZF9wb3J0X2FycmF5KHN0cnVjdCB0cmFjZWNtZF9tc2dfaGFuZGxlICptc2dfaGFuZGxlLA0KPiA+
ICAgICAgIHJldHVybiAwOw0KPiA+ICB9DQo+ID4NCj4gPiAtdm9pZCB0cmFjZWNtZF9tc2dfc2Vu
ZF9jbG9zZV9tc2coc3RydWN0IHRyYWNlY21kX21zZ19oYW5kbGUgKm1zZ19oYW5kbGUpDQo+ID4g
K2ludCB0cmFjZWNtZF9tc2dfc2VuZF9jbG9zZV9tc2coc3RydWN0IHRyYWNlY21kX21zZ19oYW5k
bGUgKm1zZ19oYW5kbGUpDQo+ID4gIHsNCj4gPiAgICAgICBzdHJ1Y3QgdHJhY2VjbWRfbXNnIG1z
ZzsNCj4gPg0KPiA+ICAgICAgIHRyYWNlY21kX21zZ19pbml0KE1TR19DTE9TRSwgJm1zZyk7DQo+
ID4gLSAgICAgdHJhY2VjbWRfbXNnX3NlbmQobXNnX2hhbmRsZS0+ZmQsICZtc2cpOw0KPiA+ICsg
ICAgIHJldHVybiB0cmFjZWNtZF9tc2dfc2VuZChtc2dfaGFuZGxlLT5mZCwgJm1zZyk7DQo+ID4g
IH0NCj4gPg0KPiA+ICBpbnQgdHJhY2VjbWRfbXNnX2RhdGFfc2VuZChzdHJ1Y3QgdHJhY2VjbWRf
bXNnX2hhbmRsZSAqbXNnX2hhbmRsZSwNCj4NCg==
