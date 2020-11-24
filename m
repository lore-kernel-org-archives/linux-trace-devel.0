Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E94C63777
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 16:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A69B3206C0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 16:20:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tUkdz/Dy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390116AbgKXQUX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Nov 2020 11:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389861AbgKXQUW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Nov 2020 11:20:22 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C18C0617A6
        for <linux-trace-devel@vger.kernel.org>; Tue, 24 Nov 2020 08:20:22 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id m9so17900089pgb.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 24 Nov 2020 08:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sPTxVqOHYf9EETuDtTbpQk3pMAxFWGrjJ9jN0G9AcgU=;
        b=tUkdz/DygfHCb4Bz8QyNfginmP1mvgAl0SAjcZL9WFBumiF+rMnscUdkiTpBcsX27N
         ExnkD36Jln/wBTyeksn6aWphHivVXNreA6wAi4L49sVxvQtkRDhto/9uGo5BMzk1XvRA
         p+m0IaqAfE3D21BQfO6WXbCjq0cZUrsoe10iAwCsRvO5r4pt+H1vVCwM8IB4MJPXC04D
         UjhPKinrTTLPCmUOOQa+XS/aycV6+tPVba9Lst6JhMyThKRml7W07gorD70MCrjEq0je
         6Pmw3ispz+ug9k3s/oPLfCLXmRR6iTjIFUT0/6GpGTxtxS4Jj5+t93M+UdXlR4QubzhT
         Bv/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sPTxVqOHYf9EETuDtTbpQk3pMAxFWGrjJ9jN0G9AcgU=;
        b=geoRM4o/v6tcFrO2PNV77W9A8Q4iPKySxTqw3CntceSS/bfRoqvY+o2u/P8W5KoRyo
         loJld5FCLOlqb8fIenq1zbdvZRSHzxVC9UMeBotVpyze5OYw0Z0nzY7m57QI2xky5CQy
         wriyh2rollM0jsopRwj5kafQBWxu3QvTJWvtjMkYkc46U4N97vdTl+TESNHClAyK2YQD
         vjVXdnB4zVJx6ND+SMk/6+P4v8RMtg/yEtYp9MpY0BSQT1YgYm9fHEnfaLm/vQHBj4DA
         qPEiLaOkWYgkTw160lj7/Fbg1oTjjdEKm+iKGyFGFQzYqD/CgW6/evLwGa8NvJuYWiW0
         0hOA==
X-Gm-Message-State: AOAM532Cv1+dseXe1pIJ9OJO592HwPJikgFIjFgnekjxOgKb7OsTVsis
        QV60wgPk6KD1HwAlcxleCBJt8dtNNm/tyO7tdi2TS+mCqECwOZ4R
X-Google-Smtp-Source: ABdhPJxg92TJY2WTcKO4uoFBemgKwVWMPA9JCPsed98kYnKUkhVZYTGs8lYf25dNEb8pAU1obPTp9UvlRAOvfTw15Vo=
X-Received: by 2002:aa7:8a03:0:b029:198:2bb5:2cf0 with SMTP id
 m3-20020aa78a030000b02901982bb52cf0mr4485083pfa.81.1606234822272; Tue, 24 Nov
 2020 08:20:22 -0800 (PST)
MIME-Version: 1.0
References: <20201123154607.5e43e1ff@gandalf.local.home>
In-Reply-To: <20201123154607.5e43e1ff@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 24 Nov 2020 18:20:05 +0200
Message-ID: <CAPpZLN5-A+vcPc+XmPUaF3E9zXwO473UaqaUWerZBj-jT8JF4g@mail.gmail.com>
Subject: Re: [PATCH v2] tracefs events: Do not process str_read_file() if size
 is zero
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Nov 23, 2020 at 10:50 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> If a file has no size (nothing is read), then str_read_file() frees the
> buffer and returns zero. The problem is that all callers of str_read_file()
> uses the buffer supplied if the value returned is not a negative. This
> causes the freed buffer being used by the callers if the file read existed
> but had no content.
>
> This is apparent when using a copy of the tracefs directory, where some file
> exist, but have no content, then loading the events would cause a segfault.
>
> Change the callers to check the return value of str_read_file() for zero or
> negative, and do not go further if it is.
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
> Changes since v1:
>
>    Have the callers of str_read_file() check for less than zero, as
>    the first patch would never allocate the passed in buffer.
>
>  tracefs-events.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tracefs-events.c b/tracefs-events.c
> index ca1d22b..631c310 100644
> --- a/tracefs-events.c
> +++ b/tracefs-events.c
> @@ -411,7 +411,7 @@ char **tracefs_tracers(const char *tracing_dir)
>                 goto out_free;
>
>         len = str_read_file(available_tracers, &buf);
> -       if (len < 0)
> +       if (len <= 0)
>                 goto out_free;
>
>         len = 0;
> @@ -471,7 +471,7 @@ static int load_events(struct tep_handle *tep,
>                         goto next_event;
>
>                 len = str_read_file(format, &buf);
> -               if (len < 0)
> +               if (len <= 0)
>                         goto next_event;
>
>                 ret = tep_parse_event(tep, buf, len, system);
> @@ -501,7 +501,7 @@ static int read_header(struct tep_handle *tep, const char *tracing_dir)
>                 goto out;
>
>         len = str_read_file(header, &buf);
> -       if (len < 0)
> +       if (len <= 0)
>                 goto out;
>
>         tep_parse_header_page(tep, buf, len, sizeof(long));
> --
> 2.25.4
>
Thanks, looks good to me.
Acked-by: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>


--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
