Return-Path: <SRS0=+9rX=K6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:34344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726003AbeHOFoq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Aug 2018 01:44:46 -0400
Date: Tue, 14 Aug 2018 22:54:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [RFC][PATCH 00/24] tools lib traceevent: Rename pevent to tep
 for preparation for library
Message-ID: <20180814225435.370210d7@vmware.local.home>
In-Reply-To: <20180810165706.GH5395@kernel.org>
References: <20180808155548.510187543@goodmis.org>
        <20180810092137.GB14485@krava>
        <20180810090010.4537e14a@gandalf.local.home>
        <20180810131401.GB4162@krava>
        <20180810165706.GH5395@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 10 Aug 2018 13:57:06 -0300
Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> > Arnaldo takes care of that, but I guess pulling from branch is the prefered way  
> 
> I'll try pulling and building it automatically patch by patch,

Hi Arnaldo,

Were you able to take this? We have another patch series that's ready
to go (it can wait till after the merge window though).

-- Steve
