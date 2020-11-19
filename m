Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BAB7C63697
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 02:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4485F246CA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 02:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgKSCA3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 21:00:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727167AbgKSCA2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 21:00:28 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F1E2246CA;
        Thu, 19 Nov 2020 02:00:27 +0000 (UTC)
Date:   Wed, 18 Nov 2020 21:00:25 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 14/20] kernel-shark: Provide merging of multiple data
 streams
Message-ID: <20201118210025.0bc6326b@oasis.local.home>
In-Reply-To: <20201118145003.156542-15-y.karadz@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
        <20201118145003.156542-15-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 18 Nov 2020 16:49:57 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The C API provides loading of the trace data in two different forms.
> The firs one is an array of kshark_entries and is being used by the

  "first one"

> KernelShark GUI. The second is a matrix-like structure that has all
> the fields of the kshark_entry stored in separate arrays, forming the
> columns of the matrix. The second form of the data is used by
> trace-cruncher. In this patch we add methods for merging of several
> data streams into a single data set. Both kshark_entries and matrix
> forms of the data are supported. This patch includes a simple example
> that demonstrate how to open a file that contains multiple buffers.
> Each buffers is loaded into a separate Data stream and those streams
> are merged together.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  examples/CMakeLists.txt    |   4 +
>  examples/multibufferload.c |  60 +++++++++
>  src/libkshark.c            | 255 +++++++++++++++++++++++++++++++++++++
>  src/libkshark.h            |  47 +++++++
>  4 files changed, 366 insertions(+)
>  create mode 100644 examples/multibufferload.c
> 
> diff --git a/examples/CMakeLists.txt b/examples/CMakeLists.txt
> index 8d40e42c..831eee24 100644
> --- a/examples/CMakeLists.txt
> +++ b/examples/CMakeLists.txt
> @@ -8,6 +8,10 @@ message(STATUS "datafilter")
>  add_executable(dfilter          datafilter.c)
>  target_link_libraries(dfilter   kshark)
>  
> +message(STATUS "multibufferload")
> +add_executable(mbload          multibufferload.c)
> +target_link_libraries(mbload   kshark)
> +
>  # message(STATUS "datahisto")
>  # add_executable(dhisto          datahisto.c)
>  # target_link_libraries(dhisto   kshark)
> diff --git a/examples/multibufferload.c b/examples/multibufferload.c
> new file mode 100644
> index 00000000..70b2733a
> --- /dev/null
> +++ b/examples/multibufferload.c
> @@ -0,0 +1,60 @@
> +#include <stdio.h>
> +#include <stdlib.h>
> +
> +#include "libkshark.h"
> +#include "libkshark-tepdata.h"
> +
> +const char *default_file = "trace.dat";
> +
> +void put_entry(struct kshark_entry *e)
> +{
> +	char *entry_str = kshark_dump_entry(e);
> +	puts(entry_str);
> +	free(entry_str);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	struct kshark_context *kshark_ctx;
> +	struct kshark_entry **data = NULL;
> +	ssize_t r, n_rows;
> +	int sd;
> +
> +	/* Create a new kshark session. */
> +	kshark_ctx = NULL;
> +	if (!kshark_instance(&kshark_ctx))
> +		return 1;
> +
> +	/* Open a trace data file produced by trace-cmd. */
> +	if (argc > 1)
> +		sd = kshark_open(kshark_ctx, argv[1]);
> +	else
> +		sd = kshark_open(kshark_ctx, default_file);

I'm confused. It doesn't look like this merges more than one stream.

-- Steve

> +
> +	if (sd < 0) {
> +		kshark_free(kshark_ctx);
> +		return 1;
> +	}
> +
> +	/* Initialize data streams for all buffers in this file. */
> +	kshark_tep_init_all_buffers(kshark_ctx, sd);
> +
> +	/* Load all buffers. */
> +	n_rows = kshark_load_all_entries(kshark_ctx, &data);
> +
> +	/* Print to the screen the first 20 entries. */
> +	for (r = 0; r < 20; ++r)
> +		put_entry(data[r]);
> +
> +	/* Free the memory. */
> +	for (r = 0; r < n_rows; ++r)
> +		free(data[r]);
> +	free(data);
> +
> +	kshark_close_all(kshark_ctx);
> +
> +	/* Close the session. */
> +	kshark_free(kshark_ctx);
> +
> +	return 0;
> +}
