Return-Path: <SRS0=xbdb=2D=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752D3C3B198
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9F48246D0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BDBkgz8S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfLMPav (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:30:51 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46570 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727891AbfLMPav (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 10:30:51 -0500
Received: by mail-lj1-f193.google.com with SMTP id z17so3051388ljk.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Dec 2019 07:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DzTxOpxQd6iCw/somb9si6l7KgJCHTtYCXRy4NispzY=;
        b=BDBkgz8SOdEI6nxrSRqV3i9J/rLzpERlQ2NeDK99ELNzmRHWP6iRZGmH/tsf17+Idq
         c/abKXIK+IEe+ub0BXKv7TmXVCvfEYEIhe9H9kDVtK6hFX2xsdpA3nP8XQvS/YRuTvIq
         o8tnHzWCxEgJvn3nwBC030XzukB2jTBlBTgsdySqHg5aM/+vLEUfxbJUzsTxRHJedI1J
         SgHcWb7E/1bMzDXKWbvboDd4t2z8lis4hRZ4oinz5rv7mOD4oVOHljfZUKTFPz6/kruM
         QqBfyc4bGIbaF4Cw7h5c4xl7apz6IUlT3pFSepDHRPJ15HztzOL/3gTvfB5FnS3ylek1
         gM7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DzTxOpxQd6iCw/somb9si6l7KgJCHTtYCXRy4NispzY=;
        b=MoJYkXYsNNChDYhpiLH4zO0ZlL4SJ51BPrZUnejO46UCcBs8K2Qd6kwp2B9U1QsslB
         DzCuDEr2hh/bL0PoPfqv6nqi92O4a1BYm5PeAL8BoQ5MbDeagq6MRGFOWe7rOQw9me5Q
         Ko4DQTr3bY6tCfvQEt+Z1brdZKAJogqwgqDMqCuwHJLpAmI6x+GDr2XRF5ORq/Y761yv
         Wc5t8bAAL4Rh6foRZXQo+wY8V/xo1nOFMcdshWA9BZbKaHVgwdNX60oyJrS340qBIZIY
         GJ/YsfSlFBILydL8TKLnIHCh5wdrz4Q1RY3M7kmR9S5RmruPtxMGIRZ4bn353jgVtA6a
         5JgQ==
X-Gm-Message-State: APjAAAW17kW8c/kgdKl73Y9RrTcTGTW/A4TvBKyhGrSSqUrrnKzUKC7+
        fxYhTPZd525sEB1Hv7htyLo=
X-Google-Smtp-Source: APXvYqx9NUAH5Jg7jdRqGU/zJOpszfWtiVL1AdRSGUGnp5fa20VyyEvCCjfSSdYkE71AXJXpBvbAIQ==
X-Received: by 2002:a2e:3e08:: with SMTP id l8mr10275449lja.236.1576251048324;
        Fri, 13 Dec 2019 07:30:48 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u19sm5012806ljk.75.2019.12.13.07.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:30:47 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v18 13/18] trace-cmd: Add guest information in host's trace.dat file
Date:   Fri, 13 Dec 2019 17:30:24 +0200
Message-Id: <20191213153029.133570-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213153029.133570-1-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c   | 110 ++++++++++++++++++++++++++++++++++
 tracecmd/trace-record.c       |  46 ++++++++++++++
 3 files changed, 161 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index b06a0c3..da8eeaf 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -88,6 +88,7 @@ enum {
 	TRACECMD_OPTION_PROCMAPS,
 	TRACECMD_OPTION_TRACEID,
 	TRACECMD_OPTION_TIME_SHIFT,
+	TRACECMD_OPTION_GUEST,
 };
 
 enum {
@@ -131,6 +132,10 @@ void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
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
index e8db876..6c4fc03 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -79,6 +79,14 @@ struct ts_offset_sample {
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
@@ -112,6 +120,7 @@ struct tracecmd_input {
 	char *			trace_clock;
 	struct input_buffer_instance	*buffers;
 	int			parsing_failures;
+	struct guest_trace_info	*guest;
 
 	struct tracecmd_ftrace	finfo;
 
@@ -2297,6 +2306,67 @@ static int trace_traceid_load(struct tracecmd_input *handle, char *buf)
 	return -1;
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
+static int trace_guest_load(struct tracecmd_input *handle, char *buf)
+{
+	struct guest_trace_info *guest = NULL;
+	unsigned long long tid;
+	char *next = NULL;
+	int cpu, pid;
+	char *line;
+
+	line = strtok_r(buf, "\n", &next);
+	if (!line)
+		goto error;
+
+	guest = calloc(1, sizeof(struct guest_trace_info));
+	if (!guest)
+		goto error;
+
+	if (sscanf(line, "%*s %ms %llu %d", &guest->name, &tid, &cpu) != 3)
+		goto error;
+	guest->trace_id = tid;
+	guest->vcpu_count = cpu;
+
+	guest->cpu_pid = calloc(guest->vcpu_count, sizeof(int));
+	if (!guest->cpu_pid)
+		goto error;
+
+	line = strtok_r(NULL, "\n", &next);
+	while (line) {
+		if (sscanf(line, "%d %d", &cpu, &pid) != 2)
+			goto error;
+
+		if (cpu < guest->vcpu_count)
+			guest->cpu_pid[cpu] = pid;
+		line = strtok_r(NULL, "\n", &next);
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
 #define STR_PROCMAP_LINE_MAX	(PATH_MAX+22)
 static int trace_pid_map_load(struct tracecmd_input *handle, char *buf)
 {
@@ -2561,6 +2631,10 @@ static int handle_options(struct tracecmd_input *handle)
 			if (buf[size-1] == '\0')
 				trace_traceid_load(handle, buf);
 			break;
+		case TRACECMD_OPTION_GUEST:
+			if (buf[size-1] == '\0')
+				trace_guest_load(handle, buf);
+			break;
 		default:
 			warning("unknown option %d", option);
 			break;
@@ -3220,6 +3294,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 	handle->pid_maps = NULL;
 
 	trace_tsync_offset_free(&handle->host);
+	trace_guests_free(handle);
 
 	if (handle->flags & TRACECMD_FL_BUFFER_INSTANCE)
 		tracecmd_close(handle->parent);
@@ -3676,6 +3751,41 @@ unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle)
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
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4bd9b7a..e4e2d63 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2884,6 +2884,19 @@ struct guest {
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
@@ -3689,6 +3702,34 @@ static void append_buffer(struct tracecmd_output *handle,
 }
 
 
+static void
+add_guest_info(struct tracecmd_output *handle, struct buffer_instance *instance)
+{
+	struct guest *guest = get_guest_info(instance->cid);
+	struct trace_seq s;
+	int i;
+
+	if (!guest)
+		return;
+	for (i = 0; i < VCPUS_MAX; i++)
+		if (!guest->cpu_pid[i])
+			break;
+
+	trace_seq_init(&s);
+
+	trace_seq_printf(&s, "Guest %s %llu %d\n",
+			 guest->name, instance->trace_id, i);
+	for (i = 0; i < VCPUS_MAX; i++) {
+		if (!guest->cpu_pid[i])
+			break;
+		trace_seq_printf(&s, "%d %d\n", i, guest->cpu_pid[i]);
+	}
+	trace_seq_terminate(&s);
+	tracecmd_add_option(handle, TRACECMD_OPTION_GUEST,
+			    s.len + 1, s.buffer);
+	trace_seq_destroy(&s);
+}
+
 static void
 add_pid_maps(struct tracecmd_output *handle, struct buffer_instance *instance)
 {
@@ -3975,6 +4016,11 @@ static void record_data(struct common_record_context *ctx)
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
2.23.0

