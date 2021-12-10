Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F5AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236958AbhLJK6j (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237153AbhLJK6j (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:39 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C961C0617A1
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:04 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id t5so28283022edd.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iaWR0wEsTVKPqRlbzDkv5c5I9vZjFWZ9ChR7t7JreIY=;
        b=WGzFiMU+yjTFDjb898pNh1A7oiOkmosJ1mRDQDe99lXysMnYhzTimb5S7SJmhEgTwn
         GUpXFPJ/u7Lh6+zPFUxzB2tbJ6sRxfbQLXmb6lmFvRK55QaUxLUIB2Z2IS1TvwYm8jEB
         0csfLf7C3p6YrUs8YYzpsII8kmtLLbe2JuofCqPiloCdeo7kxKjkqoqV5wL7Ua/SkSnE
         AzR+qmJP9AtH6SlhBkiN9uY8pIrLLIbrafGrgWws1wH7zr80MbIaRsZc+eSYrwtZycuz
         TZkq2/jAB1UqHurOVUHwNKRTYR/+wYllIH1aaaRzzmj8Fwn/UxClXEGmIkLbD+Lu2oIr
         yD5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iaWR0wEsTVKPqRlbzDkv5c5I9vZjFWZ9ChR7t7JreIY=;
        b=cA5QoKtMJYapVmQ32LDbmfT9S5Olwg27f7WiDpu3ExOc0RrXuAaSKiYl/8zVZpHq2W
         YffNP6ea0rpqmJXhqZcDBi4aCjVM30yhLzr5lro3EvFh5UbJakjCYuIsfGqiq4Mg39Yr
         z15oQZf6WQW9QNTrgXEWOVsCft5GeXugYqTh2PjanbJFaEhigwX4HMcyWkI2mCT5qMA4
         rHw7cvVPTgt7A3yqcMrxGjN6ClMhQHJTAo6HpB6MIIv+wO/ANKpack1Bhr34cmzUYSQl
         ZYAYoi99DI9L2BGaIreynntqmSrjkXkKVH8qKArp2ZCierW0SByXFLUuEeTBweQ6Xfot
         FepA==
X-Gm-Message-State: AOAM531t8z6STKntrQ2uFf/80eRWRHFE4wXyKTLh3xpTJB4ByJeENgho
        5GR1m0qRM+kdVhoVVhST/UItqbjTTcY=
X-Google-Smtp-Source: ABdhPJwzbiUZ+bgSpUyWRfw22KqnGGa3TafrqybWqd9XWT9GePHnEcVmr0hJO8Q4OotXyhSuSjAoZg==
X-Received: by 2002:aa7:c7cf:: with SMTP id o15mr37919118eds.176.1639133702974;
        Fri, 10 Dec 2021 02:55:02 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:55:02 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 14/25] trace-cmd library: Initialize internal sections database on file read
Date:   Fri, 10 Dec 2021 12:54:37 +0200
Message-Id: <20211210105448.97850-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
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
index d8ee9b74..2e0c32b6 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -154,6 +154,7 @@ enum {
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

