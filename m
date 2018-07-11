Return-Path: <SRS0=D2WB=J3=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:52816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732848AbeGKTrs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Jul 2018 15:47:48 -0400
Date: Wed, 11 Jul 2018 15:41:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/6] kernel-shark-qt: Introduce the visualization model
 used by the Qt-based KS
Message-ID: <20180711154155.3afed70b@gandalf.local.home>
In-Reply-To: <20180711133814.26854-3-y.karadz@gmail.com>
References: <20180711133814.26854-1-y.karadz@gmail.com>
        <20180711133814.26854-3-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 11 Jul 2018 16:38:10 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The model, used by the Qt-based KernelShark for visualization of trace data
> is build over the concept of "Data Bins". When visualizing a large data-set
> of trace records, we are limited by the number of screen pixels available for
> drawing. The model divides the data-set into data-units, also called Bins.
> The Bin has to be defined in such a way that the entire content of one Bin
> can be summarized and visualized by a single graphical element.
> This model uses the timestamp of the trace records, as a criteria for forming
> Bins. When the Model has to visualize all records inside a given time-window,
> it divides this time-window into N smaller, uniformly sized subintervals and
> then defines that one Bin contains all trace records, having timestamps
> falling into one of this subintervals. Because the model operates over an
> array of trace records, sorted in time, the content of each Bin can be
> retrieved by simply knowing the index of the first element inside this Bin
> and the index of the first element of the next Bin. This means that knowing
> the index of the first element in each Bin is enough to determine the State
> of the model.
> 
> The State of the model can be modified by its five basic operations: Zoon-In,
> Zoom-Out, Shift-Forward, Shift-Backward and Jump-To. After each of these
> operations, the new State of the model is retrieved, by using binary search
> to find the index of the first element in each Bin. This means that each one
> of the five basic operations of the model has log(n) time complexity (see
> previous change log).
> 
> In order to keep the visualization of the new state of the model as efficient
> as possible, the model needs a way to summarize and visualize the content of
> the Bins in constant time. This is achieved by limiting ourself to only
> checking the content of the records at the beginning and at the end of the
> Bin. As explaned in the previous change log, this approach has the very
> counter-intuitive effect of making the update of the sparse (or empty) Graphs
> much slower. The problem of the Sparse Graphs will be addressed in another
> patch, where "Data Collections" will be introduced.
> 
> The following patch will introduces a simple example, demonstrating the usage
> of the API of the Model.

The last paragraph above can be removed from the change log. It doesn't
add value to this change.

> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark-qt/src/CMakeLists.txt    |    3 +-
>  kernel-shark-qt/src/libkshark-model.c | 1133 +++++++++++++++++++++++++
>  kernel-shark-qt/src/libkshark-model.h |  138 +++
>  3 files changed, 1273 insertions(+), 1 deletion(-)
>  create mode 100644 kernel-shark-qt/src/libkshark-model.c
>  create mode 100644 kernel-shark-qt/src/libkshark-model.h
> 
> diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMakeLists.txt
> index ed3c60e..ec22f63 100644
> --- a/kernel-shark-qt/src/CMakeLists.txt
> +++ b/kernel-shark-qt/src/CMakeLists.txt
> @@ -1,7 +1,8 @@
>  message("\n src ...")
>  
>  message(STATUS "libkshark")
> -add_library(kshark SHARED libkshark.c)
> +add_library(kshark SHARED libkshark.c
> +                          libkshark-model.c)
>  
>  target_link_libraries(kshark ${CMAKE_DL_LIBS}
>                               ${TRACEEVENT_LIBRARY}
> diff --git a/kernel-shark-qt/src/libkshark-model.c b/kernel-shark-qt/src/libkshark-model.c
> new file mode 100644
> index 0000000..89ca8ab
> --- /dev/null
> +++ b/kernel-shark-qt/src/libkshark-model.c
> @@ -0,0 +1,1133 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> + /**
> +  *  @file    libkshark.c
> +  *  @brief   Visualization model for FTRACE (trace-cmd) data.
> +  */
> +
> +// C
> +#include <stdlib.h>
> +
> +// KernelShark
> +#include "libkshark-model.h"
> +
> +/**
> + * @brief Initialize the Visualization model.
> + * @param histo: Input location for the model descriptor.
> + */
> +void ksmodel_init(struct kshark_trace_histo *histo)
> +{
> +	/*
> +	 * Initialize an empty histo. The histo will have no bins and will
> +	 * contain no data.
> +	 */
> +	histo->bin_size = 0;
> +	histo->min = 0;
> +	histo->max = 0;
> +	histo->n_bins = 0;
> +
> +	histo->bin_count = NULL;
> +	histo->map = NULL;
> +}
> +
> +/**
> + * @brief Clear (reset) the Visualization model.
> + * @param histo: Input location for the model descriptor.
> + */
> +void ksmodel_clear(struct kshark_trace_histo *histo)
> +{
> +	/* Reset the histo. It will have no bins and will contain no data. */
> +	histo->bin_size = 0;
> +	histo->min = 0;
> +	histo->max = 0;
> +	histo->n_bins = 0;
> +
> +	free(histo->map);
> +	histo->map = NULL;
> +
> +	free(histo->bin_count);
> +	histo->bin_count = NULL;

The above can be shortened to:

{
	free(histo->map);
	free(histo->bin_count);
	ksmodel_init(histo);
}

> +}
> +
> +static void ksmodel_reset_bins(struct kshark_trace_histo *histo,
> +			       size_t first, size_t last)
> +{
> +	size_t i;
> +
> +	/* Reset the content of the bins. */
> +	for (i = first; i <= last; ++i) {
> +		histo->map[i] = KS_EMPTY_BIN;
> +		histo->bin_count[i] = 0;
> +	}

Hmm, could we do:

	memset(&histo->map[first], KS_EMPTY_BIN,
	       (last - first + 1) * sizeof(histo->map[0]));
	memset(&histo->bin_count[first], 0,
	       (last - fist + 1) * sizeof(histo->bin_count[0]));

As KS_EMPTY_BIN is -1, filling map with 0xff should work fine.

But we need to make a comment by KS_EMPTY_BIN that it must be -1 and no
other value (with the exception of zero).

> +}
> +
> +static void ksmodel_histo_alloc(struct kshark_trace_histo *histo, size_t n)
> +{
> +	free(histo->bin_count);
> +	free(histo->map);
> +
> +	/* Create bins. Two overflow bins are added. */
> +	histo->map = calloc(n + 2, sizeof(*histo->map));
> +	histo->bin_count = calloc(n + 2, sizeof(*histo->bin_count));
> +
> +	if (!histo->map || !histo->bin_count) {
> +		ksmodel_clear(histo);
> +		fprintf(stderr, "Failed to allocate memory for a histo.\n");

I believe that this should return success or failure.

> +		return;
> +	}
> +
> +	histo->n_bins = n;
> +}
> +
> +static void ksmodel_set_in_range_bining(struct kshark_trace_histo *histo,
> +					size_t n, uint64_t min, uint64_t max,
> +					bool force_in_range)
> +{
> +	uint64_t corrected_range, delta_range, range = max - min;
> +	struct kshark_entry *last;
> +
> +	/* The size of the bin must be >= 1, hence the range must be >= n. */
> +	if (n == 0 || range < n)
> +		return;
> +
> +	/*
> +	 * If the number of bins changes, allocate memory for the descriptor
> +	 * of the model.
> +	 */
> +	if (n != histo->n_bins) {
> +		ksmodel_histo_alloc(histo, n);

And if we fail to allocate, the histo->n_bins is zero.

> +	}
> +
> +	/* Reset the content of all bins (including overflow bins) to zero. */
> +	ksmodel_reset_bins(histo, 0, histo->n_bins + 1);
> +
> +	if (range % n == 0) {

Note, if we failed to allocate, n != histo->n_bins.

> +		/*
> +		 * The range is multiple of the number of bin and needs no
> +		 * adjustment. This is very unlikely to happen but still ...
> +		 */
> +		histo->min = min;
> +		histo->max = max;
> +		histo->bin_size = range / n;
> +	} else {
> +		/*
> +		 * The range needs adjustment. The new range will be slightly
> +		 * bigger, compared to the requested one.
> +		 */
> +		histo->bin_size = range / n + 1;

Probably could do the following:

	histo->bin_size = (range + n - 1) / n;
	histo->min = min;
	histo->max = max;

	corrected_range = histo->bin_size * n;

	/* Check if we don't need to do any adjustments */
	if (corrected_range == range)
		return;

Then do the correction below.



> +		corrected_range = histo->bin_size * n;
> +		delta_range = corrected_range - range;
> +		histo->min = min - delta_range / 2;
> +		histo->max = histo->min + corrected_range;
> +
> +		if (!force_in_range)
> +			return;
> +
> +		/*
> +		 * Make sure that the new range doesn't go outside of the time
> +		 * interval of the dataset.
> +		 */
> +		last = histo->data[histo->data_size - 1];
> +		if (histo->min < histo->data[0]->ts) {
> +			histo->min = histo->data[0]->ts;
> +			histo->max = histo->min + corrected_range;
> +		} else if (histo->max > last->ts) {
> +			histo->max = last->ts;
> +			histo->min = histo->max - corrected_range;
> +		}

Isn't it possible that the range could be outside of min and max?

I haven't looked at exactly how this is used, so it may not be. But a
comment should be added to why that is so.

> +	}
> +}
> +
> +/**
> + * @brief Prepare the bining of the Visualization model.
> + * @param histo: Input location for the model descriptor.
> + * @param n: Number of bins.
> + * @param min: Lower edge of the time-window to be visualized.
> + * @param max: Upper edge of the time-window to be visualized.
> + */
> +void ksmodel_set_bining(struct kshark_trace_histo *histo,
> +			size_t n, uint64_t min, uint64_t max)
> +{
> +	ksmodel_set_in_range_bining(histo, n, min, max, false);
> +}
> +
> +static size_t ksmodel_set_lower_edge(struct kshark_trace_histo *histo)
> +{
> +	/*
> +	 * Find the index of the first entry inside
> +	 * the range (timestamp > min).
> +	 */
> +	size_t row = kshark_find_entry_by_time(histo->min,
> +					       histo->data,
> +					       0,
> +					       histo->data_size - 1);
> +
> +	if (row != 0) {
> +		/*
> +		 * The first entry inside the range is not the first entry
> +		 * of the dataset. This means that the Lower Overflow bin
> +		 * contains data.
> +		 */
> +
> +		/* Lower Overflow bin starts at "0". */
> +		histo->map[histo->n_bins + 1] = 0;

To keep from doing off by one errors, I think we should possibly have a:

	hist->upper_overflow_bin and hist->lower_overflow_bin


Then you can do:

	histo->map[hist->lower_overflow_bin] = 0;
	histo->bin_count[hist->lower_overflow_bin] = row;

> +
> +		/*
> +		 * The number of entries inside the Lower Overflow bin is
> +		 * equal to the index of the first entry inside the range.
> +		 */
> +		histo->bin_count[histo->n_bins + 1] = row;
> +	}  else {
> +		/*
> +		 * Lower Overflow bin is empty. The number of entries is
> +		 * already set to "0".
> +		 */
> +		histo->map[histo->n_bins + 1] = KS_EMPTY_BIN;
> +	}
> +
> +	/*
> +	 * Now check if the first entry inside the range falls into the
> +	 * first bin.
> +	 */
> +	if (histo->data[row]->ts  < histo->min + histo->bin_size) {
> +		/*
> +		 * It is inside the fisrs bin. Set the beginning
> +		 * of the fisrs bin.

What's the "fisrs bin"?

> +		 */
> +		histo->map[0] = row;
> +	} else {
> +		/* The fisrs bin is empty. */
> +		histo->map[0] = KS_EMPTY_BIN;
> +	}
> +
> +	return row;
> +}
> +
> +static size_t ksmodel_set_upper_edge(struct kshark_trace_histo *histo)
> +{
> +	/*
> +	 * Find the index of the first entry outside
> +	 * the range (timestamp > max).
> +	 */
> +	size_t row = kshark_find_entry_by_time(histo->max,
> +					       histo->data,
> +					       0,
> +					       histo->data_size - 1);
> +
> +	if (row < histo->data_size - 1 ||
> +	    (row == histo->data_size - 1 &&
> +	     histo->data[histo->data_size - 1]->ts > histo->max)) {
> +		/*
> +		 * The Upper Overflow bin contains data. Set its beginning
> +		 * and the number of entries.
> +		 */
> +		histo->map[histo->n_bins] = row;
> +		histo->bin_count[histo->n_bins] = histo->data_size - row;
> +	}  else {
> +		/*
> +		 * Upper Overflow bin is empty. The number of entries is
> +		 * already set to "0".
> +		 */
> +		histo->map[histo->n_bins] = KS_EMPTY_BIN;

And here use: histo->map[histo->upper_overflow_bin]

> +	}
> +
> +	return row;
> +}
> +
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
> +	row = kshark_find_entry_by_time(time,histo->data, 0,

Space after comma: "time, histo"

> +					histo->data_size - 1);
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
> +	if (histo->data[row]->ts  >= time + histo->bin_size) {

Remove one of the two spaces between "ts  >="

> +		/* The bin is empty. */
> +		histo->map[next_bin] = KS_EMPTY_BIN;
> +		return;
> +	}
> +
> +	/* Set the index of the first entry. */
> +	histo->map[next_bin] = row;
> +}
> +
> +static void ksmodel_set_bin_counts(struct kshark_trace_histo *histo)
> +{
> +	size_t i = 0, prev_not_empty;
> +
> +	/*
> +	 * Find the first bin which contain data. Start by checking the

   "which contains data"

> +	 * Lower Overflow bin.
> +	 */
> +	if (histo->map[histo->n_bins + 1] != KS_EMPTY_BIN) {

This is where having "lower_overflow_bin" and "upper_overflow_bin" will
come in handy. One does not need to remember which is which.

> +		prev_not_empty = histo->n_bins + 1;
> +	} else {
> +		while (histo->map[i] < 0) {
> +			++i;
> +		}
> +
> +		prev_not_empty = i++;
> +	}
> +
> +	/*
> +	 * Starting from the first not empty bin, loop over all bins and
> +	 * calculate the number of entries.

I would reword the above. ", loop over all bins and fill in the
bin_count array to hold the number of empty bins after each one.."

> +	 */
> +	while (i < histo->n_bins) {
> +		if (histo->map[i] != KS_EMPTY_BIN) {
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
> +	if (histo->map[histo->n_bins] == KS_EMPTY_BIN) {

	if (histo->map[histo->upper_overflow_bin] == KS_EMPTY_BIN) {

 ;-)


Does the lower and upper overflow bins even need to be in the map array?

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
> +		histo->bin_count[prev_not_empty] = histo->map[histo->n_bins] -
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
> +	size_t bin;
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
> +	while (bin < histo->n_bins) {
> +		ksmodel_set_next_bin_edge(histo, bin);
> +		++bin;
> +	}

The above should be a for loop.

	for (bin = 0; bin < histo->n_bins; bin++)
		ksmodel_set_next_bin_edge(histo, bin);

BTW, when we have a single line after a for, while or if statement, we
don't need the brackets '{' '}'

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
> +	if (bin >= 0 && bin < (int) histo->n_bins)

Why is bin "int" and not ssize_t? If you need a cast above, that means
we can have issues if histo->n_bins is greater than 2 gig.


> +		return histo->bin_count[bin];
> +
> +	if (bin == UPPER_OVERFLOW_BIN)
> +		return histo->bin_count[histo->n_bins];
> +
> +	if (bin == LOWER_OVERFLOW_BIN)
> +		return histo->bin_count[histo->n_bins + 1];
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
> +	size_t bin;
> +	
> +	if (!histo->data_size)
> +		return;
> +
> +	if (ksmodel_bin_count(histo, UPPER_OVERFLOW_BIN) == 0) {
> +		/*
> +		 * The Upper Overflow bin is empty. This means that we are at
> +		 * the upper edge of the dataset already. Do nothing in this
> +		 * case.
> +		 */
> +		return;
> +	}
> +
> +	if (n >= histo->n_bins) {
> +		/*
> +		 * No overlap between the new and the old ranges. Recalculate
> +		 * all bins from scratch. First calculate the new range.
> +		 */
> +		histo->min += n * histo->bin_size;
> +		histo->max += n * histo->bin_size;
> +
> +		ksmodel_set_bining(histo, histo->n_bins, histo->min,
> +							 histo->max);
> +
> +		ksmodel_fill(histo, histo->data, histo->data_size);
> +		return;
> +	}
> +
> +	/* Set the new Lower Overflow bin */
> +	ksmodel_set_lower_edge(histo);
> +
> +	/*
> +	 * Copy the content of all overlaping bins starting from bin "0"
> +	 * of the new histo.
> +	 */
> +	bin = 0;
> +	while (bin <  histo->n_bins - n) {
> +		histo->map[bin] = histo->map[bin + n];
> +		histo->bin_count[bin] = histo->bin_count[bin + n];
> +		++bin;
> +	}

Replace the above with:

	memmove(&histo->map[bin + n], &histo->map[bin],
		sizeof(histo->map[0]) * n);
	memmove(&histo->bin_count[bin + n], &histo->bin_count[bin],
		sizeof(histo->bin_count[0]) * n);
	bin += n;

> +
> +	histo->map[bin] = histo->map[bin + n];
> +	histo->bin_count[bin] = 0;
> +
> +	/* Calculate only the content of the new (non-overlapping) bins. */
> +	ksmodel_reset_bins(histo, bin + 1, histo->n_bins);
> +	while (bin < histo->n_bins) {

Make this a for loop:

	for (; bin < histo->n_bins; bin++)

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
> + * @brief Shift the time-window of the model backward. Recalculate the current
> + *	  state of the model.
> + * @param histo: Input location for the model descriptor.
> + * @param n: Number of bins to shift.
> + */
> +void ksmodel_shift_backward(struct kshark_trace_histo *histo, size_t n)
> +{
> +	size_t bin;
> +
> +	if (!histo->data_size)
> +		return;
> +
> +	if (ksmodel_bin_count(histo, LOWER_OVERFLOW_BIN) == 0) {
> +		/*
> +		 * The Lower Overflow bin is empty. This means that we are at
> +		 * the Lower edge of the dataset already. Do nothing in this
> +		 * case.
> +		 */
> +		return;
> +	}
> +
> +	if (n >= histo->n_bins) {
> +		/*
> +		 * No overlap between the new and the old range. Recalculate
> +		 * all bins from scratch. First calculate the new range.
> +		 */
> +		histo->min -= n * histo->bin_size;
> +		histo->max -= n * histo->bin_size;
> +
> +		ksmodel_set_bining(histo, histo->n_bins, histo->min,
> +							 histo->max);
> +
> +		ksmodel_fill(histo, histo->data, histo->data_size);
> +		return;
> +	}
> +
> +	/*
> +	 * Copy the content of all overlaping bins starting from the last bin
> +	 * of the new histo.
> +	 */
> +	bin = histo->n_bins - 1;
> +	while (1) {

I don't really understand the below if.

> +		if (bin > histo->n_bins - n && histo->map[bin] >= 0) {
> +			histo->map[histo->n_bins] = histo->map[bin];
> +			histo->bin_count[histo->n_bins] +=
> +				histo->bin_count[bin];
> +		}
> +
> +		histo->map[bin] = histo->map[bin-n];
> +		histo->bin_count[bin] = histo->bin_count[bin-n];
> +
> +		if (bin == n)
> +			break;
> +
> +		--bin;
> +	}

But we can replace the copy again with memmove:

	memmove(&histo->map[bin], &histo->map[bin - n],
		sizeof(histo->map[0]) * n);
	memmove(&histo->bin_count[bin], &histo->bin_count[bin - n],
		sizeof(histo->bin_count[0]) * n);

> +
> +	/* Reset all new bins, including overflow bins. */
> +	ksmodel_reset_bins(histo, 0, bin);
> +	ksmodel_reset_bins(histo, histo->n_bins, histo->n_bins + 1);
> +
> +	/* Set the new Lower Overflow bin */
> +	ksmodel_set_lower_edge(histo);
> +
> +	/* Calculate only the content of the new (non-overlapping) bins. */
> +	bin = 0;
> +	while (bin < n) {

Again this should be a for loop.

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

Hmm, perhaps replace the ending of this function and the shift forward
with a helper function that removes the duplicate code.

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
> +	range_min = histo->data[histo->data_size - 1]->ts -
> +		   histo->n_bins * histo->bin_size;
> +
> +	if (min > range_min)
> +		min = range_min;
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

Comment here that mark < 0 means to zoom in the middle.

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
> +
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
> +
> +	if (bin == LOWER_OVERFLOW_BIN)
> +		return histo->map[histo->n_bins + 1];
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

So if vis_only is true, and the next entry that matches the condition
is not visible, we simply return the dummy?


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
> +
> +/**
> + * @brief In a given bin, start from the back end of the bin and go towards
> + *	  the front end, searching for an entry satisfying the Matching
> + *	  condition defined by a Matching condition function.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @param vis_only: If true, a visible entry is requested.

Same here?

> + * @param func: Matching condition function.
> + * @param val: Matching condition value, used by the Matching condition
> + *	       function.
> + * @param index: Optional output location for the index of the requested
> + *		 entry inside the array.
> + * @returns Pointer ot a kshark_entry, if an entry has been found. Else NULL.

Should document about the dummy. And that NULL can be a warning.

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
> +	if (!entry->visible) {

As so you have to return a dummy, not (-1), because this can be the
dummy.

OK, that's all the review I can do today. I skimmed the rest of the
patch but didn't see anything that stood out, but I didn't look in too
much detail. I'll try to do more tomorrow.

-- Steve


> +		/* Some data has been found, but it is filtered-out. */
> +		return KS_FILTERED_BIN;
> +	}
> +
> +	return entry->pid;
> +}
> +
> +/**
> + * @brief In a given bin, start from the front end of the bin and go towards
> + *	  the back end, searching for an entry from a given Cpu. Return
> + *	  the Process Id of the task of the entry found.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @param cpu: Cpu Id.
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
> +	entry = ksmodel_get_entry_front(histo, bin, vis_only,
> +					       kshark_check_cpu, cpu,
> +					       index);
> +	return ksmodel_get_entry_pid(entry);
> +}
> +
> +/**
> + * @brief In a given bin, start from the back end of the bin and go towards
> + *	  the front end, searching for an entry from a given Cpu. Return
> + *	  the Process Id of the task of the entry found.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @param cpu: Cpu Id.
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
> +	entry = ksmodel_get_entry_back(histo, bin, vis_only,
> +					      kshark_check_cpu, cpu,
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
> +	if (!entry->visible) {
> +		/* Some data has been found, but it is filtered-out. */
> +		return KS_FILTERED_BIN;
> +	}
> +
> +	return entry->cpu;
> +}
> +
> +/**
> + * @brief Get the Cpu Id of the first entry from a given Task in a given bin.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @param pid: Process Id of a task.
> + * @param vis_only: If true, a visible entry is requested.
> + * @param index: Optional output location for the index of the requested
> + *		 entry inside the array.
> + * @returns Cpu Id of the first entry from a given Task in this bin.
> + */
> +int ksmodel_get_cpu(struct kshark_trace_histo *histo,
> +		    int bin, int pid, bool vis_only,
> +		    ssize_t *index)
> +{
> +	struct kshark_entry_request *req;
> +	const struct kshark_entry *entry;
> +	size_t n;
> +
> +	if (index)
> +		*index = KS_EMPTY_BIN;
> +
> +	/* Get the number of entries in this bin. */
> +	n = ksmodel_bin_count(histo, bin);
> +	if (!n)
> +		return KS_EMPTY_BIN;
> +
> +	/* Create an entry request but keep the starting position unset. */
> +	req = kshark_entry_request_alloc(0, n,
> +					 kshark_check_pid, pid,
> +					 vis_only, KS_GRAPH_VIEW_FILTER_MASK);
> +
> +	if (bin == UPPER_OVERFLOW_BIN) {
> +		/*
> +		 * Set the position at the end of the Lower Overflow bin and
> +		 * go backwards.
> +		 */
> +		req->first = ksmodel_bin_count(histo, bin) - 1;
> +		entry = kshark_get_entry_back(req, histo->data, index);
> +	} else {
> +		/*
> +		 * Set the position at the beginning of the bin and go
> +		 * forward.
> +		 */
> +		req->first = ksmodel_first_index_at_bin(histo, bin);
> +		entry = kshark_get_entry_front(req, histo->data, index);
> +	}
> +
> +	free(req);
> +
> +	return ksmodel_get_entry_cpu(entry);
> +}
> +
> +/**
> + * @brief Check if a visible entry from a given Cpu exist in this bin.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @param cpu: Cpu Id.
> + * @param index: Optional output location for the index of the requested
> + *		 entry inside the array.
> + * @returns True, if a visible entry from the Cpu exists in this bin.
> + * 	    Else false.
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
> +						kshark_check_cpu, cpu);
> +	if (!req)
> +		return false;
> +
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
> + * @brief Check if a visible entry from a given Task exist in this bin.
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @param pid: Process Id of the task.
> + * @param index: Optional output location for the index of the requested
> + *		 entry inside the array.
> + * @returns True, if a visible entry from the task exists in this bin.
> + * 	    Else false.
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
> +						kshark_check_pid, pid);
> +	if (!req)
> +		return false;
> +
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
> diff --git a/kernel-shark-qt/src/libkshark-model.h b/kernel-shark-qt/src/libkshark-model.h
> new file mode 100644
> index 0000000..db42772
> --- /dev/null
> +++ b/kernel-shark-qt/src/libkshark-model.h
> @@ -0,0 +1,138 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +
> +/*
> + * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> + /**
> +  *  @file    libkshark-model.h
> +  *  @brief   Visualization model for FTRACE (trace-cmd) data.
> +  */
> +
> +#ifndef _LIB_KSHARK_MODEL_H
> +#define _LIB_KSHARK_MODEL_H
> +
> +// KernelShark
> +#include "libkshark.h"
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif // __cplusplus
> +
> +/** Overflow Bin identifiers. */
> +enum OverflowBin {
> +	/** Identifier of the Upper Overflow Bin. */
> +	UPPER_OVERFLOW_BIN = -1,
> +
> +	/** Identifier of the Lower Overflow Bin. */
> +	LOWER_OVERFLOW_BIN = -2,
> +};
> +
> +/** Structure describing the current state of the visualization model. */
> +struct kshark_trace_histo {
> +	/** Trace data. */
> +	struct kshark_entry	**data;
> +
> +	/** The size of the data. */
> +	size_t			data_size;
> +
> +	/** The index of the first entry in each bin. */
> +	ssize_t			*map;
> +
> +	/** Number of entries in each bin. */
> +	size_t			*bin_count;
> +
> +	/** Lower edge of the time-window to be visualized. */
> +	uint64_t		min;
> +
> +	/** Upper edge of the time-window to be visualized. */
> +	uint64_t		max;
> +
> +	/** The size of the bins. */
> +	uint64_t		bin_size;
> +
> +	/** Number of bins. */
> +	size_t			n_bins;
> +};
> +
> +void ksmodel_init(struct kshark_trace_histo *histo);
> +
> +void ksmodel_clear(struct kshark_trace_histo *histo);
> +
> +void ksmodel_set_bining(struct kshark_trace_histo *histo,
> +			size_t n, uint64_t min, uint64_t max);
> +
> +void ksmodel_fill(struct kshark_trace_histo *histo,
> +		  struct kshark_entry **data, size_t n);
> +
> +size_t ksmodel_bin_count(struct kshark_trace_histo *histo, int bin);
> +
> +void ksmodel_shift_forward(struct kshark_trace_histo *histo, size_t n);
> +
> +void ksmodel_shift_backward(struct kshark_trace_histo *histo, size_t n);
> +
> +void ksmodel_jump_to(struct kshark_trace_histo *histo, size_t ts);
> +
> +void ksmodel_zoom_out(struct kshark_trace_histo *histo,
> +		      double r, int mark);
> +
> +void ksmodel_zoom_in(struct kshark_trace_histo *histo,
> +		     double r, int mark);
> +
> +ssize_t ksmodel_first_index_at_bin(struct kshark_trace_histo *histo, int bin);
> +
> +ssize_t ksmodel_last_index_at_bin(struct kshark_trace_histo *histo, int bin);
> +
> +ssize_t ksmodel_first_index_at_cpu(struct kshark_trace_histo *histo,
> +				   int bin, int cpu);
> +
> +ssize_t ksmodel_first_index_at_pid(struct kshark_trace_histo *histo,
> +				   int bin, int pid);
> +
> +const struct kshark_entry *
> +ksmodel_get_entry_front(struct kshark_trace_histo *histo,
> +			int bin, bool vis_only,
> +			matching_condition_func func, int val,
> +			ssize_t *index);
> +
> +const struct kshark_entry *
> +ksmodel_get_entry_back(struct kshark_trace_histo *histo,
> +		       int bin, bool vis_only,
> +		       matching_condition_func func, int val,
> +		       ssize_t *index);
> +
> +int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
> +			  int bin, int cpu, bool vis_only,
> +			  ssize_t *index);
> +
> +int ksmodel_get_pid_back(struct kshark_trace_histo *histo,
> +			 int bin, int cpu, bool vis_only,
> +			 ssize_t *index);
> +
> +int ksmodel_get_cpu(struct kshark_trace_histo *histo,
> +		    int bin, int pid, bool vis_only,
> +		    ssize_t *index);
> +
> +bool ksmodel_cpu_visible_event_exist(struct kshark_trace_histo *histo,
> +				     int bin, int cpu, ssize_t *index);
> +
> +bool ksmodel_task_visible_event_exist(struct kshark_trace_histo *histo,
> +				      int bin, int pid, ssize_t *index);
> +
> +static inline double ksmodel_bin_time(struct kshark_trace_histo *histo,
> +				      int bin)
> +{
> +	return (histo->min + bin*histo->bin_size) * 1e-9;
> +}
> +
> +static inline uint64_t ksmodel_bin_ts(struct kshark_trace_histo *histo,
> +				      int bin)
> +{
> +	return (histo->min + bin*histo->bin_size);
> +}
> +
> +#ifdef __cplusplus
> +}
> +#endif // __cplusplus
> +
> +#endif
