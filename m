Return-Path: <SRS0=/bgX=MG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:58960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730834AbeIXVWe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Sep 2018 17:22:34 -0400
Date: Mon, 24 Sep 2018 11:19:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH 00/15] tools/lib/traceevent: Namespace updates to make
 traceevent into a library
Message-ID: <20180924111946.50ec9743@vmware.local.home>
In-Reply-To: <20180924141632.GA4640@kernel.org>
References: <20180919185643.358126338@goodmis.org>
        <20180923185626.GC30923@krava>
        <20180924045523.2c15be13@vmware.local.home>
        <20180924141632.GA4640@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon, 24 Sep 2018 11:16:32 -0300
Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> At some point would be nice if you guys provided patches to make
> tools/perf/ link dynamicly to libtraceevent as well.

It's on the agenda, but we have to get it working first ;-)

Note, we are doing all the work in the kernel's tools/lib/traceevent
and then backporting it to trace-cmd, but we are going to make the
libtraceevent.so library live in the kernel's tools directory.

-- Steve
