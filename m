Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7696C77B73
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 May 2023 20:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjEAUcG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 May 2023 16:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbjEAUcE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 May 2023 16:32:04 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B541FFD
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 May 2023 13:32:02 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-50bc37e1525so3293630a12.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 May 2023 13:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682973120; x=1685565120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8H7OIAXjkJ3+gFesoeXBFEp2Gs0YKi4vuH/7xoKVHpA=;
        b=kCXRwi9kUXlddZBL5o6Sd7G9T50mcwd3yz7iMwXtKtOnpYCKUv2i3Av28n5G0A9AFQ
         hdDKhlu/B1fOdoniygIc7PCizNF9SGkcPq/f808mERYA89cLCAxKrfNot+Jlehf+ezoK
         Ig2tSF9gBn2mpYFjbDkhzRrSctqq/LVKosDq//G3RJKc7OH8CmSN9lZnoCe+VbnMFMQz
         BYV2EqasVgS+MIv2tdVBYOQelH9JW/dobCvFqGe6b6UNLzwz+8pQknv8aDXIAkD69NXZ
         r6rSkjhImUimS8otZYV0Iv1lialrIkaqcTeyCVSX2DnuG0y9LfFHxwin/Izeb40KS+e0
         EVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682973120; x=1685565120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8H7OIAXjkJ3+gFesoeXBFEp2Gs0YKi4vuH/7xoKVHpA=;
        b=VHlBrhCM8RW7uQoE+1clXUzlifqzOZWxlThzfP0OmPEd5r4BQqODYdfEH+5BytD7au
         SBMpxBNc0BphK1Mf+KEybKlwjgSbNzdNYo7bRVbMYjb+MDqKSIqT3cynYLZ60m0zdNPS
         3YMGH7SzakAMwI8l2ny/Lp8lxyT+5AhYo88Efok5GbP5zFaEZGp4Z5qRHYcfAlAjHmOQ
         fqvaTDum4/vUa4ZYszvkCW9KZlfi1QwgMyCjvQ/dGoHDwNXjKFCRlN8UjOWBLCVc0gXT
         B33HY6ysUt0K3XELfgfPnejc13H1+aGcZTuHz/zmq3tkOasMEoOz66cH8zXmG6vgpAob
         N0pg==
X-Gm-Message-State: AC+VfDwnLsBi9/k0fOzZu2QRCJU/8B0LPCywHhzgTdSHv6XJ4izMsw7a
        KF/ujbNBR6hrOR1QFSzZvw1nD7jSzrY=
X-Google-Smtp-Source: ACHHUZ7fzx9npWT0Gaifb+TxOnkdqGFXC0d8JneyTyQZnkQQPGDJrd3OiR7H7H42QXdXCq9NAxIO9A==
X-Received: by 2002:a05:6402:1add:b0:500:50f6:dd34 with SMTP id ba29-20020a0564021add00b0050050f6dd34mr6298763edb.1.1682973120596;
        Mon, 01 May 2023 13:32:00 -0700 (PDT)
Received: from dante731.cslcs.technion.ac.il ([132.68.206.91])
        by smtp.gmail.com with ESMTPSA id i25-20020a170906851900b0094f1b8901e1sm15233933ejx.68.2023.05.01.13.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 13:32:00 -0700 (PDT)
From:   avidanborisov@gmail.com
To:     linux-trace-devel@vger.kernel.org
Cc:     Avidan Borisov <avidanborisov@gmail.com>
Subject: [PATCH 1/3] trace-cmd record: Add --daemonize
Date:   Mon,  1 May 2023 23:31:16 +0300
Message-Id: <20230501203118.3105605-2-avidanborisov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230501203118.3105605-1-avidanborisov@gmail.com>
References: <20230501203118.3105605-1-avidanborisov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Avidan Borisov <avidanborisov@gmail.com>

Add a --daemonize flag to trace-cmd record which allows the user to record
in the background, after tracing has completely initialized.

Signed-off-by: Avidan Borisov <avidanborisov@gmail.com>
---
 .../trace-cmd/trace-cmd-record.1.txt          |   3 +
 tracecmd/trace-record.c                       | 128 +++++++++++++++++-
 tracecmd/trace-usage.c                        |   1 +
 3 files changed, 130 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index b709e48..366ab46 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -418,6 +418,9 @@ OPTIONS
     run on a privileged guest that the host is aware of (as denoted by the
     'cid' in the *-P* option for the agent).
 
+*--daemonize*
+    Run trace-cmd in the background as a daemon after recording has started.
+
 EXAMPLES
 --------
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 7f0cebe..0eee8dd 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -91,6 +91,8 @@ static bool quiet;
 
 static bool fork_process;
 
+static bool do_daemonize;
+
 /* Max size to let a per cpu file get */
 static int max_kb;
 
@@ -1636,6 +1638,109 @@ static inline void ptrace_attach(struct buffer_instance *instance, int pid) { }
 
 #endif /* NO_PTRACE */
 
