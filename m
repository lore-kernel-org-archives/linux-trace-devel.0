Return-Path: <SRS0=onCu=SZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA83C10F14
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73791206A3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:10:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="aCYTNPDf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbfDWNKj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 09:10:39 -0400
Received: from mail-eopbgr760089.outbound.protection.outlook.com ([40.107.76.89]:33606
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728130AbfDWNKj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 09:10:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGP+vMu+TjOuCAStWyOGg0frISYwHklhuBGPNTLIi1o=;
 b=aCYTNPDfpYLu3gdqD7S/eYKM0v+JwHh9mWKQYts4aDJMBCVuFcXNGBcWQHsO9KjvVCgPpYda24e6a/pHmScH3zX2iaTFoHaPc4zNua83Gfsg1GlRolYbj3q+7scX56ZxIhwJx24zJts1oTIrX4HZqImjw8rn791g8E1HTZky5Uw=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3692.namprd05.prod.outlook.com (10.167.163.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.8; Tue, 23 Apr 2019 13:10:35 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::3949:85c0:3b7b:136e]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::3949:85c0:3b7b:136e%5]) with mapi id 15.20.1835.010; Tue, 23 Apr 2019
 13:10:35 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2] trace-cmd: Load trace-cmd plugins from build folder,
 if exists
Thread-Topic: [PATCH v2] trace-cmd: Load trace-cmd plugins from build folder,
 if exists
