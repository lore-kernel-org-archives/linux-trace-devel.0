Return-Path: <SRS0=Ttn5=65=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E42DC433DF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 May 2020 04:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3184206F1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 May 2020 04:53:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eo31tiCw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbgEOExe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 May 2020 00:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725899AbgEOExe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 May 2020 00:53:34 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D551C061A0C
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 May 2020 21:53:34 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z1so420425pfn.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 May 2020 21:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TEBUPT1KhyvgvN3aondqFiv4iZa7kwVEkRjUVPnXP/I=;
        b=Eo31tiCwRhVmwLXUvL4cr4cN34X88RTTxnU1OUmYq4CJ9cR1m3g/JS05tHNAC3puTe
         0Dp7xX2AhzE4I5D6axdVfSXDcw7P/lED6zPKZf4PKhGxNwnGZzI45/pXx/8LP078szRr
         EnI81CvJ4iN5G2iWOHBgW6m9W4Lc9LyQLA1VKvFizyn/YUM2kPCUAPd6aBFCYeCLSIrp
         pvsuHMi3//6EcasPSUABpNIiGO4rJaIqsHMVxvtAW/yLsi6Vw9RBZU1u115fua8gXnrF
         XBIrQ6aPRpeAzVxwZGR6haDo/pDhLDj5SCcCRaKBz4V8tKbHbxaZFTZGS9s8T8k6VZ4S
         flDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TEBUPT1KhyvgvN3aondqFiv4iZa7kwVEkRjUVPnXP/I=;
        b=ubCANgIupr1u4dcOu7Rtm+T2r40mpXK0tvtXf5y9WO5M4UNzUM1ATatsKbljYM34Mn
         5blg7hDgrRaRzVMqp7nWJ5x/5xkXSwObygZaEI9+PrvKPPGfo0DhTe0SOcyU8T5uJltr
         BhgyG/lsAzn/tuts2qKzFAE/aQy0FIbN61FTdup2H5JZearrx8tPLfQekYdYanlkdrDu
         8isbQ965mCAnYt7umbYuXgk6j5PJ33DiorRiU86G+mWocMLjvGYoR5Aax/gJvRFbTFjV
         obpunTS98DQLrVOUua7hYEegzc/u7PmeHGDG10Ai8lVXISH0eHdIka9RPVx48u/NYw47
         3XlA==
X-Gm-Message-State: AOAM533RU1QPNZRWJPgnYII4FpzcF93s7+mcso5O9MsXHiX7JgYzBj9u
        /K80Qi06aHkIwjUijWd4v5ysWCPxOwKpDgpJ7MLlYTwW
X-Google-Smtp-Source: ABdhPJw4Def8csqXGwVGm3Qrd1Ye/Z5Ya2Fj6n8TheX1EvDQGuQ2uGOwWM8ZBJAXDffMloOgo805lKxDwOWSTEPfkMA=
X-Received: by 2002:a63:1556:: with SMTP id 22mr1486376pgv.307.1589518413699;
 Thu, 14 May 2020 21:53:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200514071243.2396492-1-tz.stoyanov@gmail.com> <20200514211410.0362161b@oasis.local.home>
In-Reply-To: <20200514211410.0362161b@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 15 May 2020 07:53:22 +0300
Message-ID: <CAPpZLN6g3CmBngdH==3yjTdoyT5th2M-Cd=xU4FBMQ534xYM+g@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Optimize pretty_print() function
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, May 15, 2020 at 4:14 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
[...]
> > +static int parse_arg_format(struct tep_print_parse **parse,
> > +                         struct tep_event *event,
> > +                         const char *format, struct tep_print_arg
> > **arg) +{
> > +     struct tep_print_arg *len_arg = NULL;
> > +     char print_format[32];
> > +     const char *start = format;
> > +     int ret = 0;
> > +     int ls = 0;
> > +     int res;
> > +     int len;
> > +
> > +     if (*format != '%')
> > +             return ret;
> > +     format++;
> > +
> > +     /* %% */
> > +     if (*format == '%')
> > +             return ret;
>
> The above two checks for '%' isn't needed as it is checked by the
> caller. If for some reason that the caller didn't catch it, and we
> return here,  it would return zero and the calling loop would never
> proceed. It's not protecting anything, I would just remove these two
> checks.
>
> > +     ret++;
> > +
> > +     for (; *format; format++) {
> > +             switch (*format) {
> > +             case '#':
> > +                     /* FIXME: need to handle properly */
> > +                     break;
> > +             case 'h':
> > +                     ls--;
> > +                     break;
> > +             case 'l':
> > +                     ls++;
> > +                     break;
> > +             case 'L':
> > +                     ls = 2;
> > +                     break;
> > +             case '.':
> > +             case 'z':
> > +             case 'Z':
> > +             case '0' ... '9':
> > +             case '-':
> > +                     break;
> > +             case '*':
> > +                     /* The argument is the length. */
> > +                     if (!arg) {
> > +                             do_warning_event(event, "no argument match");
> > +                             event->flags |= TEP_EVENT_FL_FAILED;
> > +                             goto out_failed;
> > +                     }
>
> Since all cases to exit this loop do the same check, I think we can
> move this check before the loop. The old code didn't do this check
> properly for %p, but that was a bug in the old code.
>

We still have to check for a valid argument inside the switch for almost all
exit cases, as the '*' case can consume the argument that would be verified
before the loop. And there is one exit that does not require a valid argument -
the default case. The old code just prints the unknown character, without
consuming an argument.

>
> > +                     len_arg = *arg;
>
[...]
> -- Steve

Thanks, Steve!

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
