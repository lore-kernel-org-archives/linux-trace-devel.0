Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 547F0C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Apr 2022 02:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239038AbiDFCtm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Apr 2022 22:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457271AbiDEQDC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Apr 2022 12:03:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C161FA77
        for <linux-trace-devel@vger.kernel.org>; Tue,  5 Apr 2022 08:36:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76468B81E54
        for <linux-trace-devel@vger.kernel.org>; Tue,  5 Apr 2022 15:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01427C385A1
        for <linux-trace-devel@vger.kernel.org>; Tue,  5 Apr 2022 15:36:51 +0000 (UTC)
Date:   Tue, 5 Apr 2022 11:36:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: When the compression algorithm is none
 do no compression
Message-ID: <20220405113650.188bf8bf@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If there is no compression algorithm, do not even bother trying to do
compression. Just turn it off. This is not a bug, it is more of an
optimization.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 425c6077d88e..90bfa0f32984 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4278,7 +4278,10 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 		if (!zver)
 			goto failed_read;
 
-		if (strcmp(zname, "none")) {
+		if (strcmp(zname, "none") == 0) {
+			handle->read_zpage = false;
+			handle->flags &= ~TRACECMD_FL_COMPRESSION;
+		} else {
 			handle->compress = tracecmd_compress_alloc(zname, zver,
 								   handle->fd,
 								   handle->pevent, NULL);
-- 
2.35.1

