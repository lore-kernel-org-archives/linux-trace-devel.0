Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14C8C10F03
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 11:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7F0820693
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 11:49:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="Z0LieZDp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732252AbfCVLtd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 07:49:33 -0400
Received: from mail-eopbgr750071.outbound.protection.outlook.com ([40.107.75.71]:11938
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731958AbfCVLtc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 07:49:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjhVI/3NHW9oe1O9bCiaDQaxvAPJdIKRKQtvNVk0R+E=;
 b=Z0LieZDpx2CoW8hprrJAm3JisQ3+x2rHlgNfL/B2sEFyZrKq2ZQ6Kmm0dSLbPeoVi/VKWzvMg/vKSTYIcJ1sWqCEESkciBqYje7xRWRVHA/DSKWpfLl0gLCXY/BEAu7hIKmlTnwx6tu5IPHX/YZpnlFU3rFb+34Q+KIGF+ZtrZw=
Received: from CY1PR05MB2780.namprd05.prod.outlook.com (10.167.18.26) by
 CY1PR05MB2666.namprd05.prod.outlook.com (10.167.11.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.13; Fri, 22 Mar 2019 11:49:29 +0000
Received: from CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f]) by CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f%9]) with mapi id 15.20.1730.003; Fri, 22 Mar 2019
 11:49:29 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Have tracecmd_msg_data_send() return zero on
 zero size
Thread-Topic: [PATCH] trace-cmd: Have tracecmd_msg_data_send() return zero on
 zero size
