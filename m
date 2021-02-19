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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E682AC433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 10:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F50064EC4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 10:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhBSKSd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Feb 2021 05:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbhBSKRI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Feb 2021 05:17:08 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD86C061793
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Feb 2021 02:15:06 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id g5so11857718ejt.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Feb 2021 02:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yIYP438l3QQ4ZZK7Y6GOmFWtFGsqUFdDDwTzyCvm6FU=;
        b=Yiga8+6ecrzeS4vkmEko1KFXBem8rF9dZtCZ4NsDgrHyDjN0EcR4YGi2iduTKyn4Nb
         zo2n942Hx3Ewk3qKhjbpiTW7M9G6iGY0WZR316iMjd+s8SzLGaEwkYMlRxO71wHkXo2r
         l4pzq0jGDqhDsoDO4PMIVPH8R+jGAyRrv5GktwCz6XC/UL6cP+Ot392AXVv2P2zRZQzT
         EBnJ0ttLghjCEyGl0KCv2p4XWhJuDEPILUqRj6BY0WhlspRa6c1xM6LiwwFVB2rQcCCY
         KmWXEIK7XENnIPhjS68Hh60mzfiYbHEUA4mS1Bl39mRbgktF/Rqa49IDgCgZlaLArnXo
         kpJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yIYP438l3QQ4ZZK7Y6GOmFWtFGsqUFdDDwTzyCvm6FU=;
        b=ELCCT+S2KenrhNnLUt6vOZP99AfemCi9khPKurmflUxQV6sf5yOYr9ppMbkFwPHB7Z
         RO0L4m3YeVG5C8N7VhI+q2bnHib8zeM0JoHDKnk0nBElFOap0brMGFGO83KbeC8Qb0SU
         eNGx/b7KA/wdeeQ6SWzCfanGAV/t2WMFa+VWcAjpK4Ec0dTQ06Pvdc8JRWW6SDbJroLw
         hNtPHnFLCS2BzMOls95qyf1YSK9iVhwjNOjfa3Op+8d8C86I3CfQRELheNBp3XHBg/nL
         4/IMjrWgklG0JNZPtMkjUZuoTDAQI3kbbRL9ChHiOjDHC5PUMUEh1pHsi1EDNQ5pM1i3
         0Xpg==
X-Gm-Message-State: AOAM531pj9+a318On6QNwTbH/Mc9q+X9LnQFB10r5YVNSEq97n4HPhtV
        JkYolgbpfxZ+4MkYZ5b1n/Yb7jblL1P7ew==
X-Google-Smtp-Source: ABdhPJwZ2zp1aO/gLRMZBZugCQyDEShOjhk/zoh72Z8JTFgMc7L2dYhBvP9AXX/G9vvZr0bxrWevxw==
X-Received: by 2002:a17:906:8a54:: with SMTP id gx20mr2021798ejc.262.1613729704740;
        Fri, 19 Feb 2021 02:15:04 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k2sm4162481ejp.6.2021.02.19.02.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 02:15:04 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v29 5/5] trace-cmd [POC]: Add KVM timestamp synchronization plugin
Date:   Fri, 19 Feb 2021 12:14:57 +0200
Message-Id: <20210219101457.2345089-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210219101457.2345089-1-tz.stoyanov@gmail.com>
References: <20210219101457.2345089-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added new timestamp synchronization plugin for KVM hosts. It reads the
clock offsets directly from the KVM debug filesystem, if available.
The plugin works only with x86-tsc ftrace clock.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/Makefile                        |   1 +
 .../include/private/trace-cmd-private.h       |   3 +-
 lib/trace-cmd/include/trace-tsync-local.h     |   1 +
 lib/trace-cmd/trace-timesync-kvm.c            | 460 ++++++++++++++++++
 lib/trace-cmd/trace-timesync.c                |  14 +-
 tracecmd/trace-tsync.c                        |   9 +-
 6 files changed, 483 insertions(+), 5 deletions(-)
 create mode 100644 lib/trace-cmd/trace-timesync-kvm.c

diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index f41feef8..e8d2dae9 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -20,6 +20,7 @@ OBJS += trace-plugin.o
 ifeq ($(VSOCK_DEFINED), 1)
 OBJS += trace-timesync.o
 OBJS += trace-timesync-ptp.o
