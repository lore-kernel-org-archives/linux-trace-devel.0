Return-Path: <SRS0=tqF+=TQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2DEC04AAF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 May 2019 13:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC47B20833
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 May 2019 13:42:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="dCE4GNNf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfEPNmr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 May 2019 09:42:47 -0400
Received: from mail-eopbgr750040.outbound.protection.outlook.com ([40.107.75.40]:34102
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726736AbfEPNmr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 May 2019 09:42:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4hPuWLXxOs3y0NwwL+Jw1D/+eN2ECSmxbX1JWa6uLs=;
 b=dCE4GNNfpjcshGHSVJ4OgLgpXg9GmkVAGdPxmg9V/puutbRLz8Zu1y7zB/1OYbsrQFdsVK0eMtqs/MQP8/CGof7Lz9ac7t4o+qsB879hI3Pbr9JEC+eU39YlhOmhBIONCaEzhaATzzlIB73H4ruPujn1BbPLwk+IcjZu8Gl0JHI=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3723.namprd05.prod.outlook.com (10.167.163.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.8; Thu, 16 May 2019 13:42:44 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::ed2c:1a85:8103:5940]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::ed2c:1a85:8103:5940%6]) with mapi id 15.20.1922.002; Thu, 16 May 2019
 13:42:44 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: Re: [PATCH 0/6] Various modifications and fixes toward KS 1.0
