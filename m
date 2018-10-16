Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-bn3nam01on0067.outbound.protection.outlook.com ([104.47.33.67]:34715
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726778AbeJPXoW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 19:44:22 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v2 15/23] kernel-shark-qt: Add kshark-record executable
Date: Tue, 16 Oct 2018 15:53:14 +0000
Message-ID: <20181016155232.5257-16-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181016155232.5257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

kshark-record provides a simple GUI (dialog) used to generate command line
arguments for trace-cmd and to record trace data.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/CMakeLists.txt    |  4 ++++
 kernel-shark-qt/src/kshark-record.cpp | 29 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)
 create mode 100644 kernel-shark-qt/src/kshark-record.cpp

diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMake=
Lists.txt
index 3c9e1bf..3b47ce1 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -69,6 +69,10 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
     add_executable(kernelshark          kernelshark.cpp)
     target_link_libraries(kernelshark   kshark-gui)
=20
+    message(STATUS "kshark-record")
+    add_executable(kshark-record        kshark-record.cpp)
+    target_link_libraries(kshark-record kshark-gui)
+
 endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
=20
 add_subdirectory(plugins)
diff --git a/kernel-shark-qt/src/kshark-record.cpp b/kernel-shark-qt/src/ks=
hark-record.cpp
new file mode 100644
index 0000000..7d10469
--- /dev/null
+++ b/kernel-shark-qt/src/kshark-record.cpp
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+// C
+#include <unistd.h>
+
+// KernelShark
+#include "KsCaptureDialog.hpp"
+
+int main(int argc, char **argv)
+{
+	QApplication a(argc, argv);
+	KsCaptureDialog cd;
+
+	int c;
+	while ((c =3D getopt(argc, argv, "o:")) !=3D -1) {
+		switch(c) {
+		case 'o':
+			cd.setOutputFileName(QString(optarg));
+			break;
+		}
+	}
+
+	cd.show();
+	return a.exec();
+}
--=20
2.17.1
