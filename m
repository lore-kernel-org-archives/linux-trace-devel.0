Return-Path: <SRS0=xW9H=SA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399B3C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Mar 2019 15:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0947C206C0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Mar 2019 15:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbfC2PDY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Mar 2019 11:03:24 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:32890 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728717AbfC2PDY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Mar 2019 11:03:24 -0400
Received: by mail-wr1-f50.google.com with SMTP id q1so3030296wrp.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Mar 2019 08:03:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rP+0pGpvZtc/mscNs5uxoS8aYWHBwZw++l3aBIfIpJA=;
        b=ZB5wuE3eE83NK5qRG9JszUJZVOJKkEGrUL3G5cvz4GspB+KKTFL5u7bDgGoQ6piSNt
         RHsmkXMpiTVVboDD1aOkRp9MAU0jZwIKrrQTn5KygVlGn9nkDbLmQOEHloPxNIY7n1kB
         zBQKK86wfaO0ZBDTUBe/NkmOikDGTmzU1rbnFBCcPtvLProZ+CjmDFPGo8wJT3f+uD0M
         cavHgdDhw/vMj6+wRSUrbR7AKzul7Fwwqy8BfiaHyGjf77K/VobRThrlcG7kasnc2Q21
         ANRlekOuNsDDw9EiNnlwLlAeL6eWH5O9a7qFABG532xJYSFO9mkdVP+A4ONcJn3cLMXs
         7VUA==
X-Gm-Message-State: APjAAAUmurXFt5KwtvUGSKxMydJVGcs9JTgciCmA1eekDJeIUNNLBs5z
        xJULnQJQ9gdLfFsgyniNOXubDvku
X-Google-Smtp-Source: APXvYqzHUq5vKqqA3MwhpKF4E4Fs8lWqnekgMlrvLccQHjdos6Lfs8UpUdK2H466m/t2EnNkH45Ptg==
X-Received: by 2002:adf:c788:: with SMTP id l8mr22375780wrg.143.1553871802347;
        Fri, 29 Mar 2019 08:03:22 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o6sm1882483wrp.41.2019.03.29.08.03.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 Mar 2019 08:03:21 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3] kernel-shark: remove hardcoded /usr/local install prefix
Date:   Fri, 29 Mar 2019 17:03:19 +0200
Message-Id: <20190329150319.7176-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Installation prefix of kernelshark should not be hardcoded, it should be
configurable at build time. As kernelshark and trace-cmd are built together,
they should share the same installation prefix. The patch removes hardcoded
/usr/local prefix from kernelshark make files and replaces it with the one,
specified in the top Makefile.
Note: after applying the patch, kernel-shark/build/cmake_clean.sh should be
run, to ensure that cmake cache is cleared.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Reviewed-by: Yordan Karadzhov <ykaradzhov@vmware.com>
Tested-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 Makefile                                                 | 2 +-
 kernel-shark/CMakeLists.txt                              | 9 ++++++++-
 kernel-shark/README                                      | 5 ++++-
 kernel-shark/build/cmake_clean.sh                        | 1 +
 kernel-shark/build/ks.desktop.cmake                      | 2 +-
 .../org.freedesktop.kshark-record.policy.cmake}          | 2 +-
 kernel-shark/src/CMakeLists.txt                          | 6 +++---
 kernel-shark/src/plugins/CMakeLists.txt                  | 2 +-
 8 files changed, 20 insertions(+), 9 deletions(-)
 rename kernel-shark/{org.freedesktop.kshark-record.policy => build/org.freedesktop.kshark-record.policy.cmake} (86%)

diff --git a/Makefile b/Makefile
index b780718..cde45f8 100644
--- a/Makefile
+++ b/Makefile
@@ -254,7 +254,7 @@ all_cmd: $(CMD_TARGETS)
 CMAKE_COMMAND = /usr/bin/cmake
 
 $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
-	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) ..
+	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -D_INSTALL_PREFIX=$(prefix) ..
 
 gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
 	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 20ced14..10cb696 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -40,6 +40,10 @@ set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -g -pthread")
 set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -g -std=c++11 -pthread")
 
+if(NOT _INSTALL_PREFIX)
+	set(_INSTALL_PREFIX "/usr/local")
+endif()
+
 if (NOT _DEBUG)
 
 	set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -O2")
@@ -47,7 +51,7 @@ if (NOT _DEBUG)
 
 endif (NOT _DEBUG)
 
