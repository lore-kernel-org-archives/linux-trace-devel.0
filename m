Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_12_24,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32631C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 16:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 190FD611C2
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 16:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244672AbhEQQf0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 12:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244135AbhEQQfI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 12:35:08 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AF0C01CD42
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 08:27:00 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id a11so3341656plh.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 08:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MZwqKEADkEIsRDUN2WFJK99JI8/R7C51kb4KVVYukgo=;
        b=qCeLeYcHB+klLJvBwhrd7ZPGxpT0o3qj0hZegS3ZUklxMC/vr7R1C2KHztza1uOmQh
         EeZuDXyi0ofYvzpZBmuumA+pLiIc6sxm9iR0od4SBlAZt1oEDrENqgc7FRQnKQonDw/p
         05mV6UE86+7uI/vg14TjEMVR8POJfudHYiE/yux5GcbWIXb3cuWj5/gkhqPVvIq2oiJt
         sNdTS9PHkdNsbPyCoWacU+8Ft6q4UMhC9CUSXdypLh58g2e7F8NmVI0XpTu8FIDPTdft
         8lIZkt16fOauaukjqfuA770AIubp6+uLJe1k2TbKvV5FUtCZVWf4V9khZ3GRmQ+yyuca
         EtMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MZwqKEADkEIsRDUN2WFJK99JI8/R7C51kb4KVVYukgo=;
        b=iotJGGN4wps3G20mvtJoyZJR1kfWMDGHCwOMQi+/oaSNblMQWs5goXN5NkSkvWC0QP
         4aj1Nej0U8/BnNXOczwa04mCHm0FMQf3mwXQUB/CX0NmqzcIXpMPjcDxVXjFB5MqEVMY
         g0LPIjb9Tt9lk1b7bHSLmxMOS1OGDg2uxNHAdtz97FQ6YAVq0e0AntCE2j/HiNQZtsE6
         n0UG6Ty45IqjqPEwi53K4gw9tpZpeSseCD0U6gA+ikJ47+X2aZBHas8K3WueIgRVbH1W
         +Nl/VsYtOoJgdKbD6TgS0ubwgewh+Bxq5V3dJoJZ3xvCtSijGpSNWmoCAI2+nGKSecNF
         cxDA==
X-Gm-Message-State: AOAM530pknZHIfCGV/81FVTqgHZf35oVtjhv1S6d/XeR0AlYtwPW8C/T
        N4Ze1R43XvSeAuKDsEYKtCs=
X-Google-Smtp-Source: ABdhPJwACJqpofZbwZ+0lom7BEck0KeBP2Ij8vpo3o++HlaLWIe495jIYnT/V0ZBQR+MqKh+UiIdPw==
X-Received: by 2002:a17:902:d4c3:b029:ee:ae62:9fb7 with SMTP id o3-20020a170902d4c3b02900eeae629fb7mr612691plg.8.1621265220601;
        Mon, 17 May 2021 08:27:00 -0700 (PDT)
Received: from localhost.localdomain ([45.118.75.3])
        by smtp.gmail.com with ESMTPSA id p1sm9924398pfp.137.2021.05.17.08.26.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 May 2021 08:27:00 -0700 (PDT)
From:   Sameeruddin shaik <sameeross1994@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        Sameeruddin shaik <sameeross1994@gmail.com>
Subject: [PATCH] libtracefs: Add support for setting tracers
Date:   Tue, 18 May 2021 20:56:42 +0530
Message-Id: <1621351602-3703-1-git-send-email-sameeross1994@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

tracefs_tracer_set - set the tracer
tracefs_tracer_clear - clear the tracer

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sameeruddin shaik <sameeross1994@gmail.com>

diff --git a/include/tracefs.h b/include/tracefs.h
index 55ee867..e261b8a 100644
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
+int tracefs_tracer_set(struct tracefs_instance *instance, enum tracefs_tracers tracer);
+
+int tracefs_tracer_clear(struct tracefs_instance *instance);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 6ef17f6..f535231 100644
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
+ * @tracer: Tracer that has to be set, which can be integer from 0 - 12
+ * or enum value
+ */
+
+int tracefs_tracer_set(struct tracefs_instance *instance, enum tracefs_tracers tracer)
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
+int  tracefs_tracer_clear(struct tracefs_instance *instance)
+{
+	return tracefs_tracer_set(instance, TRACEFS_TRACER_NOP);
+}
-- 
2.7.4

