Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D51C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 03:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiBVDx4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:53:56 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiBVDx4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 22:53:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E572BB17
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 19:53:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A629261518
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 03:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D39C340E8;
        Tue, 22 Feb 2022 03:53:27 +0000 (UTC)
Date:   Mon, 21 Feb 2022 22:53:26 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd library: Add ZSTD support.
Message-ID: <20220221225326.09e68ca9@yoga.local.home>
In-Reply-To: <CAPpZLN5pB-6fdF5Cw3x=N0GMLx0UL8kLB=ApoJa3iqBqJkSopQ@mail.gmail.com>
References: <20220219230151.56282-1-sebastian@breakpoint.cc>
        <20220219230151.56282-2-sebastian@breakpoint.cc>
        <CAPpZLN7_xM7rp_C7KGjed-8W4nt+Yn0XiN8mpwVGLjgCboTmhQ@mail.gmail.com>
        <YhOZsr0TN+NkV3cU@breakpoint.cc>
        <CAPpZLN5pB-6fdF5Cw3x=N0GMLx0UL8kLB=ApoJa3iqBqJkSopQ@mail.gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 22 Feb 2022 05:42:56 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
> > >
> > > I think tracecmd_compress_proto_register() should be extend  with
> > > two new hooks: void *(*new_context)(void),
> > >     void (*free_context)(void *),
> > > and ctx_c,  ctx_d should be allocated and freed there. Currently,
> > > that logic in trace-cmd is in a single thread. That may change in
> > > the future, and then the current design will be a limitation.  
> >
> > I would suggest to use
> >
> > struct tracecmd_compress_algo {
> >         const char *name,
> >         const char *version,
> >         int weight,
> >         func_t *compress;
> >         func_t *decompress;
> >         func_t *bound;
> >         func_t *supported;
> > };
> >
> > and then
> >         ret = tracecmd_compress_proto_register(&comp_algo);
> >
> > so that the function has less args and can be extended without
> > touching every algo.  
> 
> We prefer to use explicit API arguments, to ensure that on API's
> change the old callers of the API will be updated. Using such
> structure is more flexible, but even though in most cases the change
> will be backward compatible - it could be hard to debug the legacy
> code in case the API's behaviour changes because of adding some new
> parameter in the structure.

The way this is done in the kernel interface (aka. system calls) is to
pass a structure along with the size. That is, the API will know which
version of the API is being called by the size of the structure.

Anything new will have to be appended to the structure, which will
increase it. If the library receives a structure of a smaller size, but
one that was once supported, it could use that information to just do
the old method. In other words, only use the fields of a structure that
fit into the size given.

> 
> >
> > As for func_t / calling convetion I would prefer something that is
> > not that close to zlib. Like
> >
> >         int comp(void *ctx, const void *src, signed int in_size,
> >                  void *dst, signed int out_size);
> >
> > This clearly limits the sizes to 31 bit (with the 40kiB probably
> > okay) and the return value can be either >= 0 returning the number
> > of bytes produced or negative for an error. And please no errno
> > touching ;) 

Oh, we are always touching errno ;-)

> 
> I like the idea to make these hooks more generic, not so close to a
> specific library. But there should be some error reporting mechanism,
> why not to use errno ? In the best case, the library itself should set
> the errno. But zlib has its own error codes, and according to its
> documentation not all of the APIs set errno in case of an error.
> That's why I added this explicit setting of errno in case of some
> Z_ERROR.
> 
> Are you interested to submit a patch with these suggestions ? I also
> can do it, when Steven merges zstd support and before the next
> trace-cmd release.

I'm hoping to get everything merged this week, but probably will not
release trace-cmd until next week. I'm still sorting out the libraries.
But I'm hoping that they are almost done.

-- Steve
