Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D47C6377D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 08:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29D096127C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 08:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhGVHkT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Jul 2021 03:40:19 -0400
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21475 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhGVHkS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Jul 2021 03:40:18 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1626942024; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=erz8wX6c4XXQid9XMm/R0qKqP3BPlklowjzuSf3OVWYYSTmemTo+3HTTE39dxA8P//qKdf5B7kwlp/DSdymwMLPMZ5FlzA5ozwUWFesJKSIonPxPe+93pepwkQ6xVymYOV6a9IMNqos4D95Xla0x7GQSuaNskHO2VEmyEKRUjSQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1626942024; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=tY0cxrD0fgrcTULdV4hsCTBlRgslbY22LkT+QZOYEio=; 
        b=S0IrjUudXl4Wd1THT7Awhkj3f/1BZPjbCLCWhIfj2UTAEeYyKQBrqZuEX1884/pPck5HPIJ9M86qszQoMLaGZslm4pfvQSTZtfjadUel4sBacr01yZ1HRovLO3n5Y6uMfaS+pfLOypbXO2r769eTqHmV0zkwszmfvNk6uA68TG0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=www@aegistudio.net;
        dmarc=pass header.from=<www@aegistudio.net>
Received: from mail.zoho.com by mx.zohomail.com
        with SMTP id 1626942018743530.1633422303678; Thu, 22 Jul 2021 01:20:18 -0700 (PDT)
Date:   Thu, 22 Jul 2021 16:20:18 +0800
From:   Haoran Luo <www@aegistudio.net>
To:     "Haoran Luo" <www@aegistudio.net>
Cc:     "rostedt" <rostedt@goodmis.org>, "mingo" <mingo@redhat.com>,
        "linux-trace-devel" <linux-trace-devel@vger.kernel.org>,
        "security" <security@kernel.org>
