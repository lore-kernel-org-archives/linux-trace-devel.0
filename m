Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA4DC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbhLJLGg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbhLJLGg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:06:36 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B62DC061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:03:01 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id r25so28221740edq.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T7Tt0E+YY6s8yL4qviI+IybjyR0hMInAnAdVD243LTk=;
        b=LPqrdfVx7ZMLgbmlHhv9MShNwefLKciYNzOpN1VeKUvlegU5t8oaf/Bq6R33dajx2G
         rt7o0PcbXOFUeE5eCvJEmTUH3ucWk+rJRUwFgClDHG4VNoPYmL+0HxkqObh7ENbKtLHa
         XYdMQ86x/wuLWts7tujO2TkW2hN8XPQy93Op7Rku93DQSjPAZzmGcYuJEmVz4pnq2Rjt
         drDL6xOOGfFGelzkdHzcZ704gLnZi+hF7ZOc6AmXdZpqVnnJsu3OhiedZOQ8jbDarZlH
         UNxhV2G/55RLmq+rNoFhR3/Bu4tc/+vuCjSwekKMSXWLyq1Zq7oaJHrqrtOYopiX/cB2
         NFZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T7Tt0E+YY6s8yL4qviI+IybjyR0hMInAnAdVD243LTk=;
        b=pO5e2SBz7GIzzrCIzUgb7kTXgwOIt3hJcJiteB4N4GfiApianvUrZlgb8XlEUgfGJa
         4Y3TKOoJmvp8jMlBa/vHGqwtrypzRXhkL3bVWyBQxs5LoOGxeMuKedIaBLRhvd4pBHru
         DUEFVdg0pcEc8pfP0DWSUuUcXNkT01QXGMfhNlvcjnVZkvLyYZd1TGZMxiMkO5ElElaR
         sLA+t70DWp4LRUp2985nvX2Iayo1hvTIbxI+QYDbISNIF8P2gsrv7ZLOUNon6++jeBoa
         Nkjdd7zdHiAT/sOf334/i1W60QTMNlDcegXffnjciHEoIHmu16fVthOUObi4ChDkJ8f8
         wQtw==
X-Gm-Message-State: AOAM531lrBY6JYQ7Lj1czK2YqVzY/2Qux139DAQkKsjSDq9Ck4d0VUzk
        PEG0U1PF228CjURFpl6QSYeJwyN8nIE=
X-Google-Smtp-Source: ABdhPJz4RtbI4wcaslxmXQvFNrL2n/B+ZV4jimoMTiYnWuqxecmNPWucR870GKYcD3sTJ0PJ0llRtg==
X-Received: by 2002:a05:6402:5188:: with SMTP id q8mr38566133edd.181.1639134179552;
        Fri, 10 Dec 2021 03:02:59 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id sg39sm1275269ejc.66.2021.12.10.03.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:02:59 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 6/9] trace-cmd library: New API to copy trace data between trace files
Date:   Fri, 10 Dec 2021 13:02:46 +0200
Message-Id: <20211210110249.98583-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110249.98583-1-tz.stoyanov@gmail.com>
References: <20211210110249.98583-1-tz.stoyanov@gmail.com>
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
index 9012ebd9..f2cfeb47 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -194,6 +194,8 @@ int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
 			       struct tracecmd_output *out_handle);
 int tracecmd_copy_options(struct tracecmd_input *in_handle,
 			  struct tracecmd_output *out_handle);
+int tracecmd_copy_trace_data(struct tracecmd_input *in_handle,
+			     struct tracecmd_output *out_handle);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 85420fb1..835c6c96 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -68,6 +68,11 @@ int out_update_section_header(struct tracecmd_output *handle, unsigned long long
 
 long long do_write_check(struct tracecmd_output *handle, const void *data, long long size);
 
+struct tracecmd_option *
+out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
+			 unsigned short id, unsigned long long data_offset,
+			 int cpus, struct data_file_write *cpu_data);
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
index ae3eea3d..af70272b 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -5110,6 +5110,179 @@ int tracecmd_copy_options(struct tracecmd_input *in_handle,
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
index 464ab693..cc27c245 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2257,6 +2257,44 @@ static int update_buffer_cpu_offset_v6(struct tracecmd_output *handle,
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
2.33.1

