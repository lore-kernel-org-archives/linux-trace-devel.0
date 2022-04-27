Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB11C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Apr 2022 22:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiD0W0l (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Apr 2022 18:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbiD0W0k (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Apr 2022 18:26:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142042DAA9
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Apr 2022 15:23:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9909961E13
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Apr 2022 22:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5317AC385A7;
        Wed, 27 Apr 2022 22:23:26 +0000 (UTC)
Date:   Wed, 27 Apr 2022 18:23:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH] kbuffer: Handle 64 bit timestamp event
Message-ID: <20220427182324.6a7b7e91@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

With the new TAI clock, the clock source can use all 64 bits for the time
stamp. The TIME_STAMP event only saves 59 bits of the clock, it is
expected that the 5 MSBs will be extracted from the buffer page 64 bit
timestamp.

Link: https://lore.kernel.org/all/20220427153339.16c33f75@gandalf.local.home/

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/kbuffer-parse.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
index 74999501f5bf..d174e7276df2 100644
--- a/src/kbuffer-parse.c
+++ b/src/kbuffer-parse.c
@@ -14,6 +14,9 @@
 
 #define COMMIT_MASK ((1 << 27) - 1)
 
+/* Absolute time stamps do not have the 5 MSB, take from the real time stamp */
+#define TS_MSB		(0xf8ULL << 56)
+
 enum {
 	KBUFFER_FL_HOST_BIG_ENDIAN	= (1<<0),
 	KBUFFER_FL_BIG_ENDIAN		= (1<<1),
@@ -347,7 +350,7 @@ static unsigned int
 translate_data(struct kbuffer *kbuf, void *data, void **rptr,
 	       unsigned long long *delta, int *length)
 {
-	unsigned long long extend;
+	unsigned long long extend, msb = 0;
 	unsigned int type_len_ts;
 	unsigned int type_len;
 
@@ -362,13 +365,15 @@ translate_data(struct kbuffer *kbuf, void *data, void **rptr,
 		*length = read_4(kbuf, data);
 		break;
 
-	case KBUFFER_TYPE_TIME_EXTEND:
 	case KBUFFER_TYPE_TIME_STAMP:
+		msb = kbuf->timestamp & TS_MSB;
+		/* fall through */
+	case KBUFFER_TYPE_TIME_EXTEND:
 		extend = read_4(kbuf, data);
 		data += 4;
 		extend <<= TS_SHIFT;
 		extend += *delta;
-		*delta = extend;
+		*delta = extend | msb;
 		*length = 0;
 		break;
 
-- 
2.35.1

