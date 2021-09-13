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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB329C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93D9E60FDA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240006AbhIMMbW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240001AbhIMMbW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:22 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652BDC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:06 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id d207-20020a1c1dd8000000b00307e2d1ec1aso695999wmd.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xP+T3hWSON7wU2+dz9tSwVvMuF5QsCbuc+E5tQxOSNk=;
        b=opSnzg8daKAP1rDPP1EU1iLCkZ9FY6g43Tma4AkHK7j1J1XMiAijcEDe4/4elpX7sm
         EynHGYUWtDT4ojhvnj/suLsD5QE3Nv0RhlnmruUusLpkIY9w2JVJW9Soz2I4SEqNQMms
         SMHm5n4zxBXpCg8YQ+K1NMOhLrN8OyiMfztoaMK9oe7arfrqQhA7XfugvljOVDzJHMNG
         EaVllyBVgPvDGhIVAxPFjUpf3YA9ZoDDU51h3lVTVTSAEYpb1UAcaeAEd/emh+1RxxAa
         O6g8AQzELzFIqPRJicxGuR4c2X00OwVAwgZlzK3BD+m5sd6DAQXwEigyFl0EgEzybDAi
         /f0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xP+T3hWSON7wU2+dz9tSwVvMuF5QsCbuc+E5tQxOSNk=;
        b=rj2Vx6bwRSLsTcubDbOR9JMhpwbyVB5cRBbyuwezs0XFGkf9iCaRkG6fCZJLDLMDMs
         ++y+Aj382NfhTJkwHpQqgv8YvI/rnNKdlJM8EIYx4n6TtpQDXs9yxpwLjndquzwBKmyn
         IEogm40jOMQ5VQIGfVLPbXxksyy7d+18UVpj9Px6CJ0FweXR+Xw55Yo3pR4er/GWAvbq
         jzz9MOYmtdV3BvzB0ouLUxR9XexenkVuLAX5Ui2YaRs0XCF1t32BaK3n7dqIHqQTRnK6
         d6uxk8eNpd8/cfoxG7EhzZj2phcBuQqhdn5L2iQh2MQTJZMrdn3tJukNK3lNo9EbStqj
         axuw==
X-Gm-Message-State: AOAM532FONFNqpm1dDDuBERpGvd7BxlmjNkJ4qX6zHuY+iRZPYtn833g
        4+dek/cMWpJY4pcu26jPWkhYqP7rLgI=
X-Google-Smtp-Source: ABdhPJwY/s7PyXEkevd2VC1xk9lqnuaesaX2fxMAJNCBp3W22QKgCWJNSiHWMZOIOl65bRsevLXGZw==
X-Received: by 2002:a05:600c:4e93:: with SMTP id f19mr11002272wmq.185.1631536204959;
        Mon, 13 Sep 2021 05:30:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:30:04 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 15/25] trace-cmd library: Initialize internal sections database on file read
Date:   Mon, 13 Sep 2021 15:29:37 +0300
Message-Id: <20210913122947.3673239-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
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
index 978758c0..bc3bc5d2 100644
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
 
+	if (!HAS_SECTIONS(handle))
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
 
+	if (!HAS_SECTIONS(handle))
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
 
+	if (!HAS_SECTIONS(handle))
+		section_add_or_update(handle, TRACECMD_OPTION_EVENT_FORMATS, 0, 0,
+				      lseek64(handle->fd, 0, SEEK_CUR));
+
 	if (regex) {
 		sreg = &spreg;
 		ereg = &epreg;
@@ -811,6 +818,10 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_KALLSYMS))
 		return 0;
 
+	if (!HAS_SECTIONS(handle))
+		section_add_or_update(handle, TRACECMD_OPTION_KALLSYMS, 0, 0,
+				      lseek64(handle->fd, 0, SEEK_CUR));
+
 	ret = read4(handle, &size);
 	if (ret < 0)
 		goto out;
@@ -847,6 +858,10 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_PRINTK))
 		return 0;
 
+	if (!HAS_SECTIONS(handle))
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
@@ -3070,6 +3097,10 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CMD_LINES))
 		return 0;
 
+	if (!HAS_SECTIONS(handle))
+		section_add_or_update(handle, TRACECMD_OPTION_CMDLINES, 0, 0,
+				      lseek64(handle->fd, 0, SEEK_CUR));
+
 	ret = read_data_and_size(handle, &cmdlines, &size);
 	if (ret < 0)
 		goto out;
@@ -3364,6 +3395,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	struct tracecmd_input *handle;
 	char test[] = TRACECMD_MAGIC;
 	unsigned int page_size;
+	size_t offset;
 	char *version;
 	char buf[BUFSIZ];
 	unsigned long ver;
@@ -3403,6 +3435,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	handle->file_version = ver;
 	free(version);
 
+	if (handle->file_version >= FILE_VERSION_SECTIONS)
+		handle->flags |= TRACECMD_FL_SECTIONED;
+
 	if (do_read_check(handle, buf, 1))
 		goto failed_read;
 
@@ -3427,14 +3462,16 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
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

