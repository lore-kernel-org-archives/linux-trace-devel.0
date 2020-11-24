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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E149DC2D0E4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 05:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79F412080A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 05:44:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nr2aHwRR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgKXFob (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Nov 2020 00:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgKXFoa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Nov 2020 00:44:30 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7726C0613CF
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Nov 2020 21:44:30 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id n137so7344327pfd.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Nov 2020 21:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rsbx91/LwlN2HD6UKICnLbIqHryLar5rMDqyYzROFGw=;
        b=nr2aHwRRx9FqdipDuQdVWJtr6X5Y4FesNBHuhuW/qREtIxd+wQdWTTc3Q4N7v7EJED
         yFperoIspl+DfREGtMHBR82xLQdU7Z+sLaFD7d25Aa3Etf+amSLMyKOIJ6eoJXDEmBRg
         4FWbzg0m9C0pVGep7QX+uBSZQ6OR97a8wYAUj2ICIItsa0YVymsy8STWJuPPF66Yy17P
         JaHPi7a+Reqcz9oDjzETpIjOijVB8kZuDu+8M8RRIaItBvPi9AfdRkmma0mr2esL6j83
         3EnJrVzreR3olYst50ACyFNZ/nU7KgA4kprSAQZOB6HfxjrrFNPd7ugSSrn8gS/PFHqG
         goKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rsbx91/LwlN2HD6UKICnLbIqHryLar5rMDqyYzROFGw=;
        b=IJbOu3iflVqOn34Lqv2aL5Wcy4jjG/xtbxvcIFkIvtUo3/BuCInLPvkDikKUyKxKXg
         QAftqcmQFs81algxOxZ9G7E72nZESGXQo8616yPqjYZ/c3ecvaSyWL3+OFkp/+rlVxOD
         og/UmAuNQGvvAudLcIsyk6Js/i2O2PLj0p15kH2r18nmpBjBYfIhVYCTitCMzVkY5Zng
         iFyWOoPz2vIydKopOKEFGPI5aDkRPHGmxBTksTec398piyVc9XH4pZ4QRMxKZPJ3nX/A
         t52fnhV40iixGc3/kG3a6jfZfxeriobCyUuFdfCMqwJTIpX/tDt1XEXTJmDEj1KaOkAa
         YPgw==
X-Gm-Message-State: AOAM531xBsO/a1Yg5hX7pcw4E1kjjqH4IBq8qq4VaC/suPZCNQmwm2P+
        DDp6En2LWmBd4HYbZ940o03pUaN8UV62enOjpgF7znDokClK7R4K
X-Google-Smtp-Source: ABdhPJyPzZ4JBt4zGT+EaqJNIDAqviXjv7wkrZE6pWtgnpDEk+4Ing3veUfe4Ud4iyE+ha5bvaMnTmV/j69vf8Vs6Cc=
X-Received: by 2002:a17:90a:aa0e:: with SMTP id k14mr3001812pjq.153.1606196670232;
 Mon, 23 Nov 2020 21:44:30 -0800 (PST)
MIME-Version: 1.0
References: <20201123153447.2e24c678@gandalf.local.home>
In-Reply-To: <20201123153447.2e24c678@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 24 Nov 2020 07:44:14 +0200
Message-ID: <CAPpZLN7W6KY_wUaGre1iTqx04cvuG90Nrbai+0MiZ17yafgrmw@mail.gmail.com>
Subject: Re: [PATCH] tracefs utils: Do not free a the buffer on a zero size str_read_file()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Nov 23, 2020 at 10:35 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> If a file has no size (nothing is read), then str_read_file() frees the
> buffer and returns zero. The problem is that all callers of str_read_file()
> uses the buffer supplied if the value returned is not a negative. This
> causes the freed buffer being used by the callers if the file read existed
> but had no content.
>
> This is apparent when using a copy of the tracefs directory, where some file
> exist, but have no content, then loading the events would cause a segfault.
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  tracefs-utils.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tracefs-utils.c b/tracefs-utils.c
> index 326b455..690506c 100644
> --- a/tracefs-utils.c
> +++ b/tracefs-utils.c
> @@ -220,7 +220,7 @@ __hidden int str_read_file(const char *file, char **buffer)
>         } while (r > 0);
>
>         close(fd);
> -       if (r == 0 && size > 0) {
> +       if (r == 0) {
>                 buf[size] = '\0';

If size is 0, in case of an empty file, then buf should also be NULL
and this assignment
will be on invalid memory.

>                 *buffer = buf;
>         } else
> --
> 2.25.4
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
