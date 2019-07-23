Return-Path: <SRS0=P3iB=VU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B604DC76186
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 18:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BAE422AEC
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 18:25:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vfo2F2a4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbfGWSZy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 14:25:54 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45433 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729661AbfGWSZy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 14:25:54 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so44169721wre.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jul 2019 11:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=erWKdgxOP/1bgXJZPh+MRbwZXHF74FJUsymsHCGoV6E=;
        b=Vfo2F2a4FV5h9WgcA6jx/O50UDTeoZDRVbriPQ1Hu2QY/A44YyLFPDXrNbBhq3W0r1
         vtEA+ehP5l3ms3WQHrcKYwKv24c3F7Y3XM3UJ5rUfNZOen0JBFAj9N6LQXyzSk27lU2o
         7XX5JTAcAhp2tt98YhzJSYyecBWCo5T2Ncx+ZocwVEF3CCzVMOHfwmtfuqtSedSU0Jap
         pfNE8QcBxaMMPlnXriwcovsuWdyHxToAOQqTi5PChLTEIm8LiSXuNOJOQ37+x1FHIYpz
         kNIhta6xR424bLPeLi4+zEtsjlgEwpaxmZSHH/YfSzAmdXBEgmob9YqRHGSIJWCFVU35
         2YxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=erWKdgxOP/1bgXJZPh+MRbwZXHF74FJUsymsHCGoV6E=;
        b=a/spzyUzYPgDuste+qVmnQnb+XJEFl1RHFL6TizjnwYMlQKwfH0XAh4CcIyGDsdv4n
         02D7myOeD9+mQt7AH2dP8kS1BRJcAm/jIeRDu9326HsZTpKMmxeqq/8hlPZFE3JesIfd
         FcAQFgxTuRZdYlPnaydAGY54gGD0fA+VOh80it9xrUnYl23a3Fuk2WBnpma+PK5VrLJk
         FVKY6MeNEq7TIuwtx4KkV4o2Jn0/Uxop0YPG8stGXlLzDgfF2IlTq1t/cbPh2X12dTE1
         L2Gf4fQjoNW9IqAfmYQ6Xe7Y/fqehxRlOCzNBwHIKC+VbuFVa9FZhL9WqC7+5QVVgvNE
         Y7aw==
X-Gm-Message-State: APjAAAUgu7GJPQMeTxoS9HeYTtgOK5+h84GnA31Lhdu00ypuZ3J2zLMw
        uxXgE7+mZ9ohjjWjhG9dK2U=
X-Google-Smtp-Source: APXvYqy2AL98//WPwzltMqtpr/7Z8UkGvg5Nn17v6NOoL779rbrQ1wWUuTAtjL+v2BAEBEi5pnxGqw==
X-Received: by 2002:adf:de10:: with SMTP id b16mr49458030wrm.296.1563906352030;
        Tue, 23 Jul 2019 11:25:52 -0700 (PDT)
Received: from localhost.localdomain ([95.87.223.238])
        by smtp.gmail.com with ESMTPSA id o185sm47027094wmo.45.2019.07.23.11.25.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 11:25:51 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark: Get the path to trace-cmd executable from _INSTALL_PREFIX
Date:   Tue, 23 Jul 2019 21:25:42 +0300
Message-Id: <20190723182542.1295-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The absolute path to the trace-cmd executable gets derived from
"_INSTALL_PREFIX", and the "Record" dialog will be using its installed
version. This is done because nothing guaranties that the trace-cmd
executable will be presented at the time when the KernelShark package
is built. The rule has one exception and this is the case when the build
type is "Debug". In "Debug" mode the "Record" dialog will try to use the
version of the trace-cmd executable from the build location.

Sugested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/CMakeLists.txt           |  8 ++++----
 kernel-shark/README                   |  7 ++++++-
 kernel-shark/build/FindTraceCmd.cmake | 10 ++++++++--
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 45c6f23..075c4af 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -13,6 +13,10 @@ message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
 
 set(KS_DIR ${CMAKE_SOURCE_DIR})
 
+if (NOT _INSTALL_PREFIX)
+    set(_INSTALL_PREFIX "/usr/local")
+endif (NOT _INSTALL_PREFIX)
+
 include(${KS_DIR}/build/FindTraceCmd.cmake)
 include(${KS_DIR}/build/FindJSONC.cmake)
 
@@ -50,10 +54,6 @@ if (NOT CMAKE_CXX_FLAGS_PACKAGE)
     set(CMAKE_CXX_FLAGS_PACKAGE "-O3")
 endif (NOT CMAKE_CXX_FLAGS_PACKAGE)
 
-if (NOT _INSTALL_PREFIX)
-    set(_INSTALL_PREFIX "/usr/local")
-endif (NOT _INSTALL_PREFIX)
-
 set(KS_PLUGIN_INSTALL_PREFIX ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/plugins/)
 
 set(KS_ICON        KS_icon_shark.svg)
diff --git a/kernel-shark/README b/kernel-shark/README
index 7e50479..6c360bb 100644
--- a/kernel-shark/README
+++ b/kernel-shark/README
@@ -86,9 +86,14 @@ By default this build type adds the "-O2" compiler flag. Package maintainers
 can chose their own compiler flags by providing the corresponding
 CMAKE_XXXX_FLAGS_PACKAGE Command-Line options (see the example below).
 
-Note that when built as a "Package" the RPATH-s of the executables are
+-- Note that when built as a "Package" the RPATH-s of the executables are
 set directly to _INSTALL_PREFIX/lib/kernelshark/
 
+-- Note that when built as a "Debug" the "Record" dialog will try to use the
+version of the trace-cmd executable from the build location. In all other cases
+the dialog will derive the absolut path to the trace-cmd executable from
+"_INSTALL_PREFIX", hence the dialog will use the installed version.
+
 If no build types is specified, the type will be "RelWithDebInfo".
 
 Examples:
diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/FindTraceCmd.cmake
index 2da4eee..d3e145c 100644
--- a/kernel-shark/build/FindTraceCmd.cmake
+++ b/kernel-shark/build/FindTraceCmd.cmake
@@ -21,6 +21,12 @@ if (CMAKE_BUILD_TYPE MATCHES Debug)
 
 endif (CMAKE_BUILD_TYPE MATCHES Debug)
 
+if (NOT TRACECMD_EXECUTABLE)
+
+  set(TRACECMD_EXECUTABLE "${_INSTALL_PREFIX}/bin/trace-cmd")
+
+endif (NOT TRACECMD_EXECUTABLE)
+
 find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h
                                 PATHS  $ENV{TRACE_CMD}/include/
                                        ${CMAKE_SOURCE_DIR}/../include/
@@ -43,11 +49,11 @@ find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h)
 find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.so)
 find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.so)
 
-IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY AND TRACECMD_EXECUTABLE)
+IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
 
   SET(TRACECMD_FOUND TRUE)
 
-ENDIF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY AND TRACECMD_EXECUTABLE)
+ENDIF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
 
 IF (TRACECMD_FOUND)
 
-- 
2.20.1

