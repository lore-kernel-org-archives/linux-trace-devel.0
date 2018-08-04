Return-Path: <SRS0=Pvu4=KT=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:39046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbeHDE03 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 4 Aug 2018 00:26:29 -0400
Date: Fri, 3 Aug 2018 22:27:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 4/6] kernel-shark-qt: Define Data collections
Message-ID: <20180803222731.4e47e97f@vmware.local.home>
In-Reply-To: <20180803142937.3970-5-y.karadz@gmail.com>
References: <20180803142937.3970-1-y.karadz@gmail.com>
        <20180803142937.3970-5-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri,  3 Aug 2018 17:29:35 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Data collections are used to optimize the search for an entry having
> an abstract property, defined by a Matching condition function and a
> value. When a collection is processed, the data which is relevant for
> the collection is enclosed in "Data intervals", defined by pairs of
> "Resume" and "Break" points. It is guaranteed that the data outside of
> the intervals contains no entries satisfying the abstract matching
> condition. Once defined, the Data collection can be used when searching
> for an entry having the same abstract property. The collection allows to
> ignore the irrelevant data, thus it eliminates the linear worst-case time
> complexity of the search.

I think you may need to explain you algorithm a bit more. That is, how
will it be used later. I have more questions below.

Does this mean the pairs of resume and break have only elements that
match a condition?

> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark-qt/src/CMakeLists.txt         |   3 +-
>  kernel-shark-qt/src/libkshark-collection.c | 805 +++++++++++++++++++++
>  kernel-shark-qt/src/libkshark.c            |  16 +
>  kernel-shark-qt/src/libkshark.h            |  79 ++
>  4 files changed, 902 insertions(+), 1 deletion(-)
>  create mode 100644 kernel-shark-qt/src/libkshark-collection.c
> 
> diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMakeLists.txt
> index ec22f63..cd42920 100644
> --- a/kernel-shark-qt/src/CMakeLists.txt
> +++ b/kernel-shark-qt/src/CMakeLists.txt
> @@ -2,7 +2,8 @@ message("\n src ...")
>  
>  message(STATUS "libkshark")
>  add_library(kshark SHARED libkshark.c
> -                          libkshark-model.c)
> +                          libkshark-model.c
> +                          libkshark-collection.c)
>  
>  target_link_libraries(kshark ${CMAKE_DL_LIBS}
>                               ${TRACEEVENT_LIBRARY}
> diff --git a/kernel-shark-qt/src/libkshark-collection.c b/kernel-shark-qt/src/libkshark-collection.c
> new file mode 100644
> index 0000000..d08b8db
> --- /dev/null
> +++ b/kernel-shark-qt/src/libkshark-collection.c
> @@ -0,0 +1,805 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> + /**
> +  *  @file    libkshark-collection.c
> +  *  @brief   Data Collections.
> +  */
> +
> +//C
> +#include <stdbool.h>
> +#include <stdlib.h>
> +#include <assert.h>
> +
> +// KernelShark
> +#include "libkshark.h"
> +
> +/* Quiet warnings over documenting simple structures */
> +//! @cond Doxygen_Suppress
> +
> +enum collection_point_type {
> +	COLLECTION_IGNORE = 0,
> +	COLLECTION_RESUME,
> +	COLLECTION_BREAK,
> +};
> +
> +#define LAST_BIN	-3
> +
> +struct entry_list {
> +	struct entry_list	*next;
> +	size_t			index;
> +	uint8_t			type;
> +};
> +
> +
> +enum map_flags {
> +	COLLECTION_BEFORE = -1,
> +	COLLECTION_INSIDE = 0,
> +	COLLECTION_AFTER = 1,
> +};
> +
> +//! @endcond
> +
> +static bool collection_add_entry(struct entry_list **list,
> +				 size_t i, uint8_t type)
> +{
> +	struct entry_list *entry = *list;
> +
> +	if (entry->type != COLLECTION_IGNORE) {
> +		entry->next = malloc(sizeof(*entry));
> +		if (!entry->next)
> +			return false;
> +
> +		entry = entry->next;
> +		*list = entry;
> +	}
> +
> +	entry->index = i;
> +	entry->type = type;

This is an interesting "add to list" function. It basically is an
update if type is IGNORE, otherwise add a new element. May want a
comment before the function about what this is doing because it is not
a normal "add to list" type of function.

> +
> +	return true;
> +}
> +
> +static struct kshark_entry_collection *
> +kshark_data_collection_alloc(struct kshark_context *kshark_ctx,
> +			     struct kshark_entry **data,
> +			     size_t first,
> +			     size_t n_rows,
> +			     matching_condition_func cond,
> +			     int val,
> +			     size_t margin)

What exactly is margin used for?

> +{
> +	struct kshark_entry_collection *col_ptr = NULL;
> +	struct kshark_entry *last_vis_entry = NULL;
> +	struct entry_list *col_list, *temp;
> +	size_t resume_count = 0, break_count = 0;
> +	size_t i, j, end, last_added = 0;
> +	bool good_data = false;
> +
> +	col_list = malloc(sizeof(*col_list));
> +	if (!col_list)
> +		goto fail;
> +
> +	temp = col_list;
> +
> +	if (margin != 0) {
> +		/*
> +		 * If this collection includes margin data, add a margin data
> +		 * interval at the very beginning of the data-set.
> +		 */
> +		temp->index = first;
> +		temp->type = COLLECTION_RESUME;
> +		++resume_count;
> +
> +		collection_add_entry(&temp, first + margin - 1,
> +				     COLLECTION_BREAK);
> +		++break_count;
> +	} else {
> +		temp->type = COLLECTION_IGNORE;
> +	}
> +
> +	end = first + n_rows - margin;
> +	for (i = first + margin; i < end; ++i) {

So margin just ignores the first part and last part of the data?

> +		if (!cond(kshark_ctx, data[i], val)) {
> +			/*
> +			 * The entry is irrelevant for this collection.
> +			 * Do nothing.
> +			 */
> +			continue;
> +		}
> +
> +		/* The Matching condition is satisfed. */
> +		if (!good_data) {
> +			/*
> +			 * Resume the collection here. Add some margin data
> +			 * in front of the data of interest.
> +			 */
> +			good_data = true;
> +			if (last_added == 0 || last_added < i - margin) {
> +				collection_add_entry(&temp, i - margin,

OK, I'm confused at exactly what role margin is playing here. Why do we
ignore data if it is not within  a given margin?

> +						 COLLECTION_RESUME);
> +				++resume_count;
> +			} else {
> +				/*
> +				 * Ignore the last collection Brack point.

"Brack point"? do you mean Break point?

> +				 * Continue extending the previous data
> +				 * interval.
> +				 */
> +				temp->type = COLLECTION_IGNORE;
> +				--break_count;
> +			}
> +		} else if (good_data &&
> +			   data[i]->next &&
> +			   !cond(kshark_ctx, data[i]->next, val)) {
> +			/*
> +			 * Brack the collection here. Add some margin data

 Brack again?

> +			 * after the data of interest.
> +			 */
> +			good_data = false;
> +			last_vis_entry = data[i];
> +
> +			/* Keep adding entries until the "next" record. */
> +			for (j = i + 1;
> +			     j != end && last_vis_entry->next != data[j];
> +			     j++)
> +				;
> +
> +			/*
> +			 * If the number of added entryes is smaller then the

					"entries"   "smaller than"


> +			 * number of margin entries requested, keep adding
> +			 * until you fill the margin.
> +			 */
> +			if (i + margin < j)
> +				i = j;
> +			else
> +				i += margin;
> +
> +			last_added = i;
> +			collection_add_entry(&temp, i, COLLECTION_BREAK);
> +			++break_count;
> +		}
> +	}
> +
> +	if (good_data) {
> +		collection_add_entry(&temp, end - 1, COLLECTION_BREAK);
> +		++break_count;
> +	}
> +
> +	if (margin != 0) {
> +		/*
> +		 * If this collection includes margin data, add a margin data
> +		 * interval at the very end of the data-set.
> +		 */
> +		collection_add_entry(&temp, first + n_rows - margin,
> +				 COLLECTION_RESUME);
> +		++resume_count;
> +
> +		collection_add_entry(&temp, first + n_rows - 1,
> +				 COLLECTION_BREAK);
> +		++break_count;
> +	}
> +
> +	/*
> +	 * If everything is OK, we must have pairs of COLLECTION_RESUME
> +	 * and COLLECTION_BREAK points.
> +	 */
> +	assert(break_count == resume_count);
> +
> +	/* Create the collection. */
> +	col_ptr = malloc(sizeof(*col_ptr));
> +	if (!col_ptr)
> +		goto fail;
> +
> +	col_ptr->next = NULL;
> +
> +	col_ptr->resume_points = calloc(resume_count,
> +					sizeof(*col_ptr->resume_points));
> +	if (!col_ptr->resume_points)
> +		goto fail;
> +
> +	col_ptr->break_points = calloc(break_count,
> +				       sizeof(*col_ptr->break_points));
> +	if (!col_ptr->break_points) {
> +		free(col_ptr->resume_points);
> +		goto fail;
> +	}
> +
> +	col_ptr->cond = cond;
> +	col_ptr->val = val;
> +
> +	col_ptr->size = resume_count;
> +	for (i = 0; i < col_ptr->size; ++i) {
> +		assert(col_list->type == COLLECTION_RESUME);
> +		col_ptr->resume_points[i] = col_list->index;
> +		temp = col_list;
> +		col_list = col_list->next;
> +		free(temp);
> +
> +		assert(col_list->type == COLLECTION_BREAK);
> +		col_ptr->break_points[i] = col_list->index;
> +		temp = col_list;
> +		col_list = col_list->next;
> +		free(temp);
> +	}
> +
> +	return col_ptr;
> +
> +fail:
> +	fprintf(stderr, "Failed to allocate memory for Data collection.\n");
> +
> +	free(col_ptr);
> +	for (i = 0; i < resume_count + break_count; ++i) {
> +		temp = col_list;
> +		col_list = col_list->next;
> +		free(temp);
> +	}
> +
> +	return NULL;
> +}
> +
> +/*
> + * This function provides mapping between the index inside the data-set and
> + * the index of the collection interval. Additional output flag is used to
> + * resolve the ambiguity of the mapping. If the value of the flag is
> + * COLLECTION_INSIDE, the "source_index" is inside the returned interval. If
> + * the value of the flag is COLLECTION_BEFORE, the "source_index" is inside
> + * the gap before the returned interval. If the value of the flag is
> + * COLLECTION_AFTER, the "source_index" is inside the gap after the returned
> + * interval.
> + */
> +static ssize_t
> +map_collection_index_from_source(const struct kshark_entry_collection *col,
> +				 size_t source_index, int *flag)
> +{
> +	size_t l, h, mid;
> +
> +	if (!col->size)
> +		return KS_EMPTY_BIN;
> +
> +	l = 0;
> +	h = col->size - 1;
> +
> +	if (source_index < col->resume_points[l]) {
> +		*flag = COLLECTION_BEFORE;
> +		return l;
> +	}
> +
> +	if (source_index >= col->resume_points[h]) {
> +		if (source_index < col->break_points[h])
> +			*flag = COLLECTION_INSIDE;
> +		else
> +			*flag = COLLECTION_AFTER;
> +
> +		return h;
> +	}
> +
> +	BSEARCH(h, l, source_index > col->resume_points[mid]);
> +
> +	if (source_index <= col->break_points[l])
> +		*flag = COLLECTION_INSIDE;
> +	else
> +		*flag = COLLECTION_AFTER;
> +
> +	return l;
> +}
> +
> +/*
> + * This finction uses the intervals of the Data collection to transform the

 "function"

> + * inputted single data request into a list of data requests. The new list of
> + * request will ignore the data outside of the intervals of the collection.

 "requests"

> + */
> +static int
> +map_collection_back_request(const struct kshark_entry_collection *col,
> +			    struct kshark_entry_request **req)
> +{
> +	struct kshark_entry_request *req_tmp = *req;
> +	int req_count, col_index_flag;
> +	size_t req_first, req_end;
> +	ssize_t col_index;
> +
> +	if (req_tmp->next || col->size == 0) {
> +		fprintf(stderr, "Unexpected input in ");
> +		fprintf(stderr, "map_collection_front_request()\n");
> +		goto do_nothing;
> +	}
> +
> +	req_end = req_tmp->first - req_tmp->n + 1;

Perhaps we should add a comment that states that ->first is the last
index of the array, and end is actually the first.

> +
> +	/*
> +	 * Find the first Resume Point of the collection which is equal or
> +	 * greater than the first index of this request.
> +	 */
> +	col_index = map_collection_index_from_source(col,
> +						     req_tmp->first,
> +						     &col_index_flag);
> +
> +	/*
> +	 * The value of "col_index" is ambiguous. Use the "col_index_flag" to
> +	 * deal with all possible cases.
> +	 */
> +	if (col_index == KS_EMPTY_BIN) {
> +		/* Empty collection. */
> +		goto do_nothing;
> +	}
> +
> +	if (col_index_flag == COLLECTION_AFTER) {
> +		/*
> +		 * This request starts after the end of interval "col_index".
> +		 */
> +		if (req_end > col->break_points[col_index]) {
> +			/*
> +			 * No overlap between the request and the collection.
> +			 * Do nothing.
> +			 */
> +			goto do_nothing;
> +		}
> +
> +		req_tmp->first = col->break_points[col_index];
> +	}
> +
> +	if (col_index_flag == COLLECTION_BEFORE) {
> +		/*
> +		 * This request starts before the beginning of interval
> +		 * "col_index".
> +		 */
> +		if (col_index == 0 ||
> +		    req_end > col->break_points[col_index - 1]) {
> +			/*
> +			 * No overlap between the request and the collection.
> +			 * Do nothing.
> +			 */
> +			goto do_nothing;
> +		}
> +
> +		req_tmp->first = col->break_points[col_index--];
> +	}
> +
> +	/*
> +	 * Now loop over the intervals of the collection going backwords till
> +	 * the end of the inputted request and create a separate request for
> +	 * each of those interest.
> +	 */
> +	req_count = 1;
> +	while (col_index >= 0 && req_end <= col->break_points[col_index]) {
> +		if (req_end >= col->resume_points[col_index]) {
> +			/*
> +			 * The last entry of the original request is inside
> +			 * the "col_index" collection interval. Close the
> +			 * collection request here and return.
> +			 */
> +			req_tmp->n = req_tmp->first - req_end + 1;
> +			break;
> +		}
> +
> +		/*
> +		 * The last entry of the original request is outside of the
> +		 * "col_index" interval. Close the collection request at the
> +		 * end of this interval and move to the next one. Try to make
> +		 * another request there.
> +		 */
> +		req_tmp->n = req_tmp->first -
> +		             col->resume_points[col_index] + 1;
> +
> +		--col_index;
> +
> +		if (req_end > col->break_points[col_index]) {
> +			/*
> +			 * The last entry of the original request comes before
> +			 * the next collection interval. Stop here.
> +			 */
> +			break;
> +		}
> +
> +		if (col_index > 0) {
> +			/* Make a new request. */
> +			req_first = col->break_points[col_index];
> +
> +			req_tmp->next =
> +				kshark_entry_request_alloc(req_first,
> +							   0,
> +							   req_tmp->cond,
> +							   req_tmp->val,
> +							   req_tmp->vis_only,
> +							   req_tmp->vis_mask);
> +
> +			req_tmp = req_tmp->next;

Need to test if req_tmp is allocated (kshark_entry_request_alloc could
fail).

> +			++req_count;
> +		}
> +	}
> +
> +	return req_count;
> +
> +do_nothing:
> +	kshark_free_entry_request(*req);
> +	*req = NULL;
> +	return 0;
> +}
> +
> +/*
> + * This finction uses the intervals of the Data collection to transform the

	"function"

> + * inputted single data request into a list of data requests. The new list of
> + * request will ignore the data outside of the intervals of the collection.
> + */
> +static int
> +map_collection_front_request(const struct kshark_entry_collection *col,
> +			     struct kshark_entry_request **req)
> +{
> +	struct kshark_entry_request *req_tmp = *req;
> +	int req_count, col_index_flag;
> +	size_t req_first, req_end;
> +	ssize_t col_index;
> +
> +	if (req_tmp->next || col->size == 0) {
> +		fprintf(stderr, "Unexpected input in ");
> +		fprintf(stderr, "map_collection_front_request()\n");
> +		goto do_nothing;
> +	}
> +
> +	req_end = req_tmp->first + req_tmp->n - 1;
> +
> +	/*
> +	 * Find the first Resume Point of the collection which is equal or
> +	 * greater than the first index of this request.
> +	 */
> +	col_index = map_collection_index_from_source(col,
> +						     req_tmp->first,
> +						     &col_index_flag);
> +
> +	/*
> +	 * The value of "col_index" is ambiguous. Use the "col_index_flag" to
> +	 * deal with all possible cases.
> +	 */
> +	if (col_index == KS_EMPTY_BIN) {
> +		/* Empty collection. */
> +		goto do_nothing;
> +	}
> +
> +	if (col_index_flag == COLLECTION_AFTER) {
> +		/*
> +		 * This request starts after the end of interval "col_index".
> +		 */
> +		if (col_index == col->size - 1 ||
> +		    req_end < col->resume_points[col_index + 1]) {
> +			/*
> +			 * No overlap between the request and the collection.
> +			 * Do nothing.
> +			 */
> +			goto do_nothing;
> +		}
> +
> +		req_tmp->first = col->resume_points[col_index++];
> +	}
> +
> +	if (col_index_flag == COLLECTION_BEFORE) {
> +		/*
> +		 * This request starts before the beginning of interval
> +		 * "col_index".
> +		 */
> +		if (req_end < col->resume_points[col_index]) {
> +			/*
> +			 * No overlap between the request and the collection.
> +			 * Do nothing.
> +			 */
> +			goto do_nothing;
> +		}
> +
> +		req_tmp->first = col->resume_points[col_index];
> +	}
> +
> +	/*
> +	 * Now loop over the intervals of the collection going forwards till
> +	 * the end of the inputted request and create a separate request for
> +	 * each of those interest.
> +	 */
> +	req_count = 1;
> +	while (col_index < col->size &&
> +	       req_end >= col->resume_points[col_index]) {
> +		if (req_end <= col->break_points[col_index]) {
> +			/*
> +			 * The last entry of the original request is inside
> +			 * the "col_index" collection interval.
> +			 * Close the collection request here and return.
> +			 */
> +			req_tmp->n = req_end - req_tmp->first + 1;
> +			break;
> +		}
> +
> +		/*
> +		 * The last entry of the original request is outside this
> +		 * collection interval (col_index). Close the collection
> +		 * request at the end of the interval and move to the next
> +		 * interval. Try to make another request there.
> +		 */
> +		req_tmp->n = col->break_points[col_index] -
> +			     req_tmp->first + 1;
> +
> +		++col_index;
> +
> +		if (req_end < col->resume_points[col_index]) {
> +			/*
> +			 * The last entry of the original request comes before
> +			 * the beginning of next collection interval. Stop here.
> +			 */
> +			break;
> +		}
> +
> +		if (col_index < col->size) {
> +			/* Make a new request. */
> +			req_first = col->resume_points[col_index];
> +
> +			req_tmp->next =
> +				kshark_entry_request_alloc(req_first,
> +							   0,
> +							   req_tmp->cond,
> +							   req_tmp->val,
> +							   req_tmp->vis_only,
> +							   req_tmp->vis_mask);
> +
> +			req_tmp = req_tmp->next;
> +			++req_count;
> +		}
> +	}
> +
> +	return req_count;
> +
> +do_nothing:
> +	kshark_free_entry_request(*req);
> +	*req = NULL;
> +	return 0;
> +}
> +

You know what I'm going to suggest ;-)  Can we combine the front and
back versions of the above functions into a single routine with
parameters that decide the difference ?

> +/**
> + * @brief Search for an entry satisfying the requirements of a given Data
> + *	  request. Start from the position provided by the request and go
> + *	  searching in the direction of the increasing timestamps (front).
> + *	  The search is performed only inside the intervals, defined by
> + *	  the data collection.
> + *
> + * @param req: Input location for a single Data request. The imputed request

								"inputted"

> + *	       will be transformed into a list of requests. This new list of
> + *	       requests will ignore the data outside of the intervals of the
> + *	       collection.
> + * @param data: Intput location for the trace data.

		"Input"

> + * @param col: Intput location for the Data collection.

		"Input"

> + * @param index: Optional output location for the index of the returned
> + *		 entry inside the array.
> + *
> + * @returns Pointer to the first entry satisfying the matching condition on
> + *	    success, or NULL on failure.
> + *	    In the special case when some entries, satisfying the Matching
> + *	    condition function have been found, but all these entries have
> + *	    been discarded because of the visibility criteria (filtered
> + *	    entries), the function returns a pointer to a special
> + *	    "Dummy entry".
> + */
> +const struct kshark_entry *
> +kshark_get_collection_entry_front(struct kshark_entry_request **req,
> +				  struct kshark_entry **data,
> +				  const struct kshark_entry_collection *col,
> +				  ssize_t *index)
> +{
> +	const struct kshark_entry *entry = NULL;
> +	int req_count;
> +
> +	/*
> +	 * Use the intervals of the Data collection to redefine the data
> +	 * request in a way which will ignore the data outside of the
> +	 * intervals of the collection.
> +	 */
> +	req_count = map_collection_front_request(col, req);
> +
> +	if (index && !req_count)
> +		*index = KS_EMPTY_BIN;
> +
> +	/*
> +	 * Loop over the list of redefined requests and search until you find
> +	 * the first matching entry.
> +	 */
> +	while (*req) {
> +		entry = kshark_get_entry_front(*req, data, index);
> +		if (entry)
> +			break;
> +
> +		*req = (*req)->next;
> +	}
> +
> +	return entry;
> +}
> +
> +/**
> + * @brief Search for an entry satisfying the requirements of a given Data
> + *	  request. Start from the position provided by the request and go
> + *	  searching in the direction of the decreasing timestamps (back).
> + *	  The search is performed only inside the intervals, defined by
> + *	  the data collection.
> + *
> + * @param req: Input location for Data request. The imputed request
> + *	       will be transformed into a list of requests. This new list of
> + *	       requests will ignore the data outside of the intervals of the
> + *	       collection.
> + * @param data: Intput location for the trace data.

		"Input"

> + * @param col: Intput location for the Data collection.

		"Input"

> + * @param index: Optional output location for the index of the returned
> + *		 entry inside the array.
> + *
> + * @returns Pointer to the first entry satisfying the matching condition on
> + *	    success, or NULL on failure.
> + *	    In the special case when some entries, satisfying the Matching
> + *	    condition function have been found, but all these entries have
> + *	    been discarded because of the visibility criteria (filtered
> + *	    entries), the function returns a pointer to a special
> + *	    "Dummy entry".
> + */
> +const struct kshark_entry *
> +kshark_get_collection_entry_back(struct kshark_entry_request **req,
> +				 struct kshark_entry **data,
> +				 const struct kshark_entry_collection *col,
> +				 ssize_t *index)
> +{
> +	const struct kshark_entry *entry = NULL;
> +	int req_count;
> +
> +	/*
> +	 * Use the intervals of the Data collection to redefine the data
> +	 * request in a way which will ignore the data outside of the
> +	 * intervals of the collection.
> +	 */
> +	req_count = map_collection_back_request(col, req);
> +	if (index && !req_count)
> +		*index = KS_EMPTY_BIN;
> +
> +	/*
> +	 * Loop over the list of redefined requests and search until you find
> +	 * the first matching entry.
> +	 */
> +	while (*req) {
> +		entry = kshark_get_entry_back(*req, data, index);
> +		if (entry)
> +			break;
> +
> +		*req = (*req)->next;
> +	}
> +
> +	return entry;
> +}
> +
> +/**
> + * @brief Search the list of Data collections and find the collection defined
> + *	  with a given Matching condition function and value.
> + *
> + * @param col: Intput location for the Data collection list.

		"Input"

> + * @param cond: Matching condition function.
> + * @param val: Matching condition value, used by the Matching condition
> + *	       function.
> + *
> + * @returns Pointer to a Data collections on success, or NULL on failure.
> + */
> +struct kshark_entry_collection *
> +kshark_find_data_collection(struct kshark_entry_collection *col,
> +			    matching_condition_func cond,
> +			    int val)
> +{
> +	while (col) {
> +		if (col->cond == cond && col->val == val)
> +			return col;
> +
> +		col = col->next;
> +	}
> +
> +	return NULL;
> +}
> +
> +/**
> + * @brief Clear all data intervals of the given Data collection.
> + *
> + * @param col: Intput location for the Data collection.

		"Input"

> + */
> +void kshark_reset_data_collection(struct kshark_entry_collection *col)
> +{
> +	free(col->resume_points);
> +	col->resume_points = NULL;
> +
> +	free(col->break_points);
> +	col->break_points = NULL;
> +
> +	col->size = 0;
> +}
> +
> +static void kshark_free_data_collection(struct kshark_entry_collection *col)
> +{
> +	free(col->resume_points);
> +	free(col->break_points);
> +	free(col);
> +}
> +

OK, the rest looks good!

-- Steve

> 
