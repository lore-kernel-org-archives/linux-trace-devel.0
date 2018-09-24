Return-Path: <SRS0=/bgX=MG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:52352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbeIXO4c (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Sep 2018 10:56:32 -0400
Date: Mon, 24 Sep 2018 04:55:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH 00/15] tools/lib/traceevent: Namespace updates to make
 traceevent into a library
Message-ID: <20180924045523.2c15be13@vmware.local.home>
In-Reply-To: <20180923185626.GC30923@krava>
References: <20180919185643.358126338@goodmis.org>
        <20180923185626.GC30923@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Sun, 23 Sep 2018 20:56:26 +0200
Jiri Olsa <jolsa@redhat.com> wrote:

> 
> Steven,
> is there still something left to rename, or we can start moving it into public rpm?
> 

We're testing it as a external library, and we did find something. Did
you get this patch?

 https://lore.kernel.org/lkml/20180921152037.1e23c7f4@gandalf.local.home

We're testing it against powertop and mceutils, when we get it working
well with them, then I think it's time to start going ahead and making
it into an rpm.

Thanks Jiri!

-- Steve
