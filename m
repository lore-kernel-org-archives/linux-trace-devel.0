Return-Path: <SRS0=L246=YS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89C0CA9EBD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Oct 2019 06:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 918BA21D82
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Oct 2019 06:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405627AbfJYGxZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Oct 2019 02:53:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393193AbfJYGxY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Oct 2019 02:53:24 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 806A021D81
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Oct 2019 06:53:24 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1iNtTP-0004uw-Ns
        for linux-trace-devel@vger.kernel.org; Fri, 25 Oct 2019 02:53:23 -0400
Message-Id: <20191025065323.618139839@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 25 Oct 2019 02:52:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Use usecs unless specified not to
References: <20191025065243.627023108@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Old trace-cmd data files did not have an option to store the clock that was
used. It was always assumed that the clock would be in usecs. If there's no
clock in the options of the trace.dat file, then use usecs by default to
stay compatible with older versions of trace-cmd trace.dat files.

Fixes: 150d479b623a ("libtraceevent, perf tools: Changes in tep_print_event_* APIs")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 43bdf6ace33b..ef8f0762a535 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2311,6 +2311,9 @@ static int handle_options(struct tracecmd_input *handle)
 	char *buf;
 	int cpus;
 
+	/* By default, use usecs, unless told otherwise */
+	handle->flags |= TRACECMD_FL_IN_USECS;
+
 	for (;;) {
 		if (do_read_check(handle, &option, 2))
 			return -1;
@@ -2586,10 +2589,11 @@ static void extract_trace_clock(struct tracecmd_input *handle, char *line)
 	if (!clock)
 		return;
 
-	if (!strcmp(clock, "local") || !strcmp(clock, "global")
-	    || !strcmp(clock, "uptime") || !strcmp(clock, "perf")
-	    || !strncmp(clock, "mono", 4))
-		handle->flags |= TRACECMD_FL_IN_USECS;
+	/* Clear usecs if not one of the specified clocks */
+	if (strcmp(clock, "local") && strcmp(clock, "global") &&
+	    strcmp(clock, "uptime") && strcmp(clock, "perf") &&
+	    strncmp(clock, "mono", 4))
+		handle->flags &= ~TRACECMD_FL_IN_USECS;
 }
 
 void tracecmd_parse_trace_clock(struct tracecmd_input *handle,
-- 
2.23.0


