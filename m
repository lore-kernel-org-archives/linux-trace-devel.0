Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C65DC43334
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Jul 2022 18:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiGVS2K (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Jul 2022 14:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236308AbiGVS2J (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Jul 2022 14:28:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C793A99675
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Jul 2022 11:28:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 276B4622BC
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Jul 2022 18:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B52DC341C6
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Jul 2022 18:28:05 +0000 (UTC)
Date:   Fri, 22 Jul 2022 14:28:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Set the long size of the tep handle in
 tracefs_local_events_system()
Message-ID: <20220722142803.24919c8a@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

While writing a workshop on using libtracefs, I found that it was
embarrassing that tracefs_local_events() does not set it, and failed some
parsing that relies on it. (tracefs_local_events() simply calls
tracefs_local_events_system() where the fix needs to be added).

Set the long size of the event using:

  tep_set_long_size(tep, tep_get_header_page_size(tep))

(oh, and that tep_get_header_page_size() is HORRIBLY misnamed!!!)

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-events.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 65d5707362c6..86395101c96a 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -969,6 +969,9 @@ struct tep_handle *tracefs_local_events_system(const char *tracing_dir,
 		tep = NULL;
 	}
 
+	/* Set the long size for this tep handle */
+	tep_set_long_size(tep, tep_get_header_page_size(tep));
+
 	return tep;
 }
 
-- 
2.35.1

