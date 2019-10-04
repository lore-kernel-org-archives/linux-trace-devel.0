Return-Path: <SRS0=JRVv=X5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BCDC4360C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 14:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEBFD207FF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 14:48:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I5s2qX6I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389196AbfJDOs4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:48:56 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38258 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388870AbfJDOs4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Oct 2019 10:48:56 -0400
Received: by mail-pg1-f195.google.com with SMTP id x10so3896563pgi.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 04 Oct 2019 07:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EQVC34WtemFHaUyOG3VhRWCt2aH9ZA4vLeVPlx0VOmM=;
        b=I5s2qX6IJik0/L5bcBfj09xuKqw+UCsT/AZbRQAUrl9GDhMZocAKws0inB0GxxiHf1
         8XcMvsqBoTGG0i2zHzm8Q5hlMdWeypK4NLFavrLo2QthkeYtQt3c9ib+fGn6hOcEYgKZ
         KKuVikqh+Dp8/L/5pogsg2E6T2XHB9ZWg2Qd6tUVO7i4Vi9mMvAyBE1J5VXjj5QuPHSW
         MWo+6IgdgUJTGxNTExIGSXMS/HPhrDPH6ANejLdMNXpJbRYW3ipA6qm1NNxDd+7fGiiQ
         BJ4epvlEIO5utkd2fDZj6b2ELSN+8UAbTif4WTCPjh0wEJ52VVmPY43/ToISqzFwK6Lv
         uITA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EQVC34WtemFHaUyOG3VhRWCt2aH9ZA4vLeVPlx0VOmM=;
        b=nkVelOa9b5NmhTwKsAzTcIfh6Z7tX5a/dkQmA6UVzNOO0jsygtN3N59x4wi1AKHR4a
         zofgpo9XEFuOF887FbC7PQmkfA0SvRinEaL8HoyWfBw0Ftzgk7J59GMUvYLG5iNGVppt
         oAlzeT8+M+9AcpojXpUAA9WSvDiten2DB5p+EcdU6dJN4k5B5W9DEYa35ZZdiWR23pen
         WUAYU8GRJe5DHPhGrlLI2nOaHldLfyXhhThKsVev8k5IifIKB0mntLWVqIVumJm9EDQV
         OtoNpb28qWYWIshAWFxQGD6uZO+MTmBO/Uk+QldjmEM1hfZiqW7HfzZ4f/N8Uxb6WTOH
         R8MA==
X-Gm-Message-State: APjAAAV2uh2slRl7yg/GBUfHn4uAsCX1DjWKSgYTQC7H1ETuaASMOt18
        zxdWIJmOdMKbW2rmb56YhOHHj6ttKZYDq/TPcqtLLg==
X-Google-Smtp-Source: APXvYqzJbZ28u8P2DEywom6HCMMDGGPhJverWX8LYoZgM287uI9u7PSPqj3WHaCUrq2Eu3t0G2r9j7n+FOPIF5wtWiM=
X-Received: by 2002:a17:90b:957:: with SMTP id dw23mr17747536pjb.32.1570200535267;
 Fri, 04 Oct 2019 07:48:55 -0700 (PDT)
MIME-Version: 1.0
References: <20191004133647.27759-1-tz.stoyanov@gmail.com> <20191004104648.64c42b28@gandalf.local.home>
In-Reply-To: <20191004104648.64c42b28@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 4 Oct 2019 17:48:43 +0300
Message-ID: <CAPpZLN5xoO52HNN7h8Yu8gTe+LYMh6fKp_n0r8auPNryK+aWaA@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] Remove redundant trace-cmd plugin handling logic
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Oct 4, 2019 at 5:46 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri,  4 Oct 2019 16:36:42 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Currently there are no trace-cmd related plugins, all of them
> > are designed to be used with libtraceeevnt. As both libtraceevent
> > and trace-cmd have logic for managing plugins, the one in trace-cmd
> > is redundant. Those redundant code is removed and replaced with calls
> > to libtraceeevnt plugin APIs. When trace-cmd has to load any plugins,
> > it uses libtraceeevnt to do the job.
> >
> > All existing plugins are moved from plugins/ to lib/traceevent/plugins
> > directory, as all of them are designed to be used with the traceevent
> > library.
> >
> > An initial infrastructure for trace-cmd specific plugins is added -
> > new lib/trace-cmd/plugins directory and an initial set of APIs
> > for working with trace-cmd plugins.
> >
> > Tzvetomir Stoyanov (1):
> >   trace-cmd: Change plugin install directories
> >
> > Tzvetomir Stoyanov (VMware) (4):
> >   trace-cmd: Move libtraceevent plugins in its own directory.
> >   trace-cmd: Rename plugin_python to plugin_python_loader.
> >   trace-cmd: Load libtraceevent plugins from build folder, if exists.
> >   trace-cmd: Add initial infrastructure for trace-cmd specific plugins.
> >
> >
>
> Hi Tzvetomir,
>
> Not sure if you noticed, but I pulled in parts of this patch series as
> they were not dependent on the patches is question.
>
> I'll take a look at the patches not yet in the series.
>
I just noticed it, going to rebase and send the next version of the
series today.

> Thanks!
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
