Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0530C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Apr 2022 04:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345601AbiDLEaL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345876AbiDLEaL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 00:30:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EF332992
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Apr 2022 21:27:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 720A5CE1B8E
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Apr 2022 04:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AC1C385AC;
        Tue, 12 Apr 2022 04:27:51 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ne886-003VeI-Io;
        Tue, 12 Apr 2022 00:27:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/4] trace-cmd record: Replace bool use_tcp with enum type
Date:   Tue, 12 Apr 2022 00:27:38 -0400
Message-Id: <20220412042739.836516-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412042739.836516-1-rostedt@goodmis.org>
References: <20220412042739.836516-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

To allow trace-cmd record to communicate with trace-cmd listen with
vsockets as a connection interface, using a boolean "use_tcp" is not
flexible enough, as now there are three kinds of connections. In
preparation for adding vsockets have trace-cmd record/listen use an enum
instead of a boolean.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index c3e52a48fa07..bff3620dcd8c 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -93,7 +93,7 @@ static bool fork_process;
 /* Max size to let a per cpu file get */
 static int max_kb;
 
-static bool use_tcp;
+static enum port_type port_type;
 
 static int do_ptrace;
 
@@ -3133,12 +3133,12 @@ static int connect_port(const char *host, unsigned int port)
 
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_family = AF_UNSPEC;
-	hints.ai_socktype = use_tcp ? SOCK_STREAM : SOCK_DGRAM;
+	hints.ai_socktype = port_type == USE_TCP ? SOCK_STREAM : SOCK_DGRAM;
 
 	s = getaddrinfo(host, buf, &hints, &results);
 	if (s != 0)
 		die("connecting to %s server %s:%s",
-		    use_tcp ? "TCP" : "UDP", host, buf);
+		    port_type == USE_TCP ? "TCP" : "UDP", host, buf);
 
 	for (rp = results; rp != NULL; rp = rp->ai_next) {
 		sfd = socket(rp->ai_family, rp->ai_socktype,
@@ -3152,7 +3152,7 @@ static int connect_port(const char *host, unsigned int port)
 
 	if (rp == NULL)
 		die("Can not connect to %s server %s:%s",
-		    use_tcp ? "TCP" : "UDP", host, buf);
+		    port_type == USE_TCP ? "TCP" : "UDP", host, buf);
 
 	freeaddrinfo(results);
 
@@ -3518,11 +3518,11 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle,
 	/* TODO, test for ipv4 */
 	if (page_size >= UDP_MAX_PACKET) {
 		warning("page size too big for UDP using TCP in live read");
-		use_tcp = 1;
+		port_type = USE_TCP;
 		msg_handle->flags |= TRACECMD_MSG_FL_USE_TCP;
 	}
 
-	if (use_tcp) {
+	if (port_type == USE_TCP) {
 		/* Send one option */
 		write(msg_handle->fd, "1", 2);
 		/* Size 4 */
@@ -3670,7 +3670,7 @@ again:
 		msg_handle->version = V3_PROTOCOL;
 	}
 
-	if (use_tcp)
+	if (port_type == USE_TCP)
 		msg_handle->flags |= TRACECMD_MSG_FL_USE_TCP;
 
 	if (msg_handle->version == V3_PROTOCOL) {
@@ -6541,7 +6541,7 @@ static void parse_record_options(int argc,
 			if (IS_EXTRACT(ctx))
 				ctx->topt = 1; /* Extract top instance also */
 			else
-				use_tcp = 1;
+				port_type = USE_TCP;
 			break;
 		case 'b':
 			check_instance_die(ctx->instance, "-b");
-- 
2.35.1

