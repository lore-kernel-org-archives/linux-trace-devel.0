Return-Path: <SRS0=jVtL=2A=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF75C43603
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Dec 2019 18:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9D4620663
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Dec 2019 18:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfLJSjY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Dec 2019 13:39:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727617AbfLJSjY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Dec 2019 13:39:24 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B19C20663;
        Tue, 10 Dec 2019 18:39:21 +0000 (UTC)
Date:   Tue, 10 Dec 2019 13:39:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v17 16/18] trace-cmd: Basic infrastructure for host -
 guest timestamp synchronization
Message-ID: <20191210133919.47830c13@gandalf.local.home>
In-Reply-To: <20191203103522.482684-17-tz.stoyanov@gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
        <20191203103522.482684-17-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  3 Dec 2019 12:35:20 +0200
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
>  Documentation/trace-cmd-record.1.txt      |   6 +
>  include/trace-cmd/trace-cmd.h             |  54 ++-
>  lib/trace-cmd/Makefile                    |   1 +
>  lib/trace-cmd/include/trace-tsync-local.h |  36 ++
>  lib/trace-cmd/trace-msg.c                 | 147 ++++++-
>  lib/trace-cmd/trace-timesync.c            | 461 ++++++++++++++++++++++
>  tracecmd/Makefile                         |   3 +-
>  tracecmd/include/trace-local.h            |  11 +
>  tracecmd/trace-agent.c                    |  34 +-
>  tracecmd/trace-record.c                   |  37 +-
>  tracecmd/trace-tsync.c                    | 268 +++++++++++++
>  tracecmd/trace-usage.c                    |   4 +
>  12 files changed, 1035 insertions(+), 27 deletions(-)
>  create mode 100644 lib/trace-cmd/include/trace-tsync-local.h
>  create mode 100644 lib/trace-cmd/trace-timesync.c
>  create mode 100644 tracecmd/trace-tsync.c
> 
> diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
> index 0d75e43..6f09200 100644
> --- a/Documentation/trace-cmd-record.1.txt
> +++ b/Documentation/trace-cmd-record.1.txt
> @@ -338,6 +338,12 @@ OPTIONS
>      the offset will also be in nanoseconds even if the displayed units are
>      in microseconds.
>  
> +*--tsync-interval*::
> +    Set the loop interval, in ms, for timestamps synchronization with guests:
> +        If a negative number is specified, timestamps synchronization is disabled
> +        If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
> +        at the beginning and at the end of the trace\n"

We should probably state that it currently only supports VSOCK

> +
>  *--stderr*::
>      Have output go to stderr instead of stdout, but the output of the command
>      executed will not be changed. This is useful if you want to monitor the
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 17badf2..6abcc9f 100644



