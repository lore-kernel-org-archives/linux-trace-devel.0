Return-Path: <SRS0=62yJ=JP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:39888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753127AbeF2S3N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Jun 2018 14:29:13 -0400
Date: Fri, 29 Jun 2018 14:29:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 3/9] kernel-shark-qt: Add API for loading trace.dat
 files
Message-ID: <20180629142911.722d9314@gandalf.local.home>
In-Reply-To: <20180629152541.10109-4-y.karadz@gmail.com>
References: <20180629152541.10109-1-y.karadz@gmail.com>
        <20180629152541.10109-4-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 29 Jun 2018 18:25:35 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> +static struct kshark_task_list *
> +kshark_add_task(struct kshark_context *kshark_ctx, int pid)
> +{
> +	uint8_t key;
> +	struct kshark_task_list *list;

Just a reminder to keep the declarations in "upside-down-xmas-tree"
order. That is, the longer lines go first.

	struct kshark_task_list *list;
	uint8_t key;

> +
> +	key = knuth_hash8(pid);
> +	list = kshark_find_task(kshark_ctx, key, pid);
> +	if (list)
> +		return list;
> +
> +	list = malloc(sizeof(*list));
> +	if (!list)
> +		return NULL;
> +
> +	list->pid = pid;
> +	list->next = kshark_ctx->tasks[key];
> +	kshark_ctx->tasks[key] = list;
> +
> +	return list;
> +}
> +
> +/**
> + * @brief Get an array containing the Process Ids of all tasks presented in
> + *	  the loaded trace data file.
> + * @param kshark_ctx: Input location for context pointer.
> + * @param pids: Output location for the Pids of the tasks. The user is
> + *		responsible for freeing the elements of the outputted array.
> + * @returns The size of the outputted array of Pids.
> + */
> +size_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int **pids)

OK, this is a new function from the last patches.

> +{
> +	struct kshark_task_list *list;
> +	size_t i, pid_count = 0, pid_size = KS_TASK_HASH_SIZE;

Here I would say it's OK to keep this order, because you have multiple
declarations, which is somewhat OK.

> +
> +	*pids = calloc(pid_size, sizeof(int));

	Need to check if  the allocation succeeded.

> +	for (i = 0; i < KS_TASK_HASH_SIZE; ++i) {
> +		list = kshark_ctx->tasks[i];
> +		while (list) {
> +			(*pids)[pid_count] = list->pid;
> +			list = list->next;
> +			if (++pid_count >= pid_size) {
> +				pid_size *= 2;
> +				*pids = realloc(*pids, pid_size * sizeof(int));

Here too. And realloc actually needs a temp variable.

				temp_pids = (*pids, pid_size *
				sizeof(int));
				if (!temp_pids) {
					free(*pids);
					*pids = NULL;
					return -ENOMEM;
				}
				*pids = temp_pids;

> +			}
> +		}
> +	}
> +
> +	*pids = realloc(*pids, pid_count * sizeof(int));

Hmm, realloc() should not fail when the new size is smaller, but I
never trust that. Perhaps we should have:

	/* Shouldn't fail, but let's be paranoid */
	temp_pids = realloc(*pids, pid_count * sizeof(int));
	if (temp_pids)
		*pids = temp_pids;

> +	return pid_count;
> +}
> +
> +static void kshark_set_entry_values(struct kshark_context *kshark_ctx,
> +				    struct pevent_record *record,
> +				    struct kshark_entry *entry)
> +{
> +	/* Offset of the record */
> +	entry->offset = record->offset;
> +
> +	/* CPU Id of the record */
> +	entry->cpu = record->cpu;
> +
> +	/* Time stamp of the record */
> +	entry->ts = record->ts;
> +
> +	/* Event Id of the record */
> +	entry->event_id = pevent_data_type(kshark_ctx->pevent, record);
> +
> +	/*
> +	 * Is visible mask. This default value means that the entry
> +	 * is visible everywhere.
> +	 */
> +	entry->visible = 0xFF;
> +
> +	/* Process Id of the record */
> +	entry->pid = pevent_data_pid(kshark_ctx->pevent, record);
> +}
> +
> +/**
> + * @brief Load the content of the trace data file into an array of
> + *	  kshark_entries. This function provides fast loading, however the
> + *	  "latency" and the "info" fields can be accessed only via the offset
> + *	  into the file. This makes the access to these two fields much
> + *	  slower.
> + * @param kshark_ctx: Input location for context pointer.
> + * @param data_rows: Output location for the trace data. The user is
> + *		     responsible for freeing the elements of the outputted
> + *		     array.
> + * @returns The size of the outputted data in the case of success, or a
> + *	    negative error code on failure.
> + */
> +ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
> +				struct kshark_entry ***data_rows)
> +{
> +	int n_cpus = tracecmd_cpus(kshark_ctx->handle);
> +	int cpu, next_cpu;
> +	size_t count, total = 0;
> +	uint64_t ts;

Lets order the above a bit nicer:

	int n_cpus = tracecmd_cpus(kshark_ctx->handle);
	size_t count, total = 0;
	int cpu, next_cpu;
	uint64_t ts;


> +
> +	struct pevent_record *rec;
> +	struct kshark_entry *entry, **next;
> +	struct kshark_entry **cpu_list, **rows;
> +	struct kshark_task_list *task;

And these as:

	struct kshark_entry **cpu_list, **rows;
	struct kshark_entry *entry, **next;
	struct kshark_task_list *task;
	struct pevent_record *rec;

See how nice and tidy it looks ;-)

Same with the other declarations.

Other than that, the patch looks good, as it looks like you did
everything I asked. I would have done the rearranging myself, but since
the realloc and calloc above need error checks, you can submit this one
again.

The first two patches are fine, and I'll pull them in so no need to
resubmit those.

I'll continue to review the other patches, and if I don't see anything
wrong with them, then you only need to update this one patch.

-- Steve

> +
> +	if (*data_rows)
> +		free(*data_rows);
> +
> +	cpu_list = calloc(n_cpus, sizeof(struct kshark_entry *));
> +
> +	for (cpu = 0; cpu < n_cpus; ++cpu) {
> +		count = 0;
> +		cpu_list[cpu] = NULL;
> +		next = &cpu_list[cpu];
> +
> +		rec = tracecmd_read_cpu_first(kshark_ctx->handle, cpu);
> +		while (rec) {
> +			*next = entry = malloc(sizeof(struct kshark_entry));
> +			if (!entry)
> +				goto fail;
> +
> +			kshark_set_entry_values(kshark_ctx, rec, entry);
> +			task = kshark_add_task(kshark_ctx, entry->pid);
> +			if (!task)
> +				goto fail;
> +
> +			entry->next = NULL;
> +			next = &entry->next;
> +			free_record(rec);
> +
> +			++count;
> +			rec = tracecmd_read_data(kshark_ctx->handle, cpu);
> +		}
> +
> +		total += count;
> +	}
