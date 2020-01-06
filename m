Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E89C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 14:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0725B2072E
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 14:30:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K0sFM8Qc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgAFOar (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 09:30:47 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34164 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgAFOar (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 09:30:47 -0500
Received: by mail-pg1-f196.google.com with SMTP id r11so26987877pgf.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Jan 2020 06:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9BUSoOiR0QeqHyQCuWsAjB2MPJpDS+c7QZRBkyC3to4=;
        b=K0sFM8QcSR1M5Gm9o1JoUfprfu7bdEgp+C5wGrdROiBykR7KM5cifgUX1HrGloZ0kS
         YjsaZjGApIo/DPKXFxS7L7qImTTSzRNOx/m3kRNYmYf8E1jkGf+NzBevKfZ3/HFbuwgC
         rjV1r5+Z95j9uJOyI0W9HEl+H/pU124nMpAuvF0xD8h41U3nEweH/oVbY+9yyhyIibrA
         pwBLWI26Noc1oVT28gTOcaGOa5c1MyJJjWVNXa37vQJJbNret8LtS3UU2HiaNes2hq8G
         g0N6HWFy63vQND9bLi2+IAIV9DSR8q1ydWzYoSjrBoRdkc6PABYlH17hzpYhxc2S5SJz
         UdeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9BUSoOiR0QeqHyQCuWsAjB2MPJpDS+c7QZRBkyC3to4=;
        b=WBubh6FMpBaVO+AFFWlpAnXDAlGCrjHMEN6zx4XQuHRoiwMj7ie6AcINvyintqn8Qd
         Gja2du8ipwjtP+1us3lIzh0RwI1Xkyh6h8cwkLJ7t4NmYBlgV8NKuyn+tjgcCd0stF0L
         +nuxNaZkQclOSHV8CGHAljC9de1dYLd6LdE5hzhQHb3Q9kbDFnxM91AAHPJvBKZ0FaMT
         9RHtrYo2TU+rc/ufq7xMzeWRFTJwEye8SaC6EFLE+ER5Jtzly85XKRTRV4mnvzCqUfTH
         ZElqYMp8BwKoni77EzbnEgqa9WmEIuMctdpGdGHeCn5mJJ0G9PrtSqUIkZYAy3vERL5l
         p95Q==
X-Gm-Message-State: APjAAAWXOTvdwqufjYQKgqxT7n2MM5e2L+khiqIYoTwbb9sHAtunLzHO
        RefCFdd/pI/bOkl5E0LyaMFvkW/4k5dcQBiokYbf3isS
X-Google-Smtp-Source: APXvYqxuzogfgBuLFxCpjqdrRCyZAhfPTecMbeQQrf50K2SC00f5gSeBUv6KOamT+eWMzpR+f3T1i1DumkS75z5dWxY=
X-Received: by 2002:a65:6914:: with SMTP id s20mr109140540pgq.44.1578321046752;
 Mon, 06 Jan 2020 06:30:46 -0800 (PST)
MIME-Version: 1.0
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
 <20191203103522.482684-4-tz.stoyanov@gmail.com> <20191220085055.79041373@gandalf.local.home>
In-Reply-To: <20191220085055.79041373@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 6 Jan 2020 16:30:35 +0200
Message-ID: <CAPpZLN66i8Am9DjOvGp-eTVkxKoehZqN8=_f+sfYdMeCUEeaFA@mail.gmail.com>
Subject: Re: [PATCH v17 03/18] trace-cmd: Add implementations of htonll() and ntohll()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Dec 20, 2019 at 3:50 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue,  3 Dec 2019 12:35:07 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> >
> > Implementations of htonll() and ntohll() are added as
> > macros, if they are not already defined.
>
> I'm somewhat nervous about this being in a global header, as it is
> mostly generic. I wonder if we should prefix these with "tracecmd_"
> just to avoid any name collisions.
>
> We could update this later when we make trace-cmd into a library.
>

I can move them to trace-msg.c file, as these are used only there.
Note that a lot of clean-ups are required for libtracecmd.

> -- Steve
>
>
> >
> > Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> > ---
> >  include/trace-cmd/trace-msg.h | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/include/trace-cmd/trace-msg.h b/include/trace-cmd/trace-msg.h
> > index aab8a69..654ca43 100644
> > --- a/include/trace-cmd/trace-msg.h
> > +++ b/include/trace-cmd/trace-msg.h
> > @@ -12,4 +12,14 @@
> >
> >  extern unsigned int page_size;
> >
> > +#ifndef htonll
> > +# if __BYTE_ORDER == __LITTLE_ENDIAN
> > +#define htonll(x) __bswap_64(x)
> > +#define ntohll(x) __bswap_64(x)
> > +#else
> > +#define htonll(x) (x)
> > +#define ntohll(x) (x)
> > +#endif
> > +#endif
> > +
> >  #endif /* _TRACE_MSG_H_ */
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
