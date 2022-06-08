Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE54C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244195AbiFHPVe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 11:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244855AbiFHPTy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 11:19:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9CAD8D0A
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 08:14:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF6B5B82615
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 15:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEB4C34116;
        Wed,  8 Jun 2022 15:14:26 +0000 (UTC)
Date:   Wed, 8 Jun 2022 11:14:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] trace-cmd split: Save missed events
Message-ID: <20220608111424.4a66d384@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the file that is being split has missed events, the new file does not
create them. This gets confusing for users that see gaps in the trace.

Have the split code preserve the missed events in the new file.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=212421
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-split.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 83c5402c279b..851ec94eda1f 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -40,6 +40,7 @@ enum split_types {
 struct cpu_data {
 	unsigned long long		ts;
 	unsigned long long		offset;
+	unsigned long long		missed_events;
 	struct tep_record		*record;
 	int				cpu;
 	int				fd;
@@ -137,18 +138,37 @@ static int write_record(struct tracecmd_input *handle,
 	return 1;
 }
 
+#define MISSING_EVENTS (1UL << 31)
+#define MISSING_STORED (1UL << 30)
+
+#define COMMIT_MASK ((1 << 27) - 1)
+
 static void write_page(struct tep_handle *pevent,
 		       struct cpu_data *cpu_data, int long_size)
 {
+	unsigned long long *ptr = NULL;
+	unsigned int flags = 0;
+
+	if (cpu_data->missed_events) {
+		flags |= MISSING_EVENTS;
+		if (cpu_data->missed_events > 0) {
+			flags |= MISSING_STORED;
+			ptr = cpu_data->page + cpu_data->index;
+		}
+	}
+
 	if (long_size == 8) {
-		unsigned long long index = cpu_data->index - 16;
+		unsigned long long index = cpu_data->index - 16 + flags;;
 		*(unsigned long long *)cpu_data->commit =
 				tep_read_number(pevent, &index, 8);
 	} else {
-		unsigned int index = cpu_data->index - 12;
+		unsigned int index = cpu_data->index - 12 + flags;;
 		*(unsigned int *)cpu_data->commit =
 			tep_read_number(pevent, &index, 4);
 	}
+	if (ptr)
+		*ptr = tep_read_number(pevent, &cpu_data->missed_events, 8);
+
 	write(cpu_data->fd, cpu_data->page, page_size);
 }
 
@@ -224,7 +244,8 @@ static int parse_cpu(struct tracecmd_input *handle,
 		start = record->ts;
 
 	while (record && (!end || record->ts <= end)) {
-		if (cpu_data[cpu].index + record->record_size > page_size) {
+		if ((cpu_data[cpu].index + record->record_size > page_size) ||
+		    record->missed_events) {
 
 			if (type == SPLIT_PAGES && ++pages > count_limit)
 				break;
@@ -237,6 +258,8 @@ static int parse_cpu(struct tracecmd_input *handle,
 					die("Failed to allocate page");
 			}
 
+			cpu_data[cpu].missed_events = record->missed_events;
+
 			memset(cpu_data[cpu].page, 0, page_size);
 			ptr = cpu_data[cpu].page;
 
-- 
2.35.1