Thread-Topic: [PATCH 0/6] Various modifications and fixes toward KS 1.0
Thread-Index: AQHVC+0vMJEP0QHBskGa3MtPrCDxug==
Date:   Thu, 16 May 2019 13:42:41 +0000
Message-ID: <CAE0o1NuLW1E7wayZA2CKtDGp4YciJjVz9-4KFkk+XWiB+GyDLA@mail.gmail.com>
References: <20190515190911.20755-1-ykaradzhov@vmware.com>
In-Reply-To: <20190515190911.20755-1-ykaradzhov@vmware.com>
Reply-To: "slavomir.kaslev@gmail.com" <slavomir.kaslev@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM6PR12CA0003.namprd12.prod.outlook.com
 (2603:10b6:5:1c0::16) To MWHPR0501MB3772.namprd05.prod.outlook.com
 (2603:10b6:301:7a::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAVgBL+R494Y+wQhyWGZOD9gS+/NopzIw0msYJ4I5W9nQYgnwRzh
        NfAweuQtIIr7b7Lf3SFyZPkhDWNVAZrV9clipw==
x-google-smtp-source: APXvYqxs5VpG3MQz5MC+ozgYgQ3jO4xhLVlTk1PN78VAR1nmAAwdN+X40fGTTVKQwuNIZkyByx5yCNTKudq/IeEUbYk=
x-received: by 2002:a05:6602:188:: with SMTP id
 m8mr17928300ioo.206.1558014153129; Thu, 16 May 2019 06:42:33 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1NuLW1E7wayZA2CKtDGp4YciJjVz9-4KFkk+XWiB+GyDLA@mail.gmail.com>
x-originating-ip: [209.85.166.45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: baec1c19-9c68-4e79-59ff-08d6da045de5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0501MB3723;
x-ms-traffictypediagnostic: MWHPR0501MB3723:
x-microsoft-antispam-prvs: <MWHPR0501MB37238022DE7C345D180E64FBDA0A0@MWHPR0501MB3723.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(346002)(39860400002)(396003)(366004)(189003)(199004)(6436002)(26005)(61266001)(14454004)(66806009)(498394004)(6512007)(9686003)(305945005)(8796002)(8936002)(6636002)(229853002)(478600001)(61726006)(5660300002)(6486002)(55446002)(186003)(66066001)(66476007)(95326003)(73956011)(22416003)(43066004)(66446008)(64756008)(54906003)(66556008)(99286004)(316002)(6246003)(53936002)(52116002)(107886003)(11346002)(2906002)(66946007)(6506007)(446003)(386003)(76176011)(71190400001)(486006)(68736007)(4326008)(6666004)(86362001)(14444005)(7736002)(8676002)(256004)(476003)(6862004)(102836004)(53546011)(25786009)(81156014)(81166006)(3846002)(6116002)(71200400001)(2860700004);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3723;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 63CnSr7oa2oNjH7FyphS9XxEBTqJyqnjK9/Cgoq0DMDHhKuhcJp/9I68uVS7hWmX7F4JUfyJo6A3xzLOlJ5TBLGo2pBnvc5xK4a6aWhhv6n3yOtYmHUmiw01v9g0agS+zLS7jcRUsGvW19wC43lx2sNOcTnFzQ3QV7EBWb5st3qoA7zN+RPgQGkYZWkNCNkVWUrUDZaxPYMfii8uSFZSwqKUUcTa/jRHIDHzeEFEFAAxrLfqluiw5uA+IayAsEj526WvRqYr06z6whM52uqPGLFOkU/hHQQSVDG490o7tVJjJQrhNRZtsoYFCzCV5F5yoehJDklUnUcah8ec7LXBRiwGwoT+gmKdA+brezDNreGc2PZQmi4aKI53e5iCtfljAFfcNuP28Q3e1IQYcZYqrSyygsR9mbt/Ok69RdIRv98=
Content-Type: text/plain; charset="utf-8"
Content-ID: <97D58E0F76F83A439F30C4534971B922@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baec1c19-9c68-4e79-59ff-08d6da045de5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 13:42:41.2028
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kaslevs@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3723
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCBNYXkgMTUsIDIwMTkgYXQgMTA6MTEgUE0gWW9yZGFuIEthcmFkemhvdiA8eWthcmFk
emhvdkB2bXdhcmUuY29tPiB3cm90ZToNCj4NCj4gVGhlIHBhdGNoLXNldCBjb250YWlucyBwYXRj
aGVzIHRoYXQgaGF2ZSBiZWVuIHNlbnQgYWxyZWFkeSwNCj4gYnV0IGhhdmUgbm90IGJlZW4gcHVz
aGVkIGR1ZSB0byB2YXJpb3VzIHJlYXNvbnMuIFRoZSBsYXN0DQo+IHR3byBwYXRjaCBhcmUgZml4
ZXMgb2YgYnVncyB0aGF0IGhhdmUgYmVlbiBmb3VuZCByZWNlbnRseS4NCj4NCj4NCj4gWW9yZGFu
IEthcmFkemhvdiAoNik6DQo+ICAga2VybmVsLXNoYXJrOiBSZW1vdmUgaGFyZC1jb2RlZCBpbnN0
YWxsIHBhdGhzDQo+ICAga2VybmVsLXNoYXJrOiBVc2UgWERHIGNvbXBsaWFudCBwYXRoIHdoZW4g
c2F2aW5nIGNhY2hlZCBkYXRhDQo+ICAga2VybmVsLXNoYXJrOiBFbmZvcmNlIHVwZGF0ZSBvZiB0
aGUgT3BlbkdMIHdpZGdldCB3aGVuIGxvYWRpbmcgbmV3DQo+ICAgICBzZXNzaW9uDQo+ICAga2Vy
bmVsLXNoYXJrOiBBZGQgIlJlcG9ydCBidWciIGJ1dHRvbiB0byAiSGVscCINCj4gICBrZXJuZWwt
c2hhcms6IEltcHJvdmUgdGhlIGFwcGVhcmFuY2Ugb24gaGlnaCBzY3JlZW4gcmVzb2x1dGlvbg0K
PiAgIGtlcm5lbC1zaGFyazogSGFuZGxlIHRoZSBjYXNlIHdoZW4gdGhlIG1hcmtlciBwb2ludHMg
dG8gYSBmaWx0ZXJlZA0KPiAgICAgZW50cnkNCj4NCj4gIGtlcm5lbC1zaGFyay9DTWFrZUxpc3Rz
LnR4dCAgICAgICAgICAgICB8ICA4ICsrKystLQ0KPiAga2VybmVsLXNoYXJrL2J1aWxkL2RlZmYu
aC5jbWFrZSAgICAgICAgIHwgIDMgKysNCj4gIGtlcm5lbC1zaGFyay9idWlsZC9rcy5kZXNrdG9w
LmNtYWtlICAgICB8ICA0ICstLQ0KPiAga2VybmVsLXNoYXJrL3NyYy9DTWFrZUxpc3RzLnR4dCAg
ICAgICAgIHwgMTkgKysrKysrKy0tLS0tLQ0KPiAga2VybmVsLXNoYXJrL3NyYy9Lc0R1YWxNYXJr
ZXIuY3BwICAgICAgIHwgIDkgKysrKysrDQo+ICBrZXJuZWwtc2hhcmsvc3JjL0tzR0xXaWRnZXQu
Y3BwICAgICAgICAgfCAyNCArKysrKysrKystLS0tLS0tDQo+ICBrZXJuZWwtc2hhcmsvc3JjL0tz
R0xXaWRnZXQuaHBwICAgICAgICAgfCAgNSArKystDQo+ICBrZXJuZWwtc2hhcmsvc3JjL0tzTWFp
bldpbmRvdy5jcHAgICAgICAgfCAyMiArKysrKysrKysrKystLS0NCj4gIGtlcm5lbC1zaGFyay9z
cmMvS3NNYWluV2luZG93LmhwcCAgICAgICB8ICA0ICsrKw0KPiAga2VybmVsLXNoYXJrL3NyYy9L
c1Bsb3RUb29scy5jcHAgICAgICAgIHwgMzcgKysrKysrKysrKysrKysrKysrKysrKystLQ0KPiAg
a2VybmVsLXNoYXJrL3NyYy9Lc1Bsb3RUb29scy5ocHAgICAgICAgIHwgMTEgKysrKysrKy0NCj4g
IGtlcm5lbC1zaGFyay9zcmMvS3NUcmFjZUdyYXBoLmNwcCAgICAgICB8ICAyICsrDQo+ICBrZXJu
ZWwtc2hhcmsvc3JjL0tzVHJhY2VWaWV3ZXIuY3BwICAgICAgfCAyMiArKysrKysrKystLS0tLS0N
Cj4gIGtlcm5lbC1zaGFyay9zcmMvS3NVdGlscy5jcHAgICAgICAgICAgICB8ICA0ICstLQ0KPiAg
a2VybmVsLXNoYXJrL3NyYy9wbHVnaW5zL0NNYWtlTGlzdHMudHh0IHwgIDMgKy0NCj4gIDE1IGZp
bGVzIGNoYW5nZWQsIDEzNCBpbnNlcnRpb25zKCspLCA0MyBkZWxldGlvbnMoLSkNCg0KQWxsIHRo
ZSBuZXcgcGF0Y2hlcyBsb29rcyBnb29kIHRvIG1lLg0KDQpSZXZpZXdlZC1ieTogU2xhdm9taXIg
S2FzbGV2IDxrYXNsZXZzQHZtd2FyZS5jb20+DQoNClRoYW5rcyENCg0KLS0gU2xhdmkNCg==
