Return-Path: <SRS0=opg7=KS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:54374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727857AbeHCUlC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Aug 2018 16:41:02 -0400
Date: Fri, 3 Aug 2018 14:43:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 2/6] kernel-shark-qt: Introduce the visualization
 model used by the Qt-based KS
Message-ID: <20180803144330.707c09c9@gandalf.local.home>
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

FYI, git warned me about bad whitespace in this patch:

.git/rebase-apply/patch:357: trailing whitespace.

.git/rebase-apply/patch:467: trailing whitespace.

.git/rebase-apply/patch:875: trailing whitespace.

And doing a git show I find:

> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark-qt/src/CMakeLists.txt    |    3 +-
>  kernel-shark-qt/src/libkshark-model.c | 1182 +++++++++++++++++++++++++
>  kernel-shark-qt/src/libkshark-model.h |  149 ++++
>  3 files changed, 1333 insertions(+), 1 deletion(-)
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
> index 0000000..d750886
> --- /dev/null
> +++ b/kernel-shark-qt/src/libkshark-model.c


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
> +	if (histo->map[LOB(histo)] != KS_EMPTY_BIN) {
> +		prev_not_empty = LOB(histo);
> +	} else {
> +		/* Loop till the first non-empty bin. */
> +		while (histo->map[i] < 0) {
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
> +	for (; i < histo->n_bins; ++i) {
> +		if (histo->map[i] != KS_EMPTY_BIN) {
> +			/* The current bin is not empty, take its data row and
> +			 * subtract it from the data row of the previous not
> +			 * empty bin, which will give us the number of data
> +			 * rows in the "prev_not_empty" bin.
> +			 */
> +			histo->bin_count[prev_not_empty] =
> +				histo->map[i] - histo->map[prev_not_empty];
> +	

The above line has a superfluous tab.

> +			prev_not_empty = i;
> +		}
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



> +/**
> + * @brief Shift the time-window of the model forward. Recalculate the current
> + *	  state of the model.
> + *
> + * @param histo: Input location for the model descriptor.
> + * @param n: Number of bins to shift.
> + */
> +void ksmodel_shift_forward(struct kshark_trace_histo *histo, size_t n)
> +{
> +	size_t last_row = 0;
> +	int bin;
> +	

Here too.

> +	if (!histo->data_size)
> +		return;
> +
> +	if (histo->map[UOB(histo)] == KS_EMPTY_BIN) {
> +		/*
> +		 * The Upper Overflow bin is empty. This means that we are at
> +		 * the upper edge of the dataset already. Do nothing in this
> +		 * case.
> +		 */
> +		return;
> +	}



> +/**
> + * @brief Get the index of the first entry from a given Task in a given bin.
> + *
> + * @param histo: Input location for the model descriptor.
> + * @param bin: Bin id.
> + * @param pid: Process Id of a task.
> + *
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

Here too.

Don't worry about fixing these unless you need to resend. I'll just fix
them in my repo.

-- Steve

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
