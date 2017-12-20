Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wm0-f67.google.com ([74.125.82.67]:40388 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756041AbdLTSIV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 13:08:21 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH 18/18] trace-cmd: Make the build to tell when python-dev is missing
Date: Wed, 20 Dec 2017 20:07:48 +0200
Message-Id: <20171220180748.17273-19-vladislav.valtchev@gmail.com>
In-Reply-To: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
References: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
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
index 0a2a78d..f463d1f 100644
--- a/Makefile
+++ b/Makefile
@@ -119,6 +119,8 @@ ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_VERS) > /dev/null 2>&1 && echo
 	PYTHON_PLUGINS := plugin_python.so
 	BUILD_PYTHON := $(PYTHON) $(PYTHON_PLUGINS)
 	BUILD_PYTHON_WORKS := 1
+else
+	BUILD_PYTHON := report_nopythondev
 endif
 endif # NO_PYTHON
 
@@ -365,6 +367,11 @@ report_noswig: force
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
