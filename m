Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B67C433ED
	for <linux-trace-devel@archiver.kernel.org>; Sat, 10 Apr 2021 01:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04D7C610FB
	for <linux-trace-devel@archiver.kernel.org>; Sat, 10 Apr 2021 01:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhDJBkQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 21:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231946AbhDJBkQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 21:40:16 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0553E610FB
        for <linux-trace-devel@vger.kernel.org>; Sat, 10 Apr 2021 01:40:01 +0000 (UTC)
Date:   Fri, 9 Apr 2021 21:40:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add tracefs_load_cmdlines() API
Message-ID: <20210409214000.5f9dc904@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

While writing a program using the libtracefs routines, I had to load the
tep handle before tracing to see what events were available before
starting the trace. Loading the mappings of pids to comms is best done
after the trace as the saved_cmdlines file gets filled by the trace. Since
the loading was already done at the beginning, I needed a way to load it
again when the trace was over.

Add tracefs_load_cmdlines() API to be able to accomplish this.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-events-tep.txt | 17 +++++++++++++++--
 include/tracefs.h                       |  2 ++
 src/tracefs-events.c                    | 19 +++++++++++++------
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/Documentation/libtracefs-events-tep.txt b/Documentation/libtracefs-events-tep.txt
index e0be02c..4c5cb21 100644
--- a/Documentation/libtracefs-events-tep.txt
+++ b/Documentation/libtracefs-events-tep.txt
@@ -3,7 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_local_events, tracefs_local_events_system, tracefs_fill_local_events -
+tracefs_local_events, tracefs_local_events_system, tracefs_fill_local_events,
+tracefs_load_cmdlines -
 Initialize a tep handler with trace events from the local system.
 
 SYNOPSIS
@@ -15,7 +16,7 @@ SYNOPSIS
 struct tep_handle pass:[*]*tracefs_local_events*(const char pass:[*]_tracing_dir_);
 struct tep_handle pass:[*]*tracefs_local_events_system*(const char pass:[*]_tracing_dir_, const char pass:[*] const pass:[*]_sys_names_);
 int *tracefs_fill_local_events*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_, int pass:[*]_parsing_failures_);
-
+int *tracefs_load_cmdlines*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_);
 --
 
 DESCRIPTION
@@ -46,6 +47,14 @@ a pointer to already allocated tep handler, that is going to be initialized.
 The _parsing_failures_ argument could be NULL or a pointer to an integer,
 where the number of failures while parsing the event files are returned.
 
+The above functions will also load the mappings between pids and the process
+command line names. In some cases the _tep_ handle is created with one
+of the above before tracing begins. As the mappings get updated during the
+trace, there may be a need to read the mappings again after the trace.
+The _tracefs_load_cmdlines()_ does just that. The _tracing_dir_ is
+the director of the mount point to load from, or NULL to use the
+mount point of the tracefs file system.
+
 RETURN VALUE
 ------------
 The _tracefs_local_events()_ and _tracefs_local_events_system()_ functions
@@ -55,6 +64,9 @@ case of an error. The returned _tep_ handler must be freed with _tep_free(3)_.
 The _tracefs_fill_local_events()_ function returns -1 in case of an error or
 0 otherwise.
 
+The _tracefs_load_cmdlines()_ function returns -1 in case of an error, or
+0 otherwise.
+
 EXAMPLE
 -------
 [source,c]
@@ -91,6 +103,7 @@ struct tep_event *tep;
 	if (tracefs_fill_local_events(NULL, tep, &parsing_failures) < 0) {
 		/* Failed to initialise tep handler with local events from top instance */
 	}
+	tracefs_load_cmdlines(NULL, tep);
 ...
 	tep_free(tep);
 --
diff --git a/include/tracefs.h b/include/tracefs.h
index 2dc29b3..55ee867 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -94,6 +94,8 @@ struct tep_handle *tracefs_local_events_system(const char *tracing_dir,
 int tracefs_fill_local_events(const char *tracing_dir,
 			       struct tep_handle *tep, int *parsing_failures);
 
+int tracefs_load_cmdlines(const char *tracing_dir, struct tep_handle *tep);
+
 char *tracefs_get_clock(struct tracefs_instance *instance);
 
 enum tracefs_option_id {
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index f37ada1..94573b3 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -610,8 +610,8 @@ static void load_kallsyms(struct tep_handle *tep)
 	free(buf);
 }
 
-static void load_saved_cmdlines(const char *tracing_dir,
-				struct tep_handle *tep)
+static int load_saved_cmdlines(const char *tracing_dir,
+			       struct tep_handle *tep, bool warn)
 {
 	char *path;
 	char *buf;
@@ -619,15 +619,17 @@ static void load_saved_cmdlines(const char *tracing_dir,
 
 	path = trace_append_file(tracing_dir, "saved_cmdlines");
 	if (!path)
-		return;
+		return -1;
 
 	ret = str_read_file(path, &buf, false);
 	free(path);
 	if (ret < 0)
-		return;
+		return -1;
 
-	tep_parse_saved_cmdlines(tep, buf);
+	ret = tep_parse_saved_cmdlines(tep, buf);
 	free(buf);
+
+	return ret;
 }
 
 static void load_printk_formats(const char *tracing_dir,
@@ -659,10 +661,15 @@ static void load_mappings(const char *tracing_dir,
 			  struct tep_handle *tep)
 {
 	load_kallsyms(tep);
-	load_saved_cmdlines(tracing_dir, tep);
+	load_saved_cmdlines(tracing_dir, tep, false);
 	load_printk_formats(tracing_dir, tep);
 }
 
+int tracefs_load_cmdlines(const char *tracing_dir, struct tep_handle *tep)
+{
+	return load_saved_cmdlines(tracing_dir, tep, true);
+}
+
 static int fill_local_events_system(const char *tracing_dir,
 				    struct tep_handle *tep,
 				    const char * const *sys_names,
-- 
2.29.2

