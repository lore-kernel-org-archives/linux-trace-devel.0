Return-Path: <SRS0=HiQF=K5=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:43982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728292AbeHOAL4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Aug 2018 20:11:56 -0400
Date: Tue, 14 Aug 2018 17:22:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 03/14] tools/lib/traceevent, tools/perf: Rename enum
 format_flags to enum tep_format_flags, add prefix TEP_ to all of its
 members
Message-ID: <20180814172250.35d04d46@gandalf.local.home>
In-Reply-To: <20180810131732.24677-4-tz.stoyanov@gmail.com>
References: <20180810131732.24677-1-tz.stoyanov@gmail.com>
        <20180810131732.24677-4-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The subject is fine with just:

 tools/lib/traceevent, tools/perf: Rename enum format_flags to enum tep_format_flags


On Fri, 10 Aug 2018 16:17:21 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> In order to make libtraceevent into a proper library, variables, data
> structures and functions require a unique prefix to prevent name space
> conflicts. That prefix will be "tep_". This renames enum format_flags
> to enum tep_format_flags and adds prefix TEP_ to all of its members.

Explaining the TEP_ part in the change log is good enough.

-- Steve

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tools/lib/traceevent/event-parse.c            | 48 +++++++++----------
>  tools/lib/traceevent/event-parse.h            | 18 +++----
>  tools/lib/traceevent/parse-filter.c           |  8 ++--
>  tools/perf/builtin-trace.c                    |  2 +-
>  tools/perf/tests/evsel-tp-sched.c             |  2 +-
>  tools/perf/util/data-convert-bt.c             | 34 ++++++-------
>  tools/perf/util/evsel.c                       |  2 +-
>  tools/perf/util/python.c                      | 12 ++---
>  .../util/scripting-engines/trace-event-perl.c | 18 +++----
>  .../scripting-engines/trace-event-python.c    | 26 +++++-----
>  tools/perf/util/sort.c                        |  4 +-
>  11 files changed, 87 insertions(+), 87 deletions(-)
> 
