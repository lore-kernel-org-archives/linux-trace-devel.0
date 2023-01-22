Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D481C27C76
	for <linux-trace-devel@archiver.kernel.org>; Sun, 22 Jan 2023 01:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjAVBov (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 21 Jan 2023 20:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjAVBou (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 21 Jan 2023 20:44:50 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924711EFD8
        for <linux-trace-devel@vger.kernel.org>; Sat, 21 Jan 2023 17:44:49 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id b17so8467947pld.7
        for <linux-trace-devel@vger.kernel.org>; Sat, 21 Jan 2023 17:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/mTqHGJF4N/wBi44tGxHaCe2bkR/IrNXl99UrMJXJs4=;
        b=QKLvWrUTcgmv5gXGn9Bm7V5cnmQIAr/wDRPTLI4g6t14klvJweEf/m9OI2t5t9ryQc
         Oa5oMuGne+jxqaSL+8zgbEFFuHoUATTcbwf6lnmOE5NncPHpJYgf33QbQVvZDHtNiZW/
         2DB0dJ80qfQaEZb6KZeuJl5JKXxevu1jnmeRoXDre4LkpdtBLRumtGy+tukIS+//8pzJ
         XFQvGU87Hg6e3/3lHs8827Qz47XSVnMc4EewS6Dt2TS4IwDM2mwW+9BUSk3ruOI36669
         y20XilIRSGpKZV2OUJnYZHO74jaoft7oAsVymy2YUtkDmziDFzvLoq4oSjqIBFiLmefJ
         QEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/mTqHGJF4N/wBi44tGxHaCe2bkR/IrNXl99UrMJXJs4=;
        b=T8Qlhkk4eIZ/+KoDwXe1jadgnyzxj6mvhHwfWro+mfHb3HGpl0quUNuxaEW7TQEh6m
         bt4otZNu7jM8gn7xfx73VJyltIepjFB6QervWsAxh8pNXmfdfo2DyO9/vANXTX/cgTrn
         /TusawjP+zWHZWlD+MgikMtRoXfMeFMCc0ATKY3Wn0nILoyD6Jb0O7ETVtLYnpDnyN8U
         BtZ/5nSIUiAeEYjrhV4euAUnCzRDgu0tLyblBjQcWdvUbwoesy8MHJYVH3yaT7hBrO9a
         0STgAAhBZLxO43tXVVgvw/+uhwxS14/ggUvqxqwkhrRPA/1cRpGav0M7bMf+4jpU1tRa
         O9ow==
X-Gm-Message-State: AFqh2kprfg/yzd29VnhL54X0I3hqpwX5pfrey0sm//YcibJq8fpO0jYr
        w1ogCZ/xm+7M7AYDJgpfRM3xeN0o3Ow=
X-Google-Smtp-Source: AMrXdXuyNqhzBUbMHSE6X5TbbSJqMG1w386NvWw626z1t/OWhYM0f/neViLKEQ67DpsMS5hM7cn0mg==
X-Received: by 2002:a05:6a20:4407:b0:af:6d54:89fe with SMTP id ce7-20020a056a20440700b000af6d5489femr6623447pzb.6.1674351888864;
        Sat, 21 Jan 2023 17:44:48 -0800 (PST)
Received: from mail.google.com (125-237-24-141-adsl.sparkbb.co.nz. [125.237.24.141])
        by smtp.gmail.com with ESMTPSA id y1-20020a17090a600100b002262ab43327sm3950791pji.26.2023.01.21.17.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jan 2023 17:44:48 -0800 (PST)
Date:   Sun, 22 Jan 2023 14:44:44 +1300
From:   Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     paulo.miguel.almeida.rodenas@gmail.com
Subject: [PATCH v4] trace-cmd: Open code execvp routine to avoid multiple
 execve syscalls
Message-ID: <Y8yVDI93geYhLQio@mail.google.com>
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

- v4: handle case in which path is relative but not './' is used. 
      (Req. Steven Rostedt)
- v3: simplify path traversal code via strtok_r. (Req. Steven Rostedt)
- v2: open code execvp routine into trace-cmd. (Req. Steven Rostedt)
- v1: https://lore.kernel.org/linux-trace-devel/Y7dUo6woh9Y31cdl@mail.google.com/

Tests made (that's should help during the review):

# Path-dependent
./tracecmd/trace-cmd <args> -F ls

# relative path with '.'
./tracecmd/trace-cmd <args> -F ../../../../usr/bin/ls

# absolute path
./tracecmd/trace-cmd <args> -F /usr/bin/ls

# relative path with no dots
mkdir test_bin 	&& cp /usr/bin/ls test_bin/ \
	&& ./tracecmd/trace-cmd <args> -F test_bin/ls \
	&& rm -rf test_bin
---
 tracecmd/trace-record.c | 48 +++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 7f0cebe..32fbfef 100644
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
+	if (!strchr(argv[0], '/')) {
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

