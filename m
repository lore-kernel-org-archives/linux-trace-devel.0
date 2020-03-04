Return-Path: <SRS0=Pf13=4V=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3823FC3F2CD
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07A942073B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:12:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YYjC+vVY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387473AbgCDJMf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Mar 2020 04:12:35 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41248 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728779AbgCDJMf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Mar 2020 04:12:35 -0500
Received: by mail-lf1-f68.google.com with SMTP id y17so861995lfe.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 04 Mar 2020 01:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WOtXHs7tV52Bd9UuOwAMexuiCNR3UOCZkjHvNN/KzO0=;
        b=YYjC+vVYoEH30eH1YFFqNs9IVByA6Q6hOVF27F1Vg9YN7r7QDDcmR6aRJVjUrIzNwI
         2GVDLxgey8b2cixwkhOCk4e1FVglEiTiv7NlqmaHaOUXHP3+gKQ7DTUnbm1i8MyAlPlh
         8e1godjXqyONcdgDs1cFuWRf+PolvS7d1Nj/IHrr9xSKL/2lEf8KyjpE/q2YGGguVb9V
         VrsaDpmTYUDSjEFB7nOC3fadR294Iz0fLf2k3gPqX8/xycGbTcrR4lox3oYZqt2oGh2c
         PGj11LmFAwPhPxnjra5GMBqW8/PxjB/b3OP+0oEXYDaP1B0Sr0IDtteWsAMzauhQPSd0
         OyLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WOtXHs7tV52Bd9UuOwAMexuiCNR3UOCZkjHvNN/KzO0=;
        b=cgPge5t+YKrGs+SuiYeXpyBgUdHXI22cLQzIc9aCcRvgZsVpmLoX51jWBz6VNHt+uP
         jVAgSftW+iLodLSmtSfrHvNgkl+oW+zUXlw0lZqKujeaUIY3Z8N6L0FZZzDv6wPWULwZ
         QasW1R5an++spx0Ohmfed4qWoChRHqUZzuQ3Hu+oyG/ICnif1w6OiqD8TObW/Yx35Ybs
         sL/537u2TLgW/hT62OldMuzTj9V6ysB7dpSnUJAE2BoE8m3ast/32Niv4AevofI4Ossv
         SPB1e4djGSKTHxYsarpzf+AoJQOIMUeIlvPGeA1JmB2+hR24x8BVEZQLyF04KQWrdmR+
         kbpA==
X-Gm-Message-State: ANhLgQ2/gMnplbHidMyeubjnjsAVaYaPdyEkuwVavWlLlze9Ub8aYwrb
        +MzAYw0zOAaJxKatVw9yOTn+bAM0
X-Google-Smtp-Source: ADFU+vvto0s6hM2QaY+QU7tX2FT4Ncbo6w+Kus2/ncY9n9q8VtyPFSuNMFRfdVqirOFe5k4l7FwjWw==
X-Received: by 2002:ac2:4a84:: with SMTP id l4mr1386067lfp.217.1583313152883;
        Wed, 04 Mar 2020 01:12:32 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v15sm13327462lfg.51.2020.03.04.01.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 01:12:32 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v22 08/13] trace-cmd: Add guest information in host's trace.dat file
Date:   Wed,  4 Mar 2020 11:12:15 +0200
Message-Id: <20200304091220.30936-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304091220.30936-1-tz.stoyanov@gmail.com>
References: <20200304091220.30936-1-tz.stoyanov@gmail.com>
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
the file as:
	Guest name, null terminated string
	long long (8 bytes) trace-id
	int (4 bytes) number of guest CPUs
	array of size number of guest CPUs:
		int (4 bytes) Guest CPU id
		int (4 bytes) Host PID, running the guest CPU

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |   5 ++
 lib/trace-cmd/trace-input.c   | 128 ++++++++++++++++++++++++++++++++++
 tracecmd/trace-dump.c         |  62 ++++++++++++++++
 tracecmd/trace-record.c       |  61 ++++++++++++++++
 4 files changed, 256 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index ac46637e..0375f500 100644
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
index 2f0274d9..01a1def4 100644
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
 
@@ -2197,6 +2206,86 @@ static void procmap_free(struct pid_addr_maps *maps)
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
+	size -= sizeof(long long);
+
+	if (size < sizeof(int))
+		goto error;
+	guest->vcpu_count = tep_read_number(handle->pevent, buf, sizeof(int));
+	buf += sizeof(int);
+	size -= sizeof(int);
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
+		size -= 2 * sizeof(int);
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
@@ -2468,6 +2557,9 @@ static int handle_options(struct tracecmd_input *handle)
 			handle->trace_id = tep_read_number(handle->pevent,
 							   &cpus, 8);
 			break;
+		case TRACECMD_OPTION_GUEST:
+			trace_guest_load(handle, buf, size);
+			break;
 		default:
 			warning("unknown option %d", option);
 			break;
@@ -3122,6 +3214,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 	handle->pid_maps = NULL;
 
 	trace_tsync_offset_free(&handle->host);
+	trace_guests_free(handle);
 
 	if (handle->flags & TRACECMD_FL_BUFFER_INSTANCE)
 		tracecmd_close(handle->parent);
@@ -3586,6 +3679,41 @@ unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle)
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
index b4beb8b2..ffb1c6b1 100644
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
index ef9d7e3e..f1e2a391 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3061,6 +3061,19 @@ static int set_vcpu_pid_mapping(struct guest *guest, int cpu, int pid)
 	return 0;
 }
 
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
@@ -3875,6 +3888,49 @@ static void append_buffer(struct tracecmd_output *handle,
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
+	for (i = 0; i < guest->cpu_max; i++)
+		if (!guest->cpu_pid[i])
+			break;
+
+	size = strlen(guest->name) + 1;
+	size +=  sizeof(long long);	/* trace_id */
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
+	for (i = 0; i < guest->cpu_max; i++) {
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
@@ -4159,6 +4215,11 @@ static void record_data(struct common_record_context *ctx)
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

