Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7155CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  7 Mar 2022 02:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbiCGChY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 6 Mar 2022 21:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbiCGChX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 6 Mar 2022 21:37:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F495D5D5
        for <linux-trace-devel@vger.kernel.org>; Sun,  6 Mar 2022 18:36:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1845261178
        for <linux-trace-devel@vger.kernel.org>; Mon,  7 Mar 2022 02:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22167C340EC;
        Mon,  7 Mar 2022 02:36:28 +0000 (UTC)
Date:   Sun, 6 Mar 2022 21:36:26 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] libtracecmd: Do not set errno to zero
Message-ID: <20220306213626.39b45180@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Libraries may set errno when an error happens, but it is in bad form to
clear errno on success.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-compress-zstd.c | 1 -
 lib/trace-cmd/trace-util.c          | 8 ++++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/trace-cmd/trace-compress-zstd.c b/lib/trace-cmd/trace-compress-zstd.c
index 3e42fc794502..10ae7a4c03c0 100644
--- a/lib/trace-cmd/trace-compress-zstd.c
+++ b/lib/trace-cmd/trace-compress-zstd.c
@@ -46,7 +46,6 @@ static int zstd_decompress(void *ctx, const void *in, int in_bytes, void *out, i
 		return -1;
 	}
 
-	errno = 0;
 	return ret;
 }
 
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 91e8a30fb90b..b5a0a1a601d4 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -131,6 +131,7 @@ void tracecmd_parse_proc_kallsyms(struct tep_handle *pevent,
 			 char *file, unsigned int size __maybe_unused)
 {
 	unsigned long long addr;
+	int sav_errno;
 	char *func;
 	char *line;
 	char *next = NULL;
@@ -144,13 +145,13 @@ void tracecmd_parse_proc_kallsyms(struct tep_handle *pevent,
 		int n;
 
 		mod = NULL;
+		sav_errno = errno;
 		errno = 0;
 		n = sscanf(line, "%16llx %c %n%*s%n%*1[\t][%n%*s%n",
 			   &addr, &ch, &func_start, &func_end, &mod_start, &mod_end);
-		if (errno) {
-			perror("sscanf");
+		if (errno)
 			return;
-		}
+		errno = sav_errno;
 
 		if (n != 2 || !func_end)
 			return;
@@ -521,7 +522,6 @@ int tracecmd_stack_tracer_status(int *status)
 
 	buf[n] = 0;
 
-	errno = 0;
 	num = strtol(buf, NULL, 10);
 
 	/* Check for various possible errors */
-- 
2.34.1

