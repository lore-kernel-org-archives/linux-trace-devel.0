Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E641C001B0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 19:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjHIT5s (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 15:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbjHIT5r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 15:57:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1335910E0
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 12:57:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 994F864715
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 19:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6FFC433C9;
        Wed,  9 Aug 2023 19:57:45 +0000 (UTC)
Date:   Wed, 9 Aug 2023 15:57:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v4 4/5] histograms: Add traceeval query
Message-ID: <20230809155743.0c72fe80@gandalf.local.home>
In-Reply-To: <20230809175340.3066-5-stevie.6strings@gmail.com>
References: <20230809175340.3066-1-stevie.6strings@gmail.com>
        <20230809175340.3066-5-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  9 Aug 2023 13:53:37 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> +static int copy_traceeval_data_set(size_t size, struct traceeval_type *type,
> +				    const union traceeval_data *orig,
> +				    union traceeval_data **copy)
> +{
> +	size_t i;
> +
> +	*copy = NULL;
> +	if (!size)
> +		return 1;
> +
> +	*copy = calloc(size, sizeof(**copy));
> +	if (!*copy)
> +		return -1;
> +
> +	for (i = 0; i < size; i++) {
> +		if (copy_traceeval_data(type + i, orig + i, (*copy) + i))
> +			goto fail;
> +	}
> +
> +	return 1;
> +
> +fail:
> +	data_release(i, copy, type);
> +	return -1;
> +}

I think Ross mentioned this too, but we should have a copy() callback to
allow things like the dyn events to be copied.

-- Steve
