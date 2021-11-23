Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BCB1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Nov 2021 18:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239872AbhKWSgU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 13:36:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238991AbhKWSgT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 13:36:19 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FD2A60FA0;
        Tue, 23 Nov 2021 18:33:11 +0000 (UTC)
Date:   Tue, 23 Nov 2021 13:33:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH] libtracefs: Rename *_show() to *_echo_cmd()
Message-ID: <20211123133309.3fcec230@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The tracefs_hist_show() and tracefs_synth_show() are misnomers and do not
really describe what they do. Those functions produce the "echo" commands
to create the histogram and synthetic event respectively.

Rename them to *_echo_cmd() to be more descriptive of what they actually
perform.

Reported-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-hist.txt   |  8 ++++----
 Documentation/libtracefs-sql.txt    |  6 +++---
 Documentation/libtracefs-synth.txt  |  6 +++---
 Documentation/libtracefs-synth2.txt | 10 +++++-----
 include/tracefs.h                   |  6 +++---
 src/tracefs-hist.c                  | 16 ++++++++--------
 utest/tracefs-utest.c               | 10 +++++-----
 7 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index c07fe6f..31ea712 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -39,9 +39,9 @@ int tracefs_hist_append_filter(struct tracefs_hist pass:[*]hist,
 			       const char pass:[*]field,
 			       enum tracefs_compare compare,
 			       const char pass:[*]val);
-int tracefs_hist_show(struct trace_seq pass:[*]s, struct tracefs_instance pass:[*]instance,
-			 struct tracefs_hist pass:[*]hist,
-			 enum tracefs_hist_command command);
+int tracefs_hist_echo_cmd(struct trace_seq pass:[*]s, struct tracefs_instance pass:[*]instance,
+			  struct tracefs_hist pass:[*]hist,
+			  enum tracefs_hist_command command);
 int tracefs_hist_command(struct tracefs_instance pass:[*]instance,
 			 struct tracefs_hist pass:[*]hist,
 			 enum tracefs_hist_command command);
@@ -155,7 +155,7 @@ _field_, _compare_, and _val_ are ignored unless _type_ is equal to
 
 *TRACEFS_COMPARE_AND* - _field_ & _val_ : where _field_ is a flags field.
 
-*trace_hist_show*() prints the commands needed to create the given histogram
+*trace_hist_echo_cmd*() prints the commands needed to create the given histogram
 in the given _instance_, or NULL for the top level, into the _seq_.
 The command that is printed is described by _command_ and shows the functionality
 that would be done by *tracefs_hist_command*(3).
diff --git a/Documentation/libtracefs-sql.txt b/Documentation/libtracefs-sql.txt
index 73984ae..3389090 100644
--- a/Documentation/libtracefs-sql.txt
+++ b/Documentation/libtracefs-sql.txt
@@ -405,7 +405,7 @@ static int do_sql(const char *buffer, const char *name, const char *var,
 				}
 			}
 		}
-		tracefs_synth_show(&seq, synth);
+		tracefs_synth_echo_cmd(&seq, synth);
 		if (execute)
 			tracefs_synth_create(synth);
 	} else {
@@ -415,7 +415,7 @@ static int do_sql(const char *buffer, const char *name, const char *var,
 			perror("get_start_hist");
 			exit(-1);
 		}
-		tracefs_hist_show(&seq, NULL, hist, 0);
+		tracefs_hist_echo_cmd(&seq, NULL, hist, 0);
 		if (execute)
 			tracefs_hist_start(NULL, hist);
 	}
@@ -561,7 +561,7 @@ _tracefs_synth_append_end_filter(3)_,
 _tracefs_synth_create(3)_,
 _tracefs_synth_destroy(3)_,
 _tracefs_synth_free(3)_,
-_tracefs_synth_show(3)_,
+_tracefs_synth_echo_cmd(3)_,
 _tracefs_hist_alloc(3)_,
 _tracefs_hist_free(3)_,
 _tracefs_hist_add_key(3)_,
diff --git a/Documentation/libtracefs-synth.txt b/Documentation/libtracefs-synth.txt
index e238f46..87d2dfc 100644
--- a/Documentation/libtracefs-synth.txt
+++ b/Documentation/libtracefs-synth.txt
@@ -257,7 +257,7 @@ static void make_event(void)
 	 * That's because, when the synth is executed, the remaining close parenthesis
 	 * will be added. That is, the string will end up being:
 	 * "next_prio < 50 || !(prev_prio >= 100)" when one of tracefs_sync_create()
