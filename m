Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:50208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727608AbeHAVKP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Aug 2018 17:10:15 -0400
Date: Wed, 1 Aug 2018 15:22:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 03/24] tools/lib/traceevent, tools/perf: Rename pevent
 plugin related APIs
Message-ID: <20180801152257.430e6682@gandalf.local.home>
In-Reply-To: <20180801124156.20894-4-tz.stoyanov@gmail.com>
References: <20180801124156.20894-1-tz.stoyanov@gmail.com>
        <20180801124156.20894-4-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed,  1 Aug 2018 15:41:35 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> In order to make libtraceevent into a proper library, variables, data
> structures and functions require a unique prefix to prevent name space
> conflicts. That prefix will be "tep_" and not "pevent_". This changes
> the pevent plugin related API.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tools/lib/traceevent/event-parse.c         |  8 ++--
>  tools/lib/traceevent/event-parse.h         | 50 +++++++++++-----------
>  tools/lib/traceevent/event-plugin.c        | 24 +++++------
>  tools/lib/traceevent/plugin_cfg80211.c     |  4 +-
>  tools/lib/traceevent/plugin_function.c     | 10 ++---
>  tools/lib/traceevent/plugin_hrtimer.c      |  4 +-
>  tools/lib/traceevent/plugin_jbd2.c         |  4 +-
>  tools/lib/traceevent/plugin_kmem.c         |  4 +-
>  tools/lib/traceevent/plugin_kvm.c          |  4 +-
>  tools/lib/traceevent/plugin_mac80211.c     |  4 +-
>  tools/lib/traceevent/plugin_sched_switch.c |  4 +-
>  tools/lib/traceevent/plugin_scsi.c         |  4 +-
>  tools/lib/traceevent/plugin_xen.c          |  4 +-
>  13 files changed, 64 insertions(+), 64 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index 90f30f9dde14..5f8019773673 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -88,7 +88,7 @@ struct event_handler {
>  	int				id;
>  	const char			*sys_name;
>  	const char			*event_name;
> -	pevent_event_handler_func	func;
> +	tep_event_handler_func	func;

You want to make sure that when things change, you keep the formatting
in sync. This makes it a bit more tedious, as you need to scan the
code. The above causes "func" to no longer be in line with the rest of
the data structure. Note, this is a common error with changes like
this, especially when they affect a lot of files like this change set
does.

You may want to scan all the code that was changed to make sure that
there's no other modifications of formats caused by name changes.

Thanks!

-- Steve



>  	void				*context;
>  };
>  
> @@ -6633,7 +6633,7 @@ static struct event_format *pevent_search_event(struct tep_handle *pevent, int i
