Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8534C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Dec 2022 20:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiLOUNZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Dec 2022 15:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLOUNX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Dec 2022 15:13:23 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D132FBDF
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Dec 2022 12:13:22 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id ay14-20020a05600c1e0e00b003cf6ab34b61so2707517wmb.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Dec 2022 12:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2o2gIvXIyQxavJDYmUx+db4rHnycOLiaMp5YOUszLIU=;
        b=KxMZ92k4g+b/96W/JuXAq/h2bO3rWWje5yNYb8L1IOvpTqcX5yNswkvrsxUIf44aDR
         YbMH4XFdPix+H/chh6xQvhxSN5g+3XviM0Wqo5dFvevHp1ydAq4Xx97oM2EP2oI0DsRA
         cyD8vkIhd2ndj+6APuE0+QZiKCVwsO/2hUM1Nk6mNI9BM81BAceXEutLAq56QXHsoqSG
         Ik9KzqX/sHoYhG5G+YnGljZjSTYwz1urpK1ay3YZpJSdpXgHZKFSiQXzkeaYH22edcU9
         4+Jhl0JR+mQP2BynQC+oNXfFBH2rc+98UglkMdbFTkipzFTXp2H0zFSExdNY5bfyFFlc
         RAeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2o2gIvXIyQxavJDYmUx+db4rHnycOLiaMp5YOUszLIU=;
        b=wQSCzHz1TsSErtCEHi7FHXtOxZuQRyiAeaEscDKuNxs6GXhcWjxW5U/pkJHzYbvCW8
         c5W71wXnRWZBaLaOs3i4hv8fHGvjjoMKhyDxM386clm2INKQdWgmCSmlTVB1m/spjETR
         dHL1MdA5KTvnTlHwpeTOtmMrBUgns09rPsEQdS5LTRC4c+A9lvdetCVMl5YK7UK115RK
         vxRo1CD5GPY3WLyLHTM0mnAORC5QojWmuXh/GyZBR39i0sc8RsXBecDfob28pzATtCby
         kJQoedBWGxv456qDwD8TwbsEnjnCsI11zCXXeuQMhpbDLngAuqv0jmwT4otKRgxjAutX
         9mlw==
X-Gm-Message-State: ANoB5pnyJuyKSk2DNMFhPfrMkM0MRXLhdryu90wZFEEbFnIZpAAT2XVy
        5UPSp/EBRoq6fpSV7cLcuc1v3b1BuCdSjQbR60uXrg==
X-Google-Smtp-Source: AA0mqf6zhiGVjTLLbHD2z6rAnE8N5MqQyzsXfpDteG4xNVRBqQoHBZzowEzDbcxeF+UdutboXbDzEgNBLWdneVlosWI=
X-Received: by 2002:a1c:7203:0:b0:3c6:c109:2d9 with SMTP id
 n3-20020a1c7203000000b003c6c10902d9mr561959wmc.149.1671135200457; Thu, 15 Dec
 2022 12:13:20 -0800 (PST)
MIME-Version: 1.0
References: <20221215183151.2685460-1-irogers@google.com> <20221215140203.103faf50@gandalf.local.home>
In-Reply-To: <20221215140203.103faf50@gandalf.local.home>
From:   Ian Rogers <irogers@google.com>
Date:   Thu, 15 Dec 2022 12:13:08 -0800
Message-ID: <CAP-5=fWVLZM9_pZcWvi1rnEeWk7BL62NgsPw43V8rUOtE=VdzQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] libtracefs: Move initialization below a null test.
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Dec 15, 2022 at 11:02 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 15 Dec 2022 10:31:50 -0800
> Ian Rogers <irogers@google.com> wrote:
>
> > Computing the address from a NULL pointer results in undefined behavior
> > which things like undefined behavior sanitizer promote into real
> > failures.
>
> I thought commit aff006d4af0c7 ("libtracefs: Do not initialize with NULL
> offsets") was suppose to fix this.

It may have done, sorry for not keeping track. I went to my libtracefs
git repo to fix the patch 2 issue and saw that this change didn't
vanish with a rebase.

> Oh, I think I may have forgotten to remove the check against dynevent!
>
> Does this work instead?
>
> -- Steve
>
> diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
> index 48bb26a96c58..7a3c45ce25a3 100644
> --- a/src/tracefs-dynevents.c
> +++ b/src/tracefs-dynevents.c
> @@ -713,9 +713,6 @@ dynevent_info(struct tracefs_dynevent *dynevent, char **system,
>                         &dynevent->address, &dynevent->format };
>         int i;
>
> -       if (!dynevent)
> -               return TRACEFS_DYNEVENT_UNKNOWN;
> -

I think the issue is above in &dynevent->... that dynevent may be
NULL. It seems from removing this that dynevent can't be NULL and so
the undefined behavior can never happen - in which case there's no
issue to fix and the test is unnecessary and should be removed. That's
a long winded way of saying I think that's a correct patch and this
patch is unnecessary :-)

Thanks,
Ian

>         for (i = 0; i < ARRAY_SIZE(lv); i++) {
>                 if (lv[i]) {
>                         if (*rv[i]) {
