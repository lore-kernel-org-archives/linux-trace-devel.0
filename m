Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-pl0-f66.google.com ([209.85.160.66]:33969 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752544AbeBFIto (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 03:49:44 -0500
Received: by mail-pl0-f66.google.com with SMTP id q17so857897pll.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Feb 2018 00:49:44 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 18/24] trace-cmd: Make the build to tell when python-dev is missing
Date: Tue,  6 Feb 2018 10:49:00 +0200
Message-Id: <20180206084906.9854-19-vladislav.valtchev@gmail.com>
In-Reply-To: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Currently, the build system will complain when swig is missing, since that
will prevent it to build the python C modules, but in case swig is present
but python-dev is not installed, the build will just silently skip them.
This patch just makes the build to report a message when that happens.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Makefile b/Makefile
index 6016bec..4f17dd3 100644
--- a/Makefile
+++ b/Makefile
@@ -120,6 +120,8 @@ ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_VERS) > /dev/null 2>&1 && echo
 	PYTHON_PLUGINS := plugin_python.so
 	BUILD_PYTHON := $(PYTHON) $(PYTHON_PLUGINS)
 	BUILD_PYTHON_WORKS := 1
+else
+	BUILD_PYTHON := report_nopythondev
 endif
 endif # NO_PYTHON
 
@@ -372,6 +374,11 @@ report_noswig: force
 	$(Q)echo "    NO_PYTHON forced: swig not installed, not compiling python plugins"
 	$(Q)echo
 
+report_nopythondev: force
+	$(Q)echo
+	$(Q)echo "    python-dev is not installed, not compiling python plugins"
+	$(Q)echo
+
 PYTHON_INCLUDES = `pkg-config --cflags $(PYTHON_VERS)`
 PYTHON_LDFLAGS = `pkg-config --libs $(PYTHON_VERS)` \
 		$(shell python2 -c "import distutils.sysconfig; print distutils.sysconfig.get_config_var('LINKFORSHARED')")
-- 
2.14.1
