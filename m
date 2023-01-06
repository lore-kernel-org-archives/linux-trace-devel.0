Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4FFC3DA7A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Jan 2023 02:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjAFCKF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 21:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjAFCKE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 21:10:04 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233BC61465
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 18:10:04 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id o21so196187pjw.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Jan 2023 18:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FyLT2N7rDiS80YAHS6awZdZzbaDZBoxicftuQTpH4Io=;
        b=b9DMJF83MJ2PTkWvBSX8fMQgWz2snSHUIGy8XzWjjqxD7ZrMujdLz65detHG24M0CF
         NRrh7h5OroycHcemyUp3Wu7ACjhri0Ty3N6nsL8ALSM7s0m71M8wCTTnQvgpTlT2aq7f
         2J70d0Gk5e4W/DPsOoX7vF+9lWOrsazkDudAfdkN7L9RWRjzbmaQDgmlVipcufHU6oRB
         pMSLRCTU1HeWBNqclWP7qHhr5TJQStlTUhvtOPxhptTj5XrHKlG1iC4dZREEUwPzRCK9
         YmQ4k2q4ctxkxtkCtz29lyUoIFtbZPQ2TxjQL8BxUP14EA+T1Amdp+tbtgAzZeygAy49
         2cpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FyLT2N7rDiS80YAHS6awZdZzbaDZBoxicftuQTpH4Io=;
        b=IAts5Bj6Li1T4fZlR33RRZzEOJgUHAA1F/IrPZHGdgF0QlzO0+uH2aRE1HjzY7TTo4
         q1ycnfANrmOfMvCpxSKs6wcFwSSsHkdyJPvilIeq1k9+A7lO6ngWpQNeS6BRm41fH2Kb
         UvUZ9TAlaUllmVKnsPjXRfZCtnhpUjKhy+s5Fd04Y8As1V1777XmISBDoPx953IQCmtA
         rc5/RT7mSnGAqt7bLrnMTvX6RljaUobdMk+3DFYH/CFNqrDyOi/poxJvPTc65gCmFByO
         sT0fsZlAZXI601S+mMnycbO7tNv+FoDfDhMWnmIn6q0GYSX8HZjPFMFLZcRCOwd0KIf9
         Yb/A==
X-Gm-Message-State: AFqh2kpiPmyALZvJqC57vaUp9VN3Y/F/TyQyvhyj4yBk5rKBBCgdhvrn
        c+yDE7zFqPL9L53Xg5EgH2iA4/Xx0NE=
X-Google-Smtp-Source: AMrXdXsxo5EQI2urDvk74dKzNArlX5s7eVEtg99AAzUMJAFdC5fDYD+7CwRATmazCkljExgqIwfsNQ==
X-Received: by 2002:a17:902:9a8a:b0:192:f281:b930 with SMTP id w10-20020a1709029a8a00b00192f281b930mr1720389plp.2.1672971003534;
        Thu, 05 Jan 2023 18:10:03 -0800 (PST)
Received: from mail.google.com (125-237-24-141-adsl.sparkbb.co.nz. [125.237.24.141])
        by smtp.gmail.com with ESMTPSA id z4-20020a1709027e8400b0018685257c0dsm3870351pla.58.2023.01.05.18.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 18:10:03 -0800 (PST)
Date:   Fri, 6 Jan 2023 15:09:58 +1300
From:   Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: document expected behaviour of execvp for
 record command
Message-ID: <Y7eC9o4JDO7XWjlw@mail.google.com>
References: <Y7dUo6woh9Y31cdl@mail.google.com>
 <20230105181317.32dcafa7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105181317.32dcafa7@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Jan 05, 2023 at 06:13:17PM -0500, Steven Rostedt wrote:
