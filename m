Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A6DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiENCzh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiENCzW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DA834A96A
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47609B83265
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B4FC341C6;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XMx-KW;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 16/26] trace-cmd: Move tsync as guest and host helpers into trace-tsync.c
Date:   Fri, 13 May 2022 22:47:46 -0400
Message-Id: <20220514024756.1319681-17-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Create a trace-tsync.c file to house the tsync host and guest helper
functions, and have the trace-record.c and trace-agent.c call them.

This is just a clean up to simplify the code for when an agent proxy is
added.

Also add some comments about these functions.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/Makefile              |   1 +
 tracecmd/include/trace-local.h |  10 ++
 tracecmd/trace-agent.c         |  17 ---
 tracecmd/trace-record.c        | 186 -------------------------
 tracecmd/trace-tsync.c         | 242 +++++++++++++++++++++++++++++++++
 5 files changed, 253 insertions(+), 203 deletions(-)
 create mode 100644 tracecmd/trace-tsync.c

diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 0114948fe385..56be9a3b88d1 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -38,6 +38,7 @@ TRACE_CMD_OBJS += trace-clear.o
 TRACE_CMD_OBJS += trace-vm.o
 TRACE_CMD_OBJS += trace-convert.o
 TRACE_CMD_OBJS += trace-agent.o
+TRACE_CMD_OBJS += trace-tsync.o
 TRACE_CMD_OBJS += trace-setup-guest.o
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-vsock.o
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index f3b805fa7bad..5febe9a60a54 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -341,6 +341,16 @@ int get_guest_pid(unsigned int guest_cid);
 int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu);
 void trace_add_guest_info(struct tracecmd_output *handle, struct buffer_instance *instance);
 
+struct tracecmd_time_sync *
+trace_tsync_as_host(int fd, unsigned long long trace_id,
+		    int loop_interval, int guest_id,
+		    int guest_cpus, const char *proto_name,
+		    const char *clock);
+
+struct tracecmd_time_sync *
+trace_tsync_as_guest(int fd, const char *tsync_proto, const char *clock,
+	       unsigned int remote_id, unsigned int local_id);
+
 /* moved from trace-cmd.h */
 void tracecmd_remove_instances(void);
 int tracecmd_add_event(const char *event_str, int stack);
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index d226833b4fd0..920094702b6d 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -144,23 +144,6 @@ static int wait_for_connection(int fd)
 	return sd;
 }
 
-static struct tracecmd_time_sync *
-trace_tsync_as_guest(int fd, const char *tsync_proto, const char *clock,
-	       unsigned int remote_id, unsigned int local_id)
-{
-	struct tracecmd_time_sync *tsync;
-
-	if (fd < 0)
-		return NULL;
-
-	tsync = tracecmd_tsync_with_host(fd, tsync_proto, clock,
-					 remote_id, local_id);
-	if (!tsync)
-		warning("Failed to negotiate timestamps synchronization with the host");
-
-	return tsync;
-}
-
 static void agent_handle(int sd, int nr_cpus, int page_size, const char *network)
 {
 	struct tracecmd_tsync_protos *tsync_protos = NULL;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 2c595a7918f0..bf85e7936b73 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3824,192 +3824,6 @@ static int open_guest_fifos(const char *guest, int **fds)
 	return i;
 }
 
