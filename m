Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5490BC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D91C61284
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbhKKPON (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbhKKPON (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:13 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E1CC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:24 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id g14so25472645edz.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hHfTm+q0hIJsvcA6EowC9GwJNGvO99FGPnegvkyEvUA=;
        b=YCWwxmPadIl/4t16099UoCs1ZCu23O7IssDU/WyqUKQ6pFJhjSjaB8P6HZVo2pffzT
         L/dJk6Gbe0X17aqjkHjwDZ+US5PfrF2u1hi/2voOuTvNqD4xgmIsVzN1XI6ST3FeiAtF
         gR6is3Vl40nl/ORR5TV1xob5KNUZ3BqRR7sHNLRxrbdLMPm9TeQtVNqdcGCYLRQhMX22
         +lgXNIV8t21H1Pilxxk/DiRhtUM4EBN1dgadoprc5C184ITiYv+JQrfsh5Smd1wcM6YS
         YK/+ID9QCt+fQb29cYwwv3I+zEx5NQ4sWaK7QnUkTlNAri+8XDIvr7NqsD3lPKXpn+Y+
         /foQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hHfTm+q0hIJsvcA6EowC9GwJNGvO99FGPnegvkyEvUA=;
        b=QR3+dF1dt7/liH72YJ/Kq3irfmyAtxljLqY7nfwPDT/5cXC5Qdkqdo0OJcoawrAkWp
         F1ofwZpptXHfoZynmwKoJt5Kt/TYN3T6+oHQmMgIYtJC0ckBqYFj5GMlcTV4+0ya+Sub
         zb+JOoqwu4MdKq7wa1j5WqwLkorKkq6LjQ//zjldFJRuh3cn5LzkPqY594TItGJy2Fuh
         H/uIZcqrwH/JyN6E201Gwgw5n1wKKHj4vUSAgmSuCpPzRs7igTicb+bWgJRiRQhf1WiT
         VSI+qZQ3y+4YCBYdLVuxrxNmHMEwyUnfSLMYdL5NR/q38Bg4LzcCTbHPI7WN0vBcojwT
         z3ow==
X-Gm-Message-State: AOAM533WbLZfXGQ/i30J5wTJEl/sZicef0apVImp3OGYLusXWvofB++w
        dRHysubobE3P/v+O/k+FBWQq1dvSWDQh9g==
X-Google-Smtp-Source: ABdhPJzXhbDTEkvE9lfTGM/sa/0j5fGoDZB9LzMPXX9/6ekhVUDfiK0aduumsAcIAFRi8Y/fbkr7Dw==
X-Received: by 2002:a17:907:7ea4:: with SMTP id qb36mr10641471ejc.146.1636643482215;
        Thu, 11 Nov 2021 07:11:22 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id nc30sm1648803ejc.35.2021.11.11.07.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:11:21 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 19/25] trace-cmd library: Handle the extended DONE option
Date:   Thu, 11 Nov 2021 17:11:12 +0200
Message-Id: <20211111151112.86751-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151112.86751-1-tz.stoyanov@gmail.com>
References: <20211111151112.86751-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7 the DONE option is extended to store the offset
in the file to the next options section. This way a list of options
sections can be stored in the file. Added logic to recursively read all
option sections from the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  1 +
 lib/trace-cmd/trace-input.c             | 42 +++++++++++++++++++++++--
 lib/trace-cmd/trace-output.c            |  2 +-
 3 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index d3760483..4b26960f 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -51,5 +51,6 @@ struct cpu_data_source {
 int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
 		       struct cpu_data_source *data, const char *buff_name);
 off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
+unsigned long long get_last_option_offset(struct tracecmd_input *handle);
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 5644cbb1..06f31679 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -176,6 +176,7 @@ struct tracecmd_input {
 	struct file_section	*sections;
 	bool			options_init;
 	unsigned long long	options_start;
+	unsigned long long	options_last_offset;
 	size_t			total_file_size;
 
 	/* For custom profilers. */
@@ -2858,6 +2859,30 @@ tracecmd_search_task_map(struct tracecmd_input *handle,
 	return lib;
 }
 
+__hidden unsigned long long get_last_option_offset(struct tracecmd_input *handle)
+{
+	return handle->options_last_offset;
+}
+
+static int handle_option_done(struct tracecmd_input *handle, char *buf, int size)
+{
+	unsigned long long offset;
+
+	if (size < 8)
+		return -1;
+	offset = lseek64(handle->fd, 0, SEEK_CUR);
+	if (offset >= size)
+		handle->options_last_offset = offset - size;
+	offset = tep_read_number(handle->pevent, buf, 8);
+	if (!offset)
+		return 0;
+
+	if (lseek64(handle->fd, offset, SEEK_SET) == (off_t)-1)
+		return -1;
+
+	return handle_options(handle);
+}
+
 static inline int save_read_number(struct tep_handle *tep, char *data, int *data_size,
 				   int *read_pos, int bytes, unsigned long long *num)
 {
@@ -2960,19 +2985,27 @@ static int handle_options(struct tracecmd_input *handle)
 	long long offset;
 	unsigned short option;
 	unsigned int size;
+	unsigned short id, flags;
 	char *cpustats = NULL;
 	struct hook_list *hook;
 	char *buf;
 	int cpus;
 	int ret;
 
-	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
+	if (!HAS_SECTIONS(handle)) {
+		handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
+	} else {
+		if (read_section_header(handle, &id, &flags, NULL, NULL))
+			return -1;
+		if (id != TRACECMD_OPTION_DONE)
+			return -1;
+	}
 
 	for (;;) {
 		if (read2(handle, &option))
 			return -1;
 
-		if (option == TRACECMD_OPTION_DONE)
+		if (!HAS_SECTIONS(handle) && option == TRACECMD_OPTION_DONE)
 			break;
 
 		/* next 4 bytes is the size of the option */
@@ -3112,7 +3145,10 @@ static int handle_options(struct tracecmd_input *handle)
 			section_add_or_update(handle, option, -1,
 					      tep_read_number(handle->pevent, buf, 8), 0);
 			break;
-
+		case TRACECMD_OPTION_DONE:
+			ret = handle_option_done(handle, buf, size);
+			free(buf);
+			return ret;
 		default:
 			tracecmd_warning("unknown option %d", option);
 			break;
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 2ed7155b..1d666775 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2154,7 +2154,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	tep_ref(handle->pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
-	handle->options_start = tracecmd_get_options_offset(ihandle);
+	handle->options_start = get_last_option_offset(ihandle);
 	list_head_init(&handle->options);
 	list_head_init(&handle->buffers);
 
-- 
2.33.1

