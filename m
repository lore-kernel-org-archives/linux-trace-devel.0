Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88CB0C48BDF
	for <linux-trace-devel@archiver.kernel.org>; Sun, 13 Jun 2021 21:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6557461357
	for <linux-trace-devel@archiver.kernel.org>; Sun, 13 Jun 2021 21:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbhFMVe5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 13 Jun 2021 17:34:57 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:44891 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbhFMVe5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 13 Jun 2021 17:34:57 -0400
Received: by mail-wm1-f46.google.com with SMTP id m41-20020a05600c3b29b02901b9e5d74f02so8513780wms.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 13 Jun 2021 14:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pkq/8ffcKgCIqRFekLzwf3l7lsfl2q8Gn0sAz/D4XOw=;
        b=tWAwegX6SDzinI8jzs791QNcCGKerPUnSn4PClRE46V/ltFt/g4KgpN5cFTY/BWXT9
         sBBZZmxCzEW13MvvTIdqS/Z3C9ziM6Ye3fZuq58fPJdUytWH8Buf2yTRctPs7p5AXQBZ
         V27axEDayMHBacMmmYdhrApWlzzp/7/Hn1EVRKQa7axamosg/QsUVCsOYin6RAHd8TZt
         AGOzm8OB3RKaXziCfiDi99cKLMAmheQnX8PRJ2yuOvDnGnBREWKpPiThp8TcELwBeaxr
         C+X/R9yzVl84Ow9Y6H0ypnGoizATaqUSXx426js2TGDeAxuan4Zzxep4KTwIF01BAolU
         xagQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pkq/8ffcKgCIqRFekLzwf3l7lsfl2q8Gn0sAz/D4XOw=;
        b=c4QhE6eZg1EuT7E1DysibL6UUvHkbLtH0uplpwdY3rceahUCcopvW74hGpLT7//OFq
         ud4xDDuAp7U6jOoPkNcBa7/VDKBY5vTelR5UydIN9FCLBIWMItqxLQAiTornvQ1l3BD9
         4e6rXXkkBn2g9HM1CniNPmLCW/E8GJH/PJu+G1C85wb+hjoJUSAy/9/qYGRTKPxGHcaT
         qkA6lKAV7BS4QGFqJYtuaL6t9XBB5XQbh3LXO+NRCI4H0r36J5MQspVGSrYH9EKDs6ly
         LI22abZEPKJenyNQkrclxInV2MzrYCOjt5npLC00KnNMPdtJG4qd+JLxyUOy4/KH7srX
         WQgg==
X-Gm-Message-State: AOAM530raVZzUO9XACuS89vF3/jh5cskDF02yrF3egc8zdiqurE65F7T
        N/ONWweovNrmCA1tbpDL/4yMdFT287DXlY48aYnfEw==
X-Google-Smtp-Source: ABdhPJzuj8p/zn6nqw7FnrdBQ3pQUsWCaN02SrgbE3llg+8m1l3sTvisg71gTFLZWxTDkar+fUsZJ7EuJ2QnIzFMhxo=
X-Received: by 2002:a1c:b603:: with SMTP id g3mr29212847wmf.58.1623619914569;
 Sun, 13 Jun 2021 14:31:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210612014501.890593-1-irogers@google.com> <20210612014501.890593-3-irogers@google.com>
 <20210612190049.7e09d8c6@rorschach.local.home>
In-Reply-To: <20210612190049.7e09d8c6@rorschach.local.home>
From:   Ian Rogers <irogers@google.com>
Date:   Sun, 13 Jun 2021 14:31:42 -0700
Message-ID: <CAP-5=fX1riLr6y8KapEhmxk3BW1Xq9kV_zMywoQ+B8Dgs6fxeg@mail.gmail.com>
Subject: Re: [PATCH 2/2] libtraceevent: Changed angled brackets to double quotes.
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Claire Jensen <cjense@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Jun 12, 2021 at 4:00 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 11 Jun 2021 18:45:01 -0700
> Ian Rogers <irogers@google.com> wrote:
>
> > From: Claire Jensen <cjense@google.com>
> >
> > Signed-off-by: Claire Jensen <cjense@google.com>
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
> >  src/event-utils.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/src/event-utils.h b/src/event-utils.h
> > index d377201..44f7968 100644
> > --- a/src/event-utils.h
> > +++ b/src/event-utils.h
> > @@ -10,7 +10,7 @@
> >  #include <stdarg.h>
> >  #include <stdbool.h>
> >
> > -#include <event-parse.h>
> > +#include "event-parse.h"
>
> Thanks for the update, but event-parse.h is part of the exported
> library and even though it happens to be local to this file, we use the
> '<' and '>' to denote that it is a library header and not a local one.
>
> -- Steve

Would it be more conventional in this situation to use quotes within
the library and angles outside? This change is within the library and
not with code trying to link against it.

Thanks,
Ian

>
> >
> >  void tep_warning(const char *fmt, ...);
> >  void tep_info(const char *fmt, ...);
>
