Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E178C6FD22
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 22:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355830AbjHQWuv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 18:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355903AbjHQWub (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 18:50:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2F73591
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 15:50:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EA9861459
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 22:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A303FC433C7;
        Thu, 17 Aug 2023 22:50:25 +0000 (UTC)
Date:   Thu, 17 Aug 2023 18:50:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH 2/9] libtraceeval: Add traceeval_iterator_query()
Message-ID: <20230817185030.729db408@gandalf.local.home>
In-Reply-To: <20230817222422.118568-3-rostedt@goodmis.org>
References: <20230817222422.118568-1-rostedt@goodmis.org>
        <20230817222422.118568-3-rostedt@goodmis.org>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 17 Aug 2023 18:24:15 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> @@ -186,5 +186,7 @@ int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
>  				   traceeval_cmp_fn sort_fn, void *data);
>  int traceeval_iterator_next(struct traceeval_iterator *iter,
>  			    const union traceeval_data **keys);
> +int traceeval_iterator_query(struct traceeval_iterator *iter,
> +			     const union traceeval_data **results);
>  

And while porting this to trace-flames.c, I also realize I need a
traceeval_iterator_results_release() to match it.

The traceeval_results_release() works, but it's nicer not to have to
remember what teval you used.

For example:

	while (traceeval_iterator_next(iter, &keys) > 0) {
		const struct traceeval_data *results;

		if (traceeval_iterator_query(iter, &results) < 1)
			continue;

		stack = results[0].pointer;
		traceeval_results_release(fstack->partial_stacks, results);


Would be much nice with:

	while (traceeval_iterator_next(iter, &keys) > 0) {
		const struct traceeval_data *results;

		if (traceeval_iterator_query(iter, &results) < 1)
			continue;

		stack = results[0].pointer;
		traceeval_iterator_results_release(iter, results);


-- Steve
