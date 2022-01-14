Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B85C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jan 2022 10:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239541AbiANKNA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jan 2022 05:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236780AbiANKM7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jan 2022 05:12:59 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71015C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 02:12:59 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id a7so10140139plh.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 02:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HbzTT1a3pd2oMdeAfmb8T67MZ//zS/GzEitaQCKV1P8=;
        b=Me6QeqGBwJNcTbyRAmBuBYbJF0aGYL5PP67DyJBh+2+j535TJYdgkMsAffme7PaQrC
         AmgWAAoDkEV02X9Ftng3Zq4HkXdqVJkpERs5MXy2ALNDFntXbKGqJZ3acqJGmexzAQdN
         Ol+HuNYqPmzX3WJ3k24iiAzmDJ9BkJDDw0rVmDRVNixLr0NaYYbvuq0oLsI5snUiiMOA
         D68h7Q7HUHRo9AywfrcvfaEMBkduKSGDUCvbITciWk8hTfxB9vT6zJlDrwh4wpxgz/Mx
         +raVnwOzOyT9Wo6tEwhPhCuln2HkB/+ajKnP7X1qFX9vMFKzyip2zAasf8se1smzp6HR
         48JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HbzTT1a3pd2oMdeAfmb8T67MZ//zS/GzEitaQCKV1P8=;
        b=knXWa6TOTKq6RKtVgZNosXmRiSQSlh7og8rQmWSQP2BQtG7RxK0s4XAs28oBswsvvQ
         Bj0KixgaBvu42wFEh2EfWB+C7PKJhrdjr2zrZcihE2Ii/OQAB1b8YeHAVgfalMfsiWBy
         G5FLcDZ02Op9skZ4MGgHBszXvLdlDq3kfO5SIzNiKM/O/ob7lyguYcPcX9tzYXhPjcum
         CYc9cs9vfue3hIgpm6s2XtugDO1ON3JJvlM9CXRb/hlQZFru984qH58qOgVgSC2NEW0W
         g8mBeyEZfsjC+9WhcVX6VEKsXlBPbdUPCt0wD489DNThA9daMz89/R3dnsPSvB0oHupG
         HUWg==
X-Gm-Message-State: AOAM533LxBQbED7sclAbydDwZRLSjjYF0p8HdLxciGG/kIvx+ize1CNP
        5HhURUeYTCQoSQbolH4J62hb37b9BXZebiy9PlsTmecG1rU=
X-Google-Smtp-Source: ABdhPJyDYAZ3Al4jGc3+jtBtGe7Yo02AV2UWvt9qj6/AQE1+AlbVeOSAxI+VZcTD3HcfUKSs/g7mnuAIOtEZDUKYOcg=
X-Received: by 2002:a17:90a:8c0e:: with SMTP id a14mr19131253pjo.111.1642155178946;
 Fri, 14 Jan 2022 02:12:58 -0800 (PST)
MIME-Version: 1.0
References: <20220113170059.82747-1-y.karadz@gmail.com>
In-Reply-To: <20220113170059.82747-1-y.karadz@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 14 Jan 2022 12:12:42 +0200
Message-ID: <CAPpZLN4ik3=Wp6W7auSUEE0t83SneWG+1njw5tHq_tp=xmOhEw@mail.gmail.com>
Subject: Re: [PATCH v2] libtracefs: New API for getting synthetic event
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Jan 14, 2022 at 10:17 AM Yordan Karadzhov (VMware)
<y.karadz@gmail.com> wrote:
>
> A new API is proposed, to get tep event descriptor for given synthetic
> event:
>
> tracefs_synth_get_event ()
>
> The API implementation gets derived from the implementation of the
> existing API  tracefs_dynevent_get_event(). It can detect any newly
> created or removed synthetic events.
>
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  Documentation/libtracefs-synth2.txt | 13 +++++++++++--
>  include/tracefs-local.h             |  2 ++
>  include/tracefs.h                   |  2 ++
>  src/tracefs-dynevents.c             | 17 +----------------
>  src/tracefs-events.c                | 21 +++++++++++++++++++++
>  src/tracefs-hist.c                  | 18 ++++++++++++++++++
>  6 files changed, 55 insertions(+), 18 deletions(-)
>
> diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
> index 8056ab8..444318c 100644
> --- a/Documentation/libtracefs-synth2.txt
> +++ b/Documentation/libtracefs-synth2.txt
> @@ -6,7 +6,8 @@ NAME
>  tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_echo_cmd, tracefs_synth_complete,
>  tracefs_synth_get_start_hist, tracefs_synth_trace, tracefs_synth_snapshot,
>  tracefs_synth_get_name, tracefs_synth_raw_fmt, tracefs_synth_show_event,
> -tracefs_synth_show_start_hist, tracefs_synth_show_end_hist - Creation of synthetic events
> +tracefs_synth_show_start_hist, tracefs_synth_show_end_hist, tracefs_synth_get_event

The new API should be added also in Documentation/libtracefs.txt, the
main man page with all APIs. Forgot to mention that in the previous
review.

[ ...  ]


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
