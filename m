Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:34136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731500AbeHAUJq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Aug 2018 16:09:46 -0400
Date: Wed, 1 Aug 2018 14:22:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH v2 3/7] kernel-shark-qt: Introduce the visualization
 model used by the Qt-based KS
Message-ID: <20180801142244.3ed8a35c@gandalf.local.home>
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


I'd add a comment above this function (yes static functions may have
header comments, just doesn't need to be doxygen like).

/*
 * Fill in the bin_count array, which maps the number of data rows that
 * exist within each bin.
 */

Or something like that.

> +static void ksmodel_set_bin_counts(struct kshark_trace_histo *histo)
> +{
> +	int i = 0, prev_not_empty;
> +
> +	memset(&histo->bin_count[0], 0,
> +	       (histo->n_bins) * sizeof(histo->bin_count[0]));
> +	/*
> +	 * Find the first bin which contains data. Start by checking the
> +	 * Lower Overflow bin.
> +	 */
> +	if (histo->map[histo->n_bins + 1] != KS_EMPTY_BIN) {

Hmm, shouldn't that be:

	if (histo->map[LOB(histo)] != KS_EMPTY_BIN) ?

> +		prev_not_empty = LOB(histo);
> +	} else {

Add a comment here:

		/* Find the first non-empty bin */

> +		while (histo->map[i] < 0) {

Can map[i] be a negative other than KS_EMPTY_BIN? 

> +			++i;
> +		}
> +
> +		prev_not_empty = i++;
> +	}
> +
> +	/*
> +	 * Starting from the first not empty bin, loop over all bins and fill
> +	 * in the bin_count array to hold the number of entries in each bin.
> +	 */
> +	while (i < histo->n_bins) {

The above should be a for loop:

	for (; i < histo->n_bins; i++) {


> +		if (histo->map[i] != KS_EMPTY_BIN) {
> +			/*
> +			 * Here we set the number of entries in
> +			 * "prev_not_empty" bin.

The above comment needs to be changed:

			/*
			 * The current bin is not empty, take its data
			 * row and subtract it from the data row of the
			 * previous not empty bin, which will give us
			 * the number of data rows in that bin.

Or something like that.

> +			 */
> +			histo->bin_count[prev_not_empty] =
> +				histo->map[i] - histo->map[prev_not_empty];
> +	
> +			prev_not_empty = i;
> +		}
> +
> +		++i;
> +	}
> +
> +	/* Check if the Upper Overflow bin contains data. */
> +	if (histo->map[UOB(histo)] == KS_EMPTY_BIN) {
> +		/*
> +		 * The Upper Overflow bin is empty. Use the size of the
> +		 * dataset to calculate the content of the previouse not
> +		 * empty bin.
> +		 */
> +		histo->bin_count[prev_not_empty] = histo->data_size -
> +						   histo->map[prev_not_empty];
> +	} else {
> +		/*
> +		 * Use the index of the first entry inside the Upper Overflow
> +		 * bin to calculate the content of the previouse not empty
> +		 * bin.
> +		 */
> +		histo->bin_count[prev_not_empty] = histo->map[UOB(histo)] -
> +						   histo->map[prev_not_empty];
> +	}
> +}
> +
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

As stated before, superfluous bin.

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

Or should this be:

	if (histo->map[UOB(histo)] == KS_EMPTY_BIN)  ?

I know it should mean the same, but we use map below, and I like to be
more consistent.

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

Hmm, the above also sets histo->map[0]. This should then equal
histo->map[n] right? I wonder if we should have a sanity check here
making sure that's the case.

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

Again, this probably should be:

	if (histo->map[LOB(histo)] == KS_EMPTY_BIN) {


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

This needs to be a for loop.

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
> +
> +/**
> + * @brief Move the time-window of the model to a given location. Recalculate
> + *	  the current state of the model.
> + * @param histo: Input location for the model descriptor.
> + * @param ts: position in time to be visualized.
> + */
> +void ksmodel_jump_to(struct kshark_trace_histo *histo, size_t ts)
> +{
> +	size_t min, max, range_min;
> +
> +	if (ts > histo->min && ts < histo->max) {
> +		/*
> +		 * The new position is already inside the range.
> +		 * Do nothing in this case.
> +		 */
> +		return;
> +	}
> +
> +	/*
> +	 * Calculate the new range without changing the size and the number
> +	 * of bins.
> +	 */
> +	min = ts - histo->n_bins * histo->bin_size / 2;
> +
> +	/* Make sure that the range does not go outside of the dataset. */
> +	if (min < histo->data[0]->ts)
> +		min = histo->data[0]->ts;
> +

I wonder if we should make this an else

	else {

> +	range_min = histo->data[histo->data_size - 1]->ts -
> +		   histo->n_bins * histo->bin_size;
> +
> +	if (min > range_min)
> +		min = range_min;

	}

Making sure min isn't less than the data set?

> +
> +	max = min + histo->n_bins * histo->bin_size;
> +
> +	/* Use the new range to recalculate all bins from scratch. */
> +	ksmodel_set_bining(histo, histo->n_bins, min, max);
> +	ksmodel_fill(histo, histo->data, histo->data_size);
> +}
> +
> +/**
> + * @brief Extend the time-window of the model. Recalculate the current state
> + *	  of the model.
> + * @param histo: Input location for the model descriptor.
> + * @param r: Scale factor of the zoom-out.
> + * @param mark: Focus point of the zoom-out.
> + */
> +void ksmodel_zoom_out(struct kshark_trace_histo *histo,
> +		      double r, int mark)
> +{
> +	size_t range, min, max, delta_min;
> +	double delta_tot;
> +
> +	if (!histo->data_size)
> +		return;
> +
> +	/*
> +	 * If the marker is not set, assume that the focal point of the zoom
> +	 * is the center of the range.
> +	 */
> +	if (mark < 0)
> +		mark = histo->n_bins / 2;
> +
> +	/*
> +	 * Calculate the new range of the histo. Use the bin of the marker
> +	 * as a focal point for the zoomout. With this the maker will stay
> +	 * inside the same bin in the new histo.
> +	 */
> +	range = histo->max - histo->min;
> +	delta_tot = range * r;
> +	delta_min = delta_tot * mark / histo->n_bins;
> +
> +	min = histo->min - delta_min;
> +	max = histo->max + (size_t) delta_tot - delta_min;

Took me a bit to figure out what exactly the above is doing. Let me
explain what I think it is doing and you can correct me if I'm wrong.

We set delta_tot to increase by the percentage requested (easy).

Now we make delta_min equal to a percentage of delta_tot based on where
mark is in the original bins. If mark is zero, then mark was at 0% of
the original bins, if it was at histo->n_bins - 1, it was at (almost)
100%. If it is half way, then we place delta_min at %50 of delta_tot.

Then we subtract the original min by the delta_tot * mark/n_bins
percentage, and add the max by delta_tot * (1 - mark/n_bins).

Sound right? Maybe we can add a comment saying such?

> +
> +	/* Make sure the new range doesn't go outside of the dataset. */
> +	if (min < histo->data[0]->ts)
> +		min = histo->data[0]->ts;
> +
> +	if (max > histo->data[histo->data_size - 1]->ts)
> +		max = histo->data[histo->data_size - 1]->ts;
> +
> +	/*
> +	 * Use the new range to recalculate all bins from scratch. Enforce
> +	 * "In Range" adjustment of the range of the model, in order to avoid
> +	 * slowly drifting outside of the data-set in the case when the very
> +	 * first or the very last entry is used as a focal point.
> +	 */
> +	ksmodel_set_in_range_bining(histo, histo->n_bins, min, max, true);
> +	ksmodel_fill(histo, histo->data, histo->data_size);
> +}
> +
> +/**
> + * @brief Shrink the time-window of the model. Recalculate the current state
> + *	  of the model.
> + * @param histo: Input location for the model descriptor.
> + * @param r: Scale factor of the zoom-in.
> + * @param mark: Focus point of the zoom-in.
> + */
> +void ksmodel_zoom_in(struct kshark_trace_histo *histo,
> +		     double r, int mark)
> +{
> +	size_t range, min, max, delta_min;
> +	double delta_tot;
> +
> +	if (!histo->data_size)
> +		return;
> +
> +	/*
> +	 * If the marker is not set, assume that the focal point of the zoom
> +	 * is the center of the range.
> +	 */
> +	if (mark < 0)
> +		mark = histo->n_bins / 2;
> +
> +	range = histo->max - histo->min;
> +
> +	/* Avoid overzooming. */
> +	if (range < histo->n_bins * 4)
> +		return;
> +
> +	/*
> +	 * Calculate the new range of the histo. Use the bin of the marker
> +	 * as a focal point for the zoomin. With this the maker will stay
> +	 * inside the same bin in the new histo.
> +	 */
> +	delta_tot =  range * r;
> +	if (mark == (int)histo->n_bins - 1)
> +		delta_min = delta_tot;


> +	else if (mark == 0)
> +		delta_min = 0;
> +	else
> +		delta_min = delta_tot * mark / histo->n_bins;

The above two are equivalent:

	if (mark == 0)
Then
	delta_min = delta_tot * mark / histo->n_bins = 0


> +
> +	min = histo->min + delta_min;
> +	max = histo->max - (size_t) delta_tot + delta_min;
> +
> +	/*
> +	 * Use the new range to recalculate all bins from scratch. Enforce
> +	 * "In Range" adjustment of the range of the model, in order to avoid
> +	 * slowly drifting outside of the data-set in the case when the very
> +	 * first or the very last entry is used as a focal point.
> +	 */
> +	ksmodel_set_in_range_bining(histo, histo->n_bins, min, max, true);
> +	ksmodel_fill(histo, histo->data, histo->data_size);
> +}

Hmm, I think zoom_out and zoom_in could be combined:

static void ksmodel_zoom(struct kshark_trace_histo *histo,
			 double r, int mark, bool zoom_in)
{
	size_t range, min, max, delta_min;
	double delta_tot;

	if (!histo->data_size)
		return;

	/*
	 * If the marker is not set, assume that the focal point of the zoom
	 * is the center of the range.
	 */
	if (mark < 0)
		mark = histo->n_bins / 2;

	range = histo->max - histo->min;

	/* Avoid overzooming. */
	if (range < histo->n_bins * 4)
		return;

	/*
	 * Calculate the new range of the histo. Use the bin of the marker
	 * as a focal point for the zoomout. With this the maker will stay
	 * inside the same bin in the new histo.
	 */
	delta_tot = range * r;
	if (mark == (int)histo->n_bins - 1)
		delta_min = delta_tot;
	else
		delta_min = delta_tot * mark / histo->n_bins;

	
	min = zoom_in ? histo->min + delta_min : histo->min - delta_min;
	max = zoom_in ? histo->max - (size_t) delta_tot + delta_min :
		        histo->max + (size_t) delta_tot - delta_min;


	/* Make sure the new range doesn't go outside of the dataset. */
	if (min < histo->data[0]->ts)
		min = histo->data[0]->ts;

	if (max > histo->data[histo->data_size - 1]->ts)
		max = histo->data[histo->data_size - 1]->ts;

	/*
	 * Use the new range to recalculate all bins from scratch. Enforce
	 * "In Range" adjustment of the range of the model, in order to avoid
	 * slowly drifting outside of the data-set in the case when the very
	 * first or the very last entry is used as a focal point.
	 */
	ksmodel_set_in_range_bining(histo, histo->n_bins, min, max, true);
	ksmodel_fill(histo, histo->data, histo->data_size);
}

void ksmodel_zoom_out(struct kshark_trace_histo *histo,
		      double r, int mark)
{
	ksmodel_zoom(histo, r, mark, false);
}

void ksmodel_zoom_in(struct kshark_trace_histo *histo,
		     double r, int mark)
{
	ksmodel_zoom(histo, r, mark, true);
}

-- Steve
