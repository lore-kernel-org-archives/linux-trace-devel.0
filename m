Return-Path: <SRS0=llO+=4X=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699BFC10F00
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Mar 2020 09:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 427382070A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Mar 2020 09:29:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mn5QFw9w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgCFJ3J (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Mar 2020 04:29:09 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44599 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgCFJ3I (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Mar 2020 04:29:08 -0500
Received: by mail-lj1-f195.google.com with SMTP id a10so1442036ljp.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 06 Mar 2020 01:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xGkaIJsp4JqNEvFxtwBws/Gmz/TmW1OIa4Fci0PSxf4=;
        b=mn5QFw9wHovQc5kzilJX1W3MA8vfnkTmGPvDbY8P2M5/ybAXzaSvmw70ArT1LGmpM+
         bAhu7nt0hr6FFAEpBPPN35c0CJFtbic/YgiWkpN0brz25sDRACzYa5NwTjIwfrQQgqR2
         TPDyBAi8mgYrYlPBXlqMgyrn4gRPGNvsT+f65jjYQ2qvyRgmFfy/IJ5BJ9MM2/yyzcN+
         MQw9ONac5A4YDPrDeAKKdo12SlJ8rn5OU+m7j4UqeNd0QugYm+8PsXXOM8qdv5QvXaz4
         0L7n8kGJp8UZCd0YfCAXTUlBdkrXlS9OnvcSZQV+a1/+qGZ6/UgEt5G4pjmsD39XogjI
         MnTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xGkaIJsp4JqNEvFxtwBws/Gmz/TmW1OIa4Fci0PSxf4=;
        b=ihb/yQC14++qUh/qPkl2MsiJqFoysW+tgFbPWMN+LqW7OawfJ64Nj5C5wm3n8zPRr5
         iej9s0qLMZHq3CvdPs8aE4Y3QewG1oYU0apRjZ3PdJ6S2WV/8/l3ZxYfwgJ+Vok6felz
         JQclU94iNQsoL8k2khLXn1g4TfEKeLbmMfRBZUH29lbLZ/sn3ieW2GWkl9brcNYFXhZQ
         nCQKWhcW3wVKbjQKAMoer7DG+PDVNXVIkmMmg7s0rWOio01Zynb5cS5yIzPgajhqvcPQ
         NWa8nCBDvtN6shiNaqAkwk2cOCME0+BzjEudXpw6SR+bUa2MOv6+8WBOQNYZ07lC+i1H
         1oEA==
X-Gm-Message-State: ANhLgQ33h8rDFKn8CUdAZc3OVn2Om/1UKlHM9bSIEZH7GXR8Xe0AA3Vq
        xDeta2yuu8QN+R9KJGa4WZcC0ZzA
X-Google-Smtp-Source: ADFU+vtCps1n3uznKtnwyf6wLfQIuVQw4Ly9lmsbGvQ/b2PZBDZGpHPu6UhGxPm2Fc/7UaW9lWqi4A==
X-Received: by 2002:a2e:b246:: with SMTP id n6mr1531977ljm.70.1583486946914;
        Fri, 06 Mar 2020 01:29:06 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r15sm16750159ljh.11.2020.03.06.01.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 01:29:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] KernelShark2.0: Link KernelShark to libtracefs
Date:   Fri,  6 Mar 2020 11:29:01 +0200
Message-Id: <20200306092902.48786-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306092902.48786-1-tz.stoyanov@gmail.com>
References: <20200306092902.48786-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

The tracefs library provides APIs for accessing files from tracefs.
The library is part of trace-cmd, it is installed as part of trace-cmd
installation. KernelShark uses some of those APIs and must be linked with
the library

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 CMakeLists.txt           |  3 ++-
 build/FindTraceCmd.cmake | 28 ++++++++++++++++++++++++++++
 src/CMakeLists.txt       |  2 ++
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index ce2a5ef..846fcf2 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -79,7 +79,8 @@ include_directories(${KS_DIR}/src/
                     ${KS_DIR}/build/src/
                     ${JSONC_INCLUDE_DIR}
                     ${TRACECMD_INCLUDE_DIR}
-                    ${TRACEEVENT_INCLUDE_DIR})
+                    ${TRACEEVENT_INCLUDE_DIR}
+                    ${TRACEFS_INCLUDE_DIR})
 
 message("")
 message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
