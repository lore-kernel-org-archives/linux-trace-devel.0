Return-Path: <SRS0=r7Bw=DN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9DE8C4363D
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Oct 2020 21:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77EC0208B8
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Oct 2020 21:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbgJFVCZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Oct 2020 17:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727305AbgJFVCZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 17:02:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A48D2087E;
        Tue,  6 Oct 2020 21:02:24 +0000 (UTC)
Date:   Tue, 6 Oct 2020 17:02:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 05/15] kernel-shark: Introduce libkshark-hash
Message-ID: <20201006170222.0093ab92@gandalf.local.home>
In-Reply-To: <20200929134123.178688-6-y.karadz@gmail.com>
References: <20200929134123.178688-1-y.karadz@gmail.com>
        <20200929134123.178688-6-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 29 Sep 2020 16:41:13 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> +/**
> + * Create new hash table of Ids.
> + */
> +struct kshark_hash_id *kshark_hash_id_alloc(size_t n_bits)
> +{
> +	struct kshark_hash_id *hash;
> +	size_t size;
> +
> +	hash = calloc(1, sizeof(*hash));
> +	assert(hash);

For failed memory, is the general plan to just crash? (assert) or return
NULL?

> +
> +	hash->n_bits = n_bits;
> +	hash->count = 0;
> +
> +	size = hash_size(hash);
> +	hash->hash = calloc(size, sizeof(*hash->hash));

In either case, this needs to be checked too.

> +
> +	return hash;
> +}
> +
> +/** Free the hash table of Ids. */
> +void kshark_hash_id_free(struct kshark_hash_id *hash)
> +{
> +	if (!hash)
> +		return;
> +
> +	kshark_hash_id_clear(hash);
> +	free(hash->hash);
> +	free(hash);
> +}
> +

> diff --git a/src/libkshark.h b/src/libkshark.h
> index 9eecc2d..57bd5e5 100644
> --- a/src/libkshark.h
> +++ b/src/libkshark.h
> @@ -33,6 +33,7 @@ extern "C" {
>  // KernelShark
>  #include "libkshark-plugin.h"
>  
> +

Extra white space.

>  /**
>   * Kernel Shark entry contains all information from one trace record needed
>   * in order to  visualize the time-series of trace records. The part of the
> @@ -72,6 +73,52 @@ struct kshark_entry {
>  	int64_t		ts;
>  };
>  
> +/** Size of the task'c hash table in terms of bits being used by the key. */

 "task'c" ?

-- Steve


> +#define KS_TASK_HASH_NBITS	16
> +
> +/** Size of the hash table of Ids in terms of bits being used by the key. */
> +#define KS_FILTER_HASH_NBITS	8
> +
> +/** A bucket for the hash table of integer Id numbers (kshark_hash_id). */
> +struct kshark_hash_id_item {
> +	/** Pointer to the Id in this bucket. */
> +	struct kshark_hash_id_item	*next;
> +
> +	/** The Id value. */
> +	int				id;
> +};
> +
> +/**
> + * Hash table of integer Id numbers. To be used for fast filter of trace
> + * entries.
> + */
> +struct kshark_hash_id {
> +	/** Array of buckets. */
> +	struct kshark_hash_id_item	**hash;
> +
> +	/** The number of Ids in the table. */
> +	size_t	count;
> +
> +	/**
> +	 * The number of bits used by the hashing function.
> +	 * Note that the number of buckets in the table if given by
> +	 * 1 << n_bits.
> +	 */
> +	size_t	n_bits;
> +};
