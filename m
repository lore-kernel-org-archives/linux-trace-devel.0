Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC2E7C00140
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Aug 2022 03:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiHODQ0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 14 Aug 2022 23:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiHODQI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 14 Aug 2022 23:16:08 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FABA12A98
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Aug 2022 20:16:07 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id h27so349872qkk.9
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Aug 2022 20:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=G3Q2jbAGUdzK9cB96Rx7tW21W8T4dfzk0bJR6ce9sqo=;
        b=wkP+uvolg6sAKV49TLsifAeVbOb7dUtFXdQo1HOB2Qk6+Yf8ejZjNV1MPRqMGtxwMj
         e0AO8VAhWc7Wxw10U1mJFU1dQsKGpRiuVFttt9DMQJROd7NyP3nkKPKB34vFZoAKiLjS
         g5ItuRTtEYz8KL3+fQu7bzk52Y+bOlncujWrE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=G3Q2jbAGUdzK9cB96Rx7tW21W8T4dfzk0bJR6ce9sqo=;
        b=SQgUc8p4Uqn0kHqdZFRXKcPaAZys6iUi4/kfCAaOgk2lKuvJeZMHAny1wk2MT2y9Ug
         eVYzStZ70HR3o3utMChdZ0BJZUXSFcJYeWs3F0L6Ogfk2cqfcJr9fyNrfM5j+YPBXXv4
         YbVxQjlZ1bEf6f4gN7R5XiRghthhxeie7PwE5rWuSo9On7wS3/7OJP2dMILCXdqTDeKS
         IYIdE0Kwjl3coQFiYbwKMG8sGv77QoCE0vrAEgOrGA8zp5c2fW5Ads6fWnmZrp3Mpt++
         4eR/eKkFqDI7D2eEO1FlXJblZLttW4TxWQYNauRG63Z9uFWs5GqOL7BVZoG3U/1gSi1L
         ZyGg==
X-Gm-Message-State: ACgBeo2hgg50oVuGjA+9x65Ecw5LRtz4wA12QFxD3ZseN0EAF584k+eG
        YLVvHN13pr1C/gtmlzyYUCI3glKcyT908w==
X-Google-Smtp-Source: AA6agR5TZJfCyg632y0mQbFlUsR0ZZ1M63e8g6aPyyxYZ8Y+roV5rtmqSH8k+lnvago0jP1L2RPPig==
X-Received: by 2002:a37:afc5:0:b0:6b8:6a6b:bd10 with SMTP id y188-20020a37afc5000000b006b86a6bbd10mr10115392qke.596.1660533366526;
        Sun, 14 Aug 2022 20:16:06 -0700 (PDT)
Received: from localhost.localdomain (c-73-148-104-166.hsd1.va.comcast.net. [73.148.104.166])
        by smtp.gmail.com with ESMTPSA id 2-20020ac85742000000b0031eeecd21d6sm7675450qtx.69.2022.08.14.20.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 20:16:06 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH] libtraceevent: Fixing linking to C++ code
Date:   Sun, 14 Aug 2022 23:15:51 -0400
Message-Id: <20220815031551.775444-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Linking in C++ compilers (including g++) causes references to be created
with their arguments. Due to this, trace library headers included into
C++ code base will cause their objects to built with symbols with
arguments. Apparently this is to support operator overloading in C++.

This causes linker errors. For example, here's what I get when I try to
link libtraceevent with a main.o built from a C++ main.cc source file.

 main.cc:(.text+0x90):
	undefined reference to `trace_seq_init(trace_seq*)'
	undefined reference to `trace_seq_do_printf(trace_seq*)'
	undefined reference to `tep_event_fields(tep_event*)'

The standard fix for this is to wrap the C project's header in
extern "C".

With this patch, I am able to link libtraceevent into a C++
code base.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/traceevent/event-parse.h | 8 ++++++++
 include/traceevent/trace-seq.h   | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 0b911e1..9d7634e 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -14,6 +14,10 @@
 
 #include "trace-seq.h"
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 #ifndef __maybe_unused
 #define __maybe_unused __attribute__((unused))
 #endif
@@ -778,4 +782,8 @@ void tep_set_loglevel(enum tep_loglevel level);
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field);
 
+#ifdef __cplusplus
+}
+#endif
+
 #endif /* _PARSE_EVENTS_H */
diff --git a/include/traceevent/trace-seq.h b/include/traceevent/trace-seq.h
index d68ec69..217492f 100644
--- a/include/traceevent/trace-seq.h
+++ b/include/traceevent/trace-seq.h
@@ -10,6 +10,10 @@
 #include <stdarg.h>
 #include <stdio.h>
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 /* ----------------------- trace_seq ----------------------- */
 
 #ifndef TRACE_SEQ_BUF_SIZE
@@ -52,4 +56,8 @@ extern void trace_seq_terminate(struct trace_seq *s);
 extern int trace_seq_do_fprintf(struct trace_seq *s, FILE *fp);
 extern int trace_seq_do_printf(struct trace_seq *s);
 
+#ifdef __cplusplus
+}
+#endif
+
 #endif /* _TRACE_SEQ_H */
-- 
2.25.1

