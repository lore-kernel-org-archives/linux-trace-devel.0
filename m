Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDAD9C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Dec 2022 03:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbiLTDnD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Dec 2022 22:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiLTDnC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Dec 2022 22:43:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0086D12AD3
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Dec 2022 19:43:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A2F36125E
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 03:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF154C433D2
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 03:42:59 +0000 (UTC)
Date:   Mon, 19 Dec 2022 22:42:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Allow stack traces to show offset too
Message-ID: <20221219224258.68a86565@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The stack traces only show the function name and the full address, which
can be useless for running under gdb, because the address could be
randomized, and to find the locations within the functions, the offsets
from the start of the function really need to be displayed and not just
the full address, as the address isn't known by gdb.

Have the function plugin "offset" option affect stack traces too. That
way, there's a way to display the offsets of the functions too.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 plugins/plugin_function.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/plugins/plugin_function.c b/plugins/plugin_function.c
index 7777569f63b5..2d6509b430e4 100644
--- a/plugins/plugin_function.c
+++ b/plugins/plugin_function.c
@@ -233,9 +233,11 @@ trace_stack_handler(struct trace_seq *s, struct tep_record *record,
 			break;
 
 		func = tep_find_function(event->tep, addr);
-		if (func)
-			trace_seq_printf(s, "=> %s (%llx)\n", func, addr);
-		else
+		if (func) {
+			trace_seq_puts(s, "=> ");
+			show_function(s, event->tep, func, addr);
+			trace_seq_printf(s, " (%llx)\n", addr);
+		} else
 			trace_seq_printf(s, "=> %llx\n", addr);
 	}
 
-- 
2.35.1

