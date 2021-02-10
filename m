Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29682C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 21:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3B2164EDC
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 21:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbhBJVqc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Feb 2021 16:46:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:39454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233358AbhBJVq0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Feb 2021 16:46:26 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D04A64EE0
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Feb 2021 21:45:45 +0000 (UTC)
Date:   Wed, 10 Feb 2021 16:45:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Fix last_timestamp logic to handle multiple
 files
Message-ID: <20210210164543.5ecd9dbd@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The last_timestamp logic to check the integrity of the timestamps in the
ring buffer was done globally, but would break if multiple files were being
included where the data files had different number of CPUs. That's because
the last_timestamp array was recreated for each passed in data file and the
size of the number of CPUs for each file.

Not only was the last_timestamp broken if there were different number of
CPUs, but it was also leaking memory.

Fixes: 8cf601567 ("trace-cmd: Add --ts-check option to report")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-read.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 9270fa2e..ce07b6bd 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -52,6 +52,7 @@ struct handle_list {
 	struct tep_record	*record;
 	struct filter		*event_filters;
 	struct filter		*event_filter_out;
+	unsigned long long	*last_timestamp;
 };
 static struct list_head handle_list;
 
@@ -1193,17 +1194,16 @@ enum output_type {
 static void read_data_info(struct list_head *handle_list, enum output_type otype,
 			   int global)
 {
-	unsigned long long *last_timestamp;
 	struct handle_list *handles;
 	struct handle_list *last_handle;
 	struct tep_record *record;
 	struct tep_record *last_record;
 	struct tep_handle *pevent;
 	struct tep_event *event;
-	int cpus;
 	int ret;
 
 	list_for_each_entry(handles, handle_list, list) {
+		int cpus;
 
 		/* Don't process instances that we added here */
 		if (tracecmd_is_buffer_instance(handles->handle))
@@ -1218,8 +1218,8 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		print_handle_file(handles);
 		printf("cpus=%d\n", cpus);
 
-		last_timestamp = calloc(cpus, sizeof(*last_timestamp));
-		if (!last_timestamp)
+		handles->last_timestamp = calloc(cpus, sizeof(*handles->last_timestamp));
+		if (!handles->last_timestamp)
 			die("allocating timestamps");
 
 		/* Latency trace is just all ASCII */
@@ -1302,31 +1302,30 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		}
 		if (last_record) {
 			int cpu = last_record->cpu;
-			if (cpu >= cpus)
-				die("cpu %d creater than %d\n", cpu, cpus);
+			if (cpu >= last_handle->cpus)
+				die("cpu %d creater than %d\n", cpu, last_handle->cpus);
 			if (tscheck &&
-			    last_timestamp[cpu] > last_record->ts) {
+			    last_handle->last_timestamp[cpu] > last_record->ts) {
 				errno = 0;
 				warning("WARNING: Record on cpu %d went backwards: %lld to %lld delta: -%lld\n",
-					cpu, last_timestamp[cpu],
+					cpu, last_handle->last_timestamp[cpu],
 					last_record->ts,
-					last_timestamp[cpu] - last_record->ts);
+					last_handle->last_timestamp[cpu] - last_record->ts);
 			}
-			last_timestamp[cpu] = last_record->ts;
+			last_handle->last_timestamp[cpu] = last_record->ts;
 			print_handle_file(last_handle);
 			trace_show_data(last_handle->handle, last_record);
 			free_handle_record(last_handle);
 		}
 	} while (last_record);
 
-	free(last_timestamp);
-
 	if (profile)
 		do_trace_profile();
 
 	list_for_each_entry(handles, handle_list, list) {
 		free_filters(handles->event_filters);
 		free_filters(handles->event_filter_out);
+		free(handles->last_timestamp);
 
 		show_test(handles->handle);
 	}
-- 
2.25.4

