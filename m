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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA63C433B4
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 May 2021 14:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9437F613C3
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 May 2021 14:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhEOPBJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 15 May 2021 11:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhEOPBG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 15 May 2021 11:01:06 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D45FC061573
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 May 2021 07:59:34 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id t193so1416531pgb.4
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 May 2021 07:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GC0mNi5szyvRwcvfriG4/8Gr3QiQkFJXfcuB7PlmI9I=;
        b=Dw/mdAhdD3hzykqB04lrXOrOQlKqZFTO/IGCGj9nKRpt00qRni1Bn1LPQLP015cQ0u
         qzCv4E7IDGZpsmE8eo12LreT2BQJijEo1wGQ2jr0Ip8KZk6BUAlFbUNxSuZAkrAuIrNl
         OGLwVObrJVNImPhU8eMrZQ3mtxCON01su7diCEqldnzsBPVy50BCkl/kla3QgekeM5VC
         EBY19uc841+zwjoiFCwP9RHUW8EutFDRwmKOL2WjhaUm0OB+mFYnQQJxLcKvrRnNzMXf
         w2jal6YQfKmTfpz8ksfsxi+IwL71TInQdpoaKj00tcOeo3x13UIzVHoF8wTzhANtFrj6
         Pmow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GC0mNi5szyvRwcvfriG4/8Gr3QiQkFJXfcuB7PlmI9I=;
        b=Dn70wOPg266AEknK1gT0CacpzBIcc5kPh1bGbA2+CCBeu0/eiNV9hI8E+IEPa+13xr
         gvhGHGwaa3YX9KeFSlU10VhwNUQBfb5h++tduAWg/G4g+gDorGA/K0wg7S5Id9E7b5He
         6q80gDoS7j5xS+OmWqnGA9hNAtPQr+MulbMCUVfPTlHQFf8ZUIjdwkUv/0MC7/Of7Pqq
         e4jXkAibRZLTc2sioF/S1iCdy5Vvh4Gsb2ZwaRbMUx+ELIuVrtdU/DcS9pyFhVuMDjkc
         24LXbNLBavGcdEL/Irz6tOvJjQbJNwiXJbcxiMdvOLF/Tojp4EKevomuCJGpNirxru8Y
         yP1A==
X-Gm-Message-State: AOAM530tXwnZPEmY/nE62xENgNaIGSlAAMIfepqD8RQChsgWtxFAIq9U
        i/xLS+NvCmRGo0zKg9JCesU=
X-Google-Smtp-Source: ABdhPJxf9+xk23hYPidDNm2h/Iy//LeaB270twTCRedeQ8XuO0F2SipNlrJsQvReZakW1NbMCeRAcw==
X-Received: by 2002:a63:ba5b:: with SMTP id l27mr52901222pgu.343.1621090774061;
        Sat, 15 May 2021 07:59:34 -0700 (PDT)
Received: from localhost.localdomain ([45.118.75.3])
        by smtp.gmail.com with ESMTPSA id w123sm6080724pfw.151.2021.05.15.07.59.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 May 2021 07:59:33 -0700 (PDT)
From:   Sameeruddin shaik <sameeross1994@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Sameeruddin shaik <sameeross1994@gmail.com>
Subject: [PATCH] libtracefs: Add support for setting tracers
Date:   Sun, 16 May 2021 20:29:19 +0530
Message-Id: <1621177159-28156-1-git-send-email-sameeross1994@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

tracefs_set_tracer - set the tracer
tracefs_stop_tracer - clear the tracer

Signed-off-by: Sameeruddin shaik <sameeross1994@gmail.com>

diff --git a/include/tracefs.h b/include/tracefs.h
index 55ee867..47d3282 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -173,4 +173,26 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 int tracefs_function_notrace(struct tracefs_instance *instance, const char *filter,
 			     const char *module, unsigned int flags);
 
+/*
+ * Tracers
+ */
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
index 6ef17f6..ceddeda 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -25,6 +25,7 @@ __hidden pthread_mutex_t toplevel_lock = PTHREAD_MUTEX_INITIALIZER;
 #define TRACE_FILTER		"set_ftrace_filter"
 #define TRACE_NOTRACE		"set_ftrace_notrace"
 #define TRACE_FILTER_LIST	"available_filter_functions"
+#define TRACER			"current_tracer"
 
 /* File descriptor for Top level set_ftrace_filter  */
 static int ftrace_filter_fd = -1;
@@ -910,3 +911,88 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
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
+* tracefs_set_tracer - fucntion to set the tracer
+* @instance: ftrace instance, can be NULL for top tracing instance
+* @tracer: Tracer that has to be set, which can be integer from 0 - 13
+* or and enum value
+*/
+
+int tracefs_set_tracer(struct tracefs_instance *instance, enum tracefs_tracers tracer)
+{
+	char *tracer_path;
+	int ret = -1;
+	int fd = -1;
+
+	tracer_path = tracefs_instance_get_file(instance, TRACER);
+	if (!tracer_path)
+		return -1;
+
+	fd = open(tracer_path, O_WRONLY);
+	if (fd < 0)
+		goto out;
+
+	switch(tracer) {
+	case 0:
+		ret = write_tracer(fd , "nop");
+		break;
+	case 1:
+		ret = write_tracer(fd, "function");
+		break;
+	case 2:
+		ret = write_tracer(fd, "function_graph");
+		break;
+	case 3:
+		ret = write_tracer(fd, "irqsoff");
+		break;
+	case 4:
+		ret = write_tracer(fd, "preemptoff");
+		break;
+	case 5:
+		ret = write_tracer(fd, "preemptirqsoff");
+		break;
+	case 6:
+		ret = write_tracer(fd, "wakeup");
+		break;
+	case 7:
+		ret = write_tracer(fd, "wakeup_rt");
+		break;
+	case 8:
+		ret = write_tracer(fd, "wakeup_dl");
+		break;
+	case 9:
+		ret = write_tracer(fd, "mmiotrace");
+		break;
+	case 10:
+		ret = write_tracer(fd, "hwlat");
+		break;
+	case 11:
+		ret = write_tracer(fd, "branch");
+		break;
+	case 12:
+		ret = write_tracer(fd, "blk");
+		break;
+	default:
+		ret = -1;
+	}
+
+ out:
+	tracefs_put_tracing_file(tracer_path);
+	return ret;
+}
+
+int  tracefs_stop_tracer(struct tracefs_instance *instance)
+{
+	return tracefs_set_tracer(instance, TRACEFS_TRACER_NOP);
+}
-- 
2.7.4

