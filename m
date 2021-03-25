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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDEFC433C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 08:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E01F4619FC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 08:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhCYIjz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 04:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhCYIjg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 04:39:36 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014B0C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 01:39:36 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id g25so699272wmh.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 01:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cmpl/V2R0S9FGk6cwFAUDPt0YtmvFBLBCusp3+15Tn0=;
        b=sKbRwfaej7PK/8d7l83H3fHt9KizUoDrknlx0d3YySQK1izGtd3otcfYtL84hExyXi
         u0qw5hP/mnbZZoR8pGNK3pyIs6Fg6jlzLxGFwYr/HxS9NfntWK5k5C1d+eI4F48l7byV
         rzvUehTU9oMlFHCSWDcFRnVG0vT9L6EWNUFl6mJXHBDYqzKprbAKUY/X25cWG+it5D/o
         jwQe7by6ehV7Ajyn4/gjCAFBeuGC7c4LhRWIT6V0Sni7Sq43eQTsOjGk7E7duGMZKB8q
         x7syWRC9z/NVtSqaOZU61ChNGeil0VsQN8h/MeT6xijIivLf3RrlEkdufVy19eDW+Ayh
         FqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cmpl/V2R0S9FGk6cwFAUDPt0YtmvFBLBCusp3+15Tn0=;
        b=KVSMXY3vS2kLeIldxe9sTP16bxCP7rV1vNWK72sc+LJedttt0900qu70yvQm1M4b90
         meK/VG/gn/9BXTPS4Q13KMsaAU8Or5gEavD3GiHTm1/ojDci3+AuYCxiA3ObEOIbSmqk
         AkhqJgLHgnEcllWH/VJX0oE3BGYaa0I9H2iDLwNTfmcVzhv2sIt4+ICxrn3gmRGL04lp
         GyV0TEQ5bfVn9A4IqkT/AqqJRD6jlFllh2FQrClET8ditnP6nzeMAKpcEkzHzYkezZtH
         gBzVi3ROdOUmEZs1mg9wHZaDtM8MyrlssQEgCmOuuQPYND3/zygN8eqAFg0D6lM+QxiB
         CgsQ==
X-Gm-Message-State: AOAM5308A2Rns9/hTqzlKuU6hoKc3RCRQ/r4NsfA07W+TFoDSFOtfNo+
        2QExcAerAnfPjuGfQhDTq40=
X-Google-Smtp-Source: ABdhPJykmLNr8v3d1PP9d7RvTdBupFz2RZrUHGjlGON3pgSMbmrj5DuTTmxzL6CZ2R7TdvrrE+uk5w==
X-Received: by 2002:a1c:e4d4:: with SMTP id b203mr6399660wmh.105.1616661574230;
        Thu, 25 Mar 2021 01:39:34 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u23sm5682321wmn.26.2021.03.25.01.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 01:39:33 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3] trace-cmd: Remove all die()s from trace-cmd library
Date:   Thu, 25 Mar 2021 10:39:32 +0200
Message-Id: <20210325083932.553120-1-tz.stoyanov@gmail.com>
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
library internal function, which prints the error message. By default,
the application is not terminated when a fatal error is encountered in
the library. If the library runs in debug mode, the _lib_fatal() call
behaves like die() - calls exit() to terminate the application.
The library debug mode can be switched using tracecmd_set_debug() API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
v3 changes:
 - If the library runs in debug mode, call exit() in _lib_fatal().  
v2 changes:
 - Replaced die() with _lib_fatal().

 lib/trace-cmd/include/trace-cmd-local.h |  2 ++
 lib/trace-cmd/trace-input.c             | 29 +++++++++++++-------
 lib/trace-cmd/trace-util.c              | 35 +++++++------------------
 3 files changed, 31 insertions(+), 35 deletions(-)

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
index 538adbc2..cb397452 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -353,12 +353,12 @@ trace_load_plugins(struct tep_handle *tep, int flags)
 	return list;
 }
 
-void __noreturn __vdie(const char *fmt, va_list ap)
+void __vlib_fatal(const char *fmt, va_list ap)
 {
 	int ret = errno;
 
 	if (errno)
-		perror("trace-cmd");
+		perror("libtracecmd");
 	else
 		ret = -1;
 
@@ -366,37 +366,20 @@ void __noreturn __vdie(const char *fmt, va_list ap)
 	vfprintf(stderr, fmt, ap);
 
 	fprintf(stderr, "\n");
-	exit(ret);
-}
-
-void __noreturn __die(const char *fmt, ...)
-{
-	va_list ap;
 
-	va_start(ap, fmt);
-	__vdie(fmt, ap);
-	va_end(ap);
+	if (debug)
+		exit(ret);
 }
 
-void __weak __noreturn die(const char *fmt, ...)
+void _lib_fatal(const char *fmt, ...)
 {
 	va_list ap;
 
 	va_start(ap, fmt);
-	__vdie(fmt, ap);
+	__vlib_fatal(fmt, ap);
 	va_end(ap);
 }
 
-void __weak *malloc_or_die(unsigned int size)
-{
-	void *data;
-
-	data = malloc(size);
-	if (!data)
-		die("malloc");
-	return data;
-}
-
 #define LOG_BUF_SIZE 1024
 static void __plog(const char *prefix, const char *fmt, va_list ap, FILE *fp)
 {
@@ -546,8 +529,10 @@ int tracecmd_count_cpus(void)
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

