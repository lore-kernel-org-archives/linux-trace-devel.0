Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F06BC43217
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 18:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbiDQSgg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 17 Apr 2022 14:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbiDQSgf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 17 Apr 2022 14:36:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629611C91B
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 11:33:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F9B5B80D88
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 18:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C7EC385AB;
        Sun, 17 Apr 2022 18:33:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ng9id-004NGW-Nq;
        Sun, 17 Apr 2022 14:33:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 3/5] trace-cmd record: Replace bool use_tcp with enum type
Date:   Sun, 17 Apr 2022 14:33:52 -0400
Message-Id: <20220417183354.1042657-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220417183354.1042657-1-rostedt@goodmis.org>
References: <20220417183354.1042657-1-rostedt@goodmis.org>
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
index ac6fb7e98892..022a024c665b 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -90,7 +90,7 @@ static bool fork_process;
 /* Max size to let a per cpu file get */
 static int max_kb;
 
-static bool use_tcp;
+static enum port_type port_type;
 
 static int do_ptrace;
 
@@ -3130,12 +3130,12 @@ static int connect_port(const char *host, unsigned int port)
 
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
@@ -3149,7 +3149,7 @@ static int connect_port(const char *host, unsigned int port)
 
 	if (rp == NULL)
 		die("Can not connect to %s server %s:%s",
-		    use_tcp ? "TCP" : "UDP", host, buf);
+		    port_type == USE_TCP ? "TCP" : "UDP", host, buf);
 
 	freeaddrinfo(results);
 
@@ -3439,11 +3439,11 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle,
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
@@ -3591,7 +3591,7 @@ again:
 		msg_handle->version = V3_PROTOCOL;
 	}
 
-	if (use_tcp)
+	if (port_type == USE_TCP)
 		msg_handle->flags |= TRACECMD_MSG_FL_USE_TCP;
 
 	if (msg_handle->version == V3_PROTOCOL) {
@@ -6467,7 +6467,7 @@ static void parse_record_options(int argc,
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

