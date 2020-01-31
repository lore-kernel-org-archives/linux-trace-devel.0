Return-Path: <SRS0=DRQG=3U=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709BDC35246
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BAC220705
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JHMmNuSh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgAaMLd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 07:11:33 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41263 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728484AbgAaMLc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 07:11:32 -0500
Received: by mail-lj1-f194.google.com with SMTP id h23so6838379ljc.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 31 Jan 2020 04:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MYJq6IqJyShRyo2p+TxgnxcD2SpGdblpKZiQcHwzkDM=;
        b=JHMmNuSh1Jvu+KIyokU241TzpEzPTv8um5ulVmzilIxrzqF0H6aavYDbSc11bnPr6D
         AQ4P8GbZAHBShR+BDRhJwMHllqijayMnAR4NIsIHayTCO21meHgvIUg8w0kppuQckyns
         Z2KXKElDufaMA5FJqom3IeL/FUv5mx7TvF3uJ83g6aH2FL7JKHA1zBTE1gbTq8d4yKdH
         MNAdzB+j+bvbxSfk3pR/rTygA88Zjtc02d9LJyDdqYSxTIsYNNwqfB1CNbT3mRI/FpfO
         80vCNlKpHgN3Fv2CsKENHD0eI0JdK/YbfuPODeGaFrJQv0Uh/QBX+i9tDOvhx460cxap
         3TPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MYJq6IqJyShRyo2p+TxgnxcD2SpGdblpKZiQcHwzkDM=;
        b=ogn6KTMDsf9bMWghILJYOySTTQ24BIYN8qCLtrM5hLMecUz3g/tNQz0emNcvna5uUP
         f+lCHT83k9ShL79lvH1NSaAt9lftzvd+YA9Ir4G9/E7OYzWUEA6maczDGTz0DcTPhE/Y
         L9r8Z5FCz8T2FDEkvPcN9Mf3BrJ8xhHDhH+aLkW3mPTMWQvVgc829H9ev0tisaCMaHdk
         SgH04ReLyX+INIeIbcpKDTKhKRWQjvt+9d5OtLAcuN51VfTu0mhQn00zQXPS6pSj7BVD
         Y61Vmm0wATzhO8GrQUhtRJbHnTRnsrf2jcjwinXN12nQjnamGCSrEVsHdUPuQVrdaXl9
         j7YQ==
X-Gm-Message-State: APjAAAUCoZsCbHQZnRpxM1ObAT5Jx0oAVwOR4xgI65wfi9d4YUOEkfIX
        ukjGFeU8Spgt/wffw4hRxakRpL7slOo=
X-Google-Smtp-Source: APXvYqzqBp7JGJKvaKJesMhmLSjtmPWcS5/TLIgP/TZB5J8nfjo0SA5KwLK+eAxQFiFdeuaxTWUUCg==
X-Received: by 2002:a2e:b4ef:: with SMTP id s15mr6073827ljm.20.1580472689247;
        Fri, 31 Jan 2020 04:11:29 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i19sm4559965lfj.17.2020.01.31.04.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 04:11:28 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v19 10/15] trace-cmd: Add guest information in host's trace.dat file
Date:   Fri, 31 Jan 2020 14:11:06 +0200
Message-Id: <20200131121111.130355-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200131121111.130355-1-tz.stoyanov@gmail.com>
References: <20200131121111.130355-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New trace.dat option is introduced: TRACECMD_OPTION_GUEST.
Written in the host's trace.dat file, it contains information about
guests, traced at the same time: guest trace ID, number of VCPUs and
PIDs of the host tasks, running those VCPU. The data is stored in
the file as NULL terminated string:
	"Guest %s %llu %d\n" -> guest name, number of VCPUs
	"%d %d\n" -> VCPU, PID of host task
	.....
	"%d %d\n" -> VCPU, PID of host task

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |   5 ++
 lib/trace-cmd/trace-input.c   | 125 ++++++++++++++++++++++++++++++++++
 tracecmd/trace-dump.c         |  62 +++++++++++++++++
 tracecmd/trace-record.c       |  61 +++++++++++++++++
 4 files changed, 253 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index ac46637..0375f50 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -111,6 +111,7 @@ enum {
 	TRACECMD_OPTION_PROCMAPS,
 	TRACECMD_OPTION_TRACEID,
 	TRACECMD_OPTION_TIME_SHIFT,
+	TRACECMD_OPTION_GUEST,
 };
 
 enum {
@@ -154,6 +155,10 @@ void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
 unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle);
+int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
+			      unsigned long long trace_id,
+			      char **name,
+			      int *vcpu_count, int **cpu_pid);
 unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle);
 int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable);
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e68e1ac..3d1de1d 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -82,6 +82,14 @@ struct ts_offset_sample {
 	long long	offset;
 };
 
