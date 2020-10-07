Return-Path: <SRS0=fydL=DO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4264BC4363C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Oct 2020 20:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F27D020872
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Oct 2020 20:29:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgJGU32 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Oct 2020 16:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728450AbgJGU32 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 16:29:28 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FFB720760;
        Wed,  7 Oct 2020 20:29:27 +0000 (UTC)
Date:   Wed, 7 Oct 2020 16:29:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 08/15] kernel-shark: Integrate the stream definitions
 with the C API
Message-ID: <20201007162925.1b9d2b30@gandalf.local.home>
In-Reply-To: <20200929134123.178688-9-y.karadz@gmail.com>
References: <20200929134123.178688-1-y.karadz@gmail.com>
        <20200929134123.178688-9-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 29 Sep 2020 16:41:16 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:


> diff --git a/examples/datafilter.c b/examples/datafilter.c
> index bebc181..38afab8 100644
> --- a/examples/datafilter.c
> +++ b/examples/datafilter.c
> @@ -7,22 +7,22 @@
>  // C
>  #include <stdio.h>
>  #include <stdlib.h>
> +#include <string.h>
>  
>  // KernelShark
>  #include "libkshark.h"
> +#include "libkshark-tepdata.h"
>  
>  const char *default_file = "trace.dat";
>  
>  int main(int argc, char **argv)
>  {
> -	ssize_t i, n_rows, n_tasks, n_evts, count;
> +	size_t i, sd, n_rows, n_tasks, n_evts, count;
>  	struct kshark_context *kshark_ctx;
> +	struct kshark_data_stream *stream;
>  	struct kshark_entry **data = NULL;
> -	struct tep_event_filter *adv_filter;
> -	struct tep_event *event;
> +	int *pids, *evt_ids;
>  	char *entry_str;
> -	bool status;
> -	int *pids;
>  
>  	/* Create a new kshark session. */
>  	kshark_ctx = NULL;
> @@ -31,32 +31,30 @@ int main(int argc, char **argv)
>  
>  	/* Open a trace data file produced by trace-cmd. */
>  	if (argc > 1)
> -		status = kshark_open(kshark_ctx, argv[1]);
> +		sd = kshark_open(kshark_ctx, argv[1]);
>  	else
> -		status = kshark_open(kshark_ctx, default_file);
> +		sd = kshark_open(kshark_ctx, default_file);

OK, here's a perfect example of how I would start breaking this up.

I would implement the switch to using this integer, and add it to all the
current old APIs (don't worry about adding new ones with this change).


>  
> -	if (!status) {
> +	if (sd < 0) {
>  		kshark_free(kshark_ctx);
>  		return 1;
>  	}
>  
>  	/* Load the content of the file into an array of entries. */
> -	n_rows = kshark_load_data_entries(kshark_ctx, &data);
> -	if (n_rows < 1) {
> -		kshark_free(kshark_ctx);
> -		return 1;
> -	}



> diff --git a/src/libkshark.c b/src/libkshark.c
> index 92e2450..3a988df 100644
> --- a/src/libkshark.c
> +++ b/src/libkshark.c
> @@ -1,26 +1,28 @@
>  // SPDX-License-Identifier: LGPL-2.1
>  
>  /*
> - * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + * Copyright (C) 2017 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>   */
>  
>   /**
>   *  @file    libkshark.c
> - *  @brief   API for processing of FTRACE (trace-cmd) data.
> + *  @brief   API for processing of traceing data.
>   */
>  
> +#ifndef _GNU_SOURCE
>  /** Use GNU C Library. */
> -#define _GNU_SOURCE 1
> +#define _GNU_SOURCE
> +#endif // _GNU_SOURCE
>  
>  // C
>  #include <stdlib.h>
>  #include <stdio.h>
>  #include <assert.h>
> +#include <string.h>
>  
>  // KernelShark
>  #include "libkshark.h"
> -
> -static __thread struct trace_seq seq;
> +#include "libkshark-tepdata.h"
>  
>  static struct kshark_context *kshark_context_handler = NULL;
>  
> @@ -32,18 +34,11 @@ static bool kshark_default_context(struct kshark_context **context)
>  	if (!kshark_ctx)
>  		return false;
>  
> -	kshark_ctx->event_handlers = NULL;
> -	kshark_ctx->collections = NULL;
> -	kshark_ctx->plugins = NULL;
> -
> -	kshark_ctx->show_task_filter = tracecmd_filter_id_hash_alloc();
> -	kshark_ctx->hide_task_filter = tracecmd_filter_id_hash_alloc();
> -
> -	kshark_ctx->show_event_filter = tracecmd_filter_id_hash_alloc();
> -	kshark_ctx->hide_event_filter = tracecmd_filter_id_hash_alloc();
> +	kshark_ctx->stream = calloc(KS_MAX_NUM_STREAMS,
> +				    sizeof(*kshark_ctx->stream));
>  
> -	kshark_ctx->show_cpu_filter = tracecmd_filter_id_hash_alloc();
> -	kshark_ctx->hide_cpu_filter = tracecmd_filter_id_hash_alloc();
> +	kshark_ctx->collections = NULL;
> +	kshark_ctx->inputs = NULL;
>  
>  	kshark_ctx->filter_mask = 0x0;
>  
> @@ -58,14 +53,6 @@ static bool kshark_default_context(struct kshark_context **context)
>  	return true;
>  }
>  
> -static bool init_thread_seq(void)
> -{
> -	if (!seq.buffer)
> -		trace_seq_init(&seq);
> -
> -	return seq.buffer != NULL;
> -}
> -
>  /**
>   * @brief Initialize a kshark session. This function must be called before
>   *	  calling any other kshark function. If the session has been
> @@ -102,1466 +89,809 @@ bool kshark_instance(struct kshark_context **kshark_ctx)
>  		}
>  	}
>  
> -	if (!init_thread_seq())
> -		return false;
> -
>  	return true;
>  }
>  
> -static void kshark_free_task_list(struct kshark_context *kshark_ctx)
> -{
> -	struct kshark_task_list *task;
> -	int i;
> -
> -	if (!kshark_ctx)
> -		return;
> -
> -	for (i = 0; i < KS_TASK_HASH_SIZE; ++i) {
> -		while (kshark_ctx->tasks[i]) {
> -			task = kshark_ctx->tasks[i];
> -			kshark_ctx->tasks[i] = task->next;
> -			free(task);
> -		}
> -	}
> -}
> -
>  /**
>   * @brief Open and prepare for reading a trace data file specified by "file".
> - *	  If the specified file does not exist, or contains no trace data,
> - *	  the function returns false.
>   *
>   * @param kshark_ctx: Input location for context pointer.
>   * @param file: The file to load.
>   *
> - * @returns True on success, or false on failure.
> + * @returns The Id number of the data stream associated with this file on success.
> + * 	    Otherwise a negative errno code.
>   */
> -bool kshark_open(struct kshark_context *kshark_ctx, const char *file)
> +int kshark_open(struct kshark_context *kshark_ctx, const char *file)
>  {
> -	struct tracecmd_input *handle;
> -
> -	kshark_free_task_list(kshark_ctx);
> -
> -	handle = tracecmd_open(file);
> -	if (!handle)
> -		return false;
> +	int sd, rt;
>  
> -	if (pthread_mutex_init(&kshark_ctx->input_mutex, NULL) != 0) {
> -		tracecmd_close(handle);
> -		return false;
> -	}
> +	sd = kshark_add_stream(kshark_ctx);
> +	if (sd < 0)
> +		return sd;

So what this can do is add the stream, but have the kshark_data_stream have
a tracecmd_handle in its field. And then you can still have:

	stream->handle = tracecmd_open(...);


This way, you can pass around the stream index in this step, but everything
still requiring to use the handle.

Then the next step would be to start abstracting each operation a little
more, until everything can use the stream directly. And then you remove the
handle.

This is what I mean by slowly moving to a new API. The in between steps may
not look like either API. But that's OK.

And it makes it much easier to review. Because honestly, this current
approach isn't much better than just squashing this all into one patch, and
hoping it works.

-- Steve

