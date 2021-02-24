Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D233C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 09:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E189B64E6F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 09:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbhBXJgZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Feb 2021 04:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbhBXJfo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Feb 2021 04:35:44 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E5FC061786
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Feb 2021 01:35:03 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id f33so1533094otf.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Feb 2021 01:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lKPh2WXWBuaddBcQsIz6T09zqVXlVBgYSj/OTCzSon0=;
        b=tk8YleOlJFG8U3gCyvwNm9zukbLVLvtqCbv0kU8xwMBjR9Y4fDENqQO9hYgsqL0oAf
         sYs/tl4u61Wa6JUgWd9QLpR1QTTzcJqNnU+gxV0MnW+XjfkkjeQOU3O4kcyVJXWsNeGS
         /im2zZ2B1n4sEnV2+AAliNy9832IQ082F26SMU8uMLnf0oY92SZHL8AavNrBWDI3BkGq
         EXAKLvnTxv0RWkpNX/l6Ofy3bpwRM2/G31xKGbZkZtc7/a75BsV9GK9TUUAN8AwSp/e4
         E+qT1t/CudBL8T7sqz1kF9mGvt+TtkWhwCWQBFqU8JpxG8enxZwTZVMSUdgrX9Vo6Oeg
         L6rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lKPh2WXWBuaddBcQsIz6T09zqVXlVBgYSj/OTCzSon0=;
        b=VwN/OP5POdqJiANYNqivSBSoFg8eXMeNgxHU9cgun+dLjv1roKpqdxraR9si8KATEJ
         GeGQeU1uD5OY4DZaiegil+WUuRbMt9+oLa6rh/M+XqcYv+PWPnwsv5jtqUFDdzbNT+aX
         YmbG+OjGc/LJPvdqsJd0q0eNKpTX8CIY0CFQz5QwxPQq0VruTgf9tM3CgWSO3ncO+yOV
         3m9Nn73bzt/iKJtvsbZMwA7vanQCWlZZQRCn/ltLO1FNvpXB8yRyT0L/SNWAXjyu9XRw
         jigBMY7SfVaEwB9DxVNDGN6gdDWWouMzQqz8Al/zKKlFWHuC7sEFvctDaZWZRtYb3eAd
         1/Jg==
X-Gm-Message-State: AOAM531VGj9/rDCx30lUT2BwEnr1/lxkVsniSYh9HvL3XocAooIfIWI7
        4Q/uzWHAMu6DMONLnNA5z+UAnlR1as4Zhy+H6ltlp16gIpWA4w==
X-Google-Smtp-Source: ABdhPJzpDMpgjcWNobKo4nVvLsIVz/ZMSxWmyPToH5sygSnYGnSgexOUGOLRtycSGHCAqu1rcOQCgnuEtcZCJR6CkyE=
X-Received: by 2002:a9d:3de5:: with SMTP id l92mr24065422otc.227.1614159303043;
 Wed, 24 Feb 2021 01:35:03 -0800 (PST)
MIME-Version: 1.0
References: <20210223120130.280e7838@gandalf.local.home> <CAPpZLN7tsF8=o1RQJc2rMAdbrFgmFvZmKWK9avbCPCa42U_iDw@mail.gmail.com>
In-Reply-To: <CAPpZLN7tsF8=o1RQJc2rMAdbrFgmFvZmKWK9avbCPCa42U_iDw@mail.gmail.com>
From:   Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Date:   Wed, 24 Feb 2021 15:04:51 +0530
Message-ID: <CAK7tX=aOyq3O_p1S5xVP3FZuciU6g=TcP997Sv3bxbxTWiBL7Q@mail.gmail.com>
Subject: Re: Fw: [Bug 210643] libtracefs: Add ways to set the filtering of
 function tracing
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

hi,

>I forgot to include you on the Cc for this email.

Not a problem at all steve , bugzilla daemon  sent me an update:)

I have read your requirements, I am thinking to give 3 incremental
patches for this API

patch-1 : will write normal strings into the filter file
patch-2: will handle the kernel glob expressions
patch-3: will handle the regular expressions

>I think there should be a complementary API for deleting the filters,
>may be something like
>int tracefs_function_filter_remove(struct tracefs_instance *instance,
>                                                        const char *
> const *filters,
>                                                       const char *module)
> It should be able to remove the filters, configured by the first API
> with the same "filters, module" input parameters.

Tzvetomir,
Let's wait for the steve inputs on this.
Thanks and regards,
sameeruddin shaik.

