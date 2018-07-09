Return-Path: <SRS0=sAIo=JZ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:54728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933543AbeGIP5K (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Jul 2018 11:57:10 -0400
Date: Mon, 9 Jul 2018 11:57:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 3/9] kernel-shark-qt: Add API for loading trace.dat
 files
Message-ID: <20180709115707.15239a56@gandalf.local.home>
In-Reply-To: <20180702140424.23221-3-y.karadz@gmail.com>
References: <20180702140424.23221-1-y.karadz@gmail.com>
        <20180702140424.23221-3-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon,  2 Jul 2018 17:04:18 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
> new file mode 100644
> index 0000000..b59c94c
> --- /dev/null
> +++ b/kernel-shark-qt/src/libkshark.h
> @@ -0,0 +1,114 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +
> +/*
> + * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> + /**
> + *  @file    libkshark.h
> + *  @brief   API for processing of FTRACE (trace-cmd) data.
> + */
> +
> +#ifndef _LIB_KSHARK_H
> +#define _LIB_KSHARK_H
> +
> +// C
> +#include <stdint.h>
> +#include <pthread.h>
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +
> +// trace-cmd
> +#include "trace-cmd.h"
> +#include "event-parse.h"
> +#include "trace-filter-hash.h"
> +

Making updates, I notice some issues here.

> +/**
> + * Kernel Shark entry contains all information from one trace record needed
> + * in order to  visualize the time-series of trace records. The part of the
> + * data which is not directly required for the visualization (latency, record
> + * info etc.) is available on-demand via the offset into the trace file.
> + */
> +struct kshark_entry {
> +	/**
> +	 * A bit mask controlling the visibility of the entry. A value of OxFF
> +	 * would mean that the entry is visible everywhere.
> +	 */
> +	uint8_t		visible;
> +
> +	/** The CPU core of the record. */
> +	uint8_t		cpu;

One byte is too small. We already have boxes that I trace with over
1000 CPUs.

> +
> +	/** The PID of the task the record was generated. */
> +	int16_t		pid;

16bits is too small for pid. There's work to have it grow to 32 bits.

I know it's going to take up more memory, but both of these will need
to grow to at 32bits. Perhaps we can combine the cpu and visible into
one 32 bits, where we reserve the MSBs for flags for visible. But to do
that, one needs to be concerned about updates to them.

-- Steve


> +
> +	/** Unique Id ot the trace event type. */
> +	int		event_id;
> +
> +	/** The offset into the trace file, used to find the record. */
> +	uint64_t	offset;
> +
> +	/**
> +	 * The time of the record in nano seconds. The value is taken from
> +	 * the timestamps within the trace data file, which are architecture
> +	 * dependent. The time usually is the timestamp from when the system
> +	 * started.
> +	 */
> +	uint64_t	ts;
> +
> +	/** Pointer to the next (in time) kshark_entry on the same CPU core. */
> +	struct kshark_entry *next;
> +};
> +