+OBJS += trace-timesync-kvm.o
 endif
 
 # Additional util objects
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 9369a9d3..d343e4f7 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -423,6 +423,7 @@ struct tracecmd_time_sync {
 	int				loop_interval;
 	pthread_mutex_t			lock;
 	pthread_cond_t			cond;
+	pthread_barrier_t		first_sync;
 	char				*clock_str;
 	struct tracecmd_msg_handle	*msg_handle;
 	void				*context;
@@ -439,7 +440,7 @@ const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos, ch
 					enum tracecmd_time_sync_role role);
 bool tsync_proto_is_supported(const char *proto_name);
 void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
-void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
+int tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
 int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync, int cpu,
 				int *count, long long **ts,
 				long long **offsets, long long **scalings);
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index d4281469..fe91e2e3 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -49,5 +49,6 @@ int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int role
 int tracecmd_tsync_proto_unregister(char *proto_name);
 
 int ptp_clock_sync_register(void);
+int kvm_clock_sync_register(void);
 
 #endif /* _TRACE_TSYNC_LOCAL_H */
diff --git a/lib/trace-cmd/trace-timesync-kvm.c b/lib/trace-cmd/trace-timesync-kvm.c
new file mode 100644
index 00000000..03a4fd73
--- /dev/null
+++ b/lib/trace-cmd/trace-timesync-kvm.c
@@ -0,0 +1,460 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2020, VMware, Tzvetomir Stoyanov tz.stoyanov@gmail.com>
+ *
+ */
+
+#include <fcntl.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <dirent.h>
+
+#include "trace-cmd.h"
+#include "trace-cmd-private.h"
+#include "tracefs.h"
+#include "trace-tsync-local.h"
+
+#define KVM_DEBUG_FS "/sys/kernel/debug/kvm"
+#define KVM_DEBUG_OFFSET_FILE	"tsc-offset"
+#define KVM_DEBUG_SCALING_FILE	"tsc-scaling-ratio"
+#define KVM_DEBUG_VCPU_DIR	"vcpu"
+
+#define KVM_SYNC_PKT_REQUEST	1
+#define KVM_SYNC_PKT_RESPONSE	2
+
+typedef __s64 s64;
+
+// equal to /sys/kernel/debug/kvm/<VM ID>/vcpu0/tsc-offset
+#define KVM_ACCURACY	0
+#define KVM_NAME	"kvm"
+
+struct kvm_clock_sync {
+	int vcpu_count;
+	char **vcpu_offsets;
+	char **vcpu_scalings;
+	int marker_fd;
+	struct tep_handle *tep;
+	int raw_id;
+	unsigned long long ts;
+};
+
+struct kvm_clock_offset_msg {
+	s64	ts;
+	s64	offset;
+	s64	scaling;
+};
+
+static bool kvm_support_check(bool guest)
+{
+	struct stat st;
+	int ret;
+
+	if (guest)
+		return true;
+
+	ret = stat(KVM_DEBUG_FS, &st);
+	if (ret < 0)
+		return false;
+
+	if (!S_ISDIR(st.st_mode))
+		return false;
+	return true;
+}
+
+static int kvm_open_vcpu_dir(struct kvm_clock_sync *kvm, int cpu, char *dir_str)
+{
+	struct dirent *entry;
+	char path[PATH_MAX];
+	DIR *dir;
+
+	dir = opendir(dir_str);
+	if (!dir)
+		goto error;
+	while ((entry = readdir(dir))) {
+		if (entry->d_type != DT_DIR) {
+			if (!strncmp(entry->d_name, KVM_DEBUG_OFFSET_FILE,
+				     strlen(KVM_DEBUG_OFFSET_FILE))) {
+				snprintf(path, sizeof(path), "%s/%s",
+					 dir_str, entry->d_name);
+				kvm->vcpu_offsets[cpu] = strdup(path);
+			}
+			if (!strncmp(entry->d_name, KVM_DEBUG_SCALING_FILE,
+				     strlen(KVM_DEBUG_SCALING_FILE))) {
+				snprintf(path, sizeof(path), "%s/%s",
+					 dir_str, entry->d_name);
+				kvm->vcpu_scalings[cpu] = strdup(path);
+			}
+		}
+	}
+	if (!kvm->vcpu_offsets[cpu])
+		goto error;
+	closedir(dir);
+	return 0;
+
+error:
+	if (dir)
+		closedir(dir);
+	free(kvm->vcpu_offsets[cpu]);
+	kvm->vcpu_offsets[cpu] = NULL;
+	free(kvm->vcpu_scalings[cpu]);
+	kvm->vcpu_scalings[cpu] = NULL;
+	return -1;
+}
+
+static int kvm_open_debug_files(struct kvm_clock_sync *kvm, int pid)
+{
+	char *vm_dir_str = NULL;
+	struct dirent *entry;
+	char *pid_str = NULL;
+	char path[PATH_MAX];
+	long vcpu;
+	DIR *dir;
+	int i;
+
+	dir = opendir(KVM_DEBUG_FS);
+	if (!dir)
+		goto error;
+	if (asprintf(&pid_str, "%d-", pid) <= 0)
+		goto error;
+	while ((entry = readdir(dir))) {
+		if (!(entry->d_type == DT_DIR &&
+		    !strncmp(entry->d_name, pid_str, strlen(pid_str))))
+			continue;
+		asprintf(&vm_dir_str, "%s/%s", KVM_DEBUG_FS, entry->d_name);
+		break;
+	}
+	closedir(dir);
+	dir = NULL;
+	if (!vm_dir_str)
+		goto error;
+	dir = opendir(vm_dir_str);
+	if (!dir)
+		goto error;
+	while ((entry = readdir(dir))) {
+		if (!(entry->d_type == DT_DIR &&
+		    !strncmp(entry->d_name, KVM_DEBUG_VCPU_DIR, strlen(KVM_DEBUG_VCPU_DIR))))
+			continue;
+		vcpu =  strtol(entry->d_name + strlen(KVM_DEBUG_VCPU_DIR), NULL, 10);
+		if (vcpu < 0 || vcpu >= kvm->vcpu_count)
+			continue;
+		snprintf(path, sizeof(path), "%s/%s", vm_dir_str, entry->d_name);
+		if (kvm_open_vcpu_dir(kvm, vcpu, path) < 0)
+			goto error;
+	}
+	for (i = 0; i < kvm->vcpu_count; i++) {
+		if (!kvm->vcpu_offsets[i])
+			goto error;
+	}
+	closedir(dir);
+	free(pid_str);
+	free(vm_dir_str);
+	return 0;
+error:
+	free(pid_str);
+	free(vm_dir_str);
+	if (dir)
+		closedir(dir);
+	return -1;
+}
+
+static int kvm_clock_sync_init_host(struct tracecmd_time_sync *tsync,
+				    struct kvm_clock_sync *kvm)
+{
+	kvm->vcpu_count = tsync->vcpu_count;
+	kvm->vcpu_offsets = calloc(kvm->vcpu_count, sizeof(char *));
+	kvm->vcpu_scalings = calloc(kvm->vcpu_count, sizeof(char *));
+	if (!kvm->vcpu_offsets || !kvm->vcpu_scalings)
+		goto error;
+	if (kvm_open_debug_files(kvm, tsync->guest_pid) < 0)
+		goto error;
+	return 0;
+
+error:
+	free(kvm->vcpu_offsets);
+	free(kvm->vcpu_scalings);
+	return -1;
+}
+
+static int kvm_clock_sync_init_guest(struct tracecmd_time_sync *tsync,
+				     struct kvm_clock_sync *kvm)
+{
+	const char *systems[] = {"ftrace", NULL};
+	struct clock_sync_context *clock_context;
+	struct tep_event *raw;
+	char *path;
+
+	clock_context = (struct clock_sync_context *)tsync->context;
+	path = tracefs_instance_get_dir(clock_context->instance);
+	if (!path)
+		goto error;
+	kvm->tep = tracefs_local_events_system(path, systems);
+	tracefs_put_tracing_file(path);
+	if (!kvm->tep)
+		goto error;
+	raw = tep_find_event_by_name(kvm->tep, "ftrace", "raw_data");
+	if (!raw)
+		goto error;
+
+	kvm->raw_id = raw->id;
+	tep_set_file_bigendian(kvm->tep, tracecmd_host_bigendian());
+	tep_set_local_bigendian(kvm->tep, tracecmd_host_bigendian());
+
+	path = tracefs_instance_get_file(clock_context->instance, "trace_marker_raw");
+	if (!path)
+		goto error;
+	kvm->marker_fd = open(path, O_WRONLY);
+	tracefs_put_tracing_file(path);
+
+	return 0;
+
+error:
+	if (kvm->tep)
+		tep_free(kvm->tep);
+	if (kvm->marker_fd >= 0)
+		close(kvm->marker_fd);
+
+	return -1;
+}
+
+static int kvm_clock_sync_init(struct tracecmd_time_sync *tsync)
+{
+	struct clock_sync_context *clock_context;
+	struct kvm_clock_sync *kvm;
+	int ret;
+
+	if (!tsync || !tsync->context)
+		return -1;
+	clock_context = (struct clock_sync_context *)tsync->context;
+
+	if (!kvm_support_check(clock_context->is_guest))
+		return -1;
+	kvm = calloc(1, sizeof(struct kvm_clock_sync));
+	if (!kvm)
+		return -1;
+	kvm->marker_fd = -1;
+	if (clock_context->is_guest)
+		ret = kvm_clock_sync_init_guest(tsync, kvm);
+	else
+		ret = kvm_clock_sync_init_host(tsync, kvm);
+	if (ret < 0)
+		goto error;
+
+	clock_context->proto_data = kvm;
+	return 0;
+
+error:
+	free(kvm);
+	return -1;
+}
+
+static int kvm_clock_sync_free(struct tracecmd_time_sync *tsync)
+{
+	struct clock_sync_context *clock_context;
+	struct kvm_clock_sync *kvm = NULL;
+	int i;
+
+	clock_context = (struct clock_sync_context *)tsync->context;
+	if (clock_context)
+		kvm = (struct kvm_clock_sync *)clock_context->proto_data;
+	if (kvm) {
+		for (i = 0; i < kvm->vcpu_count; i++) {
+			free(kvm->vcpu_offsets[i]);
+			kvm->vcpu_offsets[i] = NULL;
+			free(kvm->vcpu_scalings[i]);
+			kvm->vcpu_scalings[i] = NULL;
+		}
+		if (kvm->tep)
+			tep_free(kvm->tep);
+		if (kvm->marker_fd >= 0)
+			close(kvm->marker_fd);
+		free(kvm);
+	}
+	return -1;
+}
+
+static int read_ll_form_file(char *file, long long *res)
+{
+	char buf[32];
+	int ret;
+	int fd;
+
+	if (!file)
+		return -1;
+	fd = open(file, O_RDONLY | O_NONBLOCK);
+	if (fd < 0)
+		return -1;
+	ret = read(fd, buf, 32);
+	close(fd);
+	if (ret <= 0)
+		return -1;
+
+	*res = strtoll(buf, NULL, 10);
+
+	return 0;
+}
+
+static int kvm_clock_host(struct tracecmd_time_sync *tsync,
+			  long long *offset, long long *scaling,
+			  long long *timestamp, unsigned int cpu)
+{
+	char sync_proto[TRACECMD_TSYNC_PNAME_LENGTH];
+	struct clock_sync_context *clock_context;
+	struct kvm_clock_offset_msg packet;
+	struct kvm_clock_sync *kvm = NULL;
+	long long kvm_scaling = 1;
+	unsigned int sync_msg;
+	long long kvm_offset;
+	unsigned int size;
+	char *msg;
+	int ret;
+
+	clock_context = (struct clock_sync_context *)tsync->context;
+	if (clock_context)
+		kvm = (struct kvm_clock_sync *)clock_context->proto_data;
+	if (!kvm || !kvm->vcpu_offsets || !kvm->vcpu_offsets[0])
+		return -1;
+	if (cpu >= kvm->vcpu_count)
+		return -1;
+	ret = read_ll_form_file(kvm->vcpu_offsets[cpu], &kvm_offset);
+	if (ret < 0)
+		return -1;
+	if (kvm->vcpu_scalings && kvm->vcpu_scalings[cpu])
+		read_ll_form_file(kvm->vcpu_scalings[cpu], &kvm_scaling);
+	msg = (char *)&packet;
+	size = sizeof(packet);
+	ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
+					  sync_proto, &sync_msg,
+					  &size, &msg);
+	if (ret || strncmp(sync_proto, KVM_NAME, TRACECMD_TSYNC_PNAME_LENGTH) ||
+	    sync_msg != KVM_SYNC_PKT_REQUEST)
+		return -1;
+
+	packet.offset = -kvm_offset;
+	packet.scaling = kvm_scaling;
+	ret = tracecmd_msg_send_time_sync(tsync->msg_handle, KVM_NAME,
+					  KVM_SYNC_PKT_RESPONSE, sizeof(packet),
+					  (char *)&packet);
+	if (ret)
+		return -1;
+
+	*scaling = packet.scaling;
+	*offset = packet.offset;
+	*timestamp = packet.ts;
+
+	return 0;
+}
+
+#define KVM_EVENT_MARKER	"kvm sync event"
+static int kvm_marker_find(struct tep_event *event, struct tep_record *record,
+			   int cpu, void *context)
+{
+	struct kvm_clock_sync *kvm = (struct kvm_clock_sync *)context;
+	struct tep_format_field *field;
+	struct tep_format_field *id;
+	char *marker;
+
+	/* Make sure this is our event */
+	if (event->id != kvm->raw_id)
+		return 0;
+	id = tep_find_field(event, "id");
+	field = tep_find_field(event, "buf");
+	if (field && id &&
+	    record->size >= (id->offset + strlen(KVM_EVENT_MARKER) + 1)) {
+		marker = (char *)(record->data + id->offset);
+		if (!strcmp(marker, KVM_EVENT_MARKER)) {
+			kvm->ts = record->ts;
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+
+static int kvm_clock_guest(struct tracecmd_time_sync *tsync,
+			   long long *offset,
+			   long long *scaling,
+			   long long *timestamp)
+{
+	char sync_proto[TRACECMD_TSYNC_PNAME_LENGTH];
+	struct clock_sync_context *clock_context;
+	struct kvm_clock_offset_msg packet;
+	struct kvm_clock_sync *kvm = NULL;
+	unsigned int sync_msg;
+	unsigned int size;
+	char *msg;
+	int ret;
+
+	clock_context = (struct clock_sync_context *)tsync->context;
+	if (clock_context)
+		kvm = (struct kvm_clock_sync *)clock_context->proto_data;
+	if (!kvm)
+		return -1;
+	kvm->ts = 0;
+	memset(&packet, 0, sizeof(packet));
+	tracefs_instance_file_write(clock_context->instance, "trace", "\0");
+	write(kvm->marker_fd, KVM_EVENT_MARKER, strlen(KVM_EVENT_MARKER) + 1);
+	kvm->ts = 0;
+	tracefs_iterate_raw_events(kvm->tep, clock_context->instance,
+				   NULL, 0, kvm_marker_find, kvm);
+	packet.ts = kvm->ts;
+	ret = tracecmd_msg_send_time_sync(tsync->msg_handle, KVM_NAME,
+					  KVM_SYNC_PKT_REQUEST, sizeof(packet),
+					  (char *)&packet);
+	if (ret)
+		return -1;
+	msg = (char *)&packet;
+	size = sizeof(packet);
+	ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
+					  sync_proto, &sync_msg,
+					  &size, &msg);
+	if (ret || strncmp(sync_proto, KVM_NAME, TRACECMD_TSYNC_PNAME_LENGTH) ||
+	    sync_msg != KVM_SYNC_PKT_RESPONSE)
+		return -1;
+
+	*scaling = packet.scaling;
+	*offset = packet.offset;
+	*timestamp = packet.ts;
+	return 0;
+}
+
+static int kvm_clock_sync_calc(struct tracecmd_time_sync *tsync,
+			       long long *offset, long long *scaling,
+			       long long *timestamp, unsigned int cpu)
+{
+	struct clock_sync_context *clock_context;
+	int ret;
+
+	if (!tsync || !tsync->context)
+		return -1;
+
+	clock_context = (struct clock_sync_context *)tsync->context;
+
+	if (clock_context->is_guest)
+		ret = kvm_clock_guest(tsync, offset, scaling, timestamp);
+	else
+		ret = kvm_clock_host(tsync, offset, scaling, timestamp, cpu);
+	return ret;
+}
+
+int kvm_clock_sync_register(void)
+{
+	int role = TRACECMD_TIME_SYNC_ROLE_GUEST;
+	int clock = 0;
+
+	if (kvm_support_check(false)) {
+		role |= TRACECMD_TIME_SYNC_ROLE_HOST;
+		clock = TRACECMD_CLOCK_X86_TSC;
+	}
+	return tracecmd_tsync_proto_register(KVM_NAME, KVM_ACCURACY,
+					     role, clock, 0,
+					     kvm_clock_sync_init,
+					     kvm_clock_sync_free,
+					     kvm_clock_sync_calc);
+}
+
+int kvm_clock_sync_unregister(void)
+{
+	return tracecmd_tsync_proto_unregister(KVM_NAME);
+}
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index fb18075b..aa3e3fc1 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -63,6 +63,7 @@ static struct tsync_proto *tsync_proto_find(const char *proto_name)
 void tracecmd_tsync_init(void)
 {
 	ptp_clock_sync_register();
+	kvm_clock_sync_register();
 }
 
 int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int roles,
@@ -433,6 +434,7 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
 	}
 	pthread_mutex_destroy(&tsync->lock);
 	pthread_cond_destroy(&tsync->cond);
+	pthread_barrier_destroy(&tsync->first_sync);
 	free(tsync->clock_str);
 }
 