+struct guest_trace_info {
+	struct guest_trace_info	*next;
+	char			*name;
+	unsigned long long	trace_id;
+	int			vcpu_count;
+	int			*cpu_pid;
+};
+
 struct host_trace_info {
 	bool			sync_enable;
 	unsigned long long	trace_id;
@@ -115,6 +123,7 @@ struct tracecmd_input {
 	char *			trace_clock;
 	struct input_buffer_instance	*buffers;
 	int			parsing_failures;
+	struct guest_trace_info	*guest;
 
 	struct tracecmd_ftrace	finfo;
 
@@ -2197,6 +2206,83 @@ static void procmap_free(struct pid_addr_maps *maps)
 	free(maps);
 }
 
+static void trace_guests_free(struct tracecmd_input *handle)
+{
+	struct guest_trace_info *guest;
+
+	while (handle->guest) {
+		guest = handle->guest;
+		handle->guest = handle->guest->next;
+		free(guest->name);
+		free(guest->cpu_pid);
+		free(guest);
+	}
+}
+
+static int trace_guest_load(struct tracecmd_input *handle, char *buf, int size)
+{
+	struct guest_trace_info *guest = NULL;
+	int cpu;
+	int i;
+
+	guest = calloc(1, sizeof(struct guest_trace_info));
+	if (!guest)
+		goto error;
+
+	/*
+	 * Guest name, null terminated string
+	 * long long (8 bytes) trace-id
+	 * int (4 bytes) number of guest CPUs
+	 * array of size number of guest CPUs:
+	 *	int (4 bytes) Guest CPU id
+	 *	int (4 bytes) Host PID, running the guest CPU
+	 */
+
+	guest->name = strndup(buf, size);
+	if (!guest->name)
+		goto error;
+	buf += strlen(guest->name) + 1;
+	size -= strlen(guest->name) + 1;
+
+	if (size < sizeof(long long))
+		goto error;
+	guest->trace_id = tep_read_number(handle->pevent, buf, sizeof(long long));
+	buf += sizeof(long long);
+
+	if (size < sizeof(int))
+		goto error;
+	guest->vcpu_count = tep_read_number(handle->pevent, buf, sizeof(int));
+	buf += sizeof(int);
+
+	guest->cpu_pid = calloc(guest->vcpu_count, sizeof(int));
+	if (!guest->cpu_pid)
+		goto error;
+
+	for (i = 0; i < guest->vcpu_count; i++) {
+		if (size < 2 * sizeof(int))
+			goto error;
+		cpu = tep_read_number(handle->pevent, buf, sizeof(int));
+		buf += sizeof(int);
+		if (cpu >= guest->vcpu_count)
+			goto error;
+		guest->cpu_pid[cpu] = tep_read_number(handle->pevent,
+						      buf, sizeof(int));
+		buf += sizeof(int);
+	}
+
+	guest->next = handle->guest;
+	handle->guest = guest;
+	return 0;
+
+error:
+	if (guest) {
+		free(guest->cpu_pid);
+		free(guest->name);
+		free(guest);
+	}
+	return -1;
+}
+
 /* Needs to be a constant, and 4K should be good enough */
 #define STR_PROCMAP_LINE_MAX	4096
 static int trace_pid_map_load(struct tracecmd_input *handle, char *buf)
@@ -2462,6 +2548,9 @@ static int handle_options(struct tracecmd_input *handle)
 			handle->trace_id = tep_read_number(handle->pevent,
 							   &cpus, 8);
 			break;
+		case TRACECMD_OPTION_GUEST:
+			trace_guest_load(handle, buf, size);
+			break;
 		default:
 			warning("unknown option %d", option);
 			break;
@@ -3116,6 +3205,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 	handle->pid_maps = NULL;
 
 	trace_tsync_offset_free(&handle->host);
+	trace_guests_free(handle);
 
 	if (handle->flags & TRACECMD_FL_BUFFER_INSTANCE)
 		tracecmd_close(handle->parent);
@@ -3580,6 +3670,41 @@ unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle)
 	return handle->trace_id;
 }
 
