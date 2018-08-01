Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:43144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbeHAUbW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Aug 2018 16:31:22 -0400
Date: Wed, 1 Aug 2018 14:44:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH v2 3/7] kernel-shark-qt: Introduce the visualization
 model used by the Qt-based KS
Message-ID: <20180801144413.227e0dea@gandalf.local.home>
In-Reply-To: <20180731135248.30587-4-y.karadz@gmail.com>
References: <20180731135248.30587-1-y.karadz@gmail.com>
        <20180731135248.30587-4-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 31 Jul 2018 16:52:44 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> +/**
> + * @brief Get the index of the first entry in a given bin.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @returns Index of the first entry in this bin. If the bin is empty the
> + *	    function returns negative error identifier (KS_EMPTY_BIN).
> + */
> +ssize_t ksmodel_first_index_at_bin(struct kshark_trace_histo *histo, int bin)
> +{
> +	if (bin >= 0 && bin < (int) histo->n_bins)
> +		return histo->map[bin];
> +
> +	if (bin == UPPER_OVERFLOW_BIN)
> +		return histo->map[histo->n_bins];

		return histo->map[UOB(histo)];

> +
> +	if (bin == LOWER_OVERFLOW_BIN)
> +		return histo->map[histo->n_bins + 1];

		return histo->map[LOB(histo)];

> +
> +	return KS_EMPTY_BIN;
> +}
> +
> +/**
> + * @brief Get the index of the last entry in a given bin.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @returns Index of the last entry in this bin. If the bin is empty the
> + *	    function returns negative error identifier (KS_EMPTY_BIN).
> + */
> +ssize_t ksmodel_last_index_at_bin(struct kshark_trace_histo *histo, int bin)
> +{
> +	ssize_t index = ksmodel_first_index_at_bin(histo, bin);
> +	size_t count = ksmodel_bin_count(histo, bin);
> +
> +	if (index >= 0 && count)
> +		index += count - 1;
> +
> +	return index;
> +}
> +
> +static bool ksmodel_is_visible(struct kshark_entry *e)
> +{
> +	if ((e->visible & KS_GRAPH_VIEW_FILTER_MASK) &&
> +	    (e->visible & KS_EVENT_VIEW_FILTER_MASK))
> +		return true;
> +
> +	return false;
> +}
> +
> +static struct kshark_entry_request *
> +ksmodel_entry_front_request_alloc(struct kshark_trace_histo *histo,
> +				  int bin, bool vis_only,
> +				  matching_condition_func func, int val)
> +{
> +	struct kshark_entry_request *req;
> +	size_t first, n;
> +
> +	/* Get the number of entries in this bin. */
> +	n = ksmodel_bin_count(histo, bin);
> +	if (!n)
> +		return NULL;
> +
> +	first = ksmodel_first_index_at_bin(histo, bin);
> +
> +	req = kshark_entry_request_alloc(first, n,
> +					 func, val,
> +					 vis_only, KS_GRAPH_VIEW_FILTER_MASK);

No need for req; just return the function:

	return kshark_entry_request_alloc(...);

> +
> +	return req;
> +}
> +
> +static struct kshark_entry_request *
> +ksmodel_entry_back_request_alloc(struct kshark_trace_histo *histo,
> +				 int bin, bool vis_only,
> +				 matching_condition_func func, int val)
> +{
> +	struct kshark_entry_request *req;
> +	size_t first, n;
> +
> +	/* Get the number of entries in this bin. */
> +	n = ksmodel_bin_count(histo, bin);
> +	if (!n)
> +		return NULL;
> +
> +	first = ksmodel_last_index_at_bin(histo, bin);
> +
> +	req = kshark_entry_request_alloc(first, n,
> +					 func, val,
> +					 vis_only, KS_GRAPH_VIEW_FILTER_MASK);

Same here.

> +
> +	return req;
> +}
> +
> +/**
> + * @brief Get the index of the first entry from a given Cpu in a given bin.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @param cpu: Cpu Id.
> + * @returns Index of the first entry from a given Cpu in this bin.
> + */
> +ssize_t ksmodel_first_index_at_cpu(struct kshark_trace_histo *histo,
> +				   int bin, int cpu)
> +{
> +	size_t i, n, first, not_found = KS_EMPTY_BIN;
> +
> +	n = ksmodel_bin_count(histo, bin);
> +	if (!n)
> +		return not_found;
> +
> +	first = ksmodel_first_index_at_bin(histo, bin);

I wonder what this is used for. Don't we have per cpu arrays or link
lists?

> +
> +	for (i = first; i < first + n; ++i) {
> +		if (histo->data[i]->cpu == cpu) {
> +			if (ksmodel_is_visible(histo->data[i]))
> +				return i;
> +			else
> +				not_found = KS_FILTERED_BIN;
> +		}
> +	}
> +
> +	return not_found;
> +}
> +
> +/**
> + * @brief Get the index of the first entry from a given Task in a given bin.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @param pid: Process Id of a task.
> + * @returns Index of the first entry from a given Task in this bin.
> + */
> +ssize_t ksmodel_first_index_at_pid(struct kshark_trace_histo *histo,
> +				   int bin, int pid)
> +{
> +	size_t i, n, first, not_found = KS_EMPTY_BIN;
> +
> +	n = ksmodel_bin_count(histo, bin);
> +	if (!n)
> +		return not_found;
> +
> +	first = ksmodel_first_index_at_bin(histo, bin);
> +	
> +	for (i = first; i < first + n; ++i) {
> +		if (histo->data[i]->pid == pid) {
> +			if (ksmodel_is_visible(histo->data[i]))
> +				return i;
> +			else
> +				not_found = KS_FILTERED_BIN;
> +		}
> +	}
> +
> +	return not_found;
> +}
> +
> +/**
> + * @brief In a given bin, start from the front end of the bin and go towards
> + *	  the back end, searching for an entry satisfying the Matching
> + *	  condition defined by a Matching condition function.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @param vis_only: If true, a visible entry is requested.
> + * @param func: Matching condition function.
> + * @param val: Matching condition value, used by the Matching condition
> + *	       function.
> + * @param index: Optional output location for the index of the requested
> + *		 entry inside the array.
> + * @returns Pointer ot a kshark_entry, if an entry has been found. Else NULL.
> + */
> +const struct kshark_entry *
> +ksmodel_get_entry_front(struct kshark_trace_histo *histo,
> +			int bin, bool vis_only,
> +			matching_condition_func func, int val,
> +			ssize_t *index)
> +{
> +	struct kshark_entry_request *req;
> +	const struct kshark_entry *entry;
> +
> +	if (index)
> +		*index = KS_EMPTY_BIN;
> +
> +	/* Set the position at the beginning of the bin and go forward. */
> +	req = ksmodel_entry_front_request_alloc(histo, bin, vis_only,
> +							    func, val);
> +	if (!req)
> +		return NULL;
> +
> +	entry = kshark_get_entry_front(req, histo->data, index);
> +	free(req);
> +
> +	return entry;
> +}

