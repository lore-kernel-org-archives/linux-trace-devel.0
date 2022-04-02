Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E06FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat,  2 Apr 2022 01:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbiDBBQ6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Apr 2022 21:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbiDBBQ5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Apr 2022 21:16:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0851066D9
        for <linux-trace-devel@vger.kernel.org>; Fri,  1 Apr 2022 18:15:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95F4061C24
        for <linux-trace-devel@vger.kernel.org>; Sat,  2 Apr 2022 01:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAC5C340EC
        for <linux-trace-devel@vger.kernel.org>; Sat,  2 Apr 2022 01:15:05 +0000 (UTC)
Date:   Fri, 1 Apr 2022 21:15:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Fix trace-cmd convert to handle offset update
Message-ID: <20220401211503.73457413@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

With changing the cpu_data[]->file_offset to be unique per CPU, the
convert code had a path that was still relying on it being zero.
Specifically, when read_zpage is false. This would decompress the data
into a temp file, and the offset would be from that temp file. Thus, using
the unique file_offset would cause it to index farther than the size of
the file and crash. Instead, subtract the cpu_data[].file_offset from the
offset used in the temp file.

Fixes: add83e0c8b51 ("trace-cmd library: Fix tracecmd_read_at()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index d35006294032..18bb4cf984da 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1442,9 +1442,10 @@ static void *allocate_page_map(struct tracecmd_input *handle,
 		map_size -= map_offset + map_size -
 			(cpu_data->file_offset + cpu_data->file_size);
 
-	if (cpu_data->compress.fd >= 0)
+	if (cpu_data->compress.fd >= 0) {
+		map_offset -= cpu_data->file_offset;
 		fd = cpu_data->compress.fd;
-	else
+	} else
 		fd = handle->fd;
  again:
 	page_map->size = map_size;
-- 
2.35.1

