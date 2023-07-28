Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BBEEC41513
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jul 2023 17:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbjG1R3z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 13:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234185AbjG1R3p (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 13:29:45 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BF63A9B
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jul 2023 10:29:34 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-407db3e9669so13081cf.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jul 2023 10:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690565373; x=1691170173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RFPU8SbvYweWy/0B9ZVn/iGNrEhN7Hrca5mOWZOVSiU=;
        b=nEit5NaFSV+d69VnhyIMyDi7ZFOro3SqVLWfk35Rsp2LrpqqOYa11gQbZ1dGhFYZjO
         Afh6VozNEL0ks6qP/Uq8h5Dbc5eJaKnFb2AZhHCKwngdd7KYq+MJkjoFkeFaaGBiJX3H
         4EjbTVeBBlsTq62ugO4uQCYA3Tr7JW7a8emgyx9YqxPfgmqlbfNcj2KNfflSsUMRgYkL
         yENQ2Re/UG/e1i7YlvnWuUuGrDiAmxZGLGbv0tHqm/CWX8cbI016jCyDNP49GxfIfG35
         3x2v1Aq4lLl1ktCUyWnf4NS43oOYW4M4IkVzX91LeYkdN9cWDWMbMsPeOhMqiyHVICPr
         iDIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690565373; x=1691170173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RFPU8SbvYweWy/0B9ZVn/iGNrEhN7Hrca5mOWZOVSiU=;
        b=f+DvVodaRkE69tWVnd5YTxOruPHrL/UcYWTjOE4EY5iYp/tWkJYjEYRohT7OwqpLnb
         g3P1mtmc6pAnMLtkk1YRxOdn46KQ/+h3zhKEW7K9T95scVUY76enhQIX5+rG0tO2qKuS
         Xc4/c5xUsAo/w20yKmZvkiEiHnDW6GTwM1NmaRWvIKZDadxL+ISrHW5zPTWz/pc66RyN
         VTrYv8endNKxebYxJwFHShJgLoVvtxo4KHm2clnSVxp0qeW41fi34x+QKwUviyhIVSyj
         pefFehgAmsPBrhVHrD7zUwLlKpo6F1inLlwpeE4yoLJwbYrg4eBS5EzuSHu1gONEj0VW
         1+zw==
X-Gm-Message-State: ABy/qLaG8QEt8kmQIJ05/gXn2BLo/LfUfOtbGAzKb3HOcb2Ng8Rworh7
        Izp8MWjTfJWPfJMCwpwUJud+IvuCKZT/L/Y/z+YJwRTeX1zuXMjKzeOwVA==
X-Google-Smtp-Source: APBJJlG3vkdSXwaK+QDwCWAi4fCSKVsG1lcjeI6l+A0NqIBc3JZ3ilJG1lR+n3Zlckmgqy8iCgjf90vwAh2UPBOumC4=
X-Received: by 2002:a05:622a:1301:b0:403:dcd4:b9b1 with SMTP id
 v1-20020a05622a130100b00403dcd4b9b1mr7450qtk.18.1690565373022; Fri, 28 Jul
 2023 10:29:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230726121618.19198-1-zegao@tencent.com>
In-Reply-To: <20230726121618.19198-1-zegao@tencent.com>
From:   Ian Rogers <irogers@google.com>
Date:   Fri, 28 Jul 2023 10:29:21 -0700
Message-ID: <CAP-5=fVJ_RL9Md92R4nWBKvZcF9iovL07-=dJ7bqN3LWwufVGw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/3] report task state in symbolic chars from sched tracepoint
To:     Ze Gao <zegao2021@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org, Ze Gao <zegao@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jul 26, 2023 at 5:16=E2=80=AFAM Ze Gao <zegao2021@gmail.com> wrote:
>
>
> This is the 2nd attempt to fix the report task state issue in sched
> tracepint, here is the first version:
>
> https://lore.kernel.org/linux-trace-kernel/20230725072254.32045-1-zegao@t=
encent.com
>
> Against v1, add a new var to report task state in symbolic char instead
> of replacing the old one and to not to break anything.
>
> --
>
> In the status quo, we should see three different outcomes of the reported
> sched-out task state from perf-script, perf-sched-timehist, and Tp_printk
> of tracepoint sched_switch.  And it's not hard to figure out that the
> former two are built upon the third one, and the reason why we see this
> inconsistency is that the former two does not catch up with the internal
> change of reported task state definitions as the kernel evolves.
>
> IMHO, exporting internal representations of task state in the tracepoint
> sched_switch is not a good practice and not encouraged at all, which can
> easily break userspace tools that relies on it. Especially when tracepoin=
ts
> are massively used in many observability tools nowadays due to its stable
> nature, which makes them no longer used for debug only purpose and we
> should be careful to decide what ought to be reported to userspace and wh=
at
> ought not.
>
> Therefore, to fix the issues mentioned above for good, instead of choosin=
g
> I proposed to add a new variable to report task state in sched_switch wit=
h
> a symbolic character along with the old hardcoded value, and save the
> further processing of userspace tools and spare them from knowing
> implementation details in the kernel.
>
> After this patch seires, we report 'RSDTtXZPI' the same as in procfs, plu=
s
> a 'p' which denotes PREEMP_ACTIVE and is used for sched_switch tracepoint=
 only.
>
> Reviews welcome!

Thanks Ze,

I think this is worthwhile cleanup and makes the code overall simpler.
I don't know if others have strong opinions, I don't often work in
this code, but I think the patches are worth landing this.

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> Regards,
>
> Ze
>
> Ze Gao (2):
>   sched, tracing: add to report task state in symbolic chars
>   perf sched: use the new prev_state_char instead in tracepoint
>     sched_switch
>
>  include/trace/events/sched.h | 60 +++++++++++++++++++++---------------
>  tools/perf/builtin-sched.c   | 57 ++++++----------------------------
>  2 files changed, 45 insertions(+), 72 deletions(-)
>
> Ze Gao (1):
>   libtraceevent: use the new prev_state_char instead in tracepoint
>     sched_switch
>
>  plugins/plugin_sched_switch.c | 29 ++++-------------------------
>  1 file changed, 4 insertions(+), 25 deletions(-)
>
> --
> 2.40.1
>
