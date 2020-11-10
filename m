Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7620C55ABD
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Nov 2020 12:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85DDC206E3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Nov 2020 12:23:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VXBzKPTq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730368AbgKJMXC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Nov 2020 07:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730299AbgKJMXB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 07:23:01 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13ADC0613CF
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Nov 2020 04:23:00 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id oq3so17270985ejb.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Nov 2020 04:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O6Btt4mcRaXSFhkznXITIe2kjeYx4czc7jB2oIQRiDw=;
        b=VXBzKPTqSnLtGHE+vZYCuHVTQD4KrIvnH0mOSdK2KQ/zv0DI/RVKup4pT9Q3V68I4N
         3XwKd9wAdqynkFXj5p9jxz/ha5oSIbKIvhbpsbZXcMhqIsOjOkuOI9lzXgSHGxP1AZp6
         i/zNB6VUcVVF4btpw4yynOGkssJaD8M8yOdVGeT3rRrsYxLYjJ7vdLwbjXlbFS1/8m6B
         WdJ8+z4eFOuHDHT4/8oZpCeLPAWK4GOS7sPlfurH/Zw1wxZMveNCN7ynJTzDeg5MVwPu
         YsrymG5tVicEvV674r//97p2/InEdWlrYYz1EnL90ATwf2Js4l0ot1ZzvYDz6WJ4ccfb
         h62Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O6Btt4mcRaXSFhkznXITIe2kjeYx4czc7jB2oIQRiDw=;
        b=JV5+y3bCwMXugRa8UhJIehvqTRX1JwGh8GxRkrEO9EJ+i4La9UPUqnmVWY1sEl6wXP
         I3oGGdNQJNhpZQCzX4topIhcP2lsEff7mvqAFf7j1bAINKmxddHHPmh1HVslD+Ek3j7b
         1m6CO8NVmcP0CTtbjDkt1E3T3pWDKrOH5uxSNJM4m7SZotP+Pptaizi1b2rA/gVut6/P
         ExnKF5VrsJhOTO+/gMPwU0p+dFIsIjtG3I9Chf6+pPU3dSJ6RoQmJ/KSvdXBQml93UoC
         8cIMe7eVAUBUUkG4dCyyy7uXB7v0ajN6JtLaABMc7qyZvw92biIjBWt2rGu4FW8kC91W
         jn6w==
X-Gm-Message-State: AOAM532bokfjgzrKvLkbI7PZCuGtdz6syM4dJDjZOo7u5lcijK54bnzu
        /MgHj1LpjrL1ojjqhiLWcV2LcnewV8UEpDMr
X-Google-Smtp-Source: ABdhPJxUlBn6upSDakUS/YXpRU86qDP53JI4jwuuP8WFSJ0pJNEJ7zVd59LEFD3Y0H2dL03S/zLe5w==
X-Received: by 2002:a17:906:1989:: with SMTP id g9mr18754361ejd.62.1605010979711;
        Tue, 10 Nov 2020 04:22:59 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h9sm10204156ejk.118.2020.11.10.04.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 04:22:59 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 6/6] trace-cmd: Add new libtrasefs API to get the current trace clock
Date:   Tue, 10 Nov 2020 14:22:49 +0200
Message-Id: <20201110122249.911664-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110122249.911664-1-tz.stoyanov@gmail.com>
References: <20201110122249.911664-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new API is added to tracefs library:
	tracefs_get_clock()
It reads the trace_clock file from the ftrace file system, parses it
and returns a string with the current trace clock. The returned string
must be freed by free().

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs/tracefs.h      |  2 ++
 lib/tracefs/tracefs-instance.c | 35 ++++++++++++++++++++++++++++++++++
 tracecmd/trace-stat.c          | 29 +++++++---------------------
 utest/tracefs-utest.c          | 30 ++++++++++++++++++++++++++++-
 4 files changed, 73 insertions(+), 23 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index e796462a..07269cee 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -57,4 +57,6 @@ struct tep_handle *tracefs_local_events_system(const char *tracing_dir,
 int tracefs_fill_local_events(const char *tracing_dir,
 			       struct tep_handle *tep, int *parsing_failures);
 
+char *tracefs_get_clock(struct tracefs_instance *instance);
+
 #endif /* _TRACE_FS_H */
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index 5ff313c7..6158804c 100644
--- a/lib/tracefs/tracefs-instance.c
+++ b/lib/tracefs/tracefs-instance.c
@@ -394,3 +394,38 @@ out:
 	tracefs_put_tracing_file(path);
 	return fret;
 }
