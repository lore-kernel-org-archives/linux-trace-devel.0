Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1434DC07E95
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Jul 2021 09:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDC7E6120D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Jul 2021 09:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbhGTI2H (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Jul 2021 04:28:07 -0400
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21485 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235590AbhGTIYg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Jul 2021 04:24:36 -0400
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jul 2021 04:24:36 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1626770933; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=aIBPaT48rDM3NOtUuh9ALouktaxYOKIq3iabUUbh/BYETx4a4DNUJ83TVAR/DuEYzXklq2cjuZ/4BeNXIMhkuRAD5s/yFH+M3619k1xqOWYg1TiqjC+1Y7E3/25iVQc3ZaTHb1dEC8FGTQVt9BfSvrVIdhWISNN/KSCQYm6gjUM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1626770933; h=Content-Type:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=1avyemSFjWrJp1QuFiua700xaNBkOSaePnKbcmoo1KU=; 
        b=lHlQU8wtEr7XvxnH0b9Ao5W442T+xUu/DGR4Q828VuUL/2AAflXl7HtsdPNwvrGP4Lyo+o+hc6ARgg1pPptTYeykSbnJMsURjUsmxCFexlnSPSSDlR7GB8+7YpTinaeHRhsjOC6YZjWlluacKuQqvOoPARrcd3vlkJNPZv4DDss=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=www@aegistudio.net;
        dmarc=pass header.from=<www@aegistudio.net>
Received: from aegistudio (125.119.77.199 [125.119.77.199]) by mx.zohomail.com
        with SMTPS id 1626770930804975.4596574966488; Tue, 20 Jul 2021 01:48:50 -0700 (PDT)
Date:   Tue, 20 Jul 2021 08:48:44 +0000
From:   Haoran Luo <www@aegistudio.net>
To:     rostedt@goodmis.org, mingo@redhat.com
Cc:     Haoran Luo <www@aegistudio.net>, linux-trace-devel@vger.kernel.org,
        security@kernel.org
Subject: [PATCH 1/1] tracing: fix bug in rb_per_cpu_empty() that might cause
 deadloop.
Message-ID: <YPaNxsIlb2yjSi5Y@aegistudio>
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
 kernel/trace/ring_buffer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d1463eac11a3..00446a501742 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3883,7 +3883,8 @@ static bool rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
 	return reader->read == rb_page_commit(reader) &&
 		(commit == reader ||
 		 (commit == head &&
-		  head->read == rb_page_commit(commit)));
+		  (rb_page_commit(commit) == 0 ||
+		   head->read == rb_page_commit(commit))));
 }
 
 /**
-- 
2.30.2

