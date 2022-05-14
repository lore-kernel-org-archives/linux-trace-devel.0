Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD85C4332F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiENCzX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiENCzU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D795134A02C
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE82161DFF
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887BAC3411B;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XMV-Ed;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 09/26] trace-cmd: Add kernel-doc to trace_record_agent()
Date:   Fri, 13 May 2022 22:47:39 -0400
Message-Id: <20220514024756.1319681-10-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

I'm getting confused by what exactly is being passed to
trace_record_agent(). Document it, so I can at least be only temporarily
confused.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 5f7ac15dd80a..8b6b27595c96 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -7192,6 +7192,24 @@ void trace_record(int argc, char **argv)
 	exit(0);
 }
 
+/**
+ * trace_record_agent - record command running from the agent
+ * @msg_handle: The handle to communicate with the peer
+ * @cpus: The number of CPUs the agent has to record
+ * @fds: The array of file descriptors for the CPUs
+ * @argc: The number of arguments to pass to the record session
+ * @argv: The arguments to pass to the record session
+ * @use_fifos: True if fifos are used instead of sockets.
+ * @trace_id: The agent's trace_id
+ * @host: Set if this is an IP connection and not a vsocket one
+ *
+ * This is used to enable tracing via the record command just
+ * like trace-cmd record, but it is being done via the agent
+ * and all the data is being transfered to the peer that is
+ * connected on the other end of the sockets.
+ *
+ *  Returns zero on success, negative otherwise.
+ */
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
 		       int argc, char **argv,
-- 
2.35.1

