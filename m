Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F4AC43217
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Nov 2022 22:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiKJW7h (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Nov 2022 17:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbiKJW7e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Nov 2022 17:59:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20ABD5F86D
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Nov 2022 14:59:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3AEEB8238D
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Nov 2022 22:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801ACC433D6;
        Thu, 10 Nov 2022 22:59:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1otGWf-009ahe-2r;
        Thu, 10 Nov 2022 18:00:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] libtracefs: Reset errno to success on EAGAIN for the flush functions
Date:   Thu, 10 Nov 2022 17:59:59 -0500
Message-Id: <20221110225959.2285998-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221110225959.2285998-1-rostedt@goodmis.org>
References: <20221110225959.2285998-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The functions tracefs_cpu_flush() and tracefs_cpu_flush_write() both
usually end with errno = EAGAIN. This should not be passed to the calling
function, so reset it to 0.

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

