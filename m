Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:59254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732863AbeHACeL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 Jul 2018 22:34:11 -0400
Date: Tue, 31 Jul 2018 20:51:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH v2 3/7] kernel-shark-qt: Introduce the visualization
 model used by the Qt-based KS
Message-ID: <20180731205113.2fe79e72@gandalf.local.home>
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
> index 0000000..4a4e910
> --- /dev/null
> +++ b/kernel-shark-qt/src/libkshark-model.c
> @@ -0,0 +1,1135 @@
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

Needs comment here explaining what these are.

> +#define UOB(histo) (histo->n_bins)
> +#define LOB(histo) (histo->n_bins + 1)

Perhaps add:

/* For all bins */
# define ALLB(histo) LOB(histo)

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
> +	free(histo->map);
> +	free(histo->bin_count);
> +	ksmodel_init(histo);
> +}
> +
> +static void ksmodel_reset_bins(struct kshark_trace_histo *histo,
> +			       size_t first, size_t last)
> +{
> +	/* Reset the content of the bins. */
> +	memset(&histo->map[first], KS_EMPTY_BIN,
> +	       (last - first + 1) * sizeof(histo->map[0]));

This patch should add a comment here and by KS_EMPTY_BIN stating that
KS_EMPTY_BIN is expected to be -1, as it is used to reset the entire
array with memset(). As memset() only updates an array to a single
byte, that byte must be the same throughout. Which works for zero and
-1.

> +
> +	memset(&histo->bin_count[first], 0,
> +	       (last - first + 1) * sizeof(histo->bin_count[0]));
> +}
> +
> +static bool ksmodel_histo_alloc(struct kshark_trace_histo *histo, size_t n)
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
> +		return false;
> +	}
> +
> +	histo->n_bins = n;
> +
> +	return true;
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
> +		if (!ksmodel_histo_alloc(histo, n)) {
> +			ksmodel_clear(histo);
> +			return;
> +		}
> +	}
> +
> +	/* Reset the content of all bins (including overflow bins) to zero. */
> +	ksmodel_reset_bins(histo, 0, histo->n_bins + 1);

Here we could then have:

	ksmodel_reset_bins(histo, 0, ALLB(histo));

> +
> +	if (range % n == 0) {
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

Hmm, Let's say the range of the data is 0..1,000,001 and we picked a
range of 999,999 starting at 0. And there's 1024 buckets. This would
have:

min = 0; max = 999999; n = 1024; range = 999999;

bin_size = 999999 / 1024 + 1 = 977;
correct_range = 977 * 1024 = 1000448;
delta_rang = 1000448 - 999999 = 449;
histo->min = 0 - 449 / 2 = -224;
histo->max = -224 + 1000448 = 1000224;

Now histo->min (-224) < histo->data[0]->ts (0) so

histo->min = 0;
histo->max = 0 + 1000448 = 1000448;

Thus we get max greater than the data set.

Actually, we would always get a range greater than the data set, if the
data set itself is not divisible by the bin size. This that a problem?

-- Steve

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
>
