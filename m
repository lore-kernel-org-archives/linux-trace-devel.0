Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A848C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 04:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4D4061168
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 04:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhDIE1s (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 00:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhDIE1r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 00:27:47 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F66C061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 21:27:34 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mj7-20020a17090b3687b029014d162a65b6so4336110pjb.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 21:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oMausf7L0tZ1BW4C+Q4bNct8xzNWzq5zDQYJH8PYq48=;
        b=NaHzpzk3wQvDhROk3N4fLqNzcRbmlz3MDB4xhe6CbF4zVCu/0fAX5KAaHl2ypJ6l0A
         tdgzdR0oyh/tfs/8PZatTd7cPP79+pquXbBTCsJSS0PjcZJChxF+I1jfZvEcOZSYv/BM
         OkJ87YoPcDnC8z5y1hkly1yc8YVJ2zavpfKW8Mgw8CP5tE69WpTQMxVtZgUIy++LPyts
         +DBbwkHwsGIVTQ0xI1kpYjroZXThJUsENqf/tNMhzfiyUUE4jVOhHIhRv7UOePviMG2k
         hxmwSCxiBrRJ0menG8Rkuqej+Vgd+DwWD26SmkPlQDRDH+wm8GZUHAJnDZQ8V7zJYEUI
         pL5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oMausf7L0tZ1BW4C+Q4bNct8xzNWzq5zDQYJH8PYq48=;
        b=NIBxXV6fUV7yuUKbbiVZabbwDg9WOsPABewhPUOWY0WLo8y43BQjEXMn1KoqD3sIb5
         DpAfI0xVdFbYgzeoea2Mtrcl5zNYulUWRB1Ri1wbpkq3V0TuQ1zLJwsddg1AMKVqf6By
         W5Kyljop6Dyld2+lykKn/j62ED/6lWIIZGttA0T8UfSJPzrdT8SYSxue44+/nSOlZJii
         wf26bSzm/aUdAN1/SedJfv+CYDbSWPHGTHtsTFLE29ebOELik8nZ1wJU45ARckXa+JZf
         f/PURzdt1SwE81QWNcT8RoCXYklGhwxgY456mU+ei00L+blN95j2HcmM2BY9MiNd7KiV
         1kCQ==
X-Gm-Message-State: AOAM5305gL5VpBIZpGtjsHGE2Vyn8a9bdI7TabXz5xiSfk3qxNy9OEoi
        6qUc08DD/m2XSE8ooags2rjghexUxzAGLKfkraMwU4t9UJpSoA==
X-Google-Smtp-Source: ABdhPJyfm//6VeVjyskmHLiruepJuAJY2v1XxrJbtt1uFQBdS6hCjf3cL36ICIvqyHYwefaD01NDGmFl0cusyJZwJPE=
X-Received: by 2002:a17:90a:34c:: with SMTP id 12mr11725120pjf.100.1617942453810;
 Thu, 08 Apr 2021 21:27:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210408042843.3112349-1-tz.stoyanov@gmail.com> <20210408195738.5910fd96@oasis.local.home>
In-Reply-To: <20210408195738.5910fd96@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 9 Apr 2021 07:27:10 +0300
Message-ID: <CAPpZLN4BiR_0fRuYZQXN9nRHdtvQqxqLg0b1BgTvia3=pM=e4w@mail.gmail.com>
Subject: Re: [PATCH v3] trace-cmd: Implement warning() in the library
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 9, 2021 at 2:57 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu,  8 Apr 2021 07:28:43 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > The warning() function is used in a lot of places in the trace-cmd
> > library, but there is no implementation. The function is implemented in
> > the trace-cmd application. There is also a weak implementation in
> > traceevent library, which is specific to that library.
> > Implemented a new tracecmd_lib_warning(), specific to the trace-cmd
> > library and replaced all warning() calls with the new function in the
> > library. The new function is implemented as weak, so it can be
> > overridden by the application.
> > The tracecm_lib_warning() uses tep_vwarning() from libtraceevent for
> > printing the warning, which is also a weak function and can be
> > overridden by the application.
>
> Hmm, this seems inconsistent with the other warnings. We have
> tep_warning(), tracefs_warning, and here it's tracecmd_lib_warning(). I
> wonder if it's better to drop the "_lib" part, and just call it,
> tracecmd_warning()?
>
> And if we do, we should rename tracecmd_lib_fatal() to just
> tracecmd_fatal(). The "lib" just seems redundant.
>
> -- Steve

You are right, I'll rename both tracecmd_lib_warning() and tracecmd_lib_fatal().
I was confused, thinking that "tracecmd_" is the prefix for the
application, but indeed it is used by the library.

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
