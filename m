Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D8A2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhLBMZq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358026AbhLBMZb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:31 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5084C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:22:08 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id t5so115415352edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vnfAXC44ApuzRsYmj/eLVSejArVAi4v2CJLKUtRoec8=;
        b=KCI/3CUG/FBFJhMjR7jOU+v3RUC++jXN80xPhFUbIf07hv5FU3VByZcQxFYYzWYR6u
         bfn+RacMlkiApHiGe1X4Zwbewooe1uyWoM+uYRYk0LCvnESOq36n6+6pbv8dJAUtvBp0
         9cTjMiDWHOf0ffOdtusnW9iqf0OQSQD8AqBKoFr1L3JWOO+YrqWnev9aUCYixxPJn/wc
         eKxTDB5LunnCnfXR4hV3W/ZbtMXt80g0A/qligYS55CAPUs6Sjkw1niYZMftHxL5KZMt
         IszfUrcXPbuO1YYfnvVmx3bup+JDQEzccg32FT4kZ7dzOuC+jfc2nQOoF5jeHQoVfRnI
         JABA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vnfAXC44ApuzRsYmj/eLVSejArVAi4v2CJLKUtRoec8=;
        b=sWTWlf3iWixj5kCYsxEC4KtgG9krFA9nU5KiMCcHX4Th3nHxToxNCdLLQC1k2aDQAM
         /f+g4wmISJyTCz+y4L49bgywvqyfMCgmfKQCL+wPgdwfPdlqfSXBDWYT1R+Szh0O/yaE
         ffFQkCNpywgdgxm/b8etH/l2TgKG9XL/6ISKKMHkSOw+HhLcd3f48+QQPMn6RsQGOUGp
         xmJKnL5WPJS01eBoBsLHntrTVfF8VeEMp0IaTzrGYXnCVV3CTxVteShv2eEZg9w2TWwP
         whyE9cQeUVXczI7zRhT1ZqB/wYfWW6XqzBhzsTDyiFXupCi2TPchUIDKoOxgocapUqd/
         Bk9g==
X-Gm-Message-State: AOAM532C5A0dIL6Oh9USK++ZPGeVo9FfGZE9L10ujxtGVs5viI4wIlWN
        o79ZkFQUJ1cytkI6zhHb4sbeoaZm70OxAg==
X-Google-Smtp-Source: ABdhPJxjfe9yl+g8WAt0wbNymZxALEwZH/POBXjfSDsEQhLv+HPWUP0JL+fu2mz/DB7GayUQcu7djA==
X-Received: by 2002:a50:9514:: with SMTP id u20mr17109898eda.117.1638447727120;
        Thu, 02 Dec 2021 04:22:07 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:22:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 13/23] trace-cmd library: Initialize internal sections database on file read
Date:   Thu,  2 Dec 2021 14:21:42 +0200
Message-Id: <20211202122152.43275-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add sections in internal database on file reading and parsing.
In trace file version 7, sections are initialized when parsing
corresponding trace options. In version 6 files, sections are retrieved
on file reading, as there they are in a fixed position in the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-input.c                   | 65 +++++++++++++++----
 2 files changed, 52 insertions(+), 14 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index a738a9e6..3b5afeba 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -153,6 +153,7 @@ enum {
 	TRACECMD_FL_BUFFER_INSTANCE	= (1 << 1),
 	TRACECMD_FL_IN_USECS		= (1 << 2),
 	TRACECMD_FL_RAW_TS		= (1 << 3),
+	TRACECMD_FL_SECTIONED		= (1 << 4),
 };
 
 struct tracecmd_ftrace {
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 78f9effd..7f24d2e2 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -165,8 +165,7 @@ struct tracecmd_input {
 	struct file_section	*sections;
 	size_t			header_files_start;
 	size_t			ftrace_files_start;
-	size_t			event_files_start;
-	size_t			options_start;
+	unsigned long long	options_start;
 	size_t			total_file_size;
 
 	/* For custom profilers. */
@@ -176,6 +175,7 @@ struct tracecmd_input {
 __thread struct tracecmd_input *tracecmd_curr_thread_handle;
 
 #define CHECK_READ_STATE(H, S) ((H)->file_version < FILE_VERSION_SECTIONS && (H)->file_state >= (S))
+#define HAS_SECTIONS(H) ((H)->flags & TRACECMD_FL_SECTIONED)
 
 static int read_options_type(struct tracecmd_input *handle);
 
@@ -448,6 +448,10 @@ static int read_header_files(struct tracecmd_input *handle)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_HEADERS))
 		return 0;
 
+	if (!HAS_SECTIONS(handle))
+		section_add_or_update(handle, TRACECMD_OPTION_HEADER_INFO, 0, 0,
+				      lseek64(handle->fd, 0, SEEK_CUR));
+
 	if (do_read_check(handle, buf, 12))
 		return -1;
 
@@ -491,9 +495,6 @@ static int read_header_files(struct tracecmd_input *handle)
 
 	free(header);
 
-	handle->ftrace_files_start =
-		lseek64(handle->fd, 0, SEEK_CUR);
-
 	handle->file_state = TRACECMD_FILE_HEADERS;
 
 	return 0;
@@ -654,6 +655,10 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_FTRACE_EVENTS))
 		return 0;
 
