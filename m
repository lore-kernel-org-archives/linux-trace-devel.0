Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9555C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 03:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240168AbiBVDnh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:43:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240180AbiBVDng (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 22:43:36 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B412D24BF4
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 19:43:12 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id t4-20020a17090a3b4400b001bc40b548f9so1108163pjf.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 19:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a0/1QSPFpm6kiR9R+hCjeya6y9U6DM35VnspBBPlZ28=;
        b=D+k3uVIBERitPjMQkCIzGso0kzhP3xSBRu1r5Q4TcUkknQzc6bd7nRG6xrdEWhxnGx
         zLVLhNdxKq2VtVV289VqiFCalSTeqvPDImxO+eX3rJbEyzBjNaNR54B05ZBVy7txNkjX
         +thLkb32NlICVeSDZAA3gfLe4LCsNaceobw8f8TYMd/G5ZN2yrmK7j37WHEziOMJrEjG
         CAOAX3j/Nm7cJ7xnrp8Df8juU/sKZUsWUCwO0Bi1iJ31TXj57VRc6Yx5Pkp4zn0o4VuX
         KQhUaVcF0vc5sYW/r98dCGxmXGEMxl2uI443DyQyZwXasd11wqXAhtFoKk/Ns6mMijqr
         921Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a0/1QSPFpm6kiR9R+hCjeya6y9U6DM35VnspBBPlZ28=;
        b=ORHTzNtw2wwCH0xiXmr8E23nAPZZ43HV7DUV5gC3pq4BgjcgeFvwQM54BFkjxXKTlp
         UTJW1T+qVQvHNcxprroWcYkFOtaF4PuSUdM5sXFS/AHC+7jyY8lZBI0LoSerwvjjY8ux
         PTNxItncX6hnyFmIVgZqTPgH4zHIaqEOHqhWE0dc0ffXpQXM5hMEfKMswHhoe03wvPxz
         d65HjXGy1gSECyQEkKljjqobWBmH5TcsFIyvKEVwhosR/eZBtJhEYeNYL+mwB20dwJrb
         8N+tIxlv3aSMDnHpawBzeDIJyV6LhdMmsluM7khJ+yXgAko4F57flA5T3ukH1fLeFMy3
         oX9g==
X-Gm-Message-State: AOAM533ygFwKOHs8VFYU6HFeO0vaefGWYxnuGLJFO+iIaIhc1ujMZbwk
        aSHwkz8BKYGVfRdNYywr+VoI4FblxXdm8aNd4P+xqkwvyts=
X-Google-Smtp-Source: ABdhPJx50Z28D6+lvVbXn8LK9aMictG4amvFgNH8c0l86OTAc5Ya7V+1G7+7cMxhSk3Oh3rpr970483BwcXFnkMshbM=
X-Received: by 2002:a17:90a:ca06:b0:1bc:650b:a30d with SMTP id
 x6-20020a17090aca0600b001bc650ba30dmr2059831pjt.96.1645501392280; Mon, 21 Feb
 2022 19:43:12 -0800 (PST)
MIME-Version: 1.0
References: <20220219230151.56282-1-sebastian@breakpoint.cc>
 <20220219230151.56282-2-sebastian@breakpoint.cc> <CAPpZLN7_xM7rp_C7KGjed-8W4nt+Yn0XiN8mpwVGLjgCboTmhQ@mail.gmail.com>
 <YhOZsr0TN+NkV3cU@breakpoint.cc>
In-Reply-To: <YhOZsr0TN+NkV3cU@breakpoint.cc>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 22 Feb 2022 05:42:56 +0200
Message-ID: <CAPpZLN5pB-6fdF5Cw3x=N0GMLx0UL8kLB=ApoJa3iqBqJkSopQ@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd library: Add ZSTD support.
To:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Feb 21, 2022 at 3:55 PM Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
>
[ ... ]
> > > +int tracecmd_zstd_init(void)
> > > +{
> > > +       int ret = 0;
> > > +       size_t r;
> > > +
> > > +       ctx_c = ZSTD_createCCtx();
> > > +       ctx_d = ZSTD_createDCtx();
> > > +       if (!ctx_c || !ctx_d)
> > > +               goto err;
> > > +
> > > +       r = ZSTD_CCtx_setParameter(ctx_c, ZSTD_c_contentSizeFlag, 0);
> > > +       if (ZSTD_isError(r))
> > > +               goto err;
> > > +
> > > +       ret = tracecmd_compress_proto_register(__ZSTD_NAME,
> > > +                                              ZSTD_versionString(),
> > > +                                              __ZSTD_WEIGTH,
> > > +                                              zstd_compress,
> > > +                                              zstd_decompress,
> > > +                                              zstd_compress_bound,
> > > +                                              zstd_is_supported);
> >
> > I think tracecmd_compress_proto_register() should be extend  with two new hooks:
> >     void *(*new_context)(void),
> >     void (*free_context)(void *),
> > and ctx_c,  ctx_d should be allocated and freed there. Currently, that
> > logic in trace-cmd is in a single thread. That may change in the
> > future, and then the current design will be a limitation.
>
> I would suggest to use
>
> struct tracecmd_compress_algo {
>         const char *name,
>         const char *version,
>         int weight,
>         func_t *compress;
>         func_t *decompress;
>         func_t *bound;
>         func_t *supported;
> };
>
> and then
>         ret = tracecmd_compress_proto_register(&comp_algo);
>
> so that the function has less args and can be extended without touching
> every algo.

We prefer to use explicit API arguments, to ensure that on API's
change the old callers of the API will be updated. Using such
structure is more flexible, but even though in most cases the change
will be backward compatible - it could be hard to debug the legacy
code in case the API's behaviour changes because of adding some new
parameter in the structure.

>
> As for func_t / calling convetion I would prefer something that is not
> that close to zlib. Like
>
>         int comp(void *ctx, const void *src, signed int in_size,
>                  void *dst, signed int out_size);
>
> This clearly limits the sizes to 31 bit (with the 40kiB probably okay)
> and the return value can be either >= 0 returning the number of bytes
> produced or negative for an error. And please no errno touching ;)
>

I like the idea to make these hooks more generic, not so close to a
specific library. But there should be some error reporting mechanism,
why not to use errno ? In the best case, the library itself should set
the errno. But zlib has its own error codes, and according to its
documentation not all of the APIs set errno in case of an error.
That's why I added this explicit setting of errno in case of some
Z_ERROR.

Are you interested to submit a patch with these suggestions ? I also
can do it, when Steven merges zstd support and before the next
trace-cmd release.

> Sebastian

--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
