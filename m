Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1602C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 00:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0AA6611CA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 00:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbhIWAMD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Sep 2021 20:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234487AbhIWAMD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Sep 2021 20:12:03 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E48C061756
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Sep 2021 17:10:32 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id m10-20020a05620a290a00b004334bcdf1f4so15014494qkp.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Sep 2021 17:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=BCJvCUMu8cEQCM2npj9/T23V8EuGaCj9MUTMMJSKFhI=;
        b=LZ0AxlxdL6Ab/URwRSHoF3DLo4ESAnLaBJPa9wEXL0iC1dwX3oH7QqT2MM96O7iyqU
         W+3DAz6Hk8cOdOD3KMLBMclBagw+aGoMP3k4gupw98S4YVGsy08LH2tBu6kGw3HvUqxE
         3zyB0eXQnIYBUTPqaLFL3PvdF0kp9XxPfh+Y1wDK+4RMeG6D/Pf0xHGaDZ1tHyXlXH27
         +tTzU9l72JbEwYgTW8weT/GdadDIphtKCt7I8ap7/R8/jmtzk3txYIgTmsWOkMmhnL4E
         2rou2vBy44pYeB7d3ggdTv6cmmYTXSh4IIHUOiMhmbpcXVPCYG2AEG+ts+iGo0A0LNJZ
         jFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=BCJvCUMu8cEQCM2npj9/T23V8EuGaCj9MUTMMJSKFhI=;
        b=P+MbDvi+jj3ORerFJWKp3/a1s3HKa444EnLd0Ov4yUtiHJCcQiEDwFwNioM4TJsb+e
         U9qno8NouxJEz8q+soPTKJ27gM1W8n+c0xVkYoYM00Wr/KpmS8AeLGYRW4S/cEJ6tN1D
         H57fCig8aGXi7x01NPs9yEaS8G0gPnRwOjPDdCDzJfubYjN4IiiN95cpsiulRUx9SlIg
         PlYXYiSRDyxz2K5SY+L2RQwZGdoYuyxtiBzfooN+htZmVznYCVexbLVVIjSLrWhjO1Sc
         XOcJEQuS5hxMaOJgVku3HyiOtNzagJOz83NwZUPBv9IWDH89wda1H3RdrM1Qa3Ulce7k
         EeVw==
X-Gm-Message-State: AOAM530WzgNMNhAY+n7XXyn1TedlpBxqn72XZ5+HB/jCTN9xSHXfpq4M
        ZUNPK288YtNeObL+h0zELyQXBjw2GHvT
X-Google-Smtp-Source: ABdhPJxKICrY5ejeu7qNYQ3l+App5+TxEUjjBS6BCcRlyBztcTHnImyVmezywBvXj6+kJkj8Ch5lDy/q6gSH
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:d3ff:e8f7:11f4:c738])
 (user=irogers job=sendgmr) by 2002:a25:6b4d:: with SMTP id
 o13mr2111544ybm.241.1632355831884; Wed, 22 Sep 2021 17:10:31 -0700 (PDT)
Date:   Wed, 22 Sep 2021 17:10:21 -0700
Message-Id: <20210923001024.550263-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v3 1/4] perf: Enable libtracefs dynamic linking
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     eranian@google.com, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently libtracefs isn't used by perf, but there are potential
improvements by using it as identified Steven Rostedt's e-mail:
https://lore.kernel.org/lkml/20210610154759.1ef958f0@oasis.local.home/

This change is modelled on the dynamic libtraceevent patch by Michael
Petlan:
https://lore.kernel.org/linux-perf-users/20210428092023.4009-1-mpetlan@redhat.com/

v3. Adds file missed in v1 and v2 spotted by Jiri Olsa.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/build/Makefile.feature          |  1 +
 tools/build/feature/Makefile          |  4 ++++
 tools/build/feature/test-libtracefs.c | 10 ++++++++++
 tools/perf/Makefile.config            |  9 +++++++++
 tools/perf/Makefile.perf              |  2 ++
 5 files changed, 26 insertions(+)
 create mode 100644 tools/build/feature/test-libtracefs.c

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index 3dd2f68366f9..45a9a59828c3 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -52,6 +52,7 @@ FEATURE_TESTS_BASIC :=                  \
         libslang                        \
         libslang-include-subdir         \
         libtraceevent                   \
+        libtracefs                      \
         libcrypto                       \
         libunwind                       \
         pthread-attr-setaffinity-np     \
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index eff55d287db1..d024b5204ba0 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -36,6 +36,7 @@ FILES=                                          \
          test-libslang.bin                      \
          test-libslang-include-subdir.bin       \
          test-libtraceevent.bin                 \
+         test-libtracefs.bin                    \
          test-libcrypto.bin                     \
          test-libunwind.bin                     \
          test-libunwind-debug-frame.bin         \
@@ -199,6 +200,9 @@ $(OUTPUT)test-libslang-include-subdir.bin:
 $(OUTPUT)test-libtraceevent.bin:
 	$(BUILD) -ltraceevent
 
+$(OUTPUT)test-libtracefs.bin:
+	$(BUILD) -ltracefs
+
 $(OUTPUT)test-libcrypto.bin:
 	$(BUILD) -lcrypto
 
diff --git a/tools/build/feature/test-libtracefs.c b/tools/build/feature/test-libtracefs.c
new file mode 100644
index 000000000000..8eff16c0c10b
--- /dev/null
+++ b/tools/build/feature/test-libtracefs.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <tracefs/tracefs.h>
+
+int main(void)
+{
+	struct tracefs_instance *inst = tracefs_instance_create("dummy");
+
+	tracefs_instance_destroy(inst);
+	return 0;
+}
diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 446180401e26..00ec900ddbca 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -1098,6 +1098,15 @@ ifdef LIBTRACEEVENT_DYNAMIC
   endif
 endif
 
+ifdef LIBTRACEFS_DYNAMIC
+  $(call feature_check,libtracefs)
+  ifeq ($(feature-libtracefs), 1)
+    EXTLIBS += -ltracefs
+  else
+    dummy := $(error Error: No libtracefs devel library found, please install libtracefs-dev);
+  endif
+endif
+
 # Among the variables below, these:
 #   perfexecdir
 #   perf_include_dir
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index e04313c4d840..7df13e74450c 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -130,6 +130,8 @@ include ../scripts/utilities.mak
 #
 # Define LIBTRACEEVENT_DYNAMIC to enable libtraceevent dynamic linking
 #
+# Define LIBTRACEFS_DYNAMIC to enable libtracefs dynamic linking
+#
 
 # As per kernel Makefile, avoid funny character set dependencies
 unexport LC_ALL
-- 
2.33.0.464.g1972c5931b-goog

