Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:44798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729617AbeHAUhu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Aug 2018 16:37:50 -0400
Date: Wed, 1 Aug 2018 14:50:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] kernel-shark-qt: Introduce the visualization
 model used by the Qt-based KS
Message-ID: <20180801145040.47352585@gandalf.local.home>
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

> index 0000000..15391a9
> --- /dev/null
> +++ b/kernel-shark-qt/src/libkshark-model.h
> @@ -0,0 +1,142 @@
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

Should add what an "Overflow Bin" is.

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

	/** The size of the above data array */

> +	size_t			data_size;
> +
> +	/** The index of the first entry in each bin. */

	/** The first entry (index of data array) in each bin */

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

	/** The size in time for each bin */

> +	uint64_t		bin_size;
> +
> +	/** Number of bins. */
> +	int			n_bins;
> +};

The rest looks good. Ug that was a big patch to review! ;-)

-- Steve

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
> +int ksmodel_get_cpu_front(struct kshark_trace_histo *histo,
> +			  int bin, int pid, bool vis_only,
> +			  ssize_t *index);
> +
> +int ksmodel_get_cpu_back(struct kshark_trace_histo *histo,
> +			 int bin, int pid, bool vis_only,
> +			 ssize_t *index);
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
