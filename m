Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5CCBC04A6A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Aug 2023 20:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbjHHUhf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 16:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235220AbjHHUhU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 16:37:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E75E7F
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 13:05:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94ED062C14
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 20:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2ECC433C8;
        Tue,  8 Aug 2023 20:05:02 +0000 (UTC)
Date:   Tue, 8 Aug 2023 16:05:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v3 1/6] histograms: Initial histograms interface
Message-ID: <20230808160500.7fa99988@gandalf.local.home>
In-Reply-To: <20230808161204.5704-2-stevie.6strings@gmail.com>
References: <20230808161204.5704-1-stevie.6strings@gmail.com>
        <20230808161204.5704-2-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  8 Aug 2023 12:11:54 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> 
> Initial header file for libtraceeval's histogram API. The interface
> provides a simple way of aggregating trace data and reading through said
> data.
> 
> Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> ---
>  include/traceeval-hist.h | 130 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 130 insertions(+)
>  create mode 100644 include/traceeval-hist.h
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> new file mode 100644
> index 0000000..ebce94e
> --- /dev/null
> +++ b/include/traceeval-hist.h
> @@ -0,0 +1,130 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * libtraceeval histogram interface.
> + *
> + * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
> + * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
> + */
> +#ifndef __LIBTRACEEVAL_HIST_H__
> +#define __LIBTRACEEVAL_HIST_H__
> +
> +#include <stdlib.h>
> +#include <stddef.h>
> +#include <stdbool.h>
> +
> +/* Data definition interfaces */
> +
> +/* Field name/descriptor for number of hits */
> +#define TRACEEVAL_VAL_HITS ((const char *)(-1UL))
> +
> +/* Data type distinguishers */
> +enum traceeval_data_type {
> +	TRACEEVAL_TYPE_NONE,
> +	TRACEEVAL_TYPE_NUMBER_64,
> +	TRACEEVAL_TYPE_NUMBER_32,
> +	TRACEEVAL_TYPE_NUMBER_16,
> +	TRACEEVAL_TYPE_NUMBER_8,
> +	TRACEEVAL_TYPE_NUMBER,
> +	TRACEEVAL_TYPE_STRING,
> +	TRACEEVAL_TYPE_DYNAMIC
> +};
> +
> +/* Statistics specification flags */
> +enum traceeval_flags {
> +	TRACEEVAL_FL_SIGNED		= (1 << 0),
> +	TRACEEVAL_FL_TIMESTAMP		= (1 << 1),
> +};
> +
> +/*
> + * Trace data entry for a traceeval histogram
> + * Constitutes keys and values.
> + */
> +union traceeval_data {
> +	char				*string;
> +	struct traceeval_dynamic	*dyn_data;

I think the above should be:

	struct traceeval_dynamic	dyn_data;

and not a pointer. Otherwise it really does not give us any benefit having
it be anything but a pointer.

That is, keeping it a pointer is as useful as:

	void				*dyn_data;

Which is fine, but we need to do one or the other.

-- Steve


> +	unsigned long long		number_64;
> +	unsigned long			number;
> +	unsigned int			number_32;
> +	unsigned short			number_16;
> +	unsigned char			number_8;
> +};
> +
