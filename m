Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F45DC433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 07:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1231961407
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 07:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhENH6D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 03:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbhENH6D (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 03:58:03 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30288C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 00:56:52 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id b13-20020a17090a8c8db029015cd97baea9so976671pjo.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 00:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XgM1wax9sd7whQvvXQmGp4EPdB9uyxeW5RrqU1HkQkA=;
        b=TIWU2KrDNEo9VIUmgB8qVzK8nKzU/2qO8aqklbNCGGFbskAe23Bref4hvHYHEIM+RF
         WU+dWCL51HR7UCx2fu+lU4jkBjTTWT/HmwP01RGeKe4SmrAAsMIF7SjAGiDPwo40yJ7X
         p8jH10e4s6E4bH/KGQd9Zx2rLIPPEaB0gpc8c7O6NOg/l7hZdOjBW+OmPSs+FJ3V/MBQ
         VQeu2rRRo+XSA60F/wNudwRHQ+bbuklu9+Ma7L/u5HF4/SN+1k0UkkEexZP4gOWc+9XL
         9ede2qqXV1ldImUm46Pp3a3KjaNNNzyZVZlZ58ZWbjp8b4DZP3bxoPoTTxVnPmLutJgK
         Uc/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XgM1wax9sd7whQvvXQmGp4EPdB9uyxeW5RrqU1HkQkA=;
        b=c0z7GCo1/wj3BQqdwX3ZhEoEk1uP/6CA9pQQddvARLf2BY5pyEl+0MLn5tS21Se+Jl
         FW3pWQ8/sG7iB9ipvo3Dhn3VhftuQ7ycisc6DVomRWLpJorfwtUcpSvulQD7Cb4fZH/L
         sHu7aAQ5sLGM8vbBcdoRaUHcaabOorvTtPSr/1cTFkOoGiCDNVDKiivSBzG+Z5mS0VNk
         1MPYdPIvO9xOQOUhlp0Iw8fMRcZIF5SKM3N9IJsEhwz+1Ny/52MOikC1DyFULl8wyCRX
         myn5qexcmHkoXVByk9Wyr6sxv146rahggBV28T4QJu+Tuemvn6yN6yUOwR/4SDi6VhGg
         rHiA==
X-Gm-Message-State: AOAM5315TPp6RFJvw6opODv1uSsWoCuJeCDL79jkJnSvKYUt7rzZijzJ
        YEp2PPR+dzlVwZ3QIXhQURbBXCCrfEsCoaANRH0=
X-Google-Smtp-Source: ABdhPJxg7GgRC5Hz1f9P3RhuuxMW1ZypavVzBswRZTEzU8K+9YUfuuzeGnUsFl2eKMZTIC0RcMciXCIcIjTu45q3mK8=
X-Received: by 2002:a17:90a:ff02:: with SMTP id ce2mr49989182pjb.100.1620979011733;
 Fri, 14 May 2021 00:56:51 -0700 (PDT)
MIME-Version: 1.0
References: <8c1d353e-05d5-d789-00a2-de94d705950e@redhat.com>
 <20210512095541.4dcfdb4d@gandalf.local.home> <f35477a7-c301-655e-940a-bcc6b38c44f0@redhat.com>
In-Reply-To: <f35477a7-c301-655e-940a-bcc6b38c44f0@redhat.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 14 May 2021 10:56:35 +0300
Message-ID: <CAPpZLN6x-SeP7FtkD1Oopa7fj-HLxj47SJi3ATkdvjcfyhunKw@mail.gmail.com>
Subject: Re: trace-cmd profile is not working
To:     Jerome Marchand <jmarchan@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Jerome,

On Wed, May 12, 2021 at 5:09 PM Jerome Marchand <jmarchan@redhat.com> wrote:
>
> On 12/05/2021 15:55, Steven Rostedt wrote:
> > On Wed, 12 May 2021 15:51:52 +0200
> > Jerome Marchand <jmarchan@redhat.com> wrote:
> >
> >> Hi,
> >>
> >> Streams, and thus trace-cmd profile, are not working. A simple
> >> "trace-cmd profile ls" command exit with the following message
> >> "Creating stream for 0". I've been looking at it and the issue is that
> >> tracecmd_read_headers() tries to read the cmdlines, cpus and options
> >> sections that have not been written to the temporary file when called
> >> from trace_stream_init().
> >>
> >> AFAICT, it is caused by the two following patches:
> >>
> >> commit 1eea02a4 ("trace-cmd: Write saved cmdlines in the trace file at
> >> the end of the trace.") which moved the writing of cmdlines from
> >> create_file_fd() to tracecmd_create_file_latency() and
> >> tracecmd_append_cpu_data()
> >>
> >> commit 5d4d7ec3 ("trace-cmd: Move reading of trace.dat options to
> >> tracecmd_read_headers()") which moved the reading of options and cpu
> >> datas to tracecmd_read_headers().
> >>
> >
> > Thanks for the report. I'm not surprised, profiling and streams have not
> > been given the love they deserve (been focusing on host/guest tracing
> > recently).
> >
> > Can you fill out a bug report on bugzilla?
>
> Sure thing:
> https://bugzilla.kernel.org/show_bug.cgi?id=213045
>
> Jerome
>
> >
> >    https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&list_id=1090417&product=Tools&resolution=---
> >
> > Thanks!
> >

I've submitted a fix for this, please can you verify if it fixes the problem.
Thanks for testing this code and reporting bugs!

> > -- Steve
> >
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
