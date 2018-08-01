Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35657 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732937AbeHAR5O (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Aug 2018 13:57:14 -0400
Received: by mail-wm0-f66.google.com with SMTP id o18-v6so7720996wmc.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Aug 2018 09:10:47 -0700 (PDT)
From: Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH v2 3/7] kernel-shark-qt: Introduce the visualization model
 used by the Qt-based KS
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
References: <20180731135248.30587-1-y.karadz@gmail.com>
 <20180731135248.30587-4-y.karadz@gmail.com>
 <20180731205113.2fe79e72@gandalf.local.home>
Message-ID: <735f8de7-0a46-18c6-0665-378de46b68f1@Gmail.com>
Date: Wed, 1 Aug 2018 19:10:46 +0300
MIME-Version: 1.0
In-Reply-To: <20180731205113.2fe79e72@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 1.08.2018 03:51, Steven Rostedt wrote:
>> +static void ksmodel_set_in_range_bining(struct kshark_trace_histo *histo,
>> +					size_t n, uint64_t min, uint64_t max,
>> +					bool force_in_range)
>> +{
>> +	uint64_t corrected_range, delta_range, range = max - min;
>> +	struct kshark_entry *last;
>> +
>> +	/* The size of the bin must be >= 1, hence the range must be >= n. */
>> +	if (n == 0 || range < n)
>> +		return;
>> +
>> +	/*
>> +	 * If the number of bins changes, allocate memory for the descriptor
>> +	 * of the model.
>> +	 */
>> +	if (n != histo->n_bins) {
>> +		if (!ksmodel_histo_alloc(histo, n)) {
>> +			ksmodel_clear(histo);
>> +			return;
>> +		}
>> +	}
>> +
>> +	/* Reset the content of all bins (including overflow bins) to zero. */
>> +	ksmodel_reset_bins(histo, 0, histo->n_bins + 1);
> Here we could then have:
>
> 	ksmodel_reset_bins(histo, 0, ALLB(histo));
>
>> +
>> +	if (range % n == 0) {
>> +		/*
>> +		 * The range is multiple of the number of bin and needs no
>> +		 * adjustment. This is very unlikely to happen but still ...
>> +		 */
>> +		histo->min = min;
>> +		histo->max = max;
>> +		histo->bin_size = range / n;
>> +	} else {
>> +		/*
>> +		 * The range needs adjustment. The new range will be slightly
>> +		 * bigger, compared to the requested one.
>> +		 */
>> +		histo->bin_size = range / n + 1;
>> +		corrected_range = histo->bin_size * n;
>> +		delta_range = corrected_range - range;
>> +		histo->min = min - delta_range / 2;
>> +		histo->max = histo->min + corrected_range;
>> +
>> +		if (!force_in_range)
>> +			return;
>> +
>> +		/*
>> +		 * Make sure that the new range doesn't go outside of the time
>> +		 * interval of the dataset.
>> +		 */
>> +		last = histo->data[histo->data_size - 1];
>> +		if (histo->min < histo->data[0]->ts) {
>> +			histo->min = histo->data[0]->ts;
>> +			histo->max = histo->min + corrected_range;
>> +		} else if (histo->max > last->ts) {
>> +			histo->max = last->ts;
>> +			histo->min = histo->max - corrected_range;
>> +		}
> Hmm, Let's say the range of the data is 0..1,000,001 and we picked a
> range of 999,999 starting at 0. And there's 1024 buckets. This would
> have:
>
> min = 0; max = 999999; n = 1024; range = 999999;
>
> bin_size = 999999 / 1024 + 1 = 977;
> correct_range = 977 * 1024 = 1000448;
> delta_rang = 1000448 - 999999 = 449;
> histo->min = 0 - 449 / 2 = -224;
> histo->max = -224 + 1000448 = 1000224;
>
> Now histo->min (-224) < histo->data[0]->ts (0) so
>
> histo->min = 0;
> histo->max = 0 + 1000448 = 1000448;
>
> Thus we get max greater than the data set.
>
> Actually, we would always get a range greater than the data set, if the
> data set itself is not divisible by the bin size. This that a problem?
Hi Steven,
In your example you consider the case when we want to visualize the 
entire data-set.
Indeed in this case the true range of the histo will be slightly bigger. 
This is not a problem.

The "force_in_range" part of the logic in this function deals with 
another case.
Let's stick to your example but say that the current range is from 0 to 
10,000.
Now if the user hits the "Zoom Out" for a second, this function will be 
called several hundred times
and each call of the function will add its own small negative correction 
to the value of histo->min (initially 0).
At the end we will have a significant part of the graph outside of the 
data-set.

Thanks!
Yordan

>
> -- Steve
>
>> +	}
>> +}
>> +
>> +/**
>> + * @brief Prepare the bining of the Visualization model.
>> + * @param histo: Input location for the model descriptor.
>> + * @param n: Number of bins.
>> + * @param min: Lower edge of the time-window to be visualized.
>> + * @param max: Upper edge of the time-window to be visualized.
>> + */
>> +void ksmodel_set_bining(struct kshark_trace_histo *histo,
>> +			size_t n, uint64_t min, uint64_t max)
>> +{
>> +	ksmodel_set_in_range_bining(histo, n, min, max, false);
>> +}
>> +
>>
