Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC2AC4743C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 02:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB4286124B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 02:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhFVCUc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Jun 2021 22:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230338AbhFVCUb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Jun 2021 22:20:31 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87311611C1;
        Tue, 22 Jun 2021 02:18:16 +0000 (UTC)
Date:   Mon, 21 Jun 2021 22:18:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: [PATCH] trace-cmd: Initialize option list earlier in
 create_file_fd()
Message-ID: <20210621221814.200894db@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The error paths of create_file_fd() after the handle is allocated, jumps
to the out_free label. This will call tracecmd_output_close(), which will
clean up the allocated tracecmd_output handle. This includes the options
list. But there's two error paths that will jump to out_free before the
options list is initialized. If an error occurs in one of these two
locations, then walking the option list will cause a segfault.

Initialize the option list immediately after the allocation of the handle
and before any of the error paths that jump to out_free.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index b3d0fe7e..78a25350 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -938,6 +938,8 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 		return NULL;
 	memset(handle, 0, sizeof(*handle));
 
+	list_head_init(&handle->options);
+
 	handle->fd = fd;
 	if (tracing_dir) {
 		handle->tracing_dir = strdup(tracing_dir);
@@ -950,8 +952,6 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 	if (select_file_version(handle, ihandle))
 		goto out_free;
 
-	list_head_init(&handle->options);
-
 	buf[0] = 23;
 	buf[1] = 8;
 	buf[2] = 68;
-- 
2.29.2

