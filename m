Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98555C28CF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 04:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiAZE4b (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 23:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiAZE4a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 23:56:30 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59242C06161C
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Jan 2022 20:56:30 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id v3so14887432pgc.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Jan 2022 20:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QZQAhYgKJp+1MSyep+9ztODSYTq87YZHfTFt5pmTQCg=;
        b=phEcOsPWiiudenRxEcpfW1o2C79QBm9e1oAnR2xSf047gjmDMxvaaurUscoPwqOIuL
         fikypT0KPJMfYN5bZJprAyh3ZC0pWVHxAT5c8Svo8dD9Ps4Uy9UXyRpT6p2d02yJhCcX
         rHHU+yGIjOvwPad5ENReAyto1ui8bLLMns1C+Wl/aTXwO2vCPVP5ubHR85OQfesbpYMZ
         YhAL183FIZbMqSvOljtc5CUkjG3PioVmNXYrrG5/XMb/L8yhtPNr6uR7i+tbMbXGvbmu
         MiEemI8H8Yhymb7z/vMQ7+Y4eIzJcmcxqvNDXYSaGWdnIne4L00+i8mHURUYNW0G2dT/
         gvKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QZQAhYgKJp+1MSyep+9ztODSYTq87YZHfTFt5pmTQCg=;
        b=ZjwBjLr6GSqoeTAd2+oocmIo6za1z5HT2f3Os36Aj4JKL5f9mOb6pP6jo/fnwjPuWe
         MCAE8MXbd5N/pI2syCfBbNNl8QUQd+s8l6RGRgCmhg5nz+NsM7uBs9JOpu7EU6UVkXRF
         Jl4uqdYldflu/1Dn1beNjTqvMVuIssMbv6V/kthiXBaAcQbzPv4ipF/JJ5tXPcQTkhyE
         W7bSZeNP7ggLIdcJDqSLEajtinHmo9mDRurD0kE0w9hRRSkVF2hGD0bcV3rrpqPcyaGz
         xjcjOxt58KIIK4xyNDem9FV8rHDnIq4kRI9fws3kTLvOFtt3ecfmg4YxRf8B4BSMW3Be
         b6bQ==
X-Gm-Message-State: AOAM5322C6mpUlveNEQbnAdD9sI98zfCjTHPp9LSk+h1WS1eWnFImTG2
        a8OdXI6MALp0FydBr2FQ0Tr5NTIVSrJVrteLDPdvaL/CKzQ=
X-Google-Smtp-Source: ABdhPJxh8uMsKh7u+AwyTbertpcl5bQTtAgeo+g3p3RMCPjpuk8lTthYxINHN47YpJy7v6LC90WFrTBFIh4Mm+rEObg=
X-Received: by 2002:a63:1910:: with SMTP id z16mr17231735pgl.323.1643172989651;
 Tue, 25 Jan 2022 20:56:29 -0800 (PST)
MIME-Version: 1.0
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
 <20220119082715.245846-2-tz.stoyanov@gmail.com> <20220123174851.52f0e2bb@rorschach.local.home>
 <CAPpZLN6BpbaThK66MJaykk7gSPDq2qQHkbmunQeT0NyMNMGnAw@mail.gmail.com>
 <20220124150335.2516da99@gandalf.local.home> <CAPpZLN6_VNmH3O1GML6cPfXJwp2K-SJseVd4fe=bbLZR8pm8PA@mail.gmail.com>
 <20220125100809.528667ef@gandalf.local.home> <CAPpZLN4ET-wF2BcQzEb99F8LFADVDYZR6_kdo4530XC=1eJG3Q@mail.gmail.com>
In-Reply-To: <CAPpZLN4ET-wF2BcQzEb99F8LFADVDYZR6_kdo4530XC=1eJG3Q@mail.gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 26 Jan 2022 06:56:13 +0200
Message-ID: <CAPpZLN7EYCuAS=uU_BzS1r_G8TBcfDta3nbSFwykPFuzgbwJNA@mail.gmail.com>
Subject: Re: [PATCH v7 01/20] trace-cmd library: Add support for compression algorithms
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Jan 25, 2022 at 7:30 PM Tzvetomir Stoyanov
<tz.stoyanov@gmail.com> wrote:
>
> On Tue, Jan 25, 2022 at 5:08 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Tue, 25 Jan 2022 09:48:43 +0200
> > Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
> >
> > > > > >
> > > > > > > +     free(bytes);
> > > > > > > +     handle->pointer = 0;
> > > > > > > +     handle->capacity = s_uncompressed;
> > > > > >
> > > > > > If size is the greater of the two (compressed could be larger) and
> > > > > > capacity is the allocated buffer, shouldn't we make it equal to size
> > > > > > and not uncompressed?
> > > > >
> > > > > The name "capacity" in reading logic is a bit confusing, as it
> > > > > actually is used to track the size of uncompressed data. The buffer
> > > > > may be larger, but if the uncompressed is smaller - the rest is
> > > > > garbage and must not be read.
> > > >
> > > > Then the extend function is broken:
> > >
> > > For this particular use case, the logic is not correct - the realloc()
> > > could be redundant, if the real buffer size is bigger than the
> > > capacity. But as usually a compression handle is used for reading or
> > > for writing only, this is unlikely to happen. At least I cannot
> > > imagine a use case where the same compression handle will be used for
> > > reading a compress block and for writing compressed data. But even if
> > > we hit that case - there is no data corruption or memory leak, just a
> > > redundant realloc(). To solve that, reading and writing capacities
> > > could be introduced ?
> > >     struct tracecmd_compression {
> > >        ...
> > >        unsigned int            capacity_read;
> > >        unsigned int            capacity_write;
> > >        ...
> > >    }
> >
> > A redundant realloc is not an issue, in fact, they are pretty fast (it
> > detects that the requested size still fits what is allocated and just
> > returns).
> >
> > >
> > > But that change will be for a very rare case - when the compressed
> > > data size is bigger than the uncompressed (usually happens only with a
> > > very small data) + the same compression handle is used for compression
> > > and decompression (not used in that way in trace-cmd).
> > >
> > > >
> > > > static inline int buffer_extend(struct tracecmd_compression *handle, unsigned int size)
> > > > {
> > > >         int extend;
> > > >         char *buf;
> > > >
> > > >         if (size <= handle->capacity)
> > > >                 return 0;
> > > >
> > > >         extend = ((size - handle->capacity) / BUFSIZ + 1) * BUFSIZ;
> > > >         buf = realloc(handle->buffer, handle->capacity + extend);
> > > >         if (!buf)
> > > >                 return -1;
> > > >         handle->buffer = buf;
> > > >         handle->capacity += extend;
> > > >
> > > >         return 0;
> > > > }
> > > >
> > > > As it sets the capacity to the allocated size, not what is stored.
> > > >
> > > > Perhaps you meant:
> > > >
> > > >         handle->capacity += size;
> >
> > The above should still work, instead of doing the += extend.
> >
> > The point I was making is that capacity should either be the requested size
> > allocated, or what is actually allocated. The above function sets it to
> > what is allocated, and the other code sets it to what was requested. We
> > should pick it to be one or the other.
>
> I didn't know about that realloc optimization (check if requested size
> fits into already allocated memory). In that case, we can use the
> requested size in both places. But still allocate a page aligned
> buffer in buffer_extend(), to avoid frequent reallocs (although
> realloc will be called almost every time).
>

I did some tests, these extra realloc() calls actually cause 7-8% slow
down on writing compressed trace files. So, I decided to go with the
other approach - use capacity_read and capacity_write.

> >
> > -- Steve

>
>
>
> --
> Tzvetomir (Ceco) Stoyanov
> VMware Open Source Technology Center



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
