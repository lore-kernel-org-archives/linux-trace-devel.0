Return-Path: <SRS0=gJTR=AT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D82C433DF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jul 2020 20:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 372A82078A
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jul 2020 20:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgGHUaU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jul 2020 16:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgGHUaT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jul 2020 16:30:19 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B55620775;
        Wed,  8 Jul 2020 20:30:18 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jtGht-004NNa-4v; Wed, 08 Jul 2020 16:30:17 -0400
Message-ID: <20200708203017.038156451@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 08 Jul 2020 16:28:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 2/5] tools lib traceveent: Fix kbuffer_start_of_data() to return the first
 record
References: <20200708202850.764168067@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

The first record in a ring buffer page may not allways be at the
beginning of the page. There could be time-extends injected before it.
In this case kbuffer_start_of_data() will not return the first record,
as expected. Additional field "start" is added in kbuffer struct, to hold
the offset of the first record from the page and kbuffer_start_of_data()
is modified to use it.

Link: https://lore.kernel.org/linux-trace-devel/20200706154714.27566-1-tz.stoyanov@gmail.com

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
[ Finished the patch from Steven ]
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/kbuffer-parse.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/lib/traceevent/kbuffer-parse.c b/lib/traceevent/kbuffer-parse.c
index 2c5f00a9e786..844db976b38c 100644
--- a/lib/traceevent/kbuffer-parse.c
+++ b/lib/traceevent/kbuffer-parse.c
@@ -35,6 +35,7 @@ enum {
  * @next		- offset from @data to the start of next event
  * @size		- The size of data on @data
  * @start		- The offset from @subbuffer where @data lives
+ * @first		- The offset from @subbuffer where the first non time stamp event lives
  *
  * @read_4		- Function to read 4 raw bytes (may swap)
  * @read_8		- Function to read 8 raw bytes (may swap)
@@ -51,6 +52,7 @@ struct kbuffer {
 	unsigned int		next;
 	unsigned int		size;
 	unsigned int		start;
+	unsigned int		first;
 
 	unsigned int (*read_4)(void *ptr);
 	unsigned long long (*read_8)(void *ptr);
@@ -546,6 +548,9 @@ int kbuffer_load_subbuffer(struct kbuffer *kbuf, void *subbuffer)
 
 	next_event(kbuf);
 
+	/* save the first record from the page */
+	kbuf->first = kbuf->curr;
+
 	return 0;
 }
 
@@ -755,7 +760,7 @@ void kbuffer_set_old_format(struct kbuffer *kbuf)
  */
 int kbuffer_start_of_data(struct kbuffer *kbuf)
 {
-	return kbuf->start;
+	return kbuf->first + kbuf->start;
 }
 
 /**
-- 
2.26.2


