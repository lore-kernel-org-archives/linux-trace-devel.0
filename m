Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2DEBC2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 10:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D4B1613AE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 10:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhFVKqO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 06:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhFVKqO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 06:46:14 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB90C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Jun 2021 03:43:58 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id u2so1509130plf.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Jun 2021 03:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uZoxIcXTLTzHdi7gXSysUiJIa6XMT9erO67lKXKonuE=;
        b=MI/KPJ4+mPjcRnHtY3M3AOGPbtnmIbOTpmMgpP8W9K6vROOURhDG0Ky/xVQiHoBR86
         rmnGR9FJ22d+T96igi9sMQ3ZRH3W20kutIPl9rAFV40euwuDQ6kFaHbRfsA/TxxPR8cP
         //E6UUVfURCcy7zvr8thlNmbtM5urcmPd/a7jQkVwc+M9pdTRqyGtIwi/KdQSC4BDy8j
         0H19DQceITz6o2Vqa2+EqTmM1laUI+1FGmleMErVCz2yEtYiXN4W/CxbBwKTKseSzF4p
         t5YaBORXjd6z4Ju1dDu//0Xik31pIy6O3nWRByrJ/cLLqCm5lSGxDQ0TvnEEHgtUKgvY
         lLVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uZoxIcXTLTzHdi7gXSysUiJIa6XMT9erO67lKXKonuE=;
        b=ZG4gJTNJH/gB05p11fvcftpOLb+xVcuqHy/O16yN4GLSsQaXTW42Qdo86e8MWIEK8q
         Y4RrS5NgOb9llOpI90Pz+VkVmVUUKraOXPwhoMwCle3Hka0eY9gzPcm1DetsX5iBLkYI
         EVU8Qsnfh9Clocycik8Odlkm0rl3Lb2vP95ggU2MditkXjDM6DwKBSXnJLXRdBSpERVF
         LEUQ0Lzz7fAGyH0TB2mIipeXRRY59CixL7opGjkmsxs330CV8C8kjRJCaIdy2hLWHNvf
         DqkkEFeRMd6SVsERLnZHJV1fjwFuteehqY0RUkKj/kWQgFBez4eVNk9yy7YJ28C7d9Sz
         s/lg==
X-Gm-Message-State: AOAM533DYBxbrxad9eftpEABpLANRcjs5nPI9ziu3/PMFejt4Hz71yni
        K1MZhyHDZX6Rbfmm17Q/DDGfdOPLH9m3W70uRHo=
X-Google-Smtp-Source: ABdhPJzMxucyoEBVvhiYKLts3EoI4HYwN+GOprpAOpswKfHlwTNwn3JPslGe96PbephMdULcqzQFWZwFqcSyx1O1TtM=
X-Received: by 2002:a17:902:da91:b029:116:864e:893b with SMTP id
 j17-20020a170902da91b0290116864e893bmr21885830plx.26.1624358637749; Tue, 22
 Jun 2021 03:43:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
 <20210614075029.598048-22-tz.stoyanov@gmail.com> <20210621191040.6ba78839@gandalf.local.home>
In-Reply-To: <20210621191040.6ba78839@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 22 Jun 2021 13:43:41 +0300
Message-ID: <CAPpZLN41M77nAfQKomvnv7JxZK4kYHnnWT6K0ytaJSKbhk9knA@mail.gmail.com>
Subject: Re: [PATCH v6 21/45] trace-cmd library: Add compression of the option
 section of the trace file
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Jun 22, 2021 at 2:10 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 14 Jun 2021 10:50:05 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Comperss the option section of the trace file. This section is not big
> > currently and compressing it does not reduce significantly the size of
> > the file. This could be useful in the future as new options can be
> > added, storing a potentially huge amount of data.
>
> I'm not sure we want to bother doing this. New options should never be
> large, and if they are, then the option itself can be compressed when
> created.
>
> What good reason is there to compress the options?

I think adding any new metadata should be done only by adding new
options - this will not break the format. For example kernel debug
information for parsing function's arguments - it will be huge. Having
the entire option section compressed will simplify that. And it is
consistent with the other metadata sections.

>
> I believe this is just adding more complexity than needed.
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
