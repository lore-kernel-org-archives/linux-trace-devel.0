Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB14CCA47A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jun 2022 02:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243804AbiFOCym (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jun 2022 22:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237203AbiFOCyl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jun 2022 22:54:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181B02FFEE
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jun 2022 19:54:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C4A5B81B3B
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Jun 2022 02:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD84C3411B;
        Wed, 15 Jun 2022 02:54:38 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1o1JAy-002Nx2-Vx;
        Tue, 14 Jun 2022 22:54:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] trace-cmd library: Fail if tracecmd_init_data() fails
Date:   Tue, 14 Jun 2022 22:54:35 -0400
Message-Id: <20220615025436.568682-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220615025436.568682-1-rostedt@goodmis.org>
References: <20220615025436.568682-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the initialization of tracecmd_init_data() fails, the processing will
continue and this can cause errors latter on that are unrelated to the
actual problem. Fail immediately instead.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 11c0057589b6..c181c7d93be4 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -5382,12 +5382,14 @@ static int copy_trace_data_from_v6(struct tracecmd_input *in_handle,
 static int copy_trace_data_from_v7(struct tracecmd_input *in_handle,
 				   struct tracecmd_output *out_handle)
 {
-	int ret = 0;
+	int ret;
 	int i;
 
 	/* Force using temporary files for trace data decompression */
 	in_handle->read_zpage = false;
-	tracecmd_init_data(in_handle);
+	ret = tracecmd_init_data(in_handle);
+	if (ret < 0)
+		return ret;
 	tracecmd_set_out_clock(out_handle, in_handle->trace_clock);
 
 	/* copy top buffer */
-- 
2.35.1

