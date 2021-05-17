Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_12_24,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1528FC433B4
	for <linux-trace-devel@archiver.kernel.org>; Sun, 16 May 2021 09:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8F3E6023B
	for <linux-trace-devel@archiver.kernel.org>; Sun, 16 May 2021 09:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbhEPJZb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 16 May 2021 05:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbhEPJZa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 16 May 2021 05:25:30 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920A6C061573
        for <linux-trace-devel@vger.kernel.org>; Sun, 16 May 2021 02:24:16 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id m190so2649304pga.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 16 May 2021 02:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qSdr5d2iuVoDKhgo5YJwcN8F0wan+0cGyYnanvLRz9s=;
        b=FeJ+C1tWU8gSUC0ViCFAQpFblsQAnhCKobNEgeG63lyZO+JPg9eJXetRHABhXopqok
         JJJ3rpOBRDh9awPM3GzoycJ/S4n1dqib/RS9dSPP2Uezgzf6nZmlZTxJAaYCAsoe9APg
         LcoyrRH7+xc+IkZLJmnLlYE/d9Sxhu9l94sC8h1kllttOAFIfoL68ydMBZhqG4WpqBkj
         0sRYCwRrXixVxMYMd6L90DfM1IQBSqlHdtkAUDsSmdIIFGxgxh5cHGeN7RqACaaeMXUF
         6gSOd/aL4qnSgFyA/jWTpqBBU8iziLRdibuTKFUV+rE8DR2xT0VWee+Y2Y2OQLHs2PzM
         0VQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qSdr5d2iuVoDKhgo5YJwcN8F0wan+0cGyYnanvLRz9s=;
        b=gLjZciNS4HeSgF/LHpyoce5Ohq3IJyOLm0uSCDaWMN0cCjtewfEe+x7kAIkxcwAVSJ
         SNWpfFY3yk6p0VM5F9bA41FrG2s6OUmDNarnCTVI2ngGKe/+45SeLpj8Vx2RBKAlvjLV
         Q2sFNpmVrypHXyjckku5A7BMbZbjZcbT+EWi45VoVqGOlaiuSI4BOmQhQz84VJaiFR2A
         rVr9j08HdCJy0HofYX+oiLMHkHG3LG6dHa35WKNc4k9vQrepzSE4iM/NymfhBdFU2Bjf
         LgSJ4NHD8BIhYnOBuylTRJ2VoDWCCOgqCDzXmOIt6JxDapHmEgin1/UHoIcSJrdjBHL3
         HuYA==
X-Gm-Message-State: AOAM532pzqm5BKIvLGZCI+205L9QpsVygxqHDqf1KCOIrRRi/KAScCS4
        sykdTTnZKwmgdMyJyYpgssomh1k7AbY=
X-Google-Smtp-Source: ABdhPJytm8dZuV0SWC4eRxBy+h2p4kWqlp5OXtbbE29lUaOupCPwHF+rsTM1iMdh0gbUh+lgBrlofA==
X-Received: by 2002:a63:fe0e:: with SMTP id p14mr33915882pgh.116.1621157055932;
        Sun, 16 May 2021 02:24:15 -0700 (PDT)
Received: from localhost.localdomain ([45.118.75.3])
        by smtp.gmail.com with ESMTPSA id n5sm7440199pfo.40.2021.05.16.02.24.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 May 2021 02:24:15 -0700 (PDT)
From:   Sameeruddin shaik <sameeross1994@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Sameeruddin shaik <sameeross1994@gmail.com>
Subject: [PATCH] libtracefs: Add support for setting tracers
Date:   Mon, 17 May 2021 14:54:06 +0530
Message-Id: <1621243446-7402-1-git-send-email-sameeross1994@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

tracefs_set_tracer - set the tracer
tracefs_stop_tracer - clear the tracer

Signed-off-by: Sameeruddin shaik <sameeross1994@gmail.com>

diff --git a/include/tracefs.h b/include/tracefs.h
index 55ee867..0270a9e 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -173,4 +173,23 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 int tracefs_function_notrace(struct tracefs_instance *instance, const char *filter,
 			     const char *module, unsigned int flags);
 
