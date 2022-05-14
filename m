Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F0EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiENCzg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiENCzW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751A534A969
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D093B83264
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64D5C341CF;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XNP-P3;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 23/26] trace-cmd agent proxy: Add the remote guest cid to guest list
Date:   Fri, 13 May 2022 22:47:53 -0400
Message-Id: <20220514024756.1319681-24-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When the trace-cmd agent is passed the proxy flag "-P" with the guest
CID that it can talk to, add it to the list of guests, as it should be
able to find all the host tasks that control the guest.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-agent.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 360079297b88..4430cb5506ff 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -22,6 +22,8 @@
 #include "trace-local.h"
 #include "trace-msg.h"
 
+#define GUEST_NAME	"::GUEST::"
+
 #define dprint(fmt, ...)	tracecmd_debug(fmt, ##__VA_ARGS__)
 
 static void make_vsocks(int nr, int *fds, unsigned int *ports)
@@ -377,6 +379,7 @@ enum {
 
 void trace_agent(int argc, char **argv)
 {
+	struct trace_guest *guest;
 	bool do_daemon = false;
 	unsigned int port = TRACE_AGENT_DEFAULT_PORT;
 	const char *network = NULL;
@@ -419,8 +422,11 @@ void trace_agent(int argc, char **argv)
 			break;
 		case 'P':
 			proxy_id = atoi(optarg);
-			if (network)
-				die("-P cannot be used with -N");
+
+			guest = trace_get_guest(proxy_id, GUEST_NAME);
+			if (!guest)
+				die("Failed to allocate guest instance");
+
 			break;
 		case DO_DEBUG:
 			tracecmd_set_debug(true);
-- 
2.35.1

