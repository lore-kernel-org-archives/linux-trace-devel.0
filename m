Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C85CC12002
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Jul 2021 14:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED33961246
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Jul 2021 14:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbhGUNcR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Jul 2021 09:32:17 -0400
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21427 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbhGUNcR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Jul 2021 09:32:17 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1626876742; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=d+S5Jg7pDaCsgGR0cdTUpeCa2JDom6PWq8bbZU7jZ007MaeHCXF9pZlIiiGPSZgxvU2+H3rU/dJS8XsfKFBhIehBvD5Q89vVtcYVmp+IMxSFHcCDa6r16Z7XsBE9HyLVrRoG+vAowDow3xBKy1k1calYPfOK9cHClN4NUbvXMBU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1626876742; h=Content-Type:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=627CTDguG2J86UWYWrzPPnXYUcpqqIUAanukatyu3SM=; 
        b=FUXwT4U0QWKp70E3CggrQVx4eDOcgp1ugk5bdLLs2B7Bwe7UVkaVEq5F54jcwrRwUhYyPPmIKnfltoxDUkWl+In2kYx916zlfbAyI6E4XMH5t7L3g7Bg/IRRG3iVp9ksj1XT5fnpei2OgR5nGm1VqKjC+1DC1FsCzm4269Rw5Ag=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=www@aegistudio.net;
        dmarc=pass header.from=<www@aegistudio.net>
Received: from aegistudio (124.160.216.48 [124.160.216.48]) by mx.zohomail.com
        with SMTPS id 1626876739156808.5311746954301; Wed, 21 Jul 2021 07:12:19 -0700 (PDT)
Date:   Wed, 21 Jul 2021 14:12:07 +0000
From:   Haoran Luo <www@aegistudio.net>
To:     rostedt@goodmis.org, mingo@redhat.com
Cc:     www@aegistudio.net, linux-trace-devel@vger.kernel.org,
        security@kernel.org
Subject: [PATCH v3 1/1] tracing: fix bug in rb_per_cpu_empty() that might
 cause deadloop.
Message-ID: <YPgrN85WL9VyrZ55@aegistudio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "rb_per_cpu_empty()" misinterpret the condition (as not-empty) when
"head_page" and "commit_page" of "struct ring_buffer_per_cpu" points to
the same buffer page, whose "buffer_data_page" is empty and "read" field
is non-zero.

An error scenario could be constructed as followed (kernel perspective):

1. All pages in the buffer has been accessed by reader(s) so that all of
them will have non-zero "read" field.

2. Read and clear all buffer pages so that "rb_num_of_entries()" will
return 0 rendering there's no more data to read. It is also required
that the "read_page", "commit_page" and "tail_page" points to the same
page, while "head_page" is the next page of them.

3. Invoke "ring_buffer_lock_reserve()" with large enough "length"
so that it shot pass the end of current tail buffer page. Now the
"head_page", "commit_page" and "tail_page" points to the same page.

4. Discard current event with "ring_buffer_discard_commit()", so that
"head_page", "commit_page" and "tail_page" points to a page whose buffer
data page is now empty.

When the error scenario has been constructed, "tracing_read_pipe" will
be trapped inside a deadloop: "trace_empty()" returns 0 since
"rb_per_cpu_empty()" returns 0 when it hits the CPU containing such
constructed ring buffer. Then "trace_find_next_entry_inc()" always
return NULL since "rb_num_of_entries()" reports there's no more entry
to read. Finally "trace_seq_to_user()" returns "-EBUSY" spanking
"tracing_read_pipe" back to the start of the "waitagain" loop.

I've also written a proof-of-concept script to construct the scenario
and trigger the bug automatically, you can use it to trace and validate
my reasoning above:

  https://github.com/aegistudio/RingBufferDetonator.git

Tests has been carried out on linux kernel 5.14-rc2
(2734d6c1b1a089fb593ef6a23d4b70903526fe0c), my fixed version
of kernel (for testing whether my update fixes the bug) and
some older kernels (for range of affected kernels). Test result is
also attached to the proof-of-concept repository.

Signed-off-by: Haoran Luo <www@aegistudio.net>
---
 kernel/trace/ring_buffer.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d1463eac11a3..e592d1df6f88 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3880,10 +3880,30 @@ static bool rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
 	if (unlikely(!head))
 		return true;
 
-	return reader->read == rb_page_commit(reader) &&
-		(commit == reader ||
-		 (commit == head &&
-		  head->read == rb_page_commit(commit)));
+	/* Reader should exhaust content in reader page */
+	if (reader->read != rb_page_commit(reader))
+		return false;
+
+	/*
+	 * If writers are committing on the reader page, knowing all
+	 * committed content has been read, the ring buffer is empty.
+	 */
+	if (commit == reader)
+		return true;
+
+	/*
+	 * If writers are committing on a page other than reader page
+	 * and head page, there should always be content to read.
+	 */
+	if (commit != head)
+		return false;
+
+	/*
+	 * Writers are committing on the head page, we just need
+	 * to care about there're committed data, and the reader will
+	 * swap reader page with head page when it is to read data.
+	 */
+	return rb_page_commit(commit) == 0;
 }
 
 /**
-- 
2.30.2

