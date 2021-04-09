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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2DB9C43461
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 05:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86B9A61185
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 05:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhDIFJZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 01:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbhDIFIl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 01:08:41 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3373C061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 22:08:23 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a25so6677171ejk.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 22:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SCWC7YroSTpj14YrvIJHbgI7/yclZGUri7mmp64Psn0=;
        b=kCe52jD8MxBmJjKOTPDqaHMb6DR9aaxm+jaiMjklodVTVA61zMzRWBPTIjVwieElBi
         0Onbe9lUQQGJ0nqS/suS72s681JJi7obZ9kwvPYnZJ2Pj02DPHQ5epQ+nPHykCKKXmTH
         2tRo3twUwOjkoJEKpCYgKAdNMQ/+cnMqGwRPEb5XNCoC80lPyhVSEJRDEQOHRe5IdlXl
         7Az+XAnj2gCUo3wPg4s7+RCoM6jl2Z3BgKS+4jsXiqUqf1+DYJiiEF/GvQIdZ8oPTPZF
         6SOr4+OsmuCh3OJIxDpu10Zb5rI/IU6jb8fIAXEaZjUGaeRtD5PhVPc0d+y6WiS/JU4T
         U89A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SCWC7YroSTpj14YrvIJHbgI7/yclZGUri7mmp64Psn0=;
        b=nPqvvHFQczTabco+QqRcOZTa+UlQ//799V7625dpqvGwfFshpwI4t7UnVz0VuSIhwN
         bD+WZgPlttaykQ62ifIb/jrTJumcYzW15RANw63n8P/MhAkcqdPutmY+QZMezkr/Y1Z/
         21Jr1tLhDh8iGUahXYJREjxdLDRCgaS3S1zHrk4lyRCuqdchDt6ZNuPrFgfKuo9WwMZA
         IESL6+gSD0MdkTJTnRgFyRzszfWjRxG420v9u4Sc2yK+FPmmnJQ4joL4uhWr+hmlhtob
         8hTOXV6ZWXaoWAEICOrrMYyLMf0ok4ANbfP7DcFAfG3REekw6zdm+uSYLW/uo08uJ4wx
         ceWw==
X-Gm-Message-State: AOAM533XNsCe/3LzNvpJjq7Ld8p7hnMMD5qe5SwbLEd8tYs+KxNBSoeK
        7cwBc2Ga/qH4vycSs9YEupgx4qYceSBykw==
X-Google-Smtp-Source: ABdhPJyiXVAcigISlJbvI/zesR60glwlxggSrYUtME5ISrjAlvFjw/SowF+rTyeLXDKVNSwa6Dw2jw==
X-Received: by 2002:a17:906:1784:: with SMTP id t4mr12038172eje.167.1617944902550;
        Thu, 08 Apr 2021 22:08:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q25sm734922edt.51.2021.04.08.22.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 22:08:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Renamed tracecmd_lib_fatal() to tracecmd_fatal()
Date:   Fri,  9 Apr 2021 08:08:20 +0300
Message-Id: <20210409050820.3185347-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

To be consistent with the prefix, used by the trace-cmd library, the
functon for printing fatal library error is renamed from
tracecmd_lib_fatal() to tracecmd_fatal().

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  2 +-
 lib/trace-cmd/trace-input.c             | 12 ++++++------
 lib/trace-cmd/trace-util.c              |  4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 376aff11..21515288 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -11,7 +11,7 @@
 
 /* Can be overridden */
 void warning(const char *fmt, ...);
-void tracecmd_lib_fatal(const char *fmt, ...);
+void tracecmd_fatal(const char *fmt, ...);
 
 /* trace.dat file format version */
 #define FILE_VERSION 6
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 7b25e92c..64825bfd 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1104,7 +1104,7 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
 	int index;
 
 	if (!page->ref_count) {
-		tracecmd_lib_fatal("Page ref count is zero!\n");
+		tracecmd_fatal("Page ref count is zero!\n");
 		return;
 	}
 
@@ -1165,7 +1165,7 @@ void tracecmd_free_record(struct tep_record *record)
 		return;
 
 	if (!record->ref_count) {
-		tracecmd_lib_fatal("record ref count is zero!");
+		tracecmd_fatal("record ref count is zero!");
 		return;
 	}
 
@@ -1175,7 +1175,7 @@ void tracecmd_free_record(struct tep_record *record)
 		return;
 
 	if (record->locked) {
-		tracecmd_lib_fatal("freeing record when it is locked!");
+		tracecmd_fatal("freeing record when it is locked!");
 		return;
 	}
 
@@ -1377,7 +1377,7 @@ static int get_page(struct tracecmd_input *handle, int cpu,
 
 	if (offset & (handle->page_size - 1)) {
 		errno = -EINVAL;
-		tracecmd_lib_fatal("bad page offset %llx", offset);
+		tracecmd_fatal("bad page offset %llx", offset);
 		return -1;
 	}
 
@@ -1385,7 +1385,7 @@ static int get_page(struct tracecmd_input *handle, int cpu,
 	    offset > handle->cpu_data[cpu].file_offset +
 	    handle->cpu_data[cpu].file_size) {
 		errno = -EINVAL;
-		tracecmd_lib_fatal("bad page offset %llx", offset);
+		tracecmd_fatal("bad page offset %llx", offset);
 		return -1;
 	}
 
@@ -1951,7 +1951,7 @@ tracecmd_peek_data(struct tracecmd_input *handle, int cpu)
 
 		record = handle->cpu_data[cpu].next;
 		if (!record->data) {
-			tracecmd_lib_fatal("Something freed the record");
+			tracecmd_fatal("Something freed the record");
 			return NULL;
 		}
 
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index db7bead6..85e28403 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -368,7 +368,7 @@ static int __vlib_warning(const char *fmt, va_list ap)
 	return ret;
 }
 
-void __weak tracecmd_lib_fatal(const char *fmt, ...)
+void __weak tracecmd_fatal(const char *fmt, ...)
 {
 	int ret;
 	va_list ap;
@@ -534,7 +534,7 @@ int tracecmd_count_cpus(void)
 
 	fp = fopen("/proc/cpuinfo", "r");
 	if (!fp) {
-		tracecmd_lib_fatal("Can not read cpuinfo");
+		tracecmd_fatal("Can not read cpuinfo");
 		return 0;
 	}
 
-- 
2.30.2

