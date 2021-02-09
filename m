Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A51C1C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 11:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B20F64E10
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 11:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhBILsG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 06:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbhBILpi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 06:45:38 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC2BC061793
        for <linux-trace-devel@vger.kernel.org>; Tue,  9 Feb 2021 03:44:58 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id nm1so1407818pjb.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Feb 2021 03:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m5icVyHSzXNyDeuYQDyYUjhI+/d9LTfPgs/VqFREg+c=;
        b=itvgOJtLeOfocd8nYmEo+3UGoeckamcK39CTAF9u1X8m00TkplITwwnTi8ueXGIkK/
         PsvY8ZpJgAOOrRwaRRYiv8fAC3koGZaFLgJ9eSMdoxlSaNAE3KSzxUm7nvxvgbvKCJoG
         wj2V37IC8RJ1gTN9ldsUptDj3q4PlO5CaeRNsnr0ajuLbDZClKpqC7mUXv4Z2ZQjNh4E
         ZProLWeaPMXlrXzBWCgpv+9RoZ/cAbw82rWo9ByN9djmOFinfaXD1erug1gRMnqk/8zx
         rxvPo+DpZIwKA3gkdBuwCEPl4Y7wChK3zCBbHovYWSHXvka0g7dg0gANjTODLegEVxn6
         Kanw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m5icVyHSzXNyDeuYQDyYUjhI+/d9LTfPgs/VqFREg+c=;
        b=F1fHaoV64g+aQhAo6CAkWzuAx+miw5xG+cErHa0e/uCgBDcmdD+lViA6JTSGuN8/kl
         yfkhgN3dYIvGV50nWqmiD+vEJII63RexzB8RNoOu1+06bRMNZle5YVbmIhmRPea61AK1
         T6HKpDbSdMchc9xDs+ceb8kBh95MDrpqIknAf6BCs3KcDskKXO1nWDGsAcRFFnYudVWG
         NTdNLdSm7a50b0qkLSo27fGAl+1oXLvfHXfhGQvyortprF2AQ7gvsT2mlORaikC0bnek
         ljO0HcXOX98NA2hEjj6jUAXmmSnhmUkEHMUhcKK9c/AyaWg4f56uETbNsvgmqtEosxMn
         W8Tw==
X-Gm-Message-State: AOAM532sGtUYAi5KfdelmcL/p+hGil+l1jk+VS7BskPzAbs14gbOESMO
        TxBuxd+heR2RQh+PmbsHOCITeVGxvypNPWpYj5ihCjc1Ajw=
X-Google-Smtp-Source: ABdhPJz5PT2aNUsP86MF6smy/Mn5Ofw0rUQetASkW6VRyEGeWAj26ndhaE4bBDaU9C3xBLHgbaW5d9Dyz8Vt+AMHfX4=
X-Received: by 2002:a17:90b:3886:: with SMTP id mu6mr3556366pjb.153.1612871098191;
 Tue, 09 Feb 2021 03:44:58 -0800 (PST)
MIME-Version: 1.0
References: <20210208061743.510964-1-tz.stoyanov@gmail.com>
 <bb09f02e5d1e14cf835c85c97ae7902976bdb408.camel@suse.com> <CAPpZLN5SQu=XwQ+XodbVWrXUb-qtcLjH-U79R6NBDJ4jwQSvsw@mail.gmail.com>
 <CAPpZLN7boZK+9921zJ+OvZ-yhT6DdAkWkj9+fgswV_g4PxsROg@mail.gmail.com> <f6a169322dde8038832371fa1d5856f74e2ab308.camel@suse.com>
In-Reply-To: <f6a169322dde8038832371fa1d5856f74e2ab308.camel@suse.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 9 Feb 2021 13:44:41 +0200
Message-ID: <CAPpZLN6wUD4wFLLODFL3529vz_khKgvK-PkHspOzA5zEwPeHjQ@mail.gmail.com>
Subject: Re: [PATCH v28 0/8] Timestamp synchronization of host - guest tracing session
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Dario,

On Tue, Feb 9, 2021 at 9:28 AM Dario Faggioli <dfaggioli@suse.com> wrote:
>
> On Tue, 2021-02-09 at 08:08 +0200, Tzvetomir Stoyanov wrote:
> >
> > Also, please note that there are two patches that should be applied
> > also,
> > not part of v28 version of the patchset:
> >
> Aha!
>
> >   "trace-cmd: Fix plist allocation check in trace-msg.c"
> >
> > https://patchwork.kernel.org/project/linux-trace-devel/patch/20210203165431.792152a4@gandalf.local.home/
> >  "trace-cmd: Fix SEGFAULT when no tsync_protos are supplied"
> >
> > https://patchwork.kernel.org/project/linux-trace-devel/patch/20210203171018.5b82a0a7@gandalf.local.home/
> >
> I just applied both, and it now seems that things work!
>
> Or at least, host and guest talk, and I see this: "Negotiated kvm time
> sync protocol with guest (null)" (is that "(null)" ok/intentional? I
> guess I can check the code... :-))

That null looks like an error, the name of the guest VM should be printed there.
Thanks for testing these patches, I hope the code will be stabilized
and merged soon.

>
> Thanks a lot. :-)
> --
> Dario Faggioli, Ph.D
> http://about.me/dario.faggioli
> Virtualization Software Engineer
> SUSE Labs, SUSE https://www.suse.com/
> -------------------------------------------------------------------
> <<This happens because _I_ choose it to happen!>> (Raistlin Majere)



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
