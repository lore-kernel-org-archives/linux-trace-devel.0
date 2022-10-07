Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A2FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Oct 2022 18:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJGSi4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 Oct 2022 14:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJGSiz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 Oct 2022 14:38:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BFE3056A
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 Oct 2022 11:38:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A595D61AA8
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 Oct 2022 18:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFF3C433C1;
        Fri,  7 Oct 2022 18:38:52 +0000 (UTC)
Date:   Fri, 7 Oct 2022 14:38:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Ian Rogers <irogers@google.com>
Subject: [PATCH] trace-cmd library: Do not call callbacks with NULL record
Message-ID: <20221007143859.6895d756@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The callbacks path can possibly be called when the next record is NULL. Do
not call the callbacks in this case, as they are not expecting a NULL
record, nor should they have to.

Move the code that calls the callbacks in tracecmd_iterate_events() and
tracecmd_iterate_events_multi() into a single helper function to alleviate
fixing one and not the other.

Reported-by: Ian Rogers <irogers@google.com>
Fixes: 3cd1b55f3 ("trace-cmd library: Add tracecmd_follow_event()")
Fixes: 82ed4a937 ("trace-cmd library: Add filtering logic for iterating events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 42 ++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index d81918249871..6a8ca2e8a6b8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2648,6 +2648,29 @@ static int call_followers(struct tracecmd_input *handle,
 	return ret;
 }
 
+static int call_callbacks(struct tracecmd_input *handle, struct tep_record *record,
+			  int next_cpu,
+			  int (*callback)(struct tracecmd_input *handle,
+					  struct tep_record *,
+					  int, void *),
+			  void *callback_data)
+{
+	int ret = 0;
+
+	if (!record)
+		return 0;
+
+	if (!handle->filter ||
+	    tracecmd_filter_match(handle->filter, record) == TRACECMD_FILTER_MATCH) {
+		if (handle->nr_followers)
+			ret = call_followers(handle, record, next_cpu);
+		if (!ret && callback)
+			ret = callback(handle, record, next_cpu, callback_data);
+	}
+
+	return ret;
+}
+
 /**
  * tracecmd_iterate_events - iterate events over a given handle
  * @handle: The handle to iterate over
@@ -2709,13 +2732,9 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 			record = tracecmd_read_data(handle, next_cpu);
 			records[next_cpu] = tracecmd_peek_data(handle, next_cpu);
 
-			if (!handle->filter ||
-			    tracecmd_filter_match(handle->filter, record) == TRACECMD_FILTER_MATCH) {
-				if (handle->nr_followers)
-					ret = call_followers(handle, record, next_cpu);
-				if (!ret && callback)
-					ret = callback(handle, record, next_cpu, callback_data);
-			}
+			ret = call_callbacks(handle, record, next_cpu,
+					     callback, callback_data);
+
 			tracecmd_free_record(record);
 		}
 	} while (next_cpu >= 0 && ret >= 0);
@@ -2803,14 +2822,9 @@ int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
 			record = tracecmd_read_data(handle, cpu);
 			records[next_cpu].record = tracecmd_peek_data(handle, cpu);
 
-			if (!handle->filter ||
-			    tracecmd_filter_match(handle->filter, record) == TRACECMD_FILTER_MATCH) {
-				if (handle->nr_followers)
-					ret = call_followers(handle, record, next_cpu);
+			ret = call_callbacks(handle, record, next_cpu,
+					     callback, callback_data);
 
-				if (!ret && callback)
-					ret = callback(handle, record, next_cpu, callback_data);
-			}
 			tracecmd_free_record(record);
 		}
 
-- 
2.35.1

