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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F84C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B641611CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbhIJNwd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbhIJNwc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:32 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0581C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:21 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id n27so4410550eja.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hp58nxRaPnJoDg6NV4I4UoKt+saIlEVAyHUc1NKgw/U=;
        b=ZF7oyOl9N9V8Ju0avyxYkGFUt7d9Asc7Gcc0TBkJ2zsDabq7A7SBE70uN6Ko2INDZS
         DWLkDQgh/WdyDsEv2DT5ImfWuH4gXuKCV72JL0RJ+SJkNiVkSvH7GlQWuSlXSLWxPN0M
         Zy3gUFQJoabigGilC3FlXy1nAXvuQ8nopR+aA2rhMkNk4Buw9Ymkt8VQW2ozjKUphBfN
         H195JGtIy7YBNmF9XHN2dUz+h4/Oy1Malj9DRb2wVcnCWuZJzAEZdWufV9TWT7GLnWkP
         JcW+69rNTQhzck/tl/RyThMp7lSWR4qqYs+U5eKxQ2gYIm9pCcC3ysmQwsqARci3eeNP
         eVog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hp58nxRaPnJoDg6NV4I4UoKt+saIlEVAyHUc1NKgw/U=;
        b=nRU61cbm8cWtzy8gnCZX4IjgQ8FCaAyfqv//HzE2ZqaseFjkTDkc4bcEPatTdnwdQU
         G0XrL67JP2b4rwokWwFMAIrtIAWjnOTONxCWfxMamOTv7Q1Ls658JhrGPDrTB4u6OUGq
         qyKDkX5u+nMSb0oPF3WwwK9Y/rbJC6Q/ansIsLCG+4zoxrH5b+yiYcbwm3MthrVFGi3k
         cs8GmmXvetdYDouT1fKV2zq90av/IW4THviq+phcNRJPTSLA38AcvuXi4XObP38f+jPz
         MaDIAPjS2sA0ovMtVejFMXHeOCwxRCQS8fpfyM2LdCRnqhIspZmJ9yKOToQgZIJrx7wC
         rMAw==
X-Gm-Message-State: AOAM5319eyEo10tdGkITg2oOHZGjp8v1eGSLZYqVObWtamCPTwVQKbHH
        5bP0XUVUjBVVl9oaUvEJeZd/PTiRTDA=
X-Google-Smtp-Source: ABdhPJxBiSXCa7ZAzSeXlFf6jkWZNhx0X0z3wRIDx1yw5UyrLG5OFIXYgaLmSf2oEmhw95xmVfY/Lg==
X-Received: by 2002:a17:906:9989:: with SMTP id af9mr1841424ejc.480.1631281880418;
        Fri, 10 Sep 2021 06:51:20 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 18/25] trace-cmd library: Read extended BUFFER option
Date:   Fri, 10 Sep 2021 16:50:54 +0300
Message-Id: <20210910135101.2865226-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The BUFFER option is extended in trace file version 7. It holds CPU
metadata related to the recorded CPU traces. Also, there is a new
BUFFER_TEXT option for describing the latency trace data. A new logic
is implemented for these new options.
In trace file version 7, the top buffer is saved as other buffers in the
file, no special treatment. But saving the top buffer in the list of
buffers in the input handler causes problems. It breaks the legacy logic
of trace-cmd library users, which have special logic for trace buffers
processing. That's why "top_buffer" member is added in the input handler
structure, to hold the top buffer.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 137 +++++++++++++++++++++++++++++++-----
 1 file changed, 120 insertions(+), 17 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 0aa263ba..3f3b3c75 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -74,9 +74,19 @@ struct cpu_data {
 	int			pipe_fd;
 };
 
