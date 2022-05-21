Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A9AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 21 May 2022 20:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346204AbiEUUrz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 21 May 2022 16:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346221AbiEUUru (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 21 May 2022 16:47:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E1650009
        for <linux-trace-devel@vger.kernel.org>; Sat, 21 May 2022 13:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BDF160ECC
        for <linux-trace-devel@vger.kernel.org>; Sat, 21 May 2022 20:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C05FC385AA
        for <linux-trace-devel@vger.kernel.org>; Sat, 21 May 2022 20:47:47 +0000 (UTC)
Date:   Sat, 21 May 2022 16:47:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd listen: Do not compress for v1 of the msg
 protocol
Message-ID: <20220521164745.54897f01@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The v1 of the msg protocol cannot handle compression being sent across
the network. Do not compress if the listener can only handle the v1 message
protocol.

Fixes: 3f8447b1e2f97 ("trace-cmd library: Add support for compression algorithms")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index f8d2bad70566..c770f698019f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3780,19 +3780,18 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		if (ret)
 			goto error;
 	} else {
+		/*
+		 * V3 can handle compression, but V1 can not.
+		 * Set the file version back to 6.
+		 */
+		ctx->file_version = FILE_VERSION_MIN;
+		ctx->compression = false;
 		network_handle = tracecmd_output_create_fd(msg_handle->fd);
 		if (!network_handle)
 			goto error;
 		if (tracecmd_output_set_version(network_handle, ctx->file_version))
 			goto error;
 
-		if (ctx->compression) {
-			if (tracecmd_output_set_compression(network_handle, ctx->compression))
-				goto error;
-		} else if (ctx->file_version >= FILE_VERSION_COMPRESSION) {
-			tracecmd_output_set_compression(network_handle, "any");
-		}
-
 		if (tracecmd_output_write_headers(network_handle, listed_events))
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
-- 
2.35.1

