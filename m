Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35710EB64DA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jun 2023 09:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjFZJUO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Jun 2023 05:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjFZJTh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Jun 2023 05:19:37 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9A12D7C
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jun 2023 02:16:59 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-98d34f1e54fso286828366b.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jun 2023 02:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687771018; x=1690363018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ssvwn1tdcdG6G287S2LoeqKIHY9bjql6tD9NTTbWJyE=;
        b=LO8jO+mdJzNhfLZo7y7HRoK4yBuixH9A4QOnagXLtlO6flL2kmSItbhJzt8QHvQSm+
         28MNzzbY6wBbLHM/8yPQAB87eD0YXxqj3NEv71NFJeGLkcJyfiMkPPc+PgFX0y1Z79qw
         6Zy2Vy1MsamdJS8JTmIPh7M7xI1l3wcqAhnxUttZUthCqgN8wHQn8VWiasx5219pKujU
         x4HxcW3//LQQCom2TGW510h9JQntvLRelBql+5dMhOEdeoW71IsjpcqRj1xDTam1I50e
         Jv0J9TW7liYlHTKx++BQKCIakLfMqHziPrrtyozK7/P682f3GiASOE/9lw7Naamg8Yvz
         VNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687771018; x=1690363018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ssvwn1tdcdG6G287S2LoeqKIHY9bjql6tD9NTTbWJyE=;
        b=BZ25yPM8xIuqeA+4TiKL895un6cy/nbJDKb4HxNVBkoOmpKTO8FWbvl2SDNDfX/TbZ
         ccLiSHo6HtBKfeWYxu7GkgCSGMl9hO7gMGR+GwEr6QOIla7FPlX2n4p3ErbDnDT5VceV
         opGf3pPP9FIFF1Db+8FcrJqEC0CO2R0LQZKXeX0sZY6WGcu1QxmIcywoX8Okm/LOctld
         mi40RgKMxnbdF3wRyzGyQLtESum0tb6EMSzPay4D5sMpvfeCWRGbSUP94WUcp4vTe5ez
         5kbc4JIT1s9fK8BzhBPHRnexEeYCAG+WIPLue29dpnliyzJR1H1YlrXD0UQFrvI/GuV7
         4XGQ==
X-Gm-Message-State: AC+VfDyqiVQQR3Z01OO6lk+86abaREQ7Mqqv9xvoYV95R6yD20PFEiad
        GrGzokbNFTp9JPRduhsZCziisTrTcRVOAQ==
X-Google-Smtp-Source: ACHHUZ5flIxiNKJB9oqO43ijy/K4zhWn20QkmKHCo7ZC8D7W8dAZspJiYDoydjOR76/EJOHZ37vHWA==
X-Received: by 2002:a17:907:1628:b0:991:eb77:74e with SMTP id hb40-20020a170907162800b00991eb77074emr451567ejc.76.1687771017929;
        Mon, 26 Jun 2023 02:16:57 -0700 (PDT)
Received: from dante731.cslcs.technion.ac.il ([132.68.206.91])
        by smtp.gmail.com with ESMTPSA id lc1-20020a170906f90100b00988e953a586sm3061414ejb.61.2023.06.26.02.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 02:16:57 -0700 (PDT)
From:   avidanborisov@gmail.com
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, avidanborisov@gmail.com
Subject: [PATCH v2 3/4] trace-cmd record: Create a pidfile when using --daemonize
Date:   Mon, 26 Jun 2023 12:16:34 +0300
Message-Id: <20230626091635.3002827-4-avidanborisov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230626091635.3002827-1-avidanborisov@gmail.com>
References: <20230530045119.30c8d973@rorschach.local.home>
 <20230626091635.3002827-1-avidanborisov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Avidan Borisov <avidanborisov@gmail.com>

When used with --daemonize, create a pidfile at
/var/run/trace-cmd-record.pid during the duration
of the recording, and delete it after we're done.

Signed-off-by: Avidan Borisov <avidanborisov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-record.1.txt |  1 +
 tracecmd/trace-record.c                        | 13 +++++++++++++
 tracecmd/trace-usage.c                         |  4 +++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 366ab46..0c9a914 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -420,6 +420,7 @@ OPTIONS
 
 *--daemonize*
     Run trace-cmd in the background as a daemon after recording has started.
+    Creates a pidfile at /var/run/trace-cmd-record.pid with the pid of trace-cmd during the recording.
 
 EXAMPLES
 --------
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 0049768..69a10bf 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -46,6 +46,8 @@
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
+#define RECORD_PIDFILE	"trace-cmd-record.pid"
+
 #define TRACE_CTRL	"tracing_on"
 #define TRACE		"trace"
 #define AVAILABLE	"available_tracers"
@@ -93,6 +95,8 @@ static bool fork_process;
 
 static bool do_daemonize;
 
+static bool created_pidfile;
+
 /* Max size to let a per cpu file get */
 static int max_kb;
 
@@ -646,6 +650,9 @@ void die(const char *fmt, ...)
 	else
 		ret = -1;
 
+	if (created_pidfile)
+		remove_pid_file(RECORD_PIDFILE);
+
 	kill_threads();
 	va_start(ap, fmt);
 	fprintf(stderr, "  ");
@@ -1737,6 +1744,9 @@ static void daemonize_finish(void)
 
 	if (kill(getppid(), SIGRTMIN) == -1)
 		die("daemonize: kill");
+
+	make_pid_file(RECORD_PIDFILE);
+	created_pidfile = true;
 }
 
 static void trace_or_sleep(enum trace_type type, bool pwait)
@@ -7225,6 +7235,9 @@ static void record_trace(int argc, char **argv,
 
 	destroy_stats();
 	finalize_record_trace(ctx);
+
+	if (created_pidfile)
+		remove_pid_file(RECORD_PIDFILE);
 }
 
 /*
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 45cb4f0..37d576b 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -81,7 +81,9 @@ static struct usage_help usage_help[] = {
 		"                        available algorithms can be listed with trace-cmd list -c\n"
 		"          --proxy vsocket to reach the agent. Acts the same as -A (for an agent)\n"
 		"              but will send the proxy connection to the agent.\n"
-		"          --daemonize run trace-cmd in the background as a daemon after recording has started\n"
+		"          --daemonize run trace-cmd in the background as a daemon after recording has started.\n"
+		"                      creates a pidfile at /var/run/trace-cmd-record.pid with the pid of trace-cmd\n"
+		"                      during the recording.\n"
 	},
 	{
 		"set",
-- 
2.25.1

