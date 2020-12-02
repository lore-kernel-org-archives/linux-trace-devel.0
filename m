Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09383C71156
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 19:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D7D9206A5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 19:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgLBTc2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 14:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728477AbgLBTc1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 14:32:27 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF45C0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Dec 2020 11:31:47 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id i18so3166712ioa.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Dec 2020 11:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mOyVOq23P0S/DlcYsr/pZwyOx3c3ymZpfDlLpHds5TU=;
        b=H7jMHTYvmqo1lFPM8ZrAbAQEVBWtCEcReIyOXn3PzhXJ7KnjC91K4psmeh6RN+JyRi
         pudQpiH3h3hSXOUy39TFHC7yhD9I4wHZ2CzQRBJ1dnxR/KiiOqrLE4a4h5SqtDbeZBWg
         HJlaByj9pebcGs8IpTxURbTz4qFeaRbUFVOvREPoqZoM4Fpt/enC+Hby01DFKbirxlie
         Z3yqeMrG7qJNWDzMVtpiEVyavh3hmQj2flbs3ZQtcFxrsDYIHCaW824YPsln+tP5sZzL
         UqLyewuuIqmnfWtSiA9BKcwFuxHCAhTrDVmAo0EGJy4If7eHz37evscdHJAuXrmvwA5v
         kZmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mOyVOq23P0S/DlcYsr/pZwyOx3c3ymZpfDlLpHds5TU=;
        b=nxGBwm9EaLw7r1ig4UAk/tLkJVc1uCK9evyMe14PorvVh1uv3m5gyu+2vK3R+rbfYj
         3Lngelf+dsOZ8aV3r1qdeWO8iWLUGfIYVD5kYgn85u9VPsDPKK9zVhcDgEzZrFZ0much
         PtwuT32x2WT45eUlVSpcDTTwbyTppd1DW9WEQdst7Gx8n8R/99VqsuM0k8rK6/5rIF9k
         vGNMyyVv8ot9JWVcXuC7qTu9K2MsuIzHEwD8RYw+Vka/qeeXEcdUbnf4tam83OEiXgIN
         o1buchp+v2yzXAbK6nfMzZ3UDBeyfNgK+5KrCY/021QXbBlB6kRhhKA6lpb9BR7UCxGZ
         LO3A==
X-Gm-Message-State: AOAM531ftomuoVUIZDFvyNvLu5V6AMD8jKbQcG1Rapt3rh6u18UdGQCN
        yncdTcnL51P9pCtzGpTwmN3e/pWNh1rEqNSbohU=
X-Google-Smtp-Source: ABdhPJyLKDnNBV8N2TemWJFHJ48wAY5mgje7us7QnE28k/IAdaejaWMhy4KwZAHCtXhScUfbNMQLArMQ9vfamIdhrIQ=
X-Received: by 2002:a5d:85c7:: with SMTP id e7mr3285609ios.162.1606937506906;
 Wed, 02 Dec 2020 11:31:46 -0800 (PST)
MIME-Version: 1.0
References: <20201202040802.327203-1-tz.stoyanov@gmail.com>
 <20201202093647.78d861ec@oasis.local.home> <CABQJdOGMr6tbsH=nLeCVJ5sVdDBvg2Ba-wL4d9T7ey50RYZn4Q@mail.gmail.com>
 <20201202142327.3b178edf@gandalf.local.home>
In-Reply-To: <20201202142327.3b178edf@gandalf.local.home>
From:   Beniamin Sandu <beniaminsandu@gmail.com>
Date:   Wed, 2 Dec 2020 21:31:35 +0200
Message-ID: <CABQJdOE-xzRjO0GEW4uiYFXYrQ=oEw3fq9aKsZ7YAa2P9yJv2Q@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: make it build against musl C library
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Dec 2, 2020 at 9:23 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 2 Dec 2020 20:43:58 +0200
> Beniamin Sandu <beniaminsandu@gmail.com> wrote:
>
> > Hey guys,
> >
> > Sorry to hijack your thread, my previous replies got bounced back by
> > the mailing list (although I sent them in Plain Text mode), so just
> > trying again now to see if it works...
> >
>
> I see this in both my INBOX and in my trace-devel folder.
>
> -- Steve
Yep, looks like it's working now.
Thanks for the reply and for accepting my patch!

/Beni
