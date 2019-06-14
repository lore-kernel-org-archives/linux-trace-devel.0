Return-Path: <SRS0=/4Dl=UN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC02C31E4B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:27:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF66121473
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:26:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="WCdjfpAR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfFNN07 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 09:26:59 -0400
Received: from mail-eopbgr730062.outbound.protection.outlook.com ([40.107.73.62]:38304
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728187AbfFNN07 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 09:26:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yeCP2bZ9UjSP99E0Buq2pdeMng3SYnI7Ekemv0a51Ww=;
 b=WCdjfpARW1lMP8Wue2yWtYu2GEVbu2eVrBAtSqJ4pYuLYCkAjybBPAo2eaL0VnKkBpyCxFRx21RViY3HYAIxFeD20qouqZPcqJTRaBTTalnflgtKSp3FVZ/pyof3fRzTF/TBrjqBmdYFvEmRyxcsPKcQejXfn3M8wjCyLi3+aik=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3918.namprd05.prod.outlook.com (10.167.142.158) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.9; Fri, 14 Jun 2019 13:26:57 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c%5]) with mapi id 15.20.1987.010; Fri, 14 Jun 2019
 13:26:57 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "y.karadz@gmail.com" <y.karadz@gmail.com>,
        "troyengel@gmail.com" <troyengel@gmail.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 2/3] kernel-shark: Avoid TRACECMD_BIN_DIR being set to the
 build path
Thread-Topic: [PATCH v2 2/3] kernel-shark: Avoid TRACECMD_BIN_DIR being set to
 the build path
Thread-Index: AQHVIrTWT/nq4dN4kUujNmcBLDX2cg==
Date:   Fri, 14 Jun 2019 13:26:57 +0000
Message-ID: <20190614132609.16465-3-ykaradzhov@vmware.com>
References: <20190614132609.16465-1-ykaradzhov@vmware.com>
In-Reply-To: <20190614132609.16465-1-ykaradzhov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DB8P191CA0020.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:130::30) To SN4PR0501MB3903.namprd05.prod.outlook.com
 (2603:10b6:803:4d::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba437df0-e942-434a-62e4-08d6f0cbf916
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN4PR0501MB3918;
x-ms-traffictypediagnostic: SN4PR0501MB3918:
x-microsoft-antispam-prvs: <SN4PR0501MB3918CCB46545CDB668C6BF46A0EE0@SN4PR0501MB3918.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(39860400002)(136003)(366004)(199004)(189003)(1076003)(66066001)(486006)(2501003)(2616005)(476003)(3846002)(14444005)(6116002)(68736007)(256004)(99286004)(6916009)(66476007)(86362001)(66556008)(478600001)(64756008)(66446008)(73956011)(26005)(305945005)(66946007)(7736002)(14454004)(5660300002)(76176011)(102836004)(386003)(6506007)(52116002)(71190400001)(107886003)(36756003)(8936002)(8676002)(4326008)(71200400001)(2906002)(53936002)(25786009)(1730700003)(446003)(11346002)(5640700003)(186003)(316002)(2351001)(50226002)(81166006)(6512007)(6436002)(54906003)(6486002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3918;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PSaCp5F2IIYOUAw0/dlNLY/t+rhFBrN8ieacIHMSxkAN72zdoBougYvGnSIr7yJi/e/7mwRCxbqFl8AvnRKdSCTnmRyhC9fYcsiNi21M3Nysz7R+WQiKXT5guyRxuGNmfdPx340Zjw7pj+tnSX93fpsl8PlTD5QlNmbmsEc8+UfAebOaAFMiBx3b0+OEFKjsx1QXO8NwZmXXlEpELlMhdlnekyPRVoS7rknmGF+qTXALFtj/iRgQhcNk7e016eFl2/zGAmwckmzIjRJHushED3dV4T+x2Ooo2484zYXLUEWWX0wjqyQmNSvBNp/o6M10MPmCkOtGquBNqYRnURrgK7L1xqwvBZOvJ+KT5FrlezRGTdcQzjwnmTGdFaGjtsgVr4rYZcCN5QoekKN/QUS5Z+XEMAPt7RGaA/TtjXsEx6o=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <826D5B69C71EDE40B41C08D65280F292@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba437df0-e942-434a-62e4-08d6f0cbf916
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 13:26:57.0573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ykaradzhov@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3918
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The full path to the build directory (which is random for every user)
is embedded in the final binary. This is a no-no for some Linux distros
which are requiring that the finished binaries should not have such paths
embedded in them.

Reported-by: Troy Engel <troyengel@gmail.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/build/FindTraceCmd.cmake | 18 +++++++++++-------
 kernel-shark/build/deff.h.cmake       |  2 +-
 kernel-shark/src/KsCaptureDialog.cpp  |  7 +++----
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/Fin=
dTraceCmd.cmake
index 8c51f11..2da4eee 100644
--- a/kernel-shark/build/FindTraceCmd.cmake
+++ b/kernel-shark/build/FindTraceCmd.cmake
@@ -12,10 +12,14 @@
 # MESSAGE(" Looking for trace-cmd ...")
=20
 # First search in the user provided paths.
-find_path(TRACECMD_BIN_DIR      NAMES  trace-cmd
-                                PATHS  $ENV{TRACE_CMD}/tracecmd/
-                                       ${CMAKE_SOURCE_DIR}/../tracecmd/
-                                NO_DEFAULT_PATH)
+if (CMAKE_BUILD_TYPE MATCHES Debug)
+
+  find_program(TRACECMD_EXECUTABLE   NAMES  trace-cmd
+                                     PATHS  $ENV{TRACE_CMD}/tracecmd/
+                                            ${CMAKE_SOURCE_DIR}/../tracecm=
d/
+                                     NO_DEFAULT_PATH)
+
+endif (CMAKE_BUILD_TYPE MATCHES Debug)
=20
 find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h
                                 PATHS  $ENV{TRACE_CMD}/include/
@@ -34,16 +38,16 @@ find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtr=
aceevent.a
=20
 # If not found, search in the default system paths. Note that if the previ=
ous
 # search was successful "find_path" will do nothing this time.
-find_path(TRACECMD_BIN_DIR      NAMES  trace-cmd)
+find_program(TRACECMD_EXECUTABLE   NAMES  trace-cmd)
 find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h)
 find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.so)
 find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.so)
