Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF2BC7EE23
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Jun 2023 11:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjFALvB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Jun 2023 07:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjFALvB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Jun 2023 07:51:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36425129
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Jun 2023 04:51:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C272F614F4
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Jun 2023 11:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7AAC433D2;
        Thu,  1 Jun 2023 11:50:58 +0000 (UTC)
Date:   Thu, 1 Jun 2023 07:50:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Douglas RAILLARD <douglas.raillard@arm.com>
Subject: [PATCH] trace-cmd extract: Do not extract top level unless told to
Message-ID: <20230601075053.3fa7dd9b@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

The trace-cmd extract man pages explicitly states that if the '-B'
option is used, it will only extract the given instance and not touch
any other buffer instance including the top level, unless '-t' is given
(for the top level) or '-a' (for all instances). But currently it is
hard coded to extract the top level. Make extract only touch what it is
told according to the documentation.

Reported-by: Douglas RAILLARD <douglas.raillard@arm.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217340
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index f852aa71..56b7991a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -7278,7 +7278,7 @@ void trace_extract(int argc, char **argv)
 
 	type = get_trace_cmd_type(ctx.curr_cmd);
 
-	update_first_instance(ctx.instance, 1);
+	update_first_instance(ctx.instance, ctx.topt);
 	check_function_plugin();
 
 	if (!ctx.output)
