Return-Path: <SRS0=Wk/S=MR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45765 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729047AbeJEX0n (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Oct 2018 19:26:43 -0400
Message-Id: <1538756836.4131485.1532106896.50BF1EF3@webmail.messagingengine.com>
From: Colin McCabe <colin@cmccabe.xyz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
Date: Fri, 05 Oct 2018 09:27:16 -0700
In-Reply-To: <20181005113056.55b23c31@gandalf.local.home>
References: <20181002175539.2ac894c7@gandalf.local.home>
 <20181005113056.55b23c31@gandalf.local.home>
Subject: Re: [PATCH v3] tools/lib/traceevent: Replace str_error_r() with an open
 coded implementation
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hmm.  Did you consider setting the ifdefs you can set to always get the POSIX version of strerror_r?

best,
Colin


On Fri, Oct 5, 2018, at 08:30, Steven Rostedt wrote:
> On Tue, 2 Oct 2018 17:55:39 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> > 
> > While working on having PowerTop use libtracevent as a shared object
> > library, Tzvetomir hit "str_error_r not defined". This was added by commit
> > c3cec9e68f12d ("tools lib traceevent: Use str_error_r()") because
> > strerror_r() has two definitions, where one is GNU specific, and the other
> > is XSI complient. The strerror_r() is in a wrapper str_error_r() to keep the
> > code from having to worry about which compiler is being used.
> > 
> > The problem is that str_error_r() is external to libtraceevent, and not part
> > of the library. If it is used as a shared object then the tools using it
> > will need to define that function. I do not want that function defined in
> > libtraceevent itself, as it is out of scope for that library.
> > 
> > As there's only a single instance of this call, I replaced it with an open
> > coded algorithm that uses sys_nerr and sys_errlist error array with
> > strncpy() to place the error message in the given buffer. We don't need to
> > worry about the errors that strerror_r() returns. If the buffer isn't big
> > enough, we simply truncate it.
> > 
> > The sys_nerr and sys_errlist idea was found here:
> > 
> >   http://www.club.cc.cmu.edu/~cmccabe/blog_strerror.html
> > 
> > Cc: Colin Patrick McCabe <cmccabe@alumni.cmu.edu>
> > Reported-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > ---
> > Changes since v2:
> > 
> >   Use sys_nerr and sys_errlist idea.
> > 
> >  tools/lib/traceevent/event-parse.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> > index 7980fc6c3bac..d23d10bc5314 100644
> > --- a/tools/lib/traceevent/event-parse.c
> > +++ b/tools/lib/traceevent/event-parse.c
> > @@ -18,7 +18,6 @@
> >  #include <errno.h>
> >  #include <stdint.h>
> >  #include <limits.h>
> > -#include <linux/string.h>
> >  #include <linux/time64.h>
> >  
> >  #include <netinet/in.h>
> > @@ -6215,7 +6214,13 @@ int tep_strerror(struct tep_handle *pevent __maybe_unused,
> >  	const char *msg;
> >  
> >  	if (errnum >= 0) {
> > -		str_error_r(errnum, buf, buflen);
> > +		if (buflen > 0) {
> > +			if (errnum < sys_nerr)
> > +				strncpy(buf, sys_errlist[errnum], buflen);
> > +			else
> > +				snprintf(buf, buflen, "Unknown error %d", errnum);
> > +			buf[buflen - 1] = 0;
> > +		}
> 
> Bah, I now get warnings that sys_nerr and sys_errlist are deprecated.
> 
> OK, so going back to just using the racy strerror() should be good
> enough, as this incompatibility with strerror_r() is a disaster!
> 
> -- Steve
> 
> 
> >  		return 0;
> >  	}
> >  
> 


C.
