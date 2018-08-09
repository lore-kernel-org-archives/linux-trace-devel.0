Return-Path: <SRS0=xDRx=KY=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:57198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730634AbeHIQFv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Aug 2018 12:05:51 -0400
Date: Thu, 9 Aug 2018 09:40:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
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
Message-ID: <20180809094051.543eda0e@gandalf.local.home>
In-Reply-To: <20180809081202.GC19243@krava>
References: <20180808155548.510187543@goodmis.org>
        <20180809081202.GC19243@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 9 Aug 2018 10:12:02 +0200
Jiri Olsa <jolsa@redhat.com> wrote:

> nah... now when I see it 'te' actualy sounds better ;)))) just kidding,
> great we finaly got to this.. is there a branch somewhere with this?

I just pushed it to my repo:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git

  branch: tip/perf/core

Based off of commit ec2cb7a526d49b65576301e183448fb51ee543a6 from tip's
perf/core tree.

-- Steve
