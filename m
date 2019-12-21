Return-Path: <SRS0=3JjO=2L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B59BC43603
	for <linux-trace-devel@archiver.kernel.org>; Sat, 21 Dec 2019 04:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0304521927
	for <linux-trace-devel@archiver.kernel.org>; Sat, 21 Dec 2019 04:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfLUEsc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 23:48:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:45286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbfLUEsc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 23:48:32 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D99D21927;
        Sat, 21 Dec 2019 04:48:31 +0000 (UTC)
Date:   Fri, 20 Dec 2019 23:48:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v18 16/18] trace-cmd: Basic infrastructure for host -
 guest timestamp synchronization
Message-ID: <20191220234829.55000e54@rorschach.local.home>
In-Reply-To: <20191213153029.133570-17-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
        <20191213153029.133570-17-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 13 Dec 2019 17:30:27 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The infrastructure for host - guest timestamp synchronization is divided
> in two parts:
>  - logic in libtracecmd
>  - logic in trace-cmd application
> 
> The libtracecmd is extended with new trace message, MSG_TIME_SYNC, used to
> exchange time synch information between host and guest. The trace request and
> response messages are extended to handle the time synch negotiation. The logic
> is implemented in trace-timesync.c file:
>  - Register / unregister time sync protocols.
>  - Choosing what protocol will be used for a tracing session.
>  - Init common context, used by all protocols - a ftrace instance, vsockets.
>  - Invoke protocol routines to perform time synchronization.
>  - Store calculated offsets in an array.
> 
> The trace-cmd application is extended to perform timestamp synchronization.
> The main logic is in trace-tsync.c file
>  - Negotiate what time synch algorithm will be used for the tracing session.
>  - Run pthreads, to do continuous timestamp synchronization, during the trace.
>  - Store calculated offsets in guest's trace.dat file, using TRACECMD_OPTION_TIME_SHIFT option
>  - A new trace-cmd option is added, to control the timestamp synchronization:
>       --tsync-interval: set the time sync loop interval, in ms. The default
>    value is 0 - timestamp synchronization is performed twice, before and after
>    the trace. If a negative number is specified, the timestamp synchronization
>    is disabled.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  Documentation/trace-cmd-record.1.txt      |   7 +
>  include/trace-cmd/trace-cmd.h             |  59 ++-
>  lib/trace-cmd/Makefile                    |   1 +
>  lib/trace-cmd/include/trace-tsync-local.h |  38 ++
>  lib/trace-cmd/trace-msg.c                 | 394 ++++++++++++++---
>  lib/trace-cmd/trace-timesync.c            | 496 ++++++++++++++++++++++
>  tracecmd/Makefile                         |   3 +-
>  tracecmd/include/trace-local.h            |  11 +
>  tracecmd/trace-agent.c                    |  38 +-
>  tracecmd/trace-record.c                   |  42 +-
>  tracecmd/trace-tsync.c                    | 271 ++++++++++++
>  tracecmd/trace-usage.c                    |   4 +
>  12 files changed, 1297 insertions(+), 67 deletions(-)
>  create mode 100644 lib/trace-cmd/include/trace-tsync-local.h
>  create mode 100644 lib/trace-cmd/trace-timesync.c
>  create mode 100644 tracecmd/trace-tsync.c
> 
> diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
> index 0d75e43..f5ecad5 100644
> --- a/Documentation/trace-cmd-record.1.txt
> +++ b/Documentation/trace-cmd-record.1.txt
> @@ -338,6 +338,13 @@ OPTIONS
>      the offset will also be in nanoseconds even if the displayed units are
>      in microseconds.
>  
> +*--tsync-interval*::
> +    Set the loop interval, in ms, for timestamps synchronization with guests:
> +        If a negative number is specified, timestamps synchronization is disabled
> +        If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
> +        at the beginning and at the end of the trace.
> +        Timestamps synchronization with guests works only if there is support for VSOCK.\n"
> +
>  *--stderr*::
>      Have output go to stderr instead of stdout, but the output of the command
>      executed will not be changed. This is useful if you want to monitor the
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index da8eeaf..bf52785 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -362,19 +362,38 @@ void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
>  
>  int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
>  				int argc, char **argv, bool use_fifos,
> -				unsigned long long trace_id);
> +				unsigned long long trace_id,
> +				char *tsync_protos,
> +				int tsync_protos_size);
> +
>  int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
>  				int *argc, char ***argv, bool *use_fifos,
> -				unsigned long long *trace_id);
> +				unsigned long long *trace_id,
> +				char **tsync_protos,
> +				unsigned int *tsync_protos_size);
>  
>  int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
>  				 int nr_cpus, int page_size,
>  				 unsigned int *ports, bool use_fifos,
> -				 unsigned long long trace_id);
> +				 unsigned long long trace_id,
> +				 unsigned int tsync_proto,
> +				 unsigned int tsync_port);
>  int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
>  				 int *nr_cpus, int *page_size,
>  				 unsigned int **ports, bool *use_fifos,
> -				 unsigned long long *trace_id);
> +				 unsigned long long *trace_id,
> +				 unsigned int *tsync_proto,
> +				 unsigned int *tsync_port);
> +
> +int tracecmd_msg_send_time_sync(struct tracecmd_msg_handle *msg_handle,
> +				unsigned int sync_protocol,
> +				unsigned int sync_msg_id,
> +				unsigned int payload_size, char *payload);
> +int tracecmd_msg_recv_time_sync(struct tracecmd_msg_handle *msg_handle,
> +				unsigned int *sync_protocol,
> +				unsigned int *sync_msg_id,
> +				unsigned int *payload_size, char **payload);
> +
>  /* --- ftrace instances --- */
>  
>  struct tracecmd_instance;
> @@ -407,6 +426,38 @@ int tracecmd_iterate_raw_events(struct tep_handle *tep,
>  				void *callback_context);
>  
>  
> +/* --- Timestamp synchronization --- */
> +
> +enum{
> +	TRACECMD_TIME_SYNC_PROTO_NONE	= 0,
> +};
> +enum{
> +	TRACECMD_TIME_SYNC_CMD_PROBE	= 1,
> +	TRACECMD_TIME_SYNC_CMD_STOP	= 2,
> +};
> +
> +#define TRACECMD_TIME_SYNC_PROTO_PTP_WEIGHT	10
> +
> +struct tracecmd_time_sync {
> +	unsigned int			sync_proto;
> +	int				loop_interval;
> +	pthread_mutex_t			lock;
> +	pthread_cond_t			cond;
> +	char				*clock_str;
> +	struct tracecmd_msg_handle	*msg_handle;
> +	void				*context;
> +};
> +
> +void tracecmd_tsync_init(void);
> +int tracecmd_tsync_proto_getall(char **proto_mask, int *words);
> +unsigned int tracecmd_tsync_proto_select(char *proto_mask, int words);
> +bool tsync_proto_is_supported(unsigned int proto_id);
> +void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
> +void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
> +int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
> +				int *count,
> +				long long **ts, long long **offsets);
> +void tracecmd_tsync_free(struct tracecmd_time_sync *tsync);
>  
>  /* --- Plugin handling --- */
>  extern struct tep_plugin_option trace_ftrace_options[];
> diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
> index 18c7013..6221b36 100644
> --- a/lib/trace-cmd/Makefile
> +++ b/lib/trace-cmd/Makefile
> @@ -16,6 +16,7 @@ OBJS += trace-util.o
>  OBJS += trace-instance.o
>  OBJS += trace-filter-hash.o
>  OBJS += trace-msg.o
> +OBJS += trace-timesync.o
>  
>  # Additional util objects
>  OBJS += trace-blk-hack.o
> diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
> new file mode 100644
> index 0000000..511c838
> --- /dev/null
> +++ b/lib/trace-cmd/include/trace-tsync-local.h
> @@ -0,0 +1,38 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +/*
> + * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> + *
> + */
> +#ifndef _TRACE_TSYNC_LOCAL_H
> +#define _TRACE_TSYNC_LOCAL_H
> +
> +#include <stdbool.h>
> +
> +struct clock_sync_context {
> +	void				*proto_data;	/* time sync protocol specific data */
> +	bool				server;		/* server or guest time sync role */

Let's call this "is_server" as it is a boolean value. "server" looks
like it should be a pointer or something.

> +	struct tracecmd_instance	*vinst;		/* ftrace buffer, used for time sync events */

As this is part of a structure and not a global that would interfere
with other name spaces, I think it should be called "instance", as I
had no idea what "vinst" was when looking at it below. Let's be
consistent and call struct tracecmd_instance "instance" when we can.
That way we know exactly what it is by looking at the name.

> +
> +	/* Arrays with calculated time offsets at given time */
> +	int				sync_size;	/* Allocated size of sync_ts and sync_offsets */
> +	int				sync_count;	/* Number of elements in sync_ts and sync_offsets */
> +	long long			*sync_ts;
> +	long long			*sync_offsets;
> +
> +	/* Identifiers of local and remote time sync peers: cid and port */
> +	unsigned int			local_cid;
> +	unsigned int			local_port;
> +	unsigned int			remote_cid;
> +	unsigned int			remote_port;
> +};
> +
> +int tracecmd_tsync_proto_register(unsigned int proto_id, int weight,
> +				int (*init)(struct tracecmd_time_sync *),
> +				int (*free)(struct tracecmd_time_sync *),
> +				int (*calc)(struct tracecmd_time_sync *,
> +					    long long *, long long *));
> +int tracecmd_tsync_proto_unregister(unsigned int proto_id);
> +
> +int ptp_clock_sync_register(void);
> +
> +#endif /* _TRACE_TSYNC_LOCAL_H */
> diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
> index a34297f..551b9a0 100644
> --- a/lib/trace-cmd/trace-msg.c
> +++ b/lib/trace-cmd/trace-msg.c
> @@ -28,6 +28,8 @@
>  
>  typedef __u32 u32;
>  typedef __be32 be32;
> +typedef __u64 u64;
> +typedef __s64 s64;
>  
>  static inline void dprint(const char *fmt, ...)
>  {
> @@ -60,9 +62,20 @@ struct tracecmd_msg_rinit {
>  	be32 cpus;
>  } __attribute__((packed));
>  
> +#define TRACE_REQ_PARAM_SIZE  (2 * sizeof(int))
> +enum trace_req_params {
> +	TRACE_REQUEST_ARGS,
> +	TRACE_REQUEST_TSYNC_PROTOS,
> +};
> +
> +struct tracecmd_msg_trace_req_param {
> +	int id;
> +	int length;
> +	char *value;
> +};
> +
>  struct tracecmd_msg_trace_req {
>  	be32 flags;
> -	be32 argc;
>  	u64 trace_id;
>  } __attribute__((packed));
>  
> @@ -71,6 +84,13 @@ struct tracecmd_msg_trace_resp {
>  	be32 cpus;
>  	be32 page_size;
>  	u64 trace_id;
> +	be32 tsync_proto;
> +	be32 tsync_port;
> +} __attribute__((packed));
> +
> +struct tracecmd_msg_tsync {
> +	be32 sync_protocol;
> +	be32 sync_msg_id;
>  } __attribute__((packed));
>  
>  struct tracecmd_msg_header {
> @@ -88,7 +108,8 @@ struct tracecmd_msg_header {
>  	C(NOT_SUPP,	5,	0),					\
>  	C(TRACE_REQ,	6,	sizeof(struct tracecmd_msg_trace_req)),	\
>  	C(TRACE_RESP,	7,	sizeof(struct tracecmd_msg_trace_resp)),\
> -	C(CLOSE_RESP,	8,	0),
> +	C(CLOSE_RESP,	8,	0),					\
> +	C(TIME_SYNC,	9,	sizeof(struct tracecmd_msg_tsync)),
>  
>  #undef C
>  #define C(a,b,c)	MSG_##a = b
> @@ -122,6 +143,7 @@ struct tracecmd_msg {
>  		struct tracecmd_msg_rinit	rinit;
>  		struct tracecmd_msg_trace_req	trace_req;
>  		struct tracecmd_msg_trace_resp	trace_resp;
> +		struct tracecmd_msg_tsync	tsync;
>  	};
>  	char					*buf;
>  } __attribute__((packed));
> @@ -264,6 +286,17 @@ static int tracecmd_msg_send(int fd, struct tracecmd_msg *msg)
>  	return ret;
>  }
>  
> +static int msg_send_nofree(int fd, struct tracecmd_msg *msg)
> +{
> +	int ret = 0;
> +
> +	ret = msg_write(fd, msg);
> +	if (ret < 0)
> +		ret = -ECOMM;
> +
> +	return ret;
> +}
> +
>  static int msg_read(int fd, void *buf, u32 size, int *n)
>  {
>  	ssize_t r;
> @@ -813,82 +846,142 @@ int tracecmd_msg_wait_close_resp(struct tracecmd_msg_handle *msg_handle)
>  	return tracecmd_msg_wait_for_cmd(msg_handle, MSG_CLOSE_RESP);
>  }
>  
> -static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv,
> -			  bool use_fifos, unsigned long long trace_id)
> +static int make_trace_req_protos(char **buf, int *size,
> +				 int protos_size, char *tsync_protos)
> +{
> +	size_t buf_size = 0;

Why initialize buf_size to zero, when you set it below in the first
instruction?

> +	char *nbuf;
> +	char *p;
> +
> +	buf_size = TRACE_REQ_PARAM_SIZE + protos_size;
> +	nbuf = realloc(*buf, *size + buf_size);
> +	if (!nbuf)
> +		return -1;
> +
> +	p = nbuf + *size;
> +	memset(p, 0, buf_size);
> +
> +	*(unsigned int *)p = htonl(TRACE_REQUEST_TSYNC_PROTOS);
> +	p += sizeof(int);
> +	*(unsigned int *)p = htonl(protos_size);
> +	p += sizeof(int);
> +
> +	memcpy(p, tsync_protos, protos_size);
> +
> +	*size += buf_size;
> +	*buf = nbuf;
> +	return 0;
> +}
> +
> +static int make_trace_req_args(char **buf, int *size, int argc, char **argv)
>  {
>  	size_t args_size = 0;
> +	size_t buf_size = 0;

Same here. args_size and buf_size are not used before they are assigned.

> +	char *nbuf;
>  	char *p;
>  	int i;
>  
> +	args_size = sizeof(int);
>  	for (i = 0; i < argc; i++)
>  		args_size += strlen(argv[i]) + 1;
>  
> -	msg->hdr.size = htonl(ntohl(msg->hdr.size) + args_size);
> -	msg->trace_req.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
> -	msg->trace_req.argc = htonl(argc);
> -	msg->trace_req.trace_id = htonll(trace_id);
> -	msg->buf = calloc(args_size, 1);
> -	if (!msg->buf)
> -		return -ENOMEM;
> +	buf_size = TRACE_REQ_PARAM_SIZE + args_size;
> +	nbuf = realloc(*buf, *size + buf_size);
> +	if (!nbuf)
> +		return -1;
> +
> +	p = nbuf + *size;
> +	memset(p, 0, buf_size);
> +
> +	*(unsigned int *)p = htonl(TRACE_REQUEST_ARGS);
> +	p += sizeof(int);
> +	*(unsigned int *)p = htonl(args_size);
> +	p += sizeof(int);
>  
> -	p = msg->buf;
> +	*(unsigned int *)p = htonl(argc);
> +	p += sizeof(int);
>  	for (i = 0; i < argc; i++)
>  		p = stpcpy(p, argv[i]) + 1;
>  
> +	*size += buf_size;
> +	*buf = nbuf;
> +	return 0;
> +}
> +

