Return-Path: <SRS0=MjeC=CY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397D7C43461
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Sep 2020 13:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E256F20B1F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Sep 2020 13:13:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gxKPlWHc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgIONNO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Sep 2020 09:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgIONNL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Sep 2020 09:13:11 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B785CC061788
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Sep 2020 06:13:00 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id kk9so1700368pjb.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Sep 2020 06:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=teBauf1eYqgWKlGYBPzKeVqVLaub7TS6l+fh6l5QSDs=;
        b=gxKPlWHc1cwndMUtwiCCQmKpf0LPl3scuK45YVxFY59pdimIkhbI9Id8RiWBPWfWgR
         h/AP9gugprlQL7eKBAISoZXoZcPPkGfgdjzAUnFC48wIQM38nwxj5egDKGN0nZ9ENgtP
         Gs9IZObYsRAW07gUZdEOUL39g9iiL4OiEeE7zpZSxYO/oUpcqJzlx/CxdJT1SORLCpmc
         vWdcYLeFDkzLUYvC8F2zfdG5hn+IS+Pvdfy8syhgzFzh+/WcnZ0JlKfMWtFVl6phGpet
         e6gz4jyTmQ7nRcHP89CItabiOjf+ocSfuUQHkbq5b8Kchw+DV9R90lfJ2837mqcOPc6x
         1Q5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=teBauf1eYqgWKlGYBPzKeVqVLaub7TS6l+fh6l5QSDs=;
        b=IEfRM64C+BPZm0rgOaKbiWBcdlQ5N4YT6w7Be8H2k7t6ZHcBhf1tYkZJrq3yjnjPjB
         GE7XOrSeK9voIpbu/EeAoWjtrS4cdcigltCBuKVN00/ajrIWyVKKtC3reE8OO0vPftL2
         I7P6Viu9ymb9vF3VzZWAueWtlbRbyyynI4dfcsaJHjeYDh24yiMXGY64GPtutbx/9+wi
         i7qk+TGOnMrVQ/V22DhhIDCntQxMTwcoU4dGDCozHsQn/FGwfhtAXjCgdPE/miDo+GT3
         aBJKBzMpL+qM5KInZrqrX6G0AHTvydSV7Q4XP8YDigOwubWoQZDFbazCkw3LoklOoI/P
         uipw==
X-Gm-Message-State: AOAM530Dhdtlj9pCyjfSy5zmibNtBrEa5t22FkPAK6flzqx6oAqp3iJc
        NtnWhckn0jDfWWXgChzuqEkwuDJDozCuz4/KvDfFMm+iJlawFA==
X-Google-Smtp-Source: ABdhPJxoZmj3DdqNSQS5BafXFhbMWxcVLy4ZzImg25hHl9ZYHh1W9zQMzo1yiZqczGHCUixI3fY0Wr2WVOvMsRTIFUc=
X-Received: by 2002:a17:902:b590:b029:d1:cbf4:bcdc with SMTP id
 a16-20020a170902b590b02900d1cbf4bcdcmr8193455pls.29.1600175580221; Tue, 15
 Sep 2020 06:13:00 -0700 (PDT)
MIME-Version: 1.0
References: <e4afdd82deb5e023d53231bb13e08dca78085fb0.camel@decadent.org.uk> <20200914212945.GC166601@kernel.org>
In-Reply-To: <20200914212945.GC166601@kernel.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 15 Sep 2020 16:12:43 +0300
Message-ID: <CAPpZLN5Wt3dFxxLh1aCN43kJWAadsPXga7wXGUxDDPzHW3Ot=Q@mail.gmail.com>
Subject: Re: tep_free_plugin_paths() function in libtraceevent
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Sep 15, 2020 at 12:29 AM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Fri, Sep 11, 2020 at 03:08:16AM +0100, Ben Hutchings escreveu:
> > I noticed that the new function tep_free_plugin_paths() is exported
> > from libtraceevent, but is only declared in a private header file.

Hi Ben,
The tep_free_plugin_paths() function is supposed to be an internal
function, not an API - that's why it is in a private header. What do you
mean by "exported": the "tep_" prefix, or the fact that it is not static?
I can remove the prefix, if that is what bothers you. The function is
defined in event-plugin.c and is used in event-parse.c, that's why it
cannot be made static without a library redesign.

> >
> > If it's meant to be part of the API, it should be declared in a public
> > header file.  If not, I think it should be hidden from library users.
> >
> > (I think there are other only functions with this issue; this just came
> > to my attention because the Debian packaging tools prompted me to
> > update the symbol-to-minimum-version mapping.)
>
> Tzvetomir, can you please take a look?
>
> - Arnaldo



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
