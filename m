Return-Path: <SRS0=6QNz=DW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C35C433E7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Oct 2020 21:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 484CF2076A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Oct 2020 21:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbgJOVYX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Oct 2020 17:24:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728409AbgJOVYX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Oct 2020 17:24:23 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A5E220759;
        Thu, 15 Oct 2020 21:24:22 +0000 (UTC)
Date:   Thu, 15 Oct 2020 17:24:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v24 01/10] trace-cmd: [POC] PTP-like algorithm for host
 - guest timestamp synchronization
Message-ID: <20201015172420.699a4cdc@gandalf.local.home>
In-Reply-To: <20201009140338.25260-2-tz.stoyanov@gmail.com>
References: <20201009140338.25260-1-tz.stoyanov@gmail.com>
        <20201009140338.25260-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  9 Oct 2020 17:03:29 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> PTP protocol is designed for synchronizing clocks of machines in a local network.
> The same approach can be used for host - guest timestamp synchronization.
> This implementation uses ftrace raw markers to track trace timestamps of PTP events.
> The patch is a POC, two different algorithms for PTP calculations are proposed:
>   - Choosing the sample with the fastest response time for calculating the clocks offset.
>   - Calculating the clocks offset using the average of all PTP samples.
> 
> The implementation can be tuned using those parameters:
>  - #define FASTEST_RESPONSE - is defined, the sample with the fastest response time
>     is used for calculating the clocks offset. Otherwise the histogram of all samples is used.
>  - #define PTP_SYNC_LOOP 340 - defines the number of samples, used for one calculation.
>  - --tsync-interval - a trace-cmd argument, choose the intervals between offset calculations,
> 	performed continuously during the trace.
>  - #define TSYNC_DEBUG - if defined, a debug information is collected and stored in files,
>    in the guest machine:
>      s-cid*.txt - For each offset calculation: host and guest clocks and calculated offset.
>      res-cid*.txt - For each tracing session: all calculated clock offsets.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h      |   1 +
>  lib/trace-cmd/Makefile             |   1 +
>  lib/trace-cmd/trace-timesync-ptp.c | 690 +++++++++++++++++++++++++++++
>  lib/trace-cmd/trace-timesync.c     |   8 +
>  tracecmd/trace-agent.c             |   2 +
>  tracecmd/trace-record.c            |  23 +-
>  6 files changed, 717 insertions(+), 8 deletions(-)
>  create mode 100644 lib/trace-cmd/trace-timesync-ptp.c
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index f3c95f30..f9c1f843 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -419,6 +419,7 @@ int tracecmd_msg_recv_time_sync(struct tracecmd_msg_handle *msg_handle,
>  
>  enum{
>  	TRACECMD_TIME_SYNC_PROTO_NONE	= 0,
> +	TRACECMD_TIME_SYNC_PROTO_PTP	= 1,
>  };
>  enum{
>  	TRACECMD_TIME_SYNC_CMD_PROBE	= 1,
> diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
> index 666a1ebf..7cab7514 100644
> --- a/lib/trace-cmd/Makefile
> +++ b/lib/trace-cmd/Makefile
> @@ -18,6 +18,7 @@ OBJS += trace-msg.o
>  OBJS += trace-plugin.o
>  ifeq ($(VSOCK_DEFINED), 1)
>  OBJS += trace-timesync.o
> +OBJS += trace-timesync-ptp.o
>  endif
>  
>  # Additional util objects
> diff --git a/lib/trace-cmd/trace-timesync-ptp.c b/lib/trace-cmd/trace-timesync-ptp.c
> new file mode 100644
> index 00000000..19e2f647
> --- /dev/null
> +++ b/lib/trace-cmd/trace-timesync-ptp.c
> @@ -0,0 +1,690 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2019, VMware, Tzvetomir Stoyanov tz.stoyanov@gmail.com>
> + *
> + */
> +
> +#include <fcntl.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <arpa/inet.h>
> +#include <linux/vm_sockets.h>
> +#include <sys/types.h>
> +#include <linux/types.h>
> +#include <time.h>
> +#include <sched.h>
> +#include "trace-cmd.h"
> +#include "tracefs.h"
> +#include "trace-tsync-local.h"
> +#include "trace-msg.h"
> +#include "trace-cmd-local.h"
> +
> +typedef __be32 be32;
> +typedef __u64 u64;
> +typedef __s64 s64;
> +
> +#define PTP_SYNC_LOOP	340
> +
> +#define PTP_SYNC_PKT_START	1
> +#define PTP_SYNC_PKT_PROBE	2
> +#define PTP_SYNC_PKT_PROBES	3
> +#define PTP_SYNC_PKT_OFFSET	4
> +#define PTP_SYNC_PKT_END	5
> +
> +/* print time sync debug messages */
> +#define TSYNC_DEBUG
> +
> +struct ptp_clock_sync {
> +	struct tep_handle	*tep;
> +	int			raw_id;
> +	int			marker_fd;
> +	int			series_id;
> +	int			flags;
> +	int			debug_fd;
> +};
> +
> +enum {
> +/* Consider only the probe with fastest response time,
> + * otherwise make a histogram from all probes.
> + */
> +	PTP_FLAG_FASTEST_RESPONSE		= (1 << 0),
> +/* Use trace marker to get the clock,
> + * otherwise use directly the system clock
> + */

Nit, multi-line comments should be:

/*
 * Use trace marker to get the clock,
 * otherwise use directly the system clock
 */

Although Linux networking code does the above, that's only allowed because
Linus likes David Miller, and he allows him to request that in his
networking code. ;-)

Also, the grammar of the above should be:

 "Use trace marker to get the clock, otherwise use the system clock
 directly."



> +	PTP_FLAG_USE_MARKER			= (1 << 1),
> +};
> +static int ptp_flags = PTP_FLAG_FASTEST_RESPONSE | PTP_FLAG_USE_MARKER;
> +
> +struct ptp_clock_start_msg {
> +	be32	series_id;
> +	be32	flags;
> +} __attribute__((packed));

We should define a macro: __packed and use that instead. Makes the code
look cleaner.

> +
> +struct ptp_clock_sample {
> +	s64		ts;
> +	be32		id;
> +} __attribute__((packed));
> +
> +struct ptp_clock_result_msg {
> +	be32			series_id;
> +	be32			count;
> +	struct ptp_clock_sample	samples[2*PTP_SYNC_LOOP];
> +} __attribute__((packed));
> +
> +struct ptp_clock_offset_msg {
> +	s64	ts;
> +	s64	offset;
> +};
> +
> +struct ptp_markers_context {
> +	struct clock_sync_context	*clock;
> +	struct ptp_clock_sync		*ptp;
> +	int				size;
> +	struct ptp_clock_result_msg	msg;
> +};

Me being picky about holes in structures, as "int" is 4 bytes, it should be
either at the end or mapped with other elements of 4 bytes. That is, msg
and size should be swapped.

> +
> +struct ptp_marker_buf {
> +	int local_cid;
> +	int remote_cid;
> +	int count;
> +	int packet_id;
> +} __attribute__((packed));
> +
> +struct ptp_marker {
> +	int series_id;
> +	struct ptp_marker_buf data;
> +} __attribute__((packed));
> +
> +static int ptp_clock_sync_init(struct tracecmd_time_sync *tsync)
> +{
> +	const char *systems[] = {"ftrace", NULL};
> +	struct clock_sync_context *clock_context;
> +	struct ptp_clock_sync *ptp;
> +	struct tep_event *raw;
> +	char *path;
> +
> +	if (!tsync || !tsync->context)
> +		return -1;
> +	clock_context = (struct clock_sync_context *)tsync->context;
> +	if (clock_context->proto_data)
> +		return 0;
> +
> +	ptp = calloc(1, sizeof(struct ptp_clock_sync));
> +	if (!ptp)
> +		return -1;
> +
> +	ptp->marker_fd = -1;
> +	ptp->debug_fd = -1;
> +
> +	path = tracefs_instance_get_dir(clock_context->instance);
> +	if (!path)
> +		goto error;
> +	ptp->tep = tracefs_local_events_system(path, systems);
> +	tracefs_put_tracing_file(path);
> +	if (!ptp->tep)
> +		goto error;
> +	raw = tep_find_event_by_name(ptp->tep, "ftrace", "raw_data");
> +	if (!raw)
> +		goto error;
> +
> +	ptp->raw_id = raw->id;
> +	tep_set_file_bigendian(ptp->tep, tracecmd_host_bigendian());
> +	tep_set_local_bigendian(ptp->tep, tracecmd_host_bigendian());
> +
> +	path = tracefs_instance_get_file(clock_context->instance, "trace_marker_raw");
> +	if (!path)
> +		goto error;
> +	ptp->marker_fd = open(path, O_WRONLY);
> +	tracefs_put_tracing_file(path);
> +
> +	clock_context->proto_data = ptp;
> +
> +#ifdef TSYNC_DEBUG
> +	if (clock_context->is_server) {
> +		char buff[256];
> +		int res_fd;
> +
> +		sprintf(buff, "res-cid%d.txt", clock_context->remote_cid);
> +
> +		res_fd = open(buff, O_CREAT|O_WRONLY|O_TRUNC, 0644);
> +		if (res_fd > 0)
> +			close(res_fd);
> +	}
> +#endif
> +
> +	return 0;
> +
> +error:
> +	if (ptp) {
> +		tep_free(ptp->tep);
> +		if (ptp->marker_fd >= 0)
> +			close(ptp->marker_fd);
> +	}
> +	free(ptp);
> +	return -1;
> +}
> +
> +static int ptp_clock_sync_free(struct tracecmd_time_sync *tsync)
> +{
> +	struct clock_sync_context *clock_context;
> +	struct ptp_clock_sync *ptp;
> +
> +	if (!tsync || !tsync->context)
> +		return -1;
> +	clock_context = (struct clock_sync_context *)tsync->context;
> +
> +	if (clock_context && clock_context->proto_data) {
> +		ptp = (struct ptp_clock_sync *)clock_context->proto_data;
> +		tep_free(ptp->tep);
> +		if (ptp->marker_fd >= 0)
> +			close(ptp->marker_fd);
> +		if (ptp->debug_fd >= 0)
> +			close(ptp->debug_fd);
> +		free(clock_context->proto_data);
> +		clock_context->proto_data = NULL;
> +	}
> +	return 0;
> +}
> +
> +static void ptp_probe_store(struct ptp_markers_context *ctx,
> +			    struct ptp_marker *marker,
> +			    unsigned long long ts)
> +{
> +	int index = -1;
> +
> +	if (marker->data.packet_id == 'r' &&
> +	    marker->data.count <= ctx->size) {
> +		index = marker->data.count - 1;
> +	} else if (marker->data.packet_id == 's' &&
> +		  marker->data.count*2 <= ctx->size){
> +		index = ctx->size / 2 + marker->data.count - 1;

These calculations should be turned into macros, or at the very least have
comments to why this is done.

Also, data.count for both should always be less than or equal ctx->size /
2, right?

If the ctx->size is for both, then the count should only be half. Wouldn't
the 'r' packet start writing over the 's' packets if it is not? If this is
the case, then we could simplify this to:

	if (marker->data.count > ctx->size / 2)
		return;

	index = marker->data_count - 1;

	switch (marker->data.packet_id) {
	case 'r':
		break;
	case 's':
		index += ctx->size / 2;
		break;
	default:
		return;
	}

	ctx->msg.samples[index].id = marker->data.count;
	ctx->msg.samples[index].ts = ts;
	ctx->msg.count++;

BTW, when would the samples[index].id ever equal to something other than
the index + 1, or index + size / 2 + 1?

> +	}
> +
> +	if (index >= 0) {
> +		ctx->msg.samples[index].id = marker->data.count;
> +		ctx->msg.samples[index].ts = ts;
> +		ctx->msg.count++;
> +	}
> +}
> +
> +static int ptp_marker_find(struct tep_event *event, struct tep_record *record,
> +			   int cpu, void *context)
> +{
> +	struct ptp_markers_context *ctx;
> +	struct tep_format_field *field;
> +	struct tep_format_field *id;
> +	struct ptp_marker *marker;
> +
> +	ctx = (struct ptp_markers_context *)context;
> +
> +	/* Make sure this is our event */
> +	if (event->id != ctx->ptp->raw_id)
> +		return 0;
> +	id = tep_find_field(event, "id");
> +	field = tep_find_field(event, "buf");

These probably could be saved and reused, instead of searching for them
each time. Could probably be saved in the context before even calling this.
Save the id and field when saving the raw_id.

> +	if (field && id &&
> +	    record->size >= (id->offset + sizeof(struct ptp_marker))) {
> +		marker = (struct ptp_marker *)(record->data + id->offset);
> +		if (marker->data.local_cid == ctx->clock->local_cid &&
> +		    marker->data.remote_cid == ctx->clock->remote_cid &&
> +		    marker->series_id == ctx->ptp->series_id &&
> +		    marker->data.count)
> +			ptp_probe_store(ctx, marker, record->ts);
> +	}
> +
> +	return 0;
> +}
> +
> +static int ptp_calc_offset_fastest(struct clock_sync_context *clock,
> +			   struct ptp_clock_result_msg *server,
> +			   struct ptp_clock_result_msg *client,
> +			   long long *offset_ret, long long *ts_ret,
> +			   int *bad_probes)
> +{
> +	struct ptp_clock_sample *sample_send;
> +	long long delta_min = 0;

If you set delta_min to LLONG_MAX...

> +	long long offset = 0;
> +	long long delta = 0;
> +	long long ts = 0;
> +	int i;
> +
> +	*bad_probes = 0;
> +	sample_send = server->samples + (server->count / 2);
> +	for (i = 0; i * 2 < server->count && i < client->count; i++) {

Instead of both checks, you could have:

	max_i = server->count / 2 < client->count ? server->count / 2 :
		client->count;

	for (i = 0; i < max_i; i++) {

> +		if (!server->samples[i].ts ||
> +		    !sample_send[i].ts ||
> +		    !client->samples[i].ts ||
> +		    server->samples[i].id != sample_send[i].id ||
> +		    server->samples[i].id != client->samples[i].id) {
> +			(*bad_probes)++;
> +			continue;
> +		}
> +
> +		ts = (sample_send[i].ts + server->samples[i].ts) / 2;
> +		offset = client->samples[i].ts - ts;
> +
> +		delta = server->samples[i].ts - sample_send[i].ts;
> +		if (!delta_min || delta_min > delta) {

... you can make this just (delta_min > delta) and not check the !delta_min.

> +			delta_min = delta;
> +			*offset_ret = offset;
> +			*ts_ret = ts;
> +		}
> +#ifdef TSYNC_DEBUG
> +		{
> +			struct ptp_clock_sync *ptp;
> +
> +			ptp = (struct ptp_clock_sync *)clock->proto_data;
> +			if (ptp && ptp->debug_fd > 0) {
> +				char buff[256];
> +
> +				sprintf(buff, "%lld %lld %lld\n",
> +					ts, client->samples[i].ts, offset);
> +				write(ptp->debug_fd, buff, strlen(buff));
> +			}
> +		}
> +#endif
> +	}
> +
> +	return 0;
> +}
> +
> +static int ptp_calc_offset_hist(struct clock_sync_context *clock,
> +			   struct ptp_clock_result_msg *server,
> +			   struct ptp_clock_result_msg *client,
> +			   long long *offset_ret, long long *ts_ret,
> +			   int *bad_probes)
> +{
> +	struct ptp_clock_sample *sample_send;
> +	long long timestamps[PTP_SYNC_LOOP];
> +	long long offsets[PTP_SYNC_LOOP];
> +	int hist[PTP_SYNC_LOOP];
> +	long long offset_max = 0;
> +	long long offset_min = 0;
> +	int ind, max = 0;
> +	long long bin;
> +	int i, k = 0;
> +
> +	*bad_probes = 0;
> +	memset(hist, 0, sizeof(int) * PTP_SYNC_LOOP);
> +	sample_send = server->samples + (server->count / 2);
> +	for (i = 0; i * 2 < server->count && i < client->count; i++) {
> +		if (!server->samples[i].ts ||
> +		    !sample_send[i].ts ||
> +		    !client->samples[i].ts ||
> +		    server->samples[i].id != sample_send[i].id ||
> +		    server->samples[i].id != client->samples[i].id) {
> +			(*bad_probes)++;
> +			continue;

Since this check is done twice, it would be good to make it into a static
inline function:

static inline bool good_probe(struct ptp_clock_sample *server_sample,
			      struct ptp_clock_sample *send_sample,
			      struct ptp_clock_sample *client_sample,
			      int *bad_probes)
{
	if (server_sample->ts && send_sample->ts && client_sample->ts &&
	    server_sample->id == send_sample->id &&
	    server_sample->id == client_sample->id)
		return true;
	(*bad_probes)++;
	return false;
}

Then you just need:

		if (!good_sample(&server->samples[i], &sample_send[i],
				 &client->samples[i], bad_probes))
			continue;

for both locations.

> +		}
> +
> +		timestamps[k] = (sample_send[i].ts + server->samples[i].ts) / 2;
> +		offsets[k] = client->samples[i].ts - timestamps[k];
> +		if (!offset_max || offset_max < llabs(offsets[k]))
> +			offset_max = llabs(offsets[k]);

No need for the offset_max check.

> +		if (!offset_min || offset_min > llabs(offsets[k]))

Same trick with LLONG_MAX.

> +			offset_min = llabs(offsets[k]);
> +#ifdef TSYNC_DEBUG
> +		{
> +			struct ptp_clock_sync *ptp;
> +
> +			ptp = (struct ptp_clock_sync *)clock->proto_data;
> +
> +			if (ptp && ptp->debug_fd > 0) {
> +				char buff[256];
> +
> +				sprintf(buff, "%lld %lld %lld\n",
> +					timestamps[k],
> +					client->samples[i].ts, offsets[k]);
> +				write(ptp->debug_fd, buff, strlen(buff));
> +			}
> +		}
> +#endif
> +		k++;
> +	}
> +
> +	bin = (offset_max - offset_min) / PTP_SYNC_LOOP;
> +	for (i = 0; i < k; i++) {
> +		ind = (llabs(offsets[i]) - offset_min) / bin;
> +		if (ind < PTP_SYNC_LOOP) {
> +			hist[ind]++;
> +			if (max < hist[ind]) {
> +				max = hist[ind];
> +				*offset_ret = offsets[i];
> +				*ts_ret = timestamps[i];
> +			}

I'm curious to how accurate this is?

-- Steve

> +		}
> +	}
> +
> +	return 0;
> +}
> +
