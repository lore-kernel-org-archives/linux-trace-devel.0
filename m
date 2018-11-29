Return-Path: <SRS0=ZWpJ=OI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:58556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728272AbeK3DLn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Nov 2018 22:11:43 -0500
Date: Thu, 29 Nov 2018 11:05:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [POC][PATCH v4] tools/lib/traceevent: make libtraceevent thread
 safe
Message-ID: <20181129110549.5039c7ce@gandalf.local.home>
In-Reply-To: <20181129122330.22500-1-tstoyanov@vmware.com>
References: <20181129122330.22500-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 29 Nov 2018 12:23:42 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch is a PoC about transforming libtraceevent
> into a thread safe library. It implements per thread local
> storage and internal APIs to access it. It covers only
> tep->last_event cache, but easily can be extended with all
> library's thread sensitive data.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
> v2: Added local thread data per tep context
> v3: Implemented APIs to access specific tread local data,
>     instead of the whole struct tep_thread_data.
> v4: Simplify the implementation to keep cache only for the last
>     used tep context in current thread, instead to track
>     cache for all tep contexts. Remove "tep_" prefix of functions,
>     as these are internal APIs and are not going to be exposed to
>     the library users.
> ---
>  tools/lib/traceevent/event-parse-local.h  | 16 ++++--
>  tools/lib/traceevent/event-parse-thread.c | 62 +++++++++++++++++++++++
>  tools/lib/traceevent/event-parse.c        | 21 ++++----
>  3 files changed, 87 insertions(+), 12 deletions(-)
>  create mode 100644 tools/lib/traceevent/event-parse-thread.c
> 
> diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
> index 9a092dd4a86d..bf3f810ce02f 100644
> --- a/tools/lib/traceevent/event-parse-local.h
> +++ b/tools/lib/traceevent/event-parse-local.h
> @@ -14,6 +14,13 @@ struct func_list;
>  struct event_handler;
>  struct func_resolver;
>  
> +/* cache */
> +struct tep_thread_data {
> +	struct tep_handle *tep;
> +
> +	struct tep_event *last_event;

Small nit. The space between tep and last_event isn't needed.

> +};
> +

The rest looks good. Care to send a non POC patch?

Thanks!

-- Steve
