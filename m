Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345B8C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 04:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC4F961106
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 04:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhDIEjo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 00:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhDIEjm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 00:39:42 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C88C061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 21:39:28 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id p10so2158410pld.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 21:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yCfTesDtAnoa6Ul6KeJl+jZgzLsXnc1oAxElab2qpFo=;
        b=MStITXmR5Us6rV/xDCcUcSIgGCHdsL2u6Uto0JSZVcIJjAjdwhoMAakMHd6K2ahvCZ
         L6nZVPcE1mVoOSeTG2wAGOFP6iuaPkdeH7bzPOwBh+apvLS4WiSjczWdzkL9+4jnnFG1
         tnGLCu3pSgSryP/t5HI8eT6KCLTRZG6Ylo1SAoMvEsqg7RyotoXhsFpMTXhVyk51CQUe
         0lcgkKGnDsOZCZSSfnFaGj1CKseBWMxJwuONKNcgEN76NAsXQDqHGQHUv3p4wSRaaUj+
         2xJ1P6+Ujo61/AUywFfGGX5dp1D3q0W7gAdaFhVdvonnmrQvK/snnff+zS6pdIaoWhFe
         Wl7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yCfTesDtAnoa6Ul6KeJl+jZgzLsXnc1oAxElab2qpFo=;
        b=Te8mRaw+YkQ7drY4xq6fN3XF0FI+dKqCRC/BAecYMJzqCQABTRMMuACRfnWOFoJZ1N
         ocvJ3S8Ei9kf5RGcMQyfcm/ZGd0hoK/wwC9xVBaltB5jeH4ldF05agooOFNbb4EyX74B
         CslaWOZAYIiv0Aqnbcm755xmhQFxfh1hPyg4hUf0xHl21EN/ffQm4ysNyB9k0dQPn6My
         YTEegW7E1o6/tcyXIWzfdULouuAyxaY2T5FtsWn1XUluBVgJKtg9yboGtEuxynANHDPK
         zfTBbXO2WIa1XsPHsd163+KIheqdSL/faJmLi59UNyZvaqYeC73J7SnPJRCrn4DUUQka
         BmNg==
X-Gm-Message-State: AOAM533/7a3BYkkNtR9PTdrym1USlTWR1WiHk6FGwi1YBbbFj2zaj6hv
        u/B52mzkZjGDAAAERBSW2OMlU+sMfJWuyzV7CF24h0bHwBg=
X-Google-Smtp-Source: ABdhPJyWHDj6Mz6WHLkWMQ29RCQfdhceu54PQaAWSY3lrGanmZNq5bx1p7hLPEJOAcIGHCRgn1McM25bHlV7PKHs6Ww=
X-Received: by 2002:a17:90b:1643:: with SMTP id il3mr12175765pjb.2.1617943167686;
 Thu, 08 Apr 2021 21:39:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210408140024.13093-1-y.karadz@gmail.com>
In-Reply-To: <20210408140024.13093-1-y.karadz@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 9 Apr 2021 07:39:11 +0300
Message-ID: <CAPpZLN4rnz38_7+GFSFKKi7Xj7MQ3ayiJMJWcLSbMzkhp9RcAQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] Refactor the APIs for tracing options
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 8, 2021 at 5:00 PM Yordan Karadzhov (VMware)
<y.karadz@gmail.com> wrote:
>
> Yordan Karadzhov (VMware) (5):
>   libtracefs: Fix issues with tracefs_option_id()
>   libtracefs: Modify the arguments of tracefs_option_is_set()
>   libtracefs: Encapsulate "struct tracefs_options_mask"
>   libtracefs: Option's bit masks to be owned by the instance
>   libtracefs: Rename tracefs_option_is_set()
>
>  Documentation/libtracefs-option-get.txt |  4 +-
>  include/tracefs-local.h                 | 12 ++++++
>  include/tracefs.h                       | 11 ++---
>  src/tracefs-instance.c                  | 15 +++++++
>  src/tracefs-tools.c                     | 57 +++++++++----------------
>  utest/tracefs-utest.c                   | 12 ++----
>  6 files changed, 56 insertions(+), 55 deletions(-)
>
> --
> 2.27.0
>
The man pages should be updated to reflect the changes in the APIs.

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
