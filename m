Return-Path: <SRS0=8H7y=JS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:47930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752235AbeGBTD4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Jul 2018 15:03:56 -0400
Date: Mon, 2 Jul 2018 15:03:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 3/9] kernel-shark-qt: Add API for loading trace.dat
 files
Message-ID: <20180702150354.2d643dfd@gandalf.local.home>
In-Reply-To: <20180702140424.23221-3-y.karadz@gmail.com>
References: <20180702140424.23221-1-y.karadz@gmail.com>
        <20180702140424.23221-3-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon,  2 Jul 2018 17:04:18 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:


> +/**
> + * @brief Get an array containing the Process Ids of all tasks presented in
> + *	  the loaded trace data file.
> + * @param kshark_ctx: Input location for context pointer.
> + * @param pids: Output location for the Pids of the tasks. The user is
> + *		responsible for freeing the elements of the outputted array.
> + * @returns The size of the outputted array of Pids in the case of success,
> + *	    or a negative error code on failure.
> + */
> +ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int **pids)
> +{
> +	size_t i, pid_count = 0, pid_size = KS_TASK_HASH_SIZE;
> +	struct kshark_task_list *list;
> +	int *temp_pids;
> +
> +	*pids = calloc(pid_size, sizeof(int));
> +	if(!*pids)
> +		goto fail;
> +
> +	for (i = 0; i < KS_TASK_HASH_SIZE; ++i) {
> +		list = kshark_ctx->tasks[i];
> +		while (list) {
> +			(*pids)[pid_count] = list->pid;
> +			list = list->next;
> +			if (++pid_count >= pid_size) {
> +				pid_size *= 2;
> +				temp_pids = realloc(*pids, pid_size * sizeof(int));
> +				if (!temp_pids) {
> +					goto fail;
> +				}
> +				*pids = temp_pids;
> +			}
> +		}
> +	}
> +
> +	temp_pids = realloc(*pids, pid_count * sizeof(int));
> +	if (!temp_pids)
> +		goto fail;

Almost, but we need:

	*pids = temp_pids;

Otherwise, if the unlikely case of *pids gets reallocated (it shouldn't
because we are shrinking *pids), it gets assigned properly. Yes, I know
I'm being paranoid here, but it's better safe than sorry.

No need to send another patch, I'll add this myself.

Thanks!

-- Steve

> +
> +	return pid_count;
> +
> +fail:
> +	fprintf(stderr, "Failed to allocate memory for Task Pids.\n");
> +	free(*pids);
> +	*pids = NULL;
> +	return -ENOMEM;
> +}
> +
