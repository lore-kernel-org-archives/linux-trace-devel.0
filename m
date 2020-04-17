Return-Path: <SRS0=hWvo=6B=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1332C2BB1D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Apr 2020 20:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A08B620656
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Apr 2020 20:39:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="psBoZvB0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgDQUj2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Apr 2020 16:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgDQUj1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Apr 2020 16:39:27 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B5FC061A0C
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Apr 2020 13:39:26 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id u13so4549723wrp.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Apr 2020 13:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=S1nDbRMbHpD5b8Z1thwYGsSmjcd3lWZFSaaaO/P21D8=;
        b=psBoZvB0AYJ5w5+lYUQyTU48ZGTrzZb54TFPRxeov3fH0WQyBzDK+ZiMTE0gC28OkD
         +JmxG8EPnhYhGT94KciRtuP8TCUvsK6UCHb9btDbn0TiKyrNpgiohUXNg6D3ett1oBpS
         tckAdAu6onth4MczcoMvEZixLbpDyDU0kAEzs4TBeUqEkuqlWzi/9pDvWVriVMdvm+qk
         Fab3ejKUoEfs5+rI9voEUrNDTdasTvM4pwFL8KNyCJLAqrcu1UFy3AD4gMGfQ+1Djsl9
         6oP/Kg1O7Nlw/XlUQ6enhob4KtN1GDyeC1KhLhl8u7ZK2957zjD3KXbx0R2DRg4S+EaM
         gwzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=S1nDbRMbHpD5b8Z1thwYGsSmjcd3lWZFSaaaO/P21D8=;
        b=svoRNHAkuamFWtXAkXMqAaQ2NFwkJ9eVVftqIvfwqo82joaX17x4uONCI7lI5yffck
         BieHTqzkxH1feVMU+WH9HVhOF5XhZAmo0boE3Yt84GOqB6XTl3z97XmpmavRhgpBZAFc
         ud9YyS6B/M9pgojEWGmxh9kk5n6ZbxZkvS+EfTIDp9wMO8WjDAeEwizyaKAPzV5FpTxF
         t/rxSNFm9Pltm+9IV86ihy/5Abp7DeVEQZ/c29mdNEXr8nqNRh1uzpjC4olbYIfxXeTh
         c19O8/zGaD7FEl+KdBqd7z4FBFtYeT6PkCe9xsGV021vzWQHi5YX+wEhsSyL9oD/oezq
         wOAg==
X-Gm-Message-State: AGi0PuZQqMCqfN8Qz/kp/myT6SHuV3l+sWgTHGMyvDeHMEjNNfpcKCix
        sHvNPHvOzppQ9Dr8KqBtOZs=
X-Google-Smtp-Source: APiQypKWVX1s/C7IRCcrdZouUjmJ//A8kuJquQbLAkX2pT019WuLvemn9aBKnEris1y67sieZMPTmA==
X-Received: by 2002:adf:fc92:: with SMTP id g18mr5989339wrr.10.1587155965316;
        Fri, 17 Apr 2020 13:39:25 -0700 (PDT)
Received: from debian.lan (host-84-13-17-86.opaltelecom.net. [84.13.17.86])
        by smtp.gmail.com with ESMTPSA id p16sm26913865wro.21.2020.04.17.13.39.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Apr 2020 13:39:24 -0700 (PDT)
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] trace-cmd: Fix build with gcc-10
Date:   Fri, 17 Apr 2020 21:39:14 +0100
Message-Id: <20200417203914.26358-1-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The build fails while building with gcc-10 with the error:
multiple definition of `common_type_field'

Rename the field in trace-hist.c and trace-mem.c to satisfy gcc-10.

Bug-Link: https://bugs.debian.org/957879
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 tracecmd/trace-hist.c | 8 ++++----
 tracecmd/trace-mem.c  | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index c458c25..c4d8b40 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -27,7 +27,7 @@ static int kernel_stack_type;
 
 static int long_size;
 
-static struct tep_format_field *common_type_field;
+static struct tep_format_field *common_type_hist;
 static struct tep_format_field *common_pid_field;
 static struct tep_format_field *sched_wakeup_comm_field;
 static struct tep_format_field *sched_wakeup_new_comm_field;
@@ -568,7 +568,7 @@ process_record(struct tep_handle *pevent, struct tep_record *record)
 	unsigned long long val;
 	int type;
 
-	tep_read_number_field(common_type_field, record->data, &val);
+	tep_read_number_field(common_type_hist, record->data, &val);
 	type = val;
 
 	if (type == function_type)
@@ -956,8 +956,8 @@ static void do_trace_hist(struct tracecmd_input *handle)
 
 	long_size = tracecmd_long_size(handle);
 
-	common_type_field = tep_find_common_field(event, "common_type");
-	if (!common_type_field)
+	common_type_hist = tep_find_common_field(event, "common_type");
+	if (!common_type_hist)
 		die("Can't find a 'type' field?");
 
 	common_pid_field = tep_find_common_field(event, "common_pid");
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index 465b182..76f38fa 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -30,7 +30,7 @@ static int kmem_cache_alloc_type;
 static int kmem_cache_alloc_node_type;
 static int kmem_cache_free_type;
 
-static struct tep_format_field *common_type_field;
+static struct tep_format_field *common_type_mem;
 
 static struct tep_format_field *kmalloc_callsite_field;
 static struct tep_format_field *kmalloc_bytes_req_field;
@@ -369,7 +369,7 @@ process_record(struct tep_handle *pevent, struct tep_record *record)
 	unsigned long long val;
 	int type;
 
-	tep_read_number_field(common_type_field, record->data, &val);
+	tep_read_number_field(common_type_mem, record->data, &val);
 	type = val;
 
 	if (type == kmalloc_type)
@@ -490,8 +490,8 @@ static void do_trace_mem(struct tracecmd_input *handle)
 	ret = tep_data_type(pevent, record);
 	event = tep_find_event(pevent, ret);
 
-	common_type_field = tep_find_common_field(event, "common_type");
-	if (!common_type_field)
+	common_type_mem = tep_find_common_field(event, "common_type");
+	if (!common_type_mem)
 		die("Can't find a 'type' field?");
 
 	update_kmalloc(pevent);
-- 
2.11.0

