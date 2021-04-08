Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481D6C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 12:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F232361132
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 12:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhDHMxy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 08:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229803AbhDHMxx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 08:53:53 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1196661105;
        Thu,  8 Apr 2021 12:53:41 +0000 (UTC)
Date:   Thu, 8 Apr 2021 08:53:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: Re: [PATCH 2/3] libtracefs: Add tracefs_function_notrace() API
Message-ID: <20210408085340.5e84064f@gandalf.local.home>
In-Reply-To: <CAPpZLN5Lmc6QegJrLLzXsbu-bDtAVovnSF+=NZpr8E53K-JLYQ@mail.gmail.com>
References: <20210407202126.1870994-1-rostedt@goodmis.org>
        <20210407202126.1870994-3-rostedt@goodmis.org>
        <CAPpZLN5Lmc6QegJrLLzXsbu-bDtAVovnSF+=NZpr8E53K-JLYQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 8 Apr 2021 07:25:20 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
> > index bf2fabf..9f45624 100644
> > --- a/src/tracefs-instance.c
> > +++ b/src/tracefs-instance.c
> > @@ -44,6 +44,7 @@ static struct tracefs_instance *instance_alloc(const char *trace_dir, const char
> >         }
> >
> >         instance->ftrace_filter_fd = -1;
> > +       instance->ftrace_notrace_fd = -1;  
> 
> These descriptors should be closed in tracefs_instance_free(), as part
> of the instance cleanup.

Good point. I'll add a patch on top of this one to close both of them.

> 
> >
> >         return instance;
> >
> > diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> > index 21a9bd3..b41806b 100644
> > --- a/src/tracefs-tools.c
> > +++ b/src/tracefs-tools.c
> > @@ -21,10 +21,12 @@
> >
> >  #define TRACE_CTRL             "tracing_on"
> >  #define TRACE_FILTER           "set_ftrace_filter"
> > +#define TRACE_NOTRACE          "set_ftrace_notrace"
> >  #define TRACE_FILTER_LIST      "available_filter_functions"
> >
> >  /* File descriptor for Top level set_ftrace_filter  */
> >  static int ftrace_filter_fd = -1;
> > +static int ftrace_notrace_fd = -1;
> >  static pthread_mutex_t filter_lock = PTHREAD_MUTEX_INITIALIZER;  
> 
> I'm wondering if we should free these global resources somehow. A
> cleanup API for the whole library can be implemented  using
> __attribute__((destructor)), or some other way ?

No need. The OS will close them for you when the application exits. All
file descriptors that are opened will be closed by the OS.

That said, we should probably add O_CLOEXEC in the open for them such that
they don't stay open if the application does an exec() system call.

-- Steve
