Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D63A8C282DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 16:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADA2220663
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 16:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbfDQQ3r (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 12:29:47 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44342 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729512AbfDQQ3r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 12:29:47 -0400
Received: by mail-wr1-f65.google.com with SMTP id w18so2655766wrv.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Apr 2019 09:29:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YOGlgvezcRQmzVWepPSoaUDyeztScaNXBTL2ytHMvT0=;
        b=rGwFfsQVwP0y/imwBz2yRJ2Tr/Y7NEwETRoLlF1wKSRkES7QLsPh64JMoDP6rkaPld
         IIfNDWotl4ETgdxoWf8VPMP0/08Cf+nGmvXmV9qzcysUi7N9xU+6XtITiD/k/xSFyCEZ
         5m/MEZk3/cOeGRf9XM9YP7KMuK3Bk6ewhQA36APSLCtEkMbjJ5KTjlDqj75t5c00NcTV
         mBveSQCUQxba1ZJ3ValJ65goEElpiFWVa3DZ0u7H1Elr4ygSb5iRrB0TmUaIHjjUdxF5
         7WwjEw0hJs/E23NQX2kqfpGah1ErJay8j9A6gfSTCLa70igm57BeHxUDtT6G8/yMPgt5
         CZSw==
X-Gm-Message-State: APjAAAU1KVH5U0m8y1rZiHOYe+l93oh/09nlk0dGSVy6f2KmRn3Xi1+i
        iitFWkNBM9rM8KHW//NkeWm95zWA
X-Google-Smtp-Source: APXvYqzu37HKnEz4EBxaMpkNRqAafWuXPH1qZsxs1BspIzy6R2ry6bVYsceMFSX/6z8U1eGF2xgsbQ==
X-Received: by 2002:adf:fec3:: with SMTP id q3mr58420269wrs.173.1555518585550;
        Wed, 17 Apr 2019 09:29:45 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r196sm4064175wmf.22.2019.04.17.09.29.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Apr 2019 09:29:44 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] trace-cmd: Exit the application if runs in "filter test" mode
Date:   Wed, 17 Apr 2019 19:29:43 +0300
Message-Id: <20190417162943.32601-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Users can use trace-cmd to test specific filters, with the command
  trace-cmd record -F <filter> -T
When trace-cmd runs in this "test filter" mode, after processing the filter
string, the resulting filter will be displayed for each event. It should not run
the actual trace, but exit after all filters are processed. This exit() was
originally performed in the context of libtraceevent, but removed from there as
a library function should not force the application to exit. The logic was
moved to trace-cmd application.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-read.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index a7ffcc5..dbfb3a5 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -83,6 +83,7 @@ static int instances;
 
 static int *filter_cpus;
 static int nr_filter_cpus;
+static int test_filters_mode;
 
 static int show_wakeup;
 static int wakeup_id;
@@ -489,6 +490,7 @@ static void process_filters(struct handle_list *handles)
 	struct filter_str *filter;
 	struct tep_handle *pevent;
 	char errstr[200];
+	int filters = 0;
 	int ret;
 
 	pevent = tracecmd_get_pevent(handles->handle);
@@ -522,10 +524,12 @@ static void process_filters(struct handle_list *handles)
 			*filter_next = event_filter;
 			filter_next = &event_filter->next;
 		}
-
+		filters++;
 		free(filter->filter);
 		free(filter);
 	}
+	if (filters && test_filters_mode)
+		exit(0);
 }
 
 static void init_wakeup(struct tracecmd_input *handle)
@@ -1426,7 +1430,6 @@ void trace_report (int argc, char **argv)
 	int latency_format = 0;
 	int show_events = 0;
 	int print_events = 0;
-	int test_filters = 0;
 	int nanosec = 0;
 	int no_date = 0;
 	int global = 0;
@@ -1500,7 +1503,7 @@ void trace_report (int argc, char **argv)
 			add_hook(optarg);
 			break;
 		case 'T':
-			test_filters = 1;
+			test_filters_mode = 1;
 			break;
 		case 'f':
 			show_funcs = 1;
@@ -1692,7 +1695,7 @@ void trace_report (int argc, char **argv)
 		if (raw)
 			tep_set_print_raw(pevent, 1);
 
-		if (test_filters)
+		if (test_filters_mode)
 			tep_set_test_filters(pevent, 1);
 
 		if (functions)
-- 
2.20.1

