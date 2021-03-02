Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4344CC433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF7D464F16
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhCBX5U (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 18:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1576013AbhCBEXA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Mar 2021 23:23:00 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B2CC061788
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Mar 2021 20:22:17 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id t25so13036439pga.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Mar 2021 20:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kT2SMWueA7xUGOcgSsnv4gGqfocz52B+H5kXCbeRM9A=;
        b=WtbMRs2ri3cspPpIqt9Z3x24q/WGx+/Ft6ifGPfpaGPnEsm8+1nKlWMQywRUGYSepl
         0D191Hlnku0TpAD6sy7on3N+87bGOmIpYkNywp5zF1xIZ00S0Jcz8xLHAIOaJdAcngPJ
         dR858Wybn+rlEhDWw4XrcssqJ7USsLQ5W+ilgaO+1LKksHf3NdoLomGhDrcQmFjoqC+9
         bGU/+EsUBNxXNdL5cA0ntE7h5K2Q1XSlrRL1pOHCo2H9EODdr+bQZmifCJHi4aGG/hgz
         xkT/6HGO72tDP0Tv8LbQRzifDXGnTtWAesLFlfmlYgHx62jjee+PSi8ndf0llzv3MHUi
         NatA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kT2SMWueA7xUGOcgSsnv4gGqfocz52B+H5kXCbeRM9A=;
        b=HkVPoY/mt0rjscDZahRViS4JfDtfN//Ic12Zyy16ErUKD11NdelTaz0xZk23rVWcTz
         Yihn4bS99dxMYZHfzuON7ZxYxo83LT0w0jgCub02PKbBWJzdlzTTGWu7bZ0Ml8fgbBzG
         6J0OswixK8+7fIAbqVgIl6fOIl0sSyF/oWcDDSZ7rOJcSzxSoZcIvDWpWz7n+AhtPmeB
         C65s6b2IKpHBbOitQoo/627N2LuCi7e2hYCeduEtcnOE6BTnBgjNiBuC+f0wGw48/b7q
         vmOGoFVi1s60ECF3y5PNzd8oFPja4BQVSpG/fFzv6O+RYD2D1TXJYhsM9jxjZ5xaKyOo
         m++A==
X-Gm-Message-State: AOAM531NBftebokInrRnin5fyixlWqReo7Ym1cqKxJaIxXdVCfdueDqx
        rwa35eRNfIWBOyTQMSf8lzX7j3w8mitpgR6NOBMHuqVL2yes2A==
X-Google-Smtp-Source: ABdhPJwGaeIlQDyXHKMzKBbBONCJObcHuDEzq/75ZzkQFjLPTZm+rU3tLgXS2N4J30+rIr3k6ouvgyydeipB6d8Lq0w=
X-Received: by 2002:a62:184f:0:b029:1ed:e5ae:889b with SMTP id
 76-20020a62184f0000b02901ede5ae889bmr1749026pfy.50.1614658936821; Mon, 01 Mar
 2021 20:22:16 -0800 (PST)
MIME-Version: 1.0
References: <1614705310-5887-1-git-send-email-sameeruddin.shaik8@gmail.com> <20210301131754.11f0be38@gandalf.local.home>
In-Reply-To: <20210301131754.11f0be38@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 2 Mar 2021 06:21:59 +0200
Message-ID: <CAPpZLN7XLeOqTqBZZDetyL9Wc32dDNd0Gd8yBcET7Pd3qUYRcw@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Mar 1, 2021 at 10:40 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue,  2 Mar 2021 22:45:10 +0530
> Sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:
>
> > This new API will write the function filters into the
> > set_ftrace_filter file, it will write only string as of now, it can't
> > handle kernel glob or regular expressions.
>
> The limitation of no glob or regular expressions is fine. We can add that
> in future patches.
>
> >
> > tracefs_function_filter()
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=210643
> >
> > Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
> >
[ ... ]
>
> > +                     free(each_str);
> > +                     continue;
> > +             }
> > +             size += write(fd, each_str, write_size);
>
> Need to check errors here, and we need a way to report that an error
> happened for a string. Perhaps the API also needs to have an error message
> pointer that is passed in? Or a bitmask that lets the user know which
> filter failed?
>
> Tzvetomir, have any ideas on how to report back to the caller which filter
> failed? Could just send back an array of strings of the filters that failed.

It is very useful to have a way to report back the failed filters.
Using an array
of strings will work for this API, but I was thinking somehow to leverage the
error_log file by the ftrace itself. Currently it does not report any
error, just
returns EINVAL. In more complex filters it would be useful to log
more detailed description of the problem in the error_log file.

[ ... ]


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