-	 * or tracefs_sync_show() is run.
+	 * or tracefs_sync_echo_cmd() is run.
 	 */
 }
 
@@ -268,7 +268,7 @@ static void show_event(void)
 
 	trace_seq_init(&s);
 
-	tracefs_synth_show(&s, synth);
+	tracefs_synth_echo_cmd(&s, synth);
 	trace_seq_terminate(&s);
 	trace_seq_do_printf(&s);
 	trace_seq_destroy(&s);
@@ -312,7 +312,7 @@ SEE ALSO
 --------
 _tracefs_synth_create_(3),
 _tracefs_synth_destroy_(3),
-_tracfes_synth_show_(3),
+_tracfes_synth_echo_cmd(3),
 _libtracefs(3)_,
 _libtraceevent(3)_,
 _trace-cmd(1)_,
diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index 95f3092..c7be963 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_show,tracefs_synth_complete,
+tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_echo_cmd,tracefs_synth_complete,
 tracefs_synth_get_start_hist,tracefs_synth_trace,tracefs_synth_snapshot - Creation of synthetic events
 
 SYNOPSIS
@@ -14,7 +14,7 @@ SYNOPSIS
 
 int tracefs_synth_create(struct tracefs_synth pass:[*]synth);
 int tracefs_synth_destroy(struct tracefs_synth pass:[*]synth);
-int tracefs_synth_show(struct trace_seq pass:[*]seq, struct tracefs_synth pass:[*]synth);
+int tracefs_synth_echo_cmd(struct trace_seq pass:[*]seq, struct tracefs_synth pass:[*]synth);
 bool tracefs_synth_complete(struct tracefs_synth pass:[*]synth);
 struct tracefs_hist pass:[*]tracefs_synth_get_start_hist(struct tracefs_synth pass:[*]synth);
 
@@ -52,7 +52,7 @@ across all instances.
 *tracefs_synth_destroy*() destroys the synthetic event. It will attempt to stop the running of it in
 its instance (top by default), but if its running in another instance this may fail as busy.
 
-*tracefs_synth_show*() acts like *tracefs_synth_create*(), but instead of creating
+*tracefs_synth_echo_cmd*() acts like *tracefs_synth_create*(), but instead of creating
 the synthetic event in the system, it will write the echo commands to manually create
 it in the _seq_ given.
 
@@ -184,7 +184,7 @@ static void make_event(void)
 	 * That's because, when the synth is executed, the remaining close parenthesis
 	 * will be added. That is, the string will end up being:
 	 * "next_prio < 50 || !(prev_prio >= 100)" when one of tracefs_sync_create()
-	 * or tracefs_sync_show() is run.
+	 * or tracefs_sync_echo_cmd() is run.
 	 */
 }
 
@@ -195,7 +195,7 @@ static void show_event(void)
 
 	trace_seq_init(&s);
 
-	tracefs_synth_show(&s, synth);
+	tracefs_synth_echo_cmd(&s, synth);
 	trace_seq_terminate(&s);
 	trace_seq_do_printf(&s);
 	trace_seq_destroy(&s);
diff --git a/include/tracefs.h b/include/tracefs.h
index 2ced45c..9662603 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -371,8 +371,8 @@ int tracefs_hist_append_filter(struct tracefs_hist *hist,
 			       const char *field,
 			       enum tracefs_compare compare,
 			       const char *val);
-int tracefs_hist_show(struct trace_seq *seq,  struct tracefs_instance *instance,
-		      struct tracefs_hist *hist, enum tracefs_hist_command command);
+int tracefs_hist_echo_cmd(struct trace_seq *seq,  struct tracefs_instance *instance,
+			  struct tracefs_hist *hist, enum tracefs_hist_command command);
 int tracefs_hist_command(struct tracefs_instance *instance,
 			 struct tracefs_hist *hist, enum tracefs_hist_command cmd);
 
@@ -530,7 +530,7 @@ struct tracefs_hist *tracefs_synth_get_start_hist(struct tracefs_synth *synth);
 int tracefs_synth_create(struct tracefs_synth *synth);
 int tracefs_synth_destroy(struct tracefs_synth *synth);
 void tracefs_synth_free(struct tracefs_synth *synth);
