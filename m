Return-Path: <SRS0=/bgX=MG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:35604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728122AbeIXUS6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Sep 2018 16:18:58 -0400
Date: Mon, 24 Sep 2018 11:16:32 -0300
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
Message-ID: <20180924141632.GA4640@kernel.org>
References: <20180919185643.358126338@goodmis.org>
 <20180923185626.GC30923@krava>
 <20180924045523.2c15be13@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180924045523.2c15be13@vmware.local.home>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Em Mon, Sep 24, 2018 at 04:55:23AM -0400, Steven Rostedt escreveu:
> On Sun, 23 Sep 2018 20:56:26 +0200
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > 
> > Steven,
> > is there still something left to rename, or we can start moving it into public rpm?
> > 
> 
> We're testing it as a external library, and we did find something. Did
> you get this patch?
> 
>  https://lore.kernel.org/lkml/20180921152037.1e23c7f4@gandalf.local.home

I'm finishing tests with the patchset before this last patch, will push
to Ingo soon, then will check if the patch with the private copy of the
strerror_r() wrapper passes on the systems that made that wrapper came
to be, i.e. systems using the musl libc (https://www.musl-libc.org/).
 
> We're testing it against powertop and mceutils, when we get it working
> well with them, then I think it's time to start going ahead and making
> it into an rpm.

At some point would be nice if you guys provided patches to make
tools/perf/ link dynamicly to libtraceevent as well.

- Arnaldo
