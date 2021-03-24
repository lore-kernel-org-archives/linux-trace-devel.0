Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB0AC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DACD661A01
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235430AbhCXNwR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234934AbhCXNvt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:51:49 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72509C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:51:48 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so1236559wmj.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vtlCmafP3Au3z4KckhMoDqnQiZzVkSAeApx2mwCJ718=;
        b=J2VW9NbDJ3Jo0+H5TuXmxJ+rJ8kS7+pcFazX8LnkZ1zXPV5zBOhmERXpKYFWqBqrm/
         djae6rZ0NkckjHPZSMTLUhLkqrTdQFy72nTx48MyUcc1kA89Vqjnu0A+TK/kUOkH20CU
         PEupxmQh2BD3P8eCZnnVytNSSD8H7sUPhTSAOjVXbWjJ6M1TBtHEj+dkrg7YWjUBokOv
         GSWIP6d0F8h1CdqIaKOaJOb9nyMKtF9FbKHZ1I9PqvMNhIQUaOcITHx+ceBu8zFmb3Cl
         xrBYZhy14AJaDS2M/6vAZikVK/INmaXeuISV5j1xecF5fCOfn6xuTkTm37SHwmFd5Ts1
         /z6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vtlCmafP3Au3z4KckhMoDqnQiZzVkSAeApx2mwCJ718=;
        b=fMkUqc7f3uTNV1oAGX7k+z0aCzrAHCXEcIJi3f7x7SyuD+nJUSUorVQlU5jCtLuPBh
         XWy7eM2hHBCEA1AvjZbmVjK3BqlSS+WEUQ99Yg+TM8sdHT9pzpuwPbfVnPJ+RAoj1UAp
         PqxUbQ549Uj76ARVBw19drABE01Hr+6aYstl09hhkAz3EXIrp3XaJlrxUX4KYVzZ6hLV
         tXwvybGGW2d2w+ga+MCS9foV9T/65FpGO72eATq/2NxGof3MMQHuDYbkQEIJLyNxvv0E
         titsRUEw79Ng3JjlO8NQFbUsoWE/9O9VDyh/gYbEucgpBJE/1WcjgzBO2zF9YBIldk5V
         soAQ==
X-Gm-Message-State: AOAM530VAj+mBy9rfvwVX+vbHdBkkcwG1fSGKu3p3sSZ/E8svNL2Yuci
        Lfn7HeMywnsu9SYS8j6UVyarWh4NKNOZWw==
X-Google-Smtp-Source: ABdhPJzuS2enY/vvXtDobavc+cMevVr+6cLv0i8RBJiaHIgaC1f6tgNgomEdC78p29DkqvAVjzgO4w==
X-Received: by 2002:a7b:c2fa:: with SMTP id e26mr3024923wmk.102.1616593907116;
        Wed, 24 Mar 2021 06:51:47 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b65sm2544879wmh.4.2021.03.24.06.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:51:46 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] trace-cmd: Remove all die()s from trace-cmd library
Date:   Wed, 24 Mar 2021 15:51:43 +0200
Message-Id: <20210324135143.445443-1-tz.stoyanov@gmail.com>
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
useful to have them. The die() call is replaced with _lib_fatal()
library internal function, which prints the error message without
terminating the application. If the library is compiled with
  LIB_DIE
defined, the _lib_fatal() call behaves like die() - calls exit() to
terminate the application.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
v2 changes:
 - Replaced die() with _lib_fatal().

 lib/trace-cmd/include/trace-cmd-local.h |  2 ++
 lib/trace-cmd/trace-input.c             | 29 +++++++++++++-------
 lib/trace-cmd/trace-util.c              | 36 ++++++++++++-------------
 3 files changed, 38 insertions(+), 29 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index d265e4c8..da9d8d58 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -12,6 +12,8 @@
 /* Can be overridden */
 void warning(const char *fmt, ...);
 
+void _lib_fatal(const char *fmt, ...);
+
 #define __packed __attribute__((packed))
 
 /* trace.dat file format version */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 2093a3dc..3687de09 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -16,6 +16,7 @@
 #include <linux/time64.h>
 
 #include "trace-write-local.h"
+#include "trace-cmd-local.h"
 #include "trace-local.h"
 #include "kbuffer.h"
 #include "list.h"
@@ -1087,8 +1088,10 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
 	struct page **pages;
 	int index;
 
