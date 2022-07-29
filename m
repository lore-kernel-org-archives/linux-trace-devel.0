Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF8CC00144
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Jul 2022 20:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbiG2UtC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Jul 2022 16:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiG2UtA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Jul 2022 16:49:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9186AA14
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jul 2022 13:49:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3C58ACE2B5C
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jul 2022 20:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8C7C433C1
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jul 2022 20:48:56 +0000 (UTC)
Date:   Fri, 29 Jul 2022 16:48:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd libs: Initialize msg to NULL
 tracecmd_msg_read_data()
Message-ID: <20220729164850.460886bb@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If there are no parameters passed to the guest agent, then the loop
inside tracecmd_msg_read_data() will not iterate and the msg variable
will be accessed (freed) without being initailized causing a possible
SEGFAULT.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-msg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 9c26401a..342d03e4 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -980,6 +980,8 @@ int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 	ssize_t s;
 	int ret;
 
+	memset(&msg, 0, sizeof(msg));
+
 	while (!tracecmd_msg_done(msg_handle)) {
 		n = read_msg_data(msg_handle, &msg);
 		if (n <= 0)
-- 
2.35.1

