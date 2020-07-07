Return-Path: <SRS0=/1KP=AS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD0C8C433DF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jul 2020 15:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5DA420738
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jul 2020 15:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594134572;
	bh=3FhL2ZRnBBx7Z10NkIE51qlwGEHzyJGWX2u13X8SHzk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=nPoNDrNDqnLz59CCw1tDOzrF6LPQxdEqmwknYuyeIP5k38M2zvRCAjV+DosSSPmsq
	 stcYK15icOuL35JAVbXd45mu8yxnH+SWl1KJEW7YfMu89efHltnN9bJE1smtHPgz89
	 ecqMrWwu2HlIUMM13quR57grUgtTecBoRFowPbbM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgGGPJc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jul 2020 11:09:32 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54912 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbgGGPJc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jul 2020 11:09:32 -0400
Received: by mail-wm1-f67.google.com with SMTP id o8so43642898wmh.4;
        Tue, 07 Jul 2020 08:09:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LyPt8pjQ2hYzxgcpGlgQLq9YypxpQ46IFjPp9/Hk1tY=;
        b=HMvYV6DfxQ/z55h/jUgu6uIGa8UE8X+MQaaczH4kl6vP8QxstJBMFGMndNxMNpqqVU
         lOyavX08bLueKPx0DA1/aifJPpTvjyUqaFXd/g/+MQxzrwWsjPCM05mUaa8nV20DI4cZ
         0NC+qY5DNZCXFAgqZmjU+5lD9ZHIX2QrRSlCrKqIwxJXrZz/ZGNzWJe06cu9FWvPwnhL
         T7NTywem7MmunrDj4BBPYuasuZpcv+SIVTSLh2sBr+tApwKmSqO1zF4U2elZDZGG0nTm
         hiGt5szh/rDJMW2rNUUV/OTAQFNlIwGqFsoig8fUdaYwnyWm8jzY8OkCQGridItSH+GM
         t5rA==
X-Gm-Message-State: AOAM5322ge6tiQ2Gb1Bbw2lKlNjvdlplHRP9ARHVi6SpPjGxCEy9jBai
        AsvnTRhKmrcHIPsFkaDYXb90Co3T7imWJGN7yBA=
X-Google-Smtp-Source: ABdhPJzW0YR6fYlxQOLIgcuUjDm8eADQDlJqMhbvCMgroXw5W0/wpybst044K6xPwzuVMMY0hs32B2Xk6bSK4DXu/u0=
X-Received: by 2002:a1c:7d56:: with SMTP id y83mr4948838wmc.154.1594134570063;
 Tue, 07 Jul 2020 08:09:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200702185344.913492689@goodmis.org> <20200702185704.401148804@goodmis.org>
In-Reply-To: <20200702185704.401148804@goodmis.org>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Wed, 8 Jul 2020 00:09:18 +0900
Message-ID: <CAM9d7cjboXGg+iMOA4BQo=E01iLGcJNB1MyPJ4doPP1XeGVJRA@mail.gmail.com>
Subject: Re: [PATCH v2 06/15] tools lib traceevent: Add support for more
 printk format specifiers
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Jul 3, 2020 at 3:57 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
>
> The printk format specifiers used in event's print format files extend
> the standard printf formats. There are a lot of new options related to
> printing pointers and kernel specific structures. Currently trace-cmd
> does not support many of them.
>
> Support for these new printk specifiers is added to the pretty_print()
> function:
>  - UUID/GUID address: %pU[bBlL]
>  - Raw buffer as a hex string: %*ph[CDN]
>
> These are improved:
>  - MAC address: %pMF, %pM and %pmR
>  - IPv4 adderss: %p[Ii]4[hnbl]
>
> Function pretty_print() is refactored. The logic for printing pointers
> %p[...] is moved to its own function.
>
> Link: https://lore.kernel.org/linux-trace-devel/20200515053754.3695335-1-tz.stoyanov@gmail.com
> Link: http://lore.kernel.org/linux-trace-devel/20200625100516.365338-7-tz.stoyanov@gmail.com
>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207605
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
[SNIP]
> +static int parse_ip4_print_args(struct tep_handle *tep,
> +                               const char *ptr, bool *reverse)
> +{
> +       int ret = 0;
> +
> +       *reverse = false;
> +
> +       /* hnbl */
> +       switch (*ptr) {
> +       case 'h':
> +               if (tep->file_bigendian)
> +                       *reverse = false;
> +               else
> +                       *reverse = true;
> +               ret++;
> +       break;

Indentation is broken..

> +       case 'l':
> +               *reverse = true;
> +               ret++;
> +       break;

Ditto.

Thanks
Namhyung


> +       case 'n':
> +       case 'b':
> +               ret++;
> +               /* fall through */
> +       default:
> +               *reverse = false;
> +               break;
> +       }
> +
> +       return ret;
>  }
