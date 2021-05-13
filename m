Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780B9C43460
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 20:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A48B6143D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 20:43:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhEMUoc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 May 2021 16:44:32 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:52827 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230305AbhEMUoc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 May 2021 16:44:32 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 13 May 2021 13:43:17 -0700
Received: from vypre.com (unknown [10.21.244.58])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id DB30A20403;
        Thu, 13 May 2021 13:43:19 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 2/2] trace-cmd: Trace timesync to find pids that map vCPUs
Date:   Thu, 13 May 2021 16:43:15 -0400
Message-ID: <20210513204315.1206204-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210513204315.1206204-1-rostedt@goodmis.org>
References: <20210513204315.1206204-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If qemu is not found, then there's no mapping between the vCPUs of the
guest and the threads that run them. As the time sync has the agent run on
all the guest's CPUs, trace it, looking for all kvm_entry, which state
which vCPU the host thread is entering on the guest, and then use that to
create the mapping for the data files.

Only parse for qemu if no CID is given on the command line.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
Changes since v1:
 - Skipped v2 (added to v3 of this patch series)
 - Used some of the new APIs of libtracefs 1.2
 - Call read_qemu_guests is CID is not supplied on the command line.

 tracecmd/include/trace-local.h |   2 +
 tracecmd/trace-record.c        | 202 ++++++++++++++++++++++++++++++++-
 2 files changed, 203 insertions(+), 1 deletion(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index b3997d00..4c5669c9 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -298,11 +298,13 @@ void update_first_instance(struct buffer_instance *instance, int topt);
 void show_instance_file(struct buffer_instance *instance, const char *name);
 
 struct trace_guest {
+	struct tracefs_instance *instance;
 	char *name;
 	int cid;
 	int pid;
 	int cpu_max;
 	int *cpu_pid;
+	int *task_pids;
 };
 struct trace_guest *trace_get_guest(unsigned int cid, const char *name);
 bool trace_have_guests_pid(void);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 5dd8be4a..5219d60b 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3230,6 +3230,38 @@ static int do_accept(int sd)
 	return -1;
 }
 
+/* Find all the tasks associated with the guest pid */
+static void find_tasks(struct trace_guest *guest)
+{
+	struct dirent *dent;
+	char *path;
+	DIR *dir;
+	int ret;
+	int tasks = 0;
+
+	ret = asprintf(&path, "/proc/%d/task", guest->pid);
+	if (ret < 0)
+		return;
+
+	dir = opendir(path);
+	free(path);
+	if (!dir)
+		return;
+
+	while ((dent = readdir(dir))) {
+		int *pids;
+		if (!(dent->d_type == DT_DIR && is_digits(dent->d_name)))
+			continue;
+		pids = realloc(guest->task_pids, sizeof(int) * (tasks + 2));
+		if (!pids)
+			break;
+		pids[tasks++] = strtol(dent->d_name, NULL, 0);
+		pids[tasks] = -1;
+		guest->task_pids = pids;
+	}
+	closedir(dir);
+}
+
 static char *parse_guest_name(char *gname, int *cid, int *port)
 {
 	struct trace_guest *guest;
@@ -3250,10 +3282,18 @@ static char *parse_guest_name(char *gname, int *cid, int *port)
 	} else if (is_digits(gname))
 		*cid = atoi(gname);
 
-	read_qemu_guests();
+	if (*cid < 0)
+		read_qemu_guests();
+
+	if (*cid < 0)
+		return NULL;
+
 	guest = trace_get_guest(*cid, gname);
 	if (guest) {
 		*cid = guest->cid;
+		/* Mapping not found, search for them */
+		if (!guest->cpu_pid)
+			find_tasks(guest);
 		return guest->name;
 	}
 
@@ -3712,6 +3752,162 @@ static int open_guest_fifos(const char *guest, int **fds)
 	return i;
 }
 
+struct trace_mapping {
+	struct tep_event		*kvm_entry;
+	struct tep_format_field		*vcpu_id;
+	struct tep_format_field		*common_pid;
+	int				*pids;
+	int				*map;
+	int				max_cpus;
+};
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
+static void stop_mapping_vcpus(struct buffer_instance *instance,
+			       struct trace_guest *guest)
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
+	tmap.max_cpus = instance->cpu_count;
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
 static int host_tsync(struct common_record_context *ctx,
 		      struct buffer_instance *instance,
 		      unsigned int tsync_port, char *proto)
@@ -3724,11 +3920,15 @@ static int host_tsync(struct common_record_context *ctx,
 	if (guest == NULL)
 		return -1;
 
+	start_mapping_vcpus(guest);
+
 	instance->tsync = tracecmd_tsync_with_guest(top_instance.trace_id,
 						    instance->tsync_loop_interval,
 						    instance->cid, tsync_port,
 						    guest->pid, instance->cpu_count,
 						    proto, ctx->clock);
+	stop_mapping_vcpus(instance, guest);
+
 	if (!instance->tsync)
 		return -1;
 
-- 
2.29.2

