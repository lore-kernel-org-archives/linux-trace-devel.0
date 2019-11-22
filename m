Return-Path: <SRS0=hl++=ZO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69ABFC432C0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Nov 2019 21:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 440432071C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Nov 2019 21:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfKVVzm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Nov 2019 16:55:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbfKVVzm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Nov 2019 16:55:42 -0500
Received: from oasis.local.home (unknown [66.170.99.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5191B20708
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Nov 2019 21:55:42 +0000 (UTC)
Date:   Fri, 22 Nov 2019 16:55:37 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Fix latency format to show latency
Message-ID: <20191122165537.26f89069@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When trace-cmd report -l is used, the latency format is missing. This is
due to the show data routine not using TEP_PRINT_LATENCY. Need to change
the logic slightly where different parameters is sent to tep_print_event()
when latency_format is set, instead of just passing a different format
file.

Fixes: 150d479b623a ("libtraceevent, perf tools: Changes in tep_print_event_* APIs")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-read.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 4958fa81..a5813848 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -781,7 +781,6 @@ static void finish_wakeup(void)
 void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 {
 	tracecmd_show_data_func func = tracecmd_get_show_data_func(handle);
-	const char *lfmt = latency_format ? "%8.8s-%-5d %3d" : "%16s-%-5d [%03d]";
 	const char *tfmt = tracecmd_get_flags(handle) & TRACECMD_FL_IN_USECS ? " %6.1000d:" : "%12d:";
 	struct tep_handle *pevent;
 	struct tep_event *event;
@@ -823,8 +822,17 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 		}
 	}
 
-	tep_print_event(pevent, &s, record, lfmt, TEP_PRINT_COMM,
-			TEP_PRINT_PID, TEP_PRINT_CPU);
+	if (latency_format)
+		tep_print_event(pevent, &s, record, "%8.8s-%-5d %3d%s",
+				TEP_PRINT_COMM,
+				TEP_PRINT_PID,
+				TEP_PRINT_CPU,
+				TEP_PRINT_LATENCY);
+	else
+		tep_print_event(pevent, &s, record, "%16s-%-5d [%03d]",
+				TEP_PRINT_COMM,
+				TEP_PRINT_PID,
+				TEP_PRINT_CPU);
 	tep_print_event(pevent, &s, record, tfmt, TEP_PRINT_TIME);
 
 	if (tsdiff) {
-- 
2.24.0

