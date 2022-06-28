Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA81CCA479
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Jun 2022 16:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiF1Qcq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 12:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiF1QcL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 12:32:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791A011150
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Jun 2022 09:23:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C848617C4
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Jun 2022 16:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC1BC3411D;
        Tue, 28 Jun 2022 16:23:52 +0000 (UTC)
Date:   Tue, 28 Jun 2022 12:23:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Chuck Lever III <chuck.lever@oracle.com>
Subject: [PATCH] libtraceevent: Add processing of __get_sockaddr() and
 __get_sockaddr_rel()
Message-ID: <20220628122350.434ec8df@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The macros __get_sockaddr() and __get_sockaddr_rel() are now added in the
TRACE_EVENT() helper functions and can be used to retrieve dynamically
saved sockaddr structures that hold IP addresses. Update libtraceevent to
handle them.

Link: https://lore.kernel.org/all/25C37F40-7D8E-41C6-961F-0774C8138CCB@oracle.com/

Reported-by: Chuck Lever III <chuck.lever@oracle.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 823333a3bde4..b252c4d890a0 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -3485,7 +3485,9 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
 		return process_bitmask(event, arg, tok);
 	}
 	if (strcmp(token, "__get_dynamic_array") == 0 ||
-	    strcmp(token, "__get_rel_dynamic_array") == 0) {
+	    strcmp(token, "__get_rel_dynamic_array") == 0 ||
+	    strcmp(token, "__get_sockaddr") == 0 ||
+	    strcmp(token, "__get_sockaddr_rel") == 0) {
 		free_token(token);
 		return process_dynamic_array(event, arg, tok);
 	}
-- 
2.35.1

