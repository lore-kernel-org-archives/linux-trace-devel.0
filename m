Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D007CC2D0E4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Nov 2020 00:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 694B521527
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Nov 2020 00:44:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AfzXJvQ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgKYAos (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Nov 2020 19:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727621AbgKYAor (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Nov 2020 19:44:47 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C335C0613D4
        for <linux-trace-devel@vger.kernel.org>; Tue, 24 Nov 2020 16:44:47 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id d8so745356lfa.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 24 Nov 2020 16:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ms07/h62twahlEwZuOadpTv78iUIw5NsYBc7AfTxgIs=;
        b=AfzXJvQ30M2Cd34Rk55vUwB5mrySnLMtqqXKDQUno2KPKcIb7ps+0I9wkm4/VKXnFV
         N5lhzDBmt/9OMaVVXbx5Qwj2t4Qr+G6EVVFcuC2VhGOPS0LN3hO5naEcgHf1RlXdSQtK
         Qs7FUzGeM2cFxLa2cR+jbzWVHzmGo1K42eHv9xYMSgHx+99XjP9DRBAQ0tmOAmaLjCRq
         8V5paByVIhPgflcnQPbRtCpLw3jpbU8dg8pMtk5gDu7voKmOMe+jvIOU1OBhpSzzSdLJ
         8UxLDVo+OLRWT/4WQRVoVQVvaxUniacdEZcdN9JHDi1pheaWdOqjiFYym8MAI5A7e4YR
         ocSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ms07/h62twahlEwZuOadpTv78iUIw5NsYBc7AfTxgIs=;
        b=R5Lx+XRks6h7u5EK7GYvAr8tzgzNOaBXLKhPwIZjHL8o+FEaiFaccJGVH1RYUa9xAb
         MGhzvLZ+wlA0jJROkE89EXf3r7qcJdG65ZpbLv1+hm/PtX7UowG6w4oMXa0fA+fubylq
         jlS78MYFtx9pMlEuuC30XeLSFIPM8HeLbj5pvU0cqW+np6yrANKzxtwFWUJigPanEomG
         WAmOQpH8d1LKSBOMpFJCyWdUyOhSkAjnFtQfRP2Yjo8R4jjasScEZ7ZWE3TWDGIPtJev
         CZmWZjkTd1rk0rAqPSlyscTPzyK1QVGMKIe7hLOHjhJb8aQ3ZtSd6O8rYsAXdPrUNKwp
         cO8w==
X-Gm-Message-State: AOAM530KiDXckjtc5cUCiE3KPf2fsHaazZm8XLlsGmNnWjR4AAlim/X9
        LpfTx0ukCLx/UFhrkUVESfGhP4dpP7h3scbeS88kKFpy
X-Google-Smtp-Source: ABdhPJzBXf9FZExR601qvgHoLqeFZ2M+m4UZlC8NBSDdHwgs0hfxx0FRuZEYurlTqW5/XzwTC3CFg3vZnsYUgxNETz4=
X-Received: by 2002:a05:6512:1102:: with SMTP id l2mr270466lfg.500.1606265085956;
 Tue, 24 Nov 2020 16:44:45 -0800 (PST)
MIME-Version: 1.0
References: <20201124172755.31795-1-marcelo827@gmail.com> <CA+saATWWh9jvNHxyzuKEtrzybJXQS+wWTo9W6-SJNATmEt1bSw@mail.gmail.com>
 <20201124170258.4d6ac78e@oasis.local.home> <20201124171130.4545101c@oasis.local.home>
In-Reply-To: <20201124171130.4545101c@oasis.local.home>
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Date:   Tue, 24 Nov 2020 19:44:34 -0500
Message-ID: <CA+saATWPmT8zVH=bKEP3VV4vGXzGmzizZapV0N=9SSDv9E+tHQ@mail.gmail.com>
Subject: Re: [PATCH] libtraceevent: Install kbuffer.h from the install_lib
 make target
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Sounds good! Thanks for taking a look at it.

-Marcelo

On Tue, Nov 24, 2020 at 5:11 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 24 Nov 2020 17:02:58 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > On Tue, 24 Nov 2020 12:30:28 -0500
> > Marcelo Diop-Gonzalez <marcelo827@gmail.com> wrote:
> >
> > > I figured I'd send this because it might have been left out by mistake
> > > given that it's included in the library in the kernel tree, and I've
> > > been working on a program that uses kbuffer.h, so thought other people
> > > might find it useful, too. Feel free to ignore if it was left out on
> > > purpose, though
> > >
> >
> > Thanks! This was definitely an oversight on my part. I'll add your
> > patch next week as I'm not starting my turkey vacation ;-)
> >
>
> I took a quick look before my vacation, and noticed that kbuffer.h is
> already there. Then I noticed that this is for the trace-cmd.git tree.
>
> The code in trace-cmd.git is now obsolete, and will not be updated for
> libtraceevent work.
>
> libtraceevent.git now lives at:
>
>   https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
>
> And we are also moving out libtracefs.git:
>
>   https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
>
> Sorry for the confusion. We are trying to clean things up, and probably
> sometime next year, I'll be removing the libtraceevent and libtracefs
> code from trace-cmd.git, and it will then depend on these as separate
> packages.
>
> Please feel free to look at those repositories. The libtraceevent is
> pretty much stable (but will probably be updated as the kernel gets
> updated), but the libtracefs has a lot more to expand on. It is going
> to be the API to communicate with the /sys/kernel/tracing directory.
>
> Cheers!
>
> --- Steve
