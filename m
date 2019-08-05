Return-Path: <SRS0=cY0P=WB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C90C41514
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Aug 2019 20:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C74BC214C6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Aug 2019 20:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbfHEUn5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Aug 2019 16:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730055AbfHEUn5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Aug 2019 16:43:57 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B4E021738;
        Mon,  5 Aug 2019 20:43:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hujpj-0008Ri-AG; Mon, 05 Aug 2019 16:43:55 -0400
Message-Id: <20190805204355.195042846@goodmis.org>
User-Agent: quilt/0.65
Date:   Mon, 05 Aug 2019 16:43:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Patrick McLean <chutzpah@gentoo.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: [PATCH 2/3] tools/lib/traceevent: Remove tep_register_trace_clock()
References: <20190805204312.169565525@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

The tep_register_trace_clock() API is used to instruct the
traceevent library how to print the event time stamps. As event
print interface if redesigned, this API is not needed any more.
The new event print API is flexible and the user can specify how
the time stamps are printed.

Link: http://lore.kernel.org/linux-trace-devel/20190801074959.22023-3-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse-local.h |  2 --
 tools/lib/traceevent/event-parse.c       | 11 -----------
 tools/lib/traceevent/event-parse.h       |  1 -
 3 files changed, 14 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
index 6e58ee1fe7c8..cee469803a34 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -81,8 +81,6 @@ struct tep_handle {
 
 	/* cache */
 	struct tep_event *last_event;
-
-	char *trace_clock;
 };
 
 void tep_free_event(struct tep_event *event);
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 0f2bc23efdca..93a21bdd0eaf 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -351,16 +351,6 @@ int tep_override_comm(struct tep_handle *tep, const char *comm, int pid)
 	return _tep_register_comm(tep, comm, pid, true);
 }
 
-int tep_register_trace_clock(struct tep_handle *tep, const char *trace_clock)
-{
-	tep->trace_clock = strdup(trace_clock);
-	if (!tep->trace_clock) {
-		errno = ENOMEM;
-		return -1;
-	}
-	return 0;
-}
-
 struct func_map {
 	unsigned long long		addr;
 	char				*func;
@@ -7015,7 +7005,6 @@ void tep_free(struct tep_handle *tep)
 		free_handler(handle);
 	}
 
-	free(tep->trace_clock);
 	free(tep->events);
 	free(tep->sort_events);
 	free(tep->func_resolver);
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index cf7f302eb44a..d438ee44289f 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -435,7 +435,6 @@ int tep_set_function_resolver(struct tep_handle *tep,
 void tep_reset_function_resolver(struct tep_handle *tep);
 int tep_register_comm(struct tep_handle *tep, const char *comm, int pid);
 int tep_override_comm(struct tep_handle *tep, const char *comm, int pid);
-int tep_register_trace_clock(struct tep_handle *tep, const char *trace_clock);
 int tep_register_function(struct tep_handle *tep, char *name,
 			  unsigned long long addr, char *mod);
 int tep_register_print_string(struct tep_handle *tep, const char *fmt,
-- 
2.20.1


