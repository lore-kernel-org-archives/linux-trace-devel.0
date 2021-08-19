Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC7AC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 04:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F3C66113A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 04:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhHSETW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 00:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229715AbhHSETT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 00:19:19 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C87ED610E6;
        Thu, 19 Aug 2021 04:18:43 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mGZVq-004dzx-Rj; Thu, 19 Aug 2021 00:18:42 -0400
Message-ID: <20210819041842.696873153@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 19 Aug 2021 00:13:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>
Subject: [PATCH v7 09/10] selftests/ftrace: Add clear_dynamic_events() to test cases
References: <20210819041321.105110033@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a function to remove all dynamic events from the tracing directory. It
requires a loop as some of the dynamic events may depend on others being
removed first. Also add a safety that prevents it from looping infinitely
due to a bug where an event never gets removed.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../testing/selftests/ftrace/test.d/functions | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/ftrace/test.d/functions b/tools/testing/selftests/ftrace/test.d/functions
index a6fac927ee82..1e6ae4a243a4 100644
--- a/tools/testing/selftests/ftrace/test.d/functions
+++ b/tools/testing/selftests/ftrace/test.d/functions
@@ -83,6 +83,27 @@ clear_synthetic_events() { # reset all current synthetic events
     done
 }
 
+clear_dynamic_events() { # reset all current dynamic events
+    again=1
+    stop=1
+    # loop mulitple times as some events require other to be removed first
+    while [ $again -eq 1 ]; do
+	stop=$((stop+1))
+	# Prevent infinite loops
+	if [ $stop -gt 10 ]; then
+	    break;
+	fi
+	again=2
+	grep -v '^#' dynamic_events|
+	while read line; do
+	    del=`sed -e 's/^.\([^ ]*\).*/-\1/'`
+	    if ! echo "$del" >> dynamic_events; then
+		again=1
+	    fi
+	done
+    done
+}
+
 initialize_ftrace() { # Reset ftrace to initial-state
 # As the initial state, ftrace will be set to nop tracer,
 # no events, no triggers, no filters, no function filters,
@@ -93,6 +114,7 @@ initialize_ftrace() { # Reset ftrace to initial-state
     reset_events_filter
     reset_ftrace_filter
     disable_events
+    clear_dynamic_events
     [ -f set_event_pid ] && echo > set_event_pid
     [ -f set_ftrace_pid ] && echo > set_ftrace_pid
     [ -f set_ftrace_notrace ] && echo > set_ftrace_notrace
-- 
2.30.2
