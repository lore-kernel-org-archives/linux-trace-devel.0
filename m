Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C559C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 16:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DC216108B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 16:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243095AbhDGQrJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Apr 2021 12:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbhDGQrJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Apr 2021 12:47:09 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C14C061756
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Apr 2021 09:47:00 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so1600635pjb.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Apr 2021 09:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NqQIPkLcKZZMGoqXI6t1qf1Rd2HP1HEag8M5mU1CUWE=;
        b=elgdyzehawR9lEXXRBMfuPy2YkTuc5Komel0Jd3Oc0SEXI75gIb6jz0KIU76Kb19MO
         frX5M0LAqDw3quH4QVgL2L1yt4W4PA/ozUN+h6EnyT1Cv0IEXHYLgkn75yf6yQ5pdPdK
         wVdqtmJYa2xB9MxOsT/j54Un2dMCzdUOMtJU/QKRq/mYJYjP/1DsiL1+CFr9c83b+Sa0
         64knyX3lj2XxBz83vO3YRCwP0x0MvxAEF7oRhnw4QIidc/JWUjGpDHOnMxOli3/kGSRq
         KHMTdAMti/0I7WqiSwQwPOxFPQF56idG/SBvXLVj7/4UcGcxnc/pIdnc/2Jh5cUoLrE1
         Dy3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NqQIPkLcKZZMGoqXI6t1qf1Rd2HP1HEag8M5mU1CUWE=;
        b=kn4gyOt/8u2ajutaUSLQrGr7MN/dV794PP7qJ+NM0fCKE7JM5VpmZ6yQwZrT/zC6wx
         VOpUpE2Ip25L93FLkKD2bbnSEdhK0HjC2dI4MxjH7dhujl5lS8KEQaXUE9Te3UTL2BMh
         uhs6w//x/3EUXl6oSSp4AC60da7fRSmaXWPeS8eUTWn3hkxfwxWE1aJZn/W37fcJCtHI
         1TnXFGpZeDko9NZwZxtEjkYmNON02Ypr6TPuFonVtHOcZZjuy6rzikKAtD8dTDEDbX3+
         GyrmXoUOyNpbQlxuC4FvIIHF4Uf5WciJH/RgRN7XguJ1Fn3YgF18PSGy4GbX61lhi4Eq
         MIEQ==
X-Gm-Message-State: AOAM531WnP7ekKQ4oqL4C7UAr2kOP+t/jgNLaLb+p7nAZKIY5uWoExtk
        DGXM74X+QGKYDfXTlKG03gSU+u/5W7imalkU0uBjO0DNlsY=
X-Google-Smtp-Source: ABdhPJxoBxX9BNIpBNuTjjawT36HcrmwjmajOxUssAs2M8h5NDJ0uWWn6sF768DTYFbc1AS6dlz3QY8vLfHBGfZh/6Y=
X-Received: by 2002:a17:90a:34c:: with SMTP id 12mr4093493pjf.100.1617814019411;
 Wed, 07 Apr 2021 09:46:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210407051154.2422172-1-tz.stoyanov@gmail.com> <20210407121928.464045ee@gandalf.local.home>
In-Reply-To: <20210407121928.464045ee@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 7 Apr 2021 19:46:43 +0300
Message-ID: <CAPpZLN4BUmTwx1QGYLZPoWc0iTRS0GPN3vo1GkXXd9GFerToVg@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: Implement tracefs_warning()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Apr 7, 2021 at 7:19 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed,  7 Apr 2021 08:11:54 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > The warning() function is used in a lot of places in the libracefs
> > library, and it is implemented as a dummy weak function. There is a
> > weak implementation of the same function in traceevent library, which
> > could cause a problem when both are used in an application.
> > Replaced warning() with tracefs_warning() and implemented it as a
> > weak function, specific to this library.
> > Added a __weak define in the library internal header file.
>
> I've been thinking about this more, and I think we only want one function
> to override, and that would be:
>
> void __weak tep_vwarning(const char *name, const char *fmt, va_list ap)
> {
>         if (errno)
>                 perror(name);
>
>         fprintf(stderr, "  ");
>         vfprintf(stderr, fmt, ap);
>         fprintf(stderr, "\n");
> }
>
I understood that idea from your comments, but have a few concerns:

1. That way we create a dependency, not logical to the user of the libraries.
2. That print functionality is not something logically specific to the
libtraceevent, it is not related to the main purpose of this library.
3. A weak function specific to each library is a more straightforward
way and the user has the flexibility to control warnings per library.
The overhead to add library specific wrappers to those weak functions
is not so big.

[...]


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
