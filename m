Return-Path: <SRS0=gVBF=RY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCE0C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 23:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8608421917
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 23:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfCUXla (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 19:41:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbfCUXla (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 19:41:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52D5D21900;
        Thu, 21 Mar 2019 23:41:29 +0000 (UTC)
Date:   Thu, 21 Mar 2019 19:41:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH] trace-cmd: Have tracecmd_msg_data_send() return zero on
 zero size
Message-ID: <20190321194127.4ac47d99@gandalf.local.home>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If tracecmd_msg_data_send() is passed a size of zero, the loop is not
entered, nothing is sent, but the ret variable is not initialized and
garbage can be sent out. The option code can call this with a size of zero,
which can cause an error report.

Just don't do anything in this case, and return a success.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-msg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index 51d0ac8b..382bd766 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -590,6 +590,10 @@ int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
 	int ret;
 	int count = 0;
 
+	/* Don't bother doing anything if there's nothing to do */
+	if (!size)
+		return 0;
+
 	tracecmd_msg_init(MSG_SEND_DATA, &msg);
 
 	msg.buf = malloc(MSG_MAX_DATA_LEN);
-- 
2.20.1

