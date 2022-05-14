Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BF1C433FE
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiENCz2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiENCzU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B20534A946
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74EBC61E21
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4016C341C8;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XN9-MS;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 19/26] trace-cmd msg: Keep track of offset of flushed cache
Date:   Fri, 13 May 2022 22:47:49 -0400
Message-Id: <20220514024756.1319681-20-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The proxy agent will need to send data in two chunks, and will need to
save the offset of the flushed cache so that it can be used later.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-msg.c                     | 29 +++++++++++++++----
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 8824dcae0b16..ef2351e8491f 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -389,6 +389,7 @@ struct tracecmd_msg_handle {
 	short			cpu_count;
 	short			version;	/* Current protocol version */
 	unsigned long		flags;
+	off64_t			cache_start_offset;
 	bool			done;
 	bool			cache;
 	int			cfd;
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index c16e8e81e50a..963ef94e977b 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -184,13 +184,27 @@ static int __msg_write(int fd, struct tracecmd_msg *msg, bool network)
 
 __hidden off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off64_t offset, int whence)
 {
+	off64_t cache_offset = msg_handle->cache_start_offset;
+	off64_t ret;
+
 	/*
 	 * lseek works only if the handle is in cache mode,
 	 * cannot seek on a network socket
 	 */
 	if (!msg_handle->cache || msg_handle->cfd < 0)
 		return (off64_t)-1;
-	return lseek64(msg_handle->cfd, offset, whence);
+
+	if (whence == SEEK_SET) {
+		if (offset < cache_offset)
+			return (off64_t)-1;
+		offset -= cache_offset;
+	}
+
+	ret = lseek64(msg_handle->cfd, offset, whence);
+	if (ret == (off64_t)-1)
+		return ret;
+
+	return ret + cache_offset;
 }
 
 static int msg_write(struct tracecmd_msg_handle *msg_handle, struct tracecmd_msg *msg)
@@ -618,15 +632,16 @@ int tracecmd_msg_handle_cache(struct tracecmd_msg_handle *msg_handle)
 static int flush_cache(struct tracecmd_msg_handle *msg_handle)
 {
 	char buf[MSG_MAX_DATA_LEN];
+	int fd = msg_handle->cfd;
 	int ret;
 
-	if (!msg_handle->cache || msg_handle->cfd < 0)
+	if (!msg_handle->cache || fd < 0)
 		return 0;
 	msg_handle->cache = false;
-	if (lseek64(msg_handle->cfd, 0, SEEK_SET) == (off64_t)-1)
+	if (lseek64(fd, 0, SEEK_SET) == (off64_t)-1)
 		return -1;
 	do {
-		ret = read(msg_handle->cfd, buf, MSG_MAX_DATA_LEN);
+		ret = read(fd, buf, MSG_MAX_DATA_LEN);
 		if (ret <= 0)
 			break;
 		ret = tracecmd_msg_data_send(msg_handle, buf, ret);
@@ -634,7 +649,11 @@ static int flush_cache(struct tracecmd_msg_handle *msg_handle)
 			break;
 	} while (ret >= 0);
 
-	close(msg_handle->cfd);
+	msg_handle->cache_start_offset = lseek64(fd, 0, SEEK_CUR);
+	if (msg_handle->cache_start_offset == (off64_t)-1)
+		return -1;
+
+	close(fd);
 	msg_handle->cfd = -1;
 	return ret;
 }
-- 
2.35.1

