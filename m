Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-bn3nam01on0067.outbound.protection.outlook.com ([104.47.33.67]:34715
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727242AbeJPXoZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 19:44:25 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v2 16/23] kernel-shark-qt: Instruct CMake to search for
 "pkexec"
Date: Tue, 16 Oct 2018 15:53:16 +0000
Message-ID: <20181016155232.5257-17-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181016155232.5257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

CMake will search for "pkexec" and if it is found will add a line

to the CMake-generated header file.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/build/deff.h.cmake | 3 +++
 kernel-shark-qt/src/CMakeLists.txt | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/kernel-shark-qt/build/deff.h.cmake b/kernel-shark-qt/build/def=
f.h.cmake
index d1a1bb7..80d624c 100644
--- a/kernel-shark-qt/build/deff.h.cmake
+++ b/kernel-shark-qt/build/deff.h.cmake
@@ -20,6 +20,9 @@
 /** Location of the trace-cmd executable. */
 #cmakedefine TRACECMD_BIN_DIR "@TRACECMD_BIN_DIR@"
=20
+/** "pkexec" executable. */
+#cmakedefine DO_AS_ROOT "@DO_AS_ROOT@"
+
 #ifdef __cplusplus
=20
 	#include <QString>
diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMake=
Lists.txt
index 3b47ce1..6819f86 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -77,5 +77,7 @@ endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
=20
 add_subdirectory(plugins)
=20
+find_program(DO_AS_ROOT pkexec)
+
 configure_file( ${KS_DIR}/build/deff.h.cmake
                 ${KS_DIR}/src/KsCmakeDef.hpp)
--=20
2.17.1
