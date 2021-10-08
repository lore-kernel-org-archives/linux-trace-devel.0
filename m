Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB92C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77DEB60F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhJHE1P (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhJHE1O (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:27:14 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D029C061755
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:25:20 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g10so30405799edj.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C73UR9CHgiHdyCoTYajArZtbw2p3x1T5aEwlJru5qZw=;
        b=QWCrnzE7k7Po022ffTyyIvUerCnHZRcLuB2MIouMmuSlLq8pHhKi3KSDl98wyN72JI
         NhLTAVdT5mDjYxRHUmlBWVa39wC5or5gzz7LbUctDXD4WWud02ERZ/kHqzFGWuO0Mzj6
         w3mVk2Tw41R8bF9OOrbCxa4rsNmezGr+TAGi043ie9VUz22DzTkd8DZIwAgfE1qfDj5e
         5prC/7VMOF7xR2+0lSV2N3XB2ISDVSkhwGs9aWtztGlUoUEAy9hKJqHfI095UWwgWuJw
         7C8Ga81ckCWkSW77hmrbL9xSDzLvZb4NORIZB1qR7k8+hzWiNKeGWrU0sqzFrDZDmkFr
         MgxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C73UR9CHgiHdyCoTYajArZtbw2p3x1T5aEwlJru5qZw=;
        b=PRN3kyRh8v0r4+mbpWG2ERxTzBDnv16k8cC+q+nSa06MlTRtJz/yGvmdWO94vyrdZy
         HmyrUqI1JinKBaC1TpA6Gar+ZQBkrTpmMXBFW+bUG4Lj/CQH6ynrJLYxd3qopl2AdtOs
         0k2J91oeXu48VUdEel94bBvw3URF2kURj6VHj5j03GMQt7mD6XoJga5zXEMCb7zHtDpL
         fNdSRqElkwL7NpqB+zdyAgvTFl9BIF+/39go9VS9Sk5apCtjMLivouw3CRngFJJ4CTZE
         ETWBVhU0YVmClTs89MWCRW3te27Y4VIQA8qotZxvtg9vZ51U2FIADklnVVAAwEU4PHWH
         a+wA==
X-Gm-Message-State: AOAM531kXFX2J11loKXGx2JYir5eakvJz9vS3omX9zzI7yjVUxOE1PLy
        3PCwyh9ISCSnzsbd4p07GHZN0Do2Ppi9Gg==
X-Google-Smtp-Source: ABdhPJxaTF3PQK96UfvaVwHvm0+tDHOWjaPknu6QhlnmgzuadGXRixs/kN7MSf8a/p99uV3373Zb+Q==
X-Received: by 2002:a17:906:27cb:: with SMTP id k11mr1298526ejc.140.1633667118596;
        Thu, 07 Oct 2021 21:25:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e7sm506320edz.95.2021.10.07.21.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:25:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 6/8] trace-cmd library: New API to copy trace data between trace files
Date:   Fri,  8 Oct 2021 07:25:08 +0300
Message-Id: <20211008042510.978362-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042510.978362-1-tz.stoyanov@gmail.com>
References: <20211008042510.978362-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c                   | 173 ++++++++++++++++++
 lib/trace-cmd/trace-output.c                  |  38 ++++
 4 files changed, 219 insertions(+)

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
index 0dba4b58..638b993c 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -66,6 +66,11 @@ int out_update_section_header(struct tracecmd_output *handle, unsigned long long
 
 long long do_write_check(struct tracecmd_output *handle, const void *data, long long size);
 
+struct tracecmd_option *
+out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
+			 unsigned short id, unsigned long long data_offset,
+			 int cpus, struct data_file_write *cpu_data);
+
 struct cpu_data_source {
 	int fd;
 	int size;
@@ -74,6 +79,7 @@ struct cpu_data_source {
 
 int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
 		       struct cpu_data_source *data, const char *buff_name);
+int out_write_emty_cpu_data(struct tracecmd_output *handle, int cpus);
 off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
 unsigned long long get_last_option_offset(struct tracecmd_input *handle);
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 1f99c5b8..3140d50f 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -5043,6 +5043,179 @@ int tracecmd_copy_options(struct tracecmd_input *in_handle,
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
+	int cpus;
+	int ret;
+	int i, j;
+
+	if (tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS)
+		cpus = in_handle->max_cpu;
+	else
+		cpus = in_handle->cpus;
+
+	data = calloc(cpus, sizeof(struct cpu_data_source));
+	if (!data)
+		return -1;
+	for (i = 0; i < in_handle->cpus; i++) {
+		j = in_handle->cpu_data[i].cpu;
+		data[j].size = in_handle->cpu_data[i].file_size;
+		total_size += data[j].size;
+		if (in_handle->cpu_data[i].compress.fd >= 0) {
+			data[j].fd = in_handle->cpu_data[i].compress.fd;
+			data[j].offset = 0;
+		} else {
+			data[j].fd = in_handle->fd;
+			data[j].offset = in_handle->cpu_data[i].file_offset;
+		}
+	}
+	if (total_size || tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS)
+		ret = out_write_cpu_data(out_handle, cpus, data, buff_name);
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
index a66637aa..49104527 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2162,6 +2162,44 @@ static int update_buffer_cpu_offset_v6(struct tracecmd_output *handle,
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