Thread-Index: AQHU+dXvspRuc7waEkaC184/+qc2gw==
Date:   Tue, 23 Apr 2019 13:10:35 +0000
Message-ID: <f9e75bf11ee9507ebe8b1e3d6c34c4db9322da97.camel@vmware.com>
References: <20190423095658.3907-1-tstoyanov@vmware.com>
In-Reply-To: <20190423095658.3907-1-tstoyanov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0124312e-9668-49df-5ab0-08d6c7ed1288
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0501MB3692;
x-ms-traffictypediagnostic: MWHPR0501MB3692:
x-microsoft-antispam-prvs: <MWHPR0501MB3692CDDEDCA1FCD5DE04623CDA230@MWHPR0501MB3692.namprd05.prod.outlook.com>
x-forefront-prvs: 0016DEFF96
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(366004)(346002)(376002)(51444003)(199004)(189003)(99286004)(6436002)(229853002)(4326008)(66946007)(26005)(73956011)(71200400001)(5660300002)(486006)(64756008)(97736004)(2501003)(186003)(66446008)(66476007)(6246003)(66556008)(476003)(68736007)(446003)(2616005)(53936002)(11346002)(118296001)(6486002)(81156014)(3846002)(8936002)(256004)(86362001)(76176011)(81166006)(6116002)(8676002)(2906002)(76116006)(66066001)(478600001)(305945005)(36756003)(102836004)(25786009)(110136005)(91956017)(71190400001)(7736002)(6512007)(316002)(14454004)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3692;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9LA9ZHGawb5mQDM/pecdcWaUE92e1tHGnt/VdsNV/zahcWk8KUJIqDUuAji+Sn77vXD5iQeadmBim8cYZJhnsk+C+v035v3IaV7RKRYkGF5Q/kXlSJz7ElzwneMlVbPDqsSjWE/w29sQCPIAn/DTU/E3dm2eEXZPQdkl6FMdvU7MjKhX6+d5anU/Zd3KBpgoIAXGi/i95elRgCiMggtx3CAF7oIJCqFb6b3DkBKkc7xLV9D3Crl8WS7MNaehri6HWahK8ZjhskVraDSKn5SY556yl4vo6lRdf7kI3QuoG+9Ca4PGgBgpaVuLuzpBK8ZRisElmOqGxuU7RzmQj4dGf0kq8J3yGetzkQjp3xegrw4CllT6xPE5ky1Il8ssmHjpEv86c6x4vbk2xgmA2Ofh4wKKUdee8vebiSvb5Ap8EOM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C171A9FDADB0AA4D8D59BF3EACD37CD4@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0124312e-9668-49df-5ab0-08d6c7ed1288
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2019 13:10:35.0845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3692
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCAyMDE5LTA0LTIzIGF0IDEyOjU2ICswMzAwLCBUenZldG9taXIgU3RveWFub3Ygd3Jv
dGU6DQo+IFsNCj4gIHYyIGNoYW5nZXM6DQo+ICAgLSBSZW1vdmVkIHRoZSBsb2dpYyBsb29raW5n
IGZvciBwbHVnaW5zIGluIHRoZSBidWlsZCBwYXRoLg0KPiAgIC0gQWRkZWQgbG9naWMgd2hpY2gg
Z2V0cyB0aGUgZnVsbCBwYXRoIG9mIHRoZSBydW5uaW5nIHRyYWNlLWNtZA0KPiAgICAgYmluYXJ5
IGFuZCBsb2FkcyBwbHVnaW5zIGZyb20gInBsdWdpbnMiIGRpcmVjdG9yeSBhcm91bmQgaXQsIGlm
DQo+IGV4aXN0Lg0KPiBdDQo+IA0KPiBXaGVuIGEgZGV2ZWxvcG1lbnQgdmVyc2lvbiBvZiB0cmFj
ZS1jbWQgaXMgYnVpbHQgYW5kIHJ1biBvbiB0aGUNCj4gbWFjaGluZSwNCj4gYnkgZGVmYXVsdCBp
dCBsb2FkcyBhbGwgcGx1Z2lucyBmcm9tIHByZWRlZmluZWQgZHJpZXJjdG9yaWVzIDoNCj4gICAo
aW5zdGFsbF9wcmVmZml4KS9saWIvdHJhY2VldmVudC9wbHVnaW5zDQo+ICAgfi8udHJhY2VldmVu
dC9wbHVnaW5zDQo+ICAgdGhlIHBhdGggc3BlY2lmaWVkIGluIFRSQUNFRVZFTlRfUExVR0lOX0RJ
UiBlbnZpcm9ubWVudCB2YXJpYWJsZS4NCj4gVGh1cywgdGhlIGRldmVsb3BtZW50IHBsdWdpbnMg
d2lsbCBub3QgYmUgbG9hZGVkLiBUbyBzaW1wbGlmeSB0aGUNCj4gZGV2ZWxvcG1lbnQNCj4gcHJv
Y2VzcywgYSBuZXcgbG9naWMgaXMgYWRkZWQ6DQo+ICAgQXQgcGx1Z2lucyBsb2FkIHRpbWUsIGNo
ZWNrIHRoZSBsb2NhdGlvbiBvZiB0cmFjZS1jbWQgYXBwbGljYXRpb24NCj4gYW5kIGxvb2sNCj4g
ICBmb3IgInBsdWdpbnMiIGRpcmVjdG9yeSBhcm91bmQgaXQuIElmIGZvdW5kLCBsb2FkIHBsdWdp
bnMgZnJvbSBpdC4NCj4gVGhvc2UNCj4gICBwbHVpZ2lucyB3aWxsIGJlIGxvYWRlZCBsYXN0LCBz
byBpbiBjYXNlIG9mIGR1cGxpY2F0aW9uIHRoZQ0KPiAiZGV2ZWxvcG1lbnQiDQo+ICAgcGx1Z2lu
cyB3aW4uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBUenZldG9taXIgU3RveWFub3YgPHRzdG95YW5v
dkB2bXdhcmUuY29tPg0KPiAtLS0NCj4gIGxpYi90cmFjZS1jbWQvdHJhY2UtdXRpbC5jIHwgMzQg
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDM0
IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9saWIvdHJhY2UtY21kL3RyYWNlLXV0
aWwuYyBiL2xpYi90cmFjZS1jbWQvdHJhY2UtdXRpbC5jDQo+IGluZGV4IDhkMjFmYjIuLjk4NDAy
YTAgMTAwNjQ0DQo+IC0tLSBhL2xpYi90cmFjZS1jbWQvdHJhY2UtdXRpbC5jDQo+ICsrKyBiL2xp
Yi90cmFjZS1jbWQvdHJhY2UtdXRpbC5jDQo+IEBAIC0xMzY0LDYgKzEzNjQsMzQgQEAgc3RhdGlj
IGludCBhZGRfcGx1Z2luX2ZpbGUoc3RydWN0IHRlcF9oYW5kbGUNCj4gKnBldmVudCwgY29uc3Qg
Y2hhciAqcGF0aCwNCj4gIAlyZXR1cm4gLUVOT01FTTsNCj4gIH0NCj4gIA0KPiArc3RhdGljIGNo
YXIgKnRyYWNlX3V0aWxfZ2V0X3NvdXJjZV9wbHVnaW5zX2Rpcih2b2lkKQ0KPiArew0KPiArCWNo
YXIgKnBsdWdpbnMgPSAiL3BsdWdpbnMiOw0KPiArCWNoYXIgcGF0aFtQQVRIX01BWCsxXTsNCj4g
KwlpbnQgc2xhc2ggPSAwOw0KPiArCWludCByZXQ7DQo+ICsNCj4gKwlyZXQgPSByZWFkbGluaygi
L3Byb2Mvc2VsZi9leGUiLCBwYXRoLCBQQVRIX01BWCk7DQo+ICsJaWYgKHJldCA+IFBBVEhfTUFY
IHx8IHJldCA8IDApDQo+ICsJCXJldHVybiBOVUxMOw0KPiArDQo+ICsJd2hpbGUgKHJldCkgew0K
PiArCQlpZiAoJy8nID09IHBhdGhbcmV0LS1dKQ0KPiArCQkJc2xhc2grKzsNCj4gKwkJaWYgKHNs
YXNoID09IDIpIHsNCj4gKwkJCXBhdGhbcmV0KzFdID0gMDsNCj4gKwkJCWlmIChzdHJsZW4ocGF0
aCkgKyBzdHJsZW4ocGx1Z2lucykgPiBQQVRIX01BWCkNCj4gKwkJCQlicmVhazsNCj4gKwkJCXN0
cmNhdChwYXRoLCBwbHVnaW5zKTsNCj4gKwkJCXJldHVybiBzdHJkdXAocGF0aCk7DQo+ICsJCX0N
Cj4gKwl9DQoNCkxvb2tzIGdvb2QuIEkgdGhpbmsgdGhhdCB0aGlzIHdoaWxlKCkgbG9vcCBjYW4g
YmUgc2ltcGxpZmllZCB1c2luZyB0aGUNCnN0YW5kYXJkIGxpYnJhcnkgdG8gc29tZXRoaW5nIGxp
a2U6DQoNCgljaGFyIHJlc29sdmVkW1BBVEhfTUFYKzFdOw0KDQoJZGlybmFtZShwYXRoKTsNCglz
dHJjYXQocGF0aCwgIi8uLi9wbHVnaW5zIik7DQoJaWYgKCFyZWFscGF0aChwYXRoLCByZXNvbHZl
ZCkpDQoJCXJldHVybiBOVUxMOw0KDQpUaGUgcmVhbHBhdGgoKSBhYm92ZSBpcyBhbHNvIG5vdCBz
dHJpY3RseSBuZWNlc3NhcnkuDQoNCkNoZWVycywNCg0KLS0gU2xhdmkNCg==
