Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52F4C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90A0C613E1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhEJGX2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 02:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhEJGX1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 02:23:27 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CC5C061573
        for <linux-trace-devel@vger.kernel.org>; Sun,  9 May 2021 23:22:20 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id i13so13024444pfu.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 09 May 2021 23:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y3V/3Cp5HNdtsh3PZulf9E40p20xOwEbltR3PKt0FuE=;
        b=F8mtiDh75E3jNtcZFCSW4rgtlRfQV5NrqbGYqqYx2YfzzyaF17tZzOO57zm11Poz8X
         3t+Z/LydXYAqXmDaF/IFOjWzvGy9sPQGn0oZQldWvzB1Wyna2HXVfqRflaGE+ixEvvNB
         RPdHqLUSZgkAxWNvTaa6KWShJxhe8PseocsJPs86r794xM6IKJUhCZRs01WpHVbU89i8
         y2SbVfH6uJtm50npAF6lEGwvkJ3QEpnEUTRjxyrxRcFKKDWTi0n2XpbX0Im3HJQ9yq0G
         B1Z9xdADhuWfFRd8y7RE1Z7jI/Wavc+VKvuuSeOAqso2v0HwBajdZQ5K2c16oL7dRe+O
         8jDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y3V/3Cp5HNdtsh3PZulf9E40p20xOwEbltR3PKt0FuE=;
        b=p7wuEq/Vp1bgjH6/HkkQIMGy5vowUBxgObZrzVtFQLyuWuV9zxY73lyTBF0WMGRRqB
         54KKhf/TlFvWsPiQjuLktn03gfN+pe8QmEBcYHWg2l5+75GXfx3AnGj58K2vLFseXKJ9
         8lPJc5Lg1OeHWT0jWhSU4KimTsW4nZmoxz76poYUL/Z0ZcOTcWrOHUstqwcLsbDovbD5
         u881k8XdJ1yET0SoLxdi/DvLzNCBZlBsxE59sgKeW5HM71M87f1QQKkJZsVrmb968vTH
         wyrmErSvlAC0Ot5/8jL/iVmTpcOpxt2YUnNudL2n9xQplUklykEODPyURsV9uZxVw70k
         ChfA==
X-Gm-Message-State: AOAM532Cb2WrLTjhwf8Nrzt02dWRfAkgjPIgdAcr8sTHdTr29/laPg8m
        PZ6nzrYk6IRWgntxuaAUamvJs0dXlPNMmq/uLtG6L7tXC/pVPw==
X-Google-Smtp-Source: ABdhPJy3Ai2+47z7VAu+5vyuer3cXWVG+EKgT6LxwNJPN8eyBeNL1Ku7rpKz9vl+G5m8HBgsp+vCXOQmrRSiRbZksaU=
X-Received: by 2002:a65:47ca:: with SMTP id f10mr23779444pgs.206.1620627739900;
 Sun, 09 May 2021 23:22:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210429040119.843617-1-tz.stoyanov@gmail.com>
In-Reply-To: <20210429040119.843617-1-tz.stoyanov@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 10 May 2021 09:22:03 +0300
Message-ID: <CAPpZLN7VAdLOjHj4cspdqupYK+b_1gQOtac-xJ7_Xos26Q5CpQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] Bump trace file version
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 29, 2021 at 7:01 AM Tzvetomir Stoyanov (VMware)
<tz.stoyanov@gmail.com> wrote:
>
> Changed the trace file version to 7 and added support for choosing
> the desired file version.
>
> v2 changes:
>  - Include "Check if file version is supported" patch in the set, as other
>    patches depend on it.
>  - Reorganized the order of the patches, put the clean up patch "Remove
>    unused private APIs for creating trace files" first.
>
> Tzvetomir Stoyanov (VMware) (7):
>   trace-cmd library: Remove unused private APIs for creating trace files
>   trace-cmd: Check if file version is supported
>   trace-cmd library: Bump the trace file version to 7
>   trace-cmd library: Add new API to get file version of input handler
>   trace-cmd library: Select the file version when writing trace file
>   trace-cmd library: Extend the create file APIs to support different
>     file version
>   trace-cmd record: Add new parameter --file-version
>
>  .../include/private/trace-cmd-private.h       | 29 +++---
>  lib/trace-cmd/include/trace-cmd-local.h       |  2 +-
>  lib/trace-cmd/trace-input.c                   | 19 ++++
>  lib/trace-cmd/trace-output.c                  | 98 ++++++++++---------
>  lib/trace-cmd/trace-util.c                    |  7 ++
>  tracecmd/trace-dump.c                         |  7 ++
>  tracecmd/trace-record.c                       | 25 +++--
>  tracecmd/trace-restore.c                      |  4 +-
>  tracecmd/trace-usage.c                        |  1 +
>  9 files changed, 121 insertions(+), 71 deletions(-)
>
> --
> 2.30.2
>

This patchset is superseded by "[PoC PATCH v2 00/21] Add trace file compression"
https://lore.kernel.org/linux-trace-devel/20210510061636.1794357-1-tz.stoyanov@gmail.com/


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
