Return-Path: <SRS0=ZUfG=6F=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D97FC55182
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Apr 2020 10:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5672D2068F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Apr 2020 10:47:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jkBG4Wsp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgDUKrT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 21 Apr 2020 06:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgDUKrS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 06:47:18 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2CAC061A0F
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Apr 2020 03:47:18 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id w145so10729642lff.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Apr 2020 03:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QW1dIH+KiildWskugcpG7is+oI5bfoI2dgIK2AoZcjw=;
        b=jkBG4WsprvDjfWQVrn4bf+iOtA098mkss3iMKhVV984xJYx7uvzWfcTAVL5Kklbf+E
         wrBz0w5suOeclyJJTKLmkGbpFsXqkU0BKinS64asGqRoevd4DVF0re9S4ha4+1mIxNlJ
         i27XW80jCt/Hc/qRwAQV0qkUghqeHwvWcvaC6dKxMeFhiL8DliDusevpzY6HrMoKyA82
         zTEnzJvfLurDXOzy4PwKAcHLoBzOkmMMeS+Vi1yAP14X+QC29SgesqBNz5KoD+D6UAu2
         YI6reU/LqhsZ2PMUBPfd59vF98chv9i1o+YXZjEDU2M8EDUfu/pzPAguy11ubzjyBtky
         zo8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QW1dIH+KiildWskugcpG7is+oI5bfoI2dgIK2AoZcjw=;
        b=Rk3PAv8J10TpRQbR3Mi02UcWJt4jM8eoOfcCaijwc/WBBv5ti34r6dORU3ZsGkEzLk
         G3r+oh90gs11X+CQz0SgMBBZDRzEdhc++SG1zCNADh2dzRdXW6m0xl6uXNefn353cSOo
         z3EYd/BB1fJfZbRgK39Vo0K1p96GyWT/UKITY6QIAzfQYdToMg1wK2ZRHyCCxwzdmBvt
         /MWEP6+EIfnpaBzap6h/RWlb2Q+0dFWP73Ty6KQadpc3btfU+KTHowTkC8D5yczG9t5f
         25YyjLADALoV+kX4B0uIJ/nE6te2wwTRX5DZeSBHnJ4ILUlhX7N/I/ZTEN14/KRLDvn/
         1LeA==
X-Gm-Message-State: AGi0PuZaL7a8wyl3sxEjT04YutCSYFZRwz3egYQkE69Y7qH0fUtHa7Zg
        W9mj2elK7q6bVRxHxcCGaawLtC0epo4=
X-Google-Smtp-Source: APiQypKnUFoeBEus3ttCyJTbJ/CIir6RI623Jnfk4JSX8DuaBJwDzPs5ghFaqTyjs7xJqM3qgK1xaA==
X-Received: by 2002:a19:ee06:: with SMTP id g6mr13478547lfb.90.1587466037016;
        Tue, 21 Apr 2020 03:47:17 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id m23sm1680202ljb.87.2020.04.21.03.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 03:47:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Add helper function to print content of a trace file
Date:   Tue, 21 Apr 2020 13:47:12 +0300
Message-Id: <20200421104713.31762-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200421104713.31762-1-tz.stoyanov@gmail.com>
References: <20200421104713.31762-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

trace-cmd stat command prints various information about the current
ftrace configuration. Some of it is just a dump of a ftrace file.
These functions from trace-stat.c have almost the same logic:
 report_plugin()
 report_latency()
 report_errorlog()
A helper function is added, implementing this common logic:
 report_file()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-stat.c | 77 ++++++++++++-------------------------------
 1 file changed, 21 insertions(+), 56 deletions(-)

diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index c5057978..2e3d83c3 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -122,6 +122,24 @@ static char *get_instance_file_content(struct buffer_instance *instance,
 	return str;
 }
 
+static void report_file(struct buffer_instance *instance,
+			char *name, char *def_value, char *description)
+{
+	char *str;
+	char *cont;
+
+	if (!tracefs_file_exists(instance->tracefs, name))
+		return;
+	str = get_instance_file_content(instance, name);
+	if (!str)
+		return;
+	cont = strstrip(str);
+	if (cont[0] && strcmp(cont, def_value))
+		printf("\n%s%s\n", description, cont);
+
+	free(str);
+}
+
 static void report_instances(void)
 {
 	struct dirent *dent;
@@ -166,26 +184,6 @@ out:
 	tracefs_put_tracing_file(path);
 }
 
-static void report_plugin(struct buffer_instance *instance)
-{
-	char *str;
-	char *cont;
-
-	str = get_instance_file_content(instance, "current_tracer");
-	if (!str)
-		return;
-
-	cont = strstrip(str);
-
-	/* We only care if the plugin is something other than nop */
-	if (strcmp(cont, "nop") == 0)
-		goto out;
-
-	printf("\nTracer: %s\n", cont);
- out:
-	free(str);
-}
-
 struct event_iter *trace_event_iter_alloc(const char *path)
 {
 	struct event_iter *iter;
@@ -817,23 +815,6 @@ static void report_cpumask(struct buffer_instance *instance)
 	free(str);
 }
 
-static void report_latency(struct buffer_instance *instance)
-{
-	char *str;
-	char *cont;
-
-	str = get_instance_file_content(instance, "tracing_max_latency");
-	if (!str)
-		return;
-
-	cont = strstrip(str);
-
-	if (strcmp(cont, "0") != 0)
-		printf("\nMax Latency: %s\n", cont);
-
-	free(str);
-}
-
 static void report_probes(struct buffer_instance *instance,
 			  const char *file, const char *string)
 {
@@ -897,22 +878,6 @@ static void report_traceon(struct buffer_instance *instance)
 	free(str);
 }
 
-static void report_errorlog(struct buffer_instance *instance)
-{
-	char *str;
-
-	if (!tracefs_file_exists(instance->tracefs, "error_log"))
-		return;
-	str = get_instance_file_content(instance, "error_log");
-	if (!str)
-		return;
-
-	if (str[0])
-		printf("\nError log:\n%s\n", str);
-
-	free(str);
-}
-
 static void stat_instance(struct buffer_instance *instance)
 {
 	if (instance != &top_instance) {
@@ -923,7 +888,7 @@ static void stat_instance(struct buffer_instance *instance)
 	} else
 		report_instances();
 
-	report_plugin(instance);
+	report_file(instance, "current_tracer", "nop", "Tracer: ");
 	report_events(instance);
 	report_event_filters(instance);
 	report_event_triggers(instance);
@@ -932,11 +897,11 @@ static void stat_instance(struct buffer_instance *instance)
 	report_buffers(instance);
 	report_clock(instance);
 	report_cpumask(instance);
-	report_latency(instance);
+	report_file(instance, "tracing_max_latency", "0", "Max Latency: ");
 	report_kprobes(instance);
 	report_uprobes(instance);
 	report_traceon(instance);
-	report_errorlog(instance);
+	report_file(instance, "error_log", "", "Error log:\n");
 }
 
 void trace_stat (int argc, char **argv)
-- 
2.25.3