We could save on the allocation if we were to create the following:

void
kshark_entry_request_set(struct kshark_entry_request *req,
			 size_t first, size_t n,
			 matching_condition_func cond, int val,
			 bool vis_only, int vis_mask)
{
	req->first = first;
	req->n = n;
	req->cond = cond;
	req->val = val;
	req->vis_only = vis_only;
	req->vis_mask = vis_mask;
}

bool
ksmodel_entry_front_request_set(struct kshark_trace_histo *histo,
				struct kshark_entry_request *req,
				int bin, bool vis_only,
				matching_condition_func func, int val)
{
	size_t first, n;

	/* Get the number of entries in this bin. */
	n = ksmodel_bin_count(histo, bin);
	if (!n)
		return false;

	first = ksmodel_first_index_at_bin(histo, bin);

	kshark_entry_request_set(first, n,
			       func, val,
			       vis_only, KS_GRAPH_VIEW_FILTER_MASK);

	return true;
}

const struct kshark_entry *
ksmodel_get_entry_front(struct kshark_trace_histo *histo,
			int bin, bool vis_only,
			matching_condition_func func, int val,
			ssize_t *index)
{
	struct kshark_entry_request req;
	const struct kshark_entry *entry;
	bool ret;

	if (index)
		*index = KS_EMPTY_BIN;

	/* Set the position at the beginning of the bin and go forward. */
	ret = ksmodel_entry_front_request_set(histo, bin, vis_only,
							    func, val);
	if (!ret)
		return NULL;

	entry = kshark_get_entry_front(req, histo->data, index);

	return entry;
}

