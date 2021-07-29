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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC7FC4320E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6D1D61054
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhG2FKk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbhG2FKk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:40 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A56C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:37 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id da26so6430476edb.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SZGfgbN8GTyZFbiZL50LNL3hWol4el7zjJSKUrxYzbQ=;
        b=jFOfbzfYVRESLqLtsnQkNZtplfngynPwjNyiuhiSzr3hMUtzEeah9DXIivJfRK/H4D
         cnA0qXJG5fgnhDfFliaSiYkaJY9xnbwfsjeCslv74rkDq0M7/qiK9TuQ1TkOHN346lKr
         Nb7frvG4MTCdP+9vlhNWHc8admDTYdWfyU/qljf4sROv87RIq0qSdBGmk8dk+CH6e4Cs
         ScTjjwo8RnRykJ3nDvQjNqSl2Ut2nZCMauglT/RmocXqcvwGw2EVsvwbp8JM1F+OD/FU
         6Oqr080zwvt4lE28Ug6GM3JZCvUdpcaABReXUUuhAwaHUf6zHReoQ3aeVhZmefidbGNE
         I3yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SZGfgbN8GTyZFbiZL50LNL3hWol4el7zjJSKUrxYzbQ=;
        b=o1k/Sx6eOWaA+WfpnMuAwEOjNzc6zEiUbID+rcDdw78MY4FY1ajXVv/bRDdTaOh6qY
         d9RJ42B0HIGL3g1jZVLxnXab5RLKS7q2kNGa64rIDJ9sxGi9vX9Tmo6PVshBZIxxz4xE
         BgPFUSSjMgEQhVCKwQs0sJgq2lqxt/cTSuMcKIvtlpw+BiniMdi7P+ZtskaagNiCCfrt
         pkXWLUdM7mII3CZzQVVO7PgcqRGmXhhRaAcqSAimzWtb38hRIy2iL5qD0M7Bq7twzPbH
         INI6RN7QvR0MMxJRPriK2wLI622Vdkh/n/bguNCieb7twAhyrGsrqXn1nJ5JyjrH6SOI
         aInQ==
X-Gm-Message-State: AOAM530Xa+ez8mptTWY+p22pXT9mH8KPYZujNZWXLI8arm5gRrEgmzWU
        Lp9ab2QF+w3bECTK2KVMzZc=
X-Google-Smtp-Source: ABdhPJxMIfnc4eN09K5z7M8P4lpOKKsNrLfApAujaYAU9YkYLq0d6toLWTLEZ2eHuYrD8iwWtIspIw==
X-Received: by 2002:a05:6402:487:: with SMTP id k7mr3819192edv.315.1627535435876;
        Wed, 28 Jul 2021 22:10:35 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:35 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 35/87] trace-cmd library: Initialize internal sections database on file read
Date:   Thu, 29 Jul 2021 08:09:07 +0300
Message-Id: <20210729050959.12263-36-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
index e8eefb5c..f5e13bbc 100644
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
@@ -691,6 +691,10 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_FTRACE_EVENTS))
 		return 0;
 
+	if (handle->file_version < 7)
+		add_section(handle, TRACECMD_OPTION_FTRACE_EVENTS, 0, 0,
+			    lseek64(handle->fd, 0, SEEK_CUR));
+
 	if (regex) {
 		sreg = &spreg;
 		ereg = &epreg;
@@ -729,9 +733,6 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 			return -1;
 	}
 
-	handle->event_files_start =
-		lseek64(handle->fd, 0, SEEK_CUR);
-
 	if (sreg) {
 		regfree(sreg);
 		regfree(ereg);
@@ -762,6 +763,10 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_ALL_EVENTS))
 		return 0;
 
+	if (handle->file_version < 7)
+		add_section(handle, TRACECMD_OPTION_EVENT_FORMATS, 0, 0,
+			    lseek64(handle->fd, 0, SEEK_CUR));
+
 	if (regex) {
 		sreg = &spreg;
 		ereg = &epreg;
@@ -847,6 +852,11 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
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
@@ -878,6 +888,11 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
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
@@ -2909,6 +2924,16 @@ static int handle_options(struct tracecmd_input *handle)
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

