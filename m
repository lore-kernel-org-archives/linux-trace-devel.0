Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7089DC6FA82
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Sep 2022 16:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiIWQ3P (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 23 Sep 2022 12:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiIWQ3P (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Sep 2022 12:29:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB7F137468
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Sep 2022 09:29:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 037D5B82DAB
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Sep 2022 16:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A9BC433D6;
        Fri, 23 Sep 2022 16:29:11 +0000 (UTC)
Date:   Fri, 23 Sep 2022 12:30:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceevent: Fix uninitialized variable in eval_num_arg()
Message-ID: <20220923123014.489e0e39@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

It appears that my compiler version did not notice that "field_size"
passed to check_data_offset_size() in the TEP_PRINT_DYNAMIC_ARRAY case was
not initialized. But other compilers do.

Since this case we just want to make sure the offset is not passed the end
of the event data, we can simply pass in zero.

Fixes: efd32896dd5db ("libtraceevent: Add warnings if fields are outside the event")
Reported-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 980e980985ad..a0458e548765 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -4310,7 +4310,7 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 		dynamic_offset_field(tep, arg->dynarray.field, data, size,
 				     &offset, NULL);
 		if (check_data_offset_size(event, arg->field.name, size,
-					   offset, field_size)) {
+					   offset, 0)) {
 			val = (unsigned long)data;
 			break;
 		}
-- 
2.35.1

