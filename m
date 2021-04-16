Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2349C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 10:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 938BF61166
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 10:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240026AbhDPKOn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 06:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235124AbhDPKOm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 06:14:42 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38D8C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Apr 2021 03:14:17 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id cu16so11722416pjb.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Apr 2021 03:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WfCYpwvMEykn6LiWvWn5iaUnh37KqvgU2+gxazIrgBc=;
        b=GnUKIOb+OKsQ6nFVVqEV0hOGQwQofySYTi8VmvQOA9y7+g71UfBLvFV+CKblM1JCQ6
         SvXk2nihHHVcrBEa93D8MQXbTy0uxFuqZvfGNi8VgAG4aMXS2R5FFzC25kbhMGk4OLTQ
         s7Mrt5xmBo9drlbL9Daek7qhIHLnJbZun9dHeXksYbMMirFnZmiY6TTY5klNayaXrqCu
         jBYneHCT+BR2yQaT/JOcHUOS3TBNhboL4X/u7h9sG73n7VSfCBkHhANg4Kdd3re5Mskt
         a6SpVCvNPgYz7IwUBDP6BgPyMP+rR9X1Q2S5rhLDG+woM9TIpo7A9eoLAvy6WOYe4yqX
         Bu5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WfCYpwvMEykn6LiWvWn5iaUnh37KqvgU2+gxazIrgBc=;
        b=T4eAqYKUKuqH7dWxTi4yiOwkM9UwyJuWuihxj8gK0pKKDR1oQ++N4iqiJW8WXLnw3d
         tESMBWa7hsY28KRae0BRxLOnYHejvYvAwpRWlxrVrnS8JlNss/HKTSRd8mYRvXozxbJv
         wkKncF+zVmVMyZyKu/6ynQ2Xwi6BTHR5mrL/HNyGcmdM+NRX2p55wAknX0UmI+EpVEWD
         EL4fbdQUdSzNNZXIusfeUzZJxSvRt64sL058XAPuMGPCXyT6BYufJU6V1TySSU9Pqboa
         C3IhlUyI3KXhOUZn1skcP5WTb95qfNpllGlJexBs1Rrqf416cDbowMD/gfmsOUw0XXbd
         tWyQ==
X-Gm-Message-State: AOAM533N8NolBO+Al28KzR3CA5NvEiDCOKpGXHuHHniMcg1QowvMSxAT
        xT86oMAF1E+UAUTzAAQq0tgXCItG1357AtNplZSLhjv65bWGnA==
X-Google-Smtp-Source: ABdhPJxMZs3TTlZxFVAUEWkVKNjrIpww9ibkWuR9zfJ5pQu6mNkOvbhmPaY3cAyo2m9y3SsRJvFwmZalyD9IHrpjqvs=
X-Received: by 2002:a17:90a:fa84:: with SMTP id cu4mr9068430pjb.2.1618568057197;
 Fri, 16 Apr 2021 03:14:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210415080316.3482986-1-tz.stoyanov@gmail.com> <20210415093428.1a3a1678@gandalf.local.home>
In-Reply-To: <20210415093428.1a3a1678@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 16 Apr 2021 13:14:01 +0300
Message-ID: <CAPpZLN7ZvgSKoNVek+msCHarKY7F-dYUhKSuoKt_DF2qaE_rwg@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Suppress trace library warnings
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 15, 2021 at 4:34 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 15 Apr 2021 11:03:16 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Suppress all warnings from libtraceevent, libtracefs and libtracecmd if
> > the trace-cmd application does not run in debug mode.
>
> Actually, don't we have a -q option to turn off warnings from trace-cmd?
>
> From the man page:
>
>        -q
>            Quiet non critical warnings.
>
> Which I see, currently doesn't work, but should. Not being able to parse
> events is something we should keep displaying by default, but it should
> not be displayed if -q is on the command line.
>

I can fix "-q" to suppress warnings from all trace libraries, but the
problem is that "-q" is not set by default. These "Not being able to
parse" messages could be very annoying in some cases and as I
understood they are not critical ? The other problem is that not all
trace-cmd commands have the "-q" option, but almost all of them need a
tep handler that could cause printing of these messages.
Yodan found one more issue, the pr_stat() libtraceevent function is
not affected by tep_vwarning() redefine. It prints statistics on
KernelShark startup. I think we should add some kind of priorities of
all those library messages and decide which of them when will be
printed.  It makes sense only for fatal library messages to be printed
by default, if the "-q" option is not set. All others should be
visible only if trace-cmd runs in debug mode.

> -- Steve
>
[...]


--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
