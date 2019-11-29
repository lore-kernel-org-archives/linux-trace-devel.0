Return-Path: <SRS0=Qwo8=ZV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F992C432C3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:17:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B16F20833
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:17:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TrUKB28L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfK2KRy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Nov 2019 05:17:54 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43466 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfK2KRy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Nov 2019 05:17:54 -0500
Received: by mail-lj1-f196.google.com with SMTP id a13so8225853ljm.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Nov 2019 02:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wcQL78XUCyajNt4YlqnV1DffF7NrC/gu/1/VE/NGmdc=;
        b=TrUKB28LlRDre08LlYhng6/Q34c/Qys6sWvUIPkG1VulO2WcJ/bC+BF/cY2kTliHVT
         ozHDRwoWuOUS2iDy7Fw5Klru3V1kRyEHea8SIzgSOBBgc1jE5hAaa1KB+nywu9X4brMV
         s9qEt6cdrie2jdHkQL/g5a+7B9A+Ko+Ege6WDYjTy6IqDWQPIk3BtEKjAetArz5PzDPf
         xbuI416nImR6ImZyiVfBmd5nQbLiaJrD5sHDHrPoALiqIK50bHaaXW81nQNzxDYHoEj2
         ju5Ac7trGG6ZNp6gb2HeLq1n3btkWD7tE/b3AJZ6W90C73eOfEWXG+OjasltU5JhUJK2
         pXRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wcQL78XUCyajNt4YlqnV1DffF7NrC/gu/1/VE/NGmdc=;
        b=WwWDxcY0sx2DGG3z39TEdjj/3BsXSVW0Ti2tPFn0yy2Nrec2jPGRuTb9ZBRqSro7k8
         7hkIKnhoaFcDs4jzzAx5BEUv7AsicAgthHco2EEyo1ZzrXdXnIV7Pc8P/smUUmJDns6J
         CoSyNpqsD4ofoFq3fUWVDdu05zAF5Y1APYqCcoV3LnFJgMWqQz5m0zBAeiO5hV8QJI73
         3FKUNs3LfGYU1P9iizRdCNNBz/UoQXBjmySgMV7F1L86xuI8qg7qOb6aRIPJF6Gc/3Bl
         no8IeERNU4BCoFWzRiSANMewbDKkT3TDcbtE+mhX/GhaMPqOzHE7SBZBmd1QTZeOkYq/
         j+4A==
X-Gm-Message-State: APjAAAV+5fW4mIqZulZ9moW1xnBuwF1chRVT2EQC6Tz6jFJL7xT0aLvp
        /NfJGSoflYySfQkBjpWFJrn12Bu1kU8=
X-Google-Smtp-Source: APXvYqylgxka25BRuv8jBl215VI8Fjka9wHDU1zc4PAHU8JY9e3BuE+CjQnmCxKZpn/EQSsm0Cl/VQ==
X-Received: by 2002:a2e:5751:: with SMTP id r17mr6586790ljd.254.1575022671602;
        Fri, 29 Nov 2019 02:17:51 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x29sm11367935lfg.45.2019.11.29.02.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 02:17:51 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v16 13/18] trace-cmd: Add guest information in host's trace.dat file
Date:   Fri, 29 Nov 2019 12:17:28 +0200
Message-Id: <20191129101733.375808-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191129101733.375808-1-tz.stoyanov@gmail.com>
References: <20191129101733.375808-1-tz.stoyanov@gmail.com>
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
 include/trace-cmd/trace-cmd.h |   1 +
 lib/trace-cmd/trace-input.c   | 113 ++++++++++++++++++++++++++++++++++
 tracecmd/trace-record.c       |  45 ++++++++++++++
 3 files changed, 159 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 1240b4a..17badf2 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -88,6 +88,7 @@ enum {
 	TRACECMD_OPTION_PROCMAPS,
 	TRACECMD_OPTION_TRACEID,
 	TRACECMD_OPTION_TIME_SHIFT,
+	TRACECMD_OPTION_GUEST,
 };
 
 enum {
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index a6b675a..e36ebaa 100644
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
 
@@ -2294,6 +2303,73 @@ static int trace_traceid_load(struct tracecmd_input *handle, char *buf)
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
+	char *line;
+	int cpu, pid;
+
+	line = strchr(buf, '\n');
+	if (!line)
+		goto error;
+	*line = '\0';
+
+	guest = calloc(1, sizeof(struct guest_trace_info));
+	if (!guest)
+		goto error;
+
+	if (sscanf(buf, "%*s %ms %llu %d", &guest->name, &tid, &cpu) != 3)
+		goto error;
+	guest->trace_id = tid;
+	guest->vcpu_count = cpu;
+
+	guest->cpu_pid = calloc(guest->vcpu_count, sizeof(int));
+	if (!guest->cpu_pid)
+		goto error;
+
+	buf = line + 1;
+	line = strchr(buf, '\n');
+	while (line) {
+		*line = '\0';
+		if (sscanf(buf, "%d %d", &cpu, &pid) != 2)
+			goto error;
+
+		if (cpu < guest->vcpu_count)
+			guest->cpu_pid[cpu] = pid;
+		buf = line + 1;
+		if (!*buf)
+			break;
+
+		line = strchr(buf, '\n');
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
@@ -2558,6 +2634,10 @@ static int handle_options(struct tracecmd_input *handle)
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
@@ -3217,6 +3297,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 	handle->pid_maps = NULL;
 
 	trace_tsync_offset_free(&handle->host);
+	trace_guests_free(handle);
 
 	if (handle->flags & TRACECMD_FL_BUFFER_INSTANCE)
 		tracecmd_close(handle->parent);
@@ -3673,6 +3754,38 @@ unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle)
 	return handle->trace_id;
 }
 
+/**
+ * tracecmd_get_guest_cpumap - get the mapping of guest VCPU to host process
+ * @handle: input handle for the trace.dat file
+ * @trace_id: ID of the guest tracing session
+ *
+ * Returns @name of the guest, number of VPUs (@vcpu_count)
+ * and array @cpu_pid with size @vcpu_count. Array index is VCPU id, array
+ * content is PID of the host process, running this VCPU.
+ *
+ * This information is stored in host trace.dat file
+ */
+int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
+			      unsigned long long trace_id,
+			      char *name,
+			      int *vcpu_count, int *cpu_pid)
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
+	name = guest->name;
+	*vcpu_count = guest->vcpu_count;
+	cpu_pid = guest->cpu_pid;
+	return 0;
+}
+
 /**
  * tracecmd_get_tsync_peer - get the trace session id of the peer host
  * @handle: input handle for the trace.dat file
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e51134f..49730d6 100644
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
@@ -3689,6 +3702,33 @@ static void append_buffer(struct tracecmd_output *handle,
 	}
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
 
 static void
 add_pid_maps(struct tracecmd_output *handle, struct buffer_instance *instance)
@@ -3976,6 +4016,11 @@ static void record_data(struct common_record_context *ctx)
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

