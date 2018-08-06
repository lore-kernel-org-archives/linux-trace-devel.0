Return-Path: <SRS0=QejA=KV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32908 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbeHFQdY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Aug 2018 12:33:24 -0400
Received: by mail-wr1-f66.google.com with SMTP id g6-v6so12593923wrp.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Aug 2018 07:24:02 -0700 (PDT)
Subject: Re: [PATCH v3 2/6] kernel-shark-qt: Introduce the visualization model
 used by the Qt-based KS
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180803142937.3970-1-y.karadz@gmail.com>
 <20180803142937.3970-3-y.karadz@gmail.com>
 <20180803174852.6ee5c889@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <033bbc3f-e80d-8c80-2fab-66e10a491fe3@gmail.com>
Date: Mon, 6 Aug 2018 17:24:00 +0300
MIME-Version: 1.0
In-Reply-To: <20180803174852.6ee5c889@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On  4.08.2018 00:48, Steven Rostedt wrote:
> On Fri,  3 Aug 2018 17:29:33 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> --- /dev/null
>> +++ b/kernel-shark-qt/src/libkshark-model.h
>> @@ -0,0 +1,149 @@
>> +/* SPDX-License-Identifier: LGPL-2.1 */
>> +
>> +/*
>> + * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
>> + */
>> +
>> + /**
>> +  *  @file    libkshark-model.h
>> +  *  @brief   Visualization model for FTRACE (trace-cmd) data.
>> +  */
>> +
>> +#ifndef _LIB_KSHARK_MODEL_H
>> +#define _LIB_KSHARK_MODEL_H
>> +
>> +// KernelShark
>> +#include "libkshark.h"
>> +
>> +#ifdef __cplusplus
>> +extern "C" {
>> +#endif // __cplusplus
>> +
>> +/**
>> + * Overflow Bin identifiers. The two overflow bins are used to hold the data
>> + * outside the visualized range.
>> + */
>> +enum OverflowBin {
>> +	/**
>> +	 * Identifier of the Upper Overflow Bin. This bin is used to hold the data
>> +	 * before (in time) the beginning of the visualized range.
>> +	 */
>> +	UPPER_OVERFLOW_BIN = -1,
>> +
>> +	/** Identifier of the Lower Overflow Bin. This bin is used to hold the data
>> +	 * after (in time) the end of the visualized range.*/
>> +	LOWER_OVERFLOW_BIN = -2,
> 
> Wait, I thought the upper overflow bin was to store the data after the
> visualized range and the lower overnflow bin the time before?
> 

Correct, I have to swap the tow descriptions.

> 
>> +};
>> +
>> +/** Structure describing the current state of the visualization model. */
> 
> 
>> +static size_t ksmodel_set_lower_edge(struct kshark_trace_histo *histo)
>> +{
>> +	/*
>> +	 * Find the index of the first entry inside
>> +	 * the range (timestamp > min).
>> +	 */
this comment contains a mistake as well. It has to be:
	 /*
	  * Find the index of the first entry inside
	  * the range (timestamp >= min). Note that the
	  * value of min is considered inside the range.
	  */

>> +	ssize_t row = kshark_find_entry_by_time(histo->min,
>> +						histo->data,
>> +						0,
>> +						histo->data_size - 1);
>> +
>> +	assert(row != BSEARCH_ALL_SMALLER);
>> +
>> +	if (row == BSEARCH_ALL_GREATER || row == 0) {
> 
> LOB(hist) is set by the lower row (which is less in time isn't it?)


If the data[0]->ts == histo->min, "row" will be equal to 0. If the 
data-sat starts after histo->min (in time) then "row" will be
equal to BSEARCH_ALL_GREATER. In both cases the LOB is empty.

> 
>> +		/* Lower Overflow bin is empty. */
>> +		histo->map[LOB(histo)] = KS_EMPTY_BIN;
>> +		histo->bin_count[LOB(histo)] = 0;
>> +		row = 0;
>> +	} else {
>> +		/*
>> +		 * The first entry inside the range is not the first entry
>> +		 * of the dataset. This means that the Lower Overflow bin
>> +		 * contains data.
>> +		 */
>> +
>> +		/* Lower Overflow bin starts at "0". */
>> +		histo->map[LOB(histo)] = 0;
>> +
>> +		/*
>> +		 * The number of entries inside the Lower Overflow bin is
>> +		 * equal to the index of the first entry inside the range.
>> +		 */
>> +		histo->bin_count[LOB(histo)] = row;
>> +	}
>> +
>> +	/*
>> +	 * Now check if the first entry inside the range falls into the
>> +	 * first bin.
>> +	 */
>> +	if (histo->data[row]->ts < histo->min + histo->bin_size) {
>> +		/*
>> +		 * It is inside the first bin. Set the beginning
>> +		 * of the first bin.
>> +		 */
>> +		histo->map[0] = row;
>> +	} else {
>> +		/* The first bin is empty. */
>> +		histo->map[0] = KS_EMPTY_BIN;
>> +	}
>> +
>> +	return row;
>> +}
>> +
>> +static size_t ksmodel_set_upper_edge(struct kshark_trace_histo *histo)
>> +{
>> +	/*
>> +	 * Find the index of the first entry outside the range
>> +	 * (timestamp > max). Remember that kshark_find_entry_by_time returns
>> +	 * the first entry which is equal or greater than the reference time.
>> +	 */

I will change this comment as well:
	/*
	 * Find the index of the first entry outside the range
	 * (timestamp > max). Note that the value of max is considered
	 * inside the range. Remember that kshark_find_entry_by_time
	 * returns the first entry which is equal or greater than the
	 * reference time.
	 */

>> +	ssize_t row = kshark_find_entry_by_time(histo->max + 1,

Here we search for "histo->max + 1"

>> +						histo->data,
>> +						0,
>> +						histo->data_size - 1);
>> +
>> +	assert(row != BSEARCH_ALL_GREATER);
>> +
>> +	if (row == BSEARCH_ALL_SMALLER || row == histo->data_size - 1) {
> 

And I have a bug here. it has to be:

	if (row == BSEARCH_ALL_SMALLER) {


I will send this patch again.
Thanks!
Yordan


> UOB(histo) is set by the highest row. Right?
> 
> -- Steve
> 
>> +		/* Upper Overflow bin is empty. */
>> +		histo->map[UOB(histo)] = KS_EMPTY_BIN;
>> +		histo->bin_count[UOB(histo)] = 0;
>> +	} else {
>> +		/*
>> +		 * The Upper Overflow bin contains data. Set its beginning
>> +		 * and the number of entries.
>> +		 */
>> +		histo->map[UOB(histo)] = row;
>> +		histo->bin_count[UOB(histo)] = histo->data_size - row;
>> +	}
>> +
>> +	return row;
>> +}
>> +
