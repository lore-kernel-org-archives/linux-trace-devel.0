Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA19C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Jul 2022 01:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237002AbiGHBmu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jul 2022 21:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237102AbiGHBmt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jul 2022 21:42:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBA173580
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jul 2022 18:42:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC24962085
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Jul 2022 01:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DD5C341C8;
        Fri,  8 Jul 2022 01:42:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1o9d14-002qLt-2t;
        Thu, 07 Jul 2022 21:42:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Vineeth Pillai <vineethrp@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] trace-cmd: Have the pid to vcpu mappings know about sparse maps
Date:   Thu,  7 Jul 2022 21:42:44 -0400
Message-Id: <20220708014244.677826-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220708014244.677826-1-rostedt@goodmis.org>
References: <20220708014244.677826-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the kvm vcpuX files do not map directly to the guest's CPUs, then the
tmaps will not match and the host will not have a mapping to the guest.

That is, if the hypervisor has:

 # ls -d /sys/kernel/debug/kvm/[0-9]*/vcpu*
/sys/kernel/debug/kvm/408-7/vcpu0   /sys/kernel/debug/kvm/408-7/vcpu24
/sys/kernel/debug/kvm/408-7/vcpu1   /sys/kernel/debug/kvm/408-7/vcpu26
/sys/kernel/debug/kvm/408-7/vcpu16  /sys/kernel/debug/kvm/408-7/vcpu28
/sys/kernel/debug/kvm/408-7/vcpu18  /sys/kernel/debug/kvm/408-7/vcpu30
/sys/kernel/debug/kvm/408-7/vcpu20  /sys/kernel/debug/kvm/408-7/vcpu8
/sys/kernel/debug/kvm/408-7/vcpu22  /sys/kernel/debug/kvm/408-7/vcpu9

But the guest sees CPUs 0-11, the kvm exit/enter events will also show the
above numbers (vcpu 8 for guest CPU 3).

Have the mapping logic look at these files and sort them, and then map the
threads to CPU via them.

Link: https://lore.kernel.org/all/20220504010242.1388192-1-vineethrp@google.com/

Reported-by: Vineeth Pillai <vineethrp@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-tsync.c | 100 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 99 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index a96b4e43e0d9..57baff399bd3 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -16,14 +16,105 @@ struct trace_mapping {
 	struct tep_format_field		*common_pid;
 	int				*pids;
 	int				*map;
+	int				*vcpu;
 	int				max_cpus;
 };
 
+static int cmp_tmap_vcpu(const void *A, const void *B)
+{
+	const int *a = A;
+	const int *b = B;
+
+	if (*a < *b)
+		return -1;
+	return *a > *b;
+}
+
+static int map_kvm_vcpus(int guest_pid, struct trace_mapping *tmap)
+{
+	struct dirent *entry;
+	const char *debugfs;
+	char *vm_dir_str = NULL;
+	char *pid_file = NULL;
+	char *kvm_dir;
+	int pid_file_len;
+	bool found = false;
+	DIR *dir;
+	int ret = -1;
+	int i;
+
+	tmap->vcpu = malloc(sizeof(*tmap->vcpu) * tmap->max_cpus);
+	if (!tmap->vcpu)
+		return -1;
+
+	memset(tmap->vcpu, -1, sizeof(*tmap->vcpu) * tmap->max_cpus);
+
+	debugfs = tracefs_debug_dir();
+	if (!debugfs)
+		return -1;
+
+	if (asprintf(&kvm_dir, "%s/kvm", debugfs) < 0)
+		return -1;
+
+	dir = opendir(kvm_dir);
+	if (!dir)
+		goto out;
+
+	if (asprintf(&pid_file, "%d-", guest_pid) <= 0)
+		goto out;
+
+	pid_file_len = strlen(pid_file);
+
+	while ((entry = readdir(dir))) {
+		if (entry->d_type != DT_DIR ||
+		    strncmp(entry->d_name, pid_file, pid_file_len) != 0)
+			continue;
+		if (asprintf(&vm_dir_str, "%s/%s", kvm_dir, entry->d_name) < 0)
+			goto out;
+		found = true;
+		break;
+	}
+	if (!found)
+		goto out;
+
+	closedir(dir);
+	dir = opendir(vm_dir_str);
+	if (!dir)
+		goto out;
+	i = 0;
+	while ((entry = readdir(dir))) {
+		if (entry->d_type != DT_DIR ||
+		    strncmp(entry->d_name, "vcpu", 4))
+			continue;
+		if (i == tmap->max_cpus)
+			goto out;
+		tmap->vcpu[i] = strtol(entry->d_name + 4, NULL, 10);
+		i++;
+	}
+
+	if (i < tmap->max_cpus)
+		goto out;
+
+	qsort(tmap->vcpu, tmap->max_cpus, sizeof(*tmap->vcpu), cmp_tmap_vcpu);
+
+	ret = 0;
+
+ out:
+	if (dir)
+		closedir(dir);
+	free(vm_dir_str);
+	free(pid_file);
+	free(kvm_dir);
+
+	return ret;
+}
+
 static int map_vcpus(struct tep_event *event, struct tep_record *record,
 		     int cpu, void *context)
 {
 	struct trace_mapping *tmap = context;
 	unsigned long long val;
+	int *vcpu;
 	int type;
 	int pid;
 	int ret;
@@ -53,10 +144,13 @@ static int map_vcpus(struct tep_event *event, struct tep_record *record,
 
 	cpu = (int)val;
 
+	vcpu = bsearch(&cpu, tmap->vcpu, tmap->max_cpus, sizeof(cpu), cmp_tmap_vcpu);
 	/* Sanity check, warn? */
-	if (cpu >= tmap->max_cpus)
+	if (!vcpu)
 		return 0;
 
+	cpu = vcpu - tmap->vcpu;
+
 	/* Already have this one? Should we check if it is the same? */
 	if (tmap->map[cpu] >= 0)
 		return 0;
@@ -123,6 +217,10 @@ static void stop_mapping_vcpus(int cpu_count, struct trace_guest *guest)
 	if (!tmap.map)
 		return;
 
+	/* Check if the kvm vcpu mappings are the same */
+	if (map_kvm_vcpus(guest->pid, &tmap) < 0)
+		goto out;
+
 	for (i = 0; i < tmap.max_cpus; i++)
 		tmap.map[i] = -1;
 
-- 
2.35.1

