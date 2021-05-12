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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F362C43461
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13696613B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhELGjx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbhELGjx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:53 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E973DC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:44 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id f1so3472170edt.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nl8zn9xpnr7w2/VoLzRibtEBiv7NU2J3cESIglbFL/0=;
        b=Xebx9GhaOAfu5KimjMWcXyfS1VdMp3Wiy/oiLhVPjOc4XTJH2Nq9BSA+Vs7Z6TVB5f
         DmA5HuN1Hf2VBnpjsiWqiY/NGRQtzruuai/tfqTm178w6DqrbV69TWTRL8havYRTRKN7
         CQYs8OEm8ODPig4Dp6l3TNzkUw0Ios+vtVJ/RcbqBKQfjdTp1WWLMDL3qZhkKFbMbBVL
         qi36BkHfvBjC3gJbXzEm33NUQtwtDV8u4nxy4uRhfPsR/Xv2QSumGK3LnC843oyUbPrn
         T8Jw9Et9aNSekAmf/aH3fDz5oMHkUNbGItlba9EWzMevDf15qjiBTO/3zfCBfrfMv2ad
         WkOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nl8zn9xpnr7w2/VoLzRibtEBiv7NU2J3cESIglbFL/0=;
        b=UHBgkb2Nlsy8MTRLyQxHCOV6bsObQjXUcJ7WNYFQhpXnrRx2OpQ1UAg4cnCoikguWm
         g0Xsvnnl0lQGEJC9YQ/wDq/Oh/WYdnubmo1bWr9Go3Q1ltbL4lQLJwbaq41H7TpZ9Nx9
         kJe5FqNjwfsf8HU4uhNTOi6rfAOLjsZqzz9l5maUCO2i/xo2UAkpb9X9bAnarg1Podvw
         2nO+vNs3hSAlI0FPwX8UHY7O0yJoVxt8Po+dglBsNuR8wj2IliKi4V8VnDD9EwvOzdx6
         mWOl/p/nwd4o/m0mqanYmw/eH03Y7N/NHJViOijFNvw9VygbJt+1vW+94gmRAw6nYYeV
         E4Gw==
X-Gm-Message-State: AOAM532/pVw47vvABKOpKgYT9hx8OiQ7VyVB8z+6lib6o85FCNyNUlDp
        x0l5OWYCBr8S4FFe18Rv38U=
X-Google-Smtp-Source: ABdhPJwF9MQ4JiEoZaxnMBMcPOoXQZ/ZiN9VW7tglGT1pK+zwKZjVyohJ2CFbvXy1gwNBmSzHeA9rg==
X-Received: by 2002:aa7:cb43:: with SMTP id w3mr41143456edt.287.1620801523657;
        Tue, 11 May 2021 23:38:43 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:43 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 19/25] trace-cmd: Move buffers description outside of options
Date:   Wed, 12 May 2021 09:38:17 +0300
Message-Id: <20210512063823.324610-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a new buffer data are written in the trace file, the file offset is
stored in the buffer description. As the buffer description is part of
the trace options, which are already written in the file, the offset field
in this option is updated with the new value. This causes a serious
problem when option section of the file is compressed. Updating a value
in already compressed section may change the size of this section, which
can make the calculated offset of the buffer trace data invalid. To
solve that problem and to enable the compression of the option section
of the file, the structure of the trace file is changed:
 - In trace file v7, the description of the buffers is moved to a
   separate section in the trace file medatata. It is stored after the
   CPU count section and before the option section. The format of this
   new buffers description is:
    4 bytes - count of the buffers, stored in the file. The top buffer
      is not counted.
    For each buffer:
     8 bytes, offset of the trace data for this buffer in the file.
     null-terminated string, name of the buffer.
   The new section is mandatory, in case of no buffers - the count 0 is
   stored in the first 4 bytes.
 - In trace file v6, the description of the buffers is not changed.

These changes are needed for compression of the options sections from
the trace file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-input.c                   | 40 ++++++++++
 lib/trace-cmd/trace-output.c                  | 78 ++++++++++++++++++-
 tracecmd/trace-dump.c                         | 24 ++++++
 tracecmd/trace-listen.c                       |  3 +
 tracecmd/trace-record.c                       |  4 +
 6 files changed, 146 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 7d34f27b..d7488346 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -112,6 +112,7 @@ enum tracecmd_file_states {
 	TRACECMD_FILE_PRINTK,
 	TRACECMD_FILE_CMD_LINES,
 	TRACECMD_FILE_CPU_COUNT,
+	TRACECMD_FILE_BUFERS,
 	TRACECMD_FILE_OPTIONS,
 	TRACECMD_FILE_CPU_LATENCY,
 	TRACECMD_FILE_CPU_FLYRECORD,
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 9dff2188..5088a059 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -881,6 +881,39 @@ static int read_cpus(struct tracecmd_input *handle)
 	return 0;
 }
 
