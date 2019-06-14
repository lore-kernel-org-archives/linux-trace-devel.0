Return-Path: <SRS0=/4Dl=UN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0437C31E4B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68E8621473
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:27:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="WbFYjabX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbfFNN1D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 09:27:03 -0400
Received: from mail-eopbgr730044.outbound.protection.outlook.com ([40.107.73.44]:17040
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728180AbfFNN1D (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 09:27:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Isl0tOfkfzbsY/mBQJkedB6QcO+48GegZEf/gwU/dw=;
 b=WbFYjabXbl65ft/M1i6BcdnqEkwTO27Oy3I78c06fKfRPMEQYdR24K7zHx7IEuQQ02/MBf9um9dUJsTgqelutzrpMnacdcfHbaPDY0FEbqzQZUbU2ylzRkzROyyA4LuG0ARgGk/xQB5EyfmsPNj+hN4XKL9T8fCmvh+cIDdOqjU=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3918.namprd05.prod.outlook.com (10.167.142.158) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.9; Fri, 14 Jun 2019 13:26:59 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c%5]) with mapi id 15.20.1987.010; Fri, 14 Jun 2019
 13:26:59 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "y.karadz@gmail.com" <y.karadz@gmail.com>,
        "troyengel@gmail.com" <troyengel@gmail.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 3/3] kernel-shark: Define a CMAKE_BUILD_TYPE "Package"
