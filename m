Return-Path: <SRS0=kCFW=WZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE80C3A59F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 13:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B64E215EA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 13:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfH2NSU convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Aug 2019 09:18:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfH2NST (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Aug 2019 09:18:19 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 475D3215EA;
        Thu, 29 Aug 2019 13:18:18 +0000 (UTC)
Date:   Thu, 29 Aug 2019 09:18:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] kernel-shark: Increase the size of the task hash
Message-ID: <20190829091816.0a695576@gandalf.local.home>
In-Reply-To: <b651e39a-6f32-fe59-36bf-224cad5bc649@gmail.com>
References: <20190828140016.3ce1be4f@gandalf.local.home>
        <b651e39a-6f32-fe59-36bf-224cad5bc649@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Aug 2019 15:46:24 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> On 28.08.19 г. 21:00 ч., Steven Rostedt wrote:
> > From: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > 
> > When loading a data file that contained 100,000s of tasks, using a 256
> > bucket size hash crippled it. By increasing the hash to 2^16 (65536) it
> > solves the issue (still small enough not to waste too much memory).
> > 
> > In the process, I changed the knuth_hash() in libkshark.c to use the 32
> > bit version and just have the key use what it needs:  
> 
> If the size the hash table is 65536 then the multiplicative hashing 
> function has to multiply the key by a prime number which is closer to 
> 65536 / 1.61803398875 (the so called "golden ratio" of the size).
> It makes no sense to multiply by a number that is several orders of 
> magnitude bigger than the size of the hash table.

Does it really matter?

> 
> > 
> >    key = knuth_hash();
> >    key += knuth_hash >> SHIFT;
> >    key &= (1 << SHIFT) - 1;
> > 
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > ---
> > diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
> > index 4201fa02..41572e18 100644
> > --- a/kernel-shark/src/libkshark.c
> > +++ b/kernel-shark/src/libkshark.c
> > @@ -252,19 +252,19 @@ void kshark_free(struct kshark_context *kshark_ctx)
> >   	free(kshark_ctx);
> >   }
> >   
> > -static inline uint8_t knuth_hash(uint32_t val)
> > +static inline uint32_t knuth_hash(uint32_t val)
> >   {
> >   	/*
> > -	 * Small table hashing function adapted from Donald E. Knuth's 32 bit
> > +	 * Hashing function adapted from Donald E. Knuth's 32 bit
> >   	 * multiplicative hash.  See The Art of Computer Programming (TAOCP).
> >   	 * Multiplication by the Prime number, closest to the golden ratio of
> > -	 * 2^8.
> > +	 * 2^32.
> >   	 */
> > -	return UINT8_C(val) * UINT8_C(157);
> > +	return val * UINT32_C(2654435761);  
> 
> So according to my understanding of the idea in the book, this line 
> should look look this:
> 
> 	return UINT16_C(val) * UINT8_16(65537);

The reason I did it the way I did, was to decouple the hashing
algorithm from the size of the hash. If you notice, if I find the size
too big, or too small, I can make a single modification (change
TASK_HASH_SHIFT to any other number less than 32), and the algorithm
still works.

I'm not tied to this solution, and since you will be maintaining this
code, I have no problem implementing it the way you suggest. I just
wanted to state that by doing so, it binds the size of the hash table
with the entire algorithm, and modifications to the number of buckets
in the hash will be more difficult to maintain.

It does not need to be perfect, and in practice, the one I proposed
worked quite well. Remember, perfection is the enemy of good enough ;-)

> 
> and you do not need to do any additional manipulation of the key (PID).
> Also the function has to return uint16_t.

I see no reason it has to return uint16_t.

-- Steve

> 
> Thanks!
> Yordan
> 
> >   }
> >   
> >   static struct kshark_task_list *
> > -kshark_find_task(struct kshark_context *kshark_ctx, uint8_t key, int pid)
> > +kshark_find_task(struct kshark_context *kshark_ctx, uint32_t key, int pid)
> >   {
> >   	struct kshark_task_list *list;
> >   
> > @@ -280,9 +280,12 @@ static struct kshark_task_list *
> >   kshark_add_task(struct kshark_context *kshark_ctx, int pid)
> >   {
> >   	struct kshark_task_list *list;
> > -	uint8_t key;
> > +	uint32_t key;
> >   
> >   	key = knuth_hash(pid);
> > +	key += key >> KS_TASK_HASH_SHIFT;
> > +	key &= (1 << KS_TASK_HASH_SHIFT) - 1;
> > +
> >   	list = kshark_find_task(kshark_ctx, key, pid);
> >   	if (list)
> >   		return list;
> > diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
> > index 04e9cbfc..3407db19 100644
> > --- a/kernel-shark/src/libkshark.h
> > +++ b/kernel-shark/src/libkshark.h
> > @@ -72,7 +72,8 @@ struct kshark_entry {
> >   };
> >   
> >   /** Size of the task's hash table. */
> > -#define KS_TASK_HASH_SIZE 256
> > +#define KS_TASK_HASH_SHIFT 16
> > +#define KS_TASK_HASH_SIZE (1 << KS_TASK_HASH_SHIFT)
> >   
> >   /** Linked list of tasks. */
> >   struct kshark_task_list {
> >   

