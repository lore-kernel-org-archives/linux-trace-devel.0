Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D54EB64DA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 Jul 2023 16:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjGJQjT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 12:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGJQjS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 12:39:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D5393
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 Jul 2023 09:39:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 460BA6112A
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 Jul 2023 16:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68249C433C8;
        Mon, 10 Jul 2023 16:39:16 +0000 (UTC)
Date:   Mon, 10 Jul 2023 12:39:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Sharon Gabay <Sharon.Gabay@mobileye.com>
Subject: [PATCH] trace-cmd split: Do not append '.1' to single file if
 output specified
Message-ID: <20230710123914.5a58be62@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the user specifies an output file, and it is not the same as the input
file, and the '-r' (repeat) option is not specified, there's no reason to
append the '.1' to the output file name. Just use what the user specified.

Link: https://lore.kernel.org/linux-trace-users/VE1PR09MB3535FFA94A0481583EF7992CF230A@VE1PR09MB3535.eurprd09.prod.outlook.com/

Suggested-by: Sharon Gabay <Sharon.Gabay@mobileye.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-split.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 1daa847d9775..59df1d02b345 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -545,7 +545,7 @@ void trace_split (int argc, char **argv)
 	if (!output)
 		output = strdup(input_file);
 
-	if (!repeat) {
+	if (!repeat && strcmp(output, input_file) == 0) {
 		output = realloc(output, strlen(output) + 3);
 		strcat(output, ".1");
 	}
-- 
2.39.2

