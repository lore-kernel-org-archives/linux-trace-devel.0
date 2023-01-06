Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E1CC63797
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Jan 2023 18:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjAFSjj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Jan 2023 13:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjAFSjf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Jan 2023 13:39:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E837CDDA
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 10:39:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A796B81E51
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 18:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1313DC43392;
        Fri,  6 Jan 2023 18:39:32 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pDrcp-0003Ky-0C;
        Fri, 06 Jan 2023 13:39:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 05/10] trace-cmd library: Fix read_data() with error from tracefs_cpu_read()
Date:   Fri,  6 Jan 2023 13:39:25 -0500
Message-Id: <20230106183930.12565-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230106183930.12565-1-rostedt@goodmis.org>
References: <20230106183930.12565-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If tracefs_cpu_read() has an error, it will return a negative value. But the
value is then used as an index. An error check is required to make sure that
if an error is returned from tracefs_cpu_read() the function exits with that
error and does not continue further.

Fixes: 2610bdcde ("trace-cmd library: Use tracefs_cpu for recorder helpers")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-recorder.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 79b95ce1193d..db159e5e5d14 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -323,6 +323,8 @@ static long read_data(struct tracecmd_recorder *recorder)
 	long r, w;
 
 	r = tracefs_cpu_read(recorder->tcpu, buf, nonblock);
+	if (r < 0)
+		return r;
 
 	left = r;
 	do {
-- 
2.35.1

