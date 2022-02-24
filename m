Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A4FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Feb 2022 16:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiBXQxn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 11:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiBXQxn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 11:53:43 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E6113AA21
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 08:53:13 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id j12so690178ybh.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 08:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oYjH0epb4EAp0Ra1CbQhm5083zOxgobdxBaH7fLLKYg=;
        b=dgs97y9RhSRXAaApuoZVmQPVv6JCjrAu9KRz12WUdWjcFd91uiuF1/0iNpccMYdmcu
         K4+Hq7fURiB2hjcBr4bkE9AIwHzMnivTE3TYqZmoV1tanAy/jw0eELipKu/ebENRcCgK
         BBXyLNAyu3rzMybB6MNi5JLY0KzTONjZqxZflfVNn5oycmQpN3R3kn5oi8epl/ZlJBNZ
         MpsGQCs4oZrAoDhXVQJ4OQV9r6lNEXeB3I/vswL95b7yYnu/ydiKITjXIN9WHkacJyeA
         9uPFhoXGZF4JnBdi6gaFa57r/uXv7Bjejrq8JQCjQ2t1wxtrG23EXBLm6b6bCKIToTft
         tFbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oYjH0epb4EAp0Ra1CbQhm5083zOxgobdxBaH7fLLKYg=;
        b=O7R8+jkOxrT6RGTDDae1MX+OotaM+LOgAHRUo8g5oKfWpVfd/hhY8lneJsxnUUCUvn
         oluGdMOYPypnZ5rrZsCsWy0Nz4/A8RULdpNrYseTRN7YcVbBT8uOTP6zsJ+4dnLow1N1
         taOLoV8RukIyPyxr19Xq873II55r1ea2JEBvUeYIUF1eqq5vNIXyng4ix8NoCIVknoxk
         w4vFWxDtbd8JWAcGOr4JhyqjrKfdvtYQN1iWxqwd+n34ne2xoc05xopNc/DPBBa2eszW
         B9EJfRG1gtleg7mvSaaoz/AATJiQmXjYSz7p6Gx031EXd1Pb/I0UllRp0Xut3WZlts9F
         xBEA==
X-Gm-Message-State: AOAM530z2/DC2OPL7ZNWzk/Fq2h4+Y4O24Kd9efTCwrZAJDqzi/ElS3S
        rXF177tYFF3OVv7R7CG9ZoJBCzqM2NYcKnzZThy0Ww==
X-Google-Smtp-Source: ABdhPJyTsvn8tEVAfPSmwz6IzRq2zI8IRly6DlY4nsjIfz75T2tAKPnRncGsWgdJzMyQSo//bwAQG50eObpDmz5XIWA=
X-Received: by 2002:a05:6902:562:b0:610:f96a:49e4 with SMTP id
 a2-20020a056902056200b00610f96a49e4mr3237374ybt.611.1645721592235; Thu, 24
 Feb 2022 08:53:12 -0800 (PST)
MIME-Version: 1.0
References: <20220224163711.185308-1-tz.stoyanov@gmail.com>
In-Reply-To: <20220224163711.185308-1-tz.stoyanov@gmail.com>
From:   Ian Rogers <irogers@google.com>
Date:   Thu, 24 Feb 2022 08:52:59 -0800
Message-ID: <CAP-5=fVsQ2kGTvCDmovLWR00SDKQz635ftVmLphZcMM82sGKHA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] trace-cruncher: Initial support for perf
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, acme@kernel.org, olsajiri@gmail.com,
        rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 24, 2022 at 8:37 AM Tzvetomir Stoyanov (VMware)
<tz.stoyanov@gmail.com> wrote:
>
> Two major functionalities are introduced by this patch set:
>  - VMA <-> function name resolving, using bfd library.

Just wanted to point out that perf is often not built against libbfd:
Please build perf against libbfd -
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=911815

where long running addr2line is now the best performance solution:
https://lore.kernel.org/linux-perf-users/20210909112202.1947499-1-tonyg@leastfixedpoint.com/

The comment from the bug:
perf can link against libbfd if available, but the result is
undistributable as they are licenced under GPL v2 and v3+
respectively.

Thanks,
Ian

>  - Support for Linux kernel perf framework, using perf library.
>
> This is still a work in progress. Depends on this patch, not yet merged:
> https://lore.kernel.org/linux-perf-users/20220221102628.43904-1-tz.stoyanov@gmail.com/
>
> Tzvetomir Stoyanov (VMware) (3):
>   trace-cruncher: Logic for resolving address to function name
>   trace-cruncher: Support for perf
>   trace-cruncher: perf example
>
>  examples/perf_sampling.py |  51 +++
>  setup.py                  |   9 +-
>  src/perfpy-utils.c        | 699 ++++++++++++++++++++++++++++++
>  src/perfpy-utils.h        |  41 ++
>  src/perfpy.c              | 141 ++++++
>  src/trace-obj-debug.c     | 873 ++++++++++++++++++++++++++++++++++++++
>  src/trace-obj-debug.h     |  52 +++
>  7 files changed, 1865 insertions(+), 1 deletion(-)
>  create mode 100755 examples/perf_sampling.py
>  create mode 100644 src/perfpy-utils.c
>  create mode 100644 src/perfpy-utils.h
>  create mode 100644 src/perfpy.c
>  create mode 100644 src/trace-obj-debug.c
>  create mode 100644 src/trace-obj-debug.h
>
> --
> 2.34.1
>
