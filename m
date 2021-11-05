Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE7E6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 15:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D043860F70
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 15:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbhKEPYv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 11:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbhKEPYv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 11:24:51 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C01C061714
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Nov 2021 08:22:11 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id w9-20020a17090a1b8900b001a6b3b7ec17so3472924pjc.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Nov 2021 08:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d7G+ZX6lshRk5AvMkQw2EWE5URL9CztjAy235mYM3go=;
        b=O/ffo4HbS/Knqux518TM1dIZG3RVkoyy0wmjm8i4KNbaNhtDT4fb87TWmOZYVMQETi
         h4d1UI3hsXTzaK+WTEEJPnSMnMg8c30w2Az19AuJ9nnzWbGyLKSfZ4LwyA9/y/cn+r4n
         bhkG72VryBCL2v6pjidQMyOKGH9AKX4Fpg1NRQg2zQ5knPtRwCTDR6bb9dW9LsgOycgh
         kB3lgkpqC9VfhSfUVj5GdMqhC3lnsHOR5AG0H3pE0IoDH71IgMxA91E/LS3+ddBuF+7o
         T4pp7nxE0mD5+gBqDCd/jd5x4o1Mmjgzs7gBOn0xBV0dpyaFfnY4x2PXFMjaqNwUyveH
         EuXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d7G+ZX6lshRk5AvMkQw2EWE5URL9CztjAy235mYM3go=;
        b=IAaIrQK1QB9AwTi4TLRoYqzxoVYGT+IAxD7+oLjMKqjC5qW09i0z3XAAsZsvbbku08
         EIad92fDhHUxRbZXshe8nBAOxsZqbO7KIkcJNdHu+srX+Q7pRo+vzNsVkpPd/RH+0u/u
         ByrFuUxZJ+Zr9C0kZYUrZcNbL7HYL7yMqgRKXEgx9RIn81wWT7LMhamWNR+nanr/g5wR
         VdVx8q/mv2ZTgwEoLuMuBcRWyIEANgIIL4hE/7isxljvlcuJlg1crcJM3543HFr6o97M
         YPjFJATy6Cb3CZopoBD2MDS0yFh7TtjLZFdmownwC/pvtk7XegtbURQyWsNSeEG5hc/x
         d00w==
X-Gm-Message-State: AOAM530XCMdjuCdvZW7x3xxibd8QAMHKo24Cag/8tJqXi+q9uUv4qVVG
        oNYGrbd7ePMRHmd5ehz/pF20GTsTIuszEUze5hw=
X-Google-Smtp-Source: ABdhPJxEoZ33gBKBM1+rlAh/he5fnFlmx56bUj/fuOsoM2ho05rYeOymq2sab40uesrgiGqhLbEIG3Gb2dXkdBqjQ9U=
X-Received: by 2002:a17:90a:5917:: with SMTP id k23mr31118459pji.111.1636125731438;
 Fri, 05 Nov 2021 08:22:11 -0700 (PDT)
MIME-Version: 1.0
References: <20211105121624.398717-1-tz.stoyanov@gmail.com>
 <20211105121624.398717-2-tz.stoyanov@gmail.com> <20211105110310.429d58e8@gandalf.local.home>
In-Reply-To: <20211105110310.429d58e8@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 5 Nov 2021 17:21:55 +0200
Message-ID: <CAPpZLN5KFR+Z3=r38pGO84knCsqjKH9A_Tf544=NGUvS3GE41A@mail.gmail.com>
Subject: Re: [PATCH v5 01/12] libtracefs: New APIs for dynamic events
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Nov 5, 2021 at 5:03 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri,  5 Nov 2021 14:16:13 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > +static void init_devent_desc(void)
> > +{
> > +     int i;
> > +
> > +     BUILD_BUG_ON(ARRAY_SIZE(dynevents) != max_dyn_index);
> > +
> > +     /* Use  ftrace dynamic_events, if available */
> > +     if (tracefs_file_exists(NULL, DYNEVENTS_EVENTS)) {
> > +             for (i = 0; i < max_dyn_index; i++)
> > +                     dynevents[i].file = DYNEVENTS_EVENTS;
> > +             return;
> > +     }
> > +
> > +     if (tracefs_file_exists(NULL, KPROBE_EVENTS)) {
> > +             dynevents[ffs(TRACEFS_DYNEVENT_KPROBE) - 1].file = KPROBE_EVENTS;
> > +             dynevents[ffs(TRACEFS_DYNEVENT_KRETPROBE) - 1].file = KPROBE_EVENTS;
> > +     }
> > +     if (tracefs_file_exists(NULL, UPROBE_EVENTS)) {
> > +             dynevents[ffs(TRACEFS_DYNEVENT_UPROBE) - 1].file = UPROBE_EVENTS;
> > +             dynevents[ffs(TRACEFS_DYNEVENT_URETPROBE) - 1].file = UPROBE_EVENTS;
> > +     }
> > +     if (tracefs_file_exists(NULL, SYNTH_EVENTS)) {
> > +             dynevents[ffs(TRACEFS_DYNEVENT_SYNTH) - 1].file = SYNTH_EVENTS;
> > +             dynevents[ffs(TRACEFS_DYNEVENT_SYNTH) - 1].prefix = "";
> > +     }
> > +}
> > +
>
> I would have kept your bit_index() function to simplify the above. I just
> meant to use ffs in that function.
>
> static inline bit_index(unsigned int bits)
> {
>         return ffs(bits) - 1;
> }
>
> -- Steve
>

The problem with that function is that it cannot be used to initialise
constant variables, gcc complains about that. The ffs() API has no
such problem

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
