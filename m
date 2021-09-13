Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBACCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C33EF6101B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhIMMtW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235933AbhIMMtS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:49:18 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E50C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:48:03 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id i3so6572736wmq.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=feCVGlTfCqkMNX7xuX3pLK7rOhc4wmoLC7irXhcqNaM=;
        b=LRY67PrrICnRuRhn98Hs6hSuQykALWvzh3nQ7xbd2aXFoAHnQah4gIedkY9h52k9Us
         ov8CDMFOdIRSI7d8FKME0oTKMo794I2Ou7EFzUA9U5bMsps72XiNJLLf97+jTlX4UX5p
         cnVaMlV2qCkWS5CrboJPYmLRxYdKBx6q3Z4AWiypadAEvzpvsEbkQTSQVOcNeKPlWWUN
         3GJRzrNsjmdBgFjD5hPmoydkI+McSrvMdCBUhqzqRfSwNL7hKf4zohK5vTJooQmV7lfb
         xT/EkM/SGp+9cEIuw+FVD+Jrrcju9sSV8wsutd55/KiGSePFBdE/3/GAehd8v3+0qoHz
         E4Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=feCVGlTfCqkMNX7xuX3pLK7rOhc4wmoLC7irXhcqNaM=;
        b=lMtOsd56V+5wT814mlbou0POrD2O89aATPMEhG/fnhazPoRA6jdNZN1LaHr/lAgw3O
         CKq/oqp/qN6vg7MWDfENfJmMUcsksoR10AwQ381A6kcs4CNWDQdcDitVBWEhTgx7VyUM
         E1GcflAeG4Vd8GIKEOEITYvkP6OJIuq4zsgxu3X1MfnU3tXeRc7R/WYe7y8rNPieaX7q
         GwfvBUS231rRL/yt+f/o3nOaDMCki/Ou+FWEU2/b0r6XR6Cgp7ULK57w6e3+WiCUDTTB
         PP+TJLtknvcThRPWrs6BcnSDr2Ilek9W47vdLVV2drOb725xkS24yZYNhO405Bf1MZBe
         NTuA==
X-Gm-Message-State: AOAM530kOEzNaTPrMMQUhsLr1yt5NF0q8ePZR4Wo9qitK5wwupmdvIIC
        wGXn19Wxn0yYTCCVVEYNzTAWAL1C4Zs=
X-Google-Smtp-Source: ABdhPJzUO3UshmuON2x9/rKrWxxykgP3w0p7GWx1ufLz7cvE3A+ipYunbSz9NaSe3WV16psZSbQqZw==
X-Received: by 2002:a05:600c:3790:: with SMTP id o16mr10970413wmr.157.1631537281619;
        Mon, 13 Sep 2021 05:48:01 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm7718077wmj.0.2021.09.13.05.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:48:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 6/8] trace-cmd library: New API to copy trace data between trace files
Date:   Mon, 13 Sep 2021 15:47:52 +0300
Message-Id: <20210913124754.3679916-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913124754.3679916-1-tz.stoyanov@gmail.com>
References: <20210913124754.3679916-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new library API is introduced, to copy trace data between trace files:
	tracecmd_copy_trace_data()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |   2 +
 lib/trace-cmd/include/trace-cmd-local.h       |   6 +
 lib/trace-cmd/trace-input.c                   | 166 ++++++++++++++++++
 lib/trace-cmd/trace-output.c                  |  38 ++++
 4 files changed, 212 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index e68f75b8..2c373030 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -193,6 +193,8 @@ int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
 			       struct tracecmd_output *out_handle);
 int tracecmd_copy_options(struct tracecmd_input *in_handle,
 			  struct tracecmd_output *out_handle);
