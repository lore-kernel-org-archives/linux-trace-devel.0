Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1963FC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 04:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D349861185
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 04:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhEEEq6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 May 2021 00:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhEEEq6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 May 2021 00:46:58 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F23DC061574
        for <linux-trace-devel@vger.kernel.org>; Tue,  4 May 2021 21:46:01 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v13so466270ple.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 04 May 2021 21:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xh2Dei6RlvM9/xBsqEB0pvLHHYJvcW1i1vycPhrQ6oc=;
        b=iFvfXF/kWRllEGaF8nKhwQzLfwdC63pwJWEUswQeKPpdcGoNByqKaC9buoROBScdFn
         hZZ7cO9ztxCbWUU1AYydUwdc50pSeUHzTZWKWYbtJvb/RpP+86ii6iZWcJ6h/Axngx9B
         Wn2qipSkihv1bIKoifFkjQqAI2mlajSfomdPQMlZwENpYEBWryPqWFY/yLGBr9PlzQ1p
         ZiC4IQs65cHh6uDQ8Q5cc7pcGPIF2FgQv13E89Df6nc1CA7XiCDpouBHVTedsC4ydNeQ
         JGwjboJPu31dMtljUfzH44OEJnDY03x+g7mhBdmE4bnbU8eG1Wfvx87CBWFJauEPoRHU
         pFCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xh2Dei6RlvM9/xBsqEB0pvLHHYJvcW1i1vycPhrQ6oc=;
        b=giGDcO8OJM6CJkqdB43ZjFn2vkY3fPT2LdzjZnc1GtujFPUx+ARWe167drfMN8nHCI
         SCfN8Uop0MvFOBCtJHohcwfA8kNcZrKDA1bAZbyjPDW9M59WLTKSCGE6GMejfnmPYe54
         Yv2hQntaYF9UBKzpopX85GkpNZIwFb1lnhkR6k7SIEIHA/dDZIM2lx8LBf4fQoRu/kJS
         gLpeOVLCGT/QSybMHPrnjB5lfqS//W/z9ERQTDXGl+R2/rCgOv6m4weCi3zqF6lJxN88
         hP/NwG1116Ak0GwzPSKWKPSzdwQdwe5zthF/XPV0strlzV9V0CWDq51jBVjZDGDwTyTS
         LNyg==
X-Gm-Message-State: AOAM5332X/WwtrN/f/V7nKHJNUcN6Zy/61QbzAYRfmC5oj2zwtUDO7T2
        N+MSVDux27QmuSZx/onppIMJ7qJ/flb68lR1aJySt3KGB5i82w==
X-Google-Smtp-Source: ABdhPJxebdvGU8hd2VL+reKNG2eMY2gAjj79lJHyBFa+WOxlPAOuFMTxThjyz+sHzGXKI+ImwK6NS36C5NDWoU7tTp0=
X-Received: by 2002:a17:902:d681:b029:ed:6877:376 with SMTP id
 v1-20020a170902d681b02900ed68770376mr28838046ply.58.1620189961073; Tue, 04
 May 2021 21:46:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210428073001.755905-1-tz.stoyanov@gmail.com>
 <20210428073001.755905-3-tz.stoyanov@gmail.com> <20210504162425.5cced88c@gandalf.local.home>
In-Reply-To: <20210504162425.5cced88c@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 5 May 2021 07:45:44 +0300
Message-ID: <CAPpZLN4opBm_OQm2HYH73PmpBOmV9VMaV1vt+Wx_EzjOOAPWcw@mail.gmail.com>
Subject: Re: [PATCH 2/4] libtraceevent: Add logs with severity info
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, May 4, 2021 at 11:24 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 28 Apr 2021 10:29:59 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> >  void tep_info(const char *fmt, ...)
> >  {
> >       va_list ap;
> >
> >       if (log_level < TEP_LOG_INFO)
> >               return;
> >
> >       va_start(ap, fmt);
> >       tep_vprint("libtraceevent", TEP_LOG_INFO fmt, ap);
> >       va_end(ap);
> >  }
>
> The above should just be:
>
> void tep_info(const char *fmt, ...)
> {
>         va_list ap;
>
>         va_start(ap, fmt);
>         tep_vprint("libtraceevent", TEP_LOG_INFO fmt, ap);
>         va_end(ap);
> }
>
> And let the tep_vprint() decide to print it or not.

The tep_vprint() is used also by libtacecmd and libtracefs for
printing logs. Each library has its own log_level local variable,
that's why I check the log level in the library specific log
functions.

>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
