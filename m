Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751170AbeACRxj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:39 -0500
Message-Id: <20180103175338.546809042@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 26/38] trace-cmd listen: Add better output on error of connections
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0026-trace-cmd-listen-Add-better-output-on-error-of-conne.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Some of the errors that happen when a client connects to a server have
ambiguous error messages. Clean them up a little.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-listen.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/trace-listen.c b/trace-listen.c
index bd4c2734f181..cfb0f146244d 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -240,7 +240,7 @@ static int process_udp_child(int sfd, const char *host, const char *port,
 		if (r < 0) {
 			if (errno == EINTR)
 				break;
-			pdie("reading client");
+			pdie("reading pages from client");
 		}
 		if (!r)
 			break;
@@ -558,8 +558,10 @@ static int *create_all_readers(int cpus, const char *node, const char *port,
 
 	if (proto_ver == V2_PROTOCOL) {
 		/* send set of port numbers to the client */
-		if (tracecmd_msg_send_port_array(fd, cpus, port_array) < 0)
+		if (tracecmd_msg_send_port_array(fd, cpus, port_array) < 0) {
+			plog("Failed sending port array\n");
 			goto out_free;
+		}
 	} else {
 		/* send the client a comma deliminated set of port numbers */
 		for (cpu = 0; cpu < cpus; cpu++) {
-- 
2.13.2
