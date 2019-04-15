Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406E1C10F12
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 23:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1329E2084B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 23:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfDOXA1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 19:00:27 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39596 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbfDOXA1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 19:00:27 -0400
Received: by mail-wm1-f66.google.com with SMTP id n25so22505095wmk.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 16:00:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/B6kne7Oor5k7nI87WPMSvdH2yPz3zRd4cAAmlf36j4=;
        b=Z9cfEEVQEJgbhjkRZk4bCkeprqTV0QNckmqGdPNZgCuHUvACJtgsDxLp4bFLOKEOW4
         7dAbDg137Na8FQ6EUyowL3bilLKaGL8xUQ0pRHESpmBxIttO06yZlvjMUH9/cJwmUNbF
         Q8Lveejm7V3H23ckzS8mIM+IL6X2FJHFHWd7+WyuyB0XV0xud+KrC1/Bzy/8qOFCJE3C
         Os1co6YBJy98qIQgNQU3cEh0SYu44C7OyLNyH3j0MOQODo+sJJ9bhP7zYcZhfs0nG34z
         buh+2xJEOmNUYbvcQ/se6pm/6nk0F+Yqg+QsM7fvzwztHZJ+Uh7kk5/i+gkR+RTMnche
         3Tjg==
X-Gm-Message-State: APjAAAVZxG4dkEJbefnCVTosyS5WUvtZthzxixev8esfOZD+z5Ncbtyb
        6O/9ytkUCYT/u2AO1GGWTA==
X-Google-Smtp-Source: APXvYqxuAI94D4ZoWznBhTIpFgjRYBEo1jNdj2fp3SHrYt2CYiRNXvUFnr7ZCozgtzWpWehQpj+orw==
X-Received: by 2002:a1c:20cf:: with SMTP id g198mr23785016wmg.42.1555369225952;
        Mon, 15 Apr 2019 16:00:25 -0700 (PDT)
Received: from localhost.localdomain ([151.251.250.145])
        by smtp.gmail.com with ESMTPSA id v184sm36426455wma.6.2019.04.15.16.00.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Apr 2019 16:00:25 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, pauld@redhat.com,
        ykaradzhov@vmware.com, jbacik@fb.com, tstoyanov@vmware.com,
        slavomir.kaslev@gmail.com
Subject: [PATCH v3 2/2] trace-cmd: Add --no-filter option to not filter recording processes
Date:   Tue, 16 Apr 2019 02:00:16 +0300
Message-Id: <20190415230016.13932-3-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190415230016.13932-1-kaslevs@vmware.com>
References: <20190415230016.13932-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add --no-filter option which doesn't install filters for the trace-cmd recording
processes pids.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 14 +++++++++++---
 tracecmd/trace-usage.c  |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index dae0396..05a313b 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -86,6 +86,7 @@ static int do_ptrace;
 
 static int filter_task;
 static int filter_pid = -1;
+static bool no_filter = false;
 
 static int local_cpu_count;
 
@@ -1063,6 +1064,9 @@ static void update_task_filter(void)
 	struct buffer_instance *instance;
 	int pid = getpid();
 
+	if (no_filter)
+		return;
+
 	if (filter_task)
 		add_filter_pid(pid, 0);
 
@@ -4377,9 +4381,9 @@ void update_first_instance(struct buffer_instance *instance, int topt)
 }
 
 enum {
-
-	OPT_quiet		= 246,
-	OPT_debug		= 247,
+	OPT_quiet		= 245,
+	OPT_debug		= 246,
+	OPT_no_filter		= 247,
 	OPT_max_graph_depth	= 248,
 	OPT_tsoffset		= 249,
 	OPT_bycomm		= 250,
@@ -4603,6 +4607,7 @@ static void parse_record_options(int argc,
 			{"by-comm", no_argument, NULL, OPT_bycomm},
 			{"ts-offset", required_argument, NULL, OPT_tsoffset},
 			{"max-graph-depth", required_argument, NULL, OPT_max_graph_depth},
+			{"no-filter", no_argument, NULL, OPT_no_filter},
 			{"debug", no_argument, NULL, OPT_debug},
 			{"quiet", no_argument, NULL, OPT_quiet},
 			{"help", no_argument, NULL, '?'},
@@ -4877,6 +4882,9 @@ static void parse_record_options(int argc,
 			if (!ctx->max_graph_depth)
 				die("Could not allocate option");
 			break;
+		case OPT_no_filter:
+			no_filter = true;
+			break;
 		case OPT_debug:
 			debug = 1;
 			break;
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 9ea1906..29a7081 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -56,6 +56,7 @@ static struct usage_help usage_help[] = {
 		"          --func-stack perform a stack trace for function tracer\n"
 		"             (use with caution)\n"
 		"          --max-graph-depth limit function_graph depth\n"
+		"          --no-filter do not set any event filters\n"
 	},
 	{
 		"start",
-- 
2.19.1

