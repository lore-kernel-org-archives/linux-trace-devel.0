Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FED3C43219
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Nov 2022 22:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbiKNWUE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 17:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237010AbiKNWTs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 17:19:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA4815822
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 14:19:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5215DCE12E0
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 22:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547B4C433D7;
        Mon, 14 Nov 2022 22:19:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ouhoW-00ADfL-2p;
        Mon, 14 Nov 2022 17:20:24 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] libtracefs: Reset errno to success on EAGAIN for the flush functions
Date:   Mon, 14 Nov 2022 17:20:24 -0500
Message-Id: <20221114222024.2435776-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221114222024.2435776-1-rostedt@goodmis.org>
References: <20221114222024.2435776-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The functions tracefs_cpu_flush() and tracefs_cpu_flush_write() both
usually end with errno = EAGAIN. This should not be passed to the calling
function, so reset it to 0.

Fixes: 26b8893efda7c ("libtracefs: Add reading of per cpu files")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-record.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index 71d1df99bb02..428bec0dfe3d 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -308,8 +308,11 @@ int tracefs_cpu_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock)
 	ret = read(tcpu->fd, buffer, tcpu->subbuf_size);
 
 	/* It's OK if there's no data to read */
-	if (ret < 0 && errno == EAGAIN)
+	if (ret < 0 && errno == EAGAIN) {
+		/* Reset errno */
+		errno = 0;
 		ret = 0;
+	}
 
 	return ret;
 }
@@ -470,8 +473,11 @@ int tracefs_cpu_flush(struct tracefs_cpu *tcpu, void *buffer)
 		tcpu->buffered -= ret;
 
 	/* It's OK if there's no data to read */
-	if (ret < 0 && errno == EAGAIN)
+	if (ret < 0 && errno == EAGAIN) {
+		/* Reset errno */
+		errno = 0;
 		ret = 0;
+	}
 
 	return ret;
 }
-- 
2.35.1

