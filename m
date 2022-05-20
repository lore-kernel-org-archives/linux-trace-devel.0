Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F21C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 May 2022 20:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbiETUIs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 May 2022 16:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237646AbiETUIr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 May 2022 16:08:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83B119CEE9
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 May 2022 13:08:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DF3461AC3
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 May 2022 20:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44219C385AA;
        Fri, 20 May 2022 20:08:44 +0000 (UTC)
Date:   Fri, 20 May 2022 16:08:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vineeth Pillai <vineethrp@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH] trace-cmd: rework of the pid detection of vcpus
Message-ID: <20220520160842.75d0ecbe@gandalf.local.home>
In-Reply-To: <20220504010242.1388192-1-vineethrp@google.com>
References: <20220504010242.1388192-1-vineethrp@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  4 May 2022 01:02:42 +0000
Vineeth Pillai <vineethrp@google.com> wrote:


>  /* --- System --- */
>  unsigned long long tracecmd_generate_traceid(void);
>  int tracecmd_count_cpus(void);
> +int tracecmd_count_cpus_apicid(int *max_apicid);
>  
>  /* --- Hack! --- */
>  int tracecmd_blk_hack(struct tracecmd_input *handle);
> diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
> index 39465ad..1bb56a0 100644
> --- a/lib/trace-cmd/trace-msg.c
> +++ b/lib/trace-cmd/trace-msg.c
> @@ -73,6 +73,7 @@ struct tracecmd_msg_trace_req {
>  struct tracecmd_msg_trace_resp {
>  	be32 flags;
>  	be32 cpus;
> +	be32 max_apicid;
>  	be32 page_size;
>  	u64 trace_id;
>  	char tsync_proto_name[TRACECMD_TSYNC_PNAME_LENGTH];

Unfortunately, the above will break the protocol for released instances of
trace-cmd that is already out there. One requirement I have is that if two
instances of trace-cmd use to work (on host and guest) that if you upgrade
one of them, what use to work still does.

We need to figure out another way to handle this :-/


>  static void stop_mapping_vcpus(struct buffer_instance *instance,
> @@ -3961,21 +3959,19 @@ static void stop_mapping_vcpus(struct buffer_instance *instance,
>  	struct trace_mapping tmap = { };
>  	struct tep_handle *tep;
>  	const char *systems[] = { "kvm", NULL };
> -	int i;
>  
>  	if (!guest->instance)
>  		return;
>  
>  	tmap.pids = guest->task_pids;
> +	tmap.nr_cpus = 0;
>  	tmap.max_cpus = instance->cpu_count;
> +	tmap.max_apicid = instance->max_apicid;
>  
> -	tmap.map = malloc(sizeof(*tmap.map) * tmap.max_cpus);
> +	tmap.map = calloc((tmap.max_apicid + 1), sizeof(*tmap.map));
>  	if (!tmap.map)
>  		return;
>  
> -	for (i = 0; i < tmap.max_cpus; i++)
> -		tmap.map[i] = -1;

Note, we wrote this with -1, because we envisioned working with hypervisors
that may not be Linux, and that PID = 0 may be legitimate.

> -
>  	tracefs_instance_file_write(guest->instance, "events/kvm/kvm_entry/enable", "0");
>  
>  	tep = tracefs_local_events_system(NULL, systems);

We'll have to investigate a solution for this further.

-- Steve
