Return-Path: <SRS0=xBmi=YK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84856FA372A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Oct 2019 21:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59DBC21A4C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Oct 2019 21:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441048AbfJQVGm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 17:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394965AbfJQVGi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 17:06:38 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F089D21D7A;
        Thu, 17 Oct 2019 21:06:36 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1iLCyi-00069h-6K; Thu, 17 Oct 2019 17:06:36 -0400
Message-Id: <20191017210636.061448713@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 17 Oct 2019 17:05:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf: Iterate on tep event arrays directly
References: <20191017210521.465613686@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of calling a useless (and broken) helper function to get the next
event of a tep event array, just get the array directly and iterate over it.

Note, the broken part was from trace_find_next_event() which after this will
no longer be used, and can be removed.

Link: http://lkml.kernel.org/r/20191017153733.630cd5eb@gandalf.local.home

Reported-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/perf/util/scripting-engines/trace-event-perl.c   | 8 ++++++--
 tools/perf/util/scripting-engines/trace-event-python.c | 9 +++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 15961854ba67..741f040648b5 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -539,10 +539,11 @@ static int perl_stop_script(void)
 
 static int perl_generate_script(struct tep_handle *pevent, const char *outfile)
 {
+	int i, not_first, count, nr_events;
+	struct tep_event **all_events;
 	struct tep_event *event = NULL;
 	struct tep_format_field *f;
 	char fname[PATH_MAX];
-	int not_first, count;
 	FILE *ofp;
 
 	sprintf(fname, "%s.pl", outfile);
@@ -603,8 +604,11 @@ sub print_backtrace\n\
 }\n\n\
 ");
 
+	nr_events = tep_get_events_count(pevent);
+	all_events = tep_list_events(pevent, TEP_EVENT_SORT_ID);
 
-	while ((event = trace_find_next_event(pevent, event))) {
+	for (i = 0; all_events && i < nr_events; i++) {
+		event = all_events[i];
 		fprintf(ofp, "sub %s::%s\n{\n", event->system, event->name);
 		fprintf(ofp, "\tmy (");
 
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 5d341efc3237..93c03b39cd9c 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -1687,10 +1687,11 @@ static int python_stop_script(void)
 
 static int python_generate_script(struct tep_handle *pevent, const char *outfile)
 {
+	int i, not_first, count, nr_events;
+	struct tep_event **all_events;
 	struct tep_event *event = NULL;
 	struct tep_format_field *f;
 	char fname[PATH_MAX];
-	int not_first, count;
 	FILE *ofp;
 
 	sprintf(fname, "%s.py", outfile);
@@ -1735,7 +1736,11 @@ static int python_generate_script(struct tep_handle *pevent, const char *outfile
 	fprintf(ofp, "def trace_end():\n");
 	fprintf(ofp, "\tprint(\"in trace_end\")\n\n");
 
-	while ((event = trace_find_next_event(pevent, event))) {
+	nr_events = tep_get_events_count(pevent);
+	all_events = tep_list_events(pevent, TEP_EVENT_SORT_ID);
+
+	for (i = 0; all_events && i < nr_events; i++) {
+		event = all_events[i];
 		fprintf(ofp, "def %s__%s(", event->system, event->name);
 		fprintf(ofp, "event_name, ");
 		fprintf(ofp, "context, ");
-- 
2.23.0


