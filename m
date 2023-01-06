Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436CAC54EBD
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Jan 2023 19:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235556AbjAFTXr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Jan 2023 14:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235541AbjAFTXr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Jan 2023 14:23:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676BB669A1
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 11:23:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C648B81DA1
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 19:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697F6C433F0;
        Fri,  6 Jan 2023 19:23:43 +0000 (UTC)
Date:   Fri, 6 Jan 2023 14:23:41 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Douglas RAILLARD <douglas.raillard@arm.com>
Subject: [PATCH] libtraceevent: Fix output of raw prints
Message-ID: <20230106142341.15df4486@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The raw prints that uses the parsed fields directly, had a bug in it where
the check to catch if reading the event went beyond the event size it
would warn. But instead of testing against the event size, it was testing
against the field size. The test was suppose to test:

  field->offset + field->size > data_size

Which would catch an overflow, but instead it was testing:

  field->offset + field->size > field->size

Which will always be true! (well, if the field was not at the beginning of
the data, which is always is due to meta data).

Have it check the data size and not the field size.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216896
Reported-by:  Douglas RAILLARD  <douglas.raillard@arm.com>
Fixes: 09f02890358a2 ("libtraceevent: Improve tep_print_field()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 8167777fccd7..18db7fcb456d 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -6032,7 +6032,7 @@ static inline void print_field(struct trace_seq *s, void *data, int size,
 		if (has_0x)
 			trace_seq_puts(s, "0x");
 
-		print_parse_data(parse, s, data, field->size, event);
+		print_parse_data(parse, s, data, size, event);
 
 		if (parse_ptr)
 			*parse_ptr = parse->next;
-- 
2.35.1

