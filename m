Return-Path: <SRS0=D2WB=J3=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:52004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388160AbeGKQq7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Jul 2018 12:46:59 -0400
Date: Wed, 11 Jul 2018 12:41:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/6] kernel-shark-qt: Add generic instruments for
 searching inside the trace data
Message-ID: <20180711124147.2bbf5b02@gandalf.local.home>
In-Reply-To: <20180711133814.26854-2-y.karadz@gmail.com>
References: <20180711133814.26854-1-y.karadz@gmail.com>
        <20180711133814.26854-2-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 11 Jul 2018 16:38:09 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> This patch introduces the instrumentation for data extraction, used by the

						No need for the comma.

> visualization model of the Qt-based KernelShark. The effectiveness of these
> instruments for searching has a dominant effect over the performance of the
> model, so let's spend some time and explain this in details.

						"in detail."

> 
> The first type of instruments provides binary search inside a sorted in time

	either "first type of instrument provides" or
	       "first type of instruments provide"

> arrays of kshark_entries or trace_records. The search returns the first
> element of the array, having timestamp bigger than a reference time value.
> The time complexity of these searches is log(n).
> 
> The second type of instruments provides searching for the first (in time)

	Same here for the "second type ..."

> entry, satisfying an abstract Matching condition. Since the array is sorted
> in time, but we search for an abstract property, for this search the array
> is considered unsorted, thus we have to iterate and check all elements of the
> array one by one. If we search for a type of entries, which are well presented
> in the array, the time complexity of the search is constant, because no matter
> how big is the array the search only goes through small number of entries at
> the beginning of the array (or at the end, if we search backwards), before it
> finds the first match. However if we search for sparse, or even nonexistent
> entries, the time complexity becomes linear.
> 
> These explanations will start making more sense with the following patches.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark-qt/src/libkshark.c | 269 +++++++++++++++++++++++++++++++-
>  kernel-shark-qt/src/libkshark.h |  76 ++++++++-
>  2 files changed, 342 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
> index 3299752..b79d0ac 100644
> --- a/kernel-shark-qt/src/libkshark.c
> +++ b/kernel-shark-qt/src/libkshark.c
> @@ -861,7 +861,7 @@ static const char *kshark_get_info(struct pevent *pe,
>   * @returns The returned string contains a semicolon-separated list of data
>   *	    fields.
>   */
> -char* kshark_dump_entry(struct kshark_entry *entry)
> +char* kshark_dump_entry(const struct kshark_entry *entry)
>  {
>  	const char *event_name, *task, *lat, *info;
>  	struct kshark_context *kshark_ctx;
> @@ -908,3 +908,270 @@ char* kshark_dump_entry(struct kshark_entry *entry)
>  
>  	return NULL;
>  }
> +
> +/**
> + * @brief Binary search inside a time-sorted array of kshark_entries.
> + * @param time: The value of time to search for.
> + * @param data_rows: Input location for the trace data.
> + * @param l: Array index specifying the lower edge of the range to search in.
> + * @param h: Array index specifying the upper edge of the range to search in.
> + * @returns On success, the first kshark_entry inside the range, having a
> +	    timestamp equal or bigger than "time". In the case when no
> +	    kshark_entry has been found inside the range, the function will
> +	    return the value of "l" or "h".
> + */
> +size_t kshark_find_entry_by_time(uint64_t time,
> +				 struct kshark_entry **data_rows,
> +				 size_t l, size_t h)
> +{
> +	size_t mid;
> +
> +	if (data_rows[l]->ts >= time)
> +		return l;
> +
> +	if (data_rows[h]->ts < time)
> +		return h;
> +
> +	while (h - l > 1) {
> +		mid = (l + h) / 2;
> +		if (data_rows[mid]->ts < time)
> +			l = mid;
> +		else
> +			h = mid;
> +	}
> +
> +	return h;
> +}
> +
> +/**
> + * @brief Binary search inside a time-sorted array of pevent_records.
> + * @param time: The value of time to search for.
> + * @param data: Input location for the trace data.
> + * @param l: Array index specifying the lower edge of the range to search in.
> + * @param h: Array index specifying the upper edge of the range to search in.
> + * @returns On success, the first pevent_record inside the range, having a
> +	    timestamp equal or bigger than "time". In the case when no
> +	    pevent_record has been found inside the range, the function will
> +	    return the value of "l" or "h".
> + */
> +size_t kshark_find_record_by_time(uint64_t time,
> +				  struct pevent_record **data,
> +				  size_t l, size_t h)
> +{
> +	size_t mid;
> +
> +	if (data[l]->ts >= time)
> +		return l;
> +
> +	if (data[h]->ts < time)
> +		return h;
> +
> +	while (h - l > 1) {
> +		mid = (l + h) / 2;
> +		if (data[mid]->ts < time)
> +			l = mid;
> +		else
> +			h = mid;
> +	}
> +
> +	return h;
> +}
> +

I don't like the duplication of code, but we can wait till later to see
if we can combine this. Once I get a good idea of how the code is being
used then we can restructure this. But for now, we'll keep this as is.

> +/**
> + * @brief Simple Pid matching function to be user for data requests.
> + * @param kshark_ctx: Input location for the session context pointer.
> + * @param e: kshark_entry to be checked.
> + * @param pid: Matching condition value.
> + * @returns True if the Pid of the entry matches the value of "pid".
> + *	    Else false.

Is this going to be extended in the future? Why the kshark_ctx?

> + */
> +bool kshark_check_pid(struct kshark_context *kshark_ctx,
> +		      struct kshark_entry *e, int pid)
> +{
> +	if (e->pid == pid)
> +		return true;
> +
> +	return false;
> +}
> +
> +/**
> + * @brief Simple Cpu matching function to be user for data requests.
> + * @param kshark_ctx: Input location for the session context pointer.
> + * @param e: kshark_entry to be checked.
> + * @param cpu: Matching condition value.
> + * @returns True if the Cpu of the entry matches the value of "cpu".
> + *	    Else false.
> + */
> +bool kshark_check_cpu(struct kshark_context *kshark_ctx,
> +		      struct kshark_entry *e, int cpu)

Same here.

And since kshark_entry is defined in the header, why not make these
inlined functions?

> +{
> +	if (e->cpu == cpu)
> +		return true;
> +
> +	return false;
> +}
> +
> +/**
> + * @brief Create Data request. The user has to free the returned
> + *	  kshark_entry_request.

Information about freeing should usually be in the @returns, or is this
different with Doxygen?

But the description should say something about what to create a request
for.

> + * @param first: Array index specifying the position inside the array from
> + *		 where the search starts.
> + * @param n: Number of array elements to search in.
> + * @param cond: Matching condition function.
> + * @param val: Matching condition value, used by the Matching condition
> + *	       function.
> + * @param vis_only: If true, a visible entry is requested.
> + * @param vis_mask: If "vis_only" is true, use this mask to specify the level
> + *		    of visibility of the requested entry
> + * @returns Pointer to kshark_entry_request on success, or NULL on failure.

Like adding: "The pointer must be freed by the user.", also it should
explain what function to use to free it.

> + */
> +struct kshark_entry_request *
> +kshark_entry_request_alloc(size_t first, size_t n,
> +			   matching_condition_func cond, int val,
> +			   bool vis_only, int vis_mask)
> +{
> +	struct kshark_entry_request *req = malloc(sizeof(*req));
> +
> +	if (!req) {
> +		fprintf(stderr,
> +			"Failed to allocate memory for entry request.\n");

This should use warning(). But that can be done later.

> +		return NULL;
> +	}
> +
> +	req->first = first;
> +	req->n = n;
> +	req->cond = cond;
> +	req->val = val;
> +	req->vis_only = vis_only;
> +	req->vis_mask = vis_mask;
> +
> +	return req;
> +}
> +
> +/** Dummy entry, used to indicate the existence of filtered entries. */
> +const struct kshark_entry dummy_entry = {/* next */ NULL,
> +					 /* visible */ 0x00,
> +					 /* cpu */ KS_FILTERED_BIN,
> +					 /* pid */ KS_FILTERED_BIN,
> +					 /* event_id */ -1,
> +					 /* offset */ 0,
> +					 /* ts */ 0};

BTW, C99 allows you to do this:

				= {
	.next		= NULL,
	.visible	= 0x00,
	.cpu		= KS_FILTERED_BIN,
	.pid		= KS_FILTERED_BIN,
	.event_id	= -1,
	.offset		= 0,
	.ts		= 0
};

And then you don't need to worry about keeping the values in order of
the structure.

> +
> +/**
> + * @brief Search for an entry satisfying the requirements of a given Data
> + *	  request. Start from the position provided by the request and go
> + *	  searching in the direction of the increasing timestamps (front).
> + * @param req: Input location for Data request.
> + * @param data: Input location for the trace data.
> + * @param index: Optional output location for the index of the returned
> + *		 entry inside the array.
> + * @returns Pointer to the first entry satisfying the matching conditionon
> + *	    success, or NULL on failure.
> + *	    In the special case when some entries, satisfying the Matching
> + *	    condition function have been found, but all these entries have
> + *	    been discarded because of the visibility criteria (filtered
> + *	    entries), the function returns a pointer to a special
> + *	    "Dummy entry".
> + */
> +const struct kshark_entry *
> +kshark_get_entry_front(const struct kshark_entry_request *req,
> +		       struct kshark_entry **data,
> +		       ssize_t *index)
> +{
> +	struct kshark_context *kshark_ctx = NULL;
> +	const struct kshark_entry *e = NULL;
> +	size_t i, last;
> +
> +	if (index)
> +		*index = KS_EMPTY_BIN;
> +
> +	if (!kshark_instance(&kshark_ctx))
> +		return e;
> +
> +	last = req->first + req->n;
> +	for (i = req->first; i < last; ++i) {
> +		if (req->cond(kshark_ctx, data[i], req->val)) {
> +			/*
> +			 * Data satisfying the condition has been found.
> +			 */
> +			if (req->vis_only &&
> +			    !(data[i]->visible & req->vis_mask)) {
> +				/* This data entry has been filtered. */
> +				e = &dummy_entry;

I'm thinking that you don't need the dummy entry, but instead do:

#define INVALID_KSHARK_ENTRY ((struct kshark_entry *)-1UL)

	e = INVALID_KSHARK_ENTRY;

And then have a macro to test the result:

#define VALID_KSHARK_ENTRY(e)	((e) != INVALID_KSHARK_ENTRY)

This is common to do in Linux.

> +			} else {
> +				e = data[i];
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (index) {
> +		if (e)
> +			*index = (e->event_id >= 0)? i : KS_FILTERED_BIN;

Then this would be:

			*index = VALID_KSHARK_ENTRY(e) ? i :
			KS_FILTERED_BIN;

> +		else
> +			*index = KS_EMPTY_BIN;
> +	}
> +
> +	return e;
> +}
> +
> +/**
> + * @brief Search for an entry satisfying the requirements of a given Data
> + *	  request. Start from the position provided by the request and go
> + *	  searching in the direction of the decreasing timestamps (back).
> + * @param req: Input location for Data request.
> + * @param data: Input location for the trace data.
> + * @param index: Optional output location for the index of the returned
> + *		 entry inside the array.
> + * @returns Pointer to the first entry satisfying the matching conditionon
> + *	    success, or NULL on failure..
> + *	    In the special case when some entries, satisfying the Matching
> + *	    condition function have been found, but all these entries have
> + *	    been discarded because of the visibility criteria (filtered
> + *	    entries), the function returns a pointer to a special
> + *	    "Dummy entry".
> + */
> +const struct kshark_entry *
> +kshark_get_entry_back(const struct kshark_entry_request *req,
> +		      struct kshark_entry **data,
> +		      ssize_t *index)
> +{
> +	struct kshark_context *kshark_ctx = NULL;
> +	const struct kshark_entry *e = NULL;
> +	ssize_t i, last;
> +
> +	if (index)
> +		*index = KS_EMPTY_BIN;
> +
> +	if (!kshark_instance(&kshark_ctx))
> +		return e;
> +
> +	last = req->first - req->n + 1;
> +	if (last < 0)
> +		last = 0;
> +
> +	for (i = req->first; i >= last; --i) {
> +		if (req->cond(kshark_ctx, data[i], req->val)) {
> +			/*
> +			 * Data satisfying the condition has been found.
> +			 */
> +			if (req->vis_only &&
> +			    !(data[i]->visible & req->vis_mask)) {
> +				/* This data entry has been filtered. */
> +				e = &dummy_entry;
> +			} else {
> +				e = data[i];
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (index) {
> +		if (e)
> +			*index = (e->event_id >= 0)? i : KS_FILTERED_BIN;
> +		else
> +			*index = KS_EMPTY_BIN;
> +	}
> +
> +	return e;
> +}

I think you can combine the above two functions:

static const struct kshark_entry *
get_entry(const struct kshark_entry_request *req,
          struct kshark_entry **data,
          ssize_t *index, ssize_t start, ssize_t last, int inc)
{
        struct kshark_context *kshark_ctx = NULL;
        const struct kshark_entry *e = NULL;
        ssize_t i;

        if (index)
                *index = KS_EMPTY_BIN;

        if (!kshark_instance(&kshark_ctx))
                return e;

        last = req->first + req->n;
        for (i = start; i != last; i += inc) {
                if (req->cond(kshark_ctx, data[i], req->val)) {
                        /*
                         * Data satisfying the condition has been found.
                         */
                        if (req->vis_only &&
                            !(data[i]->visible & req->vis_mask)) {
                                /* This data entry has been filtered. */
                                e = &dummy_entry;
                        } else {
                                e = data[i];
                                break;
                        }
                }
        }

        if (index) {
                if (e)
                        *index = (e->event_id >= 0)? i : KS_FILTERED_BIN;
                else
                        *index = KS_EMPTY_BIN;
        }

        return e;
}

const struct kshark_entry *
kshark_get_entry_front(const struct kshark_entry_request *req,
                       struct kshark_entry **data,
                       ssize_t *index)
{
        return get_entry(req, data, index, req->first,
                         req->first + req->n, 1);
}

kshark_get_entry_back(const struct kshark_entry_request *req,
                      struct kshark_entry **data,
                      ssize_t *index)
{
        return get_entry(req, data, index, req->first,
                         req->first - req->n, -1);
}

I haven't really checked it, so it may be buggy. But you get the idea.

> diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
> index 2e26552..358d498 100644
> --- a/kernel-shark-qt/src/libkshark.h
> +++ b/kernel-shark-qt/src/libkshark.h
> @@ -45,7 +45,7 @@ struct kshark_entry {
>  	uint8_t		visible;
>  
>  	/** The CPU core of the record. */
> -	uint8_t		cpu;
> +	int8_t		cpu;

This should be a separate patch.

-- Steve

>  
>  	/** The PID of the task the record was generated. */
>  	int16_t		pid;
> @@ -133,7 +133,7 @@ void kshark_close(struct kshark_context *kshark_ctx);
>  
>  void kshark_free(struct kshark_context *kshark_ctx);
>  
> -char* kshark_dump_entry(struct kshark_entry *entry);
> +char* kshark_dump_entry(const struct kshark_entry *entry);
>  
>  /** Bit masks used to control the visibility of the entry after filtering. */
>  enum kshark_filter_masks {
> @@ -190,6 +190,78 @@ void kshark_filter_entries(struct kshark_context *kshark_ctx,
>  			   struct kshark_entry **data,
>  			   size_t n_entries);
>  
> +size_t kshark_find_entry_by_time(uint64_t time,
> +				 struct kshark_entry **data_rows,
> +				 size_t l, size_t h);
> +
> +size_t kshark_find_record_by_time(uint64_t time,
> +				  struct pevent_record **data_rows,
> +				  size_t l, size_t h);
> +
> +bool kshark_check_pid(struct kshark_context *kshark_ctx,
> +		      struct kshark_entry *e, int pid);
> +
> +bool kshark_check_cpu(struct kshark_context *kshark_ctx,
> +		      struct kshark_entry *e, int cpu);
> +
> +/** Empty bin identifier. */
> +#define KS_EMPTY_BIN		-1
> +
> +/** Filtered bin identifier. */
> +#define KS_FILTERED_BIN		-2
> +
> +/** Matching condition function type. To be user for data requests */
> +typedef bool (matching_condition_func)(struct kshark_context*,
> +				       struct kshark_entry*,
> +				       int);
> +
> +/**
> + * Data request structure, defining the properties of the required
> + * kshark_entry.
> + */
> +struct kshark_entry_request {
> +	/**
> +	 * Array index specifying the position inside the array from where
> +	 * the search starts.
> +	 */
> +	size_t first;
> +
> +	/** Number of array elements to search in. */
> +	size_t n;
> +
> +	/** Matching condition function. */
> +	matching_condition_func *cond;
> +
> +	/**
> +	 * Matching condition value, used by the Matching condition function.
> +	 */
> +	int val;
> +
> +	/** If true, a visible entry is requested. */
> +	bool vis_only;
> +
> +	/**
> +	 * If "vis_only" is true, use this mask to specify the level of
> +	 * visibility of the requested entry.
> +	 */
> +	uint8_t vis_mask;
> +};
> +
> +struct kshark_entry_request *
> +kshark_entry_request_alloc(size_t first, size_t n,
> +			   matching_condition_func cond, int val,
> +			   bool vis_only, int vis_mask);
> +
> +const struct kshark_entry *
> +kshark_get_entry_front(const struct kshark_entry_request *req,
> +		       struct kshark_entry **data,
> +		       ssize_t *index);
> +
> +const struct kshark_entry *
> +kshark_get_entry_back(const struct kshark_entry_request *req,
> +		      struct kshark_entry **data,
> +		      ssize_t *index);
> +
>  #ifdef __cplusplus
>  }
>  #endif
