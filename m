Return-Path: <SRS0=AbPd=64=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544F8C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 May 2020 16:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2744F206DC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 May 2020 16:43:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gNhq4APO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgENQn2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 May 2020 12:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgENQn1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 May 2020 12:43:27 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550E7C061A0C
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 May 2020 09:43:26 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id ee19so1976675qvb.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 May 2020 09:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yhhGy+ya5ScSsIcmsj0dNTrwQuXMxofKznZaLjjvFPQ=;
        b=gNhq4APOV6kT7Ef5d/vPPLGsaVqNHMW3gboYW8d/Cbix9TjfUABiUNHmh9YLtxjizv
         9mYuo9G4R+NmqkMIPirekGsMYuOthovRHuy6loVN44qEfMPJTK4J2LVPy9GqumZSqp6n
         smDx3KAH1bpQVwW/ienPHXtWTQZWb3QI4jEoDXN23ToTaLT4zG6CZmHixw37pmOJ8pr0
         aegcP950qSFkblE41yB8PAFUWBSpwQQXQknAWqBq8TwKjzqJQ1yVZF5ERgxc6rKXpmXy
         SrO90MBc8BCwPUKe9FUHF13Gm7cJG7zW1iJh23+iIvu/U69JGGFsUcVGP3yotKoT6bqz
         rZVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yhhGy+ya5ScSsIcmsj0dNTrwQuXMxofKznZaLjjvFPQ=;
        b=WjqfDU0pT4ALvITk9HAxdiXcYFiCZ6sax8Sgvpp9tcv4DcTeP+uAhMEX2roT4zG1tp
         1IphGUAwmWSnoasq1nr+FaRBu7Ozchg8ED3ygkFPbdOxd6/X3nh7GnkckzjnlVMqTjjT
         XQOQBq4/oVoaA09xpMxbT3uwqniQF9e/nPGbO5CkueFxqnwEoUWb2pc9GgJEuf9Wvv/9
         6VRKKQR0SeHYMNWYxqEDRHnt4TEyDTcJ391jaD1+vfF6yr7skau61zVN5JLU8PhrIWSC
         FoZJoMPUm6SrvUw9HGu++cGGhm8yuKV1us3NuqlBU6DI4S6UUOrZ4PJl5n6mzO7JCpZR
         5HkA==
X-Gm-Message-State: AOAM531sZcwrBQdEf7Bo+EFEsavcSxabCV69RxpOaoabH3cEBPgZE6wl
        ZzELBcti/x5udNlI0xOQszw=
X-Google-Smtp-Source: ABdhPJw5No+trd6HRj6aZfwefgXb2La8GmOQcF5cK+P8M3QADBt8C02wOjkbAQRvjuOOBBlhyRYVjQ==
X-Received: by 2002:a0c:f054:: with SMTP id b20mr5551401qvl.112.1589474604638;
        Thu, 14 May 2020 09:43:24 -0700 (PDT)
Received: from localhost.localdomain (cpe-65-30-164-238.wi.res.rr.com. [65.30.164.238])
        by smtp.gmail.com with ESMTPSA id h22sm2591277qtn.23.2020.05.14.09.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 09:43:23 -0700 (PDT)
From:   Bijan Tabatabai <bijan311@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Bijan Tabatabai <bijan311@yahoo.com>
Subject: [PATCH v4] trace-cmd: Stop recording when processes traced with -P exit
Date:   Thu, 14 May 2020 11:42:44 -0500
Message-Id: <20200514164244.12858-1-bijan311@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Bijan Tabatabai <bijan311@yahoo.com>

When the -F flag is used in trace-cmd record, trace-cmd stops recording
when the executable it is tracing terminates.
This patch makes the -P flag act similarly.

Signed-off-by: Bijan Tabatabai <bijan311@yahoo.com>
---
 v4 fixes a bug where trace-cmd would stop tracing after the processes in
 the first instance exited.
