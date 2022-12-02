Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B1DC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Dec 2022 17:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbiLBRjB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Dec 2022 12:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbiLBRjB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Dec 2022 12:39:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B81D827E
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Dec 2022 09:39:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAAB5B8218F
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Dec 2022 17:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F12C433D6
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Dec 2022 17:38:57 +0000 (UTC)
Date:   Fri, 2 Dec 2022 12:38:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Add kbuffer_create()
Message-ID: <20221202123854.5761a742@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The kbuffer_alloc() is awkward to use as the size and endianess needs to
be passed in by enum values. Add a kbuffer_create() that only takes a tep
handle, and it determines these values via the handle instead.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceevent/kbuffer.h |  1 +
 src/parse-utils.c            | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/traceevent/kbuffer.h b/include/traceevent/kbuffer.h
index a2b522093cfd..66b095833b81 100644
--- a/include/traceevent/kbuffer.h
+++ b/include/traceevent/kbuffer.h
@@ -29,6 +29,7 @@ enum {
 struct kbuffer;
 
 struct kbuffer *kbuffer_alloc(enum kbuffer_long_size size, enum kbuffer_endian endian);
+struct kbuffer *kbuffer_create(struct tep_handle *tep);
 void kbuffer_free(struct kbuffer *kbuf);
 int kbuffer_load_subbuffer(struct kbuffer *kbuf, void *subbuffer);
 void *kbuffer_read_event(struct kbuffer *kbuf, unsigned long long *ts);
diff --git a/src/parse-utils.c b/src/parse-utils.c
index 09059edf0159..ffa6c5871289 100644
--- a/src/parse-utils.c
+++ b/src/parse-utils.c
@@ -11,6 +11,7 @@
 
 #include "event-utils.h"
 #include "event-parse.h"
+#include "kbuffer.h"
 
 #define __weak __attribute__((weak))
 
@@ -122,3 +123,28 @@ void __weak __vpr_stat(const char *fmt, va_list ap)
 }
 
 void vpr_stat(const char *fmt, va_list ap) __attribute__((weak, alias("__vpr_stat")));
+
+/**
+ * kbuffer_create - create and allocate a new kbuffer
+ * @tep: the data to get the long size and endianess from
+ *
+ * Allocates and returns a new kbuffer.
+ */
+struct kbuffer *kbuffer_create(struct tep_handle *tep)
+{
+	enum kbuffer_endian endian;
+	int long_size;
+
+	long_size = tep_get_long_size(tep);
+	if (long_size == 8)
+		long_size = KBUFFER_LSIZE_8;
+	else
+		long_size = KBUFFER_LSIZE_4;
+
+	if (tep_is_file_bigendian(tep))
+		endian = KBUFFER_ENDIAN_BIG;
+	else
+		endian = KBUFFER_ENDIAN_LITTLE;
+
+	return kbuffer_alloc(long_size, endian);
+}
-- 
2.35.1

