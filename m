Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACCCC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Dec 2022 21:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiLHVgv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 16:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLHVgu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 16:36:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644959B28B
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Dec 2022 13:36:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE3A7B82440
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Dec 2022 21:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F74BC433D2
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Dec 2022 21:36:46 +0000 (UTC)
Date:   Thu, 8 Dec 2022 16:36:44 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2] libtraceevent kbuffer: Add SAME_AS_HOST for endian and
 size
Message-ID: <20221208163644.185bf199@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a SAME_AS_HOST to the endian and size parameters of kbuffer_alloc()
that makes it easier for the applications that simply read the ring
buffer.

If the host has 4 byte word, it will call uname() and check the machine
value. If machine contains the string "64", it will assume that the kernel
is 64 bit and that is what the host will be considered.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1 https://lore.kernel.org/all/20221208152422.2d0a62cc@gandalf.local.home/
 - Accidentally deleted the "break" statement. Add it back.

 include/traceevent/kbuffer.h |  2 ++
 src/kbuffer-parse.c          | 31 ++++++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/traceevent/kbuffer.h b/include/traceevent/kbuffer.h
index c8983a000585..abfd83e6fe9f 100644
--- a/include/traceevent/kbuffer.h
+++ b/include/traceevent/kbuffer.h
@@ -13,11 +13,13 @@
 enum kbuffer_endian {
 	KBUFFER_ENDIAN_BIG,
 	KBUFFER_ENDIAN_LITTLE,
+	KBUFFER_ENDIAN_SAME_AS_HOST,
 };
 
 enum kbuffer_long_size {
 	KBUFFER_LSIZE_4,
 	KBUFFER_LSIZE_8,
+	KBUFFER_LSIZE_SAME_AS_HOST,
 };
 
 enum {
diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
index d174e7276df2..390a789b20fb 100644
--- a/src/kbuffer-parse.c
+++ b/src/kbuffer-parse.c
@@ -6,6 +6,9 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <stdbool.h>
+
+#include <sys/utsname.h>
 
 #include "kbuffer.h"
 
@@ -159,6 +162,24 @@ static int calc_index(struct kbuffer *kbuf, void *ptr)
 
 static int __next_event(struct kbuffer *kbuf);
 
+/*
+ * Just because sizeof(long) is 4 bytes, doesn't mean the OS isn't
+ * 64bits
+ */
+static bool host_is_32bit(void)
+{
+	struct utsname buf;
+	int ret;
+
+	ret = uname(&buf);
+	if (ret < 0) {
+		/* Oh well, just assume it is 32 bit */
+		return true;
+	}
+	/* If the uname machine value contains 64, assume the kernel is 64 bit */
+	return strstr(buf.machine, "64") == NULL;
+}
+
 /**
  * kbuffer_alloc - allocat a new kbuffer
  * @size;	enum to denote size of word
@@ -175,6 +196,10 @@ kbuffer_alloc(enum kbuffer_long_size size, enum kbuffer_endian endian)
 	switch (size) {
 	case KBUFFER_LSIZE_4:
 		break;
+	case KBUFFER_LSIZE_SAME_AS_HOST:
+		if (sizeof(long) != 8 && host_is_32bit())
+			break;
+		/* fallthrough */
 	case KBUFFER_LSIZE_8:
 		flags |= KBUFFER_FL_LONG_8;
 		break;
@@ -184,6 +209,7 @@ kbuffer_alloc(enum kbuffer_long_size size, enum kbuffer_endian endian)
 
 	switch (endian) {
 	case KBUFFER_ENDIAN_LITTLE:
+	case KBUFFER_ENDIAN_SAME_AS_HOST:
 		break;
 	case KBUFFER_ENDIAN_BIG:
 		flags |= KBUFFER_FL_BIG_ENDIAN;
@@ -198,8 +224,11 @@ kbuffer_alloc(enum kbuffer_long_size size, enum kbuffer_endian endian)
 
 	kbuf->flags = flags;
 
-	if (host_is_bigendian())
+	if (host_is_bigendian()) {
+		if (endian == KBUFFER_ENDIAN_SAME_AS_HOST)
+			flags |= KBUFFER_FL_BIG_ENDIAN;
 		kbuf->flags |= KBUFFER_FL_HOST_BIG_ENDIAN;
+	}
 
 	if (do_swap(kbuf)) {
 		kbuf->read_8 = __read_8_sw;
-- 
2.35.1

