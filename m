Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21FECC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 10:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0699861164
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 10:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244925AbhIXKw7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 06:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244877AbhIXKw6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 06:52:58 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AC4C061574;
        Fri, 24 Sep 2021 03:51:25 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id v22so33694913edd.11;
        Fri, 24 Sep 2021 03:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+twz7xKPCaRunuTxRINFpzWiUTbchcGRYSuBzbIOSmo=;
        b=HY31ST0y+HiXEYCTwV1rZkRHKeNqguq/BX9aJcwou20huoO3PJyFoPuTgEuMcMgXSM
         SAE/EpmQSU8BJmEdq6H3M/UC7gWZoWQE9/w5QRjuUJ4S8pyAh3/bMceOLHt3udN3LswF
         T++X9g8ozweHwA27lNKiHcyRgLBo5FIqvzo7o22ykVO7pq0KgViQ6yYYchTNG02hNRHd
         6yD/4ET+irP8nOQJLCkz8iER2zRmFbngWfGRCELMOu4x7Rd77lPEh7Q9mu050+cUlkOz
         u1gvC3QxH9LzvLf9d0cuVOrkmtxPDGmKcX9iCTE2LB/29M28Ky82y+iwLLanii3VGBxI
         kc1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+twz7xKPCaRunuTxRINFpzWiUTbchcGRYSuBzbIOSmo=;
        b=jWrmatQZQA8dEAjtiST2Eh4B0Dl0pTndWMvK9+HTZqpzj684qT70JHuTqutE5Y/94F
         nW9FjfssuPdY50tzY/hf3xOanrBpshwEm5LK2LLr/6DIdMxiERIU5EPfKn/sFGlzTLRD
         NAmYdFoYktVi7jgy+3RG+iqRiy7fFqMjpws90x/6QW92b77G3vb4eTTRR2p6clZlgW9F
         rAWveRDcFkzXC1spb5JCRDkRZZgYIA7UyUjN5rJSj1oeMZPgnfkx+u0ApWB7TgTfNFR+
         C+BjLQppmA2/H5NdX4bEBcwFuMCOMXPyYnGb/F2NGMu513OU7SaL/q1hhIyL8EuO/uiA
         C97g==
X-Gm-Message-State: AOAM533NN7gSAkpUHuF3lQG7j0USWBdpcWVPlcqnr30zO8UNl1P+wBOH
        241mdal/vRUmwbjiItoId/kxWAo4PbV+IW1+ocHVQ2Zf
X-Google-Smtp-Source: ABdhPJw/XN8LzCFhJbsRtkJPqhNDeBOIWif89XJ+aXSnIudxvRfqx3R2olJRXxcT2tVKTMt0eHRH6doICE3Tvb0fsEg=
X-Received: by 2002:a17:906:4544:: with SMTP id s4mr10553731ejq.102.1632480683787;
 Fri, 24 Sep 2021 03:51:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210924033547.939554938@goodmis.org> <20210924000717.310b492a@rorschach.local.home>
In-Reply-To: <20210924000717.310b492a@rorschach.local.home>
From:   Eugene Syromyatnikov <evgsyr@gmail.com>
Date:   Fri, 24 Sep 2021 12:51:07 +0200
Message-ID: <CACGkJdtsHWBstw_Gzb-Dq4Xs_eAW1jsARr5wbh0yE_=NsPA5bw@mail.gmail.com>
Subject: Re: [PATCH 0/2] tracing: Have trace_pid_list be a sparse array
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Sep 24, 2021 at 6:07 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 23 Sep 2021 23:35:47 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > The pid_mask will start out with 1024 entries for the first 10 MSB bits.
> > This will cost 4K for 32 bit architectures and 8K for 64 bit. Each of
> > these will have a 1024 array to store the next 10 bits of the pid (another
> > 4 or 8K). These will hold an 512 byte bitmask (which will cover the LSB 12
> >   bits or 4096 bits).
>
> Thinking about this more, I should adjust this split.
>
> Currently, this is a 10,10,12 split, but since the upper chunks are
> arrays of pointers, and the lower chunk is a bitmask, and that pids
> tend to be close together, I should make the lower split bigger.
>
> As a 4K page is 32768 bits (2^15), the lower split should be 15 bits,
> not 12. This will probably allocate better.
>
> Of course 32 - 15 is 17. So maybe to keep it simple, by having the two
> upper chunks still the same in size, I could have it be 14 bits for the
> lower (2048 bytes). And since pid_max can only be 2^30, we don't even
> need to cover the full 32 bits.
>
> 30 - 14 = 16 = 8 * 2.
>
> Then I can make the upper chunks cover 8 bits (arrays of 256 pointers)
> and the lower chunks cove 14 bits. This would coincidentally make all
> chunks 2K in size (on 64 bit machines).
>
> Hmm, in that case, I can make the lower and upper chunks use the same
> memory and not separate them. They are unions after all. But that may
> be unfair for 32 bit machines, as the upper chunks are only going to be
> 1K in size for them (256 * 4).

Note that there is only one top-level chunk (so its size doesn't
matter much), (usually) about one middle-tier chunk (except for some
heavy cases, since pids are allocated linearly), and quite some
lower-tier bitset leaves.  So I'd optimise towards smaller leaves at
the expense of middle-tier (and especially top-tier) chunk size
(especially considering the fact that in the kernel, buddy allocator
is used), like 12-8-12 or something like that, but I have no factual
basis for arguing about specific split.  Also, I cannot resist from
noticing that this reminds me an awful lot of XArray and [1].  Maybe,
some wrapper around XArray would do?

[1] https://gitlab.com/strace/strace/-/raw/master/src/trie.h

>
> -- Steve
>



--
Eugene Syromyatnikov
mailto:evgsyr@gmail.com
xmpp:esyr@jabber.{ru|org}
