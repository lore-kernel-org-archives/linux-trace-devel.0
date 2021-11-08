Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D62C43217
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 298A761265
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbhKHIHB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 03:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237456AbhKHIHA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 03:07:00 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474B5C061570
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 Nov 2021 00:04:16 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id g14so58382321edz.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Nov 2021 00:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xfcNu8KPhhn830EejbFSoKLQ5KGiIh5o1B54CgVdhfE=;
        b=jfi+S7SuEDzmLFjB8VVXLaysdy0yNSXpCIpM8UfP9nw4MtJjMKGwORnXSxqiQqDEGv
         rQ8qs8DS120TLxyyZBVWBwGkDwzJHHmIkPoWPtmlNT5xEOgvUroPxryZYRQbhF2pnYR6
         c282jWg03lgzPUs/X5SWjVRBwwfD08Q3riaSIhnHe8DsGadDMYlMdtR2NK+WzoTsjrg+
         ULEcS0Yxi+akSxAG3+SXHCOSYRVRYkOashF9TRpDBVNVbwMA7LuWBLtnEeUXT9+fxuG2
         XXWNZNQUZNgqkBI5jEqk68dapnoNT4lRjUuISPvfvyc/kuUwJVj6juB6NXqV7i5C3h6R
         g8zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xfcNu8KPhhn830EejbFSoKLQ5KGiIh5o1B54CgVdhfE=;
        b=Zv4ee2zB91GD1cpRI2Zb+edmbdYonAVuwLj3XciWQQiKEz+FQPKgYsEHu38J4K+BPC
         BOKyktYSAbanCyhGjzqLYjV7W9l+PX+tuqEHOw33q3NCQ/D3z5bNCLu+XNWYiiAmCFhu
         GenCzbtWSoPRYeN3cH8D5bMKPZZb0QgkycISGM87aY7RRr1j7joJxawIy85cLLdMllwb
         rLBs7cyTVOg5lq3kVzFmbYvmC+M2NGJK9wCiuWhfO5VzHElzM5t9/ITAfo4vbSi6+Z5H
         mEc04eT+m1g94G+cfnrz8j5lJDJZPe+8gRlXdPSC7FQ8uJN2QiLDdHDjXZDaV3Gdo0kq
         xfCA==
X-Gm-Message-State: AOAM5321Jr3t/ctHbIsPSJWOUT5y7MABXBMN6ylI+U9sWlUnD2Crep9p
        2unpkgXM2KGBdznq7DTLjxqERZCvZbBQBg==
X-Google-Smtp-Source: ABdhPJz601ay6oxAz0J477sj4afVVy3MgxNXR0YLfbPocS5Q8df3vLCi5ztlrEXAZYIDqbv4EWUPhg==
X-Received: by 2002:a17:907:7b98:: with SMTP id ne24mr66121945ejc.14.1636358654804;
        Mon, 08 Nov 2021 00:04:14 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id mp5sm7962309ejc.68.2021.11.08.00.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:04:14 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 08/12] libtracefs: Remove instance parameter from synthetic events APIs
Date:   Mon,  8 Nov 2021 10:04:00 +0200
Message-Id: <20211108080404.55814-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211108080404.55814-1-tz.stoyanov@gmail.com>
References: <20211108080404.55814-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The synthetic events apply across all instances, but some histograms
configuration is performed in specific instance. That configuration is
implementation detail of the synthetic event and should not be part of
the API. These APIs are affected by the change:
 tracefs_synth_create()
 tracefs_synth_destroy()
 tracefs_synth_show()

Now, the top trace instance is used by default. If there is a use case
for a custom instance, a new API could be proposed in the future:
 tracefs_synth_add_instance()
that will associate the synthetic event with a custom instance, before
calling the create API.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Suggested-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-sql.txt    |  4 ++--
 Documentation/libtracefs-synth.txt  |  6 ++---
 Documentation/libtracefs-synth2.txt | 30 ++++++++++--------------
 include/tracefs.h                   |  9 +++-----
 src/tracefs-hist.c                  | 36 ++++++++++++-----------------
 utest/tracefs-utest.c               | 10 ++++----
 6 files changed, 40 insertions(+), 55 deletions(-)

diff --git a/Documentation/libtracefs-sql.txt b/Documentation/libtracefs-sql.txt
index e762eae..73984ae 100644
--- a/Documentation/libtracefs-sql.txt
+++ b/Documentation/libtracefs-sql.txt
@@ -405,9 +405,9 @@ static int do_sql(const char *buffer, const char *name, const char *var,
 				}
 			}
 		}
