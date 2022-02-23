Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E790C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 04:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbiBWERL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 23:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiBWERK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 23:17:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B6B19C1C
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 20:16:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DFB960AD3
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 04:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74932C340E7;
        Wed, 23 Feb 2022 04:16:41 +0000 (UTC)
Date:   Tue, 22 Feb 2022 23:16:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>
Subject: [PATCH] libtracefs: Use tracefs_warning() for
 tracefs_user_event_record() errors
Message-ID: <20220222231639.3ccfe44e@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Instead of hard coding fprintf() into the library, allow the application
to control the output, and use tracefs_warning() instead.
Also switch the setting of the errno, as tracefs_warning() will
add a perror() to the message.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-userevents.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/tracefs-userevents.c b/src/tracefs-userevents.c
index ccd511b3045d..7da6aa35bf12 100644
--- a/src/tracefs-userevents.c
+++ b/src/tracefs-userevents.c
@@ -504,13 +504,13 @@ int tracefs_user_event_record(struct tracefs_user_event *event,
 	return writev(e->group->fd, head, used);
 
 bad_length:
-	fprintf(stderr, "Bad user_event item length at index %d\n",
-		used - 1);
 	errno = EINVAL;
+	tracefs_warning("Bad user_event item length at index %d\n",
+		used - 1);
 	return -1;
 
 bad_count:
-	fprintf(stderr, "Too many user_event items passed\n");
 	errno = E2BIG;
+	tracefs_warning("Too many user_event items passed\n");
 	return -1;
 }
-- 
2.34.1

