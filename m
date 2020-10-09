Return-Path: <SRS0=rOCb=DQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2130C433DF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 857B322267
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:04:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="foJe9mMH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388503AbgJIOEA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 10:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388481AbgJIOEA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 10:04:00 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF711C0613D2
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Oct 2020 07:03:59 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id qp15so13256716ejb.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Oct 2020 07:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l/XPzoIKRft1vywNhYu+QhKlDGIdQrj+lWHV18bkQJc=;
        b=foJe9mMHXgoNqqW+9pf6PLbFnS9IRwdS/Fxv1V5qnKuuuNmQwe1YkAbsIYjGDVwWzX
         6N+c1sqKeyWdeDccJBLgHz8g7GRZbI7bpFZtkwkewcforPXYMb1uza8yuRAxB595+yyj
         dj+V6aPw+5CM7QzTbc/SiKwzqT60TyGZPIKXv7Re8K9E3V3olh5oUGhHtiSsZYYhbuEa
         31/PxrqJVe98TYjeAKg8u57Jx+06LqPX6COg2LulPu09nhZs/UMpCgPGDtNTLOuA6Ica
         Dku0Pj1RhkhGalO7ltO9ObwdzwAKq+5rq7/0WUW8KUFLQLfy5D3tA9+eCOVfGCXByElb
         wCEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l/XPzoIKRft1vywNhYu+QhKlDGIdQrj+lWHV18bkQJc=;
        b=QvPKR/Hul9alpTFoKXDC015QYIIZFadAFk1by00S/KccHwDz7nub5dnJn23RUJAXdT
         Y/ZgC7QsSHVn4R5SXV4MO5Ek67lbE8trFtL1LQiwYPbxKHItbVngenxCb5ba5Jc2l+5B
         G5r9C4MUtoQBnlZ5HH/AszlYUz6SKbe4vXXKXcJZakISNSyIrXLe12bdieBINrAYM846
         Y/rsyNRjLFTp/1aBxXr1ye2xgIqsANsNHnrekek2uo5OH+jhJzxKTRNiMto4VqgDseMT
         6CQ23iOHe7DqfG6dV0SBv6zj5OS+pNe2nCxrBq9vKIYsIOzL2VAD4bDIjo2vwPgLPkWo
         Kwdg==
X-Gm-Message-State: AOAM530Ye+RsvU3SGQk+CI8db3LTG6J1PG3qB8g8w/1gdTjxyy9Xm646
        vKCFimorRt479I1T+62fp7o=
X-Google-Smtp-Source: ABdhPJwAgmnUiDqYTe94gc7F5shSOAobSFcH77EWMlx41h5AnRe8HSnMwSNq6xafYJTY2mOBwDcN5Q==
X-Received: by 2002:a17:906:eb02:: with SMTP id mb2mr13888401ejb.506.1602252237961;
        Fri, 09 Oct 2020 07:03:57 -0700 (PDT)
Received: from localhost.localdomain ([151.251.253.218])
        by smtp.gmail.com with ESMTPSA id ck19sm6362483ejb.99.2020.10.09.07.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 07:03:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v24 10/10] trace-cmd [POC]: Add KVM timestamp synchronization plugin