+	if (!HAS_SECTIONS(handle))
+		section_add_or_update(handle, TRACECMD_OPTION_FTRACE_EVENTS, 0, 0,
+				      lseek64(handle->fd, 0, SEEK_CUR));
+
 	if (regex) {
 		sreg = &spreg;
 		ereg = &epreg;
@@ -694,8 +699,6 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 			goto out;
 	}
 
-	handle->event_files_start =
-		lseek64(handle->fd, 0, SEEK_CUR);
 	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
 	ret = 0;
 out:
@@ -727,6 +730,10 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_ALL_EVENTS))
 		return 0;
 
+	if (!HAS_SECTIONS(handle))
+		section_add_or_update(handle, TRACECMD_OPTION_EVENT_FORMATS, 0, 0,
+				      lseek64(handle->fd, 0, SEEK_CUR));
+
 	if (regex) {
 		sreg = &spreg;
 		ereg = &epreg;
@@ -810,6 +817,9 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_KALLSYMS))
 		return 0;
+	if (!HAS_SECTIONS(handle))
+		section_add_or_update(handle, TRACECMD_OPTION_KALLSYMS, 0, 0,
+				      lseek64(handle->fd, 0, SEEK_CUR));
 
 	if (read4(handle, &size) < 0)
 		return -1;
@@ -844,6 +854,10 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_PRINTK))
 		return 0;
 
+	if (!HAS_SECTIONS(handle))
+		section_add_or_update(handle, TRACECMD_OPTION_PRINTK, 0, 0,
+				      lseek64(handle->fd, 0, SEEK_CUR));
+
 	if (read4(handle, &size) < 0)
 		return -1;
 	if (!size) {
@@ -2876,6 +2890,18 @@ static int handle_options(struct tracecmd_input *handle)
 			handle->tsc_calc.offset = tep_read_number(handle->pevent,
 								  buf + 8, 8);
 			break;
+		case TRACECMD_OPTION_HEADER_INFO:
+		case TRACECMD_OPTION_FTRACE_EVENTS:
+		case TRACECMD_OPTION_EVENT_FORMATS:
+		case TRACECMD_OPTION_KALLSYMS:
+		case TRACECMD_OPTION_PRINTK:
+		case TRACECMD_OPTION_CMDLINES:
+			if (size < 8)
+				break;
+			section_add_or_update(handle, option, -1,
+					      tep_read_number(handle->pevent, buf, 8), 0);
+			break;
+
 		default:
 			tracecmd_warning("unknown option %d", option);
 			break;
@@ -3060,6 +3086,11 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CMD_LINES))
 		return 0;
 
+	if (!HAS_SECTIONS(handle))
+		section_add_or_update(handle, TRACECMD_OPTION_CMDLINES, 0, 0,
+				      lseek64(handle->fd, 0, SEEK_CUR));
+
+
 	if (read_data_and_size(handle, &cmdlines, &size) < 0)
 		return -1;
 	cmdlines[size] = 0;
@@ -3349,6 +3380,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	struct tracecmd_input *handle;
 	char test[] = TRACECMD_MAGIC;
 	unsigned int page_size;
+	size_t offset;
 	char *version;
 	char buf[BUFSIZ];
 	unsigned long ver;
@@ -3388,6 +3420,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	handle->file_version = ver;
 	free(version);
 
+	if (handle->file_version >= FILE_VERSION_SECTIONS)
+		handle->flags |= TRACECMD_FL_SECTIONED;
+
 	if (do_read_check(handle, buf, 1))
 		goto failed_read;
 
@@ -3412,14 +3447,16 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	read4(handle, &page_size);
 	handle->page_size = page_size;
 
-	handle->header_files_start =
-		lseek64(handle->fd, 0, SEEK_CUR);
-
-	handle->total_file_size =
-		lseek64(handle->fd, 0, SEEK_END);
+	offset = lseek64(handle->fd, 0, SEEK_CUR);
+	handle->total_file_size = lseek64(handle->fd, 0, SEEK_END);
+	lseek64(handle->fd, offset, SEEK_SET);
 
-	handle->header_files_start =
-		lseek64(handle->fd, handle->header_files_start, SEEK_SET);
+	if (HAS_SECTIONS(handle)) {
+		if (read8(handle, &(handle->options_start))) {
+			tracecmd_warning("Filed to read the offset of the first option section");
+			goto failed_read;
+		}
+	}
 
 	handle->file_state = TRACECMD_FILE_INIT;
 
-- 
2.33.1

