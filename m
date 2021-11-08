Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B1BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 22:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7F3961105
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 22:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240772AbhKHWs3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 17:48:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233784AbhKHWs3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 17:48:29 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0536961105;
        Mon,  8 Nov 2021 22:45:43 +0000 (UTC)
Date:   Mon, 8 Nov 2021 17:45:42 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     mhiramat@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/10] user_events: Optimize writing events by only
 copying data once
Message-ID: <20211108174542.39c255e1@gandalf.local.home>
In-Reply-To: <20211104170433.2206-10-beaub@linux.microsoft.com>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
        <20211104170433.2206-10-beaub@linux.microsoft.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  4 Nov 2021 10:04:32 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> Pass iterator through to probes to allow copying data directly to the
> probe buffers instead of taking multiple copies. Enables eBPF user and
> raw iterator types out to programs for no-copy scenarios.
> 
> Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> ---
>  kernel/trace/trace_events_user.c | 97 +++++++++++++++++++++++---------
>  1 file changed, 69 insertions(+), 28 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
> index b5fe0550b489..d50118b9630a 100644
> --- a/kernel/trace/trace_events_user.c
> +++ b/kernel/trace/trace_events_user.c
> @@ -39,6 +39,10 @@
>  #define MAX_EVENT_DESC 512
>  #define EVENT_NAME(user_event) ((user_event)->tracepoint.name)
>  
> +#define MAX_BPF_COPY_SIZE PAGE_SIZE
> +#define MAX_STACK_BPF_DATA 512
> +#define copy_nofault copy_from_iter_nocache
> +
>  static char *register_page_data;
>  
>  static DEFINE_MUTEX(reg_mutex);
> @@ -63,8 +67,7 @@ struct user_event_refs {
>  	struct user_event *events[];
>  };
>  
> -typedef void (*user_event_func_t) (struct user_event *user,
> -				   void *data, u32 datalen,
> +typedef void (*user_event_func_t) (struct user_event *user, struct iov_iter *i,
>  				   void *tpdata);
>  
>  static int user_event_parse(char *name, char *args, char *flags,
> @@ -491,7 +494,7 @@ static struct user_event *find_user_event(char *name, u32 *outkey)
>  /*
>   * Writes the user supplied payload out to a trace file.
>   */
> -static void user_event_ftrace(struct user_event *user, void *data, u32 datalen,
> +static void user_event_ftrace(struct user_event *user, struct iov_iter *i,
>  			      void *tpdata)
>  {
>  	struct trace_event_file *file;
> @@ -506,41 +509,82 @@ static void user_event_ftrace(struct user_event *user, void *data, u32 datalen,
>  		return;
>  
>  	entry = trace_event_buffer_reserve(&event_buffer, file,
> -					   sizeof(*entry) + datalen);
> +					   sizeof(*entry) + i->count);
>  
>  	if (unlikely(!entry))
>  		return;
>  
> -	memcpy(entry + 1, data, datalen);
> +	if (unlikely(!copy_nofault(entry + 1, i->count, i)))

Need:
		__trace_event_discard_commit(event_buffer.buffer, event_buffer.event);

Because the trace_event_buffer_reserve() will not only allocate space on
the ring buffer, but may also disable preemption.

-- Steve


> +		return;
>  
>  	trace_event_buffer_commit(&event_buffer);
>  }
>  
>  #ifdef CONFIG_PERF_EVENTS
