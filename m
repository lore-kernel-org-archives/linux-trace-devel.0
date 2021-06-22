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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C63C2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 10:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57628613B4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 10:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFVKcK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 06:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhFVKcJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 06:32:09 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C9FC061756
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Jun 2021 03:29:53 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so1465123pjs.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Jun 2021 03:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WlrbCPaTRJeZ6lffY4DMtsMKhTn98pstBY6kj4PFLlI=;
        b=r4G2RJ+GhIKLBvwXyC9b+6RhOmTt/K9oUhtwjrNIFh8OLulhFhs5WMt1wd2555e9jW
         6VJ3Fx0YhSpTODtvKrhXy/6NrFLV2FQDu1Tbh477FRJHMaPYi+gGDbEAVyjnAYn51rnR
         HA5xWhazZ8DFmgHvUk7+pKoz3h3Mf9iTpsPWQvlyv6lTHhR2Yai5G80izMghPP4kA0R0
         boUfNGVs6g5kIvahts+JdjYjJpoqOX2/pngBpM/Jn6e3wDaLhlSKHnO+VFCQ29tv/srF
         rcgEgL143OOBDcQ5WasQsC7ZtywJwc1v9UnHdxwL/8+Kei5JXSSCTyWLuzy6RS7TOl3P
         bszQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WlrbCPaTRJeZ6lffY4DMtsMKhTn98pstBY6kj4PFLlI=;
        b=TkGp2N6rGf7A8tPjbS2fGG7BDWedd/nmbtBE9b56DOMtPgm1t412d6SMz/n4BZggRc
         1xkDnGyJ7VwvcNyg13MyYHrKvnf88MNztjfACyFC6AqPkdyUDUjgZk6Pnq5NtF13cFFI
         cglTnwaWObR/E5G4MPysz4kDbauLE8cLt9coqQT4WMXHyLshAoWb7VknzBCTCf+AlhTj
         KdV9IDcLSq4VnwuJEJPfTEkoUmTk+UlXFabAdgWd0XQ1dW6H7Codw41j/W8tiS1pBzac
         K/QN4KQUcUKV2QAB5W0fd/0HquL+xg2jqQLQrES8IjaVayaYX7iQxAE/JT4+B58aHS7n
         bkHQ==
X-Gm-Message-State: AOAM532fbL9p1EmI0hL+a4YCbIczgqVi0J4X26l4cXvO44cKJ/1ZOe+7
        t3v3LyrF1+Ww4G6ppm/tV+xApf1PaJtpBYiczZ7gEa7a8I9Z7w==
X-Google-Smtp-Source: ABdhPJxVitqjvM4Ow7Cy8/WFlywLpdEBf+okqUgcmNvkq3KkaZjxeAbi/knpsfEob0KL4wUdB29CiRPsLZDE9NXHd2U=
X-Received: by 2002:a17:90b:10e:: with SMTP id p14mr3299328pjz.153.1624357792812;
 Tue, 22 Jun 2021 03:29:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
 <20210614075029.598048-18-tz.stoyanov@gmail.com> <20210621212633.455fb125@oasis.local.home>
In-Reply-To: <20210621212633.455fb125@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 22 Jun 2021 13:29:36 +0300
Message-ID: <CAPpZLN5oB30ZUKkbeFuLhPuigMPzi4AT7P7mPTYd1AuHXXVuhw@mail.gmail.com>
Subject: Re: [PATCH v6 17/45] trace-cmd library: Add support for zlib
 compression library
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Jun 22, 2021 at 4:26 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 14 Jun 2021 10:50:01 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > If libz is available, use that library to provide trace file compression
> > support. The library is detected runtime.
>
> Why have the library detected at runtime?
>
> If it is detected, we can then have the library flags include -lz.
>
> Why use dlopen to load zlib? And not just include it?
>
> This seems rather fragile to try to get right.

The idea of this design is not to bring additional mandatory
dependencies. I do not know if libz is available by default, but even
if we assume it is - each additional compression library that is added
will be a mandatory dependency. The compression is not a mandatory
functionality, trace-cmd can work without it. Why do you think it is
fragile, I think dlopen() uses the same core linker logic to find and
load the library. The only difference I see is that using "-lz" leads
to a mandatory dependency, trace-cmd will not run without it.


>
> -- Steve
>
>
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---



--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