>  /* --- ftrace instances --- */
>  
>  struct tracecmd_instance {
> @@ -406,6 +423,35 @@ int tracecmd_iterate_raw_events(struct tep_handle *tep,
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
> +	sem_t				sem;

I already mentioned what I think about semaphores.

> +	char				*clock_str;
> +	struct tracecmd_msg_handle	*msg_handle;
> +	void				*context;
> +};
> +
> +unsigned int tracecmd_tsync_proto_getall(void);
> +unsigned int tracecmd_tsync_proto_select(unsigned int protos);
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
> index 0000000..72a6556
> --- /dev/null
> +++ b/lib/trace-cmd/include/trace-tsync-local.h
> @@ -0,0 +1,36 @@
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

We should have a comment here that explains what the fields of the
structure are.

> +struct clock_sync_context {
> +	void				*proto_data;
> +	bool				server;
> +	struct tracecmd_instance	*vinst;
> +
> +	int				sync_size;
> +	int				sync_count;
> +	long long			*sync_ts;
> +	long long			*sync_offsets;
> +
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
> index a34297f..b6ea5fc 100644
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
> @@ -64,6 +66,7 @@ struct tracecmd_msg_trace_req {
>  	be32 flags;
>  	be32 argc;
>  	u64 trace_id;
> +	be32 tsync_protos;
>  } __attribute__((packed));
>  
>  struct tracecmd_msg_trace_resp {
> @@ -71,6 +74,13 @@ struct tracecmd_msg_trace_resp {
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
> @@ -88,7 +98,8 @@ struct tracecmd_msg_header {
>  	C(NOT_SUPP,	5,	0),					\
>  	C(TRACE_REQ,	6,	sizeof(struct tracecmd_msg_trace_req)),	\
>  	C(TRACE_RESP,	7,	sizeof(struct tracecmd_msg_trace_resp)),\
> -	C(CLOSE_RESP,	8,	0),
> +	C(CLOSE_RESP,	8,	0),					\
> +	C(TIME_SYNC,	9,	sizeof(struct tracecmd_msg_tsync)),
>  
>  #undef C
>  #define C(a,b,c)	MSG_##a = b
> @@ -122,6 +133,7 @@ struct tracecmd_msg {
>  		struct tracecmd_msg_rinit	rinit;
>  		struct tracecmd_msg_trace_req	trace_req;
>  		struct tracecmd_msg_trace_resp	trace_resp;
> +		struct tracecmd_msg_tsync	tsync;
>  	};
>  	char					*buf;
>  } __attribute__((packed));
> @@ -264,6 +276,17 @@ static int tracecmd_msg_send(int fd, struct tracecmd_msg *msg)
>  	return ret;
>  }
>  
> +static int tracecmd_msg_send_nofree(int fd, struct tracecmd_msg *msg)

We probably shouldn't have a static function that starts with
"tracecmd_".

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
> @@ -814,7 +837,8 @@ int tracecmd_msg_wait_close_resp(struct tracecmd_msg_handle *msg_handle)
>  }
>  
>  static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv,
> -			  bool use_fifos, unsigned long long trace_id)
> +			  bool use_fifos, unsigned long long trace_id,
> +			  unsigned int tsync_protos)
>  {
>  	size_t args_size = 0;
>  	char *p;
> @@ -824,7 +848,11 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv,
>  		args_size += strlen(argv[i]) + 1;
>  
>  	msg->hdr.size = htonl(ntohl(msg->hdr.size) + args_size);
> -	msg->trace_req.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
> +	msg->trace_req.flags = 0;
> +	if (use_fifos)
> +		msg->trace_req.flags |= MSG_TRACE_USE_FIFOS;

Why the change to flags here?

> +	msg->trace_req.flags = htonl(msg->trace_req.flags);
> +	msg->trace_req.tsync_protos = htonl(tsync_protos);
>  	msg->trace_req.argc = htonl(argc);
>  	msg->trace_req.trace_id = htonll(trace_id);
>  	msg->buf = calloc(args_size, 1);
> @@ -840,28 +868,30 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv,
>  
>  int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
>  				int argc, char **argv, bool use_fifos,
> -				unsigned long long trace_id)
> +				unsigned long long trace_id,
> +				unsigned int tsync_protos)
>  {
>  	struct tracecmd_msg msg;
>  	int ret;
>  
>  	tracecmd_msg_init(MSG_TRACE_REQ, &msg);
>  	ret = make_trace_req(&msg, argc, argv,
> -			     use_fifos, trace_id);
> +			     use_fifos, trace_id, tsync_protos);
>  	if (ret < 0)
>  		return ret;
>  
>  	return tracecmd_msg_send(msg_handle->fd, &msg);
>  }
>  
> - /*
> -  * NOTE: On success, the returned `argv` should be freed with:
> -  *     free(argv[0]);
> -  *     free(argv);
> -  */
> +/*
> + * NOTE: On success, the returned `argv` should be freed with:
> + *     free(argv[0]);
> + *     free(argv);
> + */
>  int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
>  				int *argc, char ***argv, bool *use_fifos,
> -				unsigned long long *trace_id)
> +				unsigned long long *trace_id,
> +				unsigned int *tsync_protos)
>  {
>  	struct tracecmd_msg msg;
>  	char *p, *buf_end, **args;
> @@ -908,6 +938,7 @@ int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
>  	*argc = nr_args;
>  	*argv = args;
>  	*use_fifos = ntohl(msg.trace_req.flags) & MSG_TRACE_USE_FIFOS;
> +	*tsync_protos = ntohl(msg.trace_req.tsync_protos);
>  	*trace_id = ntohll(msg.trace_req.trace_id);
>  
>  	/*
> @@ -928,9 +959,81 @@ out:
>  	return ret;
>  }
>  

Should add a kerneldoc comment that describes this function. If for
anything else, to describe the parameters.

> +int tracecmd_msg_send_time_sync(struct tracecmd_msg_handle *msg_handle,
> +				unsigned int sync_protocol,
> +				unsigned int sync_msg_id,
> +				unsigned int payload_size, char *payload)
> +{
> +	struct tracecmd_msg msg;
> +
> +	tracecmd_msg_init(MSG_TIME_SYNC, &msg);
> +	msg.tsync.sync_protocol = htonl(sync_protocol);
> +	msg.tsync.sync_msg_id = htonl(sync_msg_id);
> +	msg.hdr.size = htonl(ntohl(msg.hdr.size) + payload_size);
> +
> +	msg.buf = payload;
> +	return tracecmd_msg_send_nofree(msg_handle->fd, &msg);
> +}
> +

Should add a kerneldoc comment for this function too.

> +int tracecmd_msg_recv_time_sync(struct tracecmd_msg_handle *msg_handle,
> +				unsigned int *sync_protocol,
> +				unsigned int *sync_msg_id,
> +				unsigned int *payload_size, char **payload)
> +{
> +	struct tracecmd_msg msg;
> +	int ret = -1;
> +	int buf_size;
> +
> +	memset(&msg, 0, sizeof(msg));
> +	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (ntohl(msg.hdr.cmd) != MSG_TIME_SYNC) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	if (sync_protocol)
> +		*sync_protocol = ntohl(msg.tsync.sync_protocol);
> +	if (sync_msg_id)
> +		*sync_msg_id = ntohl(msg.tsync.sync_msg_id);
> +
> +	buf_size = msg_buf_len(&msg);
> +	if (buf_size < 0) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (buf_size && payload && payload_size) {
> +		if (*payload_size) {
> +			if (*payload_size != buf_size || *payload == NULL) {

This patch doesn't yet have a use case for payload_size, so I don't
know how its used. But I'm not sure we should make it have to equal
buf_size, perhaps we should have it be:

			*payload_size < buf_size


As it should be OK to over allocate, but not under allocate.


> +				ret = -ENOMEM;
> +				goto out;
> +			}
> +			memcpy(*payload, msg.buf, buf_size);
> +			goto out;
> +		}
> +
> +		*payload = malloc(buf_size);
> +		if (*payload == NULL) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +		*payload_size = buf_size;
> +		memcpy(*payload, msg.buf, buf_size);
> +	}
> +
> +out:
> +	msg_free(&msg);
> +	return ret;
> +}
> +
>  static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
>  			   unsigned int *ports, bool use_fifos,
> -			   unsigned long long trace_id)
> +			   unsigned long long trace_id,
> +			   unsigned int tsync_proto,
> +			   unsigned int tsync_port)
>  {
>  	int data_size;
>  
> @@ -941,7 +1044,13 @@ static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
>  	write_uints(msg->buf, data_size, ports, nr_cpus);
>  
>  	msg->hdr.size = htonl(ntohl(msg->hdr.size) + data_size);
> -	msg->trace_resp.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
> +	msg->trace_resp.flags = 0;
> +	if (use_fifos)
> +		msg->trace_resp.flags |= MSG_TRACE_USE_FIFOS;
> +	msg->trace_resp.flags = htonl(msg->trace_resp.flags);
> +	msg->trace_resp.tsync_proto = htonl(tsync_proto);
> +	msg->trace_resp.tsync_port = htonl(tsync_port);
> +
>  	msg->trace_resp.cpus = htonl(nr_cpus);
>  	msg->trace_resp.page_size = htonl(page_size);
>  	msg->trace_resp.trace_id = htonll(trace_id);
> @@ -952,14 +1061,16 @@ static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
>  int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
>  				 int nr_cpus, int page_size,
>  				 unsigned int *ports, bool use_fifos,
> -				 unsigned long long trace_id)
> +				 unsigned long long trace_id,
> +				 unsigned int tsync_proto,
> +				 unsigned int tsync_port)
>  {
>  	struct tracecmd_msg msg;
>  	int ret;
>  
>  	tracecmd_msg_init(MSG_TRACE_RESP, &msg);
>  	ret = make_trace_resp(&msg, page_size, nr_cpus, ports,
> -			      use_fifos, trace_id);
> +			      use_fifos, trace_id, tsync_proto, tsync_port);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -969,7 +1080,9 @@ int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
>  int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
>  				 int *nr_cpus, int *page_size,
>  				 unsigned int **ports, bool *use_fifos,
> -				 unsigned long long *trace_id)
> +				 unsigned long long *trace_id,
> +				 unsigned int *tsync_proto,
> +				 unsigned int *tsync_port)
>  {
>  	struct tracecmd_msg msg;
>  	char *p, *buf_end;
> @@ -996,6 +1109,8 @@ int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
>  	*nr_cpus = ntohl(msg.trace_resp.cpus);
>  	*page_size = ntohl(msg.trace_resp.page_size);
>  	*trace_id = ntohll(msg.trace_resp.trace_id);
> +	*tsync_proto = ntohl(msg.trace_resp.tsync_proto);
> +	*tsync_port = ntohl(msg.trace_resp.tsync_port);
>  	*ports = calloc(*nr_cpus, sizeof(**ports));
>  	if (!*ports) {
>  		ret = -ENOMEM;
> diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
> new file mode 100644
> index 0000000..073423d
> --- /dev/null
> +++ b/lib/trace-cmd/trace-timesync.c
> @@ -0,0 +1,461 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> + *
> + */
> +
> +#include <fcntl.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <arpa/inet.h>
> +#include <linux/vm_sockets.h>
> +#include <linux/limits.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <time.h>
> +#include <dirent.h>
> +#include <errno.h>
> +#include "trace-cmd.h"
> +#include "trace-cmd-local.h"
> +#include "trace-tsync-local.h"
> +
> +struct tsync_proto {
> +	struct tsync_proto *next;
> +	unsigned int proto_id;
> +	int	weight;
> +
> +	int (*clock_sync_init)(struct tracecmd_time_sync *clock_context);
> +	int (*clock_sync_free)(struct tracecmd_time_sync *clock_context);
> +	int (*clock_sync_calc)(struct tracecmd_time_sync *clock_context,
> +			       long long *offset, long long *timestamp);
> +} static * tsync_proto_list;

Just a nit, but it's usually cleaner and easier to read to separate the
struct declaration and the variables. That is:

struct tsync_proto {
	[..]
};

static struct tsync_proto *tsync_proto_list;

> +
> +static struct tsync_proto *tsync_proto_get(unsigned int proto_id)

I'd rename this to tsync_find_proto(), as to me, "_get" usually means
that a reference count is incremented and it should be paired with a
"_put" somewhere.


> +{
> +	struct tsync_proto *proto = tsync_proto_list;
> +
> +	while (proto) {
> +		if (proto->proto_id == proto_id)
> +			return proto;
> +		proto = proto->next;
> +	}

Another nit, but I usually prefer for loops for this ;-)

	for (proto = tsync_proto_list; proto; proto = proto->next) {
		if (proto->proto_id == proto_id)
			return proto;
	}



> +	return NULL;
> +}
> +
> +int tracecmd_tsync_proto_register(unsigned int proto_id, int weight,
> +				int (*init)(struct tracecmd_time_sync *),
> +				int (*free)(struct tracecmd_time_sync *),
> +				int (*calc)(struct tracecmd_time_sync *,
> +					    long long *, long long *))
> +{
> +	struct tsync_proto *proto;
> +
> +	if (tsync_proto_get(proto_id))
> +		return -1;
> +	proto = calloc(1, sizeof(struct tsync_proto));
> +	if (!proto)
> +		return -1;
> +	proto->proto_id = proto_id;
> +	proto->weight = weight;
> +	proto->clock_sync_init = init;
> +	proto->clock_sync_free = free;
> +	proto->clock_sync_calc = calc;
> +
> +	proto->next = tsync_proto_list;
> +	tsync_proto_list = proto;
> +	return 0;
> +}
> +
> +int tracecmd_tsync_proto_unregister(unsigned int proto_id)
> +{
> +	struct tsync_proto *proto = tsync_proto_list;
> +	struct tsync_proto *pdel;
> +
> +	if (tsync_proto_list && tsync_proto_list->proto_id == proto_id) {
> +		pdel = tsync_proto_list;
> +		tsync_proto_list = pdel->next;
> +		free(pdel);
> +		return 0;
> +	}
> +
> +	while (proto->next) {
> +		if (proto->next->proto_id == proto_id) {
> +			pdel = proto->next;
> +			proto->next = pdel->next;
> +			free(pdel);
> +			return 0;
> +		}
> +		proto = proto->next;
> +	}

The above could be written as one loop:


	struct tsync_proto **last = &tsync_proto_list;

	for (; *last; last = &(*last)->next) {
		if ((*last)->proto_id = proto_id) {
			struct tsync_proto *proto = *last;

			*last = proto->next;
			free(proto);
			return 0;
		}
	}


> +
> +	return -1;
> +}
> +
> +/**
> + * tracecmd_tsync_get_offsets - Return the calculated time offsests
> + *
> + * @tsync: Pointer to time sync context.
> + * @count: Returns the number of calculated time offsets.
> + * @ts: Array of size @count containing timestamps of callculated offsets
> + * @offsets: array of size @count, containing offsets for each timestamp.
> + *
> + * Retuns -1 in case of an error, or 0 otherwise
> + */
> +int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
> +				int *count,
> +				long long **ts, long long **offsets)
> +{
> +	struct clock_sync_context *tsync_context;
> +
> +	if (!tsync || !tsync->context)
> +		return -1;
> +	tsync_context = (struct clock_sync_context *)tsync->context;
> +	if (count)
> +		*count = tsync_context->sync_count;
> +	if (ts)
> +		*ts = tsync_context->sync_ts;
> +	if (offsets)
> +		*offsets = tsync_context->sync_offsets;
> +	return 0;
> +}
> +
> +/**
> + * tracecmd_tsync_proto_select - Select time sync protocol, to be used for
> + *		timestamp synchronization with a peer.
> + *
> + * @protos: Bitmask of time sync protocols, supported by the peer.

Hmm, so we are limiting the number of protocols that we will ever
support to 32? This makes me nervous (I always think of the famous
quote of "Who will ever need more than 64K of RAM?")

To be safe, we should probably make this an array:

	int tracecmd_tsync_proto_select(unsigned int *protos, int words)

The proto_id should be a bit, not a mask, that is:

	int word;

	for (word = 0; word < words; word++) {

		for (proto = tsync_proto_list; proto; proto = proto->next) {
			if (proto->proto_id < word * 32)
				continue;

			id = proto->proto_id - word * 32;
			if (id >= 32)
				continue;

			if ((1 << id) & protos[word]) {
				if (selected)
					[...]

While we only have a single word, callers would just do:

	unsigned int protos;

	ret = tracecmd_tsync_proto_select(&protos, 1);

At least this will never limit us to just 32 protocols, even though we
will likely never need more. But we are safe if we ever do ;-)

> + *
> + * Retuns Id of a time sync protocol, that can be used with the peer, or 0
> + *	in case there is no match with supported protocols.
> + */
> +unsigned int tracecmd_tsync_proto_select(unsigned int protos)
> +{
> +	struct tsync_proto *proto = tsync_proto_list;
> +	struct tsync_proto *selected = NULL;
> +
> +	while (proto) {
> +		if (proto->proto_id & protos) {
> +			if (selected) {
> +				if (selected->weight < proto->weight)
> +					selected = proto;
> +			} else
> +				selected = proto;
> +		}
> +		proto = proto->next;
> +	}
> +
> +	if (selected)
> +		return selected->proto_id;
> +
> +	return 0;
> +}
> +
> +/**
> + * tracecmd_tsync_proto_getall - Returns bitmask of all supported
> + *				 time sync protocols.
> + *
> + */
> +unsigned int tracecmd_tsync_proto_getall(void)