+struct cpu_file_data {
+	int			cpu;
+	unsigned long long	offset;
+	unsigned long long	size;
+};
+
 struct input_buffer_instance {
 	char			*name;
 	size_t			offset;
+	char			*clock;
+	bool			latency;
+	int			cpus;
+	struct cpu_file_data	*cpu_data;
 };
 
 struct ts_offset_sample {
@@ -152,6 +162,7 @@ struct tracecmd_input {
 	char *			uname;
 	char *			version;
 	char *			trace_clock;
+	struct input_buffer_instance	top_buffer;
 	struct input_buffer_instance	*buffers;
 	int			parsing_failures;
 	struct guest_trace_info	*guest;
@@ -2860,13 +2871,107 @@ tracecmd_search_task_map(struct tracecmd_input *handle,
 	return lib;
 }
 
+static inline int save_read_number(struct tep_handle *tep, char *data, int *data_size,
+				   int *read_pos, int bytes, unsigned long long *num)
+{
+	if (bytes > *data_size)
+		return -1;
+	*num = tep_read_number(tep, (data + *read_pos), bytes);
+	*read_pos += bytes;
+	*data_size -= bytes;
+	return 0;
+}
+
+static inline char *save_read_string(char *data, int *data_size, int *read_pos)
+{
+	char *str;
+
+	if (*data_size < 1)
+		return NULL;
+	str = strdup(data + *read_pos);
+	if (!str)
+		return NULL;
+	*data_size -= (strlen(str) + 1);
+	if (*data_size < 0) {
+		free(str);
+		return NULL;
+	}
+	*read_pos += (strlen(str) + 1);
+
+	return str;
+}
+
+static int handle_buffer_option(struct tracecmd_input *handle,
+				unsigned short id, char *data, int size)
+{
+	struct input_buffer_instance *buff;
+	unsigned long long tmp;
+	int rsize = 0;
+	char *name;
+	int i;
+
+	if (save_read_number(handle->pevent, data, &size, &rsize, 8, &tmp))
+		return -1;
+	name = save_read_string(data, &size, &rsize);
+	if (!name)
+		return -1;
+
+	if (*name == '\0') {
+		/* top buffer */
+		buff = &handle->top_buffer;
+	} else {
+		buff = realloc(handle->buffers, sizeof(*handle->buffers) * (handle->nr_buffers + 1));
+		if (!buff) {
+			free(name);
+			return -1;
+		}
+		handle->buffers = buff;
+		handle->nr_buffers++;
+
+		buff = &handle->buffers[handle->nr_buffers - 1];
+	}
+	memset(buff, 0, sizeof(struct input_buffer_instance));
+	buff->name = name;
+	buff->offset = tmp;
+	if (handle->file_version < 7)
+		return 0;
+
+	/* file version >= 7 specific data */
+	buff->clock = save_read_string(data, &size, &rsize);
+	if (!buff->clock)
+		return -1;
+	if (id == TRACECMD_OPTION_BUFFER) {
+		if (save_read_number(handle->pevent, data, &size, &rsize, 4, &tmp))
+			return -1;
+		buff->cpus = tmp;
+		if (!buff->cpus)
+			return 0;
+		buff->cpu_data = calloc(buff->cpus, sizeof(struct cpu_file_data));
+		if (!buff->cpu_data)
+			return -1;
+		for (i = 0; i < buff->cpus; i++) {
+			if (save_read_number(handle->pevent, data, &size, &rsize, 4, &tmp))
+				return -1;
+			buff->cpu_data[i].cpu = tmp;
+			if (save_read_number(handle->pevent, data,
+					     &size, &rsize, 8, &buff->cpu_data[i].offset))
+				return -1;
+			if (save_read_number(handle->pevent, data,
+					     &size, &rsize, 8, &buff->cpu_data[i].size))
+				return -1;
+		}
+	} else {
+		buff->latency = true;
+	}
+	return 0;
+}
+
 static int handle_options(struct tracecmd_input *handle)
 {
 	long long offset;
 	unsigned short option;
 	unsigned int size;
 	char *cpustats = NULL;
-	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
 	char *buf;
 	int cpus;
@@ -2955,21 +3060,10 @@ static int handle_options(struct tracecmd_input *handle)
 			handle->cpustats = cpustats;
 			break;
 		case TRACECMD_OPTION_BUFFER:
-			/* A buffer instance is saved at the end of the file */
-			handle->nr_buffers++;
-			handle->buffers = realloc(handle->buffers,
-						  sizeof(*handle->buffers) * handle->nr_buffers);
-			if (!handle->buffers)
-				return -ENOMEM;
-			buffer = &handle->buffers[handle->nr_buffers - 1];
-			buffer->name = strdup(buf + 8);
-			if (!buffer->name) {
-				free(handle->buffers);
-				handle->buffers = NULL;
-				return -ENOMEM;
-			}
-			offset = *(unsigned long long *)buf;
-			buffer->offset = tep_read_number(handle->pevent, &offset, 8);
+		case TRACECMD_OPTION_BUFFER_TEXT:
+			ret = handle_buffer_option(handle, option, buf, size);
+			if (ret < 0)
+				return ret;
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
 			if (!handle->ts2secs)
@@ -3719,6 +3813,13 @@ void tracecmd_ref(struct tracecmd_input *handle)
 	handle->ref++;
 }
 
+static inline void free_buffer(struct input_buffer_instance *buf)
+{
+	free(buf->name);
+	free(buf->clock);
+	free(buf->cpu_data);
+}
+
 /**
  * tracecmd_close - close and free the trace.dat handle
  * @handle: input handle for the trace.dat file
@@ -3774,8 +3875,9 @@ void tracecmd_close(struct tracecmd_input *handle)
 		free(del_sec);
 	}
 
+	free_buffer(&handle->top_buffer);
 	for (i = 0; i < handle->nr_buffers; i++)
-		free(handle->buffers[i].name);
+		free_buffer(&handle->buffers[i]);
 	free(handle->buffers);
 
 	tracecmd_free_hooks(handle->hooks);
@@ -4219,6 +4321,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 		return NULL;
 
 	*new_handle = *handle;
+	memset(&new_handle->top_buffer, 0, sizeof(new_handle->top_buffer));
 	new_handle->cpu_data = NULL;
 	new_handle->nr_buffers = 0;
 	new_handle->buffers = NULL;
-- 
2.31.1

