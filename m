Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A137C004D4
	for <linux-trace-devel@archiver.kernel.org>; Sat, 21 Jan 2023 05:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjAUFuh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 21 Jan 2023 00:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjAUFug (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 21 Jan 2023 00:50:36 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D336E0D7
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Jan 2023 21:50:35 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso6817472pjf.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Jan 2023 21:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N+WxGVmXWhIf4QZFko3rU43GV9FUtUDBc04sIT2doVw=;
        b=C0AgbOO8fFbzmHiS6fOvWdKE89aEftfkN7ckbCeW5UqVVtTifAD+Km3ettS7LlIxzS
         m15hVnMF+yM+JB8IiIKrFPNC+7Q1uxr04XylwEFNwcuch5BrKdZ879cp/JM77WBLJ1jd
         St7/aEG7qS2FNlrlM9jTYfyuYZ8FiNtSLh+xinpzTpRapGSRCvDKl9xUeBrI2qrQtqVl
         2WMqc9PQunSg+fZo7pY76VVSmL0FsFqiSofgMC7bOihAlQM4q0xSbIBYwjEzAetM8Hj+
         8p3JLaO8ThlBxzz/xbb+S6Yv5iQT15vYZ9OQoRo/8O1FZQTwPuO5nVId4wkWN862FWL7
         J+2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N+WxGVmXWhIf4QZFko3rU43GV9FUtUDBc04sIT2doVw=;
        b=WyGS3hK1zgzxI+GCCqb5SHiZ7chmHF4y8eRT1qu3ROvXj3ld0y4/jelZ2OLQ5AKF4N
         +SfpF8Ddoq72Lr+cllBVjiqP0sCP2NElylq8k2qr1Kc8qh/ofjV4chUOUQSv/tCbPRyl
         fJH2yz8f8OEskc+vmGOH9ns0cfeCfYpfPZN0kD+LN+/X0Apm59/+FJmnTRDj9wexzfWI
         ILcLHCGXHQL/W/TawrFWMEUpdws+SizUQSfJyDM3u9uT+6004bDWge6HOlR1pr2aetN2
         wGP8xTnpSt5a0p/bO7FO6WUNo69OV+rvfPXiX1vQIjZsv9t87nS/wI2zQ80oy2xl+plW
         jl3w==
X-Gm-Message-State: AFqh2kqfigJBoHzMFtrRM5x20jKQKyStRQvhmUKu4E1rfAbrgNAc7Cpt
        OrUeWUT9Hz0E3SiUw3nKklaRvZyeJtU=
X-Google-Smtp-Source: AMrXdXu396cCeTSGpt8rrtE/R+auPFARbpizNeasl3/lb57Dmn8qGZyDrmABVfL8OkmRQ01ebMaUmg==
X-Received: by 2002:a17:903:543:b0:192:fa8a:568a with SMTP id jo3-20020a170903054300b00192fa8a568amr4260603plb.2.1674280234613;
        Fri, 20 Jan 2023 21:50:34 -0800 (PST)
Received: from mail.google.com (125-237-24-141-adsl.sparkbb.co.nz. [125.237.24.141])
        by smtp.gmail.com with ESMTPSA id o22-20020aa79796000000b00581ad007a9fsm3399179pfp.153.2023.01.20.21.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 21:50:34 -0800 (PST)
Date:   Sat, 21 Jan 2023 18:50:29 +1300
From:   Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     paulo.miguel.almeida.rodenas@gmail.com
Subject: [PATCH v3] trace-cmd: Open code execvp routine to avoid multiple
 execve syscalls
Message-ID: <Y8t9JbdH9s29fyRW@mail.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In tracecmd/trace-record.c:<run_cmd>, trace-cmd record -F <executable>
is launched via the libc's execvp() routine. The way that execvp() routine
works is by invoking execve syscall for every entry on the $PATH if
command specified is neither absolute nor relative which can come across
as a bit cryptic to untrained eyes.

- absolute path example:

        # trace-cmd record -p function_graph \
                -g __x64_sys_execve -O nofuncgraph-irqs \
                -n __cond_resched --max-graph-depth 1  \
                -F /usr/bin/echo "ftrace" > /dev/null

        # trace-cmd report
        echo-172994 [000] 185539.798539: funcgraph_entry:      ! 803.376 us |  __x64_sys_execve();

- PATH-dependent path example:

        # trace-cmd record -p function_graph \
                -g __x64_sys_execve -O nofuncgraph-irqs \
                -n __cond_resched --max-graph-depth 1  \
                -F echo "ftrace" > /dev/null

        # trace-cmd report
        echo-172656 [002] 185009.671586: funcgraph_entry:      ! 288.732 us |  __x64_sys_execve();
        echo-172656 [002] 185009.671879: funcgraph_entry:      ! 158.337 us |  __x64_sys_execve();
        echo-172656 [002] 185009.672042: funcgraph_entry:      ! 161.843 us |  __x64_sys_execve();
        echo-172656 [002] 185009.672207: funcgraph_entry:      ! 157.656 us |  __x64_sys_execve();
        echo-172656 [002] 185009.672369: funcgraph_entry:      ! 156.343 us |  __x64_sys_execve();
        echo-172656 [002] 185009.672529: funcgraph_entry:      ! 863.629 us |  __x64_sys_execve();

Open code the libc's execvp routine into trace-cmd so ftrace will only
start recording once the command is found when it needs to be found in
PATH.

Signed-off-by: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
---
Changelog:

- v3: simplify path traversal code via strtok_r. (Req. Steven Rostedt)
- v2: open code execvp routine into trace-cmd. (Req. Steven Rostedt)
- v1: https://lore.kernel.org/linux-trace-devel/Y7dUo6woh9Y31cdl@mail.google.com/
---
 tracecmd/trace-record.c | 48 +++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 7f0cebe..c111ef6 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1683,6 +1683,46 @@ static int change_user(const char *user)
 	return 0;
 }
 
