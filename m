Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F161C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 18:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbiDQSsS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 17 Apr 2022 14:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbiDQSsR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 17 Apr 2022 14:48:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A301AD8B
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 11:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A20A260C8C
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 18:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B383C385AE;
        Sun, 17 Apr 2022 18:45:39 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ng9tz-004Nk0-36;
        Sun, 17 Apr 2022 14:45:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 5/9] trace-cmd library: Create tracecmd_debug() for debug printing
Date:   Sun, 17 Apr 2022 14:45:34 -0400
Message-Id: <20220417184538.1044417-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220417184538.1044417-1-rostedt@goodmis.org>
References: <20220417184538.1044417-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Move the dprint() of trace-msg.c into trace-utils.c and export it such
that other applications could use it as well. It is now renamed to
tracecmd_debug().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  3 +++
 lib/trace-cmd/trace-msg.c                         | 12 +-----------
 lib/trace-cmd/trace-util.c                        | 12 ++++++++++++
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 6e7b346cda07..766e0a762c2b 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -43,6 +43,9 @@ enum {
 	RINGBUF_TYPE_TIME_STAMP		= 31,
 };
 
+/* Can be overridden */
+void tracecmd_debug(const char *fmt, ...);
+
 void tracecmd_record_ref(struct tep_record *record);
 
 void tracecmd_set_debug(bool set_debug);
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 6cf74f9b1c99..39465ade8ab3 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -31,17 +31,7 @@
 typedef __u32 u32;
 typedef __be32 be32;
 
-static inline void dprint(const char *fmt, ...)
-{
-	va_list ap;
-
-	if (!tracecmd_get_debug())
-		return;
-
-	va_start(ap, fmt);
-	vprintf(fmt, ap);
-	va_end(ap);
-}
+#define dprint(fmt, ...)	tracecmd_debug(fmt, ##__VA_ARGS__)
 
 /* Two (4k) pages is the max transfer for now */
 #define MSG_MAX_LEN			8192
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index b5a0a1a601d4..9564c81a5c99 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -415,6 +415,18 @@ void __weak tracecmd_critical(const char *fmt, ...)
 	}
 }
 
+void __weak tracecmd_debug(const char *fmt, ...)
+{
+	va_list ap;
+
+	if (!tracecmd_get_debug())
+		return;
+
+	va_start(ap, fmt);
+	vprintf(fmt, ap);
+	va_end(ap);
+}
+
 #define LOG_BUF_SIZE 1024
 static void __plog(const char *prefix, const char *fmt, va_list ap, FILE *fp)
 {
-- 
2.35.1