Thread-Topic: [PATCH v2 3/3] kernel-shark: Define a CMAKE_BUILD_TYPE "Package"
Thread-Index: AQHVIrTYQ8meRfx1cUeG853h2WW4hw==
Date:   Fri, 14 Jun 2019 13:26:59 +0000
Message-ID: <20190614132609.16465-4-ykaradzhov@vmware.com>
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
x-ms-office365-filtering-correlation-id: d6b8e9c4-1156-40cf-de5c-08d6f0cbfaad
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN4PR0501MB3918;
x-ms-traffictypediagnostic: SN4PR0501MB3918:
x-microsoft-antispam-prvs: <SN4PR0501MB39189AE263AC7B7D83123629A0EE0@SN4PR0501MB3918.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(39860400002)(136003)(366004)(199004)(189003)(1076003)(66066001)(486006)(2501003)(2616005)(476003)(3846002)(14444005)(6116002)(68736007)(256004)(99286004)(6916009)(66476007)(86362001)(66556008)(478600001)(64756008)(66446008)(73956011)(26005)(305945005)(66946007)(7736002)(14454004)(5660300002)(76176011)(102836004)(386003)(6506007)(52116002)(71190400001)(107886003)(36756003)(8936002)(8676002)(4326008)(71200400001)(2906002)(53936002)(25786009)(1730700003)(446003)(11346002)(5640700003)(186003)(316002)(2351001)(50226002)(81166006)(6512007)(6436002)(54906003)(6486002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3918;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8S76BfGfA13GPuZoWL8YzXAtj9BCOUs86xOKvu8Ub+QjMnfH4/6Cg9J0r86p1Kwhft6O4MoUWBszlbt12+R97dRrbOUzB+1xlM4REWCPhn7B2pRrqh0y3Pr2UbUuie3yCqGTHxCLHtg8t6iwv62Orif4rooQbvhbw03Ycl3S8M5XHpsWzvPH1x1BCDpJC69avRWQgPoG4XSeIZZPkz5jtgj5Qo9jj8GtfO/hgGxoXoExEEb45efKUVsHjDV9goQDlal4jMzLxB6jZI7pZ7Q7xi9aod5qQEhy2iNM9NLrBUKeiIGhUgc1ZdGnS3K4dUKEEShOsVekaikTUNRJqkhWwEkfsrWUm775zWcXp341fFnKBFYvutDDlGq5O67cTYVsq38Lls1DkDzBFnm2R6ZtG9vd1chMiNRKXHja83E0SqA=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D9E3B311D7BA07469F9F5EDE262F173D@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6b8e9c4-1156-40cf-de5c-08d6f0cbfaad
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 13:26:59.7268
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

A special build type dedicated for package maintainers is added.
By default this build type adds the "-O2" compiler flag. Users
can chose their own compiler flags by providing the corresponding
CMAKE_XXXX_FLAGS_PACKAGE Command-Line options.

If no type is specified, the build type will be "Debug".

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/CMakeLists.txt | 41 +++++++++++++++++++++++++------------
 kernel-shark/README         | 22 ++++++++++++++------
 2 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 87f33d6..4b58b9b 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -36,9 +36,34 @@ set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread -fPIC")
 set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=3Dc++11 -pthread -fPIC"=
)
=20
-if(NOT _INSTALL_PREFIX)
-	set(_INSTALL_PREFIX "/usr/local")
-endif()
+if (NOT CMAKE_BUILD_TYPE)
+    set(CMAKE_BUILD_TYPE Debug)
+endif (NOT CMAKE_BUILD_TYPE)
+
+message("\n Build type: ${CMAKE_BUILD_TYPE}")
+
+if (NOT CMAKE_C_FLAGS_PACKAGE)
+    set(CMAKE_C_FLAGS_PACKAGE "-O3")
+endif (NOT CMAKE_C_FLAGS_PACKAGE)
+
+if (NOT CMAKE_CXX_FLAGS_PACKAGE)
+    set(CMAKE_CXX_FLAGS_PACKAGE "-O3")
+endif (NOT CMAKE_CXX_FLAGS_PACKAGE)
+
+if (NOT _INSTALL_PREFIX)
+    set(_INSTALL_PREFIX "/usr/local")
+endif (NOT _INSTALL_PREFIX)
+
+if (CMAKE_BUILD_TYPE MATCHES Package)
+
+    set(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/")
+    set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
+
+else (CMAKE_BUILD_TYPE MATCHES Package)
+
+    set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
+
+endif (CMAKE_BUILD_TYPE MATCHES Package)
=20
 set(KS_PLUGIN_INSTALL_PREFIX ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/plugins=
/)
=20
@@ -47,16 +72,6 @@ set(KS_ICON_FIN    KS_icon_fin.svg)
 set(KS_LOGO        KS_logo_symbol.svg)
 set(KS_LOGO_LABEL  KS_logo_horizontal.svg)
=20
-if (NOT _DEBUG)
-
-	set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -O2")
-	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2")
-
-endif (NOT _DEBUG)
-
-SET(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/")
-SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
-
 include_directories(${KS_DIR}/src/
                     ${KS_DIR}/build/src/
                     ${JSONC_INCLUDE_DIR}
diff --git a/kernel-shark/README b/kernel-shark/README
index 379c390..75a0dd0 100644
--- a/kernel-shark/README
+++ b/kernel-shark/README
@@ -38,14 +38,24 @@ the original trace-cmd end traceevent libraries.
 2.1.1 In order to create a Doxygen documentation add -D_DOXYGEN_DOC=3D1
 as a CMake Command-Line option.
=20
-2.1.2 In order to generates complete debug information to be used by GDB a=
dd
--D_DEBUG=3D1 as a CMake Command-Line option.
-
-2.1.3 By default, installation prefix is "/usr/local". It can be changed u=
sing
+2.1.2 By default, installation prefix is "/usr/local". It can be changed u=
sing
 -D_INSTALL_PREFIX=3D as a CMake Command-Line option.
=20
-Example:
-    cmake -D_DOXYGEN_DOC=3D1 -D_DEBUG=3D1 -D_INSTALL_PREFIX=3D/usr ../
+2.1.3 In addition to the standard CMake build types (Debug, Release,
+RelWithDebInfo, MinSizeRel) KernelShark supports a "Package" build type.
+By default this build type adds the "-O2" compiler flag. Package maintaine=
rs
+can chose their own compiler flags by providing the corresponding
+CMAKE_XXXX_FLAGS_PACKAGE Command-Line options (see the example below).
+
+Note that when built as a "Package" the RPATH-s of the executables are
+set directly to _INSTALL_PREFIX/lib/kernelshark/
+
+If no build types is specified, the type will be "Debug".
+
+Examples:
+    cmake -D_DOXYGEN_DOC=3D1 -D_INSTALL_PREFIX=3D/usr ../
+
+    cmake -DCMAKE_BUILD_TYPE=3DPackage -DCMAKE_C_FLAGS_PACKAGE=3D"-O3 -ped=
antic"  ../
=20
 2.2.1 Use "make clean" if you want to delete all already compiled objects.
=20
--=20
2.20.1

