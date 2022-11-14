Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63446C4167B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Nov 2022 22:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236456AbiKNWUE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 17:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237017AbiKNWTs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 17:19:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66D9113E
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 14:19:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 59D93CE12FB
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 22:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A9FC433D6;
        Mon, 14 Nov 2022 22:19:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ouhoW-00ADfI-2l;
        Mon, 14 Nov 2022 17:20:24 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] libtracefs: Do not return negative on EAGAIN for tracefs_cpu_flush_write()
Date:   Mon, 14 Nov 2022 17:20:23 -0500
Message-Id: <20221114222024.2435776-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221114222024.2435776-1-rostedt@goodmis.org>
References: <20221114222024.2435776-1-rostedt@goodmis.org>
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

Fixes: 26b8893efda7c ("libtracefs: Add reading of per cpu files")
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

