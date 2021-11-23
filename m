Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B1AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Nov 2021 22:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhKWWNN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 17:13:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:37204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhKWWNN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 17:13:13 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94C6A60F5B;
        Tue, 23 Nov 2021 22:10:04 +0000 (UTC)
Date:   Tue, 23 Nov 2021 17:10:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Cliff Wickman <cliff.wickman@hpe.com>
Subject: [PATCH] libtraceevent: Do not read non printable characters
Message-ID: <20211123171003.7e24cd37@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Cliff Wickman <cliff.wickman@hpe.com>

libtraceevent is getting into a loop if the trace.dat file contains
corrupted strings ending in non-printable characters instead of quotes.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215121
Signed-off-by: Cliff Wickman <cliff.wickman@hpe.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/event-parse.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 7063758..c3ea98e 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -1246,7 +1246,8 @@ static enum tep_event_type __read_token(char **tok)
 			/* the '\' '\' will cancel itself */
 			if (ch == '\\' && last_ch == '\\')
 				last_ch = 0;
-		} while (ch != quote_ch || last_ch == '\\');
+			/* Break out if the file is corrupted and giving non print chars */
+		} while ((ch != quote_ch && isprint(ch)) || last_ch == '\\');
 		/* remove the last quote */
 		i--;
 
-- 
2.31.1

