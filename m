Return-Path: <SRS0=+uc8=UK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92EEC4321A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jun 2019 15:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2A482146E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jun 2019 15:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387563AbfFKPVn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 Jun 2019 11:21:43 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39465 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388810AbfFKPVn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Jun 2019 11:21:43 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so10862282wrt.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jun 2019 08:21:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DIPgdMCtTzFDIWlUdQ/kWuxZpe+pTbkrld+tpnDfqfA=;
        b=nRf4jQX+dgHrGCLZhHNH89cGspbu+riQRzVa0CjBkgwhACVUG97A92uTmgNbnhrMz4
         ST3b9ngIloymfS+4x8SE/Us4QK5XB3HyJjaFY/IpC0YEvbk0NB66ChsdNxXuakOVwH0y
         JuAsd6HUc493uKSvXjJecBmcHLcSpDQJ4GThWytY4aweqb8HqQSv67ugVE/TF0DBnk7l
         3UI9rAHZHX7aRL4df9BQ06EQDdUzCS2BDPQgseYkVXGUSgveFBa3dD+CS5SsIFboCc5O
         uczKwFpRGYVH2sOFARFU9G32UnmMHs0sUKbIu37QF1MbLNlDv0hyeorjsQ8jG0jm5fym
         vpwA==
X-Gm-Message-State: APjAAAUOpMDx4uS3yWnGJ12bSPIIIAjDfdYb2G69V9+UNhf0N0dWMQfT
        tsotv83zxm8Jayebay3iUC0=
X-Google-Smtp-Source: APXvYqynpXE5bwDQfYChMGKyV8Ps5FcYuw8mXXDSnpWlYtC3NIdOWy7aZAKrYdjv9jErK/lLNN6zsA==
X-Received: by 2002:adf:f5c5:: with SMTP id k5mr10264938wrp.280.1560266501803;
        Tue, 11 Jun 2019 08:21:41 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r2sm2793821wma.26.2019.06.11.08.21.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 08:21:41 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        troyengel@gmail.com, Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/2] kernel-shark: Avoid TRACECMD_BIN_DIR being set to the build path
Date:   Tue, 11 Jun 2019 18:20:42 +0300
Message-Id: <20190611152043.22572-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611152043.22572-1-ykaradzhov@vmware.com>
References: <20190611152043.22572-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 kernel-shark/build/FindTraceCmd.cmake | 14 +++++++++-----
 kernel-shark/build/deff.h.cmake       |  2 +-
 kernel-shark/src/KsCaptureDialog.cpp  | 13 ++++++++-----
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/FindTraceCmd.cmake
index 8c51f11..3d11347 100644
--- a/kernel-shark/build/FindTraceCmd.cmake
+++ b/kernel-shark/build/FindTraceCmd.cmake
@@ -12,10 +12,14 @@
 # MESSAGE(" Looking for trace-cmd ...")
 
 # First search in the user provided paths.
-find_path(TRACECMD_BIN_DIR      NAMES  trace-cmd
-                                PATHS  $ENV{TRACE_CMD}/tracecmd/
-                                       ${CMAKE_SOURCE_DIR}/../tracecmd/
-                                NO_DEFAULT_PATH)
+if (NOT CMAKE_BUILD_TYPE MATCHES Release)
+
+  find_program(TRACECMD_EXECUTABLE   NAMES  trace-cmd
+                                     PATHS  $ENV{TRACE_CMD}/tracecmd/
+                                            ${CMAKE_SOURCE_DIR}/../tracecmd/
+                                     NO_DEFAULT_PATH)
+
+endif (NOT CMAKE_BUILD_TYPE MATCHES Release)
 
 find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h
                                 PATHS  $ENV{TRACE_CMD}/include/
@@ -34,7 +38,7 @@ find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.a
 
 # If not found, search in the default system paths. Note that if the previous
 # search was successful "find_path" will do nothing this time.
-find_path(TRACECMD_BIN_DIR      NAMES  trace-cmd)
+find_program(TRACECMD_EXECUTABLE   NAMES  trace-cmd)
 find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h)
 find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.so)
 find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.so)
diff --git a/kernel-shark/build/deff.h.cmake b/kernel-shark/build/deff.h.cmake
index efee2a1..79726ff 100644
--- a/kernel-shark/build/deff.h.cmake
+++ b/kernel-shark/build/deff.h.cmake
@@ -18,7 +18,7 @@
 #cmakedefine KS_PLUGIN_INSTALL_PREFIX "@KS_PLUGIN_INSTALL_PREFIX@"
 
 /** Location of the trace-cmd executable. */
-#cmakedefine TRACECMD_BIN_DIR "@TRACECMD_BIN_DIR@"
+#cmakedefine TRACECMD_EXECUTABLE "@TRACECMD_EXECUTABLE@"
 
 /** "pkexec" executable. */
 #cmakedefine DO_AS_ROOT "@DO_AS_ROOT@"
diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index b107595..96ab3e2 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -489,12 +489,15 @@ KsCaptureDialog::KsCaptureDialog(QWidget *parent)
 	connect(&_captureCtrl._closeButton,	&QPushButton::pressed,
 		this,				&KsCaptureDialog::close);
 
-	if (KsUtils::isInstalled())
-		captureExe = QString(_INSTALL_PREFIX) + QString("/bin");
-	else
-		captureExe = TRACECMD_BIN_DIR;
+	captureExe = QString(_INSTALL_PREFIX) + QString("/bin/trace-cmd");
+
+#ifdef TRACECMD_EXECUTABLE
+
+	if (!KsUtils::isInstalled())
+		captureExe = TRACECMD_EXECUTABLE;
+
+#endif
 
-	captureExe += "/trace-cmd";
 	_captureProc.setProgram(captureExe);
 
 	_captureMon.connectMe(&_captureProc, &_captureCtrl);
-- 
2.20.1

