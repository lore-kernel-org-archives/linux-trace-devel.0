Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68836C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 09:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C1AE613A4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 09:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240391AbhDEJV6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 05:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbhDEJVK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 05:21:10 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793A1C061756
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 02:21:04 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id x7so10375800wrw.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 02:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D7vxoi0Ttn6HcdOmXy5xf3r0HKXCQ4PxwIGo01sOMXc=;
        b=JTZHZdWUuKhPDCqWAGItC/a1L7vHaw5969XBPKnzKimnJGgbL3NwhHVAZDejUGtbja
         y+ueyewvvH2e/4y4VqlLtlbG3nHtbLoiBh+f3OQ+7F5MRZeV2dYTEa5HhD+G3jM0alXO
         q/RH5l0+B229wjiKVKdOxMOMi748rWF/J7QirQLtweTgcccLhZ/9E8vEGZVw9OO1s//r
         7Hqj+UkL7cq/XjiBJYKnCEJ39wbR7+0Nb8Zf8fFBTiqJisL2VPgrqS7OHsvn0yMufQ1m
         bP642qEUisFRJP+qaxzm0HsddckeRKV0IM6MxXpCPpCKZo3iHjds9qFZHSCmYM/rp5Ju
         KDsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D7vxoi0Ttn6HcdOmXy5xf3r0HKXCQ4PxwIGo01sOMXc=;
        b=WNXQHbJo64YcAGMmAkESz2mlewHrRJxw9jTimQpBwMV+8sSat02g1Iudsoy+Syk+Rp
         pJBRLVcIsiQKKx0uPyoRl1laWXNDzLcJm1EP2qc84bEBylwEHoNaOuNIe6SGf4gsdAGe
         miDEfmBv9BemUCqXyjTmxT8uFgNEgFxEr5+gyjbyP0zMLfQWcQcPrzCpaKI3/CCACCfR
         2Y8BgLSQO9/+WAZwos74+zaBZepslLQ3jD1YENPZOemeywid0cb0ccMZMqZocUd9VZGd
         8STQHyqiY+4gLLZVzu2Bv4j+MDWT8e6xC1tA8YEzPhv32UJVi/1NnB9J72deBfHxyikp
         L1nA==
X-Gm-Message-State: AOAM531t5SdoFQQlv1kxOsc3SCUOlX9n8y6sV7a6MLEMz0XOC4DBJMMd
        MQDW5/f1mnJnPnyzWh+Z6cKU9JX2LhZoPA==
X-Google-Smtp-Source: ABdhPJz38xOkvmeA0VP1wXniXfxLy/B++6dT8jHlz+2MMAxv2cbMRCyvj2XBdGDx5n4+34F8MtAqrQ==
X-Received: by 2002:a5d:428f:: with SMTP id k15mr10960676wrq.276.1617614463285;
        Mon, 05 Apr 2021 02:21:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h62sm26990025wmf.37.2021.04.05.02.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 02:21:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4] trace-cmd: Remove all die()s from trace-cmd library
Date:   Mon,  5 Apr 2021 12:21:00 +0300
Message-Id: <20210405092100.869572-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The die() call is used for a fatal error. It terminates the current
program with exit(). The program should not be terminated from a library
routine, the die() call should not be used in the trace-cmd library
context.

But as all these logs indicate a fatal error in the library, it is
useful to have them. The die() call is replaced with tracecmd_lib_fatal()
library function, which prints the error message. By default,
the application is not terminated when a fatal error is encountered in
the library. If the library runs in debug mode, the _lib_fatal() call
behaves like die() - calls exit() to terminate the application.
The library debug mode can be switched using tracecmd_set_debug() API.

The tracecmd_lib_fatal() function is defined as weak and can be
overridden by the application.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
v4 changes:
 - Renamed _lib_fatal() to tracecmd_lib_fatal() and implemented it as a weak
   function.
v3 changes:
 - If the library runs in debug mode, call exit() in _lib_fatal().  
v2 changes:
 - Replaced die() with _lib_fatal().

 lib/trace-cmd/include/trace-cmd-local.h |  1 +
 lib/trace-cmd/trace-input.c             | 29 +++++++++++------
 lib/trace-cmd/trace-util.c              | 41 +++++++++----------------
 3 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 0cd27441..376aff11 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -11,6 +11,7 @@
 
 /* Can be overridden */
 void warning(const char *fmt, ...);
