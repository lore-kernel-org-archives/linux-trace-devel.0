Return-Path: <SRS0=nG5h=4T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B11C3F2D1
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 18:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B02F21D56
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 18:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgCBSDi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 13:03:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:41124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgCBSDi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 13:03:38 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB8A621D56
        for <linux-trace-devel@vger.kernel.org>; Mon,  2 Mar 2020 18:03:37 +0000 (UTC)
Date:   Mon, 2 Mar 2020 13:03:36 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Have trace-cmd record -c set function-fork
 option if exists
Message-ID: <20200302130336.4b6c63e5@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If the function-fork option exists on the machine, then it should be set if
'-c' is added to trace-cmd record. Othrewise the function tracers will not
trace the children of the process it is recording.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 0a3851ad..2866b776 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -128,6 +128,7 @@ static int len_filter_pids;
 
 static int have_set_event_pid;
 static int have_event_fork;
+static int have_func_fork;
 
 struct opt_list {
 	struct opt_list *next;
@@ -354,6 +355,14 @@ static void test_set_event_pid(void)
 	}
 	tracefs_put_tracing_file(path);
 
+	path = tracefs_get_tracing_file("options/function-fork");
+	ret = stat(path, &st);
+	if (!ret) {
+		have_func_fork = 1;
+		reset_save_file(path, RESET_DEFAULT_PRIO);
+	}
+	tracefs_put_tracing_file(path);
+
 	tested = 1;
 }
 
@@ -5595,6 +5604,8 @@ static void parse_record_options(int argc,
 				save_option("event-fork");
 				ctx->do_child = 1;
 			}
+			if (have_func_fork)
+				save_option("function-fork");
 			break;
 		case 'C':
 			ctx->instance->clock = optarg;
-- 
2.20.1