+static int read_buffers(struct tracecmd_input *handle)
+{
+	struct input_buffer_instance *buffer;
+	unsigned long long offset;
+	unsigned int count;
+	int i;
+
+	if (handle->file_version < 7 || handle->file_state >= TRACECMD_FILE_BUFERS)
+		return 0;
+
+	if (read4(handle, &count) < 0)
+		return -1;
+	i = handle->nr_buffers;
+	handle->nr_buffers += count;
+	handle->buffers = realloc(handle->buffers,
+				  sizeof(*handle->buffers) * handle->nr_buffers);
+	if (!handle->buffers)
+		return -1;
+
+	for (; i < handle->nr_buffers; i++) {
+		buffer = &handle->buffers[i];
+		if (read8(handle, &offset) < 0)
+			return -1;
+		buffer->offset = offset;
+		buffer->name = read_string(handle);
+		if (!buffer->name)
+			return -1;
+	}
+
+	handle->file_state = TRACECMD_FILE_BUFERS;
+	return 0;
+}
+
 /**
  * tracecmd_read_headers - read the header information from trace.dat
  * @handle: input handle for the trace.dat file
@@ -955,6 +988,13 @@ int tracecmd_read_headers(struct tracecmd_input *handle,
 	if (state <= handle->file_state)
 		return 0;
 
+	if (read_buffers(handle) < 0)
+		return -1;
+
+	if (state <= handle->file_state)
+		return 0;
+
+
 	if (read_options_type(handle) < 0)
 		return -1;
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index aa55a089..57b11493 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -376,6 +376,17 @@ static int check_out_state(struct tracecmd_output *handle, int new_state)
 	if (!handle)
 		return -1;
 
+	if (handle->file_version < 7) {
+		switch (new_state) {
+		case TRACECMD_FILE_BUFERS:
+			tracecmd_warning("State %d is not supported in trace file version %d",
+					 new_state, handle->file_version);
+			return -1;
+		default:
+			break;
+		}
+	}
+
 	switch (new_state) {
 	case TRACECMD_FILE_HEADERS:
 	case TRACECMD_FILE_FTRACE_EVENTS:
@@ -384,10 +395,16 @@ static int check_out_state(struct tracecmd_output *handle, int new_state)
 	case TRACECMD_FILE_PRINTK:
 	case TRACECMD_FILE_CMD_LINES:
 	case TRACECMD_FILE_CPU_COUNT:
-	case TRACECMD_FILE_OPTIONS:
+	case TRACECMD_FILE_BUFERS:
 		if (handle->file_state == (new_state - 1))
 			return 0;
 		break;
+	case TRACECMD_FILE_OPTIONS:
+		if (handle->file_version < 7 && handle->file_state == TRACECMD_FILE_CPU_COUNT)
+			return 0;
+		if (handle->file_version >= 7 && handle->file_state == TRACECMD_FILE_BUFERS)
+			return 0;
+		break;
 	case TRACECMD_FILE_CPU_LATENCY:
 	case TRACECMD_FILE_CPU_FLYRECORD:
 		if (handle->file_state == TRACECMD_FILE_OPTIONS)
@@ -1436,7 +1453,7 @@ int tracecmd_add_buffer_description(struct tracecmd_output *handle, const char *
 	return 0;
 }
 
-int tracecmd_write_buffers_description(struct tracecmd_output *handle)
+static int write_buffers_description_v6(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *option;
 	struct tracecmd_buffer *buf;
@@ -1450,6 +1467,56 @@ int tracecmd_write_buffers_description(struct tracecmd_output *handle)
 	return 0;
 }
 
+static int write_buffers_description_v7(struct tracecmd_output *handle)
+{
+	struct tracecmd_buffer *buf;
+	char *data = NULL;
+	int count = 0;
+	int size;
+	int ret;
+
+	ret = check_out_state(handle, TRACECMD_FILE_BUFERS);
+	if (ret < 0) {
+		tracecmd_warning("Cannot write buffers descriptions");
+		return ret;
+	}
+
+	list_for_each_entry(buf, &handle->buffers, list) {
+		count++;
+	}
+
+	count = convert_endian_4(handle, count);
+	ret = do_write_check(handle, &count, 4);
+	if (ret < 0)
+		return ret;
+
+	list_for_each_entry(buf, &handle->buffers, list) {
+		size = 8 + strlen(buf->name) + 1;
+		data = malloc(size);
+		if (!data)
+			goto error;
+		*(tsize_t *)data = 0;
+		strcpy(data + 8, buf->name);
+		/* Save the data location in case it needs to be updated */
+		buf->offset = do_lseek(handle, 0, SEEK_CUR);
+		if (do_write_check(handle, data, size))
+			goto error;
+	}
+
+	handle->file_state = TRACECMD_FILE_BUFERS;
+	return 0;
+error:
+	return -1;
+}
+
+int tracecmd_write_buffers_description(struct tracecmd_output *handle)
+{
+	if (handle->file_version >= 7)
+		return write_buffers_description_v7(handle);
+
+	return write_buffers_description_v6(handle);
+}
+
 static tsize_t get_buffer_file_offset(struct tracecmd_output *handle, const char *name)
 {
 	struct tracecmd_buffer *buf;
@@ -1508,7 +1575,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	if (tracecmd_write_cpus(handle, cpus) < 0)
 		goto out_free;
-
+	if (tracecmd_write_buffers_description(handle) < 0)
+		goto out_free;
 	if (tracecmd_write_options(handle) < 0)
 		goto out_free;
 
@@ -1701,7 +1769,9 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 	ret = tracecmd_write_cpus(handle, cpus);
 	if (ret)
 		return ret;
-
+	ret = tracecmd_write_buffers_description(handle);
+	if (ret)
+		return ret;
 	ret = tracecmd_write_options(handle);
 	if (ret)
 		return ret;
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index ed82104b..56acb01d 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -420,6 +420,29 @@ static void dump_cpus_count(int fd)
 	do_print(SUMMARY, "\t%d [CPUs with tracing data]\n", trace_cpus);
 }
 
