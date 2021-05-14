Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1558C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 02:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 827D3613F7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 02:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhENCwv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 May 2021 22:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbhENCwv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 May 2021 22:52:51 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5CCC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 May 2021 19:51:40 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id pf4-20020a17090b1d84b029015ccffe0f2eso882248pjb.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 May 2021 19:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wimw0K3GR1ZjijmHQTGKLu+cXfB0BONKgxePK9Zy/uE=;
        b=g+JXf3xQWfwFBGFnSDHFM1HjCruXMtlcWG6dZ/gL4U5YRfUiWVfgCBHJfUJCTEYEph
         ZYrabW1O1qNd3Mzu7ms+YBMJPVsCTkqTtbZUq5n2fxpDBj4ZaWQlhnLcBrSymgZXS9R4
         +7rwfoxikSFFgEyI9NLrxdQqEIGdG1pELkTYTyjI0nBj1qFIA4AiNqciaJ4jpSY4S6vM
         xauP3/l148qHBOdcIPNZnSgw8LtqUVphe8P/k2Az6+shQoPMpNDeBxBKV5vhF8verA+y
         qAsaayLI5Rq5NT5+c9HiBM1ydKUjxUfdcXvExF1eyWhQHTQb7Pjro43ORE4V27gPIU9t
         emog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wimw0K3GR1ZjijmHQTGKLu+cXfB0BONKgxePK9Zy/uE=;
        b=aeSFN0izr9Dk+Jzk9zxucijpuyizsIC1r5vUIhihI2a2HknuQLBV7E7oSDhN9ZyCk/
         Aov9z35mP1eDxFkGk2J4q3WqznwzPwXmPERGUfnbwFBMO0a87P0iNDcK6em3rinY6Cm9
         dczOiw0HKoErql1+ZBGRq6ArQ8tnJTuJZr4bzVmrRvI7iotNIRsKOuekIkLr3LEiuWAa
         Bzujvwj4Lo/4tzxqTFz6qu1poG2ptmMJSFfWPNX+hvZkFIUd2WWjS6v6ACmC3s4ozzxF
         dJM41PwHBnoWMIZJ7oxCbaMQ2xVmKPOO8DxNdElLIfSxfszHu9lpOMCTgAeqczNv5Qmp
         JnWQ==
X-Gm-Message-State: AOAM530fFluoEUkv+stdgDyE2zpMnMSPcOHdPx9WbDboCWcpds256ccV
        eoNiGvzQqGU2OWLOyyLpvHQlqrzk6naCh6MUkoQcdl/Y+LxyjA==
X-Google-Smtp-Source: ABdhPJyjgbQ5K9U1hthG7ERpaykWORluBrMqQHiu8nClXHQvgCkJ2OxZF6Qf3vSuf9eusfIatrZL5ZaACDr/OI8/b/A=
X-Received: by 2002:a17:90a:db02:: with SMTP id g2mr3109976pjv.2.1620960700448;
 Thu, 13 May 2021 19:51:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
 <20210507095333.1080910-4-tz.stoyanov@gmail.com> <20210513172338.79ee4d2f@gandalf.local.home>
In-Reply-To: <20210513172338.79ee4d2f@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 14 May 2021 05:51:24 +0300
Message-ID: <CAPpZLN6+Tvdef-c6qgeg-f8RTpmAhxi5yy1am5FykyFVU4zTcA@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] trace-cmd library: Add log levels
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, May 14, 2021 at 12:23 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri,  7 May 2021 12:53:28 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Removed the "weak" definition of the library log functions. Setting
> > the desired log level can be used to silence the library logs, instead
> > of overwriting the log functions.
>
> That's not the purpose of the weak definition. It is so that a GUI (like
> kernelshark) can turn it into a pop up if need be or show in a status
> window. It was not for quieting the function.

The description is not correct. All these log functions use
tep_vprint(), which is implemented as weak. This function has
information for the library and log severity and should be used by
kernelshark for that purpose. That's why I removed weak library
specific functions.

>
> Please do not remove the weak symbols.
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
