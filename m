Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83799C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 13:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5069961157
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 13:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhDZNfx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 09:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhDZNfw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 09:35:52 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80280C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 06:35:11 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id t22so4806631pgu.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 06:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nZV+iijfOU5e1q7RiC6a+y+J7UI/VUvVbkxqUA91D2o=;
        b=N//y/Vszug6+8HzCtgtBPUyfrZyGB7GJ9l4sXs5j/2fJiQens7heT/r/sIlk5wV/7O
         mdvE0+pFX1jHXPkh6IabsGRwODiDhHOUPQXzmwmLhiSqbJCs+ul0WtUQhcUZcw5vwcFA
         n31aztRbfZKhPPxlZj4/WjMYQ3iByZpM/SZTQduwjJve8R+ynBJ2OizzejW/YI+ZSeLG
         uWJHCmRrXYehVmolhopBzRo9Ux3OFzHgtY4BWaxDrW6nQGYGUa7AWg3iRCJuUWgbnQJk
         6hU87ik5u7sPN4KN0xO+e4BW06D/ZTZ7ydIZxw9sPayy1OEWU0CXjAPjvT/qK+MNGqX/
         vIQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nZV+iijfOU5e1q7RiC6a+y+J7UI/VUvVbkxqUA91D2o=;
        b=ivZW13IhwoF+3zqiWkMzsczlapeyARZYJIKnwTGyhTj/JBAMEuk1R/Orb/OdABiMXi
         Jos9uxbVmVMxSIrAcSTae2gENH8g/QIYVw9V6a+mJlJHwME3ayCXVPfPHzaBwRcTEPeo
         B79Jtw9v7v7eXIoPn/zv+L+5Z8Ttj3p+Y4G9Y0upbTxR1h4n1qEUv8FozNE2ZErXZHhl
         3IaLzjP0tBZMU+LAUlwWBzp2UZzvuWgNQFzkwgzjOSPPxQ/ewDKhFFUZ9m7I3au0PCH1
         ot7ScavAImaqdN6AMYBrvnobBkdV5SZ0Nu5S4BllO/+QbaOA0LVYtjh/yXSoDltFojK7
         yTVw==
X-Gm-Message-State: AOAM530i76DeyN5w8ubhdZAQjLwDz/vfYKYVkAD7Pen/EcBQJN38ytym
        PMjTpS85745ldDAkaXF0J0Ho4T0FM6Y9o+27+DEukZmb8yRhgg==
X-Google-Smtp-Source: ABdhPJw+xm7Q0RvjfaZrEP+XRndB9PKOsQhafBYQNi9NpdeEJ22faXumqbp4lmyM42AilyOM7YltERmFkCuvOZvAs0Y=
X-Received: by 2002:aa7:8051:0:b029:272:7b9c:cde1 with SMTP id
 y17-20020aa780510000b02902727b9ccde1mr10533408pfm.55.1619444111077; Mon, 26
 Apr 2021 06:35:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210423232648.1197063-1-sudipm.mukherjee@gmail.com>
In-Reply-To: <20210423232648.1197063-1-sudipm.mukherjee@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 26 Apr 2021 16:34:54 +0300
Message-ID: <CAPpZLN5CNmN-g2wOGYAOEK0V1etk8bxe1QcN=LQ3wmnkVO_7yw@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: use mode with open()
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Apr 24, 2021 at 2:27 AM Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> If -D_FORTIFY_SOURCE=3D2 is mentioned as a buildflag then the build fails
> with the error:
> In function =E2=80=98open=E2=80=99,
>     inlined from =E2=80=98copy_trace_file=E2=80=99 at tracefs-utest.c:103=
2:10:
> error: call to =E2=80=98__open_missing_mode=E2=80=99 declared with attrib=
ute error:
>   open with O_CREAT or O_TMPFILE in second argument needs 3 arguments
>
> Mention the permission with open() when O_CREAT is mentioned.
>
> Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

Thanks Sudip!
Acked-by: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>

> ---
>  utest/tracefs-utest.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
> index edb3a3d..0965363 100644
> --- a/utest/tracefs-utest.c
> +++ b/utest/tracefs-utest.c
> @@ -1061,7 +1061,7 @@ static void copy_trace_file(const char *from, char =
*to)
>         fd_from =3D open(from, O_RDONLY);
>         if (fd_from < 0)
>                 goto out;
> -       fd_to =3D open(to, O_WRONLY | O_TRUNC | O_CREAT);
> +       fd_to =3D open(to, O_WRONLY | O_TRUNC | O_CREAT, S_IRWXU | S_IRWX=
G);
>         if (fd_to < 0)
>                 goto out;
>
> --
> 2.30.2
>
--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