-	if (!page->ref_count)
-		die("Page ref count is zero!\n");
+	if (!page->ref_count) {
+		_lib_fatal("Page ref count is zero!\n");
+		return;
+	}
 
 	page->ref_count--;
 	if (page->ref_count)
@@ -1146,16 +1149,20 @@ void tracecmd_free_record(struct tep_record *record)
 	if (!record)
 		return;
 
-	if (!record->ref_count)
-		die("record ref count is zero!");
+	if (!record->ref_count) {
+		_lib_fatal("record ref count is zero!");
+		return;
+	}
 
 	record->ref_count--;
 
 	if (record->ref_count)
 		return;
 
-	if (record->locked)
-		die("freeing record when it is locked!");
+	if (record->locked) {
+		_lib_fatal("freeing record when it is locked!");
+		return;
+	}
 
 	record->data = NULL;
 
@@ -1318,7 +1325,7 @@ static int get_page(struct tracecmd_input *handle, int cpu,
 
 	if (offset & (handle->page_size - 1)) {
 		errno = -EINVAL;
-		die("bad page offset %llx", offset);
+		_lib_fatal("bad page offset %llx", offset);
 		return -1;
 	}
 
@@ -1326,7 +1333,7 @@ static int get_page(struct tracecmd_input *handle, int cpu,
 	    offset > handle->cpu_data[cpu].file_offset +
 	    handle->cpu_data[cpu].file_size) {
 		errno = -EINVAL;
-		die("bad page offset %llx", offset);
+		_lib_fatal("bad page offset %llx", offset);
 		return -1;
 	}
 
@@ -1891,8 +1898,10 @@ tracecmd_peek_data(struct tracecmd_input *handle, int cpu)
 	if (handle->cpu_data[cpu].next) {
 
 		record = handle->cpu_data[cpu].next;
-		if (!record->data)
-			die("Something freed the record");
+		if (!record->data) {
+			_lib_fatal("Something freed the record");
+			return NULL;
+		}
 
 		if (handle->cpu_data[cpu].timestamp == record->ts)
 			return record;
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 538adbc2..e8ed22fa 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -353,12 +353,12 @@ trace_load_plugins(struct tep_handle *tep, int flags)
 	return list;
 }
 
-void __noreturn __vdie(const char *fmt, va_list ap)
+int __vlib_fatal(const char *fmt, va_list ap)
 {
 	int ret = errno;
 
 	if (errno)
-		perror("trace-cmd");
+		perror("libtracecmd");
 	else
 		ret = -1;
 
@@ -366,36 +366,32 @@ void __noreturn __vdie(const char *fmt, va_list ap)
 	vfprintf(stderr, fmt, ap);
 
 	fprintf(stderr, "\n");
-	exit(ret);
+	return ret;
 }
 
-void __noreturn __die(const char *fmt, ...)
+#ifdef LIB_DIE
+
+void __noreturn _lib_fatal(const char *fmt, ...)
 {
 	va_list ap;
+	int ret;
 
 	va_start(ap, fmt);
-	__vdie(fmt, ap);
+	ret = __vlib_fatal(fmt, ap);
 	va_end(ap);
+	exit(ret);
 }
 
-void __weak __noreturn die(const char *fmt, ...)
+#else
+void _lib_fatal(const char *fmt, ...)
 {
 	va_list ap;
 
 	va_start(ap, fmt);
-	__vdie(fmt, ap);
+	__vlib_fatal(fmt, ap);
 	va_end(ap);
 }
-
-void __weak *malloc_or_die(unsigned int size)
-{
-	void *data;
-
-	data = malloc(size);
-	if (!data)
-		die("malloc");
-	return data;
-}
+#endif
 
 #define LOG_BUF_SIZE 1024
 static void __plog(const char *prefix, const char *fmt, va_list ap, FILE *fp)
@@ -546,8 +542,10 @@ int tracecmd_count_cpus(void)
 	pbuf = buf;
 
 	fp = fopen("/proc/cpuinfo", "r");
-	if (!fp)
-		die("Can not read cpuinfo");
+	if (!fp) {
+		_lib_fatal("Can not read cpuinfo");
+		return 0;
+	}
 
 	while ((r = getline(&pbuf, pn, fp)) >= 0) {
 		char *p;
-- 
2.30.2