+static bool child_detached;
+
+static void daemonize_set_child_detached(int s)
+{
+	child_detached = true;
+}
+
+static void daemonize_start(void)
+{
+	int devnull;
+	int status;
+	int pid;
+	int rc;
+
+	pid = fork();
+	if (pid == -1)
+		die("daemonize: fork failed");
+
+	if (pid == 0) { /* child */
+		/*
+		 * We keep stdout and stderr open to allow the user to
+		 * see output and errors after the daemonization (he can
+		 * choose to supress it with >/dev/null if he wants).
+		 *
+		 * No reason to keep stdin open (it might interfere with the
+		 * shell), we redirect it to /dev/null.
+		 */
+		devnull = open("/dev/null", O_RDONLY);
+		if (devnull == -1)
+			die("daemonize: open /dev/null failed");
+
+		if (devnull > 0) {
+			if (dup2(devnull, 0) == -1)
+				die("daemonize: dup2");
+			close(0);
+		}
+
+		return;
+
+		/*
+		 * The child returns to back to the caller, but the parent waits until
+		 * SIGRTMIN is received from the child (by calling daemonize_finish()),
+		 * or the child exits for some reason (usually an indication of
+		 * an error), which ever comes first.
+		 *
+		 * Then the parent exits (with the status code of the child,
+		 * if it finished early, or with 0 if SIGRTMIN was received),
+		 * which causes the child (and its entire process tree) to be
+		 * inherited by init.
+		 *
+		 * Note that until the child calls daemonize_finish(), it still has
+		 * the same session id as the parent, so it can die together with
+		 * the parent before daemonization finished (purposefully, since the
+		 * user might send a quick Ctrl^C to cancel the command, and we don't
+		 * want background processes staying alive in that case)
+		 */
+	} else { /* parent */
+		struct sigaction sa = {
+			/* disable SA_RESTART, to allow waitpid() to be interrupted by SIGRTMIN */
+			.sa_flags = 0,
+			.sa_handler = daemonize_set_child_detached
+		};
+
+		if (sigemptyset(&sa.sa_mask) == -1)
+			die("daemonize: sigemptyset failed");
+
+		if (sigaddset(&sa.sa_mask, SIGRTMIN) == -1)
+			die("daemonize: sigaddset failed");
+
+		if (sigprocmask(SIG_UNBLOCK, &sa.sa_mask, NULL) == -1)
+			die("daemonize: sigprocmask failed");
+
+		if (sigaction(SIGRTMIN, &sa, NULL) == -1)
+			die("daemonize: sigaction failed");
+
+		do {
+			rc = waitpid(pid, &status, 0);
+		} while (!child_detached && ((rc == -1) && (errno == EINTR)));
+
+		if (child_detached)
+			exit(0);
+		else if (rc == pid)
+			exit(WIFEXITED(status));
+		else
+			die("daemonize: waitpid failed");
+
+		__builtin_unreachable();
+	}
+}
+
+static void daemonize_finish(void)
+{
+	/*
+	 * setsid() will also set the sid to be the pgid to all currently
+	 * running threads in the process group (such as the tsync thread).
+	 */
+	if (setsid() == -1)
+		die("daemonize: setsid");
+
+	if (kill(getppid(), SIGRTMIN) == -1)
+		die("daemonize: kill");
+}
+
 static void trace_or_sleep(enum trace_type type, bool pwait)
 {
 	int i;
@@ -1716,6 +1821,9 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
 			die("Failed to exec %s", argv[0]);
 		}
 	}
+
+	if (do_daemonize)
+		daemonize_finish();
 	if (fork_process)
 		exit(0);
 	if (do_ptrace) {
@@ -5757,6 +5865,7 @@ enum {
 	OPT_proxy		= 261,
 	OPT_temp		= 262,
 	OPT_notimeout		= 264,
+	OPT_daemonize		= 265,
 };
 
 void trace_stop(int argc, char **argv)
@@ -6183,6 +6292,7 @@ static void parse_record_options(int argc,
 			{"file-version", required_argument, NULL, OPT_file_ver},
 			{"proxy", required_argument, NULL, OPT_proxy},
 			{"temp", required_argument, NULL, OPT_temp},
+			{"daemonize", no_argument, NULL, OPT_daemonize},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6656,6 +6766,10 @@ static void parse_record_options(int argc,
 				die("--fork option used for 'start' command only");
 			fork_process = true;
 			break;
+		case OPT_daemonize:
+			if (!IS_RECORD(ctx))
+				die("--daemonize option used for 'record' command only");
+			do_daemonize = true;
 		case OPT_tsc2nsec:
 			ret = get_tsc_nsec(&ctx->tsc2nsec.shift,
 					   &ctx->tsc2nsec.mult);
@@ -6899,6 +7013,9 @@ static void record_trace(int argc, char **argv,
 	struct buffer_instance *instance;
 	struct filter_pids *pid;
 
+	if (do_daemonize)
+		daemonize_start();
+
 	/*
 	 * If top_instance doesn't have any plugins or events, then
 	 * remove it from being processed.
@@ -7017,8 +7134,15 @@ static void record_trace(int argc, char **argv,
 				}
 			}
 		}
-		/* sleep till we are woken with Ctrl^C */
-		printf("Hit Ctrl^C to stop recording\n");
+
+		if (do_daemonize) {
+			daemonize_finish();
+			printf("Send SIGINT to pid %d to stop recording\n", getpid());
+		} else {
+			/* sleep till we are woken with Ctrl^C */
+			printf("Hit Ctrl^C to stop recording\n");
+		}
+
 		for_all_instances(instance) {
 			/* If an instance is not tracing individual processes
 			 * or there is an error while waiting for a process to
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 42a8e7d..0630e8e 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -81,6 +81,7 @@ static struct usage_help usage_help[] = {
 		"                        available algorithms can be listed with trace-cmd list -c\n"
 		"          --proxy vsocket to reach the agent. Acts the same as -A (for an agent)\n"
 		"              but will send the proxy connection to the agent.\n"
+		"          --daemonize run trace-cmd in the background as a daemon after recording has started\n"
 	},
 	{
 		"set",
-- 
2.25.1

