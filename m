Return-Path: <SRS0=/bgX=MG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mx1.redhat.com ([209.132.183.28]:59052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbeIXXwG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Sep 2018 19:52:06 -0400
Date: Mon, 24 Sep 2018 19:48:46 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH 00/15] tools/lib/traceevent: Namespace updates to make
 traceevent into a library
Message-ID: <20180924174846.GC22809@krava>
References: <20180919185643.358126338@goodmis.org>
 <20180923185626.GC30923@krava>
 <20180924045523.2c15be13@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180924045523.2c15be13@vmware.local.home>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon, Sep 24, 2018 at 04:55:23AM -0400, Steven Rostedt wrote:
> On Sun, 23 Sep 2018 20:56:26 +0200
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > 
> > Steven,
> > is there still something left to rename, or we can start moving it into public rpm?
> > 
> 
> We're testing it as a external library, and we did find something. Did
> you get this patch?
> 
>  https://lore.kernel.org/lkml/20180921152037.1e23c7f4@gandalf.local.home

ah yep, overlooked this one.. going to check it

jirka

> 
> We're testing it against powertop and mceutils, when we get it working
> well with them, then I think it's time to start going ahead and making
> it into an rpm.
> 
> Thanks Jiri!
> 
> -- Steve
