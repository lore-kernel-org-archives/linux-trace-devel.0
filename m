Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3677C4321E
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 18:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234760AbiDQSYg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 17 Apr 2022 14:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234761AbiDQSYf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 17 Apr 2022 14:24:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816645FD0
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 11:21:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B870B80D8D
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 18:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629DDC385B0;
        Sun, 17 Apr 2022 18:21:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ng9X1-004Mz9-8G;
        Sun, 17 Apr 2022 14:21:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 2/7] trace-cmd library: Remove ports from clock context
Date:   Sun, 17 Apr 2022 14:21:49 -0400
Message-Id: <20220417182154.1041513-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220417182154.1041513-1-rostedt@goodmis.org>
References: <20220417182154.1041513-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The local and remote port fields are set but never used. Remove them.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/include/trace-tsync-local.h |  2 --
 lib/trace-cmd/trace-timesync.c            | 11 +++--------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index b357662c8d41..d0f82f5d0916 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -51,9 +51,7 @@ struct clock_sync_context {
 
 	/* Identifiers of local and remote time sync peers: cid and port */
 	unsigned int			local_cid;
-	unsigned int			local_port;
 	unsigned int			remote_cid;
-	unsigned int			remote_port;
 };
 
 int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int roles,
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 9e82094eaa31..514d333e57a7 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -405,8 +405,7 @@ int __hidden vsock_get_port(int sd, unsigned int *port)
 	return 0;
 }
 
-static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *lport,
-			      unsigned int *rcid, unsigned int *rport)
+static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid)
 {
 	struct sockaddr_vm addr;
 	socklen_t addr_len = sizeof(addr);
@@ -416,7 +415,6 @@ static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *lport,
 		return -1;
 	if (addr.svm_family != AF_VSOCK)
 		return -1;
-	*lport = addr.svm_port;
 	*lcid = addr.svm_cid;
 
 	memset(&addr, 0, sizeof(addr));
@@ -425,7 +423,6 @@ static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *lport,
 		return -1;
 	if (addr.svm_family != AF_VSOCK)
 		return -1;
-	*rport = addr.svm_port;
 	*rcid = addr.svm_cid;
 
 	return 0;
@@ -448,8 +445,7 @@ static int vsock_get_port(int sd, unsigned int *port)
 	return -ENOTSUP;
 }
 
-static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *lport,
-			      unsigned int *rcid, unsigned int *rport)
+static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid)
 {
 	return -ENOTSUP;
 }
@@ -503,8 +499,7 @@ static int clock_context_init(struct tracecmd_time_sync *tsync,
 	clock->is_server = clock->is_guest;
 
 	if (get_vsocket_params(tsync->msg_handle->fd, &clock->local_cid,
-			       &clock->local_port, &clock->remote_cid,
-			       &clock->remote_port))
+			       &clock->remote_cid))
 		goto error;
 
 	clock->instance = clock_synch_create_instance(tsync->clock_str,
-- 
2.35.1

