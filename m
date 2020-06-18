Return-Path: <SRS0=0fRq=77=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D876CC433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 16:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF25A20776
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 16:03:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dUPEIi45"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgFRQDz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Jun 2020 12:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbgFRQDx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Jun 2020 12:03:53 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0D0C06174E
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jun 2020 09:03:53 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id 35so2625969ple.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jun 2020 09:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WbER9m3BrbGBUB5jmWrKXqsoGxC6c1J2lueW2z0Eo2M=;
        b=dUPEIi45UCdxlasEG/CoD4z34eVa6DIwZmeBuJmlmShuHkZfI9hWih+Z6PYndIv07B
         pgaeBXu5jTJaBu/HVOmmYGsshw73MJ/5cQQqcxnANXgErEa/DLVYEdbz6qjPvD/ycKiU
         dSIWP/uXQdWvEwaUfPlltz69imj2M/E2SqXhM91HzD1Huc70TzFH1ZUx+BHFKTQxqGm9
         RoMLviLOVdBsw/xLvSYTxvjqg5LP2PEzN7epxFQ0+XkmaGmo9gM0rq+GRyetDvealpWi
         5lV+0s8kSOk/6EAHLmH//Vo5f7PVgvdCrZqVlkZX0Psyms1sVZdMDTvqrC2peJfS4179
         uAvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WbER9m3BrbGBUB5jmWrKXqsoGxC6c1J2lueW2z0Eo2M=;
        b=DGIs/jGD0amWhTMSxXENb+aCxoSh+9nYMq2l4MFWNNesFOaaXACELTMN0D+bgqgor/
         qnDO2phQHk2JoBBZ81D0apqMGuf+Ge+IhBWrIJ1/kmUCvItVc62vaPww+q7dNpeGOepj
         ZEX8ap2u6STuXxqDqGXOCBa5MV9aeyEdK3pDJQ8HtdqRv/oCTgXq5kzI/hdY2B5HuduR
         d6fvQNOcADsuG7QugI5f7JdtjCBsUO1LBb+Dm49L5IOS94Ni/83UstBtuMJ5Sy0cJqNb
         SHhr6q0fUfOQN50/QjGgc6DDTogLDCdsaQvsgc8IuFwgmVAAvlOTCBk7o9vWuWPyI7vb
         hwaw==
X-Gm-Message-State: AOAM532NIIMhhmfDEI/K1QlU2JArLlIwT/BDxYfARi3Gmn0mUaq86yCn
        Avyw0nuA+FThYv4/yFTLN/0D4zN1sKLB1vJinXsD3LFkHg8=
X-Google-Smtp-Source: ABdhPJxge+0FOmeZyWoEgiXG2P8/SvvFJLb41+Ys4g3uPKXxpkGJx+8dp+tCcmTxCRF9l6BOu/lOXILxLFqsBuuM2gQ=
X-Received: by 2002:a17:90a:22cc:: with SMTP id s70mr5217289pjc.2.1592496232666;
 Thu, 18 Jun 2020 09:03:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAPpZLN4RkWjAFBw=wShOMhQ0ECWJnDiOyQQPP6os68pSM9VeBQ@mail.gmail.com>
 <20200618095831.45958f30@oasis.local.home>
In-Reply-To: <20200618095831.45958f30@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 18 Jun 2020 19:03:41 +0300
Message-ID: <CAPpZLN6CKjMD4norOmvQ9PP0KXKrAGXr4PQxYhEqfvWUcFUiuQ@mail.gmail.com>
Subject: Re: libtraceevent sync
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Jun 18, 2020 at 4:58 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 18 Jun 2020 14:43:42 +0300
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > Hi Steven,
> > These are differences in commits between both libtracevent
> > implementations, in trace-cmd and in kernel. Please look at them, I'm
> > going to synchronize both trees according to this list.
> >
> > trace-cmd/traceevent commits, should be added in kernel/traceevent:
> >   "trace-cmd: Introduced new traceevent API, for adding new plugins
> > directories."
> >      https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=5c8ac22552af4213f81cb7839f7f262252a80855
> >    "trace-cmd: Optimize pretty_print() function"
> >       https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=d8c1349f44ca9ac8ef0e7f198a133603ea399a95
> >    "trace-cmd: Move plugin options from trace-cmd to libtraceevent."
> >       https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=5988d3085d9ec5d7418ad49bc8c7e88c832d5ac5
> >  "trace-cmd: Remove trace-cmd plugin handling routines"
> >       https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=b2cf2e46a6d013d4037118274cc783570277ce32
> >   "trace-cmd: Add proper KBUFFER_TYPE_TIME_STAMP handling"
> >       https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=e5de44dd43523764d18dc773f82ce1b738c22e64
> >    "trace-cmd: Add --debug to trace-cmd report"
> >       https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=8cdbccd5ef422dc518e7246aa1c41922e834120b
>
> OK for the above, but they the subjects will need to change to follow
> the lib/traceeevent subjects. For example:
>
>  trace-cmd: Optimize pretty_print() function
>
> would become:
>
>   tools lib traceevent: Optimize pretty_print() function
>
> Also, the change logs may need to be tweaked to be specific for the
> library. Though they can still reference trace-cmd as a user of the
> APIs.
>
> But keep the authors of these patches the same (From: lines).
>
> >
> > trace-cmd/traceevent/plugins commits, should be added in
> > kernel/traceevent/plugins:
> >     "trace-cmd report: Add -O offset for function plugin"
> >          https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=1785022e12cf0079889c519ffc7157f2143326ea
> >     "trace-cmd: Move kernel_stack event handler to "function" plugin."
> >         https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=8ba49dad8877fbd27cd6659397a01fb9243f7953
> >     "tools lib traceevent: Add builtin handler for trace_marker_raw"
> >         https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=d9f4b4043a68602f869c8c73b499cd7c7b4194b9
> >     "trace-cmd: Add plugin for decoding syscalls/sys_enter_futex"
> >         https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=25224f44a75e2ede5c2085683c0a008980ca87e7
>
> Same for the above.
>
> >     "Change to SPDX License format"
> >         https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=ff551288621dd07e9a9da433cb5b9f539c025cb6
>
> This hasn't already been updated (haven't gone and looked)?
Most of the files in "tools/lib/traceevent/plugins/" have no "SPDX
License" header, should we update them ?

>
> >     "trace-cmd: Add more SVM exit reasons"
> >         https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=4421d9551b903d720bb8534a02c3564187eab045
> >     "trace-cmd: Add plugin for tlb_flush"
> >         https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=7a0ead47bdb85288c855fafae24719b1ca9b907e
>
> The above are fine with the same comments as the others.
>
> >     "trace-cmd: Add hack to report out blktrace"
> >         https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=9e0fd22b14805a3a3219a99bc5eccebf70f5484a
>
> Hold off on this one.
>
> I'll take a look at the rest later.
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
