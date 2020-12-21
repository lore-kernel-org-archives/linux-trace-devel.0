Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D79E3C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 05:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 935D322CB3
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 05:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgLUFE3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 00:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgLUFE2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 00:04:28 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C446C061248
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 21:03:48 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id q22so5771779pfk.12
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 21:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j60PLVFcCpstzSmpVqLrUwIhsEZgK+VCL6WsHn1UDY0=;
        b=mUj7ZwtKpasoVttrXfw1FKjZLaD/G99XpS40iPJBQ8DYSEwl5tlyBcZxD9PZnUnQ2m
         lf+h/hBuBI0Pyj92EKMDVKwJZWMbBnNZmR0zQ9KVXjQkbsUcXL4P5jTb+Ljz5LRPTWwu
         2zuy/9JG7FywUpdXk70YCJeCP+0fuaTcmE4cjcVIRad8lQoKaCvesbmE7PkCry1r43kG
         x/vdk20yQU2d48m3vV58FZv3sCQqSdBFSBwQhfaiulI9uc4r5OGtA3GLFHZE4mMK7ew7
         QdIQWO4n1bIYszjL9/IqiXTdOVkilX909+v5SjCra9FNkGODeb3Xa/QeAW+d/JsCuQ9w
         gPog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j60PLVFcCpstzSmpVqLrUwIhsEZgK+VCL6WsHn1UDY0=;
        b=hXU0unIyUhQDfmjg6rqsveQJS66Hm2JZkHIksG3dR6vM67M2Q50G4nahMzmU/oYUVs
         o3JQboHy5lx4is32koRr0u/Q2lvPS9vQTvkUbvJfLg1vR6Y2w1JhuKdBEoClAlJzcPYp
         myzIi1/FPcB98iLIr7elr5o8SzUp25/BNMqu2Bxa5uG/8Q9bh5/aDQITrFRqICzRWdlt
         bKY5rdJZfaQRvkyzveoMToE+2Gkaz3YBqhj3NPRYaUJIRqhv99ud8j/hhavcwoo0b4ZG
         e3MU/XzqTumm4R/FvftwzvFcITeJKivdNyZ74N5YMnKx9wZZvuDIoGZxVUdwOSNF6IKw
         m2EA==
X-Gm-Message-State: AOAM5301v1X4P/bo0pEeJvEUqkTWCZT4s8fzBod5Vzp3aZzC97lMlFFe
        xSilR4/oAIZc/GJl8SKPPWLDusKQaCRkh9aqLsmYvXs6K47TDDNi
X-Google-Smtp-Source: ABdhPJzBU7uAT5dhqZdxE44Y/PEsathSz7ez/SL5b1yLgehUGxUstTJkye1VHeUFNpaAXybRs/hrLsUIj/5VFl8Zl1g=
X-Received: by 2002:a63:405:: with SMTP id 5mr13779658pge.44.1608527027855;
 Sun, 20 Dec 2020 21:03:47 -0800 (PST)
MIME-Version: 1.0
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
 <20201217094626.1402191-4-tz.stoyanov@gmail.com> <20201218135519.2643e7cd@gandalf.local.home>
 <CAPpZLN5VZMGx9rpUktjSDFiKhOw8BUqSqdDdHOCGMF3O5c8TpA@mail.gmail.com> <20201220231011.0418e4ce@oasis.local.home>
In-Reply-To: <20201220231011.0418e4ce@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 21 Dec 2020 07:03:31 +0200
Message-ID: <CAPpZLN6QSmUR5mV36FPyEwofUGNZB7ayzBr-EB20ruJaRcp5=Q@mail.gmail.com>
Subject: Re: [PATCH 3/9] libtracefs man pages: APIs for locating trace
 directory and files.
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Dec 21, 2020 at 6:10 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 21 Dec 2020 05:44:45 +0200
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > > How should it be freed?
> > I'll add " with free()" in the next version of the patch, but I was
> > wondering if the
> > user should use "tracefs_put_tracing_file()" instead ? These APIs are not
> > consistent, may be they should be renamed.
>
> Good point.
>
> > Now we have:
> >
> >    tracefs_get_tracing_file() / tracefs_put_tracing_file()
> >    tracefs_get_tracing_dir() / returns static, must not be feed.
> >    tracefs_find_tracing_dir() / free()
>
> Perhaps we should change tracefs_get_tracing_dir() to simply:
> tracefs_tracing_dir().
>
>
> Hmm, what's the difference between "tracefs_find_tracing_dir() and
> tracefs_get_tracing_dir() (or what we will call tracefs_tracing_dir())?
>
> The only difference I see from the two descriptions is that one returns
> a cached string and the other returns just an allocated string. Do we
> even need tracefs_find_tracing_dir()?

The tracefs_find_tracing_dir() function is used in trace-cmd, but I agree that
it can be removed. I'll rename tracefs_get_tracing_dir() to
tracefs_tracing_dir()
and remove tracefs_find_tracing_dir() API. Going to change trace-cmd to use
only tracefs_tracing_dir() API.

>
> >
> >
> > >
> > > > +
> > > > +The _tracefs_get_tracing_dir()_ function returns the full path to the
> > > > +trace file system. In the first function call, the mount point of the
> > > > +tracing file system is located, cached and returned. It will mount it,
> > > > +if it is not minted. On any subsequent call the cached path is returned.
>
> Just noticed the above typo. s/minted/mounted/
>
> Although,  I wonder if a minted dir tastes good? ;-)
>
> -- Steve
>
> > > > +The return string must _not_ be freed.
> > > > +
> > > > +RETURN VALUE
> > > > +------------
> > > > +The _tracefs_get_tracing_file()_ function returns a string or NULL in case
> > > > +of an error. The returned string must be freed with _tracefs_put_tracing_file()_.
> > > > +
> > > > +The _tracefs_find_tracing_dir()_ function returns a string or NULL in case
> > > > +of an error. The returned string must be freed.
> > >
> > > Should state how it should be freed. tracefs_put_tracing_file() or free() ?
> > >
> > > If it is free(), then stating:
> > >
> > >  "The returned string must be freed with free()"
> > >
> > > is fine.
> > >
> > > > +
> > > > +The _tracefs_get_tracing_dir()_ function returns a constant string or NULL
> > > > +in case of an error. The returned string must _not_ be freed.
> > > > +
> > > > +EXAMPLE
> > > > +-------
> > > > +[source,c]
> > > > +--
> > > > +#include <tracefs.h>
> > > > +...
> > > > +char *trace_on = tracefs_get_tracing_file("tracing_on");
> > > > +     if (trace_on) {
> > > > +             ...
> > > > +             tracefs_put_tracing_file(trace_on);
> > > > +     }
> > > > +...
> > > > +char *trace_dir = tracefs_find_tracing_dir();
> > > > +     if (trace_dir) {
> > > > +             ...
> > > > +             free(trace_dir);
> > > > +     }
> > > > +...
> > > > +const char *trace_dir = tracefs_get_tracing_dir();
> > > > +
> > >
> > > Not a very useful example ;-)  We we can fix examples at a later time. I
> > > plan on writing a lot of example code to post, and some can make their way
> > > into the man pages.
> > >
> > > -- Steve
> >
> >
> >
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
