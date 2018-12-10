Return-Path: <SRS0=ba+9=OT=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:34702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727473AbeLJV0Y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 Dec 2018 16:26:24 -0500
Date: Mon, 10 Dec 2018 16:26:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] tools/lib/traceevent: Fix processing of dereferenced
 args in bprintk events
Message-ID: <20181210162621.2050475a@gandalf.local.home>
In-Reply-To: <20181210184807.GA26445@kernel.org>
References: <20181210134522.3f71e2ca@gandalf.local.home>
        <20181210184807.GA26445@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon, 10 Dec 2018 15:48:07 -0300
Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Em Mon, Dec 10, 2018 at 01:45:22PM -0500, Steven Rostedt escreveu:
> > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> > 
> > In the case that a bprintk event has a dereferenced pointer that is stored
> > as a string, and there's more values to process (more args), the arg was not
> > updated to point to the next arg after processing the dereferenced pointer,
> > and it screwed up what was to be displayed.  
> 
> Thanks, applied.
>  
> > Cc: stable@vger.kernel.org
> > Fixes: 7db96bb49629 ("tools lib traceevent: Handle new pointer processing of bprint strings")  

Arnaldo,

It seems that I cut and pasted the sha1 of the "fixes" part wrong. Can
you add a "3". That is, the above should have been: 37db96bb49629

Thanks,

-- Steve

> 
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > ---
> >  tools/lib/traceevent/event-parse.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> > index 3692f29fee46..70144b98141c 100644
> > --- a/tools/lib/traceevent/event-parse.c
> > +++ b/tools/lib/traceevent/event-parse.c
> > @@ -4970,6 +4970,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
> >  
> >  				if (arg->type == TEP_PRINT_BSTRING) {
> >  					trace_seq_puts(s, arg->string.string);
> > +					arg = arg->next;
> >  					break;
> >  				}
> >  
> > -- 
> > 2.19.1  
> 
