Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD56267714
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Feb 2026 01:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770167762; cv=none; b=kDv9cyGpDQSyzcCJnx8ZUP0lSPLWTvJ0FRCfmjDRmyLgtCLSspkW511gm6ec8fmi1Egl27iu/Xn7WVzaytq5TedBYM7shIOKDEjkjBa3yT1yR/rtHucvZgqF66leB7bANUIHS/TihP3OptFra7vuyNKct2zOwReURXUNZ4+CrqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770167762; c=relaxed/simple;
	bh=d36RnYw+e2MCCB4EhBGzdVW8uhMr5+VekLcw/YPwanA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5TdWcfesyKgiwAalHWbybY06MdPeeeHMQPHWMwPmSNT0Twrn6g0Q5snAfg8J+QmMi+aYPJeg5qknIPiB/IUSuYYsTFe/kaQ2JWhJlZIgiKopfl75SknXEMFbmZgNeFKUZDhT8BBlHFSl5J9skwdBIIJ4AiCQ1SSN5lNJKFNodk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F76C19425;
	Wed,  4 Feb 2026 01:16:00 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vnRVO-00000008xVA-47tt;
	Tue, 03 Feb 2026 20:16:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] trace-cmd record: Add -K flag to keep current settings
Date: Tue,  3 Feb 2026 20:14:54 -0500
Message-ID: <20260204011629.2135260-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260204011629.2135260-1-rostedt@goodmis.org>
References: <20260204011629.2135260-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a -K flag to keep the current settings and not to reset before
executing the record. This makes trace-cmd record act more like trace-cmd set
but also record the data.

Also fix typo in trace-cmd record man page.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/trace-cmd/trace-cmd-record.1.txt |  7 ++++++-
 tracecmd/trace-record.c                        | 18 +++++++++++-------
 tracecmd/trace-usage.c                         |  1 +
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 7cb652bc3c0c..494c5c9f7155 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -254,12 +254,17 @@ OPTIONS
 *-k*::
     By default, when trace-cmd is finished tracing, it will reset the buffers
     and disable all the tracing that it enabled. This option keeps trace-cmd
-    from disabling the tracer and reseting the buffer. This option is useful for
+    from disabling the tracer and resetting the buffer. This option is useful for
     debugging trace-cmd.
 
     Note: usually trace-cmd will set the "tracing_on" file back to what it
     was before it was called. This option will leave that file set to zero.
 
+*-K*::
+    By default, when before trace-cmd starts recording, it will reset the buffers
+    and clear events as well as any triggers and such. This option keeps trace-cmd
+    from doing that. It is similar to *trace-cmd set* but still records data.
+
 *-i*::
     By default, if an event is listed that trace-cmd does not find, it
     will exit with an error. This option will just ignore events that are
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 1cef9a623158..1707345b343f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -73,6 +73,7 @@ static tracecmd_handle_init_func handle_init = NULL;
 static int rt_prio;
 
 static int keep;
+static int Keep; // do not reset before tracing
 
 static int latency;
 static long sleep_time = 1000;
@@ -6438,9 +6439,6 @@ static void parse_record_options(int argc,
 
 	init_common_record_context(ctx, curr_cmd);
 
-	if (IS_CMDSET(ctx))
-		keep = 1;
-
 	for (;;) {
 		int option_index = 0;
 		int ret;
@@ -6483,7 +6481,7 @@ static void parse_record_options(int argc,
 		if (IS_EXTRACT(ctx))
 			opts = "+haf:Fp:co:O:sr:g:l:n:P:N:tb:B:ksiT";
 		else
-			opts = "+hae:f:FA:p:cC:dDGo:O:s:r:V:vg:l:n:P:N:tb:R:B:ksSiTm:M:H:q";
+			opts = "+hae:f:FA:p:cC:dDGo:O:s:r:V:vg:l:n:P:N:tb:R:B:kKsSiTm:M:H:q";
 		c = getopt_long (argc-1, argv+1, opts, long_options, &option_index);
 		if (c == -1)
 			break;
@@ -6852,6 +6850,9 @@ static void parse_record_options(int argc,
 			if (IS_PROFILE(ctx))
 				ctx->instance->flags |= BUFFER_FL_PROFILE;
 			break;
+		case 'K':
+			Keep = 1;
+			/* fall through */
 		case 'k':
 			cmd_check_die(ctx, CMD_set, *(argv+1), "-k");
 			keep = 1;
@@ -7216,7 +7217,7 @@ static void record_trace(int argc, char **argv,
 		ctx->topt = 1;
 
 	update_first_instance(ctx->instance, ctx->topt);
-	if (!IS_CMDSET(ctx)) {
+	if (!Keep) {
 		check_doing_something();
 		check_function_plugin();
 	}
@@ -7258,7 +7259,7 @@ static void record_trace(int argc, char **argv,
 
 	if (!is_guest(ctx->instance))
 		fset = set_ftrace(ctx->instance, !ctx->disable, ctx->total_disable);
-	if (!IS_CMDSET(ctx))
+	if (!Keep)
 		tracecmd_disable_all_tracing(1);
 
 	for_all_instances(instance)
@@ -7314,7 +7315,7 @@ static void record_trace(int argc, char **argv,
 
 		update_task_filter();
 
-		if (!IS_CMDSET(ctx))
+		if (!Keep)
 			tracecmd_enable_tracing();
 
 		if (type & (TRACE_TYPE_START | TRACE_TYPE_SET))
@@ -7416,6 +7417,9 @@ void trace_set(int argc, char **argv)
 {
 	struct common_record_context ctx;
 
+	/* Keep the current settings */
+	Keep = 1;
+	keep = 1;
 	parse_record_options(argc, argv, CMD_set, &ctx);
 	record_trace_command(argc, argv, &ctx);
 	exit(0);
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index f5a1c74c2ddf..e7b32f800e00 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -50,6 +50,7 @@ static struct usage_help usage_help[] = {
 		"          -b change kernel buffersize (in kilobytes per CPU)\n"
 		"          -B create sub buffer and following events will be enabled here\n"
 		"          -k do not reset the buffers after tracing.\n"
+		"          -K do not reset the buffers before tracing.\n"
 		"          -i do not fail if an event is not found\n"
 		"          -q print no output to the screen\n"
 		"          -G when profiling, set soft and hard irqs as global\n"
-- 
2.51.0

