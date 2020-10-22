Return-Path: <SRS0=yu5d=D5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18943C2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Oct 2020 01:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2144208C3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Oct 2020 01:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441930AbgJVBjh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Oct 2020 21:39:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439831AbgJVBjg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Oct 2020 21:39:36 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A667208C3;
        Thu, 22 Oct 2020 01:39:35 +0000 (UTC)
Date:   Wed, 21 Oct 2020 21:39:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v24 05/10] trace-cmd: Add clock parameter to timestamp
 synchronization plugins
Message-ID: <20201021213933.2c69d3e5@oasis.local.home>
In-Reply-To: <20201009140338.25260-6-tz.stoyanov@gmail.com>
References: <20201009140338.25260-1-tz.stoyanov@gmail.com>
        <20201009140338.25260-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  9 Oct 2020 17:03:33 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Some timestamp synchronization plugins may not support all ftrace
> clocks. Added logic to timestamp synchronization plugins to declare what
> ftace clocks they support. Added logic to select plugin depending on the

 s/ftace/ftrace/

> ftrace clock used in the current trace session and supported clocks.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h             |  4 ++--
>  lib/trace-cmd/include/trace-tsync-local.h |  1 +
>  lib/trace-cmd/trace-timesync-ptp.c        |  1 +
>  lib/trace-cmd/trace-timesync.c            | 21 +++++++++++++++++++--
>  tracecmd/trace-record.c                   |  4 +++-
>  tracecmd/trace-tsync.c                    |  2 +-
>  6 files changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 393a2e7b..66b5d02b 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -455,8 +455,8 @@ struct tracecmd_time_sync {
>  };
>  
>  void tracecmd_tsync_init(void);
> -int tracecmd_tsync_proto_getall(char **proto_mask, int *words);
> -unsigned int tracecmd_tsync_proto_select(char *proto_mask, int words);
> +int tracecmd_tsync_proto_getall(char **proto_mask, int *words, const char *clock);
> +unsigned int tracecmd_tsync_proto_select(char *proto_mask, int words, char *clock);
>  bool tsync_proto_is_supported(unsigned int proto_id);
>  void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
>  void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
> diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
> index 1de9d5e5..37c3597b 100644
> --- a/lib/trace-cmd/include/trace-tsync-local.h
> +++ b/lib/trace-cmd/include/trace-tsync-local.h
> @@ -27,6 +27,7 @@ struct clock_sync_context {
>  };
>  
>  int tracecmd_tsync_proto_register(unsigned int proto_id, int weight,
> +				  int supported_clocks,
>  				int (*init)(struct tracecmd_time_sync *),
>  				int (*free)(struct tracecmd_time_sync *),
>  				int (*calc)(struct tracecmd_time_sync *,
> diff --git a/lib/trace-cmd/trace-timesync-ptp.c b/lib/trace-cmd/trace-timesync-ptp.c
> index 19e2f647..51f17bca 100644
> --- a/lib/trace-cmd/trace-timesync-ptp.c
> +++ b/lib/trace-cmd/trace-timesync-ptp.c
> @@ -678,6 +678,7 @@ int ptp_clock_sync_register(void)
>  {
>  	return tracecmd_tsync_proto_register(TRACECMD_TIME_SYNC_PROTO_PTP,
>  					     TRACECMD_TIME_SYNC_PROTO_PTP_WEIGHT,
> +					     0,
>  					     ptp_clock_sync_init,
>  					     ptp_clock_sync_free,
>  					     ptp_clock_sync_calc);
> diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
> index e294698b..47d34e2a 100644
> --- a/lib/trace-cmd/trace-timesync.c
> +++ b/lib/trace-cmd/trace-timesync.c
> @@ -26,6 +26,7 @@ struct tsync_proto {
>  	struct tsync_proto *next;
>  	unsigned int proto_id;
>  	int	weight;
> +	int supported_clocks;
>  
>  	int (*clock_sync_init)(struct tracecmd_time_sync *clock_context);
>  	int (*clock_sync_free)(struct tracecmd_time_sync *clock_context);
> @@ -55,6 +56,7 @@ void tracecmd_tsync_init(void)
>  }
>  
>  int tracecmd_tsync_proto_register(unsigned int proto_id, int weight,
> +				int supported_clocks,
>  				int (*init)(struct tracecmd_time_sync *),
>  				int (*free)(struct tracecmd_time_sync *),
>  				int (*calc)(struct tracecmd_time_sync *,
> @@ -69,6 +71,7 @@ int tracecmd_tsync_proto_register(unsigned int proto_id, int weight,
>  		return -1;
>  	proto->proto_id = proto_id;
>  	proto->weight = weight;
> +	proto->supported_clocks = supported_clocks;
>  	proto->clock_sync_init = init;
>  	proto->clock_sync_free = free;
>  	proto->clock_sync_calc = calc;
> @@ -139,19 +142,26 @@ int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
>   *
>   * @proto_mask: bitmask array of time sync protocols, supported by the peer
>   * @length: size of the @protos array
> + * @clock: selected trace clock
>   *
>   * Retuns Id of a time sync protocol, that can be used with the peer, or 0
>   *	  in case there is no match with supported protocols
>   */
> -unsigned int tracecmd_tsync_proto_select(char *proto_mask, int length)
> +unsigned int tracecmd_tsync_proto_select(char *proto_mask, int length, char *clock)
>  {
>  	struct tsync_proto *selected = NULL;
>  	struct tsync_proto *proto;
> +	int clock_id = 0;
>  	int word;
>  	int id;
>  
> +	if (clock)
> +		clock_id = tracecmd_clock_str2id(clock);

I wonder if we should just have tracecmd_clock_str2id(NULL) return zero.

Then you don't need the 'if (clock)' check.


>  	for (word = 0; word < length; word++) {
>  		for (proto = tsync_proto_list; proto; proto = proto->next) {
> +			if (proto->supported_clocks && clock_id &&
> +			    !(proto->supported_clocks & clock_id))
> +				continue;
>  			if (proto->proto_id < word * PROTO_MASK_SIZE)
>  				continue;
>  
> @@ -181,18 +191,22 @@ unsigned int tracecmd_tsync_proto_select(char *proto_mask, int length)
>   * @proto_mask: return, allocated bitmask array of time sync protocols,
>   *	       supported by the peer. Must be freed by free()
>   * @words: return, allocated size of the @protobits array
> + * @clock: selected trace clock
>   *
>   * If completed successfully 0 is returned and allocated array in @proto_mask of
>   * size @words. In case of an error, -1 is returned.
>   * @proto_mask must be freed with free()
>   */
> -int tracecmd_tsync_proto_getall(char **proto_mask, int *words)
> +int tracecmd_tsync_proto_getall(char **proto_mask, int *words, const char *clock)
>  {
>  	struct tsync_proto *proto;
>  	int proto_max = 0;
> +	int clock_id = 0;
>  	int count = 0;
>  	char *protos;
>  
> +	if (clock)
> +		clock_id =  tracecmd_clock_str2id(clock);
>  	for (proto = tsync_proto_list; proto; proto = proto->next)
>  		if (proto->proto_id > proto_max)
>  			proto_max = proto->proto_id;
> @@ -205,6 +219,9 @@ int tracecmd_tsync_proto_getall(char **proto_mask, int *words)
>  	for (proto = tsync_proto_list; proto; proto = proto->next) {
>  		if ((proto->proto_id / PROTO_MASK_SIZE) >= count)
>  			continue;
> +		if (proto->supported_clocks && clock_id &&
> +		    !(proto->supported_clocks & clock_id))
> +			continue;
>  		protos[proto->proto_id / PROTO_MASK_SIZE] |=
>  				(1 << (proto->proto_id % PROTO_MASK_SIZE));
>  	}
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 9149cf76..08bbc0e0 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -3677,7 +3677,7 @@ static void connect_to_agent(struct buffer_instance *instance)
>  		die("Failed to allocate message handle");
>  
>  	if (instance->tsync.loop_interval >= 0)
> -		tracecmd_tsync_proto_getall(&protos, &protos_count);
> +		tracecmd_tsync_proto_getall(&protos, &protos_count, instance->clock);
>  
>  	ret = tracecmd_msg_send_trace_req(msg_handle, instance->argc,
>  					  instance->argv, use_fifos,
> @@ -6111,6 +6111,8 @@ static void parse_record_options(int argc,
>  						 (char *)top_instance.clock,
>  						 true);
>  					add_argv(instance, "-C", true);
> +					if (!instance->clock)
> +						instance->clock = strdup((char *)top_instance.clock);

Need to check the success of the allocation.

-- Steve

>  				}
>  			}
>  			instance->tsync.loop_interval = top_instance.tsync.loop_interval;
> diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
> index e639788d..832b70c3 100644
> --- a/tracecmd/trace-tsync.c
> +++ b/tracecmd/trace-tsync.c
> @@ -220,7 +220,7 @@ unsigned int tracecmd_guest_tsync(char *tsync_protos,
>  	int fd;
>  
>  	fd = -1;
> -	proto = tracecmd_tsync_proto_select(tsync_protos, tsync_protos_size);
> +	proto = tracecmd_tsync_proto_select(tsync_protos, tsync_protos_size, clock);
>  	if (!proto)
>  		return 0;
>  #ifdef VSOCK

