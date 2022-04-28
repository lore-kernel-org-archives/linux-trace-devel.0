Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 810D7C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Apr 2022 23:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353279AbiD1XdN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Apr 2022 19:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbiD1XdM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Apr 2022 19:33:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CD1BCB71
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Apr 2022 16:29:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6874CB82C97
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Apr 2022 23:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDACC385A9
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Apr 2022 23:29:53 +0000 (UTC)
Date:   Thu, 28 Apr 2022 19:29:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Add kernel-doc to trace_record_agent()
Message-ID: <20220428192951.2c5e21fd@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
index a4a0d63d907d..64b966c89f11 100644
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

