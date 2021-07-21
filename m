Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D80C07E9B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Jul 2021 02:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65A71608FC
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Jul 2021 02:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhGUCJH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Jul 2021 22:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231325AbhGUCI0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Jul 2021 22:08:26 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 344F0610F7;
        Wed, 21 Jul 2021 02:49:03 +0000 (UTC)
Date:   Tue, 20 Jul 2021 22:48:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     contact me <www@aegistudio.net>
Cc:     "Linus Torvalds" <torvalds@linuxfoundation.org>,
        "Ingo Molnar" <mingo@redhat.com>,
        "linux-trace-devel" <linux-trace-devel@vger.kernel.org>,
        "Security Officers" <security@kernel.org>
Subject: Re: [PATCH 1/1] tracing: fix bug in rb_per_cpu_empty() that might
 cause deadloop.
Message-ID: <20210720224856.7a19cf40@oasis.local.home>
In-Reply-To: <17ac6d675f2.129c41f20168460.6720846023977971963@aegistudio.net>
References: <YPaNxsIlb2yjSi5Y@aegistudio>
        <CAHk-=wgFVAtZy9sc98nqujuEh-HqDW5WBvc+MAzobvphY8vZog@mail.gmail.com>
        <20210720210855.6fdf1190@oasis.local.home>
        <17ac6d675f2.129c41f20168460.6720846023977971963@aegistudio.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 21 Jul 2021 10:13:01 +0800
contact me <www@aegistudio.net> wrote:

> I'll have a try and tell you the result. But I've seen the code written on

Thanks.

> 
> https://github.com/torvalds/linux/blob/2734d6c1b1a089fb593ef6a23d4b70903526fe0c/kernel/trace/ring_buffer.c#L4513
> 	cpu_buffer->reader_page->read = 0;

Yeah, that clears the "read" for the reader page after it gets swapped
out of the writers buffer, and before the reader gets to it.

> 
> I though the algorithm is to reset the reader_page->read when it swaps with the
> head page. And following the original algorithm the read field of a buffer page 
> should be either 0 or its original value when the content to read exhaust. So I
> added an extra conditional to ensure that.

Actually, we could just change it to ignore read as well, and that
could be the fix.

Basically, the bug is that we use that "read" field that's in the
writer's buffer (the main ring buffer outside the reader page), and it
has stale data.

So we either need to clear the "read" before placing it back into the
writer's buffer (which my patch does). Or we can simply ignore it,
which would change your patch to:

 	return reader->read == rb_page_commit(reader) &&
 		(commit == reader ||
 		 (commit == head &&
-		  head->read == rb_page_commit(commit)));
+		  (rb_page_commit(commit) == 0)));
 }

In which case, you can send me that patch with the cleanup that Linus
suggested, and my commenting.

-- Steve

