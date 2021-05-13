Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A4A7C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 21:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2F12613B6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 21:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbhEMVEe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 May 2021 17:04:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233226AbhEMVEe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 May 2021 17:04:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C663161438
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 May 2021 21:03:23 +0000 (UTC)
Date:   Thu, 13 May 2021 17:03:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: trace-cmd record: Update filter_command() to use
 tracefs_instance_file_append()
Message-ID: <20210513170322.5aa779d7@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Now that trace-cmd depends on libtracefs 1.2, have filter_command use the
tracefs_instance_file_append() as it had originally when first added,
instead of open coding it for libtracefs 1.1.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 5219d60b..ba9542ff 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4556,20 +4556,7 @@ enum filter_type {
 
 static int filter_command(struct tracefs_instance *instance, const char *cmd)
 {
-	char *path;
-	int ret;
-	int fd;
-
-	path = tracefs_instance_get_file(instance, "set_ftrace_filter");
-	if (!path)
-		return -1;
-	fd = open(path, O_WRONLY);
-	tracefs_put_tracing_file(path);
-	if (fd < 0)
-		return -1;
-	ret = write(fd, cmd, strlen(cmd));
-	close(fd);
-	return ret;
+	return tracefs_instance_file_append(instance, "set_ftrace_filter", cmd);
 }
 
 static int write_func_filter(enum filter_type type, struct buffer_instance *instance,
-- 
2.29.2

