Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2867AC3527B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 21:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379590AbiDDV3w (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379697AbiDDRya (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 13:54:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CB8245BD
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 10:52:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4546B81065
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 17:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE60C2BBE4;
        Mon,  4 Apr 2022 17:52:30 +0000 (UTC)
Date:   Mon, 4 Apr 2022 13:52:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH] libtracefs: Add uprobes man page example into samples
Message-ID: <20220404135229.33bdd854@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the code in the tracefs_uprobes man pages to be built into the samples
directory.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/Makefile b/samples/Makefile
index f03aff6c9ba8..97a570d6c956 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -11,6 +11,7 @@ EXAMPLES :=
 EXAMPLES += dynevents
 EXAMPLES += kprobes
 EXAMPLES += eprobes
+EXAMPLES += uprobes
 EXAMPLES += synth
 EXAMPLES += error
 EXAMPLES += filter
-- 
2.35.1

