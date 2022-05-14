Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA99C4332F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiENCzl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiENCzU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B93B34A71F
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4635F61BF7
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC98EC341C4;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XMl-HA;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 13/26] trace-cmd agent: Add trace_tsync_as_guest() helper function
Date:   Fri, 13 May 2022 22:47:43 -0400
Message-Id: <20220514024756.1319681-14-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In preparation to implementing a agent proxy, where the record side will
need to synchronize as the guest, pull out the code that does so into its
own function. It will later be placed in a separate file.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-agent.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 7ee5fc8352c6..d226833b4fd0 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -144,6 +144,23 @@ static int wait_for_connection(int fd)
 	return sd;
 }
 
+static struct tracecmd_time_sync *
+trace_tsync_as_guest(int fd, const char *tsync_proto, const char *clock,
+	       unsigned int remote_id, unsigned int local_id)
+{
+	struct tracecmd_time_sync *tsync;
+
+	if (fd < 0)
+		return NULL;
+
+	tsync = tracecmd_tsync_with_host(fd, tsync_proto, clock,
+					 remote_id, local_id);
+	if (!tsync)
+		warning("Failed to negotiate timestamps synchronization with the host");
+
+	return tsync;
+}
+
 static void agent_handle(int sd, int nr_cpus, int page_size, const char *network)
 {
 	struct tracecmd_tsync_protos *tsync_protos = NULL;
@@ -218,15 +235,10 @@ static void agent_handle(int sd, int nr_cpus, int page_size, const char *network
 
 	if (tsync_proto) {
 		fd = wait_for_connection(fd);
-		if (fd >= 0)
-			tsync = tracecmd_tsync_with_host(fd, tsync_proto,
-							 get_clock(argc, argv),
-							 remote_id, local_id);
-		if (!tsync) {
-			warning("Failed to negotiate timestamps synchronization with the host");
-			if (fd >= 0)
-				close(fd);
-		}
+		tsync = trace_tsync_as_guest(fd, tsync_proto, get_clock(argc, argv),
+					     remote_id, local_id);
+		if (!tsync)
+			close(fd);
 	}
 
 	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv,
-- 
2.35.1

