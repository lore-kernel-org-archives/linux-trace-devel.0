Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99791C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 15:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68F9E61984
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 15:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhCVPjY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 11:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhCVPjU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 11:39:20 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065E2C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 08:39:20 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ha17so8680837pjb.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 08:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U8GsdptcwfHoQGaXWqtkKwyQzX5g0RQJXAszGOZZqgw=;
        b=ihKC5cdlc5MCexo+P2/RhVkgFdaIzpPakwlHLPIpSERiEEhu8uubPj9xTjHGE3aFqe
         8wWPplmKsqZw1RBjAu9TFkWMocNF6cXm3WJ2j6w1HGGqloZRQ784bHcyPydlT8vXiGmk
         U+a6oiY/T+FimS27A53iSpsfmlGwWsW8yISLVkxogNOipwFOryBRlnp8SO3AFnNwRLHM
         ccw5FyMCoPPUUbICw3Sh8P4b9jC+NgK/FYlfQCZ+Bq0jAZLs9knvle6Yx3tqm2GMVSGs
         uzYYKIZwJQitHJGCHtmwMcD9Yp6ymRPNDjumYPcQJ8zc4BdfBmUMD4hyRwFEe5OYoc11
         Rwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U8GsdptcwfHoQGaXWqtkKwyQzX5g0RQJXAszGOZZqgw=;
        b=BJocrJ4jANQrMBg8f43Rn9TiRvBypMbOAdvfAexxnxqAX942girQj6XxByzBZeQXcS
         VtS/nfeKVGlWSSqVwRu/UYMsVzhwF28c6d0kb8HFVyf4TKtnBqa241bC3pIakEsvVJmv
         WT5dQ+eYV7UJ+JaAnBnv0BNLqKBy/slYNL/EKJ9C9inaQaBi7d0MNEm06E3NucO/BmIJ
         DBtJzSYQu69OXUJ2cOvy6WKSjhNTmqm0ixTfnl6fjO/RpnqwOTVj/UKNXvpMp/jy9RWx
         6XkF/Gglf+G/C/256E+bkNxteYd8xM5pEsK8lLlz5yqnHS5EUzdhT3YCrNLxVKavDziN
         UyEQ==
X-Gm-Message-State: AOAM530e8JV5AmrnOEnd2zsD+WYCjfWaWWhYfM7Agr6+qhppAXuTmNF8
        Wu9pioVf9ZTXh4A5kDn9tz+zGDa4e47BcsxmEZOfoeP4mCA=
X-Google-Smtp-Source: ABdhPJyesvNxyuHDHwJ4on2egSq+lbALvO1UjryGAj/nZBK+nzS/D7Z5TyUa18PR7LvIIzltJrL9rP85aegYiZosjfU=
X-Received: by 2002:a17:90a:8505:: with SMTP id l5mr2640pjn.100.1616427559494;
 Mon, 22 Mar 2021 08:39:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210322115422.272718-1-tz.stoyanov@gmail.com> <20210322113330.4778d3fa@gandalf.local.home>
