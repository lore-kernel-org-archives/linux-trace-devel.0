Return-Path: <SRS0=NxYB=W6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53938C3A5A2
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Sep 2019 12:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 235662087E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Sep 2019 12:24:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t/n/aW8g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfICMYO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Sep 2019 08:24:14 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36104 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfICMYO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Sep 2019 08:24:14 -0400
Received: by mail-pl1-f193.google.com with SMTP id f19so7822021plr.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Sep 2019 05:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qg65HF4+dGo9LUZVUYWgPdITr1w4ODFdKON+mMiSXtA=;
        b=t/n/aW8gtt/J3M9YnD+mek8miQ+0xFyuqv664dRavs9jibz1fI/pe3rycCca7Uz0MZ
         fO9gwp2KR3YMC/bRWRAxkMEgWJ0T4SH2Q+oQX6oJpiviMEjMlNQQbi8BgTMOYo1/ofYC
         MmoFa+R5XTq8VZspze5GHiQBuKocoxamV3w+4jVn0da220ye+kXCWu5zaulEKD4WIPdj
         Gj/kr50On5RPMoNxweo1hOM6fkfEZdh2UBjj4c9OIYx0Ol2f+r7kWd3rGcDWFkgD9aqn
         DbvfyvvCY105Y6EC6EUteINJFKi0Ea+cG1b01PzLV1w7ErTPH+MaH3Xylg86Mu3VRw/s
         t1+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qg65HF4+dGo9LUZVUYWgPdITr1w4ODFdKON+mMiSXtA=;
        b=rNqGrkKoGf0ahw/uSJpV2FkwqYrpIGFogGnQZDbUCJVAL89GHtLUrVFRSX1Fn5kH54
         RQpslJxwfxAlxYvCInaPMPOgp1zF2fRAT+DFZt1uGdcMi63CKy/9oNJT7hNwCZfIxbca
         pCsTFuFHb1fIuZ4wTGp+PB49FXKokb/PDRLGonicRRXlBa7YNHUVIdYpxnoEHk0rBAuk
         PI/fWBvi49mHoo77dRanRPJCsrWguA1fSBNEm4H2AthjWJjmDFH7X6Dp67UG1Q0/ejGS
         b7T2r2NdWH6Nw6x49vlCvtC+dthftrN5HK8P2UoXwmFZwrPFdvj30xuA1ONN/04HwhYX
         GrXw==
X-Gm-Message-State: APjAAAVd0+qG3ZuUX89Sh1nbSVvVTuUO9juwoauPVYhiZHk9I4ziAGNZ
        4N49kdPCbdhGngeSIPEqbGY+xxhB09b8EY6M+xvQQqba
X-Google-Smtp-Source: APXvYqwL8WAzRRfdAxpRK9CrdTHbSprmP1u5Kk/m2WzyzDxqJRowdGvv7nVXeY7VMZUOTUVw9Vqfair/NUvnp1kkimE=
X-Received: by 2002:a17:902:9b8f:: with SMTP id y15mr36693684plp.194.1567513453910;
 Tue, 03 Sep 2019 05:24:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190814084712.28188-1-tz.stoyanov@gmail.com> <20190814084712.28188-9-tz.stoyanov@gmail.com>
 <20190828162140.38dd0880@gandalf.local.home>
In-Reply-To: <20190828162140.38dd0880@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 3 Sep 2019 15:24:02 +0300
Message-ID: <CAPpZLN6N0HiBkXsP8CEJp78ZcvVFJRX6mEkrJf1ta-8kVfvCBw@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] trace-cmd: Move tracecmd_stack_tracer_status()
 function to libtracecmd
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On Wed, Aug 28, 2019 at 11:21 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
...
> > +/**
> > + * tracecmd_stack_tracer_status - Check stack trace status
> > + * @status: Returned stack trace status:
> > + *           0 - not configured, disabled
> > + *           non 0 - enabled
> > + *
> > + * Returns -1 in case of an error, 0 if file does not exist
> > + *  (stack tracer not enabled) or 1 on successful completion.
>
>   "(stack tracer not configured in kernel)"
>
> Saying "enabled" is ambiguous.
>
> > + */
> > +int tracecmd_stack_tracer_status(int *status)
>
> If we are making this a library function, shouldn't it be declared in
> the trace-cmd.h file?
>

It is already part of trace-cmd.h, that was one of the problems - it was defined
as library API, but implemented in the trace-cmd application. This patch moves
the implementation in the library, the declaration in trace-cmd.h
remains the same.

> -- Steve

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
