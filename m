Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:33620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752279AbdLRPmB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Dec 2017 10:42:01 -0500
Date: Mon, 18 Dec 2017 10:41:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: David Hildenbrand <david@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v1] trace-cmd: introduce --initital-delay for record
 command
Message-ID: <20171218104158.22519a7e@gandalf.local.home>
In-Reply-To: <20171218112412.11898-1-david@redhat.com>
References: <20171218112412.11898-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon, 18 Dec 2017 12:24:12 +0100
David Hildenbrand <david@redhat.com> wrote:

> If recording a big number of events to a big buffer, one might want to
> minimize the trace-cmd activity for a certain period in time.
> Especially, don't see any trace-cmd activity for some time. If there are
> a lot of events, the loop might actually never sleep, resulting in the
> "-s" option never becomming active.
> 
> E.g. I am using scheduler events to trace thread activity per CPU. Esp.
> sched:sched_wakeup and sched:sched_stat_runtime. Even when setting the
> sleep time to something huge like 30 seconds, I can see constant activity
> from the trace-cmd tasks.

Thanks for reporting this. Honestly, I believe this is fixing a symptom
of a real problem. I'd like to investigate why trace-cmd is running
with a sleep time of 30 seconds. I think that should be fixed.

-- Steve
