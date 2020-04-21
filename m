Return-Path: <SRS0=ZUfG=6F=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F35B6C2BA19
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Apr 2020 03:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEC6B208E4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Apr 2020 03:16:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MqVQQoi9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgDUDQV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 20 Apr 2020 23:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgDUDQV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 23:16:21 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE36C061A0E
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Apr 2020 20:16:21 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id c83so1270314oob.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Apr 2020 20:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1FEBpVuhPh1CUSQw6XRM7JeOYlXfUsG3H5LTiDsLclU=;
        b=MqVQQoi9cb6Ysu6AuOrJ05QVcB5ar4mB0uIwKDZyn4g9DxhPflPisKy2xXh0H47dYh
         KbaeYgY/B9JxsmXfD2LvP+ceLmFyfS25SLsSSL69QiMYngVWG5mPq76NxaJ+Q28ovPPQ
         WW+v9YGxXT0yneGP8hoa8NU1FVKsXN3LvaY4iGCTnWvWlIJLYLSma1ADbNGqx29FDVMU
         3xXz2c8FKVgPjVChuVon15C2YlZT1x9hMR5o50E+Nt36PEHNOdTRXI0JILwOs6ZOEhnT
         dnGxcxE0d3Thx4omCGLAr5jN64RmnrvWvl0Yw/sxZl6t7F0nZRtMZoKt1TIfRxQ9KSS/
         7nmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1FEBpVuhPh1CUSQw6XRM7JeOYlXfUsG3H5LTiDsLclU=;
        b=nYcow+sIWGgYOe+pzzAJV+2R365pK06FzyRToYxlHu7Lqb2xIELFROz49yqE3vJvAw
         vt+A7w6U1GIzBgzl7fvoooadI6vltkmbQfdWwr2J3iFBGKSiflri6HxzNk4qvrlWmTrw
         DLxQccygAbyG2mKW8sK4cwO7fy3pPDCkx1p+MTqu1cpEFsRbP/hL0TVMpmnhpAro19dL
         OUVKHcPEXwtsgjhxrSO9GHvYnErMeNprYmHPDneAqUk8H/7BSnpHCAjcPl+3uaZUePzs
         wVEv2qaF7wC24QKvm3pRkg2UIViJ9A0nXU07RutLBm+FPWecxDa+yPkKTByIr4IcTEo+
         oCDw==
X-Gm-Message-State: AGi0PuYjlRxzFPfAhYem9uFklacL8l7Ny6ysIRRn0gSKguTxK8dnUSII
        0aitKEb+wX7g1xUdZmeqddTfNFpyKZv1OY/sRns=
X-Google-Smtp-Source: APiQypIA0932UWNNLjzKhywVmTn/3GJVVMRDw1LWVt8CiDGkZ0Cw1m/jF3q15B9VwOqDYmv7r5we+L8QC0C52VvUIRA=
X-Received: by 2002:a4a:3005:: with SMTP id q5mr15406362oof.53.1587438980092;
 Mon, 20 Apr 2020 20:16:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200418163605.32461-1-bijan311.ref@yahoo.com>
 <20200418163605.32461-1-bijan311@yahoo.com> <20200420170706.0d813d96@gandalf.local.home>
 <CAMvvPS5eAoA6nsv9s7iA7wU1g3LKGXOusgg0Lfnyag25L0oTjQ@mail.gmail.com> <20200420223118.5a6db47f@oasis.local.home>
In-Reply-To: <20200420223118.5a6db47f@oasis.local.home>
From:   bijan tabatabai <bijan311@gmail.com>
Date:   Mon, 20 Apr 2020 22:16:09 -0500
Message-ID: <CAMvvPS5riZw0HH3503XQfGstCv7w+-5vp4V3CfVze==njBr0hQ@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Stop recording when processes traced with -P exit
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Bijan Tabatabai <bijan311@yahoo.com>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 20, 2020 at 9:31 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > Hi Steve,
> >
> > > Won't that while loop just go into a spin?
> > >
> > > What about something like a fsnotify on a /proc/<pid>/ file?
> > >
> > > I rather have trace-cmd sleep and wake up when a task exits, than to do a
> > > spin. Like it does for the -F option.
> >
> > I just tried doing this using the inotify API and hit a snag.
> > It turns out inotify can't monitor pseudo-filesystems like /proc, so I
> > don't think that suggestion will work.
> >
> > What if I put a call to sleep in the loop?
> > It's not the most elegant solution, but that way it wouldn't be too
> > different from the current code that sleeps for 10 seconds after
> > checking if finished is set to true.
>
> Perhaps using the new pidfd interface may work here.
>
>   https://lwn.net/Articles/794707/
>
> It was added in 5.4 (which is still rather new), but this would be a
> new trace-cmd feature as well.
>
> -- Steve
>
This is a stupid question, but what would be the best way to use the
pidfd interface and also keep backwards compatibility with older
kernel versions?
Or is that not really a concern?

Bijan
