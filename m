Return-Path: <SRS0=o1/+=W2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E98C3A59B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Aug 2019 16:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBBFC2342F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Aug 2019 16:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfH3Q4L (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 30 Aug 2019 12:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbfH3Q4L (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Aug 2019 12:56:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F044F2342F
        for <linux-trace-devel@vger.kernel.org>; Fri, 30 Aug 2019 16:56:10 +0000 (UTC)
Date:   Fri, 30 Aug 2019 12:56:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Limit the size written into the pid mapname
Message-ID: <20190830125609.2397b21a@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Need to tell scanf() the size of the mapname so that we don't risk a buffer
overflow. As STRINGIFY() will make a string from the size, we can't use
"PATH_MAX + 22", but 4096 should be plenty big enough.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 8cceb31c..1db1bffa 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -20,6 +20,9 @@
 #include "kbuffer.h"
 #include "list.h"
 
+#define _STRINGIFY(x) #x
+#define STRINGIFY(x) _STRINGIFY(x)
+
 #define MISSING_EVENTS (1 << 31)
 #define MISSING_STORED (1 << 30)
 
@@ -2164,11 +2167,12 @@ static void procmap_free(struct pid_addr_maps *maps)
 	free(maps);
 }
 
-#define STR_PROCMAP_LINE_MAX	(PATH_MAX+22)
+/* Needs to be a constant, and 4K should be good enough */
+#define STR_PROCMAP_LINE_MAX	4096
 static int trace_pid_map_load(struct tracecmd_input *handle, char *buf)
 {
 	struct pid_addr_maps *maps = NULL;
-	char mapname[STR_PROCMAP_LINE_MAX];
+	char mapname[STR_PROCMAP_LINE_MAX+1];
 	char *line;
 	int res;
 	int ret;
@@ -2187,7 +2191,7 @@ static int trace_pid_map_load(struct tracecmd_input *handle, char *buf)
 	if (strlen(buf) > STR_PROCMAP_LINE_MAX)
 		goto out_fail;
 
-	res = sscanf(buf, "%x %x %s", &maps->pid, &maps->nr_lib_maps, mapname);
+	res = sscanf(buf, "%x %x %"STRINGIFY(STR_PROCMAP_LINE_MAX)"s", &maps->pid, &maps->nr_lib_maps, mapname);
 	if (res != 3)
 		goto out_fail;
 
-- 
2.20.1

