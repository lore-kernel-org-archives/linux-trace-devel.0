Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D874C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sun, 22 May 2022 00:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242581AbiEVAjn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 21 May 2022 20:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239316AbiEVAjm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 21 May 2022 20:39:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE21D4664E
        for <linux-trace-devel@vger.kernel.org>; Sat, 21 May 2022 17:39:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3F261CE09E9
        for <linux-trace-devel@vger.kernel.org>; Sun, 22 May 2022 00:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B693DC385A5;
        Sun, 22 May 2022 00:39:37 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nsZdA-000p8p-Qj;
        Sat, 21 May 2022 20:39:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/4] trace-cmd kvm timesync: Check for one valid VM
Date:   Sat, 21 May 2022 20:39:33 -0400
Message-Id: <20220522003935.196466-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220522003935.196466-1-rostedt@goodmis.org>
References: <20220522003935.196466-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Currently if there are no valid VMs the kvm supported check can return
true. Check for at least one valid VM, and that echa VM has one valid
VCPU.

Also comment the code as it is very confusing to why the scaling checks
return true or false.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-timesync-kvm.c | 46 +++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/lib/trace-cmd/trace-timesync-kvm.c b/lib/trace-cmd/trace-timesync-kvm.c
index a645fa2cc70b..671eafaf62b8 100644
--- a/lib/trace-cmd/trace-timesync-kvm.c
+++ b/lib/trace-cmd/trace-timesync-kvm.c
@@ -73,6 +73,11 @@ static int read_ll_from_file(char *file, long long *res)
 	return 0;
 }
 
+/*
+ * Returns true if both scaling and fraction exist or both do
+ * not exist. false if one exists without the other or if there
+ * is a memory error.
+ */
 static bool kvm_scaling_check_vm_cpu(char *vname, char *cpu)
 {
 	bool has_scaling = false;
@@ -101,46 +106,66 @@ static bool kvm_scaling_check_vm_cpu(char *vname, char *cpu)
 	return true;
 }
 
+/*
+ * Returns true if a VCPU exists with a tsc-offset file and that
+ * the scaling files for ratio and fraction both exist or both
+ * do not exist. False if there is no VM with a tsc-offset or
+ * there is only one of the two scaling files, or there's a
+ * memory issue.
+ */
 static bool kvm_scaling_check_vm(char *name)
 {
 	struct dirent *entry;
 	char *vdir;
 	DIR *dir;
+	bool valid = false;
 
 	if (asprintf(&vdir, "%s/%s", KVM_DEBUG_FS, name) < 0)
-		return true;
+		return false;
 
 	dir = opendir(vdir);
 	if (!dir) {
 		free(vdir);
-		return true;
+		return false;
 	}
 	while ((entry = readdir(dir))) {
-		if (entry->d_type == DT_DIR && !strncmp(entry->d_name, "vcpu", 4) &&
-		    !kvm_scaling_check_vm_cpu(vdir, entry->d_name))
-			break;
+		if (entry->d_type == DT_DIR && !strncmp(entry->d_name, "vcpu", 4)) {
+			if (!kvm_scaling_check_vm_cpu(vdir, entry->d_name))
+				break;
+			valid = true;
+		}
 	}
 
 	closedir(dir);
 	free(vdir);
-	return entry == NULL;
+	return valid && entry == NULL;
 }
+
+/*
+ * Returns true if all VMs have a tsc-offset file and that
+ * the scaling files for ratio and fraction both exist or both
+ * do not exist. False if a VM with a tsc-offset or there is only
+ * one of the two scaling files, or no VM exists or there's a memory issue.
+ */
 static bool kvm_scaling_check(void)
 {
 	struct dirent *entry;
 	DIR *dir;
+	bool valid = false;
 
 	dir = opendir(KVM_DEBUG_FS);
 	if (!dir)
 		return true;
 
 	while ((entry = readdir(dir))) {
-		if (entry->d_type == DT_DIR && isdigit(entry->d_name[0]) &&
-		    !kvm_scaling_check_vm(entry->d_name))
-			break;
+		if (entry->d_type == DT_DIR && isdigit(entry->d_name[0])) {
+			if (!kvm_scaling_check_vm(entry->d_name))
+				break;
+			valid = true;
+		}
 	}
 	closedir(dir);
-	return entry == NULL;
+	return valid && entry == NULL;
 }
 
 static bool kvm_support_check(bool guest)
@@ -148,6 +173,7 @@ static bool kvm_support_check(bool guest)
 	struct stat st;
 	int ret;
 
+	/* The kvm files are only in the host so we can ignore guests */
 	if (guest)
 		return true;
 
-- 
2.35.1

