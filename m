Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17658C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiENCz3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiENCzU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4B634A94C
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 830B661E36
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1247C341CD;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XNH-No;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 21/26] trace-cmd library: Add tracecmd_msg_flush_data()
Date:   Fri, 13 May 2022 22:47:51 -0400
Message-Id: <20220514024756.1319681-22-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add tracecmd_msg_flush_data() that will flush the current cached data to
the network and restart the cache file.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-msg.c                     | 20 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 28fa712c4de8..053866d547af 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -416,6 +416,7 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
 			       const char *buf, int size);
 int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle);
+int tracecmd_msg_flush_data(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_send_close_resp_msg(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle);
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 963ef94e977b..a0c7f1818b0f 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -823,6 +823,26 @@ int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
 	return ret;
 }
 
+/**
+ * tracecmd_msg_flush_data - Send the current cache data over the network
+ * @msg_handle: message handle, holding the communication context
+ *
+ * Send the content in the cache file over the nework, reset the file
+ * and start the cache up again (with nothing in it).
+ */
+int tracecmd_msg_flush_data(struct tracecmd_msg_handle *msg_handle)
+{
+	struct tracecmd_msg msg;
+	int ret;
+
+	flush_cache(msg_handle);
+	tracecmd_msg_init(MSG_FIN_DATA, &msg);
+	ret = tracecmd_msg_send(msg_handle, &msg);
+	if (ret < 0)
+		return ret;
+	return tracecmd_msg_handle_cache(msg_handle);
+}
+
 int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle)
 {
 	struct tracecmd_msg msg;
-- 
2.35.1

