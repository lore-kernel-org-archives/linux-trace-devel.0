Return-Path: <SRS0=Wk/S=MR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:45684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727572AbeJEWoe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Oct 2018 18:44:34 -0400
Date: Fri, 5 Oct 2018 11:45:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Colin Patrick McCabe <cmccabe@alumni.cmu.edu>
Subject: Re: [PATCH v3] tools/lib/traceevent: Replace str_error_r() with an
 open coded implementation
Message-ID: <20181005114516.68f47767@gandalf.local.home>
In-Reply-To: <20181005153731.GC20250@kernel.org>
References: <20181002175539.2ac894c7@gandalf.local.home>
        <20181005113056.55b23c31@gandalf.local.home>
        <20181005153731.GC20250@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 5 Oct 2018 12:37:31 -0300
Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Em Fri, Oct 05, 2018 at 11:30:56AM -0400, Steven Rostedt escreveu:
> > Bah, I now get warnings that sys_nerr and sys_errlist are deprecated.
> > 
> > OK, so going back to just using the racy strerror() should be good
> > enough, as this incompatibility with strerror_r() is a disaster!  
> 
> I've been there, done that... ;-) Check:
> 
> tools/lib/str_error_r.c
> tools/lib/bpf/str_error.c
> 
> The trick: have this function in a separate file, so that _GNU_SOURCE
> doesn't get in the way...
> 

Yep, I've been looking at these. I'll need to add yet another version,
so that we can have it for the external libtraceevent. I'll be sending
out a patch shortly.

-- Steve
