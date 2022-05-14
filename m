Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D94C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiENC5T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiENCzh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3098B34A003
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A97FD61E06
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FAAC3411C;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XME-CY;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 06/26] trace-cmd: Move trace_msg cache file to memfd
Date:   Fri, 13 May 2022 22:47:36 -0400
Message-Id: <20220514024756.1319681-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Joel Fernandes <joel@joelfernandes.org>

This is cleaner and also fixes issues in Android where /tmp does not
exist.

With this, host-guest tracing works on Android VM running on ChromeOS
Linux.

Link: https://lore.kernel.org/linux-trace-devel/20220405192204.1551283-1-joel@joelfernandes.org

Signed-off-by: Joel Fernandes <joel@joelfernandes.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 2 --
 lib/trace-cmd/trace-msg.c                         | 5 ++---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 766e0a762c2b..0efc2a1c4850 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -381,7 +381,6 @@ enum tracecmd_msg_flags {
 };
 
 /* for both client and server */
-#define MSG_CACHE_FILE "/tmp/trace_msg_cacheXXXXXX"
 struct tracecmd_msg_handle {
 	int			fd;
 	short			cpu_count;
@@ -390,7 +389,6 @@ struct tracecmd_msg_handle {
 	bool			done;
 	bool			cache;
 	int			cfd;
-	char			cfile[sizeof(MSG_CACHE_FILE)];
 };
 
 struct tracecmd_tsync_protos {
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 39465ade8ab3..5ba2eeb2d183 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -19,6 +19,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <arpa/inet.h>
+#include <sys/mman.h>
 #include <sys/types.h>
 #include <linux/types.h>
 
@@ -590,11 +591,9 @@ tracecmd_msg_handle_alloc(int fd, unsigned long flags)
 int tracecmd_msg_handle_cache(struct tracecmd_msg_handle *msg_handle)
 {
 	if (msg_handle->cfd < 0) {
-		strcpy(msg_handle->cfile, MSG_CACHE_FILE);
-		msg_handle->cfd = mkstemp(msg_handle->cfile);
+		msg_handle->cfd = memfd_create("trace_msg_cache", 0);
 		if (msg_handle->cfd < 0)
 			return -1;
-		unlink(msg_handle->cfile);
 	}
 	msg_handle->cache = true;
 	return 0;
-- 
2.35.1

