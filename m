Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726389AbfADEIB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Jan 2019 23:08:01 -0500
Date: Thu, 3 Jan 2019 23:07:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pratyush Anand <pratyush.anand@gmail.com>
Cc: linux-kernel@vger.kernel.org, dyoung@redhat.com,
        "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [trace-cmd Patch RFC] trace-cmd: top: A new interface to detect
 peak memory
Message-ID: <20190103230757.5adf871d@vmware.local.home>
In-Reply-To: <20190103230207.13058ac1@vmware.local.home>
References: <2e2d52edc0488adfefa6d19e27b8b9beae95a7b6.1488380367.git.panand@redhat.com>
        <20170426100135.758cb098@gandalf.local.home>
        <727920fa-219c-6d8d-3ba6-2f0553b2cbdc@redhat.com>
        <20170427124940.62ca6a06@gandalf.local.home>
        <b27d00d4-7cf4-a925-25e1-8f12cc266072@redhat.com>
        <20190103230207.13058ac1@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 3 Jan 2019 23:02:07 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 27 Apr 2017 23:03:24 +0530
> Pratyush Anand <panand@redhat.com> wrote:
> 
> Hi Pratyush,
> 
> I was digging through old email, and came across this. Our thread sorta
> just died. Are you still interested in implementing "trace-cmd top"?
> 
> We've changed the code structure quite a bit since this came out so it
> would require a rewrite. But would actually fit better now.
> 

And it appears you don't work for Red Hat anymore!

-- Steve

> 
> 
> > On Thursday 27 April 2017 10:19 PM, Steven Rostedt wrote:  
> > > On Thu, 27 Apr 2017 19:32:43 +0530
> > > Pratyush Anand <panand@redhat.com> wrote:
> > >    
> > >> I will implement your review comments and will send next revision.
> > >> However, I had couple of observation which I was unable to justify:
> > >>
> > >> # ./trace-cmd top -s /tmp/test
> > >> # ./trace-cmd top -p /tmp/test | grep trace-cmd
> > >>    15292           trace-cmd               22144           15808    
> > >
> > > What does it give for your /tmp/test ?    
> > 
> > /tmp/test is name of socket through which both trace aggregator (-s) and 
> > printer (-p) process are talking to each other.
> >   
> > >
> > > Note, tracing doesn't start till after trace-cmd is loaded. Everything
> > > before is not going to be seen.    
> > 
> > Yes. So with `./trace-cmd top -s /tmp/test` tracing starts and it aggregates 
> > stats for all processes including self process as well. After some time I 
> > execute `./trace-cmd top -p /tmp/test` which prints stats for all the 
> > processes including self. In the above example, I see that peak memory 
> > calculated for self process (`./trace-cmd top -s /tmp/test`) was 22144KB.
> >   
> > >    
> > >> Here,15292 is the pid of trace-cmd task
> > >> 22144 KB is the peak memory usage
> > >> 15808 KB is the current memory usage
> > >>
> > >> Now check rss component from statm
> > >> # cat /proc/15292/statm
> > >>    50 35 23 7 0 12 0 36
> > >>
> > >> This is a result on ARM64/64KB page size. Therefore, as per statm rss is 35
> > >> pages = 35*64 = 2240KB
> > >> I patched my kernel [2] for test purpose, so that statm reports peak memory as
> > >> well. Here, the last extra entry in statm output is peak memory and it is 36
> > >> pages = 2304KB.
> > >> So, this is a huge difference between what has been reported by statm and what
> > >> we get from trace-cmd.
> > >> I understand that `trace-cmd top` output would only be approximate, because
> > >> many of the memory could be allocated by task and freed in interrupt context.
> > >> So, many a time it can differ. But, is such a huge difference justified? If
> > >> yes, can we count on the output of this utility to find early boot time oom
> > >> issues?    
> > >
> > > Doesn't it only just trace the memory usage of when the tracing starts?    
> > 
> > So,should be less than what is being reported by statm, right? But, here we 
> > see that value reported by trace-cmd is far more than rss value of statm.
> > 
> > Well, there is one known bug in the code, which I am trying to find out a way. 
> > But, that should not cause this huge difference.
> > 
> > When we receive a trace entry for any new process, we read rss value from 
> > statm. We think,that these are the memory consumption by that process before 
> > tracing started. So,we initialize peak and current memory value for that 
> > process with rss from statm, and then we increase current when there is an 
> > entry for mm_page_alloc() and decrease when an entry for mm_page_free(). peak 
> > value of current at any point is reported as peak memory.
> > 
> > Now, lets consider a process p1 which was existing before tracing started. its 
> > rss was having value r1 KB. we receive first trace entry for p1, which says 
> > 8KB was allocated for p1.
> > 
> > p1->cur = r1 + 8;
> > p->peak = r1 + 8;
> > 
> > We receive another entry with 4KB de-allocation.
> > 
> > p1->cur = r1 + 4;
> > p->peak = r1 + 8;
> > 
> > There would have been some of these entries which have also been taken care in 
> > statm/rss (r1 here). We do not know how many entries were already considered.
> > Currently, these n (unknown) entries [which had been generated between (a) 1st 
> > tarce entry and (b) when trace-cmd top reads statm/rss] are considered twice, 
> > which is a bug.
> > 
> > ~Pratyush
> >   
> > >>
> > >> [1]
> > >> https://github.com/pratyushanand/trace-cmd/commit/602c2cd96aa613633ad20c6d382e41f7db37a2a4
> > >> [2]
> > >> https://github.com/pratyushanand/linux/commit/197e2045361b6b70085c46c78ea6607d8afce517    
> > >    
> 
