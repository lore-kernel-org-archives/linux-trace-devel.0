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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22761C4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FFA56023E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbhG2FLT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbhG2FLS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:18 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22444C0613C1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:15 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id nd39so8466509ejc.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hvBfWVcxz5c7nYZDb5JZXKqUOClgX+o4XpZ1B0dYn1g=;
        b=P49aqXMKKw3cUhrcM3egUcLh+Zz6ejU+GYXHKrEBd+snTfmUJpw0yclXpjC07m4qjD
         uTGwAwIyg9bYUaE//kVGkftIiH7d/W3upjGgyjYntLbFJshttduqqf9jlaFa2CqU7Z3/
         PyALFlSmJGdNbuGOVFIkoaqcQJOkFDC5ueHqpPLMymn1+1RNOGJYw3oqLEpSoDahZOyR
         cALiYL881aKeohLeAcxmIBqo0QsN7IOdelCAQePzaNnkuqr222RTfR+yWmsNXjv3/wBu
         Vkvy3BmkALWgIK1VNhawAM8hv0WfO2RVsqyNtta0u6UIv2Y5FZFkBr8kIi9dc03NfY/4
         UiTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hvBfWVcxz5c7nYZDb5JZXKqUOClgX+o4XpZ1B0dYn1g=;
        b=jiHo/dBoy9HKqBgNUXk8nHoelax2XNqf5D9JPPkLFaVmZQGPiFvGjNRyRmnaFYAPjg
         aemQDSUnfWKctGUZ032ZHZUOhdd+M88vNvyK9DmWAdGgG4HjDNMlhEMHbU2dF+e2kO2q
         LG2pbwVNHkkFv/jPs0pnp7VQuJu/6RvN6SN5uE+OA4+uhPymmxFAz9anTCudKmvhfZOw
         BD2taZpkt4moE65cL6vNV6G1sPVZtxaUz8HTtBQWPpqczlzetbTjyNdlXzfh6/BUeW+D
         T3GIP48STNGejtMgcml7twtI+kIUrevJVhstdbmYNTo5y5DbCGUqwkLM7QQ2VwDbK5xz
         2cZw==
X-Gm-Message-State: AOAM533qlAOFkySdpvsX/vc/r9uZmx2JisM/UQkhDk+5G3c58tU+uaGi
        0wNnnc7TkGupmM8KZ7uJlFLdsxZTcYvSrg==
X-Google-Smtp-Source: ABdhPJxm863y+Ji6i6a5rZ1s/L8ymeCFRg3v2axsUx1O/Vz8WFtWSWLgw7uf932xrEZJSjbgTt2PaA==
X-Received: by 2002:a17:906:404:: with SMTP id d4mr2802334eja.449.1627535473757;
        Wed, 28 Jul 2021 22:11:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:11:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 75/87] trace-cmd library: Handle version 7 files when copying headers between files
Date:   Thu, 29 Jul 2021 08:09:47 +0300
Message-Id: <20210729050959.12263-76-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When copying header data between trace files, handle the file versions.
Internal library functions for copying these headers are fixed to work
with trace file version 7:
 copy_header_files
 copy_ftrace_files
 copy_event_files
 copy_proc_kallsyms
 copy_command_lines

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |   1 +
 lib/trace-cmd/trace-input.c             | 191 ++++++++++++++++++++----
 lib/trace-cmd/trace-output.c            |   5 +
 3 files changed, 167 insertions(+), 30 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index c73b37a6..60520b07 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -51,6 +51,7 @@ void out_compression_reset(struct tracecmd_output *handle);
 void in_uncompress_reset(struct tracecmd_input *handle);
 int in_uncompress_block(struct tracecmd_input *handle);
 
