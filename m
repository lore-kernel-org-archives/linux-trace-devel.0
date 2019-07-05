Return-Path: <SRS0=byw1=VC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20F49C4649B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 11:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E908321852
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 11:35:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rwWE0bO9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfGELfm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 07:35:42 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51063 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfGELfl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 07:35:41 -0400
Received: by mail-wm1-f68.google.com with SMTP id n9so8556821wmi.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Jul 2019 04:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PSbIUjzuNMow74ac00NeXNty4lpJhFEoR+7iY9m1zjg=;
        b=rwWE0bO9rZYphpGcVLWMMtYYhu+IWnxq5hUFtyT0uDI4vdEmnlrpJUS62zP8D/x2f+
         zyMn4MbRx4RSALph/OVnIMRMpYpsahz+M4/FemjIfDc22Guo8hCMtkVXp7ohXnmwl71t
         uGLEqzNvxstSeNpKooG2Y9qCoxcXRMDJlnAzpWnKhBF3AnQyNRf8XJpghZf3QjJ3BSCu
         DwesxVJV/zA+2d4DI1BCW3aXblnk49YAo46ZdPPvTftdVG7ADyfqgIlYw+mZEDdGet5I
         zI4WPxxIES7zF+SsOaUMQ2dOeRTrY8/hU/jhg4i0RCEqCugkcZ4kq2cEwg5CJuE0xSM0
         fSGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PSbIUjzuNMow74ac00NeXNty4lpJhFEoR+7iY9m1zjg=;
        b=XdJvKTk5nlfDx2H8vkOnVG/UgLUUn8qroiR7pWjuaKOIkVGBdIVV5fXEdVO93xLHYZ
         ECm6T/vElGsX6p1RObNVViP7W7FWGHYGHZ6QBLBJBDVnxtGdsIDbBjkHmJZXaWSpmFMF
         aKHZy4i99EaEcFXEfi6i6Ac0vtodc6FfowJN4rOipmQUGsDzP5/U7kV8bIG3IolRD97w
         Cl3u5cTwLoubt+hGyxcOuDiv5VA3foUXWe+wH1/iHdQgGhly0G8znxFDT/Ra29MW9/0c
         LvwiUSA7AnRpwmHOGow2qcChRNjV7+rj6KP3vBLDRHVo6qbgSb4DkKRSTeRvIIRNzrDe
         IMnw==
X-Gm-Message-State: APjAAAVXebH6+QbEs48MGg9uW4Bmq4tAu/KcffnDlDgaHdJj37bzXw3I
        AjCvh464a+bMR0HCjHVVvLkhtsZb
X-Google-Smtp-Source: APXvYqwYTfM6l6i6COMitM6yJJcGIki/SGM9m+xhTTMvS8l3ZDt3av5C5RbtJ/Pu+nkc7qK0I50v3w==
X-Received: by 2002:a7b:c310:: with SMTP id k16mr3092096wmj.133.1562326539152;
        Fri, 05 Jul 2019 04:35:39 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t1sm10951778wra.74.2019.07.05.04.35.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 04:35:38 -0700 (PDT)
From:   tz.stoyanov@gmail.com
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Add option to execute traced process as given user
Date:   Fri,  5 Jul 2019 14:35:36 +0300
Message-Id: <20190705113536.10496-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

A new trace-cmd record option is added: "--user". When it is set with
combination of option -F, the traced process is executed in the context
of the specified user.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Suggested-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
[
  Should be applied on top of patch "trace-cmd: Save the tracee memory map
into the trace.dat file."
]

 Documentation/trace-cmd-record.1.txt |  4 +++
 tracecmd/trace-record.c              | 38 +++++++++++++++++++++++++---
 tracecmd/trace-usage.c               |  1 +
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
index 4a59de9..df92354 100644
--- a/Documentation/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd-record.1.txt
@@ -122,6 +122,10 @@ OPTIONS
 *--mmap*::
      Used with either *-F* or *-P*, save the traced process memory map into
      the trace.dat file.
+
+*--user*::
+     Used with -F, execute the traced process as given user.
+
 *-C* 'clock'::
      Set the trace clock to "clock".
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 48081d4..cfaee90 100644
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
@@ -1417,7 +1420,26 @@ static void trace_or_sleep(enum trace_type type)
 		sleep(10);
 }
 
-static void run_cmd(enum trace_type type, int argc, char **argv)
+static void change_user(char *user)
+{
+	struct passwd *pwd;
+
+	if (!user)
+		return;
+
+	pwd = getpwnam(user);
+	if (pwd) {
+		initgroups(user, pwd->pw_gid);
+		setgid(pwd->pw_gid);
+		setuid(pwd->pw_uid);
+
+		setenv("HOME", pwd->pw_dir, 1);
+		setenv("USER", pwd->pw_name, 1);
+		setenv("LOGNAME", pwd->pw_name, 1);
+	}
+}
+
+static void run_cmd(enum trace_type type, char *user, int argc, char **argv)
 {
 	int status;
 	int pid;
@@ -1438,6 +1460,9 @@ static void run_cmd(enum trace_type type, int argc, char **argv)
 			dup2(save_stdout, 1);
 			close(save_stdout);
 		}
+
+		change_user(user);
+
 		if (execvp(argv[0], argv)) {
 			fprintf(stderr, "\n********************\n");
 			fprintf(stderr, " Unable to exec %s\n", argv[0]);
@@ -4548,6 +4573,7 @@ void update_first_instance(struct buffer_instance *instance, int topt)
 }
 
 enum {
+	OPT_user		= 243,
 	OPT_mmap		= 244,
 	OPT_quiet		= 245,
 	OPT_debug		= 246,
@@ -4780,6 +4806,7 @@ static void parse_record_options(int argc,
 			{"quiet", no_argument, NULL, OPT_quiet},
 			{"help", no_argument, NULL, '?'},
 			{"mmap", no_argument, NULL, OPT_mmap},
+			{"user", required_argument, NULL, OPT_user},
 			{"module", required_argument, NULL, OPT_module},
 			{NULL, 0, NULL, 0}
 		};
@@ -5011,6 +5038,9 @@ static void parse_record_options(int argc,
 		case 'i':
 			ignore_event_not_found = 1;
 			break;
+		case OPT_user:
+			ctx->user = strdup(optarg);
+			break;
 		case OPT_mmap:
 			get_mmap = 1;
 			break;
@@ -5079,7 +5109,9 @@ static void parse_record_options(int argc,
 	if (!ctx->filtered && ctx->instance->filter_mod)
 		add_func(&ctx->instance->filter_funcs,
 			 ctx->instance->filter_mod, "*");
-
+	if (ctx->user && !filter_task)
+		warning("--user %s is ignored, no traced process is specified",
+			ctx->user);
 	if (filter_task && get_mmap)
 		do_ptrace = 1;
 
@@ -5237,7 +5269,7 @@ static void record_trace(int argc, char **argv,
 	}
 
 	if (ctx->run_command)
-		run_cmd(type, (argc - optind) - 1, &argv[optind + 1]);
+		run_cmd(type, ctx->user, (argc - optind) - 1, &argv[optind + 1]);
 	else {
 		update_task_filter();
 		tracecmd_enable_tracing();
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index c658ede..fcc314e 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -58,6 +58,7 @@ static struct usage_help usage_help[] = {
 		"          --max-graph-depth limit function_graph depth\n"
 		"          --no-filter include trace-cmd threads in the trace\n"
 		"          --mmap used with -F or -P, save the traced process memory map into the trace.dat file\n"
+		"          --user used with -F, execute the traced process as given user\n"
 	},
 	{
 		"start",
-- 
2.21.0

