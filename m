Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C167C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 21:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241873AbiBWVDx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Feb 2022 16:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239208AbiBWVDw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Feb 2022 16:03:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC814DF79
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 13:03:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A43E2CE1C54
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 21:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A0FC340E7;
        Wed, 23 Feb 2022 21:03:20 +0000 (UTC)
Date:   Wed, 23 Feb 2022 16:03:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Chuck Lever III <chuck.lever@oracle.com>
Subject: [PATCH] libtraceevent: Fix %zd and %Zd processing
Message-ID: <20220223160318.09b7c4eb@gandalf.local.home>
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

Reported-by: Chuck Lever III <chuck.lever@oracle.com>
Fixes: 6582b0aea1cc ("tools/events: Add files to create libtraceevent.a")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index de28b3be9955..124166909589 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5713,9 +5713,11 @@ static int parse_arg_format(struct tep_print_parse **parse,
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

