Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40559 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727678AbfAHPAb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Jan 2019 10:00:31 -0500
Received: by mail-pg1-f196.google.com with SMTP id z10so1843676pgp.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Jan 2019 07:00:30 -0800 (PST)
From: Slavomir Kaslev <kaslevs@vmware.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v2 4/6] trace-cmd: Simplify and fix memory leaks in tracecmd_msg_collect_data
Date: Tue,  8 Jan 2019 17:00:13 +0200
Message-Id: <20190108150015.21327-5-kaslevs@vmware.com>
In-Reply-To: <20190108150015.21327-1-kaslevs@vmware.com>
References: <20190108150015.21327-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch addresses leaking tracecmd_msg messages in tracecmd_msg_collect_data.

It also splits out tracecmd_msg_read_data from tracecmd_msg_collect_data which
only reads incomming data and doesn't wait for a final MSG_CLOSE message and is
used by the VM tracing agent.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h |  1 +
 tracecmd/trace-msg.c          | 28 ++++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 9ae17cf..c1b18fa 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -332,6 +332,7 @@ void tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
 				 int *ports);
+int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd);
 int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd);
 bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
 void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index 1a2ec40..edde582 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -626,7 +626,7 @@ int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle)
 	return 0;
 }
 
-int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd)
+int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 {
 	struct tracecmd_msg msg;
 	int t, n, cmd;
@@ -659,13 +659,34 @@ int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 				if (errno == EINTR)
 					continue;
 				warning("writing to file");
-				return -errno;
+				ret = -errno;
+				goto error;
 			}
 			t -= s;
 			s = n - t;
 		}
+
+		msg_free(&msg);
 	}
 
+	return 0;
+
+error:
+	error_operation_for_server(&msg);
+	msg_free(&msg);
+	return ret;
+}
+
+int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd)
+{
+	struct tracecmd_msg msg;
+	u32 cmd;
+	int ret;
+
+	ret = tracecmd_msg_read_data(msg_handle, ofd);
+	if (ret)
+		goto error;
+
 	/* check the finish message of the client */
 	while (!tracecmd_msg_done(msg_handle)) {
 		ret = tracecmd_msg_recv(msg_handle->fd, &msg);
@@ -683,11 +704,14 @@ int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 			ret = -EINVAL;
 			goto error;
 		}
+
+		msg_free(&msg);
 	}
 
 	return 0;
 
 error:
 	error_operation_for_server(&msg);
+	msg_free(&msg);
 	return ret;
 }
-- 
2.19.1
