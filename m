Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E96C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Nov 2022 22:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbiKJW7g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Nov 2022 17:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbiKJW7d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Nov 2022 17:59:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9015F85F
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Nov 2022 14:59:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26A8D619EB
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Nov 2022 22:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A866C433D7;
        Thu, 10 Nov 2022 22:59:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1otGWf-009ahb-2n;
        Thu, 10 Nov 2022 18:00:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] libtracefs: Do not return negative on EAGAIN for tracefs_cpu_flush_write()
Date:   Thu, 10 Nov 2022 17:59:58 -0500
Message-Id: <20221110225959.2285998-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221110225959.2285998-1-rostedt@goodmis.org>
References: <20221110225959.2285998-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Like tracefs_cpu_flush(), when the buffer is empty, and because the
reading of the buffer is done in NON_BLOCK mode, it will finish with a
negative and EAGAIN. This is a successful state, do not return a negative
number here.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-record.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index dbe0e9f01aad..71d1df99bb02 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -495,6 +495,10 @@ int tracefs_cpu_flush_write(struct tracefs_cpu *tcpu, int wfd)
 	if (ret > 0)
 		ret = write(wfd, buffer, ret);
 
+	/* It's OK if there's no data to read */
+	if (ret < 0 && errno == EAGAIN)
+		ret = 0;
+
 	return ret;
 }
 
-- 
2.35.1

