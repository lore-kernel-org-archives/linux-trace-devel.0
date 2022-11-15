Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A57C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 04:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbiKOE7w (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 23:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiKOE7v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 23:59:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8BEB87E
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 20:59:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AD2A61487
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 04:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778D9C433C1
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 04:59:49 +0000 (UTC)
Date:   Tue, 15 Nov 2022 00:00:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Have tracefs_tracer_set() return zero on
 success
Message-ID: <20221115000031.5f2da5dd@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The tracefs_tracer_set() does a ret = write() to write the tracer name
into the current_tracer file, but then it returns the ret as well. "write"
returns the number of bytes written, but tracefs_tracer_set() is suppose
to return 0 on success.

Have it return 0 instead of the number of bytes written on success.

Fixes: df130d4915b15 ("libtracefs: Add support for setting tracers")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-tools.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 489be28a3b94..8e7b46db86e9 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -1055,7 +1055,7 @@ int tracefs_tracer_set(struct tracefs_instance *instance,
  out:
 	tracefs_put_tracing_file(tracer_path);
 	close(fd);
-	return ret;
+	return ret > 0 ? 0 : ret;
 }
 
 int  tracefs_tracer_clear(struct tracefs_instance *instance)
-- 
2.35.1

