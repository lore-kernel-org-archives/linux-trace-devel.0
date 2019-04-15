Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7309AC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 10:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B7C220684
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 10:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfDOKnz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 06:43:55 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34284 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfDOKny (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 06:43:54 -0400
Received: by mail-wr1-f65.google.com with SMTP id p10so21295038wrq.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 03:43:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m2R1bA4NIpMvffH+6p9P1AxosRvGBmNGukHmKUyzQxc=;
        b=NNqp2AQ+CfVToqvTC2WSYaQqEfE2bw/LfxntqLx6/ysjFz7AUcTF3jAVT4TVVfj4ZM
         HUTYy3mJkBdfBNJZtlNQHK8ECjeYDbZcXzCWTBsBeVNuxUvd2kSGRzmXeuDRl4EwFgnv
         5D/uN7VbRgDMbiouMxNb9TxtbC/lIMQQX90a7QOy8zdrHESamjroi1zYdP7kJCGMpx8V
         VzaymYf4kRvQ/lkN8i6b8ykHGBE8qCAla7pXJhnr5T4GGbeDaKIZyf0PXSNLcDqnvTgT
         8c1STJOQXrw1FLi2tItAiur9MAbaTwdrcjUCpBm1ISaOdMqQFUfFaErQmluzayc4ICbu
         3pxg==
X-Gm-Message-State: APjAAAXoJMIxX5zw3TYEZm6TDbCmyOHQhKCtmfV98dH2RtYAKxgZoDNJ
        P6lvsrdd4v+QTei/kHis6Q==
X-Google-Smtp-Source: APXvYqwgouex8ryfwOTfpYpA5fSZtb7NarcUlDTA2dOKuAMGXxGmacND0yJCKaxi4q1U6XT3Obpw/w==
X-Received: by 2002:adf:f78c:: with SMTP id q12mr26315242wrp.172.1555325033057;
        Mon, 15 Apr 2019 03:43:53 -0700 (PDT)
Received: from localhost.localdomain ([151.251.250.145])
        by smtp.gmail.com with ESMTPSA id y17sm60463430wrh.60.2019.04.15.03.43.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Apr 2019 03:43:52 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, pauld@redhat.com,
        ykaradzhov@vmware.com, jbacik@fb.com, tstoyanov@vmware.com,
        slavomir.kaslev@gmail.com
Subject: [PATCH 2/2] trace-cmd: Add --no-filter option to not filter recording processes
Date:   Mon, 15 Apr 2019 13:43:43 +0300
Message-Id: <20190415104343.31113-3-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190415104343.31113-1-kaslevs@vmware.com>
References: <20190415104343.31113-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add --no-filter option which doesn't install filters for the trace-cmd recording
processes pids.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-record.c | 14 +++++++++++---
 tracecmd/trace-usage.c  |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 0959cb8..f99dda6 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -86,6 +86,7 @@ static int do_ptrace;
 
 static int filter_task;
 static int filter_pid = -1;
+static bool no_filter = false;
 
 static int local_cpu_count;
 
@@ -1058,6 +1059,9 @@ static void update_task_filter(void)
 	struct buffer_instance *instance;
 	int pid = getpid();
 
+	if (no_filter)
+		return;
+
 	if (filter_task)
 		add_filter_pid(pid, 0);
 
@@ -4372,9 +4376,9 @@ void update_first_instance(struct buffer_instance *instance, int topt)
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
@@ -4598,6 +4602,7 @@ static void parse_record_options(int argc,
 			{"by-comm", no_argument, NULL, OPT_bycomm},
 			{"ts-offset", required_argument, NULL, OPT_tsoffset},
 			{"max-graph-depth", required_argument, NULL, OPT_max_graph_depth},
+			{"no-filter", no_argument, NULL, OPT_no_filter},
 			{"debug", no_argument, NULL, OPT_debug},
 			{"quiet", no_argument, NULL, OPT_quiet},
 			{"help", no_argument, NULL, '?'},
@@ -4872,6 +4877,9 @@ static void parse_record_options(int argc,
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

