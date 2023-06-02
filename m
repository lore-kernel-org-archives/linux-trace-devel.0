Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127B0C77B7A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jun 2023 07:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbjFBH6V (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jun 2023 03:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbjFBH6V (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jun 2023 03:58:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC32123
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jun 2023 00:58:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 471D960E9B
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jun 2023 07:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC57CC433EF;
        Fri,  2 Jun 2023 07:58:17 +0000 (UTC)
Date:   Fri, 2 Jun 2023 03:58:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] libtracecmd: Free buf_from in error path of
 tracecmd_compress_copy_from()
Message-ID: <20230602035815.43904076@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The failure of allocating buf_to returns without freeing buf_from.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217127
Reported-by: Markus Elfring <Markus.Elfring@web.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-compress.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index ca6e03b88e69..e550dbd4b0d5 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -696,8 +696,10 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
 		return -1;
 
 	buf_to = malloc(csize);
-	if (!buf_to)
+	if (!buf_to) {
+		free(buf_from);
 		return -1;
+	}
 
 	/* save the initial offset and write 0 as initial chunk count */
 	offset = lseek(handle->fd, 0, SEEK_CUR);
-- 
2.39.2

