Return-Path: <SRS0=Wk/S=MR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:48726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727572AbeJEXJW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Oct 2018 19:09:22 -0400
Date: Fri, 5 Oct 2018 13:09:57 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Colin Patrick McCabe <cmccabe@alumni.cmu.edu>
Subject: Re: [PATCH v3] tools/lib/traceevent: Replace str_error_r() with an
 open coded implementation
Message-ID: <20181005160957.GE20250@kernel.org>
References: <20181002175539.2ac894c7@gandalf.local.home>
 <20181005113056.55b23c31@gandalf.local.home>
 <20181005153731.GC20250@kernel.org>
 <20181005114516.68f47767@gandalf.local.home>
 <20181005154740.GD20250@kernel.org>
 <20181005115843.46155df8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005115843.46155df8@gandalf.local.home>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Em Fri, Oct 05, 2018 at 11:58:43AM -0400, Steven Rostedt escreveu:
> On Fri, 5 Oct 2018 12:47:40 -0300 Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> > > Yep, I've been looking at these. I'll need to add yet another version,
> > > so that we can have it for the external libtraceevent. I'll be sending
> > > out a patch shortly.  
> > 
> > Unfortunately, yes, due to licensing and because we don't have a
> > liblinux with the things in tools/lib/*.c, we need to relicense that as
> > at least LGPL 2.1 :-\
> > 
> > Lets start here, whoever reads this message, would you have a problem
> > with relicensing what is in tools/lib/*.c and tools/lib/api/ as LGPL
> > 2.1?
> > 
> 
> All of the libtraceeevent code was already licensed as LGPL 2.1 to
> begin with. It was taken from trace-cmd which had that as LGPL as well.

yes, sure, you did it right :-)

- Arnaldo
