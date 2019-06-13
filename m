Return-Path: <SRS0=Le/E=UM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D5BC31E49
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C8DA20449
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:15:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="Iz3VRf6b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732241AbfFMPPH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:15:07 -0400
Received: from mail-eopbgr740042.outbound.protection.outlook.com ([40.107.74.42]:46048
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732238AbfFMN0T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 09:26:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mDOLgw7VyMnDy+6CQb70rmGb1+NQTjtBCMdBWZMLpSk=;
 b=Iz3VRf6bqLrxyDCfhFv7medZO+gNp1UB95eTTdcHRoNT+BqUBZXUSfDNg/s3Nfr+xybTkIgxUAh9ZkFcnshEQ5XFBfAN63FwAF06D24q5SPzyWt59S++dNaTHbV1/7JBzM4VgTV5a+EFQSiaAlEFmWszUi0WFLEPpve2Ytkh6Rw=
Received: from DM6PR05MB4044.namprd05.prod.outlook.com (20.176.71.154) by
 DM6PR05MB4956.namprd05.prod.outlook.com (20.177.221.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 13 Jun 2019 13:26:12 +0000
Received: from DM6PR05MB4044.namprd05.prod.outlook.com
 ([fe80::c5ce:1ccd:9894:2181]) by DM6PR05MB4044.namprd05.prod.outlook.com
 ([fe80::c5ce:1ccd:9894:2181%7]) with mapi id 15.20.1987.010; Thu, 13 Jun 2019
 13:26:12 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v6 2/2] tools/lib/traceevent: Man pages for tep plugins APIs
Thread-Topic: [PATCH v6 2/2] tools/lib/traceevent: Man pages for tep plugins
 APIs
Thread-Index: AQHVIeuRvG5chiAIhUu2X2fiqEUWqA==
Date:   Thu, 13 Jun 2019 13:26:12 +0000
Message-ID: <20190613132559.24704-2-tstoyanov@vmware.com>
References: <20190613132559.24704-1-tstoyanov@vmware.com>
In-Reply-To: <20190613132559.24704-1-tstoyanov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR09CA0111.eurprd09.prod.outlook.com
 (2603:10a6:803:78::34) To DM6PR05MB4044.namprd05.prod.outlook.com
 (2603:10b6:5:8f::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.21.0
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 452b0bcf-9682-4229-8bda-08d6f002b41f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR05MB4956;
x-ms-traffictypediagnostic: DM6PR05MB4956:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM6PR05MB49561317D37C90D27E1EFF45DCEF0@DM6PR05MB4956.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(39860400002)(346002)(396003)(199004)(189003)(1730700003)(66476007)(2351001)(2501003)(5640700003)(2906002)(73956011)(7736002)(446003)(66946007)(52116002)(66066001)(26005)(81156014)(81166006)(86362001)(11346002)(71190400001)(71200400001)(66556008)(486006)(8676002)(6486002)(305945005)(64756008)(476003)(66446008)(6436002)(316002)(2616005)(8936002)(6306002)(1076003)(4326008)(14444005)(50226002)(6506007)(6916009)(76176011)(256004)(186003)(5660300002)(6512007)(99286004)(68736007)(386003)(6116002)(102836004)(36756003)(3846002)(53936002)(25786009)(478600001)(14454004)(2004002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB4956;H:DM6PR05MB4044.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zIz0YNjJ/mcpMKEiIeD2FzmirvhJcd4GLQrk0GxlpIT0AOAQl6lrVkItlO8gE4PeowzuMQZb/C/PStwPNqpvQ0DDd2xj3+TPR7rc3pjyCCK02Mms8agpLzEnFDnYGMX6qTW9kzLLpRnuQFhpj838Y9+YkzN2e2F9lNNWy2My0/BdyFaJafs+U9hkG7/sWh3BdFf+GNz8534BEtN55Q3kfZc3KQRg10y7On4SNMr/23Ksyqr6EIEvYmLu9mv3PJEEr2vkRRxmbdxkXeYKoJC/Tkz03C6Vm3GYIaODbzlVKIBT0MTqfxVfoUcqm4xhDvcXqvsFE6uZ6mdIrXIwPGTl/7qjQ4ValGmBMIa1WjFnOfquMAtpklF1WbTKtZQXbPdHUaE/hGanBy7kiO1mNQT+KvI459TjiF8/Qbvs5e5GhDQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 452b0bcf-9682-4229-8bda-08d6f002b41f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 13:26:12.5718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tstoyanov@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB4956
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Q3JlYXRlIG1hbiBwYWdlcyBmb3IgbGlidHJhY2VldmVudCBBUElzOg0KICB0ZXBfbG9hZF9wbHVn
aW5zKCksDQogIHRlcF91bmxvYWRfcGx1Z2luKCkNCg0KU2lnbmVkLW9mZi1ieTogVHp2ZXRvbWly
IFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJlLmNvbT4NCi0tLQ0KIC4uLi9Eb2N1bWVudGF0aW9u
L2xpYnRyYWNlZXZlbnQtcGx1Z2lucy50eHQgICB8IDk4ICsrKysrKysrKysrKysrKysrKysNCiAx
IGZpbGUgY2hhbmdlZCwgOTggaW5zZXJ0aW9ucygrKQ0KIGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29s
cy9saWIvdHJhY2VldmVudC9Eb2N1bWVudGF0aW9uL2xpYnRyYWNlZXZlbnQtcGx1Z2lucy50eHQN
Cg0KZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi90cmFjZWV2ZW50L0RvY3VtZW50YXRpb24vbGlidHJh
Y2VldmVudC1wbHVnaW5zLnR4dCBiL3Rvb2xzL2xpYi90cmFjZWV2ZW50L0RvY3VtZW50YXRpb24v
bGlidHJhY2VldmVudC1wbHVnaW5zLnR4dA0KbmV3IGZpbGUgbW9kZSAxMDA2NDQNCmluZGV4IDAw
MDAwMDAwMDAwMC4uYjhjMDUyNWM3MzEyDQotLS0gL2Rldi9udWxsDQorKysgYi90b29scy9saWIv
dHJhY2VldmVudC9Eb2N1bWVudGF0aW9uL2xpYnRyYWNlZXZlbnQtcGx1Z2lucy50eHQNCkBAIC0w
LDAgKzEsOTggQEANCitsaWJ0cmFjZWV2ZW50KDMpDQorPT09PT09PT09PT09PT09PQ0KKw0KK05B
TUUNCistLS0tDQordGVwX2xvYWRfcGx1Z2lucywgdGVwX3VubG9hZF9wbHVnaW5zIC0gTG9hZCAv
IHVubG9hZCB0cmFjZWV2ZW50IHBsdWdpbnMuDQorDQorU1lOT1BTSVMNCistLS0tLS0tLQ0KK1t2
ZXJzZV0NCistLQ0KKyojaW5jbHVkZSA8ZXZlbnQtcGFyc2UuaD4qDQorDQorc3RydWN0IHRlcF9w
bHVnaW5fbGlzdCBwYXNzOlsqXSp0ZXBfbG9hZF9wbHVnaW5zKihzdHJ1Y3QgdGVwX2hhbmRsZSBw
YXNzOlsqXV90ZXBfKTsNCit2b2lkICp0ZXBfdW5sb2FkX3BsdWdpbnMqKHN0cnVjdCB0ZXBfcGx1
Z2luX2xpc3QgcGFzczpbKl1fcGx1Z2luX2xpc3RfLCBzdHJ1Y3QgdGVwX2hhbmRsZSBwYXNzOlsq
XV90ZXBfKTsNCistLQ0KKw0KK0RFU0NSSVBUSU9ODQorLS0tLS0tLS0tLS0NCitUaGUgX3RlcF9s
b2FkX3BsdWdpbnMoKV8gZnVuY3Rpb24gbG9hZHMgYWxsIHBsdWdpbnMsIGxvY2F0ZWQgaW4gdGhl
IHBsdWdpbg0KK2RpcmVjdG9yaWVzLiBUaGUgX3RlcF8gYXJndW1lbnQgaXMgdHJhY2UgZXZlbnQg
cGFyc2VyIGNvbnRleHQuDQorVGhlIHBsdWdpbiBkaXJlY3RvcmllcyBhcmUgOg0KK1t2ZXJzZV0N
CistLQ0KKwktIFN5c3RlbSdzIHBsdWdpbiBkaXJlY3RvcnksIGRlZmluZWQgYXQgdGhlIGxpYnJh
cnkgY29tcGlsZSB0aW1lLiBJdA0KKwkgIGRlcGVuZHMgb24gdGhlIGxpYnJhcnkgaW5zdGFsbGF0
aW9uIHByZWZpeCBhbmQgdXN1YWxseSBpcw0KKwkgIF8oaW5zdGFsbF9wcmVmZml4KS9saWIvdHJh
Y2VldmVudC9wbHVnaW5zXw0KKwktIERpcmVjdG9yeSwgZGVmaW5lZCBieSB0aGUgZW52aXJvbm1l
bnQgdmFyaWFibGUgX1RSQUNFRVZFTlRfUExVR0lOX0RJUl8NCisJLSBVc2VyJ3MgcGx1Z2luIGRp
cmVjdG9yeSwgbG9jYXRlZCBhdCBffi8uY29uZmlnL3RyYWNlZXZlbnQvcGx1Z2luc18NCistLQ0K
K0xvYWRpbmcgb2YgcGx1Z2lucyBjYW4gYmUgY29udHJvbGxlZCBieSB0aGUgX3RlcF9mbGFnc18s
IHVzaW5nIHRoZQ0KK190ZXBfc2V0X2ZsYWcoKV8gQVBJOg0KK1t2ZXJzZV0NCistLQ0KKwlfVEVQ
X0RJU0FCTEVfU1lTX1BMVUdJTlNfCS0gZG8gbm90IGxvYWQgcGx1Z2lucywgbG9jYXRlZCBpbg0K
KwkJCQkJdGhlIHN5c3RlbSdzIHBsdWdpbiBkaXJlY3RvcnkuDQorCV9URVBfRElTQUJMRV9QTFVH
SU5TXwkJLSBkbyBub3QgbG9hZCBhbnkgcGx1Z2lucy4NCistLQ0KK1RoZSBfdGVwX3NldF9mbGFn
KClfIEFQSSBtdXN0IGJlIGNhbGxlZCBiZWZvcmUgX3RlcF9sb2FkX3BsdWdpbnMoKV8uDQorDQor
VGhlIF90ZXBfdW5sb2FkX3BsdWdpbnMoKV8gZnVuY3Rpb24gdW5sb2FkcyB0aGUgcGx1Z2lucywg
cHJldmlvdXNseSBsb2FkZWQgYnkNCitfdGVwX2xvYWRfcGx1Z2lucygpXy4gVGhlIF90ZXBfIGFy
Z3VtZW50IGlzIHRyYWNlIGV2ZW50IHBhcnNlciBjb250ZXh0LiBUaGUNCitfcGx1Z2luX2xpc3Rf
IGlzIHRoZSBsaXN0IG9mIGxvYWRlZCBwbHVnaW5zLCByZXR1cm5lZCBieQ0KK3RoZSBfdGVwX2xv
YWRfcGx1Z2lucygpXyBmdW5jdGlvbi4NCisNCitSRVRVUk4gVkFMVUUNCistLS0tLS0tLS0tLS0N
CitUaGUgX3RlcF9sb2FkX3BsdWdpbnMoKV8gZnVuY3Rpb24gcmV0dXJucyBhIGxpc3Qgb2Ygc3Vj
Y2Vzc2Z1bGx5IGxvYWRlZCBwbHVnaW5zLA0KK29yIE5VTEwgaW4gY2FzZSBubyBwbHVnaW5zIGFy
ZSBsb2FkZWQuDQorDQorRVhBTVBMRQ0KKy0tLS0tLS0NCitbc291cmNlLGNdDQorLS0NCisjaW5j
bHVkZSA8ZXZlbnQtcGFyc2UuaD4NCisuLi4NCitzdHJ1Y3QgdGVwX2hhbmRsZSAqdGVwID0gdGVw
X2FsbG9jKCk7DQorLi4uDQorc3RydWN0IHRlcF9wbHVnaW5fbGlzdCAqcGx1Z2lucyA9IHRlcF9s
b2FkX3BsdWdpbnModGVwKTsNCitpZiAocGx1Z2lucyA9PSBOVUxMKSB7DQorCS8qIG5vIHBsdWdp
bnMgYXJlIGxvYWRlZCAqLw0KK30NCisuLi4NCit0ZXBfdW5sb2FkX3BsdWdpbnMocGx1Z2lucywg
dGVwKTsNCistLQ0KKw0KK0ZJTEVTDQorLS0tLS0NCitbdmVyc2VdDQorLS0NCisqZXZlbnQtcGFy
c2UuaCoNCisJSGVhZGVyIGZpbGUgdG8gaW5jbHVkZSBpbiBvcmRlciB0byBoYXZlIGFjY2VzcyB0
byB0aGUgbGlicmFyeSBBUElzLg0KKyotbHRyYWNlZXZlbnQqDQorCUxpbmtlciBzd2l0Y2ggdG8g
YWRkIHdoZW4gYnVpbGRpbmcgYSBwcm9ncmFtIHRoYXQgdXNlcyB0aGUgbGlicmFyeS4NCistLQ0K
Kw0KK1NFRSBBTFNPDQorLS0tLS0tLS0NCitfbGlidHJhY2VldmVudCgzKV8sIF90cmFjZS1jbWQo
MSlfLCBfdGVwX3NldF9mbGFnKDMpXw0KKw0KK0FVVEhPUg0KKy0tLS0tLQ0KK1t2ZXJzZV0NCist
LQ0KKypTdGV2ZW4gUm9zdGVkdCogPHJvc3RlZHRAZ29vZG1pcy5vcmc+LCBhdXRob3Igb2YgKmxp
YnRyYWNlZXZlbnQqLg0KKypUenZldG9taXIgU3RveWFub3YqIDx0ei5zdG95YW5vdkBnbWFpbC5j
b20+LCBhdXRob3Igb2YgdGhpcyBtYW4gcGFnZS4NCistLQ0KK1JFUE9SVElORyBCVUdTDQorLS0t
LS0tLS0tLS0tLS0NCitSZXBvcnQgYnVncyB0byAgPGxpbnV4LXRyYWNlLWRldmVsQHZnZXIua2Vy
bmVsLm9yZz4NCisNCitMSUNFTlNFDQorLS0tLS0tLQ0KK2xpYnRyYWNlZXZlbnQgaXMgRnJlZSBT
b2Z0d2FyZSBsaWNlbnNlZCB1bmRlciB0aGUgR05VIExHUEwgMi4xDQorDQorUkVTT1VSQ0VTDQor
LS0tLS0tLS0tDQoraHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvdG9ydmFsZHMvbGludXguZ2l0DQotLSANCjIuMjEuMA0KDQo=