+void tracecmd_lib_fatal(const char *fmt, ...);
 
 /* trace.dat file format version */
 #define FILE_VERSION 6
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 2f7ba5db..7b25e92c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -16,6 +16,7 @@
 #include <linux/time64.h>
 
 #include "trace-write-local.h"
+#include "trace-cmd-local.h"
 #include "trace-local.h"
 #include "kbuffer.h"
 #include "list.h"
@@ -1102,8 +1103,10 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
 	struct page **pages;
 	int index;
 
-	if (!page->ref_count)
-		die("Page ref count is zero!\n");
+	if (!page->ref_count) {
+		tracecmd_lib_fatal("Page ref count is zero!\n");
+		return;
+	}
 
 	page->ref_count--;
 	if (page->ref_count)
@@ -1161,16 +1164,20 @@ void tracecmd_free_record(struct tep_record *record)
 	if (!record)
 		return;
 
-	if (!record->ref_count)
-		die("record ref count is zero!");
+	if (!record->ref_count) {
+		tracecmd_lib_fatal("record ref count is zero!");
+		return;
+	}
 
 	record->ref_count--;
 
 	if (record->ref_count)
 		return;
 
-	if (record->locked)
-		die("freeing record when it is locked!");
+	if (record->locked) {
+		tracecmd_lib_fatal("freeing record when it is locked!");
+		return;
+	}
 
 	record->data = NULL;
 
@@ -1370,7 +1377,7 @@ static int get_page(struct tracecmd_input *handle, int cpu,
 
 	if (offset & (handle->page_size - 1)) {
 		errno = -EINVAL;
-		die("bad page offset %llx", offset);
+		tracecmd_lib_fatal("bad page offset %llx", offset);
 		return -1;
 	}
 
@@ -1378,7 +1385,7 @@ static int get_page(struct tracecmd_input *handle, int cpu,
 	    offset > handle->cpu_data[cpu].file_offset +
 	    handle->cpu_data[cpu].file_size) {
 		errno = -EINVAL;
-		die("bad page offset %llx", offset);
+		tracecmd_lib_fatal("bad page offset %llx", offset);
 		return -1;
 	}
 
@@ -1943,8 +1950,10 @@ tracecmd_peek_data(struct tracecmd_input *handle, int cpu)
 	if (handle->cpu_data[cpu].next) {
 
 		record = handle->cpu_data[cpu].next;
-		if (!record->data)
-			die("Something freed the record");
+		if (!record->data) {
+			tracecmd_lib_fatal("Something freed the record");
+			return NULL;
+		}
 
 		if (handle->cpu_data[cpu].timestamp == record->ts)
 			return record;
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 9e37b371..db7bead6 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -353,48 +353,35 @@ trace_load_plugins(struct tep_handle *tep, int flags)
 	return list;
 }
 
-void __noreturn __vdie(const char *fmt, va_list ap)
+static int __vlib_warning(const char *fmt, va_list ap)
 {
 	int ret = errno;
 
 	if (errno)
-		perror("trace-cmd");
-	else
-		ret = -1;
+		perror("libtracecmd");
 
 	fprintf(stderr, "  ");
 	vfprintf(stderr, fmt, ap);
 
 	fprintf(stderr, "\n");
-	exit(ret);
-}
 
-void __noreturn __die(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	__vdie(fmt, ap);
-	va_end(ap);
+	return ret;
 }
 
-void __weak __noreturn die(const char *fmt, ...)
+void __weak tracecmd_lib_fatal(const char *fmt, ...)
 {
+	int ret;
 	va_list ap;
 
 	va_start(ap, fmt);
-	__vdie(fmt, ap);
+	ret = __vlib_warning(fmt, ap);
 	va_end(ap);
-}
-
-void __weak *malloc_or_die(unsigned int size)
-{
-	void *data;
 
-	data = malloc(size);
-	if (!data)
-		die("malloc");
-	return data;
+	if (debug) {
+		if (!ret)
+			ret = -1;
+		exit(ret);
+	}
 }
 
 #define LOG_BUF_SIZE 1024
@@ -546,8 +533,10 @@ int tracecmd_count_cpus(void)
 	pbuf = buf;
 
 	fp = fopen("/proc/cpuinfo", "r");
-	if (!fp)
-		die("Can not read cpuinfo");
+	if (!fp) {
+		tracecmd_lib_fatal("Can not read cpuinfo");
+		return 0;
+	}
 
 	while ((r = getline(&pbuf, pn, fp)) >= 0) {
 		char *p;
-- 
2.30.2

