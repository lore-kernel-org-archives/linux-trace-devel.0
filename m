Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A59C7EE2F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jun 2023 01:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240121AbjFGB15 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 21:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234897AbjFGB1y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 21:27:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FCB1981
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Jun 2023 18:27:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E78986302B
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jun 2023 01:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B28C433EF
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jun 2023 01:27:51 +0000 (UTC)
Date:   Tue, 6 Jun 2023 21:27:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: Fix memory leaks of followers
Message-ID: <20230606212750.1abd4a1d@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

While running valgrind to test the new attach command, it discovered that
the follow strings in the handle were never freed. Free them.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 865721ae50b6..145c02eeb718 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4942,6 +4942,8 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle->trace_clock);
 	free(handle->strings);
 	free(handle->version);
+	free(handle->followers);
+	free(handle->missed_followers);
 	trace_guest_map_free(handle->map);
 	close(handle->fd);
 	free(handle->latz.chunks);
-- 
2.39.2

