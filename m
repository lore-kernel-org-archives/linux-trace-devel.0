Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E704C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiENCzp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiENCzh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E06D34992E
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0F5361D33
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA2FC34115;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XMK-Dr;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 08/26] trace-cmd agent: Test if memfd_create() is available
Date:   Fri, 13 May 2022 22:47:38 -0400
Message-Id: <20220514024756.1319681-9-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Some systems do not have memfd_create() available and it is a regression
to require it. Fall back to tempfs if memfd_create() is not available at
build time.

Link: https://lore.kernel.org/linux-trace-devel/20220428174949.797657-3-rostedt@goodmis.org

Cc: Joel Fernandes <joel@joelfernandes.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile                                          | 11 ++++++++++-
 lib/trace-cmd/include/private/trace-cmd-private.h |  5 +++++
 lib/trace-cmd/trace-msg.c                         |  8 ++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 9fbc6de25d05..abc4ac723db4 100644
--- a/Makefile
+++ b/Makefile
@@ -184,6 +184,15 @@ endef
 # have flush/fua block layer instead of barriers?
 blk-flags := $(call test-build,$(BLK_TC_FLUSH_SOURCE),-DHAVE_BLK_TC_FLUSH)
 
+define MEMFD_CREATE_SOURCE
+#define _GNU_SOURCE
+#include <sys/mman.h>
+int main(void) { return memfd_create(\"test\", 0); }
+endef
+
+# have memfd_create available
+memfd-flags := $(call test-build,$(MEMFD_CREATE_SOURCE),-DHAVE_MEMFD_CREATE)
+
 ifeq ("$(origin O)", "command line")
 
   saved-output := $(O)
@@ -363,7 +372,7 @@ endif
 # Append required CFLAGS
 override CFLAGS += $(INCLUDES) $(VAR_DIR)
 override CFLAGS += $(PLUGIN_DIR_TRACECMD_SQ)
-override CFLAGS += $(udis86-flags) $(blk-flags)
+override CFLAGS += $(udis86-flags) $(blk-flags) $(memfd-flags)
 override LDFLAGS += $(udis86-ldflags)
 
 CMD_TARGETS = trace-cmd $(BUILD_PYTHON)
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 0efc2a1c4850..3b84170f2258 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -380,6 +380,8 @@ enum tracecmd_msg_flags {
 	TRACECMD_MSG_FL_USE_VSOCK	= 1 << 1,
 };
 
+#define MSG_CACHE_FILE "/tmp/trace_msg_cacheXXXXXX"
+
 /* for both client and server */
 struct tracecmd_msg_handle {
 	int			fd;
@@ -389,6 +391,9 @@ struct tracecmd_msg_handle {
 	bool			done;
 	bool			cache;
 	int			cfd;
+#ifndef HAVE_MEMFD_CREATE
+	char			cfile[sizeof(MSG_CACHE_FILE)];
+#endif
 };
 
 struct tracecmd_tsync_protos {
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 5ba2eeb2d183..9899fa8796e2 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -591,9 +591,17 @@ tracecmd_msg_handle_alloc(int fd, unsigned long flags)
 int tracecmd_msg_handle_cache(struct tracecmd_msg_handle *msg_handle)
 {
 	if (msg_handle->cfd < 0) {
+#ifdef HAVE_MEMFD_CREATE
 		msg_handle->cfd = memfd_create("trace_msg_cache", 0);
 		if (msg_handle->cfd < 0)
 			return -1;
+#else
+		strcpy(msg_handle->cfile, MSG_CACHE_FILE);
+		msg_handle->cfd = mkstemp(msg_handle->cfile);
+		if (msg_handle->cfd < 0)
+			return -1;
+		unlink(msg_handle->cfile);
+#endif
 	}
 	msg_handle->cache = true;
 	return 0;
-- 
2.35.1

