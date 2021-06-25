Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 766C8C2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 20:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E88561969
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 20:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhFYUcg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Jun 2021 16:32:36 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:38882 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229573AbhFYUcg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Jun 2021 16:32:36 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jun 2021 16:32:36 EDT
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 25 Jun 2021 13:15:10 -0700
Received: from oasis.vmware.com (unknown [10.84.232.102])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id A384820337;
        Fri, 25 Jun 2021 13:15:13 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] trace-cmd: Do not require --verbose to have an argument
Date:   Fri, 25 Jun 2021 16:15:09 -0400
Message-ID: <20210625201511.1206465-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210625201511.1206465-1-rostedt@goodmis.org>
References: <20210625201511.1206465-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In most applications, when specifying a "verbose" argument, they do not
require adding a level of verbosity. Just saying "--verbose" should be
sufficient, unless they want a specific type of verbosity.

Have --verbose be acceptable as an argument without specifying a level.
Unfortunately, it appears that getopt_long() does not recognize the next
argument on the command line as an optional argument, but requires an
equal sign between the "--verbose" and the level. That is, when the user
wants to specify a specific level, they need to do it like so:

  trace-cmd report --verbose=debug

And not like

  trace-cmd report --verbose debug

The man pages are updated to reflect this.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/trace-cmd/trace-cmd-check-events.1.txt | 5 +++--
 Documentation/trace-cmd/trace-cmd-dump.1.txt         | 5 +++--
 Documentation/trace-cmd/trace-cmd-extract.1.txt      | 5 +++--
 Documentation/trace-cmd/trace-cmd-listen.1.txt       | 5 +++--
 Documentation/trace-cmd/trace-cmd-profile.1.txt      | 5 +++--
 Documentation/trace-cmd/trace-cmd-record.1.txt       | 5 +++--
 Documentation/trace-cmd/trace-cmd-report.1.txt       | 5 +++--
 Documentation/trace-cmd/trace-cmd-set.1.txt          | 5 +++--
 Documentation/trace-cmd/trace-cmd-stack.1.txt        | 5 +++--
 tracecmd/trace-agent.c                               | 2 +-
 tracecmd/trace-check-events.c                        | 2 +-
 tracecmd/trace-cmd.c                                 | 3 ++-
 tracecmd/trace-dump.c                                | 2 +-
 tracecmd/trace-listen.c                              | 2 +-
 tracecmd/trace-read.c                                | 2 +-
 tracecmd/trace-record.c                              | 2 +-
 tracecmd/trace-stack.c                               | 2 +-
 17 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-check-events.1.txt b/Documentation/trace-cmd/trace-cmd-check-events.1.txt
index 40c3c8cd..debab6c5 100644
--- a/Documentation/trace-cmd/trace-cmd-check-events.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-check-events.1.txt
@@ -24,14 +24,15 @@ OPTIONS
 -------
 *-N* - Don't load plugins
 
-*--verbose* 'level'::
+*--verbose*[='level']::
      Set the log level. Supported log levels are "none", "critical", "error", "warning",
      "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
      level to specific value enables all logs from that and all previous levels.
+     The level will default to "info" if one is not specified.
 
      Example: enable all critical, error and warning logs
 
-      trace-cmd check-events --verbose warning
+      trace-cmd check-events --verbose=warning
 
 SEE ALSO
 --------
diff --git a/Documentation/trace-cmd/trace-cmd-dump.1.txt b/Documentation/trace-cmd/trace-cmd-dump.1.txt
index b1a3f90d..9c95244b 100644
--- a/Documentation/trace-cmd/trace-cmd-dump.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-dump.1.txt
@@ -52,14 +52,15 @@ OPTIONS
     Print all meta data from the file.
 *--help*::
     Print usage information.
-*--verbose* 'level'::
+*--verbose*[='level']::
      Set the log level. Supported log levels are "none", "critical", "error", "warning",
      "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
      level to specific value enables all logs from that and all previous levels.
+     The level will default to "info" if one is not specified.
 
      Example: enable all critical, error and warning logs
 
-      trace-cmd report --verbose warning
+      trace-cmd report --verbose=warning
 
 EXAMPLES
 --------
diff --git a/Documentation/trace-cmd/trace-cmd-extract.1.txt b/Documentation/trace-cmd/trace-cmd-extract.1.txt
index 88749da7..776da6e1 100644
--- a/Documentation/trace-cmd/trace-cmd-extract.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-extract.1.txt
@@ -67,14 +67,15 @@ OPTIONS
     this is the same as the default. But if *-B* or *-a* is used, this is
     required if the top level instance buffer should also be extracted.
 
