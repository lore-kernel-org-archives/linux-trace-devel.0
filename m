Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B04AC43334
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Jul 2022 01:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237103AbiGHBmw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jul 2022 21:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237102AbiGHBmv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jul 2022 21:42:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC36E72EFE
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jul 2022 18:42:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 659B4B824C5
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Jul 2022 01:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25302C3411E;
        Fri,  8 Jul 2022 01:42:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1o9d14-002qLq-2D;
        Thu, 07 Jul 2022 21:42:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Vineeth Pillai <vineethrp@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] trace-cmd: Do not use KVM debug vcpu directories as the CPU mapping
Date:   Thu,  7 Jul 2022 21:42:43 -0400
Message-Id: <20220708014244.677826-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220708014244.677826-1-rostedt@goodmis.org>
References: <20220708014244.677826-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

There are some setups where the vcpu directories in:

  /sys/kernel/debug/kvm/<pid>/vcpuX

Does not match the CPU of the guest. That is, the guest CPU 3 may be
vcpu8.

This breaks the algorithm used when setting up the kvm time
synchronization. As it expects these files to map to the CPU used, and if
one of the vcpuX is greater than the number of CPUs of the guest, it will
fail.

Currently, the locations that do this at least have the guest CPUS
consecutive (non sparse) and they map to the kvm vcpuX in order. That is,
if the vcpuX is sorted by the X it will then map to the CPUs of the guest.

This may not hold true for all setups, but we are currently just going to
solve this one. It appears that the vcpuX in kvm maps to the guest's
apicid in /proc/cpuinfo. More can be done later to make sure the two are
in order and if not to put in meta data that will allow the kvm mappings
to still work.

For now restructure the code by creating a single kvm_clock_files
structure to hold the offset, scaling and frac arrays in a single
structure, and also add the vcpu to it when adding new information from
the vcpuX directories. Then sort the list by the vcpu such that it should
map to the 0-nr_cpus of the guest.

Link: https://lore.kernel.org/all/20220504010242.1388192-1-vineethrp@google.com/

Reported-by: Vineeth Pillai <vineethrp@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-timesync-kvm.c | 104 ++++++++++++++++-------------
 1 file changed, 58 insertions(+), 46 deletions(-)

diff --git a/lib/trace-cmd/trace-timesync-kvm.c b/lib/trace-cmd/trace-timesync-kvm.c
index 1db63d94f545..aa1799b1eefb 100644
--- a/lib/trace-cmd/trace-timesync-kvm.c
+++ b/lib/trace-cmd/trace-timesync-kvm.c
@@ -33,15 +33,20 @@ typedef __s64 s64;
 #define KVM_ACCURACY	0
 #define KVM_NAME	"kvm"
 
+struct kvm_clock_files {
+	int		vcpu;
+	char		*offsets;
+	char		*scalings;
+	char		*frac;
+};
+
 struct kvm_clock_sync {
-	int vcpu_count;
-	char **vcpu_offsets;
-	char **vcpu_scalings;
-	char **vcpu_frac;
-	int marker_fd;
-	struct tep_handle *tep;
-	int raw_id;
-	unsigned long long ts;
+	int			vcpu_count;
+	int			marker_fd;
+	struct kvm_clock_files	*clock_files;
+	struct tep_handle	*tep;
+	int			raw_id;
+	unsigned long long	ts;
 };
 
 struct kvm_clock_offset_msg {
@@ -210,7 +215,7 @@ static bool kvm_support_check(bool guest)
 	return kvm_scaling_check();
 }
 
