Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C13C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 04:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88F2423A34
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 04:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731578AbhAOEz4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Jan 2021 23:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbhAOEzz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Jan 2021 23:55:55 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77590C061575
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 20:55:15 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id w1so5653645pjc.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 20:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WZL+WKYJXQnW1F7SZwVSQJccmXsc7Gdb0PHhvHsMukQ=;
        b=Urdn1YvG1xSPr6f53omgf8IH0hhIDv+hvxMy8v333L3s+tEw8Ok9+DrMheLdKHSreA
         YrnLsSleswUF+fkDB2qRzNABi6L7gmamQE1weN7MQc/RF5iPLo5eV3DoQiwghYVC1Tmz
         Fnta2rKGTzMSgXXNSzIxRiYsn3ly5HBtqBIBBw4ROAwbu7Lj3dw6ctzYFvihPrTx0sUF
         EvQDgE75fw/axmEum3PYQSOlHI+epZsF5zdQFsivoVBtnC+I2LzlRgBUDdUPpa98wusC
         EHaOpJpGLE/g3xcVR60Y3huBf5SwcL/+d28fClxKbb2AG2qDo47l/IMryveJF7ztdGUk
         MfqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WZL+WKYJXQnW1F7SZwVSQJccmXsc7Gdb0PHhvHsMukQ=;
        b=kJ+lRWwAoamVkOwLhhesZGVg6p/20l31AagyVnd/a5Cwfsm3n9vTFxczenFkzqsmkZ
         qMRkf8xq/NZDqOpzcEqISgCgBbnX0hoFbFbLwjxAw3hUgmvfw88FujuZnQBTe6YxGdqH
         N+sX3R57R7fdCfzFwzKBjoBR/0DPmp0NXeMhNOnVRn4LsKKtC4D9IUe5dxs0U01O2hiF
         Adj6rO4FTYExAxKBnHTXZ9340OAFS5MJGvB155YTaKs074iKxf/tKdvbwqRo2zfCLqGK
         S5queckBMcCMxfwjBDiFxONZ7tc7dIAj5s3E5hHfoH7xs9mlpT7xjt+n/eYncQnYQ3Mt
         jtFA==
X-Gm-Message-State: AOAM530z2l8S6F+bLgVBfQ008cxfxSWmjkl7CYt0FvifHcyE3GLG8dVR
        eKEwpt3DQcTtKyPsTd3x2zp+0P8zUrkWl1YhNH1kFZJj+vXKMnYK
X-Google-Smtp-Source: ABdhPJwmZ2T/84BDa4MhBu8iECR9lujIiVd82B1ThEnr1um75tzJ+O7ZUNo5Rg33Vy1CiQ+CnrErBKpFR1PgTATj8wA=
X-Received: by 2002:a17:90a:6589:: with SMTP id k9mr8540020pjj.100.1610686514910;
 Thu, 14 Jan 2021 20:55:14 -0800 (PST)
MIME-Version: 1.0
References: <20200409132825.79475-1-tz.stoyanov@gmail.com> <20200409132825.79475-3-tz.stoyanov@gmail.com>
 <20210113170110.261ae555@gandalf.local.home>
In-Reply-To: <20210113170110.261ae555@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 15 Jan 2021 06:54:57 +0200
Message-ID: <CAPpZLN7CdnFytdo9E6C_=2w5cqBCpLwqgoA7dGmcmGUeynA9mw@mail.gmail.com>
Subject: Re: [PATCH 2/2] trace-cmd: Add new API tracecmd_open_head()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Jan 14, 2021 at 12:01 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu,  9 Apr 2020 16:28:25 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Add an API to create a tracecmd_handle from a file,
> > read and parse only the trace headers from the file.
> > This allows to implement opening a trace file on
> > stages - reading the trace headers and reading the trace data.
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  include/trace-cmd/trace-cmd.h |  1 +
> >  lib/trace-cmd/trace-input.c   | 28 ++++++++++++++++++++++++++++
> >  2 files changed, 29 insertions(+)
> >
> > diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> > index 3f96bbde..e22aa251 100644
> > --- a/include/trace-cmd/trace-cmd.h
> > +++ b/include/trace-cmd/trace-cmd.h
> > @@ -143,6 +143,7 @@ typedef void (*tracecmd_handle_init_func)(struct tracecmd_input *handle,
> >  struct tracecmd_input *tracecmd_alloc(const char *file);
> >  struct tracecmd_input *tracecmd_alloc_fd(int fd);
> >  struct tracecmd_input *tracecmd_open(const char *file);
> > +struct tracecmd_input *tracecmd_open_head(const char *file);
> >  struct tracecmd_input *tracecmd_open_fd(int fd);
> >  void tracecmd_ref(struct tracecmd_input *handle);
> >  void tracecmd_close(struct tracecmd_input *handle);
>
> Hi Tzvetomir,
>
> I was thinking, before we release libtracecmd, we should add
> tracecmd_open() and tracecmd_open_fd() to the library. Just because I find
> that tracecmd_open_head() is a awkward name to have alone and only makes
> sense if there's already a tracecmd_open(). It will also help with
> differentiating the different functions.

I'll add tracecmd_open() and tracecmd_open_fd() as APIs. The reason
why tracecmd_open_head()
is used by KernelShark is that tracecmd_open() reads headers + tracing
data and calculates the
timestamps. Thus makes it hard to open multiple tracing files from a
single trace session and adjust
timestamps to be in a same time space. The current KernelShark open flow is:
 - Open a trace file and parse only the headers with tracecmd_open_head()
 - Based on the metadata information from the headers, check if there
is already an opened file from
  the same tracing session. If such is found, pair both files with
tracecmd_pair_peer(), before reading
  the tracing data.
 - Read the tracing data from the file with tracecmd_init_data(). This
will adjust timestamps accordingly,
   if there is a paired peer to the file.

We can rename tracecmd_open_head() to something else, or redesign the
whole flow of opening trace files

>
> I know we were going to only have functions that kernelshark uses, but that
> may be a little too limiting.
>
> Thanks!
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
