Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE4F0C07E9B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Jul 2021 02:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAF5A61178
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Jul 2021 02:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhGUBdc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Jul 2021 21:33:32 -0400
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21440 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbhGUBd0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Jul 2021 21:33:26 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1626833587; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=apGRv2nfALLUdS5l/1DxUivi3S0eNDI5vlmrZBQzgnd8NWA4uzVhiEFJ9kEsCeFYX8BkBk6DRHNqmR1MkX6v4SpEdQU2v3o8IRF9CcmSdy2wGWoOZgDj3G0d7IEzj3DBSXn347B5emhgMYkbTJW8+JeLaWUx4A2FX1R3jgxTuqM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1626833587; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=m6FcGbismNygfnM2gPJUsh5dkr+XynZmuKg9HH+Azak=; 
        b=LhMNC13J9M+2wqs8A+jf6YPFn2UYygMLVsi4/l+ut2EpA/idQdzT+xARmrHtNI4BGJU+KzHPgBsa0yymxgViPEu4lXcTOSUzvI+udh2SYcaae49otx60kgdMknpRCib2TPhao5YLClBov/912SZZtygCdsLoYS7rd72q+KToB2o=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=www@aegistudio.net;
        dmarc=pass header.from=<www@aegistudio.net>
Received: from mail.zoho.com by mx.zohomail.com
        with SMTP id 1626833581580246.27937065921674; Tue, 20 Jul 2021 19:13:01 -0700 (PDT)
Date:   Wed, 21 Jul 2021 10:13:01 +0800
From:   contact me <www@aegistudio.net>
To:     "Steven Rostedt" <rostedt@goodmis.org>
Cc:     "Linus Torvalds" <torvalds@linuxfoundation.org>,
        "Ingo Molnar" <mingo@redhat.com>,
        "linux-trace-devel" <linux-trace-devel@vger.kernel.org>,
        "Security Officers" <security@kernel.org>
Message-ID: <17ac6d675f2.129c41f20168460.6720846023977971963@aegistudio.net>
In-Reply-To: <20210720210855.6fdf1190@oasis.local.home>
References: <YPaNxsIlb2yjSi5Y@aegistudio>
 <CAHk-=wgFVAtZy9sc98nqujuEh-HqDW5WBvc+MAzobvphY8vZog@mail.gmail.com> <20210720210855.6fdf1190@oasis.local.home>
