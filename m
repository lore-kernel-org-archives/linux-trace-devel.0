Return-Path: <SRS0=/4Dl=UN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CEB8C31E4B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E69F320850
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:51:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="aUc4mYYK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbfFNNvZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 09:51:25 -0400
Received: from mail-eopbgr740080.outbound.protection.outlook.com ([40.107.74.80]:58880
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728669AbfFNNvZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 09:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjHFxpsMkBgKgX3RWkgiIBJwJ5QU+m1aMhGR9yG5ZaE=;
 b=aUc4mYYK3P4CNPBk8+5PI4FgbjGXMVzyjDLIHwgIh4hBs4ocQJu/AMY0h1aPbWgQNkoL2KEUpLNag1ITISImeW3whKi5OVwUQgrr/F6uEOmwwyRl0JXKg8GdHcaO2B9/eBnssBR21uEDQlIMx4qP6GQs7X87H/Owut+W21tu/d8=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3776.namprd05.prod.outlook.com (10.167.141.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Fri, 14 Jun 2019 13:51:21 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c%5]) with mapi id 15.20.1987.010; Fri, 14 Jun 2019
 13:51:21 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Alan Mikhak <alanmikhak@gmail.com>
Subject: [PATCH v2 2/3] kernel-shark: Always use 64 bit variables for
 timestamps.
Thread-Topic: [PATCH v2 2/3] kernel-shark: Always use 64 bit variables for
 timestamps.
Thread-Index: AQHVIrg/67Or2OkgMUSl0XfK/lALJw==
Date:   Fri, 14 Jun 2019 13:51:20 +0000
Message-ID: <20190614135045.17223-3-ykaradzhov@vmware.com>
References: <20190614135045.17223-1-ykaradzhov@vmware.com>
In-Reply-To: <20190614135045.17223-1-ykaradzhov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DB6P190CA0012.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:2f::25)
 To SN4PR0501MB3903.namprd05.prod.outlook.com (2603:10b6:803:4d::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 503b80ad-5745-424e-68f5-08d6f0cf6183
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN4PR0501MB3776;
x-ms-traffictypediagnostic: SN4PR0501MB3776:
x-microsoft-antispam-prvs: <SN4PR0501MB3776787FB61258B305488331A0EE0@SN4PR0501MB3776.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(346002)(136003)(366004)(396003)(199004)(189003)(26005)(478600001)(186003)(25786009)(386003)(6506007)(305945005)(53936002)(52116002)(102836004)(73956011)(76176011)(50226002)(66066001)(66946007)(6486002)(6436002)(68736007)(81166006)(14454004)(1730700003)(66476007)(66556008)(81156014)(2351001)(8676002)(2906002)(64756008)(6512007)(66446008)(8936002)(36756003)(4326008)(5640700003)(54906003)(2616005)(476003)(11346002)(486006)(5660300002)(1076003)(71200400001)(7736002)(71190400001)(316002)(446003)(6116002)(99286004)(3846002)(86362001)(2501003)(256004)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3776;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uO4uFMg6emLhZhjCZWVvTW382n9nH28J2H1c1MUagymq1fAMb2COqryByav4qvObX2W6ASrmrPh66TaUZqye6onZUVKHejH3TvKJPw4NeBA6I8cXAkMdrAh+rSXO5pZXkhjLU4W5u64kJcmOSCJsdCsiLFg6NZCv4pLgcUBk4OTz1bvRs6IQbrQPISqZGfaH7QT1rt4oJE4w3+4ktHZiVkArAaeLuXcMubUvgLkLb8g065ZospQ1vZeTxLuu0q0a1qzE6k1dICdtUvF2/w7sk0p12/elKlzR4Zkxe3SiKsG/khdOFs8oMfr2yU3ZDGsto9JIIIaL9KB1s015ImoENkObuuCEd8SW54EHBPV0DHqqZLQTNbw10ICOcDWycTckKtyTXlOz9b0fFQkQy5i5Z9d/OjUnrqxAnmb8oG7+nWI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CAFCC8027D367E44879F6092F76E8406@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 503b80ad-5745-424e-68f5-08d6f0cf6183
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 13:51:20.7750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ykaradzhov@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3776
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All time stamps of the trace records are coded with 64 bits, however
on some systems the size_t type can be 32 bits.

Reported-by: Alan Mikhak <alanmikhak@gmail.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-model.c | 7 ++++---
 kernel-shark/src/libkshark-model.h | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshar=
k-model.c
index 0cac924..18f9c69 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -260,7 +260,8 @@ static size_t ksmodel_set_upper_edge(struct kshark_trac=
e_histo *histo)
 static void ksmodel_set_next_bin_edge(struct kshark_trace_histo *histo,
 				      size_t bin, size_t last_row)
 {
-	size_t time_min, time_max, next_bin =3D bin + 1;
+	uint64_t time_min, time_max;
+	size_t next_bin =3D bin + 1;
 	ssize_t row;
=20
 	/* Calculate the beginning and the end of the next bin. */
@@ -601,9 +602,9 @@ void ksmodel_shift_backward(struct kshark_trace_histo *=
histo, size_t n)
  * @param histo: Input location for the model descriptor.
  * @param ts: position in time to be visualized.
  */
-void ksmodel_jump_to(struct kshark_trace_histo *histo, size_t ts)
+void ksmodel_jump_to(struct kshark_trace_histo *histo, uint64_t ts)
 {
-	size_t min, max, range_min;
+	uint64_t min, max, range_min;
=20
 	if (ts > histo->min && ts < histo->max) {
 		/*
diff --git a/kernel-shark/src/libkshark-model.h b/kernel-shark/src/libkshar=
k-model.h
index 95c30b6..47793b1 100644
--- a/kernel-shark/src/libkshark-model.h
+++ b/kernel-shark/src/libkshark-model.h
@@ -89,7 +89,7 @@ void ksmodel_shift_forward(struct kshark_trace_histo *his=
to, size_t n);
=20
 void ksmodel_shift_backward(struct kshark_trace_histo *histo, size_t n);
=20
-void ksmodel_jump_to(struct kshark_trace_histo *histo, size_t ts);
+void ksmodel_jump_to(struct kshark_trace_histo *histo, uint64_t ts);
=20
 void ksmodel_zoom_out(struct kshark_trace_histo *histo,
 		      double r, int mark);
--=20
2.20.1

