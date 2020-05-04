Return-Path: <SRS0=47nt=6S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C4FFC3A5A9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 06:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE22C206EB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 06:27:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i3dzZuXQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgEDG1V (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 02:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgEDG1V (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 02:27:21 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04860C061A0E
        for <linux-trace-devel@vger.kernel.org>; Sun,  3 May 2020 23:27:21 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id j14so8697700lfg.9
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 May 2020 23:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s6qyLLIWD8TaJO9UxyeRn9/FdaG8yzqRBtUJKcAHM+o=;
        b=i3dzZuXQXbHKSm71EaDg87Tywdqjbm2vIo0Ew6Q+9nRywTaL887yMDPl71mGhdTdLU
         H5C2+GioDKcOqEofeIc6uPfhZMkfda8aA62DYf+3I7cRvQBMEpvsSm426Uox9AoaryXT
         U7NvR0i6aKfXw9r6EiEQsoMEymfPZ/4HwGpyl/ZOFKMdvoSi4yN+PtGDlmhO9LbB9+4t
         s5VjIALllV+XW7q95B4ysJ4IDLIFz2H04r7hjjkBA2TvSIHOWj5o4C/BkJ5ZipuOixYH
         QNepyuNUg/WPr/aUv96MP+TqhnQRBSupdJhM3k4fIftnqt+t4rcWiLVQz4mcES6eOfzv
         UY2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s6qyLLIWD8TaJO9UxyeRn9/FdaG8yzqRBtUJKcAHM+o=;
        b=Jx3ORFUCZRAnUC0SatYv1qFD6d0EphKzhGn47PX7miPnyZRS+l2mToeI70r/1xdn2P
         FKhtvgNrkAhwPpJmCQUc4/0GFEmoKgyLB5klG50EAc44fCGhMR8jRSdUQMbMq6pB5Nwz
         0xY9WqXQjbxAkQo1Hz9GIykTu0WFchdfvmlQ83F8ws82nGdJo85yebd6VH5O/SgqPQ4B
         8JKaS459D2n22xp87+Exw054zoZK+2YPRUImUY3WeILPctei4OXZNWTDO9GbViu+jl3l
         HdxPENpvso9c64NKhnhGFydpa0JEFuDmgnE8Mi3mgYK5/cP91uCpE5JhKc3c+OTgTOmV
         oddw==
X-Gm-Message-State: AGi0PuaAABtNmY8gh4uv3T5pPEAfgLzIbUEsdreVxkzEWgyJ6KgEEf+/
        oiqO+bQTt73SCq73i7ZL/tE=
X-Google-Smtp-Source: APiQypK5UzEk5ONHBcqL5ROqWOIFD8OdFPNEK2u/9NXqq6GEQtag+Jy3TP5TxVPCXwA//2dISquFfQ==
X-Received: by 2002:ac2:5684:: with SMTP id 4mr10276075lfr.88.1588573639552;
        Sun, 03 May 2020 23:27:19 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u6sm7397150ljd.68.2020.05.03.23.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 23:27:19 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/4] trace-cmd: Do not try to update parent's memory from a fork()-ed child
Date:   Mon,  4 May 2020 09:27:11 +0300
Message-Id: <20200504062711.107867-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504062711.107867-1-tz.stoyanov@gmail.com>
References: <20200504062711.107867-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When trace-cmd runs a command, specified with the "-F" flag, it forks a
child process and executes the command in its context. This child process
receives a full copy of the parents memory at the moment of fork(). When
it modifies this copy, the parent memory is not affected. Calling the
function update_task_filter() in the child context will operate on a valid
data, but will not update anything in the parent's databases.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 64 +++++++++++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 12 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 1e4d38fa..ae8a5745 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -11,6 +11,7 @@
 #include <stdarg.h>
 #include <getopt.h>
 #include <time.h>
+#include <semaphore.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/time.h>
@@ -1187,10 +1188,12 @@ static void get_filter_pid_maps(void)
 	}
 }
 
-static void update_task_filter(void)
+static void update_task_filter(int pid)
 {
 	struct buffer_instance *instance;
-	int pid = getpid();
+
+	if (pid < 0)
+		pid = getpid();
 
 	if (no_filter)
 		return;
@@ -1487,18 +1490,40 @@ static int change_user(const char *user)
 	return 0;
 }
 
+#define TRACE_RUN_SEM	"trace_cmd_semaphore_run"
+#define TRACE_INIT_SEM	"trace_cmd_semaphore_init"
 static void run_cmd(enum trace_type type, const char *user, int argc, char **argv)
 {
+	sem_t *sem_init = SEM_FAILED;
+	sem_t *sem_run = SEM_FAILED;
+	char *die_log = NULL;
 	int status;
 	int pid;
 
-	if ((pid = fork()) < 0)
-		die("failed to fork");
+	sem_init = sem_open(TRACE_INIT_SEM, O_CREAT, S_IRUSR|S_IWUSR, 0);
+	if (sem_init == SEM_FAILED) {
+		die_log = "failed to init trace_cmd init semaphore";
+		goto out;
+	}
+
+	sem_run = sem_open(TRACE_RUN_SEM, O_CREAT, S_IRUSR|S_IWUSR, 0);
+	if (sem_run == SEM_FAILED) {
+		die_log = "failed to init trace_cmd run semaphore";
+		goto out;
+
+	}
+
+	if ((pid = fork()) < 0) {
+		die_log = "failed to fork";
+		goto out;
+	}
 	if (!pid) {
 		/* child */
-		update_task_filter();
+		sem_wait(sem_init);
 		tracecmd_enable_tracing();
 		enable_ptrace();
+		sem_post(sem_run);
+
 		/*
 		 * If we are using stderr for stdout, switch
 		 * it back to the saved stdout for the code we run.
@@ -1519,12 +1544,27 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
 			die("Failed to exec %s", argv[0]);
 		}
 	}
-	if (do_ptrace) {
-		add_filter_pid(pid, 0);
-		ptrace_attach(pid);
+	update_task_filter(pid);
+	sem_post(sem_init);
+	sem_wait(sem_run);
+
+	if (do_ptrace)
 		ptrace_wait(type);
-	} else
+	else
 		trace_waitpid(type, pid, &status, 0);
+
+out:
+	if (sem_init != SEM_FAILED) {
+		sem_close(sem_init);
+		sem_unlink(TRACE_INIT_SEM);
+	}
+	if (sem_run != SEM_FAILED) {
+		sem_close(sem_run);
+		sem_unlink(TRACE_RUN_SEM);
+	}
+
+	if (die_log)
+		die(die_log);
 }
 
 static void
@@ -6285,7 +6325,7 @@ static void record_trace(int argc, char **argv,
 		if (!latency)
 			start_threads(type, ctx);
 	} else {
-		update_task_filter();
+		update_task_filter(-1);
 		tracecmd_enable_tracing();
 		exit(0);
 	}
@@ -6293,11 +6333,11 @@ static void record_trace(int argc, char **argv,
 	if (ctx->run_command) {
 		run_cmd(type, ctx->user, (argc - optind) - 1, &argv[optind + 1]);
 	} else if (ctx->instance && is_agent(ctx->instance)) {
-		update_task_filter();
+		update_task_filter(-1);
 		tracecmd_enable_tracing();
 		tracecmd_msg_wait_close(ctx->instance->msg_handle);
 	} else {
-		update_task_filter();
+		update_task_filter(-1);
 		tracecmd_enable_tracing();
 		/* We don't ptrace ourself */
 		if (do_ptrace && filter_pids) {
-- 
2.26.2