On Wed, Feb 24, 2021 at 1:10 PM Tzvetomir Stoyanov
<tz.stoyanov@gmail.com> wrote:
>
> On Tue, Feb 23, 2021 at 7:07 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> >
> > Forwarding this to the mailing list, as well. Any discussions on this may
> > be easier to discuss here than on the bugzilla.
> >
> > -- Steve
> >
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=210643
> >
> > --- Comment #7 from Steven Rostedt (rostedt@goodmis.org) ---
> > After some discussions on the mailing lists, I found that it is important to
> > establish the requirements that I expect of this API. I'm doing it in the
> > bugzilla instead of the mailing list (but will also forward this to the
> > mailing list), as this is more about the feature request and not about the
> > development of it.
> >
> > The prototype should be:
> >
> >  int tracefs_function_filter(struct tracefs_instance *instance,
> >                              const char * const *filters,
> >                              const char *module,
> >                              boolean reset);
>
> I think there should be a complementary API for deleting the filters,
> may be something like
>   int tracefs_function_filter_remove(struct tracefs_instance *instance,
>                                                         const char *
> const *filters,
>                                                         const char *module)
> It should be able to remove the filters, configured by the first API
> with the same "filters, module" input parameters.
>
> >
> > If @instance is NULL, the filter for the top level tracing directory is
> > used. Otherwise the filter is for the given instance.
> >
> > The @filters is an array of strings that holds one or more filters, and the
> > array ends with a NULL pointer.
> >
> > If @module is set, only apply the filter to functions for a given module.
> > This is ignored if NULL is passed in. I added this to the interface because
> > it is commonly used, and the set_ftrace_filter has a special way to handle
> > it (see more below).
> >
> > If @reset is set, the function filter for the given instance (or toplevel if
> > @instance is NULL), is cleared before applying the new filter functions.
> > Otherwise, the function filters are appended.
> >
> > Note on reset being set: This is an important implementation detail. The
> > reset must be done by opening the file with O_WRONLY|O_TRUNC set. And the
> > file is not closed until all the new filters are added. It must not clear
> > the file and close it before setting the new filters. The reason is, if it
> > does, then all functions will start to be traced!
> >
> > If the function filter has some functions in set_ftrace_filter, and the
> > function tracer is active, then it is only tracing those functions in
> > set_ftrace_filter. If you want to change that set of functions to a new set,
> > you open the set_ftrace_filter file with O_WRONLY|O_TRUNC and add your new
> > functions. On closing the file, the change takes place. The old functions
> > being filtered will no longer be traced, and the new functions being filter
> > will start to be traced.
> >
> > If the set_ftrace_filter is truncated and closed without setting the new
> > functions, then the function tracer will start tracing *all* functions!
> > That is not what this API should do. This is why it is important that you
> > write the new filters after opening with O_TRUNC and before closing the
> > file descriptor. This is another reason to use an array of filters instead
> > of having the application call this function multiple times with different
> > filters strings.
> >
> > Now when writing the filters, the following should be done for each filter.
> > Write the filter to set_ftrace_filter file, and if it succeeds, then
> > continue to the next filter. If it does not succeed, then check if it is a
> > regex. If so, then add all the functions that match the regex that are in
> > available_filter_functions.
> >
> > Note, if @module is not NULL, then before writing the filter strings for the
> > non regex write, append ":mod:@module" to each filter string. That is, if
> > @module is "bridge" and the filter is "br_*", then what should be written
> > into the set_ftrace_filter file is: "br_*:mod:bridge", and the kernel will
> > only apply the "br_*" to the module "bridge". Implementation detail, you
> > can simply write the filter unmodified, then write ":mod:" then write
> > "bridge", before writing any spaces to separate the filters. The kernel
> > will process that as one string "br_*:mod:bridge". This way the function
> > does not need to worry about allocating extra memory and copying the string
> > to append the ":mod:bridge" before writing.
> >
> > If a regex is used, then the search of available_filter_functions should
> > only look for function names that have the module name behind it. That is,
> > if @module is "bridge" and the filter is ".*switchdev_\\(port\\|fdb\\).*",
> > and @module is set, then the search over available_filter_functions should
> > run the regex only on functions that have a matching module name "[bridge]".
> >
> > --
> > You may reply to this email to add a comment.
> >
> > You are receiving this mail because:
> > You reported the bug.
> > You are watching the assignee of the bug.
> > You are watching the reporter of the bug.
>
>
>
> --
> Tzvetomir (Ceco) Stoyanov
> VMware Open Source Technology Center