Thread-Index: AQHU4D+dXLMmhMdlIEynrVvJxQ17d6YXihuA
Date:   Fri, 22 Mar 2019 11:49:29 +0000
Message-ID: <66ec4786aecc3585081b932ab96b700f13f78d96.camel@vmware.com>
References: <20190321194127.4ac47d99@gandalf.local.home>
In-Reply-To: <20190321194127.4ac47d99@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba6835a5-6c83-4ab0-fd49-08d6aebc7130
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2666;
x-ms-traffictypediagnostic: CY1PR05MB2666:
x-microsoft-antispam-prvs: <CY1PR05MB26667B823904FE3ECD8800B4DA430@CY1PR05MB2666.namprd05.prod.outlook.com>
x-forefront-prvs: 09840A4839
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(366004)(136003)(346002)(396003)(199004)(189003)(5660300002)(316002)(478600001)(2616005)(99286004)(68736007)(305945005)(26005)(2906002)(7736002)(3846002)(186003)(2501003)(25786009)(256004)(486006)(446003)(102836004)(11346002)(476003)(71200400001)(71190400001)(86362001)(6116002)(6506007)(53936002)(118296001)(6246003)(76176011)(66066001)(14454004)(81166006)(8676002)(81156014)(8936002)(97736004)(6436002)(110136005)(105586002)(106356001)(6486002)(6512007)(229853002)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2666;H:CY1PR05MB2780.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2aUjBeZoZdfF5JWxmVYlyff5811HhaiGW3YLqBjK1pAePgwmdVCNGGCrYicbZQ5Mrl2sRbGRIIrioOCVd3kcTZ38UmVBTGTLwK+1OVtH+twfSWRDtmNglGWHv7BjRujABo1RTLMFK+F/30y/22cVy+sPFdc9fE51eeOMz71CndJtrgrJEhlLSewjDYK41VqlFTTEotlsFVEGlEyXgaIQmQR6Pj6/xZH83VtDGGiPN2N+PMuN17FqiVVKp7kfQ5x1CwhdcbCYUopbDWxmGm5/1n27I3v0fIQfRt7DiI/DqAHehOHbuLkhK4PDTWCqmTzs7dFpyAAnUWGUYw5ICMw7iRl9f04sA/Gf44joVsrP5DT7kyCph/WivnisZUuu65Ov7NgoQdP+CkE7ojcucoWsl8KtoNri0zNX+pvhklYp7eU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2029E30B1E70F842B23F95F6E8FED12C@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba6835a5-6c83-4ab0-fd49-08d6aebc7130
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2019 11:49:29.4293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2666
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVGh1LCAyMDE5LTAzLTIxIGF0IDE5OjQxIC0wNDAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gRnJvbTogIlN0ZXZlbiBSb3N0ZWR0IChWTXdhcmUpIiA8cm9zdGVkdEBnb29kbWlzLm9yZz4N
Cj4gDQo+IElmIHRyYWNlY21kX21zZ19kYXRhX3NlbmQoKSBpcyBwYXNzZWQgYSBzaXplIG9mIHpl
cm8sIHRoZSBsb29wIGlzIG5vdA0KPiBlbnRlcmVkLCBub3RoaW5nIGlzIHNlbnQsIGJ1dCB0aGUg
cmV0IHZhcmlhYmxlIGlzIG5vdCBpbml0aWFsaXplZCBhbmQNCj4gZ2FyYmFnZSBjYW4gYmUgc2Vu
dCBvdXQuIFRoZSBvcHRpb24gY29kZSBjYW4gY2FsbCB0aGlzIHdpdGggYSBzaXplIG9mDQo+IHpl
cm8sDQo+IHdoaWNoIGNhbiBjYXVzZSBhbiBlcnJvciByZXBvcnQuDQo+IA0KPiBKdXN0IGRvbid0
IGRvIGFueXRoaW5nIGluIHRoaXMgY2FzZSwgYW5kIHJldHVybiBhIHN1Y2Nlc3MuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBTdGV2ZW4gUm9zdGVkdCAoVk13YXJlKSA8cm9zdGVkdEBnb29kbWlzLm9y
Zz4NCj4gLS0tDQo+ICB0cmFjZWNtZC90cmFjZS1tc2cuYyB8IDQgKysrKw0KPiAgMSBmaWxlIGNo
YW5nZWQsIDQgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3RyYWNlY21kL3RyYWNl
LW1zZy5jIGIvdHJhY2VjbWQvdHJhY2UtbXNnLmMNCj4gaW5kZXggNTFkMGFjOGIuLjM4MmJkNzY2
IDEwMDY0NA0KPiAtLS0gYS90cmFjZWNtZC90cmFjZS1tc2cuYw0KPiArKysgYi90cmFjZWNtZC90
cmFjZS1tc2cuYw0KPiBAQCAtNTkwLDYgKzU5MCwxMCBAQCBpbnQgdHJhY2VjbWRfbXNnX2RhdGFf
c2VuZChzdHJ1Y3QNCj4gdHJhY2VjbWRfbXNnX2hhbmRsZSAqbXNnX2hhbmRsZSwNCj4gIAlpbnQg
cmV0Ow0KPiAgCWludCBjb3VudCA9IDA7DQo+ICANCj4gKwkvKiBEb24ndCBib3RoZXIgZG9pbmcg
YW55dGhpbmcgaWYgdGhlcmUncyBub3RoaW5nIHRvIGRvICovDQo+ICsJaWYgKCFzaXplKQ0KPiAr
CQlyZXR1cm4gMDsNCj4gKw0KPiAgCXRyYWNlY21kX21zZ19pbml0KE1TR19TRU5EX0RBVEEsICZt
c2cpOw0KPiAgDQo+ICAJbXNnLmJ1ZiA9IG1hbGxvYyhNU0dfTUFYX0RBVEFfTEVOKTsNCg0KTmlj
ZSBjYXRjaC4gRGVmaW5pdGVseSBhIGxhdGVudCBidWcgd2FpdGluZyBmb3Igc29tZW9uZSB0byBz
dGVwIG9uIGl0Lg0KDQpSZXZpZXdlZC1ieTogU2xhdm9taXIgS2FzbGV2IDxrYXNsZXZzQHZtd2Fy
ZS5jb20+DQoNCi0tIFNsYXZpDQo=
