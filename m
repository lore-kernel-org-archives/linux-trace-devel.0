Return-Path: <SRS0=MeYK=SF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E9BC4360F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Apr 2019 13:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6040A2084C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Apr 2019 13:14:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="KcPbggAu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfDCNOo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 09:14:44 -0400
Received: from mail-eopbgr810088.outbound.protection.outlook.com ([40.107.81.88]:18464
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725959AbfDCNOn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 09:14:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQZdqvsSmheYji+6Xu2GNg7SiJqWXgmgM6XdnUwJ9ZY=;
 b=KcPbggAuqUSs15TFbpvz3B+xTwTZOAWoPgDMuHlh6zKrkiksi3BaK9ibbXaMfeMGVHhXt0/LIDWQFH6zu8OecfRakEoc4OnRmfL++eLpLLhlJCncY2JzmF7MM39J9HnOWLaEfshf0KhCTDy5fvNQYrScQxyjsEAIwyEGGGdEZVk=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3884.namprd05.prod.outlook.com (10.167.173.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.9; Wed, 3 Apr 2019 13:14:39 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41%5]) with mapi id 15.20.1771.007; Wed, 3 Apr 2019
 13:14:39 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [RFC PATCH v9 01/11] trace-cmd: Make ports unsigned int
Thread-Topic: [RFC PATCH v9 01/11] trace-cmd: Make ports unsigned int
Thread-Index: AQHU6h0v5jTpRRLCYk23wXZAp3jzEaYqaiYA
Date:   Wed, 3 Apr 2019 13:14:39 +0000
Message-ID: <f6688daaea66596a5696f0e5e7ad7e8ae772823b.camel@vmware.com>
References: <20190402134540.32321-1-kaslevs@vmware.com>
         <20190402134540.32321-2-kaslevs@vmware.com>
         <20190403090002.75119b51@gandalf.local.home>
In-Reply-To: <20190403090002.75119b51@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca16a3ee-6684-4a85-f992-08d6b8365424
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0501MB3884;
x-ms-traffictypediagnostic: MWHPR0501MB3884:
x-microsoft-antispam-prvs: <MWHPR0501MB38845D41B12743A90A065136DA570@MWHPR0501MB3884.namprd05.prod.outlook.com>
x-forefront-prvs: 0996D1900D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(376002)(366004)(396003)(346002)(54094003)(189003)(199004)(26005)(76176011)(6116002)(5640700003)(3846002)(2501003)(6506007)(36756003)(229853002)(86362001)(6436002)(6486002)(97736004)(102836004)(105586002)(6512007)(106356001)(68736007)(2906002)(316002)(118296001)(7736002)(6916009)(8676002)(81156014)(1730700003)(66066001)(2616005)(71200400001)(305945005)(81166006)(5660300002)(11346002)(8936002)(476003)(25786009)(14454004)(446003)(478600001)(2351001)(99286004)(71190400001)(256004)(486006)(4744005)(186003)(4326008)(6246003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3884;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:3;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3jQR5EYXP0DYZyuCfCCfjPrJY6FLNILJVuKly2nsJNae38DQ/FlbuyOCHJS2/H0WlriCvs9jBXYoPW6nMvkJdyiVvjIUOnFd/+DdgMs7Zbw/3dYxN4Hk9OpM7YQyemgSqYm3GWTwzmtslL6XZqweOpQqRuNk8kKlHwykTJfRF2lIzOiwW+Vc1MUT25/slwvdJqEfrM4+AYMbLoQ7uU3ZBD8nRo8BYNqe7Nr9ebJvotV5wSjA2ccZnL+kMjtbu39imEJ5oPY9giMSauwfe1qdW+yPBDtlfKHYr3tUnO6utIBII5/Xbj0A5M6Eary7K1x0q6ZN1Pyi+B4/oXYi+rCgE5dRyp4bDwG+NpVI6WrjwsN19C1eEhgw7ZC7Pe/hnIqrUJt+SyGUfohNKCeWXsJaxo3dux6NmGlNduIuhpBdfOA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DDD15208E0CAEF4F8E6A2CDCB7D2B621@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca16a3ee-6684-4a85-f992-08d6b8365424
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2019 13:14:39.7576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3884
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCAyMDE5LTA0LTAzIGF0IDA5OjAwIC0wNDAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gT24gVHVlLCAgMiBBcHIgMjAxOSAxNjo0NTozMCArMDMwMA0KPiBTbGF2b21pciBLYXNsZXYg
PGthc2xldnNAdm13YXJlLmNvbT4gd3JvdGU6DQo+IA0KPiA+IC1zdGF0aWMgaW50IHdyaXRlX2lu
dHMoY2hhciAqYnVmLCBzaXplX3QgYnVmX2xlbiwgaW50ICphcnIsIGludA0KPiA+IGFycl9sZW4p
DQo+ID4gK3N0YXRpYyB1bnNpZ25lZCBpbnQgYXRvdShjb25zdCBjaGFyICpzKQ0KPiA+ICt7DQo+
ID4gKwlsb25nIHI7DQo+ID4gKw0KPiA+ICsJciA9IGF0b2wocyk7DQo+ID4gKwlpZiAociA+PSAw
ICYmIHIgPD0gVUlOVF9NQVgpDQo+ID4gKwkJcmV0dXJuIHI7DQo+ID4gKw0KPiA+ICsJcmV0dXJu
IDA7DQo+ID4gK30NCj4gPiArDQo+IA0KPiBJIHdvbmRlciBpZiB3ZSBzaG91bGQgZG8gdGhpcyBp
bnN0ZWFkOg0KPiANCj4gLyogdGVzdCBhIHRvIHUgKi8NCj4gc3RhdGljIGludCB0YXRvdShjb25z
dCBjaGFyICpzLCBpbnQgKnJlcykNCj4gew0KPiAJbG9uZyByOw0KPiANCj4gCXIgPSBhdG9sKHMp
Ow0KPiAJaWYgKHIgPj0gMCAmJiByIDw9IFVJTlRfTUFYKSB7DQo+IAkJKnJlcyA9ICh1bnNpZ25l
ZClyOw0KPiAJCXJldHVybiAwOw0KPiAJfQ0KPiAJcmV0dXJuIC0xOw0KPiB9DQoNCk1ha2VzIHNl
bnNlLiBJIGRpZCBjb25zaWRlciBpdCB3aGlsZSB3cml0aW5nIHRoaXMgYnV0IGRlY2lkZWQgdG8g
Z28NCndpdGggdGhlIHRyYWRpdGlvbmFsICJicm9rZW4iIHByb3RvdHlwZSBmb3Igc3VjaCBmdW5j
dGlvbnMuDQo=