[..]

> +
> +
> +#define PROTO_MASK_SIZE (sizeof(char))

I'm thinking that declaring a mask the size of 1 is a bit overkill.

> +/**
> + * tracecmd_tsync_proto_select - Select time sync protocol, to be used for
> + *		timestamp synchronization with a peer
> + *
> + * @proto_mask: bitmask array of time sync protocols, supported by the peer
> + * @words: size of the @protos array
> + *
> + * Retuns Id of a time sync protocol, that can be used with the peer, or 0
> + *	  in case there is no match with supported protocols
> + */
> +unsigned int tracecmd_tsync_proto_select(char *proto_mask, int words)

Probably should just call it "length", as words usually means "int" or
"long".

> +{
> +	struct tsync_proto *selected = NULL;
> +	struct tsync_proto *proto;
> +	int word;
> +	int id;
> +
> +	for (word = 0; word < words; word++) {
> +		for (proto = tsync_proto_list; proto; proto = proto->next) {
> +			if (proto->proto_id < word * PROTO_MASK_SIZE)

Then we can remove the multiplier here.

Also, if the tsync_proto_list is sorted, we could optimize this. But
that's an optimization for another day, as we currently only have a
single proto.


> +				continue;
> +
> +			id = proto->proto_id - word * PROTO_MASK_SIZE;
> +			if (id >= PROTO_MASK_SIZE)
> +				continue;
> +
> +			if ((1 << id) & proto_mask[word]) {
> +				if (selected) {
> +					if (selected->weight < proto->weight)
> +						selected = proto;
> +				} else
> +					selected = proto;
> +			}
> +		}
> +	}
> +
> +	if (selected)
> +		return selected->proto_id;
> +
> +	return 0;
> +}
> +

