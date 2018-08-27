Return-Path: <SRS0=/uS6=LK=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:39946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726890AbeH0REe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Aug 2018 13:04:34 -0400
Date: Mon, 27 Aug 2018 09:17:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 21/24] tools lib traceevent: Rename various pevent
 get/set/is APIs
Message-ID: <20180827091754.3f832e87@gandalf.local.home>
In-Reply-To: <20180827081759.17297-22-tz.stoyanov@gmail.com>
References: <20180827081759.17297-1-tz.stoyanov@gmail.com>
        <20180827081759.17297-22-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon, 27 Aug 2018 11:17:56 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:


> diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
> index 808b2f3..88870c1 100644
> --- a/kernel-shark/trace-graph.c
> +++ b/kernel-shark/trace-graph.c
> @@ -1133,7 +1133,7 @@ int trace_graph_check_sched_switch(struct graph_info *ginfo,
>  		 * First time through, register any missing
>  		 *  comm / pid mappings.
>  		 */
> -		if (!pevent_pid_is_registered(ginfo->pevent, *pid))
> +		if (!tep_find_event_by_record(ginfo->pevent, *pid))

Hmm, this isn't just a name change, but a change in function. Did you
mean this?

-- Steve

>  			tep_register_comm(ginfo->pevent,
>  					  *comm, *pid);
>  	}
