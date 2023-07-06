Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E57DEB64DA
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 Jul 2023 01:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbjGFBxz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 21:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbjGFBxz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 21:53:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7D2E57
        for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jul 2023 18:53:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6AE3617F0
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jul 2023 01:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D670BC433C8
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jul 2023 01:53:52 +0000 (UTC)
Date:   Wed, 5 Jul 2023 21:53:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Fix documentation of
 tracefs_trace_pipe_stream() flags
Message-ID: <20230705215351.2fe04ea0@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The flags description in the man page of tracefs_trace_pipe_stream() is
not detailed enough. Not only does it just say "(see )" without saying
"open(2)", it needs a bit more description about how it is used, as it is
not exactly like open(2).

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-stream.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-stream.txt b/Documentation/libtracefs-stream.txt
index 8008be810a33..7f1ff6aca4e6 100644
--- a/Documentation/libtracefs-stream.txt
+++ b/Documentation/libtracefs-stream.txt
@@ -31,8 +31,9 @@ The *tracefs_trace_pipe_stream()* function redirects the stream of trace data to
 file. The "splice" system call is used to moves the data without copying between kernel
 address space and user address space. The _fd_ is the file descriptor of the output file
 and _flags_ is a bit mask of flags to be passed to the open system call of the trace_pipe
-file (see ). If flags contain O_NONBLOCK, then that is also passed to the splice calls
-that may read the file to the output stream file descriptor.
+file (see *open(2)*). If flags contain O_NONBLOCK, then that is also passed to the splice calls
+that may read the file to the output stream file descriptor. Note, O_RDONLY is or'd to
+the _flags_ and only O_NONBLOCK is useful for this parameter.
 
 The *tracefs_trace_pipe_print()* function is similar to *tracefs_trace_pipe_stream()*, but
 the stream of trace data is redirected to stdout.
-- 
2.39.2

