Return-Path: <SRS0=pI6O=2G=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD14C43603
	for <linux-trace-devel@archiver.kernel.org>; Mon, 16 Dec 2019 16:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49D69206EC
	for <linux-trace-devel@archiver.kernel.org>; Mon, 16 Dec 2019 16:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfLPQFm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 16 Dec 2019 11:05:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbfLPQFl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 11:05:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E332B2067C;
        Mon, 16 Dec 2019 16:05:40 +0000 (UTC)
Date:   Mon, 16 Dec 2019 11:05:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Tom Zanussi' <zanussi@kernel.org>,
        Sven Schnelle <svens@stackframe.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ftrace histogram sorting broken on BE architecures
Message-ID: <20191216110539.2b268d86@gandalf.local.home>
In-Reply-To: <4805b40c3e1547f8a26eeac6932f6499@AcuMS.aculab.com>
References: <20191211123316.GD12147@stackframe.org>
        <20191211103557.7bed6928@gandalf.local.home>
        <20191211110959.2baeb70f@gandalf.local.home>
        <1576178241.3309.2.camel@kernel.org>
        <4805b40c3e1547f8a26eeac6932f6499@AcuMS.aculab.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 16 Dec 2019 15:47:12 +0000
David Laight <David.Laight@ACULAB.COM> wrote:

> > From: Tom Zanussi
> > Sent: 12 December 2019 19:17
> > On Wed, 2019-12-11 at 11:09 -0500, Steven Rostedt wrote:  
> > > On Wed, 11 Dec 2019 10:35:57 -0500
> > > Steven Rostedt <rostedt@goodmis.org> wrote:
> > >  
> > > > > Any thoughts on how to fix this? I'm not sure whether i fully
> > > > > understand the
> > > > > ftrace maps... ;-)  
> > > >
> > > > Your analysis makes sense. I'll take a deeper look at it.  
> > >
> > > Sven,
> > >
> > > Does this patch fix it for you?
> > >
> > > Tom,
> > >
> > > Correct me if I'm wrong, from what I can tell, all sums and keys are
> > > u64 unless they are a string. Thus, I believe this patch should not
> > > have any issues.  
> ...
> > > --- a/kernel/trace/tracing_map.c
> > > +++ b/kernel/trace/tracing_map.c
> > > @@ -148,8 +148,8 @@ static int tracing_map_cmp_atomic64(void *val_a,
> > > void *val_b)
> > >  #define DEFINE_TRACING_MAP_CMP_FN(type) 	\
> > >  static int tracing_map_cmp_##type(void *val_a, void *val_b) \
> > >  { \
> > > -	type a = *(type *)val_a; \
> > > -	type b = *(type *)val_b; \
> > > +	type a = (type)(*(u64 *)val_a); 	\
> > > +	type b = (type)(*(u64 *)val_b); 	\
> > > \
> > >  	return (a > b) ? 1 : ((a < b) ? -1 : 0); \
> > >  }  
> 
> That looks so horrid/wrong it can't be right on both BE and LE.

Well, the original is obviously not right for both BE and LE, but the
fix is:

	type a = (type)(*(u64 *)val_a);

Which breaks down to:

		(u64 *)val_a - make val_a a pointer to a u64 number

all values were written as u64.

	u64 data = (u64)original_val_a

Where original_val_a could be a byte, short, int, long or long long.

Now that we have (u64 *)val_a, we dereference it:

		*(u64 *)val_a - which gives us a u64 number.

This u64 number should be the same as the u64 data.

Then we convert this as:

		(type)(*(u64 *)val_a)

Taking the u64 number we retrieved and converted it back to the
original type that was recorded.

In other words, if the following should work:


	type a = x;
	u64 data = (u64)a;
	u64 *ptr = &data;
	u64 b_data = *ptr;
	type b = (type)b_data;

If b == a above, then there should be nothing wrong with this patch.

The compiler should know how to map those type conversions properly for
both BE and LE.

-- Steve
