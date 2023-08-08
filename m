Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E312DC001B0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Aug 2023 19:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbjHHTwq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 15:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235989AbjHHTwa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 15:52:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CC516FD8F
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 11:18:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48CB6629C3
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 18:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A9CC433C8;
        Tue,  8 Aug 2023 18:18:18 +0000 (UTC)
Date:   Tue, 8 Aug 2023 14:18:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v3 3/6] histograms: Add traceeval compare
Message-ID: <20230808141816.38d8fade@gandalf.local.home>
In-Reply-To: <20230808161204.5704-4-stevie.6strings@gmail.com>
References: <20230808161204.5704-1-stevie.6strings@gmail.com>
        <20230808161204.5704-4-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  8 Aug 2023 12:11:56 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> 
> traceeval_compare() compares two struct traceeval instances for
> equality. This suite of comparitors was made for testing purposes.
> 
> Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> ---
>  include/traceeval-test.h |  16 +++
>  src/histograms.c         | 213 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 229 insertions(+)
>  create mode 100644 include/traceeval-test.h
> 
> diff --git a/include/traceeval-test.h b/include/traceeval-test.h
> new file mode 100644
> index 0000000..bb8092a
> --- /dev/null
> +++ b/include/traceeval-test.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * libtraceeval interface for unit testing.
> + *
> + * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
> + * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
> + */
> +
> +#ifndef __LIBTRACEEVAL_TEST_H__
> +#define __LIBTRACEEVAL_TEST_H__
> +
> +#include <traceeval-hist.h>
> +
> +int traceeval_compare(struct traceeval *orig, struct traceeval *copy);
> +
> +#endif /* __LIBTRACEEVAL_TEST_H__ */
> diff --git a/src/histograms.c b/src/histograms.c
> index b85d1a8..6fac205 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -11,6 +11,20 @@
>  #include <stdio.h>
>  
>  #include <traceeval-hist.h>
> +#include <traceeval-test.h>

Note, for anything that is not going to be installed in the system, I
prefer to use "" includes. It lets you know that it's local to the repo.

#include <traceeval-hist.h>

#include "traceeval-test.h"

-- Steve

> +
> +/*
> + * Compare two integers of variable length.
> + *
> + * Return 0 if @a and @b are the same, 1 if @a is greater than @b, and -1
> + * if @b is greater than @a.
> + */
> +#define compare_numbers_return(a, b)	\
> +do {					\
> +	if ((a) < (b))			\
> +		return -1;		\
> +	return (a) != (b);		\
> +} while (0)				\
>  
>  /* A key-value pair */
>  struct entry {
> @@ -48,6 +62,205 @@ static void print_err(const char *fmt, ...)
>  	fprintf(stderr, "\n");
>  }
>  
