Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0E7C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Feb 2022 20:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344109AbiBJUJD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 15:09:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344103AbiBJUJC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 15:09:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D5D2737;
        Thu, 10 Feb 2022 12:09:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B748561882;
        Thu, 10 Feb 2022 20:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A8EC340F3;
        Thu, 10 Feb 2022 20:09:02 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1nIFkT-002zKY-8L;
        Thu, 10 Feb 2022 15:09:01 -0500
Message-ID: <20220210200901.093041898@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 10 Feb 2022 15:05:12 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: [for-linus][PATCH 3/6] rtla/trace: Error message fixup
References: <20220210200509.089236997@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

Use capital and change "tracer %s" to "%s tracer".

No functional change.

Link: https://lkml.kernel.org/r/361697d27431afefa64c67c323564205385c418d.1643990447.git.bristot@kernel.org

Fixes: b1696371d865 ("rtla: Helper functions for rtla")
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-trace-devel@vger.kernel.org
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tools/tracing/rtla/src/trace.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/tracing/rtla/src/trace.c b/tools/tracing/rtla/src/trace.c
index 107a0c6387f7..83de259abcc1 100644
--- a/tools/tracing/rtla/src/trace.c
+++ b/tools/tracing/rtla/src/trace.c
@@ -20,14 +20,14 @@ int enable_tracer_by_name(struct tracefs_instance *inst, const char *tracer_name
 
 	tracer = TRACEFS_TRACER_CUSTOM;
 
-	debug_msg("enabling %s tracer\n", tracer_name);
+	debug_msg("Enabling %s tracer\n", tracer_name);
 
 	retval = tracefs_tracer_set(inst, tracer, tracer_name);
 	if (retval < 0) {
 		if (errno == ENODEV)
-			err_msg("tracer %s not found!\n", tracer_name);
+			err_msg("Tracer %s not found!\n", tracer_name);
 
-		err_msg("failed to enable the tracer %s\n", tracer_name);
+		err_msg("Failed to enable the %s tracer\n", tracer_name);
 		return -1;
 	}
 
@@ -44,7 +44,7 @@ void disable_tracer(struct tracefs_instance *inst)
 
 	retval = tracefs_tracer_set(inst, t);
 	if (retval < 0)
-		err_msg("oops, error disabling tracer\n");
+		err_msg("Oops, error disabling tracer\n");
 }
 
 /*
-- 
2.34.1
