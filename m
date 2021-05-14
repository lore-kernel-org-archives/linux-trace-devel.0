Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 606F2C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 13:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D3C4613B9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 13:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhENNcq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 09:32:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231576AbhENNcq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 09:32:46 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4BE8613B9;
        Fri, 14 May 2021 13:31:34 +0000 (UTC)
Date:   Fri, 14 May 2021 09:31:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 6/7] kernel-shark: Check if "trace_seq" was destroyed
 before using it
Message-ID: <20210514093133.504d1008@gandalf.local.home>
In-Reply-To: <20210514121826.161749-7-y.karadz@gmail.com>
References: <20210514121826.161749-1-y.karadz@gmail.com>
        <20210514121826.161749-7-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 14 May 2021 15:18:25 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> When closing a "tep" data stream we destroy the "trace_seq" object.
> However, trace_seq_destroy() sets the buffer to "TRACE_SEQ_POISON"
> which is different from NULL.
> 
> It is unfortunate that TRACE_SEQ_POISON is an internal definition
> of libtraceevent, so we have to redefine it here, but this can be
> fixed in the future.

It's not unfortunate. It can change in the future without breaking API.

Redefining it here is not robust, and if trace-seq decides to do something
different with that poison value, this will break, and it can't be blamed
on API (using internal knowledge to implement code is not protected by
being backward compatible).

The correct solution is to NULL the buffer after calling destroy.

	if (seq.buffer) {
		trace_seq_destroy(&seq);
		seq.buffer = NULL;
	}

Just like you would do with a pointer you free but may use NULL as a value
you are checking.

-- Steve


> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/libkshark-tepdata.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
> index bc5babb..4a84141 100644
> --- a/src/libkshark-tepdata.c
> +++ b/src/libkshark-tepdata.c
> @@ -29,11 +29,17 @@
>  #include "libkshark-plugin.h"
>  #include "libkshark-tepdata.h"
>  
> +/**
> + * The TEP_SEQ_POISON is to catch the use of
> + * a trace_seq structure after it was destroyed.
> + */
> +#define TEP_SEQ_POISON	((void *)0xdeadbeef)
> +
>  static __thread struct trace_seq seq;
>  
>  static bool init_thread_seq(void)
>  {
> -	if (!seq.buffer)
> +	if (!seq.buffer || seq.buffer == TEP_SEQ_POISON)
>  		trace_seq_init(&seq);
>  
>  	return seq.buffer != NULL;