> +
> +/**
> + * @brief In a given bin, start from the back end of the bin and go towards
> + *	  the front end, searching for an entry satisfying the Matching
> + *	  condition defined by a Matching condition function.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @param vis_only: If true, a visible entry is requested.
> + * @param func: Matching condition function.
> + * @param val: Matching condition value, used by the Matching condition
> + *	       function.
> + * @param index: Optional output location for the index of the requested
> + *		 entry inside the array.
> + * @returns Pointer ot a kshark_entry, if an entry has been found. Else NULL.
> + */
> +const struct kshark_entry *
> +ksmodel_get_entry_back(struct kshark_trace_histo *histo,
> +		       int bin, bool vis_only,
> +		       matching_condition_func func, int val,
> +		       ssize_t *index)
> +{
> +	struct kshark_entry_request *req;
> +	const struct kshark_entry *entry;
> +
> +	if (index)
> +		*index = KS_EMPTY_BIN;
> +
> +	/* Set the position at the end of the bin and go backwards. */
> +	req = ksmodel_entry_back_request_alloc(histo, bin, vis_only,
> +							   func, val);
> +	if (!req)
> +		return NULL;
> +
> +	entry = kshark_get_entry_back(req, histo->data, index);
> +	free(req);

Ditto.


> +
> +	return entry;
> +}
> +
> +static int ksmodel_get_entry_pid(const struct kshark_entry *entry)
> +{
> +	if (!entry) {
> +		/* No data has been found. */
> +		return KS_EMPTY_BIN;
> +	}
> +
> +	/*
> +	 * Note that if some data has been found, but this data is
> +	 * filtered-outa, the Dummy entry is returned. The PID of the Dummy
> +	 * entry is KS_FILTERED_BIN.
> +	 */
> +
> +	return entry->pid;
> +}
> +
> +/**
> + * @brief In a given bin, start from the front end of the bin and go towards
> + *	  the back end, searching for an entry from a given CPU. Return
> + *	  the Process Id of the task of the entry found.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @param cpu: CPU Id.
> + * @param vis_only: If true, a visible entry is requested.
> + * @param index: Optional output location for the index of the requested
> + *		 entry inside the array.
> + * @returns Process Id of the task if an entry has been found. Else a negative
> + *	    Identifier (KS_EMPTY_BIN or KS_FILTERED_BIN).
> + */
> +int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
> +			  int bin, int cpu, bool vis_only,
> +			  ssize_t *index)
> +{
> +	const struct kshark_entry *entry;
> +
> +	if (cpu < 0)
> +		return KS_EMPTY_BIN;
> +
> +	entry = ksmodel_get_entry_front(histo, bin, vis_only,
> +					       kshark_match_cpu, cpu,
> +					       index);
> +	return ksmodel_get_entry_pid(entry);
> +}
> +
> +/**
> + * @brief In a given bin, start from the back end of the bin and go towards
> + *	  the front end, searching for an entry from a given CPU. Return
> + *	  the Process Id of the task of the entry found.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @param cpu: CPU Id.
> + * @param vis_only: If true, a visible entry is requested.
> + * @param index: Optional output location for the index of the requested
> + *		 entry inside the array.
> + * @returns Process Id of the task if an entry has been found. Else a negative
> + *	    Identifier (KS_EMPTY_BIN or KS_FILTERED_BIN).
> + */
> +int ksmodel_get_pid_back(struct kshark_trace_histo *histo,
> +			 int bin, int cpu, bool vis_only,
> +			 ssize_t *index)
> +{
> +	const struct kshark_entry *entry;
> +
> +	if (cpu < 0)
> +		return KS_EMPTY_BIN;
> +
> +	entry = ksmodel_get_entry_back(histo, bin, vis_only,
> +					      kshark_match_cpu, cpu,
> +					      index);
> +
> +	return ksmodel_get_entry_pid(entry);
> +}
> +
> +static int ksmodel_get_entry_cpu(const struct kshark_entry *entry)
> +{
> +	if (!entry) {
> +		/* No data has been found. */
> +		return KS_EMPTY_BIN;
> +	}
> +
> +	/*
> +	 * Note that if some data has been found, but this data is
> +	 * filtered-outa, the Dummy entry is returned. The CPU Id of the Dummy
> +	 * entry is KS_FILTERED_BIN.
> +	 */
> +
> +	return entry->cpu;
> +}
> +
> +/**
> + * @brief In a given bin, start from the front end of the bin and go towards
> + *	  the back end, searching for an entry from a given PID. Return
> + *	  the CPU Id of the entry found.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @param pid: Process Id.
> + * @param vis_only: If true, a visible entry is requested.
> + * @param index: Optional output location for the index of the requested
> + *		 entry inside the array.
> + * @returns Process Id of the task if an entry has been found. Else a negative
> + *	    Identifier (KS_EMPTY_BIN or KS_FILTERED_BIN).
> + */
> +int ksmodel_get_cpu_front(struct kshark_trace_histo *histo,
> +			  int bin, int pid, bool vis_only,
> +			  ssize_t *index)
> +{
> +	const struct kshark_entry *entry;
> +
> +	if (pid < 0)
> +		return KS_EMPTY_BIN;
> +
> +	entry = ksmodel_get_entry_front(histo, bin, vis_only,
> +					       kshark_match_pid, pid,
> +					       index);
> +	return ksmodel_get_entry_cpu(entry);
> +}
> +
> +/**
> + * @brief In a given bin, start from the back end of the bin and go towards
> + *	  the front end, searching for an entry from a given PID. Return
> + *	  the CPU Id of the entry found.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @param pid: Process Id.
> + * @param vis_only: If true, a visible entry is requested.
> + * @param index: Optional output location for the index of the requested
> + *		 entry inside the array.
> + * @returns Process Id of the task if an entry has been found. Else a negative
> + *	    Identifier (KS_EMPTY_BIN or KS_FILTERED_BIN).
> + */
> +int ksmodel_get_cpu_back(struct kshark_trace_histo *histo,
> +			 int bin, int pid, bool vis_only,
> +			 ssize_t *index)
> +{
> +	const struct kshark_entry *entry;
> +
> +	if (pid < 0)
> +		return KS_EMPTY_BIN;
> +
> +	entry = ksmodel_get_entry_back(histo, bin, vis_only,
> +					      kshark_match_pid, pid,
> +					      index);
> +
> +	return ksmodel_get_entry_cpu(entry);
> +}
> +
> +/**
> + * @brief Check if a visible trace event from a given Cpu exists in this bin.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @param cpu: Cpu Id.
> + * @param index: Optional output location for the index of the requested
> + *		 entry inside the array.
> + * @returns True, if a visible entry exists in this bin. Else false.
> + */
> +bool ksmodel_cpu_visible_event_exist(struct kshark_trace_histo *histo,
> +				     int bin, int cpu, ssize_t *index)
> +{
> +	struct kshark_entry_request *req;
> +	const struct kshark_entry *entry;
> +
> +	if (index)
> +		*index = KS_EMPTY_BIN;
> +
> +	/* Set the position at the beginning of the bin and go forward. */
> +	req = ksmodel_entry_front_request_alloc(histo,
> +						bin, true,
> +						kshark_match_cpu, cpu);

And would save an allocation here too.

> +	if (!req)
> +		return false;
> +
> +	/*
> +	 * The default visibility mask of the Model Data request is
> +	 * KS_GRAPH_VIEW_FILTER_MASK. Change the mask to
> +	 * KS_EVENT_VIEW_FILTER_MASK because we want to find a visible event.
> +	 */
> +	req->vis_mask = KS_EVENT_VIEW_FILTER_MASK;
> +
> +	entry = kshark_get_entry_front(req, histo->data, index);
> +	free(req);
> +
> +	if (!entry || !entry->visible) {
> +		/* No visible entry has been found. */
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +/**
> + * @brief Check if a visible trace event from a given Task exists in this bin.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @param pid: Process Id of the task.
> + * @param index: Optional output location for the index of the requested
> + *		 entry inside the array.
> + * @returns True, if a visible entry exists in this bin. Else false.
> + */
> +bool ksmodel_task_visible_event_exist(struct kshark_trace_histo *histo,
> +				      int bin, int pid, ssize_t *index)
> +{
> +	struct kshark_entry_request *req;
> +	const struct kshark_entry *entry;
> +
> +	if (index)
> +		*index = KS_EMPTY_BIN;
> +
> +	/* Set the position at the beginning of the bin and go forward. */
> +	req = ksmodel_entry_front_request_alloc(histo,
> +						bin, true,
> +						kshark_match_pid, pid);
> +	if (!req)
> +		return false;
> +
> +	/*
> +	 * The default visibility mask of the Model Data request is
> +	 * KS_GRAPH_VIEW_FILTER_MASK. Change the mask to
> +	 * KS_EVENT_VIEW_FILTER_MASK because we want to find a visible event.
> +	 */
> +	req->vis_mask = KS_EVENT_VIEW_FILTER_MASK;
> +
> +	entry = kshark_get_entry_front(req, histo->data, index);
> +	free(req);

And here.

-- Steve

> +
> +	if (!entry || !entry->visible) {
> +		/* No visible entry has been found. */
> +		return false;
> +	}
> +
> +	return true;
> +}
