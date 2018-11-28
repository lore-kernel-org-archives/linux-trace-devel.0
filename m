Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:60362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbeK1OT0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 09:19:26 -0500
Date: Tue, 27 Nov 2018 22:19:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Slavomir Kaslev <kaslevs@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Fix record --date flag when sending tracing
 data to a listener
Message-ID: <20181127221921.3e67172a@vmware.local.home>
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
> fallback to broken behavior. This implies a new protocol version or extending
> MSG_TINIT/MSG_RINIT so that we can infer the behavior on the other side and
> fallback to being broken when necessary.

Agreed.

> 
> What would you suggest?

I just want to stress that I feel as strong for backward compatibility
as Linus feels for not breaking user space. That is, I'll go without a
fix if it breaks backward compatibility. 

But the really good news is, your code didn't break backward
compatibility. It uncovered a bug :-) :-) :-)

The failure of the old code is that it looked at buf[0] without
initializing it. The fix is this:

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e1e2f433..143793da 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2775,6 +2775,8 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 	 */
 	write(fd, V2_CPU, sizeof(V2_CPU));
 
+	buf[0] = 0;
+
 	/* read a reply message */
 	n = read(fd, buf, BUFSIZ);
 

That said, I have one minor nit with the patch. I'll reply to the patch
itself.

Thanks!

-- Steve
