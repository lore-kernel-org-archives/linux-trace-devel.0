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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C2FC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FD7423356
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbhAUHrS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 02:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727718AbhAUHrM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 02:47:12 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE24C06179E
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:17 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id a1so734778wrq.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PJSb9OOJPBlS6pFTzi4KYc8KJscqDen08f3PVzQ1c1o=;
        b=DB8HcmCBGFfHzVepztfX3s+2i8Q6MLfZtRm6CX/30CEHrFoaRCGliwzs+21GmqHK1z
         etl2byps5/cS/GgSrwJKt+uijMRP6QJPwaOVGPBQtunbtiLOKvFKVYgtPA4TVd9Oe71i
         nQJVRRJfuuB/h9oB5XnqiBDGZNv221yg1p4epj34VsAp4Dz2M58nWgL/ssh4pphJmSQW
         CW10kAKB8RBeSLjAw1dnyf4x3fL6HfJcHqlF1NW2cWkvIf0D8UlinD1sUX6di+WJW/4c
         3BcovT31lbvLspsYfHXnq22qG9LtHtS0ozDBDFb7qql+sM3l0cPvRXWh3CRS071H07hQ
         FjVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PJSb9OOJPBlS6pFTzi4KYc8KJscqDen08f3PVzQ1c1o=;
        b=h1dVHj6JdXnm+XMFSw/cV8Qr/6DlmCkoynfOMgGRvYxjZ7pzbdx/nq+LcIJZtGZ1v3
         SJyjW9cEhM880bMmkKG+vVClV0m8EmRgF18+f4NvTZkcWP1h+AUpmwK1qb1xn0kj1jlf
         3P+qT6/reNKqi2LBwUTrE2UDSki6SwbK6pnp1Q6ZZiP1V1dVNERuYSBVgDLbm2nWys16
         tHsD5uoNySX0m+fj1t/Nnsl6gvBbMNUK8t26zZxxqEjV8zb9BwpulfHu1UBx1y6j0SeI
         xgJqhLpIsTZ0QMjrbsvjUJ7T35kn2X8qqQQhh7YwyEcNUe0H5+sPvZa9HDzRW5C3mlt+
         aqqg==
X-Gm-Message-State: AOAM530TMsU1Cog9LJJQO2xudzZP9GZkwJVoaCABCcw5sGYa4q3YsHQN
        q00GGSAriwXGe+gve06XGqoqqNFGuyopP/vl
X-Google-Smtp-Source: ABdhPJw93wucaHpmni7sMGMPi1DjhJk5uw6rIOgbQcesOQYJhOGSSU8iS/QVtGasgUEjgYnF7Tb2lA==
X-Received: by 2002:a05:6000:368:: with SMTP id f8mr12781122wrf.150.1611215116263;
        Wed, 20 Jan 2021 23:45:16 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm6788474wmj.32.2021.01.20.23.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 23:45:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v26 15/15] trace-cmd [POC]: Add KVM timestamp synchronization plugin
Date:   Thu, 21 Jan 2021 09:44:56 +0200
Message-Id: <20210121074456.157658-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121074456.157658-1-tz.stoyanov@gmail.com>
References: <20210121074456.157658-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/Makefile                    |   1 +
 lib/trace-cmd/include/trace-tsync-local.h |   1 +
 lib/trace-cmd/trace-timesync-kvm.c        | 459 ++++++++++++++++++++++
 lib/trace-cmd/trace-timesync.c            |   1 +
 4 files changed, 462 insertions(+)
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
index 00000000..ba3a958a
--- /dev/null
+++ b/lib/trace-cmd/trace-timesync-kvm.c
@@ -0,0 +1,459 @@
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
+				   kvm_marker_find, kvm);
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
index b8ed82c7..0747ab42 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -65,6 +65,7 @@ static struct tsync_proto *tsync_proto_find(const char *proto_name)
 void tracecmd_tsync_init(void)
 {
 	ptp_clock_sync_register();
+	kvm_clock_sync_register();
 }
 
 int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int roles,
-- 
2.29.2