-*--verbose* 'level'::
+*--verbose*[='level']::
      Set the log level. Supported log levels are "none", "critical", "error", "warning",
      "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
      level to specific value enables all logs from that and all previous levels.
+     The level will default to "info" if one is not specified.
 
      Example: enable all critical, error and warning logs
 
-      trace-cmd extract --verbose warning
+      trace-cmd extract --verbose=warning
 
 SEE ALSO
 --------
diff --git a/Documentation/trace-cmd/trace-cmd-listen.1.txt b/Documentation/trace-cmd/trace-cmd-listen.1.txt
index da841867..aa6a307f 100644
--- a/Documentation/trace-cmd/trace-cmd-listen.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-listen.1.txt
@@ -36,14 +36,15 @@ OPTIONS
 *-l* 'filename'::
     This option writes the output messages to a log file instead of standard output.
 
-*--verbose* 'level'::
+*--verbose*[='level']::
      Set the log level. Supported log levels are "none", "critical", "error", "warning",
      "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
      level to specific value enables all logs from that and all previous levels.
+     The level will default to "info" if one is not specified.
 
      Example: enable all critical, error and warning logs
 
-      trace-cmd listen --verbose warning
+      trace-cmd listen --verbose=warning
 
 SEE ALSO
 --------
diff --git a/Documentation/trace-cmd/trace-cmd-profile.1.txt b/Documentation/trace-cmd/trace-cmd-profile.1.txt
index 0d285ff7..078ae9e0 100644
--- a/Documentation/trace-cmd/trace-cmd-profile.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-profile.1.txt
@@ -90,14 +90,15 @@ These are the same as trace-cmd-record(1) with the *--profile* option.
     is not changed. This allows watching the command execute and saving the
     output of the profile to another file.
 
-*--verbose* 'level'::
+*--verbose*[='level']::
      Set the log level. Supported log levels are "none", "critical", "error", "warning",
      "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
      level to specific value enables all logs from that and all previous levels.
+     The level will default to "info" if one is not specified.
 
      Example: enable all critical, error and warning logs
 
-      trace-cmd profile --verbose warning
+      trace-cmd profile --verbose=warning
 
 EXAMPLES
 --------
diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index d8065641..96c27108 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -367,14 +367,15 @@ OPTIONS
     Traces are extracted by busy waiting, which will hog the CPUs, so only use
     when really needed.
 
-*--verbose* 'level'::
+*--verbose*[='level']::
      Set the log level. Supported log levels are "none", "critical", "error", "warning",
      "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
      level to specific value enables all logs from that and all previous levels.
+     The level will default to "info" if one is not specified.
 
      Example: enable all critical, error and warning logs
 
-      trace-cmd record --verbose warning
+      trace-cmd record --verbose=warning
 
 EXAMPLES
 --------
diff --git a/Documentation/trace-cmd/trace-cmd-report.1.txt b/Documentation/trace-cmd/trace-cmd-report.1.txt
index 3b801a1c..a6c863a8 100644
--- a/Documentation/trace-cmd/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-report.1.txt
@@ -315,14 +315,15 @@ OPTIONS
 *--align-ts*::
      Display timestamps aligned to the first event.
 
-*--verbose* 'level'::
+*--verbose*[='level']::
      Set the log level. Supported log levels are "none", "critical", "error", "warning",
      "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
      level to specific value enables all logs from that and all previous levels.
+     The level will default to "info" if one is not specified.
 
      Example: enable all critical, error and warning logs
 
-      trace-cmd report --verbose warning
+      trace-cmd report --verbose=warning
 
 EXAMPLES
 --------
diff --git a/Documentation/trace-cmd/trace-cmd-set.1.txt b/Documentation/trace-cmd/trace-cmd-set.1.txt
index 50af7677..a182d191 100644
--- a/Documentation/trace-cmd/trace-cmd-set.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-set.1.txt
@@ -227,14 +227,15 @@ OPTIONS
     unless the *--fork* option is specified. Then it will fork the command and
     return immediately.
 
-*--verbose* 'level'::
+*--verbose*[='level']::
      Set the log level. Supported log levels are "none", "critical", "error", "warning",
      "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
      level to specific value enables all logs from that and all previous levels.
+     The level will default to "info" if one is not specified.
 
      Example: enable all critical, error and warning logs
 
-      trace-cmd set --verbose warning
+      trace-cmd set --verbose=warning
 
 EXAMPLES
 --------
diff --git a/Documentation/trace-cmd/trace-cmd-stack.1.txt b/Documentation/trace-cmd/trace-cmd-stack.1.txt
index 75bd50ba..20752407 100644
--- a/Documentation/trace-cmd/trace-cmd-stack.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-stack.1.txt
@@ -24,9 +24,10 @@ stack found since the start was enabled.
 
 Use *--reset* to reset the stack counter to zero.
 
