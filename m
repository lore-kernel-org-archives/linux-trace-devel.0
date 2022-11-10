Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263F3C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Nov 2022 07:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbiKJHXr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Nov 2022 02:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbiKJHXo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Nov 2022 02:23:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEC05F92
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 23:23:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A591615C2
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Nov 2022 07:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4970C433D6
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Nov 2022 07:23:42 +0000 (UTC)
Date:   Thu, 10 Nov 2022 02:23:41 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Quiet the warnings
Message-ID: <20221110022341.7a719ec3@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Set the default loglevel to TEP_LOG_ERROR, as TEP_LOG_WARNING is adds a
lot of noise.

Fixes: 51ae62947 ("trace-cmd library: Only set trace-cmd log level")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-read.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index d51e3371..224a6dde 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1565,7 +1565,7 @@ void trace_report (int argc, char **argv)
 
 	signal(SIGINT, sig_end);
 
-	trace_set_loglevel(TEP_LOG_INFO);
+	trace_set_loglevel(TEP_LOG_ERROR);
 
 	for (;;) {
 		int option_index = 0;
-- 
2.35.1

