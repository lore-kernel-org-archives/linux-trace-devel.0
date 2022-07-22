Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733E9C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Jul 2022 20:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbiGVURg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Jul 2022 16:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236362AbiGVURg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Jul 2022 16:17:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FAF7F50A
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Jul 2022 13:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43CF561E87
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Jul 2022 20:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D58C341C6
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Jul 2022 20:17:34 +0000 (UTC)
Date:   Fri, 22 Jul 2022 16:17:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Return negative number when
 tracefs_filter_string_append() fails
Message-ID: <20220722161732.0c5d7023@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the field passed into tracefs_filter_string_append() does not match a
field of the event, or if the value is not proper, it fails to append the
filter, but still returns 0 as it was successful.

Return -1 if it fails.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-filter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-filter.c b/src/tracefs-filter.c
index 85d0be17f6b7..b16dfadb3aa9 100644
--- a/src/tracefs-filter.c
+++ b/src/tracefs-filter.c
@@ -423,7 +423,8 @@ int tracefs_filter_string_append(struct tep_event *event, char **filter,
 		free(*filter);
 		*filter = str;
 	}
-	return 0;
+
+	return ret;
 }
 
 static int error_msg(char **err, char *str,
-- 
2.35.1

