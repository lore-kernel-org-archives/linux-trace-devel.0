Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0674AC54EBD
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Jan 2023 18:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbjAFSjh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Jan 2023 13:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234327AbjAFSje (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Jan 2023 13:39:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6367DE1A
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 10:39:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4991C61F21
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 18:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344A5C433A1;
        Fri,  6 Jan 2023 18:39:32 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pDrcp-0003LI-0T;
        Fri, 06 Jan 2023 13:39:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 09/10] trace-cmd record: Set sleep_time to zero at end of recording
Date:   Fri,  6 Jan 2023 13:39:29 -0500
Message-Id: <20230106183930.12565-10-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230106183930.12565-1-rostedt@goodmis.org>
References: <20230106183930.12565-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When the recording (of trace-cmd record) or streaming (of trace-cmd stream)
is finished, set sleep_time to zero. This will cause various calls to read
the buffer to not block, as the sleep_time is used in some instances to
determine how long to wait if there's no data.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 9eb10cd8ccdf..b3614b0706de 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3164,6 +3164,8 @@ static void expand_event_list(void)
 
 static void finish(void)
 {
+	sleep_time = 0;
+
 	/* all done */
 	if (recorder)
 		tracecmd_stop_recording(recorder);
-- 
2.35.1