=20
-IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
+IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY AND TRACECMD_EXECUTABLE)
=20
   SET(TRACECMD_FOUND TRUE)
=20
-ENDIF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
+ENDIF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY AND TRACECMD_EXECUTABLE)
=20
 IF (TRACECMD_FOUND)
=20
diff --git a/kernel-shark/build/deff.h.cmake b/kernel-shark/build/deff.h.cm=
ake
index efee2a1..79726ff 100644
--- a/kernel-shark/build/deff.h.cmake
+++ b/kernel-shark/build/deff.h.cmake
@@ -18,7 +18,7 @@
 #cmakedefine KS_PLUGIN_INSTALL_PREFIX "@KS_PLUGIN_INSTALL_PREFIX@"
=20
 /** Location of the trace-cmd executable. */
-#cmakedefine TRACECMD_BIN_DIR "@TRACECMD_BIN_DIR@"
+#cmakedefine TRACECMD_EXECUTABLE "@TRACECMD_EXECUTABLE@"
=20
 /** "pkexec" executable. */
 #cmakedefine DO_AS_ROOT "@DO_AS_ROOT@"
diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCapt=
ureDialog.cpp
index b107595..7f8cf64 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -489,12 +489,11 @@ KsCaptureDialog::KsCaptureDialog(QWidget *parent)
 	connect(&_captureCtrl._closeButton,	&QPushButton::pressed,
 		this,				&KsCaptureDialog::close);
=20
-	if (KsUtils::isInstalled())
-		captureExe =3D QString(_INSTALL_PREFIX) + QString("/bin");
+	if (!KsUtils::isInstalled())
+		captureExe =3D QString(_INSTALL_PREFIX) + QString("/bin/trace-cmd");
 	else
-		captureExe =3D TRACECMD_BIN_DIR;
+		captureExe =3D TRACECMD_EXECUTABLE;
=20
-	captureExe +=3D "/trace-cmd";
 	_captureProc.setProgram(captureExe);
=20
 	_captureMon.connectMe(&_captureProc, &_captureCtrl);
--=20
2.20.1

