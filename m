Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6C3C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 03:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E33C64E31
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 03:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhBKDJP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Feb 2021 22:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhBKDJO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Feb 2021 22:09:14 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0366C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Feb 2021 19:08:34 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id f3so844839oiw.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Feb 2021 19:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pI8+6/63Xf7KswrvlOhnrUvT8MENJJTT04nPPR8uJ6g=;
        b=d0WriIA+QzFlH/2G+x/0c876FJTL8TRsyIFmhxZ2qL7YLREJzbabyo0bBV/QbEC/L6
         VT4aU4bz0Yk9zdrvNC+r3FrBRMQrM9p2myQZMzpn6A3QPns4Jz4XZRLgoYf2iAE6nQUK
         nEICfK0ze/1tIBVXbArWKPKXO3gSZ2+eecbmnXhe61oC1XO+cB7BFbOkUeQV/z/JlaR5
         XjozYavQadSxJF2Ldwyqtis5inSh2AmI/WJ6ko1SyJIrNPBKY87WW36VpPbsnOSIL3lF
         fesX/IsWpX9krZw70rL6JI0JLu/AxyqMD7hjqKaNvtWf0sU9bLfAmLLPMH/ys8knBkRS
         vEEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pI8+6/63Xf7KswrvlOhnrUvT8MENJJTT04nPPR8uJ6g=;
        b=YGbOSQy5ZW8hpKmG0BXF8TzTWAgfiXw66kdGSS5YLiWEgIYFbr9PwM98xnXI0TipCF
         YXJPy1iJtCOJRJ9cPx/AdLcsUfkjmS3z8xLB487oeKP20ql1K9HxCUsK1ZGrk9cK5Ee9
         iIa/n60AjzpTQjEpYwYMlkq0efrUXMOZU4KtWHssC4pBRRAsc6xzNFse+0Lib6nkd1z1
         5ghcgEFMM/5lzSy4KJPCJBvwuBan7AqHSVf1oGMRiW9WbVkjI3CFtvHnVHvJK/drIK0V
         Kp91oCei6wf5jffKMghOPa1U0LVxvim3fmE9qtcDeg1Fv6VqN/WaGJC+sSw5OJpxlT2U
         cRCA==
X-Gm-Message-State: AOAM532AyNVadMR+HKDexXebypiKXo799X8WCAkZH5KJ0JN433XI9wKY
        lRXuExf2Lg0rsCZBdKposbsIIYTBtRpz/rmzPB+j9yapANMU+g==
X-Google-Smtp-Source: ABdhPJxDVgep+ibzig805+1w7lulbCTH28at9HqFcOust98cU18h/XzBsB7ZGN/5OB3NlaB3JDN4nHzxtfK/evkzz2w=
X-Received: by 2002:a05:6808:649:: with SMTP id z9mr1422198oih.154.1613012914170;
 Wed, 10 Feb 2021 19:08:34 -0800 (PST)
MIME-Version: 1.0
References: <CAK7tX=angRdxNdg2yNnss-NuBm+i-Y3unyT6BaeY0Quj-QB+UA@mail.gmail.com>
 <CAPpZLN7ysUKXLXwCbkfq+-OMhzUOXtDam+937gquDX4uT_nTHQ@mail.gmail.com>
 <20210209115855.37826f7f@gandalf.local.home> <CAK7tX=YfQ4SGdUu3ac7bwRw0jGKBzgrNGtVib6VfrBUYEdJj2g@mail.gmail.com>
 <20210210103846.1ccbc4f1@gandalf.local.home>
In-Reply-To: <20210210103846.1ccbc4f1@gandalf.local.home>
From:   Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Date:   Fri, 12 Feb 2021 08:39:22 +0530
Message-ID: <CAK7tX=Z6JLRP2RwPSNqU-15C0SRCb-LdbV4ceeJCOjZG0rJ3Qg@mail.gmail.com>
Subject: Re: [PATCH][WIP]libtracefs:New API to enable the filtering of functions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Yeah steve understood,
Will try to implement the functionality in phases.

On Wed, Feb 10, 2021 at 9:08 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 11 Feb 2021 08:33:50 +0530
> Sameeruddin Shaik <sameeruddin.shaik8@gmail.com> wrote:
>
> > By this you mean to say like, we have to do the filter functions
> > validation in the API?
> > or
> > shall we continue with tzvetomir idea (I mean depending on the kernel
> > validation)?
>
> I mean write to the file, and if it errors, then do our own operations on
> it. This would need to be documented in the man page for this function.
>
>
> For example:
>
>    filter = "sched*"
>
> would write into the file, which the kernel should turn into a selection of
> all functions that start with "sched".
>
> But if you had:
>
>    filter = "sched_feat_[^w].*"
>
> Which would set "sched_feat_open" and "sched_feat_show" but not
> "sched_feat_write". Since it is a regex and not a glob expression, it will
> fail the filter.
>
>  fd = open("set_ftrace_filter", O_WRONLY);
>  write(fd, "sched_feat_[^w].*", 7);
>
> Will return an error of EINVAL. When that happens, you should run this
> through the regex exec, and then use the result to find all the matches.
>
> Note, it should be implied that if the regex does not start with "^" and
> end with "$", then that should be added too.
>
>   "sched_feat_[^w].*" turns into "^sched_feat_[^w].*$"
>
> before processing it into the regex.
>
> You may be asking, what if someone wants to add something that is a regex,
> but also acceptable as a glob?
>
> Let's say you want "_*acpi_device_uevent_modalias", where you want:
>
>  "__acpi_device_uevent_modalias" and "acpi_device_uevent_modalias"
>
> But the glob would only select "__acpi_device_uevent_modalias"
>
> To force the regex, the user should just add "^" to the beginning of the
> string.
>
> Thus "_*acpi_device_uevent_modalias" wont work as expected, but
> "^_*acpi_device_uevent_modalias" will.
>
> Make sense?
>
> -- Steve
>
