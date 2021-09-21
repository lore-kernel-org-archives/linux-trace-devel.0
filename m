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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C55BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Sep 2021 20:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F1DD61156
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Sep 2021 20:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbhIUUuU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 21 Sep 2021 16:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234573AbhIUUuU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Sep 2021 16:50:20 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C3BC061575
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Sep 2021 13:48:51 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 13-20020ac8560d000000b0029f69548889so3609087qtr.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Sep 2021 13:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=SS8p382b/+MpzDEKHFqeki4mKVdeQdYY0H5NNgwH11A=;
        b=X3Fii41kydfo469RvTRIPRGu6D4NahUVyM1IpsOidXGdWldWHkUvhW2Vo9lN/LfOOd
         QFbtEMYXDNsaAbZM2qqgsULT4RqKHX6euBQPSLKnOjBwHjSeKYQp0oBHxRZUw63622BM
         AH+RbuQq3XuvOdajQxiR3SOys/l38Gkm/LKv+msY6QMovpYDxS6sv+JqTo2qS/BkOdc2
         6CUPke8MWARLJrNS2u/gOutk7TS6gL6EPCxRlDkkR8KOHxOl7R6quAGJZhIUJhpIRhWo
         S59HIYRLPLwOhnGUpMVrfMItPtQm4H+hdSrFSmU+XMCP3PNvuM9L8E1I/ZHAmLArzmdf
         L3qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=SS8p382b/+MpzDEKHFqeki4mKVdeQdYY0H5NNgwH11A=;
        b=1iZcxXiJi8DTiWgdfXvOtNgyb81FiL9W5d/rTUSF4r6RvPNPxtNItINs+Q0RolyTw4
         BiDauLwoh6mLMC2v0abrSCmtT59CmcuF/RVkoWgqCpl8zhWBn29DqHu1leMGjaaZP3WB
         1QfuHz3LdoVkWRbVTsrgGlWKEtA2yXfG/gDtoxIOsJre3ucHRgz1rFMYu6zulDDEJXte
         G+nsborsRKlFdrztmCATyV430dk+Cec7eam+B5rziTjxuG6JLatHzSFjBTAJG6loXn66
         f8Fro/99XDKpictNntu8vkbjd+Mwi3TuR96EhZGp8DCb5hVH6fS37YyIXrQaTAX4/RHc
         RYxg==
X-Gm-Message-State: AOAM5322t7COi/jmyR8Z2b/4UbL2ojh72oB9udFYxwBXfNyNHNXzUBNI
        zwL6PKPFQwS5oRBlHzR6hzM9R9PeDb86
X-Google-Smtp-Source: ABdhPJzcwyxZUGyLCqvEi6klZbQxxfa2zzSLXp8Z7ILqpWhvTXUEbxebpLk0txplencstN7nXLnwlS/+CzjX
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:dffa:819a:f0e2:47e])
 (user=irogers job=sendgmr) by 2002:a05:6214:13a3:: with SMTP id
 h3mr32949438qvz.26.1632257330641; Tue, 21 Sep 2021 13:48:50 -0700 (PDT)
Date:   Tue, 21 Sep 2021 13:48:36 -0700
Message-Id: <20210921204839.236840-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 1/4] perf: Enable libtracefs dynamic linking
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

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/build/Makefile.feature | 1 +
 tools/build/feature/Makefile | 4 ++++
 tools/perf/Makefile.config   | 9 +++++++++
 tools/perf/Makefile.perf     | 2 ++
 4 files changed, 16 insertions(+)

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

