Return-Path: <SRS0=sqOa=W7=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A93C3A5A7
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Sep 2019 11:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FF4622DBF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Sep 2019 11:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729859AbfIDLzJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 07:55:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729356AbfIDLzJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 07:55:09 -0400
Received: from oasis.local.home (bl11-233-114.dsl.telepac.pt [85.244.233.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 798A022CF7;
        Wed,  4 Sep 2019 11:55:07 +0000 (UTC)
Date:   Wed, 4 Sep 2019 07:55:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Cc:     "Uhanov, Kirill" <kirill.uhanov@intel.com>
Subject: [PATCH] trace-cmd: Fix typo in use of file descriptor in
 conditional
Message-ID: <20190904075500.6c296198@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Uhanov, Kirill" <kirill.uhanov@intel.com>

tracecmd_create_buffer_recorder_maxkb() opens a file and uses fd2 as
the variable name to store the descriptor but the proceeding check on
the status of the opened file uses the variable name fd instead.

Signed-off-by: Kirill Uhanov <kirill.uhanov@intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 0bd0657..650b259 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -244,7 +244,7 @@ tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags,
 		goto out;
 
 	fd2 = open(file2, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
-	if (fd < 0)
+	if (fd2 < 0)
 		goto err;
 
 	recorder = tracecmd_create_buffer_recorder_fd2(fd, fd2, cpu, flags, buffer, maxkb);
