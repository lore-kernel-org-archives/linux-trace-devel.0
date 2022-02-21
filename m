Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E47C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Feb 2022 13:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240587AbiBUNzY convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 08:55:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377126AbiBUNzX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 08:55:23 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E471CDE9D
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 05:55:00 -0800 (PST)
Received: from bigeasy by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1nM99W-0000y9-I0; Mon, 21 Feb 2022 14:54:58 +0100
Date:   Mon, 21 Feb 2022 14:54:58 +0100
From:   Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] trace-cmd library: Add ZSTD support.
Message-ID: <YhOZsr0TN+NkV3cU@breakpoint.cc>
References: <20220219230151.56282-1-sebastian@breakpoint.cc>
 <20220219230151.56282-2-sebastian@breakpoint.cc>
 <CAPpZLN7_xM7rp_C7KGjed-8W4nt+Yn0XiN8mpwVGLjgCboTmhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAPpZLN7_xM7rp_C7KGjed-8W4nt+Yn0XiN8mpwVGLjgCboTmhQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2022-02-21 08:08:51 [+0200], Tzvetomir Stoyanov wrote:
> On Sun, Feb 20, 2022 at 1:02 AM Sebastian Andrzej Siewior
> <sebastian@breakpoint.cc> wrote:
> >
> 
> Hi Sebastian,
Hi Tzvetomir,

> Thank you for contributing zstd support for trace-cmd! The zlib was
> chosen for the PoC implementation of the trace file compression
> support, as it is one of the widely available compression libraries.
> But as you have already seen, the design allows easily adding multiple
> compression algorithms. Support for a new compression library is less
> than 100 lines of code, that's why I suggest to keep the zlib support
> - even though the default will be zstd.

Oki.

> > The zstd support is using the context aware function so there is no need
> > to for the library to allocate one (including the memory) for every
> > invocation. This requires to be used in a single threaded environment or
> > the API needs to be extended to pass the context parameter.
> 
> Good point, the current design is according to zlib - that's why there
> is no context. But I like the idea to have a library specific context
> and this should be added now, before the first release.

cool.

> >
> > In most cases the input buffer was 40KiB so it does not make sense to
> > use higher compression levels. Higher compression levels won't
> > significantly improve the compression ration given that the every 40KiB
> > block is independent. However higher compression levels will slow down
> > the compression process.
> >
> 
> By default, the buffer is 10 system pages - so it could be larger on
> some systems.

Just a hint that if we increase the buffer size then the compression
would benefit from it ;)

> > diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
> > index 48f179d6f524a..8601a15f86f22 100644
> > --- a/lib/trace-cmd/include/trace-cmd-local.h
> > +++ b/lib/trace-cmd/include/trace-cmd-local.h
> > @@ -30,6 +30,10 @@ void tracecmd_info(const char *fmt, ...);
> >  int tracecmd_zlib_init(void);
> >  #endif
> >
> > +#ifdef HAVE_ZLIB
> 
> I think you mean HAVE_ZSTD here.

Yeah, fixed in v2, thanks.

> > diff --git a/lib/trace-cmd/trace-compress-zstd.c b/lib/trace-cmd/trace-compress-zstd.c
> > new file mode 100644
> > index 0000000000000..fc5e350f32509
> > --- /dev/null
> > +++ b/lib/trace-cmd/trace-compress-zstd.c
…
> > +int tracecmd_zstd_init(void)
> > +{
> > +       int ret = 0;
> > +       size_t r;
> > +
> > +       ctx_c = ZSTD_createCCtx();
> > +       ctx_d = ZSTD_createDCtx();
> > +       if (!ctx_c || !ctx_d)
> > +               goto err;
> > +
> > +       r = ZSTD_CCtx_setParameter(ctx_c, ZSTD_c_contentSizeFlag, 0);
> > +       if (ZSTD_isError(r))
> > +               goto err;
> > +
> > +       ret = tracecmd_compress_proto_register(__ZSTD_NAME,
> > +                                              ZSTD_versionString(),
> > +                                              __ZSTD_WEIGTH,
> > +                                              zstd_compress,
> > +                                              zstd_decompress,
> > +                                              zstd_compress_bound,
> > +                                              zstd_is_supported);
> 
> I think tracecmd_compress_proto_register() should be extend  with two new hooks:
>     void *(*new_context)(void),
>     void (*free_context)(void *),
> and ctx_c,  ctx_d should be allocated and freed there. Currently, that
> logic in trace-cmd is in a single thread. That may change in the
> future, and then the current design will be a limitation.

I would suggest to use

struct tracecmd_compress_algo {
	const char *name,
	const char *version,
	int weight,
	func_t *compress;
	func_t *decompress;
	func_t *bound;
	func_t *supported;
};

and then
	ret = tracecmd_compress_proto_register(&comp_algo);

so that the function has less args and can be extended without touching
every algo.

As for func_t / calling convetion I would prefer something that is not
that close to zlib. Like

	int comp(void *ctx, const void *src, signed int in_size,
		 void *dst, signed int out_size);

This clearly limits the sizes to 31 bit (with the 40kiB probably okay)
and the return value can be either >= 0 returning the number of bytes
produced or negative for an error. And please no errno touching ;)

Sebastian
