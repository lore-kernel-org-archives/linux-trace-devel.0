Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 685ABC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 21 May 2022 22:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346365AbiEUWIv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 21 May 2022 18:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346344AbiEUWIu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 21 May 2022 18:08:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4371142A33
        for <linux-trace-devel@vger.kernel.org>; Sat, 21 May 2022 15:08:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52AD1B80AC6
        for <linux-trace-devel@vger.kernel.org>; Sat, 21 May 2022 22:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD24CC385AA
        for <linux-trace-devel@vger.kernel.org>; Sat, 21 May 2022 22:08:45 +0000 (UTC)
Date:   Sat, 21 May 2022 18:08:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd listen: Use copy of host for connect_ip()
Message-ID: <20220521180844.2af85772@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If an old trace-cmd only uses v1 in the listen communication, to determine
this a trick is done by passing the v1 CPU communication a -1 followed by
the communication version. V3 and beyond knows this as the version
communication number, but v1 will error out. Then the connection is closed
and v1 is tried anew. (Note, v2 never existed in a release so it can be ignored).

The problem is that on the retry, the host has been updated with via a
strchr(), and modified. The second time around, it will not have the port
number attached to it, so it will fail to communicate.

Fixes: 194467199c076 ("trace-cmd listen: Add vsocket usage")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index c770f698019f..ce20402af7c2 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3630,7 +3630,7 @@ static int connect_ip(char *thost)
 	char *port;
 	char *p;
 
-	if (!strchr(host, ':')) {
+	if (!strchr(thost, ':')) {
 		server = strdup("localhost");
 		if (!server)
 			die("alloctating server");
@@ -3662,19 +3662,24 @@ static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instanc
 {
 	struct tracecmd_msg_handle *msg_handle = NULL;
 	enum port_type type = instance->port_type;
+	char *thost = strdup(host);
 	int sfd;
 
+	if (!thost)
+		die("Failed to allocate host");
 again:
 	switch (type) {
 	case USE_VSOCK:
-		sfd = connect_vsock(host);
+		sfd = connect_vsock(thost);
 		break;
 	default:
-		sfd = connect_ip(host);
+		sfd = connect_ip(thost);
 	}
 
-	if (sfd < 0)
+	if (sfd < 0) {
+		free(thost);
 		return NULL;
+	}
 
 	if (msg_handle) {
 		msg_handle->fd = sfd;
@@ -3704,6 +3709,7 @@ again:
 			/* reconnect to the server for using the v1 protocol */
 			close(sfd);
 			free(host);
+			host = NULL;
 			goto again;
 		}
 		communicate_with_listener_v3(msg_handle, &instance->client_ports);
@@ -3712,6 +3718,7 @@ again:
 	if (msg_handle->version == V1_PROTOCOL)
 		communicate_with_listener_v1(msg_handle, instance);
 
+	free(thost);
 	return msg_handle;
 }
 
-- 
2.35.1

