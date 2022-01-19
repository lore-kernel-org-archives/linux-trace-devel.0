Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B81F9C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352475AbiASI2z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiASI2y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:28:54 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD581C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:28:53 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id 30so7651796edv.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3bzdvwPhAO/CH1SWAZp/aqxzetzDxKLtkYepYwzKxrc=;
        b=iK9rRNyfVET0WFR9/sWy39FLMEzWm59TuallDU+6S7lEO4koAkVnoCN850wASHASMu
         9t4eSqeXEbtoYrzLBCjsjTCIkmi+KOGcKIIP26q8bE5goVg9e6zBictygQoCf+dwZJi4
         KLxLzr5bFhsGsdSkyfK8d0bxpHwJkKuxkALTtaNPlBvETYeMpuwk7dx2YL03b6MbfJYy
         Ftx3U9tckfjVFQdFKWMnn1WqPNSGVrIBrAB9f3DFb8QKaMNCo15uwipjhaPPMeAGVYI6
         MQQF9ATPJBjsQW2GBJCrg+HMgw+h8VlpOOKziZSDZIPUG5+C7msAtF+iBj+IvneY2aI0
         Q+3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3bzdvwPhAO/CH1SWAZp/aqxzetzDxKLtkYepYwzKxrc=;
        b=2oq2HMp14fI0RFxenIpg0Fa2u3Uh9xOj0j+L9K68PwbJUkF+r5bOm4g1NCT59WL2Vx
         sdijGcGPOj2qkoWvY7qo1MbFyZx2IYHdJ3Btjw7azvSgqBgGojh+D/xEDW42S10dhVQf
         sbge+KOSRDId1WMieGxv5nJSkHOHzLGQQieNPhYzhXI832Ef2oxDb0DygqvGbc/HMhVn
         a/1W1vNabIai5o8/ORGKI/FYnhI5DQwskOp50V4gWC+4lslMEITVEK8KjZG0AKbBh5qw
         xu+K5Yl43xLzruQ+Ol2Um9duUR0/D/M3keMBz825Iqk9iNHv6N3TIyUcjq8fHxKviZg6
         3pBA==
X-Gm-Message-State: AOAM533mSMPMK2jWeonrYI9SVXYhtEX7KHmUb/PnTpz5Fg849Os2aaoX
        LIp74WhHOx508LA9u8ybkSyotfA/yOg=
X-Google-Smtp-Source: ABdhPJxJkIbFNYnoQEqaoB6ABCNM0Tc/g5dy5T+/KoR37ekznDNE9hOmE6sg9M+Hv9M7w1/PqVpulg==
X-Received: by 2002:a05:6402:114e:: with SMTP id g14mr19224579edw.401.1642580932268;
        Wed, 19 Jan 2022 00:28:52 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t14sm860838edq.24.2022.01.19.00.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:28:51 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 6/9] trace-cmd library: New API to copy trace data between trace files
Date:   Wed, 19 Jan 2022 10:28:42 +0200
Message-Id: <20220119082845.245993-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082845.245993-1-tz.stoyanov@gmail.com>
References: <20220119082845.245993-1-tz.stoyanov@gmail.com>
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
index 5ed8278d..00d5a41a 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -199,6 +199,8 @@ int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
 			       struct tracecmd_output *out_handle);
 int tracecmd_copy_options(struct tracecmd_input *in_handle,
 			  struct tracecmd_output *out_handle);
+int tracecmd_copy_trace_data(struct tracecmd_input *in_handle,
+			     struct tracecmd_output *out_handle);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 85420fb1..48f179d6 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -68,6 +68,11 @@ int out_update_section_header(struct tracecmd_output *handle, unsigned long long
 
 long long do_write_check(struct tracecmd_output *handle, const void *data, long long size);
 
+struct tracecmd_option *
+out_add_buffer_option(struct tracecmd_output *handle, const char *name,
+		      unsigned short id, unsigned long long data_offset,
+		      int cpus, struct data_file_write *cpu_data);
+
 struct cpu_data_source {
 	int fd;
 	int size;
@@ -76,6 +81,7 @@ struct cpu_data_source {
 
 int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
 		       struct cpu_data_source *data, const char *buff_name);
+int out_write_emty_cpu_data(struct tracecmd_output *handle, int cpus);
 off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
 unsigned long long get_last_option_offset(struct tracecmd_input *handle);
 unsigned int get_meta_strings_size(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index aecf29a2..5056702a 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -5121,6 +5121,179 @@ int tracecmd_copy_options(struct tracecmd_input *in_handle,
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
+	    !out_add_buffer_option(out_handle, buf_name, TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
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
+	tracecmd_set_out_clock(out_handle, in_handle->trace_clock);
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
+	int ret = 0;
+	int i;
+
+	/* Force using temporary files for trace data decompression */
+	in_handle->read_zpage = false;
+	tracecmd_init_data(in_handle);
+	tracecmd_set_out_clock(out_handle, in_handle->trace_clock);
+
+	/* copy top buffer */
+	if (in_handle->top_buffer.latency)
+		ret = copy_trace_latency(in_handle, out_handle, in_handle->top_buffer.name);
+	else if (in_handle->top_buffer.cpus)
+		ret = copy_trace_flyrecord_data(in_handle, out_handle,
+						in_handle->top_buffer.name);
+	else if (tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS)
+		ret = out_write_emty_cpu_data(out_handle, in_handle->max_cpu);
+	if (ret)
+		return ret;
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
+
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
index 60df8d17..612cb63d 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2273,6 +2273,44 @@ static int update_buffer_cpu_offset_v6(struct tracecmd_output *handle,
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
2.34.1

