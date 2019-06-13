Return-Path: <SRS0=Le/E=UM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D884EC31E4A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1C7520B7C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:15:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="bcUm1SYm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732238AbfFMPPI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:15:08 -0400
Received: from mail-eopbgr740042.outbound.protection.outlook.com ([40.107.74.42]:46048
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732236AbfFMN0Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 09:26:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJNBNHjVef7TvKX/EBaFfbbaOndrQ3zt+OS49/Uel8A=;
 b=bcUm1SYmtMPWYKRoPzHHmKRfD0nUxzfiqNY4mCDXV1LpnsBf30H6KrkKoCFpQJzzC3l2Xms1ktKPm1oXfGcuebt81Ldwbj1UXwYwZOdJlOVKUQURIch5QV5BGVs0IK/9ukslNF1KG7/DxtvGd0BBb0i1DtAZno4pSkTTSmzVvBg=
Received: from DM6PR05MB4044.namprd05.prod.outlook.com (20.176.71.154) by
 DM6PR05MB4956.namprd05.prod.outlook.com (20.177.221.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 13 Jun 2019 13:26:11 +0000
Received: from DM6PR05MB4044.namprd05.prod.outlook.com
 ([fe80::c5ce:1ccd:9894:2181]) by DM6PR05MB4044.namprd05.prod.outlook.com
 ([fe80::c5ce:1ccd:9894:2181%7]) with mapi id 15.20.1987.010; Thu, 13 Jun 2019
 13:26:11 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v6 1/2] tools/lib/traceevent: Man pages for libtraceevent
 event print related API
Thread-Topic: [PATCH v6 1/2] tools/lib/traceevent: Man pages for libtraceevent
 event print related API
Thread-Index: AQHVIeuRqhEX7Ws5vUa2cvLklTGNog==
Date:   Thu, 13 Jun 2019 13:26:11 +0000
Message-ID: <20190613132559.24704-1-tstoyanov@vmware.com>
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
x-ms-office365-filtering-correlation-id: 14fb3c45-6817-42da-21a4-08d6f002b352
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR05MB4956;
x-ms-traffictypediagnostic: DM6PR05MB4956:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM6PR05MB495652BB7CD8CAAE32F6B160DCEF0@DM6PR05MB4956.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(39860400002)(346002)(396003)(199004)(189003)(1730700003)(66476007)(2351001)(2501003)(5640700003)(2906002)(73956011)(7736002)(66946007)(52116002)(66066001)(26005)(81156014)(81166006)(86362001)(71190400001)(71200400001)(66556008)(486006)(8676002)(6486002)(305945005)(64756008)(476003)(66446008)(6436002)(316002)(2616005)(8936002)(6306002)(1076003)(4326008)(14444005)(50226002)(6506007)(6916009)(256004)(186003)(5660300002)(6512007)(99286004)(68736007)(386003)(6116002)(102836004)(36756003)(3846002)(53936002)(25786009)(478600001)(14454004)(2004002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB4956;H:DM6PR05MB4044.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: trFx+z2orozTzb7fILFlijwdl0X0hQx1Vlq0OMk+06KzpY8VKYbfdEK02xwCrTKJ0Krpvz9hzR1XmBTGjya8+P//Z1yl6VOU5sFgvT2y1t8OXv0B8xtUHqrrf6XgYp8qfaOkAtswEUYCVMiXzt0SRIt5LJ68pBf4MwunkyAwcJdamP7FoVgQcX/BE6sXxcGvLOtFRBuN84QN2eqnx0h3eMML6ONqONnO3DArpdhvrH1bbtZA9cdY/e2zx1wSA6ScvFhKDpsKn7DIYvhdIoiWe+s0wJ5Qu5jii2o/YfFCur15jmBggIXXlIDA+fGBDLusHYk0hPqoZpiAp39jmFr+LVQ/E4Vpk40gdq2Lmqdz2UIcKt8bZUQ0CftAVq8RQV5t7yPp7MnEafL5wkLxwluovDyLjRPRHn9ZiRlUq9h1klA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14fb3c45-6817-42da-21a4-08d6f002b352
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 13:26:11.3665
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

QWRkZWQgbmV3IG1hbiBwYWdlLCBkZXNjcmliaW5nIHRlcF9wcmludF9ldmVudCgpIGxpYnRyYWNl
ZXZlbnQgQVBJLg0KDQpTaWduZWQtb2ZmLWJ5OiBUenZldG9taXIgU3RveWFub3YgPHRzdG95YW5v
dkB2bXdhcmUuY29tPg0KLS0tDQogLi4uL2xpYnRyYWNlZXZlbnQtZXZlbnRfcHJpbnQudHh0ICAg
ICAgICAgICAgIHwgMTMwICsrKysrKysrKysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCAxMzAg
aW5zZXJ0aW9ucygrKQ0KIGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy9saWIvdHJhY2VldmVudC9E
b2N1bWVudGF0aW9uL2xpYnRyYWNlZXZlbnQtZXZlbnRfcHJpbnQudHh0DQoNCmRpZmYgLS1naXQg
YS90b29scy9saWIvdHJhY2VldmVudC9Eb2N1bWVudGF0aW9uL2xpYnRyYWNlZXZlbnQtZXZlbnRf
cHJpbnQudHh0IGIvdG9vbHMvbGliL3RyYWNlZXZlbnQvRG9jdW1lbnRhdGlvbi9saWJ0cmFjZWV2
ZW50LWV2ZW50X3ByaW50LnR4dA0KbmV3IGZpbGUgbW9kZSAxMDA2NDQNCmluZGV4IDAwMDAwMDAw
MDAwMC4uZGRiZjk5YjljNjYxDQotLS0gL2Rldi9udWxsDQorKysgYi90b29scy9saWIvdHJhY2Vl
dmVudC9Eb2N1bWVudGF0aW9uL2xpYnRyYWNlZXZlbnQtZXZlbnRfcHJpbnQudHh0DQpAQCAtMCww
ICsxLDEzMCBAQA0KK2xpYnRyYWNlZXZlbnQoMykNCis9PT09PT09PT09PT09PT09DQorDQorTkFN
RQ0KKy0tLS0NCit0ZXBfcHJpbnRfZXZlbnQgLSBXcml0ZXMgZXZlbnQgaW5mb3JtYXRpb24gaW50
byBhIHRyYWNlIHNlcXVlbmNlLg0KKw0KK1NZTk9QU0lTDQorLS0tLS0tLS0NCitbdmVyc2VdDQor
LS0NCisqI2luY2x1ZGUgPGV2ZW50LXBhcnNlLmg+Kg0KKyojaW5jbHVkZSA8dHJhY2Utc2VxLmg+
Kg0KKw0KK3ZvaWQgKnRlcF9wcmludF9ldmVudCooc3RydWN0IHRlcF9oYW5kbGUgcGFzczpbKl1f
dGVwXywgc3RydWN0IHRyYWNlX3NlcXBhc3M6WypdX3NfLCBzdHJ1Y3QgdGVwX3JlY29yZCBwYXNz
OlsqXV9yZWNvcmRfLCBjb25zdCBjaGFyIHBhc3M6WypdX2ZtdF8sIF8uLi5fKQ0KKy0tDQorDQor
REVTQ1JJUFRJT04NCistLS0tLS0tLS0tLQ0KKw0KK1RoZSBfdGVwX3ByaW50X2V2ZW50KClfIGZ1
bmN0aW9uIHBhcnNlcyB0aGUgZXZlbnQgaW5mb3JtYXRpb24gb2YgdGhlIGdpdmVuDQorX3JlY29y
ZF8gYW5kIHdyaXRlcyBpdCBpbnRvIHRoZSB0cmFjZSBzZXF1ZW5jZSBfc18sIGFjY29yZGluZyB0
byB0aGUgZm9ybWF0DQorc3RyaW5nIF9mbXRfLiBUaGUgZGVzaXJlZCBpbmZvcm1hdGlvbiBpcyBz
cGVjaWZpZWQgYWZ0ZXIgdGhlIGZvcm1hdCBzdHJpbmcuDQorVGhlIF9mbXRfIGlzIHByaW50Zi1s
aWtlIGZvcm1hdCBzdHJpbmcsIGZvbGxvd2luZyBhcmd1bWVudHMgYXJlIHN1cHBvcnRlZDoNCitb
dmVyc2VdDQorLS0NCisJVEVQX1BSSU5UX1BJRCwgIiVkIiAgLSBQSUQgb2YgdGhlIGV2ZW50Lg0K
KwlURVBfUFJJTlRfQ1BVLCAiJWQiICAtIEV2ZW50IENQVS4NCisJVEVQX1BSSU5UX0NPTU0sICIl
cyIgLSBFdmVudCBjb21tYW5kIHN0cmluZy4NCisJVEVQX1BSSU5UX05BTUUsICIlcyIgLSBFdmVu
dCBuYW1lLg0KKwlURVBfUFJJTlRfTEFURU5DWSwgIiVzIiAtIExhdGVuY3kgb2YgdGhlIGV2ZW50
LiBJdCBwcmludHMgNCBvciBtb3JlDQorCQkJZmllbGRzIC0gaW50ZXJydXB0IHN0YXRlLCBzY2hl
ZHVsaW5nIHN0YXRlLA0KKwkJCWN1cnJlbnQgY29udGV4dCwgYW5kIHByZWVtcHRpb24gY291bnQu
DQorCQkJRmllbGQgMSBpcyB0aGUgaW50ZXJydXB0IGVuYWJsZWQgc3RhdGU6DQorCQkJCWQgOiBJ
bnRlcnJ1cHRzIGFyZSBkaXNhYmxlZA0KKwkJCQkuIDogSW50ZXJydXB0cyBhcmUgZW5hYmxlZA0K
KwkJCQlYIDogVGhlIGFyY2hpdGVjdHVyZSBkb2VzIG5vdCBzdXBwb3J0IHRoaXMNCisJCQkJICAg
IGluZm9ybWF0aW9uDQorCQkJRmllbGQgMiBpcyB0aGUgIm5lZWQgcmVzY2hlZCIgc3RhdGUuDQor
CQkJCU4gOiBUaGUgdGFzayBpcyBzZXQgdG8gY2FsbCB0aGUgc2NoZWR1bGVyIHdoZW4NCisJCQkJ
ICAgIHBvc3NpYmxlLCBhcyBhbm90aGVyIGhpZ2hlciBwcmlvcml0eSB0YXNrDQorCQkJCSAgICBt
YXkgbmVlZCB0byBiZSBzY2hlZHVsZWQgaW4uDQorCQkJCS4gOiBUaGUgdGFzayBpcyBub3Qgc2V0
IHRvIGNhbGwgdGhlIHNjaGVkdWxlci4NCisJCQlGaWVsZCAzIGlzIHRoZSBjb250ZXh0IHN0YXRl
Lg0KKwkJCQkuIDogTm9ybWFsIGNvbnRleHQNCisJCQkJcyA6IFNvZnQgaW50ZXJydXB0IGNvbnRl
eHQNCisJCQkJaCA6IEhhcmQgaW50ZXJydXB0IGNvbnRleHQNCisJCQkJSCA6IEhhcmQgaW50ZXJy
dXB0IGNvbnRleHQgd2hpY2ggdHJpZ2dlcmVkDQorCQkJCSAgICBkdXJpbmcgc29mdCBpbnRlcnJ1
cHQgY29udGV4dC4NCisJCQkJeiA6IE5NSSBjb250ZXh0DQorCQkJCVogOiBOTUkgY29udGV4dCB3
aGljaCB0cmlnZ2VyZWQgZHVyaW5nIGhhcmQNCisJCQkJICAgIGludGVycnVwdCBjb250ZXh0DQor
CQkJRmllbGQgNCBpcyB0aGUgcHJlZW1wdGlvbiBjb3VudC4NCisJCQkJLiA6IFRoZSBwcmVlbXB0
IGNvdW50IGlzIHplcm8uDQorCQkJT24gcHJlZW1wdGlibGUga2VybmVscyAod2hlcmUgdGhlIHRh
c2sgY2FuIGJlIHNjaGVkdWxlZA0KKwkJCW91dCBpbiBhcmJpdHJhcnkgbG9jYXRpb25zIHdoaWxl
IGluIGtlcm5lbCBjb250ZXh0KSwgdGhlDQorCQkJcHJlZW1wdCBjb3VudCwgd2hlbiBub24gemVy
bywgd2lsbCBwcmV2ZW50IHRoZSBrZXJuZWwNCisJCQlmcm9tIHNjaGVkdWxpbmcgb3V0IHRoZSBj
dXJyZW50IHRhc2suIFRoZSBwcmVlbXB0IGNvdW50DQorCQkJbnVtYmVyIGlzIGRpc3BsYXllZCB3
aGVuIGl0IGlzIG5vdCB6ZXJvLg0KKwkJCURlcGVuZGluZyBvbiB0aGUga2VybmVsLCBpdCBtYXkg
c2hvdyBvdGhlciBmaWVsZHMNCisJCQkobG9jayBkZXB0aCwgb3IgbWlncmF0aW9uIGRpc2FibGVk
LCB3aGljaCBhcmUgdW5pcXVlIHRvDQorCQkJc3BlY2lhbGl6ZWQga2VybmVscykuDQorCVRFUF9Q
UklOVF9USU1FLCAlZCAtIGV2ZW50IHRpbWUgc3RhbXAuIEEgZGl2aXNvciBhbmQgcHJlY2lzaW9u
IGNhbiBiZQ0KKwkJCXNwZWNpZmllZCBhcyBwYXJ0IG9mIHRoaXMgZm9ybWF0IHN0cmluZzoNCisJ
CQkiJXByZWNpc2lvbi5kaXZpc29yZCIuIEV4YW1wbGU6DQorCQkJIiUzLjEwMDBkIiAtIGRpdmlk
ZSB0aGUgdGltZSBieSAxMDAwIGFuZCBwcmludCB0aGUgZmlyc3QNCisJCQkzIGRpZ2l0cyBiZWZv
cmUgdGhlIGRvdC4gVGh1cywgdGhlIHRpbWUgc3RhbXANCisJCQkiMTIzNDU2MDAwIiB3aWxsIGJl
IHByaW50ZWQgYXMgIjEyMy40NTYiDQorCVRFUF9QUklOVF9JTkZPLCAiJXMiIC0gZXZlbnQgaW5m
b3JtYXRpb24uIElmIGFueSB3aWR0aCBpcyBzcGVjaWZpZWQgaW4NCisJCQl0aGUgZm9ybWF0IHN0
cmluZywgdGhlIGV2ZW50IGluZm9ybWF0aW9uIHdpbGwgYmUNCisJCQlwcmludGVkIGluIHJhdyBm
b3JtYXQuDQorLS0NCitFWEFNUExFDQorLS0tLS0tLQ0KK1tzb3VyY2UsY10NCistLQ0KKyNpbmNs
dWRlIDxldmVudC1wYXJzZS5oPg0KKyNpbmNsdWRlIDx0cmFjZS1zZXEuaD4NCisuLi4NCitzdHJ1
Y3QgdHJhY2Vfc2VxIHNlcTsNCit0cmFjZV9zZXFfaW5pdCgmc2VxKTsNCitzdHJ1Y3QgdGVwX2hh
bmRsZSAqdGVwID0gdGVwX2FsbG9jKCk7DQorLi4uDQordm9pZCBwcmludF9teV9ldmVudChzdHJ1
Y3QgdGVwX3JlY29yZCAqcmVjb3JkKQ0KK3sNCisJdHJhY2Vfc2VxX3Jlc2V0KCZzZXEpOw0KKwl0
ZXBfcHJpbnRfZXZlbnQodGVwLCBzLCByZWNvcmQsICIlMTZzLSUtNWQgWyUwM2RdICVzICU2LjEw
MDBkICVzICVzIiwNCisJCQlURVBfUFJJTlRfQ09NTSwgVEVQX1BSSU5UX1BJRCwgVEVQX1BSSU5U
X0NQVSwNCisJCQlURVBfUFJJTlRfTEFURU5DWSwgVEVQX1BSSU5UX1RJTUUsIFRFUF9QUklOVF9O
QU1FLA0KKwkJCVRFUF9QUklOVF9JTkZPKTsNCit9DQorLi4uDQorLS0NCisNCitGSUxFUw0KKy0t
LS0tDQorW3ZlcnNlXQ0KKy0tDQorKmV2ZW50LXBhcnNlLmgqDQorCUhlYWRlciBmaWxlIHRvIGlu
Y2x1ZGUgaW4gb3JkZXIgdG8gaGF2ZSBhY2Nlc3MgdG8gdGhlIGxpYnJhcnkgQVBJcy4NCisqdHJh
Y2Utc2VxLmgqDQorCUhlYWRlciBmaWxlIHRvIGluY2x1ZGUgaW4gb3JkZXIgdG8gaGF2ZSBhY2Nl
c3MgdG8gdHJhY2Ugc2VxdWVuY2VzIHJlbGF0ZWQgQVBJcy4NCisJVHJhY2Ugc2VxdWVuY2VzIGFy
ZSB1c2VkIHRvIGFsbG93IGEgZnVuY3Rpb24gdG8gY2FsbCBzZXZlcmFsIG90aGVyIGZ1bmN0aW9u
cw0KKwl0byBjcmVhdGUgYSBzdHJpbmcgb2YgZGF0YSB0byB1c2UuDQorKi1sdHJhY2VldmVudCoN
CisJTGlua2VyIHN3aXRjaCB0byBhZGQgd2hlbiBidWlsZGluZyBhIHByb2dyYW0gdGhhdCB1c2Vz
IHRoZSBsaWJyYXJ5Lg0KKy0tDQorDQorU0VFIEFMU08NCistLS0tLS0tLQ0KK19saWJ0cmFjZWV2
ZW50KDMpXywgX3RyYWNlLWNtZCgxKV8NCisNCitBVVRIT1INCistLS0tLS0NCitbdmVyc2VdDQor
LS0NCisqU3RldmVuIFJvc3RlZHQqIDxyb3N0ZWR0QGdvb2RtaXMub3JnPiwgYXV0aG9yIG9mICps
aWJ0cmFjZWV2ZW50Ki4NCisqVHp2ZXRvbWlyIFN0b3lhbm92KiA8dHouc3RveWFub3ZAZ21haWwu
Y29tPiwgYXV0aG9yIG9mIHRoaXMgbWFuIHBhZ2UuDQorLS0NCitSRVBPUlRJTkcgQlVHUw0KKy0t
LS0tLS0tLS0tLS0tDQorUmVwb3J0IGJ1Z3MgdG8gIDxsaW51eC10cmFjZS1kZXZlbEB2Z2VyLmtl
cm5lbC5vcmc+DQorDQorTElDRU5TRQ0KKy0tLS0tLS0NCitsaWJ0cmFjZWV2ZW50IGlzIEZyZWUg
U29mdHdhcmUgbGljZW5zZWQgdW5kZXIgdGhlIEdOVSBMR1BMIDIuMQ0KKw0KK1JFU09VUkNFUw0K
Ky0tLS0tLS0tLQ0KK2h0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwv
Z2l0L3RvcnZhbGRzL2xpbnV4LmdpdA0KLS0gDQoyLjIxLjANCg0K
