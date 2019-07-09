Return-Path: <SRS0=uJAW=VG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF5FC73C50
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 14:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FCBF20844
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 14:26:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jlbCD3xP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfGIO0M (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 10:26:12 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53460 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfGIO0M (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 10:26:12 -0400
Received: by mail-wm1-f66.google.com with SMTP id x15so3308883wmj.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Jul 2019 07:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ufJG7KSt2BmzqEdXqGBShMDTK10WgQch0/xjA9o1lRI=;
        b=jlbCD3xPdgjLPaAE+zpvwFf7GOZmNbJlUuMjJvJ7rSW8McDAwmFJ+djpiuUaN3sL5m
         JTVhJvVsTOs9WZWds3zbrK6DHBpcunJJfmeoBgLo1d2EK8lPRd5GLI7Nh3o4VEmlGu6b
         WeK2Sgqw9/I8Ttd7q7s3qEPZ8bX09t3ahQJG4FsYXUSCnzM9piSM4lSlV61k3l/apHCV
         36oKcuG/vbZSG8a3JdUIHEy5cuZ8VV4LFlJOX4BQmmxu9Qs0DPJXp78PsHB6IS3pqLQ7
         E3m+QPH6LIhtw0cBz0qurYI3i+88MRskKEtkw6wVGGD0gC5RTidOopa3cbv8waDgatp9
         7eFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ufJG7KSt2BmzqEdXqGBShMDTK10WgQch0/xjA9o1lRI=;
        b=QoD7EY72hCREvsiGYStTMU836CewxV1JUo9YbPP1mENwX58r5Nv8/om12QnAYy9n4h
         N/3Fqa6HAUevoHooiW7n9qtfnF/qvdbQY8RGg0ChMaDfkQRj1r9rPwNT7VSStvUHEVBO
         smwKWcxF3cgRPdP/A5WEE7XfkEMstnHqth8dLvv9hmbyDY0RwGrSG93O9wdSQ5LECL1k
         mvxrdRJMcsyfAgBBxrpUyYIJzUxLUTVYzv4HEFjtWBnjUnhALaavwffFYWvXfVDwVwfV
         o+u8Drg+h7M6y6FTZbgKLid5GnGHItXqxKV8F51ZMsbJ+t+ANGF/6Z1CZ2Pa9oSq9sZW
         thLw==
X-Gm-Message-State: APjAAAV3NjfEi7ejtjeDRCmv07Q8wyOyAGLN3Jrue7E5JSOtC0UzX6HY
        OKuC3z269tnI/O9Mm8cTX9mjHyNE
X-Google-Smtp-Source: APXvYqz0leVDbUxLbJbS3L8+qgGzbLR5AyYD3iQeD1auKD670begJZrpJzRVF2UkR7m4SBqVKSHSqA==
X-Received: by 2002:a1c:4d05:: with SMTP id o5mr237768wmh.63.1562682369244;
        Tue, 09 Jul 2019 07:26:09 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f18sm8597171wrt.43.2019.07.09.07.26.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 07:26:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] trace-cmd: Add option to execute traced process as given user
Date:   Tue,  9 Jul 2019 17:26:07 +0300
Message-Id: <20190709142607.13414-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new trace-cmd record option is added: "--user". If a comnmand is specified
as trce-cmd argument, it is executed in the context of the given user.

Suggested-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
[
   v2 changes:
      "--user" does not depend on option -F, it works with any command,
       specified as trace-cmd argument.
]


 Documentation/trace-cmd-record.1.txt |  4 +++
 tracecmd/trace-record.c              | 47 ++++++++++++++++++++++++++--
 tracecmd/trace-usage.c               |  1 +
 3 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
index 4a59de9..6a0f975 100644
--- a/Documentation/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd-record.1.txt
@@ -122,6 +122,10 @@ OPTIONS
 *--mmap*::
      Used with either *-F* or *-P*, save the traced process memory map into
      the trace.dat file.
+
+*--user*::
+     Execute the specified *command* as given user.
+
 *-C* 'clock'::
      Set the trace clock to "clock".
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 48081d4..acadd7a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -33,6 +33,8 @@
 #include <errno.h>
 #include <limits.h>
 #include <libgen.h>
+#include <pwd.h>
+#include <grp.h>
 
 #include "version.h"
 #include "trace-local.h"
@@ -208,6 +210,7 @@ struct common_record_context {
 	struct buffer_instance *instance;
 	const char *output;
 	char *date2ts;
+	char *user;
 	int data_flags;
 
 	int record_all;
@@ -1417,7 +1420,34 @@ static void trace_or_sleep(enum trace_type type)
 		sleep(10);
 }
 
-static void run_cmd(enum trace_type type, int argc, char **argv)
+static int change_user(char *user)
+{
+	struct passwd *pwd;
+
+	if (!user)
+		return 0;
+
+	pwd = getpwnam(user);
+	if (!pwd)
+		return -1;
+	if (initgroups(user, pwd->pw_gid) < 0)
+		return -1;
+	if (setgid(pwd->pw_gid) < 0)
+		return -1;
+	if (setuid(pwd->pw_uid) < 0)
+		return -1;
+
+	if (setenv("HOME", pwd->pw_dir, 1) < 0)
+		return -1;
+	if (setenv("USER", pwd->pw_name, 1) < 0)
+		return -1;
+	if (setenv("LOGNAME", pwd->pw_name, 1) < 0)
+		return -1;
+
+	return 0;
+}
+
+static void run_cmd(enum trace_type type, char *user, int argc, char **argv)
 {
 	int status;
 	int pid;
@@ -1438,6 +1468,10 @@ static void run_cmd(enum trace_type type, int argc, char **argv)
 			dup2(save_stdout, 1);
 			close(save_stdout);
 		}
+
+		if (change_user(user) < 0)
+			die("Failed to change user to %s", user);
+
 		if (execvp(argv[0], argv)) {
 			fprintf(stderr, "\n********************\n");
 			fprintf(stderr, " Unable to exec %s\n", argv[0]);
@@ -4548,6 +4582,7 @@ void update_first_instance(struct buffer_instance *instance, int topt)
 }
 
 enum {
+	OPT_user		= 243,
 	OPT_mmap		= 244,
 	OPT_quiet		= 245,
 	OPT_debug		= 246,
@@ -4780,6 +4815,7 @@ static void parse_record_options(int argc,
 			{"quiet", no_argument, NULL, OPT_quiet},
 			{"help", no_argument, NULL, '?'},
 			{"mmap", no_argument, NULL, OPT_mmap},
+			{"user", required_argument, NULL, OPT_user},
 			{"module", required_argument, NULL, OPT_module},
 			{NULL, 0, NULL, 0}
 		};
@@ -5011,6 +5047,9 @@ static void parse_record_options(int argc,
 		case 'i':
 			ignore_event_not_found = 1;
 			break;
+		case OPT_user:
+			ctx->user = strdup(optarg);
+			break;
 		case OPT_mmap:
 			get_mmap = 1;
 			break;
@@ -5079,7 +5118,6 @@ static void parse_record_options(int argc,
 	if (!ctx->filtered && ctx->instance->filter_mod)
 		add_func(&ctx->instance->filter_funcs,
 			 ctx->instance->filter_mod, "*");
-
 	if (filter_task && get_mmap)
 		do_ptrace = 1;
 
@@ -5097,6 +5135,9 @@ static void parse_record_options(int argc,
 			    "Did you mean 'record'?");
 		ctx->run_command = 1;
 	}
+	if (ctx->user && !ctx->run_command)
+		warning("--user %s is ignored, no command is specified",
+			ctx->user);
 }
 
 static enum trace_type get_trace_cmd_type(enum trace_cmd cmd)
@@ -5237,7 +5278,7 @@ static void record_trace(int argc, char **argv,
 	}
 
 	if (ctx->run_command)
-		run_cmd(type, (argc - optind) - 1, &argv[optind + 1]);
+		run_cmd(type, ctx->user, (argc - optind) - 1, &argv[optind + 1]);
 	else {
 		update_task_filter();
 		tracecmd_enable_tracing();
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index c658ede..e3e8186 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -58,6 +58,7 @@ static struct usage_help usage_help[] = {
 		"          --max-graph-depth limit function_graph depth\n"
 		"          --no-filter include trace-cmd threads in the trace\n"
 		"          --mmap used with -F or -P, save the traced process memory map into the trace.dat file\n"
+		"          --user execute the specified [command ...] as given user\n"
 	},
 	{
 		"start",
-- 
2.21.0