Subject: Re: [PATCH 1/1] tracing: fix bug in rb_per_cpu_empty() that might
 cause deadloop.
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 21 Jul 2021 09:08:55 +0800 Steven Rostedt <rostedt@goodmis.org> wrote:
 > On Tue, 20 Jul 2021 11:35:56 -0700 
 > Linus Torvalds <torvalds@linuxfoundation.org> wrote: 
 >  
 > > On Tue, Jul 20, 2021 at 2:04 AM Haoran Luo <www@aegistudio.net> wrote: 
 > > > 
 > > >         return reader->read == rb_page_commit(reader) && 
 > > >                 (commit == reader || 
 > > >                  (commit == head && 
 > > > -                 head->read == rb_page_commit(commit))); 
 > > > +                 (rb_page_commit(commit) == 0 || 
 > > > +                  head->read == rb_page_commit(commit)))); 
 > > >  } 
 > > 
 > > Can we please re-write that whole thing to be legible? 
 > > 
 > > That conditional was complicated before. It's worse now. 
 >  
 > I agree. I always cringe when I write code like this. For some reason, 
 > I write code I dislike over adding multiple returns. Not sure why I do 
 > that. Probably some childhood trauma. 
 >  
 > I'll add the comments below, as it looks correct. 
 >  
 > > 
 > > For example, just splitting it up would help: 
 > > 
 >  
 >     /* 
 >      * If what has been read on the reader page is not equal 
 >      * to the content on the reader page, then there's more 
 >      * data (not empty). 
 >      */ 
 >  
 > >         if (reader->read != rb_page_commit(reader)) 
 > >                 return false; 
 > > 
 >  
 >     /* 
 >      * The last thing written is on the reader page, and the above 
 >      * statement already shows everything written was read. 
 >      * (empty buffer) 
 >      */ 
 >  
 > >         if (commit == reader) 
 > >                 return true; 
 > > 
 >  
 >     /* 
 >      * The last page written does not equal the last page read, 
 >      * thus there's more data (not empty). 
 >      */ 
 >  
 > >         if (commit != head) 
 > >                 return false; 
 > > 
 >  
 > So, looking at this, I see that the bug is not here. head->read should 
 > never be non-zero. The issue is that we missed resetting "read" to zero 
 > before adding it back to the ring buffer. 
 >  
 >  
 > >         return !rb_page_commit(commit) || 
 > >                 commit->read == rb_page_commit(commit); 
 >  
 > Really, the original code worked because head->read is expected to be 
 > zero. And looking at the code more, it should even work with: 
 >  
 >     /* 
 >      * With the commit == head page (tail == head), and nothing on 
 >      * the commit page there's nothing in the buffer. 
 >      */ 
 >     if (!rb_page_commit(commit)) 
 >         return true; 
 >  
 > > 
 > > but adding comments to each conditional case would also be good. 
 > > 
 > > Note: I checked "head->read" to "commit->read" in that last 
 > > conditional, because we had _just_ verified that "commit" and "head" 
 > > are the same, and it seems to be more logical to check "commit->read" 
 > > with "rb_page_commit(commit)". 
 >  
 > I believe I kept it as "head" to re-enforce that the two are the same. 
 >  
 >  
 > > 
 > > (And somebody should check that I split it right - I'm just doing this 
 > > in the MUA without knowing the code: I hate conditionals that are 
 > > cross multiple lines like this, and I hate them particularly when they 
 > > turn out to be buggy, so when you fix a complex conditional, that's a 
 > > BIG sign to me that the problem was that the conditional was too 
 > > complex to begin with). 
 > > 
 > > Btw, that "rb_page_commit()" forces a new atomic read each time, so 
 > > the "rb_page_commit(commit)" value should probably be cached as a 
 > > variable before it's used twice. 
 > > 
 >  
 > Well, the double read of rb_page_commit() is not needed as the bug is 
 > that read is non zero. And I'm not sure this patch even fixes the bug, 
 > because read is not updated when commit is, thus read is some random 
 > number that could cause this to return a false positive. "read" needed 
 > to be reset when the page was added back to the ring buffer, and it 
 > appears that it was missed (ever though all the other fields were reset). 
 >  
 > Although this patch is wrong, I'm not against a clean up patch to make 
 > the code easier to read. 
 >  
 > I think the real fix is below (not even compiled tested). 
 >  
 > -- Steve 
 >  
 > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c 
 > index d1463eac11a3..0b9ce927e95f 100644 
 > --- a/kernel/trace/ring_buffer.c 
 > +++ b/kernel/trace/ring_buffer.c 
 > @@ -4445,6 +4445,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer) 
 >      local_set(&cpu_buffer->reader_page->write, 0); 
 >      local_set(&cpu_buffer->reader_page->entries, 0); 
 >      local_set(&cpu_buffer->reader_page->page->commit, 0); 
 > +    cpu_buffer->reader_page->read = 0; 
 >      cpu_buffer->reader_page->real_end = 0; 
 >  
 >  spin: 
 > 

I'll have a try and tell you the result. But I've seen the code written on

https://github.com/torvalds/linux/blob/2734d6c1b1a089fb593ef6a23d4b70903526fe0c/kernel/trace/ring_buffer.c#L4513
	cpu_buffer->reader_page->read = 0;

I though the algorithm is to reset the reader_page->read when it swaps with the
head page. And following the original algorithm the read field of a buffer page 
should be either 0 or its original value when the content to read exhaust. So I
added an extra conditional to ensure that.
