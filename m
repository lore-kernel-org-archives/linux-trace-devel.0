Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE4CC4338F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 09:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9484E60F42
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 09:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhGZJB1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 05:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbhGZJB1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 05:01:27 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B875C061760
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jul 2021 02:41:56 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id l4-20020a05600c1d04b02902506f89ad2dso1779232wms.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jul 2021 02:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oTNzR4PmC98esA7TTxE31tq/QUDiGH9v7Tmna7qvEUE=;
        b=UUZ/71NOxcNfo2xssrOvnpvsfwsK4vq7DpIVwFb0PGrGhEK72a42sD8erJwCSVoOj8
         q0e3ZGZGJr4neybpqzwmdnf1+quFANxWp1r3znvLRghm3DOPK21fknWlo1C2Yy1gn2L1
         xCb5TIFpTgS55DqdO4N+GbH38v7SKnxMIBx3lgY9WEtwEHS3tXFGy5KwqxH1wKYj9i28
         4kOgtaYLFXRGOrT1x96zGVMSbO/92oxlQdl4FMcr0/QkWHdRZrV7edcwCIxAQ+G1lJWg
         Mqn6u19fZdrP7pytHpb8rqkAaLBxwr90GmatW6MJnCvMteq4s/EyfuZr28YgdSCjxOUA
         /6JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oTNzR4PmC98esA7TTxE31tq/QUDiGH9v7Tmna7qvEUE=;
        b=cM6eci6QJLtokNWIDdKDW0dtmJglKgTpi4pjEb4nzt/ykeRzWXe7IEwXWHZ13yYMS3
         Dq0H1d06LFu120wBkC8MzrtWF9KLhEfbqfPoyULX5KhlkDVMH6Pbl03vrAyuGsYeDDc5
         FP5xCMT3FNhsVEVAQ5BhvJGr+U3ETbHW5sjZ932hi2EGI9grrzYEAbmgnfc9kRFpybt1
         IkzRSZ6Hoi6A83oU+1VKplRv0MV/Hmf8e7zSKm9QN0NovK5knokVuI2LcTJ9ddWkbLM5
         6frHch2CDkljdn3OdBfE58ZwqsOow5jv1Gr7OqBSRQGXAXOv0SuUk8PzKoRRXNVoN3DV
         MhjA==
X-Gm-Message-State: AOAM530WmyjYtKcyPaB8gQDMyDS95U0bzBq0zeuQKnMFkkvNglzh7J6j
        4WHqNmbjS3PixLJGMJZ2hk1zqnTRny8=
X-Google-Smtp-Source: ABdhPJyqEtR9nwC3Z+/tz+nTE4EAv3hop7++85TOBFb/q3WG60GU8VLnO6y5prsuBXTqSBBwSn6QFg==
X-Received: by 2002:a05:600c:214a:: with SMTP id v10mr16308666wml.67.1627292514874;
        Mon, 26 Jul 2021 02:41:54 -0700 (PDT)
Received: from localhost.localdomain ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id t6sm42005030wru.75.2021.07.26.02.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 02:41:54 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] kernel-shark: Treat all tracing headers as library headers
Date:   Mon, 26 Jul 2021 12:41:41 +0300
Message-Id: <20210726094141.191579-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210726094141.191579-1-y.karadz@gmail.com>
References: <20210726094141.191579-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The CMake scripts used to discover all tracing libraries are modified
such that the full path to the header is determined. Later there is
no need to add that part when the headers are included. Using angular
brackets ('<' and '>') denotes that it is a library header and not a
local one.

1. Note that this patch actually fixes a build failure, caused by the
following commit in libtracefs:
880885d (libtracefs: Remove "traceevent/" from referencing libtraceevent headers)
It seems that so far the discovery of the headers was working more or
less by chance.

