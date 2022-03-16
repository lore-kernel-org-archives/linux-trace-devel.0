Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFDAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Mar 2022 15:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbiCPP0a (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Mar 2022 11:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiCPP03 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Mar 2022 11:26:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DF4574B5
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Mar 2022 08:25:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C9D460BCB
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Mar 2022 15:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8086EC340E9;
        Wed, 16 Mar 2022 15:25:13 +0000 (UTC)
Date:   Wed, 16 Mar 2022 11:25:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH] kernelshark: Release input_mutex on not finding record
Message-ID: <20220316112512.55e5b486@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The tepdata_get_latency() function could exit without releasing the
stream->input_mutex, which would cause a lockup later on.

Fixes: 836ce858246b7 ("kernel-shark: Add stream interface for trace-cmd data")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/libkshark-tepdata.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index e9244b0761bb..08aca0989a59 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -793,8 +793,10 @@ static char *tepdata_get_latency(struct kshark_data_stream *stream,
 
 	record = tracecmd_read_at(kshark_get_tep_input(stream), entry->offset, NULL);
 
-	if (!record)
+	if (!record) {
+		pthread_mutex_unlock(&stream->input_mutex);
 		return NULL;
+	}
 
 	trace_seq_reset(&seq);
 	tep_print_event(kshark_get_tep(stream), &seq, record,
-- 
2.35.1

