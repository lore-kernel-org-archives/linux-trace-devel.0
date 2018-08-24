Return-Path: <SRS0=lMx0=LH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:36774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbeHXE2a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Aug 2018 00:28:30 -0400
Date: Thu, 23 Aug 2018 20:56:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH 01/24] tools lib traceevent, perf tools: Rename struct
 pevent to struct tep_handle
Message-ID: <20180823205616.3046842b@vmware.local.home>
In-Reply-To: <20180823140648.GB2077@redhat.com>
References: <20180821133328.3249-1-tz.stoyanov@gmail.com>
        <20180821133328.3249-2-tz.stoyanov@gmail.com>
        <20180823140648.GB2077@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 23 Aug 2018 11:06:48 -0300
Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Tue, Aug 21, 2018 at 04:33:05PM +0300, Tzvetomir Stoyanov (VMware) escreveu:
> > In order to make libtraceevent into a proper library, variables, data
> > structures and functions require a unique prefix to prevent name space
> > conflicts. That prefix will be "tep_" and not "pevent_". This changes
> > the struct pevent to struct tep_handle.  
> 
> This isn't for the kernel sources, right? We don't have kernel-shark
> there :-)
> 

Ah, this is the backport of the patches from the kernel into the
trace-cmd library to get them back in sync. Notice that LKML isn't
Cc'd. I told Tzvetomir to keep the change log from the kernel to
preserve the history of the commit in trace-cmd, I forgot that it will
cause git to Cc those in the change log. :-/

I believe there's a way for git sendmail not to send email to the Cc's
in the commit message, right? I'll work with Tzvetomir to make sure
that we avoid sending these to kernel folks when doing the trace-cmd
backports.

Sorry for the noise ;-)

-- Steve
