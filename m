Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600F8C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Feb 2021 01:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D4F164EF1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Feb 2021 01:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbhBYBYu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Feb 2021 20:24:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229954AbhBYBYt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Feb 2021 20:24:49 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73B7D64EF1;
        Thu, 25 Feb 2021 01:24:08 +0000 (UTC)
Date:   Wed, 24 Feb 2021 20:24:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Add new API for open trace marker file
Message-ID: <20210224202406.5e3e0796@oasis.local.home>
In-Reply-To: <CAPpZLN7GS1WOxrs6-b3brUbx93ZWyUDMregp4xFXUskqSUMWsw@mail.gmail.com>
References: <20210219055353.2244340-1-tz.stoyanov@gmail.com>
        <20210219092642.0f496a19@gandalf.local.home>
        <CAPpZLN7GS1WOxrs6-b3brUbx93ZWyUDMregp4xFXUskqSUMWsw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Feb 2021 07:35:30 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> >
> > As I wrote the perf-trace.c program, I was thinking what we really should
> > have is the following API. We can keep this API, but what would be nice is:
> >
> >
> >         int tracefs_print_init(struct tracefs_instance *instance);
> >
> >         int tracefs_print(struct tracefs_instance *instance,
> >                          const char *fmt, ...);
> >
> >         int tracefs_vprint(struct tracefs_instance *instance,
> >                            const char *fmt, va_list ap);
> >
> >         void tracefs_print_reset(struct tracefs_instance *instance);
> >
> > Where tracefs_print_init() will open the trace_marker for that instance
> > (NULL being the top level), and storing it in the instance structure.  
> 
> You mean to hold the marker fd in the tracefs_instance structure ?
> I like such approach, to hold some library specific context in that
> structure, internally and not visible from the user. In that case we do
> not need tracefs_print_init() at all, the first call to some tracefs_print
> API will open the file.

We need to have the tracefs_print_init() because when trace_marker
writes are done, it can happen in a place that we don't want any
unnecessary kernel actions. For example, cyclictest could use this, and
it uses the write to trace_marker in a place that there should be
minimal disturbance to the system. Having the first write open the file
would require the open system call, and that would be unacceptable for
the use case.

The normal use cases that use trace marker does exactly what is
explained above. The file descriptor is opened at the start of
execution, so that it can be used later in the the code when needed
without needing that open system call. Not to mention, it causes a
large latency to open it first. Hence, why we need the init function.


> But that will make the APIs not thread safe, is
> it OK marker fd to be used from multiple threads at the same time ?

Yes, because the locking would happen in the kernel. Now, the opening
should have pthread mutexes around it, which would be another reason to
have the init, to not need the mutex calls to open.

That is, we should have this:

int tracefs_print_init(struct tracefs_instance *instance)
{
	int *print_fd = instance ? &instance->print_fd : &global_print_fd;

	if (*print_fd >= 0)
		return *print_fd;

	pthread_mutex_lock(&open_print_mutex);
	if (*print_fd < 0) {
		path = // get path to trace_marker for instance
		*print_fd = open(path, O_WRONLY);
	}
	pthread_mutex_unlock(&open_print_mutex);
	return *print_fd;
}

int tracefs_vprint(struct tracefs_instance *instance,
		   const char *fmt, va_list ap)
{
	int *print_fd = instance ? &instance->print_fd : &global_print_fd;

	if (*print_fd <= 0) {
		*print_fd = tracefs_print_init(instance);
		if (*print_fd <= 0)
			return -1;
	}

	// do write here.
}	

That is, only the opening needs a mutex protection.


> 
> >
> > tracefs_print() and tracefs_vprint() will check if the trace_marker
> > file has already been opened (tracefs_print_init() was previously
> > called), and if not, it will open it and keep it open. Then it will
> > write to the trace_marker file the passed in print data after
> > formatting it (see my trace_print in perf-trace.c).
> >
> > The tracefs_print_reset() will simply close the trace_marker file
> > if it was previously opened, note, so will any of the destructors
> > of the instance.
> >
> > We could also have:
> >
> >         int tracefs_raw_print_init(struct tracefs_instance
> > *instance);
> >
> >         int tracefs_raw_print(struct tracefs_instance *instance,
> >                           void *data, int len);
> >
> >         void tracefs_raw_print_reset(struct tracefs_instance
> > *instance);
> >
> >
> > That is the same, but instead of writing string data to the
> > trace_marker, it would write in memory into trace_marker_raw.  
> 
> I'm afraid that having too many APIs with sort of overlapping
> functionality could make the library hard to use ? Actually the
> proposed new API by this patch, tracefs_trace_marker_get_fd(),
> already duplicates the existing tracefs_instance_file_open() API.

I don't think it would be more difficult to use. We can advertise the
normal use cases, but always leave the choice of those hard core users
that want to do a little bit extra available.

I hate libraries that "hand hold" too much, where I can't do what I
want to do, because the authors cater too much to the novice and not
the advance users. Being that this is going to be used by people that
need to know kernel events, I'd suspect that you'll have more advance
users that novices once this takes off.

-- Steve

