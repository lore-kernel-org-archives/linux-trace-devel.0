Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF4CC19F35
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 02:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87A4B61102
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 02:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238123AbhHMCR5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 22:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237496AbhHMCRw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 22:17:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35B0D60FC0;
        Fri, 13 Aug 2021 02:17:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mEMlA-003wW2-VL; Thu, 12 Aug 2021 22:17:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 6/7] libtracefs: Update the libtracefs-sql man page for the new tracefs_synth APIs
Date:   Thu, 12 Aug 2021 22:16:54 -0400
Message-Id: <20210813021655.939819-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813021655.939819-1-rostedt@goodmis.org>
References: <20210813021655.939819-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Update the libtracfes-sql man page to have the sqlhist program utilize the
new APIs:

  tracefs_synth_trace()
  tracefs_synth_snapshot()
  tracefs_synth_save()

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-sql.txt    | 105 ++++++++++++++++++++++++++--
 Documentation/libtracefs-synth2.txt |   2 +
 2 files changed, 102 insertions(+), 5 deletions(-)

diff --git a/Documentation/libtracefs-sql.txt b/Documentation/libtracefs-sql.txt
index 35ccaf5cd1a5..95625157590e 100644
--- a/Documentation/libtracefs-sql.txt
+++ b/Documentation/libtracefs-sql.txt
@@ -305,23 +305,47 @@ EXAMPLE
 
 static void usage(char **argv)
 {
-	fprintf(stderr, "usage: %s [-ed][-n name][-t dir][-f file | sql-command-line]\n"
+	fprintf(stderr, "usage: %s [-ed][-n name][-s][-S fields][-m var][-c var][-T][-t dir][-f file | sql-command-line]\n"
 		"  -n name - name of synthetic event 'Anonymous' if left off\n"
 		"  -t dir - use dir instead of /sys/kernel/tracing\n"
 		"  -e - execute the commands to create the synthetic event\n"
+		"  -m - trigger the action when var is a new max.\n"
+		"  -c - trigger the action when var changes.\n"
+		"  -s - used with -m or -c to do a snapshot of the tracing buffer\n"
+		"  -S - used with -m or -c to save fields of the end event (comma deliminated)\n"
+		"  -T - used with -m or -c to do both a snapshot and a trace\n"
 		"  -f file - read sql lines from file otherwise from the command line\n"
 		"            if file is '-' then read from standard input.\n",
 		argv[0]);
 	exit(-1);
 }
 
-static int do_sql(const char *buffer, const char *name,
-		  const char *trace_dir, bool execute)
+enum action {
+	ACTION_DEFAULT		= 0,
+	ACTION_SNAPSHOT		= (1 << 0),
+	ACTION_TRACE		= (1 << 1),
+	ACTION_SAVE		= (1 << 2),
+	ACTION_MAX		= (1 << 3),
+	ACTION_CHANGE		= (1 << 4),
+};
+
+#define ACTIONS ((ACTION_MAX - 1))
+
+static int do_sql(const char *buffer, const char *name, const char *var,
+		  const char *trace_dir, bool execute, int action,
+		  char **save_fields)
 {
 	struct tracefs_synth *synth;
 	struct tep_handle *tep;
 	struct trace_seq seq;
+	enum tracefs_synth_handler handler;
 	char *err;
+	int ret;
+
+	if ((action & ACTIONS) && !var) {
+		fprintf(stderr, "Error: -s, -S and -T not supported without -m or -c");
+		exit(-1);
+	}
 
 	if (!name)
 		name = "Anonymous";
@@ -345,6 +369,43 @@ static int do_sql(const char *buffer, const char *name,
 	}
 
 	if (tracefs_synth_complete(synth)) {
+		if (var) {
+			if (action & ACTION_MAX)
+				handler = TRACEFS_SYNTH_HANDLE_MAX;
+			else
+				handler = TRACEFS_SYNTH_HANDLE_CHANGE;
+
+			if (action & ACTION_SAVE) {
+				ret = tracefs_synth_save(synth, handler, var, save_fields);
+				if (ret < 0) {
+					err = "adding save";
+					goto failed_action;
+				}
+			}
+			if (action & ACTION_TRACE) {
+				/*
+				 * By doing the trace before snapshot, it will be included
+				 * in the snapshot.
+				 */
+				ret = tracefs_synth_trace(synth, handler, var);
+				if (ret < 0) {
+					err = "adding trace";
+					goto failed_action;
+				}
+			}
+			if (action & ACTION_SNAPSHOT) {
+				ret = tracefs_synth_snapshot(synth, handler, var);
+				if (ret < 0) {
+					err = "adding snapshot";
+ failed_action:
+					perror(err);
+					if (errno == ENODEV)
+						fprintf(stderr, "ERROR: '%s' is not a variable\n",
+							var);
+					exit(-1);
+				}
+			}
+		}
 		tracefs_synth_show(&seq, NULL, synth);
 		if (execute)
 			tracefs_synth_create(NULL, synth);
@@ -375,14 +436,18 @@ int main (int argc, char **argv)
 	int buffer_size = 0;
 	const char *file = NULL;
 	bool execute = false;
+	char **save_fields = NULL;
 	const char *name;
+	const char *var;
+	int action = 0;
+	char *tok;
 	FILE *fp;
 	size_t r;
 	int c;
 	int i;
 
 	for (;;) {
-		c = getopt(argc, argv, "ht:f:en:");
+		c = getopt(argc, argv, "ht:f:en:m:c:sS:T");
 		if (c == -1)
 			break;
 
@@ -398,12 +463,42 @@ int main (int argc, char **argv)
 		case 'e':
 			execute = true;
 			break;
+		case 'm':
+			action |= ACTION_MAX;
+			var = optarg;
+			break;
+		case 'c':
+			action |= ACTION_CHANGE;
+			var = optarg;
+			break;
+		case 's':
+			action |= ACTION_SNAPSHOT;
+			break;
+		case 'S':
+			action |= ACTION_SAVE;
+			tok = strtok(optarg, ",");
+			while (tok) {
+				save_fields = tracefs_list_add(save_fields, tok);
+				tok = strtok(NULL, ",");
+			}
+			if (!save_fields) {
+				perror(optarg);
+				exit(-1);
+			}
+			break;
+		case 'T':
+			action |= ACTION_TRACE | ACTION_SNAPSHOT;
+			break;
 		case 'n':
 			name = optarg;
 			break;
 		}
 	}
 
+	if ((action & (ACTION_MAX|ACTION_CHANGE)) == (ACTION_MAX|ACTION_CHANGE)) {
+		fprintf(stderr, "Can not use both -m and -c together\n");
+		exit(-1);
+	}
 	if (file) {
 		if (!strcmp(file, "-"))
 			fp = stdin;
@@ -434,7 +529,7 @@ int main (int argc, char **argv)
 		}
 	}
 
-	do_sql(buffer, name, trace_dir, execute);
+	do_sql(buffer, name, var, trace_dir, execute, action, save_fields);
 	free(buffer);
 
 	return 0;
diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index cfcae7411f58..4c4425325393 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -117,6 +117,8 @@ And more errors may have happened from the system calls to the system.
 
 EXAMPLE
 -------
+See *tracefs_sql*(3) for a more indepth use of some of this code.
+
 [source,c]
 --
 #include <stdlib.h>
-- 
2.30.2

