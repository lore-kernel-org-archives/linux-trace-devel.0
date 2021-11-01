Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BA7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 14:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3C2F60ED5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 14:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhKAOYG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Nov 2021 10:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbhKAOYF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Nov 2021 10:24:05 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966C7C061714
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Nov 2021 07:21:32 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gn3so12250950pjb.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Nov 2021 07:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vNxCcmH9maFs/g/YmA8nOmgt16pvDSlJRBuhjpXiGao=;
        b=fzNrLsiFU150RzC4hFGtSn8xmrjrsMdF3jOwHcZDwaZhTMURfTCw+EWpJxGv4j0F78
         Dm2gANPQerPFjuKF1cKcixavjU7KG/Jy+RZ90wtH41/aDH17XPAwjq7tJd2hJpe/j+YA
         fsMqYxg3bzp/iICyjh9vSa/bBnlz9wuKk8wEu+JIIDOJVB9VH+rsi9mNQ1SHBT53k+si
         NsHpvzzJS9bHhr+oFL7VWl+7Htj21dhQGcFfU2dXaIZU51ez37ZxBKqOuXqVcmhwt9kf
         HQKgGoDtCoIqZ0ouKmW/ISwB97fgRlI99hjyFESs2MbxFmP21rCE2V+16K4Jl1VbO9ZS
         dAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vNxCcmH9maFs/g/YmA8nOmgt16pvDSlJRBuhjpXiGao=;
        b=tKWrwIcwhoTh72LKmdpJufUzjCXC3EQEBCGgYMG4BB/cQFZraJhPXui/BZiyZue2sT
         wNzLUAXsguLBW01F58VBDSMqtgycr1GgZ0txJsZI8NZuAiUsfx5IorIJ0ZZJuGMRAqrK
         Ww18hyrHSFbzhEqGHC66/HWmqxfMCE+sV2Fk3EHAbbGdPAz6WL+DtPxJ0NWcbdl5Nlid
         XHJxBbzunw1dn8MepZP2qrS7Rgx/+N+wYuF6/Je47ZRrvXSoCjkdt4CCXKeDaoXyILQK
         opHHKemu40AyUSaqzs8rPzbb3JTrc4kr3rFv9bMZhGcxZM8TRysdmob9bG44zHeLrrc0
         xR8g==
X-Gm-Message-State: AOAM532+/HfY1TPCU+PZBkJdsv/YDXsk97wp/SsplVFkaux8eJpkMmsg
        2egRvpq4ufgGZHlPDzV6AQa7PFT3bAolW6tgmvo=
X-Google-Smtp-Source: ABdhPJwrnAB9MvnsltvoSr+aEVIdWpxvIfEoVCd/ntfXWZl3kgRu7sJbvV+s5psZe5HuWqPVdLnFBf1GyWCN0PkFAjA=
X-Received: by 2002:a17:90a:5917:: with SMTP id k23mr38772312pji.111.1635776492123;
 Mon, 01 Nov 2021 07:21:32 -0700 (PDT)
MIME-Version: 1.0
References: <20211101090904.81454-1-tz.stoyanov@gmail.com>
In-Reply-To: <20211101090904.81454-1-tz.stoyanov@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 1 Nov 2021 16:21:16 +0200
Message-ID: <CAPpZLN4BwrgGQ4VDmgPHWOGpawc32P5RKVxOjhpXgrHCb69qmA@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] libtracefs dynamic events support
To:     Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Nov 1, 2021 at 11:09 AM Tzvetomir Stoyanov (VMware)
<tz.stoyanov@gmail.com> wrote:
>
> The libtracefs logic that works with ftrace dynamic events is unified and
> capsulated into internal APIs. This change makes the code more consistent
> and reusable. Also, adding future libtracefs support for uprobes and
> eprobes dynamic events is simplified.
> The existing library APIs for kprobes and synthetic events are reimplemented
> using the new dynamic events helpers.
>

Forgot to add that this patch set depends on "[PATCH v2 0/4]
Modifications of some 'hist' APIs":
 https://lore.kernel.org/linux-trace-devel/20210924095702.151826-1-y.karadz@gmail.com/

> Suggested-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>
> v2 changes:
>  - Removed triple pointer from the APIs.
>  - Reimplement dynamic events parsing using strtok_r instead of strchr.
>  - Coding style fixes.
>
> Tzvetomir Stoyanov (VMware) (12):
>   libtracefs: Add new internal APIs for dynamic events
>   libtracefs: Rename tracefs_get_kprobes API
>   libtracefs: New kprobes APIs
>   libtracefs: Remove redundant kprobes APIs
>   libtracefs: Reimplement tracefs_kprobes_get API
>   libtracefs: Change tracefs_kprobe_info API
>   libtracefs: Reimplement kprobe raw APIs
>   libtracefs: Extend kprobes unit test
>   libtracefs: Update kprobes man pages
>   libtracefs: Rename tracefs_synth_init API
>   libtracefs: Use the internal dynamic events API when creating
>     synthetic events
>   libtracefs: Document tracefs_dynevent_list_free() API
>
>  Documentation/libtracefs-kprobes.txt | 131 ++++---
>  Documentation/libtracefs-synth.txt   |  20 +-
>  Documentation/libtracefs-synth2.txt  |  10 +-
>  Documentation/libtracefs-utils.txt   |   6 +-
>  Documentation/libtracefs.txt         |  12 +
>  include/tracefs-local.h              |  35 ++
>  include/tracefs.h                    |  38 +-
>  src/Makefile                         |   1 +
>  src/tracefs-dynevents.c              | 492 ++++++++++++++++++++++++++
>  src/tracefs-hist.c                   | 110 +++---
>  src/tracefs-kprobes.c                | 508 +++++++++++++--------------
>  src/tracefs-sqlhist.c                |   6 +-
>  utest/tracefs-utest.c                | 408 ++++++++++++---------
>  13 files changed, 1187 insertions(+), 590 deletions(-)
>  create mode 100644 src/tracefs-dynevents.c
>
> --
> 2.31.1
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
