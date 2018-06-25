Return-Path: <SRS0=jM0/=JL=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:43386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752718AbeFYTHi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Jun 2018 15:07:38 -0400
Date: Mon, 25 Jun 2018 15:07:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 6/7] kernel-shark-qt: Add filtering to the C API of
 KernelShark
Message-ID: <20180625150735.0c436096@gandalf.local.home>
In-Reply-To: <20180625150121.14291-7-y.karadz@gmail.com>
References: <20180625150121.14291-1-y.karadz@gmail.com>
        <20180625150121.14291-7-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon, 25 Jun 2018 18:01:20 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:


> +static bool kshark_show_task(struct kshark_context *kshark_ctx, int pid)
> +{
> +	return (!kshark_ctx->show_task_filter ||
> +		!kshark_ctx->show_task_filter->count ||
> +		tracecmd_filter_id_find(kshark_ctx->show_task_filter, pid)) &&
> +		(!kshark_ctx->hide_task_filter ||
> +		 !kshark_ctx->hide_task_filter->count ||
> +		 !tracecmd_filter_id_find(kshark_ctx->hide_task_filter, pid));
> +}
> +
> +static bool kshark_show_event(struct kshark_context *kshark_ctx, int event_id)
> +{
> +	return (!kshark_ctx->show_event_filter ||
> +		!kshark_ctx->show_event_filter->count ||
> +		tracecmd_filter_id_find(kshark_ctx->show_event_filter, event_id)) &&
> +		(!kshark_ctx->hide_event_filter ||
> +		 !kshark_ctx->hide_event_filter->count ||
> +		 !tracecmd_filter_id_find(kshark_ctx->hide_event_filter, event_id));
> +}

To make the above cleaner, can we add some helper functions:

static bool filter_find(struct tracecmd_filter_id *filter, int pid
			bool test)
{
	return !filter || !filter->count ||
		!!(unsigned long)tracecmd_filter_id_find(filter, pid) == test;
}

static bool kshark_show_task(struct kshark_context *kshark_ctx, int pid)
{
	return filter_find(kshark->show_task_filter, pid, true) ||
	       filter_find(kshark->hid_task_filter, pid, false);
}

static bool kshark_show_event(struct kshark_context *kshark_ctx, int pid)
{
	return filter_find(kshark->show_event_filter, pid, true) ||
	       filter_find(kshark->hide_event_filter, pid, false);
}
		

> +
> +void kshark_filter_add_id(struct kshark_context *kshark_ctx, int filter_id, int id)
> +{
> +	switch (filter_id) {
> +		case SHOW_EVENT_FILTER:
> +			tracecmd_filter_id_add(kshark_ctx->show_event_filter, id);
> +			break;
> +
> +		case HIDE_EVENT_FILTER:
> +			tracecmd_filter_id_add(kshark_ctx->hide_event_filter, id);
> +			break;
> +
> +		case SHOW_TASK_FILTER:
> +			tracecmd_filter_id_add(kshark_ctx->show_task_filter, id);
> +			break;
> +
> +		case HIDE_TASK_FILTER:
> +			tracecmd_filter_id_add(kshark_ctx->hide_task_filter, id);
> +			break;
> +
> +		default:
> +			break;
> +	}
> +}

And these could be simplified a little with:

	struct tracecmd_filter_id *filter;

	switch (filter_id) {
		case SHOW_EVENT_FILTER:
			filter = kshark_ctx->show_event_filter;
			break;
		case HIDE_EVENT_FILTER:
			filter = kshark_ctx->hide_event_filter;
			break;
		case SHOW_TASK_FILTER:
			filter = kshark_ctx->show_task_filter;
			break;
		case HIDE_TASK_FILTER:
			filter = kshark_ctx->hide_task_filter;
			break;
		default:
			return;
	}
	tracecmd_filter_id_add(filter, id);

Hmm, I noticed that the tracecmd_filter_id_add() doesn't return if it
allocated, just asserts. We may want to change that and test for
returns :-/

