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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E02C43219
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 086A7611C9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhIJNwc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbhIJNwa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:30 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B604C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:19 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id kt8so4358186ejb.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CmfquvZ1YQbng/9kSm4/msXUW4OjVnO7UspuVRYcDdY=;
        b=Erdc5yMwLymmqsO9PQK2jvDt/pUJzSoZ/hBLQMVgSTneq9aCMJmhWKptD4ggLY6UJc
         ooVRDTO9bv9Wu46Gv/N8i0HvLVW6Z4ctxfaj3dxXGctRA6FZqHLaqmoMrS6vBrC/AIEb
         c+59s5gX/v99HadhUj18nLprv2bHQ1bKEYL5sOEAJhL4c8fbkIuY6gCE5a31ADZXRFL7
         2HEIvJcDBFT8d65KD3/rF3rHOAi2nC3NUiQvpb/AHQ8R4bWG0zXALFqiJQ9P1kwd+qWu
         7IudWfQy0+ScYOiW8XVysTcGi9YgtDfprXeYb4WFIV21R0iWbEQ99VMEW5g0pomZ2QGE
         cH3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CmfquvZ1YQbng/9kSm4/msXUW4OjVnO7UspuVRYcDdY=;
        b=Oo//vXWm3Da5ApKwvmajqlU1BA3UUy4aBdA8BHIODS0sqwpL/jXlepJS7k7psgn9db
         xaM8wuas9m6MksgB7clJxO+z+u2EGLcwfxZmyClORWkdXRXX5MLMy4t2H3yBy21qT8Oc
         eMEtYJi6m2lojiqvNlrwrLTswtW42JQq0XKKFE3PLX4hXdTzka9ExYfz+hCTFjHI49Pz
         c7wtbOO98vRu4Kx9AaQ0KF8acbRMsiJin882rYpsW0qc9GZZFk4msIvPjACVFw28cutw
         ZgMgZk5U3DrgsUVAHH9gfvRikc9AR+rUBzvRZlAXQ1/HYpSdwTDqMtOsGH/+05NR53jc
         cAvw==
X-Gm-Message-State: AOAM5316VBQavGWam/D5JmpDOMv99FiDtDbbTj7SjzIk/cfD8Nv1I6Lc
        /gvt6GHiKNkUx30vzuOqfZUiSjsMaok=
X-Google-Smtp-Source: ABdhPJwqSZ9c8zslsdbXarccWMxtzQgayC6Urk0mH44sgA6uUrxXWGDQ1+4AgdSxcL1NlGKf+BMRzQ==
X-Received: by 2002:a17:906:2556:: with SMTP id j22mr9972692ejb.233.1631281877618;
        Fri, 10 Sep 2021 06:51:17 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 15/25] trace-cmd library: Initialize internal sections database on file read
Date:   Fri, 10 Sep 2021 16:50:51 +0300
Message-Id: <20210910135101.2865226-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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
index d8a981af..a08890df 100644
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
index dfbd2d36..d6aa7c8e 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -164,8 +164,7 @@ struct tracecmd_input {
 	struct file_section	*sections;
 	size_t			header_files_start;
 	size_t			ftrace_files_start;
-	size_t			event_files_start;
-	size_t			options_start;
+	unsigned long long	options_start;
 	size_t			total_file_size;
 
 	/* For custom profilers. */
@@ -175,6 +174,7 @@ struct tracecmd_input {
 __thread struct tracecmd_input *tracecmd_curr_thread_handle;
 
 #define CHECK_READ_STATE(H, S) ((H)->file_version < FILE_VERSION_SECTIONS && (H)->file_state >= (S))
+#define HAS_SECTIONS(H) ((H)->flags & TRACECMD_FL_SECTIONED)
 
 static int read_options_type(struct tracecmd_input *handle);
 
@@ -447,6 +447,10 @@ static int read_header_files(struct tracecmd_input *handle)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_HEADERS))
 		return 0;
 
+	if (HAS_SECTIONS(handle))
+		section_add_or_update(handle, TRACECMD_OPTION_HEADER_INFO, 0, 0,
+				      lseek64(handle->fd, 0, SEEK_CUR));
+
 	if (do_read_check(handle, buf, 12))
 		return -1;
 
@@ -490,9 +494,6 @@ static int read_header_files(struct tracecmd_input *handle)
 
 	free(header);
 
-	handle->ftrace_files_start =
-		lseek64(handle->fd, 0, SEEK_CUR);
-
 	handle->file_state = TRACECMD_FILE_HEADERS;
 
 	return 0;
@@ -653,6 +654,10 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_FTRACE_EVENTS))
 		return 0;
 
+	if (HAS_SECTIONS(handle))
+		section_add_or_update(handle, TRACECMD_OPTION_FTRACE_EVENTS, 0, 0,
+				      lseek64(handle->fd, 0, SEEK_CUR));
+
 	if (regex) {
 		sreg = &spreg;
 		ereg = &epreg;
@@ -693,8 +698,6 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 			goto out;
 	}
 
-	handle->event_files_start =
-		lseek64(handle->fd, 0, SEEK_CUR);
 	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
 	ret = 0;
 out:
@@ -726,6 +729,10 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_ALL_EVENTS))
 		return 0;
 
+	if (HAS_SECTIONS(handle))
+		section_add_or_update(handle, TRACECMD_OPTION_EVENT_FORMATS, 0, 0,
+				      lseek64(handle->fd, 0, SEEK_CUR));
+
 	if (regex) {
 		sreg = &spreg;
 		ereg = &epreg;
@@ -811,6 +818,10 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_KALLSYMS))
 		return 0;
 
+	if (HAS_SECTIONS(handle))
+		section_add_or_update(handle, TRACECMD_OPTION_KALLSYMS, 0, 0,
+				      lseek64(handle->fd, 0, SEEK_CUR));
+
 	ret = read4(handle, &size);
 	if (ret < 0)
 		goto out;
@@ -847,6 +858,10 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_PRINTK))
 		return 0;
 
+	if (HAS_SECTIONS(handle))
+		section_add_or_update(handle, TRACECMD_OPTION_PRINTK, 0, 0,
+				      lseek64(handle->fd, 0, SEEK_CUR));
+
 	ret = read4(handle, &size);
 	if (ret < 0)
 		goto out;
@@ -2885,6 +2900,18 @@ static int handle_options(struct tracecmd_input *handle)
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
@@ -3072,6 +3099,10 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CMD_LINES))
 		return 0;
 
+	if (HAS_SECTIONS(handle))
+		section_add_or_update(handle, TRACECMD_OPTION_CMDLINES, 0, 0,
+				      lseek64(handle->fd, 0, SEEK_CUR));
+
 	ret = read_data_and_size(handle, &cmdlines, &size);
 	if (ret < 0)
 		goto out;
@@ -3366,6 +3397,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	struct tracecmd_input *handle;
 	char test[] = TRACECMD_MAGIC;
 	unsigned int page_size;
+	size_t offset;
 	char *version;
 	char buf[BUFSIZ];
 	unsigned long ver;
@@ -3405,6 +3437,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	handle->file_version = ver;
 	free(version);
 
+	if (handle->file_version >= FILE_VERSION_SECTIONS)
+		handle->flags |= TRACECMD_FL_SECTIONED;
+
 	if (do_read_check(handle, buf, 1))
 		goto failed_read;
 
@@ -3429,14 +3464,16 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
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
2.31.1