+static void execute_program(int argc, char **argv)
+{
+	char buf[PATH_MAX + NAME_MAX + 1];
+	char *path;
+	char *entry;
+	char *saveptr;
+
+	/*
+	 * if command specified by user is neither absolute nor
+	 * relative than we search for it in $PATH.
+	 */
+	if (*argv[0] != '/' && *argv[0] != '.') {
+		path = getenv("PATH");
+
+		if (!path)
+			die("can't search for '%s' if $PATH is NULL", argv[0]);
+
+		for (entry = strtok_r(path, ":", &saveptr);
+		     entry; entry = strtok_r(NULL, ":", &saveptr)) {
+
+			snprintf(buf, sizeof(buf), "%s/%s", entry, argv[0]);
+
+			/* does it exist and can we execute it? */
+			if (access(buf, X_OK) == 0)
+				break;
+
+		}
+	} else {
+		strncpy(buf, argv[0], sizeof(buf));
+	}
+
+	tracecmd_enable_tracing();
+	if (execve(buf, argv, environ)) {
+		fprintf(stderr, "\n********************\n");
+		fprintf(stderr, " Unable to exec %s\n", argv[0]);
+		fprintf(stderr, "********************\n");
+		die("Failed to exec %s", argv[0]);
+	}
+}
+
 static void run_cmd(enum trace_type type, const char *user, int argc, char **argv)
 {
 	int status;
@@ -1693,7 +1733,6 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
 	if (!pid) {
 		/* child */
 		update_task_filter();
-		tracecmd_enable_tracing();
 		if (!fork_process)
 			enable_ptrace();
 		/*
@@ -1709,12 +1748,7 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
 		if (change_user(user) < 0)
 			die("Failed to change user to %s", user);
 
-		if (execvp(argv[0], argv)) {
-			fprintf(stderr, "\n********************\n");
-			fprintf(stderr, " Unable to exec %s\n", argv[0]);
-			fprintf(stderr, "********************\n");
-			die("Failed to exec %s", argv[0]);
-		}
+		execute_program(argc, argv);
 	}
 	if (fork_process)
 		exit(0);
-- 
2.38.1

