Return-Path: <SRS0=Le/E=UM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B09C31E45
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAEBA207E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:00:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="AyWKsJtS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732605AbfFMO7n (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 10:59:43 -0400
Received: from mail-eopbgr730058.outbound.protection.outlook.com ([40.107.73.58]:56048
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732604AbfFMOvv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 10:51:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RyRiI+qUGp70ahdhEbkcxpoyEZnBRJtEUMYtz4z/BWY=;
 b=AyWKsJtSBDECXjcM0RHmS+0GLTNIPTwCF+sLN6bRjdPP+52aZlJL1wAXAmzV65HW9+lwAqSqWEOA4hGefbPhHjyysxd/nfNUdFJgmfMZONecaVRs4CS/shMe6xM7Iql608c6siJveNfZfCUrF4conW4o6UIuBFZuVcDbDJ8foQo=
Received: from DM6PR05MB4044.namprd05.prod.outlook.com (20.176.71.154) by
 DM6PR05MB6363.namprd05.prod.outlook.com (20.178.224.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.5; Thu, 13 Jun 2019 14:51:49 +0000
Received: from DM6PR05MB4044.namprd05.prod.outlook.com
 ([fe80::c5ce:1ccd:9894:2181]) by DM6PR05MB4044.namprd05.prod.outlook.com
 ([fe80::c5ce:1ccd:9894:2181%7]) with mapi id 15.20.1987.010; Thu, 13 Jun 2019
 14:51:49 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 3/3] trace-cmd: Check the return of get_file_content()
 before calling add_reset_file()
Thread-Topic: [PATCH 3/3] trace-cmd: Check the return of get_file_content()
 before calling add_reset_file()
Thread-Index: AQHVIUuBUxEwyxKjXkqneeUGr2BsuqaZrGMA
Date:   Thu, 13 Jun 2019 14:51:48 +0000
Message-ID: <CACqStod__XjWd7sk4oz2+E-DmQEHvT1kgKvU4sR-Kew8aki-zQ@mail.gmail.com>
References: <20190612181927.608151291@goodmis.org>
 <20190612182019.169932649@goodmis.org>
In-Reply-To: <20190612182019.169932649@goodmis.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR0202CA0011.eurprd02.prod.outlook.com
 (2603:10a6:208:1::24) To DM6PR05MB4044.namprd05.prod.outlook.com
 (2603:10b6:5:8f::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAWKkGaBhBBPuF3DV1IXMjCTDzX6VPOqbpsKJPtybJR5nsWfS8BL
        rXIiPbD3ejbx7aPysoE4brW4/64k2N6CmgDBqSU=
x-google-smtp-source: APXvYqwOZ/X13O+mY+dX64ZQ6anSSu/PN8VVB19B+2ZaZMkiwHPZXuAN/6crOt8NTuY149WUHN6X+ae5Sx2JwErx6PM=
x-received: by 2002:adf:db81:: with SMTP id u1mr58319150wri.296.1560437503680;
 Thu, 13 Jun 2019 07:51:43 -0700 (PDT)
x-gmail-original-message-id: <CACqStod__XjWd7sk4oz2+E-DmQEHvT1kgKvU4sR-Kew8aki-zQ@mail.gmail.com>
x-originating-ip: [209.85.221.50]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f75331d4-0683-4a76-268d-08d6f00ea98c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR05MB6363;
x-ms-traffictypediagnostic: DM6PR05MB6363:
x-microsoft-antispam-prvs: <DM6PR05MB636326A2678488DCF01705C1DCEF0@DM6PR05MB6363.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(136003)(39860400002)(366004)(189003)(199004)(80366005)(386003)(5660300002)(229853002)(52116002)(66556008)(86362001)(68736007)(76176011)(66446008)(66476007)(66066001)(61266001)(478600001)(102836004)(64756008)(73956011)(66946007)(55446002)(71200400001)(71190400001)(95326003)(186003)(6506007)(99286004)(26005)(53546011)(6246003)(3846002)(81166006)(81156014)(6512007)(305945005)(6116002)(7736002)(476003)(486006)(53936002)(256004)(9686003)(11346002)(2906002)(498394004)(6486002)(8676002)(6436002)(61726006)(25786009)(8936002)(4326008)(14454004)(316002)(446003)(6862004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB6363;H:DM6PR05MB4044.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: v6A9A8Mzxk4WLCNkiAV7Nim/xaaOZyoWDoIantnYbTbmGdPXEd2Wp05DEtDUpoDEvawS55V5mE2SazYX/UJTNjubdQEVFFTcGRBcf7vFeEPi8tVw2ZZ6YihnCzNkF5wkBmlJzOfaY96G6PiVjaYumcjajkmDU0yuiiCyXZdnnEKwV/PmyjmY3AIl+3i7tpJwSuAv44JZ+508hFp/DoV1JAzd5zmewLhLZZ0mLgh4rDKqum9MaENbb0A/593pH0VzScr/58/0lGx0cIYN4h6rbSpfKlp+0Pbfczm+LGNUYVOh9ffdNhnQMkkDMlzxIm1QAdS0RVpOzRAwd3+6QsPU4M4r5HL9mISl/s0+3kyAWhcvqKIi9GsD18iEaxdkizd/sKJaMdGfnTCWB1OVIceRsMrhfnJkQ0ecCIgKem2bJQM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <693A1E5DFE491145BE65CD41FDAEFF80@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f75331d4-0683-4a76-268d-08d6f00ea98c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 14:51:48.8444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tstoyanov@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB6363
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCBKdW4gMTIsIDIwMTkgYXQgOToxOSBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IEZyb206ICJTdGV2ZW4gUm9zdGVkdCAoVk13YXJlKSIg
PHJvc3RlZHRAZ29vZG1pcy5vcmc+DQo+DQo+IElmIGdldF9maWxlX2NvbnRlbnQoKSByZXR1cm5z
IE5VTEwsIGJlY2F1c2UgdGhlIGZpbGUgZG9lcyBub3QgZXhpc3Qgb3IgZm9yDQo+IGFueSBvdGhl
ciByZWFzb24sIGl0IHdpbGwgY2F1c2UgYWRkX3Jlc2V0X2ZpbGUoKSB0byB0cmlnZ2VyIGEgU0VH
U0VHViBkdWUgdG8NCj4gdXNpbmcgYSBOVUxMIHBvaW50ZXIuIE9ubHkgY2FsbCBhZGRfcmVzZXRf
ZmlsZSgpIGlmIGdldF9maWxlX2NvbnRlbnQoKQ0KPiBhY3R1YWxseSByZXR1cm5zIHNvbWV0aGlu
Zy4NCj4NCj4gU2lnbmVkLW9mZi1ieTogU3RldmVuIFJvc3RlZHQgKFZNd2FyZSkgPHJvc3RlZHRA
Z29vZG1pcy5vcmc+DQo+IC0tLQ0KDQpMb29rcyBPSy4NClJldmlld2VkLWJ5OiBUenZldG9taXIg
U3RveWFub3YgPHRzdG95YW5vdkB2bXdhcmUuY29tPg0KDQoNCj4gIHRyYWNlY21kL3RyYWNlLXJl
Y29yZC5jIHwgNiArKysrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS90cmFjZWNtZC90cmFjZS1yZWNvcmQuYyBi
L3RyYWNlY21kL3RyYWNlLXJlY29yZC5jDQo+IGluZGV4IDJkNzE2YTgxYWNiZi4uNWRjNmYxN2Fh
NzQzIDEwMDY0NA0KPiAtLS0gYS90cmFjZWNtZC90cmFjZS1yZWNvcmQuYw0KPiArKysgYi90cmFj
ZWNtZC90cmFjZS1yZWNvcmQuYw0KPiBAQCAtMjcwLDggKzI3MCwxMCBAQCBzdGF0aWMgdm9pZCBy
ZXNldF9zYXZlX2ZpbGUoY29uc3QgY2hhciAqZmlsZSwgaW50IHByaW8pDQo+ICAgICAgICAgY2hh
ciAqY29udGVudDsNCj4NCj4gICAgICAgICBjb250ZW50ID0gZ2V0X2ZpbGVfY29udGVudChmaWxl
KTsNCj4gLSAgICAgICBhZGRfcmVzZXRfZmlsZShmaWxlLCBjb250ZW50LCBwcmlvKTsNCj4gLSAg
ICAgICBmcmVlKGNvbnRlbnQpOw0KPiArICAgICAgIGlmIChjb250ZW50KSB7DQo+ICsgICAgICAg
ICAgICAgICBhZGRfcmVzZXRfZmlsZShmaWxlLCBjb250ZW50LCBwcmlvKTsNCj4gKyAgICAgICAg
ICAgICAgIGZyZWUoY29udGVudCk7DQo+ICsgICAgICAgfQ0KPiAgfQ0KPg0KPiAgLyoNCj4gLS0N
Cj4gMi4yMC4xDQo+DQo+DQoNCg0KLS0NCg0KVHp2ZXRvbWlyIChDZWNvKSBTdG95YW5vdg0KVk13
YXJlIE9wZW4gU291cmNlIFRlY2hub2xvZ3kgQ2VudGVyDQo=
