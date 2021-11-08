Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F17BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 23:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07810619A6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 23:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbhKHXDV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 18:03:21 -0500
Received: from linux.microsoft.com ([13.77.154.182]:43838 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbhKHXDU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 18:03:20 -0500
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id AACA720B409D;
        Mon,  8 Nov 2021 15:00:35 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AACA720B409D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636412435;
        bh=IYoekjc8BXBw1L4x6xX7X7r2zzBU7yy61cvPMt+EHUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JVLsB5gs/vLtjGojKAsPAz+nUbvHGKK7h7duI0yLF9k85mVF4x8irXN05/Gu8cLOs
         roc2L3hPpprHjLkjEQFCZcd9MzzwqrTilTl1ygfcnpjOrO2mTfN0ecW8f2m1S1F0N2
         mPrW7jh27vvwn2/FcG6d69R38msc/Y7pyrJIUeIY=
Date:   Mon, 8 Nov 2021 15:00:34 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     mhiramat@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/10] user_events: Optimize writing events by only
 copying data once
Message-ID: <20211108230034.GB1452@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
 <20211104170433.2206-10-beaub@linux.microsoft.com>
 <20211108174542.39c255e1@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108174542.39c255e1@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Nov 08, 2021 at 05:45:42PM -0500, Steven Rostedt wrote:
> On Thu,  4 Nov 2021 10:04:32 -0700
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > Pass iterator through to probes to allow copying data directly to the
> > probe buffers instead of taking multiple copies. Enables eBPF user and
> > raw iterator types out to programs for no-copy scenarios.
> > 
> > Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> > ---
> >  kernel/trace/trace_events_user.c | 97 +++++++++++++++++++++++---------
> >  1 file changed, 69 insertions(+), 28 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
> > index b5fe0550b489..d50118b9630a 100644
> > --- a/kernel/trace/trace_events_user.c
> > +++ b/kernel/trace/trace_events_user.c
> > @@ -39,6 +39,10 @@
> >  #define MAX_EVENT_DESC 512
> >  #define EVENT_NAME(user_event) ((user_event)->tracepoint.name)
> >  
> > +#define MAX_BPF_COPY_SIZE PAGE_SIZE
> > +#define MAX_STACK_BPF_DATA 512
> > +#define copy_nofault copy_from_iter_nocache
> > +
> >  static char *register_page_data;
> >  
> >  static DEFINE_MUTEX(reg_mutex);
> > @@ -63,8 +67,7 @@ struct user_event_refs {
> >  	struct user_event *events[];
> >  };
> >  
> > -typedef void (*user_event_func_t) (struct user_event *user,
> > -				   void *data, u32 datalen,
> > +typedef void (*user_event_func_t) (struct user_event *user, struct iov_iter *i,
> >  				   void *tpdata);
> >  
> >  static int user_event_parse(char *name, char *args, char *flags,
> > @@ -491,7 +494,7 @@ static struct user_event *find_user_event(char *name, u32 *outkey)
> >  /*
> >   * Writes the user supplied payload out to a trace file.
> >   */
> > -static void user_event_ftrace(struct user_event *user, void *data, u32 datalen,
> > +static void user_event_ftrace(struct user_event *user, struct iov_iter *i,
> >  			      void *tpdata)
> >  {
> >  	struct trace_event_file *file;
> > @@ -506,41 +509,82 @@ static void user_event_ftrace(struct user_event *user, void *data, u32 datalen,
> >  		return;
> >  
> >  	entry = trace_event_buffer_reserve(&event_buffer, file,
> > -					   sizeof(*entry) + datalen);
> > +					   sizeof(*entry) + i->count);
> >  
> >  	if (unlikely(!entry))
> >  		return;
> >  
> > -	memcpy(entry + 1, data, datalen);
> > +	if (unlikely(!copy_nofault(entry + 1, i->count, i)))
> 
> Need:
> 		__trace_event_discard_commit(event_buffer.buffer, event_buffer.event);
> 
> Because the trace_event_buffer_reserve() will not only allocate space on
> the ring buffer, but may also disable preemption.
> 
> -- Steve
> 

Ah, thank you!

-Beau

> 
> > +		return;
> >  
> >  	trace_event_buffer_commit(&event_buffer);
> >  }
> >  
> >  #ifdef CONFIG_PERF_EVENTS
