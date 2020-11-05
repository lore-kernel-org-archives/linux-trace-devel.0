Return-Path: <SRS0=ZY51=EL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C73FC56201
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C7DD22227
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731201AbgKEOwo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 09:52:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731504AbgKEOwn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 09:52:43 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC74421D81;
        Thu,  5 Nov 2020 14:52:41 +0000 (UTC)
Date:   Thu, 5 Nov 2020 09:52:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v25 01/16] trace-cmd: Replace time sync protocol ID with
 string
Message-ID: <20201105095239.500efdf2@gandalf.local.home>
In-Reply-To: <20201029111816.247241-2-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
        <20201029111816.247241-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Oct 2020 13:18:01 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Different timestamp synchronization algorithms will be implemented as
> trace-cmd plugins. Using IDs for identifying these algorithms is
> a problem, as these IDs must be defined in a single place. In order
> to be more flexible, protocol IDs are replaced by protocol names -
> strings that are part of the plugin code and are registered with
> plugin initialisation.
> The plugin names are limited up to 15 symbols, in order to simplify
> the structure of sync messages.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h             |  32 +++---
>  lib/trace-cmd/include/trace-tsync-local.h |  12 +-
>  lib/trace-cmd/trace-msg.c                 | 102 ++++++++++------
>  lib/trace-cmd/trace-timesync.c            | 134 ++++++++++------------
>  tracecmd/include/trace-local.h            |   5 +-
>  tracecmd/trace-agent.c                    |   8 +-
>  tracecmd/trace-record.c                   |  19 +--
>  tracecmd/trace-tsync.c                    |  19 ++-
>  8 files changed, 170 insertions(+), 161 deletions(-)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index f3c95f30..8d3bea73 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -385,50 +385,44 @@ void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
>  int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
>  				int argc, char **argv, bool use_fifos,
>  				unsigned long long trace_id,
> -				char *tsync_protos,
> -				int tsync_protos_size);
> +				char **tsync_protos);

Probably should make these const char * const *
(I'll have to check if I place those correctly ;-)

As I believe this is passed in and not modified.

>  int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
>  				int *argc, char ***argv, bool *use_fifos,
>  				unsigned long long *trace_id,
> -				char **tsync_protos,
> -				unsigned int *tsync_protos_size);
> +				char ***tsync_protos);

Hmm, maybe we need to make this into its own structure that handles the
array, because char *** is starting to get too complex. Prehaps we should
just abstract it out!

struct tracecmd_tsync_protos;

int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
				int argc, char **argv, bool use_fifos,
				unsigned long long trace_id,
				struct tracecmd_tsync_protos *tsync_protos);

int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
				int *argc, char ***argv, bool *use_fifos,
				unsigned long long *trace_id,
				struct tracecmd_tsync_protos **tsync_protos);

Then we have internally:

struct tracecmd_tsync_protos {
	char **protos;
}

That we play with, and have helper functions to extract the list for cases
that want to see all the protos. This would also give us flexibility to add
more complex operations to this later.

>  
>  int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
>  				 int nr_cpus, int page_size,
>  				 unsigned int *ports, bool use_fifos,
>  				 unsigned long long trace_id,
> -				 unsigned int tsync_proto,
> -				 unsigned int tsync_port);
> +				 char *tsync_proto, unsigned int tsync_port);
>  int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
>  				 int *nr_cpus, int *page_size,
>  				 unsigned int **ports, bool *use_fifos,
>  				 unsigned long long *trace_id,
> -				 unsigned int *tsync_proto,
> +				 char **tsync_proto,
>  				 unsigned int *tsync_port);
>  
>  int tracecmd_msg_send_time_sync(struct tracecmd_msg_handle *msg_handle,
> -				unsigned int sync_protocol,
> -				unsigned int sync_msg_id,
> +				char *sync_protocol, unsigned int sync_msg_id,
>  				unsigned int payload_size, char *payload);
>  int tracecmd_msg_recv_time_sync(struct tracecmd_msg_handle *msg_handle,
> -				unsigned int *sync_protocol,
> +				char *sync_protocol,
>  				unsigned int *sync_msg_id,
>  				unsigned int *payload_size, char **payload);
>  
>  /* --- Timestamp synchronization --- */
>  
> -enum{
> -	TRACECMD_TIME_SYNC_PROTO_NONE	= 0,
> -};
> +#define TRACECMD_TSYNC_PNAME_LENGTH	16
> +#define TRACECMD_TSYNC_PROTO_NONE	"none"
> +
>  enum{
>  	TRACECMD_TIME_SYNC_CMD_PROBE	= 1,
>  	TRACECMD_TIME_SYNC_CMD_STOP	= 2,
>  };
>  
> -#define TRACECMD_TIME_SYNC_PROTO_PTP_WEIGHT	10
> -
>  struct tracecmd_time_sync {
> -	unsigned int			sync_proto;
> +	char				*proto_name;

	cost char			*proto_name;

>  	int				loop_interval;
>  	pthread_mutex_t			lock;
>  	pthread_cond_t			cond;
> @@ -438,9 +432,9 @@ struct tracecmd_time_sync {
>  };
>  
>  void tracecmd_tsync_init(void);
> -int tracecmd_tsync_proto_getall(char **proto_mask, int *words);
> -unsigned int tracecmd_tsync_proto_select(char *proto_mask, int words);
> -bool tsync_proto_is_supported(unsigned int proto_id);
> +int tracecmd_tsync_proto_getall(char ***protos);
> +char *tracecmd_tsync_proto_select(char **protos);

const char *

> +bool tsync_proto_is_supported(char *proto_name);
>  void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
>  void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
>  int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
> diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
> index 1de9d5e5..1f3bc443 100644
> --- a/lib/trace-cmd/include/trace-tsync-local.h
> +++ b/lib/trace-cmd/include/trace-tsync-local.h
> @@ -26,12 +26,12 @@ struct clock_sync_context {
>  	unsigned int			remote_port;
>  };
>  
> -static int get_trace_req_protos(char *buf, int length,
> -				char **tsync_protos,
> -				unsigned int *tsync_protos_size)
> +static int get_trace_req_protos(char *buf, int length, char ***tsync_protos)
>  {
> -	*tsync_protos = malloc(length);
> -	if (!*tsync_protos)
> +	int count = 0;
> +	char *p;
> +	int i, j;
> +
> +	i = length;
> +	p = buf;
> +	while (i > 0) {
> +		i -= strlen(p) + 1;
> +		count++;
> +		p -= strlen(p) + 1;

Do you really want p to go backwards here?

> +	}
> +
> +	*tsync_protos = calloc(count + 1, sizeof(char *));
> +	if (!(*tsync_protos))
>  		return -1;
> -	memcpy(*tsync_protos, buf, length);
> -	*tsync_protos_size = length;
> +
> +	i = length;
> +	p = buf;
> +	j = 0;
> +	while (i > 0 && j < (count - 1)) {
> +		i -= strlen(p) + 1;
> +		(*tsync_protos)[j++] = strdup(p);
> +		p -= strlen(p) + 1;

And here too?

-- Steve

> +	}
>  
>  	return 0;
>  }
> @@ -1026,8 +1054,7 @@ out:
>  int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
>  				int *argc, char ***argv, bool *use_fifos,
>  				unsigned long long *trace_id,
> -				char **tsync_protos,
> -				unsigned int *tsync_protos_size)
> +				char ***tsync_protos)
>  {
>  	struct tracecmd_msg msg;
>  	unsigned int param_id;