[..]

> +static struct tracecmd_instance *
> +clock_synch_create_instance(const char *clock, unsigned int cid)
> +{
> +	struct tracecmd_instance *vinst;

Let's call this "instance".

> +	char inst_name[256];
> +
> +	snprintf(inst_name, 256, "clock_synch-%d", cid);
> +
> +	vinst = tracecmd_alloc_instance(inst_name);
> +	if (!vinst)
> +		return NULL;
> +
> +	tracecmd_make_instance(vinst);
> +	tracecmd_write_instance_file(vinst, "trace", "\0", NULL);
> +	tracecmd_alloc_instance_clock(vinst, clock);
> +	tracecmd_set_clock(vinst, NULL);
> +	return vinst;
> +}
> +

[..]

> +/**
> + * tracecmd_tsync_free - Free time sync context, allocated by
> + *		tracecmd_tsync_with_host() or tracecmd_tsync_with_guest() APIs
> + *
> + * @tsync: Pointer to time sync context
> + *
> + */
> +void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
> +{
> +	struct clock_sync_context *tsync_context;
> +	struct tsync_proto *proto;
> +
> +	if (!tsync->context)
> +		return;
> +	tsync_context = (struct clock_sync_context *)tsync->context;
> +
> +	proto = tsync_proto_find(tsync->sync_proto);
> +	if (proto && proto->clock_sync_free)
> +		proto->clock_sync_free(tsync);
> +
> +	clock_synch_delete_instance(tsync_context->vinst);
> +	tsync_context->vinst = NULL;
> +
> +	free(tsync_context->sync_ts);
> +	free(tsync_context->sync_offsets);
> +	tsync_context->sync_ts = NULL;
> +	tsync_context->sync_offsets = NULL;
> +	tsync_context->sync_count = 0;
> +	tsync_context->sync_size = 0;
> +	pthread_mutex_destroy(&tsync->lock);
> +	pthread_cond_destroy(&tsync->cond);
> +	free(tsync->clock_str);

I would think we would want a free(tsync) here. As the name of the
function suggests.

> +}
> +
> +int tracecmd_tsync_send(struct tracecmd_time_sync *tsync,
> +				  struct tsync_proto *proto)
> +{
> +	long long timestamp = 0;
> +	long long offset = 0;
> +	int ret;
> +
> +	ret = proto->clock_sync_calc(tsync, &offset, &timestamp);
> +
> +	return ret;
> +}
> +