In-Reply-To: <20210322113330.4778d3fa@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 22 Mar 2021 17:39:03 +0200
Message-ID: <CAPpZLN5tZ7WibRV1F8VugX+nPCHE0ZmFyFLsfNYwXML+CXWEdg@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Remove all die()s from trace-cmd library
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Mar 22, 2021 at 5:33 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 22 Mar 2021 13:54:22 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > The die() call is used for a fatal error. It terminates the current
> > program with exit(). The program should not be terminated from a library
> > routine, the die() call should not be used in trace-cmd library context.
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  lib/trace-cmd/trace-input.c | 10 ++++------
> >  lib/trace-cmd/trace-util.c  | 21 +--------------------
> >  2 files changed, 5 insertions(+), 26 deletions(-)
> >
> > diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> > index 2093a3dc..5398154f 100644
> > --- a/lib/trace-cmd/trace-input.c
> > +++ b/lib/trace-cmd/trace-input.c
> > @@ -1088,7 +1088,7 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
> >       int index;
> >
> >       if (!page->ref_count)
> > -             die("Page ref count is zero!\n");
> > +             return;
> >
> >       page->ref_count--;
> >       if (page->ref_count)
> > @@ -1147,7 +1147,7 @@ void tracecmd_free_record(struct tep_record *record)
> >               return;
> >
> >       if (!record->ref_count)
> > -             die("record ref count is zero!");
> > +             return;
> >
> >       record->ref_count--;
> >
> > @@ -1155,7 +1155,7 @@ void tracecmd_free_record(struct tep_record *record)
> >               return;
> >
> >       if (record->locked)
> > -             die("freeing record when it is locked!");
> > +             return;
>
>
> The above is really valuable in debugging. We should change them from die()
> to a new function, perhaps called "bug()" that works just like die, but
> will only die if the user explicitly asks to do so.
>
> Because these "die()" calls have found several bugs in the past.
>
> These are probably the few places I would say do a fprintf(stderr, ...) as
> well even when not debugging, because when they are hit, it means something
> horrible went wrong.
>
> >
> >       record->data = NULL;
> >
> > @@ -1318,7 +1318,6 @@ static int get_page(struct tracecmd_input *handle, int cpu,
> >
> >       if (offset & (handle->page_size - 1)) {
> >               errno = -EINVAL;
> > -             die("bad page offset %llx", offset);
> >               return -1;
> >       }
> >
> > @@ -1326,7 +1325,6 @@ static int get_page(struct tracecmd_input *handle, int cpu,
> >           offset > handle->cpu_data[cpu].file_offset +
> >           handle->cpu_data[cpu].file_size) {
> >               errno = -EINVAL;
> > -             die("bad page offset %llx", offset);
> >               return -1;
> >       }
> >
> > @@ -1892,7 +1890,7 @@ tracecmd_peek_data(struct tracecmd_input *handle, int cpu)
> >
> >               record = handle->cpu_data[cpu].next;
> >               if (!record->data)
> > -                     die("Something freed the record");
> > +                     return NULL;
>
> I know I hate it when libraries do output, but the above really should be
> at least printed (maybe not crash). Because they are equivalent to a
> "WARN_ON()" in the kernel.
>
> And when I screw something up, these are the first notifications I see
> telling me I screwed something up ;-)
>
> I know I told you that we should get rid of all prints from the library, as
> I hate seeing them in applications (libgtk is horrible with that). But now
> seeing what is calling it, I change my mind about it.
>
>
> >
> >               if (handle->cpu_data[cpu].timestamp == record->ts)
> >                       return record;
> > diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> > index 538adbc2..ce2e7afb 100644
> > --- a/lib/trace-cmd/trace-util.c
> > +++ b/lib/trace-cmd/trace-util.c
> > @@ -378,25 +378,6 @@ void __noreturn __die(const char *fmt, ...)
> >       va_end(ap);
> >  }
> >
> > -void __weak __noreturn die(const char *fmt, ...)
> > -{
> > -     va_list ap;
> > -
> > -     va_start(ap, fmt);
> > -     __vdie(fmt, ap);
> > -     va_end(ap);
> > -}
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
>
> We should make these internal functions, that always call warning() (which
> we probably should change to tracecmd_warning()), and with some flag set,
> would still crash the application.

I think those die()s should do warning() by default and real die() if
some compile time flag is set. I can send v2 with that change.

>
> -- Steve
>
>
> > -
> >  #define LOG_BUF_SIZE 1024
> >  static void __plog(const char *prefix, const char *fmt, va_list ap, FILE *fp)
> >  {
> > @@ -547,7 +528,7 @@ int tracecmd_count_cpus(void)
> >
> >       fp = fopen("/proc/cpuinfo", "r");
> >       if (!fp)
> > -             die("Can not read cpuinfo");
> > +             return 0;
> >
> >       while ((r = getline(&pbuf, pn, fp)) >= 0) {
> >               char *p;
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
