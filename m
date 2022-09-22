Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E88DC6FA8E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 00:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiIVAZp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 20:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiIVAZn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 20:25:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CA49CCEB
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 17:25:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E84A62985
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 00:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC75C433D7;
        Thu, 22 Sep 2022 00:25:41 +0000 (UTC)
Date:   Wed, 21 Sep 2022 20:26:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     uekawa@google.com
Subject: trace-cmd report: Add callback for kvm plugin to show guest
 functions
Message-ID: <20220921202642.44fec719@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Starting with libtraceevent 1.6.2, the kvm plugin will call a weak
function that can be overridden by the application (in this case
trace-cmd) called tep_plugin_kvm_get_func() that passes in the event, the
record, and an address to a value containing the address of the function
being requested. If the application has the guest mapping of addresses to
function names (usually taken from kallsyms), then it can define this
function to return the name of the function at the given address of the
guest.

Optionally, it can update the value holding the address, to the start of
the function such that the tep kvm plugin can print not only the function
name, but also the address offset of the original location and the
function itself.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-read.c | 94 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index db9bb2e5219f..b8931cf95543 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1040,6 +1040,98 @@ static bool skip_record(struct handle_list *handles, struct tep_record *record,
 	return !found;
 }
 
+struct kvm_cpu_map {
+	struct tracecmd_input		*guest_handle;
+	int				guest_vcpu;
+	int				host_pid;
+};
+
+static struct kvm_cpu_map *vcpu_maps;
+static int nr_vcpu_maps;
+
+static int cmp_map(const void *A, const void *B)
+{
+	const struct kvm_cpu_map *a = A;
+	const struct kvm_cpu_map *b = B;
+
+	if (a->host_pid < b->host_pid)
+		return -1;
+	return a->host_pid > b->host_pid;
+}
+
+static void map_vcpus(struct tracecmd_input **handles, int nr_handles)
+{
+	struct tracecmd_input *host_handle = handles[0];
+	unsigned long long traceid;
+	struct kvm_cpu_map *map;
+	const int *cpu_pids;
+	const char *name;
+	int vcpu_count;
+	int ret;
+	int i, k;
+
+	for (i = 1; i < nr_handles; i++) {
+		traceid = tracecmd_get_traceid(handles[i]);
+		ret = tracecmd_get_guest_cpumap(host_handle, traceid,
+						&name, &vcpu_count, &cpu_pids);
+		if (ret)
+			continue;
+		map = realloc(vcpu_maps, sizeof(*map) * (nr_vcpu_maps + vcpu_count));
+		if (!map)
+			die("Could not allocate vcpu maps");
+
+		vcpu_maps = map;
+		map += nr_vcpu_maps;
+		nr_vcpu_maps += vcpu_count;
+
+		for (k = 0; k < vcpu_count; k++) {
+			map[k].guest_handle = handles[i];
+			map[k].guest_vcpu = k;
+			map[k].host_pid = cpu_pids[k];
+		}
+	}
+	if (!vcpu_maps)
+		return;
+
+	qsort(vcpu_maps, nr_vcpu_maps, sizeof(*map), cmp_map);
+}
+
+
+const char *tep_plugin_kvm_get_func(struct tep_event *event,
+				    struct tep_record *record,
+				    unsigned long long *val)
+{
+	struct tep_handle *tep;
+	struct kvm_cpu_map *map;
+	struct kvm_cpu_map key;
+	unsigned long long rip = *val;
+	const char *func;
+	int pid;
+
+	if (!vcpu_maps || !nr_vcpu_maps)
+		return NULL;
+
+	/*
+	 * A kvm event is referencing an address of the guest.
+	 * get the PID of this event, and then find which guest
+	 * it belongs to. Then return the function name from that guest's
+	 * handle.
+	 */
+	pid = tep_data_pid(event->tep, record);
+
+	key.host_pid = pid;
+	map = bsearch(&key, vcpu_maps, nr_vcpu_maps, sizeof(*vcpu_maps), cmp_map);
+
+	if (!map)
+		return NULL;
+
+	tep = tracecmd_get_tep(map->guest_handle);
+	func = tep_find_function(tep, rip);
+	if (func)
+		*val = tep_find_function_address(tep, rip);
+	return func;
+}
+
 static int process_record(struct tracecmd_input *handle, struct tep_record *record,
 			  int cpu, void *data)
 {
@@ -1192,6 +1284,8 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		handle_array[nr_handles++] = handles->handle;
 	}
 
+	map_vcpus(handle_array, nr_handles);
+
 	tracecmd_iterate_events_multi(handle_array, nr_handles,
 				      process_record, &last_timestamp);
 
-- 
2.35.1

