Return-Path: <SRS0=a4XR=YP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C0BCA9EB0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Oct 2019 00:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 144762067B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Oct 2019 00:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387508AbfJVAFB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Oct 2019 20:05:01 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38895 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730846AbfJVAFA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Oct 2019 20:05:00 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iMgx2-0003zy-Mw; Tue, 22 Oct 2019 01:19:01 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 2E2381C047B;
        Tue, 22 Oct 2019 01:19:00 +0200 (CEST)
Date:   Mon, 21 Oct 2019 23:18:59 -0000
From:   "tip-bot2 for Steven Rostedt (VMware)" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf tools: Remove unused trace_find_next_event()
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20191017210636.224045576@goodmis.org>
References: <20191017210636.224045576@goodmis.org>
MIME-Version: 1.0
Message-ID: <157169993978.29376.7756611040363103751.tip-bot2@tip-bot2>
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

Commit-ID:     9bdff5b6436655d42dd30253c521e86ce07b9961
Gitweb:        https://git.kernel.org/tip/9bdff5b6436655d42dd30253c521e86ce07b9961
Author:        Steven Rostedt (VMware) <rostedt@goodmis.org>
AuthorDate:    Thu, 17 Oct 2019 17:05:23 -04:00
Committer:     Arnaldo Carvalho de Melo <acme@redhat.com>
CommitterDate: Fri, 18 Oct 2019 12:07:46 -03:00

perf tools: Remove unused trace_find_next_event()

trace_find_next_event() was buggy and pretty much a useless helper. As
there are no more users, just remove it.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/lkml/20191017210636.224045576@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c | 31 +----------------------------
 tools/perf/util/trace-event.h       |  2 +--
 2 files changed, 33 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 5d6bfc7..9634f0a 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -173,37 +173,6 @@ int parse_event_file(struct tep_handle *pevent,
 	return tep_parse_event(pevent, buf, size, sys);
 }
 
-struct tep_event *trace_find_next_event(struct tep_handle *pevent,
-					struct tep_event *event)
-{
-	static int idx;
-	int events_count;
-	struct tep_event *all_events;
-
-	all_events = tep_get_first_event(pevent);
-	events_count = tep_get_events_count(pevent);
-	if (!pevent || !all_events || events_count < 1)
-		return NULL;
-
-	if (!event) {
-		idx = 0;
-		return all_events;
-	}
-
-	if (idx < events_count && event == (all_events + idx)) {
-		idx++;
-		if (idx == events_count)
-			return NULL;
-		return (all_events + idx);
-	}
-
-	for (idx = 1; idx < events_count; idx++) {
-		if (event == (all_events + (idx - 1)))
-			return (all_events + idx);
-	}
-	return NULL;
-}
-
 struct flag {
 	const char *name;
 	unsigned long long value;
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 2e15838..72fdf2a 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -47,8 +47,6 @@ void parse_saved_cmdline(struct tep_handle *pevent, char *file, unsigned int siz
 
 ssize_t trace_report(int fd, struct trace_event *tevent, bool repipe);
 
-struct tep_event *trace_find_next_event(struct tep_handle *pevent,
-					struct tep_event *event);
 unsigned long long read_size(struct tep_event *event, void *ptr, int size);
 unsigned long long eval_flag(const char *flag);
 
