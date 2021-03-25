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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E108C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 07:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62FC161A2A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 07:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhCYHOg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 03:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhCYHOY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 03:14:24 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEA7C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 00:14:23 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id c8so1148362wrq.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 00:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XYSmMLM3iWs4wwsj53ncOba+VO0uBWwhQt0ixqq+Igc=;
        b=rqx3PPPK8FYodPZ6a4XKMYW8SlTdd1P+8ALfY/rDZnkW19tniIeBGvlsx0b2WBOM2X
         vV/goiPiRNEp+3tHUWriMAWXiafZ1MQpZNo4FnvyzatltAWItJraiXK6MtyW2h/9pCfs
         RWzgCDMw43Zdj6W9tpoup/3haxp9YknaNlqHvNDiwr/wrQxKK4HBP1ZTLQXx2ZcW893y
         THuLbXmOOuoEJPHtAUw9sYbKVTOAksiTGk2S1/ftAwehJ1VkSelam/Yj1IhcK8yFN8u+
         aAnmZHDEZgM3UVroT6ByWOogVwmigPlKFPC587Sn71KwlxuR0NcvZtztY302eRHV+lak
         lWMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XYSmMLM3iWs4wwsj53ncOba+VO0uBWwhQt0ixqq+Igc=;
        b=e9NJgEoQZZx6L6RnysmhpHpprkIj5HBUC6CkRU/oQ2f8AoctxQF97YdTJLLeCRnZgl
         BORuggKVO8gtOISTPoaBlYPQnC72oVECl3s9P/ZvbAwveY33y8pOMfLFHazQ3SMPn5E7
         QV6wtVYeftfnOyv0mQjsMsZq6gYIO0S3Aax3mXvHd/IV+CX4MoV2smrCmKNAwdJB4BUe
         lUVI4aYUyThpl/a1waskmnosq5j2VG90arxSTfWQhShv+KJ94jRDHf5o8c3Pb/LpIdq+
         GL5uHq1DF1CP0Rv/HNnsqKqgV+kUHa0pDCzrBd1/oIg1VegdZGFGGgU0vtDxv7TYYid0
         DhHQ==
X-Gm-Message-State: AOAM53121E3AS+RG9Ze3Mj/7r7924d6bJHQznDxVkQZIcgaI03etB5oj
        7op/GEbmfAnLqN4f7f0M4R0=
X-Google-Smtp-Source: ABdhPJyyOu7rTOYZp7jVwK2CXcHXVp6UMkymPC5LTNi9ZM8jC28e72OXSeXAVEM53BaZmX1l/Ihllw==
X-Received: by 2002:a5d:4ac7:: with SMTP id y7mr7304732wrs.395.1616656462289;
        Thu, 25 Mar 2021 00:14:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q4sm5177487wma.20.2021.03.25.00.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 00:14:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, stefano.devenuto99@gmail.com
Subject: [PATCH v33 5/5] trace-cmd [POC]: Add KVM timestamp synchronization plugin
Date:   Thu, 25 Mar 2021 09:14:13 +0200
Message-Id: <20210325071413.543640-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325071413.543640-1-tz.stoyanov@gmail.com>
References: <20210325071413.543640-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added new timestamp synchronization plugin for KVM hosts. It reads the
clock offsets directly from the KVM debug filesystem, if available.
The plugin works only with x86-tsc ftrace clock.
Note: KVM clock scaling is not supported yet. If a non-default KVM
scaling is detected, the KVM plugin is not used for timestamp
synchronization.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/Makefile                    |   1 +
 lib/trace-cmd/include/trace-tsync-local.h |   1 +
 lib/trace-cmd/trace-timesync-kvm.c        | 533 ++++++++++++++++++++++
 lib/trace-cmd/trace-timesync.c            |   1 +
 4 files changed, 536 insertions(+)
 create mode 100644 lib/trace-cmd/trace-timesync-kvm.c

diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 486ea7d1..afd74e1d 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -23,6 +23,7 @@ endif
 OBJS += trace-timesync.o
 ifeq ($(VSOCK_DEFINED), 1)
 OBJS += trace-timesync-ptp.o
+OBJS += trace-timesync-kvm.o
 endif
 
 # Additional util objects
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index b3a3bdfc..7e56d187 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -65,5 +65,6 @@ int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int role
 int tracecmd_tsync_proto_unregister(char *proto_name);
 
 int ptp_clock_sync_register(void);
+int kvm_clock_sync_register(void);
 
 #endif /* _TRACE_TSYNC_LOCAL_H */
diff --git a/lib/trace-cmd/trace-timesync-kvm.c b/lib/trace-cmd/trace-timesync-kvm.c
new file mode 100644
index 00000000..c229c2d7
--- /dev/null
+++ b/lib/trace-cmd/trace-timesync-kvm.c
@@ -0,0 +1,533 @@
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
+#include <ctype.h>
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
+/* default KVM scaling values, taken from the Linux kernel */
+#define KVM_SCALING_AMD_DEFAULT		(1ULL<<32)
+#define KVM_SCALING_INTEL_DEFAULT	(1ULL<<48)
+
+#define KVM_SYNC_PKT_REQUEST	1
+#define KVM_SYNC_PKT_RESPONSE	2
+
+typedef __s64 s64;
+
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
+static bool kvm_scaling_check_vm_cpu(char *vname, char *cpu)
+{
+	long long scaling;
+	char *path;
+	int ret;
+
+	if (asprintf(&path, "%s/%s/%s", vname, cpu, KVM_DEBUG_SCALING_FILE) < 0)
+		return true;
+	ret = read_ll_form_file(path, &scaling);
+	free(path);
+
+	/*
+	 * If there is a scaling, different from the default -
+	 * return false, not supported.
+	 */
+	if (!ret &&
+	    scaling != KVM_SCALING_AMD_DEFAULT && scaling != KVM_SCALING_INTEL_DEFAULT)
+		return false;
+
+	return true;
+}
+
+static bool kvm_scaling_check_vm(char *name)
+{
+	struct dirent *entry;
+	char *vdir;
+	DIR *dir;
+
+	if (asprintf(&vdir, "%s/%s", KVM_DEBUG_FS, name) < 0)
+		return true;
+
+	dir = opendir(vdir);
+	if (!dir) {
+		free(vdir);
+		return true;
+	}
+	while ((entry = readdir(dir))) {
+		if (entry->d_type == DT_DIR && !strncmp(entry->d_name, "vcpu", 4) &&
+		    !kvm_scaling_check_vm_cpu(vdir, entry->d_name))
+			break;
+	}
+
+	closedir(dir);
+	free(vdir);
+	return entry == NULL;
+}
+static bool kvm_scaling_check(void)
+{
+	struct dirent *entry;
+	DIR *dir;
+
+	dir = opendir(KVM_DEBUG_FS);
+	if (!dir)
+		return true;
+
+	while ((entry = readdir(dir))) {
+		if (entry->d_type == DT_DIR && isdigit(entry->d_name[0]) &&
+		    !kvm_scaling_check_vm(entry->d_name))
+			break;
+	}
+	closedir(dir);
+	return entry == NULL;
+}
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
+
+	return kvm_scaling_check();
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
+	if (kvm->vcpu_scalings && kvm->vcpu_scalings[cpu]) {
+		read_ll_form_file(kvm->vcpu_scalings[cpu], &kvm_scaling);
+		if (kvm_scaling == KVM_SCALING_AMD_DEFAULT ||
+		    kvm_scaling == KVM_SCALING_INTEL_DEFAULT)
+			kvm_scaling = 1;
+	}
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
index ada7ddb6..8b8afd01 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -66,6 +66,7 @@ void tracecmd_tsync_init(void)
 {
 #ifdef VSOCK
 	ptp_clock_sync_register();
+	kvm_clock_sync_register();
 #endif
 }
 
-- 
2.30.2

