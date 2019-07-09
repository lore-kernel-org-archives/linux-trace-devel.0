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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9AAC73C46
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 14:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EB8F2082A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 14:29:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HR8JJID9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfGIO3N (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 10:29:13 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35951 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfGIO3N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 10:29:13 -0400
Received: by mail-wm1-f67.google.com with SMTP id g67so3485124wme.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Jul 2019 07:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XKN1EpQkbk/qIL6uRGEZvHmCde4vpiDSTvprsI22HUE=;
        b=HR8JJID9kMV3x2oMTZwd8999L0kdFNxcsmR4jWL6RS5ESZhlOFMrpNBj76f+IXAX5/
         fWeyMcD/YQlFa/8CNh01PwBEawM+c55qhqH2cB1f6IF8I1yQmNaRULoJoAi15iM4gWwB
         s1jY7MfHKKNxIydNJ/8TR26Q5NZxLsgpY5LIYd+fCulB5bGXLsYjk4x2uK8yu566arPJ
         7RjkM6HpbEZ6axWkXMX5r2znJ2Yp0tuiJwq6MHPCA9Kv/0nzqHZkgZsdDzmcqPOGgnR0
         n71IZ2LqVawpni4YDyM7Gx9FG4Pw2kqPWmRTMIzN8I/zLgr7jb+ww5jpX0EtpqfkLmwx
         HfCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XKN1EpQkbk/qIL6uRGEZvHmCde4vpiDSTvprsI22HUE=;
        b=oV8w5HAJZ4rIaJ2q9kUi9a6BDUmbETrazO3yMi4hyf9+fZg2zEn1VN9lYgMLYlZz3u
         Jvq45lmIhbdUJg83Zqx2C7K+cNDAJIDOybmByENiQdi4JSq/4/dlbshCZ2+XYdFVU/qJ
         bxwyZe0YdCpjt0sKMETGrj03L9GQKuHl69dWxssJcbAp5dMeMLXkA7/l2AxXtOswA5Om
         iuewrcuZs1RXks/YVtI64XFxVilrGWupINZwK8XrmwlIA2beMNNbKzWjOc/Zrosd8o10
         2/rNzPwtw2f+1c3//+BiojXJOTMQyrLtXowPoO0lvYSYqsMseCxcAXmNo4tWZi7QCT4K
         dfHg==
X-Gm-Message-State: APjAAAX3BBudJP32eCXWIrDN+yTh6A56ekfpjFEGt7TVRW5mNmKBdO5j
        cqXYkEMpZWaO4exkTD5qvnp7wxxa
X-Google-Smtp-Source: APXvYqz+4kuGfCjLsef4ek5zd9zi/YfjEcXiicnMC9rKQ99UIYPVtPCfjPZWxtMfqTq5gME0fbM+WA==
X-Received: by 2002:a7b:c928:: with SMTP id h8mr250601wml.93.1562682550360;
        Tue, 09 Jul 2019 07:29:10 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s2sm2301928wmj.33.2019.07.09.07.29.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 07:29:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3] trace-cmd: Add option to execute traced process as given user
Date:   Tue,  9 Jul 2019 17:29:08 +0300
Message-Id: <20190709142908.13776-1-tz.stoyanov@gmail.com>
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
   v3 changes:
      "--user" does not depend on option -F, it works with any command,
       specified as trace-cmd argument.
   v2 changes:
     - Check for errors in change_user(). If an error occurs while
       changing the user, the message is printed and the traced 
       process is not executed.
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

