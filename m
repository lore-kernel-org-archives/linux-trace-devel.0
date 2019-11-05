Return-Path: <SRS0=EBFC=Y5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03EDC5DF60
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Nov 2019 18:18:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CD1D21D6C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Nov 2019 18:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572977919;
	bh=0zExdJqDp/VzHJKCc8MvHYs8Q9aEJBX1cFgElJrKlW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Zsrun3ydxf1hZEVnsoOs0bktak1KXsPfobELgjH+bftcFqYbr5zazAHpc5RGKOBrb
	 MVj1dEytXme4n/HCZDiQnnH7pAS3eFRd7siDeODUpFtaqTW1uLSPt8Zr0JnIPLQB1h
	 1a/Sdk0/cmUgLJfgycu5n1S7gGVm7aYAK2ZPhHnI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390734AbfKESSj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Nov 2019 13:18:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:50740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390520AbfKESSj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Nov 2019 13:18:39 -0500
Received: from quaco.ghostprotocols.net (unknown [177.195.215.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C698521929;
        Tue,  5 Nov 2019 18:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572977918;
        bh=0zExdJqDp/VzHJKCc8MvHYs8Q9aEJBX1cFgElJrKlW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUjHSL2YC0npT72YmZWL/ISgKX3PKq5xoS1s5SVXziMQ2C9xFlyunbr78/fE6QLSr
         nWxMSKirZVCciYB+MTmBhjX8AxAocr6RUdlDeyYXANO9xKyOwElnbLjwxdj61OO33+
         7pbUMVduCzSzPalcXHpdxybE38FPeclcu+612LDo=
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
Subject: [PATCH 2/3] perf tools: Remove unused trace_find_next_event()
Date:   Tue,  5 Nov 2019 15:18:17 -0300
Message-Id: <20191105181818.26748-3-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191105181818.26748-1-acme@kernel.org>
References: <20191105181818.26748-1-acme@kernel.org>
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

