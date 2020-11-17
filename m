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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C12DC2D0E4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 07:46:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBD7E2465B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 07:46:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D7qrmdH/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgKQHqJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 02:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgKQHqJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 02:46:09 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27881C0613CF
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:46:09 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id 1so783300wme.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BJ5wjN83iP8Lxl0yPkNqNceVG6U++HTErUt370BpT6U=;
        b=D7qrmdH/rJJih592lX+jcITb5TVq3Xk8xGy1exTzM8/JZLh7lZurQiA+ApGFRqFxVP
         t3LUGDlgBxRKpIotgu0Pz3mwaFp2SV1hfT7fuhb/jLT9eAljzCw5L5FOhmmU4g2GyAE8
         VG5IwYlG5bd7Re6j3iptlz3sFP93vglw45Zl/rIyDDMoDEUIAhAR3kHdWtdPAKWQwy0/
         w/qN0FvHpoRvvm65K+6c9bLJ9lRJ/I62ekAZQ9CZl3dRpKE/OEFzf42Pw98dro1FM7sA
         5YXCyEA+LVBp2sbzNhNh3dF9zbVSQ3Skj4T9AuVJ4ns9qNudymMF8nhtTX0UMNJDUAiA
         KgOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BJ5wjN83iP8Lxl0yPkNqNceVG6U++HTErUt370BpT6U=;
        b=eF3dCAZZkc5JTs9MRaN62P57aBGVvV/lilhYEjpUTzxXk+h+fnFL+r/ZxgP8XjUDGJ
         Gs1hMCetBtF3ZcLxiS+mTTwvkN7azrVWKgCPq9Mpk8wd5zTW304uhWwOHySCYYk722zu
         XAwzUjTl1yhx/LrpxDTGhRrHhUW2O07AZ+jiiWPC9juJ6Org/lJ+quW+6pDR6acbctDV
         HFmX1D8yNqwkl807+ClMtMWaA4IN53jemFOKfiRyOejDhcpF3Tn+B5JvF7L0CM1DmGxz
         XfsNF/JrEtnZQK7Npy55+RFV+7UQ+yOXgsWM21gVtAG3xHshh9Y8F0+F3iaajgpEsKGk
         ijhA==
X-Gm-Message-State: AOAM530bWQuoztv9+zeRwvy/RZg8A6a3pKtKm3+8VwBqutokfM9zdogj
        5A81H+ynlldGrBqm0zp1AU4=
X-Google-Smtp-Source: ABdhPJzReAdUXMWf5zVbIqMQxwhKWzwHDi0514S7jdAmiNRd+yp9qTRIG5XHplQGqul4RGoPO4Hm0w==
X-Received: by 2002:a1c:208f:: with SMTP id g137mr2789817wmg.116.1605599167930;
        Mon, 16 Nov 2020 23:46:07 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d3sm25752046wre.91.2020.11.16.23.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 23:46:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 7/8] trace-cmd: Add new libtrasefs API to get the current trace clock
Date:   Tue, 17 Nov 2020 09:45:56 +0200
Message-Id: <20201117074557.180602-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117074557.180602-1-tz.stoyanov@gmail.com>
References: <20201117074557.180602-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-stat.c          | 27 +++++---------------------
 utest/tracefs-utest.c          | 30 ++++++++++++++++++++++++++++-
 4 files changed, 71 insertions(+), 23 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index bcf3dd64..3358e33d 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -57,4 +57,6 @@ struct tep_handle *tracefs_local_events_system(const char *tracing_dir,
 int tracefs_fill_local_events(const char *tracing_dir,
 			       struct tep_handle *tep, int *parsing_failures);
 
+char *tracefs_get_clock(struct tracefs_instance *instance);
+
 #endif /* _TRACE_FS_H */
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index d05e08b1..e9e24ef8 100644
--- a/lib/tracefs/tracefs-instance.c
+++ b/lib/tracefs/tracefs-instance.c
@@ -418,3 +418,38 @@ out:
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
index e6678eab..31127872 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -710,33 +710,16 @@ static void report_buffers(struct buffer_instance *instance)
 
 static void report_clock(struct buffer_instance *instance)
 {
-	char *str;
-	char *cont;
+	struct tracefs_instance *tracefs = instance ? instance->tracefs : NULL;
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
+	clock = tracefs_get_clock(tracefs);
 
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
index c42fea12..78eda481 100644
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

