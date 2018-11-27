Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:40358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727668AbeK1Awu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 19:52:50 -0500
Date: Tue, 27 Nov 2018 08:54:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Slavomir Kaslev <kaslevs@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Fix record --date flag when sending tracing
 data to a listener
Message-ID: <20181127085447.4f57d3c2@gandalf.local.home>
In-Reply-To: <CAE0o1Ns+4UXU+UEgVT=sJvLujCOEPa78-UA7J_UVLTEK1gHoqQ@mail.gmail.com>
References: <20181114154328.14731-1-kaslevs@vmware.com>
        <20181126130530.63e8df2f@gandalf.local.home>
        <CAE0o1Ns+4UXU+UEgVT=sJvLujCOEPa78-UA7J_UVLTEK1gHoqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 27 Nov 2018 10:15:55 +0000
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> On Mon, Nov 26, 2018 at 8:06 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Wed, 14 Nov 2018 17:43:28 +0200
> > kaslevs@vmware.com wrote:
> >  
> > > From: Slavomir Kaslev <kaslevs@vmware.com>
> > >
> > > Currently the `trace-cmd record` --date is not taken into account when tracing
> > > data is sent to a remote host with the -N flag.
> > >
> > > This patch fixes this by the writing output buffer options from the recording
> > > side instead of on the listener side.
> > >
> > > Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> > > ---
> > >  
> >
> > I don't see anything too wrong with it, accept the following test broke:
> >
> >  $ git checkout trace-cmd-v2.6
> >  $ make
> >  $ sudo cp trace-cmd /usr/local/bin/trace-cmd-v2.6
> >  $ git checkout origin/master
> >  $ patch -p1 < this.patch
> >  $ make
> >  $ trace-cmd-v2.6 listen -p 12345
> >
> > In another terminal:
> >
> >  $ sudo trace-cmd record -N 127.0.0.1:12345 -e sched sleep 1
> > trace-cmd: No such file or directory
> >   Cannot handle the protocol
> >
> >
> > Remember, we need to remain backward compatible. We also need to test
> > this code running as a listener, and the trace-cmd-v2.6 (and earlier)
> > as the recorder.  
> 
> This is a design bug (the best kind), metadata should really be written from the
> recording side and not from the listener. A backward compatible fix should have
> the newer recorder and listener detect they're talking to an older version and
> fallback to broken behavior. 

Yes, that's what we need to do.

> This implies a new protocol version or extending
> MSG_TINIT/MSG_RINIT so that we can infer the behavior on the other side and
> fallback to being broken when necessary.
> 
> What would you suggest?

Let me take a deeper look at it. This reminds me of the time I
added the hack to distinguish between V1 and V2. (see commit
cc042aba4a97ae).

-- Steve