@@ -630,23 +632,24 @@ static inline void get_ts_loop_delay(struct timespec *timeout, int delay_ms)
  * It loops infinite, until the timesync semaphore is released
  *
  */
-void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
+int tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
 {
 	struct tsync_probe_request_msg probe;
 	int ts_array_size = CLOCK_TS_ARRAY;
 	struct tsync_proto *proto;
 	struct timespec timeout;
+	bool first = true;
 	bool end = false;
 	int ret;
 	int i;
 
 	proto = tsync_proto_find(tsync->proto_name);
 	if (!proto || !proto->clock_sync_calc)
-		return;
+		return -1;
 
 	clock_context_init(tsync, false);
 	if (!tsync->context)
-		return;
+		return -1;
 
 	if (tsync->loop_interval > 0 &&
 	    tsync->loop_interval < (CLOCK_TS_ARRAY * 1000))
@@ -664,6 +667,10 @@ void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
 			if (ret)
 				break;
 		}
+		if (first) {
+			first = false;
+			pthread_barrier_wait(&tsync->first_sync);
+		}
 		if (end || i < tsync->vcpu_count)
 			break;
 		if (tsync->loop_interval > 0) {
@@ -685,4 +692,5 @@ void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
 				    TRACECMD_TSYNC_PROTO_NONE,
 				    TRACECMD_TIME_SYNC_CMD_STOP,
 				    0, NULL);
