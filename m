Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 992DFC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Mar 2022 17:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241618AbiCNRDY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 13:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241639AbiCNRDR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 13:03:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F0B12AE6
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 10:02:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 569FEB80E81
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 17:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE75CC340EE
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 17:02:02 +0000 (UTC)
Date:   Mon, 14 Mar 2022 13:02:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: Fix off by one in
 tracecmd_read_cpu_first()
Message-ID: <20220314130201.6356821a@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The check in tracecmd_read_cpu_first() checks:

  if (cpus > handle->cpus)

When that should be >=, as cpus is the number of CPUs in the array, and
not the last CPU.

This wasn't noticed in tests because it only warns and does not crash.

Fixes: 3869d1529a99 ("trace-cmd library: Do not read CPU greater than CPUs registered")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 313534d09e86..643dd807c575 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2028,7 +2028,7 @@ tracecmd_read_cpu_first(struct tracecmd_input *handle, int cpu)
 	unsigned long long page_offset;
 	int ret;
 
-	if (cpu > handle->cpus)
+	if (cpu >= handle->cpus)
 		return NULL;
 
 	page_offset = calc_page_offset(handle, handle->cpu_data[cpu].file_offset);
-- 
2.35.1

