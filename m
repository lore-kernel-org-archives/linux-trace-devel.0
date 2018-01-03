Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751190AbeACRxi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:38 -0500
Message-Id: <20180103175337.552583962@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 19/38] trace-cmd: Verify RINIT was received after TINIT msg sent
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0019-trace-cmd-Verify-RINIT-was-received-after-TINIT-msg-.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

After the init data is sent to the server, make sure that it is a RINIT that
is received before processing the ports.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-msg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/trace-msg.c b/trace-msg.c
index e1abbbb99bb4..453901981c90 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -390,6 +390,9 @@ int tracecmd_msg_send_init_data(int fd)
 	if (ret < 0)
 		return ret;
 
+	if (ntohl(recv_msg.hdr.cmd) != MSG_RINIT)
+		return -EINVAL;
+
 	cpus = ntohl(recv_msg.rinit.cpus);
 	client_ports = malloc_or_die(sizeof(int) * cpus);
 	for (i = 0; i < cpus; i++)
-- 
2.13.2