> +++ b/tracecmd/trace-tsync.c
> @@ -0,0 +1,271 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> + *
> + */
> +#include <stdlib.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <sys/socket.h>
> +#include <unistd.h>
> +#include <linux/vm_sockets.h>
> +#include <pthread.h>
> +
> +#include "trace-local.h"
> +#include "trace-msg.h"
> +
> +static int get_first_cpu(cpu_set_t **pin_mask, size_t *m_size)
> +{
> +	int cpus = tracecmd_count_cpus();
> +	cpu_set_t *cpu_mask;
> +	int mask_size;
> +	int i;
> +
> +	cpu_mask = CPU_ALLOC(cpus);
> +	*pin_mask = CPU_ALLOC(cpus);
> +	if (!cpu_mask || !*pin_mask || 1)
> +		goto error;
> +
> +	mask_size = CPU_ALLOC_SIZE(cpus);
> +	CPU_ZERO_S(mask_size, cpu_mask);
> +	CPU_ZERO_S(mask_size, *pin_mask);
> +
> +	if (sched_getaffinity(0, mask_size, cpu_mask) == -1)
> +		goto error;
> +
> +	for (i = 0; i < cpus; i++) {
> +		if (CPU_ISSET_S(i, mask_size, cpu_mask)) {
> +			CPU_SET_S(i, mask_size, *pin_mask);
> +			break;
> +		}
> +	}
> +
> +	if (CPU_COUNT_S(mask_size, *pin_mask) < 1)
> +		goto error;
> +
> +	CPU_FREE(cpu_mask);
> +	*m_size = mask_size;
> +	return 0;
> +
> +error:
> +	if (cpu_mask)
> +		CPU_FREE(cpu_mask);
> +	if (*pin_mask)
> +		CPU_FREE(*pin_mask);
> +	*pin_mask = NULL;
> +	*m_size = 0;
> +	return -1;
> +}
> +
> +static void *tsync_host_thread(void *data)
> +{
> +	struct tracecmd_time_sync *tsync = NULL;
> +
> +	tsync = (struct tracecmd_time_sync *)data;
> +
> +	tracecmd_tsync_with_guest(tsync);
> +
> +	tracecmd_msg_handle_close(tsync->msg_handle);
> +	tsync->msg_handle = NULL;
> +
> +	pthread_exit(0);
> +}
> +
> +int tracecmd_host_tsync(struct buffer_instance *instance,
> +			 unsigned int tsync_port)
> +{
> +	struct tracecmd_msg_handle *msg_handle = NULL;
> +	cpu_set_t *pin_mask = NULL;
> +	pthread_attr_t attrib;
> +	size_t mask_size = 0;
> +	int ret;
> +	int fd;
> +
> +	if (!instance->tsync.sync_proto)
> +		return -1;
> +
> +	fd = trace_open_vsock(instance->cid, tsync_port);
> +	if (fd < 0) {
> +		ret = -1;
> +		goto out;
> +	}
> +	msg_handle = tracecmd_msg_handle_alloc(fd, 0);
> +	if (!msg_handle) {
> +		ret = -1;
> +		goto out;
> +	}
> +
> +	instance->tsync.msg_handle = msg_handle;
> +	if (tracecmd_get_instance_clock(top_instance.ftrace))
> +		instance->tsync.clock_str = strdup(tracecmd_get_instance_clock(top_instance.ftrace));
> +	pthread_mutex_init(&instance->tsync.lock, NULL);
> +	pthread_cond_init(&instance->tsync.cond, NULL);
> +
> +	pthread_attr_init(&attrib);
> +	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
> +	if (!get_first_cpu(&pin_mask, &mask_size))
> +		pthread_attr_setaffinity_np(&attrib, mask_size, pin_mask);
> +
> +	ret = pthread_create(&instance->tsync_thread, &attrib,
> +			     tsync_host_thread, &instance->tsync);
> +	if (!ret)
> +		instance->tsync_thread_running = true;
> +	if (pin_mask)
> +		CPU_FREE(pin_mask);
> +	pthread_attr_destroy(&attrib);
> +
> +out:
> +	if (ret) {
> +		if (msg_handle)
> +			tracecmd_msg_handle_close(msg_handle);
> +	}
> +
> +	return ret;
> +}
> +
> +static void write_guest_time_shift(struct buffer_instance *instance)
> +{
> +	struct tracecmd_output *handle;
> +	struct iovec vector[4];
> +	long long *offsets;
> +	long long *ts;
> +	char *file;
> +	int count;
> +	int ret;
> +	int fd;
> +
> +	ret = tracecmd_tsync_get_offsets(&instance->tsync, &count, &ts, &offsets);
> +	if (ret < 0 || !count || !ts || !offsets)
> +		return;
> +
> +	file = trace_get_guest_file(TRACE_FILENAME,
> +			      tracecmd_get_instance_name(instance->ftrace));
> +	fd = open(file, O_RDWR);
> +	if (fd < 0)
> +		die("error opening %s", file);
> +	free(file);
> +	handle = tracecmd_get_output_handle_fd(fd);
> +	vector[0].iov_len = 8;
> +	vector[0].iov_base = &top_instance.trace_id;
> +	vector[1].iov_len = 4;
> +	vector[1].iov_base = &count;
> +	vector[2].iov_len = 8 * count;
> +	vector[2].iov_base = ts;
> +	vector[3].iov_len = 8 * count;
> +	vector[3].iov_base = offsets;
> +	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 4);
> +	tracecmd_append_options(handle);
> +	tracecmd_output_close(handle);
> +#ifdef TSYNC_DEBUG
> +	if (count > 1)
> +		printf("Got %d timestamp synch samples for guest %s in %lld ns trace\n\r",
> +			count, tracecmd_get_instance_name(instance->ftrace),
> +			ts[count - 1] - ts[0]);
> +#endif
> +}
> +
> +void tracecmd_host_tsync_complete(struct buffer_instance *instance)
> +{
> +	if (!instance->tsync_thread_running)
> +		return;
> +

Probably should add a comment to what is going on here ;-)

