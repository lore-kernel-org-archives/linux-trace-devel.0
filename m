Return-Path: <SRS0=xW9H=SA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D788C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Mar 2019 14:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B87A206B6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Mar 2019 14:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbfC2OFU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Mar 2019 10:05:20 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35434 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728985AbfC2OFT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Mar 2019 10:05:19 -0400
Received: by mail-wm1-f68.google.com with SMTP id y197so2978581wmd.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Mar 2019 07:05:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e4c8lCxlIVb+L3h+XcR59fHgVLEbr2d9IB28E3tHEGk=;
        b=IsmG7F/OucvyoFV0umBBrvW9uAVWEx+NXAK92bXA4taLWtu9N6k3GRUPuNGScUna5s
         fJL0FWz586cS4CAt0sW8AAdmmau3rIVG5GyucRjLdiEZh1QYAkIchcLrhQjS4+lk1X3e
         QGwfWChWQXCREoO8EPMncvfMMnc/CkEfBNc7IjDTiDPDYdNpLvnTez1+rH8S3d6My+2g
         3gYxTbhzSVjBnkhJlCX6AsWpI97E1CWKMjLP3XA1kgsrtFWOe0WF/yWFNpws6qLJQFIu
         JEeqZmBZW+5HWOB5bCltALJpUxkz3wQACZM17GiS2ImfitlAmdzctMwETYSK3UxTtYb+
         Knjw==
X-Gm-Message-State: APjAAAUzM0s8QmPagnit3cRPyHWa1ThB8d/oaDjpyFvtv6ScWnMWrZln
        VUpjVJfqVyseo5z5OykeMOk=
X-Google-Smtp-Source: APXvYqzKzptJ6U/YwvCtTuPVfYVx1Whg//Wzfucnsb6/FudbWDz4sAquJ4iMu4Q5wPs475DcuUixdw==
X-Received: by 2002:a1c:bd8b:: with SMTP id n133mr3874885wmf.73.1553868317600;
        Fri, 29 Mar 2019 07:05:17 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t81sm4201352wmb.5.2019.03.29.07.05.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 Mar 2019 07:05:17 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] kernel-shark: remove hardcoded /usr/local install prefix
Date:   Fri, 29 Mar 2019 16:05:14 +0200
Message-Id: <20190329140514.1373-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190329140514.1373-1-tstoyanov@vmware.com>
References: <20190329140514.1373-1-tstoyanov@vmware.com>
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

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 Makefile                                                 | 2 +-
 kernel-shark/CMakeLists.txt                              | 9 ++++++++-
 kernel-shark/build/cmake_clean.sh                        | 1 +
 kernel-shark/build/ks.desktop.cmake                      | 2 +-
 .../org.freedesktop.kshark-record.policy.cmake}          | 2 +-
 kernel-shark/src/CMakeLists.txt                          | 6 +++---
 kernel-shark/src/plugins/CMakeLists.txt                  | 2 +-
 7 files changed, 16 insertions(+), 8 deletions(-)
 rename kernel-shark/{org.freedesktop.kshark-record.policy => build/org.freedesktop.kshark-record.policy.cmake} (86%)

diff --git a/Makefile b/Makefile
index b780718..0b08e53 100644
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

