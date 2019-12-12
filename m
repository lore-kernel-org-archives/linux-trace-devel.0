Return-Path: <SRS0=wXUw=2C=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51CCFC43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 14:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A3472173E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 14:00:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nplli573"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbfLLOAd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 09:00:33 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34990 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729524AbfLLOAd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 09:00:33 -0500
Received: by mail-pg1-f193.google.com with SMTP id l24so1208437pgk.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Dec 2019 06:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M1DZdrgYG1yUjAP3j9iKBZq18RIrMU/daMVTLlGoccA=;
        b=Nplli573oYWMqTnErl+MoEVgLXmkRKwjR7W196h5aCFTc1z1VkY/ReHAIH2ZguyuHT
         mQUELmbA6ByzJVk7MkgP0pTBjBo2YspI/2foSWYfd1eXxlHD2DQj1yzEdQoYZuBxBeOT
         zwh9j9R3mlKxzMp/XD5dI2Em9LX7rhps1xocw5jrIEJZHTrMcKh/uI7es+3F3sfqilOV
         Imx9MXLshdDYiBzMYRrO1WMjB0s+1xSo2ZOXII+I9xZReZtWq4YWPnVdsvgu95vm+6Gq
         FpYG+TH0WWVft/zZJyb21IPf/OtcuKrTgAFAUymWvAm9dJ477nRi0zxXRCt0mGVhVgvU
         N9Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M1DZdrgYG1yUjAP3j9iKBZq18RIrMU/daMVTLlGoccA=;
        b=cv0Lw8vK5FTzAVKQhbm3Ammy3KipR3l2YDScefsVNJgMxo2Hj2kuBZ3LMC4YaRMo7s
         Lv07EkIJEj3kKhi84e9lT8V0LoV0G85owAi0RMxFETtohSRqJC9x3K+jPdAdN0VjVHJ4
         uYmoyIXRPZL7ymfXc2Gw2Rc2SruvZSgJireYZ/IQ8mYGJfNzouPvFN6RbzPZEXU8lDj5
         gOlQUkdyTlDG+qJhVwJUEo/olYooz1TTZp5rtNOBA3QYn9oovwD0M+qu25QhmO3hCbMF
         oP8w0SGwa0NxjkiqnhTBYnnJhPgQjWUcRNlsXgV0GoZyC/DrXd9WHKmypEaIaRtROp+i
         ieCg==
X-Gm-Message-State: APjAAAXsq1m6RPOpS1p1h78eaGBTcorj1KD9ZQSrVix1CNINWWIaMsSk
        ApJ1zLvitdlu/pYqdlJlEIMjFzEq958RCCl47e2vC5N4/+g=
X-Google-Smtp-Source: APXvYqwaRQYSyLeHfMe/b+0CrS+usl6C4efWAz/Y6eoSYer2o5YojxMu0cHpGPbNV8ARoHFFHVcHIuV2ouUoM4g5+U0=
X-Received: by 2002:a62:a118:: with SMTP id b24mr9890590pff.71.1576159232902;
 Thu, 12 Dec 2019 06:00:32 -0800 (PST)
MIME-Version: 1.0
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
 <20191203103522.482684-17-tz.stoyanov@gmail.com> <20191210133919.47830c13@gandalf.local.home>
In-Reply-To: <20191210133919.47830c13@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 12 Dec 2019 16:00:21 +0200
Message-ID: <CAPpZLN480czXSPgTFyG5N7Jn4dY4KyKqmiUheDN_HK1gwe+iGA@mail.gmail.com>
Subject: Re: [PATCH v17 16/18] trace-cmd: Basic infrastructure for host -
 guest timestamp synchronization
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Forgot to comment on that in the previous reply :

On Tue, Dec 10, 2019 at 8:39 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
[ ... ]
> > +
> > +unsigned int tracecmd_guest_tsync(unsigned int tsync_protos, char *clock,
> > +                               unsigned int *tsync_port,
> > +                               pthread_t *thr_id)
> > +{
> > +     struct tracecmd_time_sync *tsync = NULL;
> > +     cpu_set_t *pin_mask = NULL;
> > +     pthread_attr_t attrib;
> > +     size_t mask_size = 0;
> > +     unsigned int proto;
> > +     int ret;
> > +     int fd;
> > +
> > +     fd = -1;
> > +     proto = tracecmd_tsync_proto_select(tsync_protos);
> > +     if (!proto)
> > +             return 0;
> > +#ifdef VSOCK
>
> Instead of this, perhaps we should not have this file get compiled if
> VSOCK is not defined?

I would recommend to isolate VSOCK defines inside the time synchronization code.
The caller might not be aware of time synchronization internal dependencies.
The current implementation relies on vsoks, but we may change this in
the future and
this should not affect the callers.

>
> -- Steve
>
>
> > +     fd = make_vsock(VMADDR_PORT_ANY);
> > +     if (fd < 0)
> > +             goto error;
> > +
> > +     ret = get_vsock_port(fd, tsync_port);
> > +     if (ret < 0)
> > +             goto error;
> > +#else
> > +     return 0;
> > +#endif
> > +
> > +     tsync = calloc(1, sizeof(struct tracecmd_time_sync));
> > +     tsync->msg_handle = tracecmd_msg_handle_alloc(fd, 0);
> > +     if (clock)
> > +             tsync->clock_str = strdup(clock);
> > +
> > +     pthread_attr_init(&attrib);
> > +     tsync->sync_proto = proto;
> > +     pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
> > +     if (!get_first_cpu(&pin_mask, &mask_size))
> > +             pthread_attr_setaffinity_np(&attrib, mask_size, pin_mask);
> > +
> > +     ret = pthread_create(thr_id, &attrib, tsync_agent_thread, tsync);
> > +
> > +     if (pin_mask)
> > +             CPU_FREE(pin_mask);
> > +     pthread_attr_destroy(&attrib);
> > +
> > +     if (ret)
> > +             goto error;
> > +
> > +     return proto;
> > +
> > +error:
> > +     if (tsync) {
> > +             if (tsync->msg_handle)
> > +                     tracecmd_msg_handle_close(tsync->msg_handle);
> > +             if (tsync->clock_str)
> > +                     free(tsync->clock_str);
> > +             free(tsync);
> > +     }
> > +     if (fd > 0)
> > +             close(fd);
> > +     return 0;
> > +}
> > diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
> > index 05ec021..9fa61e1 100644
> > --- a/tracecmd/trace-usage.c
> > +++ b/tracecmd/trace-usage.c
> > @@ -60,6 +60,10 @@ static struct usage_help usage_help[] = {
> >               "          --no-filter include trace-cmd threads in the trace\n"
> >               "          --proc-map save the traced processes address map into the trace.dat file\n"
> >               "          --user execute the specified [command ...] as given user\n"
> > +             "          --tsync-interval set the loop interval, in ms, for timestamps synchronization with guests:"
> > +             "               If a negative number is specified, timestamps synchronization is disabled"
> > +             "               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
> > +             "                                                         at the beginnig and at the end of the trace\n"
> >       },
> >       {
> >               "start",
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
