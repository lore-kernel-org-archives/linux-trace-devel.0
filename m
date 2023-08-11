Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84979C04A94
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Aug 2023 02:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjHKCBC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 22:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbjHKCBB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 22:01:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279302D55
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 19:00:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B164C641D1
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Aug 2023 02:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD12BC433C7;
        Fri, 11 Aug 2023 02:00:53 +0000 (UTC)
Date:   Thu, 10 Aug 2023 22:00:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v4 4/5] histograms: Add traceeval query
Message-ID: <20230810220050.6cefe4aa@gandalf.local.home>
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

> +/*
> + * traceeval_results_release - release the results return by traceeval_query()
> + * @teval: The descriptor used in traceeval_query()
> + * @results: The results returned by traceeval_query()
> + *
> + * The @results returned by traceeval_query() is owned by @teval, and
> + * how it manages it is implementation specific. The caller should not
> + * worry about it. When the caller of traceeval_query() is done with
> + * the @results, it must call traceeval_results_release() on it to
> + * allow traceeval to clean up its references.
> + */
> +void traceeval_results_release(struct traceeval *teval,
> +			       union traceeval_data *results)
> +{
> +	if (!teval || !results) {
> +		if (!results)

I just triggered this. The above should be:

		if (!teval)

Just FYI ;-)

-- Steve

> +			print_err("Results to be freed without accompanied traceeval instance!");
> +		return;
> +	}
> +
> +	data_release(teval->nr_val_types, &results, teval->val_types);
> +}
