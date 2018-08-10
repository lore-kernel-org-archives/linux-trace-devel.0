Return-Path: <SRS0=GMWY=KZ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54706 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727534AbeHJPn5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Aug 2018 11:43:57 -0400
Date: Fri, 10 Aug 2018 15:14:01 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [RFC][PATCH 00/24] tools lib traceevent: Rename pevent to tep
 for preparation for library
Message-ID: <20180810131401.GB4162@krava>
References: <20180808155548.510187543@goodmis.org>
 <20180810092137.GB14485@krava>
 <20180810090010.4537e14a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180810090010.4537e14a@gandalf.local.home>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, Aug 10, 2018 at 09:00:10AM -0400, Steven Rostedt wrote:
> On Fri, 10 Aug 2018 11:21:37 +0200
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> 
> > > This is not complete. It is only one of many preparations to make
> > > libtraceevent into a legitimate library. There's other naming conventions
> > > that will be made. But for now, I would like to hear thoughts about
> > > this change before we proceed further.  
> > 
> > right, I can see more things that needs rename, like in print_arg*,
> > trace_* stuff and others
> 
> We are working on renaming the other data structures. As for the
> "trace_" it is really "trace_seq_*" That's not going to get renamed. We
> may move it to another header file. It matches the trace_seq_* code in
> the kernel, and I would like to keep that the same.
> 
> > 
> > I'm also getting weird make error when compiling in libtraceevent dir:
> > 
> >   [jolsa@krava traceevent]$ make
> >     GEN      libtraceevent-dynamic-list
> >   Either missing one of [ plugin_jbd2.so plugin_hrtimer.so plugin_kmem.so plugin_kvm.so plugin_mac80211.so plugin_sched_switch.so plugin_function.so plugin_xen.so plugin_scsi.so plugin_cfg80211.so] or bad version of nm
> > 
> > but that seems to be there even without your patchset,
> > so probably something we should look into
> 
> Hmm, OK, I'll try to look into that later.
> 
> > 
> > other than that it looks ok to me
> 
> Great!
> 
> > 
> > once this is done, we can move forward to put this
> > to kernel-tools-libs-devel rpm
> 
> For this patch series, do you want to take the patch set, or just pull
> from my branch?

Arnaldo takes care of that, but I guess pulling from branch is the prefered way

jirka