+
+/**
+ * tracefs_get_clock - Get the current trace clock
+ * @instance: ftrace instance, can be NULL for the top instance
+ *
+ * Returns the current trace clock of the given instance, or NULL in
+ * case of an error.
+ * The return string must be freed by free()
+ */
+char *tracefs_get_clock(struct tracefs_instance *instance)
+{
+	char *all_clocks = NULL;
+	char *ret = NULL;
+	int bytes = 0;
+	char *clock;
+	char *cont;
+
+	all_clocks  = tracefs_instance_file_read(instance, "trace_clock", &bytes);
+	if (!all_clocks || !bytes)
+		goto out;
+
+	clock = strstr(all_clocks, "[");
+	if (!clock)
+		goto out;
+	clock++;
+	cont = strstr(clock, "]");
+	if (!cont)
+		goto out;
+	*cont = '\0';
+
+	ret = strdup(clock);
+out:
+	free(all_clocks);
+	return ret;
+}
diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index e6678eab..9b61a14f 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -710,33 +710,18 @@ static void report_buffers(struct buffer_instance *instance)
 
 static void report_clock(struct buffer_instance *instance)
 {
-	char *str;
-	char *cont;
 	char *clock;
 
-	str = get_instance_file_content(instance, "trace_clock");
-	if (!str)
-		return;
-
-	clock = strstr(str, "[");
-	if (!clock)
-		goto out;
-	clock++;
-
-	cont = strstr(clock, "]");
-	if (!cont) /* should never happen */
-		goto out;
-
-	*cont = '\0';
+	if (instance)
+		clock = tracefs_get_clock(instance->tracefs);
+	else
+		clock = tracefs_get_clock(NULL);
 
 	/* Default clock is "local", only show others */
-	if (strcmp(clock, "local") == 0)
-		goto out;
+	if (clock && !strcmp(clock, "local") == 0)
+		printf("\nClock: %s\n", clock);
 
-	printf("\nClock: %s\n", clock);
-
- out:
-	free(str);
+	free(clock);
 }
 
 static void report_cpumask(struct buffer_instance *instance)
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 7e9fe738..798fedb8 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -511,6 +511,33 @@ static void test_instances_walk(void)
 	}
 }
 
+static void current_clock_check(const char *clock)
+{
+	int size = 0;
+	char *clocks;
+	char *str;
+
+	clocks = tracefs_instance_file_read(test_instance, "trace_clock", &size);
+	CU_TEST(clocks != NULL);
+	CU_TEST(size > strlen(clock));
+	str = strstr(clocks, clock);
+	CU_TEST(str != NULL);
+	CU_TEST(str != clocks);
+	CU_TEST(*(str - 1) == '[');
+	CU_TEST(*(str + strlen(clock)) == ']');
+	free(clocks);
+}
+
+static void test_get_clock(void)
+{
+	const char *clock;
+
+	clock = tracefs_get_clock(test_instance);
+	CU_TEST(clock != NULL);
+	current_clock_check(clock);
+	free((char *)clock);
+}
+
 static int test_suite_destroy(void)
 {
 	tracefs_instance_destroy(test_instance);
@@ -556,5 +583,6 @@ void test_tracefs_lib(void)
 		    test_local_events);
 	CU_add_test(suite, "tracefs_instances_walk API",
 		    test_instances_walk);
-
+	CU_add_test(suite, "tracefs_get_clock API",
+		    test_get_clock);
 }
-- 
2.28.0

