Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA96C43217
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Nov 2022 22:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbiKVWwU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Nov 2022 17:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234785AbiKVWwT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Nov 2022 17:52:19 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36B7DC902B;
        Tue, 22 Nov 2022 14:52:18 -0800 (PST)
Received: from W11-BEAU-MD.localdomain (unknown [76.135.50.127])
        by linux.microsoft.com (Postfix) with ESMTPSA id BD2CF20B83C2;
        Tue, 22 Nov 2022 14:52:17 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BD2CF20B83C2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1669157538;
        bh=pclicV93QEMmKq/ZO2CptgW6018FQpvQ9RJ4O+CpTAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pHhFvf1EWAiVViC2BlNCkJ8ZhfgT0gp+VdZ4IDKH+jrqy9Qp9BH61cNUvR3XtvTn6
         M5m6hxByGrY5Go7N7l7jClbwwgRIzQuG4jNAXNcbn81fi24MixOL5ZM6Tak5yxnoTV
         POwn2TmWsQwnvw5Li9+HvXUFnWwBrSqEpMd78W4s=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, dcook@linux.microsoft.com,
        alanau@linux.microsoft.com, brauner@kernel.org,
        akpm@linux-foundation.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/9] tracing/user_events: Track fork/exec/exit for mm lifetime
Date:   Tue, 22 Nov 2022 14:52:06 -0800
Message-Id: <20221122225213.2317-3-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122225213.2317-1-beaub@linux.microsoft.com>
References: <20221122225213.2317-1-beaub@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

During tracefs discussions it was decided instead of requiring a mapping
within a user-process to track the lifetime of memory descriptors we
should hook the appropriate calls. Do this by adding the minimal stubs
required for task fork, exec, and exit. Currently this is just a NOP.
Future patches will implement these calls fully.

Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 fs/exec.c                   |  2 ++
 include/linux/sched.h       |  5 +++++
 include/linux/user_events.h | 16 +++++++++++++++-
 kernel/exit.c               |  2 ++
 kernel/fork.c               |  3 +++
 5 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index a0b1f0337a62..75ca6fbd195c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -64,6 +64,7 @@
 #include <linux/io_uring.h>
 #include <linux/syscall_user_dispatch.h>
 #include <linux/coredump.h>
+#include <linux/user_events.h>
 
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1842,6 +1843,7 @@ static int bprm_execve(struct linux_binprm *bprm,
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
 	rseq_execve(current);
+	user_events_execve(current);
 	acct_update_integrals(current);
 	task_numa_free(current, false);
 	return retval;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ffb6eb55cd13..61ed2f9deb26 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -69,6 +69,7 @@ struct sighand_struct;
 struct signal_struct;
 struct task_delay_info;
 struct task_group;
+struct user_event_mm;
 
 /*
  * Task state bitmask. NOTE! These bits are also
@@ -1528,6 +1529,10 @@ struct task_struct {
 	union rv_task_monitor		rv[RV_PER_TASK_MONITORS];
 #endif
 
+#ifdef CONFIG_USER_EVENTS
+	struct user_event_mm		*user_event_mm;
+#endif
+
 	/*
 	 * New fields for task_struct should be added above here, so that
 	 * they are included in the randomized portion of task_struct.
diff --git a/include/linux/user_events.h b/include/linux/user_events.h
index 036b360f3d97..3d747c45d2fa 100644
--- a/include/linux/user_events.h
+++ b/include/linux/user_events.h
@@ -12,7 +12,21 @@
 #include <uapi/linux/user_events.h>
 
 #ifdef CONFIG_USER_EVENTS
-#else
+struct user_event_mm {
+};
 #endif
 
+static inline void user_events_fork(struct task_struct *t,
+				    unsigned long clone_flags)
+{
+}
+
+static inline void user_events_execve(struct task_struct *t)
+{
+}
+
+static inline void user_events_exit(struct task_struct *t)
+{
+}
+
 #endif /* _LINUX_USER_EVENTS_H */
diff --git a/kernel/exit.c b/kernel/exit.c
index 35e0a31a0315..0bfadc26d278 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -67,6 +67,7 @@
 #include <linux/io_uring.h>
 #include <linux/kprobes.h>
 #include <linux/rethook.h>
+#include <linux/user_events.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -769,6 +770,7 @@ void __noreturn do_exit(long code)
 
 	coredump_task_exit(tsk);
 	ptrace_event(PTRACE_EVENT_EXIT, code);
+	user_events_exit(tsk);
 
 	validate_creds_for_do_exit(tsk);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 08969f5aa38d..8658e67d27b0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -97,6 +97,7 @@
 #include <linux/scs.h>
 #include <linux/io_uring.h>
 #include <linux/bpf.h>
+#include <linux/user_events.h>
 
 #include <asm/pgalloc.h>
 #include <linux/uaccess.h>
@@ -2416,6 +2417,8 @@ static __latent_entropy struct task_struct *copy_process(
 
 	rseq_fork(p, clone_flags);
 
+	user_events_fork(p, clone_flags);
+
 	/* Don't start children in a dying pid namespace */
 	if (unlikely(!(ns_of_pid(pid)->pid_allocated & PIDNS_ADDING))) {
 		retval = -ENOMEM;
-- 
2.25.1