Message-ID: <17acd4d149d.104a6dc15126082.6584458652825480326@aegistudio.net>
In-Reply-To: <YPgrN85WL9VyrZ55@aegistudio>
References: <YPgrN85WL9VyrZ55@aegistudio>
Subject: Re: [PATCH v3 1/1] tracing: fix bug in rb_per_cpu_empty() that
 might cause deadloop.
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 21 Jul 2021 22:12:07 +0800 Haoran Luo <www@aegistudio.net> wrote:
 > The "rb_per_cpu_empty()" misinterpret the condition (as not-empty) when 
 > "head_page" and "commit_page" of "struct ring_buffer_per_cpu" points to 
 > the same buffer page, whose "buffer_data_page" is empty and "read" field 
 > is non-zero. 
 >  
 > An error scenario could be constructed as followed (kernel perspective): 
 >  
 > 1. All pages in the buffer has been accessed by reader(s) so that all of 
 > them will have non-zero "read" field. 
 >  
 > 2. Read and clear all buffer pages so that "rb_num_of_entries()" will 
 > return 0 rendering there's no more data to read. It is also required 
 > that the "read_page", "commit_page" and "tail_page" points to the same 
 > page, while "head_page" is the next page of them. 
 >  
 > 3. Invoke "ring_buffer_lock_reserve()" with large enough "length" 
 > so that it shot pass the end of current tail buffer page. Now the 
 > "head_page", "commit_page" and "tail_page" points to the same page. 
 >  
 > 4. Discard current event with "ring_buffer_discard_commit()", so that 
 > "head_page", "commit_page" and "tail_page" points to a page whose buffer 
 > data page is now empty. 
 >  
 > When the error scenario has been constructed, "tracing_read_pipe" will 
 > be trapped inside a deadloop: "trace_empty()" returns 0 since 
 > "rb_per_cpu_empty()" returns 0 when it hits the CPU containing such 
 > constructed ring buffer. Then "trace_find_next_entry_inc()" always 
 > return NULL since "rb_num_of_entries()" reports there's no more entry 
 > to read. Finally "trace_seq_to_user()" returns "-EBUSY" spanking 
 > "tracing_read_pipe" back to the start of the "waitagain" loop. 
 >  
 > I've also written a proof-of-concept script to construct the scenario 
 > and trigger the bug automatically, you can use it to trace and validate 
 > my reasoning above: 
 >  
 >  https://github.com/aegistudio/RingBufferDetonator.git 
 >  
 > Tests has been carried out on linux kernel 5.14-rc2 
 > (2734d6c1b1a089fb593ef6a23d4b70903526fe0c), my fixed version 
 > of kernel (for testing whether my update fixes the bug) and 
 > some older kernels (for range of affected kernels). Test result is 
 > also attached to the proof-of-concept repository. 
 >  
 > Signed-off-by: Haoran Luo <www@aegistudio.net> 
 > --- 
 >  kernel/trace/ring_buffer.c | 28 ++++++++++++++++++++++++---- 
 >  1 file changed, 24 insertions(+), 4 deletions(-) 
 >  
 > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c 
 > index d1463eac11a3..e592d1df6f88 100644 
 > --- a/kernel/trace/ring_buffer.c 
 > +++ b/kernel/trace/ring_buffer.c 
 > @@ -3880,10 +3880,30 @@ static bool rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer) 
 >      if (unlikely(!head)) 
 >          return true; 
 >  
 > -    return reader->read == rb_page_commit(reader) && 
 > -        (commit == reader || 
 > -         (commit == head && 
 > -          head->read == rb_page_commit(commit))); 
 > +    /* Reader should exhaust content in reader page */ 
 > +    if (reader->read != rb_page_commit(reader)) 
 > +        return false; 
 > + 
 > +    /* 
 > +     * If writers are committing on the reader page, knowing all 
 > +     * committed content has been read, the ring buffer is empty. 
 > +     */ 
 > +    if (commit == reader) 
 > +        return true; 
 > + 
 > +    /* 
 > +     * If writers are committing on a page other than reader page 
 > +     * and head page, there should always be content to read. 
 > +     */ 
 > +    if (commit != head) 
 > +        return false; 
 > + 
 > +    /* 
 > +     * Writers are committing on the head page, we just need 
 > +     * to care about there're committed data, and the reader will 
 > +     * swap reader page with head page when it is to read data. 
 > +     */ 
 > +    return rb_page_commit(commit) == 0; 
 >  } 
 >  
 >  /** 
 > -- 
 > 2.30.2 
 >  
 > 

(It's embarrassing to be Mr.Contact due to my wrong configuration in
my email hosting when I replies, and I've corrected now.)

Allow me to explain some of my comprehension and thought.

I've submitted the initial version of this bugfix and got some feedback from
Torvalds and Steven. We've done some discussion from which I've made
up my rationale for this patch:

1. Steven has pointed out that this bug is caused by not clearing "read"
field of a buffer page after releasing it back to the writers' ring buffer. This
will cause "rb_per_cpu_empty()" to read a stale value of "read" (in the writers'
buffer) and cause a bug. Steven also offers a patch clearing out the "read"
field to zero.

2. Steven also points out that "rb_page_commit(commit) == head->read"
conditional might also produces false positive result when the newly
committed event is just the same size as "head->read".

3. The "rb_get_reader_page()" is responsible for swapping reader page and
with head page. Before putting the reader page back to the ring buffer for
writers to write, the reader will clear out writer related fields, including the
commit of buffer data page.

4. The "rb_get_reader_page()" fetches a newer reader page and clears the
"read" field when more data is available.

5. Performing #1 ensures "read" field to be zeroed when a buffer page
becomes buffer page again, this should also eliminate false positive
mentioned in #2. So I think #1 should be a working fix.

6. However, setting "read" to zero is not necessary. Based on #3, atomic
"commit" field which is fetched by "rb_page_commit()" should be a working
indicator for buffer pages' availability to read. Based on #4, (I think) the reader
should only care about "read" field of an obtained reader page, not a page
inside the writer buffer.

7. Based on #6, when the reader has exhausted data in the reader page, and
writers are currently committing on head page, "rb_per_cpu_empty()" should
only care about whether there's content on head page. And comparing
"rb_page_commit(commit) == 0" should do the work. The conditional
"rb_page_commit(commit) == head->read" requiring invariable that "read" is
0 when it is placed back to writers' buffer seems to create a coupling between
"head->read" and "0" for me, and the ring buffer should perform an extra
clear (when placing back buffer page) and read (when fetching "head->read"
in "rb_per_cpu_empty()"). I think just fetching "rb_page_commit(commit)"
and compare it with immediate "0" comes more direct for me.

The core concept of mine is #7 and all other items above are for who subscribes
to the "linux-trace-devel" mail list but not so understand what is happening in
ring buffer algorithm. The bugfix shouldn't be encrypted protocol establish between
Torvalds, Steven and me, but explained to and accepted by community. (Again,
this is my personal opinion, nothing canonical and might be completely wrong,
so accept or reject with your own judgement.)

I owes Steven in the progression of the bugfix: he points out that comparing
"head->read == rb_page_commit(commit)" is unnecessary when
"rb_page_commit(commit) == 0" is present, and confirms some details of ring
buffer with me. He also gives me some hints and advise for commenting and
formatting the code. Without him, I can't write a reasonable bugfix or form
the rationale above.

Pardon me again for my poor English, and thank you for reading such verbose
explanation of mine.

Haoran
