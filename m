Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB5C1C2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 20:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C0746194D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 20:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbhFYUcl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Jun 2021 16:32:41 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:55896 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229712AbhFYUck (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Jun 2021 16:32:40 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 25 Jun 2021 13:15:11 -0700
Received: from oasis.vmware.com (unknown [10.84.232.102])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 8C4A520318;
        Fri, 25 Jun 2021 13:15:14 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] trace-cmd report: Have -V take an optional argument
Date:   Fri, 25 Jun 2021 16:15:10 -0400
Message-ID: <20210625201511.1206465-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210625201511.1206465-1-rostedt@goodmis.org>
References: <20210625201511.1206465-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

By default "-V" will be the same as --verbose=info, but since we allow
--verbose to have an option, do the same with -V. -V will only take a
integer arguments though.

Also updated the documentation of --verbose to the names that are actually
used, and not the extended names ("crit" and not "critical", etc).

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/trace-cmd/trace-cmd-report.1.txt |  4 ++--
 tracecmd/trace-read.c                          |  8 +++-----
 tracecmd/trace-usage.c                         | 14 +++++++++++---
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-report.1.txt b/Documentation/trace-cmd/trace-cmd-report.1.txt
index a6c863a8..501994a4 100644
--- a/Documentation/trace-cmd/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-report.1.txt
@@ -164,7 +164,7 @@ OPTIONS
     *-T* is ignored if *-F* is not specified.
 
 *-V*::
-    Show the plugins that are loaded.
+    Show verbose messages (see *--verbose* but only for the numbers)
 
 *-L*::
     This will not load system wide plugins. It loads "local only". That is
@@ -316,7 +316,7 @@ OPTIONS
      Display timestamps aligned to the first event.
 
 *--verbose*[='level']::
-     Set the log level. Supported log levels are "none", "critical", "error", "warning",
+     Set the log level. Supported log levels are "none", "crit", "err", "warn",
      "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
      level to specific value enables all logs from that and all previous levels.
      The level will default to "info" if one is not specified.
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 8695f0a4..6f43c1d2 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1608,7 +1608,7 @@ void trace_report (int argc, char **argv)
 			{NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long (argc-1, argv+1, "+hSIi:H:feGpRr:tPNn:LlEwF:VvTqO:",
+		c = getopt_long (argc-1, argv+1, "+hSIi:H:feGpRr:tPNn:LlEwF:V::vTqO:",
 			long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1703,10 +1703,6 @@ void trace_report (int argc, char **argv)
 				die("Only 1 -v can be used");
 			neg = 1;
 			break;
-		case 'V':
-			show_status = 1;
-			tracecmd_set_loglevel(TEP_LOG_INFO);
-			break;
 		case 'q':
 			silence_warnings = 1;
 			tracecmd_set_loglevel(TEP_LOG_NONE);
@@ -1784,7 +1780,9 @@ void trace_report (int argc, char **argv)
 		case OPT_align_ts:
 			align_ts = 1;
 			break;
+		case 'V':
 		case OPT_verbose:
+			show_status = 1;
 			if (trace_set_verbose(optarg) < 0)
 				die("invalid verbose level %s", optarg);
 			break;
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index da0266c6..32b38bfd 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -196,7 +196,7 @@ static struct usage_help usage_help[] = {
 		"report",
 		"read out the trace stored in a trace.dat file",
 		" %s report [-i file] [--cpu cpu] [-e][-f][-l][-P][-L][-N][-R][-E]\\\n"
-		"           [-r events][-n events][-F filter][-v][-V][-T][-O option]\n"
+		"           [-r events][-n events][-F filter][-v][-V[1-6]][-T][-O option]\n"
 		"           [-H [start_system:]start_event,start_match[,pid]/[end_system:]end_event,end_match[,flags]\n"
 		"           [-G]\n"
 		"          -i input file [default trace.dat]\n"
@@ -212,7 +212,8 @@ static struct usage_help usage_help[] = {
 		"          -r raw format the events that match the option\n"
 		"          -v will negate all -F after it (Not show matches)\n"
 		"          -T print out the filter strings created and exit\n"
-		"          -V verbose (shows plugins being loaded)\n"
+		"          -V[level] verbose (shows plugins being loaded)\n"
+		"              With optional level (see --verbose numbers)\n"
 		"          -L load only local (~/.trace-cmd/plugins) plugins\n"
 		"          -N do not load any plugins\n"
 		"          -n ignore plugin handlers for events that match the option\n"
@@ -240,7 +241,14 @@ static struct usage_help usage_help[] = {
 		"          --ts-check Check to make sure no time stamp on any CPU goes backwards.\n"
 		"          --raw-ts Display raw timestamps, without any corrections.\n"
 		"          --align-ts Display timestamps aligned to the first event.\n"
-		"          --verbose 'level' Set the desired log level\n"
+		"          --verbose[=level] Set the desired log level\n"
+		"                0 or none  - no error messages\n"
+		"                1 or crit  - only critical messages\n"
+		"                2 or err   - 'crit' and error messages\n"
+		"                3 or warn  - 'err' and warning messages\n"
+		"                4 or info  - 'warn' and informational messages\n"
+		"                5 or debug - 'info' and debugging messages\n"
+		"                6 or all   - same as debug\n"
 	},
 	{
 		"stream",
-- 
2.30.2

