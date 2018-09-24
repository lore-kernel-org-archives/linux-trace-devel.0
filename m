Return-Path: <SRS0=/bgX=MG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:59086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbeIXVXz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Sep 2018 17:23:55 -0400
Date: Mon, 24 Sep 2018 12:21:05 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH 00/15] tools/lib/traceevent: Namespace updates to make
 traceevent into a library
Message-ID: <20180924152105.GC4640@kernel.org>
References: <20180919185643.358126338@goodmis.org>
 <20180923185626.GC30923@krava>
 <20180924045523.2c15be13@vmware.local.home>
 <20180924141632.GA4640@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180924141632.GA4640@kernel.org>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Em Mon, Sep 24, 2018 at 11:16:32AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Sep 24, 2018 at 04:55:23AM -0400, Steven Rostedt escreveu:
> > On Sun, 23 Sep 2018 20:56:26 +0200
> > Jiri Olsa <jolsa@redhat.com> wrote:

> > > is there still something left to rename, or we can start moving it into public rpm?

> > We're testing it as a external library, and we did find something. Did
> > you get this patch?

> >  https://lore.kernel.org/lkml/20180921152037.1e23c7f4@gandalf.local.home
 
> I'm finishing tests with the patchset before this last patch, will push
> to Ingo soon, then will check if the patch with the private copy of the
> strerror_r() wrapper passes on the systems that made that wrapper came
> to be, i.e. systems using the musl libc (https://www.musl-libc.org/).

Ok, it passes on these systems:

   1 alpine:3.4                    : Ok   gcc (Alpine 5.3.0) 5.3.0
   2 alpine:3.5                    : Ok   gcc (Alpine 6.2.1) 6.2.1 20160822
   3 alpine:3.6                    : Ok   gcc (Alpine 6.3.0) 6.3.0
   4 alpine:3.7                    : Ok   gcc (Alpine 6.4.0) 6.4.0
   5 alpine:3.8                    : Ok   gcc (Alpine 6.4.0) 6.4.0
   6 alpine:edge                   : Ok   gcc (Alpine 6.4.0) 6.4.0

Which puzzled me, but then I saw that you guys are not using
strerror_r(), but strerror() that is not thread-safe, and then the
pitfalls with strerror_r() XSI/_GNU_SOURCE problems are not hit.

This same problem happened with tools/lib/bpf/, and I fixed it in by
having a separate file to create the wrapper, where we make sure
_GNU_SOURCE is not defined and continue using strerror_r():

   https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/commit/?h=perf/urgent&id=6d41907c630d3196be89c9ed5a7f8258486b3eaf

I think it would be interesting to use something similar so that
libtraceevent becomes thread safe for this specific point.

For now I've applied the patch to my local perf/core branch, so that it
gets tested in more systems.

- Arnaldo
