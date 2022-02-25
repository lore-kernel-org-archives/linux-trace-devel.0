Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2CE6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Feb 2022 10:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiBYKWM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Feb 2022 05:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbiBYKWL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Feb 2022 05:22:11 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355D11CB08
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Feb 2022 02:21:39 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id y11so4293818pfa.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Feb 2022 02:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d14ErEgh9/870sV3mAdZVso/O7Fpxk93F5kOYyiJ+CY=;
        b=B95OSU4QmIRGh2k7ULdQlKxQqt5f/3IWYOFG8Upd/sNPC34JTkKwHusJeZRPxCK3te
         uR+hAlcJ0o9evYMEYVHTrLRJrmyBKqQz16rY4d5BdI5q7X4+0C9VavrwmqrZedC+UXc8
         Mb44B3zEt0jrKaHIqTUc/SU67OWu++XEd+rIv8DXw7Ds5f+aVSa3SMXte3yqXhWHisH7
         FkZMPRiNbTs039Zx/ZTT+jkDrh+lMXIeot2ggvUWM04DkgV3qhHBp5we79oANQNTouL9
         TsCWJx7PbO3PKOJ/Gqmx0t6iB+sQYKML/QzJLTgtR24nSR8bssCvn7g7D5CYCtLgpTtI
         shSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d14ErEgh9/870sV3mAdZVso/O7Fpxk93F5kOYyiJ+CY=;
        b=UMW+M+U3R81FSN9Ju2GX9CEOh8fLrLYVpP/LgMfv4wUgGGeTrmtYU2C8LWocQIzp6J
         UVGv/1hmybndau5aZkiKvWxpdLvGQ/M0SfKxzlepZuL709xQDE/fJ6rnuJkabMtXInxo
         43DIU0AVM8MW4x8pnEmNal3DK5tJTdPvf8Y1Sv11tN6tdQQ2R1I2UBb2DASDYEyKNeLr
         pOx4Bhpt+rwBE8p2A3P+k+3CWL1F9nB8pEfK2+90Oa9VQKMNn+aLE7ftMYBEoptgoNMw
         nrMOfT388uu3lue5T4FEsODLDgXglduIcxQGUj0Io7YBqeC3iX4D5wQSysUBBfvtoFHz
         qWgQ==
X-Gm-Message-State: AOAM5320e1Yhx1WG3dIgiwWlJRjAW0b0JRhMR7Ztmr57ehx8lWCJY3B0
        M2axCCEXfs5XUcMxy8E/D9rSsJ1Ke0ZpLXRBpf8ShB8Q7ts=
X-Google-Smtp-Source: ABdhPJx+7FY0pm3YoRzE2o6i2w/QBvCsUWvJm6DzAFQLrGVNJkFYR2U58NmWpE8wtTWitj1QhSo2kINKXPAzHpTKx/0=
X-Received: by 2002:a63:4c55:0:b0:36c:54eb:fc44 with SMTP id
 m21-20020a634c55000000b0036c54ebfc44mr5500397pgl.323.1645784498651; Fri, 25
 Feb 2022 02:21:38 -0800 (PST)
MIME-Version: 1.0
References: <20220224163711.185308-1-tz.stoyanov@gmail.com> <CAP-5=fVsQ2kGTvCDmovLWR00SDKQz635ftVmLphZcMM82sGKHA@mail.gmail.com>
In-Reply-To: <CAP-5=fVsQ2kGTvCDmovLWR00SDKQz635ftVmLphZcMM82sGKHA@mail.gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 25 Feb 2022 12:21:22 +0200
Message-ID: <CAPpZLN4RoEjhKJb+d2UB3cnJfuNzdSiu4dV8RZe=aCBUaBxWog@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] trace-cruncher: Initial support for perf
To:     Ian Rogers <irogers@google.com>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 24, 2022 at 6:53 PM Ian Rogers <irogers@google.com> wrote:
>
> On Thu, Feb 24, 2022 at 8:37 AM Tzvetomir Stoyanov (VMware)
> <tz.stoyanov@gmail.com> wrote:
> >
> > Two major functionalities are introduced by this patch set:
> >  - VMA <-> function name resolving, using bfd library.
>
> Just wanted to point out that perf is often not built against libbfd:
> Please build perf against libbfd -
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=911815
>
> where long running addr2line is now the best performance solution:
> https://lore.kernel.org/linux-perf-users/20210909112202.1947499-1-tonyg@leastfixedpoint.com/
>
> The comment from the bug:
> perf can link against libbfd if available, but the result is
> undistributable as they are licenced under GPL v2 and v3+
> respectively.
>

Hi Ian, thank you for this note. Trace-cruncher is a library licensed
under LGPLv2.1, so it should not be a problem to use libbfd. Is my
understanding correct, as I'm not an expert in all these licences ?

> Thanks,
> Ian
>
> >  - Support for Linux kernel perf framework, using perf library.
> >
> > This is still a work in progress. Depends on this patch, not yet merged:
> > https://lore.kernel.org/linux-perf-users/20220221102628.43904-1-tz.stoyanov@gmail.com/
> >
> > Tzvetomir Stoyanov (VMware) (3):
> >   trace-cruncher: Logic for resolving address to function name
> >   trace-cruncher: Support for perf
> >   trace-cruncher: perf example
> >
> >  examples/perf_sampling.py |  51 +++
> >  setup.py                  |   9 +-
> >  src/perfpy-utils.c        | 699 ++++++++++++++++++++++++++++++
> >  src/perfpy-utils.h        |  41 ++
> >  src/perfpy.c              | 141 ++++++
> >  src/trace-obj-debug.c     | 873 ++++++++++++++++++++++++++++++++++++++
> >  src/trace-obj-debug.h     |  52 +++
> >  7 files changed, 1865 insertions(+), 1 deletion(-)
> >  create mode 100755 examples/perf_sampling.py
> >  create mode 100644 src/perfpy-utils.c
> >  create mode 100644 src/perfpy-utils.h
> >  create mode 100644 src/perfpy.c
> >  create mode 100644 src/trace-obj-debug.c
> >  create mode 100644 src/trace-obj-debug.h
> >
> > --
> > 2.34.1
> >



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
