Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C069C04A94
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 18:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbjHISxX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 14:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjHISxX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 14:53:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E1BE64
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 11:53:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 126956448E
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 18:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C9EC433C8;
        Wed,  9 Aug 2023 18:53:20 +0000 (UTC)
Date:   Wed, 9 Aug 2023 14:53:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v4 1/5] histograms: Initial histograms interface
Message-ID: <20230809145318.2184f24e@gandalf.local.home>
In-Reply-To: <20230809175340.3066-2-stevie.6strings@gmail.com>
References: <20230809175340.3066-1-stevie.6strings@gmail.com>
        <20230809175340.3066-2-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  9 Aug 2023 13:53:34 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

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
> +	TRACEEVAL_TYPE_NUMBER_8,
> +	TRACEEVAL_TYPE_NUMBER_16,
> +	TRACEEVAL_TYPE_NUMBER_32,
> +	TRACEEVAL_TYPE_NUMBER_64,
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
> + * struct traceeval_dynamic - Storage for dynamic traceeval_types
> + * @size: The size of the dynamic type
> + * @data: The pointer to the data of the dynamic type
> + */
> +struct traceeval_dynamic {
> +	void		*data;
> +	size_t		size;
> +};
> +
> +/*
> + * Trace data entry for a traceeval histogram
> + * Constitutes keys and values.
> + */
> +union traceeval_data {
> +	struct traceeval_dynamic	dyn_data;
> +	char				*string;
> +	unsigned long			number;
> +	unsigned long long		number_64;
> +	unsigned int			number_32;
> +	unsigned short			number_16;
> +	unsigned char			number_8;
> +};
> +
> +struct traceeval_type;
> +
> +/* struct traceeval_dynamic release function signature */
> +typedef void (*traceeval_dyn_release_fn)(struct traceeval_type *,
> +					 struct traceeval_dynamic);
> +
> +/* struct traceeval_dynamic compare function signature */
> +typedef int (*traceeval_dyn_cmp_fn)(struct traceeval_dynamic,
> +				    struct traceeval_dynamic,

Even though we converted the union to struct traceveal_dynamic and it's no
longer a pointer, we still need to pass a pointer to the compare functions.
Passing structures by value is slow, as it needs to make a local copy of
it, and compare functions are to be quick.

-- Steve

> +				    struct traceeval_type *);
> +
> +/*
> + * struct traceeval_type - Describes the type of a traceevent_data instance
> + * @type: The enum type that describes the traceeval_data
> + * @name: The string name of the traceeval_data
> + * @flags: flags to describe the traceeval_data
> + * @id: User specified identifier
> + * @dyn_release: For dynamic types called on release (ignored for other types)
> + * @dyn_cmp: A way to compare dynamic types (ignored for other types)
> + *
> + * The traceeval_type structure defines expectations for a corresponding
> + * traceeval_data instance for a traceeval histogram instance. Used to
> + * describe both keys and values.
> + *
> + * The @id field is an optional value in case the user has multiple struct
> + * traceeval_type instances with @type fields set to TRACEEVAL_TYPE_DYNAMIC,
> + * which each relate to distinct user defined struct traceeval_dynamic
> + * 'sub-types'.
> + *
> + * For flexibility, @dyn_cmp() and @dyn_release() take a struct
> + * traceeval_type instance. This allows the user to distinguish between
> + * different sub-types of struct traceeval_dynamic within a single
> + * callback function by examining the @id field. This is not a required
> + * approach, merely one that is accommodated.
> + *
> + * @dyn_cmp() is used to compare two struct traceeval_dynamic instances when a
> + * corresponding struct traceeval_type is reached with its type field set to
> + * TRACEEVAL_TYPE_DYNAMIC. It should return 0 on equality, 1 if the first
> + * argument is greater than the second, -1 for the other way around, and -2 on
> + * error.
> + *
> + * dyn_release() is used during traceeval_release() to release a union
> + * traceeval_data's struct traceeval_dynamic field when the corresponding
> + * traceeval_type type is set to TRACEEVAL_TYPE_DYNAMIC.
> + */
> +struct traceeval_type {
> +	char				*name;
> +	enum traceeval_data_type	type;
> +	size_t				flags;
> +	size_t				id;
> +	traceeval_dyn_release_fn	dyn_release;
> +	traceeval_dyn_cmp_fn		dyn_cmp;
> +};
> +
> +/* Statistics about a given entry element */
> +struct traceeval_stat {
> +	unsigned long long	max;
> +	unsigned long long	min;
> +	unsigned long long	total;
> +	unsigned long long	avg;
> +	unsigned long long	std;
> +};
> +
> +/* Iterator over aggregated data */
> +struct traceeval_iterator;
> +
> +struct traceeval;
> +
> +#endif /* __LIBTRACEEVAL_HIST_H__ */

