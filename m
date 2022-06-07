Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E4BC43334
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jun 2022 01:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359558AbiFHBSQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jun 2022 21:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837382AbiFGX75 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jun 2022 19:59:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4B7C1A
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Jun 2022 15:31:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E40B2B82459
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Jun 2022 22:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59044C3411E
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Jun 2022 22:31:44 +0000 (UTC)
Date:   Tue, 7 Jun 2022 18:31:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd stat: Show all filter functions that are enabled
Message-ID: <20220607183142.00dac63f@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The way the files are printed in trace-cmd stat uses a read loop and keeps
allocating memory to read the content. It reads at BUFSIZ increments. But
if a read does not read exactly BUFSIZ it stops reading and returns what
it read but may not return the rest.

This does not work with the filter functions as the read may not fill the
buffer (it does not return an unfinished function). This makes the loop
exit early.

Instead just increase with BUFSIZ against what was allocated and comparing
to the total.

The way to trigger the issue is by:

   # trace-cmd start -p nop -l "*"
   # trace-cmd show --ftrace_filter |wc -l
 50979
   # trace-cmd stat | wc -l
 234

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=212489
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-stat.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index a5fb777b32b8..4c3dc6494922 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -71,21 +71,24 @@ char *append_file(const char *dir, const char *name)
 
 static char *get_fd_content(int fd, const char *file)
 {
+	size_t total = 0;
+	size_t alloc;
 	char *str = NULL;
-	int cnt = 0;
 	int ret;
 
 	for (;;) {
-		str = realloc(str, BUFSIZ * ++cnt);
+		alloc = ((total + BUFSIZ) / BUFSIZ) * BUFSIZ;
+		str = realloc(str, alloc + 1);
 		if (!str)
 			die("malloc");
-		ret = read(fd, str + BUFSIZ * (cnt - 1), BUFSIZ);
+		ret = read(fd, str + total, alloc - total);
 		if (ret < 0)
 			die("reading %s\n", file);
-		if (ret < BUFSIZ)
+		total += ret;
+		if (!ret)
 			break;
 	}
-	str[BUFSIZ * (cnt-1) + ret] = 0;
+	str[total] = 0;
 
 	return str;
 }
-- 
2.35.1

