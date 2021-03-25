Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA75FC433C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 07:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B01B61A25
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 07:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhCYHuz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 03:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhCYHub (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 03:50:31 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A9AC06174A
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 00:50:31 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id h3so1154919pfr.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 00:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KCv0w7clNNpX5XmbC9ShZXOL14/ky5E8DTyuZ7JagpI=;
        b=inokGcAx5GrnrUiY2HzpOkYVSYoCfe9LpnHJ8jWM8yz8LkZBohO5hEF7+1ffZFgJ3R
         dJYI0MDcvT3QbtUlrLo0aWZt+YWyOjXBeup2fZegNVg1gDRU5Iwts6iPuaKu22UrL5hu
         /Jkfnd1/v2w4Hroa2b8QHGM9zRJlzkLnSZM7jOn0Vsga4a8zsLMKuCy3TvP5kezHI9k3
         xCH6YjibT448UcMqWIGXhItM/xVH20QDCUabo7nGibsTyCrmz3eSJ9/Fm+0GgV4gyCCP
         +723VgHuoYrL0Q3ww10gt0J7rfOZrnEKHdfQ8QUH2mTFoujpWfI/SK4Ok1eno4exb1er
         kjWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KCv0w7clNNpX5XmbC9ShZXOL14/ky5E8DTyuZ7JagpI=;
        b=PSJNKLAMOa4SEW+aH6bmQBfhFEow0r9a2zfGjxhuoX0axCbGluNyViCJCRApgxsA1C
         VrFB1XkjvOeE3cYGS7811M6wRs6q48EMCuHcHGAH7DPWqULK8A1rBML+iQ7r4rbFSqHc
         Aqrjth0Is3G2txQvUlyDOadOjZ4Q+eWddL63iYr2G9uT/wtk8QTW/RZ1heVZ1V72Qyvq
         wf683ViRByj1mrLK+ysi2pAArMMQVghHN0204yzgkySUhKzSd+PXH4yFVkAL+iN0M9LZ
         Db/qFWgbuwLz6/Kur/PI9k8psDLv22M2zC1CZeDovoW+9CxHh7h1EXy96sWfX9XQinKp
         rzDA==
X-Gm-Message-State: AOAM531QrtdlAnLvlBxM2BNg/45jFU6gluvlRqC8dnHe8Zu4NSJwbF6y
        LdsogiFuTa7xAI19LyTO3SDRbdFWSSVmzY4IO7MJPQndHXGUYw==
X-Google-Smtp-Source: ABdhPJxOSr1XdgTG48uhhbu0q/Bkqh59+y2tISgHH1YK2EfXcu6mThKIWl4MN9KFZpS2sTIqXowywkcyfdIp/gh5GIk=
X-Received: by 2002:a65:6209:: with SMTP id d9mr6546405pgv.206.1616658630954;
 Thu, 25 Mar 2021 00:50:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210324135143.445443-1-tz.stoyanov@gmail.com> <20210324175309.4e154757@gandalf.local.home>
In-Reply-To: <20210324175309.4e154757@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 25 Mar 2021 09:50:14 +0200
Message-ID: <CAPpZLN4CWSZoPkezk7QYNSDLGm4vjNOYHE2gv4Jx=xhJbAdeow@mail.gmail.com>
Subject: Re: [PATCH v2] trace-cmd: Remove all die()s from trace-cmd library
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Mar 24, 2021 at 11:53 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 24 Mar 2021 15:51:43 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > @@ -366,36 +366,32 @@ void __noreturn __vdie(const char *fmt, va_list ap)
> >       vfprintf(stderr, fmt, ap);
> >
> >       fprintf(stderr, "\n");
> > -     exit(ret);
> > +     return ret;
> >  }
> >
> > -void __noreturn __die(const char *fmt, ...)
> > +#ifdef LIB_DIE
>
> I wonder if it would be more useful not to have it as a compile time
> define, but instead a global variable:
>
> static bool lib_die;
>
> void tracecmd_die_on_error(void)
> {
>         lib_die = true;
> }
>

There is tracecmd_set_debug() API already, It can be used to trigger
that die() logic. It makes sense for the library to do a real die()
when running in debug mode, if a fatal error is encountered.

> Make the "die()" functions into static variables here.
>
> void __hidden _lib_fatal(const char *fmt, ...)
> {
>         va_list ap;
>
>         va_start(ap, fmt);
>         if (lib_die)
>                 __vdie(fmt, ap);
>         else
>                 __vwarning(fmt, ap);
>         va_end(ap);
> }
>
> That way if we run trace-cmd with the --debug option, it could then call
> the tracecmd_die_on_error() function, and it will crash on any "fatal"
> places.
>
> -- Steve
>
>
> > +
> > +void __noreturn _lib_fatal(const char *fmt, ...)
> >  {
> >       va_list ap;
> > +     int ret;
> >
> >       va_start(ap, fmt);
> > -     __vdie(fmt, ap);
> > +     ret = __vlib_fatal(fmt, ap);
> >       va_end(ap);
> > +     exit(ret);
> >  }
> >
> > -void __weak __noreturn die(const char *fmt, ...)
> > +#else
> > +void _lib_fatal(const char *fmt, ...)
> >  {
> >       va_list ap;
> >
> >       va_start(ap, fmt);
> > -     __vdie(fmt, ap);
> > +     __vlib_fatal(fmt, ap);
> >       va_end(ap);
> >  }
> > -
> > -void __weak *malloc_or_die(unsigned int size)
> > -{
> > -     void *data;
> > -
> > -     data = malloc(size);
> > -     if (!data)
> > -             die("malloc");
> > -     return data;
> > -}
> > +#endif
> >



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
