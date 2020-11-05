Return-Path: <SRS0=ZY51=EL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC2CC388F7
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 09:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 502B920825
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 09:34:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="laMLCb0y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730980AbgKEJeJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 04:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730933AbgKEJeI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 04:34:08 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2476C0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Nov 2020 01:34:07 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id cw8so1621963ejb.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Nov 2020 01:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vDFdkMfzIupewQ9sfp+/jx3ScPJgrltT2ndr1MmEWSE=;
        b=laMLCb0y0g0a3nT2kwPU/KWhYrUNsuXyqJVd9teXcjtnTGtXcLa7xkpiumBBAGMd0U
         283qODhLtmUl0EC+B49W0q7r7ZSaGaKQ/7kqs2gv9CIwxet84tOPszXIaVz1lbYmqelo
         +Ved3KT+IV/NiPOgNPGRUjB0jK5emKQK+/Au7eaqdzAU4qme07pQ/SwU7ra/SjeaZ3Ht
         qD1FrX1SiU821epD3Qk+WS+nzYvcdiiBIkTMwibB/NziHx8r+ygpQF3olysnHxWyUNOA
         SKJczJAytLh0exjcwQlbb3k32J20RUcB+ax/sGY0F6pZEtrXwk+6TVkWyEZToq6Z3cyk
         MXlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vDFdkMfzIupewQ9sfp+/jx3ScPJgrltT2ndr1MmEWSE=;
        b=j0QDVFyn4oZLc86OeYEOuc7mHa9260JDpgL2IglSnI08WHdQH1T783SUikPXPRbbRU
         r7pGMBZ/aMvN0nLZOXLGwoqfLn74C/Wd0kgKyh5embfGSDaqqp0B2jdgnWWkxXlK9W5Z
         Nt+XEsx4u0kpPL7Gkp77IElelnH/fwatWr4B0ycTloSdhnSBP8tfTKqquW8rM71hUQyn
         +yccG6NnG4aZNlqcIiiMgTH5Oz1XnAhH1JwIc6qBSEhxsDvitLa7g1/d0L1BWbjdnMlC
         MiBja571t1EmOvp9tjBGgx3hI7qrQFXxDhglvzpRjh7Qp/cNOfiXKFGNxUFVXGTWyLDb
         Vizw==
X-Gm-Message-State: AOAM532EdHyItzJ87ehThnK9cH1bvehrdUDDa7fH0WSTAmgFGnbvJImZ
        2KssuKt/X3i4ghrQHqdfalc=
X-Google-Smtp-Source: ABdhPJzOzj3e0XpoHQK7QEZb5SPbNJ+xVFUZUZFsBGiVqREqJ+csb4qAN8zMNTq7+XD9OejTpQ6ThA==
X-Received: by 2002:a17:906:b084:: with SMTP id x4mr1489618ejy.374.1604568846491;
        Thu, 05 Nov 2020 01:34:06 -0800 (PST)
Received: from localhost.localdomain ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 1sm586725ejt.107.2020.11.05.01.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 01:34:05 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 6/6] trace-cmd: Add new libtrasefs API to get the current trace clock
Date:   Thu,  5 Nov 2020 11:33:54 +0200
Message-Id: <20201105093354.532742-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201105093354.532742-1-tz.stoyanov@gmail.com>
References: <20201105093354.532742-1-tz.stoyanov@gmail.com>
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
index 40781bb2..ad4ffa07 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -56,4 +56,6 @@ struct tep_handle *tracefs_local_events_system(const char *tracing_dir,
 int tracefs_fill_local_events(const char *tracing_dir,
 			       struct tep_handle *tep, int *parsing_failures);
 
+char *tracefs_get_clock(struct tracefs_instance *instance);
+
 #endif /* _TRACE_FS_H */
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index 777d5965..d3b9e100 100644
--- a/lib/tracefs/tracefs-instance.c
+++ b/lib/tracefs/tracefs-instance.c
@@ -377,3 +377,38 @@ out:
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
index 04fc8a1b..3a0347aa 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -504,6 +504,33 @@ static void test_instances_walk(void)
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
@@ -549,5 +576,6 @@ void test_tracefs_lib(void)
 		    test_local_events);
 	CU_add_test(suite, "tracefs_instances_walk API",
 		    test_instances_walk);
-
+	CU_add_test(suite, "tracefs_get_clock API",
+		    test_get_clock);
 }
-- 
2.28.0

