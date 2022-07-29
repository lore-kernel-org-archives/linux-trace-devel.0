Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09AE9C00144
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Jul 2022 21:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbiG2VsY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Jul 2022 17:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiG2VsX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Jul 2022 17:48:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C932C8C170
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jul 2022 14:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659131300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xlmn+IdYGAV9IqkryXRWh7FD4iUE5rIUxH8ZE8rI28E=;
        b=Koa/G24zblgpwc0d/HrTdTv2ZZMI0nkLbKpniUqSqsmkvqrf9rCmOTSNajVbAcrOumZ/ua
        PhKsrkjWOwtdJ8xVQ+JM8aSYRUsw1AcFpVYy/CMplFUuV6ZLvTYNY9tbNM8YLHGKOQzAJX
        4RXuxw+xSAXdvPO3OzMm+bk8UQXJpqU=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-NlfSzHcvMlu2oWDl-HhYkg-1; Fri, 29 Jul 2022 17:48:19 -0400
X-MC-Unique: NlfSzHcvMlu2oWDl-HhYkg-1
Received: by mail-qt1-f199.google.com with SMTP id f18-20020ac84712000000b0031eed29015cso3626958qtp.20
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jul 2022 14:48:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=xlmn+IdYGAV9IqkryXRWh7FD4iUE5rIUxH8ZE8rI28E=;
        b=zS5DSvgMJ/L/GbsNyUNiGsQwQUo5sCs/wHTwRzQ4Ww0Rqnpc9LJ6r1qABB6nppMMUg
         Te4HP+ZRhMJl81NFJGsv4P56cDRuwnM6HBO0w3xDHj9BLtYJXpLSkifHaPNYtTuBSWe4
         bqgUHswLd//XayN1jiE/oPCQKhKNOznJdQEljUupjfVaXcxyZuED9i6WP+DKgeJsi70Y
         UhnMd9YXKwO+V2EX4IIgmONrMiij9sZLGdzWLgbTTqGwDkxk+fGC3Ern3Z9b8RTdx8no
         yNizydeNShMhEetr1gsjBEmGcDdFrhxaB6ry7GrutmWRBP8g5I2vfx3u+cPbsID81O9k
         ppOQ==
X-Gm-Message-State: AJIora8mDc03s6+VixbSgoPLs2s5YL3bXNgtKMfNT6w2EYAC+wtPaUqA
        SdDWkUWGTBCHUVBmE5AibG8YVF91c4lTBcNbsqhoEn80P5bgsU1jnQ/p3HDN65OCgB7xe5TbBci
        Ut0lskbzaCLccpYianhi0kNVPWNMTSIpPmnXQCUnPSsM+O4w=
X-Received: by 2002:a05:622a:4c7:b0:31f:dd6:93ca with SMTP id q7-20020a05622a04c700b0031f0dd693camr5172982qtx.526.1659131299064;
        Fri, 29 Jul 2022 14:48:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tkFxwyy4+3Hq3I5iSFkdzvojR23bn/uT1geLp6in53AHL9YD/f31LmJh/d7cg2+DJoSl7SHZINNAF3yChqC9I=
X-Received: by 2002:a05:622a:4c7:b0:31f:dd6:93ca with SMTP id
 q7-20020a05622a04c700b0031f0dd693camr5172970qtx.526.1659131298791; Fri, 29
 Jul 2022 14:48:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220729040116.175015-1-tz.stoyanov@gmail.com> <20220729165048.77f03fc7@rorschach.local.home>
In-Reply-To: <20220729165048.77f03fc7@rorschach.local.home>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Fri, 29 Jul 2022 17:48:08 -0400
Message-ID: <CAK-6q+g2q4drxRC=5075Oy2Qh2C1pszF9fC1gRi0O90JJ49YPw@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Do not use instance from trace context
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

On Fri, Jul 29, 2022 at 4:51 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 29 Jul 2022 07:01:16 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > When trace-cmd initiates a connection to a trace agent over the network,
> > the logic in connect_to_agent() function incorrectly uses the last
> > instance saved in the trace context, instead of the actual instance
> > which is passed as input argument. This works if the remote agent is
> > set last on the command line, but causes a problem if there is more than
> > one agent or if there is a local buffer after the agent on the command
> > line.
> >
> > Reported-by: Alexander Aring <aahringo@redhat.com>
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  tracecmd/trace-record.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index 2406489a..50039dad 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -3934,15 +3934,15 @@ static void connect_to_agent(struct common_record_context *ctx,
> >               use_fifos = nr_fifos > 0;
> >       }
> >
> > -     if (ctx->instance->result) {
> > +     if (instance->result) {
>
> Bah, I kept getting confused by when to use instance vs ctx->instance,
> and I guess I messed this one up.

I tested it and it seems to fix the problem..., so if it's not to late:

Tested-by: Alexander Aring <aahringo@redhat.com>

I am not sure what I should expect from the PTP time synchronization
over IP capable interfaces (it never worked for me) but I need to say
it is significantly slower than kvm time synchronization with vsock
and I am using only virtual interfaces. On the agents I get a couple
of:

CPU 1: 787 events lost
CPU 5: 3059 events lost
...

the result looks to me like garbage too, my lock states do not make
any sense...(maybe related due the events lost?)

However I think we should move this discussion to bugzilla?

- Alex

