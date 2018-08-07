Return-Path: <SRS0=pUA5=KW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:44930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389201AbeHGQPy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Aug 2018 12:15:54 -0400
Date: Tue, 7 Aug 2018 10:01:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 4/6] kernel-shark-qt: Define Data collections
Message-ID: <20180807100123.3386e116@gandalf.local.home>
In-Reply-To: <20180806161927.11206-5-y.karadz@gmail.com>
References: <20180806161927.11206-1-y.karadz@gmail.com>
        <20180806161927.11206-5-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon,  6 Aug 2018 19:19:25 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:


I like the combination of front and back.

> +static ssize_t
> +map_collection_request_init(const struct kshark_entry_collection *col,
> +			    struct kshark_entry_request **req,
> +			    bool front, size_t *end)
> +{
> +	struct kshark_entry_request *req_tmp = *req;
> +	int col_index_flag;
> +	ssize_t col_index;
> +	size_t req_end;
> +
> +	if (req_tmp->next || col->size == 0) {
> +		fprintf(stderr, "Unexpected input in ");
> +		fprintf(stderr, "map_collection_request_init()\n");
> +		goto do_nothing;
> +	}
> +
> +	req_end = front ? req_tmp->first + req_tmp->n - 1 :
> +			  req_tmp->first - req_tmp->n + 1;
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
> +		if (front && (col_index == col->size - 1 ||
> +			      req_end < col->resume_points[col_index + 1])) {
> +			/*
> +			 * No overlap between the collection and this front
> +			 * request. Do nothing.
> +			 */
> +			goto do_nothing;
> +		} else if (!front && req_end > col->break_points[col_index]) {
> +			/*
> +			 * No overlap between the collection and this back
> +			 * request. Do nothing.
> +			 */
> +			goto do_nothing;
> +		}
> +
> +		if (front)
> +			++col_index;
> +
> +		req_tmp->first = front ? col->resume_points[col_index] :
> +					 col->break_points[col_index];

Couple of things. First you could remove the if (front) and do:

	req_tmp->first = front ? col->resume_points[++col_index] :
				 col->break_points[col_index];

	
> +	}
> +
> +	if (col_index_flag == COLLECTION_BEFORE) {
> +		/*
> +		 * This request starts before the beginning of interval
> +		 * "col_index".
> +		 */
> +		if (!front && (col_index == 0 ||
> +			       req_end > col->break_points[col_index - 1])) {
> +			/*
> +			 * No overlap between the collection and this back
> +			 * request. Do nothing.
> +			 */
> +			goto do_nothing;
> +		} else if (front && req_end < col->resume_points[col_index]) {
> +			/*
> +			 * No overlap between the collection and this front
> +			 * request. Do nothing.
> +			 */
> +			goto do_nothing;
> +		}
> +
> +		if (!front)
> +			--col_index;
> +
> +		req_tmp->first = front ? col->resume_points[col_index] :
> +					 col->break_points[col_index];

And here have:

	req_tmp->first = front ? col->resume_points[col_index] :
				 col->break_points[++col_index];

-- Steve

> +	}
> +
> +	*end = req_end;
> +
> +	return col_index;
> +
> +do_nothing:
> +	kshark_free_entry_request(*req);
> +	*req = NULL;
> +	*end = KS_EMPTY_BIN;
> +
> +	return KS_EMPTY_BIN;
> +}
> +
> +/*
> + * This function uses the intervals of the Data collection to transform the
> + * inputted single data request into a list of data requests. The new list of
> + * request will ignore the data outside of the intervals of the collection.
> + */
> +static int
> +map_collection_back_request(const struct kshark_entry_collection *col,
> +			    struct kshark_entry_request **req)
> +{
> +	struct kshark_entry_request *req_tmp;
> +	size_t req_first, req_end;
> +	ssize_t col_index;
> +	int req_count;
> +
> +	col_index = map_collection_request_init(col, req, false, &req_end);
> +	if (col_index == KS_EMPTY_BIN)
> +		return 0;
> +
> +	/*
> +	 * Now loop over the intervals of the collection going backwords till
> +	 * the end of the inputted request and create a separate request for
> +	 * each of those interest.
> +	 */
> +	req_tmp = *req;
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
> +			 * the end of the next collection interval. Stop here.
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
> +			if (!req_tmp->next)
> +				goto fail;
> +
> +			req_tmp = req_tmp->next;
> +			++req_count;
> +		}
> +	}
> +
> +	return req_count;
> +
> +fail:
> +	fprintf(stderr, "Failed to allocate memory for ");
> +	fprintf(stderr, "Collection data request.\n");
> +	kshark_free_entry_request(*req);
> +	*req = NULL;
> +	return -ENOMEM;
> +}
> +
> +/*
> + * This function uses the intervals of the Data collection to transform the
> + * inputted single data request into a list of data requests. The new list of
> + * requests will ignore the data outside of the intervals of the collection.
> + */
> +static int
> +map_collection_front_request(const struct kshark_entry_collection *col,
> +			     struct kshark_entry_request **req)
> +{
> +	struct kshark_entry_request *req_tmp;
> +	size_t req_first, req_end;
> +	ssize_t col_index;
> +	int req_count;
> +
> +	col_index = map_collection_request_init(col, req, true, &req_end);
> +	if (col_index == KS_EMPTY_BIN)
> +		return 0;
> +
> +	/*
> +	 * Now loop over the intervals of the collection going forwards till
> +	 * the end of the inputted request and create a separate request for
> +	 * each of those interest.
> +	 */
> +	req_count = 1;
> +	req_tmp = *req;
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
> +			 * the beginning of next collection interval.
> +			 * Stop here.
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
> +			if (!req_tmp->next)
> +				goto fail;
> +
> +			req_tmp = req_tmp->next;
> +			++req_count;
> +		}
> +	}
> +
> +	return req_count;
> +
> +fail:
> +	fprintf(stderr, "Failed to allocate memory for ");
> +	fprintf(stderr, "Collection data request.\n");
> +	kshark_free_entry_request(*req);
> +	*req = NULL;
> +	return -ENOMEM;
> +}
> +
> +/**
> + * @brief Search for an entry satisfying the requirements of a given Data
> + *	  request. Start from the position provided by the request and go
> + *	  searching in the direction of the increasing timestamps (front).
> + *	  The search is performed only inside the intervals, defined by
> + *	  the data collection.
> + *
> + * @param req: Input location for a single Data request. The imputted request
> + *	       will be transformed into a list of requests. This new list of
> + *	       requests will ignore the data outside of the intervals of the
> + *	       collection.
> + * @param data: Input location for the trace data.
> + * @param col: Input location for the Data collection.
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
> + * @param data: Input location for the trace data.
> + * @param col: Input location for the Data collection.
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
> + * @param col: Input location for the Data collection list.
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
> + * @param col: Input location for the Data collection.
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
> +/**
> + * @brief Allocate and process data collection, defined with a given Matching
> + *	  condition function and value. Add this collection to the list of
> + *	  collections used by the session.
> + *
> + * @param kshark_ctx: Input location for the session context pointer.
> + * @param data: Input location for the trace data.
> + * @param n_rows: The size of the inputted data.
> + * @param cond: Matching condition function for the collection to be
> + *	        registered.
> + * @param val: Matching condition value of for collection to be registered.
> + * @param margin: The size of the additional (margin) data which do not
> + *		  satisfy the matching condition, but is added at the
> + *		  beginning and at the end of each interval of the collection
> + *		  as well as at the beginning and at the end of data-set. If
> + *		  "0", no margin data is added.
> + *
> + * @returns Pointer to the registered Data collections on success, or NULL
> + *	    on failure.
> + */
> +struct kshark_entry_collection *
> +kshark_register_data_collection(struct kshark_context *kshark_ctx,
> +				struct kshark_entry **data,
> +				size_t n_rows,
> +				matching_condition_func cond,
> +				int val,
> +				size_t margin)
> +{
> +	struct kshark_entry_collection *col;
> +
> +	col = kshark_data_collection_alloc(kshark_ctx, data,
> +					   0, n_rows,
> +					   cond, val,
> +					   margin);
> +
> +	if (col) {
> +		col->next = kshark_ctx->collections;
> +		kshark_ctx->collections = col;
> +	}
> +
> +	return col;
> +}
> +
> +/**
> + * @brief Search the list of Data collections for a collection defined
> + *	  with a given Matching condition function and value. If such a
> + *	  collection exists, unregister (remove and free) this collection
> + *	  from the list.
> + *
> + * @param col: Input location for the Data collection list.
> + * @param cond: Matching condition function of the collection to be
> + *	        unregistered.
> + *
> + * @param val: Matching condition value of the collection to be unregistered.
> + */
> +void kshark_unregister_data_collection(struct kshark_entry_collection **col,
> +				       matching_condition_func cond,
> +				       int val)
> +{
> +	struct kshark_entry_collection **last = col;
> +	struct kshark_entry_collection *list;
> +
> +	for (list = *col; list; list = list->next) {
> +		if (list->cond == cond && list->val == val) {
> +			*last = list->next;
> +			kshark_free_data_collection(list);
> +			return;
> +		}
> +
> +		last = &list->next;
> +	}
> +}
> +
> +/**
> + * @brief Free all Data collections in a given list.
> + *
> + * @param col: Input location for the Data collection list.
> + */
> +void kshark_free_collection_list(struct kshark_entry_collection *col)
> +{
> +	struct kshark_entry_collection *last;
> +
> +	while (col) {
> +		last = col;
> +		col = col->next;
> +		kshark_free_data_collection(last);
> +	}
> +}
> diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
> index 879946b..58287e9 100644
> --- a/kernel-shark-qt/src/libkshark.c
> +++ b/kernel-shark-qt/src/libkshark.c
> @@ -1067,6 +1067,7 @@ kshark_entry_request_alloc(size_t first, size_t n,
>  		return NULL;
>  	}
>  
> +	req->next = NULL;
>  	req->first = first;
>  	req->n = n;
>  	req->cond = cond;
> @@ -1077,6 +1078,21 @@ kshark_entry_request_alloc(size_t first, size_t n,
>  	return req;
>  }
>  
> +/**
> + * @brief Free all Data requests in a given list.
> + * @param req: Intput location for the Data request list.
> + */
> +void kshark_free_entry_request(struct kshark_entry_request *req)
> +{
> +	struct kshark_entry_request *last;
> +
> +	while (req) {
> +		last = req;
> +		req = req->next;
> +		free(last);
> +	}
> +}
> +
>  /** Dummy entry, used to indicate the existence of filtered entries. */
>  const struct kshark_entry dummy_entry = {
>  	.next		= NULL,
> diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
> index b0e1bc8..ff09da3 100644
> --- a/kernel-shark-qt/src/libkshark.h
> +++ b/kernel-shark-qt/src/libkshark.h
> @@ -115,6 +115,9 @@ struct kshark_context {
>  	 * the event.
>  	 */
>  	struct event_filter		*advanced_event_filter;
> +
> +	/** List of Data collections. */
> +	struct kshark_entry_collection *collections;
>  };
>  
>  bool kshark_instance(struct kshark_context **kshark_ctx);
> @@ -245,6 +248,9 @@ typedef bool (matching_condition_func)(struct kshark_context*,
>   * kshark_entry.
>   */
>  struct kshark_entry_request {
> +	/** Pointer to the next Data request. */
> +	struct kshark_entry_request *next;
> +
>  	/**
>  	 * Array index specifying the position inside the array from where
>  	 * the search starts.
> @@ -277,6 +283,8 @@ kshark_entry_request_alloc(size_t first, size_t n,
>  			   matching_condition_func cond, int val,
>  			   bool vis_only, int vis_mask);
>  
> +void kshark_free_entry_request(struct kshark_entry_request *req);
> +
>  const struct kshark_entry *
>  kshark_get_entry_front(const struct kshark_entry_request *req,
>  		       struct kshark_entry **data,
> @@ -287,6 +295,78 @@ kshark_get_entry_back(const struct kshark_entry_request *req,
>  		      struct kshark_entry **data,
>  		      ssize_t *index);
>  
> +/**
> + * Data collections are used to optimize the search for an entry having an
> + * abstract property, defined by a Matching condition function and a value.
> + * When a collection is processed, the data which is relevant for the
> + * collection is enclosed in "Data intervals", defined by pairs of "Resume" and
> + * "Break" points. It is guaranteed that the data outside of the intervals
> + * contains no entries satisfying the abstract matching condition. However, the
> + * intervals may (will) contain data that do not satisfy the matching condition.
> + * Once defined, the Data collection can be used when searching for an entry
> + * having the same (ore related) abstract property. The collection allows to
> + * ignore the irrelevant data, thus it eliminates the linear worst-case time
> + * complexity of the search.
> + */
> +struct kshark_entry_collection {
> +	/** Pointer to the next Data collection. */
> +	struct kshark_entry_collection *next;
> +
> +	/** Matching condition function, used to define the collections. */
> +	matching_condition_func *cond;
> +
> +	/**
> +	 * Matching condition value, used by the Matching condition finction
> +	 * to define the collections.
> +	 */
> +	int val;
> +
> +	/**
> +	 * Array of indexes defining the beginning of each individual data
> +	 * interval.
> +	 */
> +	size_t *resume_points;
> +
> +	/**
> +	 * Array of indexes defining the end of each individual data interval.
> +	 */
> +	size_t *break_points;
> +
> +	/** Number of data intervals in this collection. */
> +	size_t size;
> +};
> +
> +struct kshark_entry_collection *
> +kshark_register_data_collection(struct kshark_context *kshark_ctx,
> +				struct kshark_entry **data, size_t n_rows,
> +				matching_condition_func cond, int val,
> +				size_t margin);
> +
> +void kshark_unregister_data_collection(struct kshark_entry_collection **col,
> +				       matching_condition_func cond,
> +				       int val);
> +
> +struct kshark_entry_collection *
> +kshark_find_data_collection(struct kshark_entry_collection *col,
> +			    matching_condition_func cond,
> +			    int val);
> +
> +void kshark_reset_data_collection(struct kshark_entry_collection *col);
> +
> +void kshark_free_collection_list(struct kshark_entry_collection *col);
> +
> +const struct kshark_entry *
> +kshark_get_collection_entry_front(struct kshark_entry_request **req,
> +				  struct kshark_entry **data,
> +				  const struct kshark_entry_collection *col,
> +				  ssize_t *index);
> +
> +const struct kshark_entry *
> +kshark_get_collection_entry_back(struct kshark_entry_request **req,
> +				 struct kshark_entry **data,
> +				 const struct kshark_entry_collection *col,
> +				 ssize_t *index);
> +
>  #ifdef __cplusplus
>  }
>  #endif
