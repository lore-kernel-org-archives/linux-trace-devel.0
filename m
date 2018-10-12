Return-Path: <SRS0=pqkA=MY=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr680056.outbound.protection.outlook.com ([40.107.68.56]:3297
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728800AbeJLXrj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Oct 2018 19:47:39 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 10/10] kernel-shark-qt: Add KernelShark GUI executable.
Date: Fri, 12 Oct 2018 19:13:18 +0300
Message-Id: <20181012161318.5302-11-ykaradzhov@vmware.com>
In-Reply-To: <20181012161318.5302-1-ykaradzhov@vmware.com>
References: <20181012161318.5302-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
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

diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMakeLists.txt
index d8daada..b51980f 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -63,6 +63,10 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
     set_target_properties(kshark-gui PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
 
+    message(STATUS "kernelshark")
+    add_executable(kernelshark          kernelshark.cpp)
+    target_link_libraries(kernelshark   kshark-gui)
+
 endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
 add_subdirectory(plugins)
diff --git a/kernel-shark-qt/src/kernelshark.cpp b/kernel-shark-qt/src/kernelshark.cpp
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
+	printf("  -p	register plugin, use plugin name, absolute or relative path\n");
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
+	bool fromSession = false;
+
+	while ((c = getopt(argc, argv, "hvi:p:u:s:")) != -1) {
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
+			input_file = optarg;
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
+			fromSession = true;
+
+		default:
+			break;
+		}
+	}
+
+	if (!fromSession) {
+		if ((argc - optind) >= 1) {
+			if (input_file)
+				usage(argv[0]);
+			input_file = argv[optind];
+		}
+
+		if (!input_file) {
+			struct stat st;
+			if (stat(default_input_file, &st) == 0)
+				input_file = default_input_file;
+		}
+
+		if (input_file)
+			ks.loadDataFile(QString(input_file));
+	}
+
+	ks.show();
+	return a.exec();
+}
-- 
2.17.1
