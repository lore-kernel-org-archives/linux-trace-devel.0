Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2042C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 09:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACF3D619FC
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 09:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbhCXJKz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 05:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbhCXJKp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 05:10:45 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE18C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 02:10:45 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y5so16865382pfn.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 02:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DqDmgKMOdEZ4dKiWQ3qPZ0X+LDBjdXaNKOZZO2j7jgg=;
        b=LyeNTv0HQhEwgsDQ5re9U9MhXiahN3SW1pnjLO6Qw9HCW7W3BI2ZHlZSq5BNdKfRCj
         9FFaoV0xD8oIZkFzIbD4VtorFBSOoeyMkjF9yqKv/kiSg1dkdrKGtg/2LasqRYLh253r
         NOL1OMBsYvYwBkzj+6V+cPv0RyYgcgoRz/2CYAWGkWTjICxN69DYqbSia0lBGM+Qin4M
         qt7iX9oY4sFdzfmr6c9U6fjHZChLSb41k51dpPJliCAdSqRbAREFduz3cD5RjeeQ/6kZ
         kxnwcTS4xJKBI8R1ePb812ef4Yl1M7mqjwWk8avAQJ/hdbH4/XGoK9sP0ZQ45SVqnFHi
         Syqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DqDmgKMOdEZ4dKiWQ3qPZ0X+LDBjdXaNKOZZO2j7jgg=;
        b=nAAMfyiTxoDjqsVVXCsvSH911cUnxzmB1VwbFUYmUu82fhgSlIj7UDCm9eflcayqTH
         dQA4nnU+jzUvhNY4s/LvXFxx5cRo6MTLKbs0M5ZbLdCtRJfsO0jEHi4Sxm+YisYiaiuI
         bdDjdYV75bTASNI0cn8t4pipYAAqZNtBgT+X8g6MzNxS34L2MC8RTi6xtZPwRGOetSKs
         +0i8fMQpKoIwwW2dcOh5QU1MHE+/8EYZa9oOB7P5ZHw1txqUCwwmi4wzIxlpkRTuHRhI
         ySERQe0yGfOOUQDs0rWffCRmEDkpYCcFSL4agN+E9PoE+a5aCpWEaZZ7oLnXy0/DwB85
         2SfQ==
X-Gm-Message-State: AOAM533vCz0NeR8MvBe4e1NAkV/bN4KU0FPA1ZiyRfSMeKyIweMZyQir
        WZdmLlvyt97gBsl+otDdK8X+2HRVAOhqGF73Z3lNwJ27BD0FAw==
X-Google-Smtp-Source: ABdhPJx5fWqe0WvdFRdurvw8/Wsj5FmCvLzgKLC731jV4kD5v8+zkgQ8BhxplbFm8VOxI4OM55ia5xzgDIyVQDSya38=
X-Received: by 2002:a63:81:: with SMTP id 123mr2096900pga.307.1616577044961;
 Wed, 24 Mar 2021 02:10:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
 <20210322095945.259300-4-tz.stoyanov@gmail.com> <20210323205205.192e62ae@oasis.local.home>
In-Reply-To: <20210323205205.192e62ae@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 24 Mar 2021 11:10:28 +0200
Message-ID: <CAPpZLN5nR4V0e2Mk-wgvg3Nn=7tVW9q6XxNZFhmDSFfdSYuytA@mail.gmail.com>
Subject: Re: [PATCH v2 03/18] trace-cmd: Save only the selected clock in the
 trace.dat file
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Mar 24, 2021 at 2:52 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 22 Mar 2021 11:59:30 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Trace clock, used for curent trace sessions is saved in the trace.dat
> > file. This information is used when displaying timestamps of the events.
> > However, only the selected clock is needed.
> > A new API is added:
> >  tracecmd_set_out_clock();
> > that can be used to set the trace clock on the output handle.
> >
>
> There's no reason not to have the other clocks in the file. I would
> rather keep them as it doesn't hurt to have them right?
>
> The reason for keeping them is when a customer sends you a trace.dat
> file (from commands you ask them to run), you can use the trace.dat
> file to see what other clocks they have configured in case you want to
> have them try another clock in their next recording.
>
> Extra data about the system the trace.dat file was run on is always a
> plus.

I'll extend the TRACECMD_OPTION_TRACECLOCK option with all clocks and
will keep the changes from this patch. That way there will be
information for all available clocks from the trace session and the
old versions of trace-cmd will still work.

>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
