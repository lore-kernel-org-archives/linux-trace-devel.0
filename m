Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 057B2C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 18:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBF77206B7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 18:00:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="C5AeiroF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfCSSA2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 14:00:28 -0400
Received: from mail-eopbgr730072.outbound.protection.outlook.com ([40.107.73.72]:3488
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727139AbfCSSA2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 14:00:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Hng+x8Z/qwbxrqqB8rCQgDfUj9R7OJIbn6UzhOAeD0=;
 b=C5AeiroF7LnAfzEclcRY23kcgENihir79ditWDXJd4I511v3jPMzmEfvGsTAZZyL2FT5sMFADZYrFvLiymUMcc/9qiIT2M5nQm21rlpcIWwQwKGryaefRlQpR/jo+ZLAhWGQb5kJfrYzMqm/XiCC5kPmLiGvOujQojGOhNOC2JA=
Received: from CY1PR05MB2780.namprd05.prod.outlook.com (10.167.18.26) by
 CY1PR05MB2731.namprd05.prod.outlook.com (10.167.18.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.8; Tue, 19 Mar 2019 18:00:23 +0000
Received: from CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f]) by CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f%9]) with mapi id 15.20.1730.003; Tue, 19 Mar 2019
 18:00:23 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 8/9] trace-cmd: Implemented new option in trace.dat
 file: TRACECMD_OPTION_TIME_SHIFT
Thread-Topic: [PATCH v7 8/9] trace-cmd: Implemented new option in trace.dat
 file: TRACECMD_OPTION_TIME_SHIFT
Thread-Index: AQHU3n2VRor0llK3QEma5p5smYUNLA==
Date:   Tue, 19 Mar 2019 18:00:22 +0000
Message-ID: <CAE0o1NvnEv=z88gFST7+hrb-345CS7rjop+tU561j=CsYju00A@mail.gmail.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
 <20190319155536.19381-9-tstoyanov@vmware.com>
In-Reply-To: <20190319155536.19381-9-tstoyanov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YQXPR0101CA0025.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:15::38) To CY1PR05MB2780.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAX/hZINhBkXFypt0lGcMTRM78Q1cI1xj/1O4J2iisaIr+Z1GuSN
        yR3GIU9MuEDHYNyjFqDTpeFwTPydWz6ZQ++lFQ==
x-google-smtp-source: APXvYqx/rSzhQiZFQ6BZhf9qb5xv2mbLgPwM26apXnLWQW388l7fOUl4hysmyGI0AVGnOVS1S9AhhTUqwkUM/dvTVMc=
x-received: by 2002:a5e:9e02:: with SMTP id i2mr2542474ioq.238.1553018419508;
 Tue, 19 Mar 2019 11:00:19 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1NvnEv=z88gFST7+hrb-345CS7rjop+tU561j=CsYju00A@mail.gmail.com>
