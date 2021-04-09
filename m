Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A3FC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 13:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E62B61181
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 13:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhDINr6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 09:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbhDINr4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 09:47:56 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D26C061760
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Apr 2021 06:47:42 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id d5-20020a17090a2a45b029014d934553c4so3981443pjg.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Apr 2021 06:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xF9ogwD+KEmAsDndyhH0jjvBeRyCPuQkoLUXEvQbO4k=;
        b=OURi2iruE0HKSScr1IdK3k4P9Qwzz4HzZ1Ys2KjqGPNLLutVkXN88EKIZsbqSoXng/
         pRBYO8N48MUd3nTNdLOB4CGbdEGv6YEu4d+R4luN1Csk51FVEjlMwlaSayGwLZibnsm5
         2n/vhjXRdvv/Mr+Yvw7kW9F5nDlaIPmynt24LBRzxnL+1kJu9+XMRa4XBEJo3FIB3NI/
         CtBEGcNfsG2qujCkoxNGihUMgTvubEa1estSMwDt6WXdWd5Dpqiy8GNxlISYp1p4QJq5
         tvTXAAYbudlX++I2OmnrtBpNYrsEt95sUqqGWTJ4xE1bjEHRxBaicgA3VdWSSpzu+2q1
         7f1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xF9ogwD+KEmAsDndyhH0jjvBeRyCPuQkoLUXEvQbO4k=;
        b=YAzgbj65fKhR6+y/ccCwCAdaXnDZ7QaJRxmWjw2itfyOhLvdm9NuQ5PVjLqlQ8RBHE
         1Ph5KX0d7WNZtz4lKi9Uwm8mlwePCQ+msIDHZPW+75x10dhidfOKDQaPc6MSjH1YdwUV
         2LPSvg3m+0JwVUhIaXXLtjdeHmhuNLiLtue5oJxtAMDZOVr4Oz6qvNRdbf52M67GyQmt
         sltrSfMG80vLKAoXwHOHfdsP2hY5FZ7WN2Nuc9+b5vXjloe1nWpGRpR9Bu99OeGIhzoy
         SumK/rL59gETd/7frsJLMV/kBKh2U/iaFg3mgVk+t8hSMl0VQY+OgdMPzzYeiFr+7G2N
         2trA==
X-Gm-Message-State: AOAM532iiu4qzwVt+BT4Z3+vq6IWByz1AaZvGCWcuihFq3F3vecnh9OV
        +eS7HXc0KZ8+WSVnBmMMMW+4exkxr8Ebd+bahpafIEdqVSs=
X-Google-Smtp-Source: ABdhPJxohiZUxvCl6Esk0DEKfkKRiBQWE2bqNVUPRVbSm4cujHMzKvnt0gT8/NO5Re1+mjImaTnNH7q5rOLKcgSFxtc=
X-Received: by 2002:a17:90a:ad84:: with SMTP id s4mr1886006pjq.153.1617976061733;
 Fri, 09 Apr 2021 06:47:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210409042739.3179257-1-tz.stoyanov@gmail.com> <20210409091215.03ceca3d@gandalf.local.home>
In-Reply-To: <20210409091215.03ceca3d@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 9 Apr 2021 16:47:25 +0300
Message-ID: <CAPpZLN6s1_XHYbBUmDwSeCEAk_M-ec2FXnf-F1kH3q6mOaWzGA@mail.gmail.com>
Subject: Re: [PATCH v3] libtracefs: Add new API for open trace marker file
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 9, 2021 at 4:12 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri,  9 Apr 2021 07:27:39 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Added new APIs for working with trace marker files of given instance.
> > Write strings in the trace_marker file:
> >  tracefs_print_init();
> >  tracefs_printf();
> >  tracefs_vprintf();
> >  tracefs_print_close();
> > Write binary data in trace_marker_raw file:
> >  tracefs_binary_init();
> >  tracefs_binary_write();
> >  tracefs_binary_close();
>
> Thanks Tzvetomir, this looks exactly like what I wanted.
>
> A few nits with the code, but I may take this series as is and then add
> these changes on top, since I want to get this library done this week. Let
> me know if you have any issues with what I plan on changing, or just let me
> know if you are OK with it.

I'm OK with these changes. I was wondering about using a mutex to
protect the open, close and write, but decided to wait for your
changes that introduce the mutex and then to reuse it.

[ ... ]

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