> +	pthread_mutex_lock(&instance->tsync.lock);
> +	pthread_cond_signal(&instance->tsync.cond);
> +	pthread_mutex_unlock(&instance->tsync.lock);
> +	pthread_join(instance->tsync_thread, NULL);
> +	write_guest_time_shift(instance);
> +	tracecmd_tsync_free(&instance->tsync);
> +}
> +
> +static void *tsync_agent_thread(void *data)
> +{
> +	struct tracecmd_time_sync *tsync = NULL;
> +	int sd;
> +
> +	tsync = (struct tracecmd_time_sync *)data;
> +
> +	while (true) {
> +		sd = accept(tsync->msg_handle->fd, NULL, NULL);
> +		if (sd < 0) {
> +			if (errno == EINTR)
> +				continue;
> +			goto out;
> +		}
> +		break;
> +	}
> +	close(tsync->msg_handle->fd);
> +	tsync->msg_handle->fd = sd;
> +
> +	tracecmd_tsync_with_host(tsync);
> +
> +out:
> +	tracecmd_msg_handle_close(tsync->msg_handle);
> +	tracecmd_tsync_free(tsync);
> +	free(tsync);
> +	close(sd);
> +
> +	pthread_exit(0);
> +}
> +
> +unsigned int tracecmd_guest_tsync(char *tsync_protos,
> +				  unsigned int tsync_protos_size, char *clock,
> +				  unsigned int *tsync_port, pthread_t *thr_id)
> +{
> +	struct tracecmd_time_sync *tsync = NULL;
> +	cpu_set_t *pin_mask = NULL;
> +	pthread_attr_t attrib;
> +	size_t mask_size = 0;
> +	unsigned int proto;
> +	int ret;
> +	int fd;
> +
> +	fd = -1;
> +	proto = tracecmd_tsync_proto_select(tsync_protos, tsync_protos_size);
> +	if (!proto)
> +		return 0;
> +#ifdef VSOCK
> +	fd = trace_make_vsock(VMADDR_PORT_ANY);
> +	if (fd < 0)
> +		goto error;
> +
> +	ret = trace_get_vsock_port(fd, tsync_port);
> +	if (ret < 0)
> +		goto error;
> +#else
> +	return 0;

If we have no synchronization support, shouldn't this return an error?

> +#endif
> +
> +	tsync = calloc(1, sizeof(struct tracecmd_time_sync));
> +	tsync->msg_handle = tracecmd_msg_handle_alloc(fd, 0);
> +	if (clock)
> +		tsync->clock_str = strdup(clock);
> +
> +	pthread_attr_init(&attrib);
> +	tsync->sync_proto = proto;
> +	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
> +	if (!get_first_cpu(&pin_mask, &mask_size))
> +		pthread_attr_setaffinity_np(&attrib, mask_size, pin_mask);
> +
> +	ret = pthread_create(thr_id, &attrib, tsync_agent_thread, tsync);
> +
> +	if (pin_mask)
> +		CPU_FREE(pin_mask);
> +	pthread_attr_destroy(&attrib);
> +
> +	if (ret)
> +		goto error;
> +
> +	return proto;
> +
> +error:
> +	if (tsync) {
> +		if (tsync->msg_handle)
> +			tracecmd_msg_handle_close(tsync->msg_handle);
> +		if (tsync->clock_str)
> +			free(tsync->clock_str);

You don't need the if statement. free() can take a NULL pointer.

Anyway, it's looking good. I like a lot of what you did. Especially
with the helpers you created.

I still need to take a deeper look at this and the following patches.
I'm thinking that this patch could possibly be broken up into two or
three patches. One patch to create the protocol, another one or two
that use the protocol.

Although we are very close to getting this in, I've been thinking more
that we should release 2.9, without the time sync. We may need to just
up the protocol when we implement the synchronization.

I'll look more at this on Monday.

Cheers!

-- Steve



> +		free(tsync);
> +	}
> +	if (fd > 0)
> +		close(fd);
> +	return 0;
> +}
> diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
> index 05ec021..9fa61e1 100644
> --- a/tracecmd/trace-usage.c
> +++ b/tracecmd/trace-usage.c
> @@ -60,6 +60,10 @@ static struct usage_help usage_help[] = {
>  		"          --no-filter include trace-cmd threads in the trace\n"
>  		"          --proc-map save the traced processes address map into the trace.dat file\n"
>  		"          --user execute the specified [command ...] as given user\n"
> +		"          --tsync-interval set the loop interval, in ms, for timestamps synchronization with guests:"
> +		"               If a negative number is specified, timestamps synchronization is disabled"
> +		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
> +		"                                                         at the beginnig and at the end of the trace\n"
>  	},
>  	{
>  		"start",

