Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68219C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Sep 2021 21:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FFCA6109F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Sep 2021 21:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhI0VTw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 27 Sep 2021 17:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237197AbhI0VTw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Sep 2021 17:19:52 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30678C061575
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Sep 2021 14:18:14 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id h129so24708958iof.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Sep 2021 14:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=rVv/3GReQn35RZoEUqNOAF+r1sUo2/rCtiSSpgk9wdU=;
        b=pLaulUQRFyKSKPgb5n+hMoDpPz0WVG06ZCm0U3xloSSGMilPPWiZ1/IE3Zyvaxfe5B
         qSNuR4Wj6KDK9K21PPrOlGeZfg3dZKFWyx4HHWV168HPL5vaQ6O9kPQuh1n2pXjECpzh
         sgAog2DJwugxfXY0KYrtrq4e2MnRwjkInNK0gVdIyBPEmDpIso+MO781tGftaduFHb2z
         Z9NJhW191LJo40sK/EKIV4yX4O9pySoz+zZm9Id2CnXug+Dcy03u1aDgjcktR1MuhRa1
         15IuaMUb0C6iHExqS6d4rRlMuzoX411x0sN9BvHtIbq8wLamP3+zziRLWizPP4DMEUV2
         +LSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=rVv/3GReQn35RZoEUqNOAF+r1sUo2/rCtiSSpgk9wdU=;
        b=GTcYJiK48sgjMATsFjXD0AZRQU+H6nrNzt2YvoZy2V6E+c5GdFvPjudvyGENjA95sW
         Dfm7rJ6ddk3IncU9tYilUEWIZd6MKohpO2qdCdbUAoBfd9t/y0nqTWbW55T1epigWl31
         vO+Ai2IzThXaWhPfc4FyjldjKD9yXfXpfULNuK4uuW64ASwpEdOPDXG2U2Ygg/Q8O0EJ
         WMPtn2IbSFjbN/8ARGPrhjNWmBLQMDn+I5T1Fo7T4DFFLQlcR47+ARfTzespT95WdPl0
         d+CcosJ+2myXmP1YTzbdGRHeu1c3DPwMZFAhgz87L9jXRkYEFdev+KkGK2vGD0wJoCak
         ijRg==
X-Gm-Message-State: AOAM530Pw7nFpYlA52zrCfYZJlrYJh/BB1TkztNaGqyC0Jdte9SCib+V
        3lRoPvd24V7AVmGXBff8WPeSnKag3S7oQ3iJp5yfQ8xpqKE=
X-Google-Smtp-Source: ABdhPJyF7378f57ovBMQEW1au/nFE59aB+98qS2o1+drWpA1g3uuPBFMDpIcXAKlHfXnLS7CYkZV7zIpSPJDcD1ETkc=
X-Received: by 2002:a5e:db0c:: with SMTP id q12mr1355993iop.32.1632777492980;
 Mon, 27 Sep 2021 14:18:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210920183715.33377-1-irogers@google.com>
In-Reply-To: <20210920183715.33377-1-irogers@google.com>
From:   Ian Rogers <irogers@google.com>
Date:   Mon, 27 Sep 2021 14:17:58 -0700
Message-ID: <CAP-5=fXsCqgKBPQxhJZ6a8QMk4Tw7TnQ4M_c=qfktqRaoMpMXw@mail.gmail.com>
Subject: Re: [PATCH] libtraceevent: Fix for print_field
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Sep 20, 2021 at 11:37 AM Ian Rogers <irogers@google.com> wrote:
>
> Correct a typo in an operator which resolves a clang warning:
>
> src/event-parse.c:5408:41: error: converting the enum constant to a boolean [-Werror,-Wint-in-bool-context]
>         if (field->flags & (TEP_FIELD_IS_ARRAY || TEP_FIELD_IS_STRING))
>                                                ^
> Signed-off-by: Ian Rogers <irogers@google.com>

Ping. Thanks,
Ian

> ---
>  src/event-parse.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/src/event-parse.c b/src/event-parse.c
> index 8057fb5..7063758 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -5405,7 +5405,7 @@ void static inline print_field(struct trace_seq *s, void *data,
>         if (!parse || event->flags & TEP_EVENT_FL_FAILED)
>                 goto out;
>
> -       if (field->flags & (TEP_FIELD_IS_ARRAY || TEP_FIELD_IS_STRING))
> +       if (field->flags & (TEP_FIELD_IS_ARRAY | TEP_FIELD_IS_STRING))
>                 goto out;
>
>         start_parse = parse;
> --
> 2.33.0.464.g1972c5931b-goog
>
