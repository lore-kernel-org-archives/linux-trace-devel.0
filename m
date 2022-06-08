Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58157C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242373AbiFHPKv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 11:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243245AbiFHPK3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 11:10:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DD1474C01
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 08:01:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B53AB827F0
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 14:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1E7C34116
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 14:52:44 +0000 (UTC)
Date:   Wed, 8 Jun 2022 10:52:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: Use uncompressed size for file size
Message-ID: <20220608105243.7eef6394@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

For tracecmd_read_at() to work, each offset for every record in the file
needs to be unique. To do so, each CPU's file_offset is from the last
CPU's file_offset plus its size. But the size used was the compressed size
and not the uncompressed size.

This had "interesting" effects, where some lookups were failing. It also
caused tracecmd_read_cpu_last() to not return the last event.

Fixes: add83e0c8b511 ("trace-cmd library: Fix tracecmd_read_at()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index fea991ce732c..11c0057589b6 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2699,13 +2699,14 @@ static int init_cpu_zpage(struct tracecmd_input *handle, int cpu)
 	cpu_data->compress.last_chunk = 0;
 
 	cpu_data->file_offset = handle->next_offset;
+	cpu_data->file_size = 0;
 
 	for (i = 0; i < count; i++)
 		cpu_data->file_size += cpu_data->compress.chunks[i].size;
 
 	cpu_data->offset = cpu_data->file_offset;
 	cpu_data->size = cpu_data->file_size;
-	handle->next_offset = (handle->next_offset + cpu_data->size + handle->page_size - 1) &
+	handle->next_offset = (handle->next_offset + cpu_data->file_size + handle->page_size - 1) &
 		~(handle->page_size - 1);
 	return 0;
 }
-- 
2.35.1