-static int kvm_open_vcpu_dir(struct kvm_clock_sync *kvm, int cpu, char *dir_str)
+static int kvm_open_vcpu_dir(struct kvm_clock_sync *kvm, int i, char *dir_str)
 {
 	struct dirent *entry;
 	char path[PATH_MAX];
@@ -224,21 +229,21 @@ static int kvm_open_vcpu_dir(struct kvm_clock_sync *kvm, int cpu, char *dir_str)
 			if (!strcmp(entry->d_name, KVM_DEBUG_OFFSET_FILE)) {
 				snprintf(path, sizeof(path), "%s/%s",
 					 dir_str, entry->d_name);
-				kvm->vcpu_offsets[cpu] = strdup(path);
+				kvm->clock_files[i].offsets = strdup(path);
 			}
 			if (!strcmp(entry->d_name, KVM_DEBUG_SCALING_FILE)) {
 				snprintf(path, sizeof(path), "%s/%s",
 					 dir_str, entry->d_name);
-				kvm->vcpu_scalings[cpu] = strdup(path);
+				kvm->clock_files[i].scalings = strdup(path);
 			}
 			if (!strcmp(entry->d_name, KVM_DEBUG_FRACTION_FILE)) {
 				snprintf(path, sizeof(path), "%s/%s",
 					 dir_str, entry->d_name);
-				kvm->vcpu_frac[cpu] = strdup(path);
+				kvm->clock_files[i].frac = strdup(path);
 			}
 		}
 	}
-	if (!kvm->vcpu_offsets[cpu])
+	if (!kvm->clock_files[i].offsets)
 		goto error;
 	closedir(dir);
 	return 0;
@@ -246,15 +251,25 @@ static int kvm_open_vcpu_dir(struct kvm_clock_sync *kvm, int cpu, char *dir_str)
 error:
 	if (dir)
 		closedir(dir);
-	free(kvm->vcpu_offsets[cpu]);
-	kvm->vcpu_offsets[cpu] = NULL;
-	free(kvm->vcpu_scalings[cpu]);
-	kvm->vcpu_scalings[cpu] = NULL;
-	free(kvm->vcpu_frac[cpu]);
-	kvm->vcpu_frac[cpu] = NULL;
+	free(kvm->clock_files[i].offsets);
+	kvm->clock_files[i].offsets = NULL;
+	free(kvm->clock_files[i].scalings);
+	kvm->clock_files[i].scalings = NULL;
+	free(kvm->clock_files[i].frac);
+	kvm->clock_files[i].frac = NULL;
 	return -1;
 }
 
