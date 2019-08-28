Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CFAC3A5A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 11:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C0F82173E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 11:25:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XKAr8GeT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfH1LZH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 07:25:07 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36828 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfH1LZG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 07:25:06 -0400
Received: by mail-wm1-f68.google.com with SMTP id p13so2233378wmh.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Aug 2019 04:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ueWojPE0uYaqhVaCkvP31HnbARge98KstgiOIw7e4Us=;
        b=XKAr8GeTXyZu7CO7hFcGuFvsue7Fiz8UqKOxm9d308W5HAJyV4bhHAm//Vt3RP8EIx
         O8b6CDj1z8tWSDC+FWFs76LTkRpXa6E4OCDHIHHwsPS3f6aghicj8n3+kA3xcL9tXSC/
         5ODp8aXOuZUQuGLXECI1WxGfaLoePTDAPAG3i9w728THUjl1TnlJri912QnveOu5kbQ2
         ho+HXb7Ikz/33SzRNW3fxpU9ty0FQi3bRtnkRFzea+LnD05v6rlqP51/KA87c2J5Ru2N
         DLyqnLLBWk+h0s0yZRvoSn8neA2mJWL4g3/wd2qXk20kThZlnvmXM5q0px5nkmVElAOG
         cvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ueWojPE0uYaqhVaCkvP31HnbARge98KstgiOIw7e4Us=;
        b=sTsD1iAXzxqikKennPczff3CFEgzPxLKVtLOnJOxKIoxUNsLpm3FeeqyMZXGqlNUNY
         Y9QnZKMG/fQlgE4zErZRb+TRK3KB1GIDIUzb7JbPS/RGTIKuv31znD/Fq6QOLkbs5H/f
         3sJ894GiX/znXtd9igbtKd4trZauMwRbeCJ1kQgYoDjCaS5Edep43SWh0uM0RZzXUlHE
         cc0rBNf0+HOtmwiYrH3iCdgJsQy4g6rMWo+vJ3Xv9f4cVHvjcqxxSHyiTUaJ+clLjhR2
         1uK9lNg+Vx2Vvwh0kQR+DnPyo6t220nm9hf73RHMtAmuFPi9k6krCBhrOYCEsIyvQarL
         4l3w==
X-Gm-Message-State: APjAAAWf3YqCIDD18mNSSU1W1wi55Xy3G2zlVMvt6JwciJdRthSmUwCT
        k1TFGTURLBi7zzc95honii+LzXLk
X-Google-Smtp-Source: APXvYqwh7MYeRkfzDpYhRLTAr4npS6ierjo57tG2kCFu+n64C7QFQ1DCZ3MzNn8/txYfJ6KjcBkODg==
X-Received: by 2002:a7b:c0d0:: with SMTP id s16mr4177028wmh.65.1566991503899;
        Wed, 28 Aug 2019 04:25:03 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c132sm2846766wme.27.2019.08.28.04.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 04:25:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 3/3] trace-cmd: Add option to execute traced process as given user
Date:   Wed, 28 Aug 2019 14:24:57 +0300
Message-Id: <20190828112457.10533-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828112457.10533-1-tz.stoyanov@gmail.com>
References: <20190828112457.10533-1-tz.stoyanov@gmail.com>
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
index 4a20339..9b7357f 100644
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
@@ -1457,7 +1460,34 @@ static void trace_or_sleep(enum trace_type type)
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
@@ -1478,6 +1508,10 @@ static void run_cmd(enum trace_type type, int argc, char **argv)
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
@@ -4592,6 +4626,7 @@ void update_first_instance(struct buffer_instance *instance, int topt)
 }
 
 enum {
+	OPT_user		= 243,
 	OPT_procmap		= 244,
 	OPT_quiet		= 245,
 	OPT_debug		= 246,
@@ -4824,6 +4859,7 @@ static void parse_record_options(int argc,
 			{"quiet", no_argument, NULL, OPT_quiet},
 			{"help", no_argument, NULL, '?'},
 			{"proc-map", no_argument, NULL, OPT_procmap},
+			{"user", required_argument, NULL, OPT_user},
 			{"module", required_argument, NULL, OPT_module},
 			{NULL, 0, NULL, 0}
 		};
@@ -5056,6 +5092,11 @@ static void parse_record_options(int argc,
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
@@ -5139,7 +5180,9 @@ static void parse_record_options(int argc,
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
@@ -5287,7 +5330,7 @@ static void record_trace(int argc, char **argv,
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