+void out_set_file_state(struct tracecmd_output *handle, int new_state);
 unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 					int fd, unsigned long long max,
 					unsigned long long *write_size);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 2d2750ad..5ceb9756 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4412,161 +4412,292 @@ static int read_copy_data(struct tracecmd_input *in_handle,
 static int copy_header_files(struct tracecmd_input *in_handle,
 			     struct tracecmd_output *out_handle)
 {
+	struct file_section *sec;
+	unsigned long long offset;
 	unsigned long long size;
 
-	if (in_handle->file_state != TRACECMD_FILE_HEADERS - 1)
+	if (!check_out_state(out_handle, TRACECMD_FILE_HEADERS))
+		return -1;
+
+	sec = open_section(in_handle, TRACECMD_OPTION_HEADER_INFO);
+	if (!sec)
 		return -1;
+	offset = out_write_section_header(out_handle, TRACECMD_OPTION_HEADER_INFO,
+					  "headers", TRACECMD_SEC_FL_COMPRESS, true);
+
+	out_compression_start(out_handle);
 
 	/* "header_page"  */
 	if (read_copy_data(in_handle, 12, out_handle) < 0)
-		return -1;
+		goto error;
 
 	if (read_copy_size8(in_handle, out_handle, &size) < 0)
-		return -1;
+		goto error;
 
 	if (read_copy_data(in_handle, size, out_handle) < 0)
-		return -1;
+		goto error;
 
 	/* "header_event"  */
 	if (read_copy_data(in_handle, 13, out_handle) < 0)
-		return -1;
+		goto error;
 
 	if (read_copy_size8(in_handle, out_handle, &size) < 0)
-		return -1;
+		goto error;
 
 	if (read_copy_data(in_handle, size, out_handle) < 0)
-		return -1;
+		goto error;
 
 	in_handle->file_state = TRACECMD_FILE_HEADERS;
+	if (out_compression_end(out_handle))
+		goto error;
+	out_set_file_state(out_handle, in_handle->file_state);
+	close_section(in_handle, sec);
+
+	if (out_update_section_header(out_handle, offset))
+		goto error;
 
 	return 0;
+error:
+	out_compression_reset(out_handle);
+	close_section(in_handle, sec);
+	return -1;
 }
 
 static int copy_ftrace_files(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
+	struct file_section *sec;
+	unsigned long long offset;
 	unsigned long long size;
 	unsigned int count;
 	unsigned int i;
 
-	if (in_handle->file_state != TRACECMD_FILE_FTRACE_EVENTS - 1)
+	if (!check_out_state(out_handle, TRACECMD_FILE_FTRACE_EVENTS))
 		return -1;
 
-	if (read_copy_size4(in_handle, out_handle, &count) < 0)
+	sec = open_section(in_handle, TRACECMD_OPTION_FTRACE_EVENTS);
+	if (!sec)
 		return -1;
+	offset = out_write_section_header(out_handle, TRACECMD_OPTION_FTRACE_EVENTS,
+					  "ftrace events", TRACECMD_SEC_FL_COMPRESS, true);
+
+	out_compression_start(out_handle);
+
+	if (read_copy_size4(in_handle, out_handle, &count) < 0)
+		goto error;
 
 	for (i = 0; i < count; i++) {
 
 		if (read_copy_size8(in_handle, out_handle, &size) < 0)
-			return -1;
+			goto error;
 
 		if (read_copy_data(in_handle, size, out_handle) < 0)
-			return -1;
+			goto error;
 	}
 
 	in_handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
+	if (out_compression_end(out_handle))
+		goto error;
+	out_set_file_state(out_handle, in_handle->file_state);
+
+	close_section(in_handle, sec);
+
+	if (out_update_section_header(out_handle, offset))
+		goto error;
 
 	return 0;
+error:
+	out_compression_reset(out_handle);
+	close_section(in_handle, sec);
+	return -1;
 }
 
 static int copy_event_files(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
+	struct file_section *sec;
+	unsigned long long offset;
 	unsigned long long size;
 	char *system;
 	unsigned int systems;
 	unsigned int count;
 	unsigned int i,x;
 
-	if (in_handle->file_state != TRACECMD_FILE_ALL_EVENTS - 1)
+	if (!check_out_state(out_handle, TRACECMD_FILE_ALL_EVENTS))
 		return -1;
 
-	if (read_copy_size4(in_handle, out_handle, &systems) < 0)
+	sec = open_section(in_handle, TRACECMD_OPTION_EVENT_FORMATS);
+	if (!sec)
 		return -1;
+	offset = out_write_section_header(out_handle, TRACECMD_OPTION_EVENT_FORMATS,
+					  "events format", TRACECMD_SEC_FL_COMPRESS, true);
+
+	out_compression_start(out_handle);
+
+	if (read_copy_size4(in_handle, out_handle, &systems) < 0)
+		goto error;
 
 	for (i = 0; i < systems; i++) {
 		system = read_string(in_handle);
 		if (!system)
-			return -1;
+			goto error;
 		if (do_write_check(out_handle, system, strlen(system) + 1)) {
 			free(system);
-			return -1;
+			goto error;
 		}
 		free(system);
 
 		if (read_copy_size4(in_handle, out_handle, &count) < 0)
-			return -1;
+			goto error;
 
 		for (x=0; x < count; x++) {
 			if (read_copy_size8(in_handle, out_handle, &size) < 0)
-				return -1;
+				goto error;
 
 			if (read_copy_data(in_handle, size, out_handle) < 0)
-				return -1;
+				goto error;
 		}
 	}
 
 	in_handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+	if (out_compression_end(out_handle))
+		goto error;
+	out_set_file_state(out_handle, in_handle->file_state);
+
+	close_section(in_handle, sec);
+
+	if (out_update_section_header(out_handle, offset))
+		goto error;
 
 	return 0;
+error:
+	out_compression_reset(out_handle);
+	close_section(in_handle, sec);
+	return -1;
 }
 
 static int copy_proc_kallsyms(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
+	struct file_section *sec;
+	unsigned long long offset;
 	unsigned int size;
 
-	if (in_handle->file_state != TRACECMD_FILE_KALLSYMS - 1)
+	if (!check_out_state(out_handle, TRACECMD_FILE_KALLSYMS))
 		return -1;
+	sec = open_section(in_handle, TRACECMD_OPTION_KALLSYMS);
+	if (!sec)
+		return -1;
+	offset = out_write_section_header(out_handle, TRACECMD_OPTION_KALLSYMS,
+					  "kallsyms", TRACECMD_SEC_FL_COMPRESS, true);
 
+	out_compression_start(out_handle);
 	if (read_copy_size4(in_handle, out_handle, &size) < 0)
-		return -1;
+		goto error;
 	if (!size)
-		return 0; /* OK? */
+		goto out; /* OK? */
 
 	if (read_copy_data(in_handle, size, out_handle) < 0)
-		return -1;
-
+		goto error;
+out:
 	in_handle->file_state = TRACECMD_FILE_KALLSYMS;
+	if (out_compression_end(out_handle))
+		goto error;
+	out_set_file_state(out_handle, in_handle->file_state);
+
+	close_section(in_handle, sec);
+
+	if (out_update_section_header(out_handle, offset))
+		goto error;
 
 	return 0;
+error:
+	out_compression_reset(out_handle);
+	close_section(in_handle, sec);
+	return -1;
 }
 
 static int copy_ftrace_printk(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
+	struct file_section *sec;
+	unsigned long long offset;
 	unsigned int size;
 
-	if (in_handle->file_state != TRACECMD_FILE_PRINTK - 1)
+	if (!check_out_state(out_handle, TRACECMD_FILE_PRINTK))
 		return -1;
 
-	if (read_copy_size4(in_handle, out_handle, &size) < 0)
+	sec = open_section(in_handle, TRACECMD_OPTION_PRINTK);
+	if (!sec)
 		return -1;
+	offset = out_write_section_header(out_handle, TRACECMD_OPTION_PRINTK,
+					  "printk", TRACECMD_SEC_FL_COMPRESS, true);
+
+	out_compression_start(out_handle);
+
+	if (read_copy_size4(in_handle, out_handle, &size) < 0)
+		goto error;
 	if (!size)
-		return 0; /* OK? */
+		goto out; /* OK? */
 
 	if (read_copy_data(in_handle, size, out_handle) < 0)
-		return -1;
+		goto error;
 
+out:
 	in_handle->file_state = TRACECMD_FILE_PRINTK;
+	if (out_compression_end(out_handle))
+		goto error;
+	out_set_file_state(out_handle, in_handle->file_state);
+
+	close_section(in_handle, sec);
+
+	if (out_update_section_header(out_handle, offset))
+		goto error;
 
 	return 0;
+error:
+	out_compression_reset(out_handle);
+	close_section(in_handle, sec);
+	return -1;
 }
 
 static int copy_command_lines(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
+	struct file_section *sec;
+	unsigned long long offset;
 	unsigned long long size;
 
 	if (!check_out_state(out_handle, TRACECMD_FILE_CMD_LINES))
 		return -1;
 
-	if (read_copy_size8(in_handle, out_handle, &size) < 0)
+	sec = open_section(in_handle, TRACECMD_OPTION_CMDLINES);
+	if (!sec)
 		return -1;
+	offset = out_write_section_header(out_handle, TRACECMD_OPTION_CMDLINES,
+					  "command lines", TRACECMD_SEC_FL_COMPRESS, true);
+
+	out_compression_start(out_handle);
+
+	if (read_copy_size8(in_handle, out_handle, &size) < 0)
+		goto error;
 	if (!size)
-		return 0; /* OK? */
+		goto out; /* OK? */
 
 	if (read_copy_data(in_handle, size, out_handle) < 0)
-		return -1;
+		goto error;
 
+out:
 	in_handle->file_state = TRACECMD_FILE_CMD_LINES;
+	if (out_compression_end(out_handle))
+		goto error;
+	out_set_file_state(out_handle, in_handle->file_state);
+
+	close_section(in_handle, sec);
+
+	if (out_update_section_header(out_handle, offset))
+		goto error;
 
 	return 0;
+error:
+	out_compression_reset(out_handle);
+	close_section(in_handle, sec);
+	return -1;
 }
 
 /**
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 8499ab6f..9972185a 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2507,6 +2507,11 @@ out_free:
 	return NULL;
 }
 
+__hidden void out_set_file_state(struct tracecmd_output *handle, int new_state)
+{
+	handle->file_state = new_state;
+}
+
 __hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
 {
 	return check_file_state(handle->file_version, handle->file_state, new_state);
-- 
2.31.1

