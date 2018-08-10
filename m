Return-Path: <SRS0=GMWY=KZ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:48192 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727166AbeHJLum (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Aug 2018 07:50:42 -0400
Date: Fri, 10 Aug 2018 11:21:37 +0200
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
Message-ID: <20180810092137.GB14485@krava>
References: <20180808155548.510187543@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180808155548.510187543@goodmis.org>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, Aug 08, 2018 at 11:55:48AM -0400, Steven Rostedt wrote:
> Having libtraceevent turn into a proper library has long been asked for.
> I never had time to do it before. Luckily, Tzvetomir was able to spend
> the time to start the preparation. The first thing that needs to be done
> is to handle namespace collisions. "pevent" was the prefix I chose, but
> many people were displeased by it, as it didn't express what the functions
> were used for. After discussing with many people at many conferences
> I've come up with "tep", which means "Trace Event Parser". Please don't
> question this. The bikeshed has been painted and I'm not changing the
> color.
> 
> This series changes all the function names and data structures from the
> "pevent_" prefix to the "tep_" prefix. Note, it does not change the
> names of local variables or even parameters. "pevent" variables and
> parameters still exist. We can change those later, but for now, I want
> all global references to "pevent" to be "tep_" instead.
> 
> This is not complete. It is only one of many preparations to make
> libtraceevent into a legitimate library. There's other naming conventions
> that will be made. But for now, I would like to hear thoughts about
> this change before we proceed further.

right, I can see more things that needs rename, like in print_arg*,
trace_* stuff and others

I'm also getting weird make error when compiling in libtraceevent dir:

  [jolsa@krava traceevent]$ make
    GEN      libtraceevent-dynamic-list
  Either missing one of [ plugin_jbd2.so plugin_hrtimer.so plugin_kmem.so plugin_kvm.so plugin_mac80211.so plugin_sched_switch.so plugin_function.so plugin_xen.so plugin_scsi.so plugin_cfg80211.so] or bad version of nm

but that seems to be there even without your patchset,
so probably something we should look into

other than that it looks ok to me

once this is done, we can move forward to put this
to kernel-tools-libs-devel rpm

thanks,
jirka
