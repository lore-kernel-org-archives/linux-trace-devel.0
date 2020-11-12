Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 138C3C2D0E4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 22:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA5CB22227
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 22:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgKLWKk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 17:10:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:53616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727352AbgKLWKk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 17:10:40 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4B9122246;
        Thu, 12 Nov 2020 22:10:38 +0000 (UTC)
Date:   Thu, 12 Nov 2020 17:10:36 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 08/20] kernel-shark: Add stream interface for
 trace-cmd data
Message-ID: <20201112171036.2c12fbe9@gandalf.local.home>
In-Reply-To: <20201112142358.36821-9-y.karadz@gmail.com>
References: <20201112142358.36821-1-y.karadz@gmail.com>
        <20201112142358.36821-9-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Nov 2020 16:23:46 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Here we provide an implementation of the Data stream interface that will
> process the trace-cmd (Ftrace) data. This can be considered the most
> essential change in the transformation of the C API towards version 2.
> However, for the moment we only have stand alone definitions that are not
> made functional yet. The actual integration with the API will be
> introduced in the following patches.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/CMakeLists.txt      |    1 +
>  src/libkshark-tepdata.c | 1489 +++++++++++++++++++++++++++++++++++++++
>  src/libkshark-tepdata.h |   51 ++
>  src/libkshark.h         |   13 +
>  4 files changed, 1554 insertions(+)
>  create mode 100644 src/libkshark-tepdata.c
>  create mode 100644 src/libkshark-tepdata.h
> 
> diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
> index 0b84851c..4d4f37b1 100644
> --- a/src/CMakeLists.txt
> +++ b/src/CMakeLists.txt
> @@ -5,6 +5,7 @@ add_library(kshark SHARED libkshark.c
>                            libkshark-hash.c
>                            libkshark-model.c
>                            libkshark-plugin.c
> +                          libkshark-tepdata.c
>                            libkshark-configio.c
>                            libkshark-collection.c)
>  
> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
> new file mode 100644
> index 00000000..8ab6531c
> --- /dev/null
> +++ b/src/libkshark-tepdata.c
> @@ -0,0 +1,1489 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright (C) 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> + */
> +
> +/**
> + *  @file    libkshark-tepdata.c
> + *  @brief   Interface for processing of FTRACE (trace-cmd) data.
> + */
> +
> +
> +// C
> +#ifndef _GNU_SOURCE
> +/** Use GNU C Library. */
> +#define _GNU_SOURCE
> +#endif // _GNU_SOURCE
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +
> +// trace-cmd
> +#include "trace-cmd/trace-cmd.h"
> +#include "tracefs/tracefs.h"
> +
> +// KernelShark
> +#include "libkshark.h"
> +#include "libkshark-plugin.h"
> +#include "libkshark-tepdata.h"
> +
> +static __thread struct trace_seq seq;
> +
> +static bool init_thread_seq(void)
> +{
> +	if (!seq.buffer)
> +		trace_seq_init(&seq);
> +
> +	return seq.buffer != NULL;
> +}
> +
> +/** Structure for handling all unique attributes of the FTRACE data. */
> +struct tepdata_handle {
> +	/** Page event used to parse the page. */
> +	struct tep_handle	*tep; /* MUST BE FIRST ENTRY */
> +
> +	/** Input handle for the trace data file. */
> +	struct tracecmd_input	*input;
> +
> +	/**
> +	 * Filter allowing sophisticated filtering based on the content of
> +	 * the event.
> +	 */
> +	struct tep_event_filter	*advanced_event_filter;
> +
> +	/** The unique Id of the sched_switch_event event. */
> +	int sched_switch_event_id;
> +
> +	/** Pointer to the sched_switch_next_field format descriptor. */
> +	struct tep_format_field	*sched_switch_next_field;
> +
> +	/** Pointer to the sched_switch_comm_field format descriptor. */
> +	struct tep_format_field	*sched_switch_comm_field;
> +};
> +
> +/** Get the Page event object used to parse the page. */
> +struct tep_handle *kshark_get_tep(struct kshark_data_stream *stream)
> +{
> +	struct kshark_generic_stream_interface *interface;
> +	struct tepdata_handle *tep_handle;
> +
> +	if (stream->format != KS_TEP_DATA)
> +		return NULL;
> +
> +	interface = stream->interface;
> +	if (!interface)
> +		return NULL;
> +
> +	tep_handle = interface->handle;
> +	return tep_handle->tep;
> +}
> +
> +/** Get the input handle for the trace data file */
> +struct tracecmd_input *kshark_get_tep_input(struct kshark_data_stream *stream)
> +{
> +	struct kshark_generic_stream_interface *interface;
> +	struct tepdata_handle *tep_handle;
> +
> +	if (stream->format != KS_TEP_DATA)
> +		return NULL;
> +
> +	interface = stream->interface;
> +	if (!interface)
> +		return NULL;
> +
> +	tep_handle = interface->handle;
> +	return tep_handle->input;
> +}
> +
> +static inline struct tep_event_filter *
> +get_adv_filter(struct kshark_data_stream *stream)
> +{
> +	struct kshark_generic_stream_interface *interface;
> +	struct tepdata_handle *tep_handle;
> +
> +	if (stream->format != KS_TEP_DATA)
> +		return NULL;
> +
> +	interface = stream->interface;
> +	if (!interface)
> +		return NULL;
> +
> +	tep_handle = interface->handle;
> +	return tep_handle->advanced_event_filter;
> +}
> +
> +static int get_sched_switch_id(struct kshark_data_stream *stream)
> +{
> +	struct kshark_generic_stream_interface *interface;
> +	struct tepdata_handle *tep_handle;
> +
> +	if (stream->format != KS_TEP_DATA)
> +		return -EINVAL;
> +
> +	interface = stream->interface;
> +	if (!interface)
> +		return -EFAULT;
> +
> +	tep_handle = interface->handle;

Since the above is repeated a lot, it may be prudent to make a helper
function:

static inline int get_tepdate_handle(struct kshark_data_stream *stream,
				struct tepdata_handle **handle)
{
	struct kshark_generic_stream_interface *interface;

	if (stream->format != KS_TEP_DATA)
		return -EINVAL;

	interface = stream->interface;
	if (!interface)
		return -EFAULT;

	*handle = interface->handle;
	return 0;	
}

Then you could make the above functions shorter with just:

{
	struct tepdata_handle *tep_handle;
	int ret;

	ret = get_tepdata_handle(stream, &tep_handle);
	if (ret < 0)
		return ret;

> +	return tep_handle->sched_switch_event_id;
> +}


> +
> +static struct tep_format_field *get_sched_next(struct kshark_data_stream *stream)
> +{
> +	struct kshark_generic_stream_interface *interface;
> +	struct tepdata_handle *tep_handle;
> +
> +	if (stream->format != KS_TEP_DATA)
> +		return NULL;
> +
> +	interface = stream->interface;
> +	if (!interface)
> +		return NULL;
> +
> +	tep_handle = interface->handle;
> +	return tep_handle->sched_switch_next_field;
> +}
> +
> +static struct tep_format_field *get_sched_comm(struct kshark_data_stream *stream)
> +{
> +	struct kshark_generic_stream_interface *interface;
> +	struct tepdata_handle *tep_handle;
> +
> +	if (stream->format != KS_TEP_DATA)
> +		return NULL;
> +
> +	interface = stream->interface;
> +	if (!interface)
> +		return NULL;
> +
> +	tep_handle = interface->handle;
> +	return tep_handle->sched_switch_comm_field;
> +}
> +
> +static void set_entry_values(struct kshark_data_stream *stream,
> +			     struct tep_record *record,
> +			     struct kshark_entry *entry)
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
> +	entry->event_id = tep_data_type(kshark_get_tep(stream), record);
> +
> +	/*
> +	 * Is visible mask. This default value means that the entry
> +	 * is visible everywhere.
> +	 */
> +	entry->visible = 0xFF;
> +
> +	/* Process Id of the record */
> +	entry->pid = tep_data_pid(kshark_get_tep(stream), record);

A minor optimization would be to have tep variable instead of recalling the
kshark_get_tep() which would cause a slight overhead for the multiple calls.

	struct tep_handle *tep;

	tep = kshark_get_tep(stream);

	[...]

	... = tep_data_type(tep, record);
	... = tep_data_pid(tep, record);

etc.

Also you could check if NULL is returned and prevent a crash by using NULL
for the tep handle in those callers.

> +}
> +
> +/** Prior time offset of the "missed_events" entry. */
> +#define ME_ENTRY_TIME_SHIFT	10
> +
> +static void missed_events_action(struct kshark_data_stream *stream,
> +				 struct tep_record *record,
> +				 struct kshark_entry *entry)
> +{
> +	/*
> +	 * Use the offset field of the entry to store the number of missed
> +	 * events.
> +	 */
> +	entry->offset = record->missed_events;
> +
> +	entry->cpu = record->cpu;
> +
> +	/*
> +	 * Position the "missed_events" entry a bit before (in time)
> +	 * the original record.
> +	 */
> +	entry->ts = record->ts - ME_ENTRY_TIME_SHIFT;
> +
> +	/* All custom entries must have negative event Identifiers. */
> +	entry->event_id = KS_EVENT_OVERFLOW;
> +
> +	entry->visible = 0xFF;
> +
> +	entry->pid = tep_data_pid(kshark_get_tep(stream), record);
> +}
> +
> +/**
> + * rec_list is used to pass the data to the load functions.
> + * The rec_list will contain the list of entries from the source,
> + * and will be a link list of per CPU entries.
> + */
> +struct rec_list {
> +	union {
> +		/* Used by kshark_load_data_records */
> +		struct {
> +			/** next pointer, matches entry->next */
> +			struct rec_list		*next;
> +			/** pointer to the raw record data */
> +			struct tep_record	*rec;
> +		};
> +		/** entry - Used for kshark_load_data_entries() */
> +		struct kshark_entry		entry;
> +	};
> +};
> +
> +static int get_next_pid(struct kshark_data_stream *stream,
> +			struct tep_record *record)
> +{
> +	unsigned long long val;
> +	int ret;
> +
> +	ret = tep_read_number_field(get_sched_next(stream),
> +				    record->data, &val);
> +
> +	return ret ? : val;
> +}
> +
> +static void register_command(struct kshark_data_stream *stream,
> +			     struct tep_record *record,
> +			     int pid)
> +{
> +	struct tep_format_field *comm_field = get_sched_comm(stream);
> +	const char *comm = record->data + comm_field->offset;
> +	/*
> +	 * TODO: The retrieve of the name of the command above needs to be
> +	 * implemented as a wrapper function in libtracevent.
> +	 */
> +
> +	if (!tep_is_pid_registered(kshark_get_tep(stream), pid))
> +			tep_register_comm(kshark_get_tep(stream), comm, pid);
> +}
> +
> +/**
> + * rec_type defines what type of rec_list is being used.
> + */
> +enum rec_type {
> +	REC_RECORD,
> +	REC_ENTRY,
> +};
> +
> +static void free_rec_list(struct rec_list **rec_list, int n_cpus,
> +			  enum rec_type type)
> +{
> +	struct rec_list *temp_rec;
> +	int cpu;
> +
> +	for (cpu = 0; cpu < n_cpus; ++cpu) {
> +		while (rec_list[cpu]) {
> +			temp_rec = rec_list[cpu];
> +			rec_list[cpu] = temp_rec->next;
> +			if (type == REC_RECORD)
> +				free_record(temp_rec->rec);
> +			free(temp_rec);
> +		}
> +	}
> +	free(rec_list);
> +}
> +
> +static ssize_t get_records(struct kshark_context *kshark_ctx,
> +			   struct kshark_data_stream *stream,
> +			   struct rec_list ***rec_list,
> +			   enum rec_type type)
> +{
> +	struct tep_event_filter *adv_filter = NULL;
> +	struct rec_list **temp_next;
> +	struct rec_list **cpu_list;
> +	struct rec_list *temp_rec;
> +	struct tep_record *rec;
> +	ssize_t count, total = 0;
> +	int pid, next_pid, cpu;
> +
> +	cpu_list = calloc(stream->n_cpus, sizeof(*cpu_list));
> +	if (!cpu_list)
> +		return -ENOMEM;
> +
> +	if (type == REC_ENTRY)
> +		adv_filter = get_adv_filter(stream);
> +
> +	for (cpu = 0; cpu < stream->n_cpus; ++cpu) {
> +		count = 0;
> +		cpu_list[cpu] = NULL;
> +		temp_next = &cpu_list[cpu];
> +
> +		rec = tracecmd_read_cpu_first(kshark_get_tep_input(stream), cpu);

Another micro optimization. Use a variable for kshark_get_tep_input(stream)
as it wont change, and there's no need to do it for every cpu.

> +		while (rec) {
> +			*temp_next = temp_rec = calloc(1, sizeof(*temp_rec));
> +			if (!temp_rec)
> +				goto fail;
> +
> +			temp_rec->next = NULL;
> +
> +			switch (type) {
> +			case REC_RECORD:
> +				temp_rec->rec = rec;
> +				pid = tep_data_pid(kshark_get_tep(stream), rec);

Same thing for kshark_get_tep(steam), as there's no reason to do that call
for ever record, is you'll get the same result.

> +				break;
> +			case REC_ENTRY: {
> +				struct kshark_entry *entry;
> +
> +				if (rec->missed_events) {
> +					/*
> +					 * Insert a custom "missed_events" entry just
> +					 * befor this record.
> +					 */
> +					entry = &temp_rec->entry;
> +					missed_events_action(stream, rec, entry);
> +
> +					entry->stream_id = stream->stream_id;
> +
> +					temp_next = &temp_rec->next;
> +					++count;
> +
> +					/* Now allocate a new rec_list node and comtinue. */
> +					*temp_next = temp_rec = calloc(1, sizeof(*temp_rec));

Need to check the return of calloc()

> +				}
> +
> +				entry = &temp_rec->entry;
> +				set_entry_values(stream, rec, entry);
> +
> +				if(entry->event_id == get_sched_switch_id(stream)) {

Nit, put a space between 'if' and '('

> +					next_pid = get_next_pid(stream, rec);
> +					if (next_pid >= 0)
> +						register_command(stream, rec, next_pid);
> +				}
> +
> +				entry->stream_id = stream->stream_id;
> +
> +				pid = entry->pid;
> +
> +				/* Apply advanced event filtering. */
> +				if (adv_filter && adv_filter->filters &&
> +				    tep_filter_match(adv_filter, rec) != FILTER_MATCH)
> +					unset_event_filter_flag(kshark_ctx, entry);
> +
> +				free_record(rec);
> +				break;
> +			} /* REC_ENTRY */
> +			}
> +
> +			kshark_hash_id_add(stream->tasks, pid);
> +
> +			temp_next = &temp_rec->next;
> +
> +			++count;
> +			rec = tracecmd_read_data(kshark_get_tep_input(stream), cpu);
> +		}
> +
> +		total += count;
> +	}
> +
> +	*rec_list = cpu_list;
> +	return total;
> +
> + fail:
> +	free_rec_list(cpu_list, stream->n_cpus, type);
> +	return -ENOMEM;
> +}
> +
> +static int pick_next_cpu(struct rec_list **rec_list, int n_cpus,
> +			 enum rec_type type)
> +{
> +	uint64_t ts = 0;
> +	uint64_t rec_ts;
> +	int next_cpu = -1;
> +	int cpu;
> +

I'm paranoid. If for some reason this gets called with type not equal to
REC_RECORD or REC_ENTRY (you add a new type someday?) rec_ts will we
undefined.

> +	for (cpu = 0; cpu < n_cpus; ++cpu) {
> +		if (!rec_list[cpu])
> +			continue;
> +
> +		switch (type) {
> +		case REC_RECORD:
> +			rec_ts = rec_list[cpu]->rec->ts;
> +			break;
> +		case REC_ENTRY:
> +			rec_ts = rec_list[cpu]->entry.ts;
> +			break;

Perhaps just add:

		default:
			return -1;
?

> +		}
> +		if (!ts || rec_ts < ts) {
> +			ts = rec_ts;
> +			next_cpu = cpu;
> +		}
> +	}
> +
> +	return next_cpu;
> +}
> +

I'm still looking at this patch, but will have to continue later.

-- Steve



> +/**
> + * @brief Load the content of the trace data file asociated with a given
> + *	  Data stream into an array of kshark_entries. This function
> + *	  provides an abstraction of the entries from the raw data
> + *	  that is read, however the "latency" and the "info" fields can be
> + *	  accessed only via the offset into the file. This makes the access
> + *	  to these two fields much slower.
> + *	  If one or more filters are set, the "visible" fields of each entry
> + *	  is updated according to the criteria provided by the filters. The
> + *	  field "filter_mask" of the session's context is used to control the
> + *	  level of visibility/invisibility of the filtered entries.
> + *
> + * @param stream: Input location for the FTRACE data stream pointer.
> + * @param kshark_ctx: Input location for context pointer.
> + * @param data_rows: Output location for the trace data. The user is
> + *		     responsible for freeing the elements of the outputted
> + *		     array.
> + *
> + * @returns The size of the outputted data in the case of success, or a
> + *	    negative error code on failure.
> + */
