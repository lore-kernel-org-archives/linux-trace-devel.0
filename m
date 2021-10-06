Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC584C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Oct 2021 17:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8390D610FC
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Oct 2021 17:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbhJFRqe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Oct 2021 13:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238534AbhJFRqW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Oct 2021 13:46:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2689610E6;
        Wed,  6 Oct 2021 17:44:29 +0000 (UTC)
Date:   Wed, 6 Oct 2021 13:44:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     mhiramat@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-ID: <20211006134428.1132ebe0@gandalf.local.home>
In-Reply-To: <20211006172723.GA2812@kbox>
References: <20211005224428.2551-1-beaub@linux.microsoft.com>
        <20211006125441.24982dd3@gandalf.local.home>
        <20211006172723.GA2812@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 6 Oct 2021 10:27:23 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> On Wed, Oct 06, 2021 at 12:54:41PM -0400, Steven Rostedt wrote:
> > > Psuedo code example of typical usage:
> > > page_fd = open("user_events_mmap", O_RDWR);
> > > page_data = mmap(NULL, PAGE_SIZE, PROT_READ, MAP_SHARED, page_fd, 0);
> > > 
> > > data_fd = open("user_events_data", O_RDWR);
> > > data_id = ioctl(data_fd, DIAG_IOCSREG, "test");
> > > 
> > > if (page_data[data_id]) write(data_fd, &payload, sizeof(payload));  
> > 
> > What is the type of "page_data". I'd like to test it before accepting it.
> > 
> > From playing around, I see that page_data is of type char *.  
> Yes, it is char *. I'll make this clear in the next patch version
> description.

Thanks.

> 
> > > +/* Bits 0-6 are for known probe types, Bit 7 is for unknown probes */
> > > +#define EVENT_BIT_FTRACE 0
> > > +#define EVENT_BIT_PERF 1
> > > +#define EVENT_BIT_OTHER 7
> > > +
> > > +#define EVENT_STATUS_FTRACE (1 << EVENT_BIT_FTRACE)
> > > +#define EVENT_STATUS_PERF (1 << EVENT_BIT_PERF)
> > > +#define EVENT_STATUS_OTHER (1 << EVENT_BIT_OTHER)  
> ...
> > > +#define DIAG_IOC_MAGIC '*'
> > > +#define DIAG_IOCSREG _IOW(DIAG_IOC_MAGIC, 0, char*)
> > > +#define DIAG_IOCSDEL _IOW(DIAG_IOC_MAGIC, 1, char*)
> > > +#define DIAG_IOCQLOCOFFSET _IO(DIAG_IOC_MAGIC, 2)  
> > 
> > These obviously will need to go into a user abi header file.
> >   
> Yes, I'm glad you mentioned it. I wasn't entirely sure where it should
> live. Is there precedent on where to put these so they span both kernel
> and user for discovery / distribution?

There is a include/uapi directory in the Linux source code. I've never
added to it (that I remember, but maybe I have? Wouldn't surprise me if I
did and forgot about it :-p Sucks getting old).


> 
> > > +
> > > +static char *register_page_data;
> > > +
> > > +static DEFINE_HASHTABLE(register_table, 4);
> > > +static DECLARE_BITMAP(page_bitmap, MAX_EVENTS);
> > > +
> > > +struct user_event {
> > > +	struct tracepoint tracepoint;
> > > +	struct trace_event_call call;
> > > +	struct trace_event_class class;
> > > +	struct dyn_event devent;
> > > +	struct hlist_node node;
> > > +	atomic_t refs;
> > > +	int index;
> > > +	char *args;
> > > +};
> > > +
> > > +#ifdef CONFIG_PERF_EVENTS
> > > +struct user_bpf_context {
> > > +	int udatalen;
> > > +	const char __user *udata;
> > > +};
> > > +#endif
> > > +
> > > +typedef void (*user_event_func_t) (struct user_event *user,
> > > +				   const char __user *udata,
> > > +				   size_t udatalen, void *tpdata);
> > > +
> > > +static int register_user_event(char *name, char *args,
> > > +			       struct user_event **newuser);
> > > +  
> > 
> > [..]
> >   
> Is the ask here to get user_bpf_context definition also into a user ABI
> header? (I took it as that).

Not sure I understand the question.

> 
> > > +static int __init trace_events_user_init(void)
> > > +{
> > > +	int ret;
> > > +
> > > +	/* Zero all bits beside 0 (which is reserved for failures) */
> > > +	bitmap_zero(page_bitmap, MAX_EVENTS);
> > > +	set_bit(0, page_bitmap);
> > > +
> > > +	register_page_data = kmalloc(MAX_EVENTS, GFP_KERNEL);  
> > 
> > You want "kzalloc" here. Because when I read the map without adding
> > anything, I get:
> > 
> >    printf("%lx\n", *(unsigned long *)page_data);
> > 
> > Produces:
> > 
> >    ffffffff9065004e
> > 
> > But if I convert it to kzalloc() it gives me:
> > 
> >    0
> > 
> > Thus, you are exposing stale memory. If you want to expose this to
> > non-admin users, this is a major security leak.
> > 
> > -- Steve
> >   
> Oops, sorry about that!

No problem. Just pointing it out.

I expect that this is going to take a few back and forth to get right. But
I do like the way it is heading.

-- Steve