> +
> +void kshark_filter_clear(struct kshark_context *kshark_ctx, int filter_id)
> +{
> +	switch (filter_id) {
> +		case SHOW_EVENT_FILTER:
> +			tracecmd_filter_id_clear(kshark_ctx->show_event_filter);
> +			break;
> +
> +		case HIDE_EVENT_FILTER:
> +			tracecmd_filter_id_clear(kshark_ctx->hide_event_filter);
> +			break;
> +
> +		case SHOW_TASK_FILTER:
> +			tracecmd_filter_id_clear(kshark_ctx->show_task_filter);
> +			break;
> +
> +		case HIDE_TASK_FILTER:
> +			tracecmd_filter_id_clear(kshark_ctx->hide_task_filter);
> +			break;
> +
> +		default:
> +			break;
> +	}

Smae here.

> +}
> +
> +static bool kshark_filter_is_set(struct kshark_context *kshark_ctx)
> +{
> +	if ((kshark_ctx->show_task_filter &&
> +	     kshark_ctx->show_task_filter->count) ||
> +	    (kshark_ctx->hide_task_filter &&
> +	     kshark_ctx->hide_task_filter->count) ||
> +	    (kshark_ctx->show_event_filter &&
> +	     kshark_ctx->show_event_filter->count) ||
> +	    (kshark_ctx->hide_event_filter &&
> +	     kshark_ctx->hide_event_filter->count)) {
> +		return true;

And above, a little helper that makes it easier to read.

static bool filter_is_set(struct tracecmd_filter_id *filter)
{
	return filter && filter->count;
}

static bool kshark_filter_is_set(struct kshark_context_*kshark_ctx)
{
	return filter_is_set(kshark_ctx->show_task_filter) ||
		filter_is_set(kshark_ctx->hide_task_filter) ||
		filter_is_set(kshark_ctx->show_event_filter) ||
		filter_is_set(kshark_ctx->hide_event_filter);
}


> +	}
> +
> +	return false;
> +}
> +

Global functions should have a kernel doc comment.

