Return-Path: <SRS0=+uc8=UK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A508CC4321A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jun 2019 01:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72BFD20896
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jun 2019 01:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390131AbfFKB1K (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 Jun 2019 21:27:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388845AbfFKB1K (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 Jun 2019 21:27:10 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CA27206BA;
        Tue, 11 Jun 2019 01:27:08 +0000 (UTC)
Date:   Mon, 10 Jun 2019 21:27:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        tstoyanov@vmware.com, slavomir.kaslev@gmail.com
Subject: [PATCH] trace-cmd: Add trace-cmd report --version to extract
 version info
Message-ID: <20190610212706.2505bffe@oasis.local.home>
In-Reply-To: <20190604124826.6716-1-kaslevs@vmware.com>
References: <20190604082440.724d7d95@oasis.local.home>
        <20190604124826.6716-1-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Now that the trace.dat file can save the version of the executable that was
used to create it, save that information. This will be useful if a user has
a problem with a trace.dat file. It can let the developers know what version
was used to create it. We need a way to extract this information. Adding a
new "--version" to trace-cmd report will display the saved version in the
trace.dat file if it exists.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/trace-cmd-report.1.txt |  4 ++++
 include/trace-cmd/trace-cmd.h        |  1 +
 lib/trace-cmd/trace-input.c          | 19 +++++++++++++++++++
 tracecmd/trace-read.c                | 12 ++++++++++++
 tracecmd/trace-usage.c               |  1 +
 5 files changed, 37 insertions(+)

diff --git a/Documentation/trace-cmd-report.1.txt b/Documentation/trace-cmd-report.1.txt
index 20d6b7ab..87f4d7a1 100644
--- a/Documentation/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd-report.1.txt
@@ -248,6 +248,10 @@ OPTIONS
     If the trace.dat file recorded uname during the run, this will retrieve that
     information.
 
+*--version*::
+    If the trace.dat file recorded the version of the executable used to create
+    it, report that version.
+
 *--ts-offset* offset::
     Add (or subtract if negative) an offset for all timestamps of the previous
     data file specified with *-i*. This is useful to merge sort multiple trace.dat
diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 8b922102..6f62ab99 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -138,6 +138,7 @@ int tracecmd_init_data(struct tracecmd_input *handle);
 
 void tracecmd_print_stats(struct tracecmd_input *handle);
 void tracecmd_print_uname(struct tracecmd_input *handle);
+void tracecmd_print_version(struct tracecmd_input *handle);
 
 struct tep_record *
 tracecmd_read_page_record(struct tep_handle *pevent, void *page, int size,
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 264e3c32..61566bad 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -94,6 +94,7 @@ struct tracecmd_input {
 	double			ts2secs;
 	char *			cpustats;
 	char *			uname;
+	char *			version;
 	struct input_buffer_instance	*buffers;
 	int			parsing_failures;
 
@@ -2220,6 +2221,9 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_UNAME:
 			handle->uname = strdup(buf);
 			break;
+		case TRACECMD_OPTION_VERSION:
+			handle->version = strdup(buf);
+			break;
 		case TRACECMD_OPTION_HOOK:
 			hook = tracecmd_create_event_hook(buf);
 			hook->next = handle->hooks;
@@ -2598,6 +2602,21 @@ void tracecmd_print_uname(struct tracecmd_input *handle)
 		printf(" uname was not recorded in this file\n");
 }
 
+/**
+ * tracecmd_print_uname - prints the recorded uname if it was recorded
+ * @handle: input handle for the trace.dat file
+ *
+ * Looks for the option TRACECMD_OPTION_VERSION and prints out what's
+ * stored there, if it is found. Otherwise it prints that none were found.
+ */
+void tracecmd_print_version(struct tracecmd_input *handle)
+{
+	if (handle->version)
+		printf("%s\n", handle->version);
+	else
+		printf(" version was not recorded in this file\n");
+}
+
 /**
  * tracecmd_hooks - return the event hooks that were used in record
  * @handle: input handle for the trace.dat file
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index dbfb3a54..d22c723b 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1112,6 +1112,7 @@ enum output_type {
 	OUTPUT_NORMAL,
 	OUTPUT_STAT_ONLY,
 	OUTPUT_UNAME_ONLY,
+	OUTPUT_VERSION_ONLY,
 };
 
 static void read_data_info(struct list_head *handle_list, enum output_type otype,
@@ -1160,6 +1161,8 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 			continue;
 		case OUTPUT_UNAME_ONLY:
 			tracecmd_print_uname(handles->handle);
+		case OUTPUT_VERSION_ONLY:
+			tracecmd_print_version(handles->handle);
 			continue;
 		}
 
@@ -1386,6 +1389,7 @@ static void add_hook(const char *arg)
 }
 
 enum {
+	OPT_version	= 238,
 	OPT_tsdiff	= 239,
 	OPT_ts2secs	= 240,
 	OPT_tsoffset	= 241,
@@ -1427,6 +1431,7 @@ void trace_report (int argc, char **argv)
 	int show_page_size = 0;
 	int show_printk = 0;
 	int show_uname = 0;
+	int show_version = 0;
 	int latency_format = 0;
 	int show_events = 0;
 	int print_events = 0;
@@ -1468,6 +1473,7 @@ void trace_report (int argc, char **argv)
 			{"debug", no_argument, NULL, OPT_debug},
 			{"profile", no_argument, NULL, OPT_profile},
 			{"uname", no_argument, NULL, OPT_uname},
+			{"version", no_argument, NULL, OPT_version},
 			{"by-comm", no_argument, NULL, OPT_bycomm},
 			{"ts-offset", required_argument, NULL, OPT_tsoffset},
 			{"ts2secs", required_argument, NULL, OPT_ts2secs},
@@ -1618,6 +1624,9 @@ void trace_report (int argc, char **argv)
 		case OPT_uname:
 			show_uname = 1;
 			break;
+		case OPT_version:
+			show_version = 1;
+			break;
 		case OPT_bycomm:
 			trace_profile_set_merge_like_comms();
 			break;
@@ -1767,6 +1776,9 @@ void trace_report (int argc, char **argv)
 	/* yeah yeah, uname overrides stat */
 	if (show_uname)
 		otype = OUTPUT_UNAME_ONLY;
+	/* and version overrides uname! */
+	if (show_version)
+		otype = OUTPUT_VERSION_ONLY;
 	read_data_info(&handle_list, otype, global);
 
 	list_for_each_entry(handles, &handle_list, list) {
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index d2a10895..00127299 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -166,6 +166,7 @@ static struct usage_help usage_help[] = {
 		"          --check-events return whether all event formats can be parsed\n"
 		"          --stat - show the buffer stats that were reported at the end of the record.\n"
 		"          --uname - show uname of the record, if it was saved\n"
+		"          --version - show version used to build the trace-cmd exec that created the file\n"
 		"          --profile report stats on where tasks are blocked and such\n"
 		"          -G when profiling, set soft and hard irqs as global\n"
 		"          -H Allows users to hook two events together for timings\n"
-- 
2.20.1

