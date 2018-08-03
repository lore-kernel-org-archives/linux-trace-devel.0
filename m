Return-Path: <SRS0=opg7=KS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:36962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729828AbeHCXrA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Aug 2018 19:47:00 -0400
Date: Fri, 3 Aug 2018 17:48:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 2/6] kernel-shark-qt: Introduce the visualization
 model used by the Qt-based KS
Message-ID: <20180803174852.6ee5c889@gandalf.local.home>
In-Reply-To: <20180803142937.3970-3-y.karadz@gmail.com>
References: <20180803142937.3970-1-y.karadz@gmail.com>
        <20180803142937.3970-3-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri,  3 Aug 2018 17:29:33 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> --- /dev/null
> +++ b/kernel-shark-qt/src/libkshark-model.h
> @@ -0,0 +1,149 @@
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
> +/**
> + * Overflow Bin identifiers. The two overflow bins are used to hold the data
> + * outside the visualized range.
> + */
> +enum OverflowBin {
> +	/**
> +	 * Identifier of the Upper Overflow Bin. This bin is used to hold the data
> +	 * before (in time) the beginning of the visualized range.
> +	 */
> +	UPPER_OVERFLOW_BIN = -1,
> +
> +	/** Identifier of the Lower Overflow Bin. This bin is used to hold the data
> +	 * after (in time) the end of the visualized range.*/
> +	LOWER_OVERFLOW_BIN = -2,

Wait, I thought the upper overflow bin was to store the data after the
visualized range and the lower overnflow bin the time before?


> +};
> +
> +/** Structure describing the current state of the visualization model. */


> +static size_t ksmodel_set_lower_edge(struct kshark_trace_histo *histo)
> +{
> +	/*
> +	 * Find the index of the first entry inside
> +	 * the range (timestamp > min).
> +	 */
> +	ssize_t row = kshark_find_entry_by_time(histo->min,
> +						histo->data,
> +						0,
> +						histo->data_size - 1);
> +
> +	assert(row != BSEARCH_ALL_SMALLER);
> +
> +	if (row == BSEARCH_ALL_GREATER || row == 0) {

LOB(hist) is set by the lower row (which is less in time isn't it?)

> +		/* Lower Overflow bin is empty. */
> +		histo->map[LOB(histo)] = KS_EMPTY_BIN;
> +		histo->bin_count[LOB(histo)] = 0;
> +		row = 0;
> +	} else {
> +		/*
> +		 * The first entry inside the range is not the first entry
> +		 * of the dataset. This means that the Lower Overflow bin
> +		 * contains data.
> +		 */
> +
> +		/* Lower Overflow bin starts at "0". */
> +		histo->map[LOB(histo)] = 0;
> +
> +		/*
> +		 * The number of entries inside the Lower Overflow bin is
> +		 * equal to the index of the first entry inside the range.
> +		 */
> +		histo->bin_count[LOB(histo)] = row;
> +	}
> +
> +	/*
> +	 * Now check if the first entry inside the range falls into the
> +	 * first bin.
> +	 */
> +	if (histo->data[row]->ts < histo->min + histo->bin_size) {
> +		/*
> +		 * It is inside the first bin. Set the beginning
> +		 * of the first bin.
> +		 */
> +		histo->map[0] = row;
> +	} else {
> +		/* The first bin is empty. */
> +		histo->map[0] = KS_EMPTY_BIN;
> +	}
> +
> +	return row;
> +}
> +
> +static size_t ksmodel_set_upper_edge(struct kshark_trace_histo *histo)
> +{
> +	/*
> +	 * Find the index of the first entry outside the range
> +	 * (timestamp > max). Remember that kshark_find_entry_by_time returns
> +	 * the first entry which is equal or greater than the reference time.
> +	 */
> +	ssize_t row = kshark_find_entry_by_time(histo->max + 1,
> +						histo->data,
> +						0,
> +						histo->data_size - 1);
> +
> +	assert(row != BSEARCH_ALL_GREATER);
> +
> +	if (row == BSEARCH_ALL_SMALLER || row == histo->data_size - 1) {

UOB(histo) is set by the highest row. Right?

-- Steve

> +		/* Upper Overflow bin is empty. */
> +		histo->map[UOB(histo)] = KS_EMPTY_BIN;
> +		histo->bin_count[UOB(histo)] = 0;
> +	} else {
> +		/*
> +		 * The Upper Overflow bin contains data. Set its beginning
> +		 * and the number of entries.
> +		 */
> +		histo->map[UOB(histo)] = row;
> +		histo->bin_count[UOB(histo)] = histo->data_size - row;
> +	}
> +
> +	return row;
> +}
> +
