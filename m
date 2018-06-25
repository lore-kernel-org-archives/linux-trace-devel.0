Return-Path: <SRS0=jM0/=JL=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:58078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964851AbeFYSfB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Jun 2018 14:35:01 -0400
Date: Mon, 25 Jun 2018 14:34:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 4/7] kernel-shark-qt: Add an example showing how to load
 trace data
Message-ID: <20180625143459.3e29de1e@gandalf.local.home>
In-Reply-To: <20180625150121.14291-5-y.karadz@gmail.com>
References: <20180625150121.14291-1-y.karadz@gmail.com>
        <20180625150121.14291-5-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon, 25 Jun 2018 18:01:18 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:


> --- /dev/null
> +++ b/kernel-shark-qt/examples/dataload.c
> @@ -0,0 +1,80 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> +// C
> +#include <stdio.h>
> +#include <stdlib.h>
> +
> +// KernelShark
> +#include "libkshark.h"
> +
> +const char *default_file = "trace.dat";
> +
> +int main(int argc, char **argv)
> +{
> +	// Create a new kshark session.

Again, for C files, please use the /* */ comment format.

> +	struct kshark_context *kshark_ctx = NULL;
> +	kshark_instance(&kshark_ctx);


Shouldn't you check the return value here?


> +
> +	// Open a trace data file produced by trace-cmd.
> +	bool status;

Even though this is an example, please put declarations at the top.

Other than that, this looks fine.

-- Steve

> +	if (argc > 1)
> +		status = kshark_open(kshark_ctx, argv[1]);
> +	else
> +		status = kshark_open(kshark_ctx, default_file);
> +
> +	if (!status) {
> +		kshark_free(kshark_ctx);
> +		return 1;
> +	}
> +
> +	// Load the content of the file into an array of entries.
> +	struct kshark_entry **data = NULL;
> +	size_t r, n_rows;
> +	n_rows = kshark_load_data_entries(kshark_ctx, &data);
> +
> +	// Print to the screen the list of all tasks.
> +	struct kshark_task_list* task = kshark_ctx->tasks;
> +	while (task) {
> +		const char *task_str = pevent_data_comm_from_pid(kshark_ctx->pevt,
> +								 task->pid);
> +		printf("task: %s-%i\n", task_str, task->pid);
> +		task = task->next;
> +	}
> +
> +	puts("\n\n");
> +
> +	// Print to the screen the first 10 entries.
> +	char *entry_str;
> +	for (r = 0; r < 10; ++r) {
> +		entry_str = kshark_dump_entry(data[r]);
> +		puts(entry_str);
> +		free(entry_str);
> +	}
> +
> +	puts("\n...\n");
> +
> +	// Print the last 10 entries.
> +	for (r = n_rows - 10; r < n_rows; ++r) {
> +		entry_str = kshark_dump_entry(data[r]);
> +		puts(entry_str);
> +		free(entry_str);
> +	}
> +
> +	// Free the memory.
> +	for (r = 0; r < n_rows; ++r)
> +		free(data[r]);
> +
> +	free(data);
> +
> +	// Close the file.
> +	kshark_close(kshark_ctx);
> +
> +	// Close the session.
> +	kshark_free(kshark_ctx);
> +
> +	return 0;
> +}
