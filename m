Return-Path: <SRS0=D6y3=CL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4808C433E7
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Sep 2020 09:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD4BC2098B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Sep 2020 09:37:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dw0jTfLp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgIBJhm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Sep 2020 05:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgIBJhm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Sep 2020 05:37:42 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27DFC061244;
        Wed,  2 Sep 2020 02:37:41 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id o20so2519945pfp.11;
        Wed, 02 Sep 2020 02:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0bVg9bCv4MMqdAgJJZZqyeP02ZTQZh4PQHFt6NK2cFo=;
        b=dw0jTfLpMqKgEABRn8le5x5Nq26lpw0U4w0VCzrtJxhOjKDCp+gW1o9TBLy8JwWtOz
         MTmYovopDK/QmRrnq5UL6+X4RJomKTaoiC131bTYztiKY7jieJ5g34eV9fpTZsxz5X5k
         jFTBizkGgspf2O6T/jszfQ26M/01ncuxrWcE+hCZ5cMmQ512ONwC4q++aHySiW4zN4II
         0vjN63urMV5y2wXk9r5YNwuFDGMNfU6o87FyZilbAlvj4w9v1jRg4qD71qmrvOJFgS/b
         z+h37d5CmzWnuDfG8ri4n09n0q4pHgUOhd072cBUZFufgucMF2iLY9iyQ4lbz9BfCNiy
         CfkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0bVg9bCv4MMqdAgJJZZqyeP02ZTQZh4PQHFt6NK2cFo=;
        b=jYv50nQeVqIxzFmJV4ABQsbagvTBcpLPCG0UwvpZnVyyNz50jnjSx0DRSEfsdjgO/H
         q9/TSnMCZMJv56QPO28INOmUMQLpPkSL4g9t6ZvaSgl4T1BSZk0GE4rc2MfXWt1huGFB
         1JaFqDMyVUPa3ASI9ExF38LPkuETYPezITrwRcNATKQYhSyiOQVhYYbSWJ2GtfB6qNpO
         7qOb8kPIsM0OKF2fT+gAMDFP9S6bO4w4ieuwl2snGLOfSh8M4BseRKu94dH0U3dkUTAi
         fGaa1/ZKDIAddVP1C7g5WN6Mzq8bybwWzWHw8t5PkJnDOM3yME341zr/uZvpl4XrA4Fn
         tIVg==
X-Gm-Message-State: AOAM530lwOH1ErqxAm9EjjNS1KOQZGBw6+Q3hXzbtOSMxQrn73sGpb4n
        htvSUVUYKF6Yehv8abxbCox1U8grmtAYIQnjubU=
X-Google-Smtp-Source: ABdhPJwJeP6Bk7+OxUaaNfM8igZ7nEc1pe+JJdoFRGgO9VLMNjvhAmFN/OKi+kRqHWdTyRkai3chz48VBOSSzzEMmYg=
X-Received: by 2002:a63:5656:: with SMTP id g22mr805184pgm.44.1599039461544;
 Wed, 02 Sep 2020 02:37:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200901221141.GB1464000@kernel.org>
In-Reply-To: <20200901221141.GB1464000@kernel.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 2 Sep 2020 12:37:30 +0300
Message-ID: <CAPpZLN6+tyGMfOL0iqC03KwWLP_qTcR9N1ii1u5vvUfiHm_+hg@mail.gmail.com>
Subject: Re: libtracevent: Build warning on 32-bit arches
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Sep 2, 2020 at 1:11 AM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Hi Tzvetomir,
>
>         I noticed this:
>
>   27 debian:experimental-x-mips    : Ok   mips-linux-gnu-gcc (Debian 8.3.0-19) 8.3.0
>   29 debian:experimental-x-mipsel  : Ok   mipsel-linux-gnu-gcc (Debian 9.2.1-8) 9.2.1 20190909
>   64 ubuntu:16.04-x-powerpc        : Ok   powerpc-linux-gnu-gcc (Ubuntu 5.4.0-6ubuntu1~16.04.9) 5.4.0 20160609
>   69 ubuntu:18.04-x-arm            : Ok   arm-linux-gnueabihf-gcc (Ubuntu/Linaro 7.5.0-3ubuntu1~18.04) 7.5.0
>   71 ubuntu:18.04-x-m68k           : Ok   m68k-linux-gnu-gcc (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0
>   77 ubuntu:18.04-x-sh4            : Ok   sh4-linux-gnu-gcc (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0
>
>     event-parse.c: In function 'print_arg_pointer':
>     event-parse.c:5262:29: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>        trace_seq_printf(s, "%p", (void *)val);
>                                  ^
> The cset is:
>
>   487ae1f4a17c197a ("tools lib traceevent: Add support for more printk format specifiers")
>

Thanks, Arnaldo
I'll submit a patch.

> Best regards,
>
> - Arnaldo



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
