Return-Path: <SRS0=Wcha=6O=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E00C8300B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Apr 2020 12:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E00D52076D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Apr 2020 12:22:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LXGR+CJb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgD3MWd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 08:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726500AbgD3MWd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 08:22:33 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D36C035494
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Apr 2020 05:22:33 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id b2so6255027ljp.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Apr 2020 05:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Wdph4dvvQ7ZWMW79jnjXB5svR+IBQaXspcv5zle/SY=;
        b=LXGR+CJb9D56bLfI3HBbmrAkd3myfcKmziC2v9bCgDHaGsw/bGenvTiOvKpncvQ7v2
         pLAl9dEFkTQWkiiNk3CW9HYLl5tsHbQq2M2U06mllBIOUT5Zon2Fu82vLCH+bUrDzqHX
         SoFnCmA8R2QCjLJs15/zhoCQT6Tb4WSoNRL1lbofombDHY2El4r47ywe7nP5o1B2L2eK
         wQPHf4icTwVRZFnWNEw1bivtD3/GX8MTf35+MYzvuooyqdXQ6VxAnN/X7aXKznvxXuZa
         u7gcKulnloZXmzf+KlZiOTWDDmhrB1DIZ8Nz0LJ+mnPCpdIM2M4i+zwMMR2s5droEtu6
         IYDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Wdph4dvvQ7ZWMW79jnjXB5svR+IBQaXspcv5zle/SY=;
        b=huuSjA7Fr/d0av2h+sL0zX7XngfAcxAy3GdePanmmwJRe2d7o28l5mSdm8n38uTEDr
         DuCg0znQ0rAdBBfCep/+z07K+dCyQ56zg/8PShQQJxliltZSEUBwOcmOLh7XJ99RUHUE
         IG9LXTeSo4KGkkcPRuIRz5fXphZ01pIdyBn34WPnwDcnD9SFkmCw6DPrm2yJkKFJF+Jd
         p8K1Wr9kkQr0LOLAuy8RSXG1TbIqoZbwY5yM2yKAX537sRDQZv8uv8r6mqrS/DwarpVu
         wqmmjCHKrlehyOwUfxHVhrxPVU/PzeFCRGb6xjrvmbYxbDwKeelYr7XMpcz7xIMozd/c
         wtMw==
X-Gm-Message-State: AGi0PuZFbeF6lkJKv6i6aDrNvDj2p+aDs4IFzCe5hr+4oO+E6sJvsIRI
        MTnbv2wO1WBqIVw5qdHc4t0=
X-Google-Smtp-Source: APiQypLVevHvwNhOjb4dx8GrLuDk4Ut3E72FyMLzUUODvqVeRoLQcOLD1lCK2ezdPPMvSCEc7U2pgw==
X-Received: by 2002:a2e:99cc:: with SMTP id l12mr2111400ljj.290.1588249351529;
        Thu, 30 Apr 2020 05:22:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a26sm4793168lfl.66.2020.04.30.05.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 05:22:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/4] trace-cmd: Do not try to update parent's memory from a fork()-ed child
Date:   Thu, 30 Apr 2020 15:22:22 +0300
Message-Id: <20200430122222.101276-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430122222.101276-1-tz.stoyanov@gmail.com>
References: <20200430122222.101276-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-record.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 1e4d38fa..2b5cd42a 100644
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
@@ -1487,18 +1488,35 @@ static int change_user(const char *user)
 	return 0;
 }
 
+#define TRACE_RUN_SEM	"trace_cmd_semaphore_run"
+#define TRACE_INIT_SEM	"trace_cmd_semaphore_init"
 static void run_cmd(enum trace_type type, const char *user, int argc, char **argv)
 {
+	sem_t *sem_init;
+	sem_t *sem_run;
 	int status;
 	int pid;
 
+	sem_init = sem_open(TRACE_INIT_SEM, O_CREAT, S_IRUSR|S_IWUSR, 0);
+	if (sem_init == SEM_FAILED)
+		die("failed to init trace_cmd init semaphore");
+
+	sem_run = sem_open(TRACE_RUN_SEM, O_CREAT, S_IRUSR|S_IWUSR, 0);
+	if (sem_run == SEM_FAILED) {
+		sem_close(sem_init);
+		sem_unlink(TRACE_INIT_SEM);
+		die("failed to init trace_cmd run semaphore");
+	}
+
 	if ((pid = fork()) < 0)
 		die("failed to fork");
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
@@ -1519,11 +1537,17 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
 			die("Failed to exec %s", argv[0]);
 		}
 	}
-	if (do_ptrace) {
-		add_filter_pid(pid, 0);
-		ptrace_attach(pid);
+	update_task_filter();
+	sem_post(sem_init);
+	sem_wait(sem_run);
+	sem_close(sem_init);
+	sem_unlink(TRACE_INIT_SEM);
+	sem_close(sem_run);
+	sem_unlink(TRACE_RUN_SEM);
+
+	if (do_ptrace)
 		ptrace_wait(type);
-	} else
+	else
 		trace_waitpid(type, pid, &status, 0);
 }
 
-- 
2.25.4

