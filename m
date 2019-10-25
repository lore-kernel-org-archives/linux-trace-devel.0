Return-Path: <SRS0=L246=YS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C95CA9EA0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Oct 2019 06:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EACF20867
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Oct 2019 06:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393194AbfJYGxZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Oct 2019 02:53:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393185AbfJYGxY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Oct 2019 02:53:24 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68DD821D71
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Oct 2019 06:53:24 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1iNtTP-0004uR-JG
        for linux-trace-devel@vger.kernel.org; Fri, 25 Oct 2019 02:53:23 -0400
Message-Id: <20191025065323.479273995@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 25 Oct 2019 02:52:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] libtraceevent: Remove extra \n in print_event_time()
References: <20191025065243.627023108@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If the precesion of print_event_time() is zero or greater than the
timestamp, it uses a different format. But that format had an extra new line
at the end, and caused the output to not look right:

cpus=2
           sleep-3946  [001]111264306005
: function:             inotify_inode_queue_event
           sleep-3946  [001]111264307158
: function:             __fsnotify_parent
           sleep-3946  [001]111264307637
: function:             inotify_dentry_parent_queue_event
           sleep-3946  [001]111264307989
: function:             fsnotify
           sleep-3946  [001]111264308401
: function:             audit_syscall_exit

Fixes: 150d479b623a ("libtraceevent, perf tools: Changes in tep_print_event_* APIs")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/traceevent/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index eb84fbb49e4d..0a49eb936b34 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -5528,7 +5528,7 @@ static void print_event_time(struct tep_handle *tep, struct trace_seq *s,
 	if (p10 > 1 && p10 < time)
 		trace_seq_printf(s, "%5llu.%0*llu", time / p10, prec, time % p10);
 	else
-		trace_seq_printf(s, "%12llu\n", time);
+		trace_seq_printf(s, "%12llu", time);
 }
 
 struct print_event_type {
-- 
2.23.0


