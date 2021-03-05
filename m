Return-Path: <SRS0=uRrw=ID=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57DE3C433E9
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 22:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D951650A5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 22:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhCEWsN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 17:48:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhCEWrv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 17:47:51 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DD2D64F4A
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Mar 2021 22:47:51 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lIJEc-001zxr-AG
        for linux-trace-devel@vger.kernel.org; Fri, 05 Mar 2021 17:47:50 -0500
Message-ID: <20210305224750.200301765@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 05 Mar 2021 17:47:20 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd record: Allow tracecmd_write_cpu_data() be called multiple
 times
References: <20210305224719.784797597@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When trace-cmd record -B foo is executed, buffers for instances are recorded
in the trace.dat file by calling tracecmd_write_cpu_data() multiple times
(for toplevel and once for each instance). But currently the verification
code fails on the second call as it expects the state to be the previous
state. Allow this call to happen when the state is already set to
TRACECMD_FILE_CPU_FLYRECORD.

Fixes: 3717bb92a ("trace-cmd: Add validation for reading and writing trace.dat files")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-output.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index c8f8a106c295..a2d4a16e3c3d 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1339,7 +1339,9 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 	int ret;
 	int i;
 
-	ret = check_out_state(handle, TRACECMD_FILE_CPU_FLYRECORD);
+	/* This can be called multiple times (when recording instances) */
+	ret = handle->file_state == TRACECMD_FILE_CPU_FLYRECORD ? 0 :
+		check_out_state(handle, TRACECMD_FILE_CPU_FLYRECORD);
 	if (ret < 0) {
 		warning("Cannot write trace data into the file, unexpected state 0x%X",
 			handle->file_state);
-- 
2.30.0


