Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C17C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Nov 2021 14:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353696AbhKZOXC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Nov 2021 09:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347139AbhKZOVC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Nov 2021 09:21:02 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210F4C0617A1
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Nov 2021 05:33:41 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id p13so1313992pfw.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Nov 2021 05:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X0vHxLsDFzgFLqCNteWlW8DK+bn16F4Af+tdbFkQyW0=;
        b=qu9Fvt9OQ1geihpo3+36O02wuH97RAp5EmDVqx11pC6zKPe/Y4VJpMFwywHqkVbO5w
         5QJchNHC1AALSZHRxbUDnGayGvr5ULBBQ9Cn/xlZoIUn67HIs7ijGXFWRQIniLFj7CKA
         zDGmQ7vm9HNiADN1pL7ns/dTsRw0dxd7MQKMTt+PNRbEw6ThV/0J8AvKh+s5eR2CpKj5
         48PJSz8GusXbNVq3ysuXYmS8eim78A2oyupH0RAaZQkfiyrcenkPAbIjgffbN3oq85ho
         Witdjt+1exoQk6YpskXqrnCMSEdrDqSm6M3FeU4CWT3BN0E9ksibTfr0GwHkA1v+Jhaw
         hD0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X0vHxLsDFzgFLqCNteWlW8DK+bn16F4Af+tdbFkQyW0=;
        b=pKfP/Ro3sDF4SM+Eof5xVZR+4eJxlemNGiHBHEZUleF66mNGHX9KSDsulCBW8raNkA
         fhlh8vaPIwoJbBc3zB9VYkRYspNtmPCSLYhHWyxDHeSMar63VNHmrwub/Q/bT0yJRZhy
         0LxAdSsd3aI2RcvE8UD6pclQK2LtagJEe7jTzJse9Qy46Gx+1kNoAhIIwu9+Z9/o2eic
         Dtg198adgIXZVOhz101l5U5cncynvLrLTT48zjr7zM+r/hYcJ5obQn+s80/9SyoILvqM
         OPy0fd5LtCvbTG0m82U+ww1gbstYCWr8l3msb8Cxf8vNm1cridxyqUFFq0PX6HMI+ldK
         dp7w==
X-Gm-Message-State: AOAM533CjMVjfqOaQFX7hgCKN5jsm51k+QUz1jfMbJO/MU2DQ/Vj3ze0
        q0b6qj2Gyomqtg6+0lCVy1XnUKtfQFnJhfzBdPx/G8H343+QKg==
X-Google-Smtp-Source: ABdhPJyPgJ7PgVlIgm3ChPHcCjogvhxzdWKkhMKD/+buXBqZ5AM8Dkwb7K73TjWL9YhWaPxd2srDdHeuE+oMwBTMBeA=
X-Received: by 2002:a05:6a00:16d2:b029:300:200b:6572 with SMTP id
 l18-20020a056a0016d2b0290300200b6572mr21023396pfc.62.1637933620489; Fri, 26
 Nov 2021 05:33:40 -0800 (PST)
MIME-Version: 1.0
References: <20211111150730.86323-1-tz.stoyanov@gmail.com> <20211123230758.3be21343@rorschach.local.home>
In-Reply-To: <20211123230758.3be21343@rorschach.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 26 Nov 2021 15:33:24 +0200
Message-ID: <CAPpZLN7Jauk8OXZFaCSnzBk58nhvuE6ZdgQc650GvM1MD6eWQA@mail.gmail.com>
Subject: Re: [PATCH v2 09/10] trace-cmd: Use the new flow when creating output handler
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Nov 24, 2021 at 6:08 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 11 Nov 2021 17:07:30 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > @@ -4437,6 +4456,30 @@ static void write_guest_file(struct buffer_instance *instance)
> >       free(temp_files);
> >  }
> >
> > +static struct tracecmd_output *create_output(struct common_record_context *ctx)
> > +{
> > +     struct tracecmd_output *out;
> > +     int fd;
> > +
> > +     fd = open(ctx->output, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
>
> I stopped at this patch because I really dislike the above.
>
> Why don't we have:
>
>         tracecmd_output_allocate(file);
>
> and
>         tracecmd_output_allocate_fd(fd);
>
> Where tracecmd_output_allocate(file) does:
>
> struct tracecmd_output *tracecmd_output_allocate(const char *file)
> {
>         int fd;
>
>         fd = open(file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
>         if (fd < 0)
>                 return NULL;
>         return tracecmd_output_allocate_fd(fd);
> }
>
> ?
>
> Then we could remove a lot of these duplicate opens all over the place.
>
> Although, I'm not sure I like the name allocate. It probably should be called:
>
> tracecmd_output_create();
>
> and we keep tracecmd_output_allocate() as is?
>

 There is already such API, I'll replace that pattern with a call to this:
   struct tracecmd_output *tracecmd_create_init_file(const char *output_file)

> -- Steve
>
>
> > +     if (fd < 0)
> > +             return NULL;
> > +
> > +     out = tracecmd_output_allocate(fd);
> > +     if (!out)
> > +             goto error;
> > +     if (tracecmd_output_write_headers(out, listed_events))
> > +             goto error;
> > +     return out;
> > +error:
> > +     if (out)



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
