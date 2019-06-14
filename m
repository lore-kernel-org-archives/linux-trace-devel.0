Return-Path: <SRS0=/4Dl=UN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5745DC31E4B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F90820850
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:51:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="1aPxnHQU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbfFNNvY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 09:51:24 -0400
Received: from mail-eopbgr740080.outbound.protection.outlook.com ([40.107.74.80]:58880
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727922AbfFNNvX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 09:51:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xi6jJEzBQ4rRzKV1pJ9YZsCk1q4ArOLtdBUXB7BfjJE=;
 b=1aPxnHQU/h0kkrxbN9qA5fJqk903SLyWSaiNKDnXG+xG5TDEzN4FfEKK0TavJid3iqazZH649lmXlXB4ldSNQPXOFhPsvWqOuNrVryeyftpMuLM0kvUn+bwIYAgtAbM/YX3kqjmZcnagiEnkrAKihuYNTXQYM+AHmdcN2f/cpt8=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3776.namprd05.prod.outlook.com (10.167.141.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Fri, 14 Jun 2019 13:51:18 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c%5]) with mapi id 15.20.1987.010; Fri, 14 Jun 2019
 13:51:18 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 1/3] kernel-shark: Fix a bug when plotting the last trace
 record
Thread-Topic: [PATCH v2 1/3] kernel-shark: Fix a bug when plotting the last
 trace record
Thread-Index: AQHVIrg9qFsnkSyWOkmuog2EgEAXgA==
Date:   Fri, 14 Jun 2019 13:51:18 +0000
Message-ID: <20190614135045.17223-2-ykaradzhov@vmware.com>
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
x-ms-office365-filtering-correlation-id: 87e9f7a9-fdf8-4281-c60f-08d6f0cf6031
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN4PR0501MB3776;
x-ms-traffictypediagnostic: SN4PR0501MB3776:
x-microsoft-antispam-prvs: <SN4PR0501MB377668C4A3BAFAA96775D4F0A0EE0@SN4PR0501MB3776.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(346002)(136003)(366004)(396003)(199004)(189003)(26005)(478600001)(186003)(25786009)(386003)(6506007)(305945005)(53936002)(52116002)(102836004)(73956011)(76176011)(50226002)(66066001)(66946007)(6486002)(6436002)(68736007)(81166006)(107886003)(14454004)(1730700003)(66476007)(66556008)(81156014)(2351001)(8676002)(2906002)(64756008)(6512007)(66446008)(8936002)(36756003)(4326008)(5640700003)(54906003)(2616005)(476003)(11346002)(486006)(5660300002)(1076003)(71200400001)(7736002)(71190400001)(316002)(446003)(6116002)(99286004)(3846002)(86362001)(2501003)(256004)(14444005)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3776;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OhU77DY+077WXWQ8QcNAz7DAHQAkTJpzZ1IvEfP5uT6/KYpuvK4nzOMPi1fDc+STLgqcDlaPMqCGuOgl1/oKg00N+sy1tUxI2SJDYICSxzgGNov87y8zmFARgHqE75EhsYxYuEFSHyTPKMPFaw9E8EU5ajSIS7tb+qdr70HE16SUeWGNb77xNHXTFVW5ZAB4a+mj6E7j1eORP8We1/LUmxx+MWWswTpy302uYx2xzsQhI1lizMWGLXrL3CBamiKdEexFWBWNeH/AUndo/+UVtx3BmDA9Ry9THdxqH5Y3xBU8uiXHNosgqO5oP5cJUYlo8emzzO2C4jWNR0RBq8t7IyVxQw5iR5vSp/tyf7v1HWaFZHIBTwepu2tmmm5sCCs1GI117NrLX0FHp0nj1EZd6b55LLirko9biBB7ZSen0bo=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <299EE68D652F1B4EB4DC96DDDE8F67CC@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e9f7a9-fdf8-4281-c60f-08d6f0cf6031
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 13:51:18.5203
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

On a first glance this patch may looks like reverting commit
9336dd6bcd38 (kernel-shark: Fix a bug in ksmodel_set_next_bin_edge())

The point is that for the last bin we want to increment its upper edge
used  when checking if the bin is empty, but we do not want to touch
the lower edge time used by kshark_find_entry_by_time().

Fixes: 9336dd6bcd38 (kernel-shark: Fix a bug in ksmodel_set_next_bin_edge()=
)
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-model.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshar=
k-model.c
index 978cd70..0cac924 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -260,20 +260,30 @@ static size_t ksmodel_set_upper_edge(struct kshark_tr=
ace_histo *histo)
 static void ksmodel_set_next_bin_edge(struct kshark_trace_histo *histo,
 				      size_t bin, size_t last_row)
 {
-	size_t time, next_bin =3D bin + 1;
+	size_t time_min, time_max, next_bin =3D bin + 1;
 	ssize_t row;
=20
-	/* Calculate the beginning of the next bin. */
-	time =3D histo->min + next_bin * histo->bin_size;
+	/* Calculate the beginning and the end of the next bin. */
+	time_min =3D histo->min + next_bin * histo->bin_size;
+	time_max =3D time_min + histo->bin_size;
+	/*
+	 * The timestamp of the very last entry of the dataset can be exactly
+	 * equal to the value of the upper edge of the range. This is very
+	 * likely to happen when we use ksmodel_set_in_range_bining(). In this
+	 * case we have to increase the size of the very last bin in order to
+	 * make sure that the last entry of the dataset will fall into it.
+	 */
+	if (next_bin =3D=3D histo->n_bins - 1)
+		++time_max;
=20
 	/*
 	 * Find the index of the first entry inside
-	 * the next bin (timestamp > time).
+	 * the next bin (timestamp > time_min).
 	 */
-	row =3D kshark_find_entry_by_time(time, histo->data, last_row,
+	row =3D kshark_find_entry_by_time(time_min, histo->data, last_row,
 					histo->data_size - 1);
=20
-	if (row < 0 || histo->data[row]->ts >=3D time + histo->bin_size) {
+	if (row < 0 || histo->data[row]->ts >=3D time_max) {
 		/* The bin is empty. */
 		histo->map[next_bin] =3D KS_EMPTY_BIN;
 		return;
--=20
2.20.1

