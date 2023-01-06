Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A657C3DA7A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Jan 2023 18:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbjAFSje (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Jan 2023 13:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjAFSjd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Jan 2023 13:39:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9237D9FE
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 10:39:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A31D761EC3
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 18:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115DEC433F2;
        Fri,  6 Jan 2023 18:39:32 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pDrcp-0003Kv-08;
        Fri, 06 Jan 2023 13:39:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 04/10] trace-cmd stream: Do one last flush when finished
Date:   Fri,  6 Jan 2023 13:39:24 -0500
Message-Id: <20230106183930.12565-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230106183930.12565-1-rostedt@goodmis.org>
References: <20230106183930.12565-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When trace-cmd stream is finished, the trace_or_sleep() will exit before
waiting for the pipes to flush. Call trace_stream_read() one more time, and
with indefinite blocking, as the pipes should finish everything and then
close (which will stop the polling).

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a03d334a65d5..83ae8e60d7cb 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -7019,6 +7019,9 @@ static void record_trace(int argc, char **argv,
 		}
 		while (!finished && wait_indefinitely)
 			trace_or_sleep(type, pwait);
+		/* Streams need to be flushed one more time */
+		if (type & TRACE_TYPE_STREAM)
+			trace_stream_read(pids, recorder_threads, NULL);
 	}
 
 	tell_guests_to_stop(ctx);
-- 
2.35.1