+	return 0;
 }
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index d7de8298..ec4b2d86 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -61,14 +61,19 @@ error:
 static void *tsync_host_thread(void *data)
 {
 	struct tracecmd_time_sync *tsync = NULL;
+	int ret;
 
 	tsync = (struct tracecmd_time_sync *)data;
 
-	tracecmd_tsync_with_guest(tsync);
+	ret = tracecmd_tsync_with_guest(tsync);
 
 	tracecmd_msg_handle_close(tsync->msg_handle);
 	tsync->msg_handle = NULL;
 
+	/* tsync with guest failed, release the barrier */
+	if (ret)
+		pthread_barrier_wait(&tsync->first_sync);
+
 	pthread_exit(0);
 }
 
@@ -106,6 +111,7 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
 		instance->tsync.clock_str = strdup(top_instance.clock);
 	pthread_mutex_init(&instance->tsync.lock, NULL);
 	pthread_cond_init(&instance->tsync.cond, NULL);
+	pthread_barrier_init(&instance->tsync.first_sync, NULL, 2);
 
 	pthread_attr_init(&attrib);
 	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
@@ -117,6 +123,7 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
 		if (!get_first_cpu(&pin_mask, &mask_size))
 			pthread_setaffinity_np(instance->tsync_thread, mask_size, pin_mask);
 		instance->tsync_thread_running = true;
+		pthread_barrier_wait(&instance->tsync.first_sync);
 	}
 
 	if (pin_mask)
-- 
2.29.2

