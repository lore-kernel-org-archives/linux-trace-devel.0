Return-Path: <SRS0=a4XR=YP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67849CA9EAF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Oct 2019 00:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3954820882
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Oct 2019 00:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730772AbfJVAEq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Oct 2019 20:04:46 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38895 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730730AbfJVAEq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Oct 2019 20:04:46 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iMgx8-000403-9h; Tue, 22 Oct 2019 01:19:06 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id A59781C0489;
        Tue, 22 Oct 2019 01:19:00 +0200 (CEST)
Date:   Mon, 21 Oct 2019 23:19:00 -0000
From:   "tip-bot2 for Steven Rostedt (VMware)" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf scripting engines: Iterate on tep event arrays directly
Cc:     Daniel Bristot de Oliveira <bristot@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        linux-trace-devel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20191017153733.630cd5eb@gandalf.local.home>
References: <20191017153733.630cd5eb@gandalf.local.home>
MIME-Version: 1.0
Message-ID: <157169994036.29376.7991606132621346447.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     a5e05abc6b8d81148b35cd8632a4a6252383d968
Gitweb:        https://git.kernel.org/tip/a5e05abc6b8d81148b35cd8632a4a6252383d968
Author:        Steven Rostedt (VMware) <rostedt@goodmis.org>
AuthorDate:    Thu, 17 Oct 2019 17:05:22 -04:00
Committer:     Arnaldo Carvalho de Melo <acme@redhat.com>
CommitterDate: Fri, 18 Oct 2019 12:07:46 -03:00

perf scripting engines: Iterate on tep event arrays directly

Instead of calling a useless (and broken) helper function to get the
next event of a tep event array, just get the array directly and iterate
over it.

Note, the broken part was from trace_find_next_event() which after this
will no longer be used, and can be removed.

Committer notes:

This fixes a segfault when generating python scripts from perf.data
files with multiple tracepoint events, i.e. the following use case is
fixed by this patch:

  # perf record -e sched:* sleep 1
  [ perf record: Woken up 31 times to write data ]
  [ perf record: Captured and wrote 0.031 MB perf.data (9 samples) ]
  # perf script -g python
  Segmentation fault (core dumped)
  #

Reported-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20191017153733.630cd5eb@gandalf.local.home
Link: http://lore.kernel.org/lkml/20191017210636.061448713@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/scripting-engines/trace-event-perl.c   |  8 ++++++--
 tools/perf/util/scripting-engines/trace-event-python.c |  9 +++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 1596185..741f040 100644
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
index 5d341ef..93c03b3 100644
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
