Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 583C9C2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 10:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38E33613AE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 10:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhFVKxS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 06:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbhFVKxS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 06:53:18 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C035C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Jun 2021 03:51:01 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id h16so11855295pjv.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Jun 2021 03:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AcxtQQTDaK61sIMxr9w2DznGT0Mx65rvI0akKXO9wzA=;
        b=WpL+FqiNfN39kn8NR/G0lUhxbehDM3NiZAoyhDqXQW0oZpkofZ3jRlzlc7Y/tSBgio
         s+h33rIcrTshdpqVXOBR7zqMwS4Snnze10WxN/YDginZP5saw2WTG+6CUqI5NLLVIhix
         KDW3QG18D0JkHU4I6Hi7ZWy23xjLySWFzloBV6L6FR2Pw4c6vUsB+wa47WGbISPbJ1RL
         5eZCR1QG2XttE9ukSBUxgCa+8TDxIb7tut482yH2nXnDWJONPfuvQutSZro+WonAFtkM
         Rw83j2wwnFo5jMrmYae7qXhJ6+ZP1jNTBufsupOKdsVUwafqxgbNTN0yvbRzrGrRD5gB
         w5kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AcxtQQTDaK61sIMxr9w2DznGT0Mx65rvI0akKXO9wzA=;
        b=oG+uapu25+0GKqxrirtLVlFEz0juGLTg9fFtAqs3PCEbVxxWfxqWsbHIRernff1Ye9
         S24hXTfecHjSnmNuU7BywpJc4z706xA+6Wxs6Oo6fdMkKaZ22BxYfX5i4477nLmdIwIV
         Nq8bm+Y6o0+RCTBl5Ib9XYUQjniVv52ykbICvRUhV/bniNzaZRgkRqhG1ATfyzIvZglb
         BpZFIjloWnDZ92f9EK7mkaCwbOhWoYwiD2VbKZYoZEuLn4eNgqsn8p9qchzXX+q9s3gm
         lwxBFM9WUl+Q/wFI4tZtsd4fAvoXzddKOk9OOo1Qzk4BnC8uh7uCRHT5iQCm4XZUAAzB
         UMAg==
X-Gm-Message-State: AOAM533+1C4kLB33AzuHMyq78dQvOKmfyXePTHtQcVwTLIB6SDSJxz2H
        qCMSgtBqlzY6xg3ajPp2V9TxFJedGzsY6M91nIGSaQlT4LA=
X-Google-Smtp-Source: ABdhPJydGDdXLcbJGoyEakEcEWHw2G5U6lB27Ps2uJRMPdp9fsZbwcjUXCePfwEZy1Ug6GTs1cZElzFnC4Las21odZk=
X-Received: by 2002:a17:90b:10e:: with SMTP id p14mr3383815pjz.153.1624359061117;
 Tue, 22 Jun 2021 03:51:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
 <20210614075029.598048-26-tz.stoyanov@gmail.com> <20210621192310.43e68a92@gandalf.local.home>
In-Reply-To: <20210621192310.43e68a92@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 22 Jun 2021 13:50:44 +0300
Message-ID: <CAPpZLN4dHKxa2DztSurSow=PbsFSyuLgkifHt8yvJ6kL8pvu8Q@mail.gmail.com>
Subject: Re: [PATCH v6 25/45] trace-cmd: Read compressed trace data
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Jun 22, 2021 at 2:23 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 14 Jun 2021 10:50:09 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > When reading a trace.dat file of version 7, uncompress the trace data.
> > The trace data for each CPU is uncompressed in a temporary file, located
> > in /tmp directory with prefix "trace_cpu_data".
>
> With large trace files, this will be an issue. Several systems setup the
> /tmp directory as a ramfs file system (that is, it is locate in ram, and
> not backed up on disk). If you have very large trace files, which you would
> if you are going to bother compressing them, by uncompressing them into
> /tmp, it could take up all the memory of the machine, or easily fill the
> /tmp limit.

There are a few possible approaches for solving that:
 - use the same directory where the input trace file is located
 - use an environment variable for user specified temp directory for these files
 - check if there is enough free space on the FS before uncompressing

>
> Simply uncompressing the entire trace data is not an option. The best we
> can do is to uncompress on a as needed basis. That would require having
> meta data that is stored to know what pages are compressed.
>
I can modify that logic to compress page by page, as the data is
loaded by pages. Or use some of the above approaches ?

> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
