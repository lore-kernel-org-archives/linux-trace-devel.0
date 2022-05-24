Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6AFC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 May 2022 01:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbiEXBuh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 May 2022 21:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbiEXBuf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 May 2022 21:50:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463EF737A3
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 May 2022 18:50:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2106B8171B
        for <linux-trace-devel@vger.kernel.org>; Tue, 24 May 2022 01:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B42C34116;
        Tue, 24 May 2022 01:50:30 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ntJgr-0015i8-M6;
        Mon, 23 May 2022 21:50:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] trace-cmd library: Keep USECS flag if TSC multiplier is set
Date:   Mon, 23 May 2022 21:50:27 -0400
Message-Id: <20220524015028.260238-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524015028.260238-1-rostedt@goodmis.org>
References: <20220524015028.260238-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the option TSC2NSECS is set, then display as microseconds like it does
with trace clock local. This is because even though the x86-tsc is not in
nanoseconds, the clock will be shifted and multiplied to be in
nanoseconds, so it makes sense to convert it to seconds.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 442b1c5a6724..e2ceff331869 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3483,6 +3483,8 @@ static int handle_options(struct tracecmd_input *handle)
 								 buf + 4, 4);
 			handle->tsc_calc.offset = tep_read_number(handle->pevent,
 								  buf + 8, 8);
+			if (!(handle->flags & TRACECMD_FL_RAW_TS))
+				handle->flags |= TRACECMD_FL_IN_USECS;
 			break;
 		case TRACECMD_OPTION_HEADER_INFO:
 		case TRACECMD_OPTION_FTRACE_EVENTS:
@@ -3865,6 +3867,10 @@ static void extract_trace_clock(struct tracecmd_input *handle, char *line)
 	if (handle->flags & TRACECMD_FL_RAW_TS)
 		handle->flags &= ~TRACECMD_FL_IN_USECS;
 
+	/* tsc_calc is a conversion to nanoseconds */
+	if (handle->tsc_calc.mult)
+		return;
+
 	/* Clear usecs if not one of the specified clocks */
 	if (strcmp(clock, "local") && strcmp(clock, "global") &&
 	    strcmp(clock, "uptime") && strcmp(clock, "perf") &&
-- 
2.35.1

