Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304D0C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 12:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 045732064A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 12:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfDOM61 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 08:58:27 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54449 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfDOM61 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 08:58:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id c1so20514502wml.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 05:58:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CVhNQc4/aqiMXKgfvwN5H+ZHOyxY6an9oXLJ8zhD3gA=;
        b=sH90y6+y1fk6Ci4PqS2YS+T/pT0+1GQMt8SWe7aIDsHHbrgEVyjzI2W6juaelo3pTd
         JrApHeV59TKTnlNuP+vCQtGIveFVykWwC+EeaqxPe/CxSiamxSOs1olQKsd1crhFoFyX
         SSbhFSbYnSJ+0a4WHWRfsy5fFlA4ZLAEoV7DzAeN29i1HJ6KjOsoCrvBiuW6zAJ4f/Vq
         9WPeNcus+Nx7BIAu1I0zyu+z1ci7lEs+JPQZI1UC97rKBz2eg3Xj68qWfXj+0sVKrMRR
         qgKzE9zMbRcO+qJdrVCWGN8hRA/o56ZYqTRW1zcffNgpFrvPR/C8Si8ly0kxBGJPZUhl
         xJmw==
X-Gm-Message-State: APjAAAWEkssQg/a5St+VQCJ+5dGDizQsL0TsWUbeiNZ44J+KtlGKiT9R
        879pOg7UP2f04HM1HyT0cT8=
X-Google-Smtp-Source: APXvYqw5ECDcCYjYaHpUZnEV59h5oNWUrhuS26bXyuhOIg3/0CsdHAxiegnoSZEn9LEXGR4qgPT++A==
X-Received: by 2002:a1c:c910:: with SMTP id f16mr21176616wmb.47.1555333105753;
        Mon, 15 Apr 2019 05:58:25 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d3sm37292462wmf.46.2019.04.15.05.58.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Apr 2019 05:58:25 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: exit the application if runs in "filter test" mode
Date:   Mon, 15 Apr 2019 15:58:23 +0300
Message-Id: <20190415125823.4011-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190415125823.4011-1-tstoyanov@vmware.com>
References: <20190415125823.4011-1-tstoyanov@vmware.com>
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
index fe116cc..3f808c8 100644
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
@@ -1427,7 +1431,6 @@ void trace_report (int argc, char **argv)
 	int latency_format = 0;
 	int show_events = 0;
 	int print_events = 0;
-	int test_filters = 0;
 	int nanosec = 0;
 	int no_date = 0;
 	int global = 0;
@@ -1501,7 +1504,7 @@ void trace_report (int argc, char **argv)
 			add_hook(optarg);
 			break;
 		case 'T':
-			test_filters = 1;
+			test_filters_mode = 1;
 			break;
 		case 'f':
 			show_funcs = 1;
@@ -1693,7 +1696,7 @@ void trace_report (int argc, char **argv)
 		if (raw)
 			tep_set_print_raw(pevent, 1);
 
-		if (test_filters)
+		if (test_filters_mode)
 			tep_set_test_filters(pevent, 1);
 
 		if (functions)
-- 
2.20.1