---
 tracecmd/include/trace-local.h |  2 +
 tracecmd/trace-record.c        | 91 +++++++++++++++++++++++++++++++++-
 2 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 4c6a63d..5d58550 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -215,9 +215,11 @@ struct buffer_instance {
 
 	struct opt_list		*options;
 	struct filter_pids	*filter_pids;
+	struct filter_pids	*process_pids;
 	char			*common_pid_filter;
 	int			nr_filter_pids;
 	int			len_filter_pids;
+	int			nr_process_pids;
 	bool			ptrace_child;
 
 	int			have_set_event_pid;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index d0619ba..cb1634d 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -16,6 +16,7 @@
 #include <sys/time.h>
 #include <sys/wait.h>
 #include <sys/socket.h>
+#include <sys/syscall.h>
 #include <sys/utsname.h>
 #ifndef NO_PTRACE
 #include <sys/ptrace.h>
@@ -33,6 +34,7 @@
 #include <errno.h>
 #include <limits.h>
 #include <libgen.h>
+#include <poll.h>
 #include <pwd.h>
 #include <grp.h>
 #ifdef VSOCK
@@ -1230,6 +1232,81 @@ static pid_t trace_waitpid(enum trace_type type, pid_t pid, int *status, int opt
 			trace_stream_read(pids, recorder_threads, &tv);
 	} while (1);
 }
+
+#ifndef __NR_pidfd_open
+#define __NR_pidfd_open 434
+#endif
+
+static int pidfd_open(pid_t pid, unsigned int flags) {
+	return syscall(__NR_pidfd_open, pid, flags);
+}
+
+static int trace_waitpidfd(id_t pidfd) {
+	struct pollfd pollfd;
+
+	pollfd.fd = pidfd;
+	pollfd.events = POLLIN;
+
+	while (!finished) {
+		int ret = poll(&pollfd, 1, -1);
+		/* If waitid was interrupted, keep waiting */
+		if (ret < 0 && errno == EINTR)
+			continue;
+		else if (ret < 0)
+			return 1;
+		else
+			break;
+	}
+
+	return 0;
+}
+
+static int trace_wait_for_processes(struct buffer_instance *instance) {
+	int ret = 0;
+	int nr_fds = 0;
+	int i;
+	int *pidfds;
+	struct filter_pids *pid;
+
+	pidfds = malloc(sizeof(int) * instance->nr_process_pids);
+	if (!pidfds)
+		return 1;
+
+	for (pid = instance->process_pids;
+	     pid && instance->nr_process_pids;
+	     pid = pid->next) {
+		if (pid->exclude) {
+			instance->nr_process_pids--;
+			continue;
+		}
+		pidfds[nr_fds] = pidfd_open(pid->pid, 0);
+
+		/* If the pid doesn't exist, the process has probably exited */
+		if (pidfds[nr_fds] < 0 && errno == ESRCH) {
+			instance->nr_process_pids--;
+			continue;
+		} else if (pidfds[nr_fds] < 0) {
+			ret = 1;
+			goto out;
+		}
+
+		nr_fds++;
+		instance->nr_process_pids--;
+	}
+
+	for (i = 0; i < nr_fds; i++) {
+		if (trace_waitpidfd(pidfds[i])) {
+			ret = 1;
+			goto out;
+		}
+	}
+
+out:
+	for (i = 0; i < nr_fds; i++)
+		close(pidfds[i]);
+	free(pidfds);
+	return ret;
+}
 #ifndef NO_PTRACE
 
 /**
@@ -5866,7 +5943,9 @@ static void parse_record_options(int argc,
 				fpids_count += add_filter_pid(ctx->instance,
 							      atoi(pid), 0);
 				pid = strtok_r(NULL, ",", &sav);
+				ctx->instance->nr_process_pids++;
 			}
+			ctx->instance->process_pids = ctx->instance->filter_pids;
 			free(pids);
 			break;
 		case 'c':
@@ -6345,6 +6424,7 @@ static void record_trace(int argc, char **argv,
 		tracecmd_msg_wait_close(ctx->instance->msg_handle);
 	} else {
 		bool pwait = false;
+		bool wait_indefinitely = false;
 
 		update_task_filter();
 		tracecmd_enable_tracing();
@@ -6361,7 +6441,16 @@ static void record_trace(int argc, char **argv,
 		}
 		/* sleep till we are woken with Ctrl^C */
 		printf("Hit Ctrl^C to stop recording\n");
-		while (!finished)
+		for_all_instances(instance) {
+			/* If an instance is not tracing individual processes
+			 * or there is an error while waiting for a process to
+			 * exit, fallback to waiting indefinitely.
+			 */
+			if (!instance->nr_process_pids
+			    || trace_wait_for_processes(instance))
+				wait_indefinitely = true;
+		}
+		while (!finished && wait_indefinitely)
 			trace_or_sleep(type, pwait);
 	}
 
-- 
2.25.1

