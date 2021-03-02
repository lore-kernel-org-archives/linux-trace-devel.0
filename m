Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E25FFC4332E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B41EE64F16
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbhCBX6C (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 18:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240100AbhCBFPH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Mar 2021 00:15:07 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AB5C061794
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Mar 2021 21:14:27 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id m25so7757571oie.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Mar 2021 21:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6wpBNQveksYZLlrFMLpl34jZmEw5Ia/AfFoWG1QtEqE=;
        b=Ey5KI1gzHeonrQKmsfAMOslssR+Ebmi9dZfmro5ttjnus2WM/E+qHiR5l5y4cxjhaV
         fFhCSNDsfo6+lbIb0h0TxZxFg26gaQv17uApCkYhOvZeeYvtK3JMNIM4ShZZcoR3GWfJ
         xCnE913uZatzevce5VqzAwkGq5+jPGnNBCiP6VGeWuMSVMJZdpWeJhWV88QK008OSSNF
         1t6LQ12XNwZ88CLDUWEPw5R4J1+Hnwi/h6k6rxUv/TymYBiZHHhF6onhG+WS7FIBxcMI
         c30QGba5chOdQr2yAY7EGZZH8blcz4BWWbQPe1YAziHsJL/Ebg2TeWvNCt7Z20Ll8mY1
         dXGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6wpBNQveksYZLlrFMLpl34jZmEw5Ia/AfFoWG1QtEqE=;
        b=OzNR65dzZvUCxLxJHQi9ZzXgrFkaFjm93hS0I21bjBSUknSG4ZnAXx8AjD04QVxOp/
         YHtg4W5ZKxheOyFi+ONVUfF60CE6m05naaJNYhMOqzV4d+t6NL2+p5s7byrDJ3yP8gIB
         ej+cgB3LwQwx+y78iVYu8VboQCzRmRabUi7gLb0/RLewobZRYDs8toAYhGzvcbC3QJHt
         ATuMgtkIlGKg/PdXCguKdPzP6Vt1E5ZosPDzVZoxqMYsELiwuVsuR70en7ryHI8qbTAF
         qZlK2xUVcHXO5q8Iljz18d0CZtpBXwWrje3L8io2GOnuUtUu1B1qFatjqJexMg/dn9pc
         GAbg==
X-Gm-Message-State: AOAM533Rh2Z7ztXCTdgvsn59VS5feFxK07Lwf2ahkv9EzFokQmz3hwqp
        b6D0WJ9R4u9xSGEjezat0nPJKImw/VX3JeVmavc=
X-Google-Smtp-Source: ABdhPJxy+sfI5q3FZLfGCVrSKKoSA75Jhkj1rcciElBQWgwH0V02NOT8kHqZAvLB4VNYHpPUuEdWR0QZfTIRX87jO+s=
X-Received: by 2002:a54:4794:: with SMTP id o20mr2029260oic.51.1614662066262;
 Mon, 01 Mar 2021 21:14:26 -0800 (PST)
MIME-Version: 1.0
References: <1614705310-5887-1-git-send-email-sameeruddin.shaik8@gmail.com>
 <20210301131754.11f0be38@gandalf.local.home> <CAPpZLN7XLeOqTqBZZDetyL9Wc32dDNd0Gd8yBcET7Pd3qUYRcw@mail.gmail.com>
In-Reply-To: <CAPpZLN7XLeOqTqBZZDetyL9Wc32dDNd0Gd8yBcET7Pd3qUYRcw@mail.gmail.com>
From:   Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Date:   Tue, 2 Mar 2021 10:44:14 +0530
Message-ID: <CAK7tX=Zn-pj2-+6Y_JwCgUraiVCVz7uc28WYP27wJuKURhYsuQ@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

> Let's fix the number of parameters to this function:)

>> Not sure what you mean by that.
Actually i meant this ""int tracefs_function_filter(struct
tracefs_instance *instance,
                                    const char * const * filters,
                                    const char * module, bool reset,
                                    const char * const ** errs);""
For every patch, a parameter is increasing in this API.

> let's return the number of bytes written, also we will calculate the
> complete filters length and return it, if there is difference,
> we will loop into the integer array and print the erroneous filters

>>Not sure how that is helpful. How would you use the number of bytes
>>written?

We will return the number of bytes written and we also store the total
length of strings
in filters array, in one pointer variable, we will check the
difference between bytes written
and the total length of the strings, if there is difference we will
print failed filters otherwise
we will not print anything.

>It is very useful to have a way to report back the failed filters.
>Using an array
>of strings will work for this API, but I was thinking somehow to leverage the
>error_log file by the ftrace itself. Currently it does not report any
>error, just
>returns EINVAL. In more complex filters it would be useful to log
>more detailed description of the problem in the error_log file.

This error_log is also a good idea.

If possible let's have a live discussion on this API,so that we can
discuss the corner cases in the design
more efficiently and we can close it ASAP.

Thanks,
sameer shaik.

Thanks,
sameer shaik


On Tue, Mar 2, 2021 at 9:52 AM Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> On Mon, Mar 1, 2021 at 10:40 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Tue,  2 Mar 2021 22:45:10 +0530
> > Sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:
> >
> > > This new API will write the function filters into the
> > > set_ftrace_filter file, it will write only string as of now, it can't
> > > handle kernel glob or regular expressions.
> >
> > The limitation of no glob or regular expressions is fine. We can add that
> > in future patches.
> >
> > >
> > > tracefs_function_filter()
> > >
> > > https://bugzilla.kernel.org/show_bug.cgi?id=210643
> > >
> > > Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
> > >
> [ ... ]
> >
> > > +                     free(each_str);
> > > +                     continue;
> > > +             }
> > > +             size += write(fd, each_str, write_size);
> >
> > Need to check errors here, and we need a way to report that an error
> > happened for a string. Perhaps the API also needs to have an error message
> > pointer that is passed in? Or a bitmask that lets the user know which
> > filter failed?
> >
> > Tzvetomir, have any ideas on how to report back to the caller which filter
> > failed? Could just send back an array of strings of the filters that failed.
>
> It is very useful to have a way to report back the failed filters.
> Using an array
> of strings will work for this API, but I was thinking somehow to leverage the
> error_log file by the ftrace itself. Currently it does not report any
> error, just
> returns EINVAL. In more complex filters it would be useful to log
> more detailed description of the problem in the error_log file.
>
> [ ... ]
>
>
> --
> Tzvetomir (Ceco) Stoyanov
> VMware Open Source Technology Center
