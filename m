Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E02C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Dec 2022 20:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiLNUoM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Dec 2022 15:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLNUoK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Dec 2022 15:44:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EE2BEE
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Dec 2022 12:44:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56B9361BEC
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Dec 2022 20:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6E6C433D2;
        Wed, 14 Dec 2022 20:44:07 +0000 (UTC)
Date:   Wed, 14 Dec 2022 15:44:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark: Do not truncate multi-line events
Message-ID: <20221214154404.5897fc23@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Some events have more than one line. The libkshark-tepdata.c get_info
function did a string search for the first occurrence of '\n' and set it
to '\0', with the comment of removing trailing newlines. Unfortunately,
it removed more than the trailing newline and removed most of the event.
This is particularly true with stack traces.

Instead, use the trace_seq.len to check the last written character, and if
that is a newline, remove it.

Fixes: 836ce858246b7 ("kernel-shark: Add stream interface for trace-cmd data")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/libkshark-tepdata.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 08aca0989a59..58be934f7d20 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -816,7 +816,7 @@ static char *get_info_str(struct kshark_data_stream *stream,
 			  struct tep_record *record,
 			  struct tep_event *event)
 {
-	char *pos, *buffer;
+	char *buffer;
 
 	if (!init_thread_seq() || !record || !event)
 		return NULL;
@@ -829,8 +829,8 @@ static char *get_info_str(struct kshark_data_stream *stream,
 	 * The event info string contains a trailing newline.
 	 * Remove this newline.
 	 */
-	if ((pos = strchr(seq.buffer, '\n')) != NULL)
-		*pos = '\0';
+	if (seq.buffer[seq.len - 1] == '\n')
+		seq.buffer[seq.len - 1] = '\0';
 
 	if (asprintf(&buffer, "%s", seq.buffer)  <= 0)
 		return NULL;
-- 
2.35.1

