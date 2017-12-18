Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mx1.redhat.com ([209.132.183.28]:43150 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759545AbdLRU4e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Dec 2017 15:56:34 -0500
Subject: Re: [PATCH v1] trace-cmd: introduce --initital-delay for record
 command
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20171218112412.11898-1-david@redhat.com>
 <20171218104158.22519a7e@gandalf.local.home>
 <7b89f63f-3a6f-4182-c26a-934514ba5670@redhat.com>
 <20171218125231.445d8fa2@gandalf.local.home>
From: David Hildenbrand <david@redhat.com>
Message-ID: <55abd06d-1cac-8deb-d9be-f661f0ba30e1@redhat.com>
Date: Mon, 18 Dec 2017 21:56:33 +0100
MIME-Version: 1.0
In-Reply-To: <20171218125231.445d8fa2@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On 18.12.2017 18:52, Steven Rostedt wrote:
> On Mon, 18 Dec 2017 17:23:24 +0100
> David Hildenbrand <david@redhat.com> wrote:
> 
>> What I need: Start tracing and flush all buffers when exiting. (e.g.
> 
> Why don't you use "trace-cmd start" and "trace-cmd extract"?
> 
> "trace-cmd record" is all about not losing events. If you are creating
> a big buffer, then I think you want to use this.
> 
> # trace-cmd start -p <tracer> -e <events> -b <big-buffer-size>
> # run test
> # trace-cmd stop
> # trace-cmd extract
> 
> Wouldn't that work for you?

It works for some scenarios I have in mind. Especially when recording
long runs, it might be beneficial to e.g. wakeup every 30 seconds to
just write out a couple of MB of traces (compared to right now -s
30000000 waking up every couple of milliseconds).

With start/stop/extract the downside is, that buffers have to be huge
for longer runs.

I'll have a try tomorrow if I I''lose events with 20MB buffers per CPU
when recording more than 60 seconds (on a very active system with
mentioned scheduler rtaces being turned on).

Thanks!

> 
> -- Steve
> 
>> after 30 seconds). Never wakeup in between, so the real trace overhead
>> in that period of time is purely storing the tracepoints to the buffer
>> in the kernel. Of course we could implement something like that ("copy
>> from the buffer only when exiting") or try to see if we can fix the
>> existing "-s" flag in a way that allows it.


-- 

Thanks,

David / dhildenb
