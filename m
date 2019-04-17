Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E296DC282DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 18:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE16420693
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 18:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732321AbfDQScH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 14:32:07 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51847 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728373AbfDQScH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 14:32:07 -0400
Received: by mail-wm1-f67.google.com with SMTP id 4so4554395wmf.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Apr 2019 11:32:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PV7gT/51t6XOhZSwVMch2TpdXH9i292jnGq/XboOJrk=;
        b=FK7l7Vvfsf+qz/JIaaFzeKKGSNhq7PetI4JFVhStVcJLoziTOVlCfXGV+7y4LRWHsk
         Gh0mV6Q41RYV8VhBV9oqCedOgrL3gBQdsh2UANGyhP2fdoOCAV+K30vSSwHOCp9pFl3p
         HYkHSGlNpaTgdDzQC/hIC85V93Dao589SXS/Fb+c8Xf0ZN1JMC7mgLFW6fov2GgOBvbz
         CqeQlwcrPC5BjDYRA+G2va/k7BAt0InGi2id76N66iiwGs9Buo53F1pahegpkfeM6y+k
         dm/iCSBu6FIhHHrnHUynaBCQZLcjuodCZtuOHLpSTKZVIOQL7q0O089jRCohaDCZDK+j
         B/1Q==
X-Gm-Message-State: APjAAAVfyZvOsHswzy3vwprtmQixQHCQK4yrmfXiNBZp0B7vcwNeC2wu
        yuPob4IG3lymQjRATCpRoaJnM0YNSQ==
X-Google-Smtp-Source: APXvYqxhI5o54SzuDivOviuZX5fxLluPfPah7U9XQDSrNpf5JYLvZKYXutJY3SK3JDDntgUgFWIdig==
X-Received: by 2002:a1c:bd8b:: with SMTP id n133mr773813wmf.73.1555525925450;
        Wed, 17 Apr 2019 11:32:05 -0700 (PDT)
Received: from localhost.localdomain ([151.251.252.188])
        by smtp.gmail.com with ESMTPSA id 192sm6090506wme.13.2019.04.17.11.32.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 11:32:04 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/1] trace-cmd: Add --no-filter option to not filter out recording processes
Date:   Wed, 17 Apr 2019 21:31:57 +0300
Message-Id: <20190417183157.8776-2-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190417183157.8776-1-kaslevs@vmware.com>
References: <20190417183157.8776-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add trace-cmd --no-filter option that disables filtering out of trace-cmd
recording processes from the trace.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 Documentation/trace-cmd-record.1.txt |  5 +++++
 tracecmd/trace-record.c              | 14 +++++++++++---
 tracecmd/trace-usage.c               |  1 +
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
index 68afa16..26a8299 100644
--- a/Documentation/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd-record.1.txt
@@ -83,6 +83,11 @@ OPTIONS
 
     The above are usually safe to use to compare fields.
 
+*--no-filter*::
+    Do not filter out the trace-cmd threads. By default, the threads are
+    filtered out to not be traced by events. This option will have the trace-cmd
+    threads also be traced.
+
 *-R* 'trigger'::
     Specify a trigger for the previous event. This must come after a *-e*. 
     This will add a given trigger to the given event. To only enable the trigger
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index d5c66ab..4523128 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -86,6 +86,7 @@ static int do_ptrace;
 
 static int filter_task;
 static int filter_pid = -1;
+static bool no_filter = false;
 
 static int local_cpu_count;
 
@@ -1065,6 +1066,9 @@ static void update_task_filter(void)
 	struct buffer_instance *instance;
 	int pid = getpid();
 
+	if (no_filter)
+		return;
+
 	if (filter_task)
 		add_filter_pid(pid, 0);
 
@@ -4379,9 +4383,9 @@ void update_first_instance(struct buffer_instance *instance, int topt)
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
@@ -4605,6 +4609,7 @@ static void parse_record_options(int argc,
 			{"by-comm", no_argument, NULL, OPT_bycomm},
 			{"ts-offset", required_argument, NULL, OPT_tsoffset},
 			{"max-graph-depth", required_argument, NULL, OPT_max_graph_depth},
+			{"no-filter", no_argument, NULL, OPT_no_filter},
 			{"debug", no_argument, NULL, OPT_debug},
 			{"quiet", no_argument, NULL, OPT_quiet},
 			{"help", no_argument, NULL, '?'},
@@ -4879,6 +4884,9 @@ static void parse_record_options(int argc,
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
index 9ea1906..d2a1089 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -56,6 +56,7 @@ static struct usage_help usage_help[] = {
 		"          --func-stack perform a stack trace for function tracer\n"
 		"             (use with caution)\n"
 		"          --max-graph-depth limit function_graph depth\n"
+		"          --no-filter include trace-cmd threads in the trace\n"
 	},
 	{
 		"start",
-- 
2.19.1

