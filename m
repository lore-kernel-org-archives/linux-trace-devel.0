Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D486AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 15:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376309AbiDDPWd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 11:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378167AbiDDPWb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 11:22:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C743C4A6
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 08:20:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7522D615F3
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 15:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9B9C340EE
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 15:20:32 +0000 (UTC)
Date:   Mon, 4 Apr 2022 11:20:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: Write buffer option in
 out_write_cpu_data()
Message-ID: <20220404112031.61506913@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When putting together the tracing files for trace-cmd restore, the call to
out_write_cpu_data() does not write the final options that added the
buffer data, and it is not able to be read.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-output.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index f3a203ec347f..ca7132e113c0 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2526,6 +2526,9 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 
 	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
 
+	if (HAS_SECTIONS(handle))
+		tracecmd_write_options(handle);
+
 	return 0;
 
  out_free:
-- 
2.35.1