+static void dump_buffers(int fd)
+{
+	unsigned long long offset;
+	char name[DUMP_SIZE];
+	int count;
+
+	if (file_version < 7)
+		return;
+
+	if (read_file_number(fd, &count, 4))
+		die("cannot read the buffers count");
+	do_print(SUMMARY, "\t%d [buffers with tracing data]\n", count);
+
+	while (count) {
+		if (read_file_number(fd, &offset, 8))
+			die("cannot read the buffer offset");
+		if (read_file_string(fd, name, DUMP_SIZE))
+			die("cannot read the buffer name");
+		do_print(SUMMARY, "\t\t 0x%llx %s[data offset, buffer name]\n", offset, name);
+		count--;
+	}
+}
+
 static void dump_option_string(int fd, int size, char *desc)
 {
 	do_print(OPTIONS, "\t\t[Option %s, %d bytes]\n", desc, size);
@@ -762,6 +785,7 @@ static void dump_file(const char *file)
 	dump_printk(fd);
 	dump_cmdlines(fd);
 	dump_cpus_count(fd);
+	dump_buffers(fd);
 	dump_therest(fd);
 
 	tep_free(tep);
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 0ae1c948..62debdb6 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -604,6 +604,9 @@ static int put_together_file(int cpus, int ofd, const char *node,
 
 	if (write_options) {
 		ret = tracecmd_write_cpus(handle, cpus);
+		if (ret)
+			goto out;
+		ret = tracecmd_write_buffers_description(handle);
 		if (ret)
 			goto out;
 		ret = tracecmd_write_options(handle);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e12d77cc..5516fe3a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3653,6 +3653,9 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		if (ret)
 			goto error;
 		ret = tracecmd_write_cpus(network_handle, instance->cpu_count);
+		if (ret)
+			goto error;
+		ret = tracecmd_write_buffers_description(network_handle);
 		if (ret)
 			goto error;
 		ret = tracecmd_write_options(network_handle);
@@ -3856,6 +3859,7 @@ static void setup_agent(struct buffer_instance *instance,
 	add_options(network_handle, ctx);
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
+	tracecmd_write_buffers_description(network_handle);
 	tracecmd_write_options(network_handle);
 	tracecmd_msg_finish_sending_data(instance->msg_handle);
 	instance->network_handle = network_handle;
-- 
2.31.1

