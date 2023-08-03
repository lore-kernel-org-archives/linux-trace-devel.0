Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5A47C41513
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Aug 2023 02:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbjHCCtu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 22:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbjHCCtt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 22:49:49 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9F81A7;
        Wed,  2 Aug 2023 19:49:48 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3fe2bc27029so5135715e9.3;
        Wed, 02 Aug 2023 19:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691030986; x=1691635786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gCPQBscIppb4GjnVbGcSI0bCg7csaBlCUm14FCMkX6c=;
        b=FjPyiE61ftWT6m4u4qkPYqpp9J2NcwS3bub1o+sxO4igem/83rXk7tEzvBXEiJnpr4
         epWWmV7ZaeUUy7Xf8De2/7ggieRxeBUGSkfJ+beM2/qQ/dXRBKW4JOrtktaf+yqKjDf/
         79rNCBYHEwshtA9GKnGKQpNL5vb9gTgB8LUW6KL+50qfULK1Y5oI8d6Iy4krdzu8VMZv
         ZPXYnynWoGVmzo7l2qQGVI9wVVhRRjYBFaJHC5pb059rIK7bkSAjUUeEqezv6PrXohTs
         Jsudh65n2ZCHJYLn0OsFGN9M4C8osNi/LmCdTN6nc14K+Xq/MFI2QkG3Ul6uz+m/zbeD
         dNQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691030986; x=1691635786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gCPQBscIppb4GjnVbGcSI0bCg7csaBlCUm14FCMkX6c=;
        b=Bmm5GzA68KSn71wTFIJ7XDhd9xG8HP9EFcktLhDMV/2WErcA7Yn0sIFLAN6sEynTYX
         6qtTTVL+Ajq75Bq1km8UrddN6npU634vz104A6MD8sNLZVWjxD6tkarXaFZ2lP1+mYa4
         ovfKH4rGxnFjC8MoFSFitg7KfJ7nkIHyzbm1IvgFjFc/AOen4FdDWMCwk8maHv2Vgp/2
         Tr/ofiGAwPUmjxGgq22F1YdRzQXhzP0oczH8Zg9MEBvAb/G1aO0WzHpfjs4U+PiGGv/m
         A6TJVm+w9GVhusipFOUqVSLt9rhoK0YBfZUGjl4j9HEacvaLtgJo6VTveJfcTNmEenFk
         hT4w==
X-Gm-Message-State: ABy/qLakRiKmLPvM+pDvV+wk9vTZZtMBPIwzcpcr2GwJsUmsJXsw0DN2
        GZ+DeycvnMO1YNvCTJgogUIO5JxG2TXx3ECOyBo=
X-Google-Smtp-Source: APBJJlEKCuZ55HVEdQWtOnyxHojOgwywxmC5gJVSWDn/Mtt/u5IvY5gFwYOmIg0wmkV5vcyCcAh0DFQDyneLvEtU4+U=
X-Received: by 2002:a05:6000:18c:b0:317:5cfb:714e with SMTP id
 p12-20020a056000018c00b003175cfb714emr6168249wrx.55.1691030986503; Wed, 02
 Aug 2023 19:49:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230802121116.324604-1-zegao@tencent.com> <20230802121116.324604-2-zegao@tencent.com>
 <20230802103630.45d95c06@gandalf.local.home> <CAD8CoPAPjuE5Ni2aTJcS5=M8TNOLqp3t4gfL=iWVrx39a25r2Q@mail.gmail.com>
 <20230802223718.6e34d3ff@gandalf.local.home>
In-Reply-To: <20230802223718.6e34d3ff@gandalf.local.home>
From:   Ze Gao <zegao2021@gmail.com>
Date:   Thu, 3 Aug 2023 10:49:35 +0800
Message-ID: <CAD8CoPA7xZm+HUwRTbwroeBqC1umH36pu8pZNRS5fuOk9=u+LA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 1/7] libtraceevent: sync state char array with the kernel
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org, Ze Gao <zegao@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Got it. Will send patches for libtraceevent separately, Combining
patches from 2 different trees annoys me as well ;)

Regards,
Ze

On Thu, Aug 3, 2023 at 10:37=E2=80=AFAM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Thu, 3 Aug 2023 10:13:16 +0800
> Ze Gao <zegao2021@gmail.com> wrote:
>
> > FYI, I=E2=80=98ve already cc-ed to it.  Do you mean I need to resend th=
is patch
> > to linux-trace-devel@vger.kernel.org solely and exclude this one from
> > this series?
> >
>
> I searched the Cc list and missed it. Anyway, you only need to Cc the
> patches that touch libtracevent, and not the rest. No biggy, I just have =
to
> mark them as "Handled elsewhere" in patchwork.
>
> -- Steve
