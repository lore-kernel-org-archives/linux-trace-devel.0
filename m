Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F29FDC432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Sep 2021 12:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6AED610CE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Sep 2021 12:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbhIBMuL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Sep 2021 08:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234254AbhIBMuL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Sep 2021 08:50:11 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018DCC061575
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Sep 2021 05:49:13 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 18so1551958pfh.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Sep 2021 05:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HZ7z+hAMahJkesUNQFky29h1KDfFstPyevXcW2pRY6Q=;
        b=W3IT3DnRSLPIwt0jCA0uAwX2grhiaxoGU4wu2KkhphQoAGObvbZRGxkSJ6acP6To3h
         4tJd0u4wMLorfa2juBbtnfi59FhGWFfvigGpDvH5aSl3LShCAqI5gH9PvvcVYh7ZmNri
         g3VmOgtBScA9GKR8g1jIpRLmsiT5Nm+9/Lq7GF1DyM+QX34AM0lNm32LtqjoMIT8rIGF
         rLrqr3Xciv5URyulaapTAMlw16sliagHd+MLMY/zC6Vc7kPQ76uOa9U6R/pWk9vPmq6c
         cJWh5n1scUKa7VYHqPjgV3Bx24ad/SzUfn4bdWByMLoi8GFaJX/3kjvUF/H4tinZ9ikf
         j76w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HZ7z+hAMahJkesUNQFky29h1KDfFstPyevXcW2pRY6Q=;
        b=uDjL463TRaACks8QYFAz/xW9DMtxRQgQ3nr4OgMqqbOstkzsTOS79Hx6m+eR/tTfEF
         20s9j44yNf+XrwSUGIt++FMt9X2RLdIs66M/sYv48VUbGq8pdSHUv7vGfEIUCvZZXGkA
         WoJ+mXei27+9YeQRTD5F7CFrnZxn+W6rGEkhdt4yOVkv6F2tRSPBWTZI/Pz7peX+zUCy
         vNCSONvkE4YzrLgCJKBEQh24sqCeThQWZ9yAFD9+Lxf/ECeE9Bokav5Wc+64rkI889sk
         EO8Ptdpru9E8zpKn//cDfAmd5+HtrrtK16HmDcjIHooDCMiK0bZqJRCBqeX+JDU6okkC
         802Q==
X-Gm-Message-State: AOAM532Da8nUPuV8HZGuYkK7+9RZNEqKEznyoHQr4cfJO5Jx6OckMz4l
        q0NZgDr1hF5cq+IMkHqxKBsReAick7WRfsYuwZk=
X-Google-Smtp-Source: ABdhPJzDYjzkH8hP2vmSEGlTz5K575SXxdWL6BJ28aqxswnv3BmS61N3353owj2Mc6S3b2Fh2SZl5G9JQZasI5lcdxI=
X-Received: by 2002:a63:d017:: with SMTP id z23mr3107721pgf.108.1630586952456;
 Thu, 02 Sep 2021 05:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210729050959.12263-1-tz.stoyanov@gmail.com> <20210729050959.12263-32-tz.stoyanov@gmail.com>
 <20210817114416.252e117e@oasis.local.home>
In-Reply-To: <20210817114416.252e117e@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 2 Sep 2021 15:48:55 +0300
Message-ID: <CAPpZLN4mFqrc5cH82A4T2UApN6j-KXCN3L8f+ZQbj2XtCamSkg@mail.gmail.com>
Subject: Re: [PATCH v2 31/87] trace-cmd library: Fit CPU latency trace data in
 the new trace file version 7 format
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Aug 17, 2021 at 6:44 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 29 Jul 2021 08:09:03 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Trace file version 7 format is based on sections. To fit the latency
> > trace data in this structure, a new section and option for it is
> > defined:
> >   BUFFER_LAT
> > It is similar to the BUFFER section which holds the flyrecord data, but
> > has a latency specific design. The BUFFER_LAT section has:
>
> Actually, let's call it BUFFER_TEXT.
>
> Although we do it for "latency" format, which I'm thinking we should
> call it something different for v7, the real difference is that it's
> text and not binary. Perhaps we can save other formats as "text".
>
> In fact, I think v7 should allow for a mixture of TEXT and BINARY
> buffers.

It does, there is no limitation to do a flyrecord in one buffer and
latency tracing in another. Although I cannot imagine a use case for
that.

>
> -- Steve
>
> >  - section header, as all other sections
> >  - compression of the trace data, optional
> >  - corresponding trace option, pointing to the section
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
