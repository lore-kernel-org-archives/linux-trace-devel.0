Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA12FEB64DA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jun 2023 09:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjFZJUR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Jun 2023 05:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjFZJTd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Jun 2023 05:19:33 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247A42D76
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jun 2023 02:16:57 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-98bcc533490so366585966b.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jun 2023 02:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687771015; x=1690363015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yEPcTxjaEjVnJ9EdnwR9/7qwFtqWTq8VdOb5lliXdnI=;
        b=R0QV53+GmTrXlVzpVPtBo1DEGsQ7a1NeusS66sHQqRPibFC41gkNNVR1CQCpgKCjYy
         +TJ7oABkRNEAarcw87j4SoY1zFMU+0AaW1GUG0gqQZNK7ap+IyJhJoWLrGXTGNfGqDx0
         K2N3GTKp+W8I7L5w8St3L9+vTHPxwy4px+CUaHT0a1IDGFiJNyCR3nP1WbV95/cNv6d+
         uG4FxO9N/dEA0sUKe+UZpr8inAHRRZns5Jm+8n3eZqPg85n9h9jGyFmafIWXUvG12+uF
         +8WXMxYknyp+2dlmhvrrMc0dwO3OMFfSMAmZOuk7g9wqiiA5JGL/lKmycgHj4c4Gd/Qw
         1jIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687771015; x=1690363015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yEPcTxjaEjVnJ9EdnwR9/7qwFtqWTq8VdOb5lliXdnI=;
        b=MJukQGNh4qx92Uv6lWhjiD17bKLMkvAsL6gpTXgQglE7Vdvs+St05G6M7Q5Taa54nh
         a0C0q3x0zXTyDKRmfgTMJpE7vUtcsYbqMDGwPsHhzenZZtxYYRU+Uxf0g6QueESeJBe4
         /1bz/WAPVVxkVLF7FntkqCNSdZ2o69so893ivJOYcy9VsGmuk59cn9QDEdQZx7kwrcVP
         2RDxdiSkHfzPW5zV4O6qG5ur/RpbmnikoC/BoxAgqIuepZsgfyXBvCxfEGCC5uREbyee
         VYhzh5H2A6mgTi12vkwITrd0j0JoxCIQ5NZS87Nf4mcBjpgUFtyST4Xs+epTOCe6/7hB
         S1Ug==
X-Gm-Message-State: AC+VfDzYGhNfwt/j3vKa/Oc9BOAyPj/jpBzxvR7c+GZLJMijr0fE589u
        8A9VZY4mEfRpv7/vjoPJ4WgTPHLG1WMXcA==
X-Google-Smtp-Source: ACHHUZ58i/BSZbf8uQyUPOS4H+ahkKf4A5l9l94a9CUXDq6KJf8p90qfCBUGJBHv9A7pbXz2uAQDlA==
X-Received: by 2002:a17:907:a03:b0:982:2278:bcef with SMTP id bb3-20020a1709070a0300b009822278bcefmr27242635ejc.60.1687771015161;
        Mon, 26 Jun 2023 02:16:55 -0700 (PDT)
Received: from dante731.cslcs.technion.ac.il ([132.68.206.91])
        by smtp.gmail.com with ESMTPSA id lc1-20020a170906f90100b00988e953a586sm3061414ejb.61.2023.06.26.02.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 02:16:54 -0700 (PDT)
From:   avidanborisov@gmail.com
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, avidanborisov@gmail.com
Subject: [PATCH v2 1/4] trace-cmd record: Add --daemonize
Date:   Mon, 26 Jun 2023 12:16:32 +0300
Message-Id: <20230626091635.3002827-2-avidanborisov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230626091635.3002827-1-avidanborisov@gmail.com>
References: <20230530045119.30c8d973@rorschach.local.home>
 <20230626091635.3002827-1-avidanborisov@gmail.com>
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
 tracecmd/trace-record.c                       | 129 +++++++++++++++++-
 tracecmd/trace-usage.c                        |   1 +
 3 files changed, 131 insertions(+), 2 deletions(-)

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
index bced804..0049768 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -91,6 +91,8 @@ static bool quiet;
 
 static bool fork_process;
 
+static bool do_daemonize;
+
 /* Max size to let a per cpu file get */
 static int max_kb;
 
@@ -1634,6 +1636,109 @@ static inline void ptrace_attach(struct buffer_instance *instance, int pid) { }
 
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
+		 * see output and errors after the daemonization (the user can
+		 * choose to supress it with >/dev/null if the user wants).
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
@@ -1748,6 +1853,9 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
 
 		execute_program(argc, argv);
 	}
+
+	if (do_daemonize)
+		daemonize_finish();
 	if (fork_process)
 		exit(0);
 	if (do_ptrace) {
@@ -5790,6 +5898,7 @@ enum {
 	OPT_proxy		= 261,
 	OPT_temp		= 262,
 	OPT_notimeout		= 264,
+	OPT_daemonize		= 265,
 };
 
 void trace_stop(int argc, char **argv)
@@ -6217,6 +6326,7 @@ static void parse_record_options(int argc,
 			{"file-version", required_argument, NULL, OPT_file_ver},
 			{"proxy", required_argument, NULL, OPT_proxy},
 			{"temp", required_argument, NULL, OPT_temp},
+			{"daemonize", no_argument, NULL, OPT_daemonize},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6690,6 +6800,11 @@ static void parse_record_options(int argc,
 				die("--fork option used for 'start' command only");
 			fork_process = true;
 			break;
+		case OPT_daemonize:
+			if (!IS_RECORD(ctx))
+				die("--daemonize option used for 'record' command only");
+			do_daemonize = true;
+			break;
 		case OPT_tsc2nsec:
 			ret = get_tsc_nsec(&ctx->tsc2nsec.shift,
 					   &ctx->tsc2nsec.mult);
@@ -6933,6 +7048,9 @@ static void record_trace(int argc, char **argv,
 	struct buffer_instance *instance;
 	struct filter_pids *pid;
 
+	if (do_daemonize)
+		daemonize_start();
+
 	/*
 	 * If top_instance doesn't have any plugins or events, then
 	 * remove it from being processed.
@@ -7051,8 +7169,15 @@ static void record_trace(int argc, char **argv,
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
index ecb7cad..45cb4f0 100644
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

