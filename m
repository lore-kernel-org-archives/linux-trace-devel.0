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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 374D7C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2261D61053
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbhG2FKx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbhG2FKx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:53 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EF0C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:49 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id e19so8425788ejs.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kABucYEO7dOvb7r+JsA5gtzuFjCQLI9a7krKmnsAwxs=;
        b=PgRjH3ykVorUaa8pZutryKbRE4KY0HiF5QX4ZeVLTiyq7blj7j6tnBNOeiOqxa47+S
         6kearyBPxAFR3L34WFd9VuZCNJ3quWAbOa4Zc4N2xCWERTZHNDXU7dFoxqoyLf7rY5vz
         lPKLuLd5g6bzMaEwv3+dfWZ/uzL5K6vhDE6B4B1D/NryMyR35Ht9QBZ2M9fDhBoK+O+J
         g2LKNiJlVHmSrXqDRA6DZRsFJrzyV0H7WjCT+xQ0aH+UrEMP7Luo665ictQ7mND27Oxz
         PYw/FQ5nqUuQrWm7gX9sjKQ4fhuB8MVIjCL9opyjJtB/IiUlkwoHFiz3P02DTsD0WRBD
         wvDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kABucYEO7dOvb7r+JsA5gtzuFjCQLI9a7krKmnsAwxs=;
        b=mRG2NcK9fyCPoFeinfYrtW7bI9crumBaK92+ESn3NkTlw4tleFgD/45N5AIo2qghmH
         keVC0ix+SSkKxH8z8Cne+CJGx0V0GAdB0LgjpYyBeS7YYssNXqFmVqWhbOoPMS9ZdVXN
         4n6oZFb118m+ZAXgeQttoduDkr695fRY80a6ck8J1fpPt/iw6fmpHoF/GR8UgXxXq6d5
         wOlWrA6eciUVrKe0QcHG3r8tRkWOP4Mcu4JZaSM6qIHzTgE4UrLsdbuRDMKIG1mTtybf
         uXe4GCa3+TkBE2GW0rBIV27bKczT1xHxOPh2gI1GMKSqJk1TnGiXDrsAu4o2gGrBuc1g
         wqvA==
X-Gm-Message-State: AOAM5329iPV/n71pd94lJE0Z5+SC2rTJx8EA2EpFqqf1AUF+1g+unyO0
        lInHMk+T1QtcvTvAH5JTwXU=
X-Google-Smtp-Source: ABdhPJxAjsCqBwl6ze96wYPjk4UYGeDDsdTqoBeLZlOFElwWV7WupP1vyiOFT9T3A31TdnXfZTmTAg==
X-Received: by 2002:a17:906:1416:: with SMTP id p22mr2848040ejc.364.1627535448283;
        Wed, 28 Jul 2021 22:10:48 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:47 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 48/87] trace-cmd library: Read extended BUFFER option
Date:   Thu, 29 Jul 2021 08:09:20 +0300
Message-Id: <20210729050959.12263-49-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The BUFFER option is extended in trace file version 7. It holds CPU
metadata related to the recorded CPU traces. Also, there is a new
BUFFER_LAT option for describing the latency trace data. A new logic
is implemented for these new options.
In trace file version 7, the top buffer is saved as other buffers in the
file, no special treatment. But saving the top buffer in the list of
buffers in the input handler causes problems. It breaks the legacy logic
of trace-cmd library users, which have special logic for trace buffers
processing. That's why "top_buffer" member is added in the input handler
structure, to hold the top buffer.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 116 ++++++++++++++++++++++++++++++------
 1 file changed, 98 insertions(+), 18 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e7f97561..57ae535a 100644
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
@@ -155,6 +165,7 @@ struct tracecmd_input {
 	char *			uname;
 	char *			version;
 	char *			trace_clock;
+	struct input_buffer_instance	top_buffer;
 	struct input_buffer_instance	*buffers;
 	int			parsing_failures;
 	struct guest_trace_info	*guest;
@@ -2904,6 +2915,80 @@ tracecmd_search_task_map(struct tracecmd_input *handle,
 	return lib;
 }
 
+#define save_read_number(R, C)							\
+	do {									\
+		if ((C) > size)							\
+			return -1;						\
+		(R) = tep_read_number(handle->pevent, (data + rsize), (C));	\
+		rsize += (C);							\
+		size -= (C);							\
+	} while (0)
+
+#define save_read_string(R)			\
+	do {					\
+		if (size < 1)			\
+			return -1;		\
+		(R) = strdup(data + rsize);	\
+		if (!(R))			\
+			return -1;		\
+		rsize += (strlen((R)) + 1);	\
+		size -= (strlen((R)) + 1);	\
+		if (size < 0)			\
+			return -1;		\
+	} while (0)
+
+static int handle_buffer_option(struct tracecmd_input *handle,
+				unsigned short id, char *data, int size)
+{
+	struct input_buffer_instance *buff;
+	unsigned long long offset;
+	int rsize = 0;
+	char *name;
+	int i;
+
+	save_read_number(offset, 8);
+	save_read_string(name);
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
+	buff->offset = offset;
+	if (handle->file_version < 7)
+		return 0;
+
+	/* file version >= 7 specific data */
+	save_read_string(buff->clock);
+	if (id == TRACECMD_OPTION_BUFFER) {
+		save_read_number(buff->cpus, 4);
+		if (!buff->cpus)
+			return 0;
+		buff->cpu_data = calloc(buff->cpus, sizeof(struct cpu_file_data));
+		if (!buff->cpu_data)
+			return -1;
+		for (i = 0; i < buff->cpus; i++) {
+			save_read_number(buff->cpu_data[i].cpu, 4);
+			save_read_number(buff->cpu_data[i].offset, 8);
+			save_read_number(buff->cpu_data[i].size, 8);
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
@@ -2911,7 +2996,6 @@ static int handle_options(struct tracecmd_input *handle)
 	unsigned int size;
 	unsigned short id, flags;
 	char *cpustats = NULL;
-	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
 	bool comperss = false;
 	char *buf;
@@ -3016,21 +3100,10 @@ static int handle_options(struct tracecmd_input *handle)
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
+		case TRACECMD_OPTION_BUFFER_LAT:
+			ret = handle_buffer_option(handle, option, buf, size);
+			if (ret < 0)
+				goto out;
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
 			if (!handle->ts2secs)
@@ -3825,9 +3898,15 @@ void tracecmd_close(struct tracecmd_input *handle)
 		handle->sections = handle->sections->next;
 		free(del_sec);
 	}
-	for (i = 0; i < handle->nr_buffers; i++)
-		free(handle->buffers[i].name);
 
+	free(handle->top_buffer.name);
+	free(handle->top_buffer.clock);
+	free(handle->top_buffer.cpu_data);
+	for (i = 0; i < handle->nr_buffers; i++) {
+		free(handle->buffers[i].name);
+		free(handle->buffers[i].clock);
+		free(handle->buffers[i].cpu_data);
+	}
 	free(handle->buffers);
 
 	tracecmd_free_hooks(handle->hooks);
@@ -4272,6 +4351,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 		return NULL;
 
 	*new_handle = *handle;
+	memset(&new_handle->top_buffer, 0, sizeof(new_handle->top_buffer));
 	new_handle->cpu_data = NULL;
 	new_handle->nr_buffers = 0;
 	new_handle->buffers = NULL;
-- 
2.31.1

