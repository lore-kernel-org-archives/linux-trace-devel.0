Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 701BEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Feb 2022 15:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbiBXP7R (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 10:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236923AbiBXP6n (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 10:58:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1A4177D35
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 07:57:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47444616D3
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 15:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC77C340E9;
        Thu, 24 Feb 2022 15:57:38 +0000 (UTC)
Date:   Thu, 24 Feb 2022 10:57:36 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Chuck Lever III <chuck.lever@oracle.com>
Subject: [PATCH][trace-cmd 2.9] libtraceevent: Fix %zd and %Zd processing
Message-ID: <20220224105736.124d84d0@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The 'z' option in printf is to handle the long case. To print as 32 bit on
32 bit architectures and 64 bit on 64 bit architectures. But currently it
is simply ignored in the printf formatting.

Link: https://lore.kernel.org/all/20220223160318.09b7c4eb@gandalf.local.home/

Reported-by: Chuck Lever III <chuck.lever@oracle.com>
Fixes: d78f5f2d3d25 ("Initial addition of trace-cmd files.")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/traceevent/event-parse.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 63b6e0c19e2c..b9b699e9acee 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -5522,9 +5522,11 @@ static int parse_arg_format(struct tep_print_parse **parse,
 		case 'L':
 			ls = 2;
 			break;
-		case '.':
 		case 'z':
 		case 'Z':
+			ls = 1;
+			break;
+		case '.':
 		case '0' ... '9':
 		case '-':
 			break;
-- 
2.34.1

