Return-Path: <SRS0=EnxC=OJ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:41338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbeLAD5j (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Nov 2018 22:57:39 -0500
Date: Fri, 30 Nov 2018 11:47:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 0/2] convert traceevent into a thread safe library
Message-ID: <20181130114742.43446dd8@gandalf.local.home>
In-Reply-To: <20181130131254.32621-1-tstoyanov@vmware.com>
References: <20181130131254.32621-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 30 Nov 2018 13:13:06 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This short patch series begins tranformation of libtraceevent into a
> thread safe library. It implements per thread local storage for 
> tep->last_event cache, and converts input_buf, input_buf_ptr
> and input_buf_siz internal variables to be thread specific.
> 

I've been thinking about this some. And we should change our
development model. We should be pushing these changes into the
trace-cmd tree first.

The reason I wanted to send to Linux tools/lib/traceevent was because
that would open it up to more people in the review stage. But
unfortunately, it leaves us vulnerable to having bugs and unexpected
consequences of these changes.

I think the renames and man pages were fine to go to Linux first. But
now that we are starting to change the way things work, that should go
into trace-cmd first, so that we can have a bit more thorough testing.

Let's get all the patches that have been sent upstream (including my
last patchset I sent to Arnaldo) backported into trace-cmd, and start
doing updates to the trace-cmd repo first. This way we can make sure
the code is tested before we send it to Arnaldo, because I believe they
think we are testing these patches before we send them, and honestly,
we are not.

Sound good?

Note, when writing the patches to trace-cmd, lets continue with the
naming convention "tools/lib/traceevent" just as if we were to be
sending them to Linux.

-- Steve


> Tzvetomir Stoyanov (2):
>   tools/lib/traceevent: make libtraceevent thread safe
>   tools/lib/traceevent: make few libtraceevent internal variables to be
>     per thread
> 
>  tools/lib/traceevent/Build                |  1 +
>  tools/lib/traceevent/event-parse-local.h  | 15 ++++--
>  tools/lib/traceevent/event-parse-thread.c | 63 +++++++++++++++++++++++
>  tools/lib/traceevent/event-parse.c        | 45 ++++++++--------
>  4 files changed, 100 insertions(+), 24 deletions(-)
>  create mode 100644 tools/lib/traceevent/event-parse-thread.c
> 
