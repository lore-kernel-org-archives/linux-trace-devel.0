Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C5CC6379F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 04:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E440C2085B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 04:59:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LKW7wPu9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgKXE7A (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Nov 2020 23:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbgKXE7A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 23:59:00 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3263FC0613CF
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Nov 2020 20:59:00 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id u2so10056538pls.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Nov 2020 20:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hWy4Xs1GDc0rM+WbGXq3+rRH5LSQWc1SArbMhBmPdy8=;
        b=LKW7wPu9GU8dFQblpWCLopGaDkXMIaAj9ilJmHDmJQYn1D6ipmpMYEN+9sVXIgBUrw
         sWGuG+D2Wnw4/IxW6dXH1mY4mfquQFWeXMssjS6FB3OGK+CT7iDD68bdT1+bktehA2BB
         w1wWdqcrKBIPNWtfP27Vxwbb242Y5zqq6ORfRCoHmM0wG3DJOMSORhIEa/lWa1QBchKA
         3QbYVdvcWQbH5gT2qXwqJsoUylmCPxhxqIUsYehlSBASlzi4BAvpkdXVjFaH47pZT2k/
         4d75yL3HER1J9ham1SEjdhPg6mcf8bdM3J8egNzLZ/+wqd2Kp4cJGAesn37pwkopc06u
         I06Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hWy4Xs1GDc0rM+WbGXq3+rRH5LSQWc1SArbMhBmPdy8=;
        b=OqcYTcVcs6mxXAx4a5Jl2Vnm+L5pU2sKj4gQ8AzkLjPNqEgSWho0OeeBf6Qp0sRDOr
         e/ZY7DljCUR1P8HyPRkqHOTgm6O1W+KmsGYkLPupAWbE5LYSgpFzDnyu+0BtctAfNGk2
         2i0scIGSPa1KXcuSmHxldCWvk0rMzTS5TLmc0TwIUwsQnM2SFgDpfqrX4acE96UcqyZk
         A8ho7S9kwSt12i6yfg620lLgyP0ODngmJ4zQu7UjhG1m/fYdGlG6lwX9QKRk+5UV7SHs
         bZtESRaRNIYFMByLnPDrnNj8rcPjHsAq8ryWOCKjjD9mi9bQ9MFl0TtfDEM/T5UCl5WH
         zsfw==
X-Gm-Message-State: AOAM532FBD46RYvMqzOunCTrzLyF92tUHyBKEna9C0XQrC2Sa+No8jv8
        StYnAZvoqNVnBjVhN0qc4r4rjkaTcxzIcSu0ToubHcdLRQAnl8eR
X-Google-Smtp-Source: ABdhPJwgbyfPWmXpynHJGdoHmCqPXhETRSgkDoFqAy6zySx3CSz6j9Gum6eCipooNxd40amCw4vY107KVwluTzAenGQ=
X-Received: by 2002:a17:902:ed52:b029:d7:d0af:f89f with SMTP id
 y18-20020a170902ed52b02900d7d0aff89fmr2548345plb.26.1606193939819; Mon, 23
 Nov 2020 20:58:59 -0800 (PST)
MIME-Version: 1.0
References: <20201123141321.66f87d11@gandalf.local.home>
In-Reply-To: <20201123141321.66f87d11@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 24 Nov 2020 06:58:43 +0200
Message-ID: <CAPpZLN5KOYbYg20wiU9c94Hac9Wq1b2irerXRPo=F_eBS7oAJQ@mail.gmail.com>
Subject: Re: [PATCH] libtraceevent: Update URL with the new repository
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Nov 23, 2020 at 9:17 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From 2ae4d15228ff07c022624a77effa17e7f49d8316 Mon Sep 17 00:00:00 2001
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> Date: Mon, 23 Nov 2020 13:55:57 -0500
> Subject: [PATCH] libtraceevent: Update URL with the new repository
>
> libtraceevent.so no longer lives in the Linux kernel repository. Update the
> pkg-config file to point to the URL of the new home.
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  libtraceevent.pc.template | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/libtraceevent.pc.template b/libtraceevent.pc.template
> index 86384fc..d558377 100644
> --- a/libtraceevent.pc.template
> +++ b/libtraceevent.pc.template
> @@ -3,7 +3,7 @@ libdir=LIB_DIR
>  includedir=HEADER_DIR
>
>  Name: libtraceevent
> -URL: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> +URL: https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
>  Description: Linux kernel trace event library
>  Version: LIB_VERSION
>  Cflags: -I${includedir}
> --
> 2.25.4
>
Looks good to me, thanks Steven!
Acked-by: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
