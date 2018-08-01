Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:36300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732901AbeHAD01 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 Jul 2018 23:26:27 -0400
Date: Tue, 31 Jul 2018 21:43:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] kernel-shark-qt: Introduce the visualization
 model used by the Qt-based KS
Message-ID: <20180731214319.060378be@gandalf.local.home>
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

> +static void ksmodel_set_next_bin_edge(struct kshark_trace_histo *histo,
> +				      size_t bin)
> +{
> +	size_t time, row, next_bin = bin + 1;
> +
> +	/* Calculate the beginning of the next bin. */
> +	time = histo->min + next_bin * histo->bin_size;
> +
> +	/*
> +	 * Find the index of the first entry inside
> +	 * the next bin (timestamp > time).
> +	 */
> +	row = kshark_find_entry_by_time(time, histo->data, 0,
> +					histo->data_size - 1);

Hmm, I see this used as this:

       for (bin = 0; bin < histo->n_bins; ++bin)
               ksmodel_set_next_bin_edge(histo, bin);

A lot. Thus we should be able to optimize this with:

static void ksmodel_set_next_bin_edge(struct kshark_trace_histo *histo,
				size_t bin, size_t *last_row)
{

	row = kshark_find_entry_by_time(time, histo->data, *last_row,
					histo->data_size - 1);

	*last_row = row;

And the caller can be:

	last_row = 0;
	for (bin = 0; bin < histo->n_bins; ++bin)
		ksmodel_set_next_bin_edge(histo, bin, &last_row);

Then we wont be doing the search from 0 each time. It should help speed
it up a little.

> +
> +	/*
> +	 * The timestamp of the very last entry of the dataset can be exactly
> +	 * equal to the value of the upper edge of the range. This is very
> +	 * likely to happen when we use ksmodel_set_in_range_bining(). In this
> +	 * case we have to increase the size of the very last bin in order to
> +	 * make sure that the last entry of the dataset will fall into it.
> +	 */
> +	if (next_bin == histo->n_bins - 1)
> +		++time;
> +
> +	if (histo->data[row]->ts >= time + histo->bin_size) {
> +		/* The bin is empty. */
> +		histo->map[next_bin] = KS_EMPTY_BIN;
> +		return;
> +	}
> +
> +	/* Set the index of the first entry. */
> +	histo->map[next_bin] = row;
> +}
> +


[..]

> +/**
> + * @brief Provide the Visualization model with data. Calculate the current
> + *	  state of the model.
> + * @param histo: Input location for the model descriptor.
> + * @param data: Input location for the trace data.
> + * @param n: Number of bins.
> + */
> +void ksmodel_fill(struct kshark_trace_histo *histo,
> +		  struct kshark_entry **data, size_t n)
> +{
> +	int bin;
> +
> +	histo->data_size = n;
> +	histo->data = data;
> +
> +	if (histo->n_bins == 0 ||
> +	    histo->bin_size == 0 ||
> +	    histo->data_size == 0) {
> +		/*
> +		 * Something is wrong with this histo.
> +		 * Most likely the binning is not set.
> +		 */
> +		ksmodel_clear(histo);
> +		fprintf(stderr,
> +			"Unable to fill the model with data.\n");
> +		fprintf(stderr,
> +			"Try to set the bining of the model first.\n");
> +
> +		return;
> +	}
> +
> +	/* Set the Lower Overflow bin */
> +	ksmodel_set_lower_edge(histo);
> +
> +	/*
> +	 * Loop over the dataset and set the beginning of all individual bins.
> +	 */
> +	bin = 0;

Superfluous bin assignment above.

> +	for (bin = 0; bin < histo->n_bins; ++bin)
> +		ksmodel_set_next_bin_edge(histo, bin);
> +
> +	/* Set the Upper Overflow bin. */
> +	ksmodel_set_upper_edge(histo);
> +
> +	/* Calculate the number of entries in each bin. */
> +	ksmodel_set_bin_counts(histo);
> +}
> +
> +/**
> + * @brief Get the total number of entries in a given bin.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @returns The number of entries in this bin.
> + */
> +size_t ksmodel_bin_count(struct kshark_trace_histo *histo, int bin)
> +{
> +	if (bin >= 0 && bin < histo->n_bins)
> +		return histo->bin_count[bin];
> +
> +	if (bin == UPPER_OVERFLOW_BIN)
> +		return histo->bin_count[UOB(histo)];
> +
> +	if (bin == LOWER_OVERFLOW_BIN)
> +		return histo->bin_count[LOB(histo)];
> +
> +	return 0;
> +}
> +
> +/**
> + * @brief Shift the time-window of the model forward. Recalculate the current
> + *	  state of the model.
> + * @param histo: Input location for the model descriptor.
> + * @param n: Number of bins to shift.
> + */
> +void ksmodel_shift_forward(struct kshark_trace_histo *histo, size_t n)
> +{
> +	int bin;
> +	
> +	if (!histo->data_size)
> +		return;
> +
> +	if (histo->bin_count[UOB(histo)] == 0) {
> +		/*
> +		 * The Upper Overflow bin is empty. This means that we are at
> +		 * the upper edge of the dataset already. Do nothing in this
> +		 * case.
> +		 */
> +		return;
> +	}
> +
> +	histo->min += n * histo->bin_size;
> +	histo->max += n * histo->bin_size;
> +
> +	if (n >= histo->n_bins) {
> +		/*
> +		 * No overlap between the new and the old ranges. Recalculate
> +		 * all bins from scratch. First calculate the new range.
> +		 */
> +		ksmodel_set_bining(histo, histo->n_bins, histo->min,
> +							 histo->max);
> +
> +		ksmodel_fill(histo, histo->data, histo->data_size);
> +		return;
> +	}
> +
> +	/* Set the new Lower Overflow bin. */
> +	ksmodel_set_lower_edge(histo);
> +
> +	/*
> +	 * Copy the the mapping indexes of all overlaping bins starting from
> +	 * bin "0" of the new histo. Note that the number of overlaping bins
> +	 * is histo->n_bins - n.
> +	 */
> +	memmove(&histo->map[0], &histo->map[n],
> +		sizeof(histo->map[0]) * (histo->n_bins - n));
> +
> +	/*
> +	 * The the mapping index pf the old Upper Overflow bin is now index

"The the" and "pf"?

> +	 * of the first new bin.
> +	 */
> +	bin = UOB(histo) - n;
> +	histo->map[bin] = histo->map[UOB(histo)];
> +
> +	/* Calculate only the content of the new (non-overlapping) bins. */
> +	for (; bin < histo->n_bins; ++bin)
> +		ksmodel_set_next_bin_edge(histo, bin);
> +
> +	/*
> +	 * Set the new Upper Overflow bin and calculate the number of entries
> +	 * in each bin.
> +	 */
> +	ksmodel_set_upper_edge(histo);
> +	ksmodel_set_bin_counts(histo);
> +}
> +
> +/**
> + * @brief Shift the time-window of the model backward. Recalculate the current
> + *	  state of the model.
> + * @param histo: Input location for the model descriptor.
> + * @param n: Number of bins to shift.
> + */
> +void ksmodel_shift_backward(struct kshark_trace_histo *histo, size_t n)
> +{
> +	int bin;
> +
> +	if (!histo->data_size)
> +		return;
> +
> +	if (histo->bin_count[LOB(histo)] == 0) {
> +		/*
> +		 * The Lower Overflow bin is empty. This means that we are at
> +		 * the Lower edge of the dataset already. Do nothing in this
> +		 * case.
> +		 */
> +		return;
> +	}
> +
> +	histo->min -= n * histo->bin_size;
> +	histo->max -= n * histo->bin_size;
> +
> +	if (n >= histo->n_bins) {
> +		/*
> +		 * No overlap between the new and the old range. Recalculate
> +		 * all bins from scratch. First calculate the new range.
> +		 */
> +		ksmodel_set_bining(histo, histo->n_bins, histo->min,
> +							 histo->max);
> +
> +		ksmodel_fill(histo, histo->data, histo->data_size);
> +		return;
> +	}
> +
> +	/*
> +	 * Copy the the mapping indexes of all overlaping bins starting from
> +	 * bin "0" of the old histo. Note that the number of overlaping bins
> +	 * is histo->n_bins - n.
> +	 */
> +	memmove(&histo->map[n], &histo->map[0],
> +		sizeof(histo->map[0]) * (histo->n_bins - n));
> +
> +	/* Set the new Lower Overflow bin. */
> +	ksmodel_set_lower_edge(histo);
> +
> +	/* Calculate only the content of the new (non-overlapping) bins. */
> +	bin = 0;
> +	while (bin < n) {

Convert this to a for loop please.

-- Steve

> +		ksmodel_set_next_bin_edge(histo, bin);
> +		++bin;
> +	}
> +
> +	/*
> +	 * Set the new Upper Overflow bin and calculate the number of entries
> +	 * in each bin.
> +	 */
> +	ksmodel_set_upper_edge(histo);
> +	ksmodel_set_bin_counts(histo);
> +}
> 
