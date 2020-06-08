Return-Path: <SRS0=emdu=7V=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06181C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Jun 2020 20:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D99832076A
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Jun 2020 20:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgFHUkB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Jun 2020 16:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgFHUkA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Jun 2020 16:40:00 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E0DB206D5;
        Mon,  8 Jun 2020 20:40:00 +0000 (UTC)
Date:   Mon, 8 Jun 2020 16:39:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Have trace-cmd start wait for command unless
 --fork is specified
Message-ID: <20200608163958.3dd8761f@oasis.local.home>
In-Reply-To: <20200608153540.06b08942@oasis.local.home>
References: <20200603121506.49992-1-tz.stoyanov@gmail.com>
        <20200603121506.49992-2-tz.stoyanov@gmail.com>
        <20200608153540.06b08942@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[ I just realized I already pushed your patch. Here's an update to what
  I would like. ]

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of forking a command specified on the command line and returning
right away, have it wait for the process to finish before returning. Unless
"--fork" is specified as well.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/trace-cmd-start.1.txt |  7 +++++++
 tracecmd/trace-record.c             | 18 +++++++++++++-----
 tracecmd/trace-usage.c              |  2 ++
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/Documentation/trace-cmd-start.1.txt b/Documentation/trace-cmd-start.1.txt
index 63d2034c..07f2ed3a 100644
--- a/Documentation/trace-cmd-start.1.txt
+++ b/Documentation/trace-cmd-start.1.txt
@@ -23,6 +23,13 @@ OPTIONS
 The options are the same as 'trace-cmd-record(1)', except that it does not
 take options specific to recording (*-s*, *-o*, *-N*, and *-t*).
 
+*--fork* ::
+   This option is only available for trace-cmd start. It tells trace-cmd
+   to not wait for the process to finish before returning.
+   With this option, trace-cmd start will return right after it forks
+   the process on the command line. This option only has an effect if
+   trace-cmd start also executes a command.
+
 SEE ALSO
 --------
 trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-stop(1),
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4d2039a1..143b736e 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -86,6 +86,8 @@ static char *host;
 
 static bool quiet;
 
+static bool fork_process;
+
 /* Max size to let a per cpu file get */
 static int max_kb;
 
@@ -1604,7 +1606,7 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
 		/* child */
 		update_task_filter();
 		tracecmd_enable_tracing();
-		if (type != TRACE_TYPE_START)
+		if (!fork_process)
 			enable_ptrace();
 		/*
 		 * If we are using stderr for stdout, switch
@@ -1626,13 +1628,15 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
 			die("Failed to exec %s", argv[0]);
 		}
 	}
-	if (type & TRACE_TYPE_START)
+	if (fork_process)
 		exit(0);
 	if (do_ptrace) {
 		ptrace_attach(NULL, pid);
 		ptrace_wait(type);
 	} else
 		trace_waitpid(type, pid, &status, 0);
+	if (type & TRACE_TYPE_START)
+		exit(0);
 }
 
 static void
@@ -5535,6 +5539,7 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_fork		= 241,
 	OPT_tsyncinterval	= 242,
 	OPT_user		= 243,
 	OPT_procmap		= 244,
@@ -5851,6 +5856,7 @@ static void parse_record_options(int argc,
 			{"user", required_argument, NULL, OPT_user},
 			{"module", required_argument, NULL, OPT_module},
 			{"tsync-interval", required_argument, NULL, OPT_tsyncinterval},
+			{"fork", no_argument, NULL, OPT_fork},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6204,6 +6210,11 @@ static void parse_record_options(int argc,
 			top_instance.tsync.loop_interval = atoi(optarg);
 			guest_sync_set = true;
 			break;
+		case OPT_fork:
+			if (!IS_START(ctx))
+				die("--fork option used for 'start' command only");
+			fork_process = true;
+			break;
 		case OPT_quiet:
 		case 'q':
 			quiet = true;
@@ -6266,9 +6277,6 @@ static void parse_record_options(int argc,
 		}
 	}
 
-	if (do_ptrace && IS_START(ctx))
-		die("ptrace not supported with command start");
-
 	for_all_instances(instance) {
 		if (instance->get_procmap && !instance->nr_filter_pids) {
 			warning("--proc-map is ignored for instance %s, "
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 58bca9e4..1e832be8 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -71,6 +71,8 @@ static struct usage_help usage_help[] = {
 		" %s start [-e event][-p plugin][-d][-O option ][-P pid]\n"
 		"          Uses same options as record.\n"
 		"          It only enables the tracing and exits\n"
+		"\n"
+		"        --fork: If a command is specified, then return right after it forks\n"
 	},
 	{
 		"extract",
-- 
2.25.4

