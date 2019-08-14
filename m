Return-Path: <SRS0=RHP/=WK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52029C0650F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DDA02083B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HAQr5CgM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfHNIrh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 04:47:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33362 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbfHNIrc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 04:47:32 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so110420557wru.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Aug 2019 01:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n1QXt3gQbeByoBsas2rGrkCWkgw3Yr5ur3kcaDgIzR8=;
        b=HAQr5CgMh//tsd0SmxJaAHnTkwSoKzdqzWw+5vw0S9BEQ9bq+PxciV7kMTa2V8RrEN
         Fh8Q69SundeZ6Me/T5OJ8WX+oY06quQ3PCXCaAFmZdJEmTiVBs/+IvabNCU0r5IkHA1M
         EogWj2Ak4m5XLbyiWtC353XDWyD/oeoBcoU6xJZGTJk1EWOf4kmQBdi18BB/8nWaHdWk
         mmgZagraqhrcl5m9EwidlY7evziCoUGICxsOeByLnF8YMTsUHh2idc4kg7cIrnrHMP5V
         gu41YjYEucE4QUQN2mbrUM/q9qbii6iu+bKEbWG8wtuGgWWqkLy2lA69pv0b4PQqJcUi
         eA3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n1QXt3gQbeByoBsas2rGrkCWkgw3Yr5ur3kcaDgIzR8=;
        b=jYfw601xzxu2OoPBYfwAuFBtgh7efkZruwQzYp781rmryFK97oAHq9NXa9ubUcD0bF
         sX8oGykOuVOzts3BtxiikdK0nvMj1BhWNVVt5kzFrQuD+aK0cRp4siYjSVtVLGqEyg/O
         Xn3Uf2n2EAV+uCwCDP6Zb87wF/9VnheybVt3F/Rrw7ri8cMYRkec3rp1XiuvW/ZQ2iXN
         Xs0bN0tkVhtsAJ9mrpv14LBc8luUaG58skOk9IhrYjFurdFH3ZqnDSeoGQ78498f2mfF
         T2VMjv067D9OEuY2k8PyLRaPWZrIT0lfZy4xWHm8YQM5pp0MT96/EeleS9zlGCs9aXvo
         mFNA==
X-Gm-Message-State: APjAAAWYF3fG+X57HwjX9ZSGCSa4z8eRhqftkqS4oqelvQTU+wRetUkX
        fRg6CMLm/Ccg+QLKHbGgET+wtehNg/8=
X-Google-Smtp-Source: APXvYqy4b/RplHj1iaBo4ufVZuKK/Fpb20HiSQ7XOywGS+gUa/jnL9kMCTSFS7uDKctEHgyOlJn7Dw==
X-Received: by 2002:adf:f812:: with SMTP id s18mr8612007wrp.32.1565772449140;
        Wed, 14 Aug 2019 01:47:29 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c19sm2897481wml.13.2019.08.14.01.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 01:47:28 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 3/3] trace-cmd: Add option to execute traced process as given user
Date:   Wed, 14 Aug 2019 11:47:12 +0300
Message-Id: <20190814084712.28188-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814084712.28188-1-tz.stoyanov@gmail.com>
References: <20190814084712.28188-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new trace-cmd record option is added: "--user". When it is set with
combination of option -F, the traced process is executed in the context
of the specified user.

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

 Documentation/trace-cmd-record.1.txt |  3 ++
 tracecmd/trace-record.c              | 49 ++++++++++++++++++++++++++--
 tracecmd/trace-usage.c               |  1 +
 3 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
index e697f03..bb18e88 100644
--- a/Documentation/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd-record.1.txt
@@ -119,6 +119,9 @@ OPTIONS
      Used with either *-F* (or *-P* if kernel supports it) to trace the process'
      children too.
 
+*--user*::
+     Execute the specified *command* as given user.
+
 *-C* 'clock'::
      Set the trace clock to "clock".
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 17c676c..088aa28 100644
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
@@ -1455,7 +1458,34 @@ static void trace_or_sleep(enum trace_type type)
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
@@ -1476,6 +1506,10 @@ static void run_cmd(enum trace_type type, int argc, char **argv)
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
@@ -4590,6 +4624,7 @@ void update_first_instance(struct buffer_instance *instance, int topt)
 }
 
 enum {
+	OPT_user		= 243,
 	OPT_procmap		= 244,
 	OPT_quiet		= 245,
 	OPT_debug		= 246,
@@ -4822,6 +4857,7 @@ static void parse_record_options(int argc,
 			{"quiet", no_argument, NULL, OPT_quiet},
 			{"help", no_argument, NULL, '?'},
 			{"proc-map", no_argument, NULL, OPT_procmap},
+			{"user", required_argument, NULL, OPT_user},
 			{"module", required_argument, NULL, OPT_module},
 			{NULL, 0, NULL, 0}
 		};
@@ -5054,6 +5090,11 @@ static void parse_record_options(int argc,
 		case 'i':
 			ignore_event_not_found = 1;
 			break;
+		case OPT_user:
+			ctx->user = strdup(optarg);
+			if (!ctx->user)
+				die("Failed to allocate user name");
+			break;
 		case OPT_procmap:
 			get_procmap = 1;
 			break;
@@ -5137,7 +5178,9 @@ static void parse_record_options(int argc,
 			    "Did you mean 'record'?");
 		ctx->run_command = 1;
 	}
-
+	if (ctx->user && !ctx->run_command)
+		warning("--user %s is ignored, no command is specified",
+			ctx->user);
 	if (get_procmap) {
 		if (!ctx->run_command && !nr_filter_pids)
 			warning("--proc-map is ignored, no command or filtered PIDs are specified.");
@@ -5285,7 +5328,7 @@ static void record_trace(int argc, char **argv,
 	}
 
 	if (ctx->run_command)
-		run_cmd(type, (argc - optind) - 1, &argv[optind + 1]);
+		run_cmd(type, ctx->user, (argc - optind) - 1, &argv[optind + 1]);
 	else {
 		update_task_filter();
 		tracecmd_enable_tracing();
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 7a67784..20cb66f 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -58,6 +58,7 @@ static struct usage_help usage_help[] = {
 		"          --max-graph-depth limit function_graph depth\n"
 		"          --no-filter include trace-cmd threads in the trace\n"
 		"          --proc-map save the traced processes address map into the trace.dat file\n"
+		"          --user execute the specified [command ...] as given user\n"
 	},
 	{
 		"start",
-- 
2.21.0