+/**
+ * tracecmd_get_guest_cpumap - get the mapping of guest VCPU to host process
+ * @handle: input handle for the trace.dat file
+ * @trace_id: ID of the guest tracing session
+ * @name: return, name of the guest
+ * @vcpu_count: return, number of VPUs
+ * @cpu_pid: return, array with guest VCPU to host process mapping
+ *
+ * Returns @name of the guest, number of VPUs (@vcpu_count)
+ * and array @cpu_pid with size @vcpu_count. Array index is VCPU id, array
+ * content is PID of the host process, running this VCPU.
+ *
+ * This information is stored in host trace.dat file
+ */
+int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
+			      unsigned long long trace_id,
+			      char **name,
+			      int *vcpu_count, int **cpu_pid)
+{
+	struct guest_trace_info	*guest = handle->guest;
+
+	while (guest) {
+		if (guest->trace_id == trace_id)
+			break;
+		guest = guest->next;
+	}
+	if (!guest)
+		return -1;
+
+	*name = guest->name;
+	*vcpu_count = guest->vcpu_count;
+	*cpu_pid = guest->cpu_pid;
+	return 0;
+}
+
 /**
  * tracecmd_get_tsync_peer - get the trace session id of the peer host
  * @handle: input handle for the trace.dat file
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index b4beb8b..ffb1c6b 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -412,6 +412,65 @@ out:
 	free(offsets);
 }
 
+void dump_option_guest(int fd, int size)
+{
+	unsigned long long trace_id;
+	char *buf, *p;
+	int cpu, pid;
+	int cpus;
+	int i;
+
+	do_print(OPTIONS, "\t\t[Option GUEST, %d bytes]\n", size);
+
+	/*
+	 * Guest name, null terminated string
+	 * long long (8 bytes) trace-id
+	 * int (4 bytes) number of guest CPUs
+	 * array of size number of guest CPUs:
+	 *	int (4 bytes) Guest CPU id
+	 *	int (4 bytes) Host PID, running the guest CPU
+	 */
+	buf = calloc(1, size);
+	if (!buf)
+		return;
+	if (read_file_bytes(fd, buf, size))
+		goto out;
+
+	p = buf;
+	do_print(OPTIONS, "%s [Guest name]\n", p);
+	size -= strlen(buf) + 1;
+	p += strlen(buf) + 1;
+
+	if (size < sizeof(long long))
+		goto out;
+	trace_id = tep_read_number(tep, p, sizeof(long long));
+	size -= sizeof(long long);
+	p += sizeof(long long);
+	do_print(OPTIONS, "0x%llX [trace id]\n", trace_id);
+
+	if (size < sizeof(int))
+		goto out;
+	cpus = tep_read_number(tep, p, sizeof(int));
+	size -= sizeof(int);
+	p += sizeof(int);
+	do_print(OPTIONS, "%d [Guest CPUs]\n", cpus);
+
+	for (i = 0; i < cpus; i++) {
+		if (size < 2 * sizeof(int))
+			goto out;
+		cpu = tep_read_number(tep, p, sizeof(int));
+		size -= sizeof(int);
+		p += sizeof(int);
+		pid = tep_read_number(tep, p, sizeof(int));
+		size -= sizeof(int);
+		p += sizeof(int);
+		do_print(OPTIONS, "  %d %d [guest cpu, host pid]\n", cpu, pid);
+	}
+
+out:
+	free(buf);
+}
+
 static void dump_options(int fd)
 {
 	unsigned short option;
@@ -468,6 +527,9 @@ static void dump_options(int fd)
 		case TRACECMD_OPTION_TIME_SHIFT:
 			dump_option_timeshift(fd, size);
 			break;
+		case TRACECMD_OPTION_GUEST:
+			dump_option_guest(fd, size);
+			break;
 		default:
 			do_print(OPTIONS, " %d %d\t[Unknown option, size - skipping]\n",
 				 option, size);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 90026d9..0c1e721 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3042,6 +3042,19 @@ struct guest {
 static struct guest *guests;
 static size_t guests_len;
 
+static struct guest *get_guest_info(unsigned int guest_cid)
+{
+	int i;
+
+	if (!guests)
+		return NULL;
+
+	for (i = 0; i < guests_len; i++)
+		if (guest_cid == guests[i].cid)
+			return guests + i;
+	return NULL;
+}
+
 static char *get_qemu_guest_name(char *arg)
 {
 	char *tok, *end = arg;
@@ -3844,6 +3857,49 @@ static void append_buffer(struct tracecmd_output *handle,
 	}
 }
 
+static void
+add_guest_info(struct tracecmd_output *handle, struct buffer_instance *instance)
+{
+	struct guest *guest = get_guest_info(instance->cid);
+	char *buf, *p;
+	int size;
+	int i;
+
+	if (!guest)
+		return;
+	for (i = 0; i < VCPUS_MAX; i++)
+		if (!guest->cpu_pid[i])
+			break;
+
+	size = strlen(guest->name) + 1;
+	size +=  sizeof(long long); 	/* trace_id */
+	size +=  sizeof(int);		/* cpu count */
+	size += i * 2 * sizeof(int);	/* cpu,pid pair */
+
+	buf = calloc(1, size);
+	if (!buf)
+		return;
+	p = buf;
+	strcpy(p, guest->name);
+	p += strlen(guest->name) + 1;
+
+	memcpy(p, &instance->trace_id, sizeof(long long));
+	p += sizeof(long long);
+
+	memcpy(p, &i, sizeof(int));
+	p += sizeof(int);
+	for (i = 0; i < VCPUS_MAX; i++) {
+		if (!guest->cpu_pid[i])
+			break;
+		memcpy(p, &i, sizeof(int));
+		p += sizeof(int);
+		memcpy(p, &guest->cpu_pid[i], sizeof(int));
+		p += sizeof(int);
+	}
+
+	tracecmd_add_option(handle, TRACECMD_OPTION_GUEST, size, buf);
+	free(buf);
+}
 
 static void
 add_pid_maps(struct tracecmd_output *handle, struct buffer_instance *instance)
@@ -4128,6 +4184,11 @@ static void record_data(struct common_record_context *ctx)
 			add_pid_maps(handle, instance);
 		}
 
+		for_all_instances(instance) {
+			if (is_guest(instance))
+				add_guest_info(handle, instance);
+		}
+
 		tracecmd_append_cpu_data(handle, local_cpu_count, temp_files);
 
 		for (i = 0; i < max_cpu_count; i++)
-- 
2.24.1