-User *--verbose* 'level' to set the log level. Supported log levels are "none", "critical", "error",
+User *--verbose*[='level'] to set the log level. Supported log levels are "none", "critical", "error",
 "warning", "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting
-the log level to specific value enables all logs from that and all previous levels.
+the log level to specific value enables all logs from that and all previous levels. The level will
+default to "info" if one is not specified.
 
 SEE ALSO
 --------
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 0dc339b4..b83d3ac1 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -302,7 +302,7 @@ void trace_agent(int argc, char **argv)
 			{"port", required_argument, NULL, 'p'},
 			{"help", no_argument, NULL, '?'},
 			{"debug", no_argument, NULL, DO_DEBUG},
-			{"verbose", required_argument, NULL, OPT_verbose},
+			{"verbose", optional_argument, NULL, OPT_verbose},
 			{NULL, 0, NULL, 0}
 		};
 
diff --git a/tracecmd/trace-check-events.c b/tracecmd/trace-check-events.c
index cf34912a..46f57e17 100644
--- a/tracecmd/trace-check-events.c
+++ b/tracecmd/trace-check-events.c
@@ -24,7 +24,7 @@ void trace_check_events(int argc, char **argv)
 	int open_flags = 0;
 	int option_index = 0;
 	static struct option long_options[] = {
-		{"verbose", required_argument, NULL, OPT_verbose},
+		{"verbose", optional_argument, NULL, OPT_verbose},
 		{NULL, 0, NULL, 0}
 	};
 
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 00cdaa37..7f5d1ffd 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -62,8 +62,9 @@ int trace_set_verbose(char *level)
 {
 	int id;
 
+	/* Default level is info */
 	if (!level)
-		return -1;
+		level = "info";
 
 	if (isdigit(level[0])) {
 		id = atoi(level);
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index cf47e7fb..2334b57e 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -730,7 +730,7 @@ void trace_dump(int argc, char **argv)
 			{"clock", no_argument, NULL, OPT_clock},
 			{"validate", no_argument, NULL, 'v'},
 			{"help", no_argument, NULL, '?'},
-			{"verbose", required_argument, NULL, OPT_verbose},
+			{"verbose", optional_argument, NULL, OPT_verbose},
 			{NULL, 0, NULL, 0}
 		};
 
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index a72365a2..0cb70b7d 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -939,7 +939,7 @@ void trace_listen(int argc, char **argv)
 			{"port", required_argument, NULL, 'p'},
 			{"help", no_argument, NULL, '?'},
 			{"debug", no_argument, NULL, OPT_debug},
-			{"verbose", required_argument, NULL, OPT_verbose},
+			{"verbose", optional_argument, NULL, OPT_verbose},
 			{NULL, 0, NULL, 0}
 		};
 
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index d5687f03..8695f0a4 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1603,7 +1603,7 @@ void trace_report (int argc, char **argv)
 			{"ts-check", no_argument, NULL, OPT_tscheck},
 			{"raw-ts", no_argument, NULL, OPT_raw_ts},
 			{"align-ts", no_argument, NULL, OPT_align_ts},
-			{"verbose", required_argument, NULL, OPT_verbose},
+			{"verbose", optional_argument, NULL, OPT_verbose},
 			{"help", no_argument, NULL, '?'},
 			{NULL, 0, NULL, 0}
 		};
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b5f9c5a0..1767a6c6 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6175,7 +6175,7 @@ static void parse_record_options(int argc,
 			{"fork", no_argument, NULL, OPT_fork},
 			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
 			{"poll", no_argument, NULL, OPT_poll},
-			{"verbose", required_argument, NULL, OPT_verbose},
+			{"verbose", optional_argument, NULL, OPT_verbose},
 			{NULL, 0, NULL, 0}
 		};
 
diff --git a/tracecmd/trace-stack.c b/tracecmd/trace-stack.c
index 6f57387a..80364949 100644
--- a/tracecmd/trace-stack.c
+++ b/tracecmd/trace-stack.c
@@ -164,7 +164,7 @@ void trace_stack (int argc, char **argv)
 			{"stop", no_argument, NULL, OPT_stop},
 			{"reset", no_argument, NULL, OPT_reset},
 			{"help", no_argument, NULL, '?'},
-			{"verbose", required_argument, NULL, OPT_verbose},
+			{"verbose", optional_argument, NULL, OPT_verbose},
 			{NULL, 0, NULL, 0}
 		};
 
-- 
2.30.2