+static int cmp_clock(const void *A, const void *B)
+{
+	const struct kvm_clock_files *a = A;
+	const struct kvm_clock_files *b = B;
+
+	if (a->vcpu < b->vcpu)
+		return -1;
+	return a->vcpu > b->vcpu;
+}
+
 static int kvm_open_debug_files(struct kvm_clock_sync *kvm, int pid)
 {
 	char *vm_dir_str = NULL;
@@ -284,21 +299,25 @@ static int kvm_open_debug_files(struct kvm_clock_sync *kvm, int pid)
 	dir = opendir(vm_dir_str);
 	if (!dir)
 		goto error;
+	i = 0;
 	while ((entry = readdir(dir))) {
 		if (!(entry->d_type == DT_DIR &&
 		    !strncmp(entry->d_name, KVM_DEBUG_VCPU_DIR, strlen(KVM_DEBUG_VCPU_DIR))))
 			continue;
-		vcpu =  strtol(entry->d_name + strlen(KVM_DEBUG_VCPU_DIR), NULL, 10);
-		if (vcpu < 0 || vcpu >= kvm->vcpu_count)
-			continue;
-		snprintf(path, sizeof(path), "%s/%s", vm_dir_str, entry->d_name);
-		if (kvm_open_vcpu_dir(kvm, vcpu, path) < 0)
+		if (i == kvm->vcpu_count)
 			goto error;
-	}
-	for (i = 0; i < kvm->vcpu_count; i++) {
-		if (!kvm->vcpu_offsets[i])
+		vcpu = strtol(entry->d_name + strlen(KVM_DEBUG_VCPU_DIR), NULL, 10);
+		kvm->clock_files[i].vcpu = vcpu;
+		snprintf(path, sizeof(path), "%s/%s", vm_dir_str, entry->d_name);
+		if (kvm_open_vcpu_dir(kvm, i, path) < 0)
 			goto error;
+		i++;
 	}
+	if (i < kvm->vcpu_count)
+		goto error;
+
+	qsort(kvm->clock_files, kvm->vcpu_count, sizeof(*kvm->clock_files), cmp_clock);
+
 	closedir(dir);
 	free(pid_str);
 	free(vm_dir_str);
@@ -315,19 +334,15 @@ static int kvm_clock_sync_init_host(struct tracecmd_time_sync *tsync,
 				    struct kvm_clock_sync *kvm)
 {
 	kvm->vcpu_count = tsync->vcpu_count;
-	kvm->vcpu_offsets = calloc(kvm->vcpu_count, sizeof(char *));
-	kvm->vcpu_scalings = calloc(kvm->vcpu_count, sizeof(char *));
-	kvm->vcpu_frac = calloc(kvm->vcpu_count, sizeof(char *));
-	if (!kvm->vcpu_offsets || !kvm->vcpu_scalings || !kvm->vcpu_frac)
+	kvm->clock_files = calloc(kvm->vcpu_count, sizeof(*kvm->clock_files));
+	if (!kvm->clock_files)
 		goto error;
 	if (kvm_open_debug_files(kvm, tsync->guest_pid) < 0)
 		goto error;
 	return 0;
 
 error:
-	free(kvm->vcpu_offsets);
-	free(kvm->vcpu_scalings);
-	free(kvm->vcpu_frac);
+	free(kvm->clock_files);
 	return -1;
 }
 
@@ -414,12 +429,9 @@ static int kvm_clock_sync_free(struct tracecmd_time_sync *tsync)
 		kvm = (struct kvm_clock_sync *)clock_context->proto_data;
 	if (kvm) {
 		for (i = 0; i < kvm->vcpu_count; i++) {
-			free(kvm->vcpu_offsets[i]);
-			kvm->vcpu_offsets[i] = NULL;
-			free(kvm->vcpu_scalings[i]);
-			kvm->vcpu_scalings[i] = NULL;
-			free(kvm->vcpu_frac[i]);
-			kvm->vcpu_frac[i] = NULL;
+			free(kvm->clock_files[i].offsets);
+			free(kvm->clock_files[i].scalings);
+			free(kvm->clock_files[i].frac);
 		}
 		if (kvm->tep)
 			tep_free(kvm->tep);
@@ -449,23 +461,23 @@ static int kvm_clock_host(struct tracecmd_time_sync *tsync,
 	clock_context = (struct clock_sync_context *)tsync->context;
 	if (clock_context)
 		kvm = (struct kvm_clock_sync *)clock_context->proto_data;
-	if (!kvm || !kvm->vcpu_offsets || !kvm->vcpu_offsets[0])
+	if (!kvm || !kvm->clock_files || !kvm->clock_files[0].offsets)
 		return -1;
 	if (cpu >= kvm->vcpu_count)
 		return -1;
-	ret = read_ll_from_file(kvm->vcpu_offsets[cpu], &kvm_offset);
+	ret = read_ll_from_file(kvm->clock_files[cpu].offsets, &kvm_offset);
 	if (ret < 0)
 		return -1;
 
-	if (kvm->vcpu_scalings && kvm->vcpu_scalings[cpu]) {
-		read_ll_from_file(kvm->vcpu_scalings[cpu], &kvm_scaling);
+	if (kvm->clock_files[cpu].scalings) {
+		read_ll_from_file(kvm->clock_files[cpu].scalings, &kvm_scaling);
 		if (kvm_scaling == KVM_SCALING_AMD_DEFAULT ||
 		    kvm_scaling == KVM_SCALING_INTEL_DEFAULT)
 			kvm_scaling = 1;
 	}
 
-	if (kvm->vcpu_frac && kvm->vcpu_frac[cpu] && kvm_scaling != 1)
-		ret = read_ll_from_file(kvm->vcpu_frac[cpu], &kvm_frac);
+	if (kvm->clock_files[cpu].frac && kvm_scaling != 1)
+		ret = read_ll_from_file(kvm->clock_files[cpu].frac, &kvm_frac);
 	msg = (char *)&packet;
 	size = sizeof(packet);
 	ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
-- 
2.35.1

