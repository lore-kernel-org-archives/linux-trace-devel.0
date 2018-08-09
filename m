Return-Path: <SRS0=xDRx=KY=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727371AbeHIKft (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Aug 2018 06:35:49 -0400
Date: Thu, 9 Aug 2018 10:12:02 +0200
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
Message-ID: <20180809081202.GC19243@krava>
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

nah... now when I see it 'te' actualy sounds better ;)))) just kidding,
great we finaly got to this.. is there a branch somewhere with this?

thanks,
jirka
