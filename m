Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A87CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 12:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4063461262
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 12:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhKEMSB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 08:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhKEMSB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 08:18:01 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13919C061714
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Nov 2021 05:15:22 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c126so244550pfb.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Nov 2021 05:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OURDJ4pw/FOAC34rSSPtQCbiwjPEmg4gDnghpYqZSn8=;
        b=H1QZ/dirGSfjazawVEM1g5wDeo6N2INTz8LYSbjKZ1xiV0BgpMz0e+rJef3DsGGQq3
         YpUZV2SGjeVhmyCq2YpBUqynv/BzzBFBP+vsVLtmVgiLJSUJiZWKm3oHhTQvv+WSEo+e
         q5+HGtADiPy215rr3LHTzqDf4WDYRax6Dr/FcPLImnBSilBK6bdix0o9ihizQRAVh1vE
         NaHm2QqfVibQzj0D0EcYSS867FIzA4i1UP2ahBEEQb5dFsn/G7BhO/Phif5zk2tSW86t
         Sa0+hDvglibeb8jdsIXw3E3Oz4wywEXmgMOJbtsak51gu5kq/sgF1xwDHOnpfJKTW7gZ
         Z//Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OURDJ4pw/FOAC34rSSPtQCbiwjPEmg4gDnghpYqZSn8=;
        b=xnANQODDFV3YNbKRWwLA4jns/VW0xG4Sq9/T/RZXGcDZHFS8Bgtb/meY8fEeWGTd8N
         /0jsiprnkFXcE1DgJWkRs3KPn0sX3q82tE1Ea1FCkwgReKpoXBfp1vQdDVqDE1C5ZLtX
         dPfnIzy21Zc66HaZ1ox9UP8TDm+KtYuCcDilyJ3pK30fq1O5GMi5WPNjBePtTP+LghsN
         QBhWnv3QqxTnLMKPr6/0VfY5RWsXKRl2Q/1rXA8IwlueJyHkYt+dKTLGvf3chnfgeNuz
         ihngwB8iWw+HRUYpqH+EZ4mIFmi9CUIU4ffl/wvwbQrwvXTrFICRpGOMaE4SVOjmy358
         Ig3A==
X-Gm-Message-State: AOAM532fN2YMGY6/PVbSTlE+u3C0VhiRaNVKIj1AR/U1Zy0YjWq+lfwy
        tm3BrtCQdNwXOZSeSfo0zWmtg7fQMFalbqV1cBIP1pc0ESp8oA==
X-Google-Smtp-Source: ABdhPJw9E76371WCZ6850OclBaE+XwO/54g1anRTK58C3ni5hptlBUM1waYiOvV5xtCrt6woUjXy6hwqcO8UrNlyFHc=
X-Received: by 2002:a63:374f:: with SMTP id g15mr44564231pgn.193.1636114521458;
 Fri, 05 Nov 2021 05:15:21 -0700 (PDT)
MIME-Version: 1.0
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
 <20211104111047.302660-9-tz.stoyanov@gmail.com> <20211104131351.1110c122@gandalf.local.home>
In-Reply-To: <20211104131351.1110c122@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 5 Nov 2021 14:15:05 +0200
Message-ID: <CAPpZLN5bSdCKOvAMSefAaj0osq60qgcyRE7npMS6jPOcYoEAYg@mail.gmail.com>
Subject: Re: [PATCH v4 08/10] libtracefs: Use the internal dynamic events API
 when creating synthetic events
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Nov 4, 2021 at 7:13 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
[ ... ]
> >  static int remove_hist(struct tracefs_instance *instance,
> >                      struct tep_event *event, const char *hist)
> >  {
> > @@ -1919,7 +1911,6 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
> >  int tracefs_synth_create(struct tracefs_instance *instance,
> >                        struct tracefs_synth *synth)
>
> I think we should call this:
>
>         tracefs_synth_create_raw()
>
> that passes in the "instance".
>
> Then we could have tracefs_synth_create() just use the top instance (no
> instance passed to it), and we could decide later if we want to create an
> internal instance or not to do the work to keep from modifying the top
> instance.
>
> That is, we would have:
>
> int tracefs_synth_create(struct tracefs_synth *synth)
> {
>         return tracefs_synth_create_raw(synth->create_instance, synth);
> }
>
> Have synth->create_instance be defaulted to NULL on allocation, and would
> get updated by another interface perhaps?
>
> We could also add to the _raw() function:
>
>         if (synth->create_instance && instance &&
>             synth->create_instance != instance) {
>                 errno = EINVAL;
>                 return -1
>         }
>
>         if (!synth->create_instance && instance) {
>                 syth->create_instance = instance;
>                 trace_get_instance(instance);
>         }
>
> Would need to have in the destructor:
>
>         if (synth->create_instance)
>                 trace_put_instance(synth->create_instance);
>
>
> Or something like that.
>

I looked and tested more this code today, but as I understood the
instance is mandatory in histograms creation and should not be removed
from this API. That API appends the histogram config in the event's
trigger files, which is for specific instances. The histogram is
accumulated only in the context of that instance. I'm going to send
next version of the patch set, but without changes to this API.

>
[ ... ]
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
