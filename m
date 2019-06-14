Return-Path: <SRS0=/4Dl=UN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F99AC31E4B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AD3120850
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:51:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="N/39bgwi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfFNNvb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 09:51:31 -0400
Received: from mail-eopbgr770042.outbound.protection.outlook.com ([40.107.77.42]:53892
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728239AbfFNNva (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 09:51:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YvkPkRN+qDakYbW28IDF+CmCPjGyRYG1bOmdPYc/t08=;
 b=N/39bgwi99dycy7tXkBzMU+ZZmlkh2tTVTTUp4FTKZqaT2hbI6DDZxAjPSCqeCUQ2UXhnyMuL+FN7vVr5FKGEdDlFsjQm90D5ONvYgS6bFiO85TB4VSc+pecpAHkrvAlWVFov6ZrU7JTlBn09wA19tKX6cdbki8sVx7AfKc+Q/U=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3776.namprd05.prod.outlook.com (10.167.141.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Fri, 14 Jun 2019 13:51:23 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c%5]) with mapi id 15.20.1987.010; Fri, 14 Jun 2019
 13:51:23 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Alan Mikhak <alanmikhak@gmail.com>
Subject: [PATCH v2 3/3] kernel-shark: Fix all warnings when building on 32 bit
 systems
Thread-Topic: [PATCH v2 3/3] kernel-shark: Fix all warnings when building on
 32 bit systems
Thread-Index: AQHVIrhAzN+GJnvWF02wC+wct2bLxw==
Date:   Fri, 14 Jun 2019 13:51:23 +0000
Message-ID: <20190614135045.17223-4-ykaradzhov@vmware.com>
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
x-ms-office365-filtering-correlation-id: c567bf05-b5c3-4bcc-04e1-08d6f0cf62fb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN4PR0501MB3776;
x-ms-traffictypediagnostic: SN4PR0501MB3776:
x-microsoft-antispam-prvs: <SN4PR0501MB37765C7515B82A61F1D01517A0EE0@SN4PR0501MB3776.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:71;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(346002)(136003)(366004)(396003)(199004)(189003)(26005)(478600001)(186003)(25786009)(386003)(6506007)(305945005)(53936002)(52116002)(102836004)(73956011)(76176011)(50226002)(66066001)(66946007)(6486002)(6436002)(68736007)(81166006)(14454004)(1730700003)(66476007)(66556008)(81156014)(2351001)(8676002)(2906002)(64756008)(6512007)(66446008)(8936002)(36756003)(4326008)(5640700003)(54906003)(2616005)(476003)(11346002)(486006)(5660300002)(1076003)(71200400001)(7736002)(71190400001)(316002)(446003)(6116002)(99286004)(3846002)(86362001)(2501003)(256004)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3776;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +oSHfSmG9LqR+ALq+VoHSkszRCohss6n9ooEuljIVUWuJKUzg+HAM2hJiLT8uJe2Ha6CgQaExdJZd+caNUUck4AJh2pILIrZMqlOFAG4TNLol6UihXpRce7bgQNORmi1IdZoeW+LjetuwX7LYj6MY3l/b56zcri5Xdo6KPS9Tb4xkfjY6anyRKz48xsSnpqk/M6ceGYx6DU5gViqzgnL3/OIuhtCayvLAWoQwIQfnOMlAy4HTYbGhkxEp21yfxogJyl9ghK921UWXc0+dMCFY5mcLyQJ9aDh0FvUDpY+zxl0NUs9I1tEKdahdjNx7pW/WICNHonIzfdwXhhLS6ou3Bc53JM1sSe0YwTXKUpsR7KkghJl7FFGmKusil4LuBb4jF2U6DdIvPhI9ZkN2D5Nia8zIaC50ie7Mpnx9q0xEuE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C4C1836071A23D40B05D56174573C2B3@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c567bf05-b5c3-4bcc-04e1-08d6f0cf62fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 13:51:23.2086
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

Fixing warnings coming from:
../examples/datahisto.c
../src/KsTraceGraph.cpp
../src/libkshark.c

Reported-by: Alan Mikhak <alanmikhak@gmail.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/examples/datahisto.c |  4 ++--
 kernel-shark/src/KsTraceGraph.cpp | 10 +++++-----
 kernel-shark/src/libkshark.c      |  4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel-shark/examples/datahisto.c b/kernel-shark/examples/data=
histo.c
index 02c6285..b177b08 100644
--- a/kernel-shark/examples/datahisto.c
+++ b/kernel-shark/examples/datahisto.c
@@ -56,11 +56,11 @@ void dump_bin(struct kshark_trace_histo *histo, int bin=
,
 		puts ("EMPTY BIN");
 	} else {
 		entry_str =3D kshark_dump_entry(e_front);
-		printf("%li -> %s\n", i_front, entry_str);
+		printf("%zd -> %s\n", i_front, entry_str);
 		free(entry_str);
=20
 		entry_str =3D kshark_dump_entry(e_back);
-		printf("%li -> %s\n", i_back, entry_str);
+		printf("%zd -> %s\n", i_back, entry_str);
 		free(entry_str);
 	}
=20
diff --git a/kernel-shark/src/KsTraceGraph.cpp b/kernel-shark/src/KsTraceGr=
aph.cpp
index da2c6aa..324f36e 100644
--- a/kernel-shark/src/KsTraceGraph.cpp
+++ b/kernel-shark/src/KsTraceGraph.cpp
@@ -277,7 +277,7 @@ void KsTraceGraph::_resetPointer(uint64_t ts, int cpu, =
int pid)
 	QString pointer;
=20
 	kshark_convert_nano(ts, &sec, &usec);
-	pointer.sprintf("%lu.%06lu", sec, usec);
+	pointer.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
 	_labelP2.setText(pointer);
=20
 	if (pid > 0 && cpu >=3D 0) {
@@ -313,7 +313,7 @@ void KsTraceGraph::_setPointerInfo(size_t i)
 	uint64_t sec, usec;
=20
 	kshark_convert_nano(e->ts, &sec, &usec);
-	pointer.sprintf("%lu.%06lu", sec, usec);
+	pointer.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
 	_labelP2.setText(pointer);
=20
 	comm.append("-");
@@ -601,17 +601,17 @@ void KsTraceGraph::_updateTimeLegends()
 	QString tMin, tMid, tMax;
=20
 	kshark_convert_nano(_glWindow.model()->histo()->min, &sec, &usec);
-	tMin.sprintf("%lu.%06lu", sec, usec);
+	tMin.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
 	_labelXMin.setText(tMin);
=20
 	tsMid =3D (_glWindow.model()->histo()->min +
 		 _glWindow.model()->histo()->max) / 2;
 	kshark_convert_nano(tsMid, &sec, &usec);
-	tMid.sprintf("%lu.%06lu", sec, usec);
+	tMid.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
 	_labelXMid.setText(tMid);
=20
 	kshark_convert_nano(_glWindow.model()->histo()->max, &sec, &usec);
-	tMax.sprintf("%lu.%06lu", sec, usec);
+	tMax.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
 	_labelXMax.setText(tMax);
 }
=20
diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 0f0a1ba..9aaf1b7 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -1423,7 +1423,7 @@ char* kshark_dump_custom_entry(struct kshark_context =
*kshark_ctx,
 	event_name =3D info_func(kshark_ctx, entry, false);
 	info =3D info_func(kshark_ctx, entry, true);
=20
-	size =3D asprintf(&entry_str, "%li; %s-%i; CPU %i; ; %s; %s",
+	size =3D asprintf(&entry_str, "%" PRIu64 "; %s-%i; CPU %i; ; %s; %s",
 			entry->ts,
 			task,
 			entry->pid,
@@ -1472,7 +1472,7 @@ char* kshark_dump_entry(const struct kshark_entry *en=
try)
 		event_name =3D event? event->name : "[UNKNOWN EVENT]";
 		lat =3D kshark_get_latency(kshark_ctx->pevent, data);
=20
-		size =3D asprintf(&temp_str, "%li; %s-%i; CPU %i; %s;",
+		size =3D asprintf(&temp_str, "%" PRIu64 "; %s-%i; CPU %i; %s;",
 				entry->ts,
 				task,
 				entry->pid,
--=20
2.20.1

