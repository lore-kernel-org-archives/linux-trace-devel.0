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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4910CC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 366D360FDA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240007AbhIMMbZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240001AbhIMMbY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:24 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03177C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:09 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id w29so13650951wra.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f/jX6SRpFrvyLzi4+DpTWoPXPKzmOiYII5e8gVDj2Ig=;
        b=CPEdEfcRUp6N7Wg95O0+anMyUCRLJryBDABJCvCyAaPjDweEvzGEfnt03DgKZ57Mwb
         8XyD6RkCsQF8cSnDcFIG8kp9NQTvVl7PgKbav/sHFbj1NcdX4qshCv9UODJ8SVdnJBQl
         AB5bHHnAJlwq4nGopGIDdrWqG+259qRQSCzwGAqUcbHhXXPb50o4aRCVX2Y6QkHJk8AR
         L6UJMdxQiNWTf3IxmkxHethADPmQyOdmTJ128qQMc0v6Nqw1E3w83L3jqIaHM7iLStdH
         AAh6+Gf7u2aCTrLCe2v7KcVvxzU40kLozKXEvvzLyzqzKTHJd3A2z/WZfnl2WmQXx7PU
         O+kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f/jX6SRpFrvyLzi4+DpTWoPXPKzmOiYII5e8gVDj2Ig=;
        b=7SWDOVq2zmSjF+6dSHOsLyvMgOwblnuUhmnwv7YyFR6TTUHb1wNwfucqI2X9QHUkjq
         ph1Nue3q4Sq6y2MXb08ywD4wWxC55SAF+rle0gjPlUERPv+YaZqzjcyrSt3ZV7WNHZ90
         l6UWsWN0qZdlokUt+N6CH9DD7J3LoQqfEyvXnyKAakuHav3NqqwapfpzHS/ArEuoCi0J
         tVVKwRukCseMjAhCsQ1kdF96vnIn/LRZ8n3JSE7eu0JiJ8XtjmXnc1o2StWxxDyQ5eZf
         HFhdk+VxX58Qx7mcTnBVuvAegF8JhG3QdqEqbyICAe3SkPk5t59UGtWJCq9GSNI5rACA
         b11w==
X-Gm-Message-State: AOAM533ed7pI53PLofslGnwSs9JXeWYkmQ++ehjxOwILeoRqA4+0253e
        s5IpP3Y6lX6ipm/nHAJjfXxS9NOkJGQ=
X-Google-Smtp-Source: ABdhPJwIIh1R9FMpxUkCg2HiF8QJwK1uCOTwhVr69uyNGqHUrU/HPmLdK82oEGOScjK9SHLflU/R/g==
X-Received: by 2002:adf:8b03:: with SMTP id n3mr12257599wra.439.1631536207635;
        Mon, 13 Sep 2021 05:30:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:30:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 18/25] trace-cmd library: Read extended BUFFER option
Date:   Mon, 13 Sep 2021 15:29:40 +0300
Message-Id: <20210913122947.3673239-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
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
index 686655bd..f90d003d 100644
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
+	if (!HAS_SECTIONS(handle))
+		return 0;
+
+	/* file sections specific data */
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
@@ -3717,6 +3811,13 @@ void tracecmd_ref(struct tracecmd_input *handle)
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
@@ -3772,8 +3873,9 @@ void tracecmd_close(struct tracecmd_input *handle)
 		free(del_sec);
 	}
 
+	free_buffer(&handle->top_buffer);
 	for (i = 0; i < handle->nr_buffers; i++)
-		free(handle->buffers[i].name);
+		free_buffer(&handle->buffers[i]);
 	free(handle->buffers);
 
 	tracecmd_free_hooks(handle->hooks);
@@ -4217,6 +4319,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 		return NULL;
 
 	*new_handle = *handle;
+	memset(&new_handle->top_buffer, 0, sizeof(new_handle->top_buffer));
 	new_handle->cpu_data = NULL;
 	new_handle->nr_buffers = 0;
 	new_handle->buffers = NULL;
-- 
2.31.1