> +void kshark_filter_entries(struct kshark_context *kshark_ctx,
> +			   struct kshark_entry **data,
> +			   size_t n_entries)
> +{
> +	if (!kshark_filter_is_set(kshark_ctx))
> +		return;
> +
> +	int i;

Move the int declaration to the top.

> +	for (i = 0; i < n_entries; ++i) {
> +		data[i]->visible = 0xFF;
> +		if (!kshark_show_task(kshark_ctx, data[i]->pid)) {
> +			data[i]->visible &= ~kshark_ctx->filter_mask;
> +		}
> +
> +		if (!kshark_show_event(kshark_ctx, data[i]->event_id)) {
> +			int mask = kshark_ctx->filter_mask;

BTW, this declaration is fine. It's still at a top of a block.

> +			mask &= ~KS_GRAPH_VIEW_FILTER_MASK;
> +			mask |= KS_EVENT_VIEW_FILTER_MASK;
> +			data[i]->visible &= ~mask;

Why is this function only filtering event_view and not graph view?

> +		}
> +	}
> +}
> +
>  static void kshark_set_entry_values(struct kshark_context *kshark_ctx,
>  				    struct pevent_record *record,
>  				    struct kshark_entry *entry)
> @@ -224,6 +354,17 @@ size_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
>  			kshark_set_entry_values(kshark_ctx, rec, entry);
>  			kshark_add_task(kshark_ctx, entry->pid);
>  
> +			if (!kshark_show_task(kshark_ctx, entry->pid)) {
> +				entry->visible &= ~kshark_ctx->filter_mask;
> +			}
> +
> +			if (!kshark_show_event(kshark_ctx, entry->event_id)) {
> +				int mask = kshark_ctx->filter_mask;
> +				mask &= ~KS_GRAPH_VIEW_FILTER_MASK;
> +				mask |= KS_EVENT_VIEW_FILTER_MASK;
> +				entry->visible &= ~mask;
> +			}
> +
>  			entry->next = NULL;
>  			next = &(entry->next);
>  			free_record(rec);
> diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
> index d6e41bb..460c0c5 100644
> --- a/kernel-shark-qt/src/libkshark.h
> +++ b/kernel-shark-qt/src/libkshark.h
> @@ -22,6 +22,7 @@ extern "C" {
>  
>  // trace-cmd
>  #include "trace-cmd.h"
> +// #include "trace-filter-hash.h"
>  #include "event-parse.h"
>  
>  /**
> @@ -82,6 +83,25 @@ struct kshark_context {
>  
>  	/** A mutex, used to protect the access to the input file. */
>  	pthread_mutex_t input_mutex;
> +
> +	/** Hash of tasks to filter on. */
> +	struct tracecmd_filter_id	*show_task_filter;
> +
> +	/** Hash of tasks to not display. */
> +	struct tracecmd_filter_id	*hide_task_filter;
> +
> +	/** Hash of events to filter on. */
> +	struct tracecmd_filter_id	*show_event_filter;
> +
> +	/** Hash of events to not display. */
> +	struct tracecmd_filter_id	*hide_event_filter;
> +
> +	/**
> +	 * Bit mask, controlling the visibility of the entries after filtering. If given
> +	 * bit is set here, all entries which are filtered-out will have this bit unset
> +	 * in their "visible" fields.
> +	 */
> +	uint8_t				filter_mask;
>  };
>  
>  /**
> @@ -150,6 +170,61 @@ void kshark_free(struct kshark_context *kshark_ctx);
>   */
>  char* kshark_dump_entry(struct kshark_entry *entry);
>  
> +/** Bit masks used to control the visibility of the entry after filtering. */
> +enum kshark_filter_masks {
> +	/** Use this mask to check the visibility of the entry in the text view. */
> +	KS_TEXT_VIEW_FILTER_MASK	= (1 << 0),
> +
> +	/** Use this mask to check the visibility of the entry in the graph view. */
> +	KS_GRAPH_VIEW_FILTER_MASK	= (1 << 1),
> +
> +	/** Special mask used whene filtering events. */
> +	KS_EVENT_VIEW_FILTER_MASK	= (1 << 2),

Parenthesis are not needed.

> +};
> +
> +/** Filter type identifier. */
> +enum kshark_filter_type {

I wonder if we should have:

	NO_FILTER,

So that all types are > 0?

> +	/** Identifier of the filter, used to specified the events to be shown. */
> +	SHOW_EVENT_FILTER,
> +
> +	/** Identifier of the filter, used to specified the events to be filtered-out. */
> +	HIDE_EVENT_FILTER,
> +
> +	/** Identifier of the filter, used to specified the tasks to be shown. */
> +	SHOW_TASK_FILTER,
> +
> +	/** Identifier of the filter, used to specified the tasks to be filtered-out. */
> +	HIDE_TASK_FILTER,

Also, if you ever expect this to be used outside of KernelShark, we
should have "KS_" prefixed to avoid namespace collisions.

-- Steve

> +};
> +
> +/**
> + * @brief Add an Id value to the filster specified by "filter_id".
> + * @param kshark_ctx: kshark_ctx: Input location for the session context pointer.
> + * @param filter_id: Identifier of the filter.
> + * @param id: Id value to be added to the filter.
> + */
> +void kshark_filter_add_id(struct kshark_context *kshark_ctx, int filter_id, int id);
> +
> +/**
> + * @brief Clear (reset) the filster specified by "filter_id".
> + * @param kshark_ctx: kshark_ctx: Input location for the session context pointer.
> + * @param filter_id: Identifier of the filter.
> + */
> +void kshark_filter_clear(struct kshark_context *kshark_ctx, int filter_id);
> +
> +/**
> + * @brief This function loops over the array of entries specified by "data" and "n_entries"
> + * and sets the "visible" fields of each entry according to the criteria provided by the
> + * filters of the session's context. The field "filter_mask" of the session's context is
> + * used to control the level of visibility/invisibility of the entries which are filtered-out.
> + * @param kshark_ctx: kshark_ctx: Input location for the session context pointer.
> + * @param data: Input location for the trace data to be filtered.
> + * @param n_entries: The size of the inputted data.
> + */
> +void kshark_filter_entries(struct kshark_context *kshark_ctx,
> +			   struct kshark_entry **data,
> +			   size_t n_entries);
> +
>  #ifdef __cplusplus
>  }
>  #endif
