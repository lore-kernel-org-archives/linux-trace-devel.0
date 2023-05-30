Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB84FC77B73
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 May 2023 04:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjE3EVr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 May 2023 00:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjE3EVp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 May 2023 00:21:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C305E3
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 May 2023 21:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18DD761161
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 04:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D15C433D2
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 04:21:42 +0000 (UTC)
Date:   Tue, 30 May 2023 00:21:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add tracefs_instance_tracers() API
Message-ID: <20230530002140.760b8cc5@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Currently there exists a tracefs_tracers() API that takes a tracing_dir
variable to define where the tracing directory is (NULL to look it up) but it
does not handle instances. As instances can have different tracers than the top
level, there needs to be an interface that shows the tracers that are available
for instances.

Add tracefs_instance_tracers() to show the available tracers for an instance
(and the available tracers for the top level if NULL is passed in. Basically
the same as tracefs_instances(NULL)).

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-tracer.txt | 32 ++++++++++++++++++------
 include/tracefs.h                   |  1 +
 src/tracefs-events.c                | 38 +++++++++++++++++++++++------
 utest/tracefs-utest.c               |  2 +-
 4 files changed, 56 insertions(+), 17 deletions(-)

diff --git a/Documentation/libtracefs-tracer.txt b/Documentation/libtracefs-tracer.txt
index ea57962d9163..8f90552fd83d 100644
--- a/Documentation/libtracefs-tracer.txt
+++ b/Documentation/libtracefs-tracer.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_tracer_set, tracefs_tracer_clear - Enable or disable a tracer in an instance or the top level
+tracefs_instance_tracers, tracefs_tracer_set, tracefs_tracer_clear - Enable or disable a tracer in an instance or the top level
 
 SYNOPSIS
 --------
@@ -11,6 +11,7 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
+char pass:[**] *tracefs_instance_tracers*(struct tracefs_instance pass:[*]_instance_);
 int *tracefs_tracer_set*(struct tracefs_instance pass:[*]_instance_, enum tracefs_tracers _tracer_);
 int *tracefs_tracer_set*(struct tracefs_instance pass:[*]_instance_, enum tracefs_tracers _tracer_, const char pass:[*]_name_);
 int *tracefs_tracer_clear*(struct tracefs_instance pass:[*]_instance_);
@@ -18,6 +19,11 @@ int *tracefs_tracer_clear*(struct tracefs_instance pass:[*]_instance_);
 
 DESCRIPTION
 -----------
+*tracefs_instance_tracers* will return a list of available tracers for a given
+_instance_ (note, an instance may not have the same set of available tracers as
+the top level). If _instance_ is NULL, then the list of available tracers
+returned will be for the top level.
+
 *tracefs_tracer_set* enables a tracer in the given instance, defined by the
 _instance_ parameter. If _instance_ is NULL, then the top level instance is
 changed. If _tracer_ is set to *TRACFES_TRACER_CUSTOM* then a _name_
@@ -119,10 +125,12 @@ int main(int argc, char *argv[])
 {
 	struct tracefs_instance *inst = NULL;
 	enum tracefs_tracers t = TRACEFS_TRACER_NOP;
+	const char *cust = NULL;
 	const char *buf = NULL;
-	const char *cust;
+	char **tracers;
 	int ret;
 	int ch;
+	int i;
 
 	while ((ch = getopt(argc, argv, "nfgiwdc:B:")) > 0) {
 		switch (ch) {
@@ -161,19 +169,27 @@ int main(int argc, char *argv[])
 		ret = tracefs_tracer_set(inst, t);
 
 	if (ret < 0) {
+		if (errno == ENODEV) {
+			if (cust)
+				printf("Tracer '%s' not supported by kernel\n", cust);
+			else
+				printf("Tracer not supported by kernel\n");
+			tracers = tracefs_instance_tracers(inst);
+			printf("Available tracers:");
+			for (i = 0; tracers && tracers[i]; i++)
+				printf(" %s", tracers[i]);
+			tracefs_list_free(tracers);
+			printf("\n");
+		} else
+			perror("Error");
 		if (inst) {
 			tracefs_instance_destroy(inst);
 			tracefs_instance_free(inst);
 		}
-		if (errno == ENODEV)
-			printf("Tracer not supported by kernel\n");
-		else
-			perror("Error");
 		exit(-1);
 	}
 
-	if (inst)
-		tracefs_instance_free(inst);
+	tracefs_instance_free(inst);
 
 	exit(0);
 }
diff --git a/include/tracefs.h b/include/tracefs.h
index 5410d00c5d2b..245a99d286ab 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -159,6 +159,7 @@ bool tracefs_event_file_exists(struct tracefs_instance *instance,
 			       const char *file);
 
 char **tracefs_tracers(const char *tracing_dir);
+char **tracefs_instance_tracers(struct tracefs_instance *instance);
 
 struct tep_handle *tracefs_local_events(const char *tracing_dir);
 struct tep_handle *tracefs_local_events_system(const char *tracing_dir,
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index c2adf415342e..c6b1d7637e72 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -817,14 +817,7 @@ char **tracefs_system_events(const char *tracing_dir, const char *system)
 	return events;
 }
 
-/**
- * tracefs_tracers - returns an array of available tracers
- * @tracing_dir: The directory that contains the tracing directory
- *
- * Returns an allocate list of plugins. The array ends with NULL
- * Both the plugin names and array must be freed with tracefs_list_free()
- */
-char **tracefs_tracers(const char *tracing_dir)
+static char **list_tracers(const char *tracing_dir)
 {
 	char *available_tracers;
 	struct stat st;
@@ -882,6 +875,35 @@ char **tracefs_tracers(const char *tracing_dir)
 	return plugins;
 }
 
+/**
+ * tracefs_tracers - returns an array of available tracers
+ * @tracing_dir: The directory that contains the tracing directory
+ *
+ * Returns an allocate list of plugins. The array ends with NULL
+ * Both the plugin names and array must be freed with tracefs_list_free()
+ */
+char **tracefs_tracers(const char *tracing_dir)
+{
+	return list_tracers(tracing_dir);
+}
+
+/**
+ * tracefs_instance_tracers - returns an array of available tracers for an instance
+ * @instance: ftrace instance, can be NULL for the top instance
+ *
+ * Returns an allocate list of plugins. The array ends with NULL
+ * Both the plugin names and array must be freed with tracefs_list_free()
+ */
+char **tracefs_instance_tracers(struct tracefs_instance *instance)
+{
+	const char *tracing_dir = NULL;
+
+	if (instance)
+		tracing_dir = instance->trace_dir;
+
+	return list_tracers(tracing_dir);
+}
+
 static int load_events(struct tep_handle *tep,
 		       const char *tracing_dir, const char *system, bool check)
 {
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 47fc9570a473..17fcac722fbc 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1776,7 +1776,7 @@ static void test_instance_reset(void)
 
 	CU_TEST(test_instance_check_default_state(instance) == true);
 
-	tracers = tracefs_tracers(NULL);
+	tracers = tracefs_instance_tracers(instance);
 	CU_TEST(tracers != NULL);
 	if (tracers) {
 		CU_TEST(tracefs_tracer_set(instance, TRACEFS_TRACER_CUSTOM, tracers[0]) == 0);
-- 
2.39.2