Date:   Fri,  9 Oct 2020 17:03:38 +0300
Message-Id: <20201009140338.25260-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201009140338.25260-1-tz.stoyanov@gmail.com>
References: <20201009140338.25260-1-tz.stoyanov@gmail.com>
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
 include/trace-cmd/trace-cmd.h             |   2 +
 lib/trace-cmd/Makefile                    |   1 +
 lib/trace-cmd/include/trace-tsync-local.h |   1 +
 lib/trace-cmd/trace-timesync-kvm.c        | 427 ++++++++++++++++++++++
 lib/trace-cmd/trace-timesync.c            |   1 +
 5 files changed, 432 insertions(+)
 create mode 100644 lib/trace-cmd/trace-timesync-kvm.c

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 48ed4bc0..67c7a42f 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -436,6 +436,7 @@ char *tracecmd_clock_id2str(enum tracecmd_clocks clock);
 enum{
 	TRACECMD_TIME_SYNC_PROTO_NONE	= 0,
 	TRACECMD_TIME_SYNC_PROTO_PTP	= 1,
+	TRACECMD_TIME_SYNC_PROTO_KVM	= 2,
 };
 enum{
 	TRACECMD_TIME_SYNC_CMD_PROBE	= 1,
@@ -447,6 +448,7 @@ enum tracecmd_time_sync_role {
 	TRACECMD_TIME_SYNC_ROLE_GUEST	= 0x02
 };
 
+#define TRACECMD_TIME_SYNC_PROTO_KVM_WEIGHT	100
 #define TRACECMD_TIME_SYNC_PROTO_PTP_WEIGHT	10
 
 struct tracecmd_time_sync {
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 7cab7514..d1b8fc49 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -19,6 +19,7 @@ OBJS += trace-plugin.o
 ifeq ($(VSOCK_DEFINED), 1)
 OBJS += trace-timesync.o
 OBJS += trace-timesync-ptp.o
+OBJS += trace-timesync-kvm.o
 endif
 
 # Additional util objects
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 1af52a12..b75dfe01 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -36,5 +36,6 @@ int tracecmd_tsync_proto_register(unsigned int proto_id, int weight, int roles,
 int tracecmd_tsync_proto_unregister(unsigned int proto_id);
 
 int ptp_clock_sync_register(void);
+int kvm_clock_sync_register(void);
 
 #endif /* _TRACE_TSYNC_LOCAL_H */
diff --git a/lib/trace-cmd/trace-timesync-kvm.c b/lib/trace-cmd/trace-timesync-kvm.c
new file mode 100644
index 00000000..ecf0a880
--- /dev/null
+++ b/lib/trace-cmd/trace-timesync-kvm.c
@@ -0,0 +1,427 @@
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
+static int kvm_clock_host(struct tracecmd_time_sync *tsync,
+			  long long *offset, long long *timestamp)
+{
+	struct clock_sync_context *clock_context;
+	struct kvm_clock_offset_msg packet;
+	struct kvm_clock_sync *kvm = NULL;
+	unsigned int sync_proto, sync_msg;
+	unsigned int size;
+	char buf[32];
+	char *msg;
+	int ret;
+	int fd;
+
+	clock_context = (struct clock_sync_context *)tsync->context;
+	if (clock_context)
+		kvm = (struct kvm_clock_sync *)clock_context->proto_data;
+	if (!kvm || !kvm->vcpu_offsets || !kvm->vcpu_offsets[0])
+		return -1;
+	fd = open(kvm->vcpu_offsets[0], O_RDONLY | O_NONBLOCK);
+	if (fd < 0)
+		return -1;
+	ret = read(fd, buf, 32);
+	close(fd);
+	if (ret <= 0)
+		return -1;
+
+	msg = (char *)&packet;
+	size = sizeof(packet);
+	ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
+					  &sync_proto, &sync_msg,
+					  &size, &msg);
+	if (ret || sync_proto != TRACECMD_TIME_SYNC_PROTO_KVM ||
+	    sync_msg != KVM_SYNC_PKT_REQUEST)
+		return -1;
+
+	packet.offset = -strtoll(buf, NULL, 10);
+	ret = tracecmd_msg_send_time_sync(tsync->msg_handle,
+					  TRACECMD_TIME_SYNC_PROTO_KVM,
+					  KVM_SYNC_PKT_RESPONSE, sizeof(packet),
+					  (char *)&packet);
+	if (ret)
+		return -1;
+
+	*offset = packet.offset;
+	*timestamp = packet.ts;
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
+			   long long *offset, long long *timestamp)
+{
+	struct clock_sync_context *clock_context;
+	struct kvm_clock_offset_msg packet;
+	struct kvm_clock_sync *kvm = NULL;
+	unsigned int sync_proto, sync_msg;
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
+	ret = tracecmd_msg_send_time_sync(tsync->msg_handle,
+					  TRACECMD_TIME_SYNC_PROTO_KVM,
+					  KVM_SYNC_PKT_REQUEST, sizeof(packet),
+					  (char *)&packet);
+	if (ret)
+		return -1;
+	msg = (char *)&packet;
+	size = sizeof(packet);
+	ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
+					  &sync_proto, &sync_msg,
+					  &size, &msg);
+	if (ret || sync_proto != TRACECMD_TIME_SYNC_PROTO_KVM ||
+	    sync_msg != KVM_SYNC_PKT_RESPONSE)
+		return -1;
+
+	*offset = packet.offset;
+	*timestamp = packet.ts;
+	return 0;
+}
+
+static int kvm_clock_sync_calc(struct tracecmd_time_sync *tsync,
+			       long long *offset, long long *timestamp)
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
+		ret = kvm_clock_guest(tsync, offset, timestamp);
+	else
+		ret = kvm_clock_host(tsync, offset, timestamp);
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
+	return tracecmd_tsync_proto_register(TRACECMD_TIME_SYNC_PROTO_KVM,
+					     TRACECMD_TIME_SYNC_PROTO_KVM_WEIGHT,
+					     role, clock,
+					     kvm_clock_sync_init,
+					     kvm_clock_sync_free,
+					     kvm_clock_sync_calc);
+}
+
+int kvm_clock_sync_unregister(void)
+{
+	return tracecmd_tsync_proto_unregister(TRACECMD_TIME_SYNC_PROTO_KVM);
+}
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 2fbb319b..e47f484b 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -54,6 +54,7 @@ static struct tsync_proto *tsync_proto_find(unsigned int proto_id)
 void tracecmd_tsync_init(void)
 {
 	ptp_clock_sync_register();
+	kvm_clock_sync_register();
 }
 
 int tracecmd_tsync_proto_register(unsigned int proto_id, int weight, int roles,
-- 
2.26.2

