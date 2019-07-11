Return-Path: <SRS0=ayt5=VI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75620C74A52
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4191D21019
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pCkf8UGl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbfGKND3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Jul 2019 09:03:29 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33086 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728645AbfGKND2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 09:03:28 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so6261793wru.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jul 2019 06:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pYGGMTBfPn7XURlfNC5AdC+Z92FhL7hQTWqdDPwy2fQ=;
        b=pCkf8UGl7ZhUBsUjprJODMcCyXPqwa3I8qtFzMz9Zl9vP5BzQsEsoRI7yh+1KoEfnH
         WpNMc7WOtMi8HQJtf9nPtmCkcaGw62bMNN4/MOubXkNQLrTHbK9ABywcEsmB68lWbXUo
         +6CUaUaRah5LAJZTJZ526wOnIZFP2ceykV+zTe1PWL048hk4exygUZ0YET6rE1GVqWb6
         Cb4pSVaHJ6Qaiw8peqVboHSTLkJkVg3AhKXCkrqtiP2zbpHX8qXyfgA8iWlptwW1r/XE
         kFCVB8QL6OMKR385jzCiFW7tEa4E/Gyk/FeI/i12LmKwmzijsom4/3WxW99w2b++MaVG
         0JQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pYGGMTBfPn7XURlfNC5AdC+Z92FhL7hQTWqdDPwy2fQ=;
        b=qWHOAEia5ExXYZWXBjCjS8Ah/PIVrhadLV/bgH39XKnZZ6aaisI6lvz8L4AkYgmw1v
         OV3HweVTfrDihfixgY9N50E+vY/2IFT/F27jFTiRPJzt6LYYHCiV1DxtSUPTx5zTrdWD
         6yIqy1VQ6DHe6dbr+LfMSLaUmfdrno5W72DP9dEWbP93vJ21x2pKlD6if0gPMqvErZIy
         iqLX2kGU1psGXg7YHs2yd2ivnFsiVkpLMcmwarAvZtKKf1KBrB0rOqqYbazmXp/lL+wo
         WQWEVL6jJg/iVJnqJPjLYED9qFwuMZQSXIPmHQgpybiL38BoF43Bybza+dg3UWyIYE3n
         0rAA==
X-Gm-Message-State: APjAAAWONOAxNnuNGiRIWEHLbSN0rahm9eHhoXr7qFvAnuzf+E/gSXgy
        nHkI+1zFtypCJXmW0bV0Tb2i1pJp
X-Google-Smtp-Source: APXvYqx35SyHmMhkYaePshZUJMSKecD1WEUek2dEpPh415jq8eTod5dyNxL6Tcl1mpxD9nuzo8Ze6A==
X-Received: by 2002:adf:eb89:: with SMTP id t9mr5095875wrn.120.1562850205758;
        Thu, 11 Jul 2019 06:03:25 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y16sm5051490wrw.33.2019.07.11.06.03.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 06:03:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4] trace-cmd: Add option to execute traced process as given user
Date:   Thu, 11 Jul 2019 16:03:24 +0300
Message-Id: <20190711130324.25139-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new trace-cmd record option is added: "--user". When it is set with
combination of option -F, the traced process is executed in the context
of the specified user.

Suggested-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
[
   v4 changes:
	- Added check for strdup() failure.
	- Made input user string argument of change_user() and run_cmd()
	 constant.
   v3 changes:
      "--user" does not depend on option -F, it works with any command,
       specified as trace-cmd argument.
   v2 changes:
     - Check for errors in change_user(). If an error occurs while
       changing the user, the message is printed and the traced 
       process is not executed.
]

 Documentation/trace-cmd-record.1.txt |  4 +++
 tracecmd/trace-record.c              | 49 ++++++++++++++++++++++++++--
 tracecmd/trace-usage.c               |  1 +
 3 files changed, 51 insertions(+), 3 deletions(-)

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
index 48081d4..af52a88 100644
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
+static int change_user(const char *user)
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
+static void run_cmd(enum trace_type type, const char *user, int argc, char **argv)
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
@@ -5011,6 +5047,11 @@ static void parse_record_options(int argc,
 		case 'i':
 			ignore_event_not_found = 1;
 			break;
+		case OPT_user:
+			ctx->user = strdup(optarg);
+			if (!ctx->user)
+				die("Failed to allocate user name");
+			break;
 		case OPT_mmap:
 			get_mmap = 1;
 			break;
@@ -5079,7 +5120,6 @@ static void parse_record_options(int argc,
 	if (!ctx->filtered && ctx->instance->filter_mod)
 		add_func(&ctx->instance->filter_funcs,
 			 ctx->instance->filter_mod, "*");
-
 	if (filter_task && get_mmap)
 		do_ptrace = 1;
 
@@ -5097,6 +5137,9 @@ static void parse_record_options(int argc,
 			    "Did you mean 'record'?");
 		ctx->run_command = 1;
 	}
+	if (ctx->user && !ctx->run_command)
+		warning("--user %s is ignored, no command is specified",
+			ctx->user);
 }
 
 static enum trace_type get_trace_cmd_type(enum trace_cmd cmd)
@@ -5237,7 +5280,7 @@ static void record_trace(int argc, char **argv,
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

