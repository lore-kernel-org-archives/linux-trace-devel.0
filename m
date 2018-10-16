Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710064.outbound.protection.outlook.com ([40.107.71.64]:54000
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727146AbeJPXoe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 19:44:34 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v2 11/23] kernel-shark-qt: Add KernelShark GUI executable.
Date: Tue, 16 Oct 2018 15:53:10 +0000
Message-ID: <20181016155232.5257-12-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181016155232.5257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

This patch adds the main executable of the KernelShark GUI.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/CMakeLists.txt  |  4 ++
 kernel-shark-qt/src/kernelshark.cpp | 93 +++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+)
 create mode 100644 kernel-shark-qt/src/kernelshark.cpp

diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMake=
Lists.txt
index d8daada..b51980f 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -63,6 +63,10 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
=20
     set_target_properties(kshark-gui PROPERTIES  SUFFIX ".so.${KS_VERSION_=
STRING}")
=20
+    message(STATUS "kernelshark")
+    add_executable(kernelshark          kernelshark.cpp)
+    target_link_libraries(kernelshark   kshark-gui)
+
 endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
=20
 add_subdirectory(plugins)
diff --git a/kernel-shark-qt/src/kernelshark.cpp b/kernel-shark-qt/src/kern=
elshark.cpp
new file mode 100644
index 0000000..2ec91de
--- /dev/null
+++ b/kernel-shark-qt/src/kernelshark.cpp
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+// C
+#include <sys/stat.h>
+#include <getopt.h>
+
+// Qt
+#include <QApplication>
+
+// KernelShark
+#include "KsCmakeDef.hpp"
+#include "KsMainWindow.hpp"
+
+#define default_input_file (char*)"trace.dat"
+
+static char *input_file;
+
+void usage(const char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -h	Display this help message\n");
+	printf("  -v	Display version and exit\n");
+	printf("  -i	input_file, default is %s\n", default_input_file);
+	printf("  -p	register plugin, use plugin name, absolute or relative path\=
n");
+	printf("  -u	unregister plugin, use plugin name or absolute path\n");
+	printf("  -s	import a session\n");
+}
+
+int main(int argc, char **argv)
+{
+	QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
+	QApplication a(argc, argv);
+
+	KsMainWindow ks;
+
+	int c;
+	bool fromSession =3D false;
+
+	while ((c =3D getopt(argc, argv, "hvi:p:u:s:")) !=3D -1) {
+		switch(c) {
+		case 'h':
+			usage(argv[0]);
+			return 0;
+
+		case 'v':
+			printf("%s - %s\n", basename(argv[0]), KS_VERSION_STRING);
+			return 0;
+
+		case 'i':
+			input_file =3D optarg;
+			break;
+
+		case 'p':
+			ks.registerPlugin(QString(optarg));
+			break;
+
+		case 'u':
+			ks.unregisterPlugin(QString(optarg));
+			break;
+
+		case 's':
+			ks.loadSession(QString(optarg));
+			fromSession =3D true;
+
+		default:
+			break;
+		}
+	}
+
+	if (!fromSession) {
+		if ((argc - optind) >=3D 1) {
+			if (input_file)
+				usage(argv[0]);
+			input_file =3D argv[optind];
+		}
+
+		if (!input_file) {
+			struct stat st;
+			if (stat(default_input_file, &st) =3D=3D 0)
+				input_file =3D default_input_file;
+		}
+
+		if (input_file)
+			ks.loadDataFile(QString(input_file));
+	}
+
+	ks.show();
+	return a.exec();
+}
--=20
2.17.1
