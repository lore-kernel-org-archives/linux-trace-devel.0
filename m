Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A9FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Sun, 22 May 2022 00:39:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240763AbiEVAjn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 21 May 2022 20:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238629AbiEVAjm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 21 May 2022 20:39:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDB146655
        for <linux-trace-devel@vger.kernel.org>; Sat, 21 May 2022 17:39:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29332B8091D
        for <linux-trace-devel@vger.kernel.org>; Sun, 22 May 2022 00:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6D6C34116;
        Sun, 22 May 2022 00:39:37 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nsZdA-000p8v-S2;
        Sat, 21 May 2022 20:39:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4/4] trace-cmd: Mount debugfs if needed for KVM data
Date:   Sat, 21 May 2022 20:39:35 -0400
Message-Id: <20220522003935.196466-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220522003935.196466-1-rostedt@goodmis.org>
References: <20220522003935.196466-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The KVM offset and multiplier are in the debugfs file system. If it is
not currently mounted, then try to mount it with the new tracefs API
tracefs_debug_dir() which will return the debugfs file system path, and
even mount it if possible (or NULL if it could not).

This also removes the hard coded path for /sys/kernel/debug/kvm and
removes the stat() of the directory as tracefs_debug_dir() will only
return mount locations which are directories.

Set libtracefs minimum version to 1.4 as that is what will have the
tarcefs_debug_dir() in it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile                           |  2 +-
 lib/trace-cmd/trace-timesync-kvm.c | 47 ++++++++++++++++++++++--------
 2 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/Makefile b/Makefile
index abc4ac723db4..3452649229df 100644
--- a/Makefile
+++ b/Makefile
@@ -23,7 +23,7 @@ export LIBTRACECMD_VERSION
 VERSION_FILE = ltc_version.h
 
 LIBTRACEEVENT_MIN_VERSION = 1.5
-LIBTRACEFS_MIN_VERSION = 1.3
+LIBTRACEFS_MIN_VERSION = 1.4
 
 MAKEFLAGS += --no-print-directory
 
diff --git a/lib/trace-cmd/trace-timesync-kvm.c b/lib/trace-cmd/trace-timesync-kvm.c
index 671eafaf62b8..1db63d94f545 100644
--- a/lib/trace-cmd/trace-timesync-kvm.c
+++ b/lib/trace-cmd/trace-timesync-kvm.c
@@ -16,7 +16,6 @@
 #include "tracefs.h"
 #include "trace-tsync-local.h"
 
-#define KVM_DEBUG_FS "/sys/kernel/debug/kvm"
 #define KVM_DEBUG_OFFSET_FILE	"tsc-offset"
 #define KVM_DEBUG_SCALING_FILE	"tsc-scaling-ratio"
 #define KVM_DEBUG_FRACTION_FILE	"tsc-scaling-ratio-frac-bits"
@@ -106,6 +105,24 @@ static bool kvm_scaling_check_vm_cpu(char *vname, char *cpu)
 	return true;
 }
 
+static const char *kvm_debug_dir(void)
+{
+	const char *debugfs;
+	static char *kvm_dir;
+
+	if (kvm_dir)
+		return kvm_dir;
+
+	debugfs = tracefs_debug_dir();
+	if (!debugfs)
+		return NULL;
+
+	if (asprintf(&kvm_dir, "%s/kvm", debugfs) < 0)
+		return NULL;
+
+	return kvm_dir;
+}
+
 /*
  * Returns true if a VCPU exists with a tsc-offset file and that
  * the scaling files for ratio and fraction both exist or both
@@ -116,11 +133,16 @@ static bool kvm_scaling_check_vm_cpu(char *vname, char *cpu)
 static bool kvm_scaling_check_vm(char *name)
 {
 	struct dirent *entry;
+	const char *kvm;
 	char *vdir;
 	DIR *dir;
 	bool valid = false;
 
-	if (asprintf(&vdir, "%s/%s", KVM_DEBUG_FS, name) < 0)
+	kvm = kvm_debug_dir();
+	if (!kvm)
+		return false;
+
+	if (asprintf(&vdir, "%s/%s", kvm, name) < 0)
 		return false;
 
 	dir = opendir(vdir);
@@ -150,10 +172,15 @@ static bool kvm_scaling_check_vm(char *name)
 static bool kvm_scaling_check(void)
 {
 	struct dirent *entry;
+	const char *kvm;
 	DIR *dir;
 	bool valid = false;
 
-	dir = opendir(KVM_DEBUG_FS);
+	kvm = kvm_debug_dir();
+	if (!kvm)
+		return false;
+
+	dir = opendir(kvm);
 	if (!dir)
 		return true;
 
@@ -170,18 +197,14 @@ static bool kvm_scaling_check(void)
 
 static bool kvm_support_check(bool guest)
 {
-	struct stat st;
-	int ret;
+	const char *kvm;
 
 	/* The kvm files are only in the host so we can ignore guests */
 	if (guest)
 		return true;
 
-	ret = stat(KVM_DEBUG_FS, &st);
-	if (ret < 0)
-		return false;
-
-	if (!S_ISDIR(st.st_mode))
+	kvm = kvm_debug_dir();
+	if (!kvm)
 		return false;
 
 	return kvm_scaling_check();
@@ -242,7 +265,7 @@ static int kvm_open_debug_files(struct kvm_clock_sync *kvm, int pid)
 	DIR *dir;
 	int i;
 
-	dir = opendir(KVM_DEBUG_FS);
+	dir = opendir(kvm_debug_dir());
 	if (!dir)
 		goto error;
 	if (asprintf(&pid_str, "%d-", pid) <= 0)
@@ -251,7 +274,7 @@ static int kvm_open_debug_files(struct kvm_clock_sync *kvm, int pid)
 		if (!(entry->d_type == DT_DIR &&
 		    !strncmp(entry->d_name, pid_str, strlen(pid_str))))
 			continue;
-		asprintf(&vm_dir_str, "%s/%s", KVM_DEBUG_FS, entry->d_name);
+		asprintf(&vm_dir_str, "%s/%s", kvm_debug_dir(), entry->d_name);
 		break;
 	}
 	closedir(dir);
-- 
2.35.1

