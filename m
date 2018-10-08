Return-Path: <SRS0=f4gm=MU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:53006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726291AbeJIAj7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Oct 2018 20:39:59 -0400
Date: Mon, 8 Oct 2018 14:27:10 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v4] tools/lib/traceevent: Separate out tep_strerror() for
 strerror_r() issues
Message-ID: <20181008172710.GN3541@kernel.org>
References: <20181005121816.484e654f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005121816.484e654f@gandalf.local.home>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Em Fri, Oct 05, 2018 at 12:18:16PM -0400, Steven Rostedt escreveu:
> 
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> While working on having PowerTop use libtracevent as a shared object
> library, Tzvetomir hit "str_error_r not defined". This was added by commit
> c3cec9e68f12d ("tools lib traceevent: Use str_error_r()") because
> strerror_r() has two definitions, where one is GNU specific, and the other
> is XSI complient. The strerror_r() is in a wrapper str_error_r() to keep the
> code from having to worry about which compiler is being used.
> 
> The problem is that str_error_r() is external to libtraceevent, and not part
> of the library. If it is used as a shared object then the tools using it
> will need to define that function. I do not want that function defined in
> libtraceevent itself, as it is out of scope for that library.
> 
> As there's only a single instance of this call, and its in the traceevent
> library's own tep_strerror() function, we can copy what was done in perf,
> and create yet another external file that undefs _GNU_SOURCE to use the more
> portable version of the function. We don't need to worry about the errors
> that strerror_r() returns. If the buffer isn't big enough, we simply
> truncate it.

Thanks, applied, replacing the previous version since this is still not
in tip.

- Arnaldo
