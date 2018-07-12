Return-Path: <SRS0=efs/=J4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:55088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729331AbeGLOkc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Jul 2018 10:40:32 -0400
Date: Thu, 12 Jul 2018 10:30:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/6] kernel-shark-qt: Introduce the visualization model
 used by the Qt-based KS
Message-ID: <20180712103041.58f41fed@gandalf.local.home>
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

I just noticed these helper functions:

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

Also, add a space around the '*' between 'bin' and 'histo'.


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

Why not:

	if (histo->data[row]->ts < ksmodel_bin_ts(histo, 1)) {

> +		/*
> +		 * It is inside the fisrs bin. Set the beginning
> +		 * of the fisrs bin.
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

	time = ksmodel_bin_ts(histo, next_bin);

-- Steve

> +
> +	/*
> +	 * Find the index of the first entry inside
> +	 * the next bin (timestamp > time).
> +	 */
> +	row = kshark_find_entry_by_time(time,histo->data, 0,
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
> +		/* The bin is empty. */
> +		histo->map[next_bin] = KS_EMPTY_BIN;
> +		return;
> +	}
> +
> +	/* Set the index of the first entry. */
> +	histo->map[next_bin] = row;
> +}
> +