diff --git a/build/FindTraceCmd.cmake b/build/FindTraceCmd.cmake
index 6278190..802d42e 100644
--- a/build/FindTraceCmd.cmake
+++ b/build/FindTraceCmd.cmake
@@ -6,6 +6,8 @@
 #  TRACEEVENT_FOUND, If false, do not try to use traceevent.
 #
 #  TRACECMD_INCLUDE_DIR, where to find trace-cmd header.
+#  TRACEFS_INCLUDE_DIR, where to find tracefs header.
+#  TRACEFS_LIBRARY, the tracefs library.
 #  TRACECMD_LIBRARY, the trace-cmd library.
 #  TRACECMD_FOUND, If false, do not try to use trace-cmd.
 
@@ -31,10 +33,18 @@ find_path(TRACECMD_INCLUDE_DIR   NAMES  trace-cmd/trace-cmd.h
                                  PATHS  $ENV{TRACE_CMD}/include/
                                  NO_DEFAULT_PATH)
 
+find_path(TRACEFS_INCLUDE_DIR    NAMES  tracefs/tracefs.h
+                                 PATHS  $ENV{TRACE_CMD}/include/
+                                NO_DEFAULT_PATH)
+
 find_library(TRACECMD_LIBRARY    NAMES  trace-cmd/libtracecmd.so
                                  PATHS  $ENV{TRACE_CMD}/lib/
                                  NO_DEFAULT_PATH)
 
+find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.so
+                                PATHS  $ENV{TRACE_CMD}/lib/
+                                NO_DEFAULT_PATH)
+
 find_path(TRACEEVENT_INCLUDE_DIR NAMES  traceevent/event-parse.h
                                  PATHS  $ENV{TRACE_CMD}/include/
                                  NO_DEFAULT_PATH)
@@ -47,7 +57,9 @@ find_library(TRACEEVENT_LIBRARY  NAMES  traceevent/libtraceevent.so
 # search was successful "find_path" will do nothing this time.
 find_program(TRACECMD_EXECUTABLE NAMES  trace-cmd)
 find_path(TRACECMD_INCLUDE_DIR   NAMES  trace-cmd/trace-cmd.h)
+find_path(TRACEFS_INCLUDE_DIR   NAMES  tracefs/tracefs.h)
 find_library(TRACECMD_LIBRARY    NAMES  trace-cmd/libtracecmd.so)
+find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.so)
 find_path(TRACEEVENT_INCLUDE_DIR NAMES  traceevent/event-parse.h)
 find_library(TRACEEVENT_LIBRARY  NAMES  traceevent/libtraceevent.so)
 
@@ -67,6 +79,22 @@ ELSE (TRACECMD_FOUND)
 
 ENDIF (TRACECMD_FOUND)
 
+IF (TRACEFS_INCLUDE_DIR AND TRACEFS_LIBRARY)
+
+  SET(TRACEFS_FOUND TRUE)
+
+ENDIF (TRACEFS_INCLUDE_DIR AND TRACEFS_LIBRARY)
+
+IF (TRACEFS_FOUND)
+
+  MESSAGE(STATUS "Found tracefs: ${TRACEFS_LIBRARY}")
+
+ELSE (TRACEFS_FOUND)
+
+  MESSAGE(FATAL_ERROR "\nCould not find tracefs!\n")
+
+ENDIF (TRACEFS_FOUND)
+
 
 IF (TRACEEVENT_INCLUDE_DIR AND TRACEEVENT_LIBRARY)
 
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index dbd33ab..8ffc66c 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -19,6 +19,7 @@ add_library(kshark SHARED libkshark.c
 
 target_link_libraries(kshark ${TRACEEVENT_LIBRARY}
                              ${TRACECMD_LIBRARY}
+                             ${TRACEFS_LIBRARY}
                              ${JSONC_LIBRARY}
                              ${CMAKE_DL_LIBS})
 
@@ -104,6 +105,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                                      Qt5::Network
                                      ${TRACEEVENT_LIBRARY}
                                      ${TRACECMD_LIBRARY}
+                                     ${TRACEFS_LIBRARY}
                                      ${CMAKE_DL_LIBS})
 
     set_target_properties(kshark-gui PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
-- 
2.24.1

