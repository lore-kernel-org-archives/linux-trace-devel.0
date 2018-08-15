Return-Path: <SRS0=+9rX=K6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726135AbeHOJz7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Aug 2018 05:55:59 -0400
Date: Wed, 15 Aug 2018 09:04:59 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
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
Message-ID: <20180815070459.GC3180@krava>
References: <20180808155548.510187543@goodmis.org>
 <20180810092137.GB14485@krava>
 <20180810090010.4537e14a@gandalf.local.home>
 <20180810131401.GB4162@krava>
 <20180810165706.GH5395@kernel.org>
 <20180814225435.370210d7@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180814225435.370210d7@vmware.local.home>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, Aug 14, 2018 at 10:54:35PM -0400, Steven Rostedt wrote:
> On Fri, 10 Aug 2018 13:57:06 -0300
> Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> 
> > > Arnaldo takes care of that, but I guess pulling from branch is the prefered way  
> > 
> > I'll try pulling and building it automatically patch by patch,
> 
> Hi Arnaldo,
> 
> Were you able to take this? We have another patch series that's ready
> to go (it can wait till after the merge window though).

I see all that in Arnaldo's perf/core branch

jirka
