Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF3DC001DF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Aug 2023 22:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjHBWYh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 18:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbjHBWYQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 18:24:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736FA49C7
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Aug 2023 15:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1614961B49
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Aug 2023 22:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10895C433C7;
        Wed,  2 Aug 2023 22:21:17 +0000 (UTC)
Date:   Wed, 2 Aug 2023 18:21:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH 3/5] histograms: traceeval release
Message-ID: <20230802182116.49ef96fc@gandalf.local.home>
In-Reply-To: <20230728190515.23088-3-stevie.6strings@gmail.com>
References: <20230728190515.23088-1-stevie.6strings@gmail.com>
        <20230728190515.23088-3-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 28 Jul 2023 15:04:38 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> +/**
> + * Deallocate a traceeval instance.
> + */
> +void traceeval_release(struct traceeval *teval)
> +{
> +	if (teval) {
> +		hist_table_release(teval);
> +		type_release(teval->def_keys);
> +		type_release(teval->def_vals);
> +		free(teval);
> +	}
>  }

Nit, but it is usually cleaner to just have:

void traceeval_release(struct traceeval *teval)
{
	if (!teval)
		return;

	hist_table_release(teval);
	type_release(teval->def_keys);
	type_release(teval->def_vals);
	free(teval);
}


Less indents ;-)

-- Steve