-SET(CMAKE_INSTALL_RPATH "/usr/local/lib/kshark/")
+SET(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/kshark/")
 SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
 
 include_directories(${KS_DIR}/src/
@@ -82,4 +86,7 @@ endif ()
 configure_file( ${KS_DIR}/build/ks.desktop.cmake
                 ${KS_DIR}/kernelshark.desktop)
 
+configure_file( ${KS_DIR}/build/org.freedesktop.kshark-record.policy.cmake
+                ${KS_DIR}/org.freedesktop.kshark-record.policy)
+
 message("")
diff --git a/kernel-shark/README b/kernel-shark/README
index efc6748..379c390 100644
--- a/kernel-shark/README
+++ b/kernel-shark/README
@@ -41,8 +41,11 @@ as a CMake Command-Line option.
 2.1.2 In order to generates complete debug information to be used by GDB add
 -D_DEBUG=1 as a CMake Command-Line option.
 
+2.1.3 By default, installation prefix is "/usr/local". It can be changed using
+-D_INSTALL_PREFIX= as a CMake Command-Line option.
+
 Example:
-    cmake -D_DOXYGEN_DOC=1 -D_DEBUG=1 ../
+    cmake -D_DOXYGEN_DOC=1 -D_DEBUG=1 -D_INSTALL_PREFIX=/usr ../
 
 2.2.1 Use "make clean" if you want to delete all already compiled objects.
 
diff --git a/kernel-shark/build/cmake_clean.sh b/kernel-shark/build/cmake_clean.sh
index ea04dc0..2e7c8f9 100755
--- a/kernel-shark/build/cmake_clean.sh
+++ b/kernel-shark/build/cmake_clean.sh
@@ -7,6 +7,7 @@ rm -rf src/
 rm -rf examples/
 rm -f ../lib/*
 rm ../kernelshark.desktop
+rm ../org.freedesktop.kshark-record.policy
 rm -f ../src/KsCmakeDef.hpp
 rm -f CMakeDoxyfile.in
 rm -f CMakeDoxygenDefaults.cmake
diff --git a/kernel-shark/build/ks.desktop.cmake b/kernel-shark/build/ks.desktop.cmake
index f1951f0..10e3610 100644
--- a/kernel-shark/build/ks.desktop.cmake
+++ b/kernel-shark/build/ks.desktop.cmake
@@ -4,7 +4,7 @@ Type=Application
 Name=Kernel Shark
 GenericName=Kernel Shark
 Comment=
-Exec=/usr/local/bin/kernelshark
+Exec=@_INSTALL_PREFIX@/bin/kernelshark
 Icon=@KS_DIR@/icons/ksharkicon.png
 Categories=System;
 Terminal=false
diff --git a/kernel-shark/org.freedesktop.kshark-record.policy b/kernel-shark/build/org.freedesktop.kshark-record.policy.cmake
similarity index 86%
rename from kernel-shark/org.freedesktop.kshark-record.policy
rename to kernel-shark/build/org.freedesktop.kshark-record.policy.cmake
index dc73817..988db78 100644
--- a/kernel-shark/org.freedesktop.kshark-record.policy
+++ b/kernel-shark/build/org.freedesktop.kshark-record.policy.cmake
@@ -11,7 +11,7 @@
       <allow_inactive>auth_admin</allow_inactive>
       <allow_active>auth_admin</allow_active>
     </defaults>
-    <annotate key="org.freedesktop.policykit.exec.path">/usr/local/bin/kshark-record</annotate>
+    <annotate key="org.freedesktop.policykit.exec.path">@_INSTALL_PREFIX@/bin/kshark-record</annotate>
     <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
   </action>
 
diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index 1e0a794..b7dbd7e 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -78,8 +78,8 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
     target_link_libraries(kshark-record kshark-gui)
 
     install(TARGETS kernelshark kshark-record kshark kshark-plot kshark-gui
-            RUNTIME DESTINATION /usr/local/bin/
-            LIBRARY DESTINATION /usr/local/lib/kshark/)
+            RUNTIME DESTINATION ${_INSTALL_PREFIX}/bin/
+            LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/kshark/)
 
     install(FILES "${KS_DIR}/kernelshark.desktop"
             DESTINATION /usr/share/applications/)
@@ -88,7 +88,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
             DESTINATION /usr/share/polkit-1/actions/)
 
     install(PROGRAMS "${KS_DIR}/bin/kshark-su-record"
-            DESTINATION /usr/local/bin/)
+            DESTINATION ${_INSTALL_PREFIX}/bin/)
 
 endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
diff --git a/kernel-shark/src/plugins/CMakeLists.txt b/kernel-shark/src/plugins/CMakeLists.txt
index 853214e..6098275 100644
--- a/kernel-shark/src/plugins/CMakeLists.txt
+++ b/kernel-shark/src/plugins/CMakeLists.txt
@@ -29,6 +29,6 @@ BUILD_PLUGIN(NAME missed_events
 list(APPEND PLUGIN_LIST "missed_events default") # This plugin will be loaded by default
 
 install(TARGETS sched_events missed_events
-        LIBRARY DESTINATION /usr/local/lib/kshark/)
+        LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/kshark/)
 
 set(PLUGINS ${PLUGIN_LIST} PARENT_SCOPE)
-- 
2.20.1

