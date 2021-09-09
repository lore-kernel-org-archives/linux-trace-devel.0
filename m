Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC29C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Sep 2021 13:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23397611C7
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Sep 2021 13:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355418AbhIINzb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Sep 2021 09:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356119AbhIINyY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Sep 2021 09:54:24 -0400
Received: from metanate.com (unknown [IPv6:2001:8b0:1628:5005::111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E7AC0560D5
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Sep 2021 04:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=metanate.com; s=stronger; h=Content-Transfer-Encoding:Message-Id:Date:
        Subject:Cc:To:From:Content-Type:Reply-To:Content-ID:Content-Description:
        In-Reply-To:References; bh=R6TIWkYcAfQALAg7PKFF5Ya+0Oy7Cs34bHultribBI0=; b=oj
        +qcpuYN7CHDo0rlCVmmh+VleJuq/WNI6bS4W+MWEsKCeMYLvGOjfjNwn60RLxXGX5EdzXk/0v9knz
        YkEoe21Ir8UoonbBBhmf8UCM9sGQ5goLDeUqJ6Ub6DljFnlj//Y7wwTjYaEF4vHzPCTSQPT+5GS3G
        J/RZ+PQYztH2eIvH5fLJNq2EEtQL6ZTCPqgptre4Bygqi91HZurARnXAytgqop9zmYDnvH02GzkU0
        SnifF5d0SkoCU5QBpquN2ZSaAWMDM1AJs4NMcShYdhVSApUgVUegcvCE47fLN0Zjdim0Xx60ZnJef
        KUvHPhyRTd6qVUgdmPqoWoeKZnwcoa0Q==;
Received: from [81.174.171.191] (helo=donbot.metanate.com)
        by email.metanate.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <john@metanate.com>)
        id 1mOIgW-0004tM-8E; Thu, 09 Sep 2021 12:57:40 +0100
From:   John Keeping <john@metanate.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        John Keeping <john@metanate.com>
Subject: [PATCH/RFC] tracing: make trace_marker{,_raw} stream-like
Date:   Thu,  9 Sep 2021 12:57:34 +0100
Message-Id: <20210909115734.3818711-1-john@metanate.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated: YES
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracing marker files are write-only streams with no meaningful
concept of file position.  Using stream_open() to mark them as
stream-link indicates this and has the added advantage that a single
file descriptor can now be used from multiple threads without contention
thanks to clearing FMODE_ATOMIC_POS.

Note that this has the potential to break existing userspace by since
both lseek(2) and pwrite(2) will now return ESPIPE when previously lseek
would have updated the stored offset and pwrite would have appended to
the trace.  A survey of libtracefs and several other projects found to
use trace_marker(_raw) [1][2][3] suggests that everyone limits
themselves to calling write(2) and close(2) on these file descriptors so
there is a good chance this will go unnoticed and the benefits of
reduced overhead and lock contention seem worth the risk.

[1] https://github.com/google/perfetto
[2] https://github.com/intel/media-driver/
[3] https://w1.fi/cgit/hostap/

Signed-off-by: John Keeping <john@metanate.com>
---
I'm marking this as RFC because it breaks the Prime Directive of Linux
development, as explained above.  But I'm hoping this is one of the
cases where we get away with it because this is a huge improvement for
multi-threaded programs when doing the simple thing of opening a single
trace_marker FD at startup and just writing to it from any thread.

After writing this, I realised that an alternative solution to my
original problem would have been to use pwrite instead of write!  But I
still think fixing this at the source would be better.

 kernel/trace/trace.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2dbf797aa133..251679846a1b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4834,6 +4834,12 @@ int tracing_open_generic_tr(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+static int tracing_mark_open(struct inode *inode, struct file *filp)
+{
+	stream_open(inode, filp);
+	return tracing_open_generic_tr(inode, filp);
+}
+
 static int tracing_release(struct inode *inode, struct file *file)
 {
 	struct trace_array *tr = inode->i_private;
@@ -7101,9 +7107,6 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	if (tt)
 		event_triggers_post_call(tr->trace_marker_file, tt);
 
-	if (written > 0)
-		*fpos += written;
-
 	return written;
 }
 
@@ -7162,9 +7165,6 @@ tracing_mark_raw_write(struct file *filp, const char __user *ubuf,
 
 	__buffer_unlock_commit(buffer, event);
 
-	if (written > 0)
-		*fpos += written;
-
 	return written;
 }
 
@@ -7564,16 +7564,14 @@ static const struct file_operations tracing_free_buffer_fops = {
 };
 
 static const struct file_operations tracing_mark_fops = {
-	.open		= tracing_open_generic_tr,
+	.open		= tracing_mark_open,
 	.write		= tracing_mark_write,
-	.llseek		= generic_file_llseek,
 	.release	= tracing_release_generic_tr,
 };
 
 static const struct file_operations tracing_mark_raw_fops = {
-	.open		= tracing_open_generic_tr,
+	.open		= tracing_mark_open,
 	.write		= tracing_mark_raw_write,
-	.llseek		= generic_file_llseek,
 	.release	= tracing_release_generic_tr,
 };
 
-- 
2.33.0

