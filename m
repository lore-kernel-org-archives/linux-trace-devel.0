Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88461C0018C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 22:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CF6B238A0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 22:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbgLPWBr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 17:01:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:43714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730003AbgLPWBp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 17:01:45 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DB1B2389E
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 22:01:05 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kper2-000wjp-1n
        for linux-trace-devel@vger.kernel.org; Wed, 16 Dec 2020 17:01:04 -0500
Message-ID: <20201216220103.883960678@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 17:00:33 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] trace-cmd: Move add_event_pid() out of #ifndef NO_PTRACE
References: <20201216220032.809666622@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When NO_PTRACE is defined, add_event_pid() is also not defined, but it is
used outside of NO_PTRACE pre processor block. And this causes a
"add_event_pid" not defined build failure.

Fixes: 0844cff1c ("trace-cmd: Fix "trace-cmd reset" command to restore the default value of set_event_pid")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index f8baed7dcd47..e2d1cedf05fb 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1312,8 +1312,13 @@ out:
 	free(pidfds);
 	return ret;
 }
-#ifndef NO_PTRACE
 
+static void add_event_pid(struct buffer_instance *instance, const char *buf)
+{
+	tracefs_instance_file_write(instance->tracefs, "set_event_pid", buf);
+}
+
+#ifndef NO_PTRACE
 /**
  * append_pid_filter - add a new pid to an existing filter
  * @curr_filter: the filter to append to. If NULL, then allocate one
@@ -1369,11 +1374,6 @@ static void update_sched_events(struct buffer_instance *instance, int pid)
 static int open_instance_fd(struct buffer_instance *instance,
 			    const char *file, int flags);
 
-static void add_event_pid(struct buffer_instance *instance, const char *buf)
-{
-	tracefs_instance_file_write(instance->tracefs, "set_event_pid", buf);
-}
-
 static void add_new_filter_child_pid(int pid, int child)
 {
 	struct buffer_instance *instance;
-- 
2.29.2


