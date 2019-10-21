Return-Path: <SRS0=j4Iw=YO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BEBCA9EB7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Oct 2019 13:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BA1C20679
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Oct 2019 13:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571665356;
	bh=0zExdJqDp/VzHJKCc8MvHYs8Q9aEJBX1cFgElJrKlW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=A0Nb30oFm797AK89dnYbfaUcoBU1eF84z6+hnw5yff2KMNQOQpktpim4bCx4X34+5
	 YoLWKV1mrzbzwwmKoNC+x8m5rALng0MtHHLF5KJqpXMv4OcSqMdiQVCi/bZnsyZ2rw
	 SUgVUM7gAYUaxRLB5sC7yxTBkjyNQ5KS4G2aJhzI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbfJUNkf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Oct 2019 09:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729512AbfJUNke (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Oct 2019 09:40:34 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.35.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1718F21A4A;
        Mon, 21 Oct 2019 13:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571665233;
        bh=0zExdJqDp/VzHJKCc8MvHYs8Q9aEJBX1cFgElJrKlW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fk4uJqatERc+i1LHX1mFOSqB5duLN7nQHIXMMiS5pmTt5U39HWIwcJhZ9w79x9biF
         WYDCg5YFVVdnTP2M6KxL36lc+pXocg+ZweeG0L5KSxbWJmd2x1TuX50jiHgM4ELLFp
         dewbBzMRz5QUID5RcFyFPGjfd/inEHT9fU2X2MxA=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 35/57] perf tools: Remove unused trace_find_next_event()
Date:   Mon, 21 Oct 2019 10:38:12 -0300
Message-Id: <20191021133834.25998-36-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021133834.25998-1-acme@kernel.org>
References: <20191021133834.25998-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

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
 tools/perf/util/trace-event-parse.c | 31 -----------------------------
 tools/perf/util/trace-event.h       |  2 --
 2 files changed, 33 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 5d6bfc70b210..9634f0ae57be 100644
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
index 2e158387b3d7..72fdf2a3577c 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -47,8 +47,6 @@ void parse_saved_cmdline(struct tep_handle *pevent, char *file, unsigned int siz
 
 ssize_t trace_report(int fd, struct trace_event *tevent, bool repipe);
 
-struct tep_event *trace_find_next_event(struct tep_handle *pevent,
-					struct tep_event *event);
 unsigned long long read_size(struct tep_event *event, void *ptr, int size);
 unsigned long long eval_flag(const char *flag);
 
-- 
2.21.0

