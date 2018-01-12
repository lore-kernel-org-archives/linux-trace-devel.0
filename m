Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:49922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964844AbeALSJc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Jan 2018 13:09:32 -0500
Message-Id: <20180112180930.345950960@goodmis.org>
Date: Fri, 12 Jan 2018 13:08:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vladislav Valtchev <vladislav.valtchev@gmail.com>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 1/3] trace-cmd: Fix leaking of port_array memory
References: <20180112180847.372748598@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-trace-cmd-Fix-leaking-of-port_array-memory.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The port_array is allocated in create_all_readers() to send the ports that
are created to the client. But after it is sent, it is no longer needed, but
it was not freed. This causes a memory leak.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 trace-listen.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/trace-listen.c b/trace-listen.c
index 38de59263800..871df0e7a04c 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -587,9 +587,11 @@ static int *create_all_readers(const char *node, const char *port,
 		write(msg_handle->fd, "\0", 1);
 	}
 
+	free(port_array);
 	return pid_array;
 
  out_free:
+	free(port_array);
 	destroy_all_readers(cpus, pid_array, node, port);
 	return NULL;
 }
-- 
2.13.2