+enum tracefs_tracers {
+	TRACEFS_TRACER_NOP = 0,
+	TRACEFS_TRACER_FUNCTION,
+	TRACEFS_TRACER_FUNCTION_GRAPH,
+	TRACEFS_TRACER_IRQSOFF,
+	TRACEFS_TRACER_PREEMPTOFF,
+	TRACEFS_TRACER_PREEMPTIRQSOFF,
+	TRACEFS_TRACER_WAKEUP,
+	TRACEFS_TRACER_WAKEUP_RT,
+	TRACEFS_TRACER_WAKEUP_DL,
+	TRACEFS_TRACER_MMIOTRACE,
+	TRACEFS_TRACER_HWLAT,
+	TRACEFS_TRACER_BRANCH,
+	TRACEFS_TRACER_BLOCK,
+};
+
+int tracefs_set_tracer(struct tracefs_instance *instance, enum tracefs_tracers tracer);
+
+int tracefs_stop_tracer(struct tracefs_instance *instance);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 6ef17f6..d772f93 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -25,6 +25,30 @@ __hidden pthread_mutex_t toplevel_lock = PTHREAD_MUTEX_INITIALIZER;
 #define TRACE_FILTER		"set_ftrace_filter"
 #define TRACE_NOTRACE		"set_ftrace_notrace"
 #define TRACE_FILTER_LIST	"available_filter_functions"
+#define CUR_TRACER		"current_tracer"
+
+#define TRACERS \
+	C(NOP,                  "nop"),			\
+	C(FUNCTION,             "function"),            \
+	C(FUNCTION_GRAPH,       "function_graph"),      \
+	C(IRQSOFF,              "irqsoff"),             \
+	C(PREEMPTOFF,           "preemptoff"),          \
+	C(PREEMPTIRQSOFF,       "preemptirqsoff"),      \
+	C(WAKEUP,               "wakeup"),              \
+	C(WAKEUP_RT,            "wakeup_rt"),	\
+	C(WAKEUP_DL,            "wakeup_dl"),           \
+	C(MMIOTRACE,            "mmiotrace"),           \
+	C(HWLAT,                "hwlat"),               \
+	C(BRANCH,               "branch"),              \
+	C(BLOCK,                "block")
+
+#undef C
+#define C(a, b) b
+const char *tracers[] = { TRACERS };
+
+#undef C
+#define C(a, b) TRACEFS_TRACER_##a
+const int tracer_enums[] = { TRACERS };
 
 /* File descriptor for Top level set_ftrace_filter  */
 static int ftrace_filter_fd = -1;
@@ -910,3 +934,68 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
 	tracefs_put_tracing_file(filter_path);
 	return ret;
 }
+
+int write_tracer(int fd, const char *tracer)
+{
+	int ret;
+
+	ret = write(fd, tracer, strlen(tracer));
+	if (ret < strlen(tracer))
+		return -1;
+	return ret;
+}
+
+/**
+ * tracefs_set_tracer - function to set the tracer
+ * @instance: ftrace instance, can be NULL for top tracing instance
+ * @tracer: Tracer that has to be set, which can be integer from 0 - 13
+ * or enum value
+ */
+
+int tracefs_set_tracer(struct tracefs_instance *instance, enum tracefs_tracers tracer)
+{
+	char *tracer_path = NULL;
+	const char *t = NULL;
+	int ret = -1;
+	int fd = -1;
+	int i;
+
+	tracer_path = tracefs_instance_get_file(instance, CUR_TRACER);
+	if (!tracer_path)
+		return -1;
+
+	fd = open(tracer_path, O_WRONLY);
+	if (fd < 0) {
+		errno = -ENOENT;
+		goto out;
+	}
+
+	if (tracer < 0 || tracer > ARRAY_SIZE(tracers)) {
+		errno = -ENODEV;
+		goto out;
+	}
+	if (tracer == tracer_enums[tracer])
+		t = tracers[tracer];
+	else {
+		for (i = 0; i < ARRAY_SIZE(tracer_enums); i++) {
+			if (tracer == tracer_enums[i]) {
+				t = tracers[i];
+				break;
+			}
+		}
+	}
+	if (!t) {
+		errno = -EINVAL;
+		goto out;
+	}
+	ret = write_tracer(fd, t);
+ out:
+	tracefs_put_tracing_file(tracer_path);
+	close(fd);
+	return ret;
+}
+
+int  tracefs_stop_tracer(struct tracefs_instance *instance)
+{
+	return tracefs_set_tracer(instance, TRACEFS_TRACER_NOP);
+}
-- 
2.7.4

