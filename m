Return-Path: <SRS0=uRrw=ID=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD4EAC43331
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 23:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADFF4650A3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 23:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhCEW7w (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 17:59:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhCEW7s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 17:59:48 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74E8D64FC9
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Mar 2021 22:59:48 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lIJQB-002091-GZ
        for linux-trace-devel@vger.kernel.org; Fri, 05 Mar 2021 17:59:47 -0500
Message-ID: <20210305225947.378797358@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 05 Mar 2021 17:52:24 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/9 v2] trace-cmd restore: Fix to add saved cmdlines after calling
 tracecmd_create_init_file_override()
References: <20210305225223.794554327@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The saving of command lines was moved out of the create_file() logic to
capture them after the tracing has finished. But this broke trace-cmd
restore as it expected them to be saved by the
tracecmd_create_init_file_override() function.

Link: https://lore.kernel.org/linux-trace-devel/20210301143856.788923617@goodmis.org

Fixes: 1eea02a4b ("trace-cmd: Write saved cmdlines in the trace file at the end of the trace.")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-restore.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index 98e757337a03..13f803053582 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -94,6 +94,8 @@ void trace_restore (int argc, char **argv)
 							    kallsyms);
 		if (!handle)
 			die("Unabled to create output file %s", output);
+		if (tracecmd_write_cmdlines(handle) < 0)
+			die("Failed to write command lines");
 		tracecmd_output_close(handle);
 		exit(0);
 	}
-- 
2.30.0