-int tracefs_synth_show(struct trace_seq *seq, struct tracefs_synth *synth);
+int tracefs_synth_echo_cmd(struct trace_seq *seq, struct tracefs_synth *synth);
 
 struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
 				  const char *sql_buffer, char **err);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 44b3099..694b800 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -103,20 +103,20 @@ static void add_hist_commands(struct trace_seq *seq, struct tracefs_hist *hist,
 }
 
 /*
- * trace_hist_show - show how to start the histogram
+ * trace_hist_echo_cmd - show how to start the histogram
  * @seq: A trace_seq to store the commands to create
  * @hist: The histogram to write into the trigger file
  * @command: If not zero, can pause, continue or clear the histogram
  *
- * This shows the commands to create the histogram for an event
+ * This shows the echo commands to create the histogram for an event
  * with the given fields.
  *
  * Returns 0 on succes -1 on error.
  */
 int
-tracefs_hist_show(struct trace_seq *seq, struct tracefs_instance *instance,
-		  struct tracefs_hist *hist,
-		  enum tracefs_hist_command command)
+tracefs_hist_echo_cmd(struct trace_seq *seq, struct tracefs_instance *instance,
+		      struct tracefs_hist *hist,
+		      enum tracefs_hist_command command)
 {
 	const char *system = hist->system;
 	const char *event = hist->event_name;
@@ -2029,7 +2029,7 @@ int tracefs_synth_destroy(struct tracefs_synth *synth)
 }
 
 /**
- * tracefs_synth_show - show the command lines to create the synthetic event
+ * tracefs_synth_echo_cmd - show the command lines to create the synthetic event
  * @seq: The trace_seq to store the command lines in
  * @synth: The tracefs_synth descriptor
  *
@@ -2040,8 +2040,8 @@ int tracefs_synth_destroy(struct tracefs_synth *synth)
  * On error, errno is set to:
  * ENOMEM - memory allocation failure.
  */
-int tracefs_synth_show(struct trace_seq *seq,
-		       struct tracefs_synth *synth)
+int tracefs_synth_echo_cmd(struct trace_seq *seq,
+			   struct tracefs_synth *synth)
 {
 	bool new_event = false;
 	char *hist = NULL;
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 96b2baf..3a01f38 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -337,28 +337,28 @@ static void test_instance_trace_sql(struct tracefs_instance *instance)
 
 	synth = tracefs_sql(tep, SQL_1_EVENT, SQL_1_SQL, NULL);
 	CU_TEST(synth != NULL);
-	ret = tracefs_synth_show(&seq, synth);
+	ret = tracefs_synth_echo_cmd(&seq, synth);
 	CU_TEST(ret == 0);
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
 	synth = tracefs_sql(tep, SQL_2_EVENT, SQL_2_SQL, NULL);
 	CU_TEST(synth != NULL);
-	ret = tracefs_synth_show(&seq, synth);
+	ret = tracefs_synth_echo_cmd(&seq, synth);
 	CU_TEST(ret == 0);
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
 	synth = tracefs_sql(tep, SQL_3_EVENT, SQL_3_SQL, NULL);
 	CU_TEST(synth != NULL);
-	ret = tracefs_synth_show(&seq, synth);
+	ret = tracefs_synth_echo_cmd(&seq, synth);
 	CU_TEST(ret == 0);
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
 	synth = tracefs_sql(tep, SQL_4_EVENT, SQL_4_SQL, NULL);
 	CU_TEST(synth != NULL);
-	ret = tracefs_synth_show(&seq, synth);
+	ret = tracefs_synth_echo_cmd(&seq, synth);
 	CU_TEST(ret == 0);
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
@@ -367,7 +367,7 @@ static void test_instance_trace_sql(struct tracefs_instance *instance)
 	if (event) {
 		synth = tracefs_sql(tep, SQL_5_EVENT, SQL_5_SQL, NULL);
 		CU_TEST(synth != NULL);
-		ret = tracefs_synth_show(&seq, synth);
+		ret = tracefs_synth_echo_cmd(&seq, synth);
 		CU_TEST(ret == 0);
 		tracefs_synth_free(synth);
 		trace_seq_reset(&seq);
-- 
2.31.1