With the bitmask I suggest above, this would need to pass back as
allocate mask.

> +{
> +	struct tsync_proto *proto = tsync_proto_list;
> +	unsigned int protos = 0;
> +
> +	while (proto) {
> +		protos |= proto->proto_id;
> +		proto = proto->next;
> +	}
> +
> +	return protos;
> +}
> +
> +static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *lport,
> +			      unsigned int *rcid, unsigned int *rport)
> +{
> +	struct sockaddr_vm addr;
> +	socklen_t addr_len = sizeof(addr);
> +
> +	memset(&addr, 0, sizeof(addr));
> +	if (getsockname(fd, (struct sockaddr *)&addr, &addr_len))
> +		return -1;
> +	if (addr.svm_family != AF_VSOCK)
> +		return -1;
> +	*lport = addr.svm_port;
> +	*lcid = addr.svm_cid;
> +
> +	memset(&addr, 0, sizeof(addr));
> +	addr_len = sizeof(addr);
> +	if (getpeername(fd, (struct sockaddr *)&addr, &addr_len))
> +		return -1;
> +	if (addr.svm_family != AF_VSOCK)
> +		return -1;
> +	*rport = addr.svm_port;
> +	*rcid = addr.svm_cid;
> +
> +	return 0;
> +}
> +
> +static struct tracecmd_instance *
> +clock_synch_create_instance(const char *clock, unsigned int cid)
> +{
> +	struct tracecmd_instance *vinst;
> +	char inst_name[256];
> +
> +	snprintf(inst_name, 256, "clock_synch-%d", cid);
> +
> +	vinst = tracecmd_create_instance(inst_name);
> +	if (!vinst)
> +		return NULL;
> +
> +	tracecmd_make_instance(vinst);
> +	tracecmd_write_instance_file(vinst, "trace", "\0", NULL);
> +	if (clock)
> +		vinst->clock = strdup(clock);
> +	tracecmd_set_clock(vinst, NULL);
> +	return vinst;
> +}
> +
> +static void
> +clock_synch_delete_instance(struct tracecmd_instance *inst)
> +{
> +	if (!inst)
> +		return;
> +	tracecmd_remove_instance(inst);
> +	free(inst->clock);
> +	tracecmd_free_instance(inst);
> +}
> +
> +static int clock_context_init(struct tracecmd_time_sync *tsync, bool server)
> +{
> +	struct clock_sync_context *clock = NULL;
> +	struct tsync_proto *protocol;
> +
> +	if (tsync->context)
> +		return 0;
> +
> +	protocol = tsync_proto_get(tsync->sync_proto);
> +	if (!protocol)
> +		return -1;
> +
> +	clock = calloc(1, sizeof(struct clock_sync_context));
> +	if (!clock)
> +		return -1;
> +
> +	clock->server = server;
> +	if (get_vsocket_params(tsync->msg_handle->fd, &clock->local_cid,
> +			       &clock->local_port, &clock->remote_cid,
> +			       &clock->remote_port))
> +		goto error;
> +
> +	clock->vinst = clock_synch_create_instance(tsync->clock_str,
> +						   clock->remote_cid);
> +	if (!clock->vinst)
> +		goto error;
> +
> +	tsync->context = clock;
> +	if (protocol->clock_sync_init && protocol->clock_sync_init(tsync) < 0)
> +		goto error;
> +
> +	return 0;
> +error:
> +	tsync->context = NULL;
> +	free(clock);
> +	return -1;
> +}
> +
> +/**
> + * tracecmd_tsync_free - Free time sync context, allocated by
> + *		tracecmd_tsync_with_host() or tracecmd_tsync_with_guest() APIs
> + *
> + * @tsync: Pointer to time sync context.
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
> +	proto = tsync_proto_get(tsync->sync_proto);
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
> +	sem_destroy(&tsync->sem);
> +	free(tsync->clock_str);
> +}
> +
> +static int tracecmd_tsync_send(struct tracecmd_time_sync *tsync,
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
> +/**
> + * tracecmd_tsync_with_host - Synchronize timestamps with host
> + *
> + * @tsync: Pointer to time sync context.
> + *
> + * This API is supposed to be called in guest context. It waits for a time
> + * sync request from the host and replies with a time sample, until time sync
> + * stop command is received.
> + *
> + */
> +void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync)
> +{
> +	struct tsync_proto *proto;
> +	unsigned int protocol;
> +	unsigned int command;
> +	int ret;
> +
> +	proto = tsync_proto_get(tsync->sync_proto);
> +	if (!proto || !proto->clock_sync_calc)
> +		return;
> +
> +	clock_context_init(tsync, true);
> +	if (!tsync->context)
> +		return;
> +
> +	while (true) {
> +		ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
> +						  &protocol, &command,
> +						  NULL, NULL);
> +
> +		if (ret ||
> +		    protocol != TRACECMD_TIME_SYNC_PROTO_NONE ||
> +		    command != TRACECMD_TIME_SYNC_CMD_PROBE)
> +			break;
> +		ret = tracecmd_tsync_send(tsync, proto);
> +		if (ret)
> +			break;
> +	}
> +}
> +
> +static int tracecmd_tsync_get(struct tracecmd_time_sync *tsync,
> +			      struct tsync_proto *proto,
> +			      int array_step)
> +{
> +	struct clock_sync_context *clock;
> +	long long *sync_offsets = NULL;
> +	long long *sync_ts = NULL;
> +	long long timestamp = 0;
> +	long long offset = 0;
> +	int ret;
> +
> +	ret = proto->clock_sync_calc(tsync, &offset, &timestamp);
> +	if (ret) {
> +		warning("Failed to synchronize timestamps with guest");
> +		return -1;
> +	}
> +	if (!offset || !timestamp)
> +		return 0;
> +	clock = tsync->context;
> +	if (clock->sync_count >= clock->sync_size) {
> +		sync_ts = realloc(clock->sync_ts,
> +				  (clock->sync_size + array_step) * sizeof(long long));
> +		sync_offsets = realloc(clock->sync_offsets,
> +				       (clock->sync_size + array_step) * sizeof(long long));
> +		if (!sync_ts || !sync_offsets) {
> +			free(sync_ts);
> +			free(sync_offsets);
> +			return -1;
> +		}
> +		clock->sync_size += array_step;
> +		clock->sync_ts = sync_ts;
> +		clock->sync_offsets = sync_offsets;
> +	}
> +
> +	clock->sync_ts[clock->sync_count] = timestamp;
> +	clock->sync_offsets[clock->sync_count] = offset;
> +	clock->sync_count++;
> +
> +	return 0;
> +}
> +
> +#define TIMER_SEC_NANO 1000000000LL
> +static inline void get_ts_loop_delay(struct timespec *timeout, int delay_ms)
> +{
> +	memset(timeout, 0, sizeof(struct timespec));
> +	clock_gettime(CLOCK_REALTIME, timeout);
> +
> +	timeout->tv_nsec += ((unsigned long long)delay_ms * 1000000LL);
> +
> +	if (timeout->tv_nsec >= TIMER_SEC_NANO) {
> +		timeout->tv_sec += timeout->tv_nsec / TIMER_SEC_NANO;
> +		timeout->tv_nsec %= TIMER_SEC_NANO;
> +	}
> +}
> +
> +#define CLOCK_TS_ARRAY 5
> +/**
> + * tracecmd_tsync_with_guest - Synchronize timestamps with guest
> + *
> + * @tsync: Pointer to time sync context.
> + *
> + * This API is supposed to be called in host context, in a separate thread.
> + * It loops infinite, until the timesync semaphore is released.
> + *
> + */
> +void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
> +{
> +	int ts_array_size = CLOCK_TS_ARRAY;
> +	struct tsync_proto *proto;
> +	struct timespec timeout;
> +	bool end = false;
> +	int ret;
> +
> +	proto = tsync_proto_get(tsync->sync_proto);
> +	if (!proto || !proto->clock_sync_calc)
> +		return;
> +
> +	clock_context_init(tsync, false);
> +	if (!tsync->context)
> +		return;
> +
> +	if (tsync->loop_interval > 0 &&
> +	    tsync->loop_interval < (CLOCK_TS_ARRAY * 1000))
> +		ts_array_size = (CLOCK_TS_ARRAY * 1000) / tsync->loop_interval;
> +
> +	while (true) {
> +		ret = tracecmd_msg_send_time_sync(tsync->msg_handle,
> +						  TRACECMD_TIME_SYNC_PROTO_NONE,
> +						  TRACECMD_TIME_SYNC_CMD_PROBE,
> +						  0, NULL);
> +		ret = tracecmd_tsync_get(tsync, proto, ts_array_size);
> +		if (ret || end)
> +			break;
> +		if (tsync->loop_interval > 0) {
> +			get_ts_loop_delay(&timeout, tsync->loop_interval);
> +			ret = sem_timedwait(&tsync->sem, &timeout);
> +			if (ret < 0) {
> +				if (errno != ETIMEDOUT && errno != EINTR)
> +					break;
> +			} else if (!ret)
> +				end = true;
> +		} else {
> +			sem_wait(&tsync->sem);
> +			end = true;
> +		}
> +	};
> +
> +	tracecmd_msg_send_time_sync(tsync->msg_handle,
> +				    TRACECMD_TIME_SYNC_PROTO_NONE,
> +				    TRACECMD_TIME_SYNC_CMD_STOP,
> +				    0, NULL);
> +}
> diff --git a/tracecmd/Makefile b/tracecmd/Makefile
> index 29a623b..908dab2 100644
> --- a/tracecmd/Makefile
> +++ b/tracecmd/Makefile
> @@ -30,6 +30,7 @@ TRACE_CMD_OBJS += trace-check-events.o
>  TRACE_CMD_OBJS += trace-show.o
>  TRACE_CMD_OBJS += trace-list.o
>  TRACE_CMD_OBJS += trace-usage.o
> +TRACE_CMD_OBJS += trace-tsync.o
>  
>  ifeq ($(VSOCK_DEFINED), 1)
>  TRACE_CMD_OBJS += trace-agent.o
> @@ -42,7 +43,7 @@ all_objs := $(sort $(ALL_OBJS))
>  all_deps := $(all_objs:$(bdir)/%.o=$(bdir)/.%.d)
>  
>  CONFIG_INCLUDES =
> -CONFIG_LIBS	= -lrt
> +CONFIG_LIBS	= -lrt -lpthread
>  CONFIG_FLAGS	=
>  
>  all: $(TARGETS)
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index 17ef31a..d652317 100644
> --- a/tracecmd/include/trace-local.h
> +++ b/tracecmd/include/trace-local.h
> @@ -226,6 +226,10 @@ struct buffer_instance {
>  	unsigned int		port;
>  	int			*fds;
>  	bool			use_fifos;
> +
> +	pthread_t		tsync_thread;
> +	bool			tsync_thread_running;
> +	struct tracecmd_time_sync tsync;
>  };
>  
>  void init_top_instance(void);
> @@ -260,6 +264,13 @@ void tracecmd_disable_tracing(void);
>  void tracecmd_enable_tracing(void);
>  void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
>  
> +int tracecmd_host_tsync(struct buffer_instance *instance,
> +			 unsigned int tsync_port);
> +void tracecmd_host_tsync_complete(struct buffer_instance *instance);
> +unsigned int tracecmd_guest_tsync(unsigned int tsync_protos, char *clock,
> +				  unsigned int *tsync_port,
> +				  pthread_t *thr_id);
> +
>  int make_vsock(unsigned int port);
>  int get_vsock_port(int sd, unsigned int *port);
>  int open_vsock(unsigned int cid, unsigned int port);
> diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
> index 530f972..1581de8 100644
> --- a/tracecmd/trace-agent.c
> +++ b/tracecmd/trace-agent.c
> @@ -19,6 +19,7 @@
>  #include <sys/wait.h>
>  #include <unistd.h>
>  #include <linux/vm_sockets.h>
> +#include <pthread.h>
>  
>  #include "trace-local.h"
>  #include "trace-msg.h"
> @@ -125,11 +126,28 @@ cleanup:
>  	return ret;
>  }
>  
> +static char *get_clock(int argc, char **argv)
> +{
> +	int i;
> +
> +	if (!argc || !argv)
> +		return NULL;
> +
> +	for (i = 0; i < argc - 1; i++) {
> +		if (!strcmp("-C", argv[i]))
> +			return argv[i+1];
> +	}
> +	return NULL;
> +}
> +
>  static void agent_handle(int sd, int nr_cpus, int page_size)
>  {
>  	struct tracecmd_msg_handle *msg_handle;
>  	unsigned long long trace_id;
> +	unsigned int tsync_protos = 0;
> +	unsigned int tsync_port = 0;
>  	unsigned int *ports;
> +	pthread_t sync_thr;
>  	char **argv = NULL;
>  	int argc = 0;
>  	bool use_fifos;
> @@ -146,7 +164,8 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
>  		die("Failed to allocate message handle");
>  
>  	ret = tracecmd_msg_recv_trace_req(msg_handle, &argc, &argv,
> -					  &use_fifos, &trace_id);
> +					  &use_fifos, &trace_id,
> +					  &tsync_protos);
>  	if (ret < 0)
>  		die("Failed to receive trace request");
>  
> @@ -155,14 +174,25 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
>  
>  	if (!use_fifos)
>  		make_vsocks(nr_cpus, fds, ports);
> +	if (tsync_protos) {
> +		tsync_protos = tracecmd_guest_tsync(tsync_protos,
> +						    get_clock(argc, argv),
> +						    &tsync_port, &sync_thr);
> +		if (!tsync_protos)
> +			warning("Failed to negotiate timestamps synchronization with the host");
> +	}
>  	trace_id = tracecmd_generate_traceid();
>  	ret = tracecmd_msg_send_trace_resp(msg_handle, nr_cpus, page_size,
> -					   ports, use_fifos, trace_id);
> +					   ports, use_fifos, trace_id,
> +					   tsync_protos, tsync_port);
>  	if (ret < 0)
>  		die("Failed to send trace response");
>  	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv,
>  			   use_fifos, trace_id);
>  
> +	if (tsync_protos)
> +		pthread_join(sync_thr, NULL);
> +
>  	free(argv[0]);
>  	free(argv);
>  	free(ports);
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index e66f999..e543c40 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -670,6 +670,11 @@ static void tell_guests_to_stop(void)
>  			tracecmd_msg_send_close_msg(instance->msg_handle);
>  	}
>  
> +	for_all_instances(instance) {
> +		if (is_guest(instance))
> +			tracecmd_host_tsync_complete(instance);
> +	}
> +
>  	/* Wait for guests to acknowledge */
>  	for_all_instances(instance) {
>  		if (is_guest(instance)) {
> @@ -3501,6 +3506,8 @@ static void connect_to_agent(struct buffer_instance *instance)
>  {
>  	struct tracecmd_msg_handle *msg_handle;
>  	int sd, ret, nr_fifos, nr_cpus, page_size;
> +	unsigned int tsync_protos_reply = 0;
> +	unsigned int tsync_port = 0;
>  	unsigned int *ports;
>  	int i, *fds = NULL;
>  	bool use_fifos = false;
> @@ -3519,19 +3526,32 @@ static void connect_to_agent(struct buffer_instance *instance)
>  	if (!msg_handle)
>  		die("Failed to allocate message handle");
>  
> +	if (instance->tsync.loop_interval >= 0)
> +		instance->tsync.sync_proto = tracecmd_tsync_proto_getall();
> +
>  	ret = tracecmd_msg_send_trace_req(msg_handle, instance->argc,
>  					  instance->argv, use_fifos,
> -					  top_instance.trace_id);
> +					  top_instance.trace_id,
> +					  instance->tsync.sync_proto);
>  
>  	if (ret < 0)
>  		die("Failed to send trace request");
>  
>  	ret = tracecmd_msg_recv_trace_resp(msg_handle, &nr_cpus, &page_size,
>  					   &ports, &use_fifos,
> -					   &instance->trace_id);
> +					   &instance->trace_id,
> +					   &tsync_protos_reply, &tsync_port);
>  
>  	if (ret < 0)
> -		die("Failed to receive trace response");
> +		die("Failed to receive trace response %d", ret);
> +
> +	if (instance->tsync.sync_proto) {
> +		if (instance->tsync.sync_proto & tsync_protos_reply) {
> +			instance->tsync.sync_proto = tsync_protos_reply;
> +			tracecmd_host_tsync(instance, tsync_port);
> +		} else
> +			warning("Failed to negotiate timestamps synchronization with the guest");
> +	}
>  
>  	if (use_fifos) {
>  		if (nr_cpus != nr_fifos) {
> @@ -3578,7 +3598,9 @@ static void setup_guest(struct buffer_instance *instance)
>  	close(fd);
>  }
>  
> -static void setup_agent(struct buffer_instance *instance, struct common_record_context *ctx)
> +static void setup_agent(struct buffer_instance *instance,
> +			struct common_record_context *ctx)
> +
>  {
>  	struct tracecmd_output *network_handle;
>  
> @@ -5131,6 +5153,7 @@ void init_top_instance(void)
>  }
>  
>  enum {
> +	OPT_tsyncinterval	= 242,
>  	OPT_user		= 243,
>  	OPT_procmap		= 244,
>  	OPT_quiet		= 245,
> @@ -5433,6 +5456,7 @@ static void parse_record_options(int argc,
>  			{"proc-map", no_argument, NULL, OPT_procmap},
>  			{"user", required_argument, NULL, OPT_user},
>  			{"module", required_argument, NULL, OPT_module},
> +			{"tsync-interval", required_argument, NULL, OPT_tsyncinterval},
>  			{NULL, 0, NULL, 0}
>  		};
>  
> @@ -5771,6 +5795,10 @@ static void parse_record_options(int argc,
>  			ctx->instance->filter_mod = optarg;
>  			ctx->filtered = 0;
>  			break;
> +		case OPT_tsyncinterval:
> +			top_instance.tsync.loop_interval = atoi(optarg);
> +			guest_config = true;

I still don't like the name of the variable. "guest_config" makes it
sound like this is a guest config, or we set a guest config. Where as
you are just going to do something to the guests when this gets set.
It's still rather confusing.

Still would be better with "clock_option_set" or something like that.
It's more descriptive of why it is true. Or perhaps something like
"guest_sync_set", where we are saying that we need to do something for
synchronizing guests.


> +			break;
>  		case OPT_quiet:
>  		case 'q':
>  			quiet = true;
> @@ -5799,6 +5827,7 @@ static void parse_record_options(int argc,
>  					add_argv(instance, "-C", true);
>  				}
>  			}
> +		instance->tsync.loop_interval = top_instance.tsync.loop_interval;
>  		}
>  	}
>  
> diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
> new file mode 100644
> index 0000000..e4189e0
> --- /dev/null
> +++ b/tracecmd/trace-tsync.c
> @@ -0,0 +1,268 @@
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
> +	fd = open_vsock(instance->cid, tsync_port);
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
> +	if (top_instance.ftrace->clock)
> +		instance->tsync.clock_str = strdup(top_instance.ftrace->clock);
> +	ret = sem_init(&instance->tsync.sem, 0, 0);
> +	if (ret)
> +		goto out;
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
> +	file = get_guest_file(TRACE_FILENAME, instance->ftrace->name);
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
> +			count, instance->ftrace->name, ts[count - 1] - ts[0]);
> +#endif
> +}
> +
> +void tracecmd_host_tsync_complete(struct buffer_instance *instance)
> +{
> +	if (!instance->tsync_thread_running)
> +		return;
> +
> +	sem_post(&instance->tsync.sem);
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
> +unsigned int tracecmd_guest_tsync(unsigned int tsync_protos, char *clock,
> +				  unsigned int *tsync_port,
> +				  pthread_t *thr_id)
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
> +	proto = tracecmd_tsync_proto_select(tsync_protos);
> +	if (!proto)
> +		return 0;
> +#ifdef VSOCK

Instead of this, perhaps we should not have this file get compiled if
VSOCK is not defined?

-- Steve


> +	fd = make_vsock(VMADDR_PORT_ANY);
> +	if (fd < 0)
> +		goto error;
> +
> +	ret = get_vsock_port(fd, tsync_port);
> +	if (ret < 0)
> +		goto error;
> +#else
> +	return 0;
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

