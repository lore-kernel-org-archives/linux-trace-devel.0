Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8760DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jan 2022 10:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbiAQKIV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 05:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236048AbiAQKIU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 05:08:20 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EA9C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 02:08:19 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id v2so5818583ply.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 02:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xf7bstkmq0yllPyL+RYAq29fbT3mSSmgsoueFAi3e3U=;
        b=p/n0NpVK92zHSPlAPaPmd32nR/l+uLKn5FzigTSnEu6jAH6fRDSxatZIiCwPMO8Bsa
         DQYk6fidktGZShUCBL2KnerzhhU8b7nnn294VvN5pLvL47Mtv1OPoUxaQRfJaiZn3jad
         TGZKWmutOAlwMASzsoBVBvSBkLsIHlx5ijZOR8cXmQNs0Bo6lZcja7gnTpcz1XsPqnCd
         3Ns8WPAaBqjr3MZWlMYE2V5biwVa9wfANlOqSYxWXLbzQkq621RsCedqPn5vBlzC+1l8
         kV7Vzbhk7bJ9gLSSHzthYzB7tgkqdDehFiy62MydvAKAnf8Ee8ZDWdvQDdEV9xuMbyeX
         u/0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xf7bstkmq0yllPyL+RYAq29fbT3mSSmgsoueFAi3e3U=;
        b=zxFPiWVZ2yMChsDClhWZzB5pdBLMYUHdymrFcP/PXFOlCNqfm5FlI1T5My52rchVF9
         OzdItswMK91YS/K6BlZjCyTHADb3Zk5VESNCYi91U7TufxKxPl83/V13CkBG+4H9MmyO
         VnW41cgId6HpEffDCuivvxIsS2RVOBB4qy000uEh2IoLo3fZOPSJYaA42FjUWP+fDJLW
         gppem5lYa1Xilf8gNx5ol80AfrTwd21VWXJdAaF3ovWGI3av4Ai33+GRtO2+Rgd6kfI3
         koV/Q/RDPARcnwN44bQw5YegmpDO5fe8US/EN3x2+XsuiT0U6TLknFuuoKsECgOb5MNi
         TaNw==
X-Gm-Message-State: AOAM531n/il949Xx3jWmXyX9tG9AAH34NnYGNeZ3KbuNedacznmnz9DG
        GXKuoeLWNwfF359xOoPDccYXQAH9pBueesqx0P1bBwlAAe8=
X-Google-Smtp-Source: ABdhPJy6MmZdnZIFKFAE6ffwRa6FoxHn3AUuEMBHsvyKmTbqSAHk1zS6UAOlHcGnqx7rBEsx6nlFoh7sGRbzYKACcJk=
X-Received: by 2002:a17:90b:4c09:: with SMTP id na9mr23990885pjb.96.1642414099154;
 Mon, 17 Jan 2022 02:08:19 -0800 (PST)
MIME-Version: 1.0
References: <20211210105448.97850-1-tz.stoyanov@gmail.com> <20211210105448.97850-6-tz.stoyanov@gmail.com>
 <20220115075856.7c5f325d@rorschach.local.home>
In-Reply-To: <20220115075856.7c5f325d@rorschach.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 17 Jan 2022 12:08:03 +0200
Message-ID: <CAPpZLN60snWoE=qa=vpeoVhdxWSLD2v9oTWJWKTTuF8zgwmBKA@mail.gmail.com>
Subject: Re: [PATCH v7 05/25] trace-cmd library: Add internal helper function
 for writing headers before file sections
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Jan 15, 2022 at 2:59 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 10 Dec 2021 12:54:28 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Introduce headers before each file section, in trace file version 7. The
> > section header has the following format:
> >  <2 bytes>, header ID
> >  <4 bytes>, offset within the strings section, where the section
> >             description string is located.
> >  <2 bytes>, section flags:
> >      1: the section is compressed
>
> Would in make more sense to have the ID and flags together, followed by
> the string? That way you could use a normal structure to represent it.
>
It would make sense in the previous version of this implementation,
where a dynamic string was stored between the ID and the flags. Now as
all these are in fixed positions, the order should not be a problem.
But anyway, I'll change it in the next version.

> struct {
>         unsigned short                  id;
>         unsigned short                  flags;
>         unsigned int                    string_offset;
>         unsigned long long              size;
> };
>
> Otherwise, all tools to read it will be forced to read each part
> individually. I can imaging that being annoying in the future.
>
> -- Steve
>
>
> >  <8 bytes>, size of the section
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