+int tracecmd_copy_trace_data(struct tracecmd_input *in_handle,
+			     struct tracecmd_output *out_handle);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 706ba250..6c4132f2 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -64,6 +64,11 @@ int out_update_section_header(struct tracecmd_output *handle, unsigned long long
 
 long long do_write_check(struct tracecmd_output *handle, const void *data, long long size);
 
+struct tracecmd_option *
+out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
+			 unsigned short id, unsigned long long data_offset,
+			 int cpus, struct data_file_write *cpu_data);
+
 struct cpu_data_source {
 	int fd;
 	int size;
@@ -72,6 +77,7 @@ struct cpu_data_source {
 
 int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
 		       struct cpu_data_source *data, const char *buff_name);
+int out_write_emty_cpu_data(struct tracecmd_output *handle, int cpus);
 off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
 unsigned long long get_last_option_offset(struct tracecmd_input *handle);
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 2e5e9bcc..7a0102fa 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -5051,6 +5051,172 @@ int tracecmd_copy_options(struct tracecmd_input *in_handle,
 	return 0;
 }
 
+static int copy_trace_latency(struct tracecmd_input *in_handle,
+			      struct tracecmd_output *out_handle, const char *buf_name)
+{
+	unsigned long long wsize;
+	unsigned long long offset;
+	int fd;
+
+	if (tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS &&
+	    do_write_check(out_handle, "latency  ", 10))
+		return -1;
+
+	offset = tracecmd_get_out_file_offset(out_handle);
+
+	if (tracecmd_get_out_file_version(out_handle) >= FILE_VERSION_SECTIONS &&
+	    !out_add_buffer_option_v7(out_handle, buf_name, TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
+		return -1;
+
+	offset = out_write_section_header(out_handle, TRACECMD_OPTION_BUFFER_TEXT,
+					  "buffer latency", TRACECMD_SEC_FL_COMPRESS, false);
+
+	if (in_handle->latz.fd >= 0)
+		fd = in_handle->latz.fd;
+	else
+		fd = in_handle->fd;
+
+	if (!out_copy_fd_compress(out_handle, fd, 0, &wsize))
+		return -1;
+	if (out_update_section_header(out_handle, offset))
+		return -1;
+
+	out_set_file_state(out_handle, TRACECMD_FILE_CPU_LATENCY);
+	return 0;
+}
+
+static int copy_trace_flyrecord_data(struct tracecmd_input *in_handle,
+				     struct tracecmd_output *out_handle, const char *buff_name)
+{
+	struct cpu_data_source *data;
+	int total_size = 0;
+	int ret;
+	int i;
+
+	data = calloc(in_handle->cpus, sizeof(struct cpu_data_source));
+	if (!data)
+		return -1;
+	for (i = 0; i < in_handle->cpus; i++) {
+		data[i].size = in_handle->cpu_data[i].file_size;
+		total_size += data[i].size;
+		if (in_handle->cpu_data[i].compress.fd >= 0) {
+			data[i].fd = in_handle->cpu_data[i].compress.fd;
+			data[i].offset = 0;
+		} else {
+			data[i].fd = in_handle->fd;
+			data[i].offset = in_handle->cpu_data[i].file_offset;
+		}
+	}
+	if (total_size || tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS)
+		ret = out_write_cpu_data(out_handle, in_handle->cpus, data, buff_name);
+	else
+		ret = 0;
+	free(data);
+
+	return ret;
+}
+
+static int copy_flyrecord_buffer(struct tracecmd_input *in_handle,
+				 struct tracecmd_output *out_handle, int index)
+{
+	struct tracecmd_input *instance;
+	const char *name;
+	int ret;
+
+	name = tracecmd_buffer_instance_name(in_handle, index);
+	if (!name)
+		return -1;
+
+	instance = tracecmd_buffer_instance_handle(in_handle, index);
+	if (!instance)
+		return -1;
+	if (!tracecmd_get_quiet(out_handle) && *name)
+		fprintf(stderr, "\nBuffer: %s\n\n", name);
+
+	if (in_handle->buffers[index].latency)
+		ret = copy_trace_latency(in_handle, out_handle, name);
+	else
+		ret = copy_trace_flyrecord_data(instance, out_handle, name);
+	tracecmd_close(instance);
+
+	return ret;
+}
+
+static int copy_trace_data_from_v6(struct tracecmd_input *in_handle,
+				   struct tracecmd_output *out_handle)
+{
+	char buf[10];
+	int ret;
+	int i;
+
+	if (do_read_check(in_handle, buf, 10))
+		return -1;
+
+	if (strncmp(buf, "latency", 7) == 0)
+		in_handle->file_state = TRACECMD_FILE_CPU_LATENCY;
+	else if (strncmp(buf, "flyrecord", 9) == 0)
+		in_handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
+
+	tracecmd_init_data(in_handle);
+
+	if (in_handle->file_state == TRACECMD_FILE_CPU_LATENCY)
+		return copy_trace_latency(in_handle, out_handle, "");
+
+	/* top instance */
+	ret = copy_trace_flyrecord_data(in_handle, out_handle, "");
+	if (ret)
+		return ret;
+
+	for (i = 0; i < in_handle->nr_buffers; i++)
+		copy_flyrecord_buffer(in_handle, out_handle, i);
+	return 0;
+}
+
+static int copy_trace_data_from_v7(struct tracecmd_input *in_handle,
+				   struct tracecmd_output *out_handle)
+{
+	int ret;
+	int i;
+
+	/* Force using temporary files for trace data decompression */
+	in_handle->read_zpage = false;
+	tracecmd_init_data(in_handle);
+
+	if (tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS) {
+		/* copy top buffer in v6 files */
+		if (in_handle->top_buffer.latency)
+			ret = copy_trace_latency(in_handle, out_handle, in_handle->top_buffer.name);
+		else if (in_handle->top_buffer.cpus)
+			ret = copy_trace_flyrecord_data(in_handle, out_handle,
+							in_handle->top_buffer.name);
+		else
+			ret = out_write_emty_cpu_data(out_handle, in_handle->max_cpu);
+		if (ret)
+			return ret;
+	}
+
+	for (i = 0; i < in_handle->nr_buffers; i++)
+		copy_flyrecord_buffer(in_handle, out_handle, i);
+
+	return 0;
+}
+
+__hidden int tracecmd_copy_trace_data(struct tracecmd_input *in_handle,
+				      struct tracecmd_output *out_handle)
+{
+	int ret;
+
+	if (!check_in_state(in_handle, TRACECMD_FILE_CPU_FLYRECORD) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_CPU_FLYRECORD))
+		return -1;
+	tracecmd_set_out_clock(out_handle, in_handle->trace_clock);
+	if (in_handle->file_version < FILE_VERSION_SECTIONS)
+		ret = copy_trace_data_from_v6(in_handle, out_handle);
+	else
+		ret = copy_trace_data_from_v7(in_handle, out_handle);
+	return ret;
+}
+
 /**
  * tracecmd_record_at_buffer_start - return true if record is first on subbuffer
  * @handle: input handle for the trace.dat file
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 8021ffb6..53bd0209 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2165,6 +2165,44 @@ static int update_buffer_cpu_offset_v6(struct tracecmd_output *handle,
 	return 0;
 }
 
+__hidden int out_write_emty_cpu_data(struct tracecmd_output *handle, int cpus)
+{
+	unsigned long long zero = 0;
+	char *clock;
+	int ret;
+	int i;
+
+	if (HAS_SECTIONS(handle))
+		return 0;
+
+	ret = handle->file_state == TRACECMD_FILE_CPU_FLYRECORD ? 0 :
+				    check_file_state(handle->file_version,
+						     handle->file_state,
+						     TRACECMD_FILE_CPU_FLYRECORD);
+	if (ret < 0) {
+		tracecmd_warning("Cannot write trace data into the file, unexpected state 0x%X",
+				 handle->file_state);
+		return ret;
+	}
+
+	if (do_write_check(handle, "flyrecord", 10))
+		return -1;
+
+	for (i = 0; i < cpus; i++) {
+		/* Write 0 for trace data offset and size */
+		if (do_write_check(handle, &zero, 8))
+			return -1;
+		if (do_write_check(handle, &zero, 8))
+			return -1;
+	}
+	clock = get_clock(handle);
+	if (clock && save_clock(handle, clock))
+		return -1;
+	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
+	return 0;
+}
+
+
 __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 				int cpus, struct cpu_data_source *data, const char *buff_name)
 {
-- 
2.31.1