> On Fri, 6 Jan 2023 11:52:19 +1300
> Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com> wrote:
> 
> > In tracecmd/trace-record.c:<run_cmd>, trace-cmd record -F <executable>
> > is launched via the libc's execvp() routine.
> > 
> > If you run a command which is meant to be found in one of the entries
> > of the PATH env var then you should see <n> invocations of the
> > __x64_sys_execve() syscall where <n> will be equal to the number of
> > attempts that execvp() routine had done until it could find the
> > executable.
> > 
> > While the routine works as expected, its behaviour can seem a bit
> > cryptic for untrained eyes and makes one wonder whether there is
> > something wrong in any of the parts involved in the tracing operation.
> > Some time after one digs into trace-cmd's and libc's code base, one
> > realises that everything is working as expected but documenting it could
> > save other people's time :-)
> > 
> > Document the expected behaviour ftrace users should see depending on
> > the way -F <executable> is used.
> > 
> > Signed-off-by: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
> > ---
> > Additional context:
> > 
> > - absolute path example:
> > 
> > 	# trace-cmd record -p function_graph \
> > 		-g __x64_sys_execve -O nofuncgraph-irqs \
> > 	        -n __cond_resched --max-graph-depth 1  \
> > 		-F /usr/bin/echo "ftrace" > /dev/null
> > 	
> > 	# trace-cmd report 
> > 	echo-172994 [000] 185539.798539: funcgraph_entry:      ! 803.376 us |  __x64_sys_execve();
> > 
> > - PATH-dependent path example:
> > 
> > 	# trace-cmd record -p function_graph \
> > 		-g __x64_sys_execve -O nofuncgraph-irqs \
> > 		-n __cond_resched --max-graph-depth 1  \
> > 		-F echo "ftrace" > /dev/null
> > 
> > 	# trace-cmd report
> >         echo-172656 [002] 185009.671586: funcgraph_entry:      ! 288.732 us |  __x64_sys_execve();
> >         echo-172656 [002] 185009.671879: funcgraph_entry:      ! 158.337 us |  __x64_sys_execve();
> >         echo-172656 [002] 185009.672042: funcgraph_entry:      ! 161.843 us |  __x64_sys_execve();
> >         echo-172656 [002] 185009.672207: funcgraph_entry:      ! 157.656 us |  __x64_sys_execve();
> >         echo-172656 [002] 185009.672369: funcgraph_entry:      ! 156.343 us |  __x64_sys_execve();
> >         echo-172656 [002] 185009.672529: funcgraph_entry:      ! 863.629 us |  __x64_sys_execve();
> 
> Honestly, the above should be in the change log.

Fair enough. I will send a new patch shortly.

> 
> > 
> > ---
> >  Documentation/trace-cmd/trace-cmd-record.1.txt | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
> > index b709e48..a000cbe 100644
> > --- a/Documentation/trace-cmd/trace-cmd-record.1.txt
> > +++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
> > @@ -113,6 +113,10 @@ OPTIONS
> >      Using *-F* will let you trace only events that are caused by the given
> >      command.
> >  
> > +    Note: if the specified filename is neither absolute or relative then libc
> > +    will invoke execve() syscall for every entry in the colon-separated list of
> > +    directory pathnames specified in the PATH environment variable.
> > +
> 
> Hmm, do you think it may be worth open-coding execvp() and looking for it
> from trace-cmd, and then only enabling tracing when it found the full path?
> 
> -- Steve

That's a good point. I thought about it for a while and this is really a pickle.

I'll dump the things I'm thinking about and peharps you can help me
choosing between the approaches :-)

Launching executables via:

libc->execvp: It avoid some sorts of TOCTOU race conditions by trying to
execve executables and leave it up to the kernel to do a 'single'
file-exists validation (best case scenario) instead of validate whether
file exists twice, once in user-space and again in kernel (best case
scenario).

bash: As a counter point (and also because that's most
likely how trace-cmd will be executed). Bash actually does the
open-coding execvp() approach as shown below:

# trace-cmd record -p function_graph \
	-g __x64_sys_execve -O nofuncgraph-irqs \
	--max-graph-depth 1  \
	-F /usr/bin/bash -c "ls" > /dev/null


ls-178525 [010] 197387.772776: funcgraph_entry:      ! 775.074 us |  __x64_sys_execve(); # for /usr/bin/bash
ls-178525 [010] 197387.775568: funcgraph_entry:      ! 993.453 us |  __x64_sys_execve(); # for /usr/bin/ls

I guess this will boil down to whether you want to make trace-cmd as
'transparent' as possible (in comparison to running the command without
prepending trace-cmd) OR if you actually care about/want to abide by
the TOCTOU 'guarantees' that libc implements for userspace applications

Let me know your thoughts. I'm flexible with either approach

- Paulo Almeida

> 
> 
> >  *-P* 'pid'::
> >       Similar to *-F* but lets you specify a process ID to trace.
> >  
> 
