Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 673E3C4361B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Dec 2020 15:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 388E52253A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Dec 2020 15:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729919AbgLOPed (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 10:34:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:35726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727879AbgLOPeY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 10:34:24 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DB3C224B8;
        Tue, 15 Dec 2020 15:33:43 +0000 (UTC)
Date:   Tue, 15 Dec 2020 10:33:41 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH] trace-cmd: Re-enable the build of KernelShark v1
Message-ID: <20201215103341.27ad0b69@gandalf.local.home>
In-Reply-To: <20201214193057.705624-1-y.karadz@gmail.com>
References: <20201214193057.705624-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


On Mon, 14 Dec 2020 21:30:57 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> diff --git a/kernel-shark/src/trace-filter-hash.h b/kernel-shark/src/trace-filter-hash.h
> new file mode 100644
> index 0000000..4111c41
> --- /dev/null
> +++ b/kernel-shark/src/trace-filter-hash.h

Hi Yordan,

So far the patch looks good, but can you not copy this file, and just
change cmake to find where it's located in the source tree?

  "lib/trace-cmd/include/private/trace-filter-hash.h"

Thanks!

-- Steve

> @@ -0,0 +1,64 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +/*
> + * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> + * Copyright (C) 2018 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
> + *
> + */
> +#ifndef _TRACE_FILTER_HASH_H
> +#define _TRACE_FILTER_HASH_H
> +
> +#include <stdint.h>
> +
> +struct tracecmd_filter_id_item {
> +	struct tracecmd_filter_id_item	*next;
> +	int				id;
> +};
> +
> +struct tracecmd_filter_id {
> +	struct tracecmd_filter_id_item **hash;
> +	int				count;
> +};
> +
> +/**
> + * tracecmd_quick_hash - A quick (non secured) hash alogirthm
> + * @val: The value to perform the hash on
> + * @bits: The size in bits you need to return
> + *
> + * This is a quick hashing function adapted from Donald E. Knuth's 32
> + * bit multiplicative hash.  See The Art of Computer Programming (TAOCP).
> + * Multiplication by the Prime number, closest to the golden ratio of
> + * 2^32.
> + *
> + * @bits is used to max the result for use cases that require
> + * a power of 2 return value that is less than 32 bits. Any value
> + * of @bits greater than 31 (or zero), will simply return the full hash on @val.
> + */
> +static inline uint32_t tracecmd_quick_hash(uint32_t val, unsigned int bits)
> +{
> +	val *= UINT32_C(2654435761);
> +
> +	if (!bits || bits > 31)
> +		return val;
> +
> +	return val & ((1 << bits) - 1);
> +}
> +
> +struct tracecmd_filter_id_item *
> +  tracecmd_filter_id_find(struct tracecmd_filter_id *hash, int id);
> +void tracecmd_filter_id_add(struct tracecmd_filter_id *hash, int id);
> +void tracecmd_filter_id_remove(struct tracecmd_filter_id *hash, int id);
> +void tracecmd_filter_id_clear(struct tracecmd_filter_id *hash);
> +struct tracecmd_filter_id *tracecmd_filter_id_hash_alloc(void);
> +void tracecmd_filter_id_hash_free(struct tracecmd_filter_id *hash);
> +struct tracecmd_filter_id *
> +  tracecmd_filter_id_hash_copy(struct tracecmd_filter_id *hash);
> +int *tracecmd_filter_ids(struct tracecmd_filter_id *hash);
> +int tracecmd_filter_id_compare(struct tracecmd_filter_id *hash1,
> +			       struct tracecmd_filter_id *hash2);
> +
> +static inline int tracecmd_filter_task_count(struct tracecmd_filter_id *hash)
> +{
> +	return hash->count;
> +}
> +
> +#endif /* _TRACE_FILTER_HASH_H */
> diff --git a/lib/traceevent/parse-utils.c b/lib/traceevent/parse-utils.c
> index 150cee8..62d2789 100644
> --- a/lib/traceevent/parse-utils.c
> +++ b/lib/traceevent/parse-utils.c
> @@ -9,8 +9,6 @@
>  #include <stdarg.h>
>  #include <errno.h>
>  
> -#include "event-utils.h"
> -
>  #define __weak __attribute__((weak))
>  
>  void __vwarning(const char *fmt, va_list ap)