-struct trace_mapping {
-	struct tep_event		*kvm_entry;
-	struct tep_format_field		*vcpu_id;
-	struct tep_format_field		*common_pid;
-	int				*pids;
-	int				*map;
-	int				max_cpus;
-};
-
-static void start_mapping_vcpus(struct trace_guest *guest)
-{
-	char *pids = NULL;
-	char *t;
-	int len = 0;
-	int s;
-	int i;
-
-	if (!guest->task_pids)
-		return;
-
-	guest->instance = tracefs_instance_create("map_guest_pids");
-	if (!guest->instance)
-		return;
-
-	for (i = 0; guest->task_pids[i] >= 0; i++) {
-		s = snprintf(NULL, 0, "%d ", guest->task_pids[i]);
-		t = realloc(pids, len + s + 1);
-		if (!t) {
-			free(pids);
-			pids = NULL;
-			break;
-		}
-		pids = t;
-		sprintf(pids + len, "%d ", guest->task_pids[i]);
-		len += s;
-	}
-	if (pids) {
-		tracefs_instance_file_write(guest->instance, "set_event_pid", pids);
-		free(pids);
-	}
-	tracefs_instance_file_write(guest->instance, "events/kvm/kvm_entry/enable", "1");
-}
-
-static int map_vcpus(struct tep_event *event, struct tep_record *record,
-		     int cpu, void *context)
-{
-	struct trace_mapping *tmap = context;
-	unsigned long long val;
-	int type;
-	int pid;
-	int ret;
-	int i;
-
-	/* Do we have junk in the buffer? */
-	type = tep_data_type(event->tep, record);
-	if (type != tmap->kvm_entry->id)
-		return 0;
-
-	ret = tep_read_number_field(tmap->common_pid, record->data, &val);
-	if (ret < 0)
-		return 0;
-	pid = (int)val;
-
-	for (i = 0; tmap->pids[i] >= 0; i++) {
-		if (pid == tmap->pids[i])
-			break;
-	}
-	/* Is this thread one we care about ? */
-	if (tmap->pids[i] < 0)
-		return 0;
-
-	ret = tep_read_number_field(tmap->vcpu_id, record->data, &val);
-	if (ret < 0)
-		return 0;
-
-	cpu = (int)val;
-
-	/* Sanity check, warn? */
-	if (cpu >= tmap->max_cpus)
-		return 0;
-
-	/* Already have this one? Should we check if it is the same? */
-	if (tmap->map[cpu] >= 0)
-		return 0;
-
-	tmap->map[cpu] = pid;
-
-	/* Did we get them all */
-	for (i = 0; i < tmap->max_cpus; i++) {
-		if (tmap->map[i] < 0)
-			break;
-	}
-
-	return i == tmap->max_cpus;
-}
-
-static void stop_mapping_vcpus(int cpu_count, struct trace_guest *guest)
-{
-	struct trace_mapping tmap = { };
-	struct tep_handle *tep;
-	const char *systems[] = { "kvm", NULL };
-	int i;
-
-	if (!guest->instance)
-		return;
-
-	tmap.pids = guest->task_pids;
-	tmap.max_cpus = cpu_count;
-
-	tmap.map = malloc(sizeof(*tmap.map) * tmap.max_cpus);
-	if (!tmap.map)
-		return;
-
-	for (i = 0; i < tmap.max_cpus; i++)
-		tmap.map[i] = -1;
-
-	tracefs_instance_file_write(guest->instance, "events/kvm/kvm_entry/enable", "0");
-
-	tep = tracefs_local_events_system(NULL, systems);
-	if (!tep)
-		goto out;
-
-	tmap.kvm_entry = tep_find_event_by_name(tep, "kvm", "kvm_entry");
-	if (!tmap.kvm_entry)
-		goto out_free;
-
-	tmap.vcpu_id = tep_find_field(tmap.kvm_entry, "vcpu_id");
-	if (!tmap.vcpu_id)
-		goto out_free;
-
-	tmap.common_pid = tep_find_any_field(tmap.kvm_entry, "common_pid");
-	if (!tmap.common_pid)
-		goto out_free;
-
-	tracefs_iterate_raw_events(tep, guest->instance, NULL, 0, map_vcpus, &tmap);
-
-	for (i = 0; i < tmap.max_cpus; i++) {
-		if (tmap.map[i] < 0)
-			break;
-	}
-	/* We found all the mapped CPUs */
-	if (i == tmap.max_cpus) {
-		guest->cpu_pid = tmap.map;
-		guest->cpu_max = tmap.max_cpus;
-		tmap.map = NULL;
-	}
-
- out_free:
-	tep_free(tep);
- out:
-	free(tmap.map);
-	tracefs_instance_destroy(guest->instance);
-	tracefs_instance_free(guest->instance);
-}
-
-static struct tracecmd_time_sync *
-trace_tsync_as_host(int fd, unsigned long long trace_id,
-		    int loop_interval, int guest_id,
-		    int guest_cpus, const char *proto_name,
-		    const char *clock)
-{
-	struct tracecmd_time_sync *tsync;
-	struct trace_guest *guest;
-	int guest_pid = -1;
-
-	if (fd < 0)
-		return NULL;
-
-	if (guest_id >= 0) {
-		guest = trace_get_guest(guest_id, NULL);
-		if (guest == NULL)
-			return NULL;
-		guest_pid = guest->pid;
-		start_mapping_vcpus(guest);
-	}
-
-	tsync = tracecmd_tsync_with_guest(trace_id, loop_interval, fd,
-					  guest_pid, guest_cpus, proto_name,
-					  clock);
-
-	if (guest_id >= 0)
-		stop_mapping_vcpus(guest_cpus, guest);
-
-	return tsync;
-}
-
 static int host_tsync(struct common_record_context *ctx,
 		      struct buffer_instance *instance,
 		      unsigned int tsync_port, char *proto)
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
new file mode 100644
index 000000000000..45ebb9c66a19
--- /dev/null
+++ b/tracecmd/trace-tsync.c
@@ -0,0 +1,242 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Google Inc, Steven Rostedt <rostedt@goodmis.org>
+ * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "trace-local.h"
+#include "trace-msg.h"
+
+struct trace_mapping {
+	struct tep_event		*kvm_entry;
+	struct tep_format_field		*vcpu_id;
+	struct tep_format_field		*common_pid;
+	int				*pids;
+	int				*map;
+	int				max_cpus;
+};
+
+static int map_vcpus(struct tep_event *event, struct tep_record *record,
+		     int cpu, void *context)
+{
+	struct trace_mapping *tmap = context;
+	unsigned long long val;
+	int type;
+	int pid;
+	int ret;
+	int i;
+
+	/* Do we have junk in the buffer? */
+	type = tep_data_type(event->tep, record);
+	if (type != tmap->kvm_entry->id)
+		return 0;
+
+	ret = tep_read_number_field(tmap->common_pid, record->data, &val);
+	if (ret < 0)
+		return 0;
+	pid = (int)val;
+
+	for (i = 0; tmap->pids[i] >= 0; i++) {
+		if (pid == tmap->pids[i])
+			break;
+	}
+	/* Is this thread one we care about ? */
+	if (tmap->pids[i] < 0)
+		return 0;
+
+	ret = tep_read_number_field(tmap->vcpu_id, record->data, &val);
+	if (ret < 0)
+		return 0;
+
+	cpu = (int)val;
+
+	/* Sanity check, warn? */
+	if (cpu >= tmap->max_cpus)
+		return 0;
+
+	/* Already have this one? Should we check if it is the same? */
+	if (tmap->map[cpu] >= 0)
+		return 0;
+
+	tmap->map[cpu] = pid;
+
+	/* Did we get them all */
+	for (i = 0; i < tmap->max_cpus; i++) {
+		if (tmap->map[i] < 0)
+			break;
+	}
+
+	return i == tmap->max_cpus;
+}
+
+static void start_mapping_vcpus(struct trace_guest *guest)
+{
+	char *pids = NULL;
+	char *t;
+	int len = 0;
+	int s;
+	int i;
+
+	if (!guest->task_pids)
+		return;
+
+	guest->instance = tracefs_instance_create("map_guest_pids");
+	if (!guest->instance)
+		return;
+
+	for (i = 0; guest->task_pids[i] >= 0; i++) {
+		s = snprintf(NULL, 0, "%d ", guest->task_pids[i]);
+		t = realloc(pids, len + s + 1);
+		if (!t) {
+			free(pids);
+			pids = NULL;
+			break;
+		}
+		pids = t;
+		sprintf(pids + len, "%d ", guest->task_pids[i]);
+		len += s;
+	}
+	if (pids) {
+		tracefs_instance_file_write(guest->instance, "set_event_pid", pids);
+		free(pids);
+	}
+	tracefs_instance_file_write(guest->instance, "events/kvm/kvm_entry/enable", "1");
+}
+
+static void stop_mapping_vcpus(int cpu_count, struct trace_guest *guest)
+{
+	struct trace_mapping tmap = { };
+	struct tep_handle *tep;
+	const char *systems[] = { "kvm", NULL };
+	int i;
+
+	if (!guest->instance)
+		return;
+
+	tmap.pids = guest->task_pids;
+	tmap.max_cpus = cpu_count;
+
+	tmap.map = malloc(sizeof(*tmap.map) * tmap.max_cpus);
+	if (!tmap.map)
+		return;
+
+	for (i = 0; i < tmap.max_cpus; i++)
+		tmap.map[i] = -1;
+
+	tracefs_instance_file_write(guest->instance, "events/kvm/kvm_entry/enable", "0");
+
+	tep = tracefs_local_events_system(NULL, systems);
+	if (!tep)
+		goto out;
+
+	tmap.kvm_entry = tep_find_event_by_name(tep, "kvm", "kvm_entry");
+	if (!tmap.kvm_entry)
+		goto out_free;
+
+	tmap.vcpu_id = tep_find_field(tmap.kvm_entry, "vcpu_id");
+	if (!tmap.vcpu_id)
+		goto out_free;
+
+	tmap.common_pid = tep_find_any_field(tmap.kvm_entry, "common_pid");
+	if (!tmap.common_pid)
+		goto out_free;
+
+	tracefs_iterate_raw_events(tep, guest->instance, NULL, 0, map_vcpus, &tmap);
+
+	for (i = 0; i < tmap.max_cpus; i++) {
+		if (tmap.map[i] < 0)
+			break;
+	}
+	/* We found all the mapped CPUs */
+	if (i == tmap.max_cpus) {
+		guest->cpu_pid = tmap.map;
+		guest->cpu_max = tmap.max_cpus;
+		tmap.map = NULL;
+	}
+
+ out_free:
+	tep_free(tep);
+ out:
+	free(tmap.map);
+	tracefs_instance_destroy(guest->instance);
+	tracefs_instance_free(guest->instance);
+}
+
+/**
+ * trace_tsync_as_host - tsync from the host side
+ * @fd: The descriptor to the peer for tsync
+ * @trace_id: The trace_id of the host
+ * @loop_interval: The loop interval for tsyncs that do periodic syncs
+ * @guest_id: The id for guests (negative if this is over network)
+ * @guest_cpus: The number of CPUs the guest has
+ * @proto_name: The protocol name to sync with
+ * @clock: The clock name to use for tracing
+ *
+ * Start the time synchronization from the host side.
+ * This will start the mapping of the virtual CPUs to host threads
+ * if it is a vsocket connection (not a network).
+ *
+ * Returns a pointer to the tsync descriptor on success or NULL on error.
+ */
+struct tracecmd_time_sync *
+trace_tsync_as_host(int fd, unsigned long long trace_id,
+		    int loop_interval, int guest_id,
+		    int guest_cpus, const char *proto_name,
+		    const char *clock)
+{
+	struct tracecmd_time_sync *tsync;
+	struct trace_guest *guest;
+	int guest_pid = -1;
+
+	if (fd < 0)
+		return NULL;
+
+	if (guest_id >= 0) {
+		guest = trace_get_guest(guest_id, NULL);
+		if (guest == NULL)
+			return NULL;
+		guest_pid = guest->pid;
+		start_mapping_vcpus(guest);
+	}
+
+	tsync = tracecmd_tsync_with_guest(trace_id, loop_interval, fd,
+					  guest_pid, guest_cpus, proto_name,
+					  clock);
+
+	if (guest_id >= 0)
+		stop_mapping_vcpus(guest_cpus, guest);
+
+	return tsync;
+}
+
+/**
+ * trace_tsync_a_guest - tsync from the guest side
+ * @fd: The file descriptor to the peer for tsync
+ * @tsync_proto: The protocol name to sync with
+ * @clock: The clock name to use for tracing
+ * @remote_id: The id to differentiate the remote server with
+ * @loca_id: The id to differentiate the local machine with
+ *
+ * Start the time synchronization from the guest side.
+ *
+ * Returns a pointer to the tsync descriptor on success or NULL on error.
+ */
+struct tracecmd_time_sync *
+trace_tsync_as_guest(int fd, const char *tsync_proto, const char *clock,
+	       unsigned int remote_id, unsigned int local_id)
+{
+	struct tracecmd_time_sync *tsync;
+
+	if (fd < 0)
+		return NULL;
+
+	tsync = tracecmd_tsync_with_host(fd, tsync_proto, clock,
+					 remote_id, local_id);
+	if (!tsync)
+		warning("Failed to negotiate timestamps synchronization with the host");
+
+	return tsync;
+}
-- 
2.35.1

