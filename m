Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D50C07E9B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Jul 2021 01:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 387B661175
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Jul 2021 01:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhGUA2i (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Jul 2021 20:28:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhGUA2Z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Jul 2021 20:28:25 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95A06610F7;
        Wed, 21 Jul 2021 01:09:02 +0000 (UTC)
Date:   Tue, 20 Jul 2021 21:08:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linuxfoundation.org>
Cc:     Haoran Luo <www@aegistudio.net>, Ingo Molnar <mingo@redhat.com>,
        linux-trace-devel@vger.kernel.org,
        Security Officers <security@kernel.org>
Subject: Re: [PATCH 1/1] tracing: fix bug in rb_per_cpu_empty() that might
 cause deadloop.
Message-ID: <20210720210855.6fdf1190@oasis.local.home>
In-Reply-To: <CAHk-=wgFVAtZy9sc98nqujuEh-HqDW5WBvc+MAzobvphY8vZog@mail.gmail.com>
References: <YPaNxsIlb2yjSi5Y@aegistudio>
 <CAHk-=wgFVAtZy9sc98nqujuEh-HqDW5WBvc+MAzobvphY8vZog@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 20 Jul 2021 11:35:56 -0700
Linus Torvalds <torvalds@linuxfoundation.org> wrote:

> On Tue, Jul 20, 2021 at 2:04 AM Haoran Luo <www@aegistudio.net> wrote:
> >
> >         return reader->read == rb_page_commit(reader) &&
> >                 (commit == reader ||
> >                  (commit == head &&
> > -                 head->read == rb_page_commit(commit)));
> > +                 (rb_page_commit(commit) == 0 ||
> > +                  head->read == rb_page_commit(commit))));
> >  }  
> 
> Can we please re-write that whole thing to be legible?
> 
> That conditional was complicated before. It's worse now.

I agree. I always cringe when I write code like this. For some reason,
I write code I dislike over adding multiple returns. Not sure why I do
that. Probably some childhood trauma.

I'll add the comments below, as it looks correct.

> 
> For example, just splitting it up would help:
> 

	/*
	 * If what has been read on the reader page is not equal
	 * to the content on the reader page, then there's more
	 * data (not empty).
	 */

>         if (reader->read != rb_page_commit(reader))
>                 return false;
> 

	/*
	 * The last thing written is on the reader page, and the above
	 * statement already shows everything written was read.
	 * (empty buffer)
	 */

>         if (commit == reader)
>                 return true;
> 

	/*
	 * The last page written does not equal the last page read,
	 * thus there's more data (not empty).
	 */

>         if (commit != head)
>                 return false;
> 

So, looking at this, I see that the bug is not here. head->read should
never be non-zero. The issue is that we missed resetting "read" to zero
before adding it back to the ring buffer.


>         return !rb_page_commit(commit) ||
>                 commit->read == rb_page_commit(commit);

Really, the original code worked because head->read is expected to be
zero. And looking at the code more, it should even work with:

	/*
	 * With the commit == head page (tail == head), and nothing on
	 * the commit page there's nothing in the buffer.
	 */
	if (!rb_page_commit(commit))
		return true;

> 
> but adding comments to each conditional case would also be good.
> 
> Note: I checked "head->read" to "commit->read" in that last
> conditional, because we had _just_ verified that "commit" and "head"
> are the same, and it seems to be more logical to check "commit->read"
> with "rb_page_commit(commit)".

I believe I kept it as "head" to re-enforce that the two are the same.


> 
> (And somebody should check that I split it right - I'm just doing this
> in the MUA without knowing the code: I hate conditionals that are
> cross multiple lines like this, and I hate them particularly when they
> turn out to be buggy, so when you fix a complex conditional, that's a
> BIG sign to me that the problem was that the conditional was too
> complex to begin with).
> 
> Btw, that "rb_page_commit()" forces a new atomic read each time, so
> the "rb_page_commit(commit)" value should probably be cached as a
> variable before it's used twice.
> 

Well, the double read of rb_page_commit() is not needed as the bug is
that read is non zero. And I'm not sure this patch even fixes the bug,
because read is not updated when commit is, thus read is some random
number that could cause this to return a false positive. "read" needed
to be reset when the page was added back to the ring buffer, and it
appears that it was missed (ever though all the other fields were reset).

Although this patch is wrong, I'm not against a clean up patch to make
the code easier to read.

I think the real fix is below (not even compiled tested).

-- Steve

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d1463eac11a3..0b9ce927e95f 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4445,6 +4445,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	local_set(&cpu_buffer->reader_page->write, 0);
 	local_set(&cpu_buffer->reader_page->entries, 0);
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
+	cpu_buffer->reader_page->read = 0;
 	cpu_buffer->reader_page->real_end = 0;
 
  spin:
