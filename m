Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D55BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jun 2022 23:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346114AbiFOXG7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 Jun 2022 19:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346086AbiFOXG7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Jun 2022 19:06:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A00124BD9
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Jun 2022 16:06:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FD85B81FDF
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Jun 2022 23:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFA7C3411A;
        Wed, 15 Jun 2022 23:06:55 +0000 (UTC)
Date:   Wed, 15 Jun 2022 19:06:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2]  trace-cmd record: Verify that splice works before using
 it
Message-ID: <20220615190653.559ad605@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a test to make sure that splice works on the source directory before
using it, and if not automatically switch over to read/write method.

Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213659
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/linux-trace-devel/20220608130527.26e50cba@gandalf.local.home
   - Found that my email client messed with the formatting.
     This is just the same patch but should now actually apply.

 lib/trace-cmd/trace-recorder.c | 38 ++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index c83337899098..c7ef13c851d2 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -220,6 +220,41 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 	return NULL;
 }
 
+static void verify_splice(const char *file, unsigned *flags)
+{
+	int brass[2];
+	int ret;
+	int fd;
+
+	fd = open(file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (fd < 0)
+		return; /* Will fail by the caller too */
+
+	if (pipe(brass) < 0)
+		goto fail_pipe;
+
+	ret = splice(brass[0], NULL, fd, NULL, 0, SPLICE_F_NONBLOCK);
+	if (ret < 0)
+		goto fail_splice;
+
+ out_pipe:
+	close(brass[0]);
+	close(brass[1]);
+ out:
+	close(fd);
+	return;
+
+ fail_pipe:
+	tracecmd_warning("Failed opening pipe, trying read/write");
+	*flags |= TRACECMD_RECORD_NOSPLICE;
+	goto out;
+
+ fail_splice:
+	tracecmd_warning("Failed splice to file, trying read/write");
+	*flags |= TRACECMD_RECORD_NOSPLICE;
+	goto out_pipe;
+}
+
 struct tracecmd_recorder *
 tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, const char *buffer)
 {
@@ -233,6 +268,9 @@ __tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
 	struct tracecmd_recorder *recorder;
 	int fd;
 
+	if (!(flags & TRACECMD_RECORD_NOSPLICE))
+		verify_splice(file, &flags);
+
 	fd = open(file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
 	if (fd < 0)
 		return NULL;
-- 
2.35.1