-		tracefs_synth_show(&seq, NULL, synth);
+		tracefs_synth_show(&seq, synth);
 		if (execute)
-			tracefs_synth_create(NULL, synth);
+			tracefs_synth_create(synth);
 	} else {
 		struct tracefs_hist *hist;
 		hist = tracefs_synth_get_start_hist(synth);
diff --git a/Documentation/libtracefs-synth.txt b/Documentation/libtracefs-synth.txt
index 2fd9019..e238f46 100644
--- a/Documentation/libtracefs-synth.txt
+++ b/Documentation/libtracefs-synth.txt
@@ -268,7 +268,7 @@ static void show_event(void)
 
 	trace_seq_init(&s);
 
-	tracefs_synth_show(&s, NULL, synth);
+	tracefs_synth_show(&s, synth);
 	trace_seq_terminate(&s);
 	trace_seq_do_printf(&s);
 	trace_seq_destroy(&s);
@@ -281,10 +281,10 @@ int main (int argc, char **argv)
 	if (argc > 1) {
 		if (!strcmp(argv[1], "create")) {
 			/* Create the synthetic event */
-			tracefs_synth_create(NULL, synth);
+			tracefs_synth_create(synth);
 		} else if (!strcmp(argv[1], "delete")) {
 			/* Delete the synthetic event */
-			tracefs_synth_destroy(NULL, synth);
+			tracefs_synth_destroy(synth);
 		} else {
 			printf("usage: %s [create|delete]\n", argv[0]);
 			exit(-1);
diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index f734b44..95f3092 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -12,12 +12,9 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-int tracefs_synth_create(struct tracefs_instance pass:[*]instance,
-			 struct tracefs_synth pass:[*]synth);
-int tracefs_synth_destroy(struct tracefs_instance pass:[*]instance,
-			  struct tracefs_synth pass:[*]synth);
-int tracefs_synth_show(struct trace_seq pass:[*]seq, struct tracefs_instance pass:[*]instance,
-		       struct tracefs_synth pass:[*]synth);
+int tracefs_synth_create(struct tracefs_synth pass:[*]synth);
+int tracefs_synth_destroy(struct tracefs_synth pass:[*]synth);
+int tracefs_synth_show(struct trace_seq pass:[*]seq, struct tracefs_synth pass:[*]synth);
 bool tracefs_synth_complete(struct tracefs_synth pass:[*]synth);
 struct tracefs_hist pass:[*]tracefs_synth_get_start_hist(struct tracefs_synth pass:[*]synth);
 
@@ -49,18 +46,15 @@ as a field for both events to calculate the delta in nanoseconds, or use
 *TRACEFS_TIMESTAMP_USECS" as the compare fields for both events to calculate the
 delta in microseconds. This is used as the example below.
 
-*tracefs_synth_create*() creates the synthetic event in the system in the system
-in the _instance_ provided. Note, synthetic events apply across all instances,
-but some creation requires histograms to be established, which are local to
-instances.
+*tracefs_synth_create*() creates the synthetic event in the system. The synthetic events apply
+across all instances.
 
-*tracefs_synth_destroy*() destroys the synthetic event. It will attempt to stop
-the running of it in the given _instance_, but if its running in another instance
-this may fail as busy.
+*tracefs_synth_destroy*() destroys the synthetic event. It will attempt to stop the running of it in
+its instance (top by default), but if its running in another instance this may fail as busy.
 
 *tracefs_synth_show*() acts like *tracefs_synth_create*(), but instead of creating
-the synthetic event in the given _instance_, it will write the echo commands to
-manually create it in the _seq_ given.
+the synthetic event in the system, it will write the echo commands to manually create
+it in the _seq_ given.
 
 *tracefs_synth_complete*() returns true if the synthetic event _synth_ has both
 a starting and ending event.
@@ -201,7 +195,7 @@ static void show_event(void)
 
 	trace_seq_init(&s);
 
-	tracefs_synth_show(&s, NULL, synth);
+	tracefs_synth_show(&s, synth);
 	trace_seq_terminate(&s);
 	trace_seq_do_printf(&s);
 	trace_seq_destroy(&s);
@@ -214,10 +208,10 @@ int main (int argc, char **argv)
 	if (argc > 1) {
 		if (!strcmp(argv[1], "create")) {
 			/* Create the synthetic event */
-			tracefs_synth_create(NULL, synth);
+			tracefs_synth_create(synth);
 		} else if (!strcmp(argv[1], "delete")) {
 			/* Delete the synthetic event */
-			tracefs_synth_destroy(NULL, synth);
+			tracefs_synth_destroy(synth);
 		} else {
 			printf("usage: %s [create|delete]\n", argv[0]);
 			exit(-1);
diff --git a/include/tracefs.h b/include/tracefs.h
index 1092609..7b3f92b 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -522,13 +522,10 @@ int tracefs_synth_save(struct tracefs_synth *synth,
 		       char **save_fields);
 bool tracefs_synth_complete(struct tracefs_synth *synth);
 struct tracefs_hist *tracefs_synth_get_start_hist(struct tracefs_synth *synth);
-int tracefs_synth_create(struct tracefs_instance *instance,
-			 struct tracefs_synth *synth);
-int tracefs_synth_destroy(struct tracefs_instance *instance,
-			  struct tracefs_synth *synth);
+int tracefs_synth_create(struct tracefs_synth *synth);
+int tracefs_synth_destroy(struct tracefs_synth *synth);
 void tracefs_synth_free(struct tracefs_synth *synth);
-int tracefs_synth_show(struct trace_seq *seq, struct tracefs_instance *instance,
-		       struct tracefs_synth *synth);
+int tracefs_synth_show(struct trace_seq *seq, struct tracefs_synth *synth);
 
 struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
 				  const char *sql_buffer, char **err);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 2685dab..005fa8f 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -658,6 +658,7 @@ struct action {
  * @end_parens: Current parenthesis level for end event
  */
 struct tracefs_synth {
+	struct tracefs_instance *instance;
 	struct tep_handle	*tep;
 	struct tep_event	*start_event;
 	struct tep_event	*end_event;
@@ -1898,11 +1899,9 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
 
 /**
  * tracefs_synth_create - creates the synthetic event on the system
- * @instance: The instance to modify the start and end events
  * @synth: The tracefs_synth descriptor
  *
- * This creates the synthetic events. The @instance is used for writing
- * the triggers into the start and end events.
+ * This creates the synthetic events.
  *
  * Returns 0 on succes and -1 on error.
  * On error, errno is set to:
@@ -1910,8 +1909,7 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
  * ENIVAL - a parameter is passed as NULL that should not be or a problem
  *   writing into the system.
  */
-int tracefs_synth_create(struct tracefs_instance *instance,
-			 struct tracefs_synth *synth)
+int tracefs_synth_create(struct tracefs_synth *synth)
 {
 	char *start_hist = NULL;
 	char *end_hist = NULL;
@@ -1947,13 +1945,13 @@ int tracefs_synth_create(struct tracefs_instance *instance,
 	if (!end_hist)
 		goto remove_synthetic;
 
-	ret = tracefs_event_file_append(instance, synth->start_event->system,
+	ret = tracefs_event_file_append(synth->instance, synth->start_event->system,
 					synth->start_event->name,
 					"trigger", start_hist);
 	if (ret < 0)
 		goto remove_synthetic;
 
-	ret = tracefs_event_file_append(instance, synth->end_event->system,
+	ret = tracefs_event_file_append(synth->instance, synth->end_event->system,
 					synth->end_event->name,
 					"trigger", end_hist);
 	if (ret < 0)
@@ -1965,7 +1963,7 @@ int tracefs_synth_create(struct tracefs_instance *instance,
 	return 0;
 
  remove_start_hist:
-	remove_hist(instance, synth->start_event, start_hist);
+	remove_hist(synth->instance, synth->start_event, start_hist);
  remove_synthetic:
 	free(end_hist);
 	free(start_hist);
@@ -1975,15 +1973,14 @@ int tracefs_synth_create(struct tracefs_instance *instance,
 
 /**
  * tracefs_synth_destroy - delete the synthetic event from the system
- * @instance: The instance to modify the start and end events
  * @synth: The tracefs_synth descriptor
  *
  * This will destroy a synthetic event created by tracefs_synth_create()
- * with the same @instance and @synth.
+ * with the same @synth.
  *
- * It will attempt to disable the synthetic event, but if other instances
- * have it active, it is likely to fail, which will likely fail on
- * all other parts of tearing down the synthetic event.
+ * It will attempt to disable the synthetic event in its instance (top by default),
+ * but if other instances have it active, it is likely to fail, which will likely
+ * fail on all other parts of tearing down the synthetic event.
  *
  * Returns 0 on succes and -1 on error.
  * On error, errno is set to:
@@ -1991,8 +1988,7 @@ int tracefs_synth_create(struct tracefs_instance *instance,
  * ENIVAL - a parameter is passed as NULL that should not be or a problem
  *   writing into the system.
  */
-int tracefs_synth_destroy(struct tracefs_instance *instance,
-			  struct tracefs_synth *synth)
+int tracefs_synth_destroy(struct tracefs_synth *synth)
 {
 	char *hist;
 	int ret;
@@ -2008,14 +2004,14 @@ int tracefs_synth_destroy(struct tracefs_instance *instance,
 	}
 
 	/* Try to disable the event if possible */
-	tracefs_event_disable(instance, "synthetic", synth->name);
+	tracefs_event_disable(synth->instance, "synthetic", synth->name);
 
 	hist = create_end_hist(synth);
 	hist = append_filter(hist, synth->end_filter,
 			     synth->end_parens);
 	if (!hist)
 		return -1;
-	ret = remove_hist(instance, synth->end_event, hist);
+	ret = remove_hist(synth->instance, synth->end_event, hist);
 	free(hist);
 
 	hist = create_hist(synth->start_keys, synth->start_vars);
@@ -2024,7 +2020,7 @@ int tracefs_synth_destroy(struct tracefs_instance *instance,
 	if (!hist)
 		return -1;
 
-	ret = remove_hist(instance, synth->start_event, hist);
+	ret = remove_hist(synth->instance, synth->start_event, hist);
 	free(hist);
 
 	ret = tracefs_dynevent_destroy(synth->dyn_event, true);
@@ -2035,7 +2031,6 @@ int tracefs_synth_destroy(struct tracefs_instance *instance,
 /**
  * tracefs_synth_show - show the command lines to create the synthetic event
  * @seq: The trace_seq to store the command lines in
- * @instance: The instance to modify the start and end events
  * @synth: The tracefs_synth descriptor
  *
  * This will list the "echo" commands that are equivalent to what would
@@ -2046,7 +2041,6 @@ int tracefs_synth_destroy(struct tracefs_instance *instance,
  * ENOMEM - memory allocation failure.
  */
 int tracefs_synth_show(struct trace_seq *seq,
-		       struct tracefs_instance *instance,
 		       struct tracefs_synth *synth)
 {
 	bool new_event = false;
@@ -2079,7 +2073,7 @@ int tracefs_synth_show(struct trace_seq *seq,
 			 synth->dyn_event->format, path, synth->dyn_event->trace_file);
 
 	tracefs_put_tracing_file(path);
-	path = tracefs_instance_get_dir(instance);
+	path = tracefs_instance_get_dir(synth->instance);
 
 	hist = create_hist(synth->start_keys, synth->start_vars);
 	hist = append_filter(hist, synth->start_filter,
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 5b656d4..75ac147 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -337,28 +337,28 @@ static void test_instance_trace_sql(struct tracefs_instance *instance)
 
 	synth = tracefs_sql(tep, SQL_1_EVENT, SQL_1_SQL, NULL);
 	CU_TEST(synth != NULL);
-	ret = tracefs_synth_show(&seq, instance, synth);
+	ret = tracefs_synth_show(&seq, synth);
 	CU_TEST(ret == 0);
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
 	synth = tracefs_sql(tep, SQL_2_EVENT, SQL_2_SQL, NULL);
 	CU_TEST(synth != NULL);
-	ret = tracefs_synth_show(&seq, instance, synth);
+	ret = tracefs_synth_show(&seq, synth);
 	CU_TEST(ret == 0);
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
 	synth = tracefs_sql(tep, SQL_3_EVENT, SQL_3_SQL, NULL);
 	CU_TEST(synth != NULL);
-	ret = tracefs_synth_show(&seq, instance, synth);
+	ret = tracefs_synth_show(&seq, synth);
 	CU_TEST(ret == 0);
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
 	synth = tracefs_sql(tep, SQL_4_EVENT, SQL_4_SQL, NULL);
 	CU_TEST(synth != NULL);
-	ret = tracefs_synth_show(&seq, instance, synth);
+	ret = tracefs_synth_show(&seq, synth);
 	CU_TEST(ret == 0);
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
@@ -367,7 +367,7 @@ static void test_instance_trace_sql(struct tracefs_instance *instance)
 	if (event) {
 		synth = tracefs_sql(tep, SQL_5_EVENT, SQL_5_SQL, NULL);
 		CU_TEST(synth != NULL);
-		ret = tracefs_synth_show(&seq, instance, synth);
+		ret = tracefs_synth_show(&seq, synth);
 		CU_TEST(ret == 0);
 		tracefs_synth_free(synth);
 		trace_seq_reset(&seq);
-- 
2.31.1

