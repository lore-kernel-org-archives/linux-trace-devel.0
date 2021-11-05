Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 967F4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 14:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 788476120A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 14:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbhKEOhE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 10:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbhKEOhD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 10:37:03 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9BAC061714
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Nov 2021 07:34:23 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id m26so9062209pff.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Nov 2021 07:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=olsk3KR/CY9hRAq45U27c2VVN/h3E+kTws1eiRlUE98=;
        b=jz2rva+IFgwXUe25M5WfDCKE08hGUu1um7x86CG6TaNsJJHV0FqjdgRh1YpwTdpY4j
         IdjZhzoAlIJI999sI7t+zWxB86iHS//KAnmsz2v32puS/4BQCmhOeQo48jQDpijhLow7
         euPpBsF6hb6paua9Oa9uliI57zUwgQvzd4yznNwNRaqIhXbvsZ+eew7BIwPK+l/Qxm4m
         ypJmZM+OVpNvnGK4o5tjkqOiWL3WqPP9rCdq/bV0rKRjmVzTHpwYbqqp9FxHeq8u7Bqo
         b+HHYMqtucIvOMKNOHRVGMmr97dFfutCxuiQPQ455orZMCT0RcEmflNdrWS5G6lG9lqO
         Nc4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=olsk3KR/CY9hRAq45U27c2VVN/h3E+kTws1eiRlUE98=;
        b=5cTLaPMuLt7OYhQBweJp67c7pzaPA/hzfbW8yGkKZrHVjupVSM5KBgrFK/j5pKXkp0
         EyCDC4QApK6T3F5GbCjRLBNGFbp4CRZbScsCGe+WgG3zP4UrshbkzPwUvn4NbsGzXafV
         epqIYiYi6n3+OG8cSPFN9bp2fArrJ91g78Yo4JwkK2YLatghPMtvL7r5FON5osxvaYAy
         wZIo8cKxfCBx5B1B8gnV9q4Cg8BGILdwRYeJXCjCAwTLxsRjjs7lOztaJWSlGFuTpfZa
         TiVUM+9MqYgD6J16/uNwiDrmIW01S5UoJVnnpQxSDgkniT8b0XzstQJQ51MUW8LHp61T
         TjvQ==
X-Gm-Message-State: AOAM531Klnu5Eqp0UfywUUUuP4HRJRD2NP3EDbAxhdtWrr31D2xo9CGx
        YQlAc3+V3gJ15F8jRiMe3VHnVOL4we4aMnGP4s0=
X-Google-Smtp-Source: ABdhPJzxYk8Xjk0Zo5qtoAvKXo2G16zTQu1fPeriuPRcrt+GnmpThyRTYPt7IGzJStxfi3b4Edib7q68xMGbyggk31w=
X-Received: by 2002:aa7:9404:0:b0:494:6e78:67cd with SMTP id
 x4-20020aa79404000000b004946e7867cdmr9301903pfo.84.1636122863064; Fri, 05 Nov
 2021 07:34:23 -0700 (PDT)
MIME-Version: 1.0
References: <20211105121624.398717-1-tz.stoyanov@gmail.com>
 <20211105121624.398717-12-tz.stoyanov@gmail.com> <20211105102426.76a20a4b@gandalf.local.home>
In-Reply-To: <20211105102426.76a20a4b@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 5 Nov 2021 16:34:06 +0200
Message-ID: <CAPpZLN6E1f3KCnCxS_=D=Qjv2zxB3tiunie4uMZGBHJXm7BvHw@mail.gmail.com>
Subject: Re: [PATCH v5 11/12] libtracefs: Remove man page compile artifact
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Nov 5, 2021 at 4:24 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri,  5 Nov 2021 14:16:23 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > The libtracefs-sqlhist.txt.1 file is generated during the tracefs
> > library man pages compilation, it should not be part of the sources.
>
> Are you sure about that?
>
> What creates it?
>
> -- Steve

"make doc" generates it on my machine, and "make doc_clean" removes it.

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