x-originating-ip: [209.85.166.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f1785f1-8a0e-4028-7295-08d6ac94c193
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2731;
x-ms-traffictypediagnostic: CY1PR05MB2731:
x-microsoft-antispam-prvs: <CY1PR05MB273188B5B4FDBC895D0884F5DA400@CY1PR05MB2731.namprd05.prod.outlook.com>
x-forefront-prvs: 0981815F2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(346002)(366004)(396003)(136003)(199004)(189003)(6486002)(53546011)(54906003)(478600001)(98316002)(52116002)(498394004)(6512007)(6436002)(76176011)(5660300002)(486006)(95326003)(55446002)(476003)(11346002)(305945005)(8676002)(6636002)(61726006)(81166006)(4326008)(229853002)(446003)(99286004)(186003)(81156014)(68736007)(6862004)(105586002)(2906002)(97736004)(3846002)(8936002)(7736002)(9686003)(71200400001)(106356001)(26005)(66066001)(14454004)(71190400001)(61266001)(86362001)(256004)(316002)(25786009)(6506007)(6116002)(53936002)(102836004)(386003)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2731;H:CY1PR05MB2780.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: z5tVbz6A/Y3iQRMvC35KJX9DVtgqsBH98dkpZjhHKqtH0RzxKFT84Bqf3ii1yrDBx7r7KEFcmhsYNt7ymRj5BNaBMTNyqIrz+I2ueWO7Kp6N9rdsOABKDjgi0dySAnHSlulnptQ2dcem36Ei8p/iy8K+HprzTo50Vn5wquIvjZyzj1S66zUp5C+Gg1x+Gx11ITDPkSh9IYQsD3LhIdAiORv/eAS3fbZmwE4a/WfUYgdsK5bKnbh0aMmMhHlHiksOdmnikMQsyZ0BMlxAzTnweILqNvBoyApvUR0BQirrJUft7tJE/4FksRxR/sLmVxsx+wzQnGC7ylvSeCaN0wK3hcTlk42MPKNW2J/NbK0V+woMlhdt99Tn/xNozfpPc58+gLQSIue/i3MTt+p+cR3jXqfQHbGWTUg3oJDVEWZuQoc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4188A18674151643B27457D783769105@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f1785f1-8a0e-4028-7295-08d6ac94c193
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2019 18:00:22.6440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2731
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCBNYXIgMTksIDIwMTkgYXQgNTo1NiBQTSBUenZldG9taXIgU3RveWFub3YgPHRzdG95
YW5vdkB2bXdhcmUuY29tPiB3cm90ZToNCj4NCj4gVGhlIFRSQUNFQ01EX09QVElPTl9USU1FX1NI
SUZUIGlzIHVzZWQgd2hlbiBzeW5jaHJvbml6aW5nIHRyYWNlIHRpbWUgc3RhbXBzIGJldHdlZW4N
Cj4gdHdvIHRyYWNlLmRhdCBmaWxlcy4gSXQgY29udGFpbnMgbXVsdGlwbGUgbG9uZyBsb25nICh0
aW1lLCBvZmZzZXQpIHBhaXJzLCBkZXNjcmliaW5nDQo+IHRpbWUgc3RhbXBzIF9vZmZzZXRfLCBt
ZWFzdXJlZCBpbiB0aGUgZ2l2ZW4gbG9jYWwgX3RpbWVfLiBUaGUgY29udGVudCBvZiB0aGUgb3B0
aW9uDQo+IGJ1ZmZlciBpczoNCj4gIGZpcnN0IDQgYnl0ZXMgLSBpbnRlZ2VyLCBjb3VudCBvZiB0
aW1lc3RhbXAgb2Zmc2V0cw0KPiAgbG9uZyBsb25nIGFycmF5IG9mIHNpemUgX2NvdW50XywgbG9j
YWwgdGltZSBpbiB3aGljaCB0aGUgb2Zmc2V0IGlzIG1lYXN1cmVkDQo+ICBsb25nIGxvbmcgYXJy
YXkgb2Ygc2l6ZSBfY291bnRfLCBvZmZzZXQgb2YgdGhlIHRpbWUgc3RhbXBzDQo+DQo+IFNpZ25l
ZC1vZmYtYnk6IFR6dmV0b21pciBTdG95YW5vdiA8dHN0b3lhbm92QHZtd2FyZS5jb20+DQo+IC0t
LQ0KPiAgaW5jbHVkZS90cmFjZS1jbWQvdHJhY2UtY21kLmggfCAgIDEgKw0KPiAgbGliL3RyYWNl
LWNtZC90cmFjZS1pbnB1dC5jICAgfCAxMjcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAxMjYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMo
LSkNCj4NCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdHJhY2UtY21kL3RyYWNlLWNtZC5oIGIvaW5j
bHVkZS90cmFjZS1jbWQvdHJhY2UtY21kLmgNCj4gaW5kZXggZjdjMDQzYS4uNTU1MjM5NiAxMDA2
NDQNCj4gLS0tIGEvaW5jbHVkZS90cmFjZS1jbWQvdHJhY2UtY21kLmgNCj4gKysrIGIvaW5jbHVk
ZS90cmFjZS1jbWQvdHJhY2UtY21kLmgNCj4gQEAgLTgyLDYgKzgyLDcgQEAgZW51bSB7DQo+ICAg
ICAgICAgVFJBQ0VDTURfT1BUSU9OX0hPT0ssDQo+ICAgICAgICAgVFJBQ0VDTURfT1BUSU9OX09G
RlNFVCwNCj4gICAgICAgICBUUkFDRUNNRF9PUFRJT05fQ1BVQ09VTlQsDQo+ICsgICAgICAgVFJB
Q0VDTURfT1BUSU9OX1RJTUVfU0hJRlQsDQo+ICB9Ow0KPg0KPiAgZW51bSB7DQo+IGRpZmYgLS1n
aXQgYS9saWIvdHJhY2UtY21kL3RyYWNlLWlucHV0LmMgYi9saWIvdHJhY2UtY21kL3RyYWNlLWlu
cHV0LmMNCj4gaW5kZXggMGE2ZTgyMC4uMDRmMjIyZCAxMDA2NDQNCj4gLS0tIGEvbGliL3RyYWNl
LWNtZC90cmFjZS1pbnB1dC5jDQo+ICsrKyBiL2xpYi90cmFjZS1jbWQvdHJhY2UtaW5wdXQuYw0K
PiBAQCAtNzUsNiArNzUsMTEgQEAgc3RydWN0IGlucHV0X2J1ZmZlcl9pbnN0YW5jZSB7DQo+ICAg
ICAgICAgc2l6ZV90ICAgICAgICAgICAgICAgICAgb2Zmc2V0Ow0KPiAgfTsNCj4NCj4gK3N0cnVj
dCB0c19vZmZzZXRfc2FtcGxlIHsNCj4gKyAgICAgICBsb25nIGxvbmcgICAgICAgdGltZTsNCj4g
KyAgICAgICBsb25nIGxvbmcgICAgICAgb2Zmc2V0Ow0KPiArfTsNCj4gKw0KPiAgc3RydWN0IHRy
YWNlY21kX2lucHV0IHsNCj4gICAgICAgICBzdHJ1Y3QgdGVwX2hhbmRsZSAgICAgICAqcGV2ZW50
Ow0KPiAgICAgICAgIHN0cnVjdCB0ZXBfcGx1Z2luX2xpc3QgICpwbHVnaW5fbGlzdDsNCj4gQEAg
LTkyLDYgKzk3LDggQEAgc3RydWN0IHRyYWNlY21kX2lucHV0IHsNCj4gICAgICAgICBib29sICAg
ICAgICAgICAgICAgICAgICB1c2VfcGlwZTsNCj4gICAgICAgICBzdHJ1Y3QgY3B1X2RhdGEgICAg
ICAgICAqY3B1X2RhdGE7DQo+ICAgICAgICAgbG9uZyBsb25nICAgICAgICAgICAgICAgdHNfb2Zm
c2V0Ow0KPiArICAgICAgIGludCAgICAgICAgICAgICAgICAgICAgIHRzX2NvcnJfY291bnQ7DQo+
ICsgICAgICAgc3RydWN0IHRzX29mZnNldF9zYW1wbGUgKnRzX2NvcnI7DQoNCk5pdDoNCnRzX2Nv
cnJfY291bnQgLT4gdHNfc2FtcGxlc19jb3VudA0KdHNfY29yciAtPiB0c19zYW1wbGVzDQo=