2. Note that after applying the patch you may need to clean the Cmake
cache (running cmake_clean.sh).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 build/FindTraceCmd.cmake     | 2 +-
 build/FindTraceEvent.cmake   | 2 +-
 build/FindTraceFS.cmake      | 2 +-
 src/KsAdvFilteringDialog.cpp | 2 +-
 src/libkshark-tepdata.c      | 3 +--
 src/plugins/sched_events.c   | 2 +-
 6 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/build/FindTraceCmd.cmake b/build/FindTraceCmd.cmake
index 23eefed..602eac5 100644
--- a/build/FindTraceCmd.cmake
+++ b/build/FindTraceCmd.cmake
@@ -42,7 +42,7 @@ pkg_check_modules(PC_TraceCmd QUIET libtracecmd)
 set(TraceCmd_VERSION     ${PC_TraceCmd_VERSION})
 set(TraceCmd_DEFINITIONS ${PC_TraceCmd_CFLAGS_OTHER})
 
-find_path(TraceCmd_INCLUDE_DIR NAMES trace-cmd/trace-cmd.h
+find_path(TraceCmd_INCLUDE_DIR NAMES trace-cmd.h
                                HINTS ${PC_TraceCmd_INCLUDE_DIRS}
                                      ${PC_TraceCmd_INCLUDEDIR})
 
diff --git a/build/FindTraceEvent.cmake b/build/FindTraceEvent.cmake
index ae391b6..668a5de 100644
--- a/build/FindTraceEvent.cmake
+++ b/build/FindTraceEvent.cmake
@@ -42,7 +42,7 @@ pkg_check_modules(PC_TraceEvent QUIET libtraceevent)
 set(TraceEvent_VERSION     ${PC_TraceEvent_VERSION})
 set(TraceEvent_DEFINITIONS ${PC_TraceEvent_CFLAGS_OTHER})
 
-find_path(TraceEvent_INCLUDE_DIR  NAMES traceevent/event-parse.h
+find_path(TraceEvent_INCLUDE_DIR  NAMES event-parse.h
                                   HINTS ${PC_TraceEvent_INCLUDE_DIRS}
                                         ${PC_TraceEvent_INCLUDEDIR})
 
diff --git a/build/FindTraceFS.cmake b/build/FindTraceFS.cmake
index 82fa012..251b506 100644
--- a/build/FindTraceFS.cmake
+++ b/build/FindTraceFS.cmake
@@ -42,7 +42,7 @@ pkg_check_modules(PC_TraceFS QUIET libtracefs)
 set(TraceFS_VERSION     ${PC_TraceFS_VERSION})
 set(TraceFS_DEFINITIONS ${PC_TraceFS_CFLAGS_OTHER})
 
-find_path(TraceFS_INCLUDE_DIR  NAMES tracefs/tracefs.h
+find_path(TraceFS_INCLUDE_DIR  NAMES tracefs.h
                                HINTS ${PC_TraceFS_INCLUDE_DIRS}
                                      ${PC_TraceFS_INCLUDEDIR})
 
diff --git a/src/KsAdvFilteringDialog.cpp b/src/KsAdvFilteringDialog.cpp
index 2fdb624..f01467d 100644
--- a/src/KsAdvFilteringDialog.cpp
+++ b/src/KsAdvFilteringDialog.cpp
@@ -10,7 +10,7 @@
  */
 
 // trace-cmd
-#include "trace-cmd/trace-cmd.h"
+#include <trace-cmd.h>
 
 // KernelShark
 #include "libkshark.h"
diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index acc554b..865ca82 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -21,8 +21,7 @@
 #include <string.h>
 
 // trace-cmd
-#include "trace-cmd/trace-cmd.h"
-#include "tracefs/tracefs.h"
+#include <trace-cmd.h>
 
 // KernelShark
 #include "libkshark.h"
diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
index 659ecc3..83c2520 100644
--- a/src/plugins/sched_events.c
+++ b/src/plugins/sched_events.c
@@ -14,7 +14,7 @@
 #include <stdio.h>
 
 // trace-cmd
-#include "trace-cmd/trace-cmd.h"
+#include <trace-cmd.h>
 
 // KernelShark
 #include "plugins/sched_events.h"
-- 
2.27.0

