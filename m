Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A630C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 20:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238654AbiKOUxc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 15:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238597AbiKOUxO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 15:53:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120963135C
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 12:53:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91CFE61A2A
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 20:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0914CC433D7;
        Tue, 15 Nov 2022 20:53:12 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ov2wO-00ApFU-0L;
        Tue, 15 Nov 2022 15:53:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/4] trace-cmd: Only show unit test output when -v is supplied
Date:   Tue, 15 Nov 2022 15:53:53 -0500
Message-Id: <20221115205355.2580214-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221115205355.2580214-1-rostedt@goodmis.org>
References: <20221115205355.2580214-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The "Use libraries to read file" test shows the output of the reading of
the trace.dat file. That should only happen if the '-v' option is
supplied, otherwise, it should be muted.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracecmd-utest.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
index e45b3537365c..2ec3f7118690 100644
--- a/utest/tracecmd-utest.c
+++ b/utest/tracecmd-utest.c
@@ -264,7 +264,8 @@ static int read_events(struct tracecmd_input *handle, struct tep_record *record,
 	tep_print_event(tep, seq, record, "%s-%d %s %s\n",
 			TEP_PRINT_COMM, TEP_PRINT_PID,
 			TEP_PRINT_NAME, TEP_PRINT_INFO);
-	trace_seq_do_printf(seq);
+	if (show_output)
+		trace_seq_do_printf(seq);
 	return 0;
 }
 
-- 
2.35.1

