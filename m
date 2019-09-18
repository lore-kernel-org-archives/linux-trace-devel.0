Return-Path: <SRS0=S2sz=XN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A7BC4CECE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 02:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A88B4218AF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 02:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfIRCFc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 22:05:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726622AbfIRCFc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 22:05:32 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7763121897
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Sep 2019 02:05:31 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1iAPLW-0000r1-Jo
        for linux-trace-devel@vger.kernel.org; Tue, 17 Sep 2019 22:05:30 -0400
Message-Id: <20190918020530.499901908@goodmis.org>
User-Agent: quilt/0.65
Date:   Tue, 17 Sep 2019 22:03:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/5] trace-cmd: Separate out time diff code in trace_show_data()
References: <20190918020334.344561631@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

To make it easier to convert to the new tep_print_event() format, use the
open coded version of the tracing data regardless if a different timestamp
is to be used.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-read.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index c14e87f76a32..01d904964edf 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -757,6 +757,7 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 {
 	tracecmd_show_data_func func = tracecmd_get_show_data_func(handle);
 	struct tep_handle *pevent;
+	struct tep_event *event;
 	struct trace_seq s;
 	int cpu = record->cpu;
 	bool use_trace_clock;
@@ -793,14 +794,13 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 		}
 	}
 	use_trace_clock = tracecmd_get_use_trace_clock(handle);
+	event = tep_find_event_by_record(pevent, record);
+	tep_print_event_task(pevent, &s, event, record);
+	tep_print_event_time(pevent, &s, event, record,
+			     use_trace_clock);
 	if (tsdiff) {
 		unsigned long long rec_ts = record->ts;
-		struct tep_event *event;
 
-		event = tep_find_event_by_record(pevent, record);
-		tep_print_event_task(pevent, &s, event, record);
-		tep_print_event_time(pevent, &s, event, record,
-					use_trace_clock);
 		buf[0] = 0;
 		if (use_trace_clock && !tep_test_flag(pevent, TEP_NSEC_OUTPUT))
 			rec_ts = (rec_ts + 500) / 1000;
@@ -811,9 +811,10 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 		}
 		last_ts = rec_ts;
 		trace_seq_printf(&s, " %-8s", buf);
-		tep_print_event_data(pevent, &s, event, record);
-	} else
-		tep_print_event(pevent, &s, record, use_trace_clock);
+	}
+
+	tep_print_event_data(pevent, &s, event, record);
+
 	if (s.len && *(s.buffer + s.len - 1) == '\n')
 		s.len--;
 	if (tracecmd_get_debug()) {
-- 
2.20.1


