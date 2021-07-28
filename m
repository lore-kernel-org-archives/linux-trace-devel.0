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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF34EC4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8D3160D07
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbhG1Ndc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236672AbhG1Ndb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:31 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D6BC061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:28 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id e19so4609337ejs.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AMRtzUCAxsmbGQIBHviWVzVkzup0w8VvFIL8yBVZnPY=;
        b=rpKAcLOwTgxYH9jG/TFhi0ioM0ZQkSOsRqGL3isWUXO43Mqz6+4qpnAnN8RcnPSZxE
         sii167qJ63mMG+EQ6FbCZhfB1LMCg+4LJlHV94d7wYGYVANf5paOhgaI1F3xLWAN1+EG
         uQZPCeHpHy0avwFnAnO7KAvwdh7/42B/SQF3UGQ3tG2xRm+b55T5UOMsWOhDbgy8gCSR
         zzgtyGa/yCabrfGGwiuojEHq+IdgdU0tGdlNoYw4lKYdbRpdlMfytm64HPVLorjp+VY+
         T6el0qPy6ag9cVEMO8Q6Q3on0Nx/uAgH+3w/hW1FoSQBBL9xdUIkzABE877+JAd83H7d
         fU0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AMRtzUCAxsmbGQIBHviWVzVkzup0w8VvFIL8yBVZnPY=;
        b=Ym8986sW/FRo6ONrM8KiH7et5LRl5orCUpvo23aVX5ZcpAzqWUU4owM0m+x5riXn+6
         OvLKRUa8ZpjtI0VOS9hvHasrRgP/x2Y0CWb20FotEDUVtZFG18ViPO9M+BlkicQKs4tF
         DA3wWIiVML6pFRT1oFpF5aPrAkd/soKBvsPsa3hC+UI282nRyGwhJuj75EU+lP9n/rNm
         9lLiYtT4bZNswmfNC03y680dPbTSqgk4OnmLGcs0LrNTzOeqE37i8MjLfIN/9PtXfo/1
         oKXpHt7kFN63dgeWBbT/CGu1nV/xl6ansrc7J6dlnfS0Lp/R4wDU9cQQD0iav/eIyyEG
         pMsA==
X-Gm-Message-State: AOAM530p70a9SJA6IER16Iq1zfvkW7t1zZZgE+2GgX4TRD5IPcJVwOPh
        ipVUr1QVcpvoI4eMJH8xWW4=
X-Google-Smtp-Source: ABdhPJxkB0Rau8r/ROAS4oSByVl3ZlntgOhBJQ6zdv5zWRtna0o7narDYHnY42gBlw9hblquBE86Xg==
X-Received: by 2002:a17:907:e92:: with SMTP id ho18mr2443264ejc.261.1627479207114;
        Wed, 28 Jul 2021 06:33:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 35/87] trace-cmd library: Initialize internal sections database on file read
Date:   Wed, 28 Jul 2021 16:31:58 +0300
Message-Id: <20210728133250.234140-36-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add sections in internal database on file reading and parsing.
In trace file version 7, sections are initialized when parsing
corresponding trace options. In version 6 files, sections are retrieved
on file reading, as there they are in a fixed position file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 55 +++++++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 15 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 61b35853..cdc7379a 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -165,7 +165,6 @@ struct tracecmd_input {
 	struct file_section	*sections;
 	size_t			header_files_start;
 	size_t			ftrace_files_start;
-	size_t			event_files_start;
 	size_t			options_start;
 	size_t			total_file_size;
 
@@ -485,6 +484,10 @@ static int read_header_files(struct tracecmd_input *handle)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_HEADERS))
 		return 0;
 
+	if (handle->file_version < 7)
+		add_section(handle, TRACECMD_OPTION_HEADER_INFO, 0, 0,
+			    lseek64(handle->fd, 0, SEEK_CUR));
+
 	if (do_read_check(handle, buf, 12))
 		return -1;
 
@@ -528,9 +531,6 @@ static int read_header_files(struct tracecmd_input *handle)
 
 	free(header);
 
-	handle->ftrace_files_start =
-		lseek64(handle->fd, 0, SEEK_CUR);
-
 	handle->file_state = TRACECMD_FILE_HEADERS;
 
 	return 0;
@@ -692,6 +692,10 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_FTRACE_EVENTS))
 		return 0;
 
+	if (handle->file_version < 7)
+		add_section(handle, TRACECMD_OPTION_FTRACE_EVENTS, 0, 0,
+			    lseek64(handle->fd, 0, SEEK_CUR));
+
 	if (regex) {
 		sreg = &spreg;
 		ereg = &epreg;
@@ -730,9 +734,6 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 			return -1;
 	}
 
-	handle->event_files_start =
-		lseek64(handle->fd, 0, SEEK_CUR);
-
 	if (sreg) {
 		regfree(sreg);
 		regfree(ereg);
@@ -763,6 +764,10 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_ALL_EVENTS))
 		return 0;
 
+	if (handle->file_version < 7)
+		add_section(handle, TRACECMD_OPTION_EVENT_FORMATS, 0, 0,
+			    lseek64(handle->fd, 0, SEEK_CUR));
+
 	if (regex) {
 		sreg = &spreg;
 		ereg = &epreg;
@@ -848,6 +853,11 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_KALLSYMS))
 		return 0;
 
+	if (handle->file_version < 7)
+		add_section(handle, TRACECMD_OPTION_KALLSYMS, 0, 0,
+			    lseek64(handle->fd, 0, SEEK_CUR));
+
+
 	if (read4(handle, &size) < 0)
 		return -1;
 	if (!size)
@@ -879,6 +889,11 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_PRINTK))
 		return 0;
 
+	if (handle->file_version < 7)
+		add_section(handle, TRACECMD_OPTION_PRINTK, 0, 0,
+			    lseek64(handle->fd, 0, SEEK_CUR));
+
+
 	if (read4(handle, &size) < 0)
 		return -1;
 	if (!size)
@@ -2910,6 +2925,16 @@ static int handle_options(struct tracecmd_input *handle)
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
+			add_section(handle, option, -1, tep_read_number(handle->pevent, buf, 8), 0);
+			break;
 		default:
 			tracecmd_warning("unknown option %d", option);
 			break;
@@ -3095,6 +3120,10 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CMD_LINES))
 		return 0;
 
+	if (handle->file_version < 7)
+		add_section(handle, TRACECMD_OPTION_CMDLINES, 0, 0,
+			    lseek64(handle->fd, 0, SEEK_CUR));
+
 	if (read_data_and_size(handle, &cmdlines, &size) < 0)
 		return -1;
 	cmdlines[size] = 0;
@@ -3384,6 +3413,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	struct tracecmd_input *handle;
 	char test[] = TRACECMD_MAGIC;
 	unsigned int page_size;
+	size_t offset;
 	char *version;
 	char buf[BUFSIZ];
 	unsigned long ver;
@@ -3444,14 +3474,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	read4(handle, &page_size);
 	handle->page_size = page_size;
 
-	handle->header_files_start =
-		lseek64(handle->fd, 0, SEEK_CUR);
-
-	handle->total_file_size =
-		lseek64(handle->fd, 0, SEEK_END);
-
-	handle->header_files_start =
-		lseek64(handle->fd, handle->header_files_start, SEEK_SET);
+	offset = lseek64(handle->fd, 0, SEEK_CUR);
+	handle->total_file_size = lseek64(handle->fd, 0, SEEK_END);
+	lseek64(handle->fd, offset, SEEK_SET);
 
 	handle->file_state = TRACECMD_FILE_INIT;
 
-- 
2.31.1

