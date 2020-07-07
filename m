Return-Path: <SRS0=/1KP=AS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FAC7C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jul 2020 15:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30B5C2082F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jul 2020 15:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594134691;
	bh=PqU1iyClieuo239iU5loC0OdtGBXkNz5pdOKjsTYV3A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=sZ9tjls4P2plwU9W3tG0FTHH2NRxkLtof6ZRVqVW1CnIh6AfSoD6Ri3/tqUE8jvRp
	 LYC1tyPr8snqN+3NxlzOfYE4seYM4PwTiYgUozm8Jek3LmMsXkUj6P1bp9GGcA+hki
	 +kWqNAbmUi7swvgseJIjEJx3bG7meO1XrqOhdDCQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgGGPLY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jul 2020 11:11:24 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39732 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbgGGPLY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jul 2020 11:11:24 -0400
Received: by mail-wm1-f68.google.com with SMTP id w3so34447238wmi.4;
        Tue, 07 Jul 2020 08:11:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P5HQjNhCixCjoEKGC+mEwSigDVUlJKQtv6gsV/u680E=;
        b=orQoXrHBJ67jA8inU9zrJKp1jPrgB33p9/bbz8rE/Rp0iP/1QxTcFuj0a8zxMmZtTr
         StZYxb/6XTLaZvaV1J4cYf6Xi4AZaiG+uBLm4gusjF/aaRT/RUK2r24LJ7jeZFX6jBrz
         Kh0ySpjJgfLQevHtIGMs8drMNdOYeLtNgGPBCq4Kp/PJdoLxPUvZ0yx8FLCz4CJl22IB
         CpXsdgkyOmmh9/TyCnICdeFg7E1OwlKPM0GVs5equ01QQ32c6u7VbS1VvX5LWjGyWYdC
         EnUXRVmIoiiYUW/pSHl3m4iT5kVpcKOVJQ6Nbsstk5AqGyl7aT8b8pF/ERoDpMrLroa4
         JQ/w==
X-Gm-Message-State: AOAM532oOxYQgIDYEQS4GXFpAnHisR78jkzgsoazK8+BhOVwTfU0naIk
        ITYMuvF7VdVrfdDKPnBkZXiKTcjkwgU+NL5qY08=
X-Google-Smtp-Source: ABdhPJyQCGg9VpFaZNj2dsCnv1aNhRU0Me+z25bKOzZYWQuHvqUD1GvpUMhPeoP8ERgj++srxuOXiyeQkmBYw1KVhAI=
X-Received: by 2002:a05:600c:410f:: with SMTP id j15mr4610640wmi.128.1594134681738;
 Tue, 07 Jul 2020 08:11:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200702185344.913492689@goodmis.org> <20200702185704.559785000@goodmis.org>
In-Reply-To: <20200702185704.559785000@goodmis.org>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Wed, 8 Jul 2020 00:11:10 +0900
Message-ID: <CAM9d7cj1LJ=QO8QxhBo_oDM9APpAswX4BbTwge0JhZ3Y4-Bv9w@mail.gmail.com>
Subject: Re: [PATCH v2 07/15] tools lib traceevent: Optimize pretty_print() function
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Jul 3, 2020 at 3:57 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
>
> Each time the pretty_print() function is called to print an event,
> the event's format string is parsed. As this format string does not
> change, this parsing can be done only once - when the event struct
> is initialized.
>
> Link: https://lore.kernel.org/linux-trace-devel/20200529134929.537110-1-tz.stoyanov@gmail.com
> Link: http://lore.kernel.org/linux-trace-devel/20200625100516.365338-8-tz.stoyanov@gmail.com
>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  tools/lib/traceevent/event-parse-local.h |  17 +
>  tools/lib/traceevent/event-parse.c       | 672 ++++++++++++++++-------
>  tools/lib/traceevent/event-parse.h       |   3 +
>  3 files changed, 495 insertions(+), 197 deletions(-)
>
> diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
> index 96a0b0ca0675..e71296a62236 100644
> --- a/tools/lib/traceevent/event-parse-local.h
> +++ b/tools/lib/traceevent/event-parse-local.h
> @@ -85,6 +85,23 @@ struct tep_handle {
>         struct tep_plugins_dir *plugins_dir;
>  };
>
> +enum tep_print_parse_type {
> +       PRINT_FMT_STING,

STRING ?

> +       PRINT_FMT_ARG_DIGIT,
> +       PRINT_FMT_ARG_POINTER,
> +       PRINT_FMT_ARG_STRING,
> +};
