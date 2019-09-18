Return-Path: <SRS0=S2sz=XN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C1DC4CEC9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 02:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8847E214AF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 02:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfIRCFc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 22:05:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbfIRCFc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 22:05:32 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 911202189D
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Sep 2019 02:05:31 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1iAPLW-0000rV-P0
        for linux-trace-devel@vger.kernel.org; Tue, 17 Sep 2019 22:05:30 -0400
Message-Id: <20190918020530.655810800@goodmis.org>
User-Agent: quilt/0.65
Date:   Tue, 17 Sep 2019 22:03:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/5] trace-cmd: Add check for trace_clock using usecs into
 tracecmd_parse_trace_clock()
References: <20190918020334.344561631@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In preparation for using the new tep_print_event() format, move the logic of
checking if the trace_clock used should be default as printed in usecs into
tracecmd_parse_trace_clock() when it parses the trace_clock.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/trace-cmd/trace-cmd.h | 1 +
 lib/trace-cmd/trace-input.c   | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index eb36a1f20c30..7c3bc2229461 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -87,6 +87,7 @@ enum {
 	TRACECMD_FL_IGNORE_DATE		= (1 << 0),
 	TRACECMD_FL_BUFFER_INSTANCE	= (1 << 1),
 	TRACECMD_FL_LATENCY		= (1 << 2),
+	TRACECMD_FL_IN_USECS		= (1 << 3),
 };
 
 struct tracecmd_ftrace {
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 5533d42fd7c2..73f27a4e50d0 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2582,6 +2582,14 @@ static void extract_trace_clock(struct tracecmd_input *handle, char *line)
 	sscanf(data, "%ms", &clock);
 	/* TODO: report if it fails to allocate */
 	handle->trace_clock = clock;
+
+	if (!clock)
+		return;
+
+	if (!strcmp(clock, "local") || !strcmp(clock, "global")
+	    || !strcmp(clock, "uptime") || !strcmp(clock, "perf")
+	    || !strncmp(clock, "mono", 4))
+		handle->flags |= TRACECMD_FL_IN_USECS;
 }
 
 void tracecmd_parse_trace_clock(struct tracecmd_input *handle,
-- 
2.20.1


