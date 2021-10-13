Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE97C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 10:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77DD261077
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 10:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237931AbhJMKFb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 06:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237525AbhJMKFa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 06:05:30 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31D7C061570
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Oct 2021 03:03:27 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id v20so1447091plo.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Oct 2021 03:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/DT2L7FSIjYn4DuhFGG3gOEnMEJbCo2+fy03RsodpeA=;
        b=kMYDvRY1JyvY0Mx1/B5xd6eLJYkOueXzSvt73NYjcE6/FtTtNLfkBlp3qeTDxmotO+
         S10gN3qD1cokJTAwev4GBBe3tSM98vdsVwDCOzP5BYAwavroH9LJ8rMYQO7/EEv0VuOd
         RlHx/VvZQzW4mLN7cRH9XwZLl1DzNN/j/RmjnWMQPCEQ+g4sA4aHJoS7cT03rX2ILJdr
         AoWm693z1egvA7mjB3kqcdKN8xHIeBqDagerRFDLoBfX6KbiKKLnZc0L3/HM7aV+QCW1
         u3Y5IxODdlNmafrOoonCW++Ok8Q8CGbVdZcWsiQ0pHoyUqhCKIfvDg7WQENxj539sWnw
         YOCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/DT2L7FSIjYn4DuhFGG3gOEnMEJbCo2+fy03RsodpeA=;
        b=bI7DEbp4e8xHcE31T2givOTmS4/JP7+/JGJT+qWkhsQvHn0s31gqEm/Kc3pPpsW9qS
         urOOGnxhwJzpbECd4sZ4sgxdzUFw6Eg7uXsEBZlD/B0am+IOUZJcRU7T+zswhlBWEsiD
         EBcI6bLqAuPo9ZDujLcMNQCd3j7JHw7Wrn3r5sNhybi60cbZ1ZEm1Lkq6myyPGlOmobR
         gvV8ayyKHcch2gyvavvYqxHcH0wFqPiPi3U0LbNIEFeGb7SJkEdVglu8T8pwiDP3BTwt
         uJWCmSWFlMEJLs4JrGRyTGv0JGjrYEDnBgOwURn+3sKfotpAzdMqW0N4q/FyEQh9Eie8
         BRUQ==
X-Gm-Message-State: AOAM5329zEzug+Nt8xLH4NgDPwNOQUWRkTp6NdfAxTlRldEpMcT9GtSJ
        UkY+0B3iEl7MnBN7c9rcalFDQkxF5FAYA+bV38o=
X-Google-Smtp-Source: ABdhPJzGDNM+IfxFPLp2p16q2RMai5wVUoWHQasgWfL0KWsG99IVQUvXPnMEDrJRbaBFyofdpeV8v2U4hyE0wkMM8ig=
X-Received: by 2002:a17:902:c402:b0:13f:1c07:5a25 with SMTP id
 k2-20020a170902c40200b0013f1c075a25mr25520045plk.38.1634119407150; Wed, 13
 Oct 2021 03:03:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210923094526.765059-1-tz.stoyanov@gmail.com>
 <20210923094526.765059-3-tz.stoyanov@gmail.com> <20211012231401.22c8c22f@oasis.local.home>
In-Reply-To: <20211012231401.22c8c22f@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 13 Oct 2021 13:03:10 +0300
Message-ID: <CAPpZLN5=_dcdOGR7E3VBrT-QQ=VH6m5nP96mz8OrAifWR6fR4A@mail.gmail.com>
Subject: Re: [PATCH 2/3] trace-cmd: Read and use fraction bits from TRACECMD_OPTION_TIME_SHIFT
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Oct 13, 2021 at 6:14 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 23 Sep 2021 12:45:25 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > @@ -1235,7 +1236,6 @@ timestamp_correction_calc(unsigned long long ts, unsigned int flags,
> >                         struct ts_offset_sample *min,
> >                         struct ts_offset_sample *max)
> >  {
> > -     long long scaling;
> >       long long tscor;
> >
> >       if (flags & TRACECMD_TSYNC_FLAG_INTERPOLATE) {
> > @@ -1243,15 +1243,12 @@ timestamp_correction_calc(unsigned long long ts, unsigned int flags,
> >               long long offset = ((long long)ts - min->time) *
> >                                  (max->offset - min->offset);
> >
> > -             scaling = (min->scaling + max->scaling) / 2;
>
> So the max->scaling is not going to play a role here?

I assume that if there is a clock scaling - it should not change
runtime, fraction bits and scaling should be the same from the VM
start. So there is no sense to make interpolation, just use the first
value.

>
> Does this work for other methods besides KVM?
>

We have only PTP and KVM till now, only KVM supports scaling. PTP just
sets scaling to 1 and fraction to 0. Unfortunately, I cannot test even
KVM scaling - I failed to enable it on my system.

> -- Steve
>
>
> >               tscor = min->offset + (offset + delta / 2) / delta;
> > -
> >       } else {
> > -             scaling = min->scaling;
> >               tscor = min->offset;
> >       }
> >
> > -     ts *= scaling;
> > +     ts = (ts * min->scaling) >> min->fraction;
> >       if (tscor < 0)
> >               return ts - llabs(tscor);
> >
> > @@ -2337,37 +2334,16 @@ static int tsync_offset_cmp(const void *a, const void *b)
> >



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
