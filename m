Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D0DC6379F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Jan 2023 22:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjAMW6t (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Jan 2023 17:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjAMW6s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Jan 2023 17:58:48 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F937F9D1
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Jan 2023 14:58:47 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id jl4so24876153plb.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Jan 2023 14:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OqeU5WGEftiG7ruFTK6GjFFTrwO2yCUJBthsKNBKtKY=;
        b=D57EusTSuxhfI2xfTM9uwr2Vpfj1t+5PNmer9O29Eru4LlaH7NNjlWhITT3okN54Gl
         8Yd27r1aCSZ2ysAIfUTGAR4MUtif2/smEFqw4jo4jW25KQYJxypuHS+M28hQCZdm4WJJ
         Cv93WgEVO2VeERnNafJPPW8BauSJsb+mrDH7X15e/maY6jbhtVCxTfucNHIdkhCuGPiw
         CD8a/tTGjd873MmBIZxbfw4uEIfuH2LWa8TR/CaM4iJe/HxC9yhEgfYDkq9ul6t2Zt2T
         dc/XR89nYqEv27M2MOJNRxsFtZ9wDlpuIAf3Zw8EDet6rC9rUj/eTykx6R2ZkDIDeadR
         VUdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OqeU5WGEftiG7ruFTK6GjFFTrwO2yCUJBthsKNBKtKY=;
        b=7xrIE715Ildy5yg/nxd2XifRkBxjbKxQ81z0jJd++zY08fZzbQABZNICYYfaLwEWFu
         rKov+PiPI5CTbS1Uykq8HiAZp7C5d/3wvNFlFTmmR/i6VKo1/IUJ1zO7nF1lgCr+0JuO
         /QZEZKkzccoWcaha/KjgcUelPohysA3Sl5mqB6P8m5eLoAaui8M8wZDr0vOjJttlTrW0
         kcuDgpcL8Ou/AIejE7KBPBrMCGWhQ9NP90y3LwZub/tKZQ6yR0ll5x0BQzC9+KJeTd+9
         AoFEKNKGwkGrnuAXCAOYWWhEjBmitDrmDa9+qpvnRbZXTpodwd1K7HMjilwPzsRYxqLl
         O8Aw==
X-Gm-Message-State: AFqh2kqKl5qM9gor9kGVnPxSxZ4TWZARz/3O5ieRuoxexwjWpxDH730y
        lnsQVocDhK7c7FgQMZ+DBb2TlEef6gk=
X-Google-Smtp-Source: AMrXdXtrfBn80fLS6aw2HIGsqL+l92n184OZsZmbgbKF9ReKKeJiCP43m+ZsBMBuw1msxm9TgbmXpQ==
X-Received: by 2002:a05:6a21:9011:b0:b5:f664:b4bc with SMTP id tq17-20020a056a21901100b000b5f664b4bcmr5041218pzb.2.1673650726641;
        Fri, 13 Jan 2023 14:58:46 -0800 (PST)
Received: from mail.google.com (125-237-24-141-adsl.sparkbb.co.nz. [125.237.24.141])
        by smtp.gmail.com with ESMTPSA id 35-20020a631563000000b0044ed37dbca8sm11983455pgv.2.2023.01.13.14.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 14:58:46 -0800 (PST)
Date:   Sat, 14 Jan 2023 11:58:41 +1300
From:   Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     paulo.miguel.almeida.rodenas@gmail.com
Subject: [PATCH v2] trace-cmd: open code execvp routine to avoid multiple
 execve syscalls
Message-ID: <Y8HiIR9IrfWFG+MY@mail.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105220727.0660a0e4@gandalf.local.home>
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

- v2: open code execvp routine into trace-cmd. (Req. Steve Rostedt)
- v1: https://lore.kernel.org/linux-trace-devel/Y7dUo6woh9Y31cdl@mail.google.com/
---
 tracecmd/trace-record.c | 59 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 53 insertions(+), 6 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 7f0cebe..4a54637 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1683,6 +1683,58 @@ static int change_user(const char *user)
 	return 0;
 }
 
+static void execute_program(int argc, char **argv)
+{
+	char buf[PATH_MAX + NAME_MAX + 1];	
+	char *path_env;
+	size_t path_len;
+	size_t entry_len;
+	char *ptr_start;
+	char *ptr_end;
+
+	/*
+	 * if command specified by user is neither absolute nor 
+	 * relative than we search for it in $PATH. 
+	 */
+	if (!strchr(argv[0], '/') && !strchr(argv[0], '.')) {
+		path_env = getenv("PATH");
+		path_len = strlen(path_env);
+		ptr_start = path_env;
+
+		while ((ptr_start - path_env) < path_len) {
+			ptr_end = strchr(ptr_start, ':');
+			
+			/* single entry in PATH? */
+			if (!ptr_end)
+				entry_len = path_len;
+			else
+				entry_len = ptr_end - ptr_start;
+
+			strncpy(buf, ptr_start, entry_len);
+
+			if (buf[entry_len - 1] != '/')
+				buf[entry_len++] = '/';
+			
+			strncpy(buf + entry_len, argv[0], sizeof(buf) - entry_len);
+
+			/* does it exist and can we execute it? */
+			if (access(buf, X_OK) == 0)
+				break;
+
+			ptr_start = ptr_end + 1;
+		}
+	} else {
+		strncpy(buf, argv[0], sizeof(buf));
+	}
+
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
@@ -1709,12 +1761,7 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
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

