Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23289C5519F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 22:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72CCD246E2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 22:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgKRWR2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 17:17:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:43570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgKRWR1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 17:17:27 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19404246DE;
        Wed, 18 Nov 2020 22:17:26 +0000 (UTC)
Date:   Wed, 18 Nov 2020 17:17:22 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 06/20] kernel-shark: Add basic methods for Data
 streams
Message-ID: <20201118171722.3b305816@oasis.local.home>
In-Reply-To: <20201118145003.156542-7-y.karadz@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
        <20201118145003.156542-7-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 18 Nov 2020 16:49:49 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> +/**
> + * Bit mask (16-63) used when converting indexes to pointers and vise-versa.
> + */
> +#define INVALID_STREAM_MASK	(~((uint64_t) INDEX_MASK))

This wont work on a 32 bit machine, as pointers are 32 bits not 64.

> +
> +static int index_from_ptr(void *ptr)
> +{
> +	unsigned long index = (unsigned long) ptr;
> +
> +	return (int) (index & INDEX_MASK);
> +}
> +
> +static void *index_to_ptr(unsigned int index)
> +{
> +	unsigned long p;
> +
> +	p = INVALID_STREAM_MASK | index;
> +
> +	return (void *) p;
> +}
> +
> +static bool kshark_is_valid_stream(void *ptr)
> +{
> +	unsigned long p = (unsigned long) ptr;
> +	bool v = !((p & ~INDEX_MASK) == INVALID_STREAM_MASK);

On 32 bit, the above will always fail, because unsigned long is 32
bits (as is void *), but INVALID_STREAM_MASK is 64 bits. And the two
could never equal each other.

-- Steve


> +
> +	return p && v;
> +}
> +
