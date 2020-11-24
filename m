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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD39EC2D0E4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76A9720857
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:30:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gb3ofn9E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390733AbgKXRam (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Nov 2020 12:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390725AbgKXRal (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Nov 2020 12:30:41 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEB0C0613D6
        for <linux-trace-devel@vger.kernel.org>; Tue, 24 Nov 2020 09:30:41 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id y7so8055160lji.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 24 Nov 2020 09:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qSyv6VSTXKsvAgjkEOpdj8Qn/mWxuXkX5EqOiLABkdk=;
        b=gb3ofn9EANwpFE/QbpVIQ/bfXJAskvB8QV95CgVuCsg4ILILa+idzau5h/pZCuo/PP
         JyYdj40Ho8bwRoTlizK/jZ85E5eGAy7WRhMpQHvroG7iroTNZHb/adlgMOUiwRM1ko2V
         eOqxSUlSYCoPNZL8yDj/9Ig8hKrg69a8Ue4JElwKu9p3+gW8fXYmRmhb9WERxnxWq+Bh
         JhF9AWcLxNn8LH9l2E1CfkajmQmpBEB3GVKnOPHGkzagrtcnEp2YtDaBiOivcSYZsJdZ
         yZ/CNGTHsS6vN8L66K5bl4iSHv+AcSQ+EhYO0pvNbhgCf7OV+oI42Mtkt+qe8PBprKsd
         mMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qSyv6VSTXKsvAgjkEOpdj8Qn/mWxuXkX5EqOiLABkdk=;
        b=dr8bNJurc1+LjEMcl/fvh/KYtJr5sffl1V8NMOAc8iZl0hkR642LrfIesnt/Z/yVBH
         Z1Kux1NGdU4N8di64mZ6mo0najtmhlWzNhVPzDczeVLIj6W0yVArwf0UR3a2+3soUMjj
         yX0jtb5BcCGVR1W3XXU24dmadE4TbPRgiuAdI41icor75ypbJXiZxxWZ+aSshwhbLQNb
         0YUOE3skU+nbtDQli0v1Fp4pv+NreExRX9u+Z06xodTR4ViYDeswKipEUw2Q2ldHsjot
         eWAW//6JXRkIc+4AmEpTMaVIrPic4KeYkRhQEBZfxDNtwt3EGPuzEBX1/4IumS1bRjsg
         J06w==
X-Gm-Message-State: AOAM5336ffQN8QO6Ef5XmwsQ9evw0g5tjC3V6h2sixX975epUXYsDWaU
        h1cB9d+gY4nMPrDT+wup1BBrkd4GgJ3925b4qXflCUWr
X-Google-Smtp-Source: ABdhPJwQgfBLFQQgwCoCUfrX12q5XJiw71bxb9wLfCG0qRadrfJHdsrJP+dUp95VZ54EBI4B1kfORmnenW5v7+HNRd4=
X-Received: by 2002:a2e:92d5:: with SMTP id k21mr2216598ljh.244.1606239040160;
 Tue, 24 Nov 2020 09:30:40 -0800 (PST)
MIME-Version: 1.0
References: <20201124172755.31795-1-marcelo827@gmail.com>
In-Reply-To: <20201124172755.31795-1-marcelo827@gmail.com>
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Date:   Tue, 24 Nov 2020 12:30:28 -0500
Message-ID: <CA+saATWWh9jvNHxyzuKEtrzybJXQS+wWTo9W6-SJNATmEt1bSw@mail.gmail.com>
Subject: Re: [PATCH] libtraceevent: Install kbuffer.h from the install_lib
 make target
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I figured I'd send this because it might have been left out by mistake
given that it's included in the library in the kernel tree, and I've
been working on a program that uses kbuffer.h, so thought other people
might find it useful, too. Feel free to ignore if it was left out on
purpose, though

-Marcelo


On Tue, Nov 24, 2020 at 12:28 PM Marcelo Diop-Gonzalez
<marcelo827@gmail.com> wrote:
>
> This file is included in the list of installed headers in
> ./tools/lib/traceevent in the kernel tree, but was left out here.
>
> Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
> ---
>  Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Makefile b/Makefile
> index 8626b91..72ec2d0 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -418,6 +418,7 @@ install_libs: libs
>         $(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ)/traceevent)
>         $(Q)$(call do_install,$(LIBTRACEFS_SHARED),$(libdir_SQ)/tracefs)
>         $(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedir_SQ)/traceevent)
> +       $(Q)$(call do_install,$(src)/include/traceevent/kbuffer.h,$(includedir_SQ)/traceevent)
>         $(Q)$(call do_install,$(src)/include/traceevent/trace-seq.h,$(includedir_SQ)/traceevent)
>         $(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ)/trace-cmd)
>         $(Q)$(call do_install,$(src)/include/tracefs/tracefs.h,$(includedir_SQ)/tracefs)
> --
> 2.20.1
>
