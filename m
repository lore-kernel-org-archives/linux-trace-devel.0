Return-Path: <SRS0=tdNt=MX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr680085.outbound.protection.outlook.com ([40.107.68.85]:53760
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730510AbeJLAZw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Oct 2018 20:25:52 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v3 4/4] kernel-shark-qt: Add widget demo example.
Date: Thu, 11 Oct 2018 16:57:43 +0000
Message-ID: <20181011165713.15257-5-ykaradzhov@vmware.com>
References: <20181011165713.15257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181011165713.15257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

This patch introduces a basic example, showing how to use KsUtils and
KsWidgetsLib.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/examples/CMakeLists.txt |   4 +
 kernel-shark-qt/examples/widgetdemo.cpp | 158 ++++++++++++++++++++++++
 2 files changed, 162 insertions(+)
 create mode 100644 kernel-shark-qt/examples/widgetdemo.cpp

diff --git a/kernel-shark-qt/examples/CMakeLists.txt b/kernel-shark-qt/exam=
ples/CMakeLists.txt
index 0c83293..e16216e 100644
--- a/kernel-shark-qt/examples/CMakeLists.txt
+++ b/kernel-shark-qt/examples/CMakeLists.txt
@@ -19,3 +19,7 @@ target_link_libraries(confio   kshark)
 message(STATUS "dataplot")
 add_executable(dplot          dataplot.cpp)
 target_link_libraries(dplot   kshark-plot)
+
+message(STATUS "widgetdemo")
+add_executable(widgetdemo          widgetdemo.cpp)
+target_link_libraries(widgetdemo   kshark-gui)
diff --git a/kernel-shark-qt/examples/widgetdemo.cpp b/kernel-shark-qt/exam=
ples/widgetdemo.cpp
new file mode 100644
index 0000000..73049bf
--- /dev/null
+++ b/kernel-shark-qt/examples/widgetdemo.cpp
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+// C
+#include <sys/stat.h>
+#include <getopt.h>
+#include <unistd.h>
+
+// C++
+#include <iostream>
+
+// Qt
+#include <QtWidgets>
+
+// KernelShark
+#include "KsUtils.hpp"
+#include "KsWidgetsLib.hpp"
+
+#define default_input_file (char*)"trace.dat"
+
+static char *input_file =3D nullptr;
+
+using namespace std;
+
+void usage(const char *prog)
+{
+	cout << "Usage: " << prog << endl
+	     << "  -h	Display this help message\n"
+	     << "  -v	Display version and exit\n"
+	     << "  -i	input_file, default is " << default_input_file << endl
+	     << "  -p	register plugin, use plugin name, absolute or relative path=
\n"
+	     << "  -u	unregister plugin, use plugin name or absolute path\n";
+}
+
+struct TaskPrint : public QObject
+{
+	tep_handle	*_pevent;
+
+	void print(QVector<int> pids)
+	{
+		for (auto const &pid: pids)
+			cout << "task: "
+			     << tep_data_comm_from_pid(_pevent, pid)
+			     << "  pid: " << pid << endl;
+	}
+};
+
+int main(int argc, char **argv)
+{
+	kshark_context *kshark_ctx(nullptr);
+	QApplication a(argc, argv);
+	KsPluginManager plugins;
+	KsDataStore data;
+	size_t nRows(0);
+	int c;
+
+	if (!kshark_instance(&kshark_ctx))
+		return 1;
+
+	while ((c =3D getopt(argc, argv, "hvi:p:u:")) !=3D -1) {
+		switch(c) {
+		case 'v':
+			printf("kshark-gui %s\n", KS_VERSION_STRING);
+			return 0;
+
+		case 'i':
+			input_file =3D optarg;
+			break;
+
+		case 'p':
+			plugins.registerPlugin(QString(optarg));
+			break;
+
+		case 'u':
+			plugins.unregisterPlugin(QString(optarg));
+			break;
+
+		case 'h':
+			usage(argv[0]);
+			return 0;
+		}
+	}
+
+	if (!input_file) {
+			struct stat st;
+			if (stat(default_input_file, &st) =3D=3D 0)
+				input_file =3D default_input_file;
+	}
+
+	if (input_file) {
+		data.loadDataFile(input_file);
+		nRows =3D data.size();
+	} else {
+		cerr << "No input file is provided.\n";
+	}
+
+	cout << nRows << " entries loaded\n";
+
+	auto lamPrintPl =3D [&]()
+	{
+		kshark_plugin_list *pl;
+		for (pl =3D kshark_ctx->plugins; pl; pl =3D pl->next)
+			cout << pl->file << endl;
+	};
+
+	cout << "\n\n";
+	lamPrintPl();
+	sleep(1);
+
+	QVector<bool> registeredPlugins;
+	QStringList pluginsList;
+
+	pluginsList << plugins._ksPluginList
+		    << plugins._userPluginList;
+
+	registeredPlugins << plugins._registeredKsPlugins
+			  << plugins._registeredUserPlugins;
+
+	KsCheckBoxWidget *pluginCBD
+		=3D new KsPluginCheckBoxWidget(pluginsList);
+
+	pluginCBD->set(registeredPlugins);
+
+	KsCheckBoxDialog *dialog1 =3D new KsCheckBoxDialog(pluginCBD);
+	QObject::connect(dialog1,	&KsCheckBoxDialog::apply,
+			&plugins,	&KsPluginManager::updatePlugins);
+
+	dialog1->show();
+	a.exec();
+
+	cout << "\n\nYou selected\n";
+	lamPrintPl();
+	sleep(1);
+
+	if (!nRows)
+		return 1;
+
+	KsCheckBoxWidget *tasks_cbd =3D
+		new KsTasksCheckBoxWidget(data.tep(), true);
+
+	tasks_cbd->setDefault(false);
+
+	TaskPrint p;
+	p._pevent =3D data.tep();
+
+	KsCheckBoxDialog *dialog2 =3D new KsCheckBoxDialog(tasks_cbd);
+	QObject::connect(dialog2,	&KsCheckBoxDialog::apply,
+			 &p,		&TaskPrint::print);
+
+	cout << "\n\nYou selected\n";
+	dialog2->show();
+	a.exec();
+
+	return 0;
+}
--=20
2.17.1
